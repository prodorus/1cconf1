﻿Перем мУдалятьДвижения;

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Заполняет ТЧ Товары и Услуги по расчетному документу
//
Процедура ЗаполнитьПоРасчетномуДокументу(РежимДобавления) Экспорт

	Перем ВидыЦенностейПоСчетамУчета;
	
	Если Не ЗначениеЗаполнено(РасчетныйДокумент) Тогда
		Возврат;
	КонецЕсли;

	Если ТоварыИУслуги.Количество() > 0 И Не РежимДобавления Тогда

		#Если Клиент Тогда
		ТекстВопроса = "Перед заполнением табличная часть будет очищена. Продолжить?";
		Ответ        = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, Метаданные().Представление());

		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
		#КонецЕсли

		ТоварыИУслуги.Очистить();

	КонецЕсли;
	
	ТаблицаДокумента = УчетНДС.ПолучитьТаблицуДокументаНДС(РасчетныйДокумент, , Ложь);
	Если ТаблицаДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТаблицаДокумента.Колонки.Найти("СуммаБезНДСВал") <> Неопределено Тогда
		Если ТаблицаДокумента.Колонки.Найти("Сумма") <> Неопределено Тогда
			ТаблицаДокумента.Колонки.Удалить("Сумма");
		КонецЕсли;
		ТаблицаДокумента.Колонки.СуммаБезНДСВал.Имя = "Сумма";
		Если ТаблицаДокумента.Колонки.Найти("СуммаНДС") = Неопределено Тогда
			Если ТаблицаДокумента.Колонки.Найти("НДСВал") <> Неопределено Тогда
				ТаблицаДокумента.Колонки.НДСВал.Имя = "СуммаНДС";
			Иначе
				ТаблицаДокумента.Колонки.НДС.Имя = "СуммаНДС";
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТаблицаДокумента.Колонки.Найти("СуммаБезНДС") <> Неопределено Тогда
		Если ТаблицаДокумента.Колонки.Найти("Сумма") <> Неопределено Тогда
			ТаблицаДокумента.Колонки.Удалить("Сумма");
		КонецЕсли;
		ТаблицаДокумента.Колонки.СуммаБезНДС.Имя = "Сумма";
		Если ТаблицаДокумента.Колонки.Найти("СуммаНДС") = Неопределено Тогда
			ТаблицаДокумента.Колонки.НДС.Имя = "СуммаНДС";
		КонецЕсли;
	Иначе
		Если ТаблицаДокумента.Колонки.Найти("СуммаНДС") = Неопределено Тогда
			ТаблицаДокумента.Колонки.НДС.Имя = "СуммаНДС";
		КонецЕсли;
	КонецЕсли;	
	
	Если ТаблицаДокумента.Колонки.Найти("СчетЗатрат") = Неопределено 
		И ТаблицаДокумента.Колонки.Найти("СчетУчетаБУ") <> Неопределено Тогда
		ТаблицаДокумента.Колонки.СчетУчетаБУ.Имя = "СчетЗатрат";		
	КонецЕсли;
	
	ТоварыИУслуги.Загрузить(ТаблицаДокумента);
	ТоварыИУслуги.Свернуть("ВидЦенности, Номенклатура, СчетЗатрат, Субконто1, Субконто2, Субконто3, СчетУчетаНДС, СтавкаНДС, 
							|Коэффициент, НомерГТД, СтранаПроисхождения, Событие", "Количество, Цена, Сумма, СуммаНДС");
							
	ПересчитыватьЗаполненнуюЦену = Не (РасчетныйДокумент.Метаданные().Реквизиты.Найти("СуммаВключаетНДС") <> Неопределено
			И РасчетныйДокумент.СуммаВключаетНДС = СуммаВключаетНДС);
			
	Для Каждого СтрокаДокумента Из ТоварыИУслуги Цикл
		
		Если СуммаВключаетНДС Тогда
			СтрокаДокумента.Сумма = СтрокаДокумента.Сумма + СтрокаДокумента.СуммаНДС;
		КонецЕсли;
		
		Если (СтрокаДокумента.Цена = 0 Или ПересчитыватьЗаполненнуюЦену) 
			И СтрокаДокумента.Сумма <> 0 
			Тогда
			Если СтрокаДокумента.Количество = 0 Тогда
				СтрокаДокумента.Количество = 1;
			КонецЕсли;
			СтрокаДокумента.Цена = СтрокаДокумента.Сумма / СтрокаДокумента.Количество;
		КонецЕсли;
		
		СтрокаДокумента.Событие = ?(ИспользоватьДокументРасчетовКакСчетФактуру, Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету, Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком);
		Если Не ЗначениеЗаполнено(СтрокаДокумента.ВидЦенности) Тогда
			СтрокаДокумента.ВидЦенности = УчетНДС.ОпределитьВидЦенности(СтрокаДокумента.Номенклатура, СтрокаДокумента.СчетЗатрат, 
																		ТипЗнч(РасчетныйДокумент) = Тип("ДокументСсылка.ПоступлениеДопРасходов"), ДоговорКонтрагента.УчетАгентскогоНДС, ДоговорКонтрагента.ВидАгентскогоДоговора, ВидыЦенностейПоСчетамУчета);
		КонецЕсли;
																	
	КонецЦикла;
	
КонецПроцедуры

// Заполняет счета БУ и НУ в строке табличной части
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт

	ЗаполнитьСчетаУчетаВТабЧасти(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ);

КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧасти()

// Заполняет счета БУ и НУ в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабЧасти(ТабличнаяЧасть, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт
	
	//СчетЗатрат определяется как счет учета номенклатуры, заполнение выполняется вне зависимости от установленного режима "Определять счета при проведении"
	СчетаУчетаВДокументах.ЗаполнитьСчетаУчетаТабличнойЧасти(ИмяТабЧасти, ТабличнаяЧасть, ЭтотОбъект, ЗаполнятьБУ, ЗаполнятьНУ,Ложь,,Истина);
	
КонецПроцедуры // ЗаполнитьСчетаУчетаВТабЧасти()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	СтруктураОбязательныхПолей = Новый Структура("Организация");
	
	Если Не (СтруктураШапкиДокумента.ИспользоватьДокументРасчетовКакСчетФактуру И УчетНДС.ДляСчетаФактурыНеТребуетсяКонтрагент(СтруктураШапкиДокумента.РасчетныйДокумент)) Тогда 
		СтруктураОбязательныхПолей.Вставить("Контрагент");
		СтруктураОбязательныхПолей.Вставить("ДоговорКонтрагента");
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ИспользоватьДокументРасчетовКакСчетФактуру Тогда 
		СтруктураОбязательныхПолей.Вставить("РасчетныйДокумент");
	КонецЕсли;
	Если СтруктураШапкиДокумента.ЗаписьДополнительногоЛиста Тогда
		СтруктураОбязательныхПолей.Вставить("КорректируемыйПериод");
	КонецЕсли;

	Если СтруктураШапкиДокумента.Дата >= '20150101' Тогда
		СтруктураОбязательныхПолей.Вставить("КодВидаОперации");
	КонецЕсли;

	// Теперь позовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура формирует структуру шапки документа и дополнительных полей.
//
Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента, Отказ) Экспорт
	
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	ДополнитьСтруктуруШапкиДокумента(СтруктураШапкиДокумента, Отказ);
	
КонецПроцедуры

// Дополняет структуру шапки документа значениями, требуемыми для проведения
//
Процедура ДополнитьСтруктуруШапкиДокумента(СтруктураШапкиДокумента, Отказ)
	
	СтруктураШапкиДокумента.Вставить("ОтражатьВНалоговомУчете", Ложь);
	СтруктураШапкиДокумента.Вставить("ОтражатьВНалоговомУчетеУСН", Ложь);
	СтруктураШапкиДокумента.Вставить("ВалютаРегламентированногоУчета", мВалютаРегламентированногоУчета);
	
	СтруктураПолейУчетнойПолитикиНУ = Новый Структура("СложныйУчетНДС");
	ОбщегоНазначения.ДополнитьПоложениямиУчетнойПолитики(СтруктураШапкиДокумента, СтруктураШапкиДокумента.Дата, Отказ, СтруктураШапкиДокумента.Организация, "Нал", СтруктураПолейУчетнойПолитикиНУ);
	
	//Если СтруктураШапкиДокумента.ИспользоватьДокументРасчетовКакСчетФактуру И ЗначениеЗаполнено(СтруктураШапкиДокумента.РасчетныйДокумент) Тогда
	//	СчетФактура = УчетНДС.НайтиПодчиненныйСчетФактуру(СтруктураШапкиДокумента.РасчетныйДокумент, "СчетФактураПолученный", Новый Структура("Проведен", Истина));
	//	Если Не ЗначениеЗаполнено(СчетФактура) Тогда
	//		СтруктураШапкиДокумента.ПредъявленСчетФактура = Ложь;
	//		СтруктураШапкиДокумента.НДСПредъявленКВычету = Ложь;
	//	Иначе
	//		СтруктураШапкиДокумента.ПредъявленСчетФактура = Истина;
	//		СтруктураШапкиДокумента.НДСПредъявленКВычету = Не СчетФактура.НДСПредъявленКВычету;
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры

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

	ТаблицаТоваров.Колонки.Добавить("Период");
	ТаблицаТоваров.Колонки.Добавить("Активность");
	ТаблицаТоваров.Колонки.Добавить("Организация");
	ТаблицаТоваров.Колонки.Добавить("Поставщик");
	ТаблицаТоваров.Колонки.Добавить("ДоговорКонтрагента");
	ТаблицаТоваров.Колонки.Добавить("СчетФактура");
	ТаблицаТоваров.Колонки.Добавить("СуммаБезНДС");
	ТаблицаТоваров.Колонки.Добавить("ЗаписьДополнительногоЛиста");
	ТаблицаТоваров.Колонки.Добавить("КорректируемыйПериод");
	ТаблицаТоваров.Колонки.Добавить("КодВидаОперации", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(10));

	Если СтруктураШапкиДокумента.Дата >= '20150101' Тогда
		ТаблицаТоваров.ЗаполнитьЗначения(СтруктураШапкиДокумента.КодВидаОперации, "КодВидаОперации");
	КонецЕсли;

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Организация = СтруктураШапкиДокумента.Организация;
		СтрокаТаблицы.Поставщик = СтруктураШапкиДокумента.Контрагент;
		СтрокаТаблицы.ДоговорКонтрагента = СтруктураШапкиДокумента.ДоговорКонтрагента;
		Если СтруктураШапкиДокумента.ИспользоватьДокументРасчетовКакСчетФактуру Тогда
			Если ТипЗнч(СтруктураШапкиДокумента.РасчетныйДокумент) = Тип("ДокументСсылка.СчетФактураВыданный") 
				И СтруктураШапкиДокумента.РасчетныйДокумент.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыВыставленного.НаАванс
				И СтруктураШапкиДокумента.РасчетныйДокумент.ДокументыОснования.Количество() <> 0 Тогда
				СтрокаТаблицы.СчетФактура = СтруктураШапкиДокумента.РасчетныйДокумент.ДокументыОснования[0].ДокументОснование;
			ИначеЕсли ТипЗнч(СтруктураШапкиДокумента.РасчетныйДокумент) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") 
				И Не СтруктураШапкиДокумента.РасчетныйДокумент.ПокупателемВыставляетсяСчетФактураНаВозврат Тогда
				СтрокаТаблицы.СчетФактура = СтруктураШапкиДокумента.РасчетныйДокумент.Сделка;
			Иначе
				СтрокаТаблицы.СчетФактура = СтруктураШапкиДокумента.РасчетныйДокумент
			КонецЕсли;
		Иначе
			СтрокаТаблицы.СчетФактура = СтруктураШапкиДокумента.Ссылка;
		КонецЕсли;
		СтрокаТаблицы.ЗаписьДополнительногоЛиста = СтруктураШапкиДокумента.ЗаписьДополнительногоЛиста;
		Если СтруктураШапкиДокумента.ЗаписьДополнительногоЛиста Тогда
			СтрокаТаблицы.КорректируемыйПериод = СтруктураШапкиДокумента.КорректируемыйПериод;
		КонецЕсли;
		Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
			Если СтруктураШапкиДокумента.ВалютаДокумента <> СтруктураШапкиДокумента.ВалютаРегламентированногоУчета Тогда
				СтрокаТаблицы.Сумма = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.Сумма, СтруктураШапкиДокумента.ВалютаДокумента,
																					СтруктураШапкиДокумента.ВалютаРегламентированногоУчета,
																					СтруктураШапкиДокумента.КурсВзаиморасчетов, 1,
																					СтруктураШапкиДокумента.КратностьВзаиморасчетов, 1);
				СтрокаТаблицы.НДС = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтрокаТаблицы.НДС, СтруктураШапкиДокумента.ВалютаДокумента,
																					СтруктураШапкиДокумента.ВалютаРегламентированногоУчета,
																					СтруктураШапкиДокумента.КурсВзаиморасчетов, 1,
																					СтруктураШапкиДокумента.КратностьВзаиморасчетов, 1);
			КонецЕсли;
			СтрокаТаблицы.СуммаБезНДС = СтрокаТаблицы.Сумма - ?(СтруктураШапкиДокумента.СуммаВключаетНДС, СтрокаТаблицы.НДС, 0);
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Событие) Тогда
			СтрокаТаблицы.Событие = ?(СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу, Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету,
										Перечисления.СобытияПоНДСПокупки.ПредъявленНДСПоставщиком);
		КонецЕсли;
	КонецЦикла;
	
	Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		ТаблицаТоваров.Свернуть("Период, Активность, Организация, ВидЦенности, Поставщик, ДоговорКонтрагента, Событие, СчетФактура, СтавкаНДС, СчетУчетаНДС, ЗаписьДополнительногоЛиста, КорректируемыйПериод, КодВидаОперации", "СуммаБезНДС, НДС");
	КонецЕсли;
	
	Возврат ТаблицаТоваров;

КонецФункции // ПодготовитьТаблицуТоваров()

Функция ПодготовитьТаблицуДокументовОплаты(РезультатЗапросаПоДокументамОплаты, СтруктураШапкиДокумента)

	ТаблицаДокументовОплаты = РезультатЗапросаПоДокументамОплаты.Выгрузить();
	ТаблицаДокументовОплаты.Колонки.Добавить("Период");
	ТаблицаДокументовОплаты.Колонки.Добавить("Активность");
	ТаблицаДокументовОплаты.Колонки.Добавить("Организация");
	ТаблицаДокументовОплаты.Колонки.Добавить("Поставщик");
	ТаблицаДокументовОплаты.Колонки.Добавить("Событие");
	ТаблицаДокументовОплаты.Колонки.Добавить("СчетФактура");
	ТаблицаДокументовОплаты.Колонки.Добавить("ЗаписьДополнительногоЛиста");
	ТаблицаДокументовОплаты.Колонки.Добавить("КорректируемыйПериод");
	ТаблицаДокументовОплаты.Колонки.Добавить("КодВидаОперации", ОбщегоНазначения.ПолучитьОписаниеТиповСтроки(10));
	
	ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация,       "Организация");
	ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.Контрагент,        "Поставщик");
	Если СтруктураШапкиДокумента.ИспользоватьДокументРасчетовКакСчетФактуру Тогда
		Если ТипЗнч(СтруктураШапкиДокумента.РасчетныйДокумент) = Тип("ДокументСсылка.СчетФактураВыданный") 
			И СтруктураШапкиДокумента.РасчетныйДокумент.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыВыставленного.НаАванс 
			И СтруктураШапкиДокумента.РасчетныйДокумент.ДокументыОснования.Количество() <> 0 Тогда
			ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.РасчетныйДокумент.ДокументыОснования[0].ДокументОснование, "СчетФактура");
		ИначеЕсли ТипЗнч(СтруктураШапкиДокумента.РасчетныйДокумент) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") 
			И Не СтруктураШапкиДокумента.РасчетныйДокумент.ПокупателемВыставляетсяСчетФактураНаВозврат Тогда
			ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.РасчетныйДокумент.Сделка, "СчетФактура");
		Иначе
			ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.РасчетныйДокумент, "СчетФактура");
		КонецЕсли;
	Иначе
		ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.Ссылка, "СчетФактура");
	КонецЕсли;
	ТаблицаДокументовОплаты.ЗаполнитьЗначения(Перечисления.СобытияПоНДСПокупки.ПредъявленНДСКВычету, "Событие");
	ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.ЗаписьДополнительногоЛиста, "ЗаписьДополнительногоЛиста");
	ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.КорректируемыйПериод, "КорректируемыйПериод");
	
	Если СтруктураШапкиДокумента.Дата >= '20150101' Тогда
		ТаблицаДокументовОплаты.ЗаполнитьЗначения(СтруктураШапкиДокумента.КодВидаОперации, "КодВидаОперации");
	КонецЕсли;
	
	ТаблицаДокументовОплаты.Колонки.Добавить("ДатаДокументаОплаты");
	ТаблицаДокументовОплаты.Колонки.Добавить("НомерДокументаОплаты");
	
	Для Каждого СтрокаТаблицы Из ТаблицаДокументовОплаты Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.ДатаОплаты)
			И ЗначениеЗаполнено(СтрокаТаблицы.ДокументОплаты) Тогда
			СтрокаТаблицы.ДатаДокументаОплаты = СтрокаТаблицы.ДатаОплаты;
			СтрокаТаблицы.НомерДокументаОплаты = ОбщегоНазначения.ПолучитьНомерНаПечать(СтрокаТаблицы.ДокументОплаты);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДокументовОплаты.Свернуть("Период, Активность, Организация, Поставщик, Событие, СчетФактура, ДатаОплаты, ДокументОплаты, ЗаписьДополнительногоЛиста, КорректируемыйПериод, КодВидаОперации, ДатаДокументаОплаты, НомерДокументаОплаты");
	
	Возврат ТаблицаДокументовОплаты;

КонецФункции  //ПодготовитьТаблицуДокументовОплаты()

Процедура ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоДокументамОплаты) Экспорт
	
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить("Номенклатура", "Номенклатура");
	СтруктураПолей.Вставить("ВидЦенности", 	"ВидЦенности");
	СтруктураПолей.Вставить("Сумма", 		"Сумма");
	СтруктураПолей.Вставить("СтавкаНДС"   , "СтавкаНДС");
	СтруктураПолей.Вставить("НДС"         , "СуммаНДС");
	СтруктураПолей.Вставить("СчетЗатрат"  , "СчетЗатрат");
	СтруктураПолей.Вставить("СчетУчетаНДС", "СчетУчетаНДС");
	СтруктураПолей.Вставить("Субконто1"   , "Субконто1");
	СтруктураПолей.Вставить("Субконто2"   , "Субконто2");
	СтруктураПолей.Вставить("Субконто3"   , "Субконто3");
	СтруктураПолей.Вставить("Событие"   , 	"Событие");

	РезультатЗапросаПоТоварам = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ТоварыИУслуги", СтруктураПолей);

	// Подготовим таблицу товаров для проведения.
	ТаблицаПоТоварам = ПодготовитьТаблицуТоваров(РезультатЗапросаПоТоварам, СтруктураШапкиДокумента);
	
	Если Не СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		БухгалтерскийУчетРасчетовСКонтрагентами.ПодготовкаТаблицыЗначенийДляЦелейПриобретенияИРеализации(ТаблицаПоТоварам, СтруктураШапкиДокумента, Ложь, мВалютаРегламентированногоУчета);
	КонецЕсли;
	
	ТаблицаПоДокументамОплаты = Неопределено;
	Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		СтруктураПолей.Очистить();
		СтруктураПолей.Вставить("ДокументОплаты", 	"ДокументОплаты");
		СтруктураПолей.Вставить("ДатаОплаты", 		"ДатаОплаты");
		РезультатЗапросаПоДокументамОплаты = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "ДокументыОплаты", СтруктураПолей);
		ТаблицаПоДокументамОплаты = ПодготовитьТаблицуДокументовОплаты(РезультатЗапросаПоДокументамОплаты, СтруктураШапкиДокумента);
	КонецЕсли;
	
