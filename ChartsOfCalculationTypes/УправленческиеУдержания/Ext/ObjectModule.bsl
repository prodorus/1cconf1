////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УправленческиеУдержанияПереопределяемый.ПередЗаписьюДополнительно(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью()
