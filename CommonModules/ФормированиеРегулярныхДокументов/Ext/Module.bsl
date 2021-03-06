Функция СформироватьРегулярныеДокументы(Настройка, ДатаНачалаПериода, ДатаОкончанияПериода) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("СозданныеДокументы",	  Новый Массив());
	Результат.Вставить("ОбработанныеДокументы",	  Новый Массив());
	Результат.Вставить("НеОбработанныеДокументы", Новый Массив());
	
	Заголовок   = "Формирование документов по настройке " + Настройка + " за период " + ПредставлениеПериода(ДатаНачалаПериода, КонецДня(ДатаОкончанияПериода));
	ТекстОшибки = "";
	
	//Выполним логику, находящуюся в регламенте
	МассивСформированныеДокументы = Неопределено;
	МассивУчтенныеДокументы		  = Неопределено;
	МассивНепроведенныеДокументы  = Неопределено;
		
	ЭкземплярРегламента = РегламентноеФормированиеДокументов.ПолучитьЭкземплярРегламента(Настройка);
	
	ОбъектНастройки = Настройка.ПолучитьОбъект();
	
	// Заблокируем объект настройки
	// Вызов метода Разблокировать() выполнять не обязательно, он будет вызван неявно при выходе из процедуры
	Попытка
		ОбъектНастройки.Заблокировать();
	Исключение
		ТекстОшибки = "Ошибка при попытке заблокировать настройку: " + ОписаниеОшибки();
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, , Заголовок);
		Возврат Результат;
	КонецПопытки;
	
	НачатьТранзакцию();
	
	// Формируем документы
	Если НЕ РегламентноеФормированиеДокументов.СформироватьДокументы(ЭкземплярРегламента, ДатаНачалаПериода, ДатаОкончанияПериода, ТекстОшибки, МассивСформированныеДокументы, МассивУчтенныеДокументы) Тогда
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, , Заголовок);
		Возврат Результат;
	КонецЕсли;
	
	// Запишем дату, по которую сформированы документы
	Если МассивСформированныеДокументы.Количество() > 0 Тогда
		Если НЕ РегламентноеФормированиеДокументов.УстановитьПериодФормированияДокументов(ОбъектНастройки, ДатаОкончанияПериода, ТекстОшибки) Тогда
			ОтменитьТранзакцию();
			ОбщегоНазначения.СообщитьОбОшибке("Ошибка при записи даты, по которую учтены данные сформированных документов: " + ТекстОшибки, , Заголовок);
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	ЗафиксироватьТранзакцию();

	// Подготовим таблицу учтенных документов
	ТаблицаУчтенныеДокументы = Новый ТаблицаЗначений();
	ТаблицаУчтенныеДокументы.Колонки.Добавить("Документ");
	ТаблицаУчтенныеДокументы.Колонки.Добавить("Проведен", Новый ОписаниеТипов("Булево"));
	
	Для Каждого Документ Из МассивУчтенныеДокументы Цикл
		ТаблицаУчтенныеДокументы.Добавить().Документ = Документ;
	КонецЦикла;
		
	// Пометим на удаление учтенные документы и проведем сформированные
	Если НЕ РегламентноеФормированиеДокументов.УдалитьУчтенныеДокументы(ЭкземплярРегламента, ТаблицаУчтенныеДокументы, Ложь, ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, , Заголовок);
	КонецЕсли;
	
	Если НЕ РегламентноеФормированиеДокументов.ПровестиСформированныеДокументы(ЭкземплярРегламента, МассивСформированныеДокументы, Ложь, ТекстОшибки, МассивНепроведенныеДокументы) Тогда
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки, , Заголовок);
	КонецЕсли;
	
	Результат.Вставить("СозданныеДокументы",	 МассивСформированныеДокументы);
	Результат.Вставить("ОбработанныеДокументы",	 МассивУчтенныеДокументы);
	Результат.Вставить("НепроведенныеДокументы", МассивНепроведенныеДокументы);
	
	Возврат Результат;
	
КонецФункции
