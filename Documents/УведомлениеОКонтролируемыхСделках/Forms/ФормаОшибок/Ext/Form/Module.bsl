﻿
&НаСервере
Функция ОбновитьТаблицуОшибок(ПеречитатьДанные = Ложь)
	
	Если ПеречитатьДанные Тогда
		Прочитать();
	КонецЕсли;
	
	ДанныеХранилища = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(ДанныеХранилища) <> Тип("ХранилищеЗначения") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОписаниеОшибок = ДанныеХранилища.Получить();
	
	Если ОписаниеОшибок = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	СписокОшибок = ОписаниеОшибок;
	
	СписокОшибок.ОтображатьСетку       = Ложь;
	СписокОшибок.ОтображатьГруппировки = Истина;
	СписокОшибок.АвтоМасштаб           = Истина;
	СписокОшибок.ПоказатьУровеньГруппировокСтрок(СписокОшибок.КоличествоУровнейГруппировокСтрок());
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ШаблонСообщения = НСтр("ru = 'Список ошибок: %1'");
	ТекстСообщения  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Объект.Ссылка);
	ЭтаФорма.Заголовок = ТекстСообщения;
	
	Параметры.Свойство("АдресХранилища", АдресХранилища);
	
	ОбновитьТаблицуОшибок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	// Перечитаем данные
	ОбновитьТаблицуОшибок(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОшибокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Навигационная ссылка
	Если Найти(Строка(Расшифровка),"e1cib") > 0 Тогда
		СтандартнаяОбработка = Ложь;
		ПерейтиПоНавигационнойСсылке(Расшифровка);
		Возврат;
	КонецЕсли;
	
	// Комплексная расшифровка
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		ОбработатьРасшифровку(Элемент, Расшифровка);
		Возврат;
	КонецЕсли;
	
	// Несколько вариантов расшифровки
	Если ТипЗнч(Расшифровка) = Тип("Массив") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбратьВариантРасшифровки(Элемент, Расшифровка);
		Возврат;
	КонецЕсли;
	
	ОтборОрганизация = Новый Структура;
	ОтборОрганизация.Вставить("Организация", Объект.Организация);
	ПараметрыРасшифровки = Новый Структура;
	ПараметрыРасшифровки.Вставить("Отбор", ОтборОрганизация);
	
  // Объект по ссылке открывается по стандартной обработке
	
КонецПроцедуры

// ОБРАБОТКА РАСШИФРОВКИ

&НаКлиенте
Процедура ВыбратьВариантРасшифровки(Элемент, Расшифровка)
	
	СписокПунктовМеню = Новый СписокЗначений;
	Для Каждого ПунктМеню Из Расшифровка Цикл
		
		// Допустимые способы расшифровки см. в ВыводСообщенийОбОшибках.НовыйОписаниеРасшифровки()
		
		Если ТипЗнч(ПунктМеню) <> Тип("Структура") Тогда
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Открыть ""%1""'"),
				ПунктМеню);
		ИначеЕсли ПунктМеню.СпособРасшифровки = "Ссылка" Тогда
			Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Открыть ""%1""'"),
				ПунктМеню.Ссылка);
		ИначеЕсли ПунктМеню.СпособРасшифровки = "ФормаСписка" Тогда
			Представление = ПунктМеню.Заголовок;
		Иначе
			Продолжить;
		КонецЕсли;
		
		СписокПунктовМеню.Добавить(ПунктМеню, Представление);
		
	КонецЦикла;
	
	Если СписокПунктовМеню.Количество() = 0 Тогда
		ВыбранноеДействие = Неопределено;
	ИначеЕсли СписокПунктовМеню.Количество() = 1 Тогда
		ВыбранноеДействие = СписокПунктовМеню[0];
		ОбработатьРасшифровку(Элемент, ВыбранноеДействие.Значение);
	Иначе
		Результат = ВыбратьИзМеню(СписокПунктовМеню, Элемент);
		
		Если Результат = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ОбработатьРасшифровку(Элемент, Результат.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзМенюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьРасшифровку(Элемент, Действие)
	
	// Допустимые способы расшифровки см. в ВыводСообщенийОбОшибках.НовыйОписаниеРасшифровки()
	
	Если ТипЗнч(Действие) <> Тип("Структура") Тогда
		
		ОткрытьЗначение(Действие);
		
	ИначеЕсли Действие.СпособРасшифровки = "Ссылка" Тогда
		
		ОткрытьЗначение(Действие.Ссылка);
		
	ИначеЕсли Действие.СпособРасшифровки = "ФормаСписка" Тогда
		
		ИмяОткрываемойФормы = Действие.Объект + ".ФормаСписка";
		
		Действие.Отбор.Вставить("Организация", Объект.Организация);
		
		ПараметрыОткрываемойФормы = Новый Структура;
		ПараметрыОткрываемойФормы.Вставить("Отбор",  Действие.Отбор);
		ПараметрыОткрываемойФормы.Вставить("Период", Новый СтандартныйПериод(НачалоМесяца(Объект.Дата), КонецМесяца(Объект.Дата))); // Обработку этого параметра следует прописывать в формах
		
		ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыОткрываемойФормы);
		
	ИначеЕсли Действие.СпособРасшифровки = "ФормаДокументаСтрокаТабличнойЧасти" Тогда
		
		ИмяОткрываемойФормы = Действие.Объект + ".ФормаОбъекта";
		
		ПараметрыОткрываемойФормы = Новый Структура;
		ПараметрыОткрываемойФормы.Вставить("Ключ", Действие.Документ);
		
		Форма = ПолучитьФорму(ИмяОткрываемойФормы, ПараметрыОткрываемойФормы);
		Форма.Открыть();
		
		Если Действие.Свойство("ИмяТабличнойЧасти") И Действие.Свойство("НомерСтроки") Тогда
			
			Форма.ТекущийЭлемент = Форма.Элементы[Действие.ИмяТабличнойЧасти];
			Форма.ТекущийЭлемент.ТекущаяСтрока = Действие.НомерСтроки - 1;
			
		КонецЕсли;
		
		
	ИначеЕсли Действие.СпособРасшифровки = "ФормаЗаписиУчастникиКонтролируемыхСделок" Тогда
		
		ИмяОткрываемойФормы = "РегистрСведений.УчастникиКонтролируемыхСделок.ФормаЗаписи";
		ПараметрыОткрываемойФормы = ПолучитьПараметрыОткрытияФормыЗаписиУчастникиКонтролируемыхСделок(Действие.Контрагент);
		
		ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыОткрываемойФормы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОткрытияФормыЗаписиУчастникиКонтролируемыхСделок(Контрагент)
	
	Возврат РегистрыСведений.УчастникиКонтролируемыхСделок.ПолучитьПараметрыОткрытияФормыЗаписиКонтрагента(Контрагент);
	
КонецФункции
