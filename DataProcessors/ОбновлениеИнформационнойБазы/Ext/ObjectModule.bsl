Функция ПолучитьРазрешениеНаОткрытиеФормы() Экспорт
	
	Если РольДоступна("ПолныеПрава") Тогда
		Возврат Истина;
	КонецЕсли;
	#Если Клиент Тогда
	Предупреждение("Форму обработки может открывать только пользователь с ролью ""Полные права""");
	#КонецЕсли
	Возврат Ложь;
	
КонецФункции