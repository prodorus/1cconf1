////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Механизм исправлений
Перем мВосстанавливатьДвижения;
Перем мСоответствиеДвижений;
Перем мИсправляемыйДокумент;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет документ по перерассчитываемому документу
// ИсходныйДокумент - тип ДокументОбъект.КомандировкиОрганизаций
//
Процедура ЗаполнитьПоПерерассчитываемомуДокументу(ИсходныйДокумент, Сотрудники = Неопределено) Экспорт
	
	ПроведениеРасчетов.ЗаполнитьИсправлениеПоКадровомуДокументу(ЭтотОбъект, ИсходныйДокумент.Ссылка, Сотрудники);
	
КонецПроцедуры // ЗаполнитьПоПерерассчитываемомуДокументу()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры:
//	Режим		- режим проведения.
//
// Возвращаемое значение:
//	Результат запроса.
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВозвратНаРаботуОрганизаций.Дата,
	|	ВозвратНаРаботуОрганизаций.Организация,
	|	ВЫБОР
	|		КОГДА ВозвратНаРаботуОрганизаций.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ВозвратНаРаботуОрганизаций.Организация
	|		ИНАЧЕ ВозвратНаРаботуОрганизаций.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	ВозвратНаРаботуОрганизаций.Ссылка
	|ИЗ
	|	Документ.ВозвратНаРаботуОрганизаций КАК ВозвратНаРаботуОрганизаций
	|ГДЕ
	|	ВозвратНаРаботуОрганизаций.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры:
