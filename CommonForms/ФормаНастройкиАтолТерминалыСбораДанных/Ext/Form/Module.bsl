﻿
// Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Параметры.Свойство("ДрайверОборудования", ДрайверОборудования);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	ЦветОшибки = ЦветаСтиля.ЦветОтрицательногоЧисла;

	СписокМодель = Элементы.Модель.СписокВыбора;
	СписокМодель.Добавить("0"     , НСтр("ru='Zebex PDL-20'"));
	СписокМодель.Добавить("00"    , НСтр("ru='Zebex PDC-10'"));
	СписокМодель.Добавить("000"   , НСтр("ru='Zebex PDL-10'"));
	СписокМодель.Добавить("0000"  , НСтр("ru='Zebex PDW-10'"));
	СписокМодель.Добавить("00000" , НСтр("ru='Zebex PDM-10'"));
	СписокМодель.Добавить("000000", НСтр("ru='Zebex PDT-10'"));
	СписокМодель.Добавить("1"  , НСтр("ru='Zebex Z-1050 (АТОЛ технологии)'"));
	СписокМодель.Добавить("3"  , НСтр("ru='Cipher CPT-711 (соединение с ПК через кабель)'"));
	СписокМодель.Добавить("03" , НСтр("ru='Cipher CPT-720 (соединение с ПК через кабель)'"));
	СписокМодель.Добавить("003", НСтр("ru='Cipher CPT-8300 (соединение с ПК через кабель)'"));
	СписокМодель.Добавить("4"  , НСтр("ru='Cipher CPT-800х (соединение с ПК через IR подставку)'"));
	СписокМодель.Добавить("04" , НСтр("ru='Cipher CPT-8300 (соединение с ПК через IR подставку)'"));
	СписокМодель.Добавить("5"  , НСтр("ru='Cipher CPT-3510 для серии CPT-8x1x'"));
	СписокМодель.Добавить("6"  , НСтр("ru='Zebex Z-2030'"));
	СписокМодель.Добавить("7"  , НСтр("ru='Терминалы с ОС WinCE/PocketPC/Windows Mobile и установленным ПО АТОЛ: Mobile Logistics'"));
	СписокМодель.Добавить("07" , НСтр("ru='Терминалы Symbol SPT-1800 с установленным ПО АТОЛ:Mobile Logistics'"));
	СписокМодель.Добавить("007", НСтр("ru='Терминалы Symbol SPT-1550 с установленным ПО АТОЛ:Mobile Logistics'"));
	СписокМодель.Добавить("8"  , НСтр("ru='Cipher CPT-8x00 (соединение с ПК через подставку)'"));
	СписокМодель.Добавить("9"  , НСтр("ru='Casio DT-900/DT-930'"));
	СписокМодель.Добавить("09" , НСтр("ru='Cipher CPT-800x/8300 (соединение с ПК через провод)'"));
	СписокМодель.Добавить("10" , НСтр("ru='MobileLogistics 4.x'"));
	
	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(1,     "300 бод");
	СписокСкорость.Добавить(2,     "600 бод");
	СписокСкорость.Добавить(3,    "1200 бод");
	СписокСкорость.Добавить(4,    "2400 бод");
	СписокСкорость.Добавить(5,    "4800 бод");
	СписокСкорость.Добавить(7,    "9600 бод");
	СписокСкорость.Добавить(10,  "19200 бод");
	СписокСкорость.Добавить(12,  "38400 бод");
	СписокСкорость.Добавить(14,  "57600 бод");
	СписокСкорость.Добавить(18, "115200 бод");
	
	СписокЧетность = Элементы.Четность.СписокВыбора;
	СписокЧетность.Добавить(0, "Нет");
	СписокЧетность.Добавить(1, "Нечетность");
	СписокЧетность.Добавить(2, "Четность");
	СписокЧетность.Добавить(3, "Установлен");
	СписокЧетность.Добавить(4, "Сброшен");
	
	СписокБитыДанных = Элементы.БитыДанных.СписокВыбора;
	СписокБитыДанных.Добавить(3, "7 бит");
	СписокБитыДанных.Добавить(4, "8 бит");
	
	СписокСтопБиты = Элементы.СтопБиты.СписокВыбора;
	СписокСтопБиты.Добавить(0, "1 бит");
	СписокСтопБиты.Добавить(2, "2 бита");
	
	времПорт            = Неопределено;
	времСкорость        = Неопределено;
	времIPПорт          = Неопределено;
	времЧетность        = Неопределено;
	времБитыДанных      = Неопределено;
	времСтопБиты        = Неопределено;
	времТаблицаВыгрузки = Неопределено;
	времТаблицаЗагрузки = Неопределено;
	времРазделитель     = Неопределено;
	времФорматВыгрузки  = Неопределено;
	времФорматЗагрузки  = Неопределено;
	времМодель          = Неопределено;
	времНаименование    = Неопределено;

	Параметры.ПараметрыОборудования.Свойство("Порт"           , времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость"       , времСкорость);
	Параметры.ПараметрыОборудования.Свойство("IPПорт"         , времIPПорт);
	Параметры.ПараметрыОборудования.Свойство("Четность"       , времЧетность);
	Параметры.ПараметрыОборудования.Свойство("БитыДанных"     , времБитыДанных);
	Параметры.ПараметрыОборудования.Свойство("СтопБиты"       , времСтопБиты);
	Параметры.ПараметрыОборудования.Свойство("ТаблицаВыгрузки", времТаблицаВыгрузки);
	Параметры.ПараметрыОборудования.Свойство("ТаблицаЗагрузки", времТаблицаЗагрузки);
	Параметры.ПараметрыОборудования.Свойство("Разделитель"    , времРазделитель);
	Параметры.ПараметрыОборудования.Свойство("ФорматВыгрузки" , времФорматВыгрузки);
	Параметры.ПараметрыОборудования.Свойство("ФорматЗагрузки" , времФорматЗагрузки);
	Параметры.ПараметрыОборудования.Свойство("Модель"         , времМодель);
	Параметры.ПараметрыОборудования.Свойство("Наименование"   , времНаименование);
	
	Порт            = ?(времПорт            = Неопределено, 1, времПорт);
	Скорость        = ?(времСкорость        = Неопределено, 7, времСкорость);
	IPПорт          = ?(времIPПорт          = Неопределено, 0, времIPПорт);
	Четность        = ?(времЧетность        = Неопределено, 0, времЧетность);
	БитыДанных      = ?(времБитыДанных      = Неопределено, 4, времБитыДанных);
	СтопБиты        = ?(времСтопБиты        = Неопределено, 0, времСтопБиты);
	ТаблицаВыгрузки = ?(времТаблицаВыгрузки = Неопределено, 0, времТаблицаВыгрузки);
	ТаблицаЗагрузки = ?(времТаблицаЗагрузки = Неопределено, 0, времТаблицаЗагрузки);
	Разделитель     = ?(времРазделитель     = Неопределено, 0, времРазделитель);

	Если времФорматВыгрузки <> Неопределено Тогда
		Для Каждого СтрокаБазы Из времФорматВыгрузки Цикл
			СтрокаТаблицы = ФорматВыгрузки.Добавить();
			СтрокаТаблицы.НомерПоля    = СтрокаБазы.НомерПоля;
			СтрокаТаблицы.Наименование = СтрокаБазы.Наименование;
		КонецЦикла;
	КонецЕсли;

	Если времФорматЗагрузки <> Неопределено Тогда
		Для Каждого СтрокаДокумента Из времФорматЗагрузки Цикл
			СтрокаТаблицы = ФорматЗагрузки.Добавить();
			СтрокаТаблицы.НомерПоля    = СтрокаДокумента.НомерПоля;
			СтрокаТаблицы.Наименование = СтрокаДокумента.Наименование;
		КонецЦикла;
	КонецЕсли;

	Модель       = ?(времМодель       = Неопределено, Элементы.Модель.СписокВыбора[0].Значение     , времМодель);
	Наименование = ?(времНаименование = Неопределено, Элементы.Модель.СписокВыбора[0].Представление, времНаименование);
	
	Элементы.ТестУстройства.Видимость    = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	Элементы.УстановитьДрайвер.Видимость = (ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформациюОДрайвере();
	ОбновитьДоступныеПорты();
	
КонецПроцедуры

// КонецОбласти

// Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МодельПриИзменении(Элемент)
	
	ОбновитьДоступныеПорты();
	
КонецПроцедуры

&НаКлиенте
Процедура РазделительПриИзменении(Элемент)
	
	СимволРазделителя = Символ(Разделитель);
	
КонецПроцедуры

&НаКлиенте
Процедура СимволРазделителяПриИзменении(Элемент)
	
	Разделитель = КодСимвола(СимволРазделителя);
	
КонецПроцедуры

// КонецОбласти

// Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"            , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"        , Скорость);
	НовыеЗначениеПараметров.Вставить("IPПорт"          , IPПорт);
	НовыеЗначениеПараметров.Вставить("Четность"        , Четность);
	НовыеЗначениеПараметров.Вставить("БитыДанных"      , БитыДанных);
	НовыеЗначениеПараметров.Вставить("СтопБиты"        , СтопБиты);
	НовыеЗначениеПараметров.Вставить("ТаблицаВыгрузки" , ТаблицаВыгрузки);
	НовыеЗначениеПараметров.Вставить("ТаблицаЗагрузки" , ТаблицаЗагрузки);
	НовыеЗначениеПараметров.Вставить("Разделитель"     , Разделитель);
	НовыеЗначениеПараметров.Вставить("Модель"          , Модель);
	НовыеЗначениеПараметров.Вставить("Наименование"    , Наименование);
	
	времФорматВыгрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматВыгрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование", СтрокаТаблицы.НомерПоля, СтрокаТаблицы.Наименование);
		времФорматВыгрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	НовыеЗначениеПараметров.Вставить("ФорматВыгрузки", времФорматВыгрузки);
	
	времФорматЗагрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматЗагрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование", СтрокаТаблицы.НомерПоля, СтрокаТаблицы.Наименование);
		времФорматЗагрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	НовыеЗначениеПараметров.Вставить("ФорматЗагрузки", времФорматЗагрузки);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("IPПорт"         , IPПорт);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("ТаблицаВыгрузки", ТаблицаВыгрузки);
	времПараметрыУстройства.Вставить("ТаблицаЗагрузки", ТаблицаЗагрузки);
	времПараметрыУстройства.Вставить("Разделитель"    , Разделитель);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("Наименование"   , Наименование);

	времФорматВыгрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматВыгрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование", СтрокаТаблицы.НомерПоля, СтрокаТаблицы.Наименование);
		времФорматВыгрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматВыгрузки", времФорматВыгрузки);

	времФорматЗагрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматЗагрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование", СтрокаТаблицы.НомерПоля, СтрокаТаблицы.Наименование);
		времФорматЗагрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматЗагрузки", времФорматЗагрузки);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		                           И ВыходныеПараметры.Количество() >= 2,
		                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1], "");
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановкаДрайвераЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		АдресЗагрузкиДрайвера = "http://www.atol.ru/link/cat/7/";
		ПерейтиПоНавигационнойСсылке(АдресЗагрузкиДрайвера);
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	Текст = НСтр("ru = 'Установка производиться средствами дистрибутива поставщика.
		|Перейти на сайт поставщика для скачивания?'");
	Оповещение = ОписаниеОповещенияЕГАИС("УстановкаДрайвераЗавершение",  ЭтаФорма);
	ПоказатьВопросЕГАИС(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// КонецОбласти

// Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"           , Порт);
	времПараметрыУстройства.Вставить("Скорость"       , Скорость);
	времПараметрыУстройства.Вставить("IPПорт"         , IPПорт);
	времПараметрыУстройства.Вставить("Четность"       , Четность);
	времПараметрыУстройства.Вставить("БитыДанных"     , БитыДанных);
	времПараметрыУстройства.Вставить("СтопБиты"       , СтопБиты);
	времПараметрыУстройства.Вставить("ТаблицаВыгрузки", ТаблицаВыгрузки);
	времПараметрыУстройства.Вставить("ТаблицаЗагрузки", ТаблицаЗагрузки);
	времПараметрыУстройства.Вставить("Разделитель"    , Разделитель);
	времПараметрыУстройства.Вставить("Модель"         , Модель);
	времПараметрыУстройства.Вставить("Наименование"   , Наименование);

	времФорматВыгрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматВыгрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматВыгрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматВыгрузки", времФорматВыгрузки);

	времФорматЗагрузки = Новый Массив();
	Для Каждого СтрокаТаблицы Из ФорматЗагрузки Цикл
		НоваяСтрока = Новый Структура("НомерПоля, Наименование",
		                              СтрокаТаблицы.НомерПоля,
		                              СтрокаТаблицы.Наименование);
		времФорматЗагрузки.Добавить(НоваяСтрока);
	КонецЦикла;
	времПараметрыУстройства.Вставить("ФорматЗагрузки", времФорматЗагрузки);

	Если МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ПолучитьВерсиюДрайвера",
	                                                               ВходныеПараметры,
	                                                               ВыходныеПараметры,
	                                                               Идентификатор,
	                                                               времПараметрыУстройства) Тогда
		Драйвер = ВыходныеПараметры[0];
		Версия  = ВыходныеПараметры[1];
	Иначе
		Драйвер = ВыходныеПараметры[2];
		Версия  = НСтр("ru='Не определена'");
	КонецЕсли;

	Элементы.Драйвер.ЦветТекста = ?(Драйвер = НСтр("ru='Не установлен'"), ЦветОшибки, ЦветТекста);
	Элементы.Версия.ЦветТекста  = ?(Версия  = НСтр("ru='Не определена'"), ЦветОшибки, ЦветТекста);

	Элементы.УстановитьДрайвер.Доступность = Не (Драйвер = НСтр("ru='Установлен'"));

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступныеПорты()

	Элементы.Порт.СписокВыбора.Очистить();
	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Индекс = 1 По 64 Цикл
		СписокПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;

	Если Число(Модель) = 7 Тогда
		СписокПорт.Добавить(65,  "USB");
		СписокПорт.Добавить(101, "TCP/IP");
		СписокПорт.Добавить(102, "IRComm (клиент)");
	ИначеЕсли Число(Модель) = 9 Тогда
		СписокПорт.Добавить(103, "IRComm (сервер)");
	ИначеЕсли Число(Модель) = 10 Тогда
		СписокПорт.Добавить(65,  "USB");
		СписокПорт.Добавить(101, "TCP/IP");
		СписокПорт.Добавить(102, "IRComm (клиент)");
		СписокПорт.Добавить(103, "IRComm (сервер)");
	КонецЕсли;

	Если СписокПорт.НайтиПоЗначению(Порт) = Неопределено Тогда
		Порт = 1;
	КонецЕсли;

КонецПроцедуры

// КонецОбласти