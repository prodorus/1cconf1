//////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ

// Данная процедура пополняет состав одной таблицы значений данными из другой.
//
// Аргументы:
//	ТаблицаПриемник		- пополняемая таблица
//	ТаблицаИсточник 	- таблица-источник данных. Если не указана - создается новая. 
//						Если не содержит колонок - создаются колонки как в источнике.
//	СПозиции 			- номер строки пополняемой таблицы, с которой производится добавление
//	НомерСтрокиИсточника - если указан номер строки таблимцы-источника
//						- добавляется данные только из нее
//
//
Процедура ДополнитьТаблицу(ТаблицаПриемник, ТаблицаИсточник, СПозиции = -1, НомерСтрокиИсточника = -1) Экспорт

	Если ТипЗнч(ТаблицаПриемник) <> Тип("ТаблицаЗначений") И ТипЗнч(ТаблицаПриемник) <> Тип("КоллекцияСтрокДереваЗначений") Тогда
		
		ТаблицаПриемник = Новый ТаблицаЗначений;
		
	КонецЕсли;
		
	Если ТипЗнч(ТаблицаПриемник) = Тип("ТаблицаЗначений") Тогда
		
		Если ТаблицаПриемник.Колонки.Количество() = 0 Тогда
			
			Если НомерСтрокиИсточника < 0 Тогда
				
				ТаблицаПриемник = ТаблицаИсточник.Скопировать();
				Возврат;
				
			Иначе
				
				Для каждого Колонка из ТаблицаИсточник.Колонки Цикл
					
					ТаблицаПриемник.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Если НомерСтрокиИсточника < 0 Тогда
		
		Для каждого СтрокаИсточник из ТаблицаИсточник Цикл
			
			// добавить (вставить) строку
			Если СПозиции < 0 Тогда
				
				НоваяСтрокаПриемник = ТаблицаПриемник.Добавить();
				
			Иначе
				
				НоваяСтрокаПриемник = ТаблицаПриемник.Вставить(СПозиции + ТаблицаИсточник.Индекс(СтрокаИсточник));
				
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(НоваяСтрокаПриемник, СтрокаИсточник);
			
		КонецЦикла;
			
	Иначе
		
		// добавить (вставить) строку
		Если СПозиции < 0 Тогда
			
			НоваяСтрокаПриемник = ТаблицаПриемник.Добавить();
			
		Иначе
			
			НоваяСтрокаПриемник = ТаблицаПриемник.Вставить(СПозиции);
			
		КонецЕсли;

		ЗаполнитьЗначенияСвойств(НоваяСтрокаПриемник, ТаблицаИсточник[НомерСтрокиИсточника]);
		
	КонецЕсли;
	
КонецПроцедуры // ДополнитьТаблицу()

// Данная функция определяет, возможна ли предполагаемая корректировка
// плановых данны исходня из того, попадает ли корректировка в закрытые даты
//
// Аргументы:
//	аргВидПланирования - 
//	аргПодразделение (необязательный) - . 
//				Значение по умолчанию - пустое подразделение.
//	аргПроект (необязательный) - 
//				Значение по умолчанию - пустой проект.
//	аргСценарий (необязательный) - 
//				Значение по умолчанию - пустой сценарий.
//	аргДатаЛимита (необязательный) - 
//				Значение по умолчанию - пустая дата ('00010101000000').
//
//
// Возвращаемое значение:
//  Дата, являющаяся границей фиксации периодов
//
Функция ПолучитьГраницуФиксацииПериодов(ВидПланирования, Подразделение = Неопределено, Проект = Неопределено, Сценарий = Неопределено, ДатаЛимита = '00010101') Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ГраницыПериодовПланирования.ГраницаФиксации КАК ГраницаФиксации
	|ИЗ
	|	РегистрСведений.ГраницыПериодовПланирования КАК ГраницыПериодовПланирования
	|ГДЕ
	|	ГраницыПериодовПланирования.ВидПланирования = &ВидПланирования
	|	И ГраницыПериодовПланирования.Подразделение В (&Подразделение, ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка))
	|	И ГраницыПериодовПланирования.Проект В (&Проект, ЗНАЧЕНИЕ(Справочник.Проекты.ПустаяСсылка))
	|	И ГраницыПериодовПланирования.Сценарий В (&Сценарий, ЗНАЧЕНИЕ(Справочник.СценарииПланирования.ПустаяСсылка))
	|	И ГраницыПериодовПланирования.ГраницаФиксации > &ДатаПланирования
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГраницаФиксации УБЫВ");

	Запрос.УстановитьПараметр("ВидПланирования", ВидПланирования);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Проект", Проект);
	Запрос.УстановитьПараметр("Сценарий", Сценарий);
	Запрос.УстановитьПараметр("ДатаПланирования", ДатаЛимита);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ГраницаФиксации;
		
	Иначе
		
		Возврат ДатаЛимита;
		
	КонецЕсли; 
	
