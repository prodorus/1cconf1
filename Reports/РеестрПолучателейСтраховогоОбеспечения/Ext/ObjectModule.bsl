Перем СохраненнаяНастройка Экспорт;        // Текущий вариант отчета

Перем ТаблицаВариантовОтчета Экспорт;      // Таблица вариантов доступных текущему пользователю

	
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	НачалоПериода = '00010101';
	КонецПериода  = '00010101';
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат Результат;
	Иначе
		НачалоПериода = ПараметрНачалоПериода.Значение;
		КонецПериода  = ПараметрКонецПериода.Значение;
		ПараметрНачалоПериода.Использование = Истина;
		ПараметрКонецПериода.Использование  = Истина;
		Если НачалоПериода = '00010101'  тогда
			НачалоПериода = НачалоМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
		КонецЕсли;
		Если КонецПериода = '00010101' тогда
			КонецПериода = КонецМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
		КонецЕсли;
	КонецЕсли;
	
	ДтНачМесяца = НачалоМесяца(НачалоПериода);
	ТекстЗапроса = "ВЫБРАТЬ
	|	ДАТАВРЕМЯ("+Формат(ДтНачМесяца, "ДФ=yyyy")+", "+Месяц(ДтНачМесяца)+", "+День(ДтНачМесяца)+") КАК Период
	|ПОМЕСТИТЬ ВТПериоды";
	
	Пока ДтНачМесяца <= КонецПериода Цикл
		ДтНачМесяца = ДобавитьМесяц(ДтНачМесяца, 1);
		ТекстЗапроса =  ТекстЗапроса + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДАТАВРЕМЯ("+Формат(ДтНачМесяца, "ДФ=yyyy")+", "+Месяц(ДтНачМесяца)+", "+День(ДтНачМесяца)+") КАК Период
		|";
	КонецЦИкла;
	
	СтрокаЗамены = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(РегламентированныйПроизводственныйКалендарь.ДатаКалендаря, МЕСЯЦ) КАК Период
	|ПОМЕСТИТЬ ВТПериоды
	|ИЗ
	|	РегистрСведений.РегламентированныйПроизводственныйКалендарь КАК РегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	РегламентированныйПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &НачалоПериода И &КонецПериода";
				   
	СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос, СтрокаЗамены, ТекстЗапроса);

	
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
		
	Возврат Результат;
		
КонецФункции

Процедура СохранитьНастройку() Экспорт

	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры

Процедура ПрименитьНастройку() Экспорт
	
	Схема = ТиповыеОтчеты.ПолучитьСхемуКомпоновкиОбъекта(ЭтотОбъект);

	// Считываение структуры настроек отчета
 	Если Не СохраненнаяНастройка.Пустая() Тогда
		
		СтруктураНастроек = СохраненнаяНастройка.ХранилищеНастроек.Получить();
		Если Не СтруктураНастроек = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьНастройки(СтруктураНастроек.НастройкиКомпоновщика);
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		Иначе
			КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
		КонецЕсли;
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	СтруктураНатроек = Новый Структура();
	Возврат СтруктураНатроек;
КонецФункции

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
// Настройка отчета при отработки расшифровки
Процедура Настроить(Отбор) Экспорт
	
	// Настройка отбора
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
		Иначе
			ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Поле);
		КонецЕсли;
		
		Если КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЗаполнитьЗначенияСвойств(НовыйЭлементОтбора, ЭлементОтбора);
		Иначе
			НовыйЭлементОтбора.Использование  = Истина;
			НовыйЭлементОтбора.ЛевоеЗначение  = ПолеОтбора;
			Если ЭлементОтбора.Иерархия Тогда
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
				КонецЕсли;
			Иначе
				Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				Иначе
					НовыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
				КонецЕсли;
			КонецЕсли;
			
			НовыйЭлементОтбора.ПравоеЗначение = ЭлементОтбора.Значение;
			
		КонецЕсли;
				
	КонецЦикла;
	
	ТиповыеОтчеты.УдалитьДублиОтбора(КомпоновщикНастроек);
	
КонецПроцедуры

#КонецЕсли

Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	Для каждого ВыбранноеПоле из КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
		Если ТипЗнч(ВыбранноеПоле) = Тип("ВыбранноеПолеКомпоновкиДанных") И ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ДанныеОФизЛице.ДеньРождения") тогда 
			ВыбранноеПоле.Заголовок = "Ближайший день рождения";
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеПараметра.Значение = '00010101' Тогда
		ЗначениеПараметра.Значение = КонецДня(ТекущаяДата());
		ЗначениеПараметра.Использование = Истина;
	КонецЕсли;
КонецПроцедуры



Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;

Если КомпоновщикНастроек = Неопределено Тогда
	КомпоновщикНастроек =  Новый КомпоновщикНастроекКомпоновкиДанных;
КонецЕсли;

УправлениеОтчетами.ЗаменитьНазваниеПолейСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос = УправлениеОтчетамиПереопределяемый.ПодставитьЗапросДляПолученияНалоговойПолитики(СхемаКомпоновкиДанных.НаборыДанных.Данные.Запрос);
