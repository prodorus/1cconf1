////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

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
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Документ.СчетНаОплатуПоставщика", ИмяМакета, 
										ПараметрКоманды, Неопределено);
		Иначе
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.СчетНаОплатуПоставщика", ИмяМакета, 
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
	
	СтруктураМакетов = Новый Структура("Заказ", "Счет на оплату поставщика");
	СтруктураМакетов.Вставить("ЗаказПоДаннымПоставщика", "Счет на оплату поставщика (по данным поставщика)");

	Возврат СтруктураМакетов;
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
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
					|Контрагент, ДоговорКонтрагента, КратностьВзаиморасчетов");

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Организация в документе должна совпадать с организацией, указанной в договоре взаиморасчетов.
	УправлениеВзаиморасчетами.ПроверитьСоответствиеОрганизацииДоговоруВзаиморасчетов(Организация, ДоговорКонтрагента, ДоговорКонтрагента.Организация, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()


// Процедура проверяет правильность заполнения табличной части "Товары".
//
Процедура ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ, Заголовок)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена, СтавкаНДС, ЕдиницаИзмерения, Коэффициент");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Товары", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	

// Процедура выполняет проверку правильности заполнения табличной части "Услуги"
//
Процедура ПроверитьЗаполнениеТабличнойЧастиУслуги(Отказ, Заголовок)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена, СтавкаНДС, Содержание");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Услуги", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	

// Процедура выполняет проверку правильности заполнения табличной части "ВозвратнаяТара"
//
Процедура ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(Отказ, Заголовок)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ВозвратнаяТара", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	

// Процедура проверяет правильность заполнения табличной части "Оборудование".
//
Процедура ПроверитьЗаполнениеТабличнойЧастиОборудование(Отказ, Заголовок)
	
	СтруктураОбязательныхРеквизитов = Новый Структура("Номенклатура, Количество, Цена, СтавкаНДС, ЕдиницаИзмерения, Коэффициент");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Оборудование", СтруктураОбязательныхРеквизитов, Отказ, Заголовок);	
	
КонецПроцедуры	


// Очищает ненужные строки табличных частей
//
Процедура ОчиститьНенужныеТабличныеЧасти() Экспорт

	// Если договор с комитентом, то надо почистить закладку "Услуги".
	Если Услуги.Количество() > 0
	   И ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда

		Услуги.Очистить();

	КонецЕсли;

КонецПроцедуры // ОчиститьНенужныеТабличныеЧасти()

// Процедура заполнения таб.части Товары
//
Процедура ЗаполнитьТабЧастиТоварыНаОсновании(ДокОснование)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегЗаказы.Номенклатура КАК Номенклатура,
	|	РегЗаказы.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	РегЗаказы.Цена,
	|	СУММА(РегЗаказы.КоличествоОстаток) КАК КолОстаток,
	|	СУММА(РегЗаказы.КоличествоОстаток * РегЗаказы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ДокЗаказ.Коэффициент) КАК КолОстатокЕдиницыДокумента,
	|	ДокЗаказ.СтавкаНДС,
	|	ДокЗаказ.ЕдиницаИзмерения,
	|	ДокЗаказ.Коэффициент,
	|	СУММА(РегЗаказы.СуммаВзаиморасчетовОстаток) КАК СуммаВзаиморасчетовОстаток,
	|	СУММА(РегЗаказы.СуммаУпрОстаток) КАК СуммаУпрОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокЗаказы.Номенклатура КАК Номенклатура,
	|		ДокЗаказы.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ДокЗаказы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ДокЗаказы.Коэффициент КАК Коэффициент,
	|		ДокЗаказы.Цена КАК Цена,
	|		ДокЗаказы.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(ДокЗаказы.СуммаНДС) КАК СуммаНДС
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ДокЗаказТовары.Номенклатура КАК Номенклатура,
	|			ДокЗаказТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			ДокЗаказТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|			ДокЗаказТовары.Коэффициент КАК Коэффициент,
	|			ДокЗаказТовары.Цена КАК Цена,
	|			ДокЗаказТовары.СтавкаНДС КАК СтавкаНДС,
	|			ДокЗаказТовары.СуммаНДС КАК СуммаНДС
	|		ИЗ
	|			Документ.ЗаказПоставщику.Товары КАК ДокЗаказТовары
	|		
	|		ГДЕ
	|			ДокЗаказТовары.Ссылка = &Заказ И
	|			ДокЗаказТовары.Ссылка.Проведен И
	|			Не ДокЗаказТовары.Номенклатура.Услуга И
	|			НЕ ДокЗаказТовары.Ссылка.ПометкаУдаления
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ДокКорректировкаТовары.Номенклатура,
	|			ДокКорректировкаТовары.ХарактеристикаНоменклатуры,
	|			ДокКорректировкаТовары.ЕдиницаИзмерения,
	|			ДокКорректировкаТовары.Коэффициент,
	|			ДокКорректировкаТовары.Цена,
	|			ДокКорректировкаТовары.СтавкаНДС,
	|			ДокКорректировкаТовары.СуммаНДС
	|		ИЗ
	|			Документ.КорректировкаЗаказаПоставщику.Товары КАК ДокКорректировкаТовары
	|		
	|		ГДЕ
	|			ДокКорректировкаТовары.Ссылка.ЗаказПоставщику = &Заказ И
	|			Не ДокКорректировкаТовары.Номенклатура.Услуга И
	|			НЕ ДокКорректировкаТовары.Ссылка.ПометкаУдаления И
	|			ДокКорректировкаТовары.Ссылка.Проведен) КАК ДокЗаказы
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДокЗаказы.Номенклатура,
	|		ДокЗаказы.ХарактеристикаНоменклатуры,
	|		ДокЗаказы.ЕдиницаИзмерения,
	|		ДокЗаказы.Коэффициент,
	|		ДокЗаказы.Цена,
	|		ДокЗаказы.СтавкаНДС) КАК ДокЗаказ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&ДатаОстатков, ЗаказПоставщику = &Заказ И СтатусПартии = &Статус) КАК РегЗаказы
	|		ПО ДокЗаказ.Номенклатура               = РегЗаказы.Номенклатура
	|		 И ДокЗаказ.ХарактеристикаНоменклатуры = РегЗаказы.ХарактеристикаНоменклатуры
	|		 И ДокЗаказ.Цена                       = РегЗаказы.Цена
	|		 И ДокЗаказ.СтавкаНДС                  = РегЗаказы.СтавкаНДС
	|
	|СГРУППИРОВАТЬ ПО
	|	РегЗаказы.Номенклатура,
	|	РегЗаказы.ХарактеристикаНоменклатуры,
	|	РегЗаказы.Цена,
	|	ДокЗаказ.СтавкаНДС,
	|	ДокЗаказ.ЕдиницаИзмерения,
	|	ДокЗаказ.Коэффициент";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ДатаОстатков", ОбщегоНазначения.ПолучитьДатуОстатков(ЭтотОбъект));
	Запрос.УстановитьПараметр("Заказ",   ДокОснование);
	
	Если ДокОснование.ВидОперации = Перечисления.ВидыОперацийЗаказПоставщику.Переработка Тогда
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПартийТоваров.ВПереработку);
	Иначе
		Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПартийТоваров.Купленный);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Обход = РезультатЗапроса.Выбрать();
	
	Пока Обход.Следующий() Цикл

		Если Обход.КолОстаток <= 0 Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.Номенклатура     = Обход.Номенклатура;
		НоваяСтрока.ЕдиницаИзмерения = Обход.ЕдиницаИзмерения;
		НоваяСтрока.Коэффициент      = Обход.Коэффициент;
		НоваяСтрока.Количество       = Обход.КолОстатокЕдиницыДокумента;
		НоваяСтрока.ХарактеристикаНоменклатуры = Обход.ХарактеристикаНоменклатуры;
		НоваяСтрока.СтавкаНДС        = Обход.СтавкаНДС;
		НоваяСтрока.Цена             = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
				МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Обход.Цена,
				ДокОснование.ВалютаДокумента, ВалютаДокумента,
				ЗаполнениеДокументов.КурсДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
				ЗаполнениеДокументов.КратностьДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета)),
				Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатурыКонтрагентов,
				ДокОснование.СуммаВключаетНДС,
				УчитыватьНДС,
				СуммаВключаетНДС,
				УчетНДС.ПолучитьСтавкуНДС(НоваяСтрока.СтавкаНДС));
			
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(НоваяСтрока, ЭтотОбъект);
		
		ОбработкаТабличныхЧастей.РассчитатьКоличествоМестТабЧасти( НоваяСтрока, ЭтотОбъект); 
		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти      ( НоваяСтрока, ЭтотОбъект);
		
	КонецЦикла;
	
	ОбработкаТабличныхЧастей.ЗаполнитьПлановуюСебестоимостьНаОсновании(ЭтотОбъект, ДокОснование, мВалютаРегламентированногоУчета);
	
КонецПроцедуры // ЗаполнитьТабЧастиТоварыНаОсновании()

// Процедура заполнения таб.части Оборудование
//
Процедура ЗаполнитьТабЧастиОборудованиеНаОсновании(ДокОснование)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегЗаказы.Номенклатура КАК Номенклатура,
	|	РегЗаказы.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|	РегЗаказы.Цена,
	|	СУММА(РегЗаказы.КоличествоОстаток) КАК Количество,
	|	СУММА(РегЗаказы.КоличествоОстаток * РегЗаказы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ДокЗаказ.Коэффициент) КАК КолОстатокЕдиницыДокумента,
	|	ДокЗаказ.СтавкаНДС,
	|	ДокЗаказ.ЕдиницаИзмерения,
	|	ДокЗаказ.Коэффициент,
	|	СУММА(РегЗаказы.СуммаУпрОстаток) КАК СуммаУпр
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокЗаказы.Номенклатура КАК Номенклатура,
	|		ДокЗаказы.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|		ДокЗаказы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ДокЗаказы.Коэффициент КАК Коэффициент,
	|		ДокЗаказы.Цена КАК Цена,
	|		ДокЗаказы.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(ДокЗаказы.СуммаНДС) КАК СуммаНДС
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ДокЗаказОборудование.Номенклатура КАК Номенклатура,
	|			ДокЗаказОборудование.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	|			ДокЗаказОборудование.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|			ДокЗаказОборудование.Коэффициент КАК Коэффициент,
	|			ДокЗаказОборудование.Цена КАК Цена,
	|			ДокЗаказОборудование.СтавкаНДС КАК СтавкаНДС,
	|			ДокЗаказОборудование.СуммаНДС КАК СуммаНДС
	|		ИЗ
	|			Документ.ЗаказПоставщику.Оборудование КАК ДокЗаказОборудование
	|		
	|		ГДЕ
	|			ДокЗаказОборудование.Ссылка = &Заказ И
	|			ДокЗаказОборудование.Ссылка.Проведен И
	|			Не ДокЗаказОборудование.Номенклатура.Услуга И
	|			НЕ ДокЗаказОборудование.Ссылка.ПометкаУдаления
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ДокКорректировкаОборудование.Номенклатура,
	|			ДокКорректировкаОборудование.ХарактеристикаНоменклатуры,
	|			ДокКорректировкаОборудование.ЕдиницаИзмерения,
	|			ДокКорректировкаОборудование.Коэффициент,
	|			ДокКорректировкаОборудование.Цена,
	|			ДокКорректировкаОборудование.СтавкаНДС,
	|			ДокКорректировкаОборудование.СуммаНДС
	|		ИЗ
	|			Документ.КорректировкаЗаказаПоставщику.Оборудование КАК ДокКорректировкаОборудование
	|		
	|		ГДЕ
	|			ДокКорректировкаОборудование.Ссылка.ЗаказПоставщику = &Заказ И
	|			Не ДокКорректировкаОборудование.Номенклатура.Услуга И
	|			НЕ ДокКорректировкаОборудование.Ссылка.ПометкаУдаления И
	|			ДокКорректировкаОборудование.Ссылка.Проведен) КАК ДокЗаказы
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДокЗаказы.Номенклатура,
	|		ДокЗаказы.ХарактеристикаНоменклатуры,
	|		ДокЗаказы.ЕдиницаИзмерения,
	|		ДокЗаказы.Коэффициент,
	|		ДокЗаказы.Цена,
	|		ДокЗаказы.СтавкаНДС) КАК ДокЗаказ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&ДатаОстатков, ЗаказПоставщику = &Заказ И СтатусПартии = &Статус) КАК РегЗаказы
	|		ПО ДокЗаказ.Номенклатура               = РегЗаказы.Номенклатура
	|		 И ДокЗаказ.ХарактеристикаНоменклатуры = РегЗаказы.ХарактеристикаНоменклатуры
	|		 И ДокЗаказ.Цена                       = РегЗаказы.Цена
	|		 И ДокЗаказ.СтавкаНДС                  = РегЗаказы.СтавкаНДС
	|
	|СГРУППИРОВАТЬ ПО
	|	РегЗаказы.Номенклатура,
	|	РегЗаказы.ХарактеристикаНоменклатуры,
	|	РегЗаказы.Цена,
	|	ДокЗаказ.СтавкаНДС,
	|	ДокЗаказ.ЕдиницаИзмерения,
	|	ДокЗаказ.Коэффициент";

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;

	Запрос.УстановитьПараметр("ДатаОстатков", ОбщегоНазначения.ПолучитьДатуОстатков(ЭтотОбъект));
	Запрос.УстановитьПараметр("Заказ",   ДокОснование);
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыПартийТоваров.Оборудование);

	РезультатЗапроса = Запрос.Выполнить();
	Обход = РезультатЗапроса.Выбрать();

	Пока Обход.Следующий() Цикл

		Если Обход.Количество <= 0 Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока = Оборудование.Добавить();
		НоваяСтрока.Номенклатура     = Обход.Номенклатура;
		НоваяСтрока.ЕдиницаИзмерения = Обход.ЕдиницаИзмерения;
		НоваяСтрока.Коэффициент      = Обход.Коэффициент;
		НоваяСтрока.Количество       = Обход.КолОстатокЕдиницыДокумента;
		НоваяСтрока.ХарактеристикаНоменклатуры = Обход.ХарактеристикаНоменклатуры;
		НоваяСтрока.СтавкаНДС        = Обход.СтавкаНДС;
		НоваяСтрока.Цена             = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
				МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Обход.Цена,
				ДокОснование.ВалютаДокумента, ВалютаДокумента,
				ЗаполнениеДокументов.КурсДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
				ЗаполнениеДокументов.КратностьДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета)),
				Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатурыКонтрагентов,
				ДокОснование.СуммаВключаетНДС,
				УчитыватьНДС,
				СуммаВключаетНДС,
				УчетНДС.ПолучитьСтавкуНДС(НоваяСтрока.СтавкаНДС));
			
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(НоваяСтрока, ЭтотОбъект);

		ОбработкаТабличныхЧастей.РассчитатьКоличествоМестТабЧасти( НоваяСтрока, ЭтотОбъект); 
		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти      ( НоваяСтрока, ЭтотОбъект);

	КонецЦикла;

КонецПроцедуры // ЗаполнитьТабЧастиОборудованиеНаОсновании()

// Процедура заполнения таб.части Услуги
//
Процедура ЗаполнитьТабЧастиУслугиНаОсновании(ДокОснование)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегЗаказы.Номенклатура КАК Номенклатура,
	|	ДокЗаказ.Содержание КАК Содержание,
	|	РегЗаказы.Цена,
	|	СУММА(РегЗаказы.КоличествоОстаток) КАК КолОстаток,
	|	СУММА(РегЗаказы.СуммаУпрОстаток) КАК СуммаУпрОстаток,
	|	СУММА(РегЗаказы.СуммаВзаиморасчетовОстаток) КАК СуммаВзаиморасчетовОстаток,
	|	ДокЗаказ.СтавкаНДС
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокЗаказы.Номенклатура КАК Номенклатура,
	|		ДокЗаказы.Содержание КАК Содержание,
	|		ДокЗаказы.Цена КАК Цена,
	|		ДокЗаказы.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(ДокЗаказы.СуммаНДС) КАК СуммаНДС
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ДокЗаказУслуги.Номенклатура КАК Номенклатура,
	|			ВЫРАЗИТЬ(ДокЗаказУслуги.Содержание КАК Строка(1000)) КАК Содержание,
	|			ДокЗаказУслуги.Цена КАК Цена,
	|			ДокЗаказУслуги.СтавкаНДС КАК СтавкаНДС,
	|			ДокЗаказУслуги.СуммаНДС КАК СуммаНДС
	|		ИЗ
	|			Документ.ЗаказПоставщику.Услуги КАК ДокЗаказУслуги
	|		
	|		ГДЕ
	|			ДокЗаказУслуги.Ссылка = &Заказ И
	|			ДокЗаказУслуги.Ссылка.Проведен И
	|			ДокЗаказУслуги.Номенклатура.Услуга И
	|			НЕ ДокЗаказУслуги.Ссылка.ПометкаУдаления
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ДокКорректировкаУслуги.Номенклатура,
	|			ВЫРАЗИТЬ(ДокКорректировкаУслуги.Содержание КАК Строка(1000)) КАК Содержание,
	|			ДокКорректировкаУслуги.Цена,
	|			ДокКорректировкаУслуги.СтавкаНДС,
	|			ДокКорректировкаУслуги.СуммаНДС
	|		ИЗ
	|			Документ.КорректировкаЗаказаПоставщику.Услуги КАК ДокКорректировкаУслуги
	|		
	|		ГДЕ
	|			ДокКорректировкаУслуги.Ссылка.ЗаказПоставщику = &Заказ И
	|			НЕ ДокКорректировкаУслуги.Ссылка.ПометкаУдаления И
	|			ДокКорректировкаУслуги.Номенклатура.Услуга И
	|			ДокКорректировкаУслуги.Ссылка.Проведен) КАК ДокЗаказы
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ДокЗаказы.Номенклатура,
	|		ДокЗаказы.Содержание,
	|		ДокЗаказы.Цена,
	|		ДокЗаказы.СтавкаНДС) КАК ДокЗаказ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&ДатаОстатков, ЗаказПоставщику = &Заказ И СтатусПартии = &Статус) КАК РегЗаказы
	|		ПО ДокЗаказ.Номенклатура = РегЗаказы.Номенклатура И ДокЗаказ.Цена = РегЗаказы.Цена
	|          И ДокЗаказ.СтавкаНДС  = РегЗаказы.СтавкаНДС
	|
	|СГРУППИРОВАТЬ ПО
	|	РегЗаказы.Номенклатура,
	|	ДокЗаказ.Содержание,
	|	РегЗаказы.Цена,
	|	ДокЗаказ.СтавкаНДС";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("ДатаОстатков", ОбщегоНазначения.ПолучитьДатуОстатков(ЭтотОбъект));
	Запрос.УстановитьПараметр("Заказ",   ДокОснование);
	Запрос.УстановитьПараметр("Статус",  Перечисления.СтатусыПартийТоваров.Купленный);

	РезультатЗапроса = Запрос.Выполнить();
	Обход = РезультатЗапроса.Выбрать();

	Пока Обход.Следующий() Цикл

		Если Обход.КолОстаток <= 0 Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока = Услуги.Добавить();
		НоваяСтрока.Номенклатура = Обход.Номенклатура;
		НоваяСтрока.Содержание   = СокрЛП(Обход.Содержание);
		НоваяСтрока.Количество   = Обход.КолОстаток;
		НоваяСтрока.СтавкаНДС    = Обход.СтавкаНДС;
		НоваяСтрока.Цена         = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
				МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Обход.Цена,
				ДокОснование.ВалютаДокумента, ВалютаДокумента,
				ЗаполнениеДокументов.КурсДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
				ЗаполнениеДокументов.КратностьДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета)),
				Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатурыКонтрагентов,
				ДокОснование.СуммаВключаетНДС,
				УчитыватьНДС,
				СуммаВключаетНДС,
				УчетНДС.ПолучитьСтавкуНДС(НоваяСтрока.СтавкаНДС));
			
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(НоваяСтрока, ЭтотОбъект);

		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти( НоваяСтрока, ЭтотОбъект);

	КонецЦикла;

