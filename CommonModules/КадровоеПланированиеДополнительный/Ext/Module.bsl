﻿////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура ДобавитьКнопкуВПодменю(Подменю, Имя, Текст, Действие, Подсказка, Пояснение)
	
	НоваяКнопка = Подменю.Кнопки.Добавить(Имя, ТипКнопкиКоманднойПанели.Действие, Текст, Действие);
	НоваяКнопка.Подсказка = Подсказка;
	НоваяКнопка.Пояснение = Пояснение;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

Функция ОбновитьРабочиеМестаУпр(Подразделение, Период = Неопределено)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Подразделение",	Подразделение);
	
	Если Период <> Неопределено Тогда
		Запрос.УстановитьПараметр("ДатаАктуальности",	КонецДня(Период));
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадровоеПланирование.Подразделение КАК Подразделение,
		|	ВЫБОР
		|		КОГДА КадровоеПланирование.Подразделение = &Подразделение
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьИерархия,
		|	КадровоеПланирование.Должность,
		|	КадровоеПланирование.Должность.Наименование КАК ДолжностьНаименование,
		|	КадровоеПланирование.ЗанятоСтавок,
		|	КадровоеПланирование.КоличествоСтавок,
		|	КадровоеПланирование.КоличествоСтавок - КадровоеПланирование.ЗанятоСтавок КАК Вакантно
		|ИЗ
		|	(ВЫБРАТЬ
		|		КадровоеПланирование.Подразделение КАК Подразделение,
		|		КадровоеПланирование.Должность КАК Должность,
		|		МАКСИМУМ(КадровоеПланирование.ЗанятоСтавок) КАК ЗанятоСтавок,
		|		МАКСИМУМ(КадровоеПланирование.КоличествоСтавок) КАК КоличествоСтавок
		|	ИЗ
		|		(ВЫБРАТЬ
		|			КадровыйПланСрезПоследних.Подразделение КАК Подразделение,
		|			КадровыйПланСрезПоследних.Должность КАК Должность,
		|			СУММА(0) КАК ЗанятоСтавок,
		|			СУММА(КадровыйПланСрезПоследних.Количество) КАК КоличествоСтавок
		|		ИЗ
		|			РегистрСведений.КадровыйПлан.СрезПоследних(
		|					&ДатаАктуальности,
		|					ПодразделениеОрганизации = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|						И Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|						И Подразделение <> ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)) КАК КадровыйПланСрезПоследних
		|		
		|		СГРУППИРОВАТЬ ПО
		|			КадровыйПланСрезПоследних.Подразделение,
		|			КадровыйПланСрезПоследних.Должность
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ЗанятыеРабочиеМестаОстатки.Подразделение,
		|			ЗанятыеРабочиеМестаОстатки.Должность.Должность,
		|			СУММА(ЗанятыеРабочиеМестаОстатки.КоличествоОстаток),
		|			СУММА(0)
		|		ИЗ
		|			РегистрНакопления.ЗанятыеРабочиеМеста.Остатки(
		|					&ДатаАктуальности,
		|					Должность.Должность <> ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|						И Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|																	) КАК ЗанятыеРабочиеМестаОстатки
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ЗанятыеРабочиеМестаОстатки.Подразделение,
		|			ЗанятыеРабочиеМестаОстатки.Должность.Должность
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			Вакансии.Подразделение,
		|			Вакансии.Должность,
		|			СУММА(0),
		|			СУММА(1)
		|		ИЗ
		|			Справочник.Вакансии КАК Вакансии
		|		ГДЕ
		|			(НЕ Вакансии.Закрыта)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|			И Вакансии.Подразделение В ИЕРАРХИИ(&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|			И Вакансии.Подразделение ССЫЛКА Справочник.Подразделения
		|		
		|		СГРУППИРОВАТЬ ПО
		|			Вакансии.Подразделение,
		|			Вакансии.Должность) КАК КадровоеПланирование
		|	
		|	СГРУППИРОВАТЬ ПО
		|		КадровоеПланирование.Подразделение,
		|		КадровоеПланирование.Должность) КАК КадровоеПланирование
		|ГДЕ
		|	НЕ (КадровоеПланирование.КоличествоСтавок = 0
		|	И КадровоеПланирование.ЗанятоСтавок = 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностьНаименование,
		|	Подразделение ИЕРАРХИЯ";
		
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КадровыйПлан.Регистратор.Дата КАК Период,
		|	КадровыйПлан.Подразделение КАК Подразделение,
		|	ВЫБОР
		|		КОГДА КадровыйПлан.Подразделение = &Подразделение
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьИерархия,
		|	КадровыйПлан.Должность КАК Должность,
		|	КадровыйПлан.Должность.Наименование КАК ДолжностьНаименование,
		|	КадровыйПлан.Количество КАК КоличествоСтавок
		|ИЗ
		|	РегистрСведений.КадровыйПлан КАК КадровыйПлан
		|ГДЕ
		|	КадровыйПлан.ПодразделениеОрганизации = ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
		|	И КадровыйПлан.Подразделение <> ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И КадровыйПлан.Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Вакансии.ДатаОткрытия,
		|	Вакансии.Подразделение,
		|	ВЫБОР
		|		КОГДА Вакансии.Подразделение = &Подразделение
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	Вакансии.Должность,
		|	Вакансии.Должность.Наименование,
		|	1
		|ИЗ
		|	Справочник.Вакансии КАК Вакансии
		|ГДЕ
		|	Вакансии.Подразделение ССЫЛКА Справочник.Подразделения";
		Если Подразделение <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И Вакансии.Подразделение В ИЕРАРХИИ (&Подразделение)";
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + "
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДолжностьНаименование,
		|	Период";
		
	КонецЕсли;
	
	Возврат Запрос.Выполнить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы

Процедура ПриИзмененииРежимаНабораПерсонала(ЭтаФорма) Экспорт
	
	ЭлементыФормы = ЭтаФорма.ЭлементыФормы;
	
	Подразделения = ЭлементыФормы.Подразделения;
	
	РежимНабораПерсонала = ПроцедурыУправленияПерсоналомДополнительный.ПолучитьРежимНабораПерсонала();
	
	КнопкиДополнительнойПанели = ЭлементыФормы.ДополнительнаяКоманднаяПанель.Кнопки.Подменю.Кнопки;
	
	Если РежимНабораПерсонала = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		Подразделения.Данные = "ПодразделенияОрганизаций";
		КнопкиДополнительнойПанели.ПоСтруктуреЮридическихЛиц.Пометка= Истина;
		КнопкиДополнительнойПанели.ПоЦентрамОтветственности.Пометка	= Ложь;
		Подразделения.Значение.Отбор.Владелец.Значение = ЭтаФорма.Организация;
		ЭлементыФормы.ПанельОрганизация.Свертка	= РежимСверткиЭлементаУправления.Нет;
	Иначе
		Подразделения.Данные = "Подразделения";
		КнопкиДополнительнойПанели.ПоСтруктуреЮридическихЛиц.Пометка= Ложь;
		КнопкиДополнительнойПанели.ПоЦентрамОтветственности.Пометка	= Истина;
		ЭлементыФормы.ПанельОрганизация.Свертка	= РежимСверткиЭлементаУправления.Верх;
	КонецЕсли;
	
	Подразделения.Дерево 	= Истина;
	Подразделения.Шапка 	= Ложь;
	Подразделения.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	
	КолонкаНаименование = Подразделения.Колонки.Добавить("Наименование");
	КолонкаНаименование.ОтображатьИерархию = Истина;
	КолонкаНаименование.Данные = "Наименование";
	
	Если ЭлементыФормы.ВстроеннаяСправка.Документ.readyState = "complete" Тогда 
		ЭтаФорма.ОбновитьСправкуФормы();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьДанныеПодразделения(ЭтотОбъект, ЭтаФорма) Экспорт
	
	РабочиеМеста = ЭтотОбъект.РабочиеМеста;
	ИзмененияКадровогоПлана = ЭтаФорма.ИзмененияКадровогоПлана;
	ЭлементыФормы = ЭтаФорма.ЭлементыФормы;
	
	РабочиеМеста.Очистить();
	
	Если Не ЭтаФорма.ЕстьДоступУпр Тогда
		Возврат;
	КонецЕсли;
	
	ИзмененияКадровогоПлана.Отбор.ДокументыИзмененияКадровогоПланаПоПодразделению.Использование	= Истина;
	ИзмененияКадровогоПлана.Отбор.Ссылка.Использование											= Ложь;
	
	ДанныеСтроки = ЭлементыФормы.Подразделения.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		ИзмененияКадровогоПлана.Отбор.ДокументыИзмененияКадровогоПланаПоПодразделению.Значение	= Справочники.Подразделения.ПустаяСсылка();
		РабочиеМеста.Загрузить(ОбновитьРабочиеМестаУпр(Неопределено, ?(ЭтаФорма.РежимПериода, Неопределено, ЭтаФорма.ДатаСреза)).Выгрузить());
		ЭлементыФормы.РабочиеМеста.Колонки.Подразделение.Видимость	= ЭтаФорма.РабочиеМеста.Итог("ЕстьИерархия") > 0;
		Возврат;
	КонецЕсли;
	
	РабочиеМеста.Загрузить(ОбновитьРабочиеМестаУпр(ДанныеСтроки.Ссылка, ?(ЭтаФорма.РежимПериода, Неопределено, ЭтаФорма.ДатаСреза)).Выгрузить());
	ЭлементыФормы.РабочиеМеста.Колонки.Подразделение.Видимость	= РабочиеМеста.Итог("ЕстьИерархия") > 0;
	
	ИзмененияКадровогоПлана.Отбор.ДокументыИзмененияКадровогоПланаПоПодразделению.Значение	= ДанныеСтроки.Ссылка;
	
КонецПроцедуры

Процедура ЗаполнитьДополнительноеМеню(ЭтаФорма, ДополнительныеДействия) Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	ДополнительнаяПанель = ЭтаФорма.ЭлементыФормы.ДополнительнаяКоманднаяПанель;
	ДополнительнаяПанель.Видимость = ИспользоватьУправленческийУчетЗарплаты;
	
	Подменю = ДополнительнаяПанель.Кнопки.Добавить("Подменю", 	ТипКнопкиКоманднойПанели.Подменю, "Режим кадрового планирования");
	
	ДобавитьКнопкуВПодменю(Подменю, "ПоСтруктуреЮридическихЛиц", "По структуре юридических лиц", ДополнительныеДействия, "Изменить режим планирования", "Изменить режим планирования");
	ДобавитьКнопкуВПодменю(Подменю, "ПоЦентрамОтветственности", "По центрам ответственности", ДополнительныеДействия, "Изменить режим планирования", "Изменить режим планирования");
	
КонецПроцедуры

#КонецЕсли
