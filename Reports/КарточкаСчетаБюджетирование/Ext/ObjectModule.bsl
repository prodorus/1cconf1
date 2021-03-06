#Если Клиент Тогда

Перем ИмяРегистраБухгалтерии Экспорт;

//////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ЗАГОЛОВКА ОТЧЕТА
//

// Выводит шапку отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт

	ОписаниеПериода = БухгалтерскиеОтчеты.СформироватьСтрокуВыводаПараметровПоДатам(ДатаНач, ДатаКон);

	Макет = ПолучитьМакет("КарточкаСчета");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	НазваниеСценария = Строка(Сценарий);
	Если ПустаяСтрока(НазваниеСценария) Тогда
		НазваниеСценария = Сценарий;
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.НазваниеСценария = НазваниеСценария;

	ЗаголовокОтчета.Параметры.ОписаниеПериода = ОписаниеПериода;

	ЗаголовокОтчета.Параметры.Заголовок = ЗаголовокОтчета();

	// Вывод списка фильтров:
	СтрФильтры   = "";

	СтрФильтры = Сред(СтрФильтры + ", " + УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор), 3);

	ОбластьОтбор = Макет.ПолучитьОбласть("СтрокаОтбор");

	Если Не ПустаяСтрока(СтрФильтры) Тогда
		ОбластьОтбор.Параметры.ТекстПроОтбор = "Отбор: " + СтрФильтры;
		ЗаголовокОтчета.Вывести(ОбластьОтбор);
	КонецЕсли;

	Возврат(ЗаголовокОтчета);

КонецФункции // СформироватьЗаголовок()

Функция ЗаголовокОтчета() Экспорт
	Возврат "Карточка счета " + Счет;	
КонецФункции // ЗаголовокОтчета()

//////////////////////////////////////////////////////////
// ПОСТРОЕНИЕ ОТЧЕТА
//

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//  ДокументРезультат - табличный документ, формируемый отчетом
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0) Экспорт

	// Проверка на пустые значения
	Если Счет.Пустая() Тогда
		Предупреждение("Не выбран счет!");
		Возврат;
	КонецЕсли;

	ОграничениеПоДатамКорректно = БухгалтерскиеОтчеты.ПроверитьКорректностьОграниченийПоДатам(ДатаНач, ДатаКон);
	Если НЕ ОграничениеПоДатамКорректно Тогда
        Возврат;
	КонецЕсли;

	// Выберем в соответствие все подчиненные счета (для определения принадлежности выводимого счета деьбета, кредита):
	ПланСчетовРегистра = Метаданные.РегистрыБухгалтерии[ИмяРегистраБухгалтерии].ПланСчетов;
	ИмяПланаСчетов = ПланСчетовРегистра.Имя;
	СоответствиеПодчиненныеСчета = БухгалтерскиеОтчеты.ВернутьСоответвиеПодчиненныхСчетов(ИмяПланаСчетов, Счет, Истина);
	
	Для Каждого Элемент Из СоответствиеПодчиненныеСчета Цикл
		
		СоответствиеПодчиненныеСчета[Элемент.Ключ] = -1;
		
	КонецЦикла;
	
	СоответствиеСчетовКэш = Новый Соответствие;

	ДокументРезультат.Очистить();

	// Вывод заголовка отчета
	БухгалтерскиеОтчеты.СформироватьИВывестиЗаголовокОтчета(ЭтотОбъект, ДокументРезультат, ВысотаЗаголовка, ПоказыватьЗаголовок);

	Макет = ПолучитьМакет("КарточкаСчета");

	ДокументРезультат.Область("R1:R4").Видимость = ПоказыватьЗаголовок;

	ЗапросПоОстаткам = Новый Запрос();
	ЗапросПоОстаткам.УстановитьПараметр("СчетАнализа", Счет);
	ЗапросПоОстаткам.УстановитьПараметр("Период",      ?(НЕ ЗначениеЗаполнено(ДатаНач), (ДатаНач + 1), НачалоДня(ДатаНач)));
	ЗапросПоОстаткам.УстановитьПараметр("Сценарий",    Сценарий);

	СтрокаОграниченийПоРеквизитам = "";
	БухгалтерскиеОтчеты.ДополнитьСтрокуОграниченийПоРеквизитам(СтрокаОграниченийПоРеквизитам, "Сценарий", Сценарий);
	
	ТекстФильтры = БухгалтерскиеОтчеты.ПолучитьТекстОграниченийПоПостроителюОтчета(ПостроительОтчета, ЗапросПоОстаткам);
	СтрокаОграниченийПоРеквизитам = БухгалтерскиеОтчеты.ОбъединитьОграничения(СтрокаОграниченийПоРеквизитам, ТекстФильтры);
	
    ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СУММА(Выборка.СуммаУпрОстатокДт) КАК СуммаОстатокДт,
	|	СУММА(Выборка.СуммаУпрОстатокКт) КАК СуммаОстатокКт,
	|	СУММА(Выборка.СуммаУпрОстаток)   КАК СуммаОстаток,
	|	СУММА(Выборка.СуммаСценарияОстатокДт) КАК СуммаСценарияОстатокДт,
	|	СУММА(Выборка.СуммаСценарияОстатокКт) КАК СуммаСценарияОстатокКт,
	|	СУММА(Выборка.СуммаСценарияОстаток)   КАК СуммаСценарияОстаток,
	|	СУММА(Выборка.КоличествоОстатокДт) КАК КоличествоОстатокДт,
	|	СУММА(Выборка.КоличествоОстатокКт) КАК КоличествоОстатокКт
	|ИЗ
	|(ВЫБРАТЬ
	|	Счет,
	|	СуммаУпрОстатокДт,
	|	СуммаУпрОстатокКт,
	|	СуммаУпрОстаток,
	|	СуммаСценарияОстатокДт,
	|	СуммаСценарияОстатокКт,
	|	СуммаСценарияОстаток,
	|	КоличествоОстатокДт,
	|	КоличествоОстатокКт
	|ИЗ
	|	РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".Остатки(&Период, Счет В ИЕРАРХИИ (&СчетАнализа), ," 
	+ СтрокаОграниченийПоРеквизитам + ") КАК ОсновнойОстатки "	
	+ "
	|) КАК Выборка";
	
	ЗапросПоОстаткам.Текст = ТекстЗапроса;
	
	//нужно ли делать пвомежуточные итоги по периоду или нет
	НужныПромежуточныеИтогиПоПериоду = (Не ПустаяСтрока(Период)) И (Не ВРег(Период) = "ПЕРИОД");

	ЗапросПоПроводкам = Новый Запрос();
	ЗапросПоПроводкам.УстановитьПараметр("СчетАнализа", Счет);
	ЗапросПоПроводкам.УстановитьПараметр("НачПериода",  ?(НЕ ЗначениеЗаполнено(ДатаНач), ДатаНач, НачалоДня(ДатаНач)));
	ЗапросПоПроводкам.УстановитьПараметр("КонПериода",  ?(НЕ ЗначениеЗаполнено(ДатаКон), ДатаКон, КонецДня(ДатаКон)));
	ЗапросПоПроводкам.УстановитьПараметр("Сценарий",    Сценарий);
	ЗапросПоПроводкам.УстановитьПараметр("Дебет",       ВидДвиженияБухгалтерии.Дебет);
	ЗапросПоПроводкам.УстановитьПараметр("Кредит",      ВидДвиженияБухгалтерии.Кредит);
	ЗапросПоПроводкам.УстановитьПараметр("ПустойСчет",  ПланыСчетов[ИмяПланаСчетов].ПустаяСсылка());

	Если Метаданные.РегистрыБухгалтерии[ИмяРегистраБухгалтерии].Корреспонденция тогда
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СчетДт,
		|	СчетКт,
		|	СчетДт.Представление КАК СчетДтПредставление,
		|	СчетКт.Представление КАК СчетКтПредставление,
		|	ВалютаДт,
		|	ВалютаКт,
		|	ПРЕДСТАВЛЕНИЕ(ВалютаДт) КАК ВалютаДтПредставление,
		|	ПРЕДСТАВЛЕНИЕ(ВалютаКт) КАК ВалютаКтПредставление,
		|	КоличествоДт     КАК КоличествоДт,
		|	КоличествоКт     КАК КоличествоКт,
		|	ВалютнаяСуммаДт  КАК ВалютнаяСуммаДт,
		|	ВалютнаяСуммаКт  КАК ВалютнаяСуммаКт,";

		Для Индекс = 1 По ПланСчетовРегистра.МаксКоличествоСубконто Цикл
			ТекстЗапроса = ТекстЗапроса + "
			|	СубконтоДт"+ Строка(Индекс) + "," + Символы.ПС + "
			|	ПРЕДСТАВЛЕНИЕ(СубконтоДт"+ Строка(Индекс) + ") КАК СубконтоДт" + Строка(Индекс) + "Представление," + Символы.ПС + 
			"	СубконтоКт"+ Строка(Индекс) + "," + Символы.ПС + " 
			|	ПРЕДСТАВЛЕНИЕ(СубконтоКт"+ Строка(Индекс) + ") КАК СубконтоКт" + Строка(Индекс) + "Представление,";
		КонецЦикла;

	Иначе
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВидДвижения,
		|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА Счет ИНАЧЕ &ПустойСчет КОНЕЦ КАК СчетДт,
		|	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА Счет ИНАЧЕ &ПустойСчет КОНЕЦ КАК СчетКт,
		|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА Счет.Представление ИНАЧЕ NULL КОНЕЦ КАК СчетДтПредставление,
		|	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА Счет.Представление ИНАЧЕ NULL КОНЕЦ КАК СчетКтПредставление,
		|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА Валюта ИНАЧЕ NULL КОНЕЦ КАК ВалютаДт,
		|	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА Валюта ИНАЧЕ NULL КОНЕЦ КАК ВалютаКт,
		|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА Валюта.Представление ИНАЧЕ NULL КОНЕЦ КАК ВалютаДтПредставление,
		|	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА Валюта.Представление ИНАЧЕ NULL КОНЕЦ КАК ВалютаКтПредставление,
		|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА Количество ИНАЧЕ 0 КОНЕЦ КАК КоличествоДт,
		|	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА Количество ИНАЧЕ 0 КОНЕЦ КАК КоличествоКт,
		|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА ВалютнаяСумма ИНАЧЕ 0 КОНЕЦ КАК ВалютнаяСуммаДт,
		|	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА ВалютнаяСумма ИНАЧЕ 0 КОНЕЦ КАК ВалютнаяСуммаКт,";

		Для Индекс = 1 По ПланСчетовРегистра.МаксКоличествоСубконто Цикл
			ТекстЗапроса = ТекстЗапроса + "
			|	ВЫБОР КОГДА ВидДвижения = &Дебет  ТОГДА Субконто"+ Строка(Индекс) + " ИНАЧЕ NULL КОНЕЦ КАК СубконтоДт"+ Строка(Индекс)+"," + Символы.ПС + 
			"	ВЫБОР КОГДА ВидДвижения = &Кредит ТОГДА Субконто"+ Строка(Индекс) + " ИНАЧЕ NULL КОНЕЦ КАК СубконтоКт"+ Строка(Индекс); 
		КонецЦикла;

	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + "
		|	СуммаУпр КАК Сумма,
		|	СуммаСценария КАК СуммаСценария,";
		
	Если НужныПромежуточныеИтогиПоПериоду Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	НАЧАЛОПЕРИОДА(Период, " + Период + ") КАК Период,";
	КонецЕсли;
		
	ТекстЗапроса = ТекстЗапроса + "
	|	ПРЕДСТАВЛЕНИЕ(Регистратор)КАК ПредставлениеОперации,
	|	Регистратор      КАК ДокументОперации,
	|	Период           КАК ДатаОперации,
	|	ПРЕДСТАВЛЕНИЕ(Сценарий) КАК Сценарий
	|
	|ИЗ
	|	РегистрБухгалтерии."+ИмяРегистраБухгалтерии+".ДвиженияССубконто(
	|		&НачПериода,
	|		&КонПериода,
	|";
	
	СтрокаОграниченийПоРеквизитам = " (Активность = ИСТИНА) И (Счет В ИЕРАРХИИ (&СчетАнализа))";
	БухгалтерскиеОтчеты.ДополнитьСтрокуОграниченийПоРеквизитам(СтрокаОграниченийПоРеквизитам, "Сценарий", Сценарий);
	
	ТекстФильтры = БухгалтерскиеОтчеты.ПолучитьТекстОграниченийПоПостроителюОтчета(ПостроительОтчета, ЗапросПоПроводкам);
	СтрокаОграниченийПоРеквизитам = БухгалтерскиеОтчеты.ОбъединитьОграничения(СтрокаОграниченийПоРеквизитам, ТекстФильтры);
	
	ТекстЗапроса = ТекстЗапроса + СтрокаОграниченийПоРеквизитам + "
	|	) КАК ОсновнойДвиженияССубконто
	|";
	
	ТекстЗапроса = ТекстЗапроса + "
	|УПОРЯДОЧИТЬ ПО Период, Регистратор ";
	
	Если НужныПромежуточныеИтогиПоПериоду Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|ИТОГИ 
			|	СУММА(КоличествоДт), 
			|	СУММА(ВалютнаяСуммаДт), 
			|	СУММА(КоличествоКт), 
			|	СУММА(ВалютнаяСуммаКт), 
			|	СУММА(Сумма), 
			|	СУММА(СуммаСценария) 
			|
			|ПО
			|	Период";
	КонецЕсли;
		
	ЗапросПоПроводкам.Текст = ТекстЗапроса;
	Проводки = ЗапросПоПроводкам.Выполнить().Выбрать();

	ОбластьМакет = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ДокументРезультат.Вывести(ОбластьМакет);

	// на начало периода
	Если Счет.Количественный Тогда
		ОбластьМакет = Макет.ПолучитьОбласть("СальдоКоличество");
	Иначе
		ОбластьМакет = Макет.ПолучитьОбласть("Сальдо");
	КонецЕсли;
	
	Остатки      = ЗапросПоОстаткам.Выполнить().Выбрать();
	ТекущееСальдо = 0;
	ТекущееСальдоКолво = 0;
	БухгалтерскиеОтчеты.ВывестиДанныеОстатковКарточкиСчетаВМакет(ЗапросПоОстаткам, ОбластьМакет, Счет, Истина, 
		ТекущееСальдо, ТекущееСальдоКолво);

	ДокументРезультат.Вывести(ОбластьМакет);

	ОборотДт = 0;
	ОборотКт = 0;
	ОборотСценарияДт = 0;
	ОборотСценарияКт = 0;
	ИтогоОборотДт   = 0;
	ИтогоОборотКт   = 0;
	ИтогоОборотСценарияДт   = 0;
	ИтогоОборотСценарияКт   = 0;
	ИтогоОборотКолвоДт   = 0;
	ИтогоОборотКолвоКт   = 0;
	ОбластьОборота = Неопределено;

	Пока Проводки.Следующий() Цикл

		Если Проводки.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоГруппировке Тогда

			Если ОбластьОборота = Неопределено Тогда

				ОбластьОборота = Макет.ПолучитьОбласть("Обороты");
				ОбластьОборота.Параметры.ОписательПериода = "Обороты за " + БухгалтерскиеОтчеты.ПолучитьПериодДатСтрокой(Период, Проводки.Период);
				
			Иначе

				ОбластьОборота.Параметры.ОборотДт = ОборотДт;
				ОбластьОборота.Параметры.ОборотКт = ОборотКт;
				ДокументРезультат.Вывести(ОбластьОборота);
				
				ОборотДт = 0;
				ОборотКт = 0;
				ОборотСценарияДт = 0;
				ОборотСценарияКт = 0;
				ОбластьОборота.Параметры.ОписательПериода = "Обороты за " + БухгалтерскиеОтчеты.ПолучитьПериодДатСтрокой(Период, Проводки.Период);
				ОбластьОборота.Параметры.Заполнить(Проводки);

			КонецЕсли;

		Иначе

			НачалоСтроки = ДокументРезультат.ВысотаТаблицы + 1;

			// детальные проводки 
			ОбластьМакет = Макет.ПолучитьОбласть("ЗаголовокПроводки");
			ОбластьМакет.Параметры.Заполнить(Проводки);
			ОбластьМакетСценария = Макет.ПолучитьОбласть("ЗаголовокПроводкиСценарий");

			Если СоответствиеПодчиненныеСчета[Проводки.СчетДт] <> Неопределено Тогда

				Если БухгалтерскиеОтчеты.ЗначениеПоляСоответствуетОтбору(Проводки, "Дт", ПостроительОтчета) Тогда
					
					ОбластьМакет.Параметры.СуммаДт = Проводки.Сумма;
					ОбластьМакетСценария.Параметры.СуммаСценарияДт = Проводки.СуммаСценария;
					
					ОборотДт      = ОборотДт      + Проводки.Сумма;
					ОборотСценарияДт = ОборотСценарияДт + Проводки.СуммаСценария;
					
					ИтогоОборотДт = ИтогоОборотДт + Проводки.Сумма;
					ИтогоОборотСценарияДт = ИтогоОборотСценарияДт + Проводки.СуммаСценария;
					ТекущееСальдо = ТекущееСальдо + Проводки.Сумма;
					
					ИтогоОборотКолвоДт = ИтогоОборотКолвоДт + БухгалтерскиеОтчеты.ПривестиКЧислу(Проводки.КоличествоДт);
					ТекущееСальдоКолво = ТекущееСальдоКолво + БухгалтерскиеОтчеты.ПривестиКЧислу(Проводки.КоличествоДт);
					
				КонецЕсли;

			КонецЕсли;

			Если СоответствиеПодчиненныеСчета[Проводки.СчетКт] <> Неопределено Тогда

				Если БухгалтерскиеОтчеты.ЗначениеПоляСоответствуетОтбору(Проводки, "Кт", ПостроительОтчета) Тогда
					
					ОбластьМакет.Параметры.СуммаКт = Проводки.Сумма;
					ОбластьМакетСценария.Параметры.СуммаСценарияКт = Проводки.СуммаСценария;
					
					ОборотКт      = ОборотКт      + Проводки.Сумма;
					ОборотСценарияКт = ОборотСценарияКт + Проводки.СуммаСценария;
					
					ИтогоОборотКт = ИтогоОборотКт + Проводки.Сумма;
					ИтогоОборотСценарияКт = ИтогоОборотСценарияКт + Проводки.СуммаСценария;
					ТекущееСальдо = ТекущееСальдо - Проводки.Сумма;
					
					ИтогоОборотКолвоКт = ИтогоОборотКолвоКт + БухгалтерскиеОтчеты.ПривестиКЧислу(Проводки.КоличествоКт);
					ТекущееСальдоКолво = ТекущееСальдоКолво - БухгалтерскиеОтчеты.ПривестиКЧислу(Проводки.КоличествоКт);
					
				КонецЕсли;

			КонецЕсли;

			ОбластьМакет.Параметры.Флаг   = ?(ТекущееСальдо = 0, "",?(ТекущееСальдо < 0,"К","Д"));
			ОбластьМакет.Параметры.Сальдо = ?(ТекущееСальдо > 0, ТекущееСальдо, - ТекущееСальдо);
			ДокументРезультат.Вывести(ОбластьМакет);
			ДокументРезультат.Вывести(ОбластьМакетСценария);

			СтруктураРасшифровки = Новый Структура;
			СтруктураРасшифровки.Вставить("ДокументОперации", Проводки.ДокументОперации);

			// Вывод Всех субконто операции
			ОбластьМакет = Макет.ПолучитьОбласть("СтрокаПроводки");

			КоличествоСубконтоСчета = БухгалтерскиеОтчеты.ОпределитьДляСчетаПоСоответсвиеКоличествоСубконто(Проводки.СчетДт, СоответствиеСчетовКэш);
			БухгалтерскиеОтчеты.ВывестиПредставленияСубконтоТекущейСтрокиВМакет("СубконтоДт", Проводки, КоличествоСубконтоСчета, 
				ОбластьМакет, ДокументРезультат, СтруктураРасшифровки);
			
			
			КоличествоСубконтоСчета = БухгалтерскиеОтчеты.ОпределитьДляСчетаПоСоответсвиеКоличествоСубконто(Проводки.СчетКт, СоответствиеСчетовКэш);
			БухгалтерскиеОтчеты.ВывестиПредставленияСубконтоТекущейСтрокиВМакет("СубконтоКт", Проводки, КоличествоСубконтоСчета, 
				ОбластьМакет, ДокументРезультат, СтруктураРасшифровки);


			Если (Проводки.КоличествоДт <> NULL ) ИЛИ (Проводки.КоличествоКт <> NULL) Тогда

				ОбластьМакет = Макет.ПолучитьОбласть("КоличествоПроводки");
				ОбластьМакет.Параметры.Заполнить(Проводки);
				ОбластьМакет.Параметры.СальдоКолво = ТекущееСальдоКолво;
				ОбластьМакет.Параметры.Расшифровка = СтруктураРасшифровки;
				ДокументРезультат.Вывести(ОбластьМакет);

			КонецЕсли;

			Если (Проводки.ВалютнаяСуммаДт <> NULL ) ИЛИ (Проводки.ВалютнаяСуммаКт <> NULL) Тогда

				ОбластьМакет = Макет.ПолучитьОбласть("ВалютнаяСуммаПроводки");
				ОбластьМакет.Параметры.Заполнить(Проводки);
				ОбластьМакет.Параметры.ОписательВалюты = "В валюте :";
				ОбластьМакет.Параметры.Расшифровка = СтруктураРасшифровки;
				ДокументРезультат.Вывести(ОбластьМакет);

			КонецЕсли;

			КонецСтроки = ДокументРезультат.ВысотаТаблицы;

			Область = ДокументРезультат.Область(НачалоСтроки, 3, КонецСтроки, 3);
			Область.Объединить();
			Область.Текст       = Проводки.ПредставлениеОперации;
			Область.Расшифровка = СтруктураРасшифровки;
			Область.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Строка;
			Область.РазмещениеТекста         = ТипРазмещенияТекстаТабличногоДокумента.Переносить;

		КонецЕсли;

	КонецЦикла;

	Если НужныПромежуточныеИтогиПоПериоду
		И Проводки.Количество() > 0 Тогда

		ОбластьОборота.Параметры.ОборотДт = ОборотДт;
		ОбластьОборота.Параметры.ОборотКт = ОборотКт;
		ОбластьОборота.Параметры.ОборотСценарияДт = ОборотСценарияДт;
		ОбластьОборота.Параметры.ОборотСценарияКт = ОборотСценарияКт;
		ДокументРезультат.Вывести(ОбластьОборота);
			
	КонецЕсли;
	
	Если ИтогоОборотКолвоДт<>0 или ИтогоОборотКолвоКт<>0 Тогда
		// Общий оборот за период
		ОбластьМакет = Макет.ПолучитьОбласть("ОборотыКоличество");
		
		ОбластьМакет.Параметры.ОборотКоличествоДт = ИтогоОборотКолвоДт;
		ОбластьМакет.Параметры.ОборотКоличествоКт = ИтогоОборотКолвоКт;
		
	Иначе
		// Общий оборот за период
		ОбластьМакет = Макет.ПолучитьОбласть("Обороты");
		
	КонецЕсли;
	
	ОбластьМакет.Параметры.ОписательПериода = "Обороты за период";
		ОбластьМакет.Параметры.ОборотДт = ИтогоОборотДт;
		ОбластьМакет.Параметры.ОборотКт = ИтогоОборотКт;
		ОбластьМакет.Параметры.ОборотСценарияДт = ИтогоОборотСценарияДт;
		ОбластьМакет.Параметры.ОборотСценарияКт = ИтогоОборотСценарияКт;
		
		ДокументРезультат.Вывести(ОбластьМакет);

	СчетКоличественный = Счет.Количественный;
	Если СчетКоличественный Тогда
		ОбластьМакет = Макет.ПолучитьОбласть("СальдоКоличество");
	Иначе
		ОбластьМакет = Макет.ПолучитьОбласть("Сальдо");
	КонецЕсли;

	ЗапросПоОстаткам.УстановитьПараметр("Период", ?(НЕ ЗначениеЗаполнено(ДатаКон), ДатаКон, Новый Граница(КонецДня(ДатаКон), ВидГраницы.Включая)));
	БухгалтерскиеОтчеты.ВывестиДанныеОстатковКарточкиСчетаВМакет(ЗапросПоОстаткам, ОбластьМакет, Счет, Ложь);
	ДокументРезультат.Вывести(ОбластьМакет);
    	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 3;

	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(ВысотаЗаголовка+2,,ВысотаЗаголовка+3,);
	
	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1,2,ДокументРезультат.ВысотаТаблицы,ДокументРезультат.ШиринаТаблицы);
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "КарточкаСчета "+ИмяРегистраБухгалтерии;

	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ДокументРезультат, ЗаголовокОтчета(), Строка(глЗначениеПеременной("глТекущийПользователь")));
	
