
//Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,            "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список,            "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокКОформлению, "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора);
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокВРегистр3  , "ОрганизацияЕГАИС", ОрганизацииЕГАИС, СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтаФорма);
	
	Если ИнтеграцияЕГАИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюЕГАИСПриСозданииНаСервере(ДальнейшееДействиеЕГАИС, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействиеЕГАИС.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
	
	Если Параметры.ОткрытьРаспоряжения Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКОформлению;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.УстановитьВидимостьКомандыОформленияДокумента(ЭтаФорма, Метаданные.Документы.АктПостановкиНаБалансЕГАИС, "СписокКОформлениюОформитьАктПостановкиНаБаланс");
	ИнтеграцияЕГАИС.УстановитьВидимостьКомандыОформленияДокумента(ЭтаФорма, Метаданные.Документы.АктПостановкиНаБалансЕГАИС, "СписокВРегистр3ОформитьВРегистр3");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_АктПостановкиНаБалансЕГАИС" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.АктПостановкиНаБалансЕГАИС") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	НастройкиОрганизацияЕГАИС = ИнтеграцияЕГАИСКлиентСервер.СтруктураПоискаПоляДляЗагрузкиИзНастроек(
		"ОрганизацииЕГАИС",
		Настройки);
	
	Если ИнтеграцияЕГАИСКлиентСервер.НеобходимОтборПоДальнейшемуДействиюЕГАИСПередЗагрузкойИзНастроек(ДальнейшееДействиеЕГАИС, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "СтатусЕГАИС",
	                                                                       СтатусЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "Ответственный",
	                                                                       Ответственный,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "ОрганизацияЕГАИС",
	                                                                       ОрганизацииЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       НастройкиОрганизацияЕГАИС);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокКОформлению,
	                                                                       "ОрганизацияЕГАИС",
	                                                                       ОрганизацииЕГАИС,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       НастройкиОрганизацияЕГАИС);
	
	Настройки.Удалить("ДальнейшееДействиеЕГАИС");
	Настройки.Удалить("СтатусЕГАИС");
	Настройки.Удалить("Ответственный");
	Настройки.Удалить("ОрганизацииЕГАИС");
	
	ИнтеграцияЕГАИС.ОтборПоОрганизацииПриСозданииНаСервере(ЭтаФорма);
	
КонецПроцедуры

//КонецОбласти

//Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусЕГАИСПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "СтатусЕГАИС",
	                                                                        СтатусЕГАИС,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(СтатусЕГАИС));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеЕГАИСПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаКОформлениюОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

//Область ОтборПоОрганизацииЕГАИС

&НаКлиенте
Процедура ОформленоОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ОрганизацииЕГАИС, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(ЭтаФорма, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, Неопределено, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры


&НаКлиенте
Процедура ОформленоОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ОрганизацияЕГАИС, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(ЭтаФорма, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, Неопределено, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры


&НаКлиенте
Процедура КОформлениюОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ОрганизацииЕГАИС, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(ЭтаФорма, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, Неопределено, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ВыбранноеЗначение, Истина, "КОформлению");
	
КонецПроцедуры


&НаКлиенте
Процедура КОформлениюОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ОрганизацияЕГАИС, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(ЭтаФорма, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, Неопределено, Истина, "КОформлению");
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ВыбранноеЗначение, Истина, "КОформлению");
	
КонецПроцедуры


&НаКлиенте
Процедура ВРегистр3ОрганизацииЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ОрганизацииЕГАИС, Истина, "ВРегистр3");
	
КонецПроцедуры

&НаКлиенте
Процедура ВРегистр3ОрганизацииЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(ЭтаФорма, "ВРегистр3");
	
КонецПроцедуры

&НаКлиенте
Процедура ВРегистр3ОрганизацииЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, Неопределено, Истина, "ВРегистр3");
	
КонецПроцедуры

&НаКлиенте
Процедура ВРегистр3ОрганизацииЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ВыбранноеЗначение, Истина, "ВРегистр3");
	
КонецПроцедуры


&НаКлиенте
Процедура ВРегистр3ОрганизацияЕГАИСПриИзменении(Элемент)
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ОрганизацияЕГАИС, Истина, "ВРегистр3");
	
КонецПроцедуры

&НаКлиенте
Процедура ВРегистр3ОрганизацияЕГАИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОткрытьФормуВыбораОрганизацийЕГАИС(ЭтаФорма, "ВРегистр3");
	
КонецПроцедуры

&НаКлиенте
Процедура ВРегистр3ОрганизацияЕГАИСОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, Неопределено, Истина, "ВРегистр3");
	
КонецПроцедуры

&НаКлиенте
Процедура ВРегистр3ОрганизацияЕГАИСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИнтеграцияЕГАИСКлиент.ОбработатьВыборОрганизацийЕГАИС(ЭтаФорма, ВыбранноеЗначение, Истина, "ВРегистр3");
	
