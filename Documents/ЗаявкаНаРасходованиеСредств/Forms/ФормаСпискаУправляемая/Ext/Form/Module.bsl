﻿////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ

&НаКлиенте
Функция ПолучитьИмяФормыПоВидуОперации(ВидОперации)
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	ИмяФормыПоВидуОперации = "ФормаОбъекта";
	#Иначе
	Если ВидОперации = ВидОперацииОплатаПоставщику 
		ИЛИ ВидОперации = ВидОперацииВозвратДенежныхСредствПокупателю
		ИЛИ ВидОперации = ВидОперацииПрочиеРасчетыСКонтрагентами Тогда
		
		ИмяФормыПоВидуОперации = "Форма.РасчетыСКонтрагентами";
		
	ИначеЕсли ВидОперации = ВидОперацииВыдачаДенежныхСредствПодотчетнику Тогда
		ИмяФормыПоВидуОперации = "Форма.РасчетыСПодотчетнымиЛицами";
		
	ИначеЕсли ВидОперации = ВидОперацииПрочийРасходДенежныхСредств Тогда
		ИмяФормыПоВидуОперации = "Форма.ПрочийРасходДенежныхСредств";
		
	Иначе
		ИмяФормыПоВидуОперации = "ФормаОбъекта";
	КонецЕсли; 
	#КонецЕсли
	
	Возврат "Документ.ЗаявкаНаРасходованиеСредств." + ИмяФормыПоВидуОперации;
	
КонецФункции // 

&НаКлиенте
Функция ПолучитьТекущуюСтрокуСписка()
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено 
		ИЛИ ТипЗнч(ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТекущаяСтрока;
	
КонецФункции // 

&НаКлиенте
Процедура ОткрытьФормуВыбранногоДокумента()

	ТекущаяСтрока = ПолучитьТекущуюСтрокуСписка();
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	ПолноеИмяФормы = ПолучитьИмяФормыПоВидуОперации(ТекущиеДанные.ВидОперации);
	
	ПараметрыФормы = Новый Структура("Ключ", ТекущаяСтрока);
	ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы);
	
КонецПроцедуры //

&НаКлиенте
Процедура ОткрытьФормуНовогоДокумента(ВидОперации = Неопределено, Копирование = Ложь)

	ПараметрыФормы = Новый Структура;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ДокументОбъект = Неопределено;
		Если Копирование Тогда
			ТекущаяСтрока = ПолучитьТекущуюСтрокуСписка();
			Если ТекущаяСтрока <> Неопределено Тогда
				ДокументОбъект = ТекущаяСтрока.Скопировать();
			КонецЕсли;
		КонецЕсли;
		Если ДокументОбъект = Неопределено Тогда
			ФормаДокумента = Документы.ЗаявкаНаРасходованиеСредств.ПолучитьФормуНовогоДокумента();
		Иначе
			ФормаДокумента = ДокументОбъект.ПолучитьФорму();
		КонецЕсли;
		
		ОткрытьФорму(ФормаДокумента);
		
	#Иначе
		
		Если ВидОперации = Неопределено Тогда
			ВидОперации = ВидОперацииОплатаПоставщику;
		КонецЕсли; 
		
		Если Копирование Тогда
			ТекущаяСтрока = ПолучитьТекущуюСтрокуСписка();
			Если ТекущаяСтрока <> Неопределено Тогда
				ТекущиеДанные = Элементы.Список.ТекущиеДанные;
				ВидОперации = ТекущиеДанные.ВидОперации;
				ПараметрыФормы.Вставить("КопируемыйОбъект", Элементы.Список.ТекущаяСтрока);
			КонецЕсли;
		Иначе
			ПараметрыФормы.Вставить("ВидОперации", ВидОперации);
		КонецЕсли;
		
		ПолноеИмяФормы = ПолучитьИмяФормыПоВидуОперации(ВидОперации);
		
		ОткрытьФорму(ПолноеИмяФормы, ПараметрыФормы, Элементы.Список);
		
	#КонецЕсли
	
КонецПроцедуры //


