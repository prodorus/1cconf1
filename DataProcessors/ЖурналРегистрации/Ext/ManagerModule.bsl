﻿
// Возвращает значение перечисления соответствующе строковому имени статус события
//
Функция СтатусТранзакцииЗаписиЖурналаРегистрацииЗначениеПоИмени(Имя) Экспорт
	
	ЗначениеПеречисления = Неопределено;
	Если Имя = "Зафиксирована" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.Зафиксирована;
	ИначеЕсли Имя = "НеЗавершена" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена;
	ИначеЕсли Имя = "НетТранзакции" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.НетТранзакции;
	ИначеЕсли Имя = "Отменена" Тогда
		ЗначениеПеречисления = СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена;
	КонецЕсли;
	Возврат ЗначениеПеречисления;
	
КонецФункции

Функция УровеньЖурналаРегистрацииЗначениеПоИмени(Имя) Экспорт
	
	ЗначениеПеречисления = Неопределено;
	Если Имя = "Информация" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Информация;
	ИначеЕсли Имя = "Ошибка" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Ошибка;
	ИначеЕсли Имя = "Предупреждение" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Предупреждение;
	ИначеЕсли Имя = "Примечание" Тогда
		ЗначениеПеречисления = УровеньЖурналаРегистрации.Примечание;
	КонецЕсли;
	Возврат ЗначениеПеречисления;
	
КонецФункции

// Устанавливает номер рисунка в строке события журнала
//
Процедура УстановитьНомерРисунка(СобытиеЖурнала) Экспорт
	
	// Установка относительного номера картинки
	Если СобытиеЖурнала.Уровень = УровеньЖурналаРегистрации.Информация Тогда
		СобытиеЖурнала.НомерРисунка = 0;
	ИначеЕсли СобытиеЖурнала.Уровень = УровеньЖурналаРегистрации.Предупреждение Тогда
		СобытиеЖурнала.НомерРисунка = 1;
	ИначеЕсли СобытиеЖурнала.Уровень = УровеньЖурналаРегистрации.Ошибка Тогда
		СобытиеЖурнала.НомерРисунка = 2;
	Иначе
		СобытиеЖурнала.НомерРисунка = 3;
	КонецЕсли;
	// Установка абсолютного номера картинки
	Если СобытиеЖурнала.СтатусТранзакции = СтатусТранзакцииЗаписиЖурналаРегистрации.НеЗавершена
	 ИЛИ СобытиеЖурнала.СтатусТранзакции = СтатусТранзакцииЗаписиЖурналаРегистрации.Отменена Тогда
		СобытиеЖурнала.НомерРисунка = СобытиеЖурнала.НомерРисунка + 4;
	КонецЕсли;
	
КонецПроцедуры
