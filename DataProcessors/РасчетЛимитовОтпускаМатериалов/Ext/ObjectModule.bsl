////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мВалютаУправленческогоУчета Экспорт;

// Соответствия, содержащая назначения свойств и категорий именам
Перем мСоответствиеНазначений Экспорт;

Перем мСтруктураДляОтбораПоКатегориям Экспорт; // предназначена для связи отборов Построителя с категориями из соединяемых таблиц

Перем мПланыПроизводства Экспорт;
Перем мПланыПродаж Экспорт;
Перем мЗаказыПокупателей Экспорт;
Перем мВнутренниеЗаказы Экспорт;
Перем мРасходСоСклада Экспорт;
Перем мРасходНаВыпуск Экспорт;
	                                            
Перем мПланыПроизводстваПроцент Экспорт;
Перем мПланыПродажПроцент Экспорт;
Перем мЗаказыПокупателейПроцент Экспорт;
Перем мВнутренниеЗаказыПроцент Экспорт;
Перем мРасходСоСкладаПроцент Экспорт;
Перем мРасходНаВыпускПроцент Экспорт;
	                                            
Перем мПланыПроизводстваДатаНач Экспорт;
Перем мПланыПродажДатаНач Экспорт;
Перем мЗаказыПокупателейДатаНач Экспорт;
Перем мВнутренниеЗаказыДатаНач Экспорт;
Перем мРасходСоСкладаДатаНач Экспорт;
Перем мРасходНаВыпускДатаНач Экспорт;
	                                            
Перем мПланыПроизводстваДатаКон Экспорт;
Перем мПланыПродажДатаКон Экспорт;
Перем мЗаказыПокупателейДатаКон Экспорт;
Перем мВнутренниеЗаказыДатаКон Экспорт;
Перем мРасходСоСкладаДатаКон Экспорт;
Перем мРасходНаВыпускДатаКон Экспорт;
	                                            
Перем мПланыПроизводстваИсключить Экспорт;
Перем мПланыПродажИсключить Экспорт;
Перем мЗаказыПокупателейИсключить Экспорт;
Перем мВнутренниеЗаказыИсключить Экспорт;
Перем мРасходСоСкладаИсключить Экспорт;
Перем мРасходНаВыпускИсключить Экспорт;
	
Перем мИзменитьРезультатРасчета Экспорт;
Перем мИзменитьРезультатРасчетаПроцент Экспорт;
Перем мРезультатРасчетаОкруглитьДо Экспорт;
	
Перем мРежимСложенияОбъединения Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ 
// 

#Если Клиент Тогда

// Выполняет настройку построителя отчета.
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	ИдентификаторыСвойств = "";
	ИдентификаторыКатегорий = "";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	1 КАК Источник,
	|	ПланыПроизводстваОбороты.Номенклатура КАК Номенклатура,
	|	ПланыПроизводстваОбороты.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ПланыПроизводстваОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ПланыПроизводстваОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПланыПроизводстваОбороты.КоличествоОборот * &ПланыПроизводстваКоэффициент КАК ЛимитОтпуска
	|ИЗ
	|	РегистрНакопления.ПланыПроизводства.Обороты(&ПланыПроизводстваДатаНач, &ПланыПроизводстваДатаКон,,
	|		&ПланыПроизводства = Истина
	|		И Подразделение = &Подразделение
	|		{
	|		Проект.* 						КАК ПланыПроизводстваПроект,
	|		Номенклатура.* 					КАК ПланыПроизводстваНоменклатура,
	|		ХарактеристикаНоменклатуры.* 	КАК ПланыПроизводстваХарактеристикаНоменклатуры,
	|		ДокументПланирования.* 			КАК ПланыПроизводстваДокументПланирования,
	|		Заказ.* 						КАК ПланыПроизводстваЗаказ}
	|	) КАК ПланыПроизводстваОбороты
	|	//СОЕДИНЕНИЯ_ПЛАНЫПРОИЗВОДСТВА
	|
	|//ОТБОР_ПЛАНЫПРОИЗВОДСТВА{ГДЕ
	|	//СВОЙСТВА_ПЛАНЫПРОИЗВОДСТВА
	|	//КАТЕГОРИИ_ПЛАНЫПРОИЗВОДСТВА
	|//ОТБОР_ПЛАНЫПРОИЗВОДСТВА}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2 КАК Источник,
	|	ПланыПродажОбороты.Номенклатура КАК Номенклатура,
	|	ПланыПродажОбороты.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ПланыПродажОбороты.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ПланыПродажОбороты.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ПланыПродажОбороты.КоличествоОборот * &ПланыПродажКоэффициент КАК ЛимитОтпуска
	|ИЗ
	|	РегистрНакопления.ПланыПродаж.Обороты(&ПланыПродажДатаНач, &ПланыПродажДатаКон, ,
	|		&ПланыПродаж = Истина
	|		И Подразделение = &Подразделение
	|		{
	|		Проект.* 						КАК ПланыПродажПроект,
	|		Номенклатура.* 					КАК ПланыПродажНоменклатура,
	|		ХарактеристикаНоменклатуры.* 	КАК ПланыПродажХарактеристикаНоменклатуры,
	|		ДокументПланирования.* 			КАК ПланыПродажДокументПланирования,
	|		Заказ.* 						КАК ПланыПродажЗаказ}
	|	) КАК ПланыПродажОбороты
	|	//СОЕДИНЕНИЯ_ПЛАНЫПРОДАЖ
	|
	|//ОТБОР_ПЛАНЫПРОДАЖ{ГДЕ
	|	//СВОЙСТВА_ПЛАНЫПРОДАЖ
	|	//КАТЕГОРИИ_ПЛАНЫПРОДАЖ
	|//ОТБОР_ПЛАНЫПРОДАЖ}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3 КАК Источник,
	|	ЗаказыПокупателейОстатки.Номенклатура КАК Номенклатура,
	|	ЗаказыПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ЗаказыПокупателейОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ЗаказыПокупателейОстатки.КоличествоОстаток * &ЗаказыПокупателейКоэффициент КАК ЛимитОтпуска
	|ИЗ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(&ЗаказыПокупателейДатаКон,
	|		&ЗаказыПокупателей = Истина И
	|		((ЗаказПокупателя.ДатаОтгрузки МЕЖДУ &ЗаказыПокупателейДатаНач И &ЗаказыПокупателейДатаКон) ИЛИ
	|		(ЗаказПокупателя.ДатаПоступления МЕЖДУ &ЗаказыПокупателейДатаНач И &ЗаказыПокупателейДатаКон))
	|		И (ЗаказПокупателя.Подразделение = &Подразделение ИЛИ ЗаказПокупателя.Подразделение = &ПустоеПодразделение)
	|		{ДоговорКонтрагента.* 			КАК ЗаказыПокупателейДоговор,
	|		ДоговорКонтрагента.Владелец.* 	КАК ЗаказыПокупателейКонтрагент,
	|		Номенклатура.* 					КАК ЗаказыПокупателейНоменклатура,
	|		ХарактеристикаНоменклатуры.* 	КАК ЗаказыПокупателейХарактеристикаНоменклатуры,
	|		ЗаказПокупателя.* 				КАК ЗаказыПокупателейЗаказПокупателя,
	|		СтатусПартии 					КАК ЗаказыПокупателейСтатусПартии}
	|	) КАК ЗаказыПокупателейОстатки
	|	//СОЕДИНЕНИЯ_ЗАКАЗЫПОКУПАТЕЛЕЙ
	|
	|//ОТБОР_ЗАКАЗЫПОКУПАТЕЛЕЙ{ГДЕ
	|	//СВОЙСТВА_ЗАКАЗЫПОКУПАТЕЛЕЙ
	|	//КАТЕГОРИИ_ЗАКАЗЫПОКУПАТЕЛЕЙ
	|//ОТБОР_ЗАКАЗЫПОКУПАТЕЛЕЙ}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	4 КАК Источник,
	|	ВнутренниеЗаказыОстатки.Номенклатура КАК Номенклатура,
	|	ВнутренниеЗаказыОстатки.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ВнутренниеЗаказыОстатки.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ВнутренниеЗаказыОстатки.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	ВнутренниеЗаказыОстатки.КоличествоОстаток * &ВнутренниеЗаказыКоэффициент КАК ЛимитОтпуска
	|ИЗ
	|	РегистрНакопления.ВнутренниеЗаказы.Остатки(&ВнутренниеЗаказыДатаКон,
	|		&ВнутренниеЗаказы = Истина И
	|		(ВнутреннийЗаказ.ДатаОтгрузки МЕЖДУ &ВнутренниеЗаказыДатаНач И &ВнутренниеЗаказыДатаКон)
	|		{Номенклатура.* 				КАК ВнутренниеЗаказыНоменклатура,
	|		ХарактеристикаНоменклатуры.* 	КАК ВнутренниеЗаказыХарактеристикаНоменклатуры,
	|		ВнутреннийЗаказ.* 				КАК ВнутренниеЗаказыВнутреннийЗаказ,
	|		СтатусПартии 					КАК ВнутренниеЗаказыСтатусПартии}
	|	) КАК ВнутренниеЗаказыОстатки
	|	//СОЕДИНЕНИЯ_ВНУТРЕННИЕЗАКАЗЫ
	|
	|//ОТБОР_ВНУТРЕННИЕЗАКАЗЫ{ГДЕ
	|	//СВОЙСТВА_ВНУТРЕННИЕЗАКАЗЫ
	|	//КАТЕГОРИИ_ВНУТРЕННИЕЗАКАЗЫ
	|//ОТБОР_ВНУТРЕННИЕЗАКАЗЫ}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	5 КАК Источник,
	|	ТоварыНаСкладах.Номенклатура КАК Номенклатура,
	|	ТоварыНаСкладах.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ТоварыНаСкладах.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ТоварыНаСкладах.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	СУММА(ТоварыНаСкладах.КоличествоРасход) * &РасходСоСкладаКоэффициент КАК ЛимитОтпуска
	|ИЗ 
	|	РегистрНакопления.ТоварыНаСкладах.Обороты(&РасходСоСкладаДатаНач, &РасходСоСкладаДатаКон, Регистратор,
	|		&РасходСоСклада = Истина
	|		И Склад = &Склад
	|		{
	|		Номенклатура.* 					КАК РасходСоСкладаНоменклатура,
	|		ХарактеристикаНоменклатуры.* 	КАК РасходСоСкладаХарактеристикаНоменклатуры}
	|	) КАК ТоварыНаСкладах
	|	//СОЕДИНЕНИЯ_РАСХОДСОСКЛАДА
	|
	|ГДЕ
	|	ТоварыНаСкладах.Регистратор ССЫЛКА Документ.ТребованиеНакладная
    |
	|СГРУППИРОВАТЬ ПО
	|	ТоварыНаСкладах.Номенклатура,
	|	ТоварыНаСкладах.Номенклатура.ЕдиницаХраненияОстатков,
	|	ТоварыНаСкладах.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент,
	|	ТоварыНаСкладах.ХарактеристикаНоменклатуры
	|
	|//ОТБОР_РАСХОДСОСКЛАДА{ГДЕ
	|	//СВОЙСТВА_РАСХОДСОСКЛАДА
	|	//КАТЕГОРИИ_РАСХОДСОСКЛАДА
	|//ОТБОР_РАСХОДСОСКЛАДА}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	6 КАК Источник,
	|	ЗатратыНаВыпускПродукции.Затрата КАК Номенклатура,
	|	ЗатратыНаВыпускПродукции.Затрата.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ЗатратыНаВыпускПродукции.Затрата.ЕдиницаХраненияОстатков.Коэффициент КАК Коэффициент,
	|	ЗатратыНаВыпускПродукции.ХарактеристикаЗатраты КАК ХарактеристикаНоменклатуры,
	|	ЗатратыНаВыпускПродукции.КоличествоОборот * &РасходСоСкладаКоэффициент КАК ЛимитОтпуска
	|ИЗ 
	|	РегистрНакопления.ЗатратыНаВыпускПродукции.Обороты(&РасходНаВыпускДатаНач, &РасходНаВыпускДатаКон,,
	|		&РасходНаВыпуск = Истина
	|		И Подразделение = &Подразделение
	|		{
	|		Продукция.* 				КАК РасходНаВыпускПродукция,
	|		ХарактеристикаПродукции.* 	КАК РасходНаВыпускХарактеристикаПродукции,
	|		СтатьяЗатрат.* 				КАК РасходНаВыпускСтатьяЗатрат,
	|		Заказ.* 					КАК РасходНаВыпускЗаказ,
	|		Затрата.* 					КАК РасходНаВыпускНоменклатура,
	|		ХарактеристикаЗатраты.* 	КАК РасходНаВыпускХарактеристикаНоменклатуры}
	|	) КАК ЗатратыНаВыпускПродукции
	|	//СОЕДИНЕНИЯ_РАСХОДНАВЫПУСК
	|
	|//ОТБОР_РАСХОДНАВЫПУСК{ГДЕ
	|	//СВОЙСТВА_РАСХОДНАВЫПУСК
	|	//КАТЕГОРИИ_РАСХОДНАВЫПУСК
	|//ОТБОР_РАСХОДНАВЫПУСК}
	|";
	//|	ВЫБРАТЬ
	//|		ТоварыНаСкладах.Номенклатура КАК Номенклатура,
	//|		ТоварыНаСкладах.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	//|		СУММА(ТоварыНаСкладах.Количество) КАК Количество
	//|	ИЗ
	//|		РегистрНакопления.ТоварыНаСкладах КАК ТоварыНаСкладах
	//|	ГДЕ
	//|		ПартииТоваровНаСкладах.Период МЕЖДУ &РасходСоСкладаДатаНач И &РасходСоСкладаДатаКон
	//|		И &РасходСоСклада = Истина
	//|		И ПартииТоваровНаСкладах.КодОперации В (&МассивКодовОпераций)
	//|		И ПартииТоваровНаСкладах.Склад = &Склад
	//|	СГРУППИРОВАТЬ ПО
	//|		ПартииТоваровНаСкладах.Номенклатура,
	//|		ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры
	//|	) КАК ПартииТоваровНаСкладах
	
	
	//МассивКодовОпераций = Новый Массив;
	//МассивКодовОпераций.Добавить(Перечисления.КодыОперацийПартииТоваров.СписаниеНаБрак);
	//МассивКодовОпераций.Добавить(Перечисления.КодыОперацийПартииТоваров.СписаниеНаВложенияВоВнеоборотныеАктивы);
	//МассивКодовОпераций.Добавить(Перечисления.КодыОперацийПартииТоваров.СписаниеНаЗатраты);
	//МассивКодовОпераций.Добавить(Перечисления.КодыОперацийПартииТоваров.СписаниеНаСтроительствоОбъектовОС);
	//МассивКодовОпераций.Добавить(Перечисления.КодыОперацийПартииТоваров.СписаниеПартийВПроизводствоОперативно);
	//ПостроительОтчета.Параметры.Вставить("МассивКодовОпераций", МассивКодовОпераций);
	
	СтруктураПредставлениеПолей = Новый Структура();
	
	// Планы производства
	СтруктураПредставлениеПолей.Вставить("ПланыПроизводстваПроект",                     "Планы производства - Проект");
	СтруктураПредставлениеПолей.Вставить("ПланыПроизводстваНоменклатура",               "Планы производства - Номенклатура");
	СтруктураПредставлениеПолей.Вставить("ПланыПроизводстваХарактеристикаНоменклатуры", "Планы производства - Характеристика номенклатуры");
	СтруктураПредставлениеПолей.Вставить("ПланыПроизводстваДокументПланирования",       "Планы производства - Документ планирования");
	СтруктураПредставлениеПолей.Вставить("ПланыПроизводстваЗаказ",                      "Планы производства - Заказ покупателя");

	// Планы продаж
	СтруктураПредставлениеПолей.Вставить("ПланыПродажПроект",                     "Планы продаж - Проект");
	СтруктураПредставлениеПолей.Вставить("ПланыПродажНоменклатура",               "Планы продаж - Номенклатура");
	СтруктураПредставлениеПолей.Вставить("ПланыПродажХарактеристикаНоменклатуры", "Планы продаж - Характеристика номенклатуры");
	СтруктураПредставлениеПолей.Вставить("ПланыПродажДокументПланирования",       "Планы продаж - Документ планирования");
	СтруктураПредставлениеПолей.Вставить("ПланыПродажЗаказ",                      "Планы продаж - Заказ покупателя");
	
	// Заказы покупателей
	СтруктураПредставлениеПолей.Вставить("ЗаказыПокупателейДоговор",                    "Заказы покупателей - Договор");
	СтруктураПредставлениеПолей.Вставить("ЗаказыПокупателейКонтрагент",                 "Заказы покупателей - Контрагент");
	СтруктураПредставлениеПолей.Вставить("ЗаказыПокупателейНоменклатура",               "Заказы покупателей - Номенклатура");
	СтруктураПредставлениеПолей.Вставить("ЗаказыПокупателейХарактеристикаНоменклатуры", "Заказы покупателей - Характеристика номенклатуры");
	СтруктураПредставлениеПолей.Вставить("ЗаказыПокупателейЗаказПокупателя",            "Заказы покупателей - Заказ покупателя");
	СтруктураПредставлениеПолей.Вставить("ЗаказыПокупателейСтатусПартии",               "Заказы покупателей - Статус партии");
	
	// Внутренние заказы
	СтруктураПредставлениеПолей.Вставить("ВнутренниеЗаказыНоменклатура",               "Внутренние заказы - Номенклатура");
	СтруктураПредставлениеПолей.Вставить("ВнутренниеЗаказыХарактеристикаНоменклатуры", "Внутренние заказы - Характеристика номенклатуры");
	СтруктураПредставлениеПолей.Вставить("ВнутренниеЗаказыВнутреннийЗаказ",            "Внутренние заказы - Внутренний заказ");
	СтруктураПредставлениеПолей.Вставить("ВнутренниеЗаказыСтатусПартии",               "Внутренние заказы - Статус партии");
	
	// Расход со склада
	СтруктураПредставлениеПолей.Вставить("РасходСоСкладаНоменклатура",               "Расход со склада - Номенклатура");
	СтруктураПредставлениеПолей.Вставить("РасходСоСкладаХарактеристикаНоменклатуры", "Расход со склада - Характеристика номенклатуры");
	
	// Расход на выпуск
	СтруктураПредставлениеПолей.Вставить("РасходНаВыпускПродукция",               "Расход на выпуск - Продукция");
	СтруктураПредставлениеПолей.Вставить("РасходНаВыпускХарактеристикаПродукции", "Расход на выпуск - Характеристика продукции");
	СтруктураПредставлениеПолей.Вставить("РасходНаВыпускСтатьяЗатрат",            "Расход на выпуск - СтатьяЗатрат");
	СтруктураПредставлениеПолей.Вставить("РасходНаВыпускЗаказ", 				  "Расход на выпуск - Заказ");
	СтруктураПредставлениеПолей.Вставить("РасходНаВыпускНоменклатура",                 "Расход на выпуск - Номенклатура");
	СтруктураПредставлениеПолей.Вставить("РасходНаВыпускХарактеристикаНоменклатуры",   "Расход на выпуск - Характеристика номенклатуры");
	
	//Отборы по свойствам и категориям
	мСоответствиеНазначений = Новый Соответствие;

	Если ИспользоватьСвойстваИКатегории = Истина Тогда
		
		ПВХ = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов;
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");
		ТаблицаПолей.Колонки.Добавить("Префикс");
		ТаблицаПолей.Колонки.Добавить("Представление");
		ТаблицаПолей.Колонки.Добавить("Назначение");
		ТаблицаПолей.Колонки.Добавить("НетКатегорий");
		
		// Планы производства
		ТаблицаПолей.Очистить();
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПроизводстваОбороты.Проект";
		СтрокаТаблицы.Префикс = "ПланыПроизводстваПроект";
		СтрокаТаблицы.Представление = "Планы производства - Проект";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Проекты;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПроизводстваОбороты.Номенклатура";
		СтрокаТаблицы.Префикс = "ПланыПроизводстваНоменклатура";
		СтрокаТаблицы.Представление = "Планы производства - Номенклатура";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПроизводстваОбороты.ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Префикс = "ПланыПроизводстваХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Планы производства - Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПроизводстваОбороты.ДокументПланирования";
		СтрокаТаблицы.Префикс = "ПланыПроизводстваДокументПланирования";
		СтрокаТаблицы.Представление = "Планы производства - Документ планирования";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПроизводстваОбороты.ДокументПланирования";
		СтрокаТаблицы.Префикс = "ПланыПроизводстваДокументПланирования";
		СтрокаТаблицы.Представление = "Планы производства - Документ планирования";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Контрагенты;
		СтрокаТаблицы.НетКатегорий = Истина;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПроизводстваОбороты.Заказ";
		СтрокаТаблицы.Префикс = "ПланыПроизводстваЗаказ";
		СтрокаТаблицы.Представление = "Планы производства - Заказ покупателя";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, "//СВОЙСТВА_ПЛАНЫПРОИЗВОДСТВА", "//КАТЕГОРИИ_ПЛАНЫПРОИЗВОДСТВА", "//СОЕДИНЕНИЯ_ПЛАНЫПРОИЗВОДСТВА", "//ОТБОР_ПЛАНЫПРОИЗВОДСТВА", мСтруктураДляОтбораПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий);

		// Планы продаж
		ТаблицаПолей.Очистить();
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПродажОбороты.Проект";
		СтрокаТаблицы.Префикс = "ПланыПродажПроект";
		СтрокаТаблицы.Представление = "Планы продаж - Проект";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Проекты;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПродажОбороты.Номенклатура";
		СтрокаТаблицы.Префикс = "ПланыПродажНоменклатура";
		СтрокаТаблицы.Представление = "Планы продаж - Номенклатура";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПродажОбороты.ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Префикс = "ПланыПродажХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Планы продаж - Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПродажОбороты.ДокументПланирования";
		СтрокаТаблицы.Префикс = "ПланыПродажДокументПланирования";
		СтрокаТаблицы.Представление = "Планы продаж - Документ планирования";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПродажОбороты.ДокументПланирования";
		СтрокаТаблицы.Префикс = "ПланыПродажДокументПланирования";
		СтрокаТаблицы.Представление = "Планы продаж - Документ планирования";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Контрагенты;
		СтрокаТаблицы.НетКатегорий = Истина;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ПланыПродажОбороты.Заказ";
		СтрокаТаблицы.Префикс = "ПланыПродажЗаказ";
		СтрокаТаблицы.Представление = "Планы продаж - Заказ покупателя";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, "//СВОЙСТВА_ПЛАНЫПРОДАЖ", "//КАТЕГОРИИ_ПЛАНЫПРОДАЖ", "//СОЕДИНЕНИЯ_ПЛАНЫПРОДАЖ", "//ОТБОР_ПЛАНЫПРОДАЖ", мСтруктураДляОтбораПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий);
		
		// Заказы покупателей
		ТаблицаПолей.Очистить();
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗаказыПокупателейОстатки.Номенклатура";
		СтрокаТаблицы.Префикс = "ЗаказыПокупателейНоменклатура";
		СтрокаТаблицы.Представление = "Заказы покупателей - Номенклатура";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗаказыПокупателейОстатки.ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Префикс = "ЗаказыПокупателейХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Заказы покупателей - Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗаказыПокупателейОстатки.ДоговорКонтрагента.Владелец";
		СтрокаТаблицы.Префикс = "ЗаказыПокупателейКонтрагент";
		СтрокаТаблицы.Представление = "Заказы покупателей - Контрагент";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Контрагенты;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗаказыПокупателейОстатки.ЗаказПокупателя";
		СтрокаТаблицы.Префикс = "ЗаказыПокупателейЗаказПокупателя";
		СтрокаТаблицы.Представление = "Заказы покупателей - Заказ покупателя";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, "//СВОЙСТВА_ЗАКАЗЫПОКУПАТЕЛЕЙ", "//КАТЕГОРИИ_ЗАКАЗЫПОКУПАТЕЛЕЙ", "//СОЕДИНЕНИЯ_ЗАКАЗЫПОКУПАТЕЛЕЙ", "//ОТБОР_ЗАКАЗЫПОКУПАТЕЛЕЙ", мСтруктураДляОтбораПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий);
		
		// Внутренние заказы
		ТаблицаПолей.Очистить();
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ВнутренниеЗаказыОстатки.Номенклатура";
		СтрокаТаблицы.Префикс = "ВнутренниеЗаказыНоменклатура";
		СтрокаТаблицы.Представление = "Внутренние заказы - Номенклатура";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ВнутренниеЗаказыОстатки.ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Префикс = "ВнутренниеЗаказыХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Внутренние заказы - Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ВнутренниеЗаказыОстатки.ВнутреннийЗаказ";
		СтрокаТаблицы.Префикс = "ВнутренниеЗаказыВнутреннийЗаказ";
		СтрокаТаблицы.Представление = "Внутренние заказы - Внутренний заказ";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, "//СВОЙСТВА_ВНУТРЕННИЕЗАКАЗЫ", "//КАТЕГОРИИ_ВНУТРЕННИЕЗАКАЗЫ", "//СОЕДИНЕНИЯ_ВНУТРЕННИЕЗАКАЗЫ", "//ОТБОР_ВНУТРЕННИЕЗАКАЗЫ", мСтруктураДляОтбораПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий);
		
		// Расход со склада
		ТаблицаПолей.Очистить();
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ТоварыНаСкладах.Номенклатура";
		СтрокаТаблицы.Префикс = "РасходСоСкладаНоменклатура";
		СтрокаТаблицы.Представление = "Расход со склада - Номенклатура";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ТоварыНаСкладах.ХарактеристикаНоменклатуры";
		СтрокаТаблицы.Префикс = "РасходСоСкладаХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Расход со склада - Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, "//СВОЙСТВА_РАСХОДСОСКЛАДА", "//КАТЕГОРИИ_РАСХОДСОСКЛАДА", "//СОЕДИНЕНИЯ_РАСХОДСОСКЛАДА", "//ОТБОР_РАСХОДСОСКЛАДА", мСтруктураДляОтбораПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий);
		
		// Расход на выпуск
		ТаблицаПолей.Очистить();
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗатратыНаВыпускПродукции.Затрата";
		СтрокаТаблицы.Префикс = "РасходНаВыпускНоменклатура";
		СтрокаТаблицы.Представление = "Расход на выпуск - Номенклатура";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗатратыНаВыпускПродукции.ХарактеристикаЗатраты";
		СтрокаТаблицы.Префикс = "РасходНаВыпускХарактеристикаНоменклатуры";
		СтрокаТаблицы.Представление = "Расход на выпуск - Характеристика номенклатуры";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗатратыНаВыпускПродукции.Продукция";
		СтрокаТаблицы.Префикс = "РасходНаВыпускПродукция";
		СтрокаТаблицы.Представление = "Расход на выпуск - Продукция";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_Номенклатура;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗатратыНаВыпускПродукции.ХарактеристикаПродукции";
		СтрокаТаблицы.Префикс = "РасходНаВыпускХарактеристикаПродукции";
		СтрокаТаблицы.Представление = "Расход на выпуск - Характеристика продукции";
		СтрокаТаблицы.Назначение = ПВХ.Справочник_ХарактеристикиНоменклатуры;
		
		СтрокаТаблицы = ТаблицаПолей.Добавить();
		СтрокаТаблицы.ПутьКДанным = "ЗатратыНаВыпускПродукции.Заказ";
		СтрокаТаблицы.Префикс = "РасходНаВыпускЗаказ";
		СтрокаТаблицы.Представление = "Расход на выпуск - Заказ";
		СтрокаТаблицы.Назначение = ПВХ.Документы;
		
		ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, ТекстЗапроса, СтруктураПредставлениеПолей, мСоответствиеНазначений, ПостроительОтчета.Параметры, "//СВОЙСТВА_РАСХОДНАВЫПУСК", "//КАТЕГОРИИ_РАСХОДНАВЫПУСК", "//СОЕДИНЕНИЯ_РАСХОДНАВЫПУСК", "//ОТБОР_РАСХОДНАВЫПУСК", мСтруктураДляОтбораПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий);
		
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстЗапроса) = Ложь Тогда
		
		ПостроительОтчета.Текст = ТекстЗапроса;
		
	КонецЕсли;
	
	УстановитьТипыЗначенийСвойствИКатегорийДляОтбораЛокально(ПостроительОтчета, мСоответствиеНазначений, СтруктураПредставлениеПолей, ИдентификаторыСвойств, ИдентификаторыКатегорий);
	
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(СтруктураПредставлениеПолей, ПостроительОтчета);
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки()

