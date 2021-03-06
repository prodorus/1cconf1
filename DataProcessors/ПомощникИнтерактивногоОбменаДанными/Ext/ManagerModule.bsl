#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ВыполнитьАвтоматическоеСопоставлениеДанных(Параметры, АдресВременногоХранилища) Экспорт
	
	ПоместитьВоВременноеХранилище(
		РезультатАвтоматическогоСопоставленияДанных(Параметры.УзелИнформационнойБазы, Параметры.ИмяФайлаСообщенияОбмена, Параметры.ИмяВременногоКаталогаСообщенийОбмена),
		АдресВременногоХранилища
	);
КонецПроцедуры

Функция РезультатАвтоматическогоСопоставленияДанных(Знач Корреспондент, Знач ИмяФайлаСообщенияОбмена, Знач ИмяВременногоКаталогаСообщенийОбмена) Экспорт
	
	// Выполняем автоматическое сопоставление данных, полученных от корреспондента
	// Получаем статистику сопоставления
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПомощникИнтерактивногоОбменаДанными = Обработки.ПомощникИнтерактивногоОбменаДанными.Создать();
	ПомощникИнтерактивногоОбменаДанными.УзелИнформационнойБазы = Корреспондент;
	ПомощникИнтерактивногоОбменаДанными.ИмяФайлаСообщенияОбмена = ИмяФайлаСообщенияОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяВременногоКаталогаСообщенийОбмена = ИмяВременногоКаталогаСообщенийОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Корреспондент);
	ПомощникИнтерактивногоОбменаДанными.ВидТранспортаСообщенийОбмена = Неопределено;
	
	// Выполняем анализ сообщения обмена
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ВыполнитьАнализСообщенияОбмена(Отказ);
	Если Отказ Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Возникли ошибки при анализе сообщения обмена для корреспондента ""%1"".'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	// Выполняем автоматическое сопоставление и получаем статистику сопоставления
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ВыполнитьАвтоматическоеСопоставлениеПоУмолчаниюИПолучитьСтатистикуСопоставления(Отказ);
	Если Отказ Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Возникли ошибки при выполнении автоматического сопоставления данных, полученных от корреспондента ""%1"".'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	ТаблицаИнформацииСтатистики = ПомощникИнтерактивногоОбменаДанными.ТаблицаИнформацииСтатистики();
	
	Результат = Новый Структура;
	Результат.Вставить("ИнформацияСтатистики", ТаблицаИнформацииСтатистики);
	Результат.Вставить("ВсеДанныеСопоставлены", ВсеДанныеСопоставлены(ТаблицаИнформацииСтатистики));
	Результат.Вставить("СтатистикаПустая", ТаблицаИнформацииСтатистики.Количество() = 0);
	
	Возврат Результат;
КонецФункции

Процедура ВыполнитьЗагрузкуДанных(Параметры, АдресВременногоХранилища) Экспорт
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЧерезФайлИлиСтроку(
		Параметры.УзелИнформационнойБазы,
		Параметры.ИмяФайлаСообщенияОбмена,
		Перечисления.ДействияПриОбмене.ЗагрузкаДанных
	);
КонецПроцедуры

Функция ВсеДанныеСопоставлены(ИнформацияСтатистики) Экспорт
	
	Возврат (ИнформацияСтатистики.НайтиСтроки(Новый Структура("ИндексКартинки", 1)).Количество() = 0);
	
КонецФункции

#КонецЕсли
