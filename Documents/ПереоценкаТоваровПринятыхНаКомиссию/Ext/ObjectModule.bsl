Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

// Хранит структуру, содержащую параметры для определения договора, доступного в данном документе:
//    список допустимых видов договоров;
//    список допустимых способов ведения взаиморасчетов.
Перем мСтруктураПараметровДляПолученияДоговора Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьПечатьПереоценкиТоваровПринятых()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийДокумент", ЭтотОбъект.Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Номер,
	|	Дата,
	|	ДоговорКонтрагента,
	|	Контрагент,
	|	Контрагент КАК Поставщик,
	|	Организация,
	|	Организация КАК Покупатель,
	|	ВалютаДокумента,
	|	Товары.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК Товар,
	|		КоличествоМест,
	|		Количество,
	|		ЕдиницаИзмерения.Представление     КАК ЕдиницаИзмерения,
	|		ЕдиницаИзмеренияМест.Представление КАК ЕдиницаИзмеренияМест,
	|		Цена,
	|		Сумма,
	|		ЦенаСтарая,
	|		СуммаСтарая,
	|		ХарактеристикаНоменклатуры КАК Характеристика,
	|		СерияНоменклатуры КАК Серия
	|	)
	|ИЗ
	|	Документ.ПереоценкаТоваровПринятыхНаКомиссию КАК ПереоценкаТоваровПринятыхНаКомиссию
	|
	|ГДЕ
	|	ПереоценкаТоваровПринятыхНаКомиссию.Ссылка = &ТекущийДокумент
	|УПОРЯДОЧИТЬ ПО
	|	Товары.НомерСтроки";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();
	ВыборкаСтрокТовары = Шапка.Товары.Выбрать();

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПереоценкаТоваровПринятыхНаКомиссию_Накладная";

	Макет = ПолучитьМакет("Накладная");

	// Выводим шапку накладной

	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Переоценка товаров принятых на комиссию");
	ТабДокумент.Вывести(ОбластьМакета);

	ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,");
	ПредставлениеКонтрагента = ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Контрагент, Шапка.Дата), "ПолноеНаименование,");

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеКонтрагента;
	ОбластьМакета.Параметры.Поставщик = Шапка.Поставщик;
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеОрганизации;
	ОбластьМакета.Параметры.Получатель = Шапка.Организация;
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести табличную часть
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Строка");

	Пока ВыборкаСтрокТовары.Следующий() Цикл

		Если НЕ ЗначениеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
			Сообщить("В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.", СтатусСообщения.Важное);
			Продолжить;
		КонецЕсли;

		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
		ОбластьМакета.Параметры.Товар = ВыборкаСтрокТовары.Товар + ФормированиеПечатныхФорм.ПредставлениеСерий(ВыборкаСтрокТовары);
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;

	// Вывести Итого
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.ВсегоПоСтарым = ОбщегоНазначения.ФорматСумм(Товары.Итог("СуммаСтарая"));
	ОбластьМакета.Параметры.ВсегоПоНовым  = ОбщегоНазначения.ФорматСумм(Товары.Итог("Сумма"));
	ТабДокумент.Вывести(ОбластьМакета);

	// Вывести подписи
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабДокумент.Вывести(ОбластьМакета);
	
	МестВсего = Шапка.Товары.Выгрузить().Итог("КоличествоМест");
    Если МестВсего = 0 Тогда
		УниверсальныеМеханизмы.СкрытьКолонкиВТабличномДокументе(ТабДокумент, "Мест",5, "ШапкаТаблицы");
    КонецЕсли;


	Возврат ТабДокумент;

КонецФункции // ПечатьПечатьПереоценкиТоваровПринятых()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ИмяМакета = "Накладная" Тогда
		// Получить экземпляр документа на печать
		ТабДокумент = ПечатьПечатьПереоценкиТоваровПринятых();
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли;

	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Накладная", "Переоценка товаров принятых на комиссию");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Процедура выполняет заполнение табличной части принятыми на реализацию,
// но еще нереализованными товарами. Если передан документ основание то
//  заполнение производится по документу основанию, иначе по всем.
//
// Параметры:
//  ДокументОснование - ссылка на документ основание.
//
Процедура ЗаполнитьТоварыУпр(ДокументОснование = Неопределено) Экспорт

	Запрос = Новый Запрос;
	
	ПараметрыПартионногоУчета = глЗначениеПеременной("ПараметрыПартионногоУчета");
	Если ПараметрыПартионногоУчета.ВестиПартионныйУчетПоСкладам Тогда
		ВремСклад = Склад;
	Иначе
		ВремСклад = Справочники.Склады.ПустаяСсылка();
	КонецЕсли;

	Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ИмяДокумента = "ПоступлениеТоваровУслуг";
	ИначеЕсли ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНТТ") Тогда
		ИмяДокумента = "ПоступлениеТоваровУслугВНТТ";
	КонецЕсли;

	// Установим параметры запроса
	
	Запрос.УстановитьПараметр("Склад",      ВремСклад);
	Запрос.УстановитьПараметр("ДоговорКонтрагента",  ДоговорКонтрагента);
	Запрос.УстановитьПараметр("СтатусПартии",       Перечисления.СтатусыПартийТоваров.НаКомиссию);
	Запрос.УстановитьПараметр("ДокументОснование",  ДокументОснование);
	Запрос.УстановитьПараметр("ДатаОстатков", ОбщегоНазначения.ПолучитьДатуОстатков(ЭтотОбъект));
	
	Если НЕ ЗначениеЗаполнено(Сделка) Тогда
		Запрос.УстановитьПараметр("Сделка",             Неопределено);
	Иначе
		Запрос.УстановитьПараметр("Сделка",             Сделка);
	КонецЕсли;

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Остатки.Номенклатура,
	|	Остатки.ХарактеристикаНоменклатуры,
	|	Остатки.СерияНоменклатуры,
	|	Остатки.ДокументОприходования,
	|	МАКСИМУМ(ВЫБОР КОГДА Остатки.СтоимостьОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Остатки.СтоимостьОстаток
	|	КОНЕЦ)                                       КАК СтоимостьОстаток,
	|	МАКСИМУМ(ВЫБОР КОГДА Остатки.КоличествоОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Остатки.КоличествоОстаток
	|	КОНЕЦ)                                       КАК КоличествоОстаток,
	|	МАКСИМУМ(ВЫБОР КОГДА Полученные.СуммаВзаиморасчетовОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Полученные.СуммаВзаиморасчетовОстаток
	|	КОНЕЦ)                                       КАК СуммаВзаиморасчетовОстаток,
	|	МАКСИМУМ(ВЫБОР КОГДА Полученные.КоличествоОстаток ЕСТЬ NULL ТОГДА
	|		0
	|	ИНАЧЕ
	|		Полученные.КоличествоОстаток
	|	КОНЕЦ)                                       КАК КоличествоПолученных,
	|	Остатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаХраненияОстатков
	| "+ ?(НЕ ЗначениеЗаполнено(ДокументОснование), "" ,"	, ПоступлениеТоваровУслугТовары.СчетУчетаБУ КАК СчетУчетаБУ" ) + "
	|ИЗ
	|	РегистрНакопления.ПартииТоваровНаСкладах.Остатки(&ДатаОстатков, 
	|			Склад          = &Склад 
	|			И СтатусПартии = &СтатусПартии
	|" + ?(ЗначениеЗаполнено(ДокументОснование), "
	|			И Номенклатура В (ВЫБРАТЬ РАЗЛИЧНЫЕ Документ." + ИмяДокумента + ".Товары.Номенклатура
	|			                ИЗ Документ." + ИмяДокумента + ".Товары 
	|			                ГДЕ Документ." + ИмяДокумента + ".Товары.Ссылка = &ДокументОснование)
	|			И ДокументОприходования = &ДокументОснование
	|", "       И ДокументОприходования.ДоговорКонтрагента = &ДоговорКонтрагента") + "
	|			                                        ) КАК Остатки
	| "+ ?(НЕ ЗначениеЗаполнено(ДокументОснование), "" ,"	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ." + ИмяДокумента + ".Товары КАК ПоступлениеТоваровУслугТовары
	|	ПО Остатки.Номенклатура = ПоступлениеТоваровУслугТовары.Номенклатура И ПоступлениеТоваровУслугТовары.Ссылка = Остатки.ДокументОприходования" ) + "
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ТоварыПолученные.Остатки(&ДатаОстатков, 
	|			ДоговорКонтрагента = &ДоговорКонтрагента 
	|			И Сделка           = &Сделка
	|" + ?(ЗначениеЗаполнено(ДокументОснование), "
	|			И Номенклатура В (ВЫБРАТЬ РАЗЛИЧНЫЕ Документ." + ИмяДокумента + ".Товары.Номенклатура
	|			                ИЗ Документ." + ИмяДокумента + ".Товары 
	|			                ГДЕ Документ." + ИмяДокумента + ".Товары.Ссылка = &ДокументОснование)", "") + ") КАК Полученные
	|	ПО Остатки.Номенклатура = Полученные.Номенклатура
	|	   И Остатки.ХарактеристикаНоменклатуры = Полученные.ХарактеристикаНоменклатуры
	|	   И Остатки.СерияНоменклатуры = Полученные.СерияНоменклатуры
	|ГДЕ
	|	Остатки.КоличествоОстаток > 0
	|	//И Полученные.КоличествоОстаток > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Номенклатура,
	|	Остатки.ХарактеристикаНоменклатуры,
	|	Остатки.СерияНоменклатуры,
	|	Остатки.ДокументОприходования
	| "+ ?(НЕ ЗначениеЗаполнено(ДокументОснование), "" ,"	, ПоступлениеТоваровУслугТовары.СчетУчетаБУ" ) + "
	|";

	РезультатЗапроса = Запрос.Выполнить();

	ВалютаУправленческогоУчета          = глЗначениеПеременной("ВалютаУправленческогоУчета");
	СтруктураКурсаУправленческогоУчета  = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаУправленческогоУчета, Дата);
	КурсВалютаУправленческогоУчета      = СтруктураКурсаУправленческогоУчета.Курс;
	КратностьВалютаУправленческогоУчета = СтруктураКурсаУправленческогоУчета.Кратность;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаТабличнойЧасти = Товары.Добавить();

		СтрокаТабличнойЧасти.Номенклатура               = Выборка.Номенклатура;
		СтрокаТабличнойЧасти.ХарактеристикаНоменклатуры = Выборка.ХарактеристикаНоменклатуры;
		СтрокаТабличнойЧасти.СерияНоменклатуры          = Выборка.СерияНоменклатуры;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения           = Выборка.ЕдиницаХраненияОстатков;
		СтрокаТабличнойЧасти.Коэффициент                = Выборка.ЕдиницаХраненияОстатков.Коэффициент;
		СтрокаТабличнойЧасти.Количество                 = Выборка.КоличествоОстаток;

		Если Выборка.КоличествоПолученных = 0 Тогда
			СтрокаТабличнойЧасти.СуммаСтарая = 0;
		Иначе
			СтрокаТабличнойЧасти.СуммаСтарая = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(
			                                   Выборка.СуммаВзаиморасчетовОстаток * Выборка.КоличествоОстаток / Выборка.КоличествоПолученных,
			                                   ДоговорКонтрагента.ВалютаВзаиморасчетов,
			                                   ВалютаДокумента,
			                                   КурсВзаиморасчетов,
			                                   ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
			                                   КратностьВзаиморасчетов,
			                                   ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета));
		КонецЕсли;

		СтрокаТабличнойЧасти.ЦенаСтарая = СтрокаТабличнойЧасти.СуммаСтарая / СтрокаТабличнойЧасти.Количество;
		СтрокаТабличнойЧасти.Сумма      = СтрокаТабличнойЧасти.СуммаСтарая;
		СтрокаТабличнойЧасти.Цена       = СтрокаТабличнойЧасти.ЦенаСтарая;

		Если ЗначениеЗаполнено(ДокументОснование) И ОтражатьВБухгалтерскомУчете Тогда
			СтрокаТабличнойЧасти.СчетУчетаБУ = Выборка.СчетУчетаБУ;
		КонецЕсли

	КонецЦикла;