КонецПроцедуры

//КонецОбласти

//КонецОбласти

//Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

//КонецОбласти

//Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКОформлению

&НаКлиенте
Процедура СписокКОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокКОформлению.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначениеЕГАИС( ,ТекущиеДанные.Документ);
	
КонецПроцедуры

//КонецОбласти

//Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияЕГАИСКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ПередайтеДанные"),
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьОбмен(
		ИнтеграцияЕГАИСКлиент.ОрганизацииЕГАИСДляОбмена(
			ЭтаФорма),,
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьАктПостановкиНаБаланс(Команда)
	
	Если Не ИнтеграцияЕГАИСКлиент.ВыборСтрокиДинамическогоСпискаКорректен(ЭтаФорма, "СписокКОформлению") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИСКлиент.ВыполнитьКомандуГиперссылки(
		Элементы.СписокКОформлению.ТекущиеДанные.Документ,
		"СоздатьАктПостановкиНаБалансЕГАИС",
		ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВРегистр3(Команда)
	
	Если Не ИнтеграцияЕГАИСКлиент.ВыборСтрокиДинамическогоСпискаКорректен(ЭтаФорма, "СписокВРегистр3") Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьКомандуОформитьВРегистр3();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтаФорма, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтаФорма, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтаФорма, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

//КонецОбласти

//Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусЕГАИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.СтатусЕГАИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.АктПостановкиНаБалансЕГАИС.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиОшибкаПередачи);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусЕГАИС.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействиеЕГАИС.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.АктПостановкиНаБалансЕГАИС.ВсеТребующиеОжидания());
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЕГАИССтатусОбработкиПередается);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтаФорма, "Список.Дата",            Элементы.Дата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтаФорма, "СписокКОформлению.Дата", Элементы.СписокКОформлениюДата.Имя);
	
КонецПроцедуры

//Область ОформлениеАкцизныхМарокВРегистр3ЕГАИС

&НаКлиенте
Процедура ВыполнитьКомандуОформитьВРегистр3()
	
	АкцизныеМаркиПоОрганизациям = Новый Соответствие;
	
	ВыделенныеСтроки = Элементы.СписокВРегистр3.ВыделенныеСтроки;
	ТипГруппировкаДС = Тип("СтрокаГруппировкиДинамическогоСписка");
	
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Если ТипЗнч(ВыделеннаяСтрока) = ТипГруппировкаДС Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Элементы.СписокВРегистр3.ДанныеСтроки(ВыделеннаяСтрока);
		
		АкцизныеМарки = АкцизныеМаркиПоОрганизациям.Получить(ДанныеСтроки.ОрганизацияЕГАИС);
		Если АкцизныеМарки = Неопределено Тогда
			АкцизныеМарки = Новый Массив;
		КонецЕсли;
		
		ДанныеАкцизнойМарки = Новый Структура;
		ДанныеАкцизнойМарки.Вставить("АкцизнаяМарка",        ДанныеСтроки.АкцизнаяМарка);
		ДанныеАкцизнойМарки.Вставить("Справка2",             ДанныеСтроки.Справка2);
		ДанныеАкцизнойМарки.Вставить("АлкогольнаяПродукция", ДанныеСтроки.АлкогольнаяПродукция);
		АкцизныеМарки.Добавить(ДанныеАкцизнойМарки);
		
		АкцизныеМаркиПоОрганизациям.Вставить(ДанныеСтроки.ОрганизацияЕГАИС, АкцизныеМарки);
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из АкцизныеМаркиПоОрганизациям Цикл
		ПараметрыОснования = Новый Структура;
		ПараметрыОснования.Вставить("АкцизныеМаркиВРегистр3", Истина);
		ПараметрыОснования.Вставить("ОрганизацияЕГАИС",       КлючИЗначение.Ключ);
		ПараметрыОснования.Вставить("АкцизныеМарки",          КлючИЗначение.Значение);
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Основание", ПараметрыОснования);
		
		ОткрытьФорму(
			"Документ.АктПостановкиНаБалансЕГАИС.ФормаОбъекта",
			ПараметрыОткрытия, ЭтаФорма, Новый УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

//КонецОбласти

//Область Отборы

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокКОформлению,
	                                                                        "Ответственный",
	                                                                        Ответственный,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

//КонецОбласти

//Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.АктПостановкиНаБалансЕГАИС.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.АктПостановкиНаБалансЕГАИС.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияЕГАИС.УстановитьОтборПоДальнейшемуДействию(Список,
	                                                     ДальнейшееДействиеЕГАИС,
	                                                     ВсеТребующиеДействия(),
	                                                     ВсеТребующиеОжидания());
	
КонецПроцедуры

//КонецОбласти

//КонецОбласти
