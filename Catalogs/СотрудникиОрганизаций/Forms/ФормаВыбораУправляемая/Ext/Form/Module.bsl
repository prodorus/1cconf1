
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		ОтборОрганизация = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборОрганизация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
		ОтборОрганизация.ПравоеЗначение = Параметры.Организация;
		ОтборОрганизация.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборОрганизация.Использование = Истина;
	КонецЕсли;
КонецПроцедуры
