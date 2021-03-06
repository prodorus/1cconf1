Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю

#Если Клиент ИЛИ ВнешнееСоединение Тогда
	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
		
КонецФункции

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры


Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	СтруктураНатроек = Новый Структура();
	Возврат СтруктураНатроек;
	
КонецФункции

#КонецЕсли

#Если Клиент Тогда
	
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры

#КонецЕсли

// Процедура запускается каждый раз перед формированием отчета. В ней содержиться код который обрабатывает настройки отчета 
// перед формированим отчета. К примеру подстановка периода отчета по умолчанию если пользователь не задал не период в отчете
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	// для отчета РасхожденияДанныхПоВзаиморасчетам
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВалютаРеглУчета"));
	Если ЗначениеПараметра = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗначениеПараметра.Использование = Истина;
	ЗначениеПараметра.Значение = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	
КонецПроцедуры

#Если Клиент Тогда
////////////////////////////////////////////////////////////	
//
//  ОСОБЕННОСТИ ОТЧЕТА РасхожденияДанныхПоВзаиморасчетам

// ОТЛИЧАЮЩИЕСЯ ОТ ВЕРСИИ 1.2.19

// РАБОТА С РАСШИФРОВКАМИ ДРУГИМИ ОТЧЕТАМИ

Процедура ОбработкаРасшировкиОтчета(Форма, Расшифровка, СтандартнаяОбработка) Экспорт
	
	// В версии 1.2.19 имеет отличия
	
	Ресурсы                   = ПолучитьРесурсыРасшифровки(Расшифровка, Форма.ДанныеРасшифровки);
	ПоляРасшифровки           = ПолучитьПоляРасшифровки(Расшифровка, Форма.ДанныеРасшифровки);
	ДополнительныеРасшифровки = ПолучитьСписокРасшифровки(ПоляРасшифровки, Ресурсы);
	
	// Выбираем расшифровку. Если выбрали "стандартную", то это обработается сразу.
	ВыбранноеПоле = ТиповыеОтчеты.ОбработкаРасшифровкиТиповогоОтчета(Расшифровка, СтандартнаяОбработка, ЭтотОбъект, Форма, ДополнительныеРасшифровки);
	
	ВывестиДополнительныйОтчет(ВыбранноеПоле, Форма, ПоляРасшифровки);
	
КонецПроцедуры // ОбработкаРасшировкиОтчета()

// ОБЩИЕ С ВЕРСИЕЙ 1.2.19

// НЕПОСРЕДСТВЕННАЯ НАСТРОЙКА И ВЫВОД ОТЧЕТОВ РАЗНЫХ ВИДОВ

// Определяет список отчетов, которые можем построить для расшифровки конкретной ячейки
Функция ПолучитьСписокРасшифровки(ПоляРасшифровки, Ресурсы)

	// Добавим возможность расшифровок другими отчетами
	ДополнительныеРасшифровки = Новый СписокЗначений;
	Для Каждого Ресурс Из Ресурсы Цикл
		
		// В зависимости от ресурса, который расшифровывается, будут использованы разные отчеты
		Если Ресурс = "ОстатокНДС" Тогда //ИЛИ Ресурс = "РасхождениеХозрасчетный_НДС" ИЛИ Ресурс = "РасхождениеРасчеты_НДС" ИЛИ Ресурс = "РасхождениеНДС_Взаиморасчеты" Тогда
			
			ДополнительныеРасшифровки.Добавить("Движения_НДСПокупатели", "По документам движения (регистр ""НДС Расчеты с покупателями"")");
			ДополнительныеРасшифровки.Добавить("Движения_НДСПоставщики", "По документам движения (регистр ""НДС Расчеты с поставщиками"")");
			
		ИначеЕсли Ресурс = "ОстатокРасчеты" Тогда //ИЛИ Ресурс = "РасхождениеХозрасчетный_Расчеты" ИЛИ Ресурс = "РасхождениеРасчеты_НДС" ИЛИ Ресурс = "РасхождениеРасчеты_Взаиморасчеты" Тогда
			
			ДополнительныеРасшифровки.Добавить("Движения_РасчетыПокупатели", "По документам движения (регистр ""Расчеты по реализации"")");
			ДополнительныеРасшифровки.Добавить("Движения_РасчетыПоставщики", "По документам движения (регистр ""Расчеты по приобретению"")");
			
		ИначеЕсли Ресурс = "ОстатокХозрасчетный" Тогда //ИЛИ Ресурс = "РасхождениеХозрасчетный_НДС" ИЛИ Ресурс = "РасхождениеХозрасчетный_Расчеты" ИЛИ Ресурс = "РасхождениеХозрасчетный_Взаиморасчеты" Тогда
			
			// ОСВ по счету и карточку счета можем выводить только для счета учета
			Если ЗначениеРасшифровки(ПоляРасшифровки, "СчетУчета") <> Неопределено Тогда
				ДополнительныеРасшифровки.Добавить("ОСВ_Хозрасчетный", "Оборотно-сальдовая ведомость");
				ДополнительныеРасшифровки.Добавить("КарточкаСчета_Хозрасчетный", "Карточка счета");
			КонецЕсли;
			
			// Карточку субконто можем выводить только для договора
			Если ЗначениеРасшифровки(ПоляРасшифровки, "ДоговорКонтрагента") <> Неопределено Тогда
				ДополнительныеРасшифровки.Добавить("КарточкаСубконто_Хозрасчетный", "Карточка субконто");
			КонецЕсли;
			
		ИначеЕсли Ресурс = "ОстатокВзаиморасчеты" Тогда //ИЛИ Ресурс = "РасхождениеНДС_Взаиморасчеты" ИЛИ Ресурс = "РасхождениеРасчеты_Взаиморасчеты" ИЛИ Ресурс = "РасхождениеХозрасчетный_Взаиморасчеты" Тогда
			
			ДополнительныеРасшифровки.Добавить("Отчет_Взаиморасчеты", "Ведомость по взаиморасчетам");
			ДополнительныеРасшифровки.Добавить("Движения_Взаиморасчеты", "По документам движения (регистр ""Взаиморасчеты с контрагентами"")");
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДополнительныеРасшифровки;
	
КонецФункции

// Процедура - роутер: в зависимости от выбранного значения строит отчет
Процедура ВывестиДополнительныйОтчет(ВыбранноеПоле, Форма, ПоляРасшифровки)
	
	Если ВыбранноеПоле = "КарточкаСубконто_Хозрасчетный" Тогда
		
		ВывестиКарточкуСубконто(Форма, ПоляРасшифровки);
		
	ИначеЕсли ВыбранноеПоле = "Движения_РасчетыПокупатели" Тогда
		
		ВывестиУниверсальныйОтчет(Форма, "РасчетыПоРеализацииВУсловныхЕдиницахОрганизации", "СуммаРег", ПоляРасшифровки);
		
	ИначеЕсли ВыбранноеПоле = "Движения_РасчетыПоставщики" Тогда
		
		ВывестиУниверсальныйОтчет(Форма, "РасчетыПоПриобретениюВУсловныхЕдиницахОрганизации", "СуммаРег", ПоляРасшифровки);
		
	ИначеЕсли ВыбранноеПоле = "Движения_Взаиморасчеты" Тогда
		
		ВывестиУниверсальныйОтчет(Форма, "ВзаиморасчетыСКонтрагентами", "СуммаВзаиморасчетов", ПоляРасшифровки);
		
	ИначеЕсли ВыбранноеПоле = "ОСВ_Хозрасчетный" Тогда
		
		ВывестиОСВ(Форма, ПоляРасшифровки);
		
	ИначеЕсли ВыбранноеПоле = "КарточкаСчета_Хозрасчетный" Тогда
		
		ВывестиКарточкуСчета(Форма, ПоляРасшифровки);
		
	ИначеЕсли ВыбранноеПоле = "Отчет_Взаиморасчеты" Тогда
		
		ВывестиОтчетВзаиморасчеты(Форма, ПоляРасшифровки);
		
	КонецЕсли;

КонецПроцедуры

// 1. Отчеты на базе Универсальный отчет

// Выполняет настройку, общую для всех отчетов на базе универсального
Процедура НастроитьУниверсальныйОтчет(УниверсальныйОтчет, ОтчетРасшифровки, ФормаОтчетаРасшифровки, Показатель, ПоляРасшифровки, ДатаКонцаРасшифровки)
	
	УниверсальныйОтчет.ПереустановитьНачальныеНастройки(УниверсальныйОтчет, ОтчетРасшифровки, ФормаОтчетаРасшифровки);
	
	// Период
	УниверсальныйОтчет.ДатаНач = ДатаНачалаРасшифровки;
	УниверсальныйОтчет.ДатаКон = ДатаКонцаРасшифровки;
	
	// Выключим все показатели
	Для Каждого ПоказательОтчетаРасшифровки Из УниверсальныйОтчет.Показатели.Строки Цикл
		ПоказательОтчетаРасшифровки.Использование = 0;
		Для Каждого ПодПоказательОтчетаРасшифровки Из ПоказательОтчетаРасшифровки.Строки Цикл
			ПодПоказательОтчетаРасшифровки.Использование = 0;
		КонецЦикла;
	КонецЦикла;
	
	// Найдем и включим нужные показатели
	// На верхнем уровне дерева - "показатели"
	// На нижнем - "функции показателей"
	ПоказательОтчетаРасшифровки = УниверсальныйОтчет.Показатели.Строки.Найти(Показатель, "Имя");
	Если ПоказательОтчетаРасшифровки <> Неопределено Тогда
		ПоказательОтчетаРасшифровки.Использование = 2;
		
		ПодПоказательОтчетаРасшифровки = ПоказательОтчетаРасшифровки.Строки.Найти(Показатель + "Приход", "Имя");
		Если ПодПоказательОтчетаРасшифровки <> Неопределено Тогда
			ПодПоказательОтчетаРасшифровки.Использование = 1;
		КонецЕсли;
		
		ПодПоказательОтчетаРасшифровки = ПоказательОтчетаРасшифровки.Строки.Найти(Показатель + "Расход", "Имя");
		Если ПодПоказательОтчетаРасшифровки <> Неопределено Тогда
			ПодПоказательОтчетаРасшифровки.Использование = 1;
		КонецЕсли;
		
		ПодПоказательОтчетаРасшифровки = ПоказательОтчетаРасшифровки.Строки.Найти(Показатель + "КонечныйОстаток", "Имя");
		Если ПодПоказательОтчетаРасшифровки <> Неопределено Тогда
			ПодПоказательОтчетаРасшифровки.Использование = 1;
		КонецЕсли;
		
	КонецЕсли;
		
	// Группировки и отборы установим такие же, как в исходном отчете
	// Имена колонок могут не совпадать. Поэтому используем таблицу подстановки имен.
	УниверсальныйОтчет.ПостроительОтчета.ИзмеренияКолонки.Очистить();
	УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Очистить();
	ОчиститьОтбор(УниверсальныйОтчет.ПостроительОтчета.Отбор);
	
	Для Каждого Поле Из ПоляРасшифровки Цикл
		
		// Определим поле построителя отчета расшифровки
		ИмяПоляПостроителя = "";
		ИмяВРегистре = ПолучитьИмяПоляОтчетаРасшифровки(Поле, УниверсальныйОтчет.ИмяРегистра, ИмяПоляПостроителя);
		
		ПолеОтчетаРасшифровки = УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.Найти(ИмяВРегистре);
		Если ПолеОтчетаРасшифровки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// 	Установим отбор и группировку.
		Если ПолеОтчетаРасшифровки.Отбор = Истина Тогда
			УстановитьОтборПоПолюРасшифровки(Поле, УниверсальныйОтчет.ПостроительОтчета.Отбор, ИмяПоляПостроителя);
		КонецЕсли;
		
		Если ТипЗнч(Поле) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") И ПолеОтчетаРасшифровки.Измерение = Истина Тогда
			УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Добавить(ИмяПоляПостроителя);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Универсальный отчет по произвольному регистру
