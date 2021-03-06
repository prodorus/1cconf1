
// Область ПрограммныйИнтерфейс

// Возвращает строковое представление номенклатуры с характеристикой и другими полями для отображения в сообщениях.
//
// Параметры:
//  Номенклатура	 - Строка, СправочникСсылка.Номенклатура			 - номенклатура;
//  Характеристика	 - Строка, СправочникСсылка.ХарактеристикиНоменклатуры	 - характеристика номенклатуры;
//  Упаковка		 - Строка, СправочникСсылка.УпаковкиНоменклатуры		 - упаковка / единица измерения номенклатуры;
//  Серия			 - Строка, СправочникСсылка.СерииНоменклатуры			 - серия номенклатуры;
//  Назначение		 - Строка, СправочникСсылка.Назначения					 - назначение номенклатуры.
// 
// Возвращаемое значение:
//  Строка - представление номенклатуры.
//
Функция ПредставлениеНоменклатуры(Номенклатура, Характеристика, Упаковка = "", Серия = "", Назначение = "") Экспорт

	СтрПредставление = СокрЛП(Номенклатура);

	Если ЗначениеЗаполнено(Характеристика)Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Характеристика);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Назначение) Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Назначение);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Серия) Тогда
		СтрПредставление = СтрПредставление + " / " + СокрЛП(Серия);
	КонецЕсли;

	Возврат СтрПредставление;

КонецФункции

// Дополнительные параметры функции НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//  * Содержание - Строка - если передано не пустое содержание, то представлением будет оно, остальные параметры игнорируются
//  * ВозвратнаяТара - Булево - если ИСТИНА, то к представлению будет добавлена фраза "возвратная тара" в скобках.
//
Функция ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати() Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Содержание", "");
	ДополнительныеПараметры.Вставить("ВозвратнаяТара", Ложь);
	ДополнительныеПараметры.Вставить("КодТНВЭД", "");
	
	Возврат ДополнительныеПараметры; 
	
КонецФункции

// Возвращает представление номенклатуры для печати.
//
// Параметры:
//  НаименованиеНоменклатурыДляПечати	 - Строка		 - нужно строго передать строку с наименованием для печати. Ссылка не подойдет, т.к. при
//  		получении по ней строкового представления платформа возьмет наименование, а не наименование для печати;
//  НаименованиеХарактеристикиДляПечати	 - Строка		 - нужно строго передать строку с наименованием для печати. Ссылка не подойдет, т.к. при
//  		получении по ней строкового представления платформа возьмет наименование, а не наименование для печати;
//  Упаковка							 - 				 - Строка, СправочникСсылка.УпаковкиНоменклатуры упаковка / единица измерения номенклатуры;
//  Серия								 - Строка, СправочникСсылка.СерииНоменклатуры	 - серия номенклатуры;
//  ДополнительныеПараметры				 - Структура									 - см. НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати.
// 
// Возвращаемое значение:
//  Строка - представление номенклатуры для печати.
//
Функция ПредставлениеНоменклатурыДляПечати(НаименованиеНоменклатурыДляПечати,
	                                       НаименованиеХарактеристикиДляПечати,
	                                       Упаковка = Неопределено,
	                                       Серия = Неопределено,
	                                       ДополнительныеПараметры = Неопределено) Экспорт
										   
	Если ДополнительныеПараметры = Неопределено Тогда
		ДополнительныеПараметры = ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	КонецЕсли;
	
	Если ТипЗнч(НаименованиеНоменклатурыДляПечати) <> Тип("Строка") Тогда
		ТекстИсключения = НСтр("ru = 'В функцию НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати не передано наименование номенклатуры для печати.'");	
		ВызватьИсключение ТекстИсключения;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НаименованиеХарактеристикиДляПечати) 
		И ТипЗнч(НаименованиеХарактеристикиДляПечати) <> Тип("Строка") Тогда
		ТекстИсключения = НСтр("ru = 'В функцию НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати не передано наименование характеристики для печати.'");	
		ВызватьИсключение ТекстИсключения;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры.Содержание) Тогда
		
		ПредставлениеНоменклатуры = СокрЛП(ДополнительныеПараметры.Содержание);
		
	Иначе
		
		ТекстВСкобках = Новый Массив;
		
		Если ЗначениеЗаполнено(НаименованиеХарактеристикиДляПечати) Тогда
			ТекстВСкобках.Добавить(СокрЛП(НаименованиеХарактеристикиДляПечати));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Упаковка) Тогда
			ТекстВСкобках.Добавить(СокрЛП(Упаковка));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Серия) Тогда
			ТекстВСкобках.Добавить(СокрЛП(Серия));
		КонецЕсли;
		
		Если ДополнительныеПараметры.ВозвратнаяТара Тогда
			ТекстВСкобках.Добавить(НСтр("ru='возвратная тара'"));
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДополнительныеПараметры.КодТНВЭД) Тогда
			ТекстВСкобках.Добавить(НСтр("ru = 'Код ТН ВЭД:'")+ Символы.НПП + ДополнительныеПараметры.КодТНВЭД);
		КонецЕсли;
		
		ТекстВСкобкахСтрока = СтрСоединить(ТекстВСкобках, ", ");
		
		Если ЗначениеЗаполнено(ТекстВСкобкахСтрока) Тогда
			ПредставлениеНоменклатуры = НСтр("ru = '%НаименованиеНоменклатурыДляПечати% (%ТекстВСкобках%)'");
			ПредставлениеНоменклатуры = СтрЗаменить(ПредставлениеНоменклатуры, "%ТекстВСкобках%", СокрЛП(ТекстВСкобкахСтрока));
		Иначе
			ПредставлениеНоменклатуры = НСтр("ru = '%НаименованиеНоменклатурыДляПечати%'");
		КонецЕсли;
		
		ПредставлениеНоменклатуры = СтрЗаменить(ПредставлениеНоменклатуры, "%НаименованиеНоменклатурыДляПечати%", СокрЛП(НаименованиеНоменклатурыДляПечати));
		
	КонецЕсли;
	
	Возврат ПредставлениеНоменклатуры;
	
КонецФункции

// Формирует массив отбора по типам номенклатуры Товар и МногооборотнаяТара
//
// Параметры:
//  ВключатьНабор	 - Булево	 - признак включения в отбор набора.
// 
// Возвращаемое значение:
//  Массив - состоит из элементов типа ПеречислениеСсылка.ТипыНоменклатуры.
//
Функция ОтборПоТоваруМногооборотнойТаре(ВключатьНабор = Истина) Экспорт
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	Если ВключатьНабор Тогда
		МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор"));
	КонецЕсли;
	
	Возврат МассивТиповНоменклатуры;
	
КонецФункции

// Формирует массив отбора по типам номенклатуры Товар и МногооборотнаяТара, Услуга, Работа.
//
// Параметры:
//  ВключатьНабор	 - Булево	 - признак включения в отбор набора.
// 
// Возвращаемое значение:
//  Массив - состоит из элементов типа ПеречислениеСсылка.ТипыНоменклатуры.
//
Функция ОтборПоТоваруМногооборотнойТареУслугеРаботе(ВключатьНабор = Истина) Экспорт
	
	МассивТиповНоменклатуры = Новый Массив;
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга"));
	МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа"));
	Если ВключатьНабор Тогда
		МассивТиповНоменклатуры.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Набор"));
	КонецЕсли;
	
	Возврат МассивТиповНоменклатуры;
	
КонецФункции

// Область ПроцедурыРаботыССериями

// Структура параметров указания серий, возвращаемая соответствующей процедурой модуля менеджера документа (обработки).
// Содержит свойства:
//
// ОБЯЗАТЕЛЬНЫЕ:
//	ИспользоватьСерииНоменклатуры - признак, нужно ли в документе заполнять статусы указания серий 
//	ПоляСвязиСерий - массив с именами реквизитов ТЧ Товары и ТЧ Серии, по которым устанавливается
//					 связь между табличными частями (поля связи "Номенклатура" и "Характеристика" 
//					 присутствуют всегда, их отдельно указывать не нужно)
//	ПолноеИмяОбъекта - Строка - полное имя объекта. Например, Документ.РеализацияТоваровУслуг.
//	
//
// НЕОБЯЗАТЕЛЬНЫЕ:
//	ТолькоПросмотр - признак того, что серии в документе можно только просматривать (значение по умолчанию ЛОЖЬ)
//	ТоварВШапке - признак, что параметры указания серий определены для товара в шапке (иначе - для товара в ТЧ) (значение по умолчанию ЛОЖЬ)
//	БлокироватьДанныеФормы - признак того, что перед открытием форму указания серий, нужно заблокировать форму документа (значение по умолчанию ИСТИНА)
//								если ТолькоПросмотр = Истина, то данные формы не блокируются.
//
//	ИмяТЧТовары - имя табличной части со списком товаров (значение по умолчанию - "Товары")
//	ИмяТЧСерии - имя табличной части со списком серий (значение по умолчанию - "Серии")
//	ИмяПоляКоличество - имя поля в ТЧ "Товары", в котором пользователь редактирует количество (значение по умолчанию - "КоличествоУпаковок")
//	ИмяПоляСклад     - имя реквизита склада (значение по умолчанию - "Склад")
//
//	ПодготовкаОрдера - параметр указывает, что ордер находится в статусе, когда происходит подготовка ордера и указание серий не обязательна (значение по умолчанию ЛОЖЬ)
//	ИменаПолейСтатусУказанияСерий - Массив - если в объекте несколько полей со статусом указания серий, то нужно добавить их имена в этот массив (значение по умолчанию пустой массив)
//	ИмяИсточникаЗначенийВФормеОбъекта - Строка - значение по умолчанию "Объект", если данные хранятся в реквизитах формы, то нужно указать "ЭтоФорма"
//	ОтборПроверяемыхСтрок
//	ТолькоСерииСУчетомОстатков - Булево - необходимо указывать серии только тогда, когда по ним ведется учет остатков. (значение по умолчанию - ЛОЖЬ)
//	ОсобеннаяПроверкаСтатусовУказанияСерий - Булево - признак, что в модуле менеджера объявлена процедура ТекстЗапросаПроверкиЗаполненияСерий(ПараметрыУказанияСерий)(значение по умолчанию - ЛОЖЬ)
//	ПараметрыЗапроса - Структура - содержит параметры запроса, используемые в функции ТекстЗапросаЗаполненияСтатусовУказанияСерий.
//	СерииПриПланированииОтгрузкиУказываютсяВТЧСерии - Булево - значение по умолчанию - ЛОЖЬ.
//
// Возвращаемое значение:
//	Структура.
//
Функция ПараметрыУказанияСерий() Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ИспользоватьСерииНоменклатуры",Неопределено);
	СтруктураПараметров.Вставить("УчитыватьСебестоимостьПоСериям",Неопределено);
	СтруктураПараметров.Вставить("ПоляСвязи", Новый Массив);
	СтруктураПараметров.Вставить("ПолноеИмяОбъекта", "");
	
	СтруктураПараметров.Вставить("ТолькоПросмотр",Ложь);
	СтруктураПараметров.Вставить("ТоварВШапке",Ложь);
	СтруктураПараметров.Вставить("БлокироватьДанныеФормы",Истина);
	СтруктураПараметров.Вставить("ИмяТЧТовары","Товары");
	СтруктураПараметров.Вставить("ИмяТЧСерии","Серии");
	СтруктураПараметров.Вставить("ИмяПоляКоличество","Количество");
	СтруктураПараметров.Вставить("ИмяПоляСклад","Склад");
	СтруктураПараметров.Вставить("ИмяПоляСкладОтправитель",Неопределено);
	СтруктураПараметров.Вставить("ИмяПоляСкладПолучатель",Неопределено);
	СтруктураПараметров.Вставить("ТолькоСерииДляСебестоимости",Ложь);
	СтруктураПараметров.Вставить("РегистрироватьСерии", Истина);
	СтруктураПараметров.Вставить("Дата",Дата(1,1,1));
	СтруктураПараметров.Вставить("ИменаПолейСтатусУказанияСерий",Новый Массив);
	СтруктураПараметров.Вставить("ИменаПолейДополнительные",Новый Массив);
	СтруктураПараметров.Вставить("ИмяИсточникаЗначенийВФормеОбъекта","Объект");
	СтруктураПараметров.Вставить("ОтборПроверяемыхСтрок", Неопределено);
	СтруктураПараметров.Вставить("ТолькоСерииСУчетомОстатков", Ложь);             
	СтруктураПараметров.Вставить("ОсобеннаяПроверкаСтатусовУказанияСерий", Ложь);
	СтруктураПараметров.Вставить("НужноОкруглятьКоличество", Истина);
	СтруктураПараметров.Вставить("ПараметрыЗапроса", Новый Структура);
	
	СтруктураПараметров.Вставить("ОперацияДокумента", Неопределено);
	
	Возврат СтруктураПараметров;
	
