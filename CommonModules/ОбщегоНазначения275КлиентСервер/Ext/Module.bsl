
Процедура ПроверитьДоговор(Контракт, Договор, ВидДоговора, ВидКонтракта, Отказ) Экспорт
	
	Если Не ЗначениеЗаполнено(Договор) Тогда
		Возврат;
	КонецЕсли;
	// Проверка единственности связи контракт-договор
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контракты.Ссылка,
	|	Контракты.Представление
	|ИЗ
	|	Справочник.КонтрактыСЗаказчиками КАК Контракты
	|ГДЕ
	|	Контракты.Ссылка <> &Ссылка
	|	И Контракты.Договор = &Договор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Контракты.Ссылка,
	|	Контракты.Представление
	|ИЗ
	|	Справочник.КонтрактыИсполнителей КАК Контракты
	|ГДЕ
	|	Контракты.Ссылка <> &Ссылка
	|	И Контракты.Договор = &Договор";
	Запрос.УстановитьПараметр("Ссылка", Контракт);
	Запрос.УстановитьПараметр("Договор", Договор);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТекстОшибки = СтрШаблон("Выбранный договор уже используется в контракте ""%1""", Выборка.Представление);
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ);
	КонецЕсли;

	// Поверка корректности реквизитов
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "ВидДоговора,ВалютаВзаиморасчетов,ПометкаУдаления,РасчетыВУсловныхЕдиницах");
	
	Если Реквизиты.ВидДоговора <> ВидДоговора Тогда
		ТекстОшибки = СтрШаблон("В контракте с %1 можно использовать только договор вида %2", ВидКонтракта, Строка(ВидДоговора));
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ);
	КонецЕсли;

	Если Реквизиты.ВалютаВзаиморасчетов <> глЗначениеПеременной("ВалютаРегламентированногоУчета") И 
		Не Реквизиты.РасчетыВУсловныхединицах Тогда
		ТекстОшибки = "Можно использовать только договоры в валюте регламентированного учета или с расчетами в условных единицах";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ);
	КонецЕсли;
	
	Если Реквизиты.ПометкаУдаления Тогда
		ТекстОшибки = "Нельзя использовать договоры, помеченные на удаление";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ);
	КонецЕсли;

КонецПроцедуры

Функция НайтиПодчиненныйКонтракт(Договор) Экспорт
	
	Результат = Неопределено;
	
	Если ЗначениеЗаполнено(Договор) Тогда
		ГдеИскать = "";
		Если Договор.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем") Тогда
			ГдеИскать = "КонтрактыСЗаказчиками";
		ИначеЕсли Договор.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") Тогда
			ГдеИскать = "КонтрактыИсполнителей";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ГдеИскать) Тогда
			Запрос = Новый Запрос();
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	Контракты.Ссылка,
			|	Контракты.Представление
			|ИЗ
			|	Справочник."+ГдеИскать+" КАК Контракты
			|ГДЕ
			|	Контракты.Договор = &Договор
			|	И Не Контракты.ПометкаУдаления
			|";      
			Запрос.УстановитьПараметр("Договор", Договор);
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				Результат = Выборка.Ссылка;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации = Неопределено) Экспорт
	
	Если ВидОперации = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Для работы с платежами по государственным контрактам необходимо в форме ""Настройка параметров учета""
		|на закладке ""Государственные контракты"" включить использование данной возможности.'");
	Иначе
		ТекстСообщения = НСтр("ru='Операция не может быть выполнена'");
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ПроверитьИспользованиеПодсистемы(Отказ) Экспорт
	Если Не глЗначениеПеременной("ВестиУчетПлатежейПоГосконтрактам") Тогда
		ТекстСообщения = ОбщегоНазначения275КлиентСервер.ТекстСообщенияОНеобходимостиНастройкиСистемы();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ПоказатьСтруктуруПодчиненности(ПараметрКоманды) Экспорт
	
	// Здесь должен быть код из модуля общей команды "СтруктураПодчиненности"
	#Если Клиент Тогда
	Если ЗначениеЗаполнено(ПараметрКоманды) Тогда

		ОткрытьФорму("ОбщаяФорма.СтруктураПодчиненности",Новый Структура("ОбъектОтбора", ПараметрКоманды));

	КонецЕсли;
	#КонецЕсли		

КонецПроцедуры

Функция ПлатежПоФЗ275(Документ) Экспорт
	Результат = Ложь;
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеСредств") Тогда
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ПлатежПоФЗ275");
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументОбъект.ЗаявкаНаРасходованиеСредств") Тогда
		Результат = Документ.ПлатежПоФЗ275;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") 
		ИЛИ ТипЗнч(Документ) = Тип("ДокументОбъект.ПлатежноеПоручениеИсходящее") Тогда
		Если Документ.РасшифровкаПлатежа.Количество() > 0 Тогда
			Заявка = Документ.РасшифровкаПлатежа[0].ДокументПланированияПлатежа;
			Если ЗначениеЗаполнено(Заявка) Тогда
				Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заявка, "ПлатежПоФЗ275");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ТипПлатежаФЗ275(Документ) Экспорт
	Результат = Справочники.ТипыПлатежейФЗ275.ПустаяСсылка();
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаявкаНаРасходованиеСредств") Тогда
		Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "ТипПлатежаФЗ275");
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументОбъект.ЗаявкаНаРасходованиеСредств") Тогда
		Результат = Документ.ТипПлатежаФЗ275;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") 
		ИЛИ ТипЗнч(Документ) = Тип("ДокументОбъект.ПлатежноеПоручениеИсходящее") Тогда
		Если Документ.РасшифровкаПлатежа.Количество() > 0 Тогда
			Заявка = Документ.РасшифровкаПлатежа[0].ДокументПланированияПлатежа;
			Если ЗначениеЗаполнено(Заявка) Тогда
				Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заявка, "ТипПлатежаФЗ275");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ЗаявкаНаРасходованиеДенежныхСредств(Ссылка) Экспорт
	Результат = Документы.ЗаявкаНаРасходованиеСредств.ПустаяСсылка();
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") Тогда
		Если Ссылка.РасшифровкаПлатежа.Количество() > 0 Тогда
			Результат = Ссылка.РасшифровкаПлатежа[0].ДокументПланированияПлатежа;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции