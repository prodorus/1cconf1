&НаСервереБезКонтекста
Процедура ПолучитьДанныеНоменклатуры(СтруктураДанных)
	СтруктураДанных.Вставить("ЕдиницаИзмерения",			СтруктураДанных.Номенклатура.ЕдиницаХраненияОстатков);
	СтруктураДанных.Вставить("Коэффициент",					СтруктураДанных.ЕдиницаИзмерения.Коэффициент);
	СтруктураДанных.Вставить("Качество", 					Справочники.Качество.Новый);
	СтруктураДанных.Вставить("ХарактеристикаНоменклатуры",	Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	СтруктураДанных.Вставить("СерияНоменклатуры", 			Справочники.СерииНоменклатуры.ПустаяСсылка());
	ЕдиницаИзмеренияМест = СтруктураДанных.Номенклатура.ЕдиницаИзмеренияМест;
	СтруктураДанных.Вставить("ЕдиницаИзмеренияМест", 		ЕдиницаИзмеренияМест);
	СтруктураДанных.Вставить("СведенияЕдиницаИзмеренияМест", РаботаСДиалогамиСервер.СведенияЕдиницаИзмеренияМест(ЕдиницаИзмеренияМест)); // Могут потребоваться на клиенте
КонецПроцедуры //
 
&НаКлиенте
Процедура СписокНоменклатурыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТипЗначения = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 3, ДопустимыйЗнак.Неотрицательный));
	
	Количество = 1;
	Если НЕ ВвестиЗначение(Количество, "Введите количество", ТипЗначения) Тогда
		Возврат;
	КонецЕсли;	
	
	СтруктураПодбора = Новый Структура();
	СтруктураПодбора.Вставить("Команда",      КомандаПодбора);
	СтруктураПодбора.Вставить("Номенклатура", Значение);
	
	СтруктураПодбора.Вставить("Количество",   Количество);
	
	ПолучитьДанныеНоменклатуры(СтруктураПодбора);
	
	ОповеститьОВыборе(СтруктураПодбора);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборУслуг(ЗначениеОтбора)

    ЭлементОтбора = СписокНоменклатуры.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Услуга");
    ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
    ЭлементОтбора.Использование = Истина;
    ЭлементОтбора.ПравоеЗначение = ЗначениеОтбора;
	
КонецПроцедуры //

// Процедура добавляет вывод остатков в список номенклатуры
//
&НаСервере
Процедура УстановитьСписокСОстатками()

	СписокНоменклатуры.ПроизвольныйЗапрос = Истина;
	
	Если Параметры.Склад.Пустая() Тогда
		СписокНоменклатуры.ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СпрНоменклатура.Ссылка,
			|	СпрНоменклатура.Код,
			|	СпрНоменклатура.Наименование,
			|	СпрНоменклатура.НаименованиеПолное,
			|	СвободныеОстаткиОстатки.КоличествоОстаток
			|ИЗ
			|	Справочник.Номенклатура КАК СпрНоменклатура
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки.Остатки(&Дата, ) КАК СвободныеОстаткиОстатки
			|		ПО СпрНоменклатура.Ссылка = СвободныеОстаткиОстатки.Номенклатура";
	Иначе
		
		СписокНоменклатуры.Параметры.УстановитьЗначениеПараметра("Склад", Параметры.Склад);
		
		СписокНоменклатуры.ТекстЗапроса =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	СпрНоменклатура.Ссылка,
			|	СпрНоменклатура.Код,
			|	СпрНоменклатура.Наименование,
			|	СпрНоменклатура.НаименованиеПолное,
			|	СвободныеОстаткиОстатки.КоличествоОстаток
			|ИЗ
			|	Справочник.Номенклатура КАК СпрНоменклатура
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеОстатки.Остатки(&Дата, Склад = &Склад) КАК СвободныеОстаткиОстатки
			|		ПО СпрНоменклатура.Ссылка = СвободныеОстаткиОстатки.Номенклатура";
	КонецЕсли; 
									  
	СписокНоменклатуры.Параметры.УстановитьЗначениеПараметра("Дата", Параметры.ДатаРасчетов);
	
	СписокНоменклатуры.ОсновнаяТаблица = "СпрНоменклатура";
	
	ПолеКоличество = Элементы.Добавить("КоличествоОстаток", Тип("ПолеФормы"), Элементы.СписокНоменклатуры);
	ПолеКоличество.ПутьКДанным = "СписокНоменклатуры.КоличествоОстаток";
	ПолеКоличество.Заголовок = "Остаток";
	ПолеКоличество.Подсказка = "Остаток номенклатуры";
	
КонецПроцедуры //
 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КомандаПодбора = Параметры.Команда;
	Если Параметры.ОтборУслугПоСправочнику Тогда
		УстановитьОтборУслуг(Параметры.ПодбиратьУслуги);
	КонецЕсли;
	
	Если глЗначениеПеременной("ИспользоватьРегистрСвободныеОстатки") Тогда
		УстановитьСписокСОстатками();
	КонецЕсли; 
	
КонецПроцедуры
