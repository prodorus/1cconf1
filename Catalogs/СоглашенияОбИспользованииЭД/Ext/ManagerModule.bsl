﻿Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка"
		Или ВидФормы = "ФормаВыбора" Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		РеквизитыСоглашения = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСоглашенияЭД(Параметры.Ключ);
		ЭтоИнтеркампани = РеквизитыСоглашения.ЭтоИнтеркампани;
		СпособОбменаЭД = РеквизитыСоглашения.СпособОбменаЭД;
		
	ИначеЕсли Параметры.Свойство("ЗначенияЗаполнения") 
		И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура")
		И Параметры.ЗначенияЗаполнения.Свойство("ЭтоИнтеркампани")
		И Параметры.ЗначенияЗаполнения.Свойство("СпособОбменаЭД") Тогда
		
		ЭтоИнтеркампани = Параметры.ЗначенияЗаполнения.ЭтоИнтеркампани;
		СпособОбменаЭД = Параметры.ЗначенияЗаполнения.СпособОбменаЭД;
		
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") 
		И ЗначениеЗаполнено(Параметры.ЗначениеКопирования)
		И ТипЗнч(Параметры.ЗначениеКопирования) = Тип("СправочникСсылка.СоглашенияОбИспользованииЭД") Тогда 
		
		РеквизитыСоглашения = ЭлектронныеДокументыСлужебныйВызовСервера.РеквизитыСоглашенияЭД(Параметры.ЗначениеКопирования);
		ЭтоИнтеркампани = РеквизитыСоглашения.ЭтоИнтеркампани;
		СпособОбменаЭД = РеквизитыСоглашения.СпособОбменаЭД;
		
	Иначе
		ЭтоИнтеркампани = Неопределено;
		СпособОбменаЭД = Неопределено;
	КонецЕсли;
	
	Если ЭтоИнтеркампани = Истина Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаЭлементаИнтеркампани";
	ИначеЕсли СпособОбменаЭД = ПредопределенноеЗначение("Перечисление.СпособыОбменаЭД.ЧерезВебРесурсБанка") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаЭлементаБанк";
	КонецЕсли;
	
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик обновления БЭД 1.0.4.0
// Разбивает ТОРГ12 на ТОРГ12Продавец и ТОРГ12Покупатель, АктВыполненныхРабот на АктИсполнитель и АктЗаказчик
//
Процедура ОбновитьВидыДокументов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		
		ТОРГ12Продавец = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12Продавец, "ИсходящийДокумент");
		
		Если ТОРГ12Продавец = Неопределено Тогда
			НайденнаяСтрока= ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12, "ИсходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.ТОРГ12Продавец;
				НоваяСтрока.ИспользоватьЭЦП           = НайденнаяСтрока.ИспользоватьЭЦП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		ТОРГ12Покупатель = ИскомоеСоглашение.ИсходящиеДокументы.Найти(
								Перечисления.ВидыЭД.ТОРГ12Покупатель,
								"ИсходящийДокумент");
		
		Если ТОРГ12Покупатель = Неопределено Тогда
			НайденнаяСтрока = ИскомоеСоглашение.ВходящиеДокументы.Найти(Перечисления.ВидыЭД.ТОРГ12, "ВходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.ТОРГ12Покупатель;
				НоваяСтрока.ИспользоватьЭЦП           = НайденнаяСтрока.ИспользоватьЭЦП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		АктИсполнитель = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.АктИсполнитель, "ИсходящийДокумент");
		
		Если АктИсполнитель = Неопределено Тогда
			НайденнаяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Найти(
									Перечисления.ВидыЭД.АктВыполненныхРабот,
									"ИсходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.АктИсполнитель;
				НоваяСтрока.ИспользоватьЭЦП           = НайденнаяСтрока.ИспользоватьЭЦП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		АктЗаказчик = ИскомоеСоглашение.ИсходящиеДокументы.Найти(Перечисления.ВидыЭД.АктЗаказчик, "ИсходящийДокумент");
		
		Если АктЗаказчик = Неопределено Тогда
			НайденнаяСтрока = ИскомоеСоглашение.ВходящиеДокументы.Найти(Перечисления.ВидыЭД.АктВыполненныхРабот,
																		"ВходящийДокумент");
			Если НайденнаяСтрока <> Неопределено Тогда
				НоваяСтрока = ИскомоеСоглашение.ИсходящиеДокументы.Добавить();
				НоваяСтрока.ИсходящийДокумент         = Перечисления.ВидыЭД.АктЗаказчик;
				НоваяСтрока.ИспользоватьЭЦП           = НайденнаяСтрока.ИспользоватьЭЦП;
				НоваяСтрока.ОжидатьКвитанциюОДоставке = НайденнаяСтрока.ОжидатьКвитанциюОДоставке;
				НоваяСтрока.Формировать               = НайденнаяСтрока.Формировать;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗаписатьОбъект Тогда
			ИскомоеСоглашение.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.6.3
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ЗаполнитьВерсииФорматов() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если ВидДокумента.Формировать И Не ЗначениеЗаполнено(ВидДокумента.ВерсияФормата)
				И ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.КаталогТоваров Тогда
				
				ВидДокумента.ВерсияФормата = "CML 4.02";
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗаписатьОбъект Тогда
			ИскомоеСоглашение.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.7.1
// Переносит сертификат ЭП из реквизита "Сертификат авторизации" в таб.часть "СертификатыПодписейОрганизации".
//
Процедура ПеренестиСертификатАвторизацииВТЧ() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка,
	|	СоглашенияОбИспользованииЭД.УдалитьСертификатАбонента
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И СоглашенияОбИспользованииЭД.СпособОбменаЭД = &СпособОбменаЭД";
	
	Запрос.УстановитьПараметр("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.ЧерезОператораЭДОТакском);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СертификатЭП = Выборка.УдалитьСертификатАбонента;
		Если ЗначениеЗаполнено(СертификатЭП) Тогда
			СоглашениеЭД = Выборка.Ссылка.ПолучитьОбъект();
			НоваяСтрока = СоглашениеЭД.СертификатыПодписейОрганизации.Добавить();
			НоваяСтрока.Сертификат = СертификатЭП;
			СоглашениеЭД.УдалитьСертификатАбонента = Неопределено;
			СоглашениеЭД.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.7.4
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ЗаполнитьВерсииФорматовИсходящихЭДИПакета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления
	|	И (СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)
	|	ИЛИ СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезFTP)
	|	ИЛИ СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту))";
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если Не ЗначениеЗаполнено(ВидДокумента.ВерсияФормата) Тогда
				
				ВерсияФормата = "CML 4.02";
				Если ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
					
					ВерсияФормата = "";
				ИначеЕсли ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.АктЗаказчик
					ИЛИ ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.АктИсполнитель
					ИЛИ ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.ТОРГ12Покупатель
					ИЛИ ВидДокумента.ИсходящийДокумент = Перечисления.ВидыЭД.ТОРГ12Продавец Тогда
					
					ВерсияФормата = "ФНС 5.01";
				КонецЕсли;
				
				ВидДокумента.ВерсияФормата = ВерсияФормата;
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(ИскомоеСоглашение.ВерсияФорматаПакета) Тогда
			ИскомоеСоглашение.ВерсияФорматаПакета = Перечисления.ВерсииФорматаПакетаЭД.Версия10;
		КонецЕсли;
			
		Если ЗаписатьОбъект Тогда
			ИскомоеСоглашение.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.13.6
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ОбновитьВерсииФорматовИсходящихЭДИПакета() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	(СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)
	|			ИЛИ СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезFTP)
	|			ИЛИ СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту))";
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если ЗначениеЗаполнено(ВидДокумента.ВерсияФормата)
				И ВидДокумента.ВерсияФормата = "CML 2.06" Тогда
				
				ВидДокумента.ВерсияФормата = "CML 2.07";
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗаписатьОбъект Тогда
			ИскомоеСоглашение.Записать();
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Обработчик обновления БЭД 1.1.14.2
// Производит заполнение реквизита "ИспользуетсяКриптография".
//
Процедура ЗаполнитьИспользованиеКриптографии() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	НЕ СоглашенияОбИспользованииЭД.ИспользуетсяКриптография
	|	И СоглашенияОбИспользованииЭД.Пользователь = """"";
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		СоглашениеЭД = Результат.Ссылка.ПолучитьОбъект();
		СоглашениеЭД.ОбменДанными.Загрузка = Истина;
		СоглашениеЭД.ИспользуетсяКриптография = Истина;
		СоглашениеЭД.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.15.4
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ОбновитьВерсиюФорматаИсходящихЭД207_208() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	(СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезКаталог)
	|			ИЛИ СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезFTP)
	|			ИЛИ СоглашенияОбИспользованииЭД.СпособОбменаЭД = ЗНАЧЕНИЕ(Перечисление.СпособыОбменаЭД.ЧерезЭлектроннуюПочту))";
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		
		ИскомоеСоглашение = Результат.Ссылка.ПолучитьОбъект();
		ЗаписатьОбъект = Ложь;
		
		Для каждого ВидДокумента Из ИскомоеСоглашение.ИсходящиеДокументы Цикл
			Если ЗначениеЗаполнено(ВидДокумента.ВерсияФормата)
				И (ВидДокумента.ВерсияФормата = "CML 2.06"
					Или ВидДокумента.ВерсияФормата = "CML 2.07") Тогда
				
				ВидДокумента.ВерсияФормата = "CML 2.08";
				ЗаписатьОбъект = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если ЗаписатьОбъект Тогда
			ИскомоеСоглашение.Записать();
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

// Обработчик обновления БЭД 1.1.18.2
// Производит заполнение версии формата в табличной части ИсходящиеДокументы.
//
Процедура ОбновитьВерсиюФорматаИсходящихЭД501_502() Экспорт
	
	ИсходящиеДокументы = Новый Массив;
	ИсходящиеДокументы.Добавить(Перечисления.ВидыЭД.СчетФактура);
	ИсходящиеДокументы.Добавить(Перечисления.ВидыЭД.КорректировочныйСчетФактура);
	ВерсияФормата = "ФНС 5.01";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ Различные
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК Профиль
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент В(&ИсходящиеДокументы)
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ВерсияФормата = &ВерсияФормата";
	Запрос.УстановитьПараметр("ИсходящиеДокументы", ИсходящиеДокументы);
	Запрос.УстановитьПараметр("ВерсияФормата", ВерсияФормата);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПрофильОбъект = Выборка.Профиль.ПолучитьОбъект();
			Для Каждого ТекСтрока Из ПрофильОбъект.ИсходящиеДокументы Цикл
				
				Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура Или
					ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
					
					ТекСтрока.ВерсияФормата = НСтр("ru = 'ФНС 5.02'");
					
				КонецЕсли;
				
			КонецЦикла;
			ПрофильОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка КАК Соглашение
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент В(&ИсходящиеДокументы)
	|	И СоглашенияОбИспользованииЭДИсходящиеДокументы.ВерсияФормата = &ВерсияФормата";
	
	Запрос.УстановитьПараметр("ИсходящиеДокументы", ИсходящиеДокументы);
	Запрос.УстановитьПараметр("ВерсияФормата", ВерсияФормата);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		НастройкаОбъект = Выборка.Соглашение.ПолучитьОбъект();
		Для Каждого ТекСтрока Из НастройкаОбъект.ИсходящиеДокументы Цикл
			
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура Или
				ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
				
				ТекСтрока.ВерсияФормата = НСтр("ru = 'ФНС 5.02'");
				
			КонецЕсли;
			
		КонецЦикла;
		НастройкаОбъект.ОбменДанными.Загрузка = Истина;
		НастройкаОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.21.3
// Из табличной части Исходящие документы настроек и профилей ЭДО удаляются ответные титулы.
//
Процедура УдалитьОтветныеТитулы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка КАК Профиль
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент В(&ОтветныеТитулы)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.Ссылка Как Настройка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД.ИсходящиеДокументы КАК СоглашенияОбИспользованииЭДИсходящиеДокументы
	|ГДЕ
	|	СоглашенияОбИспользованииЭДИсходящиеДокументы.ИсходящийДокумент В(&ОтветныеТитулы)";
	
	ОтветныеТитулы = Новый Массив;
	ОтветныеТитулы.Добавить(Перечисления.ВидыЭД.АктЗаказчик);
	ОтветныеТитулы.Добавить(Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиПолучатель);
	ОтветныеТитулы.Добавить(Перечисления.ВидыЭД.ТОРГ12Покупатель);
	
	Запрос.УстановитьПараметр("ОтветныеТитулы", ОтветныеТитулы);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Профили = Результаты[0].Выгрузить();
	Для Каждого ТекСтрока Из Профили Цикл
		
		УдалитьИсходящиеЭД(ТекСтрока.Профиль, ОтветныеТитулы);
		
	КонецЦикла;
	
	Настройки = Результаты[1].Выгрузить();
	
	Для Каждого ТекСтрока Из Настройки Цикл
		
		УдалитьИсходящиеЭД(ТекСтрока.Настройка, ОтветныеТитулы);
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.21.3
// Из табличной части Исходящие документы настроек и профилей ЭДО удаляются ответные титулы.
//
Процедура НастроитьАвтоПереходНаНовыеВерсииФорматовЭД() Экспорт
	
	НачатьТранзакцию();
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СоглашенияОбИспользованииЭД.Ссылка КАК НастройкаЭДО
		|ИЗ
		|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
		|ГДЕ
		|	НЕ СоглашенияОбИспользованииЭД.ПометкаУдаления";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			НастройкаЭДО = Выборка.НастройкаЭДО.ПолучитьОбъект();
			НастройкаЭДО.АвтоПереходНаНовыеФорматы = Истина;
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НастройкаЭДО);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		
		ОтменитьТранзакцию();
		Операция = НСтр("ru = 'Обновление подсистемы обмена с контрагентами'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'При обновлении подсистемы обмена с контрагентами произошла ошибка'");
		ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьИсключениеПоЭДНаСервере(Операция, ПодробныйТекстОшибки, ТекстСообщения);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.25.0
// Заполняет в справочнике СоглашенияОбИспользованииЭД табличную часть ВходящиеДокументы
// способами по умолчанию.
//
Процедура ЗаполнитьВходящиеДокументыНастроек() Экспорт 
	
	НачатьТранзакцию();
	
	Попытка
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	СоглашенияОбИспользованииЭД.Ссылка
		|ИЗ
		|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Настройка = Выборка.Ссылка.ПолучитьОбъект();
			Настройка.ВходящиеДокументы.Очистить();
			Настройка.ВходящиеДокументы.Загрузить(ЭлектронныеДокументыСлужебный.ТаблицаПредопределенногоПрофиля("Автоматически"));
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Настройка);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		
		ОтменитьТранзакцию();
		Операция = НСтр("ru = 'Обновление подсистемы обмена с контрагентами'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'При обновлении подсистемы обмена с контрагентами произошла ошибка'");
		ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьОшибку(Операция, ПодробныйТекстОшибки, ТекстСообщения);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Обработчик обновления БЭД 1.1.26.18
// Устанавливает признак использования для отправки у настроек ЭДО.
//
Процедура УстановитьИспользованиеДляОтправки() Экспорт 
	
	ОбработанныхОбъектов = 0;
	ПроблемныхОбъектов = 0;
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.СоглашенияОбИспользованииЭД");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();
		
		НастройкиДляОтправки = НастройкиДляОтправкиЭД();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоглашенияОбИспользованииЭД.Ссылка
		|ИЗ
		|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
		|ГДЕ
		|	СоглашенияОбИспользованииЭД.СтатусПодключения = ЗНАЧЕНИЕ(Перечисление.СтатусыУчастниковОбменаЭД.Присоединен)
		|	И НЕ СоглашенияОбИспользованииЭД.ИспользуетсяДляОтправки";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ОбработанныхОбъектов = ОбработанныхОбъектов + 1;
			
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Если Объект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Объект.Заблокировать();
			ОтборСтрок = Новый Структура("Организация,Контрагент,ДоговорКонтрагента");
			ЗаполнитьЗначенияСвойств(ОтборСтрок, Объект);
			НайденныеСтроки = НастройкиДляОтправки.НайтиСтроки(ОтборСтрок);
			Если Не ЗначениеЗаполнено(НайденныеСтроки) Тогда
				Объект.ИспользуетсяДляОтправки = Истина;
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
				НоваяСтрока = НастройкиДляОтправки.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ОтборСтрок);
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
		Операция = НСтр("ru = 'Обновление подсистемы обмена с контрагентами'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = 'При обновлении подсистемы обмена с контрагентами произошла ошибка'");
		ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьОшибку(Операция, ПодробныйТекстОшибки, ТекстСообщения);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////
// Служебные процедуры и функции

Процедура УдалитьИсходящиеЭД(СправочникСсылка, ВидыЭД)
	
	СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
	ИсходящиеДокументы = СправочникОбъект.ИсходящиеДокументы;
	н = 0;
	Пока н < ИсходящиеДокументы.Количество() Цикл
		СтрокаТЗ = ИсходящиеДокументы[н];
		ИсходящийЭД = СтрокаТЗ.ИсходящийДокумент;
		Если ВидыЭД.Найти(ИсходящийЭД) = Неопределено Тогда
			н = н + 1;
			Продолжить;
		Иначе
			ИсходящиеДокументы.Удалить(СтрокаТЗ);
		КонецЕсли;
		
	КонецЦикла;
	ИсходящиеДокументы.Сортировать("ИсходящийДокумент");
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
	
КонецПроцедуры

// Формирование СоглашениеОбОбменеЭлектроннымиДокументами_doc

// Получает за один вызов всю необходимую информацию для печати: данные объектов по макетам, двоичные
// данные макетов, описание областей макетов.
// Для вызова из клиентских модулей печати форм по макетам офисных документов.
//
// Параметры:
//   ИмяМенеджераПечати - Строка - имя для обращения к менеджеру объекта, например "Документ.<Имя документа>".
//   ИменаМакетов       - Строка - имена макетов, по которым будут формироваться печатные формы.
//   СоставДокументов   - Массив - ссылки на объекты информационной базы (должны быть одного типа).
//
Функция МакетыИДанныеОбъектовДляПечати(Знач ИмяМенеджераПечати, Знач ИменаМакетов, Знач СоставДокументов) Экспорт
	
	МассивИменМакетов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаМакетов, ", ");
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяМенеджераПечати);
	МакетыИДанные = МенеджерОбъекта.ПолучитьДанныеПечати(СоставДокументов, МассивИменМакетов);
	МакетыИДанные.Вставить("ЛокальныйКаталогФайловПечати", Неопределено); // Для обратной совместимости.
	
	Возврат МакетыИДанные;
	
КонецФункции

Функция ПолучитьДанныеПечати(Знач Субъекты, Знач МассивИменМакетов) Экспорт
	
	ДанныеПоВсемОбъектам = Новый Соответствие;
	
	Для Каждого Субъект Из Субъекты Цикл
		ДанныеОбъектаПоМакетам = Новый Соответствие;
		Для Каждого ИмяМакета Из МассивИменМакетов Цикл
			ДанныеОбъектаПоМакетам.Вставить(ИмяМакета, Субъект);
		КонецЦикла;
		ДанныеПоВсемОбъектам.Вставить(Субъект.НастройкаЭДО, ДанныеОбъектаПоМакетам);
	КонецЦикла;
	
	ОписаниеОбластей = Новый Соответствие;
	ДвоичныеДанныеМакетов = Новый Соответствие;
	ТипыМакетов = Новый Соответствие;
	
	Для Каждого ИмяМакета Из МассивИменМакетов Цикл
		Если ИмяМакета = "СоглашениеОбОбменеЭлектроннымиДокументами_doc" Тогда
			ДвоичныеДанныеМакетов.Вставить(ИмяМакета, Справочники.СоглашенияОбИспользованииЭД.ПолучитьМакет(ИмяМакета));
			ТипыМакетов.Вставить(ИмяМакета, "DOC");
		КонецЕсли;
		ОписаниеОбластей.Вставить(ИмяМакета, ПолучитьОписаниеОбластейМакетаОфисногоДокумента());
	КонецЦикла;
	
	СтруктураМакетов = Новый Структура("ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов",
										ОписаниеОбластей, ТипыМакетов, ДвоичныеДанныеМакетов);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Данные", ДанныеПоВсемОбъектам);
	СтруктураВозврата.Вставить("Макеты", СтруктураМакетов);
	
	Возврат СтруктураВозврата;
	
КонецФункции

// Добавляет к параметру НаборОбластей новую запись об области.
//
// Параметры:
//   МакетаОфисногоДокумента - Массив - набор областей (массив структур) макета офисного документа.
//   ИмяОбласти              - Строка - имя добавляемой области.
//   ТипОбласти              - Строка - тип области:
//			ВерхнийКолонтитул
//			НижнийКолонтитул
//			Общая
//			СтрокаТаблицы
//			Список
//
// Пример:
//	Функция ОбластиМакетаОфисногоДокумента()
//	
//		Области = Новый Структура;
//	
//		УправлениеПечатью.ДобавитьОписаниеОбласти(Области, "ВерхнийКолонтитул",	"ВерхнийКолонтитул");
//		УправлениеПечатью.ДобавитьОписаниеОбласти(Области, "НижнийКолонтитул",	"НижнийКолонтитул");
//		УправлениеПечатью.ДобавитьОписаниеОбласти(Области, "Заголовок",			"Общая");
//	
//		Возврат Области;
//	
//	КонецФункции
//
Функция ПолучитьОписаниеОбластейМакетаОфисногоДокумента()
	
	ОписаниеОбластей = Новый Структура;
	
	НоваяОбласть = Новый Структура;
	
	НоваяОбласть.Вставить("ИмяОбласти", "Шапка");
	НоваяОбласть.Вставить("ТипОбласти", "Общая");
	
	ОписаниеОбластей.Вставить("Шапка", НоваяОбласть);
	
	Возврат ОписаниеОбластей;
	
КонецФункции

Функция НастройкиДляОтправкиЭД()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка КАК НастройкаЭДО,
	|	СоглашенияОбИспользованииЭД.Организация КАК Организация,
	|	СоглашенияОбИспользованииЭД.Контрагент КАК Контрагент,
	|	СоглашенияОбИспользованииЭД.ДоговорКонтрагента КАК ДоговорКонтрагента
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	СоглашенияОбИспользованииЭД.ИспользуетсяДляОтправки
	|	И СоглашенияОбИспользованииЭД.СтатусПодключения = Значение(Перечисление.СтатусыУчастниковОбменаЭД.Присоединен)";
	
	Настройки = Запрос.Выполнить().Выгрузить();
	Настройки.Индексы.Добавить("Организация,Контрагент,ДоговорКонтрагента");
	
	Возврат Настройки;
	
КонецФункции

#КонецЕсли