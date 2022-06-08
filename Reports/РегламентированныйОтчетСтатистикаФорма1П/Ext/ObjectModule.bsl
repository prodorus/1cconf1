﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит таблицу значений - состав показателей отчета.
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

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

Перем мВерсияФормы Экспорт;

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

// определение форм
Форма20050101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20050822', "63",		"ФормаОтчета2005Кв1");
Форма20070101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20060724', "38",		"ФормаОтчета2007Кв1");
Форма20080101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20071009', "74",		"ФормаОтчета2008Кв1");
Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20080923', "235",	"ФормаОтчета2009Кв1");
Форма20100101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20090728', "153",	"ФормаОтчета2010Кв1");
Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20100915', "316",	"ФормаОтчета2011Кв1");
Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20110815', "355",	"ФормаОтчета2012Кв1");
Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20120829', "470",	"ФормаОтчета2013Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20130812', "323",	"ФормаОтчета2014Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20140904', "547",	"ФормаОтчета2015Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20150715', "320",	"ФормаОтчета2016Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20170821', "541",	"ФормаОтчета2017Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "601009", '20180727', "461",	"ФормаОтчета2018Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "13-02-2019");

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

ОписаниеТиповСтрока50  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(50);
ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);

мТаблицаСоставПоказателей    = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре",     ОписаниеТиповСтрока50);

мСтруктураВариантыЗаполнения = Новый Структура;

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
НоваяФорма.ФормаОтчета        = "ФормаОтчета2005Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 22.08.2005 № 63";
НоваяФорма.ДатаНачалоДействия = '20050101';
НоваяФорма.ДатаКонецДействия  = '20051231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 24.07.2006 № 38";
НоваяФорма.ДатаНачалоДействия = '20060101';
НоваяФорма.ДатаКонецДействия  = '20061231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2008Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена постановлением Росстата от 09.10.2007 № 74";
НоваяФорма.ДатаНачалоДействия = '20070101';
НоваяФорма.ДатаКонецДействия  = '20071231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 23.09.2008 № 235";
НоваяФорма.ДатаНачалоДействия = '20080101';
НоваяФорма.ДатаКонецДействия  = '20081231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 28.07.2009 № 153";
НоваяФорма.ДатаНачалоДействия = '20090101';
НоваяФорма.ДатаКонецДействия  = '20091231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 15.09.2010 № 316";
НоваяФорма.ДатаНачалоДействия = '20100101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 15.08.2011 № 355";
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20111231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 29.08.2012 № 470";
НоваяФорма.ДатаНачалоДействия = '20120101';
НоваяФорма.ДатаКонецДействия  = '20121231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 12.08.2013 № 323";
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = '20131231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 04.09.2014 № 547";
НоваяФорма.ДатаНачалоДействия = '20140101';
НоваяФорма.ДатаКонецДействия  = '20141231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 15.07.2015 № 320";
НоваяФорма.ДатаНачалоДействия = '20150101';
НоваяФорма.ДатаКонецДействия  = '20161231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 21.08.2017 № 541";
НоваяФорма.ДатаНачалоДействия = '20170101';
НоваяФорма.ДатаКонецДействия  = '20171231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.07.2018 № 461";
НоваяФорма.ДатаНачалоДействия = '20180101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));