Процедура ВывестиУниверсальныйОтчет(Форма, ИмяРегистра, Показатель, ПоляРасшифровки)
	
	Если НЕ ВвестиДатуНачала() Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетРасшифровки = Отчеты.УниверсальныйОтчет.Создать();
	ФормаОтчетаРасшифровки = ОтчетРасшифровки.ПолучитьФорму();
	ФормаОтчетаРасшифровки.Открыть();
	
	ОтчетРасшифровки.ИмяРегистра = ИмяРегистра;

	НастроитьУниверсальныйОтчет(ОтчетРасшифровки, ОтчетРасшифровки, ФормаОтчетаРасшифровки, Показатель, ПоляРасшифровки, ПолучитьДатуОкончания(Форма));
	
	// Добавим группировку по регистратору
	ОтчетРасшифровки.ПостроительОтчета.ИзмеренияСтроки.Добавить("Регистратор");
	
	ФормаОтчетаРасшифровки.ОбновитьОтчет();
	
КонецПроцедуры

// Отчет ВзаиморасчетыСКонтрагентами
Процедура ВывестиОтчетВзаиморасчеты(Форма, ПоляРасшифровки)
	
	Если НЕ ВвестиДатуНачала() Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетРасшифровки = Отчеты.ВедомостьВзаиморасчетыСКонтрагентами.Создать();
	ФормаОтчетаРасшифровки = ОтчетРасшифровки.ПолучитьФорму();
	ФормаОтчетаРасшифровки.Открыть();

	НастроитьУниверсальныйОтчет(ОтчетРасшифровки.УниверсальныйОтчет, ОтчетРасшифровки, ФормаОтчетаРасшифровки, "СуммаВзаиморасчетов", ПоляРасшифровки, ПолучитьДатуОкончания(Форма));
	
	ФормаОтчетаРасшифровки.ОбновитьОтчет();
	
КонецПроцедуры

// 2. Бухгалтерские отчеты

// Устанавливает отборы и группировки в бухгалтерских отчетах по субконто счета, выбранного в отчете
//
// Параметры
//  ПоляРасшифровки    - массив полей расшифровки отчета с данными об отборах и группировках 
//  ОтчетРасшифровки   - объект отчета КарточкаСчета или ОСВ 
//  ДобавлятьИзмерения - булево, добавлять группировки или нет
Процедура УстановитьОтборыГруппировкиПоСубконто(ПоляРасшифровки, ОтчетРасшифровки, ДобавлятьИзмерения)
	
	// Выкинем всё из отбора
	ОчиститьОтбор(ОтчетРасшифровки.ПостроительОтчета.Отбор);
	
	// Подготовим список полей построителя, которые есть в отчете
	ПоляСубконто = Новый Соответствие;
	Для Каждого Субконто Из ОтчетРасшифровки.Счет.ВидыСубконто Цикл
		ИмяПоля     = "Субконто" + (ОтчетРасшифровки.Счет.ВидыСубконто.Индекс(Субконто) + 1);
		ИмяСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПолучитьИмяПредопределенного(Субконто.ВидСубконто);
		Если НЕ ПустаяСтрока(ИмяСубконто) Тогда // Т.е. субконто - предопределенное
			ПоляСубконто.Вставить(ИмяСубконто, ИмяПоля);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Поле Из ПоляРасшифровки Цикл
		
		// Определим поле построителя отчета расшифровки
		ИмяПоляПостроителя = "";
		ИмяВРегистре = ПолучитьИмяПоляОтчетаРасшифровки(Поле, "Хозрасчетный", ИмяПоляПостроителя);
		
		Если ПоляСубконто[ИмяВРегистре] = Неопределено Тогда
			// По этому полю ничего не можем сделать, т.к. оно не соответствует субконто счета
			Продолжить;
		КонецЕсли;
		
		// Имя поля построителя преобразуем к нотации "СубконтоN."
		ИмяПоляПостроителя = ПоляСубконто[ИмяВРегистре] + Сред(ИмяПоляПостроителя, СтрДлина(ИмяВРегистре)+1);
		
		ПолеОтчетаРасшифровки = ОтчетРасшифровки.ПостроительОтчета.ДоступныеПоля[ПоляСубконто[ИмяВРегистре]];// Верим, что оно там есть, 
		//т.к. в отчете состав полей определяется по счету
		
		// 	Установим отбор и группировку
		Если ПолеОтчетаРасшифровки.Отбор = Истина Тогда
			УстановитьОтборПоПолюРасшифровки(Поле, ОтчетРасшифровки.ПостроительОтчета.Отбор, ИмяПоляПостроителя);
		КонецЕсли;
		
		Если ДобавлятьИзмерения Тогда
			Если ТипЗнч(Поле) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") И ПолеОтчетаРасшифровки.Измерение = Истина Тогда
				ОтчетРасшифровки.ПостроительОтчета.ИзмеренияСтроки.Добавить(ИмяПоляПостроителя);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры	

