Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

// Выполняет приход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьПриход() Экспорт

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Приход);

КонецПроцедуры // ВыполнитьПриход()

// Выполняет расход по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьРасход() Экспорт

	ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект, ВидДвиженияНакопления.Расход);

КонецПроцедуры // ВыполнитьРасход()

// Выполняет движения по регистру.
//
// Параметры:
//  Нет.
//
Процедура ВыполнитьДвижения() Экспорт

	Загрузить(мТаблицаДвижений);

КонецПроцедуры // ВыполнитьДвижения()

// Процедура контролирует остаток по данному регистру по переданному документу
// и его табличной части. В случае недостатка товаров выставляется флаг отказа и 
// выдается сообщение.
//
// Параметры:
//  ДокументОбъект    - объект проводимого документа, 
//  ИмяТабличнойЧасти - строка, имя табличной части, которая проводится по регистру, 
//  СтруктураШапкиДокумента - структура, содержащая значения "через точку" ссылочных реквизитов по шапке документа,
//  Отказ             - флаг отказа в проведении,
//  Заголовок         - строка, заголовок сообщения об ошибке проведения.
//
Процедура КонтрольОстатков(ДокументОбъект, ИмяТабличнойЧасти, СтруктураШапкиДокумента, Отказ, Заголовок, РежимПроведения) Экспорт
	
	Если РежимПроведения <> РежимПроведенияДокумента.Оперативный
		ИЛИ ДокументОбъект[ИмяТабличнойЧасти].Количество() = 0 Тогда
		
		Возврат;
	КонецЕсли;
	
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	ИмяДокумента        = МетаданныеДокумента.Имя;
	МетаданныеТабЧастиДокумента = МетаданныеДокумента.ТабличныеЧасти.Найти(ИмяТабличнойЧасти);

	ЕстьХарактеристика  = МетаданныеТабЧастиДокумента.Реквизиты.Найти("ХарактеристикаНоменклатуры") <> Неопределено;
	
	флКонтролироватьЦену = ложь;
	Если ИмяДокумента = "КорректировкаЗаказаПоставщику" Тогда
        флКонтролироватьЦену = истина;
		ЗаказПоставщику     = СтруктураШапкиДокумента.Ссылка;
	Иначе
		ЗаказПоставщику     = СтруктураШапкиДокумента.Сделка;
	КонецЕсли;
	
	текСтатусПартии = Перечисления.СтатусыПартийТоваров.Купленный;
	Если ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВозвратнаяТара;
	ИначеЕсли ИмяТабличнойЧасти = "Оборудование" Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.Оборудование;
	ИначеЕсли ИмяТабличнойЧасти = "Продукция" Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.Продукция;
    ИначеЕсли ИмяТабличнойЧасти = "ИспользованныеМатериалы" Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
	ИначеЕсли ИмяДокумента = "ПолучениеУслугПоПереработке" Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
	ИначеЕсли ИмяДокумента = "КорректировкаЗаказаПоставщику" Тогда
		Если ЗаказПоставщику.ВидОперации = Перечисления.ВидыОперацийЗаказПоставщику.Переработка Тогда
			текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
		КонецЕсли;
	ИначеЕсли ИмяДокумента = "ПоступлениеТоваровУслуг" Тогда
		 Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда
			текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
		 КонецЕсли;
	КонецЕсли; 
	

	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
    СтруктураПараметров = новый Структура("МетаданныеДокумента,МетаданныеТабЧастиДокумента,ИмяДокумента,ИмяТабличнойЧасти,Ссылка,ЕстьХарактеристика,СтруктураШапкиДокумента,ЗаказПоставщику,флКонтролироватьЦену",
		МетаданныеДокумента,МетаданныеТабЧастиДокумента,ИмяДокумента,ИмяТабличнойЧасти,ДокументОбъект.Ссылка,ЕстьХарактеристика,СтруктураШапкиДокумента,ЗаказПоставщику,флКонтролироватьЦену);

	СформироватьВременнуюТаблицуДокумента(МенеджерВременныхТаблиц,СтруктураПараметров);

	 Если глЗначениеПеременной("ИспользоватьБлокировкуДанных")  Тогда

		СтруктураПараметровБлокировки = Новый Структура(
			"ТипТаблицы,ИмяТаблицы,ИсточникДанных,ИмяВременнойТаблицы"
			,"РегистрНакопления"
			,"ЗаказыПоставщикам"
			,МенеджерВременныхТаблиц
			,"ВременнаяТаблицаДокумента");
			
		СтруктураИсточникаДанных = Новый Структура(
			"ДоговорКонтрагента,ЗаказПоставщику,Номенклатура"
			,"ДоговорКонтрагента"
			,"ЗаказПоставщику"
			,"Номенклатура"
			);
		Если ЕстьХарактеристика Тогда
			СтруктураИсточникаДанных.Вставить("ХарактеристикаНоменклатуры","ХарактеристикаНоменклатуры");
		КонецЕсли;
			
		Если флКонтролироватьЦену Тогда
			СтруктураИсточникаДанных.Вставить("Цена","Цена");
		КонецЕсли;
		СтруктураЗначенийБлокировки = новый Структура("СтатусПартии",текСтатусПартии);
	
		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки,СтруктураЗначенийБлокировки,СтруктураИсточникаДанных, Отказ, Заголовок);
		
	КонецЕсли; 

	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц; 

	// Установим параметры запроса
    Запрос.УстановитьПараметр("СтатусПартии", текСтатусПартии);

	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.ЗаказПоставщику 								   КАК ЗаказПоставщику,
	|	Док.Номенклатура 									   КАК Номенклатура,
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,"
	+ ?(ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры				           КАК ХарактеристикаНоменклатуры,"
	,"")
	+?(флКонтролироватьЦену,"
	|	Док.Цена 											   КАК Цена,","")+"
	| 	СУММА(Док.ДокументКоличество)                          КАК ДокументКоличество,
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0)       КАК ОстатокКоличество
	|ИЗ 
	|	ВременнаяТаблицаДокумента КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ЗаказыПоставщикам.Остатки(, 
	|		(ДоговорКонтрагента,ЗаказПоставщику,Номенклатура"+?(ЕстьХарактеристика,",ХарактеристикаНоменклатуры","")+") В (ВЫБРАТЬ ДоговорКонтрагента,ЗаказПоставщику,Номенклатура"+?(ЕстьХарактеристика,",ХарактеристикаНоменклатуры","")+" ИЗ ВременнаяТаблицаДокумента)
	|   И СтатусПартии = &СтатусПартии
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	| И Док.ХарактеристикаНоменклатуры  = Остатки.ХарактеристикаНоменклатуры"
	,"") 
	+ ?(флКонтролироватьЦену, "
	| И Док.Цена  					    = Остатки.Цена", "")
	+ "
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура,
	|	Док.ЗаказПоставщику"
	+ ?(ЕстьХарактеристика, "
	|	, Док.ХарактеристикаНоменклатуры "
	,"") 
	+ ?(флКонтролироватьЦену, ",
	|	Док.Цена ", "")	+"
	|
	|ИМЕЮЩИЕ ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) < СУММА(Док.ДокументКоличество)
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ЗаказыПоставщикам.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
	|";
    РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;

	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл

		СтрокаСообщения = "Остатка " + 
		УправлениеЗапасами.ПредставлениеНоменклатуры(Выборка.НоменклатураПредставление, 
								  ?(ЕстьХарактеристика, Выборка.ХарактеристикаНоменклатуры, "")) +
		", заказанного по документу " + (Выборка.ЗаказПоставщику)+?(флКонтролироватьЦену," с ценой " + ОбщегоНазначения.ФорматСумм(Выборка.Цена),"") +  " недостаточно.";

		УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокКоличество, Выборка.ДокументКоличество,
		Выборка.ЕдиницаХраненияОстатковПредставление, Отказ, Заголовок);

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

