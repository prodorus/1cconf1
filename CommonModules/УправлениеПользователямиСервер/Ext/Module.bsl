﻿// Функция записывает изменения данных пользователя ИБ
// Параметры:
// ИмяИдентификаторПользователя - УникальныйИдентификатор/строка - имя пользователя ИБ
//								либо уникальный идентификатор пользователя ИБ
// ПользовательСтруктура - структура - структура, содержащая новые значения
//									характеристик пользователя ИБ
//
Функция ЗаписатьПользователяИБ(	знач ИмяИдентификаторПользователя,
								знач ПользовательСтруктура,
								СообщениеОбОшибке,
								знач СписокРолей = Неопределено) Экспорт
	
	Если ТипЗнч(ИмяИдентификаторПользователя) = Тип("УникальныйИдентификатор") Тогда
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИмяИдентификаторПользователя);
	Иначе
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяИдентификаторПользователя);
	КонецЕсли;
	
	Если ПользовательИБ = Неопределено Или ПользовательИБ.Имя = "" Тогда
		ПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
	КонецЕсли;
	
	ПользовательИБ.Имя						= ПользовательСтруктура["Имя"];
	ПользовательИБ.ПолноеИмя				= ПользовательСтруктура["ПолноеИмя"];
	ПользовательИБ.АутентификацияОС			= ПользовательСтруктура["АутентификацияОС"];
	ПользовательИБ.ПользовательОС			= ПользовательСтруктура["ПользовательОС"];
	ПользовательИБ.АутентификацияСтандартная= ПользовательСтруктура["АутентификацияСтандартная"];
	ПользовательИБ.ПоказыватьВСпискеВыбора	= ПользовательСтруктура["ПоказыватьВСпискеВыбора"];
	ПользовательИБ.ЗапрещеноИзменятьПароль	= ПользовательСтруктура["ЗапрещеноИзменятьПароль"];
	ПользовательИБ.РежимЗапуска				= ПользовательСтруктура["РежимЗапуска"];
	
	Если ПользовательСтруктура.Свойство("Пароль") Тогда
		ПользовательИБ.Пароль = ПользовательСтруктура.Пароль;
	КонецЕсли;
	
	ПользовательИБ.ОсновнойИнтерфейс = Метаданные.Интерфейсы.Найти(ПользовательСтруктура["ОсновнойИнтерфейс"]);
	
	ПользовательИБ.Язык = Метаданные.Языки.Найти(ПользовательСтруктура["Язык"]);

	Если СписокРолей <> Неопределено Тогда
		ПользовательИБ.Роли.Очистить();
		Для Каждого СтрокаТаблицы Из СписокРолей Цикл
			Если НЕ СтрокаТаблицы.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			Роль = Метаданные.Роли.Найти(СтрокаТаблицы.ИмяРоли);
			Если Роль = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПользовательИБ.Роли.Добавить(Роль);
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		ПользовательИБ.Записать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеОбОшибке = ИнформацияОбОшибке.Причина.Описание;
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ПользовательИБ.УникальныйИдентификатор;
	
КонецФункции

// Процедура для удаления пользователя информационной базы
//
Функция УдалитьПользователяИБ(знач ИдентификаторПользователя) Экспорт
	
	Попытка
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ИдентификаторПользователя);
		ПользовательИБ.Удалить();
	Исключение
		Сообщение = 
			НСтр("ru = 'Ошибка удаления пользователя информационной базы: '") +
			ОбщегоНазначенияКлиентСервер.ПолучитьПредставлениеОписанияОшибки(ИнформацияОбОшибке());
		Возврат ОбщегоНазначенияКлиентСервер.ЗаполнитьРезультат(Сообщение, Ложь);
	КонецПопытки;
	
	Возврат ОбщегоНазначенияКлиентСервер.ЗаполнитьРезультат(Неопределено);
	
КонецФункции

// Функция проверяющая право администрирования объекта метаданного у текущего
// пользователя. Если объект метаданных не указан, но проверяется право
// на администрирование конфигурации.
// Параметры
// ОбъектМетаданных - метаданные - метаданные
// Возвращаемое значение
// Истина        - пользователь имеет право на администрирование
// Ложь          - пользователь не имеет права на администрирование
//
Функция ПроверитьПравоАдминистрирования(знач ОбъектМетаданных = Неопределено) Экспорт
	
	Если ОбъектМетаданных = Неопределено Тогда
		ОбъектМетаданных = Метаданные;
	КонецЕсли;
	
	Возврат ПравоДоступа("Администрирование", ОбъектМетаданных);
	