КонецПроцедуры // ЗаполнитьТабЧастиТоварыНаОсновании()

// Процедура заполнения таб.части Тара
//
Процедура ЗаполнитьТабЧастиТараНаОсновании(ДокОснование)
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РегЗаказы.Номенклатура КАК Номенклатура,
	|	РегЗаказы.Цена,
	|	СУММА(РегЗаказы.КоличествоОстаток) КАК КолОстаток,
	|	РегЗаказы.СуммаВзаиморасчетовОстаток,
	|	РегЗаказы.СуммаУпрОстаток
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДокЗаказы.Номенклатура КАК Номенклатура,
	|		ДокЗаказы.Цена КАК Цена
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ДокЗаказТовары.Номенклатура КАК Номенклатура,
	|			ДокЗаказТовары.Цена КАК Цена
	|		ИЗ
	|			Документ.ЗаказПоставщику.ВозвратнаяТара КАК ДокЗаказТовары
	|		
	|		ГДЕ
	|			ДокЗаказТовары.Ссылка = &Заказ И
	|			(ДокЗаказТовары.Ссылка.Проведен) И
	|			(НЕ(ДокЗаказТовары.Ссылка.ПометкаУдаления)) И
	|			(НЕ(ДокЗаказТовары.Номенклатура.Услуга))
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ДокКорректировкаТовары.Номенклатура,
	|			ДокКорректировкаТовары.Цена
	|		ИЗ
	|			Документ.КорректировкаЗаказаПоставщику.ВозвратнаяТара КАК ДокКорректировкаТовары
	|		
	|		ГДЕ
	|			ДокКорректировкаТовары.Ссылка.ЗаказПоставщику = &Заказ И
	|			(НЕ(ДокКорректировкаТовары.Ссылка.ПометкаУдаления)) И
	|			(ДокКорректировкаТовары.Ссылка.Проведен) И
	|			(НЕ(ДокКорректировкаТовары.Номенклатура.Услуга))) КАК ДокЗаказы) КАК ДокЗаказ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыПоставщикам.Остатки(&ДатаОстатков, ЗаказПоставщику = &Заказ И СтатусПартии = &Статус) КАК РегЗаказы
	|		ПО ДокЗаказ.Номенклатура = РегЗаказы.Номенклатура И ДокЗаказ.Цена = РегЗаказы.Цена
	|
	|СГРУППИРОВАТЬ ПО
	|	РегЗаказы.Номенклатура,
	|	РегЗаказы.Цена,
	|	РегЗаказы.СуммаВзаиморасчетовОстаток,
	|	РегЗаказы.СуммаУпрОстаток";

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;

	Запрос.УстановитьПараметр("ДатаОстатков", ОбщегоНазначения.ПолучитьДатуОстатков(ЭтотОбъект));
	Запрос.УстановитьПараметр("Заказ",   ДокОснование);
	Запрос.УстановитьПараметр("Статус",  Перечисления.СтатусыПартийТоваров.ВозвратнаяТара);

	РезультатЗапроса = Запрос.Выполнить();
	Обход = РезультатЗапроса.Выбрать();

	Пока Обход.Следующий() Цикл

		Если Обход.КолОстаток <= 0 Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрока = ВозвратнаяТара.Добавить();
		НоваяСтрока.Количество   = Обход.КолОстаток;
		НоваяСтрока.Номенклатура = Обход.Номенклатура;
		НоваяСтрока.Цена         = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
				МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(Обход.Цена,
				ДокОснование.ВалютаДокумента, ВалютаДокумента,
				ЗаполнениеДокументов.КурсДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КурсДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета),
				ЗаполнениеДокументов.КратностьДокумента(ДокОснование, мВалютаРегламентированногоУчета), ЗаполнениеДокументов.КратностьДокумента(ЭтотОбъект, мВалютаРегламентированногоУчета)),
				Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатурыКонтрагентов,
				Ложь, Ложь, Ложь, 0);
			
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(НоваяСтрока, ЭтотОбъект);

	КонецЦикла;