// Процедура добавляет в текст запроса свойства и категории.
//
Процедура ДобавитьВТекстСвойстваИКатегорииЛокально(ТаблицаПолей, Текст, СтруктураПредставлениеПолей,
												   СоответствиеНазначений, СтруктураПараметры,
												   ЗаменятьСвойства, ЗаменятьКатегории, ЗаменятьСоединения, ЗаменятьОтбор,
												   ИдентификаторыПараметровДляОтборовПоКатегориям, ИдентификаторыСвойств, ИдентификаторыКатегорий)

	ТекстИсточникиСведений = "";
	ТекстПоляКатегорий = "";
	ТекстПоляСвойств = "";
	
	Если ТипЗнч(ИдентификаторыПараметровДляОтборовПоКатегориям) <> Тип("Структура") Тогда
		
		ИдентификаторыПараметровДляОтборовПоКатегориям = Новый Структура;
		
	КонецЕсли;

	Индекс = 0;

	СвойстваОбъектов = ПланыВидовХарактеристик.СвойстваОбъектов.Выбрать();
	
	Пока СвойстваОбъектов.Следующий() Цикл

		Если СвойстваОбъектов.ЭтоГруппа ИЛИ СвойстваОбъектов.ПометкаУдаления Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если СвойстваОбъектов.ТипЗначения.Типы().Количество() > 1 Тогда
			
			ПараметрПустоеЗначениеСвойства = "Неопределено";
			
		Иначе
			
			ТипСвойства = СвойстваОбъектов.ТипЗначения.Типы()[0];
			ВозможныеТипыСвойств = Метаданные.ПланыВидовХарактеристик.СвойстваОбъектов.Тип.Типы();
			
			ИндексТекущегоВозможногоТипа = 0;
			
			Для каждого ВозможныйТипСвойства из ВозможныеТипыСвойств Цикл
				
				Если ВозможныйТипСвойства = ТипСвойства Тогда
					
					ПараметрПустоеЗначениеСвойства = "&ПараметрПустоеЗначениеСвойства" + ИндексТекущегоВозможногоТипа;
					
				КонецЕсли;
				
				ИндексТекущегоВозможногоТипа = ИндексТекущегоВозможногоТипа + 1;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Поля = ТаблицаПолей.НайтиСтроки(Новый Структура("Назначение", СвойстваОбъектов.НазначениеСвойства));
		
		Для каждого Поле из Поля Цикл

			ИмяТаблицы = Поле.Префикс + "Свойство" + Индекс;
			ИдентификаторыСвойств = ИдентификаторыСвойств + ИмяТаблицы + "Значение;";
			
			ТекстПоляСвойств = ТекстПоляСвойств + ?(НЕ ПустаяСтрока(ТекстПоляСвойств), ",", "") + "
			|	ЕСТЬNULL (" + ИмяТаблицы + ".Значение, " + ПараметрПустоеЗначениеСвойства + ") КАК " + ИмяТаблицы + "Значение";
			
			ТекстИсточникиСведений = ТекстИсточникиСведений + Символы.ПС + 
			"	{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК " + ИмяТаблицы + "
			|	ПО " + ИмяТаблицы + ".Объект = " + Поле.ПутьКДанным + "
			|	И " + ИмяТаблицы + ".Свойство = &Параметр" + ИмяТаблицы + "}";

			СтруктураПараметры.Вставить("Параметр" + ИмяТаблицы, СвойстваОбъектов.Ссылка);
			СтруктураПредставлениеПолей.Вставить(ИмяТаблицы + "Значение", Поле.Представление + " (св-во " + СвойстваОбъектов.Наименование + ")");
			СоответствиеНазначений.Вставить(Поле.Представление + " (св-во " + СвойстваОбъектов.Наименование + ")", СвойстваОбъектов.Ссылка);

			Индекс = Индекс + 1;

		КонецЦикла;

	КонецЦикла;

	Для каждого Поле Из ТаблицаПолей Цикл

		Если Поле.НетКатегорий <> Истина Тогда
			
			ИмяТаблицы = Поле.Префикс + "Категории" + Индекс;
			ИдентификаторыКатегорий = ИдентификаторыКатегорий + ИмяТаблицы + "Категория;";

			ТекстИсточникиСведений = ТекстИсточникиСведений + Символы.ПС + 
			"{ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КатегорииОбъектов КАК " + ИмяТаблицы + "
			|ПО " + ИмяТаблицы + ".Объект = " + Поле.ПутьКДанным + "
			|И " + ИмяТаблицы + ".Категория В (&Параметр" + ИмяТаблицы + ")}";

			ТекстПоляКатегорий = ТекстПоляКатегорий + ?(НЕ ПустаяСтрока(ТекстПоляСвойств) ИЛИ НЕ ПустаяСтрока(ТекстПоляКатегорий), ",", "") + "
			|	ВЫБОР КОГДА " + ИмяТаблицы + ".Категория ЕСТЬ НЕ NULL ТОГДА
			|		" + ИмяТаблицы + ".Категория
			|	ИНАЧЕ
			|		"+ Поле.ПутьКДанным + "
			|	КОНЕЦ КАК " + ИмяТаблицы + "Категория";

			ИдентификаторыПараметровДляОтборовПоКатегориям.Вставить(ИмяТаблицы + "Категория", "Параметр" + ИмяТаблицы);
			СтруктураПредставлениеПолей.Вставить(ИмяТаблицы + "Категория", Поле.Представление + " (категории)");
			СоответствиеНазначений.Вставить(Поле.Представление + " (категории)", Поле.Назначение);

			Индекс = Индекс + 1;

		КонецЕсли; 
	
	КонецЦикла; 

	Если НЕ ПустаяСтрока(ТекстПоляСвойств) ИЛИ НЕ ПустаяСтрока(ТекстПоляКатегорий) Тогда
		
		Текст = СтрЗаменить(Текст, ЗаменятьОтбор, "");	
		
	КонецЕсли;
	
	Текст = СтрЗаменить(Текст, ЗаменятьСвойства, ТекстПоляСвойств);
	Текст = СтрЗаменить(Текст, ЗаменятьКатегории, ТекстПоляКатегорий);
	Текст = СтрЗаменить(Текст, ЗаменятьСоединения, ТекстИсточникиСведений);

