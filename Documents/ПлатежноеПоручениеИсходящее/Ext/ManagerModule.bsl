﻿
// Описывает соответствие между именами реквизитов платежа в бюджет, используемыми в модуле ПлатежиВБюджетКлиентСервер,
// и именами реквизитов документа.
//
Функция РеквизитыДокументаДляПлатежаВБюджет(ОбрабатыватьУИП = Истина)
	
	Реквизиты = Новый Соответствие;
	
	Реквизиты.Вставить("ВидПеречисления",      "ВидПеречисленияВБюджет");
	Если ОбрабатыватьУИП Тогда
		Реквизиты.Вставить("ИдентификаторПлатежа", "ИдентификаторПлатежа");
	КонецЕсли;
	Реквизиты.Вставить("СтатусПлательщика",    "СтатусСоставителя");
	Реквизиты.Вставить("КБК",                  "КодБК");
	Реквизиты.Вставить("КодТерритории",        "КодОКАТО");
	Реквизиты.Вставить("ОснованиеПлатежа",     "ПоказательОснования");
	Реквизиты.Вставить("НалоговыйПериод",      "ПоказательПериода");
	Реквизиты.Вставить("НомерДокумента",       "ПоказательНомера");
	Реквизиты.Вставить("ДатаДокумента",        "ПоказательДаты");
	Реквизиты.Вставить("ТипПлатежа",           "ПоказательТипа");
	
	Возврат Реквизиты;
	
КонецФункции

// Контекст платежа используется для вызова методов модуля ПлатежиВБюджетКлиентСервер
//
Функция КонтекстПлатежногоДокумента(Объект) Экспорт
	
	ИсточникДанных = ПлатежиВБюджетПереопределяемый.НовыйИсточникДанныхКонтекстаПлатежногоДокумента();
	ИсточникДанных.Период         = Объект.Дата;
	ИсточникДанных.Организация    = Объект.Организация;
	ИсточникДанных.СчетПолучателя = Объект.СчетКонтрагента;
	
	Возврат ПлатежиВБюджетПереопределяемый.КонтекстПлатежногоДокумента(ИсточникДанных);
	
КонецФункции

// Возвращает реквизиты платежа в бюджет с именами, используемыми в модуле ПлатежиВБюджетКлиентСервер
// 
Функция РеквизитыПлатежаВБюджет(Объект) Экспорт
	
	РеквизитыПлатежаВБюджет = ПлатежиВБюджетКлиентСервер.НовыйРеквизитыПлатежаВБюджет();
	
	РеквизитыДокумента = РеквизитыДокументаДляПлатежаВБюджет();
	ЗначенияРеквизитовДокумента = Новый Структура;
	Для Каждого Реквизит Из РеквизитыДокумента Цикл
		ЗначенияРеквизитовДокумента.Вставить(Реквизит.Значение);
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЗначенияРеквизитовДокумента, Объект);
	
	Для Каждого Реквизит Из РеквизитыДокумента Цикл
		Значение = ЗначенияРеквизитовДокумента[Реквизит.Значение];
		
		// Раньше у некоторых реквизитов была фиксированная допустимая длина.
		// Поэтому в ИБ могли остаться значения с лишними пробелами справа.
		Если ТипЗнч(Значение) = Тип("Строка") Тогда
			Значение = СокрП(Значение);
		КонецЕсли;
		
		РеквизитыПлатежаВБюджет[Реквизит.Ключ] = Значение;
		
	КонецЦикла;
	
	// В документе ПоказательДаты хранится в виде даты, а не строки
	Если ТипЗнч(РеквизитыПлатежаВБюджет.ДатаДокумента) = Тип("Дата") Тогда
		Если ЗначениеЗаполнено(РеквизитыПлатежаВБюджет.ДатаДокумента) Тогда
			РеквизитыПлатежаВБюджет.ДатаДокумента = ПлатежиВБюджетКлиентСервер.ПреобразоватьДатуКСтроке(РеквизитыПлатежаВБюджет.ДатаДокумента);
		Иначе
			РеквизитыПлатежаВБюджет.ДатаДокумента = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение();
		КонецЕсли;
	КонецЕсли;
	
	Возврат РеквизитыПлатежаВБюджет;
	
КонецФункции

// Заполняет реквизиты платежа в бюджет по структуре с ключами, имена которых 
// используются в модуле ПлатежиВБюджетКлиентСервер
// 
Процедура УстановитьЗначенияРеквизитовПлатежаВБюджет(Объект, ЗначенияЗаполнения, ДобавитьСвойстваВСтруктуру = Ложь) Экспорт
	
	РеквизитыДокумента = РеквизитыДокументаДляПлатежаВБюджет(Ложь);
	ЗначенияРеквизитовДокумента = Новый Структура;
	Для Каждого ЗначениеЗаполнения Из ЗначенияЗаполнения Цикл
		ИмяРеквизитаДокумента = РеквизитыДокумента[ЗначениеЗаполнения.Ключ];
		Если Не ИмяРеквизитаДокумента = Неопределено Тогда			
			ЗначенияРеквизитовДокумента.Вставить(ИмяРеквизитаДокумента, ЗначениеЗаполнения.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ДобавитьСвойстваВСтруктуру Или ТипЗнч(Объект) <> Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитовДокумента);
		
	Иначе
		
		Для Каждого КлючИЗначение Из ЗначенияРеквизитовДокумента Цикл
			Объект.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитыПлатежаВБюджетПоУмолчанию(Дата, Организация, СчетПолучателя, ПеречислениеВБюджет) Экспорт
	
	// Получим значения по умолчанию в терминах модуля ПлатежиВБюджетКлиентСервер
	Если Не ПеречислениеВБюджет Тогда
		
		ЗначенияПоУмолчанию = ПлатежиВБюджетКлиентСервер.НовыйРеквизитыПлатежаВБюджет();
		
	Иначе
		
		СвойстваКонтекста = ПлатежиВБюджетПереопределяемый.НовыйИсточникДанныхКонтекстаПлатежногоДокумента();
		СвойстваКонтекста.Период         = Дата;
		СвойстваКонтекста.Организация    = Организация;
		СвойстваКонтекста.СчетПолучателя = СчетПолучателя;
		
		Контекст = ПлатежиВБюджетПереопределяемый.КонтекстПлатежногоДокумента(СвойстваКонтекста);
		
		ЗначенияПоУмолчанию = ПлатежиВБюджетКлиентСервер.ЗначенияПоУмолчанию(Контекст);
		
	КонецЕсли;
	
	// В незаполненных полях проставим "0"
	Для Каждого КлючИЗначение Из ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ЗначенияПоУмолчанию) Цикл
		Если КлючИЗначение.Значение = Неопределено Тогда 
			ЗначенияПоУмолчанию[КлючИЗначение.Ключ] = ПлатежиВБюджетКлиентСервер.НезаполненноеЗначение();
		КонецЕсли;
	КонецЦикла;
	
	ПлатежиВБюджетКлиентСервер.ОтметитьНезаполненныеЗначения(ЗначенияПоУмолчанию);
	
	// Переведем на язык документа
	Результат = Новый Структура;
	УстановитьЗначенияРеквизитовПлатежаВБюджет(
		Результат,           // Куда
		ЗначенияПоУмолчанию, // Откуда
		Истина);             // Добавлять свойства в "куда"
		
	Возврат Результат;

КонецФункции

// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ

// Обработчик обновления
//
// Проводит документы по регистру "ДвиженияДСпоГосконтрактам"
Процедура ПровестиПоРегиструДвиженияДСпоГосконтрактам() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документы.Ссылка,
	|	Документы.Ссылка.Оплачено,
	|	Документы.Ссылка.Дата,
	|	Документы.Ссылка.ДатаОплаты
	|ИЗ
	|	Документ.ПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК Документы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтрактыИсполнителей КАК КонтрактыИсполнителей
	|		ПО Документы.ДоговорКонтрагента = КонтрактыИсполнителей.Договор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтрактыСЗаказчиками КАК КонтрактыСЗаказчиками
	|		ПО Документы.ДоговорКонтрагента = КонтрактыСЗаказчиками.Договор
	|ГДЕ
	|	(НЕ КонтрактыИсполнителей.Ссылка ЕСТЬ NULL 
	|			ИЛИ НЕ КонтрактыСЗаказчиками.Ссылка ЕСТЬ NULL )
	|	И Документы.Ссылка.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	Документы.Ссылка,
	|	Документы.Ссылка.Оплачено,
	|	Документы.Ссылка.Дата,
	|	Документы.Ссылка.ДатаОплаты";
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		нзГосКонтракты = РегистрыНакопления.ДвиженияДСпоГосконтрактам.СоздатьНаборЗаписей();
		нзГосКонтракты.ОбменДанными.Загрузка = Истина;
		
		Пока Выборка.Следующий() Цикл

			нзГосКонтракты.Очистить();
			нзГосКонтракты.Отбор.Регистратор.Установить(Выборка.Ссылка);
			ТаблицаДвиженияДенежныхСредств = УправлениеДенежнымиСредствами.ПолучитьТаблицуДвиженияДСпоГосконтрактам(Выборка.Ссылка);
			ДатаДвижений=?(Выборка.Оплачено,УправлениеДенежнымиСредствами.ПолучитьДатуДвижений(Выборка.Дата,Выборка.ДатаОплаты),Выборка.Дата);
			Если ТаблицаДвиженияДенежныхСредств.Количество() > 0 Тогда
				Попытка
					нзГосКонтракты.мПериод          = ДатаДвижений;
					нзГосКонтракты.мТаблицаДвижений = ТаблицаДвиженияДенежныхСредств;
					нзГосКонтракты.ВыполнитьДвижения();
				Исключение
					ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
				КонецПопытки;
			КонецЕсли;
			
		КонецЦикла
		
	КонецЕсли;
	
КонецПроцедуры
