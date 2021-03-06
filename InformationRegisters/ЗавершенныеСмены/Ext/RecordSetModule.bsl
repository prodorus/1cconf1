// Обработчик события ПередЗаписью
// Проверяем заполненность обязательных реквизитов: Подразделение, Смена, ГраницаСмены
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		ЗаголовокСообщения = НСтр("ru = 'Завершение смены'");
		
		Если Запись.Подразделение.Пустая() Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru = 'Не заполнено значение реквизита ""Подразделение""'"), Отказ, ЗаголовокСообщения);
		КонецЕсли;
			
		Если Запись.ГраницаСмены = '0001-01-01' Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru = 'Не выбрана смена'"), Отказ, ЗаголовокСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОписаниеКлючаЗаписи = Новый Структура("Подразделение");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.ГраницаСмены = '0001-01-01' Тогда
			КлючЗаписи = РегистрыСведений.ЗавершенныеСмены.СоздатьКлючЗаписи(ОписаниеКлючаЗаписи);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбрана смена'"), КлючЗаписи, "ВыбраннаяСмена",, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
