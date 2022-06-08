﻿
//#Область ОбработчикиСобытийОбъектов

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяСправочника - Строка - имя справочника, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыСправочника(ИмяСправочника, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("ТекущаяСтрока") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСпискаДокументов";
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра сведений, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыРегистраСведений(ИмяРегистра, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийФормы

// Возникает на сервере при создании формы.
//
// Параметры:
//  Форма - УправляемаяФорма - создаваемая форма,
//  Отказ - Булево - признак отказа от создания формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") = Ложь Тогда
		Сообщить("Для открытия форм объектов библиотеки ЕГАИС требуется включить настройку
		|	""Учитывать алкогольную продукцию"" в группе Розничные продажи");
		Отказ = Истина;
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

// Вызывается при чтении объекта на сервере.
//
// Параметры:
//  Форма - УправляемаяФорма - форма читаемого объекта,
//  ТекущийОбъект - ДокументОбъект, СправочникОбъект - читаемый объект.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбработчикиСобытийЭлементовФормы

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	
	Если ПараметрыЗаполнения.ОбработатьУпаковки Тогда
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", Новый Структура("Номенклатура", "МаркируемаяАлкогольнаяПродукция"));
	КонецЕсли;
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения", Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	
	Если ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС Тогда
		ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
		
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус Тогда
		Если ПараметрыУказанияСерий <> Неопределено
			И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад)
			И ИнтеграцияЕГАИСКлиентСервер.ЕстьРеквизитОбъекта(Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта], ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			Склад = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта][ПараметрыУказанияСерий.ИмяПоляСклад];
		Иначе
			Склад = Неопределено;
		КонецЕсли;
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад));
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию Тогда
		СтруктураДействий.Вставить("ЗаполнитьАлкогольнуюПродукцию", ПараметрыЗаполнения);
	КонецЕсли;
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиСерверЕГАИСУТ.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПерезаполнитьНоменклатуруЕГАИС Тогда
		ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
		
		СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьАлкогольнуюПродукцию Тогда
		СтруктураДействий.Вставить("ЗаполнитьАлкогольнуюПродукцию", ПараметрыЗаполнения);
	КонецЕсли;
	
	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиСерверЕГАИСУТ.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества упаковок в таблице Товары.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ПриИзмененииКоличестваУпаковок(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	ИначеЕсли ПараметрыЗаполнения.ПересчитатьКоличествоУпаковок Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСерверЕГАИСУТ.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

//#КонецОбласти

//#Область ПрограммныйИнтерфейс

// Заполняет табличную часть Товары подобранными товарами.
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой производится подбор,
//  ВыбранноеЗначение - Произвольный - данные, содержащие подобранную пользователем номенклатуру,
//  ПараметрыЗаполнения - Структура - см. функцию СобытияФормЕГАИСКлиент.СтруктураПараметрыЗаполнения.
//
Процедура ОбработкаРезультатаПодбораНоменклатуры(Форма, ВыбранноеЗначение, ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполненияНоменклатурыЕГАИС = Новый Структура;
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагАлкогольнаяПродукция", Ложь);
	ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ИмяКолонки", "АлкогольнаяПродукция");
	
	Если НЕ ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		ПараметрыЗаполненияНоменклатурыЕГАИС.Вставить("ЗаполнитьФлагМаркируемаяАлкогольнаяПродукция", Ложь);
	КонецЕсли;
	
	СтрокаТовара = ВыбранноеЗначение;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТовара.Номенклатура,"АлкогольнаяПродукция") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Подобрана не алкогольная продукция, новая строка документа не будет добавлена'"),,"Товары");
		Возврат;
	КонецЕсли;
	
	СтрокаТовара.Вставить("Упаковка",           СтрокаТовара.ЕдиницаИзмерения);
	СтрокаТовара.Вставить("КоличествоУпаковок", СтрокаТовара.Количество);
	ТекущаяСтрока = Форма.Объект.Товары.Добавить();
		
	СписокСвойств = "Номенклатура, Характеристика, Упаковка";
	Если ТекущаяСтрока.Свойство("КоличествоУпаковок") Тогда
		СписокСвойств = СписокСвойств + ", КоличествоУпаковок";
	КонецЕсли;
		
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, СписокСвойств);
		
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
		
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
		
	Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
		СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
	КонецЕсли;
		
	Если ПараметрыЗаполнения.МаркируемаяАлкогольнаяПродукцияВТЧ Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяАлкогольнаяПродукция", Новый Структура("Номенклатура", "МаркируемаяАлкогольнаяПродукция"));
	КонецЕсли;
		
	Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
		
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИС);
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",
		Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, "Товары"));
	
	ОбработкаТабличнойЧастиСерверЕГАИСУТ.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы.Товары.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

// Устанавливет у элемента формы Упаковка подсказку ввода для соответствующей номенклатуры
//
// Параметры:
// 	Форма - УправляемаяФорма - Форма объекта.
//
Процедура УстановитьИнформациюОЕдиницеХранения(Форма) Экспорт
	
	
	Возврат;
	
КонецПроцедуры

//#КонецОбласти
