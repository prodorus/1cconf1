Перем мТаблицаСоставПоказателей Экспорт;
Перем мСтруктураВариантыЗаполнения Экспорт;

Перем мДеревоСтраницОтчета Экспорт;

Перем мЕстьВыбранные Экспорт;

Перем мВерсияФормы Экспорт;

Перем мВыбраннаяФорма Экспорт;

Перем мСкопированаФорма Экспорт;

Перем мСохраненныйДок Экспорт;

// Границы периода построения отчета.
Перем мДатаНачалаПериодаОтчета Экспорт;
Перем мДатаКонцаПериодаОтчета Экспорт;

Перем мПолноеИмяФайлаВнешнейОбработки Экспорт;

Перем мЗаписьЗапрещена Экспорт;

Перем мПериодичность Экспорт;

Перем мИнтервалАвтосохранения Экспорт;

Перем мРезультатПоиска Экспорт;// таблица с результатами поиска
Перем мСчетчикиСтраницПриПоиске Экспорт;// таблица со счетчиками номеров листов при поиске
Перем мТаблицаФормОтчета Экспорт;

Перем мЗаписываетсяНовыйДокумент Экспорт;
Перем мВариант Экспорт;

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

// Элементы настройки формы
Перем мСчетчикСтраниц Экспорт; // Автонумерация странци
Перем мАвтоВыборКодов Экспорт; // Выбор кодов из списка
Перем мПечатьБезШтрихкодаРазрешена Экспорт; // Печать на бланках без PDF417
Перем мЧтоОчищать Экспорт;

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

ОписаниеТиповСтрока15 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);
ОписаниеТиповСтрока50 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(50);

мТаблицаСоставПоказателей = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",   ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",      ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре", ОписаниеТиповСтрока50);

мСтруктураВариантыЗаполнения = Новый Структура;

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

ФормаОтчета2017Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1150027", '2013-01-28', "ММВ-7-3/41@", "ФормаОтчета2017Кв1");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2017Кв1, "5.01"); // Приказ ФНС России от 07.02.2013 № ММВ-7-6/64@

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
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом ФНС России от 28.01.2013 № ММВ-7-3/41@";
НоваяФорма.ДатаНачалоДействия = '2013-01-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
