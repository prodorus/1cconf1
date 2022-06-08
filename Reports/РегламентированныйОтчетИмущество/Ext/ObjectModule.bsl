﻿// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

Перем мВерсияФормы Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

//Перем мКоммАвто Экспорт; // флажок на форме выбора страниц, если Истина, то пересчет автоматический убрать
Перем мСчетчикСтраниц Экспорт; // флажок на форме выбора страниц, если Истина, то пересчет автоматический убрать
Перем мАвтоВыборКодов Экспорт; // для флажка "отключить выбор значений из списка"

// Следующие переменные хранят границы периода построения отчета
// и периодичность
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;
Перем мПериодичность Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мРезультатПоиска Экспорт;// таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;// таблица со счетчиками номеров листов при поиске
Перем мТаблицаФормОтчета Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

Перем мПечатьБезШтрихкодаРазрешена Экспорт;

Перем мПроверятьСоотношенияПриПечатиИВыгрузки Экспорт; // Флаг для запуска КС

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция СтрокаЧГ0(ИсходноеЧисло) Экспорт // враппер
	
	Возврат РегламентированнаяОтчетность.СтрокаЧГ0(ИсходноеЧисло);
	
КонецФункции

Процедура Инкр(ИнкрементируемоеЗначение) Экспорт
	
	ИнкрементируемоеЗначение = ИнкрементируемоеЗначение + 1;
	
КонецПроцедуры

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

Форма20040101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1152001", '2004-03-23', "САЭ-3-21/224", "ФормаОтчета2004Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20040101, "3.00003");

Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1152026", '2008-02-20', "27н", "ФормаОтчета2008Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20080101, "5.01");

Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1152026", '2011-11-24', "ММВ-7-11/895", "ФормаОтчета2011Кв3");
ОпределитьФорматВДеревеФормИФорматов(Форма20110101, "5.02");

Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1152026", '2013-11-05', "ММВ-7-11/478@", "ФормаОтчета2013Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20130101, "5.03");

Форма20170101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1152026", '2017-03-31', "ММВ-7-21/271@", "ФормаОтчета2017Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20170101, "5.04");

Форма20190101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1152026", '2018-10-04', "ММВ-7-21/575@", "ФормаОтчета2019Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20190101, "5.05");

мСтруктураВариантыЗаполнения = Новый Структура;
мТаблицаСоставПоказателей = РегламентированнаяОтчетность.СозданиеТаблицыСоставаПоказателей();
мТаблицаФормОтчета = РегламентированнаяОтчетность.СозданиеТаблицыФормОтчета();

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 Утверждено Приказом МНС России от 23.03.2004 № САЭ-3-21/224";
НоваяФорма.ДатаНачалоДействия = '2003-12-29';
НоваяФорма.ДатаКонецДействия  = '2007-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 Утверждено Приказом Минфина РФ от 20.02.2008 № 27н";
НоваяФорма.ДатаНачалоДействия = '2008-01-01';
НоваяФорма.ДатаКонецДействия  = '2010-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв3";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 24.11.2011 № ММВ-7-11/895";
НоваяФорма.ДатаНачалоДействия = '2011-01-01';
НоваяФорма.ДатаКонецДействия  = '2012-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 05.11.2013 № ММВ-7-11/478@.";
НоваяФорма.ДатаНачалоДействия = '2013-01-01';
НоваяФорма.ДатаКонецДействия  = '2016-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв4";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 31.03.2017 № ММВ-7-21/271@.";
НоваяФорма.ДатаНачалоДействия = '2017-01-01';
НоваяФорма.ДатаКонецДействия  = '2018-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 31.03.2017 № ММВ-7-21/271@ (в редакции приказа ФНС России от 04.10.2018 № ММВ-7-21/575@).";
НоваяФорма.ДатаНачалоДействия = '2019-01-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
