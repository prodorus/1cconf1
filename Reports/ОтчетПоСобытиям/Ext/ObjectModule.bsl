﻿#Если Клиент Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Количество строк заголовка поля табличного документа
Перем мКоличествоВыведенныхСтрокЗаголовка Экспорт;

// Настройка периода
Перем НП Экспорт;

// Структура секций макета для вывода параметров События
Перем мСтруктураСекцийСобытия;

// СписокЗначений - имена реквизитов документа Событие, которые будем показывать в отчете
Перем мСписокЭлементовСобытия;

// Структура - соответствие имен полей и их представления для построителя отчетов
Перем мСтруктураСоответствияИмен Экспорт;

// Строка - имя группировки строк у построителя отчета для группировки по документу "Событие"
Перем мИмяГруппировкиДокумента Экспорт;

// Список значений, имена отборов построителя отчета, которые существуют постоянно
Перем мСписокОтбора Экспорт;

// Макет отчета
Перем мМакет;

// Структура, ключи которой - имена отборов Построителя, значения - параметры Построителя
Перем мСтруктураДляОтбораПоКатегориям Экспорт;

Перем мСоответствиеНазначений Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

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
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ //РАЗЛИЧНЫЕ
	|	События.Ссылка КАК Событие
	|{ВЫБРАТЬ
	|	События.Ссылка.* КАК Событие
	|//СВОЙСТВА
	|}
	|
	|ИЗ
	|	Документ.Событие КАК События
	|//СОЕДИНЕНИЯ
	|
	|ГДЕ
	|	(&ДатаОкончания = &ПустаяДата И &ДатаНачала = &ПустаяДата)
	|	ИЛИ
	|	((&ДатаОкончания = &ПустаяДата И &ДатаНачала <> &ПустаяДата) И События.Дата >= &ДатаНачала)
	|	ИЛИ
	|	((&ДатаОкончания <> &ПустаяДата И &ДатаНачала = &ПустаяДата) И События.Дата <= &ДатаОкончания)
	|	ИЛИ
	|	((&ДатаОкончания <> &ПустаяДата И &ДатаНачала <> &ПустаяДата) И (События.Дата <= &ДатаОкончания И События.Дата >= &ДатаНачала))
	|
	|{ГДЕ
	|	События.Ссылка.* КАК Событие,
	|	События.Контрагент.* КАК Контрагент,
	|	События.КонтактноеЛицо.* КАК КонтактноеЛицо
	|	//СВОЙСТВА
	|	//КАТЕГОРИИ
	|	}
	|
	|{УПОРЯДОЧИТЬ ПО
	|	События.Ссылка.* КАК Событие,
	|	События.Контрагент.* КАК Контрагент,
	|	События.КонтактноеЛицо.* КАК КонтактноеЛицо
	|	//СВОЙСТВА
	|	}
	|
	|{ИТОГИ ПО
	|	События.Ссылка.* КАК Событие,
	|	События.Контрагент.* КАК Контрагент,
	|	События.КонтактноеЛицо.* КАК КонтактноеЛицо
	|	//СВОЙСТВА
	|	}
	|
	|";
	
	мСтруктураСоответствияИмен.Очистить();
	мСтруктураСоответствияИмен = Новый Структура("Контрагент, КонтактноеЛицо, Событие", "Контрагент", "Контактное лицо события", "Событие");
	
	мСоответствиеНазначений = Новый Соответствие;

	Если ИспользоватьСвойстваИКатегории Тогда
		
		ТаблицаПолей = Новый ТаблицаЗначений;
		ТаблицаПолей.Колонки.Добавить("ПутьКДанным");  // описание поля запроса поля, для которого добавляются свойства и категории. Используется в условии соединения с регистром сведений, хранящим значения свойств или категорий
		ТаблицаПолей.Колонки.Добавить("Представление");// представление поля, для которого добавляются свойства и категории. 
		ТаблицаПолей.Колонки.Добавить("Назначение");   // назначение свойств/категорий объектов для данного поля
		ТаблицаПолей.Колонки.Добавить("ТипЗначения");  // тип значения поля, для которого добавляются свойства и категории. Используется, если не установлено назначение
		ТаблицаПолей.Колонки.Добавить("НетКатегорий"); // признак НЕиспользования категорий для объекта

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "События.Контрагент";
		НоваяСтрока.Представление = "Контрагент";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты;

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "События.КонтактноеЛицо";
		НоваяСтрока.Представление = "Контактное лицо";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_КонтактныеЛица;

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "События.КонтактноеЛицо";
		НоваяСтрока.Представление = "Физическое лицо";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ФизическиеЛица;

		НоваяСтрока = ТаблицаПолей.Добавить();
		НоваяСтрока.ПутьКДанным = "События.Ссылка";
		НоваяСтрока.Представление = "Событие";
		НоваяСтрока.Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Документы;

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
		Если ПостроительОтчета.Отбор.Найти(ЭлементСписка.Значение) = Неопределено Тогда
			ПостроительОтчета.Отбор.Добавить(ЭлементСписка.Значение);
		КонецЕсли; 
	КонецЦикла;
	
	ПостроительОтчета.ИзмеренияСтроки.Добавить(мИмяГруппировкиДокумента);
	
КонецПроцедуры

// Функция формирует строку представления периода отчета
//
// Параметры
//  НЕТ
//
// Возвращаемое значение:
//   Строка
//
Функция СформироватьСтрокуПериода()

	ОписаниеПериода = "";
	
	// Вывод заголовка, описателя периода и фильтров и заголовка
	Если ДатаНачала = '00010101000000' И ДатаОкончания = '00010101000000' Тогда

		ОписаниеПериода     = "Период не установлен";

	Иначе

		Если ДатаНачала = '00010101000000' ИЛИ ДатаОкончания = '00010101000000' Тогда

			ОписаниеПериода = "Период: " + Формат(ДатаНачала, "ДФ = ""дд.ММ.гггг""; ДП = ""...""") 
							+ " - "      + Формат(ДатаОкончания, "ДФ = ""дд.ММ.гггг""; ДП = ""...""");

		Иначе

			Если ДатаНачала <= ДатаОкончания Тогда
				ОписаниеПериода = "Период: " + ПредставлениеПериода(НачалоДня(ДатаНачала), КонецДня(ДатаОкончания), "ФП = Истина");
			Иначе
				ОписаниеПериода = "Неправильно задан период!"
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат ОписаниеПериода;
	
КонецФункции // ()

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

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ПЕЧАТНОЙ ФОРМЫ ОТЧЕТА

// Процедура заполняет ПолеТабличногоДокумента
//
// Параметры - Таб - ПолеТабличногоДокумента
Процедура СформироватьОтчет(Таб) Экспорт

	ПостроительОтчета.Параметры.Вставить("ПустаяДата", '00010101000000');
	ПостроительОтчета.Параметры.Вставить("ДатаНачала", НачалоДня(ДатаНачала));
	ПостроительОтчета.Параметры.Вставить("ДатаОкончания", ?(ДатаОкончания = '00010101000000', ДатаОкончания, КонецДня(ДатаОкончания)));

	Если НЕ УправлениеОтчетами.ЗадатьПараметрыОтбораПоКатегориям(ПостроительОтчета, мСтруктураДляОтбораПоКатегориям) Тогда
		Предупреждение("По одной категории нельзя устанавливать несколько отборов");
		Возврат;
	КонецЕсли;

	УправлениеОтчетами.ПроверитьПорядокПостроителяОтчета(ПостроительОтчета);

	ПостроительОтчета.Выполнить();

	Таб.Очистить();

	Секция = мМакет.ПолучитьОбласть("ШапкаВерх");
	Таб.Вывести(Секция);
	
	Секция = мМакет.ПолучитьОбласть("ШапкаИнтервал");
	Секция.Параметры.СтрокаИнтервал = СформироватьСтрокуПериода();
	Таб.Вывести(Секция);
	мКоличествоВыведенныхСтрокЗаголовка = 4;
	
	СтрокаГруппировок = УправлениеОтчетами.СформироватьСтрокуИзмерений(ПостроительОтчета.ИзмеренияСтроки);
	Если НЕ ПустаяСтрока(СтрокаГруппировок) Тогда
		СтрокаГруппировок = "Группировки строк: " + СтрокаГруппировок;
		Секция = мМакет.ПолучитьОбласть("ШапкаГруппировки");
		Секция.Параметры.СтрокаГруппировок = СтрокаГруппировок;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 

	СтрокаОтборов = УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
	Если НЕ ПустаяСтрока(СтрокаОтборов) Тогда
		СтрокаОтборов = "Отбор: " + СтрокаОтборов;
		Секция = мМакет.ПолучитьОбласть("ШапкаОтбор");
		Секция.Параметры.СтрокаОтборов = СтрокаОтборов;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли; 
	
	СтрокаПорядка = УправлениеОтчетами.СформироватьСтрокуПорядка(ПостроительОтчета.Порядок);
	Если НЕ ПустаяСтрока(СтрокаПорядка) Тогда
		СтрокаПорядка = "Сортировка: " + СтрокаПорядка;
		Секция = мМакет.ПолучитьОбласть("ШапкаПорядок");
		Секция.Параметры.СтрокаПорядка = СтрокаПорядка;
		Таб.Вывести(Секция);
		мКоличествоВыведенныхСтрокЗаголовка = мКоличествоВыведенныхСтрокЗаголовка + 1;
	КонецЕсли;
	
	Секция = мМакет.ПолучитьОбласть("ПустоСтрока");
	Таб.Вывести(Секция);
	
	Таб.НачатьАвтогруппировкуСтрок();
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	ВывестиСтроки(Таб, мМакет, РезультатЗапроса, 0);

	Таб.ЗакончитьАвтогруппировкуСтрок();
	
	ИзменитьВидимостьЗаголовка(Таб);
	
	Таб.Показать();
	
КонецПроцедуры

// Процедура выводит строки в ПолеТабличногоДокумента
// 
// Параметры
//  Таб - ПолеТабличногоДокумента
//  Макет - макет отчета
//  ТекущаяВыборка - выборка запроса, из которой выводить строки
//  МассивГруппировок - массив с именами группировок
//  ИндексТекущейГруппировки - число, индекс выводимой группировки
// 
// Возвращаемое значение
//  НЕТ
Процедура ВывестиСтроки(Таб, Макет, ТекущаяВыборка, ИндексТекущейГруппировки)

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
			
		Если НаименованиеГруппировки = мИмяГруппировкиДокумента Тогда
			
			Если ПустаяСтрока(Строка(Выборка[НаименованиеГруппировки])) Тогда
				
				СтрокаВывода = "<...>";
				
			Иначе
				
				Событие = Выборка[НаименованиеГруппировки];
				
				СтрокаВывода = "";
				
				Если Событие.ВидСобытия = Перечисления.ВидыСобытий.Прочее Тогда

					Если НЕ ПустаяСтрока(Событие.ОписаниеСобытия) Тогда
					
						СтрокаВывода = СтрокаВывода + Событие.ОписаниеСобытия;

					Иначе
					
						СтрокаВывода = СтрокаВывода + "Прочее событие";
						
					КонецЕсли;
					
				Иначе

					СтрокаВывода = СтрокаВывода + Строка(Событие.ВидСобытия);
					
				КонецЕсли; 
				
				СтрокаВывода = СтрокаВывода + " № " + СокрЛП(Событие.Номер) + " от " + СокрЛП(Событие.Дата);
				
			КонецЕсли;
			
			Секция = Макет.ПолучитьОбласть("СтрокаШапкаСобытия");

			Секция.Параметры.ШапкаСобытия = СтрокаВывода;
			Секция.Области.ШапкаСобытия.Расшифровка = Выборка[НаименованиеГруппировки];
			Секция.Области.ШапкаСобытия.Отступ = ИндексТекущейГруппировки;
			Секция.Области.ШапкаСобытия.ЦветФона = ТекущийЦвет;
			Таб.Вывести(Секция, ИндексТекущейГруппировки);
			СформироватьСобытие(Событие, Макет, (ИндексТекущейГруппировки + 1), Таб);
			
		Иначе
			
			СтрокаВывода = СокрЛП(Строка(Выборка[НаименованиеГруппировки]));
			Если ПустаяСтрока(СтрокаВывода) Тогда
				СтрокаВывода = "<...>";
			КонецЕсли;

			Секция = Макет.ПолучитьОбласть("СтрокаГруппировки");
			
			Секция.Параметры.ЗначениеГруппировки = СтрокаВывода;
			Секция.Области.ЗначениеГруппировки.Расшифровка = Выборка[НаименованиеГруппировки];
			Секция.Области.ЗначениеГруппировки.Отступ = ИндексТекущейГруппировки;
			Секция.Области.ЗначениеГруппировки.ЦветФона = ТекущийЦвет;
			Таб.Вывести(Секция, ИндексТекущейГруппировки);
			
		КонецЕсли;
	
		ВывестиСтроки(Таб, Макет, Выборка, ИндексТекущейГруппировки+1);
	
	КонецЦикла; 
	
