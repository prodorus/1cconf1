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

Функция СозданиеТаблицыФормОтчета()
	
	ОписаниеТиповСтрока = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(0);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	мТаблицаФормОтчета = Новый ТаблицаЗначений;
	мТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	мТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	мТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	мТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	
	Возврат мТаблицаФормОтчета;
	
КонецФункции

Функция СозданиеТаблицыСоставаПоказателей()
	
	ОписаниеТиповСтрока15 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);
	ОписаниеТиповСтрока50 = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(50);
	
	мТаблицаСоставПоказателей = Новый ТаблицаЗначений;
	мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",    ОписаниеТиповСтрока50);
	мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",  ОписаниеТиповСтрока50);
	мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",    ОписаниеТиповСтрока50);
	мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",    ОписаниеТиповСтрока15);
	мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",     ОписаниеТиповСтрока15);
	мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре",ОписаниеТиповСтрока50);
	
	Возврат мТаблицаСоставПоказателей;
	
КонецФункции

Функция ЕстьПоказательПоМестуРазмещения(МестоРазмещенияДанных, АдресДанных) Экспорт
	
	Результат = Ложь;
	
	Если ТипЗнч(МестоРазмещенияДанных) = Тип("Структура") Тогда
		Результат = МестоРазмещенияДанных.Свойство(АдресДанных);
	Иначе
		// Это должны быть данные в поле табличного документа.
		Результат = МестоРазмещенияДанных.Области.Найти(АдресДанных) <> Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДанныеИзМестаРазмещения(МестоРазмещенияДанных, АдресДанных) Экспорт
	
	Если ТипЗнч(МестоРазмещенияДанных) = Тип("Структура") Тогда
		ЗначениеВСтруктуре = Неопределено;
		Если МестоРазмещенияДанных.Свойство(АдресДанных, ЗначениеВСтруктуре) Тогда
			Возврат ЗначениеВСтруктуре;
		Иначе
			ВызватьИсключение "Невозможно получить данные из структуры: поле " + АдресДанных + " не существует";
		КонецЕсли;
	Иначе
		// Это должны быть данные в поле табличного документа.
		Возврат МестоРазмещенияДанных.Области[АдресДанных].Значение;
	КонецЕсли;
	
КонецФункции

Процедура ПоместитьДанныеПоМестуРазмещения(МестоРазмещенияДанных, АдресДанных, ЗначениеДанных) Экспорт
	
	Если ТипЗнч(МестоРазмещенияДанных) = Тип("Структура") Тогда
		МестоРазмещенияДанных.Вставить(АдресДанных, ЗначениеДанных);
	Иначе
		МестоРазмещенияДанных.Области[АдресДанных].Значение = ЗначениеДанных;
	КонецЕсли;
	
КонецПроцедуры

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

Форма20040701 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1110005", '2004-06-15', "САЭ-3-21/368@", "ФормаОтчета2004Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20040701, "3.00000");

Форма20060401 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1110011", '2006-02-26', "САЭ-3-21/110@", "ФормаОтчета2006Кв1");
ОпределитьФорматВДеревеФормИФорматов(Форма20060401, "3.00001");

Форма20100901 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1110011", '2010-07-07', "ММВ-7-3/321", "ФормаОтчета2010Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма20100901, "5.01");

Форма2013Кв4 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1110011", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма2013Кв4, "5.02");

Форма2017Кв4 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1110011", '2017-06-14', "ММВ-7-3/505@", "ФормаОтчета2017Кв4");
ОпределитьФорматВДеревеФормИФорматов(Форма2017Кв4, "5.03");

мСтруктураВариантыЗаполнения = Новый Структура;

мТаблицаСоставПоказателей = СозданиеТаблицыСоставаПоказателей();
мТаблицаФормОтчета        = СозданиеТаблицыФормОтчета();

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Кв1";
НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом МНС России от 15.06.2004 г. № САЭ-3-21/368";
НоваяФорма.ДатаНачалоДействия = '2004-01-01';
НоваяФорма.ДатаКонецДействия  = '2006-03-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2006Кв1";
НоваяФорма.ОписаниеОтчета     = "Приказ ФНС России от 26.02.2006 № САЭ-3-21/110@";
НоваяФорма.ДатаНачалоДействия = '2006-03-01';
НоваяФорма.ДатаКонецДействия  = '2010-08-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2010Кв4";
НоваяФорма.ОписаниеОтчета     = "Приказ ФНС России от 07.07.2010 № ММВ-7-3/321";
НоваяФорма.ДатаНачалоДействия = '2010-09-01';
НоваяФорма.ДатаКонецДействия  = '2013-11-30';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
НоваяФорма.ОписаниеОтчета     = "Приказ ФНС России от 07.07.2010 № ММВ-7-3/321 (в ред. приказа ФНС России от 14 ноября 2013 г. № ММВ-7-3/501@)";
НоваяФорма.ДатаНачалоДействия = '2013-12-01';
НоваяФорма.ДатаКонецДействия  = '2017-10-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв4";
НоваяФорма.ОписаниеОтчета     = "Приказ ФНС России от 14.06.2017 № ММВ-7-3/505@";
НоваяФорма.ДатаНачалоДействия = '2017-11-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
