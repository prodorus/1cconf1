Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

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
		Предупреждение(НСтр("ru = 'Документ можно распечатать только после его записи'"));
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	
	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
	Иначе
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(Ссылка);
		
		Если НаПринтер Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Документ.СчетНаОплатуПокупателю", ИмяМакета, 
										ПараметрКоманды, Неопределено);
		Иначе
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.СчетНаОплатуПокупателю", ИмяМакета, 
										ПараметрКоманды, Неопределено, Неопределено);
		КонецЕсли;
		Возврат;
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ""), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("Счет", "Счет на оплату");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

//Процедура заполняет табличную часть по заказу покупателя (с учетом корректировок и без учета отгрузок)
Процедура ЗаполнитьТабЧастьТоварыПоЗаказуБезУчетаОтгрузок(ДокументОбъект, Товары, ЗаказПокупателя) Экспорт
	СтруктураАктуальныйЗаказ = УправлениеЗаказами.ПолучитьПоследнийЗаказПокупателяИлиИзменениеЗаказаПокупателя(ЗаказПокупателя);
	Если СтруктураАктуальныйЗаказ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ЗаказПокупателя.СуммаВключаетНДС Тогда
		ПодзапросСумма = "		ВЫБОР 
		|           КОГДА Док.Ссылка.СуммаВключаетНДС
		|				ТОГДА Док.Сумма
		|			ИНАЧЕ Док.Сумма + Док.СуммаНДС
		|		КОНЕЦ";
	Иначе
		ПодзапросСумма = "		ВЫБОР 
		|           КОГДА НЕ Док.Ссылка.СуммаВключаетНДС
		|				ТОГДА Док.Сумма
		|			ИНАЧЕ Док.Сумма + Док.СуммаНДС
		|		КОНЕЦ";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Минимум(ВложенныйЗапрос.ПризнакКорректировка) 	КАК ПризнакКорректировка,
		|	Минимум(ВложенныйЗапрос.НомерСтроки) 			КАК НомерСтроки,
		|	ВложенныйЗапрос.Номенклатура,
		|	ВложенныйЗапрос.Номенклатура.Комплект 			КАК Комплект,
		|	СУММА(ВложенныйЗапрос.Количество)               КАК Количество,
		|	ВложенныйЗапрос.ЕдиницаИзмерения  				КАК ЕдиницаИзмерения,
		|	ВложенныйЗапрос.ЕдиницаИзмерения.Коэффициент  	КАК Коэффициент,
		|	ВложенныйЗапрос.ПроцентСкидкиНаценки            КАК ПроцентСкидкиНаценки,
		|	ВложенныйЗапрос.ПроцентАвтоматическихСкидок   	КАК ПроцентАвтоматическихСкидок,
		|	СУММА(ВложенныйЗапрос.СуммаНДС)                 КАК СуммаНДС,
		|	ВложенныйЗапрос.Цена                            КАК Цена,
		|	ВложенныйЗапрос.СтавкаНДС                       КАК СтавкаНДС,
		|	СУММА(ВложенныйЗапрос.Сумма)                    КАК Сумма,
		|	ВложенныйЗапрос.ХарактеристикаНоменклатуры      КАК ХарактеристикаНоменклатуры,
		|	&ТекущийДокумент 								КАК ЗаказПокупателя
		|ИЗ
		|
		|(
		|ВЫБРАТЬ
		|		Док.Номенклатура                КАК Номенклатура,
		|		Док.ЕдиницаИзмерения            КАК ЕдиницаИзмерения,
		|		Док.Цена                        КАК Цена,
		|		Док.ПроцентСкидкиНаценки        КАК ПроцентСкидкиНаценки,
		|		Док.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
		|		Док.УсловиеАвтоматическойСкидки КАК УсловиеАвтоматическойСкидки,
		|		Док.ЗначениеУсловияАвтоматическойСкидки КАК ЗначениеУсловияАвтоматическойСкидки,
		|		Док.ХарактеристикаНоменклатуры  КАК ХарактеристикаНоменклатуры,
		|		Док.СуммаНДС                    КАК СуммаНДС,
		|" + ПодзапросСумма + " КАК Сумма,
		|		Док.СтавкаНДС 					КАК СтавкаНДС,
		|		Док.Количество                  КАК Количество,
		|		(0)                             КАК ПризнакКорректировка,
		|		Док.НомерСтроки 				КАК НомерСтроки
		|	ИЗ
		|		Документ." + СтруктураАктуальныйЗаказ.ИмяЗаказа + ".Товары КАК Док
		|
		|	ГДЕ
		|		Док.Ссылка = &АктуальныйЗаказ
		|
		|ОБЪЕДИНИТЬ ВСЕ
        |ВЫБРАТЬ
		|		Док.Номенклатура               КАК Номенклатура,
		|		Док.ЕдиницаИзмерения           КАК ЕдиницаИзмерения,
		|		Док.Цена                       КАК Цена,
		|		Док.ПроцентСкидкиНаценки       КАК ПроцентСкидкиНаценки,
		|		Док.ПроцентАвтоматическихСкидок КАК ПроцентАвтоматическихСкидок,
		|		Док.УсловиеАвтоматическойСкидки КАК УсловиеАвтоматическойСкидки,
		|		Док.ЗначениеУсловияАвтоматическойСкидки КАК ЗначениеУсловияАвтоматическойСкидки,
		|		Док.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|		Док.СуммаНДС                   КАК СуммаНДС,
		|" + ПодзапросСумма + " 				КАК Сумма,
		|		Док.СтавкаНДС 					КАК СтавкаНДС,
		|		Док.Количество               КАК Количество,
		|		(1)                          КАК ПризнакКорректировка,
		// Для корректировок номер строки увеличивается, чтобы добавляемые позиции были последними
		|		(9999 + Док.НомерСтроки)	 КАК НомерСтроки
		|	ИЗ
		|		Документ.КорректировкаЗаказаПокупателя.Товары КАК Док
		|
		|	ГДЕ
		|		Док.Ссылка.ЗаказПокупателя = &ТекущийДокумент
		|		И Док.Ссылка.Проведен      = Истина
		|		И Док.Ссылка.Дата > &ДатаАктуальногоЗаказа
        |) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Номенклатура,
		|	ВложенныйЗапрос.ЕдиницаИзмерения,
		|	ВложенныйЗапрос.ПроцентСкидкиНаценки,
		|	ВложенныйЗапрос.ПроцентАвтоматическихСкидок,
		|	ВложенныйЗапрос.ХарактеристикаНоменклатуры,
		|	ВложенныйЗапрос.Цена,
		|   ВложенныйЗапрос.СтавкаНДС
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПризнакКорректировка, НомерСтроки
		|";
		
		Запрос.УстановитьПараметр("ТекущийДокумент", ЗаказПокупателя);
		Запрос.УстановитьПараметр("АктуальныйЗаказ", СтруктураАктуальныйЗаказ.Заказ);
		Запрос.УстановитьПараметр("ДатаАктуальногоЗаказа", СтруктураАктуальныйЗаказ.ДатаЗаказа);
		Запрос.Текст = ТекстЗапроса;
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() цикл
			Если Выборка.Количество <=0 Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
			ОбработкаТабличныхЧастей.РассчитатьКоличествоМестТабЧасти( НоваяСтрока, Ссылка);
			Если Выборка.Комплект Тогда
				НоваяСтрока.КлючСтроки = НоваяСтрока.НомерСтроки;
			КонецЕсли;
		КонецЦикла;

КонецПроцедуры
#КонецЕсли
// Процедура заполняет документ на основании заказа покупателя
//
Процедура ЗаполнитьПоЗаказуПокупателя(ОчищатьСтроки = Ложь) Экспорт

	// Заполнение шапки
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию( ЭтотОбъект, ЗаказПокупателя);
	УправлениеЗаказами.УстановитьДатуОплатыПоДоговору(ЭтотОбъект);
	
	// Заполнение табличных частей
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("СуммаВключаетНДС", ЗаказПокупателя.СуммаВключаетНДС);
	ДопПараметры.Вставить("УчитыватьНДС",     ЗаказПокупателя.УчитыватьНДС);
	ДопПараметры.Вставить("УчитыватьСоставНабора",     ЗаказПокупателя.СоставНабора.Количество()>0);

	
	ДатаОстатков = ОбщегоНазначения.ПолучитьДатуОстатков(ЭтотОбъект);
	
	Если ОчищатьСтроки Тогда
		#Если Клиент Тогда
		ТекстВопроса = "Очистить строки в табличных частях перед заполнением по заказу?";
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, "Новое значение заказа");
		// Очистим значения в строках
		ОчищатьСтроки = (Ответ = КодВозвратаДиалога.Да);
		#КонецЕсли
	КонецЕсли;
	
	УправлениеЗаказами.ЗаполнитьТабЧастьТоварыПоЗаказу(Ссылка, Товары, ЗаказПокупателя, УправлениеЗаказами.ОстаткиТоваровПоЗаказуПокупателя( ЗаказПокупателя, ДоговорКонтрагента, ДатаОстатков), ДопПараметры, ОчищатьСтроки);
	ОбработкаТабличныхЧастей.ЗаполнитьПлановуюСебестоимостьНаОсновании(ЭтотОбъект, ЗаказПокупателя, мВалютаРегламентированногоУчета);
	Если ЗаказПокупателя.ВидОперации = Перечисления.ВидыОперацийЗаказПокупателя.Переработка Тогда
		СтатусПартии = Перечисления.СтатусыПартийТоваров.ВПереработку;
	Иначе
		СтатусПартии = Перечисления.СтатусыПартийТоваров.Купленный;
	КонецЕсли;

	УправлениеЗаказами.ЗаполнитьТабЧастьУслугиПоЗаказу        ( Ссылка, Услуги, ЗаказПокупателя, УправлениеЗаказами.ОстаткиУслугПоЗаказуПокупателя( ЗаказПокупателя, ДоговорКонтрагента, ДатаОстатков,СтатусПартии), ДопПараметры, ОчищатьСтроки);
	//заполняем заказ в таб части Услуги
	Для каждого строка из Услуги цикл
		Строка.ЗаказПокупателя = ЗаказПокупателя;
	КонецЦикла;
	
	УправлениеЗаказами.ЗаполнитьТабЧастьТараПоЗаказуПокупателя( Ссылка, ВозвратнаяТара, ЗаказПокупателя, ДоговорКонтрагента, ДатаОстатков, ОчищатьСтроки);

КонецПроцедуры

// Процедура заполняет документ на основании реализации
//
Процедура ЗаполнитьПоРеализации(ДокументОснование, ОчищатьСтроки = Ложь) Экспорт

	// Заполнение шапки
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию( ЭтотОбъект, ДокументОснование);
	УправлениеЗаказами.УстановитьДатуОплатыПоДоговору(ЭтотОбъект);
	
	// Заполнение табличных частей
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("СуммаВключаетНДС", ДокументОснование.СуммаВключаетНДС);
	ДопПараметры.Вставить("УчитыватьНДС",     ДокументОснование.УчитыватьНДС);
	ДопПараметры.Вставить("УчитыватьСоставНабора",     ДокументОснование.СоставНабора.Количество()>0);

	
	Если ЭтоНовый() Тогда
		ДатаОстатков = Дата('00010101');
	Иначе
		ДатаОстатков = Дата;
	КонецЕсли;
	
	Если ОчищатьСтроки Тогда
		#Если Клиент Тогда
		ТекстВопроса = "Очистить строки в табличных частях перед заполнением?";
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, "Заполнить на основании");
		// Очистим значения в строках
		ОчищатьСтроки = (Ответ = КодВозвратаДиалога.Да);
		#КонецЕсли
	КонецЕсли;
	
	СкопироватьТовары(ДокументОснование);
	СкопироватьВозвратнуюТару(ДокументОснование);
	СкопироватьУслуги(ДокументОснование);
	ОбработкаТабличныхЧастей.ЗаполнитьПлановуюСебестоимостьНаОсновании(ЭтотОбъект, ДокументОснование, мВалютаРегламентированногоУчета);
	
КонецПроцедуры

// Процедура заполняет табличную часть Товары на основании реализации
//
Процедура СкопироватьТовары(ДокументОснование = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументРеализация", ДокументОснование);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияТовары.ЕдиницаИзмерения,
	|	РеализацияТовары.ЕдиницаИзмеренияМест,
	|	РеализацияТовары.Количество,
	|	РеализацияТовары.КоличествоМест,
	|	РеализацияТовары.Коэффициент,
	|	РеализацияТовары.Номенклатура,
	|	РеализацияТовары.ХарактеристикаНоменклатуры,
	|	РеализацияТовары.Цена,
	|	РеализацияТовары.ПроцентСкидкиНаценки,
	|	РеализацияТовары.ПроцентАвтоматическихСкидок,
	|	РеализацияТовары.УсловиеАвтоматическойСкидки,
	|	РеализацияТовары.ЗначениеУсловияАвтоматическойСкидки,
	|	РеализацияТовары.ЗаказПокупателя,
	|	РеализацияТовары.Ссылка.ВалютаДокумента КАК ВалютаДокумента,";

	Запрос.Текст = Запрос.Текст + Символы.ПС + "
	|	ВЫБОР КОГДА РеализацияТовары.Ссылка.ВалютаДокумента = РеализацияТовары.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
	|		РеализацияТовары.Ссылка.КурсВзаиморасчетов
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ                                           КАК КурсДокумента,
	|	ВЫБОР КОГДА РеализацияТовары.Ссылка.ВалютаДокумента = РеализацияТовары.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
	|		РеализацияТовары.Ссылка.КратностьВзаиморасчетов
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ                                           КАК КратностьДокумента,
	|	РеализацияТовары.Сумма,
	|	РеализацияТовары.СтавкаНДС,
	|	РеализацияТовары.СуммаНДС,
	|	РеализацияТовары.Ссылка.СуммаВключаетНДС      КАК СуммаВключаетНДС,
	|	РеализацияТовары.Ссылка.УчитыватьНДС          КАК УчитыватьНДС,
	|	РеализацияТовары.КлючСтроки";

	Запрос.Текст = Запрос.Текст + Символы.ПС + 
	"ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТовары
	|
	|ГДЕ
	|	РеализацияТовары.Ссылка = &ДокументРеализация";

	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	ЕстьРеквизитПроцентСкидкиНаценки = Истина;
	ПересчитыватьСкидку = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ПриИзмененииСуммыПересчитыватьСкидку");
	ЕстьРеквизитПроцентАвтоматическихСкидок = Истина;	
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.Номенклатура                        = Выборка.Номенклатура;
		НоваяСтрока.ХарактеристикаНоменклатуры          = Выборка.ХарактеристикаНоменклатуры;
		НоваяСтрока.ЕдиницаИзмерения                    = Выборка.ЕдиницаИзмерения;
		НоваяСтрока.ЕдиницаИзмеренияМест                = Выборка.ЕдиницаИзмеренияМест;
		НоваяСтрока.Коэффициент                         = Выборка.Коэффициент;
		НоваяСтрока.Количество                          = Выборка.Количество;
		НоваяСтрока.КоличествоМест                      = Выборка.КоличествоМест;
		НоваяСтрока.ПроцентСкидкиНаценки                = Выборка.ПроцентСкидкиНаценки;
		НоваяСтрока.ПроцентАвтоматическихСкидок         = Выборка.ПроцентАвтоматическихСкидок;
		НоваяСтрока.УсловиеАвтоматическойСкидки         = Выборка.УсловиеАвтоматическойСкидки;
		НоваяСтрока.ЗначениеУсловияАвтоматическойСкидки = Выборка.ЗначениеУсловияАвтоматическойСкидки;
		НоваяСтрока.ЗаказПокупателя                     = Выборка.ЗаказПокупателя;
		НоваяСтрока.СтавкаНДС                           = Выборка.СтавкаНДС;

		НоваяСтрока.Цена  = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Цена, Выборка.ВалютаДокумента, ВалютаДокумента, Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
						    Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета));
		НоваяСтрока.Сумма = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
		МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Сумма, Выборка.ВалютаДокумента, ВалютаДокумента,
				Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
				Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета)),
				Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры,
				Выборка.СуммаВключаетНДС,
				УчитыватьНДС,
				СуммаВключаетНДС,
				УчетНДС.ПолучитьСтавкуНДС(НоваяСтрока.СтавкаНДС));

		ОбработкаТабличныхЧастей.ПриИзмененииСуммыТабЧасти(НоваяСтрока, ЭтотОбъект, ТекПользователь,,ЕстьРеквизитПроцентСкидкиНаценки,ПересчитыватьСкидку,ЕстьРеквизитПроцентАвтоматическихСкидок,"Товары");
		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ЭтотОбъект);

		НоваяСтрока.КлючСтроки                   = Выборка.КлючСтроки;

	КонецЦикла;

	Если ДокументОснование.СоставНабора.Количество() > 0 Тогда
		СоставНабора.Загрузить(ДокументОснование.СоставНабора.Выгрузить());
	КонецЕсли;

КонецПроцедуры // СкопироватьТовары()

