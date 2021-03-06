Функция ПолучитьЗначениеПоУмолчанию(Контрагент, Организация = Неопределено, ТекущееЗначение = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Возврат ТекущееЗначение;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КонтрактыИсполнителей КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И (Т.Владелец = &Контрагент
	|		ИЛИ &Контрагент = Неопределено)
	|	И (Т.Организация = &Организация
	|		ИЛИ &Организация = Неопределено)";
	
	Запрос.УстановитьПараметр("Контрагент", ?(ЗначениеЗаполнено(Контрагент), Контрагент, Неопределено));
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		ВозвращаемоеЗначение = Выборка.Ссылка;
	Иначе
		ВозвращаемоеЗначение = Справочники.КонтрактыИсполнителей.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ЗаполнитьПодтверждающиеДокументы(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТипыПлатежей.ВидДокумента,
	|	NULL КАК ПодтверждающийДокумент,
	|	NULL КАК Номер,
	|	NULL КАК Дата,
	|	NULL КАК Сумма
	|ИЗ
	|	Справочник.ТипыПлатежейФЗ275.ПодтверждающиеДокументы КАК ТипыПлатежей
	|ГДЕ
	|	ТипыПлатежей.Ссылка = &ТипПлатежа";
	
	Запрос.УстановитьПараметр("ТипПлатежа", Объект.ТипПлатежаФЗ275);
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Объект.ПодтверждающиеДокументы.Очистить();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока = Объект.ПодтверждающиеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		Если Объект.КонтрактСУчастникомГОЗ Тогда
			НоваяСтрока.ГосударственныйКонтракт = Объект.ГосударственныйКонтракт;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСпособОпределенияПоставщика() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КонтрактыИсполнителей.Ссылка,
	|	КонтрактыИсполнителей.ГосударственныйКонтракт.СпособОпределенияПоставщика КАК СпособОпределенияПоставщика
	|ИЗ
	|	Справочник.КонтрактыИсполнителей КАК КонтрактыИсполнителей
	|ГДЕ
	|	КонтрактыИсполнителей.СпособОпределенияПоставщика.Ссылка ЕСТЬ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.СпособОпределенияПоставщика = Выборка.СпособОпределенияПоставщика;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьСпособРаспределения() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтрактыИсполнителей.Ссылка,
		|	КонтрактыИсполнителей.КонтрактСУчастникомГОЗ,
		|	КонтрактыИсполнителей.ПлатежиПо275ФЗ
		|ИЗ
		|	Справочник.КонтрактыИсполнителей КАК КонтрактыИсполнителей
		|ГДЕ
		|	КонтрактыИсполнителей.РаспределениеОплатПоБанковскимСчетам = &ПустоеРаспределение";
	
	Запрос.УстановитьПараметр("ПустоеРаспределение", Перечисления.РаспределениеЗаявокПоБанковскимСчетам.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СправочникОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Если ВыборкаДетальныеЗаписи.КонтрактСУчастникомГОЗ Тогда
			СправочникОбъект.РаспределениеОплатПоБанковскимСчетам = Перечисления.РаспределениеЗаявокПоБанковскимСчетам.ПоУказаннымКонтрактам;
		Иначе
			СправочникОбъект.РаспределениеОплатПоБанковскимСчетам = Перечисления.РаспределениеЗаявокПоБанковскимСчетам.ПоВсемКонтрактам;
		КонецЕсли;
		
		ИтогоПроцентОплаты = 0;
		ВсегоКонтрактов = СправочникОбъект.НомераКонтрактов.Количество();
		Для Каждого Контракт из СправочникОбъект.НомераКонтрактов Цикл
			
			Если СправочникОбъект.НомераКонтрактов.Индекс(Контракт) = ВсегоКонтрактов - 1 Тогда
				Контракт.Процент = 100 - ИтогоПроцентОплаты;
			Иначе
				Контракт.Процент = 100 / ВсегоКонтрактов;
				ИтогоПроцентОплаты = ИтогоПроцентОплаты + Контракт.Процент;
			КонецЕсли;
			
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьГосКонтрактВПодтверждающихДокументах() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КонтрактыИсполнителейПодтверждающиеДокументы.Ссылка
	               |ИЗ
	               |	Справочник.КонтрактыИсполнителей.ПодтверждающиеДокументы КАК КонтрактыИсполнителейПодтверждающиеДокументы
	               |ГДЕ
	               |	КонтрактыИсполнителейПодтверждающиеДокументы.ГосударственныйКонтракт = ЗНАЧЕНИЕ(Справочник.ГосударственныеКонтракты.ПустаяСсылка)
	               |	И КонтрактыИсполнителейПодтверждающиеДокументы.Ссылка.КонтрактСУчастникомГОЗ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	КонтрактыИсполнителейПодтверждающиеДокументы.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		
		Для Каждого СтрокаДокумента Из Объект.ПодтверждающиеДокументы Цикл
			Если Не ЗначениеЗаполнено(СтрокаДокумента.ГосударственныйКонтракт) Тогда
				СтрокаДокумента.ГосударственныйКонтракт = Объект.ГосударственныйКонтракт;
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
	КонецЦикла;
КонецПроцедуры
