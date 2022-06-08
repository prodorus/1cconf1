﻿&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтаФорма);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтаФорма, "ТоварыХарактеристика");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтаФорма, "ТоварыУпаковка");
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	Элементы.ТоварыКодАкцизнойМарки.ТолькоПросмотр = Не ОбщегоНазначенияКлиентСервер.РежимОтладки();
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораПодборНоменклатуры(
		ОписаниеОповещенияЕГАИС("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтаФорма),
		ВыбранноеЗначение, ИсточникВыбора);
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(
		ОписаниеОповещенияЕГАИС("ПриВыбореНоменклатуры", ЭтаФорма), ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Не РедактированиеФормыНедоступно Тогда
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияПодборНоменклатуры(
			ОписаниеОповещенияЕГАИС("Подключаемый_ОбработкаРезультатаПодбораНоменклатуры", ЭтаФорма),
			ИмяСобытия, Параметр, Источник);
		
		СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещенияОбработаныНеизвестныеШтрихкоды(
			ОписаниеОповещенияЕГАИС("Подключаемый_ОбработаныНеизвестныеШтрихкоды", ЭтаФорма),
			ЭтаФорма, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Ссылка = Объект.Ссылка Тогда
		
		Если Параметр.Свойство("ОбъектИзменен")
			И Параметр.ОбъектИзменен Тогда
			Прочитать();
		Иначе
			ОбновитьСтатусЕГАИС();
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусЕГАИСВФормахДокументов)) Тогда
		
		Прочитать();
		
	КонецЕсли;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтаФорма, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтаФорма, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтаФорма, Объект.Товары);
	
	ИнтеграцияЕГАИС.ЗаполнитьАлкогольнуюПродукцию(Объект.Товары);
	
	ОбновитьСтатусЕГАИС();
	
	РазблокироватьДанныеФормыДляРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗапросАкцизныхМарокЕГАИС", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если РедактированиеФормыНедоступно Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормЕГАИСКлиент.ВнешнееСобытиеОбработатьВводШтрихкода(ЭтаФорма, Источник, Событие, Данные, КэшированныеЗначения);
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылки(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НавигационнаяСсылкаФорматированнойСтроки = ИнтеграцияЕГАИСУТКлиентСервер.НавигационнаяСсылкаСтроки(Элемент, СтатусЕГАИСПредставление);
	
	ОчиститьСообщения();
	
	Если (Не ЗначениеЗаполнено(Объект.Ссылка)) Или (Не Объект.Проведен) Тогда
		
		ОписаниеОповещенияВопрос = ОписаниеОповещенияЕГАИС("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтаФорма,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ был изменен. Провести?'");
		ПоказатьВопросЕГАИС(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	ИначеЕсли Модифицированность Тогда
		
		ОписаниеОповещенияВопрос = ОписаниеОповещенияЕГАИС("СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение",
		                                                    ЭтаФорма,
		                                                    Новый Структура("НавигационнаяСсылкаФорматированнойСтроки", НавигационнаяСсылкаФорматированнойСтроки));
		ТекстВопроса = НСтр("ru = 'Документ не проведен. Провести?'");
		ПоказатьВопросЕГАИС(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки);
		
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийЭлементовТабличнойЧастиТовары

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыАлкогольнаяПродукция Тогда
		
		ЗаполнитьСписокВыбораАлкогольнойПродукции(ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = Истина;
	ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию      = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтаФорма, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(
		ЭтаФорма,
		ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(ТекущиеДанные.АлкогольнаяПродукция));
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(
		ЭтаФорма,
		ИнтеграцияЕГАИСВызовСервера.РеквизитыАлкогольнойПродукцииДляСозданияНоменклатуры(ТекущиеДанные.АлкогольнаяПродукция));
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииХарактеристики(
		ЭтаФорма, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтаФорма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииУпаковки(
		ЭтаФорма, ТекущаяСтрока, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУпаковкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СобытияФормЕГАИСКлиентПереопределяемый.НачалоВыбораУпаковки(ЭтаФорма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипМаркиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ТипМарки", ТекущиеДанные.ТипМарки);
	КонецЕсли;
	
	ОткрытьФормуЕГАИС("ОбщаяФорма.ФормаВыбораТипаАкцизнойМаркиЕГАИС", ПараметрыФормы, Элемент,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипМаркиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = АкцизныеМаркиВызовСервера.ДанныеВыбораТипаМарки(Текст);
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента.Записать");
	
	ОчиститьСообщения();
	Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодбор(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"Документ.ЗапросАкцизныхМарокЕГАИС.ФормаДокумента.Команда.ОткрытьПодбор");
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОткрытьФормуПодбораНоменклатуры(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		ОписаниеОповещенияЕГАИС("ПоискПоШтрихкодуЗавершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанныеВТСД(Команда)
	
	ОчиститьСообщения();
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыгрузитьДанныеВТСД(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеИзТСД(Команда)
	
	ОчиститьСообщения();
	
	МенеджерОборудованияКлиент.НачатьЗагрузкуДанныеИзТСД(
		ОписаниеОповещенияЕГАИС("ЗагрузитьИзТСДЗавершение", ЭтаФорма),
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента.Провести");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	Записать(ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗапросАкцизныхМарокЕГАИС.Форма.ФормаДокумента.ПровестиИЗакрыть");
	
	ОчиститьСообщения();
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	
	Если Записать(ПараметрыЗаписи) Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтаФорма, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтаФорма, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтаФорма, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыАлкогольнаяПродукция.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.АлкогольнаяПродукция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.СопоставлениеАлкогольнаяПродукция");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",            ЦветаСтиля.ЦветТекстаПроблемаЕГАИС);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",                 Новый ПолеКомпоновкиДанных("Объект.Товары.СопоставлениеАлкогольнаяПродукция"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыАлкогольнаяПродукция.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ИнтеграцияЕГАИСПереопределяемый.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ОбновитьСтатусЕГАИС();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтаФорма, Объект.Товары);
	ИнтеграцияЕГАИС.ЗаполнитьАлкогольнуюПродукцию(Объект.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораАлкогольнойПродукции(ТекущаяСтрока)
	
	СписокВыбораНоменклатура = Элементы.ТоварыАлкогольнаяПродукция.СписокВыбора;
	СписокВыбораНоменклатура.Очистить();
	
	СписокВыбораНоменклатура.ЗагрузитьЗначения(ТекущаяСтрока.НоменклатураДляВыбора.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореНоменклатуры(Номенклатура, ДополнительныеПараметры) Экспорт
	
	Если Номенклатура = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Номенклатура = Номенклатура;
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ = Истина;
	ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию      = Истина;
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(
		ЭтаФорма, ТекущиеДанные, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
КонецПроцедуры

//#Область Штрихкоды

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	АкцизныеМаркиЕГАИСКлиент.ОбработатьВводШтрихкода(
			ЭтаФорма,
			ДанныеШтрихкода,
			КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Функция Подключаемый_ОбработатьВводШтрихкода(ДанныеШтрихкода, КэшированныеЗначения)
	
	РезультатОбработкиШтрихкода = АкцизныеМаркиЕГАИС.ОбработатьВводШтрихкода(ЭтаФорма, ДанныеШтрихкода, КэшированныеЗначения);
	
	ПослеОбработкиШтрихкодов(
		РезультатОбработкиШтрихкода,
		КэшированныеЗначения);
	
	РезультатОбработкиШтрихкода.ИзмененныеСтроки  = Неопределено;
	РезультатОбработкиШтрихкода.ДобавленныеСтроки = Неопределено;
	
	Возврат РезультатОбработкиШтрихкода;
	
КонецФункции

&НаСервере
Функция Подключаемый_ОбработатьВыборНоменклатуры(РезультатВыбора, РезультатОбработкиШтрихкода, КэшированныеЗначения)
	
	РезультатОбработкиШтрихкода = АкцизныеМаркиЕГАИС.ОбработатьВыборНоменклатуры(ЭтаФорма, РезультатВыбора, РезультатОбработкиШтрихкода, КэшированныеЗначения);
	
	ПослеОбработкиШтрихкодов(
		РезультатОбработкиШтрихкода,
		КэшированныеЗначения);
	
	РезультатОбработкиШтрихкода.ИзмененныеСтроки  = Неопределено;
	РезультатОбработкиШтрихкода.ДобавленныеСтроки = Неопределено;
	
	Возврат РезультатОбработкиШтрихкода;
	
КонецФункции

&НаСервере
Функция Подключаемый_ОбработатьВыборСправки2(РезультатВыбора, РезультатОбработкиШтрихкода, КэшированныеЗначения)
	
	РезультатОбработкиШтрихкода = АкцизныеМаркиЕГАИС.ОбработатьВыборСправки2(ЭтаФорма, РезультатВыбора, РезультатОбработкиШтрихкода, КэшированныеЗначения);
	
	ПослеОбработкиШтрихкодов(
		РезультатОбработкиШтрихкода,
		КэшированныеЗначения);
	
	РезультатОбработкиШтрихкода.ИзмененныеСтроки  = Неопределено;
	РезультатОбработкиШтрихкода.ДобавленныеСтроки = Неопределено;
	
	Возврат РезультатОбработкиШтрихкода;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПослеОбработкиШтрихкодов()
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиШтрихкодов(
		ЭтаФорма,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработаныНеизвестныеШтрихкоды(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
	ОбработатьПрочиеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПрочиеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения)
	
	РезультатОбработкиШтрихкода = АкцизныеМаркиЕГАИС.РезультатОбработкиШтрихкода();
	РезультатОбработкиШтрихкода.ТребуетсяОбработкаШтрихкода = Истина;
	РезультатОбработкиШтрихкода.ИсходныеДанные = ДанныеШтрихкодов;
	
	ПослеОбработкиШтрихкодов(РезультатОбработкиШтрихкода, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСтрокиТЧ(ДобавленныеСтроки, ИзмененныеСтроки, КэшированныеЗначения = Неопределено)
	
	Для Каждого СтрокаТЧ Из ДобавленныеСтроки Цикл
		
		ПараметрыЗаполнения = ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
		
		СобытияФормЕГАИСПереопределяемый.ПриИзмененииНоменклатуры(
			ЭтаФорма, СтрокаТЧ, КэшированныеЗначения,
			ПараметрыЗаполнения);
		
	КонецЦикла;
	
	Если ДобавленныеСтроки.Количество() > 0 Тогда
		Элементы.Товары.ТекущаяСтрока = ДобавленныеСтроки[ДобавленныеСтроки.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПослеОбработкиШтрихкодов(РезультатОбработкиШтрихкода, КэшированныеЗначения)
	
	Если РезультатОбработкиШтрихкода.ТребуетсяОбработкаШтрихкода Тогда
		
		ПараметрыЗаполнения = ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
		
		Если ТипЗнч(РезультатОбработкиШтрихкода.ИсходныеДанные) = Тип("Структура") Тогда
			ДанныеШтрихкодов = Новый Массив;
			ДанныеШтрихкодов.Добавить(РезультатОбработкиШтрихкода.ИсходныеДанные);
		Иначе
			ДанныеШтрихкодов = РезультатОбработкиШтрихкода.ИсходныеДанные;
		КонецЕсли;
		
		ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ПодготовитьДанныеДляОбработкиШтрихкодов(
			ЭтаФорма, ДанныеШтрихкодов, ПараметрыЗаполнения);
		
		ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьШтрихкоды(
			ЭтаФорма, ДанныеДляОбработки, КэшированныеЗначения);
		
		ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтаФорма, Объект.Товары);
		
	Иначе
		
		ОбработатьСтрокиТЧ(
			РезультатОбработкиШтрихкода.ДобавленныеСтроки,
			РезультатОбработкиШтрихкода.ИзмененныеСтроки,
			КэшированныеЗначения);
		
	КонецЕсли;
	
	Возврат РезультатОбработкиШтрихкода;
	
КонецФункции


&НаКлиенте
Процедура ЗагрузитьИзТСДЗавершение(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПриПолученииДанныхИзТСД(
		ОписаниеОповещенияЕГАИС("Подключаемый_ПолученыДанныеИзТСД", ЭтаФорма),
		ЭтаФорма, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолученыДанныеИзТСД(ТаблицаТоваров, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ДанныеДляОбработки = ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтаФорма, ТаблицаТоваров, КэшированныеЗначения,
		ПараметрыЗаполнения);
	
	ОбработатьДанныеИзТСД(ДанныеДляОбработки, КэшированныеЗначения);
	
	ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ПослеОбработкиТаблицыТоваровПолученнойИзТСД(
		ЭтаФорма,
		ДанныеДляОбработки,
		КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеИзТСД(ТаблицаТоваров, КэшированныеЗначения)
	
	ШтрихкодированиеНоменклатурыЕГАИСПереопределяемый.ОбработатьДанныеИзТСД(
		ЭтаФорма, ТаблицаТоваров, КэшированныеЗначения);
	
КонецПроцедуры

//#КонецОбласти

//#Область Подбор

&НаСервере
Процедура ОбработкаРезультатаПодбораНоменклатуры(ВыбранноеЗначение, ПараметрыЗаполнения)
	
	СобытияФормЕГАИСПереопределяемый.ОбработкаРезультатаПодбораНоменклатуры(ЭтаФорма, ВыбранноеЗначение, ПараметрыЗаполнения);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтаФорма, Объект.Товары);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаРезультатаПодбораНоменклатуры(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыЗаполнения = СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения();
	ОбработкаРезультатаПодбораНоменклатуры(Результат, ПараметрыЗаполнения);
	
КонецПроцедуры

//#КонецОбласти

//#Область Статус

&НаСервере
Процедура ОбновитьСтатусЕГАИС()
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка);
	
	СтатусЕГАИС        = МенеджерОбъекта.СтатусПоУмолчанию();
	ДальнейшееДействие = МенеджерОбъекта.ДальнейшееДействиеПоУмолчанию();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Статусы.Статус КАК Статус,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие1 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие1
		|	КОНЕЦ КАК ДальнейшееДействие1,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие2 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие2
		|	КОНЕЦ КАК ДальнейшееДействие2,
		|	ВЫБОР
		|		КОГДА Статусы.ДальнейшееДействие3 В (&МассивДальнейшиеДействия)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.НеТребуется)
		|		ИНАЧЕ Статусы.ДальнейшееДействие3
		|	КОНЕЦ КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовЕГАИС КАК Статусы
		|ГДЕ
		|	Статусы.Документ = &Документ");
		
		Запрос.УстановитьПараметр("Документ", Объект.Ссылка);
		Запрос.УстановитьПараметр("МассивДальнейшиеДействия", ИнтеграцияЕГАИС.НеотображаемыеВДокументахДальнейшиеДействия());
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СтатусЕГАИС = Выборка.Статус;
			
			ДальнейшееДействие = Новый Массив;
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие1);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие2);
			ДальнейшееДействие.Добавить(Выборка.ДальнейшееДействие3);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДопустимыеДействия = Новый Массив;
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеОперацию);
	ДопустимыеДействия.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ОтменитеПередачуДанных);
	
	СтатусЕГАИСПредставление = ИнтеграцияЕГАИС.ПредставлениеСтатусаЕГАИС(
		СтатусЕГАИС,
		ДальнейшееДействие,
		ДопустимыеДействия);
		
	ИнтеграцияЕГАИСУТ.СформироватьФорматированнуюСтроку(ЭтаФорма,
		СтатусЕГАИСПредставление,
		"ГруппаСтатусДальнейшееДействие",
		"СтатусЕГАИСПредставлениеОбработкаНавигационнойСсылки");
	
	РедактированиеФормыНеДоступно = СтатусЕГАИС <> Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.Черновик
	                              И СтатусЕГАИС <> Перечисления.СтатусыОбработкиЗапросаАкцизныхМарокЕГАИС.ОшибкаПередачи;
	
	Элементы.ГруппаНередактируемыеПослеОтправкиРеквизитыОсновное.ТолькоПросмотр = РедактированиеФормыНеДоступно;
	Элементы.СтраницаТовары.ТолькоПросмотр                                      = РедактированиеФормыНеДоступно;
	Элементы.ГруппаТорговоеОборудование.Доступность                             = Не РедактированиеФормыНеДоступно;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьНажатиеНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ЗапроситьАкцизныеМарки" Тогда
		
		ИнтеграцияЕГАИСКлиент.ПодготовитьКПередаче(
			Объект.Ссылка,
			ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюЕГАИС.ЗапроситеАкцизныеМарки"),
			ЭтаФорма.УникальныйИдентификатор);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьОперацию" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПоследнююОперацию(Объект.Ссылка);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "ОтменитьПередачу" Тогда
		
		ИнтеграцияЕГАИСКлиент.ОтменитьПередачу(Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОбработкиОбработкаНавигационнойСсылкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверитьЗаполнение() Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	КонецЕсли;
	
	Если Не Модифицированность И Объект.Проведен Тогда
		ОбработатьНажатиеНавигационнойСсылки(ДополнительныеПараметры.НавигационнаяСсылкаФорматированнойСтроки);
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти

//#КонецОбласти