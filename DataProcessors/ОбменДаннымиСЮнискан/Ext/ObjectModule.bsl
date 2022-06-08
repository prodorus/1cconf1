﻿
Перем мGLNПредприятия;
Перем мПарольПредприятия;
Перем мПрефиксПредприятия;

// ФУНКЦИИ ИМПОРТА ЭКСПОРТА В XML
///////////////////////////////////////////////////////////////////////////////

Функция СоздатьУзелНаВетке(ТекущаяВетка, ДеревоОбработки) Экспорт
	
	Если ТекущаяВетка = Неопределено Тогда
		Возврат ДеревоОбработки.Строки.Добавить();
	Иначе
		Возврат ТекущаяВетка.Строки.Добавить();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьДеревоИзФайла(ФайлДляЧтения) Экспорт
	
	XMLПоток = Новый ЧтениеXML();
		
	Попытка
		XMLПоток.ОткрытьФайл(ФайлДляЧтения);
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке("Импорт из файла """ + ФайлДляЧтения + """ : В файле нарушена структура XML или это не XML файл!");
		Возврат Неопределено;
	КонецПопытки;
	
	ДеревоФайла = Новый ДеревоЗначений;
	ДеревоФайла.Колонки.Добавить("Имя");
	ДеревоФайла.Колонки.Добавить("Значение");
	
	ТекущаяВетка = Неопределено;
	
	Попытка
		Пока XMLПоток.Прочитать() Цикл
			
			Если XMLПоток.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				ТекущаяВетка = СоздатьУзелНаВетке(ТекущаяВетка, ДеревоФайла);
				ТекущаяВетка.Имя = XMLПоток.Имя;
							
				Пока XMLПоток.ПрочитатьАтрибут() Цикл
					АтрибутВДереве = СоздатьУзелНаВетке(ТекущаяВетка, ДеревоФайла);
					АтрибутВДереве.Имя =  XMLПоток.Имя;
					АтрибутВДереве.Значение =  XMLПоток.Значение;
				КонецЦикла;
				
			ИначеЕсли XMLПоток.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				ТекущаяВетка = ТекущаяВетка.Родитель;
			Иначе
				АтрибутВДереве = СоздатьУзелНаВетке(ТекущаяВетка, ДеревоФайла);
				АтрибутВДереве.Имя =  "";
				АтрибутВДереве.Значение =  XMLПоток.Значение;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке("Возникла ошибка при чтении файла: " + ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ДеревоФайла;
	
КонецФункции


// функция формирует по значению параметра строку для записи в XML
Функция СформироватьСтрокуДляЗаписиВXML(Значение) Экспорт 
	
	Если ТипЗнч(Значение) = Тип("Число") Тогда
		СтрокаДляЗаписи = СтрЗаменить(Строка(Значение), Символы.НПП, "");
	Иначе
		СтрокаДляЗаписи = Значение;
	КонецЕсли;
	
	Возврат СтрокаДляЗаписи;
	
КонецФункции

// процедура записывает узел дерева в XML
Процедура ЗаписатьУзелДереваВXML(СтрокаДерева, ПотокXML) Экспорт 
	
	Если СтрокаДерева.Строки.Количество() > 0 Тогда 
		// узел, составной элемент
		Если ПустаяСтрока(СтрокаДерева.Имя) Тогда
			Возврат;
		КонецЕсли;
		
		ПотокXML.ЗаписатьНачалоЭлемента(СтрокаДерева.Имя);
		СтрокаЗначения = "";
		
		Для каждого Лист из СтрокаДерева.Строки Цикл
			Если ПустаяСтрока(Лист.Имя) Тогда
				Если Лист.Значение <> Неопределено Тогда
					СтрокаЗначения = СформироватьСтрокуДляЗаписиВXML(Лист.Значение);
				КонецЕсли;
			Иначе
				ЗаписатьУзелДереваВXML(Лист, ПотокXML);
			КонецЕсли;
		КонецЦикла;
		
		// значение в последюю очередь записываем, сначала все параметры
		Если Не Пустаястрока(СтрокаЗначения) Тогда
			ПотокXML.ЗаписатьТекст(СтрокаЗначения);	
		КонецЕсли;
		
		ПотокXML.ЗаписатьКонецЭлемента();
		
	Иначе
		// аттрибут
		Если СтрокаДерева.Значение <> Неопределено Тогда
			СтрокаДляЗаписи = СформироватьСтрокуДляЗаписиВXML(СтрокаДерева.Значение);
			Если Не Пустаястрока(СтрокаДляЗаписи) Тогда
				ПотокXML.ЗаписатьАтрибут(СтрокаДерева.Имя, СтрокаДляЗаписи);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
Конецпроцедуры

// функция записывает дерево в XML
Функция ЗаписатьДеревоВXML(Дерево, ИмяФайла)Экспорт 
	
	ПотокЗаписиXML = Новый ЗаписьXML();
	ПотокЗаписиXML.ОткрытьФайл(ИмяФайла, "UTF-8");
	ПотокЗаписиXML.ЗаписатьОбъявлениеXML();
	
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		ЗаписатьУзелДереваВXML(СтрокаДерева, ПотокЗаписиXML);
	КонецЦикла;
	
	ПотокЗаписиXML.Закрыть();
	
КонецФункции

// функция получает значение узла дерева
Функция ПолучитьЗначениеУзлаДерева(СтрокаДерева) Экспорт 
	
	Если СтрокаДерева = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокаСПустымИмененм = СтрокаДерева.Строки.Найти("", "Имя", Ложь);
	Если СтрокаСПустымИмененм = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СтрокаСПустымИмененм.Значение;
	
КонецФункции


// Функция добавляет к строкам дерева еще одну с определенным именем и значением
Функция ДобавитьСтрокуВДерево(СтрокиДерева, ИмяЭлемента, ЗначениеЭлемента = Неопределено) Экспорт 
	
	СтрокаДобавления = СтрокиДерева.Добавить();
	СтрокаДобавления.Имя = ИмяЭлемента;
	СтрокаДобавления.Значение = ЗначениеЭлемента;
	
	Возврат СтрокаДобавления;
	
КонецФункции

//Функция добавляет узел в дерево
Функция ДобавитьУзелВДерево(СтрокиДерева, ИмяЭлемента, ЗначениеЭлемента = Неопределено) Экспорт
	
	СтрокаДобавления = СтрокиДерева.Добавить();
	СтрокаДобавления.Имя = ИмяЭлемента;
	
	Если ЗначениеЭлемента <> Неопределено Тогда
		СтрокаПараметра = СтрокаДобавления.Строки.Добавить();
		СтрокаПараметра.Имя = "";
		СтрокаПараметра.Значение = ЗначениеЭлемента;
	КонецЕсли;
	
	Возврат СтрокаДобавления;
	
КонецФункции

// добавляет параметр в дерево
Функция ДобавитьПараметрВДерево(СтрокиДерева, КодПараметра, ЗначениеЭлемента = Неопределено) Экспорт
	
	// если нет значения параметра - то ничего и не записываем в дерево
	Если ЗначениеЭлемента = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// пустые параметры не записываем в дерево
	СтрокаДляЗаписи = СформироватьСтрокуДляЗаписиВXML(ЗначениеЭлемента);
	Если ПустаяСтрока(СтрокаДляЗаписи) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Узел = ДобавитьУзелВДерево(СтрокиДерева, "param", ЗначениеЭлемента);
	ДобавитьСтрокуВДерево(Узел.Строки, "id_param", КодПараметра);

	Возврат Узел;
	
КонецФункции

// Функция добавляет группу в дерево
Функция ДобавитьГруппуВДерево(СтрокиДерева, КодГруппы) Экспорт
	
	Узел = ДобавитьУзелВДерево(СтрокиДерева, "group");
	ДобавитьСтрокуВДерево(Узел.Строки, "id_group", КодГруппы);

	Возврат Узел;
	
КонецФункции

// функция добавляет запись в дерево
Функция ДобавитьЗаписьВДерево(СтрокиДерева, КодЗаписи) Экспорт
	
	Узел = ДобавитьУзелВДерево(СтрокиДерева, "record");
	ДобавитьСтрокуВДерево(Узел.Строки, "id_record", КодЗаписи);

	Возврат Узел;
	
КонецФункции


// функция проводит отправку XML файла - дерева по определенному адресу и на выходе получает итоговый файл ответа
Функция ОтправитьДеревоПоHTTP(Дерево, ИмяФайлаДляЗаписиЗапроса, ИмяФайлаДляЗаписиОтвета, ИмяСервера, АдресОтправки) Экспорт
	
	Перем HTTP;
	
	ЗаписатьДеревоВXML(Дерево, ИмяФайлаДляЗаписиЗапроса);
	
	// отправляем дерево сервер
	Попытка
		HTTP = Новый HTTPСоединение(ИмяСервера);
		HTTP.ОтправитьДляОбработки(ИмяФайлаДляЗаписиЗапроса, АдресОтправки, ИмяФайлаДляЗаписиОтвета, "");
	Исключение
		ОбщегоНазначения.СообщитьОбОшибке("Возникла ошибка при отправке данных: " + ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	// проверяем наличие файла ответа
	Файл = Новый Файл(ИмяФайлаДляЗаписиОтвета);
	
	// а есть ли вообще файл ответа
	Если Не Файл.Существует() Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не найден файл ответа : " + ИмяФайлаДляЗаписиОтвета);
		Возврат Неопределено;
	КонецЕсли;
	
	// может файл пустой
	Если Файл.Размер() = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Файл ответа пустой: " + ИмяФайлаДляЗаписиОтвета);
		Возврат Неопределено;
	КонецЕсли;

	// получаем результирующее дерево
	РезультирующееДерево = ПолучитьДеревоИзФайла(ИмяФайлаДляЗаписиОтвета);
			
	Возврат РезультирующееДерево;
	
КонецФункции

// Процедура сообщает об ошибке регистрации товаров
Процедура СообщитьОбОшибкеРегистрации(ТекстОшибки, РезультатРегистрации) Экспорт
	
	РезультатРегистрации = Ложь;
	ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки);
	
КонецПроцедуры

// функция по номенклатуре возвращает торговую марку
Функция ВернутьТорговуюМаркуПоНоменклатуре(Номенклатура) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗначенияСвойствОбъектов.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|
	| ГДЕ 
	|	ЗначенияСвойствОбъектов.Объект = &Номенклатура
	|   И ЗначенияСвойствОбъектов.Свойство = &Свойство";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Свойство", ПланыВидовХарактеристик.СвойстваОбъектов.ТорговаяМарка);
	
	ТаблицаРезультатов = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаРезультатов.Количество() = 0 Тогда
		Возврат "";
	Иначе
		Возврат Строка(ТаблицаРезультатов[0].Значение);
	КонецЕсли;	
	
КонецФункции

// Функция возвращает количество - вес для регистрации и сверки с Юнискан
Функция ВернутьКоличествоВесДляЕдиницыИзмерения(ЕдиницаИзмерения, ЕдиницаХраненияОстатков) Экспорт
	
	Если (ЕдиницаИзмерения = ЕдиницаХраненияОстатков)
		И ЗначениеЗаполнено(ЕдиницаХраненияОстатков) Тогда
		
		// это базовая единица
		Если ЗначениеЗаполнено(ЕдиницаХраненияОстатков.Вес) Тогда
			Возврат ЕдиницаХраненияОстатков.Вес * ЕдиницаХраненияОстатков.Коэффициент;
		Иначе
			Возврат ЕдиницаИзмерения.Коэффициент;
		КонецЕсли;
		
	Иначе
		Возврат ЕдиницаИзмерения.Коэффициент;
    КонецЕсли;
	
КонецФункции

// процедура устанавливает коэффициент - все для единицы измерения
Процедура УстановитьКоэффициентЮнисканУЕдиницыИзмерения(ЕдиницаИзмерения, ЕдиницаХраненияОстатков, Знач ЗначениеКоэффициента) Экспорт
	
	Если (ЕдиницаИзмерения.Ссылка = ЕдиницаХраненияОстатков)
		И ЗначениеЗаполнено(ЕдиницаХраненияОстатков) Тогда
		
		// это базовая единица
		Если ЗначениеЗаполнено(ЕдиницаИзмерения.ЕдиницаПоКлассификатору) Тогда
			МеждународноеСокращение = ЕдиницаИзмерения.ЕдиницаПоКлассификатору.МеждународноеСокращение;
		Иначе
			МеждународноеСокращение = "";
		КонецЕсли;
		
		ЭтоВесоваяЕдиница = УправлениеРозничнойТорговлей.ПолучитьПоМеждународномуСокращениюЭтоВесоваяЕдиница(МеждународноеСокращение);
		
		Если ЭтоВесоваяЕдиница Тогда
			ЕдиницаИзмерения.Вес = ЗначениеКоэффициента;
			ЕдиницаИзмерения.Коэффициент = 1;
		Иначе
			ЕдиницаИзмерения.Коэффициент = ЗначениеКоэффициента;
		КонецЕсли;
		
	Иначе
		ЕдиницаИзмерения.Коэффициент = ЗначениеКоэффициента;
    КонецЕсли;
	
КонецПроцедуры

// ИМЕНА ФАЙЛОВ РЕГИСТРАЦИИ И ПОЛУЧЕНИЯ ИНФОРМАЦИИ
///////////////////////////////////////////////////////////////////////////////

// процедура возвращает имена файлов для регистрации
Процедура ВернутьИменаФайловДляРегистрации(ИмяФайлаДляЗаписиЗапроса, ИмяФайлаДляЗаписиОтвета) Экспорт 
	
	ИмяКаталогаВременныхФайлов = КаталогВременныхФайлов();
	ИмяФайлаДляЗаписиЗапроса = ИмяКаталогаВременныхФайлов + "Base460.xml";
	ИмяФайлаДляЗаписиОтвета = ИмяКаталогаВременныхФайлов + "ReqAnswer.xml";
	
КонецПроцедуры

// процедура возвращает имена файлов для получения информации о номенклатуре
Процедура ВернутьИменаФайловДляПолученияИнформацииПоНоменклатуре(ИмяФайлаДляЗаписиЗапроса, ИмяФайлаДляЗаписиОтвета) Экспорт 
	
	ИмяКаталогаВременныхФайлов = КаталогВременныхФайлов();
	ИмяФайлаДляЗаписиЗапроса = ИмяКаталогаВременныхФайлов + "QueryGTIN.xml";
	ИмяФайлаДляЗаписиОтвета = ИмяКаталогаВременныхФайлов + "AnswerGTIN.xml";
	
КонецПроцедуры

// ФУНКЦИИ РАБОТЫ С КОНСТАНТАМИ СИСТЕМЫ
///////////////////////////////////////////////////////////////////////////////

// Функция получает GLNПредприятия
Функция ПолучитьGLNПредприятия() Экспорт
	
	Если мGLNПредприятия = Неопределено Тогда
		мGLNПредприятия = Врег(Константы.GLNПредприятия.Получить()); 
		Если НЕ ЗначениеЗаполнено(мGLNПредприятия) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнена константа ""GLN предприятия""");
		КонецЕсли;
	КонецЕсли;

	Возврат мGLNПредприятия;  
	
