﻿Функция КонтекстДокументооборотаСНалоговымиОрганами() Экспорт
	
	Результат = Неопределено;
	
	// если подключена внешняя обработка, то используем ее
	Если Константы.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль.Получить() Тогда
		
		ВнешниеОбъектыХранилище = Константы.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль;
		ДвоичныеДанныеОбработки = ВнешниеОбъектыХранилище.Получить().Получить();
		
		Если ДвоичныеДанныеОбработки <> Неопределено Тогда
			
			ИмяФайлаОбработки = ПолучитьИмяВременногоФайла("epf");
			ДвоичныеДанныеОбработки.Записать(ИмяФайлаОбработки);
			
			Попытка
				Результат = ВнешниеОбработки.Создать(ИмяФайлаОбработки);
			Исключение
				Сообщить("Не удалось загрузить внешний модуль для документооборота с налоговыми органами:
						|" + ИнформацияОбОшибке().Описание + "
						|Будет использован модуль, встроенный в конфигурацию.", СтатусСообщения.Важное);
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Результат = Неопределено Тогда
		Результат = Обработки.ДокументооборотСКонтролирующимиОрганами.Создать();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции