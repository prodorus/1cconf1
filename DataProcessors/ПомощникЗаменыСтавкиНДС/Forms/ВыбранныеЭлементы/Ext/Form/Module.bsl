////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Создать структуру свойств динамического списка для вызова УстановитьСвойстваДинамическогоСписка().
//
// Возвращаемое значение:
//  Структура - любое поле может иметь значение неопределено, если оно не устанавливается:
//     * ТекстЗапроса - Строка - новый текст запроса.
//     * ОсновнаяТаблица - Строка - имя основной таблицы.
//     * ДинамическоеСчитываниеДанных - Булево - признак использования динамического считывания.
//
&НаСервере
Функция СтруктураСвойствДинамическогоСписка() Экспорт
	
	Возврат Новый Структура("ТекстЗапроса, ОсновнаяТаблица, ДинамическоеСчитываниеДанных");
	
КонецФункции

// Установить текст запроса, основную таблицу или динамическое считывание в динамическом списке.
// Устанавливать эти свойства следует за один вызов этой процедуры, чтобы не снижалась производительность.
//
// Параметры:
//  Список - ТаблицаФормы - элемент формы динамического списка, для которого устанавливаются свойства.
//  СтруктураПараметров - Структура - см. СтруктураСвойствДинамическогоСписка().
//
&НаСервере
Процедура УстановитьСвойстваДинамическогоСписка(Список, СтруктураПараметров) Экспорт
	
	Форма = Список.Родитель;
	ТипУправляемаяФорма = Тип("УправляемаяФорма");
	
	Пока ТипЗнч(Форма) <> ТипУправляемаяФорма Цикл
		Форма = Форма.Родитель;
	КонецЦикла;
	
	ДинамическийСписок = Форма[Список.ПутьКДанным];
	ТекстЗапроса = СтруктураПараметров.ТекстЗапроса;
	
	Если Не ПустаяСтрока(ТекстЗапроса) Тогда
		ДинамическийСписок.ТекстЗапроса = ТекстЗапроса;
	КонецЕсли;
	
	ОсновнаяТаблица = СтруктураПараметров.ОсновнаяТаблица;
	
	Если Не ПустаяСтрока(ОсновнаяТаблица) Тогда
		ДинамическийСписок.ОсновнаяТаблица = ОсновнаяТаблица;
	КонецЕсли;
	
	ДинамическоеСчитываниеДанных = СтруктураПараметров.ДинамическоеСчитываниеДанных;
	
	Если ТипЗнч(ДинамическоеСчитываниеДанных) = Тип("Булево") Тогда
		ДинамическийСписок.ДинамическоеСчитываниеДанных = ДинамическоеСчитываниеДанных;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыбранныеТипы = Параметры.ВыбранныеТипы;
	
	ОбъектОбработка = РеквизитФормыВЗначение("Объект");
	ТекстЗапроса = ОбъектОбработка.ТекстЗапроса(ВыбранныеТипы);
	
	ИнициализироватьКомпоновщикНастроек();
	КомпоновщикНастроек.ЗагрузитьНастройки(Параметры.Настройки);
	
	СвойстваСписка = СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список);
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	ОбновитьСписокВыбранныхНаСервере();
	
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ КОМПОНОВЩИК НАСТРОЕК НАСТРОЙКИ ОТБОР

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ИнициализироватьОбновлениеСпискаВыбранных();
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПослеУдаления(Элемент)
	ИнициализироватьОбновлениеСпискаВыбранных();
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ОтключитьОбработчикОжидания("ОбновитьСписокВыбранных");
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ КОМПОНОВЩИК НАСТРОЕК НАСТРОЙКИ ОТБОР
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ СПИСОК

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначениеЕГАИС(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ ФОРМЫ СПИСОК
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ 

&НаКлиенте
Процедура ОК(Команда)
	Результат = Новый Структура("Настройки, ВыбранныеТипы", КомпоновщикНастроек.Настройки, ВыбранныеТипы);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЭлемент(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПоказатьЗначениеЕГАИС(, ТекущиеДанные.Ссылка);
	
КонецПроцедуры

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	Если Не ПустаяСтрока(Параметры.ВыбранныеТипы) Тогда
		СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(ТекстЗапроса);
		АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СхемаКомпоновкиДанных(ТекстЗапроса)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.СхемаКомпоновкиДанных(ТекстЗапроса);
КонецФункции

&НаСервере
Процедура ОбновитьСписокВыбранныхНаСервере()
	
	Список.Отбор.Элементы.Очистить();
	
	ГруппаОтбор = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбор.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИЛИ;

	Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	Отбор.Использование = Истина;
	Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	Отбор.ПравоеЗначение = ВыбранныеОбъекты().Строки.ВыгрузитьКолонку("Ссылка");
	
	КоличествоВыбранных = ВыбранныеОбъекты().Строки.Количество();
	Элементы.ГруппаВыбранныеОбъекты.Заголовок = ПодставитьПараметрыВСтроку(НСтр("ru = 'Выбранные элементы (%1)'"),
		?(КоличествоВыбранных > 1000, НСтр("ru = '> 1000'"), КоличествоВыбранных));
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьОбновлениеСпискаВыбранных()
	ОтключитьОбработчикОжидания("ОбновитьСписокВыбранных");
	Если Элементы.ГруппаВыбранныеОбъекты.Видимость Тогда
		ПодключитьОбработчикОжидания("ОбновитьСписокВыбранных", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокВыбранных()
	ОбновитьСписокВыбранныхНаСервере();
КонецПроцедуры

&НаСервере
Функция ВыбранныеОбъекты()
	
	Результат = Новый ДеревоЗначений;
	
	Если Не ПустаяСтрока(ВыбранныеТипы) Тогда
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		ТекстЗапроса = ОбработкаОбъект.ТекстЗапроса(ВыбранныеТипы, Истина);
		СхемаКомпоновкиДанных = СхемаКомпоновкиДанных(ТекстЗапроса);
		
		КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
		АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
		КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
		
		Результат = Новый ДеревоЗначений;
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		Попытка
			МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
				КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		Исключение
			Возврат Результат;
		КонецПопытки;
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);

		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(Результат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено)
	
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
	СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
	
	Возврат СтрокаПодстановки;
КонецФункции

// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
////////////////////////////////////////////////////////////////////////////////
