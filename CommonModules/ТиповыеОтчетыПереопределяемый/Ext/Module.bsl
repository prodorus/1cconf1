Функция ПолучитьЗаголовокОтчетаПереопределяемая(ОтчетОбъект, ФормаОтчета = Неопределено) Экспорт
	
	Заголовок = "";
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		Если НЕ ЗначениеЗаполнено(ОтчетОбъект.ПроизвольныйОтчет) Тогда
			ЗаголовокОтчета = "<Проивзольный отчет не выбран>";
		Иначе	
			ЗаголовокОтчета = Строка(ОтчетОбъект.ПроизвольныйОтчет.ВидПроизвольногоОтчета) + ": ";
			ЗаголовокОтчета = ЗаголовокОтчета + ОтчетОбъект.ПроизвольныйОтчет.Наименование;
		КонецЕсли; 
	ИначеЕсли ТиповыеОтчеты.ЭтоСтараяВерсияОтчета(ОтчетОбъект) Тогда
		ЗаголовокОтчета = ОтчетОбъект.КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Title")).Значение;
	Иначе
		ЗаголовокОтчета = ОтчетОбъект.Метаданные().Синоним;
	КонецЕсли;
	
	Если ТиповыеОтчеты.ЭтоСтараяВерсияОтчета(ОтчетОбъект) Тогда
		Если ЗначениеЗаполнено(ОтчетОбъект.СохраненнаяНастройка) Тогда
			ТекстСохраненнаяНастройка = " (" + ОтчетОбъект.СохраненнаяНастройка + ")";
		Иначе
			ТекстСохраненнаяНастройка = "";
		КонецЕсли;
	Иначе
		Если ОтчетОбъект.СохраненнаяНастройка.Пустая() Тогда
			ТекстСохраненнаяНастройка = "";
		Иначе
			ТекстСохраненнаяНастройка = " [" + ОтчетОбъект.СохраненнаяНастройка + "]";
		КонецЕсли;
	КонецЕсли;
	
	Заголовок = ЗаголовокОтчета + ТекстСохраненнаяНастройка;
	
	Возврат Заголовок;
	
КонецФункции

Функция ПолучитьСхемуКомпоновкиОбъектаПереопределяемая(ОтчетОбъект) Экспорт
	
	Если ТипЗнч(ОтчетОбъект) = Тип("СправочникСсылка.ПроизвольныеОтчеты") Тогда
		СКД = ОтчетОбъект.СхемаКомпоновкиДанных.Получить();
	Иначе
		СКД = ОтчетОбъект.СхемаКомпоновкиДанных;
	КонецЕсли; 
	
	Возврат СКД;
	
КонецФункции

Функция ПолучитьИдентификаторОбъектаПереопределяемая(ОтчетОбъект) Экспорт
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		Возврат ОтчетОбъект.ПроизвольныйОтчет;
	Иначе
		Возврат "ОтчетОбъект." + ОтчетОбъект.Метаданные().Имя;
	КонецЕсли;
	
КонецФункции

Функция ЭтоСтараяВерсияОтчетаПереопределяемая(ОтчетОбъект) Экспорт
	
	Возврат Не ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) И (Найти(ТиповыеОтчеты.ПолучитьИдентификаторОбъекта(ОтчетОбъект), "ОтчетОбъект") = 0 ИЛИ (ОтчетОбъект.Метаданные().Реквизиты.Найти("НастройкаПериода") <> Неопределено));
	
КонецФункции

Функция ПолучитьПараметрыПанелиПользователяПоУмолчаниюПереопределяемая(ОтчетОбъект, ФормаОтчета = Неопределено) Экспорт
	
	ДеревоНастроекСтандартныхСтраниц  = Новый ДеревоЗначений;
	ДеревоНастроекСтандартныхСтраниц.Колонки.Добавить("Использование");
	ДеревоНастроекСтандартныхСтраниц.Колонки.Добавить("Имя");
	ДеревоНастроекСтандартныхСтраниц.Колонки.Добавить("Представление");
	
	АналитическиеОтборы = ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Истина, "Период", "Период");
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Ложь, "ПроизвольныйОтчет", "Произвольный отчет");
		
		АналитическиеОтборы = ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Ложь, "АналитическиеОтборы", "Аналитические отборы");
		ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(АналитическиеОтборы, Истина, "КоличествоЗаписей", "Ограничение на количество записей");
		ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(АналитическиеОтборы, Истина, "Порог", "Порог существенности");
		ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(АналитическиеОтборы, Истина, "Индикаторы", "Индикаторы (тренд, состояние)");
		ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(АналитическиеОтборы, Истина, "ABCКлассификация", "ABC - Классификация");
		ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(АналитическиеОтборы, Истина, "СкрытьНулевые", "Скрытие нулевых строк и колонок");
	КонецЕсли;
	
	Параметры  = ложь;
	Показатели = ложь;
	Отбор      = ложь;
	Порядок    = ложь;
	
	Если ФормаОтчета <> Неопределено тогда
		Если ФормаОтчета.ЭлементыФормы.Найти("ПанельЗакладок") <> Неопределено тогда
			Страницы = ФормаОтчета.ЭлементыФормы.ПанельЗакладок.Страницы;
			Параметры  = ?(Страницы.Найти("Параметры") <> Неопределено И Страницы.Параметры.Видимость, Страницы.Параметры.Видимость, Параметры);
			Показатели = ?(Страницы.Найти("Показатели") <> Неопределено И Страницы.Показатели.Видимость, Страницы.Показатели.Видимость, Показатели);
			Отбор      = ?(Страницы.Найти("Отбор") <> Неопределено И Страницы.Отбор.Видимость, Страницы.Отбор.Видимость, Отбор);
			Порядок    = ?(Страницы.Найти("Порядок") <> Неопределено И Страницы.Порядок.Видимость, Страницы.Порядок.Видимость, Порядок);
		КонецЕсли;
	КонецЕсли;
	
	ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Параметры, "Параметры", "Параметры");
	ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Показатели, "Показатели", "Показатели");
	ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Отбор, "Отбор", "Отбор");
	ТиповыеОтчеты.ДобавитьИЗаполнитьСтроку(ДеревоНастроекСтандартныхСтраниц, Порядок, "Порядок", "Сортировка");
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДеревоНастроекСтандартныхСтраниц", ДеревоНастроекСтандартныхСтраниц);
	Параметры.Вставить("Отборы", Новый ТаблицаЗначений);
	Группировки = Новый ТаблицаЗначений;
	Группировки.Колонки.Добавить("Группировка");
	Группировки.Колонки.Добавить("Представление");
	Группировки.Колонки.Добавить("ПредставлениеСтрок");
	Группировки.Колонки.Добавить("ПредставлениеКолонок");
	Группировки.Колонки.Добавить("НастраиватьИерархию");
	Группировки.Колонки.Добавить("Использование");
	Параметры.Вставить("Группировки", Группировки);
	
	СписокДоступныхОтносительныхПериодов = Новый СписокЗначений;
	СписокДоступныхОтносительныхПериодов.Добавить("Предыдущий", "Предыдущий", Истина);
	СписокДоступныхОтносительныхПериодов.Добавить("СНачала", "С начала текущего", Истина);
	СписокДоступныхОтносительныхПериодов.Добавить("Текущий", "Текущий", Истина);
	СписокДоступныхОтносительныхПериодов.Добавить("ДоКонца", "До конца текущего", Истина);
	СписокДоступныхОтносительныхПериодов.Добавить("Следующий", "Следующий", Истина);
	Параметры.Вставить("СписокДоступныхОтносительныхПериодов", СписокДоступныхОтносительныхПериодов);
	
	Параметры.Вставить("ПроизвольныйПериод", Истина);
	ДополнительныеНастройкиОтчета = Новый Массив;
	Попытка 
		ДополнительныеНастройкиОтчета = ОтчетОбъект.ПолучитьДополнительныеНастройкиОтчета();
	Исключение
	КонецПопытки;
	Для каждого ДопНастройка из ДополнительныеНастройкиОтчета Цикл
		Параметры.Вставить(ДопНастройка.Имя, ДопНастройка.ЗначениеПоУмолчанию);
	КонецЦикла;
	//Если ДополнительныеНастройкиОтчета.Количество = Тип("ДиаграммаГанта")  тогда
	//	Параметры.Вставить("ВыводитьДиаграммуГантаВОтчете", Истина);
	//	Параметры.Вставить("ПризнакВыводаДиаграммыГантаНаПанель", Истина);
	//КонецЕсли;
	ДоступныеПериодичности = Новый ТаблицаЗначений;
	ДоступныеПериодичности.Колонки.Добавить("Периодичность");
	ДоступныеПериодичности.Колонки.Добавить("РассчитыватьЧерез");
	ДоступныеПериодичности.Колонки.Добавить("Использование");
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "Год",       Истина);
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "Полугодие", Истина);
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "Квартал",   Истина);
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "Месяц",     Истина);
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "Декада",    Истина);
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "Неделя",    Истина);
	ТиповыеОтчеты.ДобавитьСтрокуПериодичности(ДоступныеПериодичности, "День",      Истина);
	
	Параметры.Вставить("ДоступныеПериодичности", ДоступныеПериодичности);
	
	Возврат Параметры;
	
КонецФункции

Процедура ДополнитьЗначенияНастроекПанелиПользователяПоумолчанию(ЗначенияНастроек, ОтчетОбъект) Экспорт
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		ПроцедурыПроизвольныхОтчетов.ЗаполнитьЗначенияАналитическихОтборовПоумолчанию(ЗначенияНастроек);
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТаблицуДоступныхВариантовПереопределяемая(НастраиваемыйОбъект, Пользователь = Неопределено, СПомеченнымиНаУдаление = Ложь, ТипНастройки = Неопределено, СписокДоступныхНастроек = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = глЗначениеПеременной("глТекущийПользователь");
	КонецЕсли;
	
	Если ТипНастройки = Неопределено тогда
		ТипНастройки = Перечисления.ТипыНастроек.ПроизвольныеНастройки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СохраненныеНастройкиПользователи.Ссылка,
	|	СохраненныеНастройкиПользователи.Ссылка.Наименование КАК Наименование,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА СохраненныеНастройкиПользователи.ПравоИзменения
	|					ИЛИ &ПолныеПрава
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ПравоИзменения,
	|	СохраненныеНастройкиПользователи.Ссылка.Описание
	|ИЗ
	|	Справочник.СохраненныеНастройки.Пользователи КАК СохраненныеНастройкиПользователи
	|ГДЕ
	|	СохраненныеНастройкиПользователи.Ссылка.НастраиваемыйОбъект = &НастраиваемыйОбъект
	|	И (СохраненныеНастройкиПользователи.Пользователь.Ссылка = &Пользователь
	|			ИЛИ СохраненныеНастройкиПользователи.Пользователь.Ссылка В
	|				(ВЫБРАТЬ
	|					ГруппыПользователейПользователиГруппы.Ссылка
	|				ИЗ
	|					Справочник.ГруппыПользователей.ПользователиГруппы КАК ГруппыПользователейПользователиГруппы
	|				ГДЕ
	|					ГруппыПользователейПользователиГруппы.Пользователь.Ссылка = &Пользователь)
	|			ИЛИ СохраненныеНастройкиПользователи.Пользователь.Ссылка = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|				И СохраненныеНастройкиПользователи.Ссылка В (&СписокДоступныхНастроек)
	|				И СохраненныеНастройкиПользователи.Ссылка.Предопределенный
	|			ИЛИ СохраненныеНастройкиПользователи.Пользователь.Ссылка = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|				И &СписокДоступныхНастроекНеопределен
	|				И СохраненныеНастройкиПользователи.Ссылка.Предопределенный
	|			ИЛИ СохраненныеНастройкиПользователи.Пользователь.Ссылка = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|				И (НЕ СохраненныеНастройкиПользователи.Ссылка.Предопределенный))
	|	И (&СПомеченнымиНаУдаление
	|			ИЛИ (НЕ СохраненныеНастройкиПользователи.Ссылка.ПометкаУдаления))
	|	И СохраненныеНастройкиПользователи.Ссылка.ТипНастройки = &ТипНастройки
	|
	|СГРУППИРОВАТЬ ПО
	|	СохраненныеНастройкиПользователи.Ссылка,
	|	СохраненныеНастройкиПользователи.Ссылка.Наименование,
	|	СохраненныеНастройкиПользователи.Ссылка.Описание
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Пользователь",                       Пользователь);
	Запрос.УстановитьПараметр("НастраиваемыйОбъект",                НастраиваемыйОбъект);
	Запрос.УстановитьПараметр("СписокДоступныхНастроек",            СписокДоступныхНастроек);
	Запрос.УстановитьПараметр("СписокДоступныхНастроекНеопределен", СписокДоступныхНастроек = Неопределено);
	Если Найти(НастраиваемыйОбъект, "ОтчетОбъект") > 0 
		ИЛИ ТипЗнч(НастраиваемыйОбъект) = Тип("СправочникСсылка.ПроизвольныеОтчеты") Тогда
		Запрос.УстановитьПараметр("ТипНастройки", Перечисления.ТипыНастроек.НастройкиОтчета);
	Иначе
		Запрос.УстановитьПараметр("ТипНастройки", ТипНастройки);
	КонецЕсли;
	Запрос.УстановитьПараметр("ПолныеПрава", РольДоступна("ПолныеПрава"));
	Запрос.УстановитьПараметр("СПомеченнымиНаУдаление", СПомеченнымиНаУдаление);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Если Клиент Тогда
	
Процедура ДополнитьЗначенияНастроекПанелиПользователя(ЗначенияНастроек, ОтчетОбъект, ФормаОтчета) Экспорт
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		ПроцедурыПроизвольныхОтчетов.ЗаполнитьЗначенияАналитическихОтборов(ЗначенияНастроек, ФормаОтчета.ЭлементыФормы);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПослеВыводаПанелиПользователя(ОтчетОбъект, ФормаОтчета, ДеревоНастроекСтандартныхСтраниц, ЗначенияНастроек) Экспорт
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		
		// Управление видимостью аналитических отборов для Аналитического отчета
		НастройкаСтраницы = ДеревоНастроекСтандартныхСтраниц.Строки.Найти("АналитическиеОтборы", "Имя");
		ФормаОтчета.НарисоватьАналитическиеОтборы(НастройкаСтраницы, ЗначенияНастроек);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОтчетДляРасшифровкиПереопределяемая(ОтчетОбъект) Экспорт

	Если ТиповыеОтчеты.ЭтоВнешнийОбъект(ОтчетОбъект) Тогда
		НовыйОтчет = ВнешниеОтчеты.Создать(ОтчетОбъект.ИспользуемоеИмяФайла);
	Иначе
		НовыйОтчет = Отчеты[ОтчетОбъект.Метаданные().Имя].Создать();
	КонецЕсли;
	
	Если ПроцедурыПроизвольныхОтчетов.ЭтоПроизвольныйОтчет(НовыйОтчет) Тогда
		НовыйОтчет.УстановитьПроизвольныйОтчет(ОтчетОбъект.ПроизвольныйОтчет, ОтчетОбъект.СохраненнаяНастройка);
	Иначе
		НовыйОтчет.СохраненнаяНастройка = ОтчетОбъект.СохраненнаяНастройка;
		НовыйОтчет.ПрименитьНастройку();
	КонецЕсли; 
	
	НовыйОтчет.ЗначенияНастроекПанелиПользователя = Неопределено;
	
	Возврат НовыйОтчет;
	
КонецФункции //
 
#КонецЕсли