Процедура ВывестиКарточкуСубконто(Форма, ПоляРасшифровки)
	
	Если НЕ ВвестиДатуНачала() Тогда
		Возврат;
	КонецЕсли;

	ОтчетРасшифровки = Отчеты.КарточкаСубконтоХозрасчетный.Создать();
	ФормаОтчетаРасшифровки = ОтчетРасшифровки.ПолучитьФорму();
	ФормаОтчетаРасшифровки.Открыть();

	// Настройки отчета.
	// Возможно настройки были прочитаны при открытии формы, они нам не нужны.
	ОтчетРасшифровки.Субконто.Очистить();
	ОчиститьОтбор(ОтчетРасшифровки.ПостроительОтчета.Отбор);

	// Субконто - только договор
	ОтчетРасшифровки.Субконто.Добавить().ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;
	ОтчетРасшифровки.ПерезаполнитьНачальныеНастройки();

	// Организация
	ОтчетРасшифровки.Организация = ЗначениеРасшифровки(ПоляРасшифровки, "Организация");

	// Период
	ОтчетРасшифровки.ДатаНач = ДатаНачалаРасшифровки;
	ОтчетРасшифровки.ДатаКон = ПолучитьДатуОкончания(Форма);

	// Отборы
	УстановитьОтборПоЗначениюРасшифровки(ОтчетРасшифровки.ПостроительОтчета.Отбор, ПоляРасшифровки, "Субконто1", "ДоговорКонтрагента");
	УстановитьОтборПоЗначениюРасшифровки(ОтчетРасшифровки.ПостроительОтчета.Отбор, ПоляРасшифровки, "Счет", "СчетУчета");
	// по валюте не накладываем, т.к. выбран договор в валюте регл. учета

	ФормаОтчетаРасшифровки.ОбновитьОтчет();
	
КонецПроцедуры

Процедура ВывестиКарточкуСчета(Форма, ПоляРасшифровки)
	
	Если НЕ ВвестиДатуНачала() Тогда
		Возврат;
	КонецЕсли;

	ОтчетРасшифровки = Отчеты.КарточкаСчетаХозрасчетный.Создать();
	
	ФормаОтчетаРасшифровки = ОтчетРасшифровки.ПолучитьФорму();
	ФормаОтчетаРасшифровки.Открыть();

	// Настройки отчета.
	// Возможно настройки были прочитаны при открытии формы, они нам не нужны.
	ОчиститьОтбор(ОтчетРасшифровки.ПостроительОтчета.Отбор);

	// Счет
	ОтчетРасшифровки.Счет = ЗначениеРасшифровки(ПоляРасшифровки, "СчетУчета");
    ОтчетРасшифровки.ЗаполнитьНачальныеНастройки();
	
	// Организация
	ОтчетРасшифровки.Организация = ЗначениеРасшифровки(ПоляРасшифровки, "Организация");

	// Период
	ОтчетРасшифровки.ДатаНач = ДатаНачалаРасшифровки;
	ОтчетРасшифровки.ДатаКон = ПолучитьДатуОкончания(Форма);

	// Отборы и группировки (по субконто счета)
	УстановитьОтборыГруппировкиПоСубконто(ПоляРасшифровки, ОтчетРасшифровки, Ложь);
	
	// по валюте не накладываем, т.к. выбран договор в валюте регл. учета

	ФормаОтчетаРасшифровки.ОбновитьОтчет();
	
КонецПроцедуры