КонецПроцедуры

//////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Обработчик события начала выбора значения субконто
//
// Параметры:
//	Элемент управления.
//	Стандартная обработка.
//
Процедура НачалоВыбораЗначенияСубконто(Элемент, СтандартнаяОбработка, ТипЗначенияПоля=Неопределено) Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Дата",         ДатаКон);
	СписокПараметров.Вставить("СчетУчета",    Счет);
	СписокПараметров.Вставить("Номенклатура", Неопределено);
	СписокПараметров.Вставить("Склад", Неопределено);
	//СписокПараметров.Вставить("Организация",  Организация);
	СписокПараметров.Вставить("Контрагент",  Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	// Поищем значения в отборе и в полях выбора субконто
	Для Инд=0 По ПостроительОтчета.Отбор.Количество()-1 Цикл
		
		СтрокаОтбора = ПостроительОтчета.Отбор[Инд];
		
		ЗначениеОтбора=?(ТипЗнч(СтрокаОтбора.Значение)<> Тип("СписокЗначений"), СтрокаОтбора.Значение, СтрокаОтбора.Значение[0].Значение);
		
		Если СтрокаОтбора.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура.ТипЗначения Тогда
			СписокПараметров.Вставить("Номенклатура", ЗначениеОтбора);
		ИначеЕсли СтрокаОтбора.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады.ТипЗначения Тогда
			СписокПараметров.Вставить("Склад", ЗначениеОтбора);
		ИначеЕсли СтрокаОтбора.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты.ТипЗначения Тогда
			СписокПараметров.Вставить("Контрагент", ЗначениеОтбора);
		ИначеЕсли СтрокаОтбора.ТипЗначения = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры.ТипЗначения Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ЗначениеОтбора);
		КонецЕсли;
		
	КонецЦикла;
	
	БухгалтерскийУчет.ОбработатьВыборСубконто(Элемент, СтандартнаяОбработка, , СписокПараметров, ТипЗначенияПоля);
	
