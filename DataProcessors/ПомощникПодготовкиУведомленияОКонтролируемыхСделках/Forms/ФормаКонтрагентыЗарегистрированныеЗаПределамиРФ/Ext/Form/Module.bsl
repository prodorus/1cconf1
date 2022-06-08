﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьПараметрыОткрытияФормыКонтрагента(Контрагент)
	
	Возврат(РегистрыСведений.УчастникиКонтролируемыхСделок.ПараметрыОткрытияФормыЗаписиКонтрагента(Контрагент));
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
//

&НаКлиенте
Процедура УчастникиКонтролируемыхСделокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыОткрытияФормы = ПолучитьПараметрыОткрытияФормыКонтрагента(ВыбранноеЗначение);
		Если ПараметрыОткрытияФормы<>Неопределено Тогда
			ОткрытьФорму("РегистрСведений.УчастникиКонтролируемыхСделок.ФормаЗаписи", ПараметрыОткрытияФормы, , ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиКонтролируемыхСделокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура("РежимВыбора", Истина);
	ОткрытьФорму("РегистрСведений.УчастникиКонтролируемыхСделок.Форма.ФормаПодбораКонтрагентов", ПараметрыФормы, Элементы.УчастникиКонтролируемыхСделок, Элементы.УчастникиКонтролируемыхСделок);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодобратьИзОтчетногоГода(Команда)
	
	ПараметрыФормы = Новый Структура("Организация, ОтчетныйГод", Объект.Организация, Объект.ОтчетныйГод);
	ОткрытьФорму("Обработка.ПомощникПодготовкиУведомленияОКонтролируемыхСделках.Форма.ФормаПодбораКонтрагентовОтчетногоГода", ПараметрыФормы, ЭтаФорма, );
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиКонтролируемыхСделокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СписокИностранныхКонтрагентовИзменен" Тогда
		Элементы.УчастникиКонтролируемыхСделок.Обновить();
	КонецЕсли;
	
КонецПроцедуры



