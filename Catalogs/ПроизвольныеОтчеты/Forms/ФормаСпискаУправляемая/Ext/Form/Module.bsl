&НаСервереБезКонтекста
Функция ЭтоГруппаОтчетов(ПроизвольныйОтчетСсылка)
	
	Возврат ПроизвольныйОтчетСсылка.ЭтоГруппа;	
	
КонецФункции // 

&НаКлиенте
Процедура СформироватьПроизвольныйОтчет(ПроизвольныйОтчетСсылка, СохраненнаяНастройка = Неопределено)

	Если ЭтоГруппаОтчетов(ПроизвольныйОтчетСсылка) Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПроизвольныйОтчет", ПроизвольныйОтчетСсылка);
	СтруктураПараметров.Вставить("СохраненнаяНастройка", СохраненнаяНастройка);
	
	ОткрытьФорму("Отчет.ПроизвольныйОтчет.Форма", СтруктураПараметров,, ПроизвольныйОтчетСсылка);
	
КонецПроцедуры //


&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СформироватьПроизвольныйОтчет(ВыбраннаяСтрока);
	
КонецПроцедуры
