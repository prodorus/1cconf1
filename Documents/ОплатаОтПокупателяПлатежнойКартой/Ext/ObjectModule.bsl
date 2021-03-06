Перем мУдалятьДвижения;

// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранит текущее распределение долга работника по займу
// на основную сумму займа и начисленные проценты
Перем СтруктураДолг Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

Перем ТаблицаПлатежейУпр;


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

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, Строка(ВидОперации)), Ссылка);

КонецПроцедуры // Печать()

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	//Возврат Новый Структура("ПКО", "Приходный кассовый ордер");
	Возврат Неопределено;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Возвращает таблицу, аналогичную таблице "Расшифровка платежа" с добавленной колонкой "СуммаУпр"
//
Функция ПолучитьТаблицуПлатежейУпрПоКартам(ДатаДокумента,ВалютаДокумента,Документ, ВидПлатежногоДокумента) Экспорт
	
	ВыбиратьДокументРасчетовСКонтрагентом = Истина;
	
	ВыбиратьПроект = Ложь;
	
	Запрос=Новый Запрос;
	
	Запрос.Текст="ВЫБРАТЬ
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.ВидДоговора КАК ВидДоговора,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.КонтролироватьДенежныеСредстваКомитента КАК КонтролироватьДенежныеСредстваКомитента,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.РасчетыВУсловныхЕдиницах КАК РасчетыВУсловныхЕдиницах,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов КАК ВедениеВзаиморасчетов,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.КонтролироватьСуммуЗадолженности КАК КонтролироватьСуммуЗадолженности,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.КонтролироватьЧислоДнейЗадолженности КАК КонтролироватьЧислоДнейЗадолженности,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.ДопустимаяСуммаЗадолженности КАК ДопустимаяСуммаЗадолженности,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента.ПроцентПредоплаты КАК ПроцентПредоплаты,
	|	ВЫБОР КОГДА НЕ РасшифровкаПлатежаДок.ДоговорКонтрагента=&ПустойДоговор 
	|		Тогда РасшифровкаПлатежаДок.ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом
	|		Иначе ЛОЖЬ КОНЕЦ КАК ВестиПоДокументамРасчетовСКонтрагентом,	
	|	РасшифровкаПлатежаДок.Сделка КАК Сделка," + ?(ВыбиратьДокументРасчетовСКонтрагентом, "
	|	РасшифровкаПлатежаДок.ДокументРасчетовСКонтрагентом КАК ДокументРасчетовСКонтрагентом,", "
	|	Неопределено КАК ДокументРасчетовСКонтрагентом,") + "
	|	РасшифровкаПлатежаДок.СуммаПлатежа КАК СуммаПлатежа,
	|	РасшифровкаПлатежаДок.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,"+?(ВыбиратьПроект,"
	|	РасшифровкаПлатежаДок.Проект КАК Проект,","
	|	Неопределено КАК Проект,")+"
 	|	РасшифровкаПлатежаДок.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
 	|	РасшифровкаПлатежаДок.КратностьВзаиморасчетов КАК КратностьВзаиморасчетов,
	|	ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА &ВалютаДокумента=&ВалютаУпрУчета ТОГДА РасшифровкаПлатежаДок.СуммаПлатежа
	|		КОГДА (КурсыУпрУчета.Курс ЕСТЬ NULL) ИЛИ (КурсыДокумента.Курс ЕСТЬ NULL) ТОГДА 0
	|		КОГДА &ВалютаДокумента<>&ВалютаУпрУчета И КурсыДокумента.Курс <>0 И КурсыУпрУчета.Курс <>0 ТОГДА
	|			РасшифровкаПлатежаДок.СуммаПлатежа*КурсыДокумента.Курс * КурсыУпрУчета.Кратность 
	|			/ (КурсыУпрУчета.Курс * КурсыДокумента.Кратность)
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (15,2)) КАК СуммаУпр,
	|	ВЫРАЗИТЬ 
	|	(ВЫБОР 
	|		КОГДА &ВалютаДокумента=&ВалютаРеглУчета ТОГДА РасшифровкаПлатежаДок.СуммаПлатежа
	|		КОГДА (КурсыУпрУчета.Курс ЕСТЬ NULL) ИЛИ (КурсыДокумента.Курс ЕСТЬ NULL) ТОГДА 0
	|		КОГДА &ВалютаДокумента<>&ВалютаРеглУчета И КурсыДокумента.Курс <>0 ТОГДА
	|			РасшифровкаПлатежаДок.СуммаПлатежа*КурсыДокумента.Курс
	|			/ КурсыДокумента.Кратность
	|		ИНАЧЕ
	|			0
	|		КОНЕЦ КАК ЧИСЛО (15,2)) КАК СуммаРегл,
	|	ВЫБОР
	|		КОГДА КурсыДокумента.Курс ЕСТЬ NULL ТОГДА 0
	|		ИНАЧЕ КурсыДокумента.Курс КОНЕЦ Как КурсДокумента,
	|	ВЫБОР
	|		КОГДА КурсыДокумента.Кратность ЕСТЬ NULL ТОГДА 0
	|		ИНАЧЕ КурсыДокумента.Кратность КОНЕЦ Как КратностьДокумента,
	|	ВЫБОР
	|		КОГДА КурсыУпрУчета.Курс ЕСТЬ NULL ТОГДА 0
	|		ИНАЧЕ КурсыУпрУчета.Курс КОНЕЦ Как КурсУпрУчета,
	|	ВЫБОР
	|		КОГДА КурсыУпрУчета.Кратность ЕСТЬ NULL ТОГДА 0
	|		ИНАЧЕ КурсыУпрУчета.Кратность КОНЕЦ Как КратностьУпрУчета
	|ИЗ
	|	Документ."+ВидПлатежногоДокумента+".РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, Валюта=&ВалютаУпрУчета) КАК КурсыУпрУчета
	|	ПО ИСТИНА
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&ДатаДокумента, Валюта=&ВалютаДокумента) КАК КурсыДокумента
	|	ПО ИСТИНА
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("ДатаДокумента",ДатаДокумента);
	Запрос.УстановитьПараметр("ВалютаДокумента",ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУпрУчета",глЗначениеПеременной("ВалютаУправленческогоУчета"));
	Запрос.УстановитьПараметр("ВалютаРеглУчета",глЗначениеПеременной("ВалютаРегламентированногоУчета"));
	Запрос.УстановитьПараметр("Ссылка",Документ);
	Запрос.УстановитьПараметр("ПустойДоговор",Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции // ПолучитьТаблицуПлатежей()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Проверяет установленные курсы валют документа перед пересчетом сумм
// Нулевые курсы устанавливаются в 1
//
Процедура ПроверкаКурсовВалют(СтрокаПлатеж) Экспорт

	КурсДокумента=?(КурсДокумента=0,1, КурсДокумента);
	КратностьДокумента=?(КратностьДокумента=0,1, КратностьДокумента);
	
	Если Не СтрокаПлатеж=Неопределено Тогда
		СтрокаПлатеж.КурсВзаиморасчетов=?(СтрокаПлатеж.КурсВзаиморасчетов=0,1,СтрокаПлатеж.КурсВзаиморасчетов);
		СтрокаПлатеж.КратностьВзаиморасчетов=?(СтрокаПлатеж.КратностьВзаиморасчетов=0,1,СтрокаПлатеж.КратностьВзаиморасчетов);
	КонецЕсли;

КонецПроцедуры // ПроверкаКурсовВалют()

// Процедура выполняет заполнение суммы документа,
// по регистру "СуммыЗаказов".
//
// Параметры:
//  ДокументОснование  - документ ссылка (Заказ покупателя, Заказ поставщику).
//  ВалютаДокумента    - валюта документа (валюта регламентированного учета организаций)
//  КурсВзаиморасчетов - курс взаиморасчетов по договору
//  КратностьВзаиморасчетов - кратность взаиморасчетов по договору
//
Процедура ЗаполнитьПоЗаказуУпр(СтрокаПлатеж)

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Заказ", ДокументОснование);

	Запрос.Текст ="ВЫБРАТЬ
	|	РасчетыСКонтрагентамиОстатки.Сделка Как Сделка,
	|	РасчетыСКонтрагентамиОстатки.СуммаВзаиморасчетовОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыСКонтрагентами.Остатки(, Сделка = &Заказ) КАК РасчетыСКонтрагентамиОстатки";
	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		СтрокаПлатеж.Сделка=Выборка.Сделка;
		Если Выборка.Сумма > 0 Тогда
			СтрокаПлатеж.СуммаВзаиморасчетов=Выборка.Сумма;
			СуммаДокумента = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Сумма,
			                            СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, 
			                            ВалютаДокумента,
			                            СтрокаПлатеж.КурсВзаиморасчетов, КурсДокумента,
			                            СтрокаПлатеж.КратностьВзаиморасчетов, КратностьДокумента);
										
			СтрокаПлатеж.СуммаПлатежа=СуммаДокумента;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьПоЗаказуУпр()

Процедура ЗаполнитьПоСуммеДокументаУпр(СтрокаПлатеж)
	
	СтруктураКурсаОснования = МодульВалютногоУчета.ПолучитьКурсВалюты(ДокументОснование.ВалютаДокумента, ДокументОснование.Дата);
	КурсОснования=СтруктураКурсаОснования.Курс;
	КратностьОснования=СтруктураКурсаОснования.Кратность;

	ОснованиеСуммаДокумента  = ДокументОснование.СуммаДокумента;
	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") Тогда
		ОснованиеСуммаДокумента = ОснованиеСуммаДокумента - ДокументОснование.СуммаВознаграждения;
	КонецЕсли;
	
	СтрокаПлатеж.СуммаВзаиморасчетов = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(ОснованиеСуммаДокумента, ДокументОснование.ВалютаДокумента, ДокументОснование.ДоговорКонтрагента.ВалютаВзаиморасчетов,
									 КурсОснования, ДокументОснование.КурсВзаиморасчетов, КратностьОснования, ДокументОснование.КратностьВзаиморасчетов);
	СуммаДокумента      = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаПлатеж.СуммаВзаиморасчетов, СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, ВалютаДокумента, СтрокаПлатеж.КурсВзаиморасчетов,
									 КурсДокумента, СтрокаПлатеж.КратностьВзаиморасчетов,КратностьДокумента);
	СтрокаПлатеж.СуммаПлатежа=СуммаДокумента;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплатаУпр()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("Организация");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("Контрагент");
	СтруктураПолей.Вставить("ДоговорЭквайринга");
	СтруктураПолей.Вставить("Эквайрер");
	СтруктураПолей.Вставить("ДоговорВзаиморасчетовЭквайрера");
	СтруктураПолей.Вставить("ВидОплаты");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда 
		
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗначение()

// Проверяет заполнение табличной части документа
//
Процедура ПроверитьЗаполнениеТЧ(Отказ, Заголовок)
	
	Для Каждого Платеж Из РасшифровкаПлатежа Цикл
		
		ПроверитьЗначение(Платеж.ДоговорКонтрагента,Отказ, Заголовок,"Договор");
		ПроверитьЗначение(Платеж.СуммаВзаиморасчетов,Отказ, Заголовок,"Сумма взаиморасчетов");
		
		Если Не Отказ Тогда
			
			// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
			Если Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Заказ покупателя","Заказ поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);
				
				Если Отказ Тогда
				
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по заказам""! 
					|Заполните поле """+ТекстСделка+"""!");
					
				КонецЕсли;
				
			ИначеЕсли Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Счет покупателя","Счет поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);

				Если Отказ Тогда
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по счетам""! 
					|Заполните поле """+ТекстСделка+"""!");
				КонецЕсли;
						
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Организация) 
				И Организация <> Платеж.ДоговорКонтрагента.Организация Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Выбран договор контрагента, не соответствующий организации, указанной в документе!", Отказ, Заголовок);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ПроверитьЗаполнениеТЧ

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента)

	ДвиженияПоРегистрамУпр(Режим, Отказ, Заголовок);
	ДвиженияПоРегистрамРегл(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
	ДвиженияПоРегистрамУСНРегл(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);

	ДвиженияПоРегистрамОперативныхВзаиморасчетов(Режим, Отказ, Заголовок,СтруктураШапкиДокумента);

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамУпр(Режим, Отказ, Заголовок)
	
	Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
		
		РасчетыВозврат    = УправлениеДенежнымиСредствами.НаправленияДвиженияДляДокументаДвиженияДенежныхСредствУпр(ВидОперации);
		КоэффициентСторно = ?(РасчетыВозврат = Перечисления.РасчетыВозврат.Возврат, -1, 1);
	
		ДвиженияПоКонтрагентам = ТаблицаПлатежейУпр.Скопировать();
		ДвиженияПоКонтрагентам.Свернуть("ДоговорКонтрагента,Сделка,ДокументРасчетовСКонтрагентом","СуммаПлатежа,СуммаВзаиморасчетов,СуммаУпр");
	
		// По регистру "ВзаиморасчетыСКонтрагентами"
		
		НаборДвиженийВзаиморасчеты   = Движения.ВзаиморасчетыСКонтрагентами;
		
		// По контрагенту - по строкам табличной части
		
		ТаблицаДвиженийВзаиморасчеты = НаборДвиженийВзаиморасчеты.ВыгрузитьКолонки();
		
		Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл
			
			ТекущаяСделка = УправлениеДенежнымиСредствами.ОпределитьСделкуСтрокиТЧ (ЭтотОбъект,СтрокаПлатеж);
			
			СтрокаДвижений = ТаблицаДвиженийВзаиморасчеты.Добавить();
			СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
			СтрокаДвижений.Контрагент  		   = Контрагент;
			СтрокаДвижений.Организация  	   = Организация;

			СтрокаДвижений.Сделка              = ТекущаяСделка;
			
			СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов;
			СтрокаДвижений.СуммаУпр            = СтрокаПлатеж.СуммаУпр;
			
		КонецЦикла;
		
		НаборДвиженийВзаиморасчеты.мПериод            = Дата;
		НаборДвиженийВзаиморасчеты.мТаблицаДвижений   = ТаблицаДвиженийВзаиморасчеты;
		
		Если КоэффициентСторно = 1 Тогда
			НаборДвиженийВзаиморасчеты.ВыполнитьРасход();
		Иначе
			НаборДвиженийВзаиморасчеты.ВыполнитьПриход();
		КонецЕсли;
		
		// По эквайреру
		
		ВалютаРасчетовЭквайрера = ДоговорВзаиморасчетовЭквайрера.ВалютаВзаиморасчетов;
		КурсРасчетовЭквайрера   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРасчетовЭквайрера, Дата);
		
		ТаблицаДвиженийВзаиморасчеты = НаборДвиженийВзаиморасчеты.ВыгрузитьКолонки();
		
		СтрокаДвижений = ТаблицаДвиженийВзаиморасчеты.Добавить();
		СтрокаДвижений.ДоговорКонтрагента  = ДоговорВзаиморасчетовЭквайрера;
		СтрокаДвижений.Контрагент  		   = Эквайрер;
		СтрокаДвижений.Организация  	   = Организация;
		СтрокаДвижений.Сделка              = Неопределено;
		
		СуммаВзаиморасчетовЭквайрера       = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(
			ДвиженияПоКонтрагентам.Итог("СуммаПлатежа"), 
			ВалютаДокумента, ВалютаРасчетовЭквайрера, 
			КурсДокумента, КурсРасчетовЭквайрера.Курс, 
			КратностьДокумента, КурсРасчетовЭквайрера.Кратность);
		СуммаУпрЭквайрера = ДвиженияПоКонтрагентам.Итог("СуммаУпр");
			
		СтрокаДвижений.СуммаВзаиморасчетов = СуммаВзаиморасчетовЭквайрера;
		СтрокаДвижений.СуммаУпр            = СуммаУпрЭквайрера;
		
		НаборДвиженийВзаиморасчеты.мПериод            = Дата;
		НаборДвиженийВзаиморасчеты.мТаблицаДвижений   = ТаблицаДвиженийВзаиморасчеты;
		
		Если КоэффициентСторно = 1 Тогда
			НаборДвиженийВзаиморасчеты.ВыполнитьПриход();
		Иначе
			НаборДвиженийВзаиморасчеты.ВыполнитьРасход();
		КонецЕсли;
		
		// По регистру "РасчетыСКонтрагентами"
		
		НаборДвиженийРасчеты   = Движения.РасчетыСКонтрагентами;
		
		// По контрагенту - по строкам табличной части
		
		ТаблицаДвиженийРасчеты = НаборДвиженийРасчеты.ВыгрузитьКолонки();
		
		Для Каждого СтрокаПлатеж ИЗ ДвиженияПоКонтрагентам Цикл
			
			СтрокаДвижений = ТаблицаДвиженийРасчеты.Добавить();
			СтрокаДвижений.ДоговорКонтрагента  = СтрокаПлатеж.ДоговорКонтрагента;
			СтрокаДвижений.Контрагент  		   = Контрагент;
			СтрокаДвижений.Организация  	   = Организация;
			СтрокаДвижений.Сделка              = СтрокаПлатеж.Сделка;
			СтрокаДвижений.РасчетыВозврат      = РасчетыВозврат;
			
			СтрокаДвижений.СуммаВзаиморасчетов = СтрокаПлатеж.СуммаВзаиморасчетов;
			СтрокаДвижений.СуммаУпр            = СтрокаПлатеж.СуммаУпр;
			
		КонецЦикла;
		
		НаборДвиженийРасчеты.мПериод            = Дата;
		НаборДвиженийРасчеты.мТаблицаДвижений   = ТаблицаДвиженийРасчеты;
		
		Если КоэффициентСторно = 1 Тогда
			НаборДвиженийРасчеты.ВыполнитьРасход();
		Иначе
			НаборДвиженийРасчеты.ВыполнитьПриход();
		КонецЕсли;
		
		// По эквайреру
		
		ТаблицаДвиженийРасчеты = НаборДвиженийРасчеты.ВыгрузитьКолонки();
		
		СтрокаДвижений = ТаблицаДвиженийРасчеты.Добавить();
		СтрокаДвижений.ДоговорКонтрагента  = ДоговорВзаиморасчетовЭквайрера;
		СтрокаДвижений.Контрагент  		   = Эквайрер;
		СтрокаДвижений.Организация  	   = Организация;
		СтрокаДвижений.Сделка              = Неопределено;
		СтрокаДвижений.РасчетыВозврат      = Перечисления.РасчетыВозврат.Расчеты;
		
		СтрокаДвижений.СуммаВзаиморасчетов = СуммаВзаиморасчетовЭквайрера;
		СтрокаДвижений.СуммаУпр            = СуммаУпрЭквайрера;
			
		НаборДвиженийРасчеты.мПериод            = Дата;
		НаборДвиженийРасчеты.мТаблицаДвижений   = ТаблицаДвиженийРасчеты;
		
		Если КоэффициентСторно = 1 Тогда
			НаборДвиженийРасчеты.ВыполнитьПриход();
		Иначе
			НаборДвиженийРасчеты.ВыполнитьРасход();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)
	
	ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоРеализации;
	
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ВозвратДенежныхСредствПокупателю Тогда
		ВидДвижения = ВидДвиженияНакопления.Приход;
	Иначе //.ОплатаПокупателя Тогда
		ВидДвижения = ВидДвиженияНакопления.Расход;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("РежимПроведения", РежимПроведения);
	
	УправлениеВзаиморасчетами.ОтражениеОплатыВРегистреОперативныхРасчетовПоДокументам(СтруктураШапкиДокумента, Дата, "РасшифровкаПлатежа", ВидРасчетовПоОперации, ВидДвижения, Движения, Отказ, Заголовок);

КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(Режим, Отказ, Заголовок, СтруктураШапкиДокумента)

	Если не ОтражатьВБухгалтерскомУчете Тогда
		Возврат;
	КонецЕсли;

	ПроводкиБУ = Движения.Хозрасчетный;
	
	СтруктураПараметровДДС = БухгалтерскийУчетРасчетовСКонтрагентами.ПодготовкаСтруктурыПараметровДляДвиженияДенег(Ссылка, мВалютаРегламентированногоУчета, Заголовок, СчетУчетаРасчетовСЭквайрером, , СтруктураШапкиДокумента);
	
	ВидСубконтоКонтрагент = СчетУчетаРасчетовСЭквайрером.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты, "ВидСубконто");
	Если НЕ ВидСубконтоКонтрагент = Неопределено Тогда
		КолонкаЭквайрера = "КоррСубконто" + Формат(ВидСубконтоКонтрагент.НомерСтроки, "ЧГ=");
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("На выбранном счете расчетов с эквайрером отсутствует аналитика по контрагентам!",Отказ, Заголовок);
	КонецЕсли;
	
	ВидСубконтоДоговоры = СчетУчетаРасчетовСЭквайрером.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры, "ВидСубконто");
	Если НЕ ВидСубконтоДоговоры = Неопределено Тогда
		КолонкаДоговора  = "КоррСубконто" + Формат(ВидСубконтоДоговоры.НомерСтроки, "ЧГ=");
	Иначе
		ОбщегоНазначения.СообщитьОбОшибке("На выбранном счете расчетов с эквайрером отсутствует аналитика по договорам!",Отказ, Заголовок);
	КонецЕсли;	
	
	Если Отказ Тогда 
		Возврат 
	КонецЕсли;
	
	СтруктураПараметровДДС.Таблица.ЗаполнитьЗначения(Эквайрер,КолонкаЭквайрера);
	СтруктураПараметровДДС.Таблица.ЗаполнитьЗначения(ДоговорВзаиморасчетовЭквайрера,КолонкаДоговора);
		
	БухгалтерскийУчетРасчетовСКонтрагентами.БухгалтерскийУчетРасчетыСКонтрагентами_Оплата(СтруктураПараметровДДС, СтруктураШапкиДокумента, Движения, Отказ, Заголовок, ПринадлежностьПоследовательностям);
	
