﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
Перем мТаблицаСоставПоказателей Экспорт;

// Хранит структуру - состав показателей отчета,
// значение которых автоматически заполняется по учетным данным.
Перем мСтруктураВариантыЗаполнения Экспорт;

// Хранит структуру многостраничных разделов.
Перем мСтруктураМногостраничныхРазделов Экспорт;

// Хранит дерево значений - структуру листов отчета.
Перем мДеревоСтраницОтчета Экспорт;

// Хранит признак выбора печатных листов.
Перем мЕстьВыбранные Экспорт;

// Хранит имя выбранной формы отчета.
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета.
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы
// периода построения отчета.
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

Перем мПериодичность Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мТаблицаФормОтчета Экспорт;

Перем мРезультатПоиска Экспорт; // таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ ОПРЕДЕЛЕНИЯ ДЕРЕВА ФОРМ И ФОРМАТОВ

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

////////////////////////////////////////////////////////////////////////////////
// ОПРЕДЕЛЕНИЕ ДЕРЕВА ФОРМ И ФОРМАТОВ ОТЧЕТА

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

// Определение форм.
Форма20061201 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20060628',  "30", "ФормаОтчета2007Кв1");
Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20070808',  "62", "ФормаОтчета2008Кв1");
Форма20081201 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20080807', "184", "ФормаОтчета2009Кв1");
Форма20091201 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20090716', "139", "ФормаОтчета2010Кв1");
Форма20111201 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20110803', "344", "ФормаОтчета2012Кв1");
Форма20121201 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20120727', "423", "ФормаОтчета2013Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20130723', "291", "ФормаОтчета2014Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608025", '20140827', "535", "ФормаОтчета2015Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "26-12-2014");

ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(0);

МассивТипов = Новый Массив;
МассивТипов.Добавить(Тип("Дата"));
ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));

мТаблицаФормОтчета = Новый ТаблицаЗначений;
мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 28.06.2006 № 30";
НоваяФорма.ДатаНачалоДействия = '20061201';
НоваяФорма.ДатаКонецДействия  = '20071231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 28.06.2006 № 30 (в редакции постановления Росстата от 08.08.2007 № 62)";
НоваяФорма.ДатаНачалоДействия = '20080101';
НоваяФорма.ДатаКонецДействия  = '20081130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 07.08.2008 № 184";
НоваяФорма.ДатаНачалоДействия = '20081201';
НоваяФорма.ДатаКонецДействия  = '20091130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 16.07.2009 № 139";
НоваяФорма.ДатаНачалоДействия = '20091201';
НоваяФорма.ДатаКонецДействия  = '20111130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 03.08.2011 № 344";
НоваяФорма.ДатаНачалоДействия = '20111201';
НоваяФорма.ДатаКонецДействия  = '20121130';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.07.2012 № 423";
НоваяФорма.ДатаНачалоДействия = '20121201';
НоваяФорма.ДатаКонецДействия  = '20130930';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 23.07.2013 № 291";
НоваяФорма.ДатаНачалоДействия = '20131001';
НоваяФорма.ДатаКонецДействия  = '20140930';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.08.2014 № 535";
НоваяФорма.ДатаНачалоДействия = '20141001';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));