КонецПроцедуры // ДобавитьВТекстСвойстваИКатегорииЛокально()

// Процедура устанавливает типы значений свойств и категорий.
//
Процедура УстановитьТипыЗначенийСвойствИКатегорийДляОтбораЛокально(ПостроительОтчета, СоответствиеНазначений, СтруктураПредставлениеПолей, ИдентификаторыСвойств, ИдентификаторыКатегорий)
	
	Для каждого КлючИЗначение из СтруктураПредставлениеПолей Цикл
		
		Если Найти(ИдентификаторыСвойств, КлючИЗначение.Ключ + ";") > 0 Тогда
			
			Назначение = СоответствиеНазначений.Получить(КлючИЗначение.Значение);
			Если Назначение = Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;

			ДоступноеПоле = ПостроительОтчета.ДоступныеПоля.Найти(КлючИЗначение.Ключ);
			Если ДоступноеПоле = Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;

			Если ДоступноеПоле.Отбор Тогда
				
				ДоступноеПоле.ТипЗначения = Назначение.ТипЗначения;
				
			КонецЕсли;

		ИначеЕсли Найти(ИдентификаторыКатегорий, КлючИЗначение.Ключ + ";") > 0 Тогда

			ДоступноеПоле = ПостроительОтчета.ДоступныеПоля.Найти(КлючИЗначение.Ключ);

			Если ДоступноеПоле <> Неопределено Тогда
				
				ДоступноеПоле.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.КатегорииОбъектов");
				
			КонецЕсли;
			
		КонецЕсли;
			
	КонецЦикла;
	
	ВозможныеТипыСвойств = Метаданные.ПланыВидовХарактеристик.СвойстваОбъектов.Тип.Типы();
	
	ИндексТекущегоВозможногоТипа = 0;
			
	Для каждого ВозможныйТипСвойства из ВозможныеТипыСвойств Цикл
				
		ПостроительОтчета.Параметры.Вставить("ПараметрПустоеЗначениеСвойства" + ИндексТекущегоВозможногоТипа, ОбщегоНазначения.ПустоеЗначениеТипа(ВозможныйТипСвойства));
		ИндексТекущегоВозможногоТипа = ИндексТекущегоВозможногоТипа + 1;
				
	КонецЦикла;
		
КонецПроцедуры // УстановитьТипыЗначенийСвойствИКатегорийДляОтбораЛокально()

// Функция устанавливает параметры потроителя отчета.
//
Функция УстановитьПараметрыПостроителя(ПостроительОтчета) Экспорт
	
	ПостроительОтчета.Параметры.Вставить("ПланыПроизводства", 	мПланыПроизводства);
	ПостроительОтчета.Параметры.Вставить("ПланыПродаж",       	мПланыПродаж);
	ПостроительОтчета.Параметры.Вставить("ЗаказыПокупателей", 	мЗаказыПокупателей);
	ПостроительОтчета.Параметры.Вставить("ВнутренниеЗаказы",  	мВнутренниеЗаказы);
	ПостроительОтчета.Параметры.Вставить("РасходСоСклада", 		мРасходСоСклада);
	ПостроительОтчета.Параметры.Вставить("РасходНаВыпуск", 		мРасходНаВыпуск);
	
	ПостроительОтчета.Параметры.Вставить("ПланыПроизводстваДатаНач", 	мПланыПроизводстваДатаНач);
	ПостроительОтчета.Параметры.Вставить("ПланыПроизводстваДатаКон", 	ПолучитьКонецИнтервала(мПланыПроизводстваДатаКон));
	ПостроительОтчета.Параметры.Вставить("ПланыПродажДатаНач", 			мПланыПродажДатаНач);
	ПостроительОтчета.Параметры.Вставить("ПланыПродажДатаКон", 			ПолучитьКонецИнтервала(мПланыПродажДатаКон));
	ПостроительОтчета.Параметры.Вставить("ЗаказыПокупателейДатаНач", 	мЗаказыПокупателейДатаНач);
	ПостроительОтчета.Параметры.Вставить("ЗаказыПокупателейДатаКон", 	ПолучитьКонецИнтервала(мЗаказыПокупателейДатаКон));
	ПостроительОтчета.Параметры.Вставить("ВнутренниеЗаказыДатаНач",  	мВнутренниеЗаказыДатаНач);
	ПостроительОтчета.Параметры.Вставить("ВнутренниеЗаказыДатаКон",  	ПолучитьКонецИнтервала(мВнутренниеЗаказыДатаКон));
	ПостроительОтчета.Параметры.Вставить("РасходСоСкладаДатаНач", 		мРасходСоСкладаДатаНач);
	ПостроительОтчета.Параметры.Вставить("РасходСоСкладаДатаКон", 		ПолучитьКонецИнтервала(мРасходСоСкладаДатаКон));
	ПостроительОтчета.Параметры.Вставить("РасходНаВыпускДатаНач", 		мРасходНаВыпускДатаНач);
	ПостроительОтчета.Параметры.Вставить("РасходНаВыпускДатаКон", 		ПолучитьКонецИнтервала(мРасходНаВыпускДатаКон));
	
	ПостроительОтчета.Параметры.Вставить("ПланыПроизводстваКоэффициент", 	ПолучитьКоэффициент(мПланыПроизводстваИсключить, мПланыПроизводстваПроцент));
	ПостроительОтчета.Параметры.Вставить("ПланыПродажКоэффициент",			ПолучитьКоэффициент(мПланыПродажИсключить,       мПланыПродажПроцент));
	ПостроительОтчета.Параметры.Вставить("ЗаказыПокупателейКоэффициент", 	ПолучитьКоэффициент(мЗаказыПокупателейИсключить, мЗаказыПокупателейПроцент));
	ПостроительОтчета.Параметры.Вставить("ВнутренниеЗаказыКоэффициент",  	ПолучитьКоэффициент(мВнутренниеЗаказыИсключить,  мВнутренниеЗаказыПроцент));
	ПостроительОтчета.Параметры.Вставить("РасходСоСкладаКоэффициент", 		ПолучитьКоэффициент(мРасходСоСкладаИсключить, 	 мРасходСоСкладаПроцент));
	ПостроительОтчета.Параметры.Вставить("РасходНаВыпускКоэффициент", 		ПолучитьКоэффициент(мРасходНаВыпускИсключить, 	 мРасходНаВыпускПроцент));
	
	ПостроительОтчета.Параметры.Вставить("ПустойЗаказ",			Документы.ЗаказПокупателя.ПустаяСсылка());
	ПостроительОтчета.Параметры.Вставить("Склад",				Склад);
	ПостроительОтчета.Параметры.Вставить("Подразделение",		Подразделение);
	ПостроительОтчета.Параметры.Вставить("ПустоеПодразделение",	Справочники.Подразделения.ПустаяСсылка());

	Для каждого СтрокаОтбора Из ПостроительОтчета.Отбор Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаОтбора.ПутьКДанным) Тогда
			
			Предупреждение("В отборе не должно быть пустых полей!", 30);
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЦикла;

	Возврат УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям);

