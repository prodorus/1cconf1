﻿&НаКлиенте
Перем ПоддерживаемыеТипыВО;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура УстановитьВидимость()
	//Видимость заказов покупателя в табличной  части в зависимости от настроек
	УказаниеЗаказов = глЗначениеПеременной("УказаниеЗаказовВТабличнойЧастиДокументов");
	УказаниеЗаказовВТЧ = (УказаниеЗаказов = Перечисления.ВариантыУказанияЗаказовВТабличнойЧастиДокументов.ДляДокументовРеализации)
			ИЛИ (УказаниеЗаказов = Перечисления.ВариантыУказанияЗаказовВТабличнойЧастиДокументов.ДляДокументовПоступленияРеализации);
	Элементы.УслугиЗаказПокупателя.Видимость = 			УказаниеЗаказовВТЧ;
	
	//Видимость автоматических скидок.
	мРассчитыватьАвтоматическиеСкидки = Ложь;
	мУчетнаяПолитика = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиУпр(?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Дата,ТекущаяДата()));
	Если ЗначениеЗаполнено(мУчетнаяПолитика) 
		И (мУчетнаяПолитика.ИспользоватьСкидкиПоКоличествуТовара
		 Или мУчетнаяПолитика.ИспользоватьСкидкиПоСуммеДокумента
		 Или мУчетнаяПолитика.ИспользоватьСкидкиПоВидуОплаты
		 Или мУчетнаяПолитика.ИспользоватьСкидкиПоДисконтнойКарте) Тогда
		мРассчитыватьАвтоматическиеСкидки = Истина;
	КонецЕсли;

	Элементы.УслугиПроцентАвтоматическихСкидок.Видимость = мРассчитыватьАвтоматическиеСкидки;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьОграничениеТипаСделки()
	Если ДоговорПоСчетам Тогда
		ОписаниеТипаСделки = Новый ОписаниеТипов("ДокументСсылка.СчетНаОплатуПокупателю");
	Иначе
		ОписаниеТипаСделки = Новый ОписаниеТипов("ДокументСсылка.ЗаказПокупателя");
	КонецЕсли;
	Элементы.Сделка.ОграничениеТипа = ОписаниеТипаСделки;
	Если НЕ ОписаниеТипаСделки.СодержитТип(ТипЗнч(Объект.Сделка)) Тогда
		Объект.Сделка = ОписаниеТипаСделки.ПривестиЗначение(Объект.Сделка);
	КонецЕсли;
КонецПроцедуры

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию номенклатуры;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора) Экспорт

	Перем Номенклатура, ЕдиницаИзмерения, ЕдиницаИзмеренияМест, Количество, Коэффициент, СведенияЕдиницаИзмеренияМест;
	Перем ХарактеристикаНоменклатуры, СерияНоменклатуры;
	
	// Получим параметры подбора из структуры подбора.
	ЗначениеВыбора.Свойство("Номенклатура",					Номенклатура);
	ЗначениеВыбора.Свойство("ХарактеристикаНоменклатуры",	ХарактеристикаНоменклатуры);
	ЗначениеВыбора.Свойство("СерияНоменклатуры",			СерияНоменклатуры);
	ЗначениеВыбора.Свойство("ЕдиницаИзмерения",				ЕдиницаИзмерения);
	ЗначениеВыбора.Свойство("ЕдиницаИзмеренияМест",			ЕдиницаИзмеренияМест);
	ЗначениеВыбора.Свойство("Коэффициент",					Коэффициент);
	ЗначениеВыбора.Свойство("Количество",					Количество);
	ЗначениеВыбора.Свойство("СведенияЕдиницаИзмеренияМест", СведенияЕдиницаИзмеренияМест);


	// Ищем выбранную позицию в таблице подобранной номенклатуры.
	// Если найдем - увеличим количество; не найдем - добавим новую строку.
	СтруктураОтбора = Новый Структура();
	СтруктураОтбора.Вставить("Номенклатура", Номенклатура);
	Если ЗначениеЗаполнено(Объект.Склад) И ИмяТабличнойЧасти <> "Услуги" Тогда
		СтруктураОтбора.Вставить("Склад", Объект.Склад);
	КонецЕсли;
	
	МассивСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТабличнойЧасти = Неопределено;
	Иначе
		СтрокаТабличнойЧасти = МассивСтрок[0];
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		// Нашли, увеличиваем количество в первой найденной строке.
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + Количество;
		РаботаСДиалогамиКлиент.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти);
		РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, Новый Структура("УчитыватьНДС, СуммаВключаетНДС", Объект.УчитыватьНДС, Объект.СуммаВключаетНДС));
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		СтрокаТабличнойЧасти.Номенклатура     			= Номенклатура;
		СтрокаТабличнойЧасти.Количество       			= Количество;
		//Для заполнения цен, сумм и ставок НДС вызовем обработчики изменения номенклатуры
		ИзменениеНоменклатурыУслугиКлиент(СтрокаТабличнойЧасти);
		Если ЗначениеЗаполнено(Объект.Сделка) И ТипЗнч(Объект.Сделка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			СтрокаТабличнойЧасти.ЗаказПокупателя = Объект.Сделка;
		КонецЕсли;
	КонецЕсли;
	ПересчитатьАвтоматическиеСкидки();
	РассчитатьСуммуДокумента();
КонецПроцедуры //

&НаКлиенте
Процедура ДействиеПодбор(ИмяТабличнойЧасти)

	Команда = "ПодборВТабличнуюЧастьУслуги";
	ЕстьУслуги = Истина;

	СтруктураПараметровПодбора = Новый Структура();
	СтруктураПараметровПодбора.Вставить("Команда", Команда);
	
	СтруктураПараметровПодбора.Вставить("ПодбиратьУслуги", ЕстьУслуги);
	СтруктураПараметровПодбора.Вставить("ОтборУслугПоСправочнику", Истина);
	
	ВременнаяДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	СтруктураПараметровПодбора.Вставить("ДатаРасчетов", ВременнаяДатаРасчетов);
	
	РаботаСДиалогамиКлиент.ОткрытьПодборНоменклатуры(ЭтаФорма, СтруктураПараметровПодбора);
		
КонецПроцедуры //

&НаСервере
Процедура УстановитьЗаголовокФормы(Форма) Экспорт
	
	ОбъектФормы = Форма.Объект;

	ТекстЗаголовка	= НСтр("ru = 'Реализация товаров и услуг'");
	
	Если ЗначениеЗаполнено(ОбъектФормы.Ссылка) Тогда
		ТекстЗаголовка = ТекстЗаголовка + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru=' %1 от %2'"), ОбъектФормы.Номер, ОбъектФормы.Дата);
	Иначе
		ТекстЗаголовка = ТекстЗаголовка + НСтр("ru = ' (создание)'");
	КонецЕсли;
	
	Форма.Заголовок = ТекстЗаголовка + " (" + Строка(ОбъектФормы.ВидОперации) + ")";

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Это существующий документ. 
		// Проверим, что его можно менять.
		НастройкаПравДоступа.ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(РеквизитФормыВЗначение("Объект"), ЭтаФорма);

	Иначе
		
		Объект.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.АктВыполненныхРабот;

	КонецЕсли;
	
	УстановитьВидимость(); 
	
	//Доступность цен для изменения
	мМожноМенятьЦенуВДокументе = УправлениеДопПравамиПользователей.РазрешитьРедактированиеЦенВДокументах();

	Элементы.УслугиЦена.ТолькоПросмотр                 = НЕ мМожноМенятьЦенуВДокументе;
	Элементы.УслугиСумма.ТолькоПросмотр                = НЕ мМожноМенятьЦенуВДокументе;
	Элементы.УслугиПроцентСкидкиНаценки.ТолькоПросмотр = НЕ мМожноМенятьЦенуВДокументе;
	Элементы.УслугиСуммаНДС.ТолькоПросмотр             = НЕ мМожноМенятьЦенуВДокументе;
	
	ДоговорПоЗаказам = (Объект.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам);
	ДоговорПоСчетам = (Объект.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам);

	мПересчитыватьСкидкуДокумента = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ПриИзмененииСуммыПересчитыватьСкидку");
	ВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	СпособСписанияСоСклада = Перечисления.СпособыСписанияОстаткаТоваров.СоСклада;
	ПроцентыСтавокНДС = РаботаСДиалогамиСервер.ПолучитьПроцентыСтавокНДС();
	ПредставлениеАдресаДоставки = УправлениеКонтактнойИнформацией.ПолучитьПредставлениеАдресаПоСтрока(Объект.АдресДоставки);
	УстановитьЗаголовокФормы(ЭтаФорма);

	//РаботаСВнешнимОборудованием
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	//Конец РаботаСВнешнимОборудованием
	
	// ЭлектронныеДокументы
	ИспользоватьОбменЭД = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("ИспользоватьОбменЭД");
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	// Конец ЭлектронныеДокументы
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОграничениеТипаСделки();
	УстановитьДоступность();
	РассчитатьСуммуДокумента(Истина);
	ОбновитьНадписиИтоговыеСуммы();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//Корректируем адрес доставки если он менялся в форме
	Если ПредставлениеАдресаДоставки <> УправлениеКонтактнойИнформацией.ПолучитьПредставлениеАдресаПоСтрока(ТекущийОбъект.АдресДоставки) Тогда
		ТекущийОбъект.АдресДоставки = ПредставлениеАдресаДоставки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// ОценкаПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ПредопределенноеЗначение("Перечисление.КлючевыеОперации.ПроведениеДокументаРеализацияТоваровУслуг"));
	// Конец ОценкаПроизводительности
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Перем Команда;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ВыбранноеЗначение.Свойство("Команда", Команда);

		Если Команда = "ПодборВТабличнуюЧастьУслуги" Тогда
			ОбработкаПодбора("Услуги", ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронныеДокументы
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		УстановитьТекстСостоянияЭДНаСервере();
	КонецЕсли;
	// Конец ЭлектронныеДокументы
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстСостоянияЭДНаСервере()
	
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
	// ЭлектронныеДокументы
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	// Конец ЭлектронныеДокументы
	
КонецПроцедуры

// СОХРАНЕНИЕ И ВОССТАНОВЛЕНИЕ ДАННЫХ ИЗ НАСТРОЕК

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ХранилищаНастроек.ДанныеФорм.ДобавитьДополнительныеДанныеВНастройку(Объект, Настройки, Документы.РеализацияТоваровУслуг.СтруктураДополнительныхДанныхФормы());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ХранилищаНастроек.ДанныеФорм.ЗаполнитьОбъектДополнительнымиДанными(Объект, Настройки, Документы.РеализацияТоваровУслуг.СтруктураДополнительныхДанныхФормы());
	Модифицированность = Истина;
	
	// Заполним курс и кратность валюты
	ДанныеДляЗаполнения = Новый Структура();
	ДанныеДляЗаполнения.Вставить("ВалютаДокумента", Настройки["Объект.ВалютаДокумента"]);
	ДанныеДляЗаполнения.Вставить("Дата",            Объект.Дата);
	ЗаполнитьЗначенияСвойств(Объект, РаботаСДиалогамиСервер.ПолучитьКурсВалюты(ДанныеДляЗаполнения));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ИЗМЕНЕНИЯ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ДанныеОбменаССервером = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, УчитыватьНДС, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ЗначенияДляЗаполнения = ИзменениеКонтрагентаСервер(ДанныеОбменаССервером);
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияДляЗаполнения);
	ПредставлениеАдресаДоставки = ЗначенияДляЗаполнения.ПредставлениеАдресаДоставки;
	ДоговорПоЗаказам = ЗначенияДляЗаполнения.ДоговорПоЗаказам;
	ДоговорПоСчетам = ЗначенияДляЗаполнения.ДоговорПоСчетам;
	УстановитьДоступность();
	ПересчитатьАвтоматическиеСкидки();
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
		УстановитьОграничениеТипаСделки();
	КонецЕсли;
	ОбновитьНадписиИтоговыеСуммы();
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ДанныеОбменаССервером = Новый Структура("ДоговорКонтрагента, УчитыватьНДС, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ЗначенияДляЗаполнения = ИзменениеДоговораСервер(ДанныеОбменаССервером);
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияДляЗаполнения);
	ДоговорПоЗаказам = ЗначенияДляЗаполнения.ДоговорПоЗаказам;
	ДоговорПоСчетам = ЗначенияДляЗаполнения.ДоговорПоСчетам;
	УстановитьОграничениеТипаСделки();
	ПересчитатьАвтоматическиеСкидки();
	УстановитьДоступность();
	ОбновитьНадписиИтоговыеСуммы();
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьНДСПриИзменении(Элемент)
	ИзмененСуммаВключаетНДС = Ложь;
	Если Объект.СуммаВключаетНДС И НЕ Объект.УчитыватьНДС Тогда
		ИзмененСуммаВключаетНДС = Истина;
		Объект.СуммаВключаетНДС = Ложь;
	КонецЕсли;
	Если Объект.Товары.Количество() + Объект.Услуги.Количество() > 0 Тогда
		ПересчитатьСуммыПриИзмененииФлаговНалогов(ИзмененСуммаВключаетНДС);
	КонецЕсли;
	РассчитатьСуммуДокумента();
	УстановитьДоступность();
	ОбновитьНадписиИтоговыеСуммы();
КонецПроцедуры

&НаКлиенте
Процедура СуммаВключаетНДСПриИзменении(Элемент)
	Если Объект.Товары.Количество() + Объект.Услуги.Количество() > 0 Тогда
		ПересчитатьСуммыПриИзмененииФлаговНалогов(Истина);
	КонецЕсли;

	РассчитатьСуммуДокумента();
	ОбновитьНадписиИтоговыеСуммы();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	РаботаСДиалогамиКлиент.ЗаполнитьКурсИКратностьДокумента(Объект, ВалютаРегламентированногоУчета);
	ПересчитатьАвтоматическиеСкидки();
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	РаботаСДиалогамиКлиент.ЗаполнитьКурсИКратностьДокумента(Объект, ВалютаРегламентированногоУчета);
	ОбновитьНадписиИтоговыеСуммы();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ПустаяСтрока(Объект.Номер) Тогда
		ПрефиксацияОбъектовСобытия.ОчиститьНомерОбъекта(Объект.Номер, Объект.Организация);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСостоянияЭДНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Уникальность", 	Объект.Ссылка.УникальныйИдентификатор());
	ПараметрыОткрытия.Вставить("Источник", 		ЭтаФорма);
	
	ЭлектронныеДокументыКлиент.ОткрытьДеревоЭД(Объект.Ссылка, ПараметрыОткрытия);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОВТОРЯЮЩИЕСЯ ДЕЙСТВИЯ ПРИ ИЗМЕНЕНИИ РАЗНЫХ РЕКВИЗИТОВ

// Процедура устанавливает доступность элементов формы
//
&НаКлиенте
Процедура УстановитьДоступность()
	Элементы.УслугиСтавкаНДС.Доступность = 	Объект.УчитыватьНДС;
	Элементы.УслугиСуммаНДС.Доступность = 	Объект.УчитыватьНДС;
	Элементы.СуммаВключаетНДС.Доступность = Объект.УчитыватьНДС;
	 
	Если ДоговорПоЗаказам ИЛИ ДоговорПоСчетам Тогда
		Элементы.Сделка.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.Сделка.АвтоОтметкаНезаполненного = Ложь;
		Если Элементы.Сделка.ОтметкаНезаполненного Тогда
			Элементы.Сделка.ОтметкаНезаполненного = Ложь;
		КонецЕсли;
	КонецЕсли;
	//Если договор по счетам, заказ покупателя в табличной части должен быть недоступен
	Элементы.УслугиЗаказПокупателя.Доступность = НЕ ДоговорПоСчетам;
КонецПроцедуры
 
&НаКлиенте
Процедура РассчитатьСуммуДокумента(РасчитатьТолькоСуммуНДС = Ложь)
	НДСВсего = Объект.Товары.Итог("СуммаНДС") + Объект.Услуги.Итог("СуммаНДС");
	Если РасчитатьТолькоСуммуНДС Тогда
		Возврат;
	КонецЕсли;
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	Если Объект.УчитыватьНДС И НЕ Объект.СуммаВключаетНДС Тогда
		Объект.СуммаДокумента = Объект.СуммаДокумента + НДСВсего;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписиИтоговыеСуммы()
	Элементы.СуммаДокумента.Заголовок = "Всего, " + Объект.ВалютаДокумента;
	Элементы.НДСВсего.Заголовок = "НДС (" + ?(Объект.СуммаВключаетНДС, "в т.ч.", "сверху") + ")";
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСуммыПриИзмененииФлаговНалогов(ИзмененФлагСуммаВключаетНДС)
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	Для Каждого СтрокаТабличнойЧасти ИЗ ДокументОбъект.Услуги Цикл
		СтрокаТабличнойЧасти.Цена = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(
							СтрокаТабличнойЧасти.Цена,
							Неопределено,
							?(ИзмененФлагСуммаВключаетНДС, НЕ ДокументОбъект.СуммаВключаетНДС, ДокументОбъект.СуммаВключаетНДС),
							ДокументОбъект.УчитыватьНДС,
							ДокументОбъект.СуммаВключаетНДС,
							УчетНДС.ПолучитьСтавкуНДС(СтрокаТабличнойЧасти.СтавкаНДС));
		ОбработкаТабличныхЧастей.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, ДокументОбъект);
		ОбработкаТабличныхЧастей.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ДокументОбъект);
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ ДАННЫХ В ШАПКЕ

&НаСервереБезКонтекста
Функция ИзменениеКонтрагентаСервер(ДанныеДляЗаполнения)
	СтруктураПараметровДляПолученияДоговора = ЗаполнениеДокументов.ПолучитьСтруктуруПараметровДляПолученияДоговораПродажи();
	
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ПриИзмененииЗначенияКонтрагента(ДанныеДляЗаполнения, СтруктураПараметровДляПолученияДоговора);
	//Получим адрес доставки
	ПолучитьАдресДоставки(ДанныеДляЗаполнения, ЗначенияДляЗаполнения);
	
	Возврат ЗначенияДляЗаполнения;
КонецФункции

&НаСервереБезКонтекста
Функция ИзменениеДоговораСервер(ДанныеДляЗаполнения)
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ПриИзмененииЗначенияДоговора(ДанныеДляЗаполнения);
	Возврат ЗначенияДляЗаполнения;
КонецФункции

&НаСервереБезКонтекста
Процедура ПолучитьАдресДоставки(ДанныеДляЗаполнения, ЗначенияДляЗаполнения)
	ДополнениеКАдресуДоставки = "";
	АдресДоставки = ЗаполнениеДокументов.ПолучитьАдресДоставкиСтрокой(ДанныеДляЗаполнения.Контрагент, ДополнениеКАдресуДоставки);
	ЗначенияДляЗаполнения.Вставить("АдресДоставки", АдресДоставки);
	ЗначенияДляЗаполнения.Вставить("ПредставлениеАдресаДоставки", УправлениеКонтактнойИнформацией.ПолучитьПредставлениеАдресаПоСтрока(АдресДоставки));
	ЗначенияДляЗаполнения.Вставить("ДополнениеКАдресуДоставки", ДополнениеКАдресуДоставки);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ ДАННЫХ В ТАБЛИЧНОЙ ЧАСТИ

&НаСервереБезКонтекста
Функция ИзменениеНоменклатурыУслугиСервер(ДанныеДляЗаполнения)
	
	ЗначенияДляЗаполнения = Новый Структура();
	
	// Основные реквизиты
	ЗначенияДляЗаполнения.Вставить("СтавкаНДС",				ДанныеДляЗаполнения.Номенклатура.СтавкаНДС);
	ЗначенияДляЗаполнения.Вставить("Содержание",			?(ЗначениеЗаполнено(ДанныеДляЗаполнения.Номенклатура.НаименованиеПолное), ДанныеДляЗаполнения.Номенклатура.НаименованиеПолное, ДанныеДляЗаполнения.Номенклатура.Наименование));
	Если ДанныеДляЗаполнения.Свойство("ТипЦен") Тогда
		//Добавим сведения о ценах
		ДанныеДляЗаполнения.Вставить("СтавкаНДС", ЗначенияДляЗаполнения.СтавкаНДС);
		ДанныеДляЗаполнения.Вставить("Склад", Справочники.Склады.ПустаяСсылка());
		ДанныеДляЗаполнения.Вставить("ХарактеристикаНоменклатуры", Неопределено);
		ДанныеДляЗаполнения.Вставить("ЕдиницаИзмерения", Справочники.ЕдиницыИзмерения.ПустаяСсылка());
		Цена = ОпределитьЦенуНоменклатуры(ДанныеДляЗаполнения);
		ЗначенияДляЗаполнения.Вставить("Цена", Цена);
	КонецЕсли;
	
	Возврат ЗначенияДляЗаполнения;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеНоменклатурыУслугиКлиент(СтрокаТабличнойЧасти)
	ДанныеОбменаССервером = Новый Структура("Номенклатура, УчитыватьНДС, СуммаВключаетНДС");
	//Сведения, необходимые для расчета цены
	Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда
		ДанныеОбменаССервером.Вставить("ТипЦен");
		ДанныеОбменаССервером.Вставить("Дата");
		ДанныеОбменаССервером.Вставить("Контрагент");
		ДанныеОбменаССервером.Вставить("ВалютаДокумента");
		ДанныеОбменаССервером.Вставить("КурсВзаиморасчетов");
		ДанныеОбменаССервером.Вставить("КратностьВзаиморасчетов");
		ДанныеОбменаССервером.Вставить("ДоговорКонтрагента");
		ДанныеОбменаССервером.Вставить("УсловиеПродаж");
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, СтрокаТабличнойЧасти);
	// Получим все необходимые данные на сервере
	ЗначенияДляЗаполнения = ИзменениеНоменклатурыУслугиСервер(ДанныеОбменаССервером);
	
	// Заполним реквизиты строки
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗначенияДляЗаполнения);
	СтруктураПараметров = ПолучитьСтруктуруПараметровДляРасчетаСуммы();
	РаботаСДиалогамиКлиент.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, СтруктураПараметров);
	РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, СтруктураПараметров);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьЦенуНоменклатуры(ДанныеДляЗаполнения)
	Цена = Ценообразование.ПолучитьЦенуНоменклатуры(ДанныеДляЗаполнения.Номенклатура, 
									ДанныеДляЗаполнения.ХарактеристикаНоменклатуры,
									ДанныеДляЗаполнения.ТипЦен, 
									ДанныеДляЗаполнения.Дата, 
									ДанныеДляЗаполнения.ЕдиницаИзмерения,
									ДанныеДляЗаполнения.ВалютаДокумента, 
									ДанныеДляЗаполнения.КурсВзаиморасчетов, 
									ДанныеДляЗаполнения.КратностьВзаиморасчетов, ,
									ДанныеДляЗаполнения.ДоговорКонтрагента,
									ДанныеДляЗаполнения.УсловиеПродаж);
	
	// Если цену заполнили, то ее надо пересчитывать по флагам налогообложения
	Если ЗначениеЗаполнено(Цена) Тогда

		Цена = Ценообразование.ПересчитатьЦенуПриИзмененииФлаговНалогов(Цена, 
										Перечисления.СпособыЗаполненияЦен.ПоЦенамНоменклатуры, 
										ДанныеДляЗаполнения.ТипЦен.ЦенаВключаетНДС,
										ДанныеДляЗаполнения.УчитыватьНДС, 
										ДанныеДляЗаполнения.СуммаВключаетНДС, 
										УчетНДС.ПолучитьСтавкуНДС(ДанныеДляЗаполнения.СтавкаНДС));
	КонецЕсли;
	Возврат Цена;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипСубконтоДляСчета(ДанныеДляЗаполнения)
	ЗначенияДляЗаполнения = Новый Структура("СубконтоБУ, СубконтоНУ");
	Если ЗначениеЗаполнено(ДанныеДляЗаполнения.СчетДоходовБУ) Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ДанныеДляЗаполнения.СчетДоходовБУ.ВидыСубконто[0].ВидСубконто.ТипЗначения.Типы()[0]);
		ОписаниеТиповСубконто = Новый ОписаниеТипов(МассивТипов);
		ЗначенияДляЗаполнения.Вставить("СубконтоБУ", ОписаниеТиповСубконто.ПривестиЗначение(Неопределено));
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеДляЗаполнения.СчетДоходовНУ) Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ДанныеДляЗаполнения.СчетДоходовНУ.ВидыСубконто[0].ВидСубконто.ТипЗначения.Типы()[0]);
		ОписаниеТиповСубконто = Новый ОписаниеТипов(МассивТипов);
		ЗначенияДляЗаполнения.Вставить("СубконтоНУ", ОписаниеТиповСубконто.ПривестиЗначение(Неопределено));
	КонецЕсли;
	Возврат ЗначенияДляЗаполнения;
КонецФункции

// Процедура выполняет пересчет автоматических скидок в документе.
//
// Возвращаемое значение:
//  Булево - Истина, если автоматические скидки были рассчитаны.
//
&НаСервере
Процедура ПересчитатьАвтоматическиеСкидкиСервер()

	ТекСуммаДокументаБезСкидок = Ценообразование.ПолучитьСуммуДокументаБезСкидки(Объект.Товары) + Ценообразование.ПолучитьСуммуДокументаБезСкидки(Объект.Услуги);
	ТипЦенДляОграниченияЦены = УправлениеДопПравамиПользователей.ПравоНеОтпускатьТоварСЦенойНижеОпределенногоТипа();

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВидРеализации"					, Перечисления.ВидыСкидок.Оптовая);
	СтруктураПараметров.Вставить("СуммаДокумента"					, ТекСуммаДокументаБезСкидок);
	СтруктураПараметров.Вставить("Карта"							, Объект.ДисконтнаяКарта);
	СтруктураПараметров.Вставить("УчитыватьНДС"						, Объект.УчитыватьНДС);
	СтруктураПараметров.Вставить("СуммаВключаетНДС"					, Объект.СуммаВключаетНДС);
	СтруктураПараметров.Вставить("ВалютаРегламентированногоУчета"	, ВалютаРегламентированногоУчета);
	СтруктураПараметров.Вставить("мУчетнаяПолитика"					,мУчетнаяПолитика);
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаТабличныхЧастей.РассчитатьСкидкиПриПродаже(ДокументОбъект, ДокументОбъект.Услуги, СтруктураПараметров, , ТипЦенДляОграниченияЦены);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
КонецПроцедуры // ПересчитатьАвтоматическиеСкидки()

