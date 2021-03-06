
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Заполнение переменных формы
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	СписокВыбораВидаДоговора = ПолучитьСписокВыбораВидаДоговора(Объект.Владелец);
	
	ВидДоговораПрочее 			= Перечисления.ВидыДоговоровКонтрагентов.Прочее;
	ВидДоговораСКомиссионером 	= Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером;
	ВидДоговораСКомитентом 		= Перечисления.ВидыДоговоровКонтрагентов.СКомитентом;
	ВидДоговораСПокупателем 	= Перечисления.ВидыДоговоровКонтрагентов.СПокупателем;
	ВидДоговораСПоставщиком 	= Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	
	ВедениеВзаиморасчетовПоДоговоруВЦелом = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоДоговоруВЦелом;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()

	Элементы.ВедениеВзаиморасчетов.Доступность = (Объект.ВидДоговора <> ВидДоговораПрочее
														И ЗначениеЗаполнено(Объект.ВидДоговора));

	// Установка видимости реквизита реализации на экспорт
	Если Объект.ВидДоговора <> ВидДоговораСПокупателем Тогда
		Элементы.РеализацияНаЭкспорт.Доступность = Ложь;
	Иначе
		Элементы.РеализацияНаЭкспорт.Доступность = Истина;
	КонецЕсли;
	
	//Видимость и доступность флага "Расчеты в условных единицах"
	Элементы.РасчетыВУсловныхЕдиницах.Доступность = Ложь;
	Если Объект.ВидДоговора = ВидДоговораСПоставщиком или 
		Объект.ВидДоговора = ВидДоговораСПокупателем Тогда
		Если Объект.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета И НЕ Объект.УчетАгентскогоНДС Тогда
			Элементы.РасчетыВУсловныхЕдиницах.Доступность = Истина;
		Конецесли;
	КонецЕсли;

	Элементы.ВестиПоДокументамРасчетовСКонтрагентом.Доступность = Объект.ВидДоговора <> ВидДоговораПрочее;
	
КонецПроцедуры // УстановитьВидимость()

&НаСервереБезКонтекста
Функция ПолучитьСписокВыбораВидаДоговора(Контрагент)
	СписокВыбораВидаДоговора = Новый СписокЗначений;
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		СписокВыбораВидаДоговора = УправлениеВзаиморасчетами.ПолучитьСписокВидовДоговоровВзаиморасчетовПрочее();
	Иначе
		Если Контрагент.Покупатель И Контрагент.Поставщик Тогда
			СписокВыбораВидаДоговора = ОбщегоНазначения.ПолучитьСписокЭлементовПеречисления("ВидыДоговоровКонтрагентов");
		ИначеЕсли Контрагент.Покупатель Тогда
			СписокВыбораВидаДоговора = УправлениеВзаиморасчетами.ПолучитьСписокВидовДоговоровВзаиморасчетовДляПокупателя();
		ИначеЕсли Контрагент.Поставщик Тогда
			СписокВыбораВидаДоговора = УправлениеВзаиморасчетами.ПолучитьСписокВидовДоговоровВзаиморасчетовДляПоставщика();
		Иначе
			СписокВыбораВидаДоговора = УправлениеВзаиморасчетами.ПолучитьСписокВидовДоговоровВзаиморасчетовПрочее();
		КонецЕсли; 
	КонецЕсли;
	Возврат СписокВыбораВидаДоговора;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСписокВыбораВидаДоговора()
	Элементы.ВидДоговора.СписокВыбора.Очистить();
	Для Каждого ЭлементСписка ИЗ СписокВыбораВидаДоговора Цикл
		НовыйЭлементСписка = Элементы.ВидДоговора.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	СписокВыбораВидаДоговора = ПолучитьСписокВыбораВидаДоговора(Объект.Владелец);
	ЗаполнитьСписокВыбораВидаДоговора();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТипЦенДоговора()
	Если Объект.ВидДоговора = ВидДоговораСПокупателем ИЛИ 
		Объект.ВидДоговора = ВидДоговораСКомиссионером Тогда
		ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.ТипыЦенНоменклатуры");
	ИначеЕсли Объект.ВидДоговора = ВидДоговораСПоставщиком ИЛИ 
		Объект.ВидДоговора = ВидДоговораСКомитентом Тогда
		ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.ТипыЦенНоменклатурыКонтрагентов");
	Иначе
		Возврат;
	КонецЕсли; 
	Объект.ТипЦен = ОписаниеТипов.ПривестиЗначение(Объект.ТипЦен);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УстановитьТипЦенДоговора();
	КонецЕсли;
	ЗаполнитьСписокВыбораВидаДоговора();
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора) ИЛИ Объект.ВидДоговора = ВидДоговораПрочее Тогда
		Объект.ВедениеВзаиморасчетов                    = ВедениеВзаиморасчетовПоДоговоруВЦелом;
		Объект.ТипЦен                                   = Неопределено;
		Объект.ВестиПоДокументамРасчетовСКонтрагентом   = Ложь;
	КонецЕсли;

	//Зачистка флага "Расчеты в условных единицах" для всех видов договоров кроме договоров в поставщиком и с покупателем
	Если НЕ (Объект.ВидДоговора = ВидДоговораСПоставщиком ИЛИ Объект.ВидДоговора = ВидДоговораСПокупателем) Тогда
		Объект.РасчетыВУсловныхЕдиницах = Ложь;
	КонецЕсли;

	//Зачистка флага "Реализация на экспорт" для всех видов договоров кроме договора с покупателем
	Если Объект.ВидДоговора <> ВидДоговораСПокупателем Тогда
		Объект.РеализацияНаЭкспорт = Ложь;
	КонецЕсли;
	
	УстановитьТипЦенДоговора();
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЦенОчистка(Элемент, СтандартнаяОбработка)
	УстановитьТипЦенДоговора();
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	Если Объект.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета  Тогда
	//Зачистка флага "Расчеты в условных единицах" и "Реализация на экспорт" для валюты, совпадающей с валютой рег. учета
		Если Объект.РасчетыВУсловныхЕдиницах тогда
			Объект.РасчетыВУсловныхЕдиницах = Ложь;
		КонецЕсли;
	КонецЕсли;
	УстановитьДоступность();
КонецПроцедуры
