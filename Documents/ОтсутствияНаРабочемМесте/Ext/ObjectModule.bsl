////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мСтараяДатаНачалаСобытия;

Перем мСтараяДатаОкончанияСобытия;

Перем мДлинаСуток;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура предназначена для заполнения реквизитов нового документа
//
Процедура ОбработкаЗаполненияНовогоДокумента() Экспорт
	
	// Заполнить реквизиты значениями по умолчанию.
	ЗаполнениеДокументовПереопределяемый.ЗаполнитьШапкуДокумента(ЭтотОбъект, глЗначениеПеременной("глТекущийПользователь"));
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда		
		РабДата = ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
		ДатаНачала		= Дата(Год(РабДата), Месяц(РабДата), День(РабДата), Час(ТекущаяДата()) + ?(Минута(ТекущаяДата()) < 30, 0, 1), ?(Минута(ТекущаяДата()) < 30, 30, 0), 0);
		ДатаОкончания	= ДатаНачала;
	КонецЕсли;
	
КонецПроцедуры

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
Функция СформироватьЗапросПоШапке(Режим)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	СписокРаботающих = ПолныеПраваДополнительный.ПолучитьТаблицуРаботающихФизическихЛиц(МоментВремени(), Физлицо);
	
	Запрос.УстановитьПараметр("СписокФизлиц",	СписокРаботающих);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизическиеЛица.Ссылка КАК Физлицо
	|ПОМЕСТИТЬ ВТФизическиеЛица
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Ссылка В(&СписокФизлиц)";
	Запрос.Выполнить();
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",		Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Дата,
	|	Док.Ссылка,
	|	Док.Физлицо КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА Док.Целодневное
	|			ТОГДА НАЧАЛОПЕРИОДА(Док.ДатаНачала, ДЕНЬ)
	|		ИНАЧЕ Док.ДатаНачала
	|	КОНЕЦ КАК ДатаНачала,
	|	ВЫБОР
	|		КОГДА Док.Целодневное
	|			ТОГДА НАЧАЛОПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|		ИНАЧЕ Док.ДатаОкончания
	|	КОНЕЦ КАК ДатаОкончания,
	|	Док.ПричинаОтсутствия,
	|	Док.Целодневное,
	|	ВЫБОР
	|		КОГДА Работники.ФизЛицо ЕСТЬ NULL 
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СотрудникНеРаботает,
	|	Док.НецелодневныйОтпуск КАК НецелодневныйОтпуск,
	|	Док.ПроверяемоеЗначение КАК ПроверяемоеЗначение,
	|	Док.Регистратор КАК Регистратор,
	|	ЕСТЬNULL(СостояниеРаботников.Регистратор, СборДанныхДляПланированияЗанятостиФизлиц.Регистратор) КАК КонфликтныйДокумент,
	|	ЕСТЬNULL(СостояниеРаботников.Состояние, СборДанныхДляПланированияЗанятостиФизлиц.Состояние) КАК КонфликтноеСостояние
	|ИЗ
	|	(ВЫБРАТЬ
	|		Док.Дата КАК Дата,
	|		Док.Ссылка КАК Ссылка,
	|		Док.Физлицо КАК Физлицо,
	|		Док.ДатаНачала КАК ДатаНачала,
	|		ВЫБОР
	|			КОГДА Док.ДатаОкончания = НАЧАЛОПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|				ТОГДА КОНЕЦПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|			ИНАЧЕ Док.ДатаОкончания
	|		КОНЕЦ КАК ДатаОкончания,
	|		Док.ПричинаОтсутствия КАК ПричинаОтсутствия,
	|		ВЫБОР
	|			КОГДА НАЧАЛОПЕРИОДА(Док.ДатаНачала, ДЕНЬ) <> НАЧАЛОПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|					ИЛИ Док.ДатаНачала = Док.ДатаОкончания
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК Целодневное,
	|		ВЫБОР
	|			КОГДА Док.ПричинаОтсутствия = ЗНАЧЕНИЕ(Справочник.ПричиныОтсутствияНаРаботе.ЕжегодныйОтпуск)
	|					И (НАЧАЛОПЕРИОДА(Док.ДатаНачала, ДЕНЬ) = НАЧАЛОПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|						И Док.ДатаНачала <> Док.ДатаОкончания)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК НецелодневныйОтпуск,
	|		ВЫБОР
	|			КОГДА Док.ПериодСостояния ЕСТЬ НЕ NULL 
	|						И ВЫБОР
	|							КОГДА СостояниеРаботников.ПериодЗавершения <= Док.ДатаНачала
	|									И СостояниеРаботников.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|								ТОГДА СостояниеРаботников.СостояниеЗавершения
	|							ИНАЧЕ СостояниеРаботников.Состояние
	|						КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.СостоянияРаботника.Работает)
	|					ИЛИ Док.ПериодСостояния >= Док.ДатаНачала
	|				ТОГДА СостояниеРаботников.Регистратор
	|			КОГДА Док.ПериодЗанятости ЕСТЬ НЕ NULL 
	|						И ВЫБОР
	|							КОГДА СборДанныхДляПланированияЗанятостиФизлиц.ПериодЗавершения <= Док.ДатаНачала
	|									И СборДанныхДляПланированияЗанятостиФизлиц.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|								ТОГДА СборДанныхДляПланированияЗанятостиФизлиц.СостояниеЗавершения
	|							ИНАЧЕ СборДанныхДляПланированияЗанятостиФизлиц.Состояние
	|						КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.Свободен)
	|					ИЛИ Док.ПериодЗанятости >= Док.ДатаНачала
	|				ТОГДА СборДанныхДляПланированияЗанятостиФизлиц.Регистратор
	|			КОГДА Док.ПериодЗанятостиПлановый ЕСТЬ НЕ NULL 
	|						И ВЫБОР
	|							КОГДА СобытийныйПланЗанятостиФизлиц.ПериодЗавершения <= Док.ДатаНачала
	|									И СобытийныйПланЗанятостиФизлиц.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|								ТОГДА СобытийныйПланЗанятостиФизлиц.СостояниеЗавершения
	|							ИНАЧЕ СобытийныйПланЗанятостиФизлиц.Состояние
	|						КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.Свободен)
	|					ИЛИ Док.ПериодЗанятостиПлановый >= Док.ДатаНачала
	|				ТОГДА СобытийныйПланЗанятостиФизлиц.Регистратор
	|		КОНЕЦ КАК Регистратор,
	|		ВЫБОР
	|			КОГДА Док.ПериодСостояния ЕСТЬ НЕ NULL 
	|						И ВЫБОР
	|							КОГДА СостояниеРаботников.ПериодЗавершения <= Док.ДатаНачала
	|									И СостояниеРаботников.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|								ТОГДА СостояниеРаботников.СостояниеЗавершения
	|							ИНАЧЕ СостояниеРаботников.Состояние
	|						КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.СостоянияРаботника.Работает)
	|					ИЛИ Док.ПериодСостояния >= Док.ДатаНачала
	|				ТОГДА ""Нельзя""
	|			КОГДА Док.ПериодЗанятости ЕСТЬ НЕ NULL 
	|						И ВЫБОР
	|							КОГДА СборДанныхДляПланированияЗанятостиФизлиц.ПериодЗавершения <= Док.ДатаНачала
	|									И СборДанныхДляПланированияЗанятостиФизлиц.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|								ТОГДА СборДанныхДляПланированияЗанятостиФизлиц.СостояниеЗавершения
	|							ИНАЧЕ СборДанныхДляПланированияЗанятостиФизлиц.Состояние
	|						КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.Свободен)
	|					ИЛИ Док.ПериодЗанятости >= Док.ДатаНачала
	|				ТОГДА ""Нельзя""
	|			КОГДА Док.ПериодЗанятостиПлановый ЕСТЬ НЕ NULL 
	|						И ВЫБОР
	|							КОГДА СобытийныйПланЗанятостиФизлиц.ПериодЗавершения <= Док.ДатаНачала
	|									И СобытийныйПланЗанятостиФизлиц.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1)
	|								ТОГДА СобытийныйПланЗанятостиФизлиц.СостояниеЗавершения
	|							ИНАЧЕ СобытийныйПланЗанятостиФизлиц.Состояние
	|						КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.Свободен)
	|					ИЛИ Док.ПериодЗанятостиПлановый >= Док.ДатаНачала
	|				ТОГДА ""Нельзя""
	|			ИНАЧЕ ""Можно""
	|		КОНЕЦ КАК ПроверяемоеЗначение
	|	ИЗ
	|		(ВЫБРАТЬ
	|			МАКСИМУМ(СостояниеРаботников.Период) КАК ПериодСостояния,
	|			МАКСИМУМ(СборДанныхДляПланированияЗанятостиФизлиц.Период) КАК ПериодЗанятости,
	|			МАКСИМУМ(СобытийныйПланЗанятостиФизлиц.Период) КАК ПериодЗанятостиПлановый,
	|			Док.Дата КАК Дата,
	|			Док.Ссылка КАК Ссылка,
	|			Док.Физлицо КАК Физлицо,
	|			Док.ДатаНачала КАК ДатаНачала,
	|			Док.ДатаОкончания КАК ДатаОкончания,
	|			Док.ПричинаОтсутствия КАК ПричинаОтсутствия
	|		ИЗ
	|			Документ.ОтсутствияНаРабочемМесте КАК Док
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СборДанныхДляПланированияЗанятостиФизлиц КАК СборДанныхДляПланированияЗанятостиФизлиц
	|				ПО Док.Физлицо = СборДанныхДляПланированияЗанятостиФизлиц.ФизЛицо
	|					И (ВЫБОР
	|						КОГДА Док.ДатаНачала = Док.ДатаОкончания
	|							ТОГДА КОНЕЦПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|						ИНАЧЕ Док.ДатаОкончания
	|					КОНЕЦ > СборДанныхДляПланированияЗанятостиФизлиц.Период)
	|					И Док.Ссылка <> СборДанныхДляПланированияЗанятостиФизлиц.Регистратор
	|					И (СборДанныхДляПланированияЗанятостиФизлиц.Состояние <> ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.ОтпускЕжегодный))
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботников КАК СостояниеРаботников
	|				ПО Док.Физлицо = СостояниеРаботников.ФизЛицо
	|					И Док.ДатаОкончания > СостояниеРаботников.Период
	|					И Док.Ссылка <> СостояниеРаботников.Регистратор
	|				ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СобытийныйПланЗанятостиФизлиц КАК СобытийныйПланЗанятостиФизлиц
	|				ПО Док.Физлицо = СобытийныйПланЗанятостиФизлиц.ФизЛицо
	|					И (ВЫБОР
	|						КОГДА Док.ДатаНачала = Док.ДатаОкончания
	|							ТОГДА КОНЕЦПЕРИОДА(Док.ДатаОкончания, ДЕНЬ)
	|						ИНАЧЕ Док.ДатаОкончания
	|					КОНЕЦ > СобытийныйПланЗанятостиФизлиц.Период)
	|					И Док.Ссылка <> СобытийныйПланЗанятостиФизлиц.Регистратор
	|					И ((НЕ(Док.ПричинаОтсутствия = ЗНАЧЕНИЕ(Справочник.ПричиныОтсутствияНаРаботе.ЕжегодныйОтпуск)
	|							И СобытийныйПланЗанятостиФизлиц.Состояние = ЗНАЧЕНИЕ(Перечисление.ТипыПериодическихЗадачРаботника.ОтпускЕжегодный))))
	|		ГДЕ
	|			Док.Ссылка = &ДокументСсылка
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Док.Дата,
	|			Док.Ссылка,
	|			Док.Физлицо,
	|			Док.ДатаНачала,
	|			Док.ПричинаОтсутствия,
	|			Док.ДатаОкончания) КАК Док
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СборДанныхДляПланированияЗанятостиФизлиц КАК СборДанныхДляПланированияЗанятостиФизлиц
	|			ПО Док.Физлицо = СборДанныхДляПланированияЗанятостиФизлиц.ФизЛицо
	|				И Док.ПериодЗанятости = СборДанныхДляПланированияЗанятостиФизлиц.Период
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботников КАК СостояниеРаботников
	|			ПО Док.Физлицо = СостояниеРаботников.ФизЛицо
	|				И Док.ПериодСостояния = СостояниеРаботников.Период
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СобытийныйПланЗанятостиФизлиц КАК СобытийныйПланЗанятостиФизлиц
	|			ПО Док.Физлицо = СобытийныйПланЗанятостиФизлиц.ФизЛицо
	|				И Док.ПериодЗанятостиПлановый = СобытийныйПланЗанятостиФизлиц.Период) КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛица КАК Работники
	|		ПО Док.Физлицо = Работники.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостояниеРаботников КАК СостояниеРаботников
	|		ПО (НАЧАЛОПЕРИОДА(Док.ДатаНачала, ДЕНЬ) = СостояниеРаботников.Период)
	|			И Док.Физлицо = СостояниеРаботников.ФизЛицо
	|			И Док.Ссылка <> СостояниеРаботников.Регистратор
	|			И (Док.Целодневное)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СборДанныхДляПланированияЗанятостиФизлиц КАК СборДанныхДляПланированияЗанятостиФизлиц
	|		ПО Док.ДатаНачала = СборДанныхДляПланированияЗанятостиФизлиц.Период
	|			И Док.Физлицо = СборДанныхДляПланированияЗанятостиФизлиц.ФизЛицо
	|			И Док.Ссылка <> СборДанныхДляПланированияЗанятостиФизлиц.Регистратор
	|			И ((НЕ Док.Целодневное))";
	
	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПоШапке()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)
	
	// Сотрудник
	НетСотрудника = НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Сотрудник);
	Если НетСотрудника Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаНачала
	НетДатыНачала = НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаНачала);
	Если НетДатыНачала Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана дата начала отсутствия на рабочем месте!", Отказ, Заголовок);
	КонецЕсли;
	
	// ДатаОкончания
	НетДатыНачала = НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаОкончания);
	Если НетДатыНачала Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана дата окончания отсутствия на рабочем месте!", Отказ, Заголовок);
	КонецЕсли;
	
	// Не целодневный отпуск
	Если ВыборкаПоШапкеДокумента.НецелодневныйОтпуск Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Отпуск может быть только целодневным!", Отказ, Заголовок);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыборкаПоШапкеДокумента.ДатаНачала > ВыборкаПоШапкеДокумента.ДатаОкончания Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Дата начала отсутствия не может превышать дату окончания!", Отказ, Заголовок);
	КонецЕсли;
	
	Если ВыборкаПоШапкеДокумента.ПроверяемоеЗначение = "Нельзя" Тогда
		Расшифровки = Новый Массив;
		Расшифровки.Добавить(Новый Структура("Представление, Расшифровка", ВыборкаПоШапкеДокумента.Регистратор, ВыборкаПоШапкеДокумента.Регистратор));
		СтрокаСообщениеОбОшибке = "На указанный период уже была запланирована другая занятость документом ";
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаСообщениеОбОшибке, Отказ, Заголовок, , Расшифровки);
		
	ИначеЕсли ВыборкаПоШапкеДокумента.КонфликтноеСостояние <> NULL Тогда
		Расшифровки = Новый Массив;
		Расшифровки.Добавить(Новый Структура("Представление, Расшифровка", ВыборкаПоШапкеДокумента.КонфликтныйДокумент, ВыборкаПоШапкеДокумента.КонфликтныйДокумент));
		СтрокаСообщениеОбОшибке = "Сотрудник уже переведен в состояние """ + ВыборкаПоШапкеДокумента.КонфликтноеСостояние + """ документом ";
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаСообщениеОбОшибке, Отказ, Заголовок, , Расшифровки);
	КонецЕсли;
	
	Если ВыборкаПоШапкеДокумента.СотрудникНеРаботает Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Сотрудник " + ВыборкаПоШапкеДокумента.Сотрудник + " не работает на предприятии!", , Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  ВыборкаПоРаботникам             - выборка из результата запроса по строкам документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПараметров = "")
	
	Если ВыборкаПоШапкеДокумента.Целодневное Тогда
		Движение = Движения.СостояниеРаботников.Добавить();
		// Свойства
		Движение.Период					= ВыборкаПоШапкеДокумента.ДатаНачала;
		// Измерения
		Движение.Физлицо				= ВыборкаПоШапкеДокумента.Сотрудник;
		// Ресурсы
		Если ВыборкаПоШапкеДокумента.ПричинаОтсутствия = Справочники.ПричиныОтсутствияНаРаботе.ЕжегодныйОтпуск Тогда
			Движение.Состояние			= Перечисления.СостоянияРаботника.ОтпускЕжегодный;
		Иначе
			Движение.Состояние			= Перечисления.СостоянияРаботника.Отсутствие;
		КонецЕсли;
		Движение.ПериодЗавершения		= ВыборкаПоШапкеДокумента.ДатаОкончания + мДлинаСуток;
		Движение.СостояниеЗавершения	= Перечисления.СостоянияРаботника.Работает;
		// Реквизиты
		Если ВыборкаПоШапкеДокумента.ПричинаОтсутствия <> Справочники.ПричиныОтсутствияНаРаботе.ЕжегодныйОтпуск Тогда
			Движение.ПричинаОтсутствия	= ВыборкаПоШапкеДокумента.ПричинаОтсутствия;
		КонецЕсли;
		
	Иначе
		Движение = Движения.СборДанныхДляПланированияЗанятостиФизлиц.Добавить();
		// Свойства
		Движение.Период					= ВыборкаПоШапкеДокумента.ДатаНачала;
		// Измерения
		Движение.Физлицо				= ВыборкаПоШапкеДокумента.Сотрудник;
		Движение.Документ				= ВыборкаПоШапкеДокумента.Ссылка;
		// Ресурсы
		Движение.Состояние				= Перечисления.ТипыПериодическихЗадачРаботника.Отсутствие;
		Движение.ПериодЗавершения		= ВыборкаПоШапкеДокумента.ДатаОкончания;
		Движение.СостояниеЗавершения	= Перечисления.ТипыПериодическихЗадачРаботника.Свободен;
		// Реквизиты
		Движение.ПричинаОтсутствия		= ВыборкаПоШапкеДокумента.ПричинаОтсутствия;
		
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоСписокРаботников

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  ВыборкаПоРаботникам             - выборка из результата запроса по строкам документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакоплений(ВыборкаПоШапкеДокумента, ВыборкаПоОстаткам, СтруктураПараметров = "")
	
	Движение = Движения.ФактическиеОтпуска.Добавить();
	// Свойства
	Движение.Период			= ВыборкаПоШапкеДокумента.ДатаНачала;
	// Измерения
	Движение.Физлицо		= ВыборкаПоШапкеДокумента.Сотрудник;
	// Ресурсы
	Движение.Количество		= ВыборкаПоОстаткам.ОтпускВСчетЕжегодного + ВыборкаПоОстаткам.ОтпускАвансом;
	// Реквизиты
	Движение.ДатаОкончания	= ВыборкаПоШапкеДокумента.ДатаОкончания;
	
	Если ВыборкаПоОстаткам.ОтпускВСчетДополнительного > 0 Тогда
		Движение = Движения.ОстаткиДнейДополнительныхОтпусков.ДобавитьРасход();
		// Свойства
		Движение.Период			= ВыборкаПоШапкеДокумента.ДатаОкончания;
		// Измерения
		Движение.Физлицо		= ВыборкаПоШапкеДокумента.Сотрудник;
		// Ресурсы
		Движение.Количество		= ВыборкаПоОстаткам.ОтпускВСчетДополнительного;
	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоСписокРаботников

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// отражение в календаре пользователя занятость помещений
	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда
		
		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
		
		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда
			
			// Заполним записи в наборах записей регистров
			ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента);
			
			Если ВыборкаПоШапкеДокумента.ПричинаОтсутствия = Справочники.ПричиныОтсутствияНаРаботе.ЕжегодныйОтпуск Тогда
				ТаблицаПериодов = РезультатЗапросаПоШапке.Выгрузить();
				ТаблицаПериодов.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
				
				ВыборкаПоОтпускам	= ПроцедурыУправленияПерсоналомДополнительный.ПодготовитьДанныеПоУправленческимОтпускам(ТаблицаПериодов, Истина, Ссылка);
				
				Если ВыборкаПоОтпускам.Следующий() Тогда
					ДобавитьСтрокуВДвиженияПоРегистрамНакоплений(ВыборкаПоШапкеДокумента, ВыборкаПоОтпускам);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;
