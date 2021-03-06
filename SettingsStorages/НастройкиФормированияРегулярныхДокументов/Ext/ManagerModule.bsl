Функция ТекущийВладелецЭтоСкладскиеДокументы(КлючТекущегоВладельца) Экспорт
	Возврат ?(Найти(КлючТекущегоВладельца,"СкладскиеОрдера") > 0, Истина, Ложь)
КонецФункции	

Функция ПолучитьСсылкуПоКлючуТекущейНастройки(КлючТекущейНастройки, КлючТекущегоВладельца, ОтработанноеВремя = Ложь) Экспорт
	
	РезультатСтруктура = Новый Структура;
	ОбработкаСкладскихДокументов = ТекущийВладелецЭтоСкладскиеДокументы(КлючТекущегоВладельца);
	
	Если СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(КлючТекущейНастройки) тогда
		
		Если ОбработкаСкладскихДокументов Тогда
			ЗначениеСтруктура = Справочники.НастройкиФормированияДокументовПоОрдерам.ПолучитьСсылку(Новый УникальныйИдентификатор(КлючТекущейНастройки))		
		Иначе
		
			Если ОтработанноеВремя Тогда
				ЗначениеСтруктура = Справочники.НастройкиФормированияДокументовОтработанногоВремени.ПолучитьСсылку(Новый УникальныйИдентификатор(КлючТекущейНастройки))			
			Иначе
				ЗначениеСтруктура = Справочники.НастройкиФормированияДокументовВыпускаПродукции.ПолучитьСсылку(Новый УникальныйИдентификатор(КлючТекущейНастройки))			
			КонецЕсли; 
		
		КонецЕсли; 
		РезультатСтруктура.Вставить("НастройкаСсылка", ЗначениеСтруктура);
		
	Иначе
		
		Если ОбработкаСкладскихДокументов Тогда
			ЗначениеСтруктура = Справочники.НастройкиФормированияДокументовПоОрдерам.ПустаяСсылка()
		Иначе
		
			 Если ОтработанноеВремя Тогда
			 	 ЗначениеСтруктура = Справочники.НастройкиФормированияДокументовОтработанногоВремени.ПустаяСсылка()
			 Иначе
			 	 ЗначениеСтруктура = Справочники.НастройкиФормированияДокументовВыпускаПродукции.ПустаяСсылка()
			 КонецЕсли; 
		
		КонецЕсли; 
		РезультатСтруктура.Вставить("НастройкаСсылка", ЗначениеСтруктура);

	КонецЕсли;
	
	РезультатСтруктура.Вставить("ОбработкаСкладскихДокументов", ОбработкаСкладскихДокументов);
	
	Возврат РезультатСтруктура
	
КонецФункции

Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	СтруктураНастроек = ПолучитьСсылкуПоКлючуТекущейНастройки(КлючНастроек, КлючОбъекта);
	Ссылка							= СтруктураНастроек.НастройкаСсылка;
	ОбработкаСкладскихДокументов	= СтруктураНастроек.ОбработкаСкладскихДокументов;
	
	Если Не Ссылка.Пустая() Тогда
		Настройки = Новый Соответствие();
		Если ОбработкаСкладскихДокументов Тогда
			Настройки.Вставить("НастройкиКомпоновщика",Ссылка.НастройкиКомпоновщика.Получить());
		КонецЕсли;
		Настройки.Вставить("КлючТекущейНастройки", КлючНастроек);
		Настройки.Вставить("ТекущаяНастройка", Ссылка.Наименование);
		ОписаниеНастроек = Новый ОписаниеНастроек();
		ОписаниеНастроек.Представление = Ссылка.Наименование;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	СтруктураНастроек = ПолучитьСсылкуПоКлючуТекущейНастройки(КлючНастроек, КлючОбъекта);
	Ссылка							= СтруктураНастроек.НастройкаСсылка;
	ОбработкаСкладскихДокументов	= СтруктураНастроек.ОбработкаСкладскихДокументов;
	
	Если Не Ссылка.Пустая() Тогда
		
		НастройкаОбъект = Ссылка.ПолучитьОбъект();
		НастройкаОбъект.Заблокировать();
		Если ОбработкаСкладскихДокументов Тогда
			НастройкаОбъект.НастройкиКомпоновщика = Новый ХранилищеЗначения(Настройки["НастройкиКомпоновщика"], Новый СжатиеДанных());
		КонецЕСли;
		Если ОписаниеНастроек <> Неопределено Тогда
			НастройкаОбъект.Наименование = ОписаниеНастроек.Представление;
		КонецЕсли;
		НастройкаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

