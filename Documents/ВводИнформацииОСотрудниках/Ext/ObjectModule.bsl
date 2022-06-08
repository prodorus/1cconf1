﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВводИнформацииОСотрудниках.Ссылка,
	|	ВводИнформацииОСотрудниках.Номер,
	|	ВводИнформацииОСотрудниках.Дата,
	|	ВводИнформацииОСотрудниках.Ответственный,
	|	ВводИнформацииОСотрудниках.Комментарий
	|ИЗ
	|	Документ.ВводИнформацииОСотрудниках КАК ВводИнформацииОСотрудниках
	|ГДЕ
	|	ВводИнформацииОСотрудниках.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Возврат Запрос.Выполнить()

КонецФункции

// Формирует запрос по таблице "ИнформацияОСотрудниках" документа
//
Функция СформироватьЗапросПоРаботники()

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВводИнформацииОСотрудникахИнформацияОСотрудниках.Сотрудник,
	|	ВЫБОР
	|		КОГДА ВводИнформацииОСотрудникахИнформацияОСотрудниках.Сотрудник.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ВводИнформацииОСотрудникахИнформацияОСотрудниках.Сотрудник.Организация
	|		ИНАЧЕ ВводИнформацииОСотрудникахИнформацияОСотрудниках.Сотрудник.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	ВводИнформацииОСотрудникахИнформацияОСотрудниках.Сотрудник.Организация КАК ОбособленноеПодразделение,
	|	ВводИнформацииОСотрудникахИнформацияОСотрудниках.ПодразделениеОрганизации,
	|	ВводИнформацииОСотрудникахИнформацияОСотрудниках.Должность,
	|	ВводИнформацииОСотрудникахИнформацияОСотрудниках.НомерСтроки
	|ИЗ
	|	Документ.ВводИнформацииОСотрудниках.ИнформацияОСотрудниках КАК ВводИнформацииОСотрудникахИнформацияОСотрудниках
	|ГДЕ
	|	ВводИнформацииОСотрудникахИнформацияОСотрудниках.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Возврат Запрос.Выполнить()

КонецФункции // СформироватьЗапросПоРаботники()
 
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
	""" табл. части ""Информация о сотрудниках"": ";
	
	// Сотрудник
	НетСотрудника = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник);
	Если НетСотрудника Тогда
		ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран работник!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры
  
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаСтрокЗапроса)
	
	// Движения по регистру "РаботникиОрганизации"
	Движение = Движения.РаботникиОрганизаций.Добавить();
	
	// Свойства
	Движение.Период						= ВыборкаПоШапкеДокумента.Дата;
	
	// Измерения
	Движение.Сотрудник					= ВыборкаСтрокЗапроса.Сотрудник;
	Движение.Организация				= ВыборкаСтрокЗапроса.ГоловнаяОрганизация;
	
	// Ресурсы
	Движение.ЗанимаемыхСтавок			= 1;
	Движение.ПодразделениеОрганизации	= ВыборкаСтрокЗапроса.ПодразделениеОрганизации;
	Движение.Должность					= ВыборкаСтрокЗапроса.Должность;
	
	// Реквизиты
	Движение.ОбособленноеПодразделение	= ВыборкаСтрокЗапроса.ОбособленноеПодразделение;
	
КонецПроцедуры // СформироватьДвиженияПоРегистрамСведений()
 
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		// выполним выборку по табличной части документа
		ВыборкаСтрокЗапроса = СформироватьЗапросПоРаботники().Выбрать();
		Пока ВыборкаСтрокЗапроса.Следующий() Цикл
			
			ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаСтрокЗапроса , Отказ, Заголовок);
			Если НЕ Отказ Тогда
				
				ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента,ВыборкаСтрокЗапроса )
				
			КонецЕсли;	
			
		КонецЦикла;
		
	КонецЕсли;	

		
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(ИнформацияОСотрудниках);

	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ);
	
КонецПроцедуры // ПередЗаписью()
