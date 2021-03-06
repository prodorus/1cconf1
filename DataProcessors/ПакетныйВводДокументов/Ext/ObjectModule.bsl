#Если Клиент Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// описание типов переменных
Перем мОписаниеТиповСтрока          Экспорт;
Перем мОписаниеТиповБулево          Экспорт;
Перем мОписаниеТиповТаблицаЗначений Экспорт;
Перем мОписаниеТиповЗначенийФильтра Экспорт;
Перем мПоказыватьКод                Экспорт;
Перем мПоказыватьАртикул            Экспорт;

Перем мТаблицаФильтры          Экспорт; // Все возможные фильтры
Перем мСтруктураТиповФильтров  Экспорт; // Структура, содержащая допустимые типы фильтров
Перем мТипФильтраПоУмолчанию   Экспорт; // Значение типа фильтра по умолчанию

Перем мВалютаРегламентированногоУчета Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Заполняет таблицу фильтров в зависимости от выбранного объекта обработки
//
// Параметры: 
//	ИмяОбласти - имя области макета "ПараметрыФильтров" откуда будут
//               считаны возможные фильтры и их параметры
//	ВосстановлениеНастройки - булево, признак открытия с восстановлением настройки
//
Процедура ЗаполнитьНачальныеНастройки(ВосстановлениеНастройки = Ложь) Экспорт
	Перем ТипОбъекта;
	Перем ВысотаТаб;
	Перем Область;
	Перем МассивТипов;
	Перем ИмяПоляЗапроса;
	Перем Индекс;
	Перем Массив;
	Перем Макет;

	мТаблицаФильтры.Очистить();
	МассивТипов = Новый Массив;

	Макет     = ПолучитьМакет("ПараметрыФильтров");
	Область   = Макет.ПолучитьОбласть("Номенклатура");
	ВысотаТаб = Область.ВысотаТаблицы;

	МассивКатегории = Новый Массив;
	МассивКатегории.Добавить(Тип("СправочникСсылка.КатегорииОбъектов"));
	ОписаниеТиповКатегории = Новый ОписаниеТипов(МассивКатегории);
	МассивНазначений = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.Текст = "";
    Индекс = -1;
	ИмяПоляЗапроса = "";
	
	Для К = 1 По ВысотаТаб Цикл
		СтрНазначение = СокрЛП(Область.Область(К, 10).Текст);

		Если ПустаяСтрока( СтрНазначение) Тогда
			СтрФильтры = мТаблицаФильтры.Добавить();
			СтрФильтры.ИмяПоля           = СокрЛП( Область.Область(К, 1).Текст);
			СтрФильтры.ОписаниеПоля      = СокрЛП( Область.Область(К, 2).Текст);
			СтрФильтры.ПредставлениеПоля = СокрЛП( Область.Область(К, 3).Текст);
			СтрФильтры.ВклПоУмолчанию    = Булево( СокрЛП( Область.Область(К, 5).Текст));
			СтрФильтры.ИмяПоляВладелец   = СокрЛП( Область.Область(К, 6).Текст);
			СтрФильтры.ИмяПоляЗапроса    = СокрЛП( Область.Область(К, 7).Текст);

			Массив = Новый Массив;
			Массив.Добавить( Тип( СокрЛП( Область.Область(К, 2).Текст)));
			МассивТипов.Добавить(Массив[0]);
			СтрФильтры.ОписаниеТипов = Новый ОписаниеТипов(Массив);
		КонецЕсли;
	
		// Фильтры по значениям свойств
		//
		Индекс = Индекс + 1;

		Если Не ПустаяСтрока(СтрНазначение) Тогда
			Назначение = ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов[Лев(СтрНазначение, Найти(СтрНазначение+",", ",")-1)];
		Иначе
			Назначение = Неопределено;
		КонецЕсли;

		МассивНазначений.Добавить(Назначение);

		Если Назначение <> Неопределено Тогда

			Запрос.УстановитьПараметр("ИмяПоля"           + Индекс, СокрЛП( Область.Область(К, 1).Текст));
			Запрос.УстановитьПараметр("ОписаниеПоля"      + Индекс, СокрЛП( Область.Область(К, 2).Текст));
			Запрос.УстановитьПараметр("ПредставлениеПоля" + Индекс, СокрЛП( Область.Область(К, 3).Текст));
			Запрос.УстановитьПараметр("Назначение"        + Индекс, МассивНазначений[Индекс]);

			Запрос.Текст = Запрос.Текст + "
			|ОБЪЕДИНИТЬ ВСЕ 
			|ВЫБРАТЬ 
			|	&ИмяПоля"           + Индекс + " КАК ИмяПоля,
			|	&ОписаниеПоля"      + Индекс + " КАК ОписаниеПоля,
			|	&ПредставлениеПоля" + Индекс + " КАК ПредставлениеПоля,
			|	ПланВидовХарактеристик.СвойстваОбъектов.Представление КАК ПредставлениеСвойства,
			|	ПланВидовХарактеристик.СвойстваОбъектов.Ссылка  КАК Ссылка
			|
			|ИЗ
			|	ПланВидовХарактеристик.СвойстваОбъектов
			|
			|ГДЕ
			|	ПланВидовХарактеристик.СвойстваОбъектов.НазначениеСвойства = &Назначение"+Индекс;
			
			ИмяПоляЗапроса = СокрЛП( Область.Область(К, 7).Текст);
			
		КонецЕсли;
		
	КонецЦикла;

	Запрос.Текст = Сред(Запрос.Текст, 16); // Удаляем первое ОБЪЕДИНИТЬ ВСЕ
	
	// Добавим в таблицу фильтров
	Если Не ПустаяСтрока(Запрос.Текст) Тогда
		
		Состояние("Получение списка свойств");
		ТаблицаСвойств = Запрос.Выполнить().Выгрузить();
		
		Для Каждого Строка Из ТаблицаСвойств Цикл
			Индекс = ТаблицаСвойств.Индекс(Строка);

			СтрФильтры = мТаблицаФильтры.Добавить();
			СтрФильтры.ИмяПоля           = "Свойство" + Индекс;
			СтрФильтры.ПредставлениеПоля = СокрЛП(Строка.ПредставлениеСвойства)+" ("+НРег(СокрЛП(Строка.ПредставлениеПоля)) +")";
			СтрФильтры.ОписаниеПоля      = СокрЛП(Строка.ОписаниеПоля) + ".Свойство"+Индекс+".Значение";
			СтрФильтры.ВклПоУмолчанию    = Ложь;
			СтрФильтры.Свойство 		 = Строка.Ссылка;
			СтрФильтры.ИмяПоляЗапроса    = ИмяПоляЗапроса;

			Если ПустаяСтрока(СтрФильтры.ОписаниеПоля) Тогда
				СтрФильтры.ОписаниеПоля = СтрФильтры.ИмяПоля;
			КонецЕсли;

			СтрФильтры.ОписаниеТипов   = Строка.Ссылка.ТипЗначения;
			СтрФильтры.ИмяПоляВладелец = "";
		КонецЦикла;
	КонецЕсли;
	
	Состояние("");

	МассивТипов.Добавить(Тип("Строка"));
	КвалификаторСтроки = Новый КвалификаторыСтроки(100);
	
	МассивТипов.Добавить(Тип("Число"));
	КвалификаторЧисла  = Новый КвалификаторыЧисла(5, 2);

	МассивТипов.Добавить(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"));
	
	мОписаниеТиповЗначенийФильтра = Новый ОписаниеТипов(МассивТипов, КвалификаторЧисла, КвалификаторСтроки);
	
	Если Не ВосстановлениеНастройки Тогда
		ФильтрыОтчета.Очистить();
	КонецЕсли;	

КонецПроцедуры // ЗаполнитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мТаблицаФильтры = Новый ТаблицаЗначений;

МассивСтрока = Новый Массив;
МассивСтрока.Добавить(Тип("Строка"));
КвалификаторСтроки   = Новый КвалификаторыСтроки(100);
мОписаниеТиповСтрока = Новый ОписаниеТипов(МассивСтрока, , КвалификаторСтроки);

МассивЧисло  = Новый Массив;
МассивЧисло.Добавить(Тип("Число"));
КвалификаторЧисла    = Новый КвалификаторыЧисла(1,0);
ОписаниеТиповЧисло   = Новый ОписаниеТипов(МассивЧисло, КвалификаторЧисла);

МассивБулево = Новый Массив;
МассивБулево.Добавить(Тип("Булево"));
мОписаниеТиповБулево = Новый ОписаниеТипов(МассивБулево);

МассивТаблицаЗначений = Новый Массив;
МассивТаблицаЗначений.Добавить(Тип("ТаблицаЗначений"));
мОписаниеТиповТаблицаЗначений = Новый ОписаниеТипов(МассивТаблицаЗначений);

МассивОписаниеТипов = Новый Массив;
МассивОписаниеТипов.Добавить(Тип("ОписаниеТипов"));
ОписаниеТиповОписаниеТипов = Новый ОписаниеТипов(МассивОписаниеТипов);

МассивСвойство = Новый Массив;
МассивСвойство.Добавить(Тип("ПланВидовХарактеристикСсылка.СвойстваОбъектов"));
МассивСвойство.Добавить(Тип("ПланВидовХарактеристикСсылка.НазначенияСвойствКатегорийОбъектов"));
ОписаниеТиповСвойство = Новый ОписаниеТипов(МассивСвойство);

// Инициализация таблиц всех возможных показателей, группировок,  фильтров
мТаблицаФильтры.Колонки.Добавить("ИмяПоля",           мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("ПредставлениеПоля", мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("ОписаниеПоля",      мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("ИмяПоляВладелец",   мОписаниеТиповСтрока);
мТаблицаФильтры.Колонки.Добавить("ВклПоУмолчанию",    мОписаниеТиповБулево);
мТаблицаФильтры.Колонки.Добавить("Пометка",           мОписаниеТиповБулево);
мТаблицаФильтры.Колонки.Добавить("ОписаниеТипов",     ОписаниеТиповОписаниеТипов);
мТаблицаФильтры.Колонки.Добавить("Свойство",          ОписаниеТиповСвойство);
мТаблицаФильтры.Колонки.Добавить("ИмяПоляЗапроса",    мОписаниеТиповСтрока);

// Инициализация структуры типов фильтров. В ней содержатся все типы фильтров
мСтруктураТиповФильтров = Новый Структура;
мСтруктураТиповФильтров.Вставить("ОдноИз",   "Одно из:");
мСтруктураТиповФильтров.Вставить("ВсеИз",    "Все из:"); // Используется только для категорий.
мСтруктураТиповФильтров.Вставить("ВсеКроме", "Все, кроме:");

мТипФильтраПоУмолчанию = "ОдноИз";

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

#КонецЕсли
