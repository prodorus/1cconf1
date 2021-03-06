
// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОценкаНезавершенногоПроизводства") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ОценкаНезавершенногоПроизводства",
			"Оценка незваершенного производства",
			ПечатьОценкаНезавершенногоПроизводства(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;

КонецПроцедуры

// Процедура формирует печатную форму "Оценка незавершенного производства"
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив - Массив ссылок на объекты которые нужно распечатать
// ИСХОДЯЩИЕ:
//   ОбъектыПечати   - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
// РЕЗУЛЬТАТ:
//	 ТабличныйДокумент
//
Функция ПечатьОценкаНезавершенногоПроизводства(МассивОбъектов, ОбъектыПечати)
	
	ТекстЗапросаШапка =
	"ВЫБРАТЬ
	|	ОценкаНЗП.Организация КАК Организация,
	|	ОценкаНЗП.Подразделение КАК Подразделение,
	|	ОценкаНЗП.Подразделение.Представление КАК ПодразделениеПредставление,
	|	ОценкаНЗП.Номер,
	|	ОценкаНЗП.Дата
	|ИЗ
	|	Документ.ОценкаНезавершенногоПроизводства КАК ОценкаНЗП
	|ГДЕ
	|	ОценкаНЗП.Ссылка = &Ссылка";
	
	ТекстЗапросаСостав =
	"ВЫБРАТЬ
	|	ОценкаНЗПСостав.НомерСтроки КАК НомерСтроки,
	|	ОценкаНЗПСостав.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	ОценкаНЗПСостав.НоменклатурнаяГруппа.Представление КАК НоменклатурнаяГруппаПредставление,
	|	ОценкаНЗПСостав.ДоляЗатрат КАК ДоляЗатрат
	|ИЗ
	|	Документ.ОценкаНезавершенногоПроизводства.Состав КАК ОценкаНЗПСостав
	|ГДЕ
	|	ОценкаНЗПСостав.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ТабДокумент  = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОценкаНезавершенногоПроизводства_ОценкаНЗП";
	Макет = ПолучитьМакет("ОценкаНЗП");
	
	ПервыйДокумент = Истина;
	
	Для Каждого Ссылка Из МассивОбъектов Цикл
		
		Если НЕ ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапросаШапка;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		// Вывод шапки
		ИнфоОрганизация = УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата);
		
		Область = Макет.ПолучитьОбласть("Шапка");
		Область.Параметры.ТекстЗаголовок   = ОбщегоНазначения.СформироватьЗаголовокДокумента(Ссылка);
		Область.Параметры.ПечОрганизация   = ИнфоОрганизация.ПолноеНаименование;
		Область.Параметры.ПечПодразделение = Шапка.ПодразделениеПредставление;
		Область.Параметры.Организация      = Шапка.Организация;
		Область.Параметры.Подразделение    = Шапка.Подразделение;
		
		ТабДокумент.Вывести(Область);
		
		// Вывод табличной части
		Область = Макет.ПолучитьОбласть("Заголовок");
		ТабДокумент.Вывести(Область);
		
		Запрос.Текст = ТекстЗапросаСостав;
		
		Состав  = Запрос.Выполнить().Выбрать();
		Область = Макет.ПолучитьОбласть("Строка");
		
		Пока Состав.Следующий() Цикл
			Область.Параметры.Заполнить(Состав);
			ТабДокумент.Вывести(Область);
		КонецЦикла;
		
		// Вывод подвала
		Область = Макет.ПолучитьОбласть("Подвал");
		ТабДокумент.Вывести( Область);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);

	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции


// Процедура помещает данные оценки НЗП в УУ во временную таблицу ОценкаНезавершенногоПроизводства
//
// ВХОДЯЩИЕ:
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц
//		Месяц - дата - месяц, за который выбираем документ оценки НЗП
//
Процедура ПоместитьДанныеДляУпрУчетаВоВременнуюТаблицу(МенеджерВременныхТаблиц, Месяц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОценкаНезавершенногоПроизводства.Ссылка.Подразделение КАК Подразделение,
	|	ОценкаНезавершенногоПроизводства.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	СРЕДНЕЕ(ОценкаНезавершенногоПроизводства.ДоляЗатрат) КАК ДоляЗатрат
	|ПОМЕСТИТЬ ОценкаНезавершенногоПроизводства
	|ИЗ
	|	Документ.ОценкаНезавершенногоПроизводства.Состав КАК ОценкаНезавершенногоПроизводства
	|ГДЕ
	|	ОценкаНезавершенногоПроизводства.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Месяц, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Месяц, МЕСЯЦ)
	|	И (НЕ ОценкаНезавершенногоПроизводства.Ссылка.ПометкаУдаления)
	|	И ОценкаНезавершенногоПроизводства.Ссылка.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ОценкаНезавершенногоПроизводства.НоменклатурнаяГруппа,
	|	ОценкаНезавершенногоПроизводства.Ссылка.Подразделение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	НоменклатурнаяГруппа";
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Месяц",       Месяц);
	
	Запрос.Выполнить();
	
КонецПроцедуры

// Процедура помещает данные оценки НЗП в БУ во временную таблицу ОценкаНезавершенногоПроизводства
//
// ВХОДЯЩИЕ:
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц
//		Месяц - дата - месяц, за который выбираем документ оценки НЗП
//		Организация - СправочникСсылка.Организации - организация для отбора документов оценки НЗП
//
Процедура ПоместитьДанныеДляРеглУчетаВоВременнуюТаблицу(МенеджерВременныхТаблиц, Организация, Месяц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОценкаНезавершенногоПроизводства.Ссылка.Подразделение КАК Подразделение,
	|	ОценкаНезавершенногоПроизводства.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	СРЕДНЕЕ(ОценкаНезавершенногоПроизводства.ДоляЗатрат) КАК ДоляЗатрат
	|ПОМЕСТИТЬ ДанныеДокументов
	|ИЗ
	|	Документ.ОценкаНезавершенногоПроизводства.Состав КАК ОценкаНезавершенногоПроизводства
	|ГДЕ
	|	ОценкаНезавершенногоПроизводства.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Месяц, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Месяц, МЕСЯЦ)
	|	И (НЕ ОценкаНезавершенногоПроизводства.Ссылка.ПометкаУдаления)
	|	И ОценкаНезавершенногоПроизводства.Ссылка.Организация = &Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	ОценкаНезавершенногоПроизводства.НоменклатурнаяГруппа,
	|	ОценкаНезавершенногоПроизводства.Ссылка.Подразделение
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СоответствиеПодразделенийИПодразделенийОрганизаций.ПодразделениеОрганизации КАК Подразделение,
	|	ОценкаНезавершенногоПроизводства.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	ОценкаНезавершенногоПроизводства.ДоляЗатрат
	|ПОМЕСТИТЬ ОценкаНезавершенногоПроизводства
	|ИЗ
	|	ДанныеДокументов КАК ОценкаНезавершенногоПроизводства
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеПодразделенийИПодразделенийОрганизаций КАК СоответствиеПодразделенийИПодразделенийОрганизаций
	|		ПО ОценкаНезавершенногоПроизводства.Подразделение = СоответствиеПодразделенийИПодразделенийОрганизаций.Подразделение
	|			И (СоответствиеПодразделенийИПодразделенийОрганизаций.Организация = &Организация)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	НоменклатурнаяГруппа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДанныеДокументов";
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Месяц",       Месяц);
	
	Запрос.Выполнить();
	
КонецПроцедуры

// В функции описано, какие данные следует сохранять в шаблоне
Функция СтруктураДополнительныхДанныхФормы() Экспорт
	
	Возврат ХранилищаНастроек.ДанныеФорм.СформироватьСтруктуруДополнительныхДанных("Состав");
	
КонецФункции