Процедура СформироватьВременнуюТаблицуДокумента(МенеджерВременныхТаблиц, СтруктураПараметров)
	ИмяТаблицы          = СтруктураПараметров.ИмяДокумента + "." + СокрЛП(СтруктураПараметров.ИмяТабличнойЧасти);
	МетаданныеТабЧастиДокумента = СтруктураПараметров.МетаданныеТабЧастиДокумента;

    ЕстьКоэффициент     = МетаданныеТабЧастиДокумента.Реквизиты.Найти("Коэффициент") <> Неопределено;
	СтруктураШапкиДокумента = СтруктураПараметров.СтруктураШапкиДокумента;
	
	ТекстУсловияКоличество = "";
	Если ЕстьКоэффициент Тогда
		ТекстКоличество = "ВЫРАЗИТЬ(СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Число(15,3))";
	Иначе
		ТекстКоличество = "СУММА(Док.Количество)";
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Если СтруктураПараметров.ИмяДокумента = "КорректировкаЗаказаПоставщику" Тогда
		Запрос.УстановитьПараметр("ДокументСсылка",  СтруктураПараметров.Ссылка);
		ТекстКоличество = "-1 * "+ТекстКоличество;
		ТекстУсловияКоличество = " И Док.Количество<0";
	Иначе
		Запрос.УстановитьПараметр("ДокументСсылка",  СтруктураШапкиДокумента.Ссылка);
	КонецЕсли;
    Запрос.УстановитьПараметр("ЗаказПоставщику", СтруктураПараметров.ЗаказПоставщику);
    Запрос.УстановитьПараметр("ДоговорКонтрагента", СтруктураПараметров.ЗаказПоставщику.ДоговорКонтрагента);
	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	&ЗаказПоставщику 									   КАК ЗаказПоставщику,
	|	&ДоговорКонтрагента 								   КАК ДоговорКонтрагента,
	|	Док.Номенклатура 									   КАК Номенклатура,"
	+?(СтруктураПараметров.флКонтролироватьЦену,"
	|	Док.Цена 											   КАК Цена,","")
	+ ?(СтруктураПараметров.ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры				           КАК ХарактеристикаНоменклатуры,"
	,"")+"
	|"+ТекстКоличество+"                                       КАК ДокументКоличество
	|ПОМЕСТИТЬ ВременнаяТаблицаДокумента
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
    |ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка  "+ТекстУсловияКоличество+"
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура"
	+ ?(СтруктураПараметров.флКонтролироватьЦену, "
	|	, Док.Цена "
	,"")
	+ ?(СтруктураПараметров.ЕстьХарактеристика, "
	|	, Док.ХарактеристикаНоменклатуры "
	,"")+"
	|";
    Запрос.Выполнить();
КонецПроцедуры