КонецПроцедуры // ЗаполнитьТоварыУпр()

//Выполняет заполнение счетов учета в переданной строке табличной части
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ=Ложь) Экспорт

	ЗаполнитьСчетаУчетаВТабЧасти(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ);
	
КонецПроцедуры //ЗаполнитьСчетаУчетаВСтрокеТабЧасти()

//Выполняет заполнение счетов учета в переданной табличной части
//
Процедура ЗаполнитьСчетаУчетаВТабЧасти(ТабличнаяЧасть, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ=Ложь) Экспорт

	СчетаУчетаВДокументах.ЗаполнитьСчетаУчетаТабличнойЧасти(ИмяТабЧасти, ТабличнаяЧасть, ЭтотОбъект, ЗаполнятьБУ, Ложь);

КонецПроцедуры //ЗаполнитьСчетаУчетаВТабЧасти


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ПодготовитьТаблицуТоваровУпр(ТаблицаТоваров, СтруктураШапкиДокумента)

	// Надо добавить колонки "СуммаУпр"
	ТаблицаТоваров.Колонки.Добавить("СуммаУпр", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));

	// Надо заполнить новые колонки.
	Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл

		Сумма = СтрокаТаблицы.Сумма;

		СтрокаТаблицы.СуммаУпр = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Сумма, ВалютаДокумента, 
													СтруктураШапкиДокумента.ВалютаУправленческогоУчета,
													ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета), СтруктураШапкиДокумента.КурсВалютыУправленческогоУчета,
													ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета), СтруктураШапкиДокумента.КратностьВалютыУправленческогоУчета);

	КонецЦикла;

