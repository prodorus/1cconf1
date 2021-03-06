////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сертификат = Параметры.Сертификат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если БольшеНеНапоминать Тогда
		УстановитьПометкуНаСервере(Сертификат);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура УстановитьПометкуНаСервере(Сертификат)
	
	СертификатОбъект = Сертификат.ПолучитьОбъект();
	СертификатОбъект.ОповещенОСрокеДействия = Истина;
	СертификатОбъект.Записать();
	
КонецПроцедуры

