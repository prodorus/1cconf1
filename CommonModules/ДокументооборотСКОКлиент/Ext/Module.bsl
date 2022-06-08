﻿Процедура ПриНачалеРаботыСистемы() Экспорт
	
	// Сначала подключаем встроенную обработку на тот случай, если запуск внешней будет запрещен.
	Если КонтекстЭДО = Неопределено И ПравоДоступа("Использование", Метаданные.Обработки.ДокументооборотСКонтролирующимиОрганами)
		И ПравоДоступа("Изменение", Метаданные.Справочники.УчетныеЗаписиДокументооборота) Тогда
		КонтекстЭДО = Обработки.ДокументооборотСКонтролирующимиОрганами.Создать();
		
		ПодключитьОбработчикОжидания("Подключаемый_ИнициализироватьКонтекстДокументооборотаСНалоговымиОрганами", 1, Истина);

		ПодключитьОбработчикОжидания("Подключаемый_ПодключитьОбработчикАвтообменаСНалоговымиОрганами", 90, Истина);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьОтветыНаЗаявленияНаПодключениеПриЗапуске", 60, Истина);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьОтветыНаЗаявленияНаПодключение", 86400); // 1 сутки
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьОбИстеченииСертификатов", 450, Истина); // 7,5 мин
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьОТребованияхПоНДС", 300, Истина); // 5 мин
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьОКонфликтеКриптопровайдеров", 30, Истина);
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьОНекорректныхСтатусахОтправки2НДФЛ", 180, Истина); // 3 мин
		
		ПодключитьОбработчикОжидания("Подключаемый_ЗаменитьКодыТОГСПриНеобходимости", 15, Истина);
	КонецЕсли;

КонецПроцедуры


Процедура ПроверитьОтветыНаЗаявленияНаПодключение() Экспорт
	
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ПроверитьОтветыНаЗаявленияНаПодключениеЛокальная();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредупредитьОбИстеченииСертификатов() Экспорт
	
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ПредупредитьОбИстеченииСертификатовЛокальная();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредупредитьОТребованияхПоНДС() Экспорт
	
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.НапомнитьОТребованияхПоНДС();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредупредитьОКонфликтеКриптопровайдеров() Экспорт
	
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.СообщитьПользователюОКонфликтеКриптопровайдеров();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработчикАвтообменаСНалоговымиОрганами() Экспорт
	
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ОбработчикАвтообмена();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОбработчикАвтообменаСНалоговымиОрганами() Экспорт
	
	Если РольДоступна("ПравоНаЗащищенныйДокументооборотСКонтролирующимиОрганами") ИЛИ РольДоступна("ПолныеПрава") Тогда
		Если КонтекстЭДО <> Неопределено Тогда
			Попытка
				КонтекстЭДО.ПодключитьОбработчикАвтообменаСНалоговымиОрганами();
			Исключение
				Сообщить("Не удалось инициализировать обработчик автоматического обмена с контролирующими органами:
					|" + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), СтатусСообщения.Важное);
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПредупредитьОНекорректныхСтатусахОтправки2НДФЛ() Экспорт
	
	Если КонтекстЭДО <> Неопределено Тогда
		КонтекстЭДО.ПредупредитьОбОшибкеВСтатусахОтправки2НДФЛ();
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьКонтекстДокументооборотаСНалоговымиОрганами() Экспорт
	
	ЭтоПерваяИтерация = Истина;
	ИнициализироватьКонтекст = Истина;
	Пока ИнициализироватьКонтекст Цикл
		
		ИнициализироватьКонтекст = Ложь;
		
		// если подключена внешняя обработка, то используем ее
		Если ПравоДоступа("Чтение", Метаданные.Константы.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль)
			И ПравоДоступа("Чтение", Метаданные.Константы.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль)
			И ПравоДоступа("Изменение", Метаданные.Справочники.УчетныеЗаписиДокументооборота) Тогда
			
			// если подключена внешняя обработка, то используем ее
			Если Константы.ДокументооборотСКонтролирующимиОрганами_ИспользоватьВнешнийМодуль.Получить() Тогда
				ВнешниеОбъектыХранилище = Константы.ДокументооборотСКонтролирующимиОрганами_ВнешнийМодуль;
				ДвоичныеДанныеОбработки = ВнешниеОбъектыХранилище.Получить().Получить();
				Если ДвоичныеДанныеОбработки <> Неопределено Тогда
					Попытка
						ИмяФайлаВнешнегоМодуля = ИмяФайлаВнешнегоМодуля();
						ДвоичныеДанныеОбработки.Записать(ИмяФайлаВнешнегоМодуля);
						КонтекстЭДО = ВнешниеОбработки.Создать(ИмяФайлаВнешнегоМодуля);
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						Сообщить("Не удалось загрузить внешний модуль для документооборота с налоговыми органами:
							|" + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке) + "
							|Будет использован модуль, встроенный в конфигурацию.", СтатусСообщения.Важное);
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		// обновляем модуль документооборота с ФНС из Интернет при необходимости
		Если ЭтоПерваяИтерация И КонтекстЭДО <> Неопределено Тогда
			Попытка
				МодульОбновлен = КонтекстЭДО.ОбновитьМодульДокументооборотаСФНСПриНеобходимости();
				Если МодульОбновлен Тогда
					ИнициализироватьКонтекст = Истина;
				КонецЕсли;
			Исключение
				Сообщить("Не удалось проверить доступность обновления модуля документооборота с ФНС по причине внутренней ошибки:
					|" + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), СтатусСообщения.Важное);
			КонецПопытки;
		КонецЕсли;
		
		ЭтоПерваяИтерация = Ложь;		
	КонецЦикла;
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// СЕРВИСНЫЕ ПРОЦЕДУРЫ

Функция ИмяФайлаВнешнегоМодуля() Экспорт
	
	ИмяФайлаВнешнегоМодуля = КаталогВременныхФайлов() + "ДокументооборотСКонтролирующимиОрганами.epf";
	Если НайтиФайлы(ИмяФайлаВнешнегоМодуля).Количество() > 0 Тогда
		Попытка
			УдалитьФайлы(ИмяФайлаВнешнегоМодуля);
		Исключение
			ИмяФайлаВнешнегоМодуля = КаталогВременныхФайлов() + "_ДокументооборотСКонтролирующимиОрганами.epf";
		КонецПопытки;
	КонецЕсли;
	
	Возврат ИмяФайлаВнешнегоМодуля;
	
КонецФункции