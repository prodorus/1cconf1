
// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоГруппа Тогда
		
		Если СпособПогашенияСтоимости.Пустая() Тогда
			Сообщить("Укажите способ погашения стоимости!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если СпособОтраженияРасходов.Пустая() Тогда
			Сообщить("Укажите способ отражения расходов!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если СрокПолезногоИспользования <= 0 Тогда
			Сообщить("Укажите срок полезного использования!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
				
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