КонецПроцедуры

// Процедура формирует секцию табличного документа
//
// Параметры 
//  Событие - ДокументСсылка.Событие
//  Макет - Макет отчета
//  Индекс - Порядковый номер группировки запроса
//  Таб - Табличный документ
Процедура СформироватьСобытие(Событие, Макет, Индекс, Таб)

	Если Событие = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Секция = Макет.ПолучитьОбласть("ПустоСобытиеВерх");
	Таб.Вывести(Секция, Индекс,, Ложь);
	
	Для каждого Элементы Из мСписокЭлементовСобытия Цикл
		Секция = Неопределено;
		Если НЕ мСтруктураСекцийСобытия.Свойство(Элементы.Значение, Секция) Тогда
			Продолжить;;
		КонецЕсли;
		Если Элементы.Значение = "НачалоОкончание" Тогда
			Секция.Параметры.НачалоСобытия = Строка(Событие.НачалоСобытия);
			Секция.Параметры.ОкончаниеСобытия = Строка(Событие.ОкончаниеСобытия);
		ИначеЕсли Элементы.Значение = "Вложения" Тогда
			Если РаботаСФайлами.ЕстьДополнительнаяИнформация(Событие) Тогда
				Секция.Параметры[Элементы.Значение] = "Открыть список";
				Секция.Области.ПриложенныеФайлы.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.Ячейка;
				Секция.Области.ПриложенныеФайлы.Расшифровка              = Событие;
				Секция.Области.ПриложенныеФайлы.ГиперСсылка              = Истина;
				Секция.Области.ПриложенныеФайлы.Шрифт                    = Новый Шрифт(Секция.Области.ПриложенныеФайлы.Шрифт,,,,, Истина,) ;
				Секция.Параметры.Расшифровка = Новый Структура("ЗначениеРасшифровки", Событие);
			Иначе
				Секция.Параметры[Элементы.Значение] = "- - -";
				Секция.Области.ПриложенныеФайлы.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
				Секция.Области.ПриложенныеФайлы.ГиперСсылка              = Ложь;
				Секция.Параметры.Расшифровка = Неопределено;
			КонецЕсли; 
		Иначе
			Секция.Параметры[Элементы.Значение] = Строка(Событие[Элементы.Значение]);
		КонецЕсли;
		Если Элементы.Значение = "Основание" Тогда
			Секция.Области.ОснованиеСобытия.Расшифровка = Событие[Элементы.Значение];
			Если Событие[Элементы.Значение] <> Неопределено И НЕ Событие[Элементы.Значение].Пустая() Тогда
				Секция.Области.ОснованиеСобытия.ГиперСсылка = Истина;
				Секция.Области.ОснованиеСобытия.Шрифт       = Новый Шрифт(Секция.Области.ОснованиеСобытия.Шрифт,,,,, Истина,) ;
			Иначе
				Секция.ТекущаяОбласть.ИспользованиеРасшифровки = ИспользованиеРасшифровкиТабличногоДокумента.БезОбработки;
			КонецЕсли; 
		КонецЕсли; 
		Таб.Вывести(Секция, Индекс,, Ложь);
	КонецЦикла; 
	
	Секция = Макет.ПолучитьОбласть("ПустоСобытиеНиз");
	Таб.Вывести(Секция, Индекс,, Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

мМакет = ПолучитьМакет("Макет");

мКоличествоВыведенныхСтрокЗаголовка = 0;

// Установим имена быстрых отборов
мСписокОтбора = Новый СписокЗначений;
мСписокОтбора.Добавить("Контрагент");
мСписокОтбора.Добавить("КонтактноеЛицо");

НП = Новый НастройкаПериода;

мСписокЭлементовСобытия = Новый СписокЗначений;
мСписокЭлементовСобытия.Очистить();
мСписокЭлементовСобытия.Добавить("НачалоОкончание","НачалоОкончание");
мСписокЭлементовСобытия.Добавить("Контрагент","Контрагент");
мСписокЭлементовСобытия.Добавить("КонтактноеЛицо","КонтактноеЛицо");
мСписокЭлементовСобытия.Добавить("ОписаниеСобытия","Описание");
мСписокЭлементовСобытия.Добавить("ВидСобытия","ВидСобытия");
мСписокЭлементовСобытия.Добавить("ТипСобытия","ТипСобытия");
мСписокЭлементовСобытия.Добавить("ГруппаСобытия","ГруппаСобытия");
мСписокЭлементовСобытия.Добавить("Важность","Важность");
мСписокЭлементовСобытия.Добавить("СостояниеСобытия","Состояние");
мСписокЭлементовСобытия.Добавить("СодержаниеСобытия","Содержание");
мСписокЭлементовСобытия.Добавить("Основание","Основание");
мСписокЭлементовСобытия.Добавить("Ответственный","Ответственный");
мСписокЭлементовСобытия.Добавить("Вложения","Вложения");

мСтруктураСекцийСобытия = Новый Структура;
мСтруктураСекцийСобытия.Вставить("НачалоОкончание",мМакет.ПолучитьОбласть("НачалоОкончание"));
мСтруктураСекцийСобытия.Вставить("Контрагент",мМакет.ПолучитьОбласть("Контрагент"));
мСтруктураСекцийСобытия.Вставить("КонтактноеЛицо",мМакет.ПолучитьОбласть("КонтактноеЛицо"));
мСтруктураСекцийСобытия.Вставить("ОписаниеСобытия",мМакет.ПолучитьОбласть("ОписаниеСобытия"));
мСтруктураСекцийСобытия.Вставить("ВидСобытия",мМакет.ПолучитьОбласть("ВидСобытия"));
мСтруктураСекцийСобытия.Вставить("ТипСобытия",мМакет.ПолучитьОбласть("ТипСобытия"));
мСтруктураСекцийСобытия.Вставить("ГруппаСобытия",мМакет.ПолучитьОбласть("ГруппаСобытия"));
мСтруктураСекцийСобытия.Вставить("Важность",мМакет.ПолучитьОбласть("Важность"));
мСтруктураСекцийСобытия.Вставить("СостояниеСобытия",мМакет.ПолучитьОбласть("СостояниеСобытия"));
мСтруктураСекцийСобытия.Вставить("СодержаниеСобытия",мМакет.ПолучитьОбласть("СодержаниеСобытия"));
мСтруктураСекцийСобытия.Вставить("Основание",мМакет.ПолучитьОбласть("Основание"));
мСтруктураСекцийСобытия.Вставить("Ответственный",мМакет.ПолучитьОбласть("Ответственный"));
мСтруктураСекцийСобытия.Вставить("Вложения",мМакет.ПолучитьОбласть("Вложения"));

мСтруктураСоответствияИмен = Новый Структура;

мИмяГруппировкиДокумента = "Событие";
#КонецЕсли