КонецПроцедуры // ПодготовитьТаблицуТоваровУпр()

Процедура ПодготовитьТаблицуТоваровРегл(ТаблицаТоваров, СтруктураШапкиДокумента)

	ТаблицаТоваров.Колонки.Добавить("ПроводкаСумма",       Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));

	ВалютаРег = мВалютаРегламентированногоУчета;
	Данные    = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРег, Дата);

	// Надо заполнить новые колонки.
	Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл

		Сумма = СтрокаТаблицы.Сумма;

		// Суммы пересчитаем в валюту упр. учета
		Если СтруктураШапкиДокумента.ВалютаДокумента = ВалютаРег Тогда
			СтрокаТаблицы.ПроводкаСумма    = Сумма;
		Иначе
			СтрокаТаблицы.ПроводкаСумма = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Сумма, СтруктураШапкиДокумента.ВалютаДокумента,
			                                 ВалютаРег,
			                                 СтруктураШапкиДокумента.КурсДокумента, Данные.Курс,
			                                 СтруктураШапкиДокумента.КратностьДокумента,Данные.Кратность);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПодготовитьТаблицуТоваровРегл()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента)

	ТаблицаТоваров = РезультатЗапросаПоТоварам.Выгрузить();
	
	Если СтруктураШапкиДокумента.ВалютаВзаиморасчетов <> ВалютаДокумента Тогда
		Для каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
			СтрокаТаблицы.СуммаВзаиморасчетов = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.СуммаВзаиморасчетов, ВалютаДокумента, СтруктураШапкиДокумента.ВалютаВзаиморасчетов,
											ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета), КурсВзаиморасчетов, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета), КратностьВзаиморасчетов);
		КонецЦикла;
	КонецЕсли;								
	
	// Вызываем отдельные процедуры подготовки для регл. и упр. учета
	ПодготовитьТаблицуТоваровРегл(ТаблицаТоваров, СтруктураШапкиДокумента);
	ПодготовитьТаблицуТоваровУпр(ТаблицаТоваров, СтруктураШапкиДокумента);

	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - структура, содержащая рексвизиты шапки документа и результаты запроса по шапке,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки( СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
		Новый Структура("Организация, ВалютаДокумента, Контрагент, ДоговорКонтрагента, КурсВзаиморасчетов, КратностьВзаиморасчетов");

	// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда

		Если ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
			СтруктураОбязательныхПолей.Вставить("Сделка", 
				"По выбранному договору установлен способ ведения взаиморасчетов ""по заказам (счетам)""! 
				|Заполните поле ""Заказ поставщику:""!");
		ИначеЕсли ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам тогда
			СтруктураОбязательныхПолей.Вставить("Сделка", 
				"По выбранному договору установлен способ ведения взаиморасчетов ""по заказам (счетам)""! 
				|Заполните поле ""Счет поставщика:""!");
		КонецЕсли;

	КонецЕсли;

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	УправлениеВзаиморасчетами.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, СтруктураШапкиДокумента.ДоговорОрганизация, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "Товары".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Номенклатура, Количество, Сумма");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхПолей, Отказ, Заголовок);

	// Здесь услуг быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетУслуг(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь наборов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

	// Здесь комплектов быть не должно.
	УправлениеЗапасами.ПроверитьЧтоНетКомплектов(ЭтотОбъект, "Товары", ТаблицаПоТоварам, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	ДвиженияПоРегиструСписанныеТовары(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
    УправлениеЗапасами.ЗарегистрироватьДокументВПоследовательностяхПартионногоУчета(ЭтотОбъект, Дата, СтруктураШапкиДокумента.Организация,ОтражатьВУправленческомУчете,ОтражатьВБухгалтерскомУчете,,СтруктураШапкиДокумента.СпособВеденияПартионногоУчетаПоОрганизации);

	УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(Ссылка, Движения.СписанныеТовары.Выгрузить());

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	Если ОтражатьВУправленческомУчете Тогда

		// ТОВАРЫ ПО РЕГИСТРУ ТоварыПолученные.
		НаборДвижений = Движения.ТоварыПолученные;

		// Контроль остатков товара
		Если Товары.Количество() <> 0 Тогда
			ПроцедурыКонтроляОстатков.ТоварыПолученныеКонтрольОстатков("Товары", СтруктураШапкиДокумента, Перечисления.СтатусыПолученияПередачиТоваров.НаКомиссию, Отказ, Заголовок, РежимПроведения);
		КонецЕсли;
		
		Если НЕ Отказ Тогда
		
			СтруктТаблицДокумента = Новый Структура;
			СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварам);
								
			ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
									
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ДоговорКонтрагента", ДоговорКонтрагента);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Контрагент",         Контрагент);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Организация",        Организация);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Сделка",             УправлениеВзаиморасчетами.ОпределитьСделку(ЭтотОбъект, СтруктураШапкиДокумента));
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "СтатусПолучения",    Перечисления.СтатусыПолученияПередачиТоваров.НаКомиссию);
								
			ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Расход, ТаблицыДанныхДокумента, Дата);
			
			// Теперь в качестве суммы взаиморасчетов должна выступать колонка "Сумма"
			ТаблицаПоТоварам.Колонки.Удалить(ТаблицаПоТоварам.Колонки.Найти("СуммаВзаиморасчетов"));
			ТаблицаПоТоварам.Колонки.Сумма.Имя = "СуммаВзаиморасчетов";
				
			СтруктТаблицДокумента = Новый Структура;
			СтруктТаблицДокумента.Вставить("ТаблицаПоТоварам", ТаблицаПоТоварам);
								
			ТаблицыДанныхДокумента = ОбщегоНазначения.ЗагрузитьТаблицыДокументаВСтруктуру(НаборДвижений, СтруктТаблицДокумента);
									
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "ДоговорКонтрагента", ДоговорКонтрагента);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Контрагент",         Контрагент);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Организация",        Организация);
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "Сделка",             УправлениеВзаиморасчетами.ОпределитьСделку(ЭтотОбъект, СтруктураШапкиДокумента));
			ОбщегоНазначения.УстановитьЗначениеВТаблицыДокумента(ТаблицыДанныхДокумента, "СтатусПолучения",    Перечисления.СтатусыПолученияПередачиТоваров.НаКомиссию);
								
			ОбщегоНазначения.ЗаписатьТаблицыДокументаВРегистр(НаборДвижений, ВидДвиженияНакопления.Приход, ТаблицыДанныхДокумента, Дата);
			
		КонецЕсли;
			
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегистрамУпр()

Процедура ДвиженияПоРегиструСписанныеТовары(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок)

	// ТОВАРЫ ПО РЕГИСТРУ СписанныеТовары.

	НаборДвижений = Движения.СписанныеТовары;

	// Получим таблицу значений, совпадающую со структурой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();

	// Поступление с новой стоимостью (колонка "СтоимостьПоступление")
	ТаблицаПоТоварам.Колонки.СуммаУпр.Имя = "СтоимостьПоступление";
	ТаблицаПоТоварам.Колонки.ПроводкаСумма.Имя = "СтоимостьПоступлениеБУ";

	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений);

	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;

	ТаблицаДвижений.ЗаполнитьЗначения(Склад,"Склад");

	ТаблицаДвижений.ЗаполнитьЗначения(Дата,"Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка,"Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина,"Активность");
	ТаблицаДвижений.ЗаполнитьЗначения(Справочники.Качество.Новый, "Качество");

	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийПартииТоваров.ПереоценкаПринятыхНаКомиссию,"КодОперацииПартииТоваров");
	ТаблицаДвижений.ЗаполнитьЗначения(Организация,    "Организация");
	
	ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок, ТаблицаДвижений);
	ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамРегл(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок, ТаблицаДвижений);

	НаборДвижений.мПериод            = Дата;
	НаборДвижений.мТаблицаДвижений   = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.СписанныеТовары.ВыполнитьДвижения();
	КонецЕсли;
	
	Если Движения.СписанныеТовары.Модифицированность() Тогда
		Движения.СписанныеТовары.Записать(Истина);
	КонецЕсли;

КонецПроцедуры // ДвиженияПоРегиструСписанныеТовары()