КонецПроцедуры	

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

	ИмяТабличнойЧасти = "ТоварыИУслуги";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("СтавкаНДС" + ?(СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу, "", ", Номенклатура"));

	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Проверяет правильность заполнения строк табличной части "ДокументыОплаты".
//
// Параметры:
// Параметры: 
//  ТаблицаПоТоварам        - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеТабличнойЧастиДокументыОплаты(ТаблицаПоДокументамОплаты, СтруктураШапкиДокумента, Отказ, Заголовок)

	Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		// Укажем, что надо проверить:
		СтруктураОбязательныхПолей = Новый Структура("ДатаОплаты");
		
		// Теперь вызовем общую процедуру проверки.
		ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ДокументыОплаты", СтруктураОбязательныхПолей, Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()

// Процедура выполняет движения по регистрам
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоДокументамОплаты, Отказ, Заголовок)

	Если СтруктураШапкиДокумента.ФормироватьПроводки Тогда
		ПроводкиБУ = Движения.Хозрасчетный; 
		Для Каждого СтрокаТаблицы Из ТаблицаПоТоварам Цикл
			// Проводки по вычету в случае упрощенного учета НДС
			
			Проводка = ПроводкиБУ.Добавить();

			Проводка.Период      = СтруктураШапкиДокумента.Дата;

			Проводка.Организация = СтруктураШапкиДокумента.Организация;
			Проводка.Содержание  = "НДС";

			Проводка.СчетДт      = ПланыСчетов.Хозрасчетный.НДС; //68.02
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "ВидыПлатежейВГосБюджет", Перечисления.ВидыПлатежейВГосБюджет.Налог);

			Проводка.СчетКт      = СтрокаТаблицы.СчетУчетаНДС;
			Если Проводка.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СФПолученные) <> Неопределено Тогда 
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,"СФПолученные", СтрокаТаблицы.СчетФактура, Истина, Заголовок);
			КонецЕсли;	
			Если Проводка.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СФВыданные) <> Неопределено Тогда 
				БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,"СФВыданные", СтрокаТаблицы.СчетФактура, Истина, Заголовок);
			КонецЕсли;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт,"Контрагенты", СтруктураШапкиДокумента.Контрагент, Истина);
			Проводка.Сумма       = СтрокаТаблицы.НДС;

		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		// Прямая запись в книгу покупок
		ТаблицаДвижений_НДСЗаписиКнигиПокупок = Движения.НДСЗаписиКнигиПокупок.Выгрузить();
		
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоТоварам, ТаблицаДвижений_НДСЗаписиКнигиПокупок);
		ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоДокументамОплаты, ТаблицаДвижений_НДСЗаписиКнигиПокупок);
		Для Каждого СтрокаДвижения Из ТаблицаДвижений_НДСЗаписиКнигиПокупок Цикл
			Если Не (СтрокаДвижения.ВидЦенности = Перечисления.ВидыЦенностей.АвансыПолученные
					Или СтрокаДвижения.ВидЦенности = Перечисления.ВидыЦенностей.АвансыПолученные0
					Или СтрокаДвижения.ВидЦенности = Перечисления.ВидыЦенностей.ВозвратАвансовПолученных
					Или СтрокаДвижения.ВидЦенности = Перечисления.ВидыЦенностей.НалоговыйАгентКомитент) Тогда
				СтрокаДвижения.ДоговорКонтрагента = Неопределено;
			КонецЕсли;
		КонецЦикла;
		
		Движения.НДСЗаписиКнигиПокупок.мПериод 			= СтруктураШапкиДокумента.Дата;
		Движения.НДСЗаписиКнигиПокупок.мТаблицаДвижений = ТаблицаДвижений_НДСЗаписиКнигиПокупок;
		Движения.НДСЗаписиКнигиПокупок.ДобавитьДвижение();
	    Возврат;
	КонецЕсли; 

	ТаблицаПредъявленногоНДС = ТаблицаПоТоварам.Скопировать();
		
	УчетНДСФормированиеДвижений.СформироватьДвиженияПоРегиструНДСПредъявленный(СтруктураШапкиДокумента, ТаблицаПредъявленногоНДС, Отказ);
			