КонецФункции // ПолучитьГраницуФиксацииПериодов()

//////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ РАБОТЫ С ПЕРИОДАМИ

// Выравнивает дату по началу периода.
//
// Параметры:
//  ДатаПланирования  - выравниваемая дата
//  Периодичность     - тип интервала для выравнивания
//  НазваниеДаты 	  - наименование вида даты для вывода сообщения
//  ВыводитьСообщение - признак необходимости вывода сообщения о выравнивании
//
Процедура ВыровнятьДатуПоНачалуПериода(ДатаПланирования, Периодичность, НазваниеДаты = "Дата начала периода ", ВыводитьСообщение=Ложь) Экспорт

	ДатаИзменена = Ложь;
	ДатаНачПериода = ДатаПланирования;
	ВыровнятьПериод(ДатаНачПериода,, Периодичность);
	
	Если ДатаПланирования <> ДатаНачПериода Тогда
		
		ДатаПланирования = ДатаНачПериода;
		ДатаИзменена = Истина;
		
	КонецЕсли;
	
	Если ВыводитьСообщение и ДатаИзменена Тогда
		
		ОбщегоНазначения.СообщитьОбОшибке(НазваниеДаты + "изменена в соответствии с установленной периодичностью.");
		
	КонецЕсли;

КонецПроцедуры // ВыровнятьДатуПоНачалуПериода()

// Выравнивает дату по окончанию периода.
//
// Параметры:
//  ДатаПланирования  - выравниваемая дата
//  Периодичность     - тип интервала для выравнивания
//  НазваниеДаты 	  - наименование вида даты для вывода сообщения
//  ВыводитьСообщение - признак необходимости вывода сообщения о выравнивании
//
Процедура ВыровнятьДатуПоКонцуПериода(ДатаПланирования, Периодичность, НазваниеДаты = "Дата окончания периода ", ВыводитьСообщение = Ложь) Экспорт
	
	ДатаИзменена = Ложь;
	ДатаКонПериода = ДатаПланирования;
	ВыровнятьПериод(, ДатаКонПериода, Периодичность);
	
	Если ДатаПланирования <> ДатаКонПериода Тогда
		
		ДатаПланирования = ДатаКонПериода;
		ДатаИзменена = Истина;
		
	КонецЕсли;
	
	Если ВыводитьСообщение и ДатаИзменена Тогда
		
		ОбщегоНазначения.СообщитьОбОшибке(НазваниеДаты + "изменена в соответствии с установленной периодичностью.");
		
	КонецЕсли;

КонецПроцедуры // ВыровнятьДатуПоКонцуПериода()

// Процедура выравнивает начальнаю и конечную даты по границам указанной периодичности
// 		ДатаНачПериода - дата, которую нужно выровнять по началу указанной периодичностью
// 		ДатаКонПериода - дата, которую нужно выровнять по окончанию указанной периодичностью
// 		Периодичность - периодичность, определяющая границы выравнивания
// 
Процедура ВыровнятьПериод(ДатаНачПериода = Неопределено, ДатаКонПериода = Неопределено, Периодичность = Неопределено) Экспорт
	
	Если ТипЗнч(Периодичность) <> Тип("ПеречислениеСсылка.Периодичность") ИЛИ Периодичность = Перечисления.Периодичность.ПустаяСсылка() Тогда
		
		ТекущаяПериодичность = Перечисления.Периодичность.День;
		
	Иначе
		
		ТекущаяПериодичность = Периодичность;
		
	КонецЕсли;
	
	СтрокаТекущаяПериодичность = ОбщегоНазначения.ИмяЗначенияПеречисления(ТекущаяПериодичность);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(&ДатаНач, " + СтрокаТекущаяПериодичность + ") КАК ДатаНач,
	|	КОНЕЦПЕРИОДА(&ДатаКон, " + СтрокаТекущаяПериодичность + ") КАК ДатаКон");
	
	Запрос.УстановитьПараметр("ДатаНач", ?(ТипЗнч(ДатаНачПериода) <> Тип("Дата"), Дата('00010101'), ДатаНачПериода));
	Запрос.УстановитьПараметр("ДатаКон", ?(ТипЗнч(ДатаКонПериода) <> Тип("Дата"), Дата('00010101'), ДатаКонПериода));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДатаНачПериода = Выборка.ДатаНач;
	ДатаКонПериода = Выборка.ДатаКон;
	
КонецПроцедуры // ВыровнятьПериод()

//////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ НОРМАТИВНОЙ СИСТЕМЫ

