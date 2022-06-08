﻿#Если Клиент Тогда

// В переменной сохраняется количество выведенных строк заголовка, для возможности скрытия заголовка отчета
Перем мКоличествоВыведенныхСтрокЗаголовка;

// Структура соответствия имен и представлений построителя отчета
Перем мСтруктураСоответствияИмен;

// Список значений, имена отборов построителя отчета, которые существуют постоянно
Перем мСписокОтбора Экспорт;

// Структура, ключи которой - имена отборов Построителя, значения - параметры Построителя
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

// Процедура передает построителю отчета запрос
//
// Параметры
//  НЕТ
//
// Возвращаемое значение
//  НЕТ
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт

	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ //РАЗЛИЧНЫЕ
	|	СтадииВзаимоотношенийСПокупателями.Контрагент                 КАК Контрагент,
	|	СтадииВзаимоотношенийСПокупателями.Стадия                     КАК СтадияПокупателя,
	|	СтадииВзаимоотношенийСПокупателями.КлассПостоянногоПокупателя КАК КлассПостоянногоПокупателя,
	|	ABCКлассификацияПокупателей.ABCКлассПокупателя                КАК ABCКлассПокупателя
	|//СВОЙСТВА
	|
	|ИЗ
	|	РегистрСведений.СтадииВзаимоотношенийСПокупателями.СрезПоследних(&ДатаОтчета) КАК СтадииВзаимоотношенийСПокупателями
	|//СОЕДИНЕНИЯ
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ABCКлассификацияПокупателей.СрезПоследних(&ДатаОтчета) КАК ABCКлассификацияПокупателей
	|
	|ПО
	|	ABCКлассификацияПокупателей.Контрагент = СтадииВзаимоотношенийСПокупателями.Контрагент
	|
	|{ГДЕ
	|	СтадииВзаимоотношенийСПокупателями.Контрагент.*               КАК Контрагент,
	|	СтадииВзаимоотношенийСПокупателями.Стадия                     КАК СтадияПокупателя,
	|	СтадииВзаимоотношенийСПокупателями.КлассПостоянногоПокупателя КАК КлассПостоянногоПокупателя
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|	}
	|
	|{УПОРЯДОЧИТЬ ПО
	|	СтадииВзаимоотношенийСПокупателями.Контрагент.*               КАК Контрагент,
	|	СтадииВзаимоотношенийСПокупателями.Стадия                     КАК СтадияПокупателя,
	|	СтадииВзаимоотношенийСПокупателями.КлассПостоянногоПокупателя.Порядок КАК КлассПостоянногоПокупателя
	|	//СВОЙСТВА
	|	}
	|
	|{ИТОГИ ПО
	|	СтадииВзаимоотношенийСПокупателями.Контрагент.*               КАК Контрагент,
	|	СтадииВзаимоотношенийСПокупателями.Стадия                     КАК СтадияПокупателя,
	|	СтадииВзаимоотношенийСПокупателями.КлассПостоянногоПокупателя КАК КлассПостоянногоПокупателя
	|	//СВОЙСТВА
	|	}
	|
	|";
	
	мСтруктураСоответствияИмен.Очистить();
	мСтруктураСоответствияИмен = Новый Структура("Контрагент, , СтадияПокупателя, КлассПостоянногоПокупателя","Контрагент", "Стадия взаимоотношений с покупателем", "XYZ-класс постоянного покупателя");
	
	мСоответствиеНазначений = Новый Соответствие;

	Если ИспользоватьСвойстваИКатегории Тогда
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "СтадииВзаимоотношенийСПокупателями.Контрагент";
		НоваяСтрока.Представление = "Контрагент";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;

		ТекстПоляКатегорий = "";
		ТекстПоляСвойств = "";

		// Добавим строки запроса, необходимые для использования свойств и категорий
		УправлениеОтчетами.ДобавитьВТекстСвойстваИКатегории(ТаблицаПолей, ТекстЗапроса, мСтруктураСоответствияИмен, мСоответствиеНазначений, ПостроительОтчета.Параметры, , ТекстПоляКатегорий, ТекстПоляСвойств, , , , , , мСтруктураДляОтбораПоКатегориям);

	КонецЕсли;
	
	ПостроительОтчета.Текст = ТекстЗапроса;

	Если ИспользоватьСвойстваИКатегории Тогда
		УправлениеОтчетами.УстановитьТипыЗначенийСвойствИКатегорийДляОтбора(ПостроительОтчета, ТекстПоляКатегорий, ТекстПоляСвойств, мСоответствиеНазначений, мСтруктураСоответствияИмен);
	КонецЕсли;
	
	УправлениеОтчетами.ЗаполнитьПредставленияПолей(мСтруктураСоответствияИмен, ПостроительОтчета);
	
	Для каждого ЭлементСписка Из мСписокОтбора Цикл
		ПостроительОтчета.Отбор.Добавить(ЭлементСписка.Значение);
	КонецЦикла; 
	