КонецПроцедуры

Процедура ДвиженияПоРегистрамУСНРегл(РежимПроведения,Отказ, Заголовок, СтруктураШапкиДокумента)
	
	Если НЕ СтруктураШапкиДокумента.ОтражатьВНалоговомУчетеУСН Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйУчетУСН.ДвиженияУСН(Ссылка, РежимПроведения);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок)

	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейОплатаУпр(), Отказ, Заголовок);

	Если ВидОплаты.ТипОплаты <> Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта Тогда
		ОбщегоНазначения.СообщитьОбОшибке("В документе выбран вид оплаты неверного типа!", Отказ, Заголовок);
	КонецЕсли;

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа")= СуммаДокумента Тогда

		Сообщить(Заголовок+"
			|не совпадают сумма документа и ее расшифровка.");
		Отказ = Истина;

	КонецЕсли;
	
	ПроверитьЗаполнениеТЧ(Отказ, Заголовок);

КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаРегл(Отказ, Заголовок)

	Если ОтражатьВБухгалтерскомУчете Тогда

		Если (ЕстьРасчетыСКонтрагентами=истина) ИЛИ (ЕстьРасчетыПоКредитам=истина) Тогда
			
			СтруктураПолей = Новый Структура("СчетУчетаРасчетовСЭквайрером");
			ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураПолей, Отказ, Заголовок);

			СтруктураПолей = Новый Структура("СчетУчетаРасчетовСКонтрагентом, ДоговорКонтрагента");
			ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РасшифровкаПлатежа", СтруктураПолей, Отказ, Заголовок);

		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьРеквизитыПоУмолчаниюУпр()

	ОтраженоВОперУчете           = Истина;
	ОтражатьВУправленческомУчете = Истина;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если (Основание <> Неопределено) И (Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Основание))) Тогда
		// Заполним реквизиты из стандартного набора по документу основанию.
		ДокументОснование = Основание;
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
	КонецЕсли;

	ВалютаДокумента         = мВалютаРегламентированногоУчета;

	СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	КурсДокумента           = СтруктураКурсаДокумента.Курс;
	КратностьДокумента      = СтруктураКурсаДокумента.Кратность;

	стрСпособЗаполнения  = "Не заполнять";
	СтрокаПлатеж = РасшифровкаПлатежа.Добавить();

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") 
	 ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") Тогда

		ВидОперации  = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ОплатаПокупателя;
		Контрагент   = Основание.Контрагент;

		СтрокаПлатеж.ДоговорКонтрагента   = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
        Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") И Основание.Проведен  Тогда
			стрСпособЗаполнения = "По заказу";
		Иначе
			стрСпособЗаполнения = "По сумме документа";
		КонецЕсли;

		Если (ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя"))
			И (СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом
			ИЛИ СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам) Тогда
			
			СтрокаПлатеж.Сделка=Основание;
			
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") И СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
			
			СтрокаПлатеж.Сделка=Основание;
			
		ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.СчетНаОплатуПокупателю") И СтрокаПлатеж.ДоговорКонтрагента.ВедениеВзаиморасчетов=Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
			
			СтрокаПлатеж.Сделка=Основание.ЗаказПокупателя;			
			Если НЕ ЗначениеЗаполнено(Основание.ЗаказПокупателя) Тогда
				//заполняем заказ покупателя из табличной части
				СтруктураКурсаОснования = МодульВалютногоУчета.ПолучитьКурсВалюты(Основание.ВалютаДокумента, Основание.Дата);
				КурсОснования=СтруктураКурсаОснования.Курс;
				КратностьОснования=СтруктураКурсаОснования.Кратность;

				Запрос = Новый Запрос;
				Запрос.Текст = 
				"ВЫБРАТЬ
				|	СчетНаОплатуПокупателюТовары.ЗаказПокупателя,
				|	СУММА(ВЫБОР
				|			КОГДА СчетНаОплатуПокупателюТовары.Ссылка.УчитыватьНДС
				|					И (НЕ СчетНаОплатуПокупателюТовары.Ссылка.СуммаВключаетНДС)
				|				ТОГДА СчетНаОплатуПокупателюТовары.Сумма + СчетНаОплатуПокупателюТовары.СуммаНДС
				|			ИНАЧЕ СчетНаОплатуПокупателюТовары.Сумма
				|		КОНЕЦ) КАК Сумма
				|ИЗ
				|	Документ.СчетНаОплатуПокупателю.Товары КАК СчетНаОплатуПокупателюТовары
				|ГДЕ
				|	СчетНаОплатуПокупателюТовары.Ссылка = &СчетНаОплату
				|
				|СГРУППИРОВАТЬ ПО
				|	СчетНаОплатуПокупателюТовары.ЗаказПокупателя";
				
				Запрос.УстановитьПараметр("СчетНаОплату",Основание);
				
				Выборка = Запрос.Выполнить().Выбрать();
				ПервыйПроход = Истина;
				Пока Выборка.Следующий() Цикл
					Если ПервыйПроход Тогда
						СтрокаПлатеж.Сделка = Выборка.ЗаказПокупателя;
						КопияСтрокаПлатеж = СтрокаПлатеж;
						ПервыйПроход = Ложь;
					иначе
						СтрокаПлатеж = РасшифровкаПлатежа.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаПлатеж, КопияСтрокаПлатеж);
						СтрокаПлатеж.Сделка = Выборка.ЗаказПокупателя;
					КонецЕсли;
					
					СтрокаПлатеж.СуммаВзаиморасчетов = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Сумма, Основание.ВалютаДокумента, Основание.ДоговорКонтрагента.ВалютаВзаиморасчетов,
					                                   КурсОснования, Основание.КурсВзаиморасчетов, КратностьОснования, Основание.КратностьВзаиморасчетов);
					СуммаДокумента = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Сумма, СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, ВалютаДокумента, СтрокаПлатеж.КурсВзаиморасчетов,
					                 КурсДокумента, СтрокаПлатеж.КратностьВзаиморасчетов,КратностьДокумента);
					СтрокаПлатеж.СуммаПлатежа=СуммаДокумента;
					УправлениеДенежнымиСредствами.ПересчитатьСуммуНДС(СтрокаПлатеж);
				КонецЦикла;
				стрСпособЗаполнения = "";
			КонецЕсли;

		КонецЕсли;


		#Если Клиент Тогда
		СтрокаПлатеж.СтавкаНДС = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяСтавкаНДС");
		#КонецЕсли

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг")
		или ТипЗнч(Основание) = Тип("ДокументСсылка.ОтчетКомиссионераОПродажах") 
		или ТипЗнч(Основание) = Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг") Тогда

		ВидОперации  = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ОплатаПокупателя;
		Контрагент   = Основание.Контрагент;

		СтрокаПлатеж.ДоговорКонтрагента      = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
		
		Если Основание.ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом Тогда
			СтрокаПлатеж.ДокументРасчетовСКонтрагентом = Основание;
		КонецЕсли;

		СтрокаПлатеж.Сделка = Основание.Сделка;
		
		#Если Клиент Тогда
		СтрокаПлатеж.СтавкаНДС = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяСтавкаНДС");
		#КонецЕсли

		стрСпособЗаполнения = "По взаиморасчетам";
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияУслугПоПереработке") Тогда

		ВидОперации  = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ОплатаПокупателя;
		Контрагент   = Основание.Контрагент;

		СтрокаПлатеж.ДоговорКонтрагента      = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = МодульВалютногоУчета.ПолучитьКурсВалюты( СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;

		СтрокаПлатеж.Сделка = Основание.Сделка;
		
		СтрокаПлатеж.СтавкаНДС = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию( глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяСтавкаНДС");

		стрСпособЗаполнения = "По взаиморасчетам";
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда
		
		ВидОперации  = Перечисления.ВидыОперацийОплатаОтПокупателяПлатежнойКартой.ВозвратДенежныхСредствПокупателю;
		Контрагент   = Основание.Контрагент;

		СтрокаПлатеж.ДоговорКонтрагента      = Основание.ДоговорКонтрагента;
		СтруктураКурсаВзаиморасчетов         = МодульВалютногоУчета.ПолучитьКурсВалюты(СтрокаПлатеж.ДоговорКонтрагента.ВалютаВзаиморасчетов, Дата);
		СтрокаПлатеж.КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
		СтрокаПлатеж.КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
		
		Если Основание.ДоговорКонтрагента.ВестиПоДокументамРасчетовСКонтрагентом Тогда
			СтрокаПлатеж.ДокументРасчетовСКонтрагентом = Основание;
		КонецЕсли;

		СтрокаПлатеж.Сделка = Основание.Сделка;
		
		#Если Клиент Тогда
		СтрокаПлатеж.СтавкаНДС = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),"ОсновнаяСтавкаНДС");
		#КонецЕсли

		стрСпособЗаполнения = "По взаиморасчетам";

	КонецЕсли;

	ПроверкаКурсовВалют(СтрокаПлатеж);

	Если стрСпособЗаполнения = "По заказу" Тогда
		ЗаполнитьПоЗаказуУпр(СтрокаПлатеж);
		УправлениеДенежнымиСредствами.ПересчитатьСуммуНДС(СтрокаПлатеж);

	ИначеЕсли стрСпособЗаполнения = "По взаиморасчетам" Тогда
		УправлениеДенежнымиСредствами.ЗаполнитьПоВзаиморасчетамУпр(ВалютаДокумента,КурсДокумента,КратностьДокумента,СтрокаПлатеж,1);
		СуммаДокумента=СтрокаПлатеж.СуммаПлатежа;
		УправлениеДенежнымиСредствами.ПересчитатьСуммуНДС(СтрокаПлатеж);

	ИначеЕсли стрСпособЗаполнения = "По сумме документа" Тогда
		ЗаполнитьПоСуммеДокументаУпр(СтрокаПлатеж);
		УправлениеДенежнымиСредствами.ПересчитатьСуммуНДС(СтрокаПлатеж);

	КонецЕсли;
	
	ЕстьРасчетыСКонтрагентами=Истина;
	ЕстьРасчетыПоКредитам=Ложь;
	
	Оплачено=Истина;
	ОтражатьВБухгалтерскомУчете=Истина;
	
	Для Каждого Платеж Из РасшифровкаПлатежа Цикл
		
		Если ОтражатьВБухгалтерскомУчете Тогда
			Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
				СчетаУчета = БухгалтерскийУчетРасчетовСКонтрагентами.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, Платеж.ДоговорКонтрагента);
				Платеж.СчетУчетаРасчетовСКонтрагентом = СчетаУчета.СчетРасчетовПокупателя;
				Платеж.СчетУчетаРасчетовПоАвансам     = СчетаУчета.СчетАвансовПокупателя;
			КонецЕсли;
		Иначе
			Платеж.СчетУчетаРасчетовСКонтрагентом = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
			Платеж.СчетУчетаРасчетовПоАвансам     = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
		КонецЕсли;

	КонецЦикла;

	Ответственный = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный");

	ЗаполнитьРеквизитыПоУмолчаниюУпр();
    
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)
	Перем Заголовок, СтруктураШапкиДокумента;

	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	СтруктураШапкиДокумента   = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	СтруктураШапкиДокумента.Вставить("ВалютаРегламентированногоУчета", мВалютаРегламентированногоУчета);
	СтруктураШапкиДокумента.Вставить("ОтражатьВРегламентированномУчете", Организация.ОтражатьВРегламентированномУчете);

	СтруктураКурсаДокумента   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
	КурсДокумента             = СтруктураКурсаДокумента.Курс;
	КратностьДокумента        = СтруктураКурсаДокумента.Кратность;

	ЕстьРасчетыСКонтрагентами = Истина;
	ЕстьРасчетыПоКредитам     = Ложь;

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	//ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	Отказ = НЕ (ОтражатьВБухгалтерскомУчете ИЛИ ОтражатьВНалоговомУчете ИЛИ ОтражатьВУправленческомУчете);
	Если Отказ Тогда
		Сообщить("Документ должен принадлежать хоть к одному виду учета");
		Возврат;
	КонецЕсли;

	ТаблицаПлатежейУпр = ПолучитьТаблицуПлатежейУпрПоКартам(Дата,ВалютаДокумента,Ссылка, "ОплатаОтПокупателяПлатежнойКартой");

	ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок);
	ПроверитьЗаполнениеДокументаРегл(Отказ, Заголовок);

	//Проверим на возможность проведения в БУ и НУ
	Если ОтражатьВБухгалтерскомУчете или ОтражатьВНалоговомУчете тогда
		#Если Клиент Тогда
		Для каждого СтрокаОплаты из РасшифровкаПлатежа Цикл

			УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтрокаОплаты.ДоговорКонтрагента, ВалютаДокумента,
												ОтражатьВБухгалтерскомУчете,
												ОтражатьВНалоговомУчете,
												мВалютаРегламентированногоУчета, Истина, Отказ, 
												Заголовок, "Строка " + СтрокаОплаты.НомерСтроки + " - ");
		КонецЦикла;
		#КонецЕсли
	КонецЕсли;

	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// Удаление записей регистрации из всех последовательностей
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерЧекаККМ = 0;
	ККМ = ПредопределенноеЗначение("Справочник.КассыККМ.ПустаяСсылка");
	ТекстЭлектронногоЧека = "";
	
КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
