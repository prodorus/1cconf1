////////////////////////////////////////////////////////////////////////////////
// Работа с массивами и таблицами значений

// Функция возвращает результат вычитания элементов множества таблицы
// ТаблицаВычитаемая из ТаблицаОсновная.
//
Функция ВычестьТаблицу(знач ТаблицаОсновная,
                       знач ТаблицаВычитаемая,
                       знач КолонкаСравненияОсновнойТаблицы = "",
                       знач КолонкаСравненияВычитаемойТаблицы = "") Экспорт
	
	Если Не ЗначениеЗаполнено(КолонкаСравненияОсновнойТаблицы) Тогда
		КолонкаСравненияОсновнойТаблицы = "Значение";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КолонкаСравненияВычитаемойТаблицы) Тогда
		КолонкаСравненияВычитаемойТаблицы = "Значение";
	КонецЕсли;
	
	ТаблицаРезультат = Новый ТаблицаЗначений;
	ТаблицаРезультат = ТаблицаОсновная.Скопировать();
	
	Для Каждого Элемент Из ТаблицаВычитаемая Цикл
		Значение = Элемент[КолонкаСравненияОсновнойТаблицы];
		НайденнаяСтрока = ТаблицаРезультат.Найти(Значение, КолонкаСравненияОсновнойТаблицы);
		Если НайденнаяСтрока <> Неопределено Тогда
			ТаблицаРезультат.Удалить(НайденнаяСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаРезультат;
	
КонецФункции

// Функция возвращает таблицу созданную на основе ТаблицаИнициализации.
// Если ТаблицаИнициализации не указана, то создается пустая таблица.
//
Функция СоздатьТаблицуСравнения(ТаблицаИнициализации = Неопределено,
                                ИмяКолонкиСравнения = "Значение") Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить(ИмяКолонкиСравнения);
	
	Если ТаблицаИнициализации <> Неопределено Тогда
		
		МассивЗначений = ТаблицаИнициализации.ВыгрузитьКолонку(ИмяКолонкиСравнения);
		
		Для Каждого Элемент Из ТаблицаИнициализации Цикл
			НоваяСтрока = Таблица.Добавить();
			НоваяСтрока.Установить(0, Элемент[ИмяКолонкиСравнения]);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Таблица;

КонецФункции

Функция ЗапретитьОткрытиеНесколькихСеансов() Экспорт
	
	ЗапретитьОткрытиеНесколькихСеансов = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ЗапретитьОткрытиеНесколькихСеансов");
	
	Если НЕ ЗапретитьОткрытиеНесколькихСеансов Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекущийНомерСоединения = НомерСоединенияИнформационнойБазы();
	УникальныйИдентификаторПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	
	МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
	Для Каждого ТекСоединение Из МассивСоединений Цикл
		Если (ТекСоединение.ИмяПриложения = "1CV8") 
		   И (НЕ ТекСоединение.НомерСоединения = ТекущийНомерСоединения)
		   И (НЕ ТекСоединение.Пользователь = неопределено)
		   И (ТекСоединение.Пользователь.УникальныйИдентификатор = УникальныйИдентификаторПользователя) Тогда
		  
			Возврат Истина;
			
		КонецЕсли;
	КонецЦикла;	
	
	 Возврат Ложь;
	 
КонецФункции // 
 
Процедура ВыполнитьУдалениеОбъектов(Ссылки, Проверять) Экспорт
	
	Если ТипЗнч(Ссылки) = Тип("Массив") ИЛИ ТипЗнч(Ссылки) = Тип("ФиксированныйМассив") Тогда
		МассивСсылок = Ссылки;
	Иначе
		МассивСсылок = Новый Массив();
		МассивСсылок.Добавить(Ссылки);
	КонецЕсли;
	УстановитьПривилегированныйРежим(Истина);
	УдалитьОбъекты(МассивСсылок, Проверять);
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

// Функция выполняет запрос в привилегированном режиме и возвращает результат
//
// Параметры:
//  Текст - Строка - текст запроса
//  Параметры - Структура - параметры запроса
//
// Возвращаемое значение:
//  РезультатЗапроса
//
Функция ВыполнитьЗапросВПривилегированномРежиме(Текст, Параметры) Экспорт

	Запрос = Новый Запрос(Текст);
	Для Каждого ЭлементСтруктуры Из Параметры Цикл
		Запрос.УстановитьПараметр(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат Запрос.Выполнить();

КонецФункции


// Создает объект ОписаниеТипов, содержащий тип Строка.
//
// Параметры:
//  ДлинаСтроки - Число - длина строки.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Строка.
//
Функция ОписаниеТипаСтрока(ДлинаСтроки) Экспорт

	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));

	КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ДопустимаяДлина.Переменная);

	Возврат Новый ОписаниеТипов(Массив, , КвалификаторСтроки);

КонецФункции
