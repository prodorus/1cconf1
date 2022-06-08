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

// Хранит ссылку на документ, хранящий данные отчета
Перем мСохраненныйДок Экспорт;

Перем мВерсияФормы Экспорт;

// Следующие переменные хранят границы периода построения отчета
// и периодичность
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета  Экспорт;
Перем мПериодичность Экспорт;

Перем мСчетчикСтраниц Экспорт; // флажок на форме выбора страниц, если Истина, то пересчет автоматический убрать
Перем мАвтоВыборКодов Экспорт; // для флажка "отключить выбор значений из списка"
Перем мПроверятьСоотношенияПриПечатиИВыгрузки Экспорт; // Флаг, для запуска КС

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

// Удаляет значения итоговых показателей на листах МЧБ,
// образованных многострочными разделами (кроме последнего).
//
Процедура ОбнулитьИтоговыеПоказателиНаЛистеМЧБ(ТаблДок) Экспорт
	
	ОбластьИтоговыеПоказатели = ТаблДок.Области.Найти("ИтоговыеПоказатели");
	
	Если ОбластьИтоговыеПоказатели = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбластьИтоговыеПоказателиВерх = ОбластьИтоговыеПоказатели.Верх;
	ОбластьИтоговыеПоказателиНиз  = ОбластьИтоговыеПоказатели.Низ;
	
	Для Каждого Обл Из ТаблДок.Области Цикл
		Если Обл.Верх >= ОбластьИтоговыеПоказателиВерх
		   И Обл.Низ <= ОбластьИтоговыеПоказателиНиз
		   И Обл.ГраницаСлева.ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Точечная Тогда
			Если Обл.СодержитЗначение = Истина Тогда // возможны 3 состояния
				Обл.Значение = "-";
			Иначе
				Обл.Текст = "-";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция СтрокаЧГ0(ИсходноеЧисло) Экспорт // враппер
	
	Возврат РегламентированнаяОтчетность.СтрокаЧГ0(ИсходноеЧисло);
	
КонецФункции

Процедура Инкр(ИнкрементируемоеЗначение) Экспорт
	
	ИнкрементируемоеЗначение = ИнкрементируемоеЗначение + 1;
	
КонецПроцедуры

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

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

Форма20040101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2003-12-29', "БГ-3-21/727", "ФормаОтчета2004Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20040101, "3.00003");

Форма20070101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2006-12-29', "185н", "ФормаОтчета2007Кв1", , '20081231');
ОпределитьФорматВДеревеФормИФорматов(Форма20070101, "3.00004");

Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2008-12-31', "158н", "ФормаОтчета2007Кв1", '20090101', '20110401');
ОпределитьФорматВДеревеФормИФорматов(Форма20090101, "3.00004");

ФормаОтчета2011Кв2 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2011-04-07', "MMB-7-3/253@", "ФормаОтчета2011Кв2");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2011Кв2, "5.01");

ФормаОтчета2012Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2011-12-16', "ММВ-7-3/928@", "ФормаОтчета2012Кв1");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2012Кв1, "5.02");

ФормаОтчета2013Кв4 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2013Кв4, "5.03");

ФормаОтчета2015Кв2 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2015-05-14', "ММВ-7-3/197@", "ФормаОтчета2015Кв2");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2015Кв2, "5.04");

Форма2019Кв1_Р = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2018-12-29', "СД-4-3/24833@", "ФормаОтчета2019Кв1_Р");
ОпределитьФорматВДеревеФормИФорматов(Форма2019Кв1_Р, "5.05");

Форма2019Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151054", '2018-12-20', "ММВ-7-3/827@", "ФормаОтчета2019Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма2019Кв1, "5.06");

мСтруктураВариантыЗаполнения = Новый Структура;
мТаблицаСоставПоказателей = РегламентированнаяОтчетность.СозданиеТаблицыСоставаПоказателей();
мТаблицаФормОтчета = РегламентированнаяОтчетность.СозданиеТаблицыФормОтчета();

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 Утверждено Приказом МНС России от 29.12.2003 № БГ -3-21/727";
НоваяФорма.ДатаНачалоДействия = '2004-01-01';
НоваяФорма.ДатаКонецДействия  = '2006-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Минфина РФ от 29.12.2006 № 185н";
НоваяФорма.ДатаНачалоДействия = '2007-01-01';
НоваяФорма.ДатаКонецДействия  = '2008-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу Минфина РФ от 29.12.2006 № 185н (в редакции приказа Минфина РФ от 31.12.2008 № 158н)";
НоваяФорма.ДатаНачалоДействия = '2009-01-01';
НоваяФорма.ДатаКонецДействия  = '2011-03-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв2";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 07.04.2011 № MMB-7-3/253@";
НоваяФорма.ДатаНачалоДействия = '2011-04-01';
НоваяФорма.ДатаКонецДействия  = '2011-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 16.12.2011 № ММВ-7-3/928@";
НоваяФорма.ДатаНачалоДействия = '2012-01-01';
НоваяФорма.ДатаКонецДействия  = '2013-11-30';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 16.12.2011 № ММВ-7-3/928@ (в ред. приказа ФНС России от 14 ноября 2013 г. № ММВ-7-3/501@)";
НоваяФорма.ДатаНачалоДействия = '2013-12-01';
НоваяФорма.ДатаКонецДействия  = '2015-05-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв2";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 14.05.2015 № ММВ-7-3/197@";
НоваяФорма.ДатаНачалоДействия = '2015-05-01';
НоваяФорма.ДатаКонецДействия  = '2019-02-28';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1_Р";
НоваяФорма.ОписаниеОтчета     = "Приложение № 4 к письму ФНС России от 29.12.2018 № СД-4-3/24833@.";
НоваяФорма.ДатаНачалоДействия = '2019-01-01';
НоваяФорма.ДатаКонецДействия  = '2019-02-28';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 20.12.2018 № ММВ-7-3/827@.";
НоваяФорма.ДатаНачалоДействия = '2019-03-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
