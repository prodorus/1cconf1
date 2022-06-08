﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ВЫПОЛНЕНИЯ ЗАДАЧ

Процедура ВыполнитьВыбраннуюЗадачу(Задача) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",	Задача);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задачи.ВидЗадачи,
	|	Задачи.ОбъектЗадачи,
	|	Задачи.Дата КАК ДатаЗадачи
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК Задачи
	|ГДЕ
	|	Задачи.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ВидЗадачи			= Выборка.ВидЗадачи;
	ОбъектЗадачи		= Выборка.ОбъектЗадачи;
	ДатаЗадачи			= Выборка.ДатаЗадачи;
	
	Если ВидЗадачи = Справочники.ВидыЗадачПользователей.ВозвратНаРаботу Тогда
		ЗадачаВозвратНаРаботу(ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ДеньРождения Тогда
		ЗадачаДеньРождения(ОбъектЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.Доначисление Тогда
		ЗадачаДоначисление(ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.КадровоеПеремещение Тогда
		ЗадачаКадровоеПеремещение(ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.НачислениеПоКадровомуДокументу Тогда
		ЗадачаНачислениеПоКадровомуДокументу(ОбъектЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ОценкаИспытательногоСрока Тогда
		ЗадачаОценкаИспытательногоСрока(ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.Перезаполнение Тогда
		ЗадачаПерезаполнение(ОбъектЗадачи, ДатаЗадачи, Задача);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.Перерасчет Тогда
		ЗадачаПерерасчет(ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ПриемНаРаботу Тогда
		ЗадачаПриемНаРаботу(ОбъектЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ПроизводственныйКалендарь Тогда
		ЗадачаПроизводственныйКалендарь(ОбъектЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.РасчетЕСН Тогда
		ЗадачаРасчетныйДокумент(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.РасчетСтраховыхВзносов Тогда
		ЗадачаРасчетныйДокумент(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.РасчетЗарплаты Тогда
		ЗадачаРасчетныйДокумент(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ОтражениеЗарплатыВУчете Тогда
		ЗадачаРасчетныйДокумент(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ОшибкиПриемаПоОсновномуМестуРаботы Тогда
		ЗадачаМеханизмКонтроляПериодов(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ОшибкиПриемаПоСовместительству Тогда
		ЗадачаМеханизмКонтроляПериодов(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.СведенияОСтавкахЕСНиПФР Тогда
		ЗадачаСведенияОСтавкахЕСНиПФР(ОбъектЗадачи);
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.Увольнение Тогда
		ЗадачаУвольнение(ОбъектЗадачи, ДатаЗадачи);
		
	Иначе
		Результат = УправлениеЗадачамиКлиентПереопределяемый.ВыполнитьЗадачи(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи);
		
		Если Не Результат Тогда
			Задача.ПолучитьФорму().Открыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ВЫПОЛНЕНИЯ ЗАДАЧ ЗАРПЛАТНО-КАДРОВОЙ ФУНКЦИОНАЛЬНОСТИ

Процедура ЗадачаВозвратНаРаботу(ОбъектЗадачи, ДатаЗадачи)
	
	ФормаДокумента = Документы.ВозвратНаРаботуОрганизаций.ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
	ФормаДокумента.Заполнить(ОбъектЗадачи);
	
	Если ФормаДокумента.РаботникиОрганизации.Количество() > 0 Тогда
		НоваяСтрока = ФормаДокумента.РаботникиОрганизации[0];
		НоваяСтрока.ДатаВозврата = ДатаЗадачи;
	КонецЕсли;
	
	ФормаДокумента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаДеньРождения(ОбъектЗадачи)
	
	ФормаЭлемента = ОбъектЗадачи.ПолучитьФорму();
	ФормаЭлемента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаДоначисление(ОбъектЗадачи, ДатаЗадачи)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Сотрудник",		ОбъектЗадачи);
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоМесяца(ДатаЗадачи));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецМесяца(ДатаЗадачи));
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Доначисления.Сотрудник КАК Ссылка,
	|	Доначисления.ДатаНачала КАК ДатаНачала,
	|	Доначисления.ДатаОкончания КАК ДатаОкончания,
	|	Доначисления.Организация
	|ИЗ
	|	РегистрСведений.ДоначисленияСотрудникам КАК Доначисления
	|ГДЕ
	|	Доначисления.Сотрудник = &Сотрудник
	|	И Доначисления.ДатаНачала >= &ДатаНачала
	|	И Доначисления.ДатаОкончания <= &ДатаОкончания";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ДокументДоначисление = Документы.НачислениеЗарплатыРаботникамОрганизаций.СоздатьДокумент();
	ДокументДоначисление.Организация					= Выборка.Организация;
	
	ЗаполнениеДокументовПереопределяемый.ЗаполнитьШапкуДокумента(ДокументДоначисление, глЗначениеПеременной("глТекущийПользователь"));
	
	СписокСотрудников = Новый Массив;
	СписокСотрудников.Добавить(ОбъектЗадачи);
	
	ДокументДоначисление.ПериодНачисления				= Перечисления.ПериодНачисленияЗарплаты.ПрошлыйПериод;
	ДокументДоначисление.ПериодНачисленияДатаНачала		= Выборка.ДатаНачала;
	ДокументДоначисление.ПериодНачисленияДатаОкончания	= Выборка.ДатаОкончания;
	ДокументДоначисление.ВыполнитьАвтозаполнение(
	ДокументДоначисление.ПериодНачисленияДатаНачала, 
	ДокументДоначисление.ПериодНачисленияДатаОкончания,,,,
	СписокСотрудников);
	
	ФормаДокумента = ДокументДоначисление.ПолучитьФорму();
	ФормаДокумента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаКадровоеПеремещение(ОбъектЗадачи, ДатаЗадачи)
	
	ФормаДокумента = Документы.КадровоеПеремещениеОрганизаций.ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
	ФормаДокумента.Заполнить(ОбъектЗадачи);
	
	Если ФормаДокумента.РаботникиОрганизации.Количество() > 0 Тогда
		ФормаДокумента.РаботникиОрганизации[0].ДатаНачала = ДатаЗадачи;
	КонецЕсли;
	
	ФормаДокумента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаМеханизмКонтроляПериодов(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи)
	
	Запрос = Новый Запрос;
	
	Форма = ПолучитьОбщуюФорму("ФормаОшибокКадровыхПеремещений", , ОбъектЗадачи);
	Форма.Ошибки.Очистить();
	
	Если ВидЗадачи = Справочники.ВидыЗадачПользователей.ОшибкиПриемаПоОсновномуМестуРаботы Тогда
		МассивСотрудники = Новый Массив;
		МассивСотрудники.Добавить(ОбъектЗадачи);
		
		СообщенияОбОшибках = Новый Массив;
		
		ПроцедурыУправленияПерсоналом.ПолучитьОшибкиПериодовРаботыСотрудникаПоОсновномуМестуРаботы(НеОпределено, Истина, МассивСотрудники, СообщенияОбОшибках, НеОпределено);
		Регистраторы = Новый Соответствие();
		Для Каждого Сообщение Из СообщенияОбОшибках Цикл
			Если Сообщение.Регистратор1Ссылка <> null И Регистраторы[Сообщение.Регистратор1Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.Регистратор1Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.Регистратор1Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаНачала;
			КонецЕсли;
			Если Сообщение.Регистратор2Ссылка <> null И Регистраторы[Сообщение.Регистратор2Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.Регистратор2Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.Регистратор2Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаОкончания;
			КонецЕсли;
			Если Сообщение.ПослРегистратор1Ссылка <> null И Регистраторы[Сообщение.ПослРегистратор1Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.ПослРегистратор1Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.ПослРегистратор1Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаОкончания;
			КонецЕсли;
			Если Сообщение.ПослРегистратор2Ссылка <> null И Регистраторы[Сообщение.ПослРегистратор2Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.ПослРегистратор2Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.ПослРегистратор2Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаОкончания;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ОшибкиПриемаПоСовместительству Тогда
		МассивСотрудники = Новый Массив;
		МассивСотрудники.Добавить(ОбъектЗадачи);
		
		СообщенияОбОшибках = Новый Массив;
		
		ПроцедурыУправленияПерсоналом.ПолучитьОшибкиПериодовРаботыСотрудникаПоСовместительству(НеОпределено, Истина, МассивСотрудники, ОбъектЗадачи.Организация, СообщенияОбОшибках, НеОпределено);
		Регистраторы = Новый Соответствие();
		Для Каждого Сообщение Из СообщенияОбОшибках Цикл
			Если Сообщение.Регистратор1Ссылка <> null И Регистраторы[Сообщение.Регистратор1Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.Регистратор1Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.Регистратор1Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаНачала;
			КонецЕсли;
			Если Сообщение.Регистратор2Ссылка <> null И Регистраторы[Сообщение.Регистратор2Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.Регистратор2Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.Регистратор2Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаОкончания;
			КонецЕсли;
			Если Сообщение.ПослРегистратор1Ссылка <> null И Регистраторы[Сообщение.ПослРегистратор1Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.ПослРегистратор1Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.ПослРегистратор1Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаОкончания;
			КонецЕсли;
			Если Сообщение.ПослРегистратор2Ссылка <> null И Регистраторы[Сообщение.ПослРегистратор2Ссылка] = НеОпределено Тогда
				Регистраторы[Сообщение.ПослРегистратор2Ссылка] = 0;
				Строка = Форма.Ошибки.Добавить();
				Строка.Документ = Сообщение.ПослРегистратор2Ссылка;
				Строка.ДатаСобытия = Сообщение.ДатаОкончания;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Форма.Открыть();
	
КонецПроцедуры

Процедура ЗадачаНачислениеПоКадровомуДокументу(ОбъектЗадачи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",	ОбъектЗадачи);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Организация
	|ИЗ
	|	Документ." + ОбъектЗадачи.Метаданные().Имя + " КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ФормаОбработки = Обработки.АнализНеявок.ПолучитьФорму();
	
	ФормаОбработки.Организация					= Выборка.Организация;
	ФормаОбработки.ОтбиратьСобытияПоДокументу	= Истина;
	ФормаОбработки.ТипДокумента					= ОбъектЗадачи.Метаданные().Синоним;
	ФормаОбработки.КадровыйДокументОтбора		= ОбъектЗадачи;
	
	ФормаОбработки.Неявки.Очистить();
	ФормаОбработки.Автозаполнение();
	
	ФормаОбработки.Открыть();
	
КонецПроцедуры

Процедура ЗадачаОценкаИспытательногоСрока(ОбъектЗадачи, ДатаЗадачи)
	
	ФормаДокумента = Документы.РезультатИспытательногоСрока.ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
	
	ФормаДокумента.Сотрудник		= ОбъектЗадачи;
	ФормаДокумента.Результат		= Перечисления.РезультатыИспытательногоСрока.Положительный;
	ФормаДокумента.ДатаИзменения	= ДатаЗадачи;
	
	ФормаДокумента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаПерезаполнение(ОбъектЗадачи, ДатаЗадачи, Задача)
	
	Если НачалоМесяца(ДатаЗадачи) < НачалоМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату()) Тогда
		Форма = ПолучитьОбщуюФорму("ДиалогВопрос");
		Форма.Заголовок	= "Перезаполнение документа";
		Форма.ЭлементыФормы.НадписьТекстВопроса.Заголовок =
		"Перезаполнять можно только документы текущего периода. Вы можете
		|Перерассчитать существующий документ
		|или
		|Отметить задачу как выполненную.";
		Форма.ЭлементыФормы.КнопкаДействие1.Заголовок = "Перерассчитать";
		Форма.ЭлементыФормы.КнопкаДействие2.Заголовок = "Отметить задачу";
		
		Результат = Форма.ОткрытьМодально();
		Если ПустаяСтрока(Результат) Тогда
			Возврат;
		КонецЕсли;
		
		Если Результат = "1" Тогда
			ЗадачаПерерасчет(ОбъектЗадачи, ДатаЗадачи);
			
		Иначе
			ЗадачаОбъект = Задача.ПолучитьОбъект();
			ЗадачаОбъект.Выполнена = Истина;
			ЗадачаОбъект.Записать();
			
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументЗаполнения",	ОбъектЗадачи);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаполнениеПлановыхНачислений.Сотрудник,
	|	ЗаполнениеПлановыхНачислений.Сотрудник.Физлицо КАК Физлицо
	|ИЗ
	|	РегистрСведений.ЗаполнениеПлановыхНачислений КАК ЗаполнениеПлановыхНачислений
	|ГДЕ
	|	ЗаполнениеПлановыхНачислений.ОбъектЗаполнения = &ДокументЗаполнения";
	Выборка = Запрос.Выполнить().Выгрузить();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДокОбъект = ОбъектЗадачи.ПолучитьОбъект();
	ДокОбъект.ВыполнитьПерезаполнениеДокумента(Выборка.ВыгрузитьКолонку("Сотрудник"), Выборка.ВыгрузитьКолонку("Физлицо"));
	ДокОбъект.ПолучитьФорму().Открыть();
	
КонецПроцедуры

// функция формирует сообщение с именами сотрудников, по которым произведен перерасчет
//
Функция ПолучитьСообщениеОПерерасчетеСотрудников(ДокументПерерасчета)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументПерерасчета);
	ТекущаяДата = ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
	Если День(ТекущаяДата) < 20 Тогда
		АктуальныйПериодРегистрации = НачалоМесяца(ДобавитьМесяц(ТекущаяДата, -1));
	Иначе
		АктуальныйПериодРегистрации = НачалоМесяца(ТекущаяДата);
	КонецЕсли;
	Запрос.УстановитьПараметр("АктуальныйПериодРегистрации", АктуальныйПериодРегистрации);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 4
	|	ПРЕДСТАВЛЕНИЕ(СотрудникиПерерасчета.ФизЛицо) КАК ПредставлениеФизЛица
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ОсновныеНачисленияРаботниковОрганизацийПерерасчетОсновныхНачислений.ФизЛицо КАК ФизЛицо
	|	ИЗ
	|		РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК ОсновныеНачисленияРаботниковОрганизацийПерерасчетОсновныхНачислений
	|	ГДЕ
	|		ОсновныеНачисленияРаботниковОрганизацийПерерасчетОсновныхНачислений.ОбъектПерерасчета = &ДокументСсылка
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ДополнительныеНачисленияРаботниковОрганизацийПерерасчетДополнительныхНачислений.ФизЛицо
	|	ИЗ
	|		РегистрРасчета.ДополнительныеНачисленияРаботниковОрганизаций.ПерерасчетДополнительныхНачислений КАК ДополнительныеНачисленияРаботниковОрганизацийПерерасчетДополнительныхНачислений
	|	ГДЕ
	|		ДополнительныеНачисленияРаботниковОрганизацийПерерасчетДополнительныхНачислений.ОбъектПерерасчета = &ДокументСсылка
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		РасчетСреднегоЗаработкаПерерасчетСреднегоЗаработка.Физлицо
	|	ИЗ
	|		РегистрРасчета.РасчетСреднегоЗаработка.ПерерасчетСреднегоЗаработка КАК РасчетСреднегоЗаработкаПерерасчетСреднегоЗаработка
	|	ГДЕ
	|		РасчетСреднегоЗаработкаПерерасчетСреднегоЗаработка.ОбъектПерерасчета = &ДокументСсылка
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ЗаполнениеПлановыхНачислений.Сотрудник.Физлицо
	|	ИЗ
	|		РегистрСведений.ЗаполнениеПлановыхНачислений КАК ЗаполнениеПлановыхНачислений
	|	ГДЕ
	|		ЗаполнениеПлановыхНачислений.ОбъектЗаполнения = &ДокументСсылка
	|		И ЗаполнениеПлановыхНачислений.ПериодРегистрации < &АктуальныйПериодРегистрации) КАК СотрудникиПерерасчета";
	
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоСотрудников = 0;
	ТекстСообщения = "Документ перерассчитан. Изменились результаты расчета сотрудников:";
	Пока Выборка.Следующий() И КоличествоСотрудников < 4 Цикл
		ТекстСообщения = ТекстСообщения + " " + Выборка.ПредставлениеФизЛица + ",";
		КоличествоСотрудников = КоличествоСотрудников + 1;
	КонецЦикла;
	ТекстСообщения = Лев(ТекстСообщения, СтрДлина(ТекстСообщения) - 1);
	Если Выборка.Количество() > 3 Тогда
		ТекстСообщения = ТекстСообщения + " и других...";
	КонецЕсли;
	Если Выборка.Количество() > 0 Тогда
		Возврат ТекстСообщения;
	Иначе
		Возврат "";
	КонецЕсли;
КонецФункции // ПолучитьСообщениеОПерерасчетеСотрудников()

Процедура ЗадачаПерерасчет(ОбъектЗадачи, ДатаЗадачи)
	
	Если НачалоМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату()) <= НачалоМесяца(ДатаЗадачи) Тогда
		Результат = "2";
		
	Иначе
		Форма = ПолучитьОбщуюФорму("ДиалогВопрос");
		Форма.Заголовок	= "Перерасчет документа";
		Форма.ЭлементыФормы.НадписьТекстВопроса.Заголовок =
		"Создать документ-исправление для перерасчета текущим периодом
		|или
		|Пересчитать документ прошлым периодом";
		Форма.ЭлементыФормы.КнопкаДействие1.Заголовок = "Создать исправление";
		Форма.ЭлементыФормы.КнопкаДействие2.Заголовок = "Пересчитать прошлым периодом";
		
		Результат = Форма.ОткрытьМодально();
		Если ПустаяСтрока(Результат) Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Результат = "1" Тогда
		ФормаДокумента = Документы[Метаданные.НайтиПоТипу(ТипЗнч(ОбъектЗадачи)).Имя].ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
		ФормаДокумента.ПериодРегистрации				= НачалоМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
		ФормаДокумента.ЗаполнитьПоПерерассчитываемомуДокументу(ОбъектЗадачи);
		
		ФормаДокумента.Открыть();
		
	Иначе
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ДокументПерерасчета", ОбъектЗадачи);
		
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 4
		|	ПерерассчитываемыеДокументы.Ссылка КАК Документ
		|ИЗ
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 4
		|		РасчетЕСНОсновныеНачисления.Ссылка КАК Ссылка
		|	ИЗ
		|		(ВЫБРАТЬ
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Сотрудник.Физлицо КАК ФизЛицо,
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Сотрудник КАК Сотрудник,
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Ссылка.Организация КАК Организация
		|		ИЗ
		|			Документ.НачислениеЗарплатыРаботникамОрганизаций.Начисления КАК НачислениеЗарплатыРаботникамОрганизацийНачисления
		|		ГДЕ
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Ссылка = &ДокументПерерасчета) КАК УсловияДокумента
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетЕСН.ИсчисленныйЕСН КАК РасчетЕСНОсновныеНачисления
		|			ПО УсловияДокумента.ФизЛицо = РасчетЕСНОсновныеНачисления.ФизЛицо
		|				И УсловияДокумента.ПериодРегистрации = РасчетЕСНОсновныеНачисления.Ссылка.ПериодРегистрации
		|				И УсловияДокумента.Организация = РасчетЕСНОсновныеНачисления.Ссылка.Организация
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 4
		|		ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка
		|	ИЗ
		|		(ВЫБРАТЬ
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Сотрудник.Физлицо КАК ФизЛицо,
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Сотрудник КАК Сотрудник,
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Ссылка.Организация КАК Организация
		|		ИЗ
		|			Документ.НачислениеЗарплатыРаботникамОрганизаций.Начисления КАК НачислениеЗарплатыРаботникамОрганизацийНачисления
		|		ГДЕ
		|			НачислениеЗарплатыРаботникамОрганизацийНачисления.Ссылка = &ДокументПерерасчета) КАК УсловияДокумента
		|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗарплатаКВыплатеОрганизаций.Зарплата КАК ЗарплатаКВыплатеОрганизацийЗарплата
		|			ПО УсловияДокумента.Организация = ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка.Организация
		|				И УсловияДокумента.ФизЛицо = ЗарплатаКВыплатеОрганизацийЗарплата.Физлицо
		|				И УсловияДокумента.ПериодРегистрации = ЗарплатаКВыплатеОрганизацийЗарплата.Ссылка.ПериодРегистрации) КАК ПерерассчитываемыеДокументы
		|ГДЕ
		|	ПерерассчитываемыеДокументы.Ссылка ЕСТЬ НЕ NULL ";
		
		Выборка = Запрос.Выполнить().Выбрать();
		ДокументыТекст = "";
		НомерЗначенияЗапроса = 1;
		Пока Выборка.Следующий() Цикл
			Если НомерЗначенияЗапроса < 4 Тогда
				ДокументыТекст = ДокументыТекст + Символы.ПС + Строка(Выборка.Документ);
				НомерЗначенияЗапроса = НомерЗначенияЗапроса + 1;
			ИначеЕсли НомерЗначенияЗапроса = 4 Тогда
				ДокументыТекст = ДокументыТекст + " и другие..."
			Иначе
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если НачалоМесяца(ДатаЗадачи) = НачалоМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату()) Тогда
			ТекстСообщения = "Вы уверены в том, что хотите перерассчитать документ " + Строка(ОбъектЗадачи) + "?";
		Иначе
			ТекстСообщения = "Вы уверены в том, что хотите перерассчитать документ " + Строка(ОбъектЗадачи) + " прошлым периодом?";
		КонецЕсли;
		ТекстСообщения = ТекстСообщения +
		?(ПустаяСтрока(ДокументыТекст),"", символы.ПС + "Выполнение этой операции приведет к необходимости пересмотреть документы:" + ДокументыТекст);
		Ответ = Вопрос(ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Да, "Предупреждение");
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Попытка
				ТекстСообщения = ПолучитьСообщениеОПерерасчетеСотрудников(ОбъектЗадачи);
				
				ДокументОбъект = ОбъектЗадачи.ПолучитьОбъект();
				ДокументОбъект.Перерассчитать();
				Если ТекстСообщения <> "" Тогда
					Предупреждение(ТекстСообщения,,"Перерасчет документа");
				КонецЕсли;
				
			Исключение
				ОбщегоНазначенияЗК.СообщитьОбОшибке("Документ " + Строка(ДокументОбъект) + " не может быть перерассчитан!
				|" + ОписаниеОшибки());
				
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗадачаПриемНаРаботу(ОбъектЗадачи)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудник",	ОбъектЗадачи);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Док.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ПриемНаРаботуВОрганизацию.РаботникиОрганизации КАК Док
	|ГДЕ
	|	Док.Сотрудник = &Сотрудник
	|	И (НЕ Док.Ссылка.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ФормаДокумента = Выборка.Ссылка.ПолучитьФорму();
		
	Иначе
		ФормаДокумента = Документы.ПриемНаРаботуВОрганизацию.ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
		ФормаДокумента.Заполнить(ОбъектЗадачи);
		
	КонецЕсли;
	
	ФормаДокумента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаПроизводственныйКалендарь(ОбъектЗадачи)
	
		ФормаСпискаРегистра = РегистрыСведений.РегламентированныйПроизводственныйКалендарь.ПолучитьФормуСписка();
		ФормаСпискаРегистра.ГодВФорме	= ОбъектЗадачи;
		ФормаСпискаРегистра.Открыть();
		
КонецПроцедуры

Процедура ЗадачаРасчетныйДокумент(ВидЗадачи, ОбъектЗадачи, ДатаЗадачи)
	
	Если ВидЗадачи = Справочники.ВидыЗадачПользователей.РасчетЗарплаты Тогда
		ВидДокумента	= "НачислениеЗарплатыРаботникамОрганизаций";
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.РасчетЕСН Тогда
		ВидДокумента	= "РасчетЕСН";
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.РасчетСтраховыхВзносов Тогда
		ВидДокумента	= "РасчетСтраховыхВзносов";
	ИначеЕсли ВидЗадачи = Справочники.ВидыЗадачПользователей.ОтражениеЗарплатыВУчете Тогда
		ВидДокумента	= "ОтражениеЗарплатыВРеглУчете";
	Иначе
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",		ОбъектЗадачи);
	Запрос.УстановитьПараметр("ПериодРегистрации",	НачалоМесяца(ДатаЗадачи));
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Док.Ссылка КАК Ссылка
	|ИЗ
	|	Документ." + ВидДокумента + " КАК Док
	|ГДЕ
	|	Док.ПериодРегистрации = &ПериодРегистрации
	|	И Док.Организация = &Организация
	|	И (НЕ Док.ПометкаУдаления)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ФормаДокумента = Выборка.Ссылка.ПолучитьФорму();
		
	Иначе
		ФормаДокумента = Документы[ВидДокумента].ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
		ФормаДокумента.Организация			= ОбъектЗадачи;
		ФормаДокумента.ПериодРегистрации	= НачалоМесяца(ДатаЗадачи);
		ЗаполнениеДокументовПереопределяемый.ЗаполнитьШапкуДокумента(ФормаДокумента, глЗначениеПеременной("глТекущийПользователь"));
		ФормаДокумента.Заполнить(ОбъектЗадачи);
		
	КонецЕсли;
	
	ФормаДокумента.Открыть();
	
КонецПроцедуры

Процедура ЗадачаСведенияОСтавкахЕСНиПФР(ОбъектЗадачи)
	
	Предупреждение("С 2010 года ЕСН заменен страховыми взносами. Заполнять сведения о ставках ЕСН и ПФР больше не требуется. Отметьте задачу как выполненную.");
	
КонецПроцедуры

Процедура ЗадачаУвольнение(ОбъектЗадачи, ДатаЗадачи)
	
	ФормаДокумента = Документы.УвольнениеИзОрганизаций.ПолучитьФормуНовогоДокумента(, , ОбъектЗадачи);
	ФормаДокумента.Заполнить(ОбъектЗадачи);
	ФормаДокумента.Организация	= ОбъектЗадачи.Организация;
	
	ФормаДокумента.Открыть();
	
КонецПроцедуры
