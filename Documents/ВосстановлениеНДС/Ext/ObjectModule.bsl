Перем мУдалятьДвижения Экспорт;
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

//Процедура заполнения табличной части по данным подсистемы НДС
Процедура ЗаполнитьДокумент(ОшибкаЗаполнения = Ложь, Сообщать = Истина, СтрокаСообщения = "", ОтменитьПроведение = Ложь, УдалятьНезаполненные = Ложь) Экспорт
	
	Если Проведен Тогда
		Если ОтменитьПроведение Тогда
			Записать(РежимЗаписиДокумента.ОтменаПроведения);
		Иначе
			ОшибкаЗаполнения = Истина;
			СтрокаСообщения = " перед заполнением требуется отменить проведение документа";
			Если Сообщать Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Документ не заполнен:" + СтрокаСообщения, , Строка(Ссылка));
			КонецЕсли; 
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ТаблицаВосстановления = Состав.ВыгрузитьКолонки();
	
	Дерево_НДСДляВосстановления = ЗаполнитьПоДаннымОперативныхРегистровНДС();
	Если Дерево_НДСДляВосстановления.Строки.Количество() = 0 Тогда
		// Не обнаружен НДС к восстановлению.
		Состав.Очистить();
	Иначе
	
		СписокСчетовФактур = ОбщегоНазначения.УдалитьПовторяющиесяЭлементыМассива(Дерево_НДСДляВосстановления.Строки.ВыгрузитьКолонку("СчетФактура"),Истина);
		
		ЗаписиКнигиПокупок = ПолучитьЗаписиКнигиПокупокПоСпискуСФ(СписокСчетовФактур);

		ОпределитьДатуОплатыПоЗаписямКнигиПокупок(Дерево_НДСДляВосстановления, ТаблицаВосстановления, СписокСчетовФактур, ЗаписиКнигиПокупок);
		
		// Удаление строк, в которых есть незаполненные обязательные поля
		Если УдалятьНезаполненные Тогда
			ОбработкаТабличныхЧастейСервер.УдалитьНезаполненныеСтроки(ТаблицаВосстановления, "ВидЦенности, Поставщик, СчетФактура, СтавкаНДС, СчетУчетаНДС");
		КонецЕсли;
		
		Состав.Загрузить(ТаблицаВосстановления);
		
	КонецЕсли; 

	Если Не (Состав.Количество() > 0 
        ) Тогда
		ОшибкаЗаполнения = Истина;
		СтрокаСообщения = СтрокаСообщения+Символы.ПС+" - не обнаружены записи к восстановлению"
	КонецЕсли;	

   Если ОшибкаЗаполнения Тогда
		Если Сообщать Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Документ не заполнен:" + СтрокаСообщения, , Строка(Ссылка));
		КонецЕсли; 
		Возврат;
	КонецЕсли; 
	
КонецПроцедуры

Функция ЗаполнитьПоДаннымОперативныхРегистровНДС(УдалятьНезаполненные = Ложь)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОстаткиНДСКВычету.Организация,
	|	ОстаткиНДСКВычету.СчетФактура КАК СчетФактура,
	|	ОстаткиНДСКВычету.ВидЦенности,
	|	ОстаткиНДСКВычету.СтавкаНДС,
	|	ОстаткиНДСКВычету.СчетУчетаНДС,
	|	СУММА(-ОстаткиНДСКВычету.СуммаБезНДСОстаток) КАК СуммаБезНДС,
	|	СУММА(-ОстаткиНДСКВычету.НДСОстаток) КАК НДС,
	|	СУММА(-ОстаткиНДСКВычету.СуммаБезНДСОстаток - ОстаткиНДСКВычету.НДСОстаток) КАК СуммаСНДС_КВычету,
	|	ОстаткиНДСКВычету.СчетФактураДата КАК СчетФактураДата,
	|	ЕСТЬNULL(ОстаткиНДСКВычету.СчетФактура.Контрагент, НЕОПРЕДЕЛЕНО) КАК СчетФактураКонтрагент,
	|	ЕСТЬNULL(ОстаткиНДСКВычету.СчетФактура.ДоговорКонтрагента, НЕОПРЕДЕЛЕНО) КАК СчетФактураДоговорКонтрагента,
	|	ВЫБОР
	|		КОГДА ОстаткиНДСКВычету.СчетФактура.Контрагент ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СчетФактураСодержитКонтрагента,
	|	ВЫБОР
	|		КОГДА ОстаткиНДСКВычету.СчетФактура.ДоговорКонтрагента ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СчетФактураСодержитДоговорКонтрагента
	|ИЗ
	|	(ВЫБРАТЬ
	|		НДСПредъявленныйОстатки.Организация КАК Организация,
	|		НДСПредъявленныйОстатки.СчетФактура КАК СчетФактура,
	|		НДСПредъявленныйОстатки.ВидЦенности КАК ВидЦенности,
	|		НДСПредъявленныйОстатки.СтавкаНДС КАК СтавкаНДС,
	|		НДСПредъявленныйОстатки.СчетУчетаНДС КАК СчетУчетаНДС,
	|		НДСПредъявленныйОстатки.СуммаБезНДСОстаток КАК СуммаБезНДСОстаток,
	|		НДСПредъявленныйОстатки.НДСОстаток КАК НДСОстаток,
	|		НДСПредъявленныйОстатки.СчетФактура.Дата КАК СчетФактураДата
	|	ИЗ
	|		РегистрНакопления.НДСПредъявленный.Остатки(&КонецПериода, Организация = &Организация) КАК НДСПредъявленныйОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НДСПредъявленныйРеализация0Остатки.Организация,
	|		НДСПредъявленныйРеализация0Остатки.СчетФактура,
	|		НДСПредъявленныйРеализация0Остатки.ВидЦенности,
	|		НДСПредъявленныйРеализация0Остатки.СтавкаНДС,
	|		НДСПредъявленныйРеализация0Остатки.СчетУчетаНДС,
	|		-НДСПредъявленныйРеализация0Остатки.СуммаБезНДСОстаток,
	|		-НДСПредъявленныйРеализация0Остатки.НДСОстаток,
	|		НДСПредъявленныйРеализация0Остатки.СчетФактура.Дата
	|	ИЗ
	|		РегистрНакопления.НДСПредъявленныйРеализация0.Остатки(
	|				&КонецПериода,
	|				Организация = &Организация
	|					И (НЕ ВидЦенности В (&ИсключаемыеВидыЦенностей))) КАК НДСПредъявленныйРеализация0Остатки) КАК ОстаткиНДСКВычету
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиНДСКВычету.СтавкаНДС,
	|	ОстаткиНДСКВычету.СчетУчетаНДС,
	|	ОстаткиНДСКВычету.СчетФактура,
	|	ОстаткиНДСКВычету.ВидЦенности,
	|	ОстаткиНДСКВычету.Организация,
	|	ОстаткиНДСКВычету.СчетФактураДата,
	|	ЕСТЬNULL(ОстаткиНДСКВычету.СчетФактура.Контрагент, НЕОПРЕДЕЛЕНО),
	|	ЕСТЬNULL(ОстаткиНДСКВычету.СчетФактура.ДоговорКонтрагента, НЕОПРЕДЕЛЕНО),
	|	ВЫБОР
	|		КОГДА ОстаткиНДСКВычету.СчетФактура.Контрагент ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА ОстаткиНДСКВычету.СчетФактура.ДоговорКонтрагента ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|ИМЕЮЩИЕ
	|	СУММА(ОстаткиНДСКВычету.СуммаБезНДСОстаток) + СУММА(ОстаткиНДСКВычету.НДСОстаток) < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетФактураДата
	|ИТОГИ
	|	СУММА(СуммаБезНДС),
	|	СУММА(НДС),
	|	СУММА(СуммаСНДС_КВычету)
	|ПО
	|	СчетФактура";

	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("КонецПериода", Новый	Граница(КонецДня(Дата), ВидГраницы.Включая));
	
	// Исключаемые из анализа виды ценностей
	ИсключаемыеВидыЦенностей = Новый СписокЗначений;
	ИсключаемыеВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.АвансыПолученные);
	ИсключаемыеВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.АвансыПолученные0);
	ИсключаемыеВидыЦенностей.Добавить(Перечисления.ВидыЦенностей.ВозвратАвансовПолученных);
	
	Запрос.УстановитьПараметр("ИсключаемыеВидыЦенностей", ИсключаемыеВидыЦенностей);
	
	ДеревоРезультата = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	// Определение поставщика
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация"		, Организация);
	Запрос.УстановитьПараметр("СчетаФактуры"	, ДеревоРезультата.Строки.ВыгрузитьКолонку("СчетФактура"));
	Запрос.УстановитьПараметр("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДСПредъявленныйОбороты.Поставщик,
	|	НДСПредъявленныйОбороты.ДоговорКонтрагента,
	|	НДСПредъявленныйОбороты.СчетФактура
	|ИЗ
	|	РегистрНакопления.НДСПредъявленный.Обороты(
	|		,
	|		,
	|		,
	|		Организация = &Организация
	|		    И СчетФактура В (&СчетаФактуры)) КАК НДСПредъявленныйОбороты
	|ГДЕ
	|	НДСПредъявленныйОбороты.Поставщик <> &ПустойКонтрагент";
	
	КонтрагентПоСчетуФактуре = Запрос.Выполнить().Выгрузить();
	
	ДеревоРезультата.Колонки.Добавить("Поставщик", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ДеревоРезультата.Колонки.Добавить("ДоговорКонтрагента", Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"));
	
	Для каждого СтрокаОбрабатываемая  Из ДеревоРезультата.Строки Цикл
		СтрокаКонтрагента = КонтрагентПоСчетуФактуре.Найти(СтрокаОбрабатываемая.СчетФактура,"СчетФактура");
		Если не СтрокаКонтрагента = Неопределено Тогда
		    СтрокаОбрабатываемая.Поставщик = СтрокаКонтрагента.Поставщик;
			Для каждого СтрокаРасшифровки Из СтрокаОбрабатываемая.Строки Цикл
				СтрокаРасшифровки.Поставщик = СтрокаОбрабатываемая.Поставщик;
			КонецЦикла; 
		    СтрокаОбрабатываемая.ДоговорКонтрагента = СтрокаКонтрагента.ДоговорКонтрагента;
			Для каждого СтрокаРасшифровки Из СтрокаОбрабатываемая.Строки Цикл
				СтрокаРасшифровки.ДоговорКонтрагента = СтрокаОбрабатываемая.ДоговорКонтрагента;
			КонецЦикла; 
		Иначе
			Если СтрокаОбрабатываемая.СчетФактураСодержитКонтрагента Тогда
				СтрокаОбрабатываемая.Поставщик = СтрокаОбрабатываемая.СчетФактураКонтрагент;
				Для каждого СтрокаРасшифровки Из СтрокаОбрабатываемая.Строки Цикл
					СтрокаРасшифровки.Поставщик = СтрокаОбрабатываемая.Поставщик;
				КонецЦикла; 
			КонецЕсли;
			Если СтрокаОбрабатываемая.СчетФактураСодержитДоговорКонтрагента Тогда
				СтрокаОбрабатываемая.ДоговорКонтрагента = СтрокаОбрабатываемая.СчетФактураДоговорКонтрагента;
				Для каждого СтрокаРасшифровки Из СтрокаОбрабатываемая.Строки Цикл
					СтрокаРасшифровки.ДоговорКонтрагента = СтрокаОбрабатываемая.ДоговорКонтрагента;
				КонецЦикла; 
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат ДеревоРезультата;

КонецФункции

// Процедура вызывается из ЗаполнитьСтрокиДокумента.
// По списку счетов-фактур определяет суммы не использованных ранее распределенных оплат.
Функция ПолучитьЗаписиКнигиПокупокПоСпискуСФ(СписокСчетовФактур)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДСЗаписиКнигиПокупокОбороты.Поставщик КАК Поставщик,
	|	НДСЗаписиКнигиПокупокОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	НДСЗаписиКнигиПокупокОбороты.СчетФактура КАК СчетФактура,
	|	НДСЗаписиКнигиПокупокОбороты.ВидЦенности,
	|	НДСЗаписиКнигиПокупокОбороты.СтавкаНДС,
	|	НДСЗаписиКнигиПокупокОбороты.СчетУчетаНДС,
	|	НДСЗаписиКнигиПокупокОбороты.ДатаОплаты КАК ДатаОплаты,
	|	НДСЗаписиКнигиПокупокОбороты.ДокументОплаты КАК ДокументОплаты,
	|	СУММА(НДСЗаписиКнигиПокупокОбороты.СуммаБезНДСОборот) КАК СуммаБезНДС,
	|	СУММА(НДСЗаписиКнигиПокупокОбороты.НДСОборот) КАК НДС,
	|	НДСЗаписиКнигиПокупок.Период КАК КорректируемыйПериод
	|ИЗ
	|	РегистрНакопления.НДСЗаписиКнигиПокупок.Обороты(
	|			,
	|			&КонецПериода,
	|			Период,
	|			Организация = &Организация
	|				И СчетФактура В (&СписокСчетовФактур)) КАК НДСЗаписиКнигиПокупокОбороты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.НДСЗаписиКнигиПокупок КАК НДСЗаписиКнигиПокупок
	|		ПО НДСЗаписиКнигиПокупокОбороты.Поставщик = НДСЗаписиКнигиПокупок.Поставщик
	|			И НДСЗаписиКнигиПокупокОбороты.ДоговорКонтрагента = НДСЗаписиКнигиПокупок.ДоговорКонтрагента
	|			И НДСЗаписиКнигиПокупокОбороты.СчетФактура = НДСЗаписиКнигиПокупок.СчетФактура
	|			И НДСЗаписиКнигиПокупокОбороты.ВидЦенности = НДСЗаписиКнигиПокупок.ВидЦенности
	|			И НДСЗаписиКнигиПокупокОбороты.СтавкаНДС = НДСЗаписиКнигиПокупок.СтавкаНДС
	|			И НДСЗаписиКнигиПокупокОбороты.СчетУчетаНДС = НДСЗаписиКнигиПокупок.СчетУчетаНДС
	|			И НДСЗаписиКнигиПокупокОбороты.ДатаОплаты = НДСЗаписиКнигиПокупок.ДатаОплаты
	|			И НДСЗаписиКнигиПокупокОбороты.ДокументОплаты = НДСЗаписиКнигиПокупок.ДокументОплаты
	|
	|СГРУППИРОВАТЬ ПО
	|	НДСЗаписиКнигиПокупокОбороты.ВидЦенности,
	|	НДСЗаписиКнигиПокупокОбороты.ДокументОплаты,
	|	НДСЗаписиКнигиПокупокОбороты.СтавкаНДС,
	|	НДСЗаписиКнигиПокупокОбороты.СчетУчетаНДС,
	|	НДСЗаписиКнигиПокупокОбороты.ДатаОплаты,
	|	НДСЗаписиКнигиПокупокОбороты.Поставщик,
	|	НДСЗаписиКнигиПокупокОбороты.ДоговорКонтрагента,
	|	НДСЗаписиКнигиПокупокОбороты.СчетФактура,
	|	НДСЗаписиКнигиПокупок.Период
	|
	|УПОРЯДОЧИТЬ ПО
	|	НДСЗаписиКнигиПокупокОбороты.СчетФактура.Дата,
	|	ДатаОплаты,
	|	НДСЗаписиКнигиПокупокОбороты.ДокументОплаты.Дата
	|ИТОГИ
	|	СУММА(СуммаБезНДС),
	|	СУММА(НДС)
	|ПО
	|	СчетФактура";
	
	Запрос.УстановитьПараметр("КонецПериода", 		Новый	Граница(КонецДня(Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Организация", 		Организация);
	Запрос.УстановитьПараметр("СписокСчетовФактур", СписокСчетовФактур);
	
	ЗаписиКнигиПокупок = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);

	Возврат ЗаписиКнигиПокупок;	

КонецФункции // ПолучитьДанныеОРаспределенныхОплатахПоСпискуСФ()
 
// <Описание процедуры>
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ОпределитьДатуОплатыПоЗаписямКнигиПокупок(Дерево_НДСДляВосстановления, ТаблицаРезультатов, СписокСчетовФактур, ЗаписиКнигиПокупок)

	НДСНалоговыйПериод = Неопределено;
	
	Для каждого СтрокаСФ Из Дерево_НДСДляВосстановления.Строки Цикл
		НаборЗаписейКнигиПокупокПоСФ = ЗаписиКнигиПокупок.Строки.Найти(СтрокаСФ.СчетФактура,"СчетФактура");
		
		Если НаборЗаписейКнигиПокупокПоСФ = Неопределено тогда
			// Сокращеный вариант - записи книги не обнаружены, отражаем по текущим данным,
			// без указания документа и даты оплаты.
			Для каждого ЗаписьПОСФ Из СтрокаСФ.Строки Цикл
				СтрокаРезультата = ТаблицаРезультатов.Добавить();
				СтрокаРезультата.СчетФактура	= ЗаписьПОСФ.СчетФактура;
				СтрокаРезультата.Поставщик		= ЗаписьПОСФ.Поставщик;
				СтрокаРезультата.ДоговорКонтрагента	= ЗаписьПОСФ.ДоговорКонтрагента;
				СтрокаРезультата.ВидЦенности	= ЗаписьПОСФ.ВидЦенности;
				СтрокаРезультата.СчетУчетаНДС	= ЗаписьПОСФ.СчетУчетаНДС;
				СтрокаРезультата.СтавкаНДС		= ЗаписьПОСФ.СтавкаНДС;

				СтрокаРезультата.СуммаБезНДС	= ЗаписьПОСФ.СуммаБезНДС;
				СтрокаРезультата.НДС			= ЗаписьПОСФ.НДС;
			
				Если Дата >= '20060530' и не ОтразитьВКнигеПродаж Тогда
					СтрокаРезультата.ЗаписьДополнительногоЛиста = Истина;
					Если ЗаписьПОСФ.СчетФактураДата > '20060101' Тогда
						СтрокаРезультата.КорректируемыйПериод = ЗаписьПОСФ.СчетФактураДата;
					КонецЕсли;
				КонецЕсли;
				
			КонецЦикла; 
			
			Продолжить;
		КонецЕсли;
		
		Для каждого ЗаписьПОСФ Из СтрокаСФ.Строки Цикл
			Отбор = новый Структура("Поставщик, ВидЦенности, СчетУчетаНДС, СтавкаНДС",ЗаписьПОСФ.Поставщик, ЗаписьПОСФ.ВидЦенности, ЗаписьПОСФ.СчетУчетаНДС, ЗаписьПОСФ.СтавкаНДС);
			
			ЗаписиКнигиПоОтбору = НаборЗаписейКнигиПокупокПоСФ.Строки.НайтиСтроки(Отбор);
			
			Для каждого СторнируемаяЗаписьКнигиПокупок Из ЗаписиКнигиПоОтбору Цикл
				КВосстановлению_БезНДС = макс(0,мин(ЗаписьПОСФ.СуммаБезНДС, СторнируемаяЗаписьКнигиПокупок.СуммаБезНДС));
				КВосстановлению_НДС = макс(0,мин(ЗаписьПОСФ.НДС, СторнируемаяЗаписьКнигиПокупок.НДС));
				Если КВосстановлению_БезНДС =0 и КВосстановлению_НДС =0 Тогда
				    Продолжить;
				КонецЕсли; 
				
				СтрокаРезультата = ТаблицаРезультатов.Добавить();
				СтрокаРезультата.СчетФактура	= ЗаписьПОСФ.СчетФактура;
				СтрокаРезультата.Поставщик		= ЗаписьПОСФ.Поставщик;
				СтрокаРезультата.ДоговорКонтрагента	= ЗаписьПОСФ.ДоговорКонтрагента;
				СтрокаРезультата.ВидЦенности	= ЗаписьПОСФ.ВидЦенности;
				СтрокаРезультата.СчетУчетаНДС	= ЗаписьПОСФ.СчетУчетаНДС;
				СтрокаРезультата.СтавкаНДС		= ЗаписьПОСФ.СтавкаНДС;

				СтрокаРезультата.СуммаБезНДС	= КВосстановлению_БезНДС;
				СтрокаРезультата.НДС			= КВосстановлению_НДС;
				
				СтрокаРезультата.ДатаОплаты		= СторнируемаяЗаписьКнигиПокупок.ДатаОплаты;
				СтрокаРезультата.ДокументОплаты	= СторнируемаяЗаписьКнигиПокупок.ДокументОплаты;
				
				Если Дата >= '20060530' и не ОтразитьВКнигеПродаж Тогда
					Если НДСНалоговыйПериод = Неопределено Тогда
						НДСНалоговыйПериод = УчетНДС.ПолучитьУПНДСНалоговыйПериод(Организация, Дата);
					КонецЕсли;
					СтрокаРезультата.ЗаписьДополнительногоЛиста = Истина;
					Если ЗаписьПОСФ.СчетФактураДата < '20060101' Тогда
						СтрокаРезультата.КорректируемыйПериод = ?(НЕ ЗначениеЗаполнено(СторнируемаяЗаписьКнигиПокупок.ДатаОплаты), '00010101', 
																	Макс(ЗаписьПОСФ.СчетФактураДата, СторнируемаяЗаписьКнигиПокупок.ДатаОплаты));
					Иначе										
						СтрокаРезультата.КорректируемыйПериод = ЗаписьПОСФ.СчетФактураДата;
					КонецЕсли;
					Если ?(НДСНалоговыйПериод = Перечисления.Периодичность.Месяц, 
							КонецМесяца(СтрокаРезультата.КорректируемыйПериод) = КонецМесяца(Дата),
							КонецКвартала(СтрокаРезультата.КорректируемыйПериод) = КонецКвартала(Дата)) Тогда
						СтрокаРезультата.ЗаписьДополнительногоЛиста = Ложь;
						СтрокаРезультата.КорректируемыйПериод = '00010101';
					КонецЕсли;
				КонецЕсли;
				
				ЗаписьПОСФ.СуммаБезНДС						= ЗаписьПОСФ.СуммаБезНДС - КВосстановлению_БезНДС;
				ЗаписьПОСФ.НДС								= ЗаписьПОСФ.НДС - КВосстановлению_НДС;
				
				СторнируемаяЗаписьКнигиПокупок.СуммаБезНДС	= СторнируемаяЗаписьКнигиПокупок.СуммаБезНДС - КВосстановлению_БезНДС;
				СторнируемаяЗаписьКнигиПокупок.НДС 			= СторнируемаяЗаписьКнигиПокупок.НДС - КВосстановлению_НДС;
				
			КонецЦикла; 
			
			Если ЗаписьПОСФ.СуммаБезНДС>0 или ЗаписьПОСФ.НДС>0 Тогда
			
				СтрокаРезультата = ТаблицаРезультатов.Добавить();
				СтрокаРезультата.СчетФактура	= ЗаписьПОСФ.СчетФактура;
				СтрокаРезультата.Поставщик		= ЗаписьПОСФ.Поставщик;
				СтрокаРезультата.ДоговорКонтрагента	= ЗаписьПОСФ.ДоговорКонтрагента;
				СтрокаРезультата.ВидЦенности	= ЗаписьПОСФ.ВидЦенности;
				СтрокаРезультата.СчетУчетаНДС	= ЗаписьПОСФ.СчетУчетаНДС;
				СтрокаРезультата.СтавкаНДС		= ЗаписьПОСФ.СтавкаНДС;

				СтрокаРезультата.СуммаБезНДС	= ЗаписьПОСФ.СуммаБезНДС;
				СтрокаРезультата.НДС			= ЗаписьПОСФ.НДС;
				
				Если Дата >= '20060530' и не ОтразитьВКнигеПродаж Тогда
					СтрокаРезультата.ЗаписьДополнительногоЛиста = Истина;
					Если ЗаписьПОСФ.СчетФактураДата >= '20060101' Тогда
						СтрокаРезультата.КорректируемыйПериод = ЗаписьПОСФ.СчетФактураДата;
					КонецЕсли;
				КонецЕсли;

			КонецЕсли; 
			
		КонецЦикла;	
			
	КонецЦикла;	
	
КонецПроцедуры // РаспределитьОплатыПоДеревуСФ()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация");
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
//
Функция ПодготовитьТаблицуВосстановления(РезультатЗапроса)

	ТаблицаВосстановления = РезультатЗапроса.Выгрузить();
	
	ТаблицаВосстановления.Колонки.Добавить("КодВидаОперации", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(10));
	
	Для Каждого СтрокаТЧ Из ТаблицаВосстановления Цикл
		
		Если Не СтрокаТЧ.ЗаписьДополнительногоЛиста Тогда
			СтрокаТЧ.КорректируемыйПериод =  '00010101000000';
		КонецЕсли;
		
		Если Дата >= '20150101' Тогда
			СтрокаТЧ.КодВидаОперации = "21";
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаВосстановления;

КонецФункции // ПодготовитьТаблицуПоОплатам()

// Проверяет правильность заполнения строк табличной части.
//
//
Процедура ПроверитьЗаполнениеТабличнойЧастиСостав(ТаблицаВосстановления, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("ВидЦенности, Поставщик, СчетФактура, СтавкаНДС, СчетУчетаНДС"); 
	
	// Используем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Состав", СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	// При установленном флаге "ЗаписьДополнительногоЛиста" должен быть заполнен реквизит "КорректируемыйПериод"
	Для Каждого СтрокаТЧ Из Состав Цикл
		СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТЧ.НомерСтроки) +
	                               """ табличной части ""Состав"": ";
		Если СтрокаТЧ.ЗаписьДополнительногоЛиста И НЕ ЗначениеЗаполнено(СтрокаТЧ.КорректируемыйПериод) Тогда
			СтрокаСообщения = "Не заполнено значение реквизита ""Корректируемый период""!";
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщения, Отказ, Заголовок);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаВосстановления)
	
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаВосстановления);
	ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаВосстановления);
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура вызывается из тела процедуры ДвиженияПоРегистрам.
// Отражение восстановления НДС в бухгалтерском учете
//
Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента, ТаблицаВосстановления)
	
	Если ТаблицаВосстановления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ТаблицаВосстановления Цикл

		Если (Строка.СуммаБезНДС = 0) И (Строка.НДС = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		/////////////////////////////////////////////////
		// Формирование проводки по восстановлению НДС
		Если (Строка.НДС <> 0) Тогда
			
			СтрокаДвиженияПроводка = Движения.Хозрасчетный.Добавить();
			
			СтрокаДвиженияПроводка.Период       = СтруктураШапкиДокумента.Дата;
			СтрокаДвиженияПроводка.Организация  = СтруктураШапкиДокумента.Организация;
			СтрокаДвиженияПроводка.Содержание   = "Восстановлен НДС";
			СтрокаДвиженияПроводка.НомерЖурнала = "НДС";

			СтрокаДвиженияПроводка.СчетДт       = Строка.СчетУчетаНДС; //19.XX
			БухгалтерскийУчет.УстановитьСубконто(СтрокаДвиженияПроводка.СчетДт, СтрокаДвиженияПроводка.СубконтоДт, "Контрагенты", Строка.Поставщик);
			БухгалтерскийУчет.УстановитьСубконто(СтрокаДвиженияПроводка.СчетДт, СтрокаДвиженияПроводка.СубконтоДт, "СФПолученные", Строка.СчетФактура);
			
			СтрокаДвиженияПроводка.СчетКт       = ПланыСчетов.Хозрасчетный.НДС; //68.02
			БухгалтерскийУчет.УстановитьСубконто(СтрокаДвиженияПроводка.СчетКт, СтрокаДвиженияПроводка.СубконтоКт, "ВидыПлатежейВГосБюджет", Перечисления.ВидыПлатежейВГосБюджет.Налог);
			
			СтрокаДвиженияПроводка.Сумма        = - Строка.НДС;

		КонецЕсли; 
		// Формирование проводки по восстановлению НДС
		/////////////////////////////////////////////////

	КонецЦикла;
	
КонецПроцедуры // ДвиженияПоРегистрамРегл()

// Процедура вызывается из тела процедуры ДвиженияПоРегистрам.
// Формирует движения по регистрам подсистемы учета НДС.
Процедура ДвиженияРегистровПодсистемыНДС(СтруктураШапкиДокумента, ТаблицаВосстановления) Экспорт
	
	Если ТаблицаВосстановления.Количество() =0 Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтразитьВКнигеПродаж Тогда
		// Восстановление в книге продаж
		
		ТаблицаДвижений_НДСЗаписиКнигиПродаж = Движения.НДСЗаписиКнигиПродаж.Выгрузить();
		СоответствиеКолонок = Новый Структура("Покупатель, СуммаБезНДС, НДС", "Поставщик", "СуммаБезНДСКнигаПродаж", "НДСКнигаПродаж");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.Очистить();
		
		УчетНДС.ПереименованиеКолонок(ТаблицаДвижений_НДСЗаписиКнигиПродаж, СоответствиеКолонок );
		
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаВосстановления, ТаблицаДвижений_НДСЗаписиКнигиПродаж);
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПродажи.ВосстановлениеНДС, "Событие");
		ТаблицаДвижений_НДСЗаписиКнигиПродаж.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата, "ДатаСобытия");
		
		ВидыЦенностейТребующиеДоговора = Новый Массив;
		
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.ВнутреннееПотребление);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.СМРСобственнымиСилами);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентАренда);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентРеализацияИмущества);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентИностранцы);
	    ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.АвансыПолученные);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.АвансыПолученные0);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.ВозвратАвансовПолученных);
		ВидыЦенностейТребующиеДоговора.Добавить(Перечисления.ВидыЦенностей.АвансыВыданные);
		
		Для Каждого СтрокаДвижений Из ТаблицаДвижений_НДСЗаписиКнигиПродаж Цикл
			Если ВидыЦенностейТребующиеДоговора.Найти(СтрокаДвижений.ВидЦенности) = Неопределено Тогда
				СтрокаДвижений.ДоговорКонтрагента = Неопределено;
			КонецЕсли;	
		КонецЦикла;	
		
		УчетНДС.ПереименованиеКолонок(ТаблицаДвижений_НДСЗаписиКнигиПродаж, СоответствиеКолонок, Истина);
		
		Если НЕ ТаблицаДвижений_НДСЗаписиКнигиПродаж.Количество() = 0 Тогда
			Движения.НДСЗаписиКнигиПродаж.мПериод = СтруктураШапкиДокумента.Дата;
			Движения.НДСЗаписиКнигиПродаж.мТаблицаДвижений = ТаблицаДвижений_НДСЗаписиКнигиПродаж;
			Движения.НДСЗаписиКнигиПродаж.ДобавитьДвижение();
			Движения.НДСЗаписиКнигиПродаж.Записать(Ложь);
		КонецЕсли;
	
	Иначе
		// Сторнирование в книге покупок
		ТаблицаДвижений_НДСЗаписиКнигиПокупок = Движения.НДСЗаписиКнигиПокупок.Выгрузить();
		ТаблицаДвижений_НДСЗаписиКнигиПокупок.Очистить();
			
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаВосстановления, ТаблицаДвижений_НДСЗаписиКнигиПокупок);
		ТаблицаДвижений_НДСЗаписиКнигиПокупок.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПокупки.ВосстановленНДС,"Событие");
		ТаблицаДвижений_НДСЗаписиКнигиПокупок.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата,"ДатаСобытия");
			
		Если СтруктураШапкиДокумента.Дата >= ?(СтруктураШапкиДокумента.НДСНалоговыйПериод = Перечисления.Периодичность.Квартал, '20060401', '20060501') Тогда
			// Событие для восстановления определяется по признаку записи доп. листа
			// В декларациях старых периодов это будет отражаться как уменьшение суммы вычета
			ЗаписиДопЛистов = ТаблицаДвижений_НДСЗаписиКнигиПокупок.НайтиСтроки(Новый Структура("ЗаписьДополнительногоЛиста", Истина));
			Для каждого СтрокаЗаписиКниги Из ЗаписиДопЛистов Цикл
				СтрокаЗаписиКниги.Событие = Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету;
			КонецЦикла; 
		КонецЕсли; 
		
		Если Не ТаблицаДвижений_НДСЗаписиКнигиПокупок.Количество() = 0 Тогда
			Движения.НДСЗаписиКнигиПокупок.мПериод = СтруктураШапкиДокумента.Дата;
			Движения.НДСЗаписиКнигиПокупок.мТаблицаДвижений = ТаблицаДвижений_НДСЗаписиКнигиПокупок;
			Движения.НДСЗаписиКнигиПокупок.ДобавитьДвижение();
			Движения.НДСЗаписиКнигиПокупок.Записать(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	// Сторнирование расхода по регистру НДС предъявленный
	ТаблицаДвижений_НДСПредъявленный = Движения.НДСПредъявленный.Выгрузить();
	ТаблицаДвижений_НДСПредъявленный.Очистить();
		
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаВосстановления, ТаблицаДвижений_НДСПредъявленный);
	ТаблицаДвижений_НДСПредъявленный.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПокупки.ВосстановленНДС,"Событие");
	ТаблицаДвижений_НДСПредъявленный.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата,"ДатаСобытия");
		
	Если Не ТаблицаДвижений_НДСПредъявленный.Количество() = 0 Тогда
		Движения.НДСПредъявленный.мПериод = СтруктураШапкиДокумента.Дата;
		Движения.НДСПредъявленный.мТаблицаДвижений = ТаблицаДвижений_НДСПредъявленный;
		Движения.НДСПредъявленный.ВыполнитьРасход();
		Движения.НДСПредъявленный.Записать(Ложь);
	КонецЕсли;
		
	// Виды ценностей с особым порядком распределения оплат - по НДС выплаченному в бюджет
	// Только по ним отражаются движения в регистре НДСУчетРаспределенныхОплатПоставщикам
	ВидыЦенностей_ОплатаПоНДС = Новый СписокЗначений;
	ВидыЦенностей_ОплатаПоНДС.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентАренда);
	ВидыЦенностей_ОплатаПоНДС.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентРеализацияИмущества);
	ВидыЦенностей_ОплатаПоНДС.Добавить(Перечисления.ВидыЦенностей.НалоговыйАгентИностранцы);
	ВидыЦенностей_ОплатаПоНДС.Добавить(Перечисления.ВидыЦенностей.ВнутреннееПотребление);
	ВидыЦенностей_ОплатаПоНДС.Добавить(Перечисления.ВидыЦенностей.СМРСобственнымиСилами);
		
	// Получаем таблицу идентичную по структуре движениям регистра "НДСУчетРаспределенныхОплатПоставщикам"
	ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам = Движения.НДСУчетРаспределенныхОплатПоставщикам.Выгрузить();
	ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам.Очистить();
	
	Для Каждого Строка Из ТаблицаВосстановления Цикл

		Если (Строка.СуммаБезНДС = 0) и (Строка.НДС = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		// Сторнирование зачета оплат
		Если  ВидыЦенностей_ОплатаПоНДС.НайтиПоЗначению(Строка.ВидЦенности) <> Неопределено Тогда
	
			СтрокаДвижения = ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам.Добавить();

			СтрокаДвижения.Период = Дата;
			СтрокаДвижения.Организация = Организация;
			СтрокаДвижения.СчетФактура = Строка.СчетФактура;
			СтрокаДвижения.ДокументОплаты = Строка.ДокументОплаты;
			СтрокаДвижения.РасчетыСБюджетом = Истина;
			СтрокаДвижения.РаспределеннаяСумма = Строка.НДС;
			
		КонецЕсли;
			
	КонецЦикла; // Пока Выборка.Следующий() Цикл
	
	Если Не ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам.Количество() = 0 Тогда
		
		ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам.Свернуть("Организация, СчетФактура, ДокументОплаты, РасчетыСБюджетом, ДатаСобытия", "РаспределеннаяСумма");
		ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам.ЗаполнитьЗначения(СтруктураШапкиДокумента.Дата,"ДатаСобытия");
		Движения.НДСУчетРаспределенныхОплатПоставщикам.мПериод = СтруктураШапкиДокумента.Дата;
		Движения.НДСУчетРаспределенныхОплатПоставщикам.мТаблицаДвижений = ТаблицаДвижения_НДСУчетРаспределенныхОплатПоставщикам;
		Движения.НДСУчетРаспределенныхОплатПоставщикам.ВыполнитьРасход();
		Движения.НДСУчетРаспределенныхОплатПоставщикам.Записать(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры // ДвиженияРегистровПодсистемыНДС()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента) Экспорт
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураШапкиДокумента.Вставить("НДСНалоговыйПериод", УчетНДС.ПолучитьУПНДСНалоговыйПериод(Организация, Дата));
	
КонецПроцедуры // ПодготовитьСтруктуруШапкиДокумента()

// Процедура формирует таблицы документа.
//
Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаВосстановления) Экспорт
	
	// Подготовим данные необходимые для проведения и проверки заполнения табличной части.
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("Организация",					"Ссылка.Организация");
	СтруктураПолей.Вставить("Поставщик",					"Поставщик");
	СтруктураПолей.Вставить("ДоговорКонтрагента",			"ДоговорКонтрагента");
	СтруктураПолей.Вставить("СчетФактура",					"СчетФактура");
	СтруктураПолей.Вставить("ВидЦенности",					"ВидЦенности");
	СтруктураПолей.Вставить("СтавкаНДС",					"СтавкаНДС");
	СтруктураПолей.Вставить("СчетУчетаНДС",					"СчетУчетаНДС");
	СтруктураПолей.Вставить("ДокументОплаты",				"ДокументОплаты");
	СтруктураПолей.Вставить("ДатаОплаты",					"ДатаОплаты");
	СтруктураПолей.Вставить("СуммаБезНДС",					"СуммаБезНДС*(-1)");
	СтруктураПолей.Вставить("НДС",							"НДС*(-1)");
	СтруктураПолей.Вставить("ЗаписьДополнительногоЛиста",	"ЗаписьДополнительногоЛиста");
	СтруктураПолей.Вставить("КорректируемыйПериод",			"КорректируемыйПериод");
	Если СтруктураШапкиДокумента.ОтразитьВКнигеПродаж Тогда
		СтруктураПолей.Вставить("СуммаБезНДСКнигаПродаж",	"СуммаБезНДС");
		СтруктураПолей.Вставить("НДСКнигаПродаж",			"НДС");
	КонецЕсли; 

	РезультатЗапроса = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Состав", СтруктураПолей);
	ТаблицаВосстановления = ПодготовитьТаблицуВосстановления(РезультатЗапроса);
	
КонецПроцедуры // СформироватьТаблицыДокумента()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим) Экспорт

    Перем Заголовок, СтруктураШапкиДокумента, ТаблицаВосстановления;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(Отказ, Заголовок);
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаВосстановления);
			
	ПроверитьЗаполнениеТабличнойЧастиСостав(ТаблицаВосстановления, Отказ, Заголовок);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, ТаблицаВосстановления);
	КонецЕсли;
    
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью()


