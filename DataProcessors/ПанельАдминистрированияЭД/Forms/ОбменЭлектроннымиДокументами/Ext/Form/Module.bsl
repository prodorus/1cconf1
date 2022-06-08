﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ПолучитьСтруктуруНабораКонстантЭД(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ПолучитьСтруктуруРодительскихКонстантЭД(СоставНабораКонстантФормы);
	РежимРаботы                  = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьЭлектронныеЦифровыеПодписи");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия"               , 
						ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске
	Элементы.ГруппаИспользоватьЭлектронныеЦифровыеПодписи.Видимость        = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаОткрытьНастройкиОбменаЭлектроннымиДокументами.Видимость = НЕ РежимРаботы.БазоваяВерсия;
	Элементы.ГруппаИспользоватьОбменЭДМеждуОрганизациями.Видимость         = НЕ РежимРаботы.БазоваяВерсия;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	УстановитьВидимость();
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		Или ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Элементы.ГруппаНастройкиРегламентногоЗадания.Видимость = Ложь;
		Элементы.ГруппаОповещенияЭДО.Видимость = Ложь;
		
	Иначе
		
		УстановитьНастройкиЗаданий();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
			И ПолучитьОбщиеКлючиСтруктурЭД(Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ИспользоватьОбменЭДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЭлектронныеЦифровыеПодписиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбменЭДМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьНемедленнуюОтправкуЭДПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОзнакомлениеСЭлектроннымиДокументамиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическуюОтправкуЭДПриИзменении(Элемент)
	
	ИзменитьИспользованиеЗадания("ОтправкаОформленныхЭД", ИспользоватьАвтоматическуюОтправкуЭД);
	
	Элементы.ОтправкаОформленныхЭД.Доступность = ИспользоватьАвтоматическуюОтправкуЭД;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьАвтоматическоеПолучениеЭДПриИзменении(Элемент)
	
	ИзменитьИспользованиеЗадания("ПолучениеНовыхЭД", ИспользоватьАвтоматическоеПолучениеЭД);
	
	Элементы.ПолучениеНовыхЭД.Доступность = ИспользоватьАвтоматическоеПолучениеЭД;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьНастройкиПрофилейЭДО(Команда)
	ОткрытьФорму("Справочник.ПрофилиНастроекЭДО.Форма.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСоглашенияОбИспользованииЭД(Команда)
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.Форма.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиОбменаЭлектроннымиДокументами(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкаКриптографии", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКСервису1СТакском(Команда)
	ЭлектронныеДокументыКлиент.ПомощникПодключенияКСервису1СТакском();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПорталу1СЭДО(Команда)
	ЭлектронныеДокументыКлиент.ПомощникПодключенияКСервису1СЭДО();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПомощникПодключенияКПрямомуОбмену(Команда)
	ЭлектронныеДокументыКлиент.ПомощникПодключенияКПрямомуОбмену();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтправкуЭД(Команда)
	
	Если РасписаниеОтправкиЭД = Неопределено Тогда
		РасписаниеОтправкиЭД = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеОтправкиЭД);
		
	Если Диалог.ОткрытьМодально() Тогда
		РасписаниеОтправкиЭД = Диалог.Расписание;
	КонецЕсли;
	
	ИзменитьРасписаниеЗадания("ОтправкаОформленныхЭД", РасписаниеОтправкиЭД);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПолучениеЭД(Команда)
	
	Если РасписаниеПолученияЭД = Неопределено Тогда
		РасписаниеПолученияЭД = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеПолученияЭД);
		
	Если Диалог.ОткрытьМодально() Тогда
		РасписаниеПолученияЭД = Диалог.Расписание;
	КонецЕсли;

	ИзменитьРасписаниеЗадания("ПолучениеНовыхЭД", РасписаниеПолученияЭД);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если Результат.Свойство("ОповещениеФорм") Тогда
		Оповестить(Результат.ОповещениеФорм.ИмяСобытия, Результат.ОповещениеФорм.Параметр, Результат.ОповещениеФорм.Источник);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

// Константы

&НаКлиенте
// Возвращает структуру, содержащую ключи, имеющиеся в обеих исходных структурах.
//
Функция ПолучитьОбщиеКлючиСтруктурЭД(Структура1, Структура2)
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Структура1 Цикл
		Если Структура2.Свойство(КлючИЗначение.Ключ) Тогда
			Результат.Вставить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	УстановитьВидимость(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	РегЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания[ИмяЗадания]);
	РегЗадание.Расписание = РасписаниеРегламентногоЗадания;
	РегЗадание.Записать();
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстЗаголовка, ТекстРасписания, РасписаниеАктивно;
	
	ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстЗаголовка, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстЗаголовка, ТекстРасписания, РасписаниеАктивно) Экспорт
	
	РасписаниеАктивно = Ложь;
	
	ТекстЗаголовка = "Дополнительные настройки расписания ...";
	
	Если Задание = Неопределено Тогда
		
		//ТекстЗаголовка = "Создать регламентную настройку ...";
		ТекстРасписания = "<Расписание не задано>";
		
	Иначе
		
		//ТекстЗаголовка = "Дополнительные настройки расписания ...";
		Если Задание.Использование Тогда
			ПрефиксРасписания = "Расписание: ";
			РасписаниеАктивно = Истина;
		Иначе
			ПрефиксРасписания = "Расписание (НЕ АКТИВНО): ";
		КонецЕсли;
		
		ТекстРасписания = ПрефиксРасписания + Строка(Задание.Расписание);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	РегЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания[ИмяЗадания]);
	РегЗадание.Использование = Использование;
	РегЗадание.Записать();
	
	Элемент = Элементы[ИмяЗадания];
	
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент)
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Устанавливаем флаг "ИспользоватьАвтоматическуюОтправкуЭД"
	ЗаданиеОтправкаЭД = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОтправкаОформленныхЭД);
	ИспользоватьАвтоматическуюОтправкуЭД = ЗаданиеОтправкаЭД.Использование;
	РасписаниеОтправкиЭД = ЗаданиеОтправкаЭД.Расписание;
	Элементы.ОтправкаОформленныхЭД.Доступность = ИспользоватьАвтоматическуюОтправкуЭД;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОтправкаЭД, Элементы.ОтправкаОформленныхЭД);
	
	// Устанавливаем флаг "ИспользоватьАвтоматическоеПолучениеЭД"
	ЗаданиеПолучениеЭД = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ПолучениеНовыхЭД);
	ИспользоватьАвтоматическоеПолучениеЭД = ЗаданиеПолучениеЭД.Использование;
	РасписаниеПолученияЭД = ЗаданиеПолучениеЭД.Расписание;
	Элементы.ПолучениеНовыхЭД.Доступность = ИспользоватьАвтоматическоеПолучениеЭД;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеПолучениеЭД, Элементы.ПолучениеНовыхЭД);
	
	// Устанавливаем флаг "Оповещать о событиях ЭДО"
	УстановитьНастройкуОповещенияОСобытияхЭДО();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкуОповещенияОСобытияхЭДО()
	
	ЗаданиеНаличиеНовыхЭД = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.НаличиеНовыхЭД);
	ОповещатьОСобытияхЭДО = ЗаданиеНаличиеНовыхЭД.Использование;
	Если Не ЗаданиеНаличиеНовыхЭД.Расписание = Неопределено Тогда
		РасписаниеНовыхЭД = ЗаданиеНаличиеНовыхЭД.Расписание;
	КонецЕсли;
	Элементы.НаличиеНовыхЭД.Доступность = ОповещатьОСобытияхЭДО;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеНаличиеНовыхЭД, Элементы.НаличиеНовыхЭД);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ЕстьПодчиненныеКонстантыЭД(КонстантаИмя, КонстантаЗначение) Тогда
			УстановитьЗначенияЗависимыхКонстант(КонстантаИмя);
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
		ОповещениеФорм = Новый Структура(
			"ИмяСобытия, Параметр, Источник",
			"Запись_НаборКонстант", ПолучитьСтруктуруПодчиненныхКонстантЭД(КонстантаИмя), КонстантаИмя);
		Результат.Вставить("ОповещениеФорм", ОповещениеФорм);
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменЭД" Тогда
		
		Если Не КонстантаЗначение Тогда
			
			ИспользоватьАвтоматическуюОтправкуЭД = КонстантаЗначение;
			ИспользоватьАвтоматическоеПолучениеЭД = КонстантаЗначение;
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтправкаОформленныхЭД",  "Доступность", КонстантаЗначение);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПолучениеНовыхЭД",       "Доступность", КонстантаЗначение);
			
			ИзменитьИспользованиеЗадания("ПолучениеНовыхЭД", КонстантаЗначение);
			ИзменитьИспользованиеЗадания("ОтправкаОформленныхЭД", КонстантаЗначение);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбменЭД"
		ИЛИ РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		ИспользоватьОбменЭД = НаборКонстант.ИспользоватьОбменЭД;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьТиповыеСоглашенияОбИспользованииЭД",           "Доступность", ИспользоватьОбменЭД);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьСоглашенияОбИспользованииЭД", 				  "Доступность", ИспользоватьОбменЭД);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьОтложеннуюОтправкуЭлектронныхДокументов", "Доступность", ИспользоватьОбменЭД);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПомощникПодключенияКПрямомуОбмену",			  "Доступность", ИспользоватьОбменЭД);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьАвтоматическуюОтправкуЭД",        "Доступность", ИспользоватьОбменЭД);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьАвтоматическоеПолучениеЭД",       "Доступность", ИспользоватьОбменЭД);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОповещатьОСобытияхЭДО", "Доступность", ИспользоватьОбменЭД);
		
		ИспользоватьЭлектронныеЦифровыеПодписи = НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи;
		ВключеныЭДиЭП    = ИспользоватьОбменЭД И ИспользоватьЭлектронныеЦифровыеПодписи;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьНастройкиОбменаЭлектроннымиДокументами", 	  "Доступность", ВключеныЭДиЭП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьОбменЭДМеждуОрганизациями", 			  "Доступность", ВключеныЭДиЭП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПомощникПодключенияКСервису1СЭДО",			  "Доступность", ВключеныЭДиЭП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОткрытьПомощникПодключенияКСервису1СТакском",		  "Доступность", ВключеныЭДиЭП);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НастройкиЭлектроннойПодписиИШифрования",			  "Доступность", ВключеныЭДиЭП);
		
		ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ИспользоватьЭлектронныеПодписи", 			  "Доступность", ЭтоПолноправныйПользователь);
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		ИспользоватьЭлектронныеЦифровыеПодписи = НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи;
		ВидимостьЭлемента = Не ИспользоватьЭлектронныеЦифровыеПодписи;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаКомментарийОткрытьНастройкиОбменаЭлектроннымиДокументами",
			"Видимость",
			ВидимостьЭлемента);
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;

	
КонецПроцедуры


// Константы

&НаСервере
Процедура УстановитьЗначенияЗависимыхКонстант(ИмяРодительскойКонстанты)
	
	СтруктуруПодчиненныхКонстант = ПолучитьСтруктуруПодчиненныхКонстантЭД(ИмяРодительскойКонстанты);
	Для Каждого ИмяКонстанты Из СтруктуруПодчиненныхКонстант Цикл
		Константы[ИмяКонстанты.Ключ].Установить(НаборКонстант[ИмяРодительскойКонстанты]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
// Возвращает состав набор констант.
//
// Параметры:
//	Набор - КонстантыНабор
//
// Возвращаемое значение:
//  Структура
//		Ключ - имя константы из набора
//
Функция ПолучитьСтруктуруНабораКонстантЭД(Набор)
	
	Результат = Новый Структура;
	
	Для Каждого МетаКонстанта Из Метаданные.Константы Цикл
		Если ЕстьРеквизитОбъекта(Набор, МетаКонстанта.Имя) Тогда
			Результат.Вставить(МетаКонстанта.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита)
	
	КлючУникальностиЭД   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальностиЭД);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальностиЭД;
	
КонецФункции

&НаСервере
// Возвращает структуру, описывающую "подчиненные" константы для указанной "родительской" константы.
//
//	Параметры:
//		ИмяРодительскойКонстанты - Структура - имя родительской константы
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя подчиненной константы
//
Функция ПолучитьСтруктуруПодчиненныхКонстантЭД(ИмяРодительскойКонстанты)
	
	Результат       = Новый Структура;
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура("ИмяРодительскойКонстанты", ИмяРодительскойКонстанты));
	
	Для Каждого СтрокаПодчиненного Из ПодчиненныеКонстанты Цикл
		
		Если Результат.Свойство(СтрокаПодчиненного.ИмяПодчиненнойКонстанты) Тогда
			Продолжить;
		КонецЕсли;
		
		Результат.Вставить(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		ПодчиненныеПодчиненных = ПолучитьСтруктуруПодчиненныхКонстантЭД(СтрокаПодчиненного.ИмяПодчиненнойКонстанты);
		
		Для Каждого ПодчиненныйПодчиненного Из ПодчиненныеПодчиненных Цикл
			Результат.Вставить(ПодчиненныйПодчиненного.Ключ);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
// Возвращает структуру, описывающую "родительские" константы для указанных "подчиненных" констант.
//
//	Параметры:
//		СтруктураПодчиненныхКонстант - Структура - имена подчиненных констант
//
//	Возвращаемое значение:
//		Структура
//			Ключ - имя родительской константы
//
Функция ПолучитьСтруктуруРодительскихКонстантЭД(СтруктураПодчиненныхКонстант)
	
	Результат       = Новый Структура;
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
			 ИЛИ СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = ПолучитьСтруктуруРодительскихКонстантЭД(Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты));
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
// Возвращает таблицу, описывающую зависимость констант в конфигурации.
// Каждая строка таблицы означает:
// для родительской константы со значением Х допустимо только значение Y для подчиненной константы.
//
// Возвращаемое значение:
//	ТаблицаЗначений с колонками
//		- ИмяРодительскойКонстанты
//		- ИмяПодчиненнойКонстанты
//		- ЗначениеРодительскойКонстанты
//		- ЗначениеПодчиненнойКонстанты
//
Функция ПолучитьТаблицуЗависимостиКонстантЭД()
	
	Результат = Новый ТаблицаЗначений;
	
	Результат.Колонки.Добавить("ИмяРодительскойКонстанты", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ИмяПодчиненнойКонстанты",  Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ЗначениеРодительскойКонстанты");
	Результат.Колонки.Добавить("ЗначениеПодчиненнойКонстанты");
	
	Результат.Индексы.Добавить("ИмяРодительскойКонстанты");
	Результат.Индексы.Добавить("ИмяПодчиненнойКонстанты");
	
	// ЭДО
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьОбменЭД", 						Ложь, "ИспользоватьОбменЭДМеждуОрганизациями", 				 Ложь);
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьОбменЭД", 						Ложь, "ИспользоватьОтложеннуюОтправкуЭлектронныхДокументов", Ложь);
	
	ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(Результат,
		"ИспользоватьЭлектронныеЦифровыеПодписи", 	Ложь, "ИспользоватьОбменЭДМеждуОрганизациями", 			   	 Ложь);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ДобавитьСтрокуТаблицыЗависимостиКонстантЭД(ТаблицаКонстант,
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты, ИмяПодчиненнойКонстанты, ЗначениеПодчиненнойКонстанты)
	
	НоваяСтрока = ТаблицаКонстант.Добавить();
	НоваяСтрока.ИмяРодительскойКонстанты      = ИмяРодительскойКонстанты;
	НоваяСтрока.ЗначениеРодительскойКонстанты = ЗначениеРодительскойКонстанты;
	НоваяСтрока.ИмяПодчиненнойКонстанты       = ИмяПодчиненнойКонстанты;
	НоваяСтрока.ЗначениеПодчиненнойКонстанты  = ЗначениеПодчиненнойКонстанты;
	
