////////////////////////////////////////////////////////////////////////////////
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

// Хранит версию формы отчета
Перем мВерсияФормы Экспорт;

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

// Следующие переменные хранят границы периода построения отчета
// и периодичность
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;
Перем мПериодичность Экспорт;

Перем мСчетчикСтраниц Экспорт; // флажок на форме выбора страниц, если Истина, то пересчет автоматический убрать
Перем мАвтоВыборКодов Экспорт; // для флажка "отключить выбор значений из списка"

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мРезультатПоиска Экспорт;// таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;// таблица со счетчиками номеров листов при поиске

Перем мТаблицаФормОтчета Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мПечатьБезШтрихкодаРазрешена Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

Перем мПроверятьСоотношенияПриПечатиИВыгрузки Экспорт;
Перем СтруктураПараметров Экспорт;

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

////////////////////////////////////////////////////////////////////////////////
// ОПРЕДЕЛЕНИЕ ДЕРЕВА ФОРМ И ФОРМАТОВ ОТЧЕТА

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

Форма2019Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151115", '2019-03-05', "ММВ-7-3/118@", "ФормаОтчета2019Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма2019Кв1, "5.02");

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ 

мСтруктураВариантыЗаполнения = Новый Структура;
мТаблицаСоставПоказателей = РегламентированнаяОтчетность.СозданиеТаблицыСоставаПоказателей();
мТаблицаФормОтчета = РегламентированнаяОтчетность.СозданиеТаблицыФормОтчета();

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 30.11.2016 № ММВ-7-3/646@ (в редакции приказа ФНС России от 05.03.2019 № ММВ-7-3/118@).";
НоваяФорма.ДатаНачалоДействия = '2019-01-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
