﻿
//#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСтраницыСессийОбмена();
	
	ЭтаФорма.ТолькоПросмотр = Истина;
	ЭтаФорма.ТекущийЭлемент = Элементы["Страница" + СтрЗаменить(Запись.ИдентификаторСессииОбмена, "-", "")];
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьСтраницыСессийОбмена();
	
КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСтраницыСессийОбмена()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторЗапроса", Запись.ИдентификаторЗапроса);
	Запрос.УстановитьПараметр("ИдентификаторСессииОбмена", Запись.ИдентификаторСессииОбмена);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена КАК ИдентификаторСессииОбмена,
	|	УдалитьПротоколОбменаЕГАИС.ТипЗапроса КАК ТипЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ДатаЗапроса КАК ДатаЗапроса,
	|	УдалитьПротоколОбменаЕГАИС.ВидДокумента КАК ВидДокумента,
	|	УдалитьПротоколОбменаЕГАИС.ПолученОтказ КАК ПолученОтказ,
	|	УдалитьПротоколОбменаЕГАИС.Комментарий КАК Комментарий,
	|	УдалитьПротоколОбменаЕГАИС.ФайлОбмена КАК ФайлОбмена
	|ИЗ
	|	РегистрСведений.УдалитьПротоколОбменаЕГАИС КАК УдалитьПротоколОбменаЕГАИС
	|ГДЕ
	|	(УдалитьПротоколОбменаЕГАИС.ИдентификаторЗапроса = &ИдентификаторЗапроса
	|				И &ИдентификаторЗапроса <> """"
	|			ИЛИ УдалитьПротоколОбменаЕГАИС.ИдентификаторСессииОбмена = &ИдентификаторСессииОбмена)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаЗапроса";
	
	ДобавляемыеРеквизиты = Новый Массив;
	УдаляемыеРеквизиты = Новый Массив;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	РеквизитыФормы = ПолучитьРеквизиты();
	Для Каждого Реквизит Из РеквизитыФормы Цикл
		Если Реквизит.Имя <> "Запись" Тогда
			УдаляемыеРеквизиты.Добавить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Если УдаляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(, УдаляемыеРеквизиты);
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекИдентификатор = СтрЗаменить(Выборка.ИдентификаторСессииОбмена, "-", "");
		
		Реквизит = Новый РеквизитФормы("ДатаЗапроса" + ТекИдентификатор, Новый ОписаниеТипов("Дата"), "", НСтр("ru = 'Дата запроса'"));
		ДобавляемыеРеквизиты.Добавить(Реквизит);
		
		Реквизит = Новый РеквизитФормы("Комментарий" + ТекИдентификатор, Новый ОписаниеТипов("Строка"), "", НСтр("ru = 'Комментарий'"));
		ДобавляемыеРеквизиты.Добавить(Реквизит);
		
		Реквизит = Новый РеквизитФормы("ТекстXML" + ТекИдентификатор, Новый ОписаниеТипов("Строка"), "", НСтр("ru = 'Текст XML'"));
		ДобавляемыеРеквизиты.Добавить(Реквизит);
	КонецЦикла;
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекИдентификатор = СтрЗаменить(Выборка.ИдентификаторСессииОбмена, "-", "");
		
		Страница = Элементы.Найти("Страница" + ТекИдентификатор);
		Если Страница = Неопределено Тогда
			Страница = Элементы.Добавить("Страница" + ТекИдентификатор, Тип("ГруппаФормы"), Элементы.Страницы);
			Страница.Вид = ВидГруппыФормы.Страница;
		КонецЕсли;
		
		Страница.Заголовок = Строка(Выборка.ВидДокумента);
		
		Если Выборка.ПолученОтказ Тогда
			Страница.Картинка = БиблиотекаКартинок.ОтказЕГАИС;
		ИначеЕсли Выборка.ТипЗапроса = Перечисления.ТипыЗапросовЕГАИС.Входящий Тогда
			Страница.Картинка = БиблиотекаКартинок.ВходящийЗапросГИСМ
		ИначеЕсли Выборка.ТипЗапроса = Перечисления.ТипыЗапросовЕГАИС.Исходящий Тогда
			Страница.Картинка = БиблиотекаКартинок.ИсходящийЗапросИС;
		КонецЕсли;
		
		ВложенныеСтраницы = Элементы.Найти("Страницы" + ТекИдентификатор);
		Если ВложенныеСтраницы = Неопределено Тогда
			ВложенныеСтраницы = Элементы.Добавить("Страницы" + ТекИдентификатор, Тип("ГруппаФормы"), Страница);
			ВложенныеСтраницы.Вид = ВидГруппыФормы.Страницы;
			ВложенныеСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСнизу;
		КонецЕсли;
		
		СтраницаОсновное = Элементы.Найти("СтраницаОсновное" + ТекИдентификатор);
		Если СтраницаОсновное = Неопределено Тогда
			СтраницаОсновное = Элементы.Добавить("СтраницаОсновное" + ТекИдентификатор, Тип("ГруппаФормы"), ВложенныеСтраницы);
			СтраницаОсновное.Вид = ВидГруппыФормы.Страница;
			СтраницаОсновное.Заголовок = НСтр("ru = 'Основное'");
		КонецЕсли;
		
		СтраницаТекстXML = Элементы.Найти("СтраницаТекстXML" + ТекИдентификатор);
		Если СтраницаТекстXML = Неопределено Тогда
			СтраницаТекстXML = Элементы.Добавить("СтраницаТекстXML" + ТекИдентификатор, Тип("ГруппаФормы"), ВложенныеСтраницы);
			СтраницаТекстXML.Вид = ВидГруппыФормы.Страница;
			СтраницаТекстXML.Заголовок = НСтр("ru = 'Текст XML'");
		КонецЕсли;
		
		ИмяРеквизита = "ДатаЗапроса" + ТекИдентификатор;
		ЭтаФорма[ИмяРеквизита] = Выборка.ДатаЗапроса;
		
		Если Элементы.Найти(ИмяРеквизита) = Неопределено Тогда
			Элемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), СтраницаОсновное);
			Элемент.ПутьКДанным = ИмяРеквизита;
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
		КонецЕсли;
		
		ИмяРеквизита = "Комментарий" + ТекИдентификатор;
		ЭтаФорма[ИмяРеквизита] = Выборка.Комментарий;
		
		Если Элементы.Найти(ИмяРеквизита) = Неопределено Тогда
			Элемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), СтраницаОсновное);
			Элемент.ПутьКДанным = ИмяРеквизита;
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
			Элемент.МногострочныйРежим = Истина;
		КонецЕсли;
		
		ИмяРеквизита = "ТекстXML" + ТекИдентификатор;
		ЭтаФорма[ИмяРеквизита] = Выборка.ФайлОбмена.Получить();
		
		Если Элементы.Найти(ИмяРеквизита) = Неопределено Тогда
			Элемент = Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), СтраницаТекстXML);
			Элемент.ПутьКДанным = ИмяРеквизита;
			Элемент.Вид = ВидПоляФормы.ПолеТекстовогоДокумента;
			Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Элементы.Страницы.ПодчиненныеЭлементы.Количество() > 1 Тогда
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти