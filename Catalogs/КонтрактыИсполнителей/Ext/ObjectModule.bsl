#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не КонтрактСУчастникомГОЗ Тогда
		НомераКонтрактов.Очистить();
		ГосударственныйКонтракт = Неопределено;
	КонецЕсли;
	
	ОбщегоНазначения275КлиентСервер.ПроверитьДоговор(Ссылка, Договор, Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком, "исполнителем", Отказ);
	
	Если Не ЭтотОбъект.ДополнительныеСвойства.Свойство("НеПроверятьОбщиеРеквизиты") Тогда
		Если ЗначениеЗаполнено(Договор) Тогда
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Владелец,Организация");
			
			// Контракт с исполнителем (договор с поставщиком)
			Если Реквизиты.Организация <> Организация Тогда
				ТекстОшибки = СтрШаблон("%1 в договоре не совпадает с %2 в контракте", "Организация", "заказчиком");
				ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ);
			КонецЕсли;
			Если Реквизиты.Владелец <> Владелец Тогда
				ТекстОшибки = СтрШаблон("%1 в договоре не совпадает с %2 в контракте", "Контрагент", "исполнителем");
				ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если КонтрактСУчастникомГОЗ Тогда
		Если Не НомераКонтрактов.Количество() Тогда
			ОбщегоНазначения.СообщитьОбОшибке(НСтр("ru = 'Не указаны сведения о кооперации'"), Отказ);
		КонецЕсли;
		ПроверяемыеРеквизиты.Добавить("ГосударственныйКонтракт");
	КонецЕсли;
	
	Если Не ПлатежиПо275ФЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БанковскийСчетКонтрагента");
		МассивНепроверяемыхРеквизитов.Добавить("ТипПлатежаФЗ275");
	КонецЕсли;
	
	Если РаспределениеОплатПоБанковскимСчетам = Перечисления.РаспределениеЗаявокПоБанковскимСчетам.ПоУказаннымКонтрактам Тогда
		Если НомераКонтрактов.Итог("Процент") <> 100 Тогда
			ОбщегоНазначения.СообщитьОбОшибке(
				НСтр("ru = 'Распределение оплаты по контрактам должно быть 100%'"), Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если СуммаКонтракта < Справочники.ЭтапыКонтрактов.СуммаЭтаповКонтракта(Ссылка) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(
			НСтр("ru = 'Сумма графика платежей превышает сумму контракта'"), Отказ);
	КонецЕсли;
	
	Если ПлатежиПо275ФЗ Тогда
		Контроли275Сервер.ОбработкаПроверкиЗаполненияПодтверждающиеДокументы(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДанныеЗаполненияТип = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполненияТип = Тип("СправочникСсылка.ГосударственныеКонтракты") Тогда
		
		ОбработкаЗаполненияГосударственныеКонтракты(ДанныеЗаполнения);
		
	ИначеЕсли ДанныеЗаполненияТип = Тип("СправочникСсылка.КонтрактыСЗаказчиками") Тогда
		
		ОбработкаЗаполненияКонтрактыСЗаказчиками(ДанныеЗаполнения);
		
	ИначеЕсли ДанныеЗаполненияТип = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		
		ОбработкаЗаполненияДоговорыКонтрагентов(ДанныеЗаполнения);
		
	ИначеЕсли ДанныеЗаполненияТип = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьСправочник();
	
КонецПроцедуры

Процедура ОбработкаЗаполненияГосударственныеКонтракты(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеЗаполнения.Ссылка КАК ГосударственныйКонтракт,
	|	ИСТИНА КАК КонтрактСУчастникомГОЗ
	|ИЗ
	|	Справочник.ГосударственныеКонтракты КАК ДанныеЗаполнения
	|ГДЕ
	|	ДанныеЗаполнения.Ссылка = &ДанныеЗаполнения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

Процедура ОбработкаЗаполненияКонтрактыСЗаказчиками(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеЗаполнения.Ссылка КАК Основание,
	|	ДанныеЗаполнения.Владелец КАК Организация,
	|	ДанныеЗаполнения.Контрагент КАК Владелец,
	|	ДанныеЗаполнения.КонтрактСУчастникомГОЗ КАК КонтрактСУчастникомГОЗ,
	|	ДанныеЗаполнения.ГосударственныйКонтракт КАК ГосударственныйКонтракт,
	|	100 КАК Процент
	|ИЗ
	|	Справочник.КонтрактыСЗаказчиками КАК ДанныеЗаполнения
	|ГДЕ
	|	ДанныеЗаполнения.Ссылка = &ДанныеЗаполнения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
КонецПроцедуры

Процедура ОбработкаЗаполненияДоговорыКонтрагентов(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеЗаполнения.Ссылка КАК Договор,
	|	ИСТИНА КАК КонтрактСУчастникомГОЗ,
	|	ДанныеЗаполнения.Владелец КАК Владелец,
	|	ДанныеЗаполнения.Организация КАК Организация,
	|	ДанныеЗаполнения.Дата,
	|	ДанныеЗаполнения.Номер
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДанныеЗаполнения
	|ГДЕ
	|	ДанныеЗаполнения.Ссылка = &ДанныеЗаполнения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, , "Дата,Номер");
	Если Не ЗначениеЗаполнено(Дата) Тогда
		ЭтотОбъект.Дата = Выборка.Дата;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Номер) Тогда
		ЭтотОбъект.Номер = Выборка.Номер;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьСправочник()
	
	Если Ответственный.Пустая() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если Состояние.Пустая() Тогда
		Состояние = Перечисления.СостоянияКонтрактов.Готовится;
	КонецЕсли;
	
	Если Организация.Пустая() Тогда
		Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(Ответственный, "ОсновнаяОрганизация");
	КонецЕсли;
	Если Владелец.Пустая() Тогда
		Владелец = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(Ответственный, "ОсновнойПоставщик");
	КонецЕсли;
	
	Если ПодтверждающиеДокументы.Количество() = 0 Тогда
		Если ТипПлатежаФЗ275.Пустая() Тогда
			ВидыДокументов = Справочники.ТипыПлатежейФЗ275.ПодтверждающиеВидыДокументов(ОбщегоНазначения275Сервер.ТипПлатежа275ФЗДляКонтрактаИсполнителяПоУмолчанию());
		Иначе
			ВидыДокументов = Справочники.ТипыПлатежейФЗ275.ПодтверждающиеВидыДокументов(ТипПлатежаФЗ275);
		КонецЕсли;
		Для Каждого ВидДокумента Из ВидыДокументов Цикл 
			НоваяСтрока = ПодтверждающиеДокументы.Добавить();
			НоваяСтрока.ВидДокумента = ВидДокумента;
			Если КонтрактСУчастникомГОЗ Тогда
				НоваяСтрока.ГосударственныйКонтракт = ГосударственныйКонтракт;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли