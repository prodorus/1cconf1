
//#Область ПрограммныйИнтерфейс

// В процедуре нужно заполнить реквизиты переданных контрагентов для отображения в отчете "Информация об организации ЕГАИС".
//
// Параметры:
//  СоответствиеРеквизитовКонтрагентам - Соответствие - соответствие для заполнения.
//    * Ключ - ссылка на контрагента,
//    * Значение - заполненная структура значений.
//  СписокКонтрагентов - Массив - массив контрагентов, выводимых в отчет,
//  Реквизиты - Структура - ключ - имя реквизита, значение - значение, которое нужно заполнить:
//    * ТипОрганизации - ПеречислениеСсылка.ТипыОрганизацийЕГАИС
//    * Наименование - Строка
//    * НаименованиеПолное - Строка
//    * ИНН - Строка
//    * КПП - Строка
//    * КодСтраны - Число
//    * КодРегиона - Число
//    * ПочтовыйИндекс - Число
//    * Адрес - Строка.
//
Процедура ЗаполнитьРеквизитыКонтрагентов(СоответствиеРеквизитовКонтрагентам, СписокКонтрагентов, Реквизиты) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СписокКонтрагентов", СписокКонтрагентов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Контрагенты.НеЯвляетсяРезидентом
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЕГАИС.ИностранныйКонтрагент)
	|		КОГДА Контрагенты.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЕГАИС.ИндивидуальныйПредпринимательРФ)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыОрганизацийЕГАИС.ЮридическоеЛицоРФ)
	|	КОНЕЦ КАК ТипОрганизации,
	|	Контрагенты.Наименование КАК Наименование,
	|	Контрагенты.НаименованиеПолное КАК НаименованиеПолное,
	|	Контрагенты.ИНН КАК ИНН,
	|	Контрагенты.КПП КАК КПП,
	|	Контрагенты.Ссылка КАК Ссылка,
	|	КонтактнаяИнформация.Представление КАК ЗначенияПолей,
	|	КонтактнаяИнформация.Поле1 КАК Поле1,
	|	Контрагенты.Регион.КодРегиона КАК КодРегиона
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|		ПО (КонтактнаяИнформация.Объект = Контрагенты.Ссылка)
	|			И (КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Адрес))
	|			И (КонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ФактАдресКонтрагента))
	|ГДЕ
	|	Контрагенты.Ссылка В(&СписокКонтрагентов)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ЗначенияРеквизитов = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Реквизиты);
		ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, Выборка);
		
		Если ЗначениеЗаполнено(Выборка.ЗначенияПолей) Тогда
			
			Если Выборка.ТипОрганизации = Перечисления.ТипыОрганизацийЕГАИС.ИностранныйКонтрагент Тогда
				
				ЗапросСтрана = Новый Запрос;
				ЗапросСтрана.Текст =
				"ВЫБРАТЬ
				|	КлассификаторСтранМира.Код
				|ИЗ
				|	Справочник.КлассификаторСтранМира КАК КлассификаторСтранМира
				|ГДЕ
				|	КлассификаторСтранМира.Наименование = &Наименование";
				
				ЗапросСтрана.УстановитьПараметр("Наименование", Выборка.Поле1);
				
				ВыборкаСтрана = ЗапросСтрана.Выполнить().Выбрать();
				Если ВыборкаСтрана.Следующий() Тогда
					ЗначенияРеквизитов.КодСтраны  = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ВыборкаСтрана.Код);
				КонецЕсли;
				
			Иначе
				ЗначенияРеквизитов.КодСтраны  = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Справочники.КлассификаторСтранМира.Россия.Код);
			КонецЕсли;
			
			ЗначенияРеквизитов.КодРегиона     = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Выборка.КодРегиона);
			ЗначенияРеквизитов.ПочтовыйИндекс = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(Выборка.Поле1);
			ЗначенияРеквизитов.Адрес          = Выборка.ЗначенияПолей;
			
		КонецЕсли;
		
		СоответствиеРеквизитовКонтрагентам.Вставить(Выборка.Ссылка, ЗначенияРеквизитов);
		
	КонецЦикла;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// В процедуре нужно заполнить таблицу продаж по переданным параметрам для отчета "Обработанные чеки ЕГАИС".