// Процедура заполняет табличную часть Возвратная тара на основании реализации
//
Процедура СкопироватьВозвратнуюТару(ДокументОснование = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументРеализация", ДокументОснование);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияВозвратнаяТара.Количество,
	|	РеализацияВозвратнаяТара.Номенклатура,
	|	РеализацияВозвратнаяТара.Сумма,
	|	РеализацияВозвратнаяТара.Цена,
	|	РеализацияВозвратнаяТара.ЗаказПокупателя,
	|	РеализацияВозвратнаяТара.Ссылка.ВалютаДокумента	КАК ВалютаДокумента,
	|	ВЫБОР КОГДА РеализацияВозвратнаяТара.Ссылка.ВалютаДокумента = РеализацияВозвратнаяТара.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
	|		РеализацияВозвратнаяТара.Ссылка.КурсВзаиморасчетов
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ                                           КАК КурсДокумента,
	|	ВЫБОР КОГДА РеализацияВозвратнаяТара.Ссылка.ВалютаДокумента = РеализацияВозвратнаяТара.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
	|		РеализацияВозвратнаяТара.Ссылка.КратностьВзаиморасчетов
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ                                           КАК КратностьДокумента
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.ВозвратнаяТара КАК РеализацияВозвратнаяТара
	|
	|ГДЕ
	|	РеализацияВозвратнаяТара.Ссылка = &ДокументРеализация";

	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл

		НоваяСтрока = ВозвратнаяТара.Добавить();
		НоваяСтрока.Номенклатура = Выборка.Номенклатура;
		НоваяСтрока.Количество   = Выборка.Количество;
		НоваяСтрока.Цена  = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Цена, Выборка.ВалютаДокумента, ВалютаДокумента, Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
						    Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета));
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(НоваяСтрока, ЭтотОбъект);
		НоваяСтрока.ЗаказПокупателя              = Выборка.ЗаказПокупателя;
	КонецЦикла;

КонецПроцедуры // СкопироватьВозвратнуюТару()

// Процедура заполняет табличную часть Услуги на основании реализации
//
Процедура СкопироватьУслуги(ДокументОснование = Неопределено) Экспорт

	Если НЕ ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументРеализация", ДокументОснование);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РеализацияУслуги.Содержание,
	|	РеализацияУслуги.Количество,
	|	РеализацияУслуги.Номенклатура,
	|	РеализацияУслуги.Цена,
	|	РеализацияУслуги.ПроцентСкидкиНаценки,
	|	РеализацияУслуги.ПроцентАвтоматическихСкидок,
	|	РеализацияУслуги.УсловиеАвтоматическойСкидки,
	|	РеализацияУслуги.ЗначениеУсловияАвтоматическойСкидки,
	|	РеализацияУслуги.ЗаказПокупателя,
	|	РеализацияУслуги.Ссылка.ВалютаДокумента КАК ВалютаДокумента,";

	Запрос.Текст = Запрос.Текст + Символы.ПС + "
	|	ВЫБОР КОГДА РеализацияУслуги.Ссылка.ВалютаДокумента = РеализацияУслуги.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
	|		РеализацияУслуги.Ссылка.КурсВзаиморасчетов
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ                                           КАК КурсДокумента,
	|	ВЫБОР КОГДА РеализацияУслуги.Ссылка.ВалютаДокумента = РеализацияУслуги.Ссылка.ДоговорКонтрагента.ВалютаВзаиморасчетов ТОГДА
	|		РеализацияУслуги.Ссылка.КратностьВзаиморасчетов
	|	ИНАЧЕ
	|		1
	|	КОНЕЦ                                           КАК КратностьДокумента,
	|	РеализацияУслуги.Сумма,
	|	РеализацияУслуги.СтавкаНДС,
	|	РеализацияУслуги.СуммаНДС,
	|	РеализацияУслуги.Ссылка.СуммаВключаетНДС      КАК СуммаВключаетНДС,
	|	РеализацияУслуги.Ссылка.УчитыватьНДС          КАК УчитыватьНДС";

	Запрос.Текст = Запрос.Текст + Символы.ПС + 
	"ИЗ
	|	Документ.РеализацияТоваровУслуг.Услуги КАК РеализацияУслуги
	|
	|ГДЕ
	|	РеализацияУслуги.Ссылка = &ДокументРеализация";

	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекПользователь = глЗначениеПеременной("глТекущийПользователь");
	ЕстьРеквизитПроцентСкидкиНаценки = Истина;
	ПересчитыватьСкидку = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ПриИзмененииСуммыПересчитыватьСкидку");
	ЕстьРеквизитПроцентАвтоматическихСкидок = Истина;	
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Услуги.Добавить();
		НоваяСтрока.Номенклатура                        = Выборка.Номенклатура;
		НоваяСтрока.Содержание                          = Выборка.Содержание;
		НоваяСтрока.Количество                          = Выборка.Количество;
		НоваяСтрока.ПроцентСкидкиНаценки                = Выборка.ПроцентСкидкиНаценки;
		НоваяСтрока.ПроцентАвтоматическихСкидок         = Выборка.ПроцентАвтоматическихСкидок;
		НоваяСтрока.УсловиеАвтоматическойСкидки         = Выборка.УсловиеАвтоматическойСкидки;
		НоваяСтрока.ЗначениеУсловияАвтоматическойСкидки = Выборка.ЗначениеУсловияАвтоматическойСкидки;
		НоваяСтрока.ЗаказПокупателя                     = Выборка.ЗаказПокупателя;
		НоваяСтрока.СтавкаНДС                           = Выборка.СтавкаНДС;

		НоваяСтрока.Цена  = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Цена, Выборка.ВалютаДокумента, ВалютаДокумента, Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
						    Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета));
		НоваяСтрока.Сумма = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
		МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Выборка.Сумма, Выборка.ВалютаДокумента, ВалютаДокумента,
				Выборка.КурсДокумента, ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
				Выборка.КратностьДокумента, ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета)),
				Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры,
				Выборка.СуммаВключаетНДС,
				УчитыватьНДС,
				СуммаВключаетНДС,
				УчетНДС.ПолучитьСтавкуНДС(НоваяСтрока.СтавкаНДС));
		ОбработкаТабличныхЧастей.ПриИзмененииСуммыТабЧасти(НоваяСтрока, ЭтотОбъект, ТекПользователь,,ЕстьРеквизитПроцентСкидкиНаценки,ПересчитыватьСкидку,ЕстьРеквизитПроцентАвтоматическихСкидок,"Услуги");
		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(НоваяСтрока, ЭтотОбъект);

	КонецЦикла;