// Функция определяет возможные аналоги для переданной таблицы номенклатуры.
//
Функция ПолучитьАналогиНоменклатуры(Знач ТабНоменклатуры, ВозвращатьУзлы = Ложь) Экспорт
	
	ПустаяНоменклатура 	 = Справочники.Номенклатура.ПустаяСсылка();
	ПустаяХарактеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	ПустаяСпецификация 	 = Справочники.СпецификацииНоменклатуры.ПустаяСсылка();
	
	ТаблицаАналоги = Новый ТаблицаЗначений;
	ТаблицаАналоги.Колонки.Добавить("Номенклатура");
	ТаблицаАналоги.Колонки.Добавить("ХарактеристикаНоменклатуры");
	ТаблицаАналоги.Колонки.Добавить("ЕдиницаИзмерения");
	ТаблицаАналоги.Колонки.Добавить("Количество");
	ТаблицаАналоги.Колонки.Добавить("Приоритет");
	ТаблицаАналоги.Колонки.Добавить("Аналог");
	ТаблицаАналоги.Колонки.Добавить("ХарактеристикаАналога");
	ТаблицаАналоги.Колонки.Добавить("КоличествоАналога");
	ТаблицаАналоги.Колонки.Добавить("ЕдиницаИзмеренияАналога");
	
	Для Каждого Строка Из ТабНоменклатуры Цикл
		
		ТекстЗапроса = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АналогиНоменклатуры.Приоритет,
		|	АналогиНоменклатуры.ВидАналога,
		|	АналогиНоменклатуры.Аналог,
		|	АналогиНоменклатуры.ХарактеристикаАналога,
		|	АналогиНоменклатуры.ЕдиницаИзмеренияАналога,
		|	(&Количество * &Коэффициент /
		|		(ВЫБОР КОГДА АналогиНоменклатуры.ЕдиницаИзмерения ЕСТЬ NULL ИЛИ
		|					 АналогиНоменклатуры.ЕдиницаИзмерения.Коэффициент = 0
		|		ТОГДА
		|			1
		|		ИНАЧЕ
		|			АналогиНоменклатуры.ЕдиницаИзмерения.Коэффициент
		|		КОНЕЦ)*
		|		АналогиНоменклатуры.КоличествоАналога / АналогиНоменклатуры.Количество 
		|	)КАК КоличествоАналога
		|ИЗ
		|	РегистрСведений.АналогиНоменклатуры КАК АналогиНоменклатуры
		|
		|ГДЕ
		|	АналогиНоменклатуры.Номенклатура = &Номенклатура
		|	И (АналогиНоменклатуры.ХарактеристикаНоменклатуры = &ХарактеристикаНоменклатуры
		|	   ИЛИ АналогиНоменклатуры.ХарактеристикаНоменклатуры = &ПустаяХарактеристика)
		|	И (АналогиНоменклатуры.Продукция = &Продукция
		|	   ИЛИ АналогиНоменклатуры.Продукция = &ПустаяНоменклатура)
		|	И (АналогиНоменклатуры.ХарактеристикаПродукции = &ХарактеристикаПродукции
		|	   ИЛИ АналогиНоменклатуры.ХарактеристикаПродукции = &ПустаяХарактеристика)
		|	И (АналогиНоменклатуры.Спецификация = &Спецификация
		|	   ИЛИ АналогиНоменклатуры.Спецификация = &ПустаяСпецификация)
		|
		|УПОРЯДОЧИТЬ ПО
		|	АналогиНоменклатуры.Приоритет
		|";
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Номенклатура", 				Строка.Номенклатура);
		Запрос.УстановитьПараметр("ХарактеристикаНоменклатуры", Строка.ХарактеристикаНоменклатуры);
		Запрос.УстановитьПараметр("Количество", 				Строка.Количество);
		Запрос.УстановитьПараметр("Коэффициент", 				Строка.ЕдиницаИзмерения.Коэффициент);
		Запрос.УстановитьПараметр("Продукция", 					Строка.Продукция);
		Запрос.УстановитьПараметр("ХарактеристикаПродукции", 	Строка.ХарактеристикаПродукции);
		Запрос.УстановитьПараметр("Спецификация", 				Строка.Спецификация);
		Запрос.УстановитьПараметр("ПустаяНоменклатура", 		ПустаяНоменклатура);
		Запрос.УстановитьПараметр("ПустаяХарактеристика", 		ПустаяХарактеристика);
		Запрос.УстановитьПараметр("ПустаяСпецификация", 		ПустаяСпецификация);
		
		ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
		
		Для Каждого СтрокаЗапроса Из ТаблицаЗапроса Цикл
			
			Если СтрокаЗапроса.ВидАналога = Перечисления.ВидыАналогов.Узел И НЕ ВозвращатьУзлы Тогда
				Для каждого СтрокаУзла из СтрокаЗапроса.Аналог.ИсходныеКомплектующие Цикл
					
					НоваяСтрока = ТаблицаАналоги.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
					
					НоваяСтрока.Приоритет 				= СтрокаЗапроса.Приоритет;
					НоваяСтрока.Аналог 				  	= СтрокаУзла.Номенклатура;
					НоваяСтрока.ХарактеристикаАналога 	= СтрокаУзла.ХарактеристикаНоменклатуры;
					НоваяСтрока.ЕдиницаИзмеренияАналога = СтрокаУзла.ЕдиницаИзмерения;
					Если НЕ ЗначениеЗаполнено(СтрокаУзла.ЕдиницаИзмерения) или НЕ ЗначениеЗаполнено(СтрокаУзла.Номенклатура) Тогда
						НоваяСтрока.КоличествоАналога 	= СтрокаЗапроса.КоличествоАналога * СтрокаУзла.Количество;
					Иначе
						КоличествоАналога = СтрокаЗапроса.КоличествоАналога * СтрокаУзла.Количество * СтрокаУзла.ЕдиницаИзмерения.Коэффициент / СтрокаУзла.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент;
						НоваяСтрока.КоличествоАналога 	= КоличествоАналога;
					КонецЕсли;
				КонецЦикла;
			Иначе
				НоваяСтрока = ТаблицаАналоги.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЗапроса);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ТаблицаАналоги;
	
КонецФункции // ПолучитьАналогиНоменклатуры()

