&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.УникальныйИдентификатор = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru='Данная обработка вызывается из других процедур конфигурации.
			|Вручную ее вызывать запрещено.'");
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		
		Возврат;
		
	КонецЕсли;
	
	ИдентификаторВызывающейФормы = Параметры.УникальныйИдентификатор;
	
	ЗагрузитьНастройкиОтбораПоУмолчанию();
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокКнопкиПеренести) Тогда
		Команды["ПеренестиВДокумент"].Заголовок = Параметры.ЗаголовокКнопкиПеренести;
		Команды["ПеренестиВДокумент"].Подсказка = Параметры.ЗаголовокКнопкиПеренести;
	КонецЕсли;
	
	ИспользоватьХарактеристикиНоменклатуры = глЗначениеПеременной("ИспользоватьХарактеристикиНоменклатуры");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.Товары.ПодчиненныеЭлементы.ТоварыХарактеристикаНоменклатуры.Видимость = ИспользоватьХарактеристикиНоменклатуры;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПеренестиВДокумент И Объект.Товары.Количество() > 0 Тогда
		
		ОтветНаВопрос = Вопрос(НСтр("ru = 'Подобранные товары не перенесены в документ. Перенести?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
		Если ОтветНаВопрос = КодВозвратаДиалога.Отмена Тогда
			
			Отказ = Истина;
			
		ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
			
			Отказ = Истина;
			
			ПеренестиВДокумент(Неопределено);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВоВременноеХранилищеИЗакрыть()
	
	Закрыть(АдресТоваровВХранилище);
	
КонецПроцедуры


// Процедура выполняет загрузку настроек отбора из настроек по умолчанию.
//
&НаСервере
Процедура ЗагрузитьНастройкиОтбораПоУмолчанию()
	
	СхемаКомпоновкиДанных = Обработки.ПодборНоменклатурыПоОтбору.ПолучитьМакет("Макет");
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, ЭтаФорма.УникальныйИдентификатор)));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры // ЗагрузитьНастройкиОтбораПоУмолчанию()

// Процедура выполняет заполнение табличной части "Товары".
//
&НаСервере
Процедура ЗаполнитьТаблицуТоваровНаСервере(ПроверятьЗаполнение = Истина)
	
	// Поля необходимые для вывода в таблицу товаров на форме.
	СтруктураНастроек = Обработки.ПодборНоменклатурыПоОтбору.ПолучитьПустуюСтруктуруНастроек();
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	
	Если ПолучитьФункциональнуюОпцию("ИспользованиеХарактеристикНоменклатуры") Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("ХарактеристикаНоменклатуры");
	КонецЕсли;
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("ЕдиницаИзмерения");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Цена");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Валюта");
	
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроек;
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "Макет";
	
	Объект.Товары.Очистить();
	
	// Загрузка сформированного списка товаров.
	СтруктураРезультата = Обработки.ПодборНоменклатурыПоОтбору.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоваров Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		
		//ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ,, "ХарактеристикаНоменклатуры");
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		//Если ПолучитьФункциональнуюОпцию("ИспользованиеХарактеристикНоменклатуры") Тогда
		//	НоваяСтрока.ХарактеристикаНоменклатуры = СтрокаТЧ.ХарактеристикаНоменклатуры;
		//КонецЕсли;
		
		
	КонецЦикла;
	
	Элементы.Товары.Обновить();
	
КонецПроцедуры // ЗаполнитьТаблицуТоваровНаСервере()

&НаСервере
Процедура ПоместитьВоВременноеХранилищеНаСервере()
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(Объект.Товары.Выгрузить(), ИдентификаторВызывающейФормы);
	
КонецПроцедуры


// Процедура - обработчик команды "ПеренестиВДокумент".
//
&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент 	   = Истина;
	
	ПоместитьВоВременноеХранилищеНаСервере();
	
	ПодключитьОбработчикОжидания("ПоместитьВоВременноеХранилищеИЗакрыть", 0.1, Истина);
	
КонецПроцедуры

// Процедура - обработчик команды "ЗаполнитьТаблицуТоваров".
//
&НаКлиенте
Процедура ЗаполнитьТаблицуТоваров(Команда)
	
	ТекстВопроса = НСтр("ru = 'При заполнении все введенные ранее данные будут потеряны. Продолжить?'");
	Если Объект.Товары.Количество() = 0 ИЛИ КодВозвратаДиалога.Да = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да) Тогда
		ЗаполнитьТаблицуТоваровНаСервере();
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьТаблицуТоваров()
