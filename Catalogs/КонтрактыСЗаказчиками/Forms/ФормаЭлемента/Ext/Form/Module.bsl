
&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиКалькуляции.Ссылка
		|ИЗ
		|	Справочник.СтатьиКалькуляции КАК СтатьиКалькуляции
		|ГДЕ
		|	СтатьиКалькуляции.Предопределенный";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Объект.КалькуляцияЗатрат.Очистить();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока = Объект.КалькуляцияЗатрат.Добавить();
		НоваяСтрока.СтатьяКалькуляции = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбъектПодстановки") Тогда
		ЗначениеВРеквизитФормы(Параметры.ОбъектПодстановки, "Объект");
	КонецЕсли;
	
	КонтрактСУчастникомГОЗ = Объект.КонтрактСУчастникомГОЗ;
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	
	КоличествоДопСоглашенийНаМоментОткрытия = КоличествоДопСоглашений();

	УстановитьУсловноеОформление();
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписанКонтрактСЗаказчиком", ВладелецФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ГосударственныйКонтрактПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчет();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьБанковскийСчет()
	
	Если Не КонтрактСУчастникомГОЗ Тогда
		Объект.БанковскийСчет = Объект.Владелец.ОсновнойБанковскийСчет;
	Иначе
		Объект.БанковскийСчет = Справочники.БанковскиеСчета.ПолучитьБанковскийСчетГосКонтрактаПоУмолчанию(
			Объект.Владелец, Объект.ГосударственныйКонтракт);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.КонтрактСУчастникомГОЗ = Истина;
	
	КоличествоДопСоглашений = КоличествоДопСоглашений();
	Если КоличествоДопСоглашенийНаМоментОткрытия < КоличествоДопСоглашений Тогда
		ТекущийОбъект.ДатаДобавленияПоследнегоДопСоглашения = ТекущаяУниверсальнаяДата();
		
		КоличествоДопСоглашенийНаМоментОткрытия = КоличествоДопСоглашений;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	УстановитьВидимость(ЭтаФорма);
	
	ОбщегоНазначения275Сервер.УстановитьПараметрыВыбораБанковскогоСчета(Элементы.БанковскийСчет, КонтрактСУчастникомГОЗ);
	
КонецПроцедуры

&НаКлиенте
Процедура СметаЧастичноИзрасходованаПриИзменении(Элемент)
	УстановитьВидимость(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Элементы.СтраницаКалькуляция.Видимость            = Форма.КонтрактСУчастникомГОЗ;
	Элементы.ГосударственныйКонтракт.Видимость        = Форма.КонтрактСУчастникомГОЗ;
	Элементы.КалькуляцияЗатратИзрасходовано.Видимость = Объект.СметаЧастичноИзрасходована;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначения275КлиентСервер.ПроверитьИспользованиеПодсистемы(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ДоговорОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ДоговорОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	Отказ = Ложь;
	ВидДоговораСПокупателем = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем");
	ОбщегоНазначения275КлиентСервер.ПроверитьДоговор(Объект.Ссылка, ВыбранноеЗначение, ВидДоговораСПокупателем, "заказчиком", Отказ);
	СтандартнаяОбработка = Не Отказ;
	
	ОбъектБД = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект.КонтрактыСЗаказчиками"));
	Если Не Отказ И ОбъектБД.ЭтоНовый() Тогда
		ОбъектБД.Заполнить(ВыбранноеЗначение);
		ЗначениеВДанныеФормы(ОбъектБД, Объект);
	КонецЕсли;
КонецПроцедуры

&НаСервере 
Функция КоличествоДопСоглашений()
	Отбор = Новый Структура("ВидДокумента", Справочники.ВидыДокументов.ДополнительноеСоглашение);
	НайденныеСтроки = Объект.ПодтверждающиеДокументы.НайтиСтроки(Отбор);
	
	Возврат НайденныеСтроки.Количество();
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.КалькуляцияЗатрат.Количество() <> 0
		И Объект.СуммаКонтракта <> Объект.КалькуляцияЗатрат.Итог("Сумма") + Объект.СуммаПрибыли Тогда
		
		ТекстВопроса = НСтр("ru='Отличается сумма контракта от суммы статей калькуляции.
			|Установить сумму контракта равной сумме статей калькуляции?'");

		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, 60, 
			КодВозвратаДиалога.Да, , КодВозвратаДиалога.Отмена);
			
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			Объект.СуммаКонтракта = Объект.КалькуляцияЗатрат.Итог("Сумма") + Объект.СуммаПрибыли;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыВидДокументаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ПодтверждающиеДокументы.ТекущиеДанные;
	
	Если ТекущиеДанные.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументов.Контракт") Тогда
		ТекущиеДанные.Номер = Объект.Номер;
		ТекущиеДанные.Дата = Объект.Дата;
		ТекущиеДанные.Сумма = Объект.СуммаКонтракта;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБанковскийСчет(Команда)
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан исполнитель'"), , , , Отказ);
	КонецЕсли;
	
	Если Объект.КонтрактСУчастникомГОЗ И 
		Не ЗначениеЗаполнено(Объект.ГосударственныйКонтракт) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан государственный контракт'"), , , , Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Владелец", Объект.Владелец);
	Если Объект.КонтрактСУчастникомГОЗ Тогда
		ПараметрыЗаполнения.Вставить("ГосударственныйКонтракт", Объект.ГосударственныйКонтракт);
		ПараметрыЗаполнения.Вставить("ОтдельныйСчетГОЗ", Истина);
	КонецЕсли;
	ПараметрыСоздания.Вставить("ЗначенияЗаполнения", ПараметрыЗаполнения);
	
	ОткрытьФорму("Справочник.БанковскиеСчета.Форма.ФормаЭлемента", 
			ПараметрыСоздания, Элементы.БанковскийСчет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Текст незаполненного файла - "<Файл указывается в заявке>"

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыПодтверждающийДокумент.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.ПодтверждающийДокумент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru= '<Указывается в заявке>'"));
	
	// Текст номера и даты для документов, подтверждающих исполнение контракта

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыНомер.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыДата.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.ВидДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	
	ВидыПодтверждающиеИсполнениеКонтракта = Новый СписокЗначений;
	ВидыПодтверждающиеИсполнениеКонтракта.ЗагрузитьЗначения(Справочники.ВидыДокументов.ВидыПодтверждающиеИсполнениеКонтракта());
	ОтборЭлемента.ПравоеЗначение = ВидыПодтверждающиеИсполнениеКонтракта;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru= '<Указывается в заявке>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПаспортКонтракта(Команда)
	ПФ = Новый Структура("Ссылка", Объект.Ссылка);
	ОткрытьФорму("Отчет.ПаспортКонтракта.Форма.Форма", ПФ, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетСведенияОКооперацииПриложение1(Команда)
	ПФ = Новый Структура("Ссылка, Приложение1, Приложения2и3", Объект.Ссылка, Истина, Ложь);
	ОткрытьФорму("Отчет.СведенияОКооперации.Форма.Форма", ПФ, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтчетСведенияОКооперацииПриложения2и3(Команда)
	ПФ = Новый Структура("Ссылка, Приложение1, Приложения2и3", Объект.Ссылка, Ложь, Истина);
	ОткрытьФорму("Отчет.СведенияОКооперации.Форма.Форма", ПФ, ЭтаФорма);
КонецПроцедуры