КонецПроцедуры // ДвиженияПоРегистрам()	

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(Основание)
	
	Если Не (ЗначениеЗаполнено(Основание) И ЭтотОбъект.Метаданные().Реквизиты.РасчетныйДокумент.Тип.СодержитТип(ТипЗнч(Основание))) Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним реквизиты из стандартного набора.
	ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
	
	УпрощенныйУчетНДС = УчетНДС.ПолучитьУПУпрощенныйУчетНДС(Организация, Дата);
	Если УпрощенныйУчетНДС И Не ПрямаяЗаписьВКнигу Тогда
		ПрямаяЗаписьВКнигу = Истина;
		Если Не ФормироватьПроводки Тогда
			ФормироватьПроводки = Истина;
		КонецЕсли;			
	КонецЕсли;
	
	РасчетныйДокумент = Основание;

	ИспользоватьДокументРасчетовКакСчетФактуру = Истина;
	
	ЗаполнитьПоРасчетномуДокументу(Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	Перем СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоДокументамОплаты; 
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = "Проведение документа """ + СокрЛП(Ссылка) + """: ";
	
	ДокументСоздан_НО_НДС = (ЗначениеЗаполнено(РасчетныйДокумент)) и (ТипЗнч(РасчетныйДокумент) = Тип("ДокументСсылка.ВводНачальныхОстатковНДС"));

	Если ДокументСоздан_НО_НДС Тогда
		// Проверка и дополнительная обработка не требуются
		Возврат;
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента, Отказ);
	
	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоДокументамОплаты);
	ПроверитьЗаполнениеТабличнойЧастиТовары(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	Если СтруктураШапкиДокумента.ПрямаяЗаписьВКнигу Тогда
		ПроверитьЗаполнениеТабличнойЧастиДокументыОплаты(ТаблицаПоТоварам, СтруктураШапкиДокумента, Отказ, Заголовок);
	КонецЕсли;
	
	//Заполнение и проверка заполнения счетов учета номенклатуры и затрат
	СчетаУчетаВДокументах.ПроверитьСчетаУчетаТабличнойЧасти("ТоварыИУслуги", ТаблицаПоТоварам, 	СтруктураШапкиДокумента, Отказ, Заголовок);
	
	Если Не Отказ Тогда
		
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоТоварам, ТаблицаПоДокументамОплаты, Отказ, Заголовок);
		УчетНДС.СинхронизацияПроведенияУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный", Отказ)
		
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = ТоварыИУслуги.Итог("Сумма") + ?(Не СуммаВключаетНДС, ТоварыИУслуги.Итог("СуммаНДС"), 0);
	Если НЕ ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = мВалютаРегламентированногоУчета;
	КонецЕсли; 
	
	Если Не ИспользоватьДокументРасчетовКакСчетФактуру Тогда
		
		УчетНДС.СинхронизацияПометкиНаУдалениеУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный");
		
	КонецЕсли;
		
	Если Не ПрямаяЗаписьВКнигу И ФормироватьПроводки Тогда
		ФормироватьПроводки = Ложь;
	КонецЕсли;

	мУдалятьДвижения = Не ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью


Процедура ОбработкаУдаленияПроведения(Отказ)

	УчетНДС.СинхронизацияПроведенияУСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный", Отказ);
КонецПроцедуры // ОбработкаУдаленияПроведения

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИспользоватьДокументРасчетовКакСчетФактуру Тогда
		УчетНДС.ПроверитьСоответствиеРеквизитовСчетаФактуры(ЭтотОбъект, "СчетФактураПолученный");
	КонецЕсли;
		
КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