КонецПроцедуры

// Процедура заполняет данными поле табличного документа отчета
//
// Параметры
//  Таб - поле табличного документа
//
// Возвращаемое значение
//  НЕТ
//
Процедура СформироватьОтчет(Таб) Экспорт

	Таб.Очистить();
	
	ПостроительОтчета.Параметры.Вставить("ДатаОтчета", ?(ДатаОтчета = '00010101000000', ТекущаяДата(), ДатаОтчета));
	
	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		Возврат;
	КонецЕсли;

	УправлениеОтчетами.ПроверитьПорядокПостроителяОтчета(ПостроительОтчета);

	ПостроительОтчета.Выполнить();
	
	Макет = ПолучитьМакет("Макет");
	
	Таб.Очистить();

	Секция = Макет.ПолучитьОбласть("ШапкаВерх");
	
	СтруктураЗначенийРегистра = ОбщегоНазначения.ПолучитьПараметрыУчетнойПолитикиУпр(?(ДатаОтчета = '00010101000000', ТекущаяДата(), ДатаОтчета));
	Если НЕ ЗначениеЗаполнено(СтруктураЗначенийРегистра)  Тогда
		Возврат;
	КонецЕсли; 
	
	ПараметрРаспределения = Неопределено;
	СтруктураЗначенийРегистра.Свойство("ПараметрРаспределенияПокупателейПоСтадиямВзаимоотношений", ПараметрРаспределения);
	Если ПараметрРаспределения = Неопределено ИЛИ (ТипЗнч(ПараметрРаспределения) = Тип("ПеречислениеСсылка.ПараметрыРаспределенияПокупателейПоСтадиямВзаимоотношений") И ПараметрРаспределения.Пустая()) Тогда
		ПредставлениеПараметра = "Параметр распределения не задан в учетной политике.";
	Иначе
		ПредставлениеПараметра = "Параметр распределения: " + ПараметрРаспределения + ", в валюте упр.учета (" + СокрЛП(глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование) + ")";
	КонецЕсли; 
	Секция.Параметры.ПредставлениеПараметра = ПредставлениеПараметра;
	Таб.Вывести(Секция);

	Секция = Макет.ПолучитьОбласть("ШапкаИнтервал");
	Секция.Параметры.СтрокаИнтервал = "Период: на " + ?(ДатаОтчета = Дата("00010101000000"), ("текущее время " + Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy")),Формат(ДатаОтчета, "ДФ=dd.MM.yyyy"));
	Таб.Вывести(Секция);
	мКоличествоВыведенныхСтрокЗаголовка = 4;
	
	СтрокаГруппировок = УправлениеОтчетами.СформироватьСтрокуИзмерений(ПостроительОтчета.ИзмеренияСтроки);
	Если НЕ ПустаяСтрока(СтрокаГруппировок) Тогда
		СтрокаГруппировок = "Группировки строк: " + СтрокаГруппировок;
		Секция = Макет.ПолучитьОбласть("ШапкаГруппировки");
		Секция.Параметры.СтрокаГруппировок = СтрокаГруппировок;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 

	СтрокаОтборов = УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	Если НЕ ПустаяСтрока(СтрокаОтборов) Тогда
		СтрокаОтборов = "Отбор: " + СтрокаОтборов;
		Секция = Макет.ПолучитьОбласть("ШапкаОтбор");
		Секция.Параметры.СтрокаОтборов = СтрокаОтборов;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 
	
	СтрокаПорядка = УправлениеОтчетами.СформироватьСтрокуПорядка(ПостроительОтчета.Порядок);
	Если НЕ ПустаяСтрока(СтрокаПорядка) Тогда
		СтрокаПорядка = "Сортировка: " + СтрокаПорядка;
		Секция = Макет.ПолучитьОбласть("ШапкаПорядок");
		Секция.Параметры.СтрокаПорядка = СтрокаПорядка;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 
	
	Если ПостроительОтчета.ИзмеренияСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	МассивГруппировок = Новый Массив;

	Секция = Макет.ПолучитьОбласть("ШапкаТаблицы");
	Таб.Вывести(Секция);
	
	Таб.НачатьАвтогруппировкуСтрок();
	
	Если ПостроительОтчета.ИзмеренияСтроки.Найти("Контрагент") <> Неопределено Тогда
		ТаблицаЗапроса = РезультатЗапроса.Выгрузить();
		ТаблицаЗапросаПрошлыхСтадий = ПолучитьТаблицуЗначенийЗапросаПрошлыхСтадий(ТаблицаЗапроса);
	Иначе
		ТаблицаЗапросаПрошлыхСтадий = Неопределено;
	КонецЕсли;
	
	Таб.Рисунки.Очистить();
	
	ВывестиСтроки(Таб, Макет, РезультатЗапроса, 0, ТаблицаЗапросаПрошлыхСтадий);
	
	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	Таб.ФиксацияСверху = мКоличествоВыведенныхСтрокЗаголовка + 2;
	
	ИзменитьВидимостьЗаголовка(Таб);
	
	Таб.ТолькоПросмотр = Истина;
	Таб.Показать();
	
КонецПроцедуры

// Функция возвращает таблицу занчений со стадиями взаимоотношений с контрагентами, чтобы определить динамику
//  изменения стадий
//
// Параметры
//  ТаблицаЗапроса - Таблица значений, выгруженная из основного запроса отчета
//                   для определения списка необходимых контрагентов
//
// Возвращаемое значение:
//   ТаблицаЗначений - результат запроса
//
Функция ПолучитьТаблицуЗначенийЗапросаПрошлыхСтадий(ТаблицаЗапроса)

	ТаблицаЗапроса.Свернуть("Контрагент");
	
	МассивКонтрагентов = ТаблицаЗапроса.ВыгрузитьКолонку("Контрагент");
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивКонтрагентов", МассивКонтрагентов);
	Запрос.УстановитьПараметр("ДатаОтчета", ?(ДатаОтчета = '00010101000000', ТекущаяДата(), КонецДня(ДатаОтчета)));
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтадииВзаимоотношенийСПокупателями.Контрагент                 КАК Контрагент,
	|	СтадииВзаимоотношенийСПокупателями.Период                     КАК Период,
	|	СтадииВзаимоотношенийСПокупателями.Стадия                     КАК СтадияПокупателя,
	|	СтадииВзаимоотношенийСПокупателями.КлассПостоянногоПокупателя КАК КлассПостоянногоПокупателя
	|
	|ИЗ
	|	РегистрСведений.СтадииВзаимоотношенийСПокупателями КАК СтадииВзаимоотношенийСПокупателями
	|
	|ГДЕ
	|	СтадииВзаимоотношенийСПокупателями.Контрагент В(&МассивКонтрагентов)
	|	И
	|	СтадииВзаимоотношенийСПокупателями.Период <= &ДатаОтчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции

// Процедура меняет видимость заголовка поля табличного документа
// 
// Параметры
//  Таб - табличный документ
//
// Возвращаемые значения
//  НЕТ
Процедура ИзменитьВидимостьЗаголовка(Таб) Экспорт

	ОбластьВидимости = Таб.Область(1,,мКоличествоВыведенныхСтрокЗаголовка,);
	ОбластьВидимости.Видимость = ПоказыватьЗаголовок;

КонецПроцедуры

// Процедура выводит строки в ПолеТабличногоДокумента
// 
// Параметры
//  Таб                          - ПолеТабличногоДокумента, в котором показывать данные отчета
//  Макет                        - макет отчета
//  ТекущаяВыборка               - выборка запроса, из которой выводить строки
//  ИндексТекущейГруппировки     - число, индекс выводимой группировки
//  ТаблицаЗапросаПрошлыхСтадий  - ТаблицаЗначений,  прошлые значения стадий контрагентов
// 
// Возвращаемое значение
//  НЕТ
Процедура ВывестиСтроки(Таб, Макет, ТекущаяВыборка, ИндексТекущейГруппировки, ТаблицаЗапросаПрошлыхСтадий)

	Если ИндексТекущейГруппировки > ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
		Возврат;
	КонецЕсли; 

	НаименованиеГруппировки = ПостроительОтчета.ИзмеренияСтроки[ИндексТекущейГруппировки].Имя;

	// Если добавить в группировки строк одинаковые значения, то в именах групировок
	// добавляется цифра 1,2,3..., а поля таблицы запроса естественно не добавляются с такими именами
	// поэтому из имени группировки удилим последние цифры в имени
	
	а = СтрДлина(НаименованиеГруппировки);
	Пока а > 0 Цикл
		Если КодСимвола(Сред(НаименованиеГруппировки, а, 1)) >= 49 И КодСимвола(Сред(НаименованиеГруппировки, а, 1)) <= 57 Тогда
			а = а - 1;
			Продолжить;
		КонецЕсли;
		Прервать;
	КонецЦикла;
	
	НаименованиеГруппировки = Лев(НаименованиеГруппировки, а);

	Выборка = ТекущаяВыборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, НаименованиеГруппировки);

	Пока Выборка.Следующий() Цикл

		СтрокаВывода = СокрЛП(Строка(Выборка[НаименованиеГруппировки]));
		Если ПустаяСтрока(СтрокаВывода) Тогда
			СтрокаВывода = "<...>";
		КонецЕсли;

		ТекущийЦвет = Новый Цвет;
		Если РаскрашиватьГруппировки Тогда
			Если ИндексТекущейГруппировки <> ПостроительОтчета.ИзмеренияСтроки.Количество()-1 Тогда
				ИндексЦвета = ИндексТекущейГруппировки;
				Если ИндексЦвета >= 10 Тогда
					ИндексЦвета = (ИндексТекущейГруппировки/10 - Цел(ИндексТекущейГруппировки/10))*10;
				КонецЕсли; 
				ТекущийЦвет = Макет.Области["Цвет"+СокрЛП(Строка(ИндексЦвета))].ЦветФона;
			Иначе
				ТекущийЦвет = Новый Цвет;
			КонецЕсли; 
		КонецЕсли;
		
		Секция = Макет.ПолучитьОбласть("СтрокаГруппировки");
		
		Секция.Параметры.ЗначениеГруппировки = СтрокаВывода;
		Секция.Области.ЗначениеГруппировки.Расшифровка = Выборка[НаименованиеГруппировки];
		Секция.Области.ЗначениеГруппировки.Отступ = ИндексТекущейГруппировки;
		Секция.Области.ЗначениеГруппировки.ЦветФона = ТекущийЦвет;
		Секция.Области.КартинкаСостояния.ЦветФона   = ТекущийЦвет;
		
		Если НаименованиеГруппировки = "СтадияПокупателя" ИЛИ НаименованиеГруппировки = "КлассПостоянногоПокупателя" Тогда
			Секция.Области.ЗначениеГруппировки.Шрифт = Новый Шрифт(,, Истина)
		КонецЕсли; 
		
		СтрокаВыводаСтадии = "";
		Если НаименованиеГруппировки = "Контрагент" Тогда
			СтрокаВыводаКласса = "Не задан";
			ВыборкаДетальныхЗаписей = Выборка.Выбрать();
			Пока ВыборкаДетальныхЗаписей.Следующий() Цикл
				Если ВыборкаДетальныхЗаписей.ТипЗаписи() = ТипЗаписиЗапроса.ДетальнаяЗапись Тогда
					Если ТипЗнч(ВыборкаДетальныхЗаписей.ABCКлассПокупателя) = Тип("ПеречислениеСсылка.ABCКлассификация") И НЕ ВыборкаДетальныхЗаписей.ABCКлассПокупателя.Пустая() Тогда
						СтрокаВыводаКласса = Строка(ВыборкаДетальныхЗаписей.ABCКлассПокупателя);
					КонецЕсли; 
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
		
		Секция.Параметры.ЗначениеАВСКалсса = СтрокаВыводаКласса;
		Секция.Области.ЗначениеАВСКалсса.ЦветФона = ТекущийЦвет;
		
		Таб.Вывести(Секция, ИндексТекущейГруппировки);
		
		Если НаименованиеГруппировки = "Контрагент" Тогда
			
			РисунокКонтрагента = Таб.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
			Если РаскрашиватьГруппировки Тогда
				РисунокКонтрагента.ЦветФона = ТекущийЦвет;
			КонецЕсли;
			РисунокКонтрагента.Картинка = ПолучитьКартинкуИзмененияСтадии(Выборка[НаименованиеГруппировки], ТаблицаЗапросаПрошлыхСтадий);
			РисунокКонтрагента.РазмерКартинки = РазмерКартинки.АвтоРазмер;
			РисунокКонтрагента.ГраницаСлева = Ложь;
			РисунокКонтрагента.Защита = Истина;
			РисунокКонтрагента.Расположить(Таб.Области.КартинкаСостояния);
			
		КонецЕсли; 

		ВывестиСтроки(Таб, Макет, Выборка, ИндексТекущейГруппировки+1, ТаблицаЗапросаПрошлыхСтадий);
		
	КонецЦикла; 
	
КонецПроцедуры

// Функция определяет картинку, которая отображает динамику изменения стадии контрагента
//
// Параметры
//  Контрагент                   - СправочникКонтрагенты.Ссылка, контрагент по которому определяется динамика изменения класса
//  ТаблицаЗапросаПрошлыхСтадий  - ТаблицаЗначений,  прошлые значения стадий взаимоотношений с контрагентами
//
// Возвращаемое значение:
//   Картинка - картинка, показывающая динамику изменения стадии контрагента
//
Функция ПолучитьКартинкуИзмененияСтадии(Контрагент, ТаблицаЗапросаПрошлыхСтадий)

	Если ТипЗнч(Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат Новый Картинка;
	ИначеЕсли Контрагент.Пустая() Тогда
		Возврат Новый Картинка;
	Иначе
		
		СтрокиТаблицы = ТаблицаЗапросаПрошлыхСтадий.НайтиСтроки(Новый Структура("Контрагент", Контрагент));
		Если СтрокиТаблицы.Количество() = 0 Тогда
			Возврат Новый Картинка;
		ИначеЕсли СтрокиТаблицы.Количество() = 1 Тогда
			Возврат БиблиотекаКартинок.ИзменениеСостояния_Вверх;
		Иначе
			
			Если СтрокиТаблицы[1].КлассПостоянногоПокупателя.Пустая() Тогда
				ПрошлоеСостояние = СтрокиТаблицы[1].СтадияПокупателя;
			Иначе
				ПрошлоеСостояние = СтрокиТаблицы[1].КлассПостоянногоПокупателя;
			КонецЕсли;
			
			Если СтрокиТаблицы[0].КлассПостоянногоПокупателя.Пустая() Тогда
				ТекущееСостояние = СтрокиТаблицы[0].СтадияПокупателя;
			Иначе
				ТекущееСостояние = СтрокиТаблицы[0].КлассПостоянногоПокупателя;
			КонецЕсли;
			
			Если ПрошлоеСостояние = ТекущееСостояние Тогда
			
				Возврат БиблиотекаКартинок.ИзменениеСостояния_НаМесте;

			Иначе

				Если ТекущееСостояние = Перечисления.XYZКлассификация.XКласс Тогда
				
					Возврат БиблиотекаКартинок.ИзменениеСостояния_Вверх;
				
				ИначеЕсли ТекущееСостояние = Перечисления.XYZКлассификация.YКласс Тогда

					Если ПрошлоеСостояние = Перечисления.XYZКлассификация.XКласс Тогда
					
						Возврат БиблиотекаКартинок.ИзменениеСостояния_Вниз;

					Иначе

						Возврат БиблиотекаКартинок.ИзменениеСостояния_Вверх;
					
					КонецЕсли; 
					
				ИначеЕсли ТекущееСостояние = Перечисления.XYZКлассификация.ZКласс Тогда

					Если ПрошлоеСостояние = Перечисления.XYZКлассификация.XКласс
					 ИЛИ ПрошлоеСостояние = Перечисления.XYZКлассификация.YКласс Тогда
					
						Возврат БиблиотекаКартинок.ИзменениеСостояния_Вниз;

					Иначе

						Возврат БиблиотекаКартинок.ИзменениеСостояния_Вверх;
					
					КонецЕсли; 
					
				ИначеЕсли ТекущееСостояние = Перечисления.СтадииВзаимоотношенийСПокупателями.РазовыйПокупатель Тогда

					Возврат БиблиотекаКартинок.ИзменениеСостояния_Вверх;
					
				ИначеЕсли ТекущееСостояние = Перечисления.СтадииВзаимоотношенийСПокупателями.ПостоянныйПокупатель Тогда

					Возврат БиблиотекаКартинок.ИзменениеСостояния_НаМесте;
					
				ИначеЕсли ТекущееСостояние = Перечисления.СтадииВзаимоотношенийСПокупателями.ПотерянныйПокупатель Тогда

					Возврат БиблиотекаКартинок.ИзменениеСостояния_Вниз;
					
				КонецЕсли; 
			
			КонецЕсли;

		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый Картинка;

КонецФункции // ПолучитьКартинкуИзмененияСтадии()

мСтруктураСоответствияИмен = Новый Структура;

мКоличествоВыведенныхСтрокЗаголовка = 0;

мСписокОтбора = Новый СписокЗначений;
мСписокОтбора.Добавить("Контрагент");
мСписокОтбора.Добавить("СтадияПокупателя");
мСписокОтбора.Добавить("КлассПостоянногоПокупателя");
#КонецЕсли
