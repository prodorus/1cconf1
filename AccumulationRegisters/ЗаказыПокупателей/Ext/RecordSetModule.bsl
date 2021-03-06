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

// Процедура контролирует объем отгрузки по заказу, с проверкой прав пользователя
//
Процедура КонтрольПревышенияОбъемаЗаказа(ДокОбъект, СтруктураШапкиДокумента, ИмяТЧ, Отказ, Заголовок, РежимПроведения) Экспорт
	
	Если РежимПроведения <> РежимПроведенияДокумента.Оперативный Тогда
		Возврат;
	КонецЕсли;
	 
	Если СтруктураШапкиДокумента.Свойство("Заказ") Тогда
		ДокЗаказ = СтруктураШапкиДокумента.Заказ;
	ИначеЕсли СтруктураШапкиДокумента.Свойство("Сделка") Тогда
		ДокЗаказ = СтруктураШапкиДокумента.Сделка;
	Иначе
		Возврат;
	КонецЕсли;
	НуженКонтроль = НЕ УправлениеДопПравамиПользователей.РазрешеноПревышениеОбъемаЗаказаПриОтгрузке();

	Если НуженКонтроль Тогда
		КонтрольОстатков(ДокОбъект, ИмяТЧ, СтруктураШапкиДокумента, Отказ, Заголовок, РежимПроведения);
	КонецЕсли;
	
КонецПроцедуры // КонтрольПревышенияОбъемаЗаказа()

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
	флКонтролироватьСкидки = ложь;

	Если ИмяДокумента = "КорректировкаЗаказаПокупателя" Тогда
		флКонтролироватьЦену = истина;
		Если ИмяТабличнойЧасти = "Товары" или ИмяТабличнойЧасти = "Услуги" Тогда
			флКонтролироватьСкидки = истина;
		КонецЕсли;
	КонецЕсли;
	
	текСтатусПартии = Перечисления.СтатусыПартийТоваров.Купленный;
	Если ИмяДокумента = "ПередачаТоваров"
		ИЛИ ИмяДокумента = "РеализацияУслугПоПереработке"
		ИЛИ (ИмяДокумента = "РезервированиеТоваров" 
			И СтруктураШапкиДокумента.ЗаказВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.Переработка)
		Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
	ИначеЕсли ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВозвратнаяТара;
	ИначеЕсли ИмяДокумента = "КорректировкаЗаказаПокупателя" Тогда
		Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.Переработка Тогда
			текСтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
        КонецЕсли;
	КонецЕсли;

	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
    СтруктураПараметров = новый Структура("МетаданныеДокумента,МетаданныеТабЧастиДокумента,ИмяДокумента,ИмяТабличнойЧасти,ЕстьХарактеристика,флКонтролироватьЦену, флКонтролироватьСкидки",
		МетаданныеДокумента,МетаданныеТабЧастиДокумента,ИмяДокумента,ИмяТабличнойЧасти,ЕстьХарактеристика,флКонтролироватьЦену, флКонтролироватьСкидки);
	Если  ИмяДокумента = "КорректировкаЗаказаПокупателя" Тогда
		СтруктураПараметров.Вставить("Ссылка",ДокументОбъект.Ссылка);
		текЗаказПокупателя = СтруктураШапкиДокумента.Ссылка;
	Иначе
		СтруктураПараметров.Вставить("Ссылка",СтруктураШапкиДокумента.Ссылка);
		текЗаказПокупателя = СтруктураШапкиДокумента.Сделка;
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗаказПокупателя",текЗаказПокупателя);
	СформироватьВременнуюТаблицуДокумента(МенеджерВременныхТаблиц,СтруктураПараметров);

	Если глЗначениеПеременной("ИспользоватьБлокировкуДанных")  Тогда

		СтруктураПараметровБлокировки = Новый Структура(
			"ТипТаблицы,ИмяТаблицы,ИсточникДанных,ИмяВременнойТаблицы"
			,"РегистрНакопления"
			,"ЗаказыПокупателей"
			,МенеджерВременныхТаблиц
			,"ВременнаяТаблицаДокумента");
			
		СтруктураИсточникаДанных = Новый Структура(
			"Номенклатура,ЗаказПокупателя"
			,"Номенклатура"
			,"ЗаказПокупателя"
			);
		Если ЕстьХарактеристика Тогда
			СтруктураИсточникаДанных.Вставить("ХарактеристикаНоменклатуры","ХарактеристикаНоменклатуры");
		КонецЕсли;
			
		Если флКонтролироватьЦену Тогда
			СтруктураИсточникаДанных.Вставить("Цена","Цена");
		КонецЕсли;
		Если флКонтролироватьСкидки Тогда
			СтруктураИсточникаДанных.Вставить("ПроцентСкидкиНаценки","ПроцентСкидкиНаценки");
            СтруктураИсточникаДанных.Вставить("ПроцентАвтоматическихСкидок","ПроцентАвтоматическихСкидок");
		КонецЕсли;
		
		СтруктураЗначенийБлокировки = новый Структура("СтатусПартии",текСтатусПартии);

		ОбщегоНазначения.УстановитьУправляемуюБлокировку(СтруктураПараметровБлокировки,СтруктураЗначенийБлокировки,СтруктураИсточникаДанных, Отказ, Заголовок);

	КонецЕсли; 

	
	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("СтатусПартии", текСтатусПартии);
    Запрос.УстановитьПараметр("ДоговорКонтрагента",      СтруктураШапкиДокумента.ДоговорКонтрагента);
	
    Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ // Запрос, контролирующий остатки на складах
	|	Док.Номенклатура 									   КАК Номенклатура,
	|	Док.Номенклатура.Представление                         КАК НоменклатураПредставление,
	|	Док.Номенклатура.ЕдиницаХраненияОстатков.Представление КАК ЕдиницаХраненияОстатковПредставление,"
	+ ?(флКонтролироватьЦену, "
	|	Док.Цена				           					   КАК Цена,
	|" , "")
	+ ?(флКонтролироватьСкидки, "
	|   Док.ПроцентСкидкиНаценки							   КАК ПроцентСкидкиНаценки,
	|   Док.ПроцентАвтоматическихСкидок                        КАК ПроцентАвтоматическихСкидок,","")
	+ ?(ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры				           КАК ХарактеристикаНоменклатуры," , "")+"
	|	Док.ЗаказПокупателя 	   	   						   КАК ЗаказПокупателя,
	|	СУММА(Док.ДокументКоличество) 						   КАК ДокументКоличество,
	|	ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0)       КАК ОстатокКоличество
	|ИЗ 
	|	ВременнаяТаблицаДокумента КАК Док
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрНакопления.ЗаказыПокупателей.Остатки(, ДоговорКонтрагента=&ДоговорКонтрагента И СтатусПартии = &СтатусПартии И
	|		(Номенклатура,ЗаказПокупателя"+?(ЕстьХарактеристика,",ХарактеристикаНоменклатуры","")+") В (ВЫБРАТЬ РАЗЛИЧНЫЕ Номенклатура,ЗаказПокупателя"+?(ЕстьХарактеристика,",ХарактеристикаНоменклатуры","")+" ИЗ ВременнаяТаблицаДокумента)
	|	) КАК Остатки
	|ПО 
	|	Док.Номенклатура                = Остатки.Номенклатура"
	+ ?(ЕстьХарактеристика, "
	| И Док.ХарактеристикаНоменклатуры  = Остатки.ХарактеристикаНоменклатуры", "")
	+ ?(флКонтролироватьЦену, "
	| И Док.Цена  					    = Остатки.Цена", "")
	+ ?(флКонтролироватьСкидки, "
	| И Док.ПроцентСкидкиНаценки 		= Остатки.ПроцентСкидкиНаценки
	| И Док.ПроцентАвтоматическихСкидок = Остатки.ПроцентАвтоматическихСкидок","")+"
	| И Док.ЗаказПокупателя             = Остатки.ЗаказПокупателя
	|
	|СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура,
	|	Док.ЗаказПокупателя"
	+ ?(ЕстьХарактеристика, ",
	|	Док.ХарактеристикаНоменклатуры ", "")
	+ ?(флКонтролироватьЦену, ",
	|	Док.Цена ", "")
	+ ?(флКонтролироватьСкидки, ",
	| Док.ПроцентСкидкиНаценки,
	| Док.ПроцентАвтоматическихСкидок","")+"
	|
	|ИМЕЮЩИЕ ЕСТЬNULL(МАКСИМУМ(Остатки.КоличествоОстаток), 0) < СУММА(Док.ДокументКоличество)
	|ДЛЯ ИЗМЕНЕНИЯ РегистрНакопления.ЗаказыПокупателей.Остатки // Блокирующие чтение таблицы остатков регистра для разрешения коллизий многопользовательской работы
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
		", заказанного по документу " + Выборка.ЗаказПокупателя + 
		?(флКонтролироватьЦену," с ценой " + ОбщегоНазначения.ФорматСумм(Выборка.Цена),"") +
		?(флКонтролироватьСкидки, " с ручной скидкой "+Выборка.ПроцентСкидкиНаценки+", с автоматической скидкой "+Выборка.ПроцентАвтоматическихСкидок,"")+" недостаточно.";

		УправлениеЗапасами.ОшибкаНетОстатка(СтрокаСообщения, Выборка.ОстатокКоличество, Выборка.ДокументКоличество,
		Выборка.ЕдиницаХраненияОстатковПредставление, Отказ, Заголовок);

	КонецЦикла;

КонецПроцедуры // КонтрольОстатков()

Процедура СформироватьВременнуюТаблицуДокумента(МенеджерВременныхТаблиц, СтруктураПараметров)
	МетаданныеТабЧастиДокумента = СтруктураПараметров.МетаданныеТабЧастиДокумента;
	ЕстьКоэффициент     = МетаданныеТабЧастиДокумента.Реквизиты.Найти("Коэффициент") <> Неопределено;
    ЕстьЗаказПокупателяВТЧ = МетаданныеТабЧастиДокумента.Реквизиты.Найти("ЗаказПокупателя") <> Неопределено;
    ИмяТаблицы          = СтруктураПараметров.ИмяДокумента + "." + СокрЛП(СтруктураПараметров.ИмяТабличнойЧасти);

	ТекстУсловияКоличество = "";
	Если ЕстьКоэффициент Тогда
		ТекстКоличество = "ВЫРАЗИТЬ(СУММА(Док.Количество * Док.Коэффициент /Док.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Число(15,3))";
	Иначе
		ТекстКоличество = "СУММА(Док.Количество)";
	КонецЕсли;
	Если СтруктураПараметров.ИмяДокумента = "КорректировкаЗаказаПокупателя" Тогда
		ТекстКоличество = "-1 * "+ТекстКоличество;
		ТекстДопУсловия = " И Док.Количество<0";
	ИначеЕсли СтруктураПараметров.ИмяДокумента = "РезервированиеТоваров" Тогда
		ТекстДопУсловия = " И Док.НовоеРазмещение<>ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) И ВЫРАЗИТЬ(Док.НовоеРазмещение КАК Справочник.Склады) ССЫЛКА Справочник.Склады";
	КонецЕсли;
    Запрос = новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "	
	|ВЫБРАТЬ 
	|	Док.Номенклатура                         КАК Номенклатура,"
	+?(СтруктураПараметров.флКонтролироватьЦену,"
	|	Док.Цена 								 КАК Цена,","")
	+ ?(СтруктураПараметров.флКонтролироватьСкидки, "
	|   Док.ПроцентСкидкиНаценки							   КАК ПроцентСкидкиНаценки,
	|   Док.ПроцентАвтоматическихСкидок                        КАК ПроцентАвтоматическихСкидок,","")
	+ ?(СтруктураПараметров.ЕстьХарактеристика, "
	|	Док.ХарактеристикаНоменклатуры				           КАК ХарактеристикаНоменклатуры," , "")
	+?(ЕстьЗаказПокупателяВТЧ,"Док.ЗаказПокупателя","&ЗаказПокупателя")+" КАК ЗаказПокупателя,
	|"+ТекстКоличество+" КАК ДокументКоличество
	|ПОМЕСТИТЬ ВременнаяТаблицаДокумента
	|ИЗ 
	|	Документ." + ИмяТаблицы + " КАК Док
    |ГДЕ
	|	Док.Ссылка  =  &ДокументСсылка "+ТекстДопУсловия+
	?(ЕстьЗаказПокупателяВТЧ, "
	| И Док.ЗаказПокупателя             <> &ПустойЗаказПокупателя И Док.ЗаказПокупателя ССЫЛКА Документ.ЗаказПокупателя", "") + "
    |СГРУППИРОВАТЬ ПО
	|
	|	Док.Номенклатура"
	+ ?(СтруктураПараметров.флКонтролироватьЦену,",Док.Цена","")
	+ ?(СтруктураПараметров.флКонтролироватьСкидки, ",
	| Док.ПроцентСкидкиНаценки,
	| Док.ПроцентАвтоматическихСкидок","")
	+ ?(ЕстьЗаказПокупателяВТЧ,",Док.ЗаказПокупателя","")
	+ ?(СтруктураПараметров.ЕстьХарактеристика, ",
	|	Док.ХарактеристикаНоменклатуры ", "")+"
	|";
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",          СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("ПустойЗаказПокупателя",   Документы.ЗаказПокупателя.ПустаяСсылка());
    Запрос.УстановитьПараметр("ЗаказПокупателя",   		 СтруктураПараметров.ЗаказПокупателя);
    Запрос.Выполнить();
КонецПроцедуры