КонецФункции

// Структура, которую возвращает форма подбора серии
// 
// Возвращаемое значение:
//  Структура - структура со следующими ключами:
//  *Значение - СправочникСсылка.СерииНоменклатуры
//  *ИдентификаторСтроки - Число - идентификатор строки таблицы формы, в которую, нужно подставить значение.
//
Функция ВыбраннаяСерия() Экспорт
	
	Возврат Новый Структура("Значение,ЗначениеСписываемойСерии,ИдентификаторТекущейСтроки,ИмяТЧ");
	
КонецФункции

// Процедура обновляет кеш ключевых реквизитов текущей строки товаров. По ключевым реквизитам осуществляется связь
//  между ТЧ серий и ТЧ товаров.
//
// Параметры:
//  ТекущаяСтрока			 - ДанныеФормыЭлементКоллекции - строка, по которой обновляется кеш.
//  КэшированныеЗначения	 - Структура - переменная модуля формы, в которой хранятся кешируемые значения
//  ПараметрыУказанияСерий	 - Структура - структура параметров указания серий, возвращаемая соответствующей процедурой модуля менеджера документа
//  Копирование				 - Булево - признак, что кешированная строка скопирована (параметр события ПриНачалеРедактирования).
//
Процедура ОбновитьКешированныеЗначенияДляУчетаСерий(ТекущаяСтрока,КэшированныеЗначения,ПараметрыУказанияСерий,Копирование = Ложь) Экспорт
	
	Если Не ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры Тогда
		Возврат;
	КонецЕсли;
	
	Если КэшированныеЗначения = Неопределено Тогда
		КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСерверЕГАИСУТ.ПолучитьСтруктуруКэшируемыеЗначения();
	КонецЕсли;
	
	Если ТекущаяСтрока <> Неопределено
		И (Не Копирование
		Или ПараметрыУказанияСерий.ИмяТЧТовары = ПараметрыУказанияСерий.ИмяТЧСерии) Тогда
		
		КэшированныеЗначения.Вставить("Номенклатура",ТекущаяСтрока.Номенклатура);
		КэшированныеЗначения.Вставить("Характеристика",ТекущаяСтрока.Характеристика);
		
		Если ТекущаяСтрока.Свойство(ПараметрыУказанияСерий.ИмяПоляКоличество) Тогда
			КэшированныеЗначения.Вставить(ПараметрыУказанияСерий.ИмяПоляКоличество, ТекущаяСтрока[ПараметрыУказанияСерий.ИмяПоляКоличество]);
		КонецЕсли;
		
		Для Каждого СтрМас Из ПараметрыУказанияСерий.ПоляСвязи Цикл
			КэшированныеЗначения.Вставить(СтрМас,ТекущаяСтрока[СтрМас]);
		КонецЦикла;
		
		Для Каждого СтрМас Из ПараметрыУказанияСерий.ИменаПолейДополнительные Цикл
			КэшированныеЗначения.Вставить(СтрМас,ТекущаяСтрока[СтрМас]);
		КонецЦикла;
		
	Иначе
		КэшированныеЗначения.Вставить("Номенклатура",Неопределено);
		КэшированныеЗначения.Вставить("Характеристика",Неопределено);
		КэшированныеЗначения.Вставить(ПараметрыУказанияСерий.ИмяПоляКоличество ,0);
		
		Для Каждого СтрМас Из ПараметрыУказанияСерий.ПоляСвязи Цикл
			КэшированныеЗначения.Вставить(СтрМас,Неопределено);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Функция определяет возможность регистрации новых серий, при указании серий в документе.