// Процедура проверяет необходимость расчета автоскидок и вызывает пересчет автоматических скидок в документе.
//
&НаКлиенте
Процедура ПересчитатьАвтоматическиеСкидки()
	Если НЕ мРассчитыватьАвтоматическиеСкидки 
		ИЛИ Объект.Проведен 
		ИЛИ (Объект.Товары.Количество() = 0 И Объект.Услуги.Количество() = 0) Тогда
		Возврат;
	КонецЕсли;
	
	ПересчитатьАвтоматическиеСкидкиСервер();
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруПараметровДляРасчетаСуммы()
	Возврат Новый Структура("ЕстьПроцентАвтоматическихСкидок,ЕстьПроцентСкидкиНаценки,УчитыватьНДС,СуммаВключаетНДС", , , Объект.УчитыватьНДС, Объект.СуммаВключаетНДС);
КонецФункции

&НаКлиенте
Процедура ПриИзмененииСчетаДоходовБУ(СтрокаТабличнойЧасти)
	СтрокаТабличнойЧасти.СчетДоходовНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.СчетДоходовБУ));
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетДоходовБУ) ИЛИ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетДоходовНУ) Тогда
		СтруктураСчетаДоходов = Новый Структура("СчетДоходовБУ, СчетДоходовНУ", СтрокаТабличнойЧасти.СчетДоходовБУ, СтрокаТабличнойЧасти.СчетДоходовНУ);
		СтруктураСубконто = ПолучитьТипСубконтоДляСчета(СтруктураСчетаДоходов);
		Если СтруктураСубконто.СубконтоБУ <> Неопределено
			И ТипЗнч(СтрокаТабличнойЧасти.СубконтоБУ) <> ТипЗнч(СтруктураСубконто.СубконтоБУ) Тогда
			СтрокаТабличнойЧасти.СубконтоБУ = СтруктураСубконто.СубконтоБУ;
		КонецЕсли;
		Если СтруктураСубконто.СубконтоНУ <> Неопределено
			И ТипЗнч(СтрокаТабличнойЧасти.СубконтоНУ) <> ТипЗнч(СтруктураСубконто.СубконтоНУ) Тогда
			СтрокаТабличнойЧасти.СубконтоНУ = СтруктураСубконто.СубконтоНУ;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСчетаДоходовНУ(СтрокаТабличнойЧасти)
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетДоходовНУ) Тогда
		СтруктураСчетаДоходов = Новый Структура("СчетДоходовБУ, СчетДоходовНУ", Неопределено, СтрокаТабличнойЧасти.СчетДоходовНУ);
		СтруктураСубконто = ПолучитьТипСубконтоДляСчета(СтруктураСчетаДоходов);
		Если СтруктураСубконто.СубконтоНУ <> Неопределено
			И ТипЗнч(СтрокаТабличнойЧасти.СубконтоНУ) <> ТипЗнч(СтруктураСубконто.СубконтоНУ) Тогда
			СтрокаТабличнойЧасти.СубконтоНУ = СтруктураСубконто.СубконтоНУ;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ "УСЛУГИ" И ЕЁ РЕКВИЗИТОВ

&НаКлиенте
Процедура УслугиНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ИзменениеНоменклатурыУслугиКлиент(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровДляРасчетаСуммы();
	РаботаСДиалогамиКлиент.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, СтруктураПараметров);
	РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	СтруктураПараметров = ПолучитьСтруктуруПараметровДляРасчетаСуммы();
	РаботаСДиалогамиКлиент.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, СтруктураПараметров);
	РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура УслугиПроцентСкидкиНаценкиПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	СтруктураПараметров = ПолучитьСтруктуруПараметровДляРасчетаСуммы();
	РаботаСДиалогамиКлиент.РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, СтруктураПараметров);
	РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура УслугиСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	РаботаСДиалогамиКлиент.ПриИзмененииСуммыТабЧасти(СтрокаТабличнойЧасти, мПересчитыватьСкидкуДокумента);
	РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, ПолучитьСтруктуруПараметровДляРасчетаСуммы());
КонецПроцедуры

&НаКлиенте
Процедура УслугиСтавкаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	РаботаСДиалогамиКлиент.РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, ПолучитьСтруктуруПараметровДляРасчетаСуммы());
КонецПроцедуры

&НаКлиенте
Процедура УслугиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
		Если ЗначениеЗаполнено(Объект.Сделка) И ТипЗнч(Объект.Сделка) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			СтрокаТабличнойЧасти.ЗаказПокупателя = Объект.Сделка;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УслугиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Если Не ОтменаРедактирования Тогда
		ПересчитатьАвтоматическиеСкидки();
	КонецЕсли;

	//Пересчет суммы документа - для корректного отображения на форме
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиПослеУдаления(Элемент)
	ПересчитатьАвтоматическиеСкидки();
	//Пересчет суммы документа - для корректного отображения на форме
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиСчетДоходовБУПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ПриИзмененииСчетаДоходовБУ(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиСчетДоходовНУПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	ПриИзмененииСчетаДоходовНУ(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиСчетРасходовБУПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СчетРасходовНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.СчетРасходовБУ));
КонецПроцедуры

&НаКлиенте
Процедура УслугиСубконтоБУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетДоходовБУ) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УслугиСубконтоНУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетДоходовНУ) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УслугиПодбор(Команда)
	ДействиеПодбор("Услуги");
КонецПроцедуры