КонецФункции

// Функция получает пароль предприятия
Функция ПолучитьПарольПредприятия() Экспорт 
	
	Если мПарольПредприятия = Неопределено Тогда
		мПарольПредприятия = Врег(Константы.ПарольРегистрацииВЮнискан.Получить());
		Если НЕ ЗначениеЗаполнено(мПарольПредприятия) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнена константа ""Пароль предприятия""");
		КонецЕсли;
	КонецЕсли;
	
	Возврат мПарольПредприятия; 
	
КонецФункции

// Функция получает префикс предприятия
Функция ПолучитьПрефиксПредприятия() Экспорт 
	
	Если мПрефиксПредприятия = Неопределено Тогда
		мПрефиксПредприятия = Врег(Константы.ПрефиксШтрихКодаРегистрацииНоменклатуры.Получить());
		Если НЕ ЗначениеЗаполнено(мПрефиксПредприятия) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Не заполнена константа ""Префикс предприятия""");
		КонецЕсли;
	КонецЕсли;
	
	Возврат мПрефиксПредприятия; 
	
КонецФункции


///////////////////////////////////////////////////////////////////////////////
// РЕГИСТРАЦИЯ НОМЕНКЛАТУРЫ И СИНХРОНИЗАЦИЯ ДАННЫХ

// процедура показывает форму регистрации номенклатуры
Процедура ПоказатьФормуРегистрацииНоменклатуры(Номенклатура, ВладелецФормы) Экспорт
	
	ФормаРегистрации = ЭтотОбъект.ПолучитьФорму("РегистрацияНоменклатуры", ВладелецФормы);
	ФормаРегистрации.НоменклатураДляРегистрации = Номенклатура; 
	ФормаРегистрации.Открыть();
	
КонецПроцедуры


// ИНИЦИАЛИЗАЦИЯ НАЧАЛЬНЫХ ЗНАЧЕНИЙ

мGLNПредприятия = Неопределено;
мПарольПредприятия = Неопределено;
мПрефиксПредприятия = Неопределено;