КонецФункции // УстановитьПараметрыПостроителя()

// Функция возвращает конец периода.
//
Функция ПолучитьКонецИнтервала(Дата)
	
	Возврат ?(Дата = '00010101000000', Дата, КонецДня(Дата));
		
КонецФункции // ПолучитьКонецИнтервала()

// Функция вычисляет коэффициент.
//
Функция ПолучитьКоэффициент(Исключить, Процент)
	
	Возврат ?(Исключить, -1, 1) * Процент / 100;
	
КонецФункции // ПолучитьКоэффициент()

// Процедура рассчитывает плановую себестоимость.
//
Процедура РассчитатьЛимитыОтпускаМатериалов() Экспорт
	
	Если НЕ УстановитьПараметрыПостроителя(ПостроительОтчета) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПостроительОтчета.Выполнить();
	
	Если ПостроительОтчета.Результат.Пустой() Тогда
		
		Предупреждение("По указанным стратегиям расчета данные не выбраны!");
		Возврат;
		
	КонецЕсли;
	
	ТаблицаЗапроса = ПостроительОтчета.Результат.Выгрузить();
	
	СложениеОбъединениеПланов(ТаблицаЗапроса);
	
	КоэфИзменения = 1 + ?(мИзменитьРезультатРасчета, мИзменитьРезультатРасчетаПроцент / 100, 0);
	
	Для Каждого Строка Из ТаблицаЗапроса Цикл
		
		Строка.ЛимитОтпуска = Окр(Строка.ЛимитОтпуска * КоэфИзменения, мРезультатРасчетаОкруглитьДо, 1);
		
	КонецЦикла;
	
	// по первым четырем стратегиям необходимо проводить разузлование
	ТаблицаЗапроса.Колонки.ЛимитОтпуска.Имя = "Количество";
	ТаблицаПродукции = ТаблицаЗапроса.СкопироватьКолонки();
	ТаблицаПродукции.Колонки.Добавить("Спецификация");
	
	Сч = 0;
	Пока Сч < ТаблицаЗапроса.Количество() Цикл
		СтрокаТаблицы = ТаблицаЗапроса.Получить(Сч);
		Если СтрокаТаблицы.Источник < 5 
		   И (СтрокаТаблицы.Номенклатура.ВидВоспроизводства = Перечисления.ВидыВоспроизводстваНоменклатуры.Производство
		   ИЛИ СтрокаТаблицы.Номенклатура.ВидВоспроизводства = Перечисления.ВидыВоспроизводстваНоменклатуры.Переработка) Тогда
		   
		    Спецификация = УправлениеПроизводством.ОпределитьСпецификациюПоУмолчанию(СтрокаТаблицы.Номенклатура, СтрокаТаблицы.ХарактеристикаНоменклатуры, РабочаяДата);
			
			Если ЗначениеЗаполнено(Спецификация) Тогда
			   	НоваяСтрока = ТаблицаПродукции.Добавить();
				НоваяСтрока.Спецификация = Спецификация;
				ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТаблицы);
				
				ТаблицаЗапроса.Удалить(СтрокаТаблицы);
			Иначе
				Сч = Сч + 1;
			КонецЕсли;
		Иначе
			Сч = Сч + 1;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПродукции.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Коэффициент, Спецификация", "Количество");

	СтруктураДопКолонок = Новый Структура();
	Отбор = Новый Структура();
	ДатаСпецификации = РабочаяДата;
	
	УправлениеПроизводством.ЗаполнитьМатериалыПоСпецификациям(ТаблицаЗапроса, ТаблицаПродукции, СтруктураДопКолонок, Отбор, ДатаСпецификации, 0);
	
	ТаблицаЗапроса.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Коэффициент", "Количество");
	
	ТаблицаЗапроса.Колонки.Количество.Имя = "ЛимитОтпуска";
	
	Лимиты.Загрузить(ТаблицаЗапроса);
	
КонецПроцедуры // РассчитатьЛимитыОтпускаМатериалов()

#КонецЕсли

// Процедура производит сложение или объединение рассчитанных данных.
//
Процедура СложениеОбъединениеПланов(ТаблицаИсточник)
	
	Если ТаблицаИсточник.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	
	Если мРежимСложенияОбъединения = 0 Тогда      // Сложение
		
		ТаблицаИсточник.Свернуть("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Коэффициент, Источник", "ЛимитОтпуска");
		
	ИначеЕсли мРежимСложенияОбъединения = 1 Тогда // Объединение
		
		ТаблицаИсточник.Сортировать("Номенклатура, ХарактеристикаНоменклатуры, ЕдиницаИзмерения, Коэффициент, Источник, ЛимитОтпуска Убыв");
		
	КонецЕсли;
	
	Если мРежимСложенияОбъединения = 1 Тогда
		
		Индекс = 1;

		Пока Индекс < ТаблицаИсточник.Количество() Цикл
			
			Если ТаблицаИсточник[Индекс].Номенклатура               = ТаблицаИсточник[Индекс - 1].Номенклатура И
				 ТаблицаИсточник[Индекс].ХарактеристикаНоменклатуры = ТаблицаИсточник[Индекс - 1].ХарактеристикаНоменклатуры И
				 ТаблицаИсточник[Индекс].ЕдиницаИзмерения           = ТаблицаИсточник[Индекс - 1].ЕдиницаИзмерения И
				 ТаблицаИсточник[Индекс].Коэффициент                = ТаблицаИсточник[Индекс - 1].Коэффициент Тогда
				 
				ТаблицаИсточник.Удалить(Индекс);
				
			Иначе
				
				Индекс = Индекс + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // СложениеОбъединениеПланов()

мВалютаУправленческогоУчета     = глЗначениеПеременной("ВалютаУправленческогоУчета");
