#Если ТолстыйКлиентОбычноеПриложение Тогда

Функция УточнитьВводНаОсновании(КоманднаяПанель) Экспорт 

	ВводНаОсновании = КоманднаяПанель.Кнопки.Найти("ПодменюНаОсновании");
	Если ВводНаОсновании <> Неопределено Тогда
		КоманднаяПанель.Кнопки.Удалить(ВводНаОсновании);
	КонецЕсли;	
	ВводНаОсновании = КоманднаяПанель.Кнопки.ПодменюДействия.Кнопки.Найти("ПодменюНаОсновании");
	Если ВводНаОсновании <> Неопределено Тогда
		КоманднаяПанель.Кнопки.ПодменюДействия.Кнопки.Удалить(ВводНаОсновании);
	КонецЕсли;	

КонецФункции // УточнитьВводНаОсновании()

#КонецЕсли
