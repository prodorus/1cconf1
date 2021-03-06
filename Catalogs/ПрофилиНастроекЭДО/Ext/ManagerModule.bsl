#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Обработчик обновления на БЭД 1.1.22.5
// Заполняет реквизиты табличных частей справочников "Профили настроек ЭДО"
// и "Соглашение об использовании ЭДО".
//
Процедура ЗаполнитьРегламентЭДО() Экспорт
	
	АктуальныеВидыЭД = Новый Массив();
	ЭлектронныеДокументыПереопределяемый.ПолучитьАктуальныеВидыЭД(АктуальныеВидыЭД);
	СтрокиКУдалению = Новый Массив();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДО.Ссылка КАК Профиль
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО КАК ПрофилиНастроекЭДО";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокиКУдалению.Очистить();
		
		Профиль = Выборка.Профиль;
		ПрофильОбъект = Профиль.ПолучитьОбъект();
		ИсходящиеДокументы = ПрофильОбъект.ИсходящиеДокументы;
		Для Каждого ТекСтрока Из ИсходящиеДокументы Цикл
			
			ТекСтрока.ТребуетсяИзвещениеОПолучении = Истина;
			ТекСтрока.ТребуетсяОтветнаяПодпись = ТекСтрока.ИспользоватьЭЦП;
			
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.АктНаПередачуПрав Тогда
				ТекСтрока.Приоритет = 1;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.АктИсполнитель Тогда
				ТекСтрока.Приоритет = 2;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ТОРГ12Продавец Тогда
				ТекСтрока.Приоритет = 3;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетФактура Тогда
				ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				ТекСтрока.Приоритет = 4;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СоглашениеОбИзмененииСтоимостиОтправитель Тогда
				ТекСтрока.Приоритет = 5;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КорректировочныйСчетФактура Тогда
				ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				ТекСтрока.Приоритет = 6;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
				ТекСтрока.Приоритет = 7;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.КаталогТоваров Тогда
				ТекСтрока.Приоритет = 10;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.СчетНаОплату Тогда
				ТекСтрока.ТребуетсяОтветнаяПодпись = Ложь;
				ТекСтрока.Приоритет = 11;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ПрайсЛист Тогда
				ТекСтрока.Приоритет = 12;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ЗаказТовара Тогда
				ТекСтрока.Приоритет = 13;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ОтветНаЗаказ Тогда
				ТекСтрока.Приоритет = 14;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ОтчетОПродажахКомиссионногоТовара Тогда
				ТекСтрока.Приоритет = 15;
			КонецЕсли;
			Если ТекСтрока.ИсходящийДокумент = Перечисления.ВидыЭД.ОтчетОСписанииКомиссионногоТовара Тогда
				ТекСтрока.Приоритет = 16;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ТекСтрока.ДокументУчета)
				И АктуальныеВидыЭД.Найти(ТекСтрока.ИсходящийДокумент) <> Неопределено Тогда
				ТекСтрока.ДокументУчета = ЭлектронныеДокументыПовтИсп.ПредставлениеОснованияДляВидаЭД(ТекСтрока.ИсходящийДокумент);
			КонецЕсли;
			
			Если АктуальныеВидыЭД.Найти(ТекСтрока.ИсходящийДокумент) = Неопределено Тогда
				СтрокиКУдалению.Добавить(ТекСтрока);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого УдаляемаяСтрока Из СтрокиКУдалению Цикл
			ИсходящиеДокументы.Удалить(УдаляемаяСтрока);
		КонецЦикла;
		
		ПрофильОбъект.ИсходящиеДокументы.Сортировать("Приоритет Возр");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ПрофильОбъект);
		
		ПрофильОбъект.ИзменитьДанныеВСвязанныхНастройкахЭДО(ПрофильОбъект, Ложь);
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СоглашенияОбИспользованииЭД.Ссылка КАК Настройка
	|ИЗ
	|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	|ГДЕ
	|	СоглашенияОбИспользованииЭД.РасширенныйРежимНастройкиСоглашения = ИСТИНА";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокиКУдалению.Очистить();
		
		Соглашение = Выборка.Настройка;
		СоглашениеОбъект = Соглашение.ПолучитьОбъект();
		Для Каждого ТекСтрока Из СоглашениеОбъект.ИсходящиеДокументы Цикл
			
			ВидЭД = ТекСтрока.ИсходящийДокумент;
			ПрофильЭДО = ТекСтрока.ПрофильНастроекЭДО;
			
			СвойстваЭД = Новый Структура("ТребуетсяИзвещение, ТребуетсяОтветнаяПодпись, ИспользоватьЭЦП, ДокументУчета, Приоритет");
			ЗаполнитьСвойстваЭДИзПрофиля(ПрофильЭДО, ВидЭД, СвойстваЭД);
			
			ЗаполнитьЗначенияСвойств(ТекСтрока, СвойстваЭД);
			
			Если АктуальныеВидыЭД.Найти(ТекСтрока.ИсходящийДокумент) = Неопределено Тогда
				СтрокиКУдалению.Добавить(ТекСтрока);
			КонецЕсли;

		КонецЦикла;
		
		Для Каждого УдаляемаяСтрока Из СтрокиКУдалению Цикл
			СоглашениеОбъект.ИсходящиеДокументы.Удалить(УдаляемаяСтрока);
		КонецЦикла;

		СоглашениеОбъект.ИсходящиеДокументы.Сортировать("Приоритет Возр");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СоглашениеОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСвойстваЭДИзПрофиля(ПрофильЭДО, ВидЭД, СвойстваЭД)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяИзвещениеОПолучении КАК ТребуетсяИзвещение,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ТребуетсяОтветнаяПодпись КАК ТребуетсяОтветнаяПодпись,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ИспользоватьЭЦП КАК ИспользоватьЭЦП,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.ДокументУчета,
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Приоритет
	|ИЗ
	|	Справочник.ПрофилиНастроекЭДО.ИсходящиеДокументы КАК ПрофилиНастроекЭДОИсходящиеДокументы
	|ГДЕ
	|	ПрофилиНастроекЭДОИсходящиеДокументы.Ссылка = &ПрофильЭДО
	|	И ПрофилиНастроекЭДОИсходящиеДокументы.ИсходящийДокумент = &ВидЭД";
	
	Запрос.УстановитьПараметр("ПрофильЭДО", ПрофильЭДО);
	Запрос.УстановитьПараметр("ВидЭД", ВидЭД);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СвойстваЭД, Выборка);
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления на БЭД 1.1.26.1
// Добавляет вид ЭД "АктОРасхождениях"
Процедура ДобавитьВидЭлектронногоДокумента_АктОРасхождениях() Экспорт
	
	ОбновлениеИнформационнойБазыЭД.ОбновитьНастройкиЭДО(Перечисления.ВидыЭД.АктОРасхождениях);
	
КонецПроцедуры

#КонецЕсли