//
// Параметры:
//  ПараметрыУказанияСерий	 - Структура - структура параметров указания серий, возвращаемая соответствующей процедурой модуля менеджера документа.
//  	  
// Возвращаемое значение:
//   - Булево - ИСТИНА - можно регистрировать новые серии, ЛОЖЬ - серии можно подбирать только по остаткам.
//
Функция НеобходимоРегистрироватьСерии(ПараметрыУказанияСерий) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Извлекает из штрихкода информацию о номере и сроке годности. 
// Работает только для штрихкодов, сгенерированных обработкой печати штрихкодов и номеров 
// серий, сгенерированных формой регистрации серий.
//
// Параметры:
//	Штрихкод - Строка - штрихкод, из которого нужно извлечь информацию;
//	ЕстьПолеНомер - Булево - признак, что для серии, чей штрихкод передан, используется номер;
//	ЕстьПолеГоденДо - Булево - признак, что для серии, чей штрихкод передан, используется номер.
//
// Возвращаемое значение:
//	Структура:
//		* Номер - Строка - номер, извлеченный из штрихкода, если номера у серии нет - пустая строка;
//		* ГоденДо - Дата - дата срока годности, если срока годности у серии нет - пустая дата.
//
Функция ИнформацияОСерииИзШтрихкода(Знач Штрихкод, ЕстьПолеНомер, ЕстьПолеГоденДо) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("ЕстьОшибка", Ложь);
	
	Штрихкод = СокрЛП(Штрихкод);
	
	Возврат Результат;
	
КонецФункции

// Ошибка платформы 00110413.
// Пересчитывает значение даты элемента справочника "СерииНоменклатуры", после выбора значения платформенными средствами.
//
// Параметры:
//	ДатаСерии - Дата - дата элемента справочника "СерииНоменклатуры", полученная платформенными средствами.
//
Процедура ПересчитатьДатуСерии(ДатаСерии) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаСерии) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСерии = ?(Дата(2000, 1, 1) > ДатаСерии, ДобавитьМесяц(ДатаСерии, 1200), ДатаСерии);
	
КонецПроцедуры

// КонецОбласти

// КонецОбласти

// Область СлужебныеПроцедурыИФункции

Функция СтатусыСерийСерияНеУказана() Экспорт
	
	// Порядок статусов следования используется в ПересчитатьСтатусУказанияСерийПриОбработке
	// и должен соответствовать порядку в других функциях СтатусыСерийСерия.
	Статусы = Новый Массив;
	Статусы.Добавить(1);
	Статусы.Добавить(3);
	Статусы.Добавить(5);
	Статусы.Добавить(7);
	Статусы.Добавить(9);
	Статусы.Добавить(13);
	Статусы.Добавить(17);
	
	Возврат Статусы;
	
КонецФункции