Функция КонтрольЗацикливанияПодчиненныхРабочихЦентров(РабочийЦентр, МассивРабочихЦентров = Неопределено) Экспорт
	
	Если МассивРабочихЦентров = Неопределено Тогда
		
		МассивРабочихЦентров = Новый Массив;
		
	КонецЕсли;
	
	// Проверяемые рабочие центры заносим в отдельный массив
	МассивРодителей = Новый Массив;
	
	Если ТипЗнч(РабочийЦентр) = Тип("СправочникСсылка.РабочиеЦентры") Тогда
		
		МассивРодителей.Добавить(РабочийЦентр);
		
	ИначеЕсли ТипЗнч(РабочийЦентр) = Тип("СправочникСсылка.ГруппыЗаменяемостиРабочихЦентров") Тогда
		
		Для Каждого СтрокаСостава Из РабочийЦентр.Состав Цикл
			
			МассивРодителей.Добавить(СтрокаСостава.РабочийЦентр);
			
		КонецЦикла;
		
		МассивРодителей.Добавить(РабочийЦентр);
		
	Иначе
		
		// Ошиблись типом при вызове
		Возврат Ложь;
		
	КонецЕсли;
	
	Результат = Ложь;
	
	Для Каждого РЦРодитель Из МассивРодителей Цикл
		
		Если МассивРабочихЦентров.Найти(РЦРодитель) = Неопределено Тогда
			
			МассивРабочихЦентров.Добавить(РЦРодитель);
			
			// Вызываем контроль зацикливания для всех подчиненных рабочих центров и групп заменямости рабочих центров
			Если РЦРодитель.ТребуетсяЗагрузкаПодчиненныхРабочихЦентров Тогда
				
				Для Каждого СтрокаПодчиненныхРЦ Из РЦРодитель.ПодчиненныеРабочиеЦентры Цикл
					
					Результат = Результат ИЛИ КонтрольЗацикливанияПодчиненныхРабочихЦентров(СтрокаПодчиненныхРЦ.РабочийЦентр, МассивРабочихЦентров);
					
				КонецЦикла;
				
			КонецЕсли;
			
		Иначе
			
			// Если проверяемый рабочий центр повторился в стуктуре подчинения - есть зацикливание
			ОбщегоНазначения.СообщитьОбОшибке("Рабочий центр/группа заменяемости: """ + РЦРодитель.Наименование + """",, "Зацикливание/дублирование в структуре подчиненных рабочих центров");
			Результат = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // КонтрольЗацикливанияПодчиненныхРабочихЦентров()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ РАБОТЫ С ПЛАНАМИ

// Процедура выполняет стандартные действия при начале выбора документа составного типа в формах документов.
//
// Параметры:
//  ДокументОбъект       - объект редактируемого документа;
//  ФормаДокумента       - форма редактируемого документа;
//  ЭлементФормы         - элемент формы документа, который надо заполнить; 
//  СтандартнаяОбработка - булево, признак выполнения стандартной (системной) обработки события 
//                         начала выбора для данного элемента формы документа.
//  СтруктураОтбора      - структура, содержащая имена и значения отборов в форме выбора.
//  ИмяТабличнойЧасти    - имя табличной части.
//  ДопПараметры         - структура с дополнительными параметрами.
//
Процедура НачалоВыбораДокументаПлан(ДокументОбъект, ФормаДокумента, ЭлементФормы, СтандартнаяОбработка, СтруктураОтбора = Неопределено, ИмяТабличнойЧасти, ДопПараметры = Неопределено, ИмяКолонки = Неопределено) Экспорт

	СтандартнаяОбработка = Ложь;

	// Заполним возможный список типов документов, которые могут быть в этом реквизите.
	СписокТипов = Новый СписокЗначений;

	Если ПустаяСтрока(ИмяТабличнойЧасти) Тогда // Шапка документа
		
		МассивТипов = ДокументОбъект.Метаданные().Реквизиты[ЭлементФормы.Данные].Тип.Типы();
		
	Иначе // Табличная часть
		
		Если ИмяКолонки = Неопределено Тогда
			
			ИмяКолонки  = ФормаДокумента.ЭлементыФормы[ИмяТабличнойЧасти].ТекущаяКолонка.Имя;
			
		КонецЕсли;
		
		МассивТипов = ДокументОбъект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Реквизиты[ИмяКолонки].Тип.Типы();
		
	КонецЕсли;
	
	МассивТиповИсключений = Новый Массив;
	
	Если Не ДопПараметры = Неопределено Тогда
		
		Если ДопПараметры.Свойство("ИсключаемыеТипы") Тогда
			
			МассивТиповИсключений = ДопПараметры["ИсключаемыеТипы"];
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для К = 0 По МассивТиповИсключений.ВГраница() Цикл
		
		Индекс = МассивТипов.ВГраница();
		
		Пока Индекс >= 0 Цикл
			
			Если МассивТиповИсключений[К] = МассивТипов[Индекс] Тогда
				
				МассивТипов.Удалить(Индекс);
				
			КонецЕсли;
			
			Индекс = Индекс - 1;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если МассивТипов.Количество() = 0 Тогда // Удалили все возможные типы
	
		Возврат; // Выбор невозможен
		
	ИначеЕсли МассивТипов.Количество() = 1 Тогда
	
		ОбъектОписанияМетаданных = Метаданные.НайтиПоТипу(МассивТипов[0]);
		ВыбранныйТип = ОбъектОписанияМетаданных.Имя;
		
	Иначе

		Для каждого ЭлементМассива Из МассивТипов Цикл
			
			ПустоеЗначение = Новый(ЭлементМассива);
			ОбъектОписанияМетаданных = ПустоеЗначение.Метаданные();
			СписокТипов.Добавить(ОбъектОписанияМетаданных.Имя, ОбъектОписанияМетаданных.Представление());
			
		КонецЦикла;

		ВыбранныйЭлемент = ФормаДокумента.ВыбратьИзСписка(СписокТипов, ЭлементФормы);

		Если ВыбранныйЭлемент = Неопределено Тогда // Отказ от выбора
			Возврат;
		КонецЕсли;

		ВыбранныйТип = ВыбранныйЭлемент.Значение;

	КонецЕсли;

	Если ТипЗнч(ЭлементФормы.Значение) <> Тип("ДокументСсылка." + ВыбранныйТип) Тогда
		
		ЭлементФормы.Значение = Документы[ВыбранныйТип].ПустаяСсылка();
		
	КонецЕсли;

	// В качестве владельца формы выбора устанавливаем данный элемент,
	// чтобы выбранное значение было присвоено стандартно.
	ФормаВыбора = Документы[ВыбранныйТип].ПолучитьФормуВыбора(,ЭлементФормы,);

	Если СтруктураОтбора <> Неопределено Тогда
		
		// Отфильтруем список документов.
		Для каждого ЭлементСтруктуры Из СтруктураОтбора Цикл
			
			Если ФормаВыбора.Отбор.Найти(ЭлементСтруктуры.Ключ) = Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			Если ТипЗнч(ЭлементСтруктуры.Значение) = Тип("СписокЗначений") Тогда
				
				ФормаВыбора.Отбор[ЭлементСтруктуры.Ключ].ВидСравнения = ВидСравнения.ВСписке;
				
			КонецЕсли;
			
			ФормаВыбора.Отбор[ЭлементСтруктуры.Ключ].Значение = ЭлементСтруктуры.Значение;
			ФормаВыбора.Отбор[ЭлементСтруктуры.Ключ].Использование = Истина;
			ФормаВыбора.ЭлементыФормы.ДокументСписок.НастройкаОтбора[ЭлементСтруктуры.Ключ].Доступность = Ложь;
			
		КонецЦикла;
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ЭлементФормы.Значение) Тогда
		
		ФормаВыбора.ПараметрТекущаяСтрока = ЭлементФормы.Значение;
		
	КонецЕсли;

	ФормаВыбора.Открыть();

КонецПроцедуры // НачалоВыбораДокументаПлан()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПРИВЕДЕНИЯ ЧИСЕЛ

Функция ПривестиКМинимальнойПартииКратности(Знач Значение, Знач МинимальнаяПартия, Знач Кратность, ВМеньшуюСторону = Ложь) Экспорт
	
	Кратность = ?(Кратность < 0, -Кратность, Кратность);
	МинимальнаяПартия = ?(МинимальнаяПартия < 0, -МинимальнаяПартия, МинимальнаяПартия);
	
	Если ВМеньшуюСторону Тогда
		
		Если Значение < МинимальнаяПартия Тогда
			
			Возврат 0;
			
		Иначе
			
			Возврат ?(Кратность = 0, Значение, Цел(?((Значение / Кратность) < 1, Кратность, Цел(Значение / Кратность) * Кратность) * 1000) / 1000);
			
		КонецЕсли;
		
	Иначе
		
		Значение = Макс(Значение, МинимальнаяПартия);
		Возврат ?(Кратность = 0, Значение, Цел(?((Значение / Кратность) < 1, Кратность, ?((Цел(Значение / Кратность) - Значение / Кратность) = 0, Значение, (Цел(Значение / Кратность) + 1) * Кратность)) * 1000) / 1000);
		
	КонецЕсли;
	
КонецФункции // ПривестиКМинимальнойПартииКратности()

Функция ОкруглитьВБольшуюСторону(Значение, Разрядность) Экспорт
	
	Множитель = Цел(Pow(10, Разрядность));
	
	// Если передано неверное (нецелое или < 0) значение разрядности, возвращается 0
	Если Множитель < 1 Тогда
		
		Возврат 0;
		
	КонецЕсли;
	
	Возврат (Цел(Значение * Множитель) + ?(Значение * Множитель - Цел(Значение * Множитель) > 0, 1, 0)) / Множитель;
	
КонецФункции // ОкруглитьВБольшуюСторону()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ДРОБЯМИ

Функция ПолучитьДробь(Знач Числитель, Знач Знаменатель, Сократить = Истина) Экспорт
	
	Если Сократить Тогда
		
		НаибольшийОбщийДелитель = ПолучитьНаибольшийОбщийДелитель(Числитель, Знаменатель);
		Возврат Новый Структура("Числитель, Знаменатель, Значение", Числитель / НаибольшийОбщийДелитель, Знаменатель / НаибольшийОбщийДелитель, ?(Знаменатель = 0, 0, Числитель / Знаменатель));
		
	Иначе
		
		Возврат Новый Структура("Числитель, Знаменатель, Значение", Числитель, Знаменатель, ?(Знаменатель = 0, 0, Числитель / Знаменатель));
		
	КонецЕсли;
	
КонецФункции // ПолучитьДробь()

Функция МинДробь(Дробь1, Дробь2) Экспорт
	
	Если Дробь1.Числитель * Дробь2.Знаменатель < Дробь2.Числитель * Дробь1.Знаменатель Тогда
		
		Возврат ПолучитьДробь(Дробь1.Числитель, Дробь1.Знаменатель);
		
	Иначе
		
		Возврат ПолучитьДробь(Дробь2.Числитель, Дробь2.Знаменатель);
		
	КонецЕсли;
	
КонецФункции // МинДробь()

Функция МаксДробь(Дробь1, Дробь2) Экспорт
	
	Если Дробь1.Числитель * Дробь2.Знаменатель > Дробь2.Числитель * Дробь1.Знаменатель Тогда
		
		Возврат ПолучитьДробь(Дробь1.Числитель, Дробь1.Знаменатель);
		
	Иначе
		
		Возврат ПолучитьДробь(Дробь2.Числитель, Дробь2.Знаменатель);
		
	КонецЕсли;
	
КонецФункции // МаксДробь()

Функция РазностьДробей(Дробь1, Дробь2) Экспорт
	
	Возврат ПолучитьДробь(Дробь1.Числитель * Дробь2.Знаменатель - Дробь2.Числитель * Дробь1.Знаменатель, Дробь1.Знаменатель * Дробь2.Знаменатель);
	
КонецФункции //РазностьДробей()

Функция СуммаДробей(Дробь1, Дробь2) Экспорт
	
	Возврат ПолучитьДробь(Дробь1.Числитель * Дробь2.Знаменатель + Дробь2.Числитель * Дробь1.Знаменатель, Дробь1.Знаменатель * Дробь2.Знаменатель);
	
КонецФункции //СуммаДробей()

Функция ПолучитьНаибольшийОбщийДелитель(Знач Числитель, Знач Знаменатель) Экспорт
	
	Если Числитель = 0 ИЛИ Знаменатель = 0 Тогда
		
		Возврат 1;
		
	КонецЕсли;

	Пока Знаменатель <> 0 Цикл
		
		ОстатокОтДеления = Числитель % Знаменатель;
		Числитель = Знаменатель;
		Знаменатель = ОстатокОтДеления;
		
	КонецЦикла;
	
	Возврат Числитель;

КонецФункции // ПолучитьНаибольшийОбщийДелитель()
