
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru='Контекстный отчет не предназначен для непосредственного использования.'"), Отказ);
	
КонецПроцедуры