Процедура ВывестиОСВ(Форма, ПоляРасшифровки)
	
	Если НЕ ВвестиДатуНачала() Тогда
		Возврат;
	КонецЕсли;

	ОтчетРасшифровки = Отчеты.ОборотноСальдоваяВедомостьПоСчетуХозрасчетный.Создать();
	
	ФормаОтчетаРасшифровки = ОтчетРасшифровки.ПолучитьФорму();
	ФормаОтчетаРасшифровки.Открыть();

	// Настройки отчета.
	// Возможно настройки были прочитаны при открытии формы, они нам не нужны.
	ОчиститьОтбор(ОтчетРасшифровки.ПостроительОтчета.Отбор);
	ОтчетРасшифровки.ПостроительОтчета.ИзмеренияСтроки.Очистить();
	

	// Счет
	ОтчетРасшифровки.Счет = ЗначениеРасшифровки(ПоляРасшифровки, "СчетУчета");
    ОтчетРасшифровки.ЗаполнитьНачальныеНастройки();
	
	// Организация
	ОтчетРасшифровки.Организация = ЗначениеРасшифровки(ПоляРасшифровки, "Организация");

	// Период
	ОтчетРасшифровки.ДатаНач = ДатаНачалаРасшифровки;
	ОтчетРасшифровки.ДатаКон = ПолучитьДатуОкончания(Форма);

	// Отборы и группировки (по субконто счета)
	УстановитьОтборыГруппировкиПоСубконто(ПоляРасшифровки, ОтчетРасшифровки, Истина);
	
	// по валюте отбор не накладываем, т.к. выбран договор в валюте регл. учета

	ФормаОтчетаРасшифровки.ОбновитьОтчет();
	
КонецПроцедуры

// ОБЩИЕ ПРОЦЕДУРЫ РАБОТЫ ДЛЯ РАБОТЫ С РАСШИФРОВКАМИ

// Получает список группировок, по которым расшифровываем
Функция ПолучитьПоляРасшифровки(Расшифровка, ДанныеРасшифровки)
	
	// Подготовим список полей группировки без ресурсов
	МассивПолей = ТиповыеОтчеты.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровки);
	
	// Модифицируем список.
	// 1. Удалим из списка группы отбора, т.к. при расшифровке другими отчетами (не на СКД) мы эти группы не сможем обработать
	// 2. Удалим поля отбора, отличающиеся по виду от <Поле ВидСравнения Константа>, т.к. только их можем обработать вне СКД
	// 3. Поменяем порядок полей, для того, чтобы порядок группировок в расшифровываемом отчете 
	//    соответствовал порядку расшифровок в исходном отчете (в массиве полей он почему-то обычно "кверх-ногами")
	НовыйМассивПолей = Новый Массив();
	КоличествоПолей  = МассивПолей.Количество();
	Для НомерПоля = 1 По КоличествоПолей Цикл
		
		Поле = МассивПолей[КоличествоПолей - НомерПоля];
		
		Если ТипЗнч(Поле) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Поле) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Если ТипЗнч(Поле.ЛевоеЗначение) <> Тип("ПолеКомпоновкиДанных") 
			ИЛИ ТипЗнч(Поле.ПравоеЗначение) = Тип("ПолеКомпоновкиДанных") 
			ИЛИ Поле.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено 
			ИЛИ Поле.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		НовыйМассивПолей.Добавить(Поле);
		
	КонецЦикла;
	
	Возврат НовыйМассивПолей;
	
КонецФункции

// Получает список ресурсов, которые расшифровываются
Функция ПолучитьРесурсыРасшифровки(Расшифровка, ДанныеРасшифровки)
	
	// Подготовим список ресурсов
	ПоляРасшифровки = ТиповыеОтчеты.ПолучитьМассивПолейРасшифровки(
		Расшифровка, 
		ДанныеРасшифровки,
		,
		Истина // в массиве будут и ресурсы
		);
	Ресурсы = Новый Массив;
	Для Каждого ПолеРасшифровки Из ПоляРасшифровки Цикл
		
		// Ресурсами могут быть только поля расшифровки
		Если ТипЗнч(ПолеРасшифровки) <> Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Поле = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы.Найти(ПолеРасшифровки.Поле);
		Если Поле <> Неопределено И Поле.Ресурс И НЕ Поле.Папка Тогда
			Ресурсы.Добавить(ПолеРасшифровки.Поле);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ресурсы;
	
КонецФункции

// ОБЩИЕ МЕТОДЫ РАБОТЫ С ОТЧЕТАМИ

