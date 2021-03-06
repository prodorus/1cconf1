////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен данными"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий изменения данных

////////////////////////////////////////////////////////////////////////////////
// Обмен УПП - Розница

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменРозницаУправлениеПредприятиемЗарегистрироватьИзменение(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменРозницаУправлениеПредприятием", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменРозницаУправлениеПредприятиемЗарегистрироватьИзменениеДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменРозницаУправлениеПредприятием", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
//
Процедура ОбменРозницаУправлениеПредприятиемЗарегистрироватьУдаление(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменРозницаУправлениеПредприятием", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменРозницаУправлениеПредприятиемЗарегистрироватьИзменениеНабораЗаписей(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменРозницаУправлениеПредприятием", Источник, Отказ, Замещение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен УПП - Документооборот 1.4

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменДОУПППередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеПроизводственнымПредприятиемДокументооборот", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
//
Процедура ОбменДОУПППередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеПроизводственнымПредприятиемДокументооборот", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменДОУПППередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	// Зарегистрируем владельца КИ, если это необходимо.
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.КонтактнаяИнформация") Тогда
		Если Источник.Отбор.Найти("Объект") <> Неопределено Тогда
			Объект = Источник.Отбор.Объект.Значение;
			ТипОбъекта = ТипЗнч(Объект);
			Если ЗначениеЗаполнено(Объект) И (
				ТипОбъекта = Тип("СправочникСсылка.Организации")
				или ТипОбъекта = Тип("СправочникСсылка.Контрагенты")
				или ТипОбъекта = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов")
				или ТипОбъекта = Тип("СправочникСсылка.Пользователи")
				или ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица")) Тогда
				Узлы = ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена("ОбменУправлениеПроизводственнымПредприятиемДокументооборот");
				ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Объект);
			КонецЕсли;
		КонецЕсли;
	// Зарегистрируем структурное подразделение при изменении ответственного лица, если необходимо.
	ИначеЕсли ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ОтветственныеЛица") Тогда
		Если Источник.Отбор.Найти("СтруктурнаяЕдиница") <> Неопределено Тогда
			СтруктурнаяЕдиница = Источник.Отбор.СтруктурнаяЕдиница.Значение;
			Если ЗначениеЗаполнено(СтруктурнаяЕдиница) 
				И ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Подразделения") Тогда
				Узлы = ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена("ОбменУправлениеПроизводственнымПредприятиемДокументооборот");
				ПланыОбмена.ЗарегистрироватьИзменения(Узлы, СтруктурнаяЕдиница);
			КонецЕсли;
		КонецЕсли;
	// Стандартная механика для прочих регистров.
	Иначе
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеПроизводственнымПредприятиемДокументооборот", 
			Источник, Отказ, Замещение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен УПП - Документооборот 2.0

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменДО20УПППередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеПроизводственнымПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
//
Процедура ОбменДО20УПППередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеПроизводственнымПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменДО20УПППередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	// Зарегистрируем владельца КИ, если это необходимо.
	Если ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.КонтактнаяИнформация") Тогда
		Если Источник.Отбор.Найти("Объект") <> Неопределено Тогда
			Объект = Источник.Отбор.Объект.Значение;
			ТипОбъекта = ТипЗнч(Объект);
			Если ЗначениеЗаполнено(Объект) И (
				ТипОбъекта = Тип("СправочникСсылка.Организации")
				или ТипОбъекта = Тип("СправочникСсылка.Контрагенты")
				или ТипОбъекта = Тип("СправочникСсылка.КонтактныеЛицаКонтрагентов")
				или ТипОбъекта = Тип("СправочникСсылка.Пользователи")
				или ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица")) Тогда
				Узлы = ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена("ОбменУправлениеПроизводственнымПредприятиемДокументооборот20");
				ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Объект);
			КонецЕсли;
		КонецЕсли;
	// Зарегистрируем структурное подразделение при изменении ответственного лица, если необходимо.
	ИначеЕсли ТипЗнч(Источник) = Тип("РегистрСведенийНаборЗаписей.ОтветственныеЛица") Тогда
		Если Источник.Отбор.Найти("СтруктурнаяЕдиница") <> Неопределено Тогда
			СтруктурнаяЕдиница = Источник.Отбор.СтруктурнаяЕдиница.Значение;
			Если ЗначениеЗаполнено(СтруктурнаяЕдиница) 
				И ТипЗнч(СтруктурнаяЕдиница) = Тип("СправочникСсылка.Подразделения") Тогда
				Узлы = ОбменДаннымиПовтИсп.ПолучитьМассивУзловПланаОбмена("ОбменУправлениеПроизводственнымПредприятиемДокументооборот20");
				ПланыОбмена.ЗарегистрироватьИзменения(Узлы, СтруктурнаяЕдиница);
			КонецЕсли;
		КонецЕсли;
	// Стандартная механика для прочих регистров.
	Иначе
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеПроизводственнымПредприятиемДокументооборот20", 
			Источник, Отказ, Замещение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен УПП - Универсальный формат обмена


// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматЗарегистрироватьИзменение(Источник, Отказ) Экспорт
	
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматЗарегистрироватьИзменениеДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах
//
// Параметры:
//  ИмяПланаОбмена – Строка – имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей
//
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматЗарегистрироватьУдаление(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПриОбработке".
// Вызывается из правил регистрации плана обмена СинхронизацияДанныхЧерезУниверсальныйФормат.
//
// Параметры:
//  РазделыУчетаСтрокой – Строка – разделы учета перечисленные через запятую, при установке которых должно срабатывать ПРО.
//  ТекстЗапроса        - Строка - текст запроса, который будет использован для определения узлов-получателей.
//  ПараметрыЗапроса    - Структура - параметры в запросе для определения узлов-получателей.
//  ЭтоДокумент         - Булево - признак того, что ПРО вызывается для документа.
//
Процедура ПриОбработкеПРО(РазделыУчетаСтрокой, ТекстЗапроса, ПараметрыЗапроса, ДобавитьОтборПоСкладу = Ложь) Экспорт
	ПодзапросРазделыУчета = "";
	МассивРазделовУчета = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(РазделыУчетаСтрокой,,Истина);
	Если МассивРазделовУчета.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	НомерРаздела = 1;
	Для Каждого РазделУчета Из МассивРазделовУчета Цикл
		ПараметрыЗапроса.Вставить("РазделУчета"+НомерРаздела, СокрЛП(РазделУчета));
		ПодзапросРазделыУчета = ПодзапросРазделыУчета + ?(ПодзапросРазделыУчета = "", "", Символы.ПС + "ИЛИ ")
						+ "ПланОбменаРазделыУчета.РазделУчета = &СвойствоОбъекта_РазделУчета" + НомерРаздела;
		НомерРаздела = НомерРаздела + 1;
	КонецЦикла;
	Если МассивРазделовУчета.Количество() > 1 Тогда
		ПодзапросРазделыУчета = "(" + ПодзапросРазделыУчета + ")";
	КонецЕсли;
	ТекстЛевогоСоединения = "КАК ПланОбменаОсновнаяТаблица
		|ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.РазделыУчета КАК ПланОбменаРазделыУчета
		|ПО ПланОбменаОсновнаяТаблица.Ссылка = ПланОбменаРазделыУчета.Ссылка
		|	И " + ПодзапросРазделыУчета + "
		|	И ПланОбменаРазделыУчета.Выгружать";
	
	ТекстУсловияРазделовУчета = "	И ЕстьNULL(ПланОбменаРазделыУчета.Выгружать, ЛОЖЬ)
		|[ОбязательныеУсловия]";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КАК ПланОбменаОсновнаяТаблица", ТекстЛевогоСоединения);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОбязательныеУсловия]", ТекстУсловияРазделовУчета);
	Если НЕ ДобавитьОтборПоСкладу Тогда
		Возврат;
	КонецЕсли;
	// Ручное добавление отбора по складу. 
	// Для документов, где склад составного типа и в некоторых случаях извлекается через точку.
	// Параметр заполняется в обработчике ПРО.
	ТекстЛевогоСоединения = "КАК ПланОбменаОсновнаяТаблица
		|ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Склады КАК ПланОбменаСклады
		|ПО ПланОбменаОсновнаяТаблица.Ссылка = ПланОбменаСклады.Ссылка И ПланОбменаСклады.Склад = &СвойствоОбъекта_Склад";
	ТекстУсловияСклады = " И (ПланОбменаОсновнаяТаблица.ИспользоватьОтборПоСкладам = ЛОЖЬ ИЛИ ПланОбменаСклады.Склад IS NOT NULL)
			|[ОбязательныеУсловия]";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КАК ПланОбменаОсновнаяТаблица", ТекстЛевогоСоединения);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОбязательныеУсловия]", ТекстУсловияРазделовУчета);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обмен УПП - Клиент ЭДО

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах
//
// Параметры:
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменУправлениеПредприятиемКлиентЭДОЗарегистрироватьИзменение(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеПредприятиемКлиентЭДО", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах
//
// Параметры:
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменУправлениеПредприятиемКлиентЭДОЗарегистрироватьИзменениеДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеПредприятиемКлиентЭДО", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах
//
// Параметры:
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//
Процедура ОбменУправлениеПредприятиемКлиентЭДОЗарегистрироватьУдаление(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеПредприятиемКлиентЭДО", Источник, Отказ);
	
КонецПроцедуры

