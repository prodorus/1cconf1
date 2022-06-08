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

	СписокПорт = Элементы.Порт.СписокВыбора;
	Для Индекс = 1 По 64 Цикл
		СписокПорт.Добавить(Индекс, "COM" + СокрЛП(Индекс));
	КонецЦикла;

	СписокСкорость = Элементы.Скорость.СписокВыбора;
	СписокСкорость.Добавить(110,    "110");
	СписокСкорость.Добавить(300,    "300");
	СписокСкорость.Добавить(600,    "600");
	СписокСкорость.Добавить(1200,   "1200");
	СписокСкорость.Добавить(2400,   "2400");
	СписокСкорость.Добавить(4800,   "4800");
	СписокСкорость.Добавить(9600,   "9600");
	СписокСкорость.Добавить(14400,  "14400");
	СписокСкорость.Добавить(19200,  "19200");
	СписокСкорость.Добавить(38400,  "38400");
	СписокСкорость.Добавить(56000,  "56000");
	СписокСкорость.Добавить(57600,  "57600");
	СписокСкорость.Добавить(115200, "115200");
	СписокСкорость.Добавить(128000, "128000");
	СписокСкорость.Добавить(256000, "256000");
	
	СписокБитДанных = Элементы.БитДанных.СписокВыбора;
	Для Индекс = 1 По 8 Цикл
		СписокБитДанных.Добавить(Индекс, СокрЛП(Индекс));
	КонецЦикла;
	
	СписокСтопБит = Элементы.СтопБит.СписокВыбора;
	СписокСтопБит.Добавить(0, НСтр("ru='1 стоп-бит'"));
	СписокСтопБит.Добавить(1, НСтр("ru='1.5 стоп-бита'"));
	СписокСтопБит.Добавить(2, НСтр("ru='2 стоп-бита'"));
	
	СписокСуффикс = Элементы.Суффикс.СписокВыбора;
	СписокСуффикс.Добавить(8,  "(8) BS");
	СписокСуффикс.Добавить(9,  "(9) TAB");
	СписокСуффикс.Добавить(10, "(10) LF");
	СписокСуффикс.Добавить(13, "(13) CR");

	времПорт      = Неопределено;
	времСкорость  = Неопределено;
	времБитДанных = Неопределено;
	времСтопБит   = Неопределено;
	времПрефикс   = Неопределено;
	времСуффикс   = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("Порт",      времПорт);
	Параметры.ПараметрыОборудования.Свойство("Скорость",  времСкорость);
	Параметры.ПараметрыОборудования.Свойство("БитДанных", времБитДанных);
	Параметры.ПараметрыОборудования.Свойство("СтопБит",   времСтопБит);
	Параметры.ПараметрыОборудования.Свойство("Префикс",   времПрефикс);
	Параметры.ПараметрыОборудования.Свойство("Суффикс",   времСуффикс);
	
	Порт        = ?(времПорт      = Неопределено,         1, времПорт);
	Скорость    = ?(времСкорость  = Неопределено,      9600, времСкорость);
	БитДанных   = ?(времБитДанных = Неопределено,         8, времБитДанных);
	СтопБит     = ?(времСтопБит   = Неопределено,         0, времСтопБит);
	Префикс     = ?(времПрефикс   = Неопределено,         0, времПрефикс);
	Суффикс     = ?(времСуффикс   = Неопределено,        13, времСуффикс);
	
	АктивноеРабочееМесто = ПараметрыСеанса.РабочееМестоКлиента = Идентификатор.РабочееМесто;
	Элементы.ТестУстройства.Видимость          = АктивноеРабочееМесто;
	Элементы.УстановитьДрайвер.Видимость       = АктивноеРабочееМесто;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьИнформациюОДрайвере();
	
	ПрефиксПриИзменении();
	
	ПортПриИзменении();
	
КонецПроцедуры

// КонецОбласти

// Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрефиксПриИзменении1(Элемент)

	ПрефиксПриИзменении();

КонецПроцедуры

&НаКлиенте
Процедура КодПрефиксаПриИзменении1(Элемент)

	КодПрефиксаПриИзменении();

КонецПроцедуры

&НаКлиенте
Процедура ПортПриИзменении()

	Элементы.Скорость.Доступность  = (Порт <> 101);
	Элементы.БитДанных.Доступность = (Порт <> 101);
	Элементы.СтопБит.Доступность   = (Порт <> 101);

КонецПроцедуры

&НаКлиенте
Процедура ПрефиксПриИзменении()
	
	КодПрефикса = ?(ПустаяСтрока(Префикс), 0 , КодСимвола(Префикс));
	
КонецПроцедуры

&НаКлиенте
Процедура КодПрефиксаПриИзменении()
	
	Префикс = Символ(КодПрефикса);
	
КонецПроцедуры

// КонецОбласти

// Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("Порт"        , Порт);
	НовыеЗначениеПараметров.Вставить("Скорость"    , Скорость);
	НовыеЗначениеПараметров.Вставить("БитДанных"   , БитДанных);
	НовыеЗначениеПараметров.Вставить("СтопБит"     , СтопБит);
	НовыеЗначениеПараметров.Вставить("Префикс"     , Префикс);
	НовыеЗначениеПараметров.Вставить("Суффикс"     , Суффикс);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", Идентификатор);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Скорость" , Скорость);
	времПараметрыУстройства.Вставить("БитДанных", БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"  , СтопБит);
	времПараметрыУстройства.Вставить("Префикс"  , КодПрефикса);
	времПараметрыУстройства.Вставить("Суффикс"  , Суффикс);
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("CheckHealth",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Код ошибки:'") + ВыходныеПараметры[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
	ОбновитьИнформациюОДрайвере();
	
КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайверИзДистрибутиваПриЗавершении(Результат, Параметры) Экспорт 
	
	Если Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Установка драйвера завершена.'")); 
		ОбновитьИнформациюОДрайвере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При установке драйвера из дистрибутива произошла ошибка.'")); 
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьДрайвер(Команда)

	ОчиститьСообщения();
	ОповещенияДрайверИзДистрибутиваПриЗавершении = ОписаниеОповещенияЕГАИС("УстановитьДрайверИзДистрибутиваПриЗавершении", ЭтаФорма);
	ОповещенияДрайверИзАрхиваПриЗавершении = ОписаниеОповещенияЕГАИС("УстановитьДрайверИзАрхиваПриЗавершении", ЭтаФорма);
	МенеджерОборудованияКлиент.УстановитьДрайвер(ДрайверОборудования, ОповещенияДрайверИзДистрибутиваПриЗавершении, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

// КонецОбласти

// Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьИнформациюОДрайвере()

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("Порт"     , Порт);
	времПараметрыУстройства.Вставить("Скорость" , Скорость);
	времПараметрыУстройства.Вставить("БитДанных", БитДанных);
	времПараметрыУстройства.Вставить("СтопБит"  , СтопБит);
	времПараметрыУстройства.Вставить("Префикс"  , КодПрефикса);
	времПараметрыУстройства.Вставить("Суффикс"  , Суффикс);
	
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

// КонецОбласти