// Запрашивает у пользователя дату начала расшифровки
Функция ВвестиДатуНачала()
	
	// Запросим дату начала
	//"Дата начала расшифров" - помещается
	//"Расшифровать, начиная с"
	Возврат ВвестиДату(ДатаНачалаРасшифровки, "Расшифровать с даты", ЧастиДаты.Дата);
	
КонецФункции

// Возвращает дату окончания периода расшифровки
Функция ПолучитьДатуОкончания(Форма)
	
	Дата = Форма.СтандартнаяДатаНачала;
	Если Дата = '0001-01-01' Тогда
		Возврат Дата;
	Иначе
		Возврат НачалоДня(Дата) - 1;
	КонецЕсли;
	
КонецФункции

// Удаляет все элементы отбора
Процедура ОчиститьОтбор(Отбор)
	
	КоличествоЭлементов = Отбор.Количество();
	Для НомерЭлемента = 1 По КоличествоЭлементов Цикл
		Отбор.Удалить(КоличествоЭлементов - НомерЭлемента);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьОтборПоЗначениюРасшифровки(Отбор, ПоляРасшифровки, ИмяОтбора, ИмяРасшифровки)
	
	ЭлементОтбора = Отбор.Добавить(ИмяОтбора);
	Иерархия      = Ложь;
	Значение      = ЗначениеРасшифровки(ПоляРасшифровки, ИмяРасшифровки, Иерархия);
	Если ЗначениеЗаполнено(Значение) Тогда
		ЭлементОтбора.Установить(Значение);
	
		Если Иерархия Тогда
			ЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОтборПоПолюРасшифровки(ПолеРасшифровки, Отбор, ИмяОтбора)
	
	// Опишем соответствие видов сравнения Компоновки и Построителя
	ВидСравненияПостроителя = Новый Соответствие;
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.Больше,              ВидСравнения.Больше);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.БольшеИлиРавно,      ВидСравнения.БольшеИлиРавно);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.ВИерархии,           ВидСравнения.ВИерархии);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.ВСписке,             ВидСравнения.ВСписке);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии,   ВидСравнения.ВСпискеПоИерархии);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.Меньше,              ВидСравнения.Меньше);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,      ВидСравнения.МеньшеИлиРавно);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.НеВИерархии,         ВидСравнения.НеВИерархии);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.НеВСписке,           ВидСравнения.НеВСписке);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии, ВидСравнения.НеВСпискеПоИерархии);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.НеРавно,             ВидСравнения.НеРавно);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.НеСодержит,          ВидСравнения.НеСодержит);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.Равно,               ВидСравнения.Равно);
	ВидСравненияПостроителя.Вставить(ВидСравненияКомпоновкиДанных.Содержит,            ВидСравнения.Содержит);

	// Добавим отбор
	ЭлементОтбора = Отбор.Добавить(ИмяОтбора);
	Если ТипЗнч(ПолеРасшифровки) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
		Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
			ЭлементОтбора.Установить(ПолеРасшифровки.Значение);
			Если ПолеРасшифровки.Иерархия Тогда
				ЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ПолеРасшифровки) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ЭлементОтбора.ВидСравнения = ВидСравненияПостроителя[ПолеРасшифровки.ВидСравнения];
		ЭлементОтбора.Значение     = ПолеРасшифровки.ПравоеЗначение;
		ЭлементОтбора.Использование= Истина;
	КонецЕсли;
	
КонецПроцедуры

// Определяет имя поля в отчете расшифровки по пути к данным в поле схемы компоновки
// Если поле "сложное" (через точку), то будет возвращено поле, соответствующее имени реквизита регистра.
//
// Параметры:
//  ПолеРасшифровки - поле, которому нужно найти соответствие, 
//                    тип: ЭлементОтбораКомпоновкиДанных или ЗначениеПоляРасшифровкиКомпоновкиДанных
//  ИмяРегистра - имя регистра, в котором ищем реквизит, соответствующий полю расшифровки
//  ПостроительОтчета - в котором ищем поле
//  ПутьКДанным - в параметр будет возвращено имя поля, соответствующее переданному полю построителя
//
// Возвращаемое значение:
//  Имя поля в отчете расшифровки (имя реквизита регистра)
Функция ПолучитьИмяПоляОтчетаРасшифровки(ПолеРасшифровки, ИмяРегистра, ПутьКДанным = "")
	
	Если ТипЗнч(ПолеРасшифровки) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ИмяПоля = "" + ПолеРасшифровки.ЛевоеЗначение;
	Иначе
		ИмяПоля = ПолеРасшифровки.Поле;
	КонецЕсли;
	
	ПозицияТочки = Найти(ИмяПоля, ".");
	Если ПозицияТочки > 1 Тогда
		ИмяРеквизита = Лев(ИмяПоля, ПозицияТочки - 1);
		ПослеТочки   = Сред(ИмяПоля, ПозицияТочки + 1);
	Иначе
		ИмяРеквизита = ИмяПоля;
		ПослеТочки   = "";
	КонецЕсли;	
	
	ИмяВРегистре = ПолучитьИмяПоляРегистра(ИмяРеквизита, ИмяРегистра);
	
	ПутьКДанным = ИмяВРегистре + ?(ПустаяСтрока(ПослеТочки), "", ".") + ПослеТочки;
	
	Возврат ИмяВРегистре;
	