КонецПроцедуры // ЗаполнитьТабЧастиТараНаОсновании()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если НЕ ОбменДанными.Загрузка  Тогда
		
		// Заголовок для сообщений об ошибках.
		Заголовок = "Невозможно записать документ:";

		// Сформируем структуру реквизитов шапки документа
		СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

		// Проверим правильность заполнения шапки документа
		ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
		
		ОчиститьНенужныеТабличныеЧасти();

		// Проверка заполнения единицы измерения мест и количества мест
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(Товары);
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьЕдиницуИзмеренияМест(Оборудование);
		
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьСтавкуНДС(ЭтотОбъект, Товары);
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьСтавкуНДС(ЭтотОбъект, Услуги);
		ОбработкаТабличныхЧастей.ПриЗаписиПроверитьСтавкуНДС(ЭтотОбъект, Оборудование);
		
		// Проверка правильности заполнения табличных частей.
		ПроверитьЗаполнениеТабличнойЧастиТовары(Отказ, Заголовок);
		ПроверитьЗаполнениеТабличнойЧастиУслуги(Отказ, Заголовок);
        ПроверитьЗаполнениеТабличнойЧастиВозвратнаяТара(Отказ, Заголовок);
        ПроверитьЗаполнениеТабличнойЧастиОборудование(Отказ, Заголовок);

		// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
		СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
		
		мУдалятьДвижения = НЕ ЭтоНовый();
	
	КонецЕсли; 

КонецПроцедуры // ПередЗаписью

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)
	ДокументОснование = Основание;
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.Событие") Тогда
		
		// Заполнение шапки
		ВремяНапоминания  = Основание.ВремяНапоминания;
		Комментарий       = Основание.Комментарий;
		НапомнитьОСобытии = Основание.НапомнитьОСобытии;
		Ответственный     = Основание.Ответственный;
		КонтактноеЛицоКонтрагента    = Основание.КонтактноеЛицо;
		Контрагент        = Основание.Контрагент;
		Организация 	  = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию( глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");

        ЗаполнениеДокументов.ПриИзмененииЗначенияКонтрагента(ЭтотОбъект);
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию( ЭтотОбъект, Основание);
		УправлениеЗаказами.УстановитьДатуОплатыПоДоговору(ЭтотОбъект);
		ЗаполнитьТабЧастиТоварыНаОсновании( Основание);
		ЗаполнитьТабЧастиУслугиНаОсновании( Основание);
		ЗаполнитьТабЧастиТараНаОсновании  ( Основание);
		Если Основание.ВидОперации = Перечисления.ВидыОперацийЗаказПоставщику.Оборудование Тогда
			ЗаполнитьТабЧастиОборудованиеНаОсновании( Основание);
		КонецЕсли;
		
	КонецЕсли;
	Если ТипЗнч(Основание) = Тип("СправочникСсылка.НастройкиЗаполненияФорм") Тогда
		ХранилищаНастроек.ДанныеФорм.ЗаполнитьОбъектПоНастройке(ЭтотОбъект, Основание, Документы.РеализацияТоваровУслуг.СтруктураДополнительныхДанныхФормы());
	КонецЕсли;
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, "Покупка");
	УправлениеЗаказами.УстановитьДатуОплатыПоДоговору(ЭтотОбъект);
	СуммаДокумента = УчетНДС.ПолучитьСуммуДокументаСНДС(ЭтотОбъект);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, "Покупка", ОбъектКопирования.Ссылка);
КонецПроцедуры


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