////////////////////////////////////////////////////////////////////////////////
// СПИСОК

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ОткрытьФормуНовогоДокумента(, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьФормуВыбранногоДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуВыбранногоДокумента();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ

 &НаКлиенте
Процедура ВозвратДенежныхСредствПокупателю(Команда)
	
	ОткрытьФормуНовогоДокумента(ВидОперацииВозвратДенежныхСредствПокупателю);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеРасчетыСКонтрагентами(Команда)
	
	ОткрытьФормуНовогоДокумента(ВидОперацииПрочиеРасчетыСКонтрагентами);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыдачаДенежныхСредствПодотчетнику(Команда)
	
	ОткрытьФормуНовогоДокумента(ВидОперацииВыдачаДенежныхСредствПодотчетнику);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочийРасходДенежныхСредств(Команда)
	
	ОткрытьФормуНовогоДокумента(ВидОперацииПрочийРасходДенежныхСредств);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ФОРМА

&НаСервере
Процедура УстановитьЗначенияКонстантФормы()
	
	ВидОперацииОплатаПоставщику                  = Перечисления.ВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику;
	ВидОперацииВозвратДенежныхСредствПокупателю  = Перечисления.ВидыОперацийЗаявкиНаРасходование.ВозвратДенежныхСредствПокупателю;
	ВидОперацииПрочиеРасчетыСКонтрагентами       = Перечисления.ВидыОперацийЗаявкиНаРасходование.ПрочиеРасчетыСКонтрагентами;
	ВидОперацииВыдачаДенежныхСредствПодотчетнику = Перечисления.ВидыОперацийЗаявкиНаРасходование.ВыдачаДенежныхСредствПодотчетнику;
	ВидОперацииПрочийРасходДенежныхСредств       = Перечисления.ВидыОперацийЗаявкиНаРасходование.ПрочийРасходДенежныхСредств;
	
КонецПроцедуры //

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьЗначенияКонстантФормы();
	
	Список.Параметры.УстановитьЗначениеПараметра("СостояниеУтвержден", Перечисления.СостоянияОбъектов.Утвержден);
	Список.Параметры.УстановитьЗначениеПараметра("СостояниеОтклонен", Перечисления.СостоянияОбъектов.Отклонен);
	Список.Параметры.УстановитьЗначениеПараметра("ПустоеСостояние", Перечисления.СостоянияОбъектов.ПустаяСсылка());
	ГруппаСоздатьВидимость = Истина;
	СписокСоздатьВидимость = Истина;
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
		ГруппаСоздатьВидимость = Ложь;
		Список.Параметры.УстановитьЗначениеПараметра("ОбычноеПриложение", Истина);
	Иначе	
		СписокСоздатьВидимость = Ложь;
		Список.Параметры.УстановитьЗначениеПараметра("ОбычноеПриложение", Ложь);
	КонецЕсли; 
	
	Если НЕ ГруппаСоздатьВидимость И Элементы.Найти("ГруппаСоздать") <> Неопределено Тогда
		Элементы.ГруппаСоздать.Видимость = Ложь;
	КонецЕсли; 
	
	Если НЕ СписокСоздатьВидимость И Элементы.Найти("СписокСоздать") <> Неопределено Тогда
		Элементы.СписокСоздать.Видимость = Ложь;
	КонецЕсли; 
	
	МассивВидыОперацийРасчетыСКонтрагентами = Новый Массив();
	МассивВидыОперацийРасчетыСКонтрагентами.Добавить(Перечисления.ВидыОперацийЗаявкиНаРасходование.ВозвратДенежныхСредствПокупателю);
	МассивВидыОперацийРасчетыСКонтрагентами.Добавить(Перечисления.ВидыОперацийЗаявкиНаРасходование.ОплатаПоставщику);
	МассивВидыОперацийРасчетыСКонтрагентами.Добавить(Перечисления.ВидыОперацийЗаявкиНаРасходование.ПрочиеРасчетыСКонтрагентами);
	МассивВидыОперацийРасчетыСКонтрагентами.Добавить(Перечисления.ВидыОперацийЗаявкиНаРасходование.РасчетыПоКредитамИЗаймамСКонтрагентами);
	МассивВидыОперацийРасчетыСКонтрагентами.Добавить(Перечисления.ВидыОперацийЗаявкиНаРасходование.ПрочийРасходДенежныхСредств);
	Список.Параметры.УстановитьЗначениеПараметра("ВидыОперацийРасчетыСКонтрагентами", МассивВидыОперацийРасчетыСКонтрагентами);

	
КонецПроцедуры