КонецФункции

// Получает имя  и полное имя пользователя ИБ по идентефикатору пользователя
//
Функция ПолучитьИмяПолноеИмя(УникальныйИдентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(УникальныйИдентификатор);
	
	Если Пользователь = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Новый Структура("Имя, ПолноеИмя",Пользователь.Имя, Пользователь.ПолноеИмя);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Функциональность для управления оформлением списков пользователей

Процедура ПроверитьСинхронизациюПользователейИУстановитьОформлениеСписка(УсловноеОформление) Экспорт
	
	ПользователиОтмеченные = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	Ссылка, Код, Наименование, ИдентификаторПользователяИБ
					|ИЗ
					|	Справочник.Пользователи КАК Пользователи
					|ГДЕ
					|	НЕ ЭтоГруппа";
					
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если СокрЛП(Выборка.Код) = "<Не указан>" Тогда
			Продолжить;
		ИначеЕсли Не ЗначениеЗаполнено(Выборка.ИдентификаторПользователяИБ) Тогда
			ПользователиОтмеченные.Добавить(Выборка.Ссылка);
		ИначеЕсли НЕ ПользователиПолныеПрава.ПользовательСуществует(Выборка.ИдентификаторПользователяИБ) Тогда
			ПользователиОтмеченные.Добавить(Выборка.Ссылка);
		ИначеЕсли ПользователиПолныеПрава.РассинхронизацияИмениПользователя(Выборка.Ссылка) Тогда
			ПользователиОтмеченные.Добавить(Выборка.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Если ПользователиОтмеченные.Количество() > 0 Тогда
		УстановитьУсловноеОформлениеДляЭлементовТребующихВнимания(ПользователиОтмеченные, УсловноеОформление);
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеДляВыбранногоЭлемента(знач Ссылка, УсловноеОформление) Экспорт
	
	ЭлементУсловногоОформления = 
			ПолучитьЭлементУсловногоОформления(УсловноеОформление,
												"ЭлементыСправочникаВыбранные",
												Метаданные.ЭлементыСтиля.ПользовательВыбранный.Значение);
	
	ДобавитьЭлементОтбораКУсловномуОформлению(ЭлементУсловногоОформления, Ссылка);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеДляЭлементовТребующихВнимания(знач ПользователиОтмеченные, УсловноеОформление)
	
	ЭлементУсловногоОформления = 
			ПолучитьЭлементУсловногоОформления(УсловноеОформление,
												"ЭлементыСправочникаТребующиеВнимания",
												Метаданные.ЭлементыСтиля.ПользовательБезУчетнойЗаписи.Значение);
	
	ДобавитьЭлементОтбораКУсловномуОформлению(ЭлементУсловногоОформления, ПользователиОтмеченные);
	
КонецПроцедуры

Функция ДобавитьЭлементОтбораКУсловномуОформлению(ЭлементУсловногоОформления, МассивСсылка)
	
	Если ЭлементУсловногоОформления.Отбор.Элементы.Количество() = 0 Тогда
		ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Иначе
		ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы[0];
	КонецЕсли;
	
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	Если ЭлементОтбораДанных.ПравоеЗначение = Неопределено Тогда
		ЭлементОтбораДанных.ПравоеЗначение = Новый СписокЗначений;
	КонецЕсли;
	
	Если ТипЗнч(МассивСсылка) = Тип("Массив") Тогда
		ЭлементОтбораДанных.ПравоеЗначение.ЗагрузитьЗначения(МассивСсылка);
	Иначе
		ЭлементОтбораДанных.ПравоеЗначение.Добавить(МассивСсылка);
	КонецЕсли;
	
	ЭлементОтбораДанных.Использование = Истина;
	
КонецФункции

Функция ПолучитьЭлементУсловногоОформления(УсловноеОформление,
											ИдентификаторПользовательскойНастройки,
											ЭлементСтиляЗначение)
	
	Для Каждого ЭлементУО Из УсловноеОформление.Элементы Цикл
		Если ЭлементУО.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
			Возврат ЭлементУО;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("Код");
	
	ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеОформления.Использование = Истина;
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("Наименование");
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЭлементСтиляЗначение);
	
	ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки;
	
	Возврат ЭлементУсловногоОформления;
	
КонецФункции

Функция ПользователюРазрешенЗапускКонфигурации() Экспорт
	
	Если НЕ РольДоступна("Пользователь")
		И (НЕ РольДоступна("ПолныеПрава")) Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // 
