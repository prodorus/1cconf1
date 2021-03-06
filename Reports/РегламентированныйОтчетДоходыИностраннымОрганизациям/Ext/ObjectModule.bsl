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

Перем мФормыИФорматы Экспорт;
Перем мВерсияОтчета Экспорт;

Перем мПечатьБезШтрихкодаРазрешена Экспорт;

Перем мПроверятьСоотношенияПриПечатиИВыгрузки Экспорт;

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

Функция ИзвлечьСтруктуруXML(Макет) Экспорт
	
	ДеревоСтруктуры = Новый ДеревоЗначений;
	ДеревоСтруктуры.Колонки.Добавить("Код");
	ДеревоСтруктуры.Колонки.Добавить("Тип");
	ДеревоСтруктуры.Колонки.Добавить("Формат");
	ДеревоСтруктуры.Колонки.Добавить("МинРазмерность");
	ДеревоСтруктуры.Колонки.Добавить("МаксРазмерность");
	ДеревоСтруктуры.Колонки.Добавить("Обязательность");
	ДеревоСтруктуры.Колонки.Добавить("Многостраничность");
	ДеревоСтруктуры.Колонки.Добавить("Многострочность");
	ДеревоСтруктуры.Колонки.Добавить("Раздел");
	ДеревоСтруктуры.Колонки.Добавить("Ключ");
	ДеревоСтруктуры.Колонки.Добавить("Условие");
	ДеревоСтруктуры.Колонки.Добавить("ЗначениеПоУмолчанию");
	ДеревоСтруктуры.Колонки.Добавить("Значение");
	ДеревоСтруктуры.Колонки.Добавить("Представление");
	ДеревоСтруктуры.Колонки.Добавить("Показатели");
	
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	
	УчтенныеГруппы = Новый Соответствие;
	
	Для Уровень = 0 По Макет.КоличествоУровнейГруппировокСтрок() - 1 Цикл
		Макет.ПоказатьУровеньГруппировокСтрок(Уровень);
		Для НомерСтроки = 2 По ВысотаТаблицы Цикл
			НомСтр = ВысотаТаблицы - НомерСтроки + 2;
			Если Макет.Область(НомСтр, 1).Видимость И УчтенныеГруппы.Получить(НомСтр) = Неопределено Тогда
				
				РодительскийУзел = ДеревоСтруктуры;
				Если Уровень <> 0 Тогда
					Для Инд = 1 По НомСтр - 2 Цикл
						Узел = УчтенныеГруппы.Получить(НомСтр - Инд);
						Если Узел <> Неопределено Тогда
							РодительскийУзел = Узел;
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				
				НовСтр = РодительскийУзел.Строки.Вставить(0);
				НовСтр.Код = СокрЛП(Макет.Область(НомСтр, 1, НомСтр, 1).Текст);
				НовСтр.Раздел = СокрЛП(Макет.Область(НомСтр, 2, НомСтр, 2).Текст);
				НовСтр.Ключ = СокрЛП(Макет.Область(НомСтр, 3, НомСтр, 3).Текст);
				НовСтр.Тип = СокрЛП(Макет.Область(НомСтр, 4, НомСтр, 4).Текст);
				НовСтр.Формат = СокрЛП(Макет.Область(НомСтр, 5, НомСтр, 5).Текст);
				МинРазмерность = СокрЛП(Макет.Область(НомСтр, 6, НомСтр, 6).Текст);
				НовСтр.МинРазмерность = ?(ПустаяСтрока(МинРазмерность), ?(НовСтр.Формат = "N", 99999, 0), Число(МинРазмерность));
				МаксРазмерность = СокрЛП(Макет.Область(НомСтр, 7, НомСтр, 7).Текст);
				НовСтр.МаксРазмерность = ?(ПустаяСтрока(МаксРазмерность), 99999, Число(МаксРазмерность));
				НовСтр.Обязательность = СокрЛП(Макет.Область(НомСтр, 8, НомСтр, 8).Текст);
				НовСтр.Многостраничность = НЕ ПустаяСтрока(Макет.Область(НомСтр, 9, НомСтр, 9).Текст);
				НовСтр.Многострочность = НЕ ПустаяСтрока(Макет.Область(НомСтр, 10, НомСтр, 10).Текст);
				НовСтр.Условие = СокрЛП(Макет.Область(НомСтр, 11, НомСтр, 11).Текст);
				НовСтр.ЗначениеПоУмолчанию = СокрЛП(Макет.Область(НомСтр, 12, НомСтр, 12).Текст);
				НовСтр.Представление = СокрЛП(Макет.Область(НомСтр, 13, НомСтр, 13).Текст);
				
				УчтенныеГруппы.Вставить(НомСтр, НовСтр);
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ДеревоСтруктуры;
	
