Функция ИмяВариантаНастроекУведомления(Уведомление) Экспорт
	
	ИмяВариантаНастроек = "ПредметыКонтролируемыхСделок";
	
	Если ЗначениеЗаполнено(Уведомление) Тогда
		
		ВерсияУведомления = Документы.УведомлениеОКонтролируемыхСделках.ВерсияУведомления(Уведомление);
		Если ВерсияУведомления = КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2017() Тогда
			ИмяВариантаНастроек = "ПредметыКонтролируемыхСделок2017";
		КонецЕсли;;
		
	КонецЕсли;
	
	Возврат ИмяВариантаНастроек;
	
КонецФункции