//
// Параметры:
//  ТаблицаПродаж - ТаблицаЗначений - таблица, которую требуется заполнить. Колонки:
//    * Период - Дата
//    * ОрганизацияЕГАИС - СправочникСсылка.КлассификаторОрганизацийЕГАИС
//    * АлкогольнаяПродукция - СправочникСсылка.КлассификаторАлкогольнойПродукцииЕГАИС
//    * ЧековПродаж - Число
//    * ЧековНаВозврат - Число
//
Процедура ЗаполнитьКоличествоЧековПродаж(ТаблицаПродаж) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаПродаж", ТаблицаПродаж);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПродаж.Период КАК Период,
	|	ВЫРАЗИТЬ(ТаблицаПродаж.ОрганизацияЕГАИС КАК Справочник.КлассификаторОрганизацийЕГАИС) КАК ОрганизацияЕГАИС,
	|	ВЫРАЗИТЬ(ТаблицаПродаж.АлкогольнаяПродукция КАК Справочник.КлассификаторАлкогольнойПродукцииЕГАИС) КАК АлкогольнаяПродукция
	|ПОМЕСТИТЬ ВТ_ТаблицаПродаж
	|ИЗ
	|	&ТаблицаПродаж КАК ТаблицаПродаж
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПродаж.Период КАК Период,
	|	ТаблицаПродаж.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ТаблицаПродаж.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаПродаж.ОрганизацияЕГАИС.Контрагент КАК Организация,
	|	ТаблицаПродаж.ОрганизацияЕГАИС.ТорговыйОбъект КАК Склад
	|ПОМЕСТИТЬ ТаблицаПродаж
	|ИЗ
	|	ВТ_ТаблицаПродаж КАК ТаблицаПродаж
	|ГДЕ
	|	ТаблицаПродаж.ОрганизацияЕГАИС.Сопоставлено
	|	И ТаблицаПродаж.ОрганизацияЕГАИС.СоответствуетОрганизации
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Склад,
	|	АлкогольнаяПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЧекККМ.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ СписокЧековПродаж
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|		ПО (ЕГАИСПрисоединенныеФайлы.Документ = ЧекККМ.Ссылка)
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(ЧекККМ.Дата, МЕСЯЦ) В
	|			(ВЫБРАТЬ
	|				ТаблицаПродаж.Период
	|			ИЗ
	|				ТаблицаПродаж КАК ТаблицаПродаж)
	|	И ЧекККМ.ЧекПробитНаККМ
	|	И НЕ ЕГАИСПрисоединенныеФайлы.Ссылка ЕСТЬ NULL 
	|	И ЧекККМ.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЧекККМ.Продажа)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПродаж.Период КАК Период,
	|	ТаблицаПродаж.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ТаблицаПродаж.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЧекККМТовары.Ссылка) КАК ЧековПродаж
	|ПОМЕСТИТЬ Продажи
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК ЧекККМТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПродаж КАК ТаблицаПродаж
	|		ПО ЧекККМТовары.Ссылка.Организация = ТаблицаПродаж.Организация
	|			И ЧекККМТовары.Ссылка.Склад = ТаблицаПродаж.Склад
	|			И ЧекККМТовары.НоменклатураЕГАИС = ТаблицаПродаж.АлкогольнаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокЧековПродаж КАК СписокЧековПродаж
	|		ПО ЧекККМТовары.Ссылка = СписокЧековПродаж.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПродаж.Период,
	|	ТаблицаПродаж.ОрганизацияЕГАИС,
	|	ТаблицаПродаж.АлкогольнаяПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЧекККМВозврат.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ СписокЧековНаВозврат
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМВозврат
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|		ПО (ЕГАИСПрисоединенныеФайлы.Документ = ЧекККМВозврат.Ссылка)
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(ЧекККМВозврат.Дата, МЕСЯЦ) В
	|			(ВЫБРАТЬ
	|				ТаблицаПродаж.Период
	|			ИЗ
	|				ТаблицаПродаж КАК ТаблицаПродаж)
	|	И ЧекККМВозврат.ЧекПробитНаККМ
	|	И НЕ ЕГАИСПрисоединенныеФайлы.Ссылка ЕСТЬ NULL 
	|	И ЧекККМВозврат.ВидОперации = ЗНАЧЕНИЕ(Перечисление.ВидыОперацийЧекККМ.Возврат)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПродаж.Период КАК Период,
	|	ТаблицаПродаж.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ТаблицаПродаж.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЧекККМВозвратТовары.Ссылка) КАК ЧековНаВозврат
	|ПОМЕСТИТЬ Возвраты
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК ЧекККМВозвратТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПродаж КАК ТаблицаПродаж
	|		ПО ЧекККМВозвратТовары.Ссылка.Организация = ТаблицаПродаж.Организация
	|			И ЧекККМВозвратТовары.Ссылка.Склад = ТаблицаПродаж.Склад
	|			И ЧекККМВозвратТовары.НоменклатураЕГАИС = ТаблицаПродаж.АлкогольнаяПродукция
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокЧековНаВозврат КАК СписокЧековНаВозврат
	|		ПО ЧекККМВозвратТовары.Ссылка = СписокЧековНаВозврат.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПродаж.Период,
	|	ТаблицаПродаж.ОрганизацияЕГАИС,
	|	ТаблицаПродаж.АлкогольнаяПродукция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Период КАК Период,
	|	ВложенныйЗапрос.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	ВложенныйЗапрос.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	СУММА(ВложенныйЗапрос.ЧековПродаж) КАК ЧековПродаж,
	|	СУММА(ВложенныйЗапрос.ЧековНаВозврат) КАК ЧековНаВозврат
	|ИЗ
	|	(ВЫБРАТЬ
	|		Продажи.Период КАК Период,
	|		Продажи.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|		Продажи.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|		Продажи.ЧековПродаж КАК ЧековПродаж,
	|		0 КАК ЧековНаВозврат
	|	ИЗ
	|		Продажи КАК Продажи
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Возвраты.Период,
	|		Возвраты.ОрганизацияЕГАИС,
	|		Возвраты.АлкогольнаяПродукция,
	|		0,
	|		Возвраты.ЧековНаВозврат
	|	ИЗ
	|		Возвраты КАК Возвраты) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.ОрганизацияЕГАИС,
	|	ВложенныйЗапрос.АлкогольнаяПродукция";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Период", Выборка.Период);
		ПараметрыОтбора.Вставить("ОрганизацияЕГАИС", Выборка.ОрганизацияЕГАИС);
		ПараметрыОтбора.Вставить("АлкогольнаяПродукция", Выборка.АлкогольнаяПродукция);
		
		МассивСтрок = ТаблицаПродаж.НайтиСтроки(ПараметрыОтбора);
		Для Каждого СтрокаТаблицы Из МассивСтрок Цикл
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
		КонецЦикла;
	КонецЦикла;
	//-- НЕ ГОСИС
	
КонецПроцедуры

//#КонецОбласти