КонецПроцедуры

&НаСервере
// Возвращает признак наличия у константы "подчиненных" констант.
//
//	Параметры:
//		ИмяРодительскойКонстанты 	  - Строка - имя константы как оно задано в конфигураторе
//		ЗначениеРодительскойКонстанты - Произвольный - значение константы
//
//	Возвращаемое значение:
//		Булево - если Истина, то у константы есть "подчиненные" ей константы.
//
Функция ЕстьПодчиненныеКонстантыЭД(ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты)
	
	ТаблицаКонстант = ПолучитьТаблицуЗависимостиКонстантЭД();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура(
			"ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты",
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты));
	
	Возврат ПодчиненныеКонстанты.Количество() > 0;
	
КонецФункции

&НаКлиенте
Процедура НастроитьОповещенияЭДО(Команда)
	
	Если РасписаниеНовыхЭД = Неопределено Тогда
		РасписаниеНовыхЭД = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеНовыхЭД);
		
	Если Диалог.ОткрытьМодально() Тогда
		РасписаниеНовыхЭД = Диалог.Расписание;
	КонецЕсли;
	
	ИзменитьРасписаниеЗадания("НаличиеНовыхЭД", РасписаниеНовыхЭД);

КонецПроцедуры

&НаКлиенте
Процедура ОповещатьОСобытияхЭДОПриИзменении(Элемент)
	
	ИзменитьИспользованиеЗадания("НаличиеНовыхЭД", ОповещатьОСобытияхЭДО);
	
	Элементы.НаличиеНовыхЭД.Доступность = ОповещатьОСобытияхЭДО;

КонецПроцедуры
