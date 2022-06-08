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

// Хранит имя выбранной формы отчета
Перем мВыбраннаяФорма Экспорт;

// Хранит признак скопированной формы.
Перем мСкопированаФорма Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

Перем мСчетчикСтраниц Экспорт; // флажок на форме выбора страниц, если Истина, то пересчет автоматический убрать

Перем мПериодичность Экспорт;

// Следующие переменные хранят границы
// периода построения отчета
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;

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

// Определение форм.
Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "604017", '20130829', "349", "ФормаОтчета2013Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "604017", '20140924', "580", "ФормаОтчета2014Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "604017", '20150925', "442", "ФормаОтчета2015Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "604017", '20160805', "391", "ФормаОтчета2016Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "604017", '20170830', "563", "ФормаОтчета2017Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "604017", '20180806', "487", "ФормаОтчета2018Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20140101, "19-02-2019");

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
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 29.08.2013 № 349";
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = '20131231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 24.09.2014 № 580";
НоваяФорма.ДатаНачалоДействия = '20140101';
НоваяФорма.ДатаКонецДействия  = '20141231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 25.09.2015 № 442";
НоваяФорма.ДатаНачалоДействия = '20150101';
НоваяФорма.ДатаКонецДействия  = '20151231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 05.08.2016 № 391";
НоваяФорма.ДатаНачалоДействия = '20160101';
НоваяФорма.ДатаКонецДействия  = '20161231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 30.08.2017 № 563";
НоваяФорма.ДатаНачалоДействия = '20170101';
НоваяФорма.ДатаКонецДействия  = '20171231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 06.08.2018 № 487";
НоваяФорма.ДатаНачалоДействия = '20180101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