Процедура ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок, ТаблицаДвижений)
	
	ТаблицаДвижений.ЗаполнитьЗначения(ОтражатьВУправленческомУчете,"ОтражатьВУправленческомУчете");
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.СтатусыПартийТоваров.НаКомиссию,"ДопустимыйСтатус3");
	ТаблицаДвижений.ЗаполнитьЗначения(Подразделение,"Подразделение");
	
КонецПроцедуры

Процедура ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамРегл(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок, ТаблицаДвижений)
	
	ТаблицаДвижений.ЗаполнитьЗначения(ОтражатьВБухгалтерскомУчете, "ОтражатьВБухгалтерскомУчете");
	ТаблицаДвижений.ЗаполнитьЗначения(Ложь,                        "ОтражатьВНалоговомУчете");
	ТаблицаДвижений.ЗаполнитьЗначения(Контрагент,"КорСубконтоБУ1");
	
КонецПроцедуры

Процедура ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке)
	
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"             , "ВалютаУправленческогоУчета"        , "ВалютаУправленческогоУчета");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Константы"             , "КурсВалютыУправленческогоУчета"    , "КурсВалютыУправленческогоУчета");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "НастройкаСпособовВеденияУправленческогоПартионногоУчета", "СпособВеденияПартионногоУчетаПоОрганизации", "СпособВеденияПартионногоУчетаПоОрганизации");
КонецПроцедуры

Процедура ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл(СтруктураПолей)
	
	СтруктураПолей.Вставить("СчетУчетаБУ"               , "СчетУчетаБУ");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
	 Или ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслугВНТТ")Тогда

		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);

		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
			Если Основание.ВидПоступления = Перечисления.ВидыПоступленияТоваров.НаСклад Тогда
				Склад = Основание.СкладОрдер;
			ИначеЕсли Основание.ВидПоступления = Перечисления.ВидыПоступленияТоваров.ПоОрдеру Тогда
				Склад = Основание.СкладОрдер.Склад;
			КонецЕсли;
		Иначе
			Склад = Основание.Склад;
		КонецЕсли;

		Сделка = Основание.Сделка;

		ОтражатьВБухгалтерскомУчете    = Основание.ОтражатьВБухгалтерскомУчете;
		ВидыОперацийПоступлениеТоваров = Перечисления.ВидыОперацийПоступлениеТоваровУслуг;

		Если Не ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
			Возврат;
		КонецЕсли;

		Если Основание.Проведен Тогда
			ЗаполнитьТоварыУпр(Основание);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// Проверка заполнения единицы измерения мест и количества мест
	ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(Товары);

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = Товары.Итог("Сумма");

	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;

	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВедениеВзаиморасчетов"             , "ВедениеВзаиморасчетов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВалютаВзаиморасчетов"              , "ВалютаВзаиморасчетов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "Организация"                       , "ДоговорОрганизация");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Склад"                 , "ВидСклада"                         , "ВидСклада");
	ДополнитьДеревоПолейЗапросаПоШапкеУпр(ДеревоПолейЗапросаПоШапке);

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);

	// Получим необходимые данные для проведения и проверки заполнения данные по табличной части "Товары".
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура"              , "Номенклатура");
	СтруктураПолей.Вставить("Услуга"                    , "Номенклатура.Услуга");
	СтруктураПолей.Вставить("Набор"                     , "Номенклатура.Набор");
	СтруктураПолей.Вставить("Комплект"                  , "Номенклатура.Комплект");
	СтруктураПолей.Вставить("Количество"                , "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	СтруктураПолей.Вставить("Сумма"                     , "Сумма");
	СтруктураПолей.Вставить("СуммаВзаиморасчетов"       , "СуммаСтарая");
	СтруктураПолей.Вставить("ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить("СерияНоменклатуры"         , "СерияНоменклатуры");
	ДополнитьСтруктуруПолейТабличнойЧастиТоварыРегл(СтруктураПолей);

	РезультатЗапросаПоТоварам = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураПолей);

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);

	// Проверить заполнение ТЧ "Товары".
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);

    //Заполнение и проверка заполнения счетов учета номенклатуры и затрат
	СчетаУчетаВДокументах.ЗаполнитьИПроверитьЗаполнениеСчетовУчетаТабличнойЧасти("Товары", 		 	ТаблицаПоТоварам, 	СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	 
КонецПроцедуры


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДляПолученияДоговора = Новый Структура();
мСписокДопустимыхВидовДоговоров = Новый СписокЗначений();
мСписокДопустимыхВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
мСтруктураПараметровДляПолученияДоговора.Вставить("СписокДопустимыхВидовДоговоров", мСписокДопустимыхВидовДоговоров);