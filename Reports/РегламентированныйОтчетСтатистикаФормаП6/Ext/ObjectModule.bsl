////////////////////////////////////////////////////////////////////////////////
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

// Следующие переменные хранят границы
// периода построения отчета
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

Перем СвойстваЗаполненияОтчета Экспорт;

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
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);
ОписаниеТиповСтрока50  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(50);
 
мТаблицаСоставПоказателей    = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре",  ОписаниеТиповСтрока50);

мСтруктураВариантыЗаполнения = Новый Структура;

////////////////////////////////////////////////////////////////////////////////
// ОПРЕДЕЛЕНИЕ ДЕРЕВА ФОРМ И ФОРМАТОВ ОТЧЕТА

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

// определение форм
Форма20100101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20090716', "139",	"ФормаОтчета2010Кв1");
Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20100713', "247",	"ФормаОтчета2011Кв1");
Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20120727', "423",	"ФормаОтчета2013Кв1");
Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20130925', "382",	"ФормаОтчета2014Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20140827', "535",	"ФормаОтчета2015Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20150722', "336",	"ФормаОтчета2016Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20160831', "468",	"ФормаОтчета2017Кв1");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20170801', "509",	"ФормаОтчета2018Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "24-03-2015");
Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "608020", '20180731', "468",	"ФормаОтчета2019Кв1");
РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "03-03-2019");

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
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 16.07.2009 №139";
НоваяФорма.ДатаНачалоДействия = '20100101';
НоваяФорма.ДатаКонецДействия  = '20101231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 13.07.2010 №247";
НоваяФорма.ДатаНачалоДействия = '20110101';
НоваяФорма.ДатаКонецДействия  = '20121231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.07.2012 №423";
НоваяФорма.ДатаНачалоДействия = '20130101';
НоваяФорма.ДатаКонецДействия  = '20131231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 25.09.2013 № 382";
НоваяФорма.ДатаНачалоДействия = '20140101';
НоваяФорма.ДатаКонецДействия  = '20141231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 27.08.2014 № 535";
НоваяФорма.ДатаНачалоДействия = '20150101';
НоваяФорма.ДатаКонецДействия  = '20151231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 22.07.2015 № 336";
НоваяФорма.ДатаНачалоДействия = '20160101';
НоваяФорма.ДатаКонецДействия  = '20161231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 31.08.2016 № 468";
НоваяФорма.ДатаНачалоДействия = '20170101';
НоваяФорма.ДатаКонецДействия  = '20171231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 01.08.2017 № 509";
НоваяФорма.ДатаНачалоДействия = '20180101';
НоваяФорма.ДатаКонецДействия  = '20181231';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 31.07.2018 № 468";
НоваяФорма.ДатаНачалоДействия = '20190101';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