КонецФункции

// Определяет значение в расшифровке по имени поля
Функция ЗначениеРасшифровки(ПоляРасшифровки, ИмяПоля, Иерархия = Ложь)
	
	Для Каждого ПолеРасшифровки Из ПоляРасшифровки Цикл
		
		// Обрабатываем поля расшифровки
		Если ТипЗнч(ПолеРасшифровки) <> Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПолеРасшифровки.Поле = ИмяПоля Тогда
			Иерархия = ПолеРасшифровки.Иерархия;
			Возврат ПолеРасшифровки.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// МЕТОДЫ РАБОТЫ С ТАБЛИЦЕЙ ИМЕН ПОЛЕЙ
// Нужны для того, чтобы обрабатывать преобразование имен полей в схеме компоновки
// в имена реквизитов регистров, по которым выполняется расшифровка.

// Получает имя реквизита регистра по имени поля в СКД
Функция ПолучитьИмяПоляРегистра(ИмяПоля, ИмяРегистра)
	
	ТаблицаИмен = ТаблицаИменПолей();
	Строки = ТаблицаИмен.НайтиСтроки(Новый Структура("Компоновка,ИмяРегистра", ИмяПоля, ИмяРегистра));
	Если Строки.Количество() = 0 Тогда
		Возврат ИмяПоля;
	Иначе
		Возврат Строки[0].Регистр;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаИменПолей()
	
	ТаблицаИмен = Новый ТаблицаЗначений();
	ТаблицаИмен.Колонки.Добавить("Компоновка");
	ТаблицаИмен.Колонки.Добавить("Регистр");
	ТаблицаИмен.Колонки.Добавить("ИмяРегистра");
	
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "ДоговорКонтрагента", "Договоры",    "Хозрасчетный");
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "Контрагент",         "Контрагенты", "Хозрасчетный");
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "Контрагент",         "Покупатель",  "НДС");
	
	// РасчетыПоРеализацииВУсловныхЕдиницахОрганизации
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "ДокументРасчетов", "Документ",   "РасчетыПоРеализацииВУсловныхЕдиницахОрганизации");
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "СчетРасчетов",     "СчетОплаты", "РасчетыПоРеализацииВУсловныхЕдиницахОрганизации");
	
	// РасчетыПоПриобретениюВУсловныхЕдиницахОрганизации
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "ДокументРасчетов", "Документ",   "РасчетыПоПриобретениюВУсловныхЕдиницахОрганизации");
	ДобавитьВТаблицуИменПолей(ТаблицаИмен, "СчетРасчетов",     "СчетОплаты", "РасчетыПоПриобретениюВУсловныхЕдиницахОрганизации");
	
	Возврат ТаблицаИмен;
	
КонецФункции

Функция ДобавитьВТаблицуИменПолей(Таблица, Компоновка, Регистр, ИмяРегистра)
	
	Строка = Таблица.Добавить();
	Строка.Компоновка  = Компоновка;
	Строка.Регистр     = Регистр;
	Строка.ИмяРегистра = ИмяРегистра;
	
КонецФункции

//
//  ОСОБЕННОСТИ ОТЧЕТА РасхожденияДанныхПоВзаиморасчетам
//
////////////////////////////////////////////////////////////	
#КонецЕсли

Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;
