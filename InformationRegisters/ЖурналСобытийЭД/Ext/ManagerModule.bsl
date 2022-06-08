﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик обновления БЭД 1.1.3.7
// Изменился тип реквизита СтатусЭД в РС ЖурналСобытийЭД со строки на ПеречислениеСсылка.
Процедура ОбновитьСтатусыЭД() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЖурналСобытийЭД.УдалитьСтатусЭД,
	|	ЖурналСобытийЭД.ПрисоединенныйФайл,
	|	ЖурналСобытийЭД.НомерЗаписи
	|ИЗ
	|	РегистрСведений.ЖурналСобытийЭД КАК ЖурналСобытийЭД
	|ГДЕ
	|	ЖурналСобытийЭД.УдалитьСтатусЭД <> """"";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи                    = РегистрыСведений.ЖурналСобытийЭД.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ПрисоединенныйФайл = Выборка.ПрисоединенныйФайл;
		МенеджерЗаписи.НомерЗаписи        = Выборка.НомерЗаписи;
		МенеджерЗаписи.Прочитать();
		
		Если Выборка.УдалитьСтатусЭД = "Доставлен получателю" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.Доставлен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "<Не получен>" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.НеПолучен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "<Не сформирован>" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.НеСформирован;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Отправлен получателю" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.Отправлен;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Отправлено уведомление об уточнении" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ОтправленоУведомление;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Отправлен оператору ЭДО" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ПереданОператору;
		ИначеЕсли Выборка.УдалитьСтатусЭД = "Получено уведомление об уточнении" Тогда
			УдалитьСтатусЭД = Перечисления.СтатусыЭД.ПолученоУведомление;
		Иначе
			УдалитьСтатусЭД = СтрЗаменить(Выборка.УдалитьСтатусЭД, " ", "");
			УдалитьСтатусЭД = Перечисления.СтатусыЭД[УдалитьСтатусЭД];
		КонецЕсли;
		
		МенеджерЗаписи.СтатусЭД = УдалитьСтатусЭД;
		МенеджерЗаписи.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