КонецФункции

Функция ЗначениеСодержитсяВСписке(ПроверяемоеЗначение, КонтрольныйСписок) Экспорт
	
	Результат = Ложь;
	
	Значения = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(КонтрольныйСписок, ",");
	Для Инд = 0 По Значения.ВГраница() Цикл
		Значения[Инд] = СокрЛП(Значения[Инд]);
	КонецЦикла;
	
	Результат = (Значения.Найти(ПроверяемоеЗначение) <> Неопределено);
	
	Возврат Результат
	
КонецФункции

Функция СтрокаЧГ0(ИсходноеЧисло) Экспорт // враппер
	
	Возврат РегламентированнаяОтчетность.СтрокаЧГ0(ИсходноеЧисло);
	
КонецФункции

Процедура Инкр(ИнкрементируемоеЗначение) Экспорт
	
	ИнкрементируемоеЗначение = ИнкрементируемоеЗначение + 1;
	
КонецПроцедуры

мФормыИФорматы = РегламентированнаяОтчетность.НовоеДеревоФормИФорматов();

ФормаОтчета2004Кв2 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151056", '2004-04-14', "САЭ-3-23/286@", "ФормаОтчета2004Кв2");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2004Кв2, "3.00003");

ФормаОтчета2007Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151056", '2004-04-14', "САЭ-3-23/286@", "ФормаОтчета2007Кв1");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2007Кв1, "3.00004");

ФормаОтчета2014Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151056", '2013-12-18', "ММВ-7-3/628@", "ФормаОтчета2014Кв1");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2014Кв1, "3.00005");

ФормаОтчета2016Кв1 = ОпределитьФормуВДеревеФормИФорматов(мФормыИФорматы, "1151056", '2016-03-02', "ММВ-7-3/115@", "ФормаОтчета2016Кв1");
ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2016Кв1, "5.01");

ОписаниеТиповСтрока15  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(15);
ОписаниеТиповСтрока50  = ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(50);

мТаблицаСоставПоказателей    = Новый ТаблицаЗначений;
мТаблицаСоставПоказателей.Колонки.Добавить("ИмяПоляТаблДокумента",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСоставу",   ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоФорме",     ОписаниеТиповСтрока50);
мТаблицаСоставПоказателей.Колонки.Добавить("ПризнМногострочности",     ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("ТипДанныхПоказателя",      ОписаниеТиповСтрока15);
мТаблицаСоставПоказателей.Колонки.Добавить("КодПоказателяПоСтруктуре", ОписаниеТиповСтрока50);

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
НоваяФорма.ФормаОтчета        = "ФормаОтчета2004Кв2";
НоваяФорма.ОписаниеОтчета     = "Утверждено приказом МНС России от 14.04.2004 № САЭ-3-23/286@";
НоваяФорма.ДатаНачалоДействия = '2004-05-01';
НоваяФорма.ДатаКонецДействия  = '2007-02-28';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждено приказом МНС России от 14.04.2004 № САЭ-3-23/286@, с возможностью выгрузки электронном виде в формате версии 3.00004";
НоваяФорма.ДатаНачалоДействия = '2007-03-01';
НоваяФорма.ДатаКонецДействия  = '2013-11-30';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждено приказом МНС России от 14.04.2004 № САЭ-3-23/286@, в редакции Приказа ФНС России от 18.12.2013 № ММВ-7-3/628@";
НоваяФорма.ДатаНачалоДействия = '2013-12-01';
НоваяФорма.ДатаКонецДействия  = '2013-12-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждено приказом МНС России от 14.04.2004 № САЭ-3-23/286@, с возможностью выгрузки электронном виде в формате версии 3.00004";
НоваяФорма.ДатаНачалоДействия = '2014-01-01';
НоваяФорма.ДатаКонецДействия  = '2014-01-31';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждено приказом МНС России от 14.04.2004 № САЭ-3-23/286@, в редакции Приказа ФНС России от 18.12.2013 № ММВ-7-3/628@";
НоваяФорма.ДатаНачалоДействия = '2014-02-01';
НоваяФорма.ДатаКонецДействия  = '2016-02-29';

НоваяФорма = мТаблицаФормОтчета.Добавить();
НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
НоваяФорма.ОписаниеОтчета     = "Утверждено приказом ФНС России от 02.03.2016 № ММВ-7-3/115@";
НоваяФорма.ДатаНачалоДействия = '2016-03-01';
НоваяФорма.ДатаКонецДействия  = ОбщегоНазначения.ПустоеЗначениеТипа(Тип("Дата"));
