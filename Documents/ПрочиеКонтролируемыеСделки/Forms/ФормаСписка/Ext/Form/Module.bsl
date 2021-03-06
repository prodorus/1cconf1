
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура УведомлениеОКонтролируемыхСделкахПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено( УведомлениеОКонтролируемыхСделках) Тогда
		Список.Отбор.Элементы.Очистить();
		ОтборПоУведомлению = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборПоУведомлению.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УведомлениеОКонтролируемойСделке");
		ОтборПоУведомлению.ПравоеЗначение = УведомлениеОКонтролируемыхСделках;
		Элементы.УведомлениеОКонтролируемойСделке.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УведомлениеОКонтролируемыхСделкахОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Список.Отбор.Элементы.Очистить();
	УведомлениеОКонтролируемыхСделках = УведомлениеОКонтролируемыхСделках.Пустая();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(УведомлениеОКонтролируемыхСделках) И
		Параметры.Свойство("УведомлениеОКонтролируемыхСделках") Тогда
		УведомлениеОКонтролируемыхСделках = Параметры.УведомлениеОКонтролируемыхСделках;
	КонецЕсли;
	
	Элементы.ДекорацияОтборПоУведомлению.Заголовок = 
		КонтролируемыеСделки.ПредставлениеУведомления(УведомлениеОКонтролируемыхСделках, НСтр("ru = 'Прочие сделки'"));
	
	УведомлениеУказано = ЗначениеЗаполнено(УведомлениеОКонтролируемыхСделках);
	
	Элементы.УведомлениеОКонтролируемыхСделках.Видимость = НЕ УведомлениеУказано;
	Элементы.УведомлениеОКонтролируемойСделке.Видимость = НЕ УведомлениеУказано;
	Элементы.ДекорацияОтборПоУведомлению.Видимость = УведомлениеУказано;
	
КонецПроцедуры