КонецПроцедуры // СкопироватьУслуги()



////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
	Новый Структура("Организация, ВалютаДокумента, СтруктурнаяЕдиница,
					|Контрагент "+?(ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты"),", ДоговорКонтрагента","")+", КратностьВзаиморасчетов");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	УправлениеВзаиморасчетами.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, ДоговорКонтрагента.Организация, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура проверяет правильность заполнения табличной части "Товары".
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ, Заголовок, СтруктураШапкиДокумента)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена, ЕдиницаИзмерения, Коэффициент");
	Если Не РеализацияТоваровОблагаемыхНДСУПокупателя Тогда
		СтруктураОбязательныхРеквизитов.Вставить("СтавкаНДС");
	КонецЕсли;
		
	УправлениеЗапасами.КорректировкаСтруктурыОбязательныхПолей(СтруктураОбязательныхРеквизитов, СтруктураШапкиДокумента.Склад.ВидСклада);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	

// Процедура выполняет проверку правильности заполнения табличной части "Услуги"
//
Процедура ПроверитьЗаполнениеТабличнойЧастиУслуги(Отказ, Заголовок, СтруктураШапкиДокумента)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена, СтавкаНДС, Содержание");
	УправлениеЗапасами.КорректировкаСтруктурыОбязательныхПолей(СтруктураОбязательныхРеквизитов, СтруктураШапкиДокумента.Склад.ВидСклада);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Услуги", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	

// Процедура выполняет проверку правильности заполнения табличной части "ВозвратнаяТара"
//
Процедура ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(Отказ, Заголовок, СтруктураШапкиДокумента)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена");
	УправлениеЗапасами.КорректировкаСтруктурыОбязательныхПолей(СтруктураОбязательныхРеквизитов, СтруктураШапкиДокумента.Склад.ВидСклада);
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ВозвратнаяТара", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда

		// Заполнение по заказу
		ЗаказПокупателя = Основание;
		ЗаполнитьПоЗаказуПокупателя();
		УправлениеЗапасами.ЗаполнитьСоставНабораПоОснованию(ЭтотОбъект, Основание);

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		
		// Заполнение по реализации
		Если ЗначениеЗаполнено(Основание.Сделка) И ТипЗнч(Основание.Сделка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			ЗаказПокупателя = Основание.Сделка;
		КонецЕсли;
		ЗаполнитьПоРеализации(Основание);

	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.Событие") Тогда

		Комментарий               = Основание.Комментарий;
		КонтактноеЛицоКонтрагента = Основание.КонтактноеЛицо;
		Контрагент                = Основание.Контрагент;
		Ответственный             = Основание.Ответственный;

	КонецЕсли;
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.НастройкиЗаполненияФорм") Тогда
		ХранилищаНастроек.ДанныеФорм.ЗаполнитьОбъектПоНастройке(ЭтотОбъект, Основание, Документы.РеализацияТоваровУслуг.СтруктураДополнительныхДанныхФормы());
	КонецЕсли;
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, "Продажа");
	УправлениеЗаказами.УстановитьДатуОплатыПоДоговору(ЭтотОбъект);		
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если НЕ ОбменДанными.Загрузка  Тогда
		
		// Заголовок для сообщений об ошибках.
		Заголовок = "Невозможно записать документ: "+СокрЛП(ЭтотОбъект);

		// Сформируем структуру реквизитов шапки документа
		СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

		// Проверим правильность заполнения шапки документа
		ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
		
		// Если договор с комиссионером, то надо почистить закладку "Услуги".
		Если Услуги.Количество() > 0
		   И ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером Тогда

			Услуги.Очистить();

		КонецЕсли;

		УправлениеЗаказами.ЗаполнитьЗаказПокупателяВТЧ(неопределено,ЭтотОбъект, "РеализацияСчет");

		// Проверка заполнения единицы измерения мест и количества мест
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(Товары);
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьСтавкуНДС(ЭтотОбъект, Товары);
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьСтавкуНДС(ЭтотОбъект, Услуги);
		
		// Проверим правильность заполнения табличных частей.
		ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ, Заголовок, СтруктураШапкиДокумента);
		ПроверитьЗаполнениеТабличнойЧастиУслуги(Отказ, Заголовок, СтруктураШапкиДокумента);
        ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(Отказ, Заголовок, СтруктураШапкиДокумента);
		
		// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
		СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
		
		мУдалятьДвижения = НЕ ЭтоНовый();
		
		Для каждого СтрокаТаблицы Из ЭтотОбъект.Товары Цикл
			Если РеализацияТоваровОблагаемыхНДСУПокупателя Тогда
				СтрокаТаблицы.СтавкаНДС = Перечисления.СтавкиНДС.ПустаяСсылка();
				СтрокаТаблицы.СуммаНДС = 0;
			КонецЕсли;
		КонецЦикла;
	
	КонецЕсли;

КонецПроцедуры // ПередЗаписью

// Процедура вызывается при записи документа 
//
Процедура ПриЗаписи(Отказ)

#Если Клиент Тогда

	Если НЕ ОбменДанными.Загрузка  Тогда
		
		Если ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
			ПолныеПрава.УдалитьДанныеНезарегистрированногоКонтрагента(Ссылка, Отказ);
		КонецЕсли; 
		// Проверим допустимость для пользователя цен документа
		// Обязательно выполнять в ПриЗаписи, т.к. в процедуре используется запрос использующий ссылку на объект
		УправлениеДопПравамиПользователей.ПроверитьДопустимостьЦенОтпуска(ЭтотОбъект, "Товары", Отказ);
	КонецЕсли; 

#КонецЕсли

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
		//Не надо проверять заполнение договора
		НомерУдаляемогоЭлемента = ПроверяемыеРеквизиты.Найти("ДоговорКонтрагента");
		Если НомерУдаляемогоЭлемента <> Неопределено Тогда
			ПроверяемыеРеквизиты.Удалить(НомерУдаляемогоЭлемента);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, "Продажа", ОбъектКопирования.Ссылка);
	ЭтотОбъект.РеализацияТоваровОблагаемыхНДСУПокупателя = ОбъектКопирования.ДоговорКонтрагента.РеализацияТоваровОблагаемыхНДСУПокупателя 
		И ТекущаяДата() >= Константы.ДатаНачалаОперацийСТоварамиОблагаемымиНДСУПокупателя.Получить();
КонецПроцедуры


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");