КонецПроцедуры // ОбработкаВыбораСубконто()

Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	Если ЗначениеЗаполнено(Счет) Тогда
		
		СтарыеНастройки = УправлениеОтчетами.ПолучитьКопиюОтбораВТЗ(ПостроительОтчета.Отбор);
		
		БухгалтерскиеОтчеты.УстановитьЗапросИОтборПостроителяПоСубконтоДляДвижений(Счет, ИмяРегистраБухгалтерии, ПостроительОтчета,
			"Валюта.*");
        				
		УправлениеОтчетами.УстановитьОтборИзТаблицы(ПостроительОтчета.Отбор, СтарыеНастройки);
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьОтборПоСчету()

// Настраивает отчет по заданным параметрам (например, для расшифровки)
Процедура Настроить(СтруктураПараметров) Экспорт
	
	Параметры = БухгалтерскиеОтчеты.СоздатьПоСтруктуреСоответствие(СтруктураПараметров); 

	Счет = Параметры["Счет"];
	Организация = Параметры["Организация"];
	Сценарий = Параметры["Сценарий"];
	ДатаНач = Параметры["ДатаНач"];
	ДатаКон = Параметры["ДатаКон"];
	
	ЗаполнитьНачальныеНастройки();
	
	СтрокиОтбора = Параметры["Отбор"];
	
	БухгалтерскиеОтчеты.ВосстановитьОтборПостроителяОтчетовПоПараметрам(ПостроительОтчета, СтрокиОтбора);

КонецПроцедуры

//////////////////////////////////////////////////////////
// МОДУЛЬ ОБЪЕКТА
//

ИмяРегистраБухгалтерии = "Бюджетирование";

#КонецЕсли