//	Режим		- режим проведения.
//
// Возвращаемое значение:
//	Результат запроса.
//
Функция СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента, Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТЧРаботникиОрганизации.Ссылка,
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник КАК Сотрудник,
	|	ТЧРаботникиОрганизации.Сотрудник.Наименование,
	|	ТЧРаботникиОрганизации.Сотрудник.Организация,
	|	ТЧРаботникиОрганизации.Сотрудник.Физлицо КАК Физлицо,
	|	ТЧРаботникиОрганизации.ДатаВозврата КАК ДатаВозврата,
	|	ТЧРаботникиОрганизации.ЗаниматьСтавку
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	Документ.ВозвратНаРаботуОрганизаций.РаботникиОрганизации КАК ТЧРаботникиОрганизации
	|ГДЕ
	|	ТЧРаботникиОрганизации.Ссылка = &ДокументСсылка
	|	И (НЕ ТЧРаботникиОрганизации.Сторно)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	ДатаВозврата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|	ТЧРаботникиОрганизации.Сотрудник,
	|	ТЧРаботникиОрганизации.СотрудникНаименование,
	|	ТЧРаботникиОрганизации.Физлицо КАК Физлицо,
	|	ТЧРаботникиОрганизации.ДатаВозврата,
	|	ТЧРаботникиОрганизации.ЗаниматьСтавку,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаВозврата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизации
	|	КОНЕЦ КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаВозврата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ДолжностьЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.Должность
	|	КОНЕЦ КАК Должность,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаВозврата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок
	|	КОНЕЦ КАК ЗанимаемыхСтавок,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТЧРаботникиОрганизации.ДатаВозврата
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.Период
	|	КОНЕЦ КАК ДатаПоследнегоДвиженияПоРаботнику,
	|	ПересекающиесяСтроки.КонфликтнаяСтрокаНомер,
	|	ИмеющиесяСостояния.Состояние КАК КонфликтноеСостояние,
	|	ИмеющиесяСостояния.Регистратор КАК КонфликтныйДокумент,
	|	ВЫБОР
	|		КОГДА ТЧРаботникиОрганизации.СотрудникОрганизация = &ГоловнаяОрганизация
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОшибкаНеСоответствиеСотрудникаИОрганизации
	|ИЗ
	|	ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МАКСИМУМ(Работники.Период) КАК ДатаДвижения
	|		ИЗ
	|			ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|				ПО (Работники.Период <= ТЧРаботникиОрганизации.ДатаВозврата)
	|					И ТЧРаботникиОрганизации.Сотрудник = Работники.Сотрудник
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ДатыПоследнегоДвиженияРаботника
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ДатыПоследнегоДвиженияРаботника.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|		ПО (ДатыПоследнегоДвиженияРаботника.ДатаДвижения = ДанныеПоРаботникуДоНазначения.Период)
	|			И ТЧРаботникиОрганизации.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ТЧРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
	|			МИНИМУМ(ТЧРаботникиОрганизации2.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	|		ИЗ
	|			ВТДанныеДокумента КАК ТЧРаботникиОрганизации
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДокумента КАК ТЧРаботникиОрганизации2
	|				ПО ТЧРаботникиОрганизации.НомерСтроки > ТЧРаботникиОрганизации2.НомерСтроки
	|					И ТЧРаботникиОрганизации.ДатаВозврата = ТЧРаботникиОрганизации2.ДатаВозврата
	|					И ТЧРаботникиОрганизации.Сотрудник = ТЧРаботникиОрганизации2.Сотрудник
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ТЧРаботникиОрганизации.НомерСтроки) КАК ПересекающиесяСтроки
	|		ПО ТЧРаботникиОрганизации.НомерСтроки = ПересекающиесяСтроки.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботниковОрганизаций КАК ИмеющиесяСостояния
	|		ПО ТЧРаботникиОрганизации.ДатаВозврата = ИмеющиесяСостояния.Период
	|			И ТЧРаботникиОрганизации.Ссылка <> ИмеющиесяСостояния.Регистратор
	|			И ТЧРаботникиОрганизации.Сотрудник = ИмеющиесяСостояния.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
		
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//	Отказ					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Не указана организация, сотрудники которой возвращаются на работу!"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//	ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//								  из результата запроса по работникам. 
//	Отказ						- флаг отказа в проведении.
//	Заголовок					- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке =
		"В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + """ табл. части ""Сотрудники"": ";
	
	// Сотрудник
	НетСотрудника = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник);
	Если НетСотрудника Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;

	// ДатаВозврата
	НетДатыВозврата = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаВозврата);
	Если НетДатыВозврата Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата возврата на работу!", Отказ, Заголовок);
	КонецЕсли;

	// Организация сотрудника должна совпадать с организацией в документе
	Если ВыборкаПоСтрокамДокумента.ОшибкаНеСоответствиеСотрудникаИОрганизации Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("указанный сотрудник оформлен на другую организацию!"), Отказ, Заголовок);
	КонецЕсли;

	Если НетСотрудника ИЛИ НетДатыВозврата Тогда
		Возврат; // Дальше не проверяем
	КонецЕсли;

	// Проверка: ранее работник должен быть принят на работу
	Если ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = NULL Тогда
		СтрокаПродолжениеСообщенияОбОшибке = "на " + Формат(ВыборкаПоСтрокамДокумента.ДатаВозврата, "ДЛФ=DD") + " сотрудник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " еще не принят на работу!";
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
			
	ИначеЕсли ВыборкаПоСтрокамДокумента.ЗанимаемыхСтавок = 0 Тогда
		СтрокаПродолжениеСообщенияОбОшибке = "на " + Формат(ВыборкаПоСтрокамДокумента.ДатаВозврата, "ДЛФ=DD") + " сотрудник " + ВыборкаПоСтрокамДокумента.СотрудникНаименование + " уже уволен (с " + Формат(ВыборкаПоСтрокамДокумента.ДатаПоследнегоДвиженияПоРаботнику, "ДЛФ=DD") + ")!";
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
			
	КонецЕсли;

	// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		СтрокаСообщениеОбОшибке = "сотрудник не может быть указан в документе дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
	
	// Проверка: в регистре уже есть такое движение
	Если ВыборкаПоСтрокамДокумента.КонфликтноеСостояние <> NULL Тогда
		Расшифровки = Новый Массив;
		Расшифровки.Добавить(Новый Структура("Представление, Расшифровка", ВыборкаПоСтрокамДокумента.КонфликтныйДокумент, ВыборкаПоСтрокамДокумента.КонфликтныйДокумент));
		СтрокаСообщениеОбОшибке = "сотрудник уже переведен в состояние """ + ВыборкаПоСтрокамДокумента.КонфликтноеСостояние + """ документом ";
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок, , Расшифровки);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры:
//	ВыборкаПоШапкеДокумента					- выборка из результата запроса по шапке документа,
//
// Возвращаемое значение:
//	Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации)
	
	Движение = Движения.СостояниеРаботниковОрганизаций.Добавить();
	
	// Свойства
	Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаВозврата;
	
	// Измерения
	Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
	Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
	
	// Ресурсы
	Движение.Состояние			= Перечисления.СостоянияРаботникаОрганизации.Работает;
	
	// Реквизиты
	Движение.ПервичныйДокумент	= ВыборкаПоШапкеДокумента.Ссылка;
	
	Если ВыборкаПоРаботникиОрганизации.ЗаниматьСтавку Тогда
		// займем ставки
		Движение = Движения.СотрудникиОсвободившиеСтавкиВОрганизациях.Добавить();
	
		// Свойства
		Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаВозврата;
	
		// Измерения
		Движение.Сотрудник			= ВыборкаПоРаботникиОрганизации.Сотрудник;
		Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
		
		// Ресурсы
		Движение.ОсвобождатьСтавку	= ложь; 
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Если документ перенесен - движения не делаем
	Если ДанныеПрошлойВерсии Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);
	
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		Движения.СостояниеРаботниковОрганизаций.мВыполнятьСписаниеФактическогоОтпуска	= Истина;
		
		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
		
		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда
			
			// получим реквизиты табличной части
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(ВыборкаПоШапкеДокумента, Режим);
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл 
				
				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);
				
				Если НЕ Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;

	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаЗаполнения(Основание)
	
	ТипОснования = ТипЗнч(Основание);
	Если ТипОснования = Тип("ДокументСсылка.КомандировкиОрганизаций") или ТипОснования = Тип("ДокументСсылка.ОтпускаОрганизаций") Тогда
		
		// Заполним реквизиты из стандартного набора.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		
		Если Основание.Проведен Тогда
			
			УчетнаяПолитикаПоПерсоналуОрганизации = глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации");
			
			// Заполнение табличной части. 
			Для Каждого ТекСтрока Из Основание.РаботникиОрганизации Цикл
				Если ЗначениеЗаполнено(ТекСтрока.ДатаОкончания) и ТекСтрока.НапомнитьПоЗавершении Тогда
					НоваяСтрока = РаботникиОрганизации.Добавить();
					НоваяСтрока.Сотрудник		= ТекСтрока.Сотрудник;
					НоваяСтрока.Физлицо			= ТекСтрока.Физлицо;
					НоваяСтрока.ДатаВозврата	= ТекСтрока.ДатаОкончания + 86400;
					НоваяСтрока.ЗаниматьСтавку	= ТекСтрока.ОсвобождатьСтавку;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли ТипОснования = Тип("СправочникСсылка.СотрудникиОрганизаций") Тогда	
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
		|	СотрудникиОрганизаций.Физлицо,
		|	СотрудникиОрганизаций.Организация,
		|	СотрудникиОрганизаций.ОбособленноеПодразделение
		|ИЗ
		|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
		|ГДЕ
		|	СотрудникиОрганизаций.Ссылка = &Сотрудник";
		Запрос.УстановитьПараметр("Сотрудник",	Основание);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Если Не Выборка.ОбособленноеПодразделение.Пустая() Тогда
				Организация = Выборка.ОбособленноеПодразделение;
			Иначе
				Организация = Выборка.Организация;
			КонецЕсли;
			
			НоваяСтрока = РаботникиОрганизации.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ДатаВозврата	= ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ);
	
	ПроведениеРасчетов.ИсправлениеКадровогоДокументаПередЗаписью(Отказ, РежимЗаписи, РежимПроведения, ЭтотОбъект, мВосстанавливатьДвижения, мИсправляемыйДокумент, мСоответствиеДвижений);
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеРасчетов.ИсправлениеКадровогоДокументаПриЗаписи(Отказ, мВосстанавливатьДвижения, мИсправляемыйДокумент, мСоответствиеДвижений);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВосстанавливатьДвижения = Ложь;
