
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интернет-поддержка пользователей"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает версию библиотеки интернет-поддержки пользователей.
//
// Возвращаемое значение - Строка - версия библиотеки ИПП.
//
Функция ВерсияБиблиотеки()
	
	Возврат "1.0.3.4";
	
КонецФункции

// Определение адреса web-сервиса.
//
// Возвращаемое значение - Строка - адрес web-сервиса.
//
Функция ИмяWSОпределения() Экспорт
	
	Возврат "https://webits.1c.ru/services/WebItsService.xml";
	
КонецФункции

// Определение имени URIСервиса.
//
// Возвращаемое значение - Строка - URI сервиса.
//
Функция ИмяURIСервиса() Экспорт
 
	Возврат "https://ws.webits.onec.ru";;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   – текстовая строка с подставленными параметрами.
//
// Пример:
//  ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1,	Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	Если СтрокаПодстановки = Неопределено ИЛИ СтрДлина(СтрокаПодстановки) = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Результат = "";
	НачПозиция = 1;
	Позиция = 1;
	Пока Позиция <= СтрДлина(СтрокаПодстановки) Цикл
		СимволСтроки = Сред(СтрокаПодстановки, Позиция, 1);
		Если СимволСтроки <> "%" Тогда
			Позиция = Позиция + 1;
			Продолжить;
		КонецЕсли;
		Результат = Результат + Сред(СтрокаПодстановки, НачПозиция, Позиция - НачПозиция);
		Позиция = Позиция + 1;
		СимволСтроки = Сред(СтрокаПодстановки, Позиция, 1);
		
		Если СимволСтроки = "%" Тогда
			Позиция = Позиция + 1;
			НачПозиция = Позиция;
			Результат = Результат + "%";
			Продолжить;
		КонецЕсли;
		
		Попытка
			НомерПараметра = Число(СимволСтроки);
		Исключение
			ВызватьИсключение НСтр("ru='Входная строка СтрокаПодстановки имеет неверный формат: %'" + СимволСтроки);
		КонецПопытки;
		
		Если СимволСтроки = "1" Тогда
			ЗначениеПараметра = Параметр1;
		ИначеЕсли СимволСтроки = "2" Тогда
			ЗначениеПараметра = Параметр2;
		ИначеЕсли СимволСтроки = "3" Тогда
			ЗначениеПараметра = Параметр3;
		ИначеЕсли СимволСтроки = "4" Тогда
			ЗначениеПараметра = Параметр4;
		ИначеЕсли СимволСтроки = "5" Тогда
			ЗначениеПараметра = Параметр5;
		ИначеЕсли СимволСтроки = "6" Тогда
			ЗначениеПараметра = Параметр6;
		ИначеЕсли СимволСтроки = "7" Тогда
			ЗначениеПараметра = Параметр7;
		ИначеЕсли СимволСтроки = "8" Тогда
			ЗначениеПараметра = Параметр8;
		ИначеЕсли СимволСтроки = "9" Тогда
			ЗначениеПараметра = Параметр9;
		Иначе
			ВызватьИсключение НСтр("ru='Входная строка СтрокаПодстановки имеет неверный формат: %'" + ЗначениеПараметра);
		КонецЕсли;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = "";
		Иначе
			ЗначениеПараметра = Строка(ЗначениеПараметра);
		КонецЕсли;
		Результат = Результат + ЗначениеПараметра;
		Позиция = Позиция + 1;
		НачПозиция = Позиция;
	
	КонецЦикла;
	
	Если (НачПозиция <= СтрДлина(СтрокаПодстановки)) Тогда
		Результат = Результат + Сред(СтрокаПодстановки, НачПозиция, СтрДлина(СтрокаПодстановки) - НачПозиция + 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
