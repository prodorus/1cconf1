﻿&НаКлиенте
Перем ПоддерживаемыеТипыВО;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию номенклатуры;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора) Экспорт

	Перем Номенклатура, ЕдиницаИзмерения, ЕдиницаИзмеренияМест, Количество, Коэффициент, СведенияЕдиницаИзмеренияМест, Качество;
	Перем ХарактеристикаНоменклатуры, СерияНоменклатуры;
	
	// Получим параметры подбора из структуры подбора.
	ЗначениеВыбора.Свойство("Номенклатура",					Номенклатура);
	ЗначениеВыбора.Свойство("ХарактеристикаНоменклатуры",	ХарактеристикаНоменклатуры);
	ЗначениеВыбора.Свойство("СерияНоменклатуры",			СерияНоменклатуры);
	ЗначениеВыбора.Свойство("ЕдиницаИзмерения",				ЕдиницаИзмерения);
	ЗначениеВыбора.Свойство("ЕдиницаИзмеренияМест",			ЕдиницаИзмеренияМест);
	ЗначениеВыбора.Свойство("Коэффициент",					Коэффициент);
	ЗначениеВыбора.Свойство("Количество",					Количество);
	ЗначениеВыбора.Свойство("Качество",						Качество);
	ЗначениеВыбора.Свойство("СведенияЕдиницаИзмеренияМест", СведенияЕдиницаИзмеренияМест);


	// Ищем выбранную позицию в таблице подобранной номенклатуры.
	// Если найдем - увеличим количество; не найдем - добавим новую строку.
	СтруктураОтбора = Новый Структура();
	Если ИмяТабличнойЧасти = "Товары" Тогда
		СтруктураОтбора.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
		СтруктураОтбора.Вставить("Качество", Качество);
		СтруктураОтбора.Вставить("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
		СтруктураОтбора.Вставить("СерияНоменклатуры", СерияНоменклатуры);
	Иначе
		СтруктураОтбора.Вставить("Номенклатура", Номенклатура);
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
		Если ИмяТабличнойЧасти = "Товары" Тогда
			РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти);
		КонецЕсли;
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		СтрокаТабличнойЧасти.Номенклатура     			= Номенклатура;
		СтрокаТабличнойЧасти.Количество       			= Количество;
		Если ИмяТабличнойЧасти = "Товары" Тогда
			СтрокаТабличнойЧасти.ЕдиницаИзмерения 			= ЕдиницаИзмерения;
			СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест		= ЕдиницаИзмеренияМест;
			СтрокаТабличнойЧасти.Коэффициент      			= Коэффициент;
			СтрокаТабличнойЧасти.Качество      				= Качество;
			РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, СведенияЕдиницаИзмеренияМест);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры //

&НаКлиенте
Процедура ДействиеПодбор(ИмяТабличнойЧасти)
	Если ИмяТабличнойЧасти = "Товары" Тогда
		Команда = "ПодборВТабличнуюЧастьТовары";
	ИначеЕсли ИмяТабличнойЧасти = "ВозвратнаяТара" Тогда
		Команда = "ПодборВТабличнуюЧастьВозвратнаяТара";
	КонецЕсли;
	
	ЕстьУслуги = Ложь;
	
	СтруктураПараметровПодбора = Новый Структура();
	СтруктураПараметровПодбора.Вставить("Команда", Команда);
	
	СтруктураПараметровПодбора.Вставить("ПодбиратьУслуги", ЕстьУслуги);
	Если ЕстьУслуги Тогда
		СтруктураПараметровПодбора.Вставить("ОтборУслугПоСправочнику", Ложь);
	КонецЕсли;
	
	ВременнаяДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	СтруктураПараметровПодбора.Вставить("ДатаРасчетов", ВременнаяДатаРасчетов);
	
	РаботаСДиалогамиКлиент.ОткрытьПодборНоменклатуры(ЭтаФорма, СтруктураПараметровПодбора);
		
КонецПроцедуры //

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ПустаяСтрока(Объект.Номер) Тогда
		ПрефиксацияОбъектовСобытия.ОчиститьНомерОбъекта(Объект.Номер, Объект.Организация);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Это существующий документ. 
		// Проверим, что его можно менять.
		НастройкаПравДоступа.ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(РеквизитФормыВЗначение("Объект"), ЭтаФорма);
		
	КонецЕсли;

	//РаботаСВнешнимОборудованием
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Перем Команда;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ВыбранноеЗначение.Свойство("Команда", Команда);

		Если Команда = "ПодборВТабличнуюЧастьТовары" Тогда
			ОбработкаПодбора("Товары", ВыбранноеЗначение);
		ИначеЕсли Команда = "ПодборВТабличнуюЧастьВозвратнаяТара" Тогда
			ОбработкаПодбора("ВозвратнаяТара", ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// МеханизмВнешнегоОборудования
	Если ИспользоватьПодключаемоеОборудование
		И МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента() Тогда
		
		ОписаниеОшибки = "";
		
		ПоддерживаемыеТипыВО = Новый Массив();
		ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
		
		Если Не МенеджерОборудованияКлиент.ПодключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО, ОписаниеОшибки) Тогда
			ТекстСообщения = НСтр("ru = 'При подключении оборудования произошла ошибка:
			                      |""%ОписаниеОшибки%"".'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// МеханизмВнешнегоОборудования
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоТипу(УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	// Конец МеханизмВнешнегоОборудования
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData" Тогда
			
			//Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Данные = Новый Структура("Штрихкод, Количество", Параметр[0], 1); // Достаем штрихкод из основных данных
			Иначе
				Данные = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
			КонецЕсли;
			
			ПолученыШтрихкоды(Данные);
			
		КонецЕсли;
		
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

// СОХРАНЕНИЕ И ВОССТАНОВЛЕНИЕ ДАННЫХ ИЗ НАСТРОЕК

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	ХранилищаНастроек.ДанныеФорм.ДобавитьДополнительныеДанныеВНастройку(Объект, Настройки, Документы.ПеремещениеТоваров.СтруктураДополнительныхДанныхФормы());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ХранилищаНастроек.ДанныеФорм.ЗаполнитьОбъектДополнительнымиДанными(Объект, Настройки, Документы.ПеремещениеТоваров.СтруктураДополнительныхДанныхФормы());
	Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ "ТОВАРЫ" И ЕЁ РЕКВИЗИТОВ

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	ДанныеОбменаССервером = Новый Структура();
	ДанныеОбменаССервером.Вставить("Номенклатура",  СтрокаТабличнойЧасти.Номенклатура);
	
	// Получим все необходимые данные на сервере
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ИзменениеНоменклатуры(ДанныеОбменаССервером);
	
	// Заполним реквизиты строки
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗначенияДляЗаполнения);
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, ДанныеОбменаССервером.СведенияЕдиницаИзмеренияМест);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	ДанныеОбменаССервером = Новый Структура();
	ДанныеОбменаССервером.Вставить("ЕдиницаИзмерения",     СтрокаТабличнойЧасти.ЕдиницаИзмерения);
	ДанныеОбменаССервером.Вставить("ЕдиницаИзмеренияМест", СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест);
	
	// Получим все необходимые данные на сервере
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ИзменениеЕдиницыИзмерения(ДанныеОбменаССервером);
	
	// Заполним реквизиты строки
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ЗначенияДляЗаполнения);
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, ДанныеОбменаССервером.СведенияЕдиницаИзмеренияМест);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияМестПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	РаботаСДиалогамиКлиент.ОчиститьКоличествоМестПриОчисткеЕдиницыМест(СтрокаТабличнойЧасти);
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	РаботаСДиалогамиКлиент.РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоМестПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	РаботаСДиалогамиКлиент.РассчитатьКоличествоТабЧасти(СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНовыйСчетУчетаБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.НовыйСчетУчетаНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.НовыйСчетУчетаБУ));

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСчетУчетаБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СчетУчетаНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.СчетУчетаБУ));

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПринятыеСчетУчетаБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.ПринятыеСчетУчетаНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.ПринятыеСчетУчетаБУ));

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНовыйПринятыеСчетУчетаБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.НовыйПринятыеСчетУчетаНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.НовыйПринятыеСчетУчетаБУ));

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПодбор(Команда)
	ДействиеПодбор("Товары");
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	ТекШтрихкод = "";
	Если ШтрихКодыНоменклатурыКлиент.ВвестиШтрихкод(ТекШтрихкод) Тогда
		ПолученыШтрихкоды(ШтрихКодыНоменклатурыКлиентСервер.ПолучитьСтруктуруДанныхШтрихкода(ТекШтрихкод, 1));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолученыШтрихкоды(ДанныеШтрихкодов)
	
	СведенияПоШтрихКоду = ШтрихКодыНоменклатуры.ПолучитьСведенияПоШтрихКоду(ДанныеШтрихкодов);
	Если СведенияПоШтрихКоду <> Неопределено Тогда
		ОбработкаПодбора("Товары", СведенияПоШтрихКоду);		
	КонецЕсли; 

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТЧ "ВОЗВРАТНАЯ ТАРА" И ЕЁ РЕКВИЗИТОВ

&НаКлиенте
Процедура ВозвратнаяТараНовыйСчетУчетаБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ВозвратнаяТара.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.НовыйСчетУчетаНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.НовыйСчетУчетаБУ));

КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараСчетУчетаБУПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ВозвратнаяТара.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.СчетУчетаНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТабличнойЧасти.СчетУчетаБУ));

КонецПроцедуры

&НаКлиенте
Процедура ВозвратнаяТараПодбор(Команда)
	ДействиеПодбор("ВозвратнаяТара");
КонецПроцедуры