Функция СтатусыСерийСерияУказана() Экспорт
	
	// Порядок статусов следования используется в ПересчитатьСтатусУказанияСерийПриОбработке
	// и должен соответствовать порядку в других функциях СтатусыСерийСерия.
	Статусы = Новый Массив;
	Статусы.Добавить(2);
	Статусы.Добавить(4);
	Статусы.Добавить(6);
	Статусы.Добавить(8);
	Статусы.Добавить(10);
	Статусы.Добавить(14);
	Статусы.Добавить(18);
	
	Возврат Статусы;
	
КонецФункции

Функция СтатусыСерийСериюМожноУказать() Экспорт
	
	// Порядок статусов следования используется в ПересчитатьСтатусУказанияСерийПриОбработке
	// и должен соответствовать порядку в других функциях СтатусыСерийСерия.
	Статусы = Новый Массив;
	Статусы.Добавить(21);
	Статусы.Добавить(23);
	Статусы.Добавить(25);
	Статусы.Добавить(27);
	Статусы.Добавить(11);
	Статусы.Добавить(15);
	Статусы.Добавить(28);
	
	Возврат Статусы;
	
КонецФункции

Процедура ПересчитатьСтатусУказанияСерийПриОбработке(ПараметрыУказанияСерий, ТекущийСтатус, СерииУказаныПолностью, КоличествоСерий, ТекущиеДанные = Неопределено) Экспорт
	
	// Если серия указывается в ТЧ Товары, то значение параметра КоличествоСерий должно быть - Неопределено, т.к. в этом случае
	// статус указания серий не зависит от количества - в этом случае статус указания серий зависит только от того, указана серия 
	// или нет.
	
	// Если серия указывается в ТЧ Товары, то в параметре СерииУказаныПолностью передается признак - заполнена серия или нет,
	// иначе - равно ли количество товаров количеству серий (если количество товаров 0, то параметр должен быть ЛОЖЬ).
	
	Если ТекущийСтатус = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПрименятьСтатусМожноУказать = Не СерииУказаныПолностью
									И (КоличествоСерий = 0
										Или КоличествоСерий = Неопределено);
		
	ИндексСтатуса = СтатусыСерийСерияНеУказана().Найти(ТекущийСтатус);

	Если ИндексСтатуса = Неопределено Тогда
		ИндексСтатуса = СтатусыСерийСерияУказана().Найти(ТекущийСтатус);
	КонецЕсли;
	
	Если ИндексСтатуса = Неопределено Тогда
		ИндексСтатуса = СтатусыСерийСериюМожноУказать().Найти(ТекущийСтатус);
	КонецЕсли;
	
	Если Не СерииУказаныПолностью
		И ПрименятьСтатусМожноУказать Тогда
		МассивРезультатов = СтатусыСерийСериюМожноУказать();
	ИначеЕсли Не СерииУказаныПолностью Тогда
		МассивРезультатов = СтатусыСерийСерияНеУказана();
	ИначеЕсли СерииУказаныПолностью Тогда
		МассивРезультатов = СтатусыСерийСерияУказана();
	КонецЕсли;
	
	ТекущийСтатус = МассивРезультатов[ИндексСтатуса];
	
КонецПроцедуры

Функция ВЭтомСтатусеСерииУказываютсяВТЧТовары(СтатусУказанияСерий, ПараметрыУказанияСерий) Экспорт
	
	Если ПараметрыУказанияСерий.ИмяТЧТовары = ПараметрыУказанияСерий.ИмяТЧСерии Тогда
		Возврат Истина;
	КонецЕсли;
	
	Статусы = Новый Массив; //Статусы серий указываемых в ТЧ Товары
	Статусы.Добавить(0);
	Статусы.Добавить(13);
	Статусы.Добавить(14);
	Статусы.Добавить(15);
	Статусы.Добавить(17);
	Статусы.Добавить(18);
	Статусы.Добавить(9);
	Статусы.Добавить(10);
	Статусы.Добавить(11);
	
	Если Статусы.Найти(СтатусУказанияСерий) = Неопределено Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

Функция ВЭтомСтатусеСерииНеУказываются(СтатусУказанияСерий, ПараметрыУказанияСерий) Экспорт
	
	Если СтатусУказанияСерий = 0 Или СтатусыСерийСериюМожноУказать().Найти(СтатусУказанияСерий) <> Неопределено Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ВЭтомСтатусеСерииУказываютсяВТЧСерии(СтатусУказанияСерий, ПараметрыУказанияСерий) Экспорт
	
	Возврат Не ВЭтомСтатусеСерииНеУказываются(СтатусУказанияСерий, ПараметрыУказанияСерий)
		И Не ВЭтомСтатусеСерииУказываютсяВТЧТовары(СтатусУказанияСерий, ПараметрыУказанияСерий);
	
КонецФункции

Функция СуффиксВИмениПоляСтатусУказанияСерий(ИмяПоляСтатус) Экспорт
	
	Возврат 
		Прав(ИмяПоляСтатус, СтрДлина(ИмяПоляСтатус) - СтрНайти(ИмяПоляСтатус, "СтатусУказанияСерий") - 18);//СтрДлина("СтатусУказанияСерий") + 1 = 18 
	
КонецФункции

Функция ДатаИзСтрокиШтрихкода(Знач Штрихкод)
	ШтрихкодДата = '00010101';	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Штрихкод) Тогда
		Если СтрДлина(Штрихкод) = 8 Тогда
			
			Штрихкод =  "20" + Сред(Штрихкод,5,2) + Сред(Штрихкод,3,2) + Лев(Штрихкод,2) + Прав(Штрихкод, 2) + "0000";
			
			Попытка
				ШтрихкодДата = Дата(Штрихкод);
			Исключение
				ШтрихкодДата = '00010101';
			КонецПопытки;             
		ИначеЕсли СтрДлина(Штрихкод) = 6 Тогда
			
			Штрихкод =  "20" + Сред(Штрихкод,5,2) + Сред(Штрихкод,3,2) + Лев(Штрихкод,2) + "000000";
			
			Попытка
				ШтрихкодДата = Дата(Штрихкод);
			Исключение
				ШтрихкодДата = '00010101';
			КонецПопытки;             
		КонецЕсли;
	КонецЕсли;
	
	Возврат ШтрихкодДата;
КонецФункции

// Рассчитывает представление серии. Расчет может производится по шаблону рабочего наименования серии - тогда
// функция должна быть вызвана с сервера. Если шаблон не задан или функция вызвана с клиента, то расчет производится
// по предопределенному шаблону.
//
// Параметры:
//  ПараметрыШаблона	 - Структура - см. Справочники.ВидыНоменклатуры.НастройкиИспользованияСерий
//  ЗначенияРеквизитов	 - Структура, УправляемаяФорма, СправочникОбъект.СерииНоменклатуры, ДанныеФормыЭлементКоллекции.
// 
// Возвращаемое значение:
//  Строка - 
//
Функция ПредставлениеСерии(ЗначенияРеквизитов, ДобавитьСловоНовая = Ложь) Экспорт
	
	Представление = "";
	
	ЧастиПредставления = Новый Массив;
	
	Если ДобавитьСловоНовая Тогда
		ЧастиПредставления.Добавить(НСтр("ru = '<Новая>'"));
	КонецЕсли;
	
	ЧастиПредставления.Добавить(НСтр("ru = '%ПроизводительЕГАИС%'"));
	
	ЧастиПредставления.Добавить(НСтр("ru = '%Справка2ЕГАИС%'"));
	
	Представление = СтрСоединить(ЧастиПредставления, " ");	
	Представление = СтрЗаменить(Представление, "%ПроизводительЕГАИС%", ЗначенияРеквизитов.ПроизводительЕГАИС);
	Представление = СтрЗаменить(Представление, "%Справка2ЕГАИС%", ЗначенияРеквизитов.Справка2ЕГАИС);
	
	Возврат Представление;
	
КонецФункции

// КонецОбласти
