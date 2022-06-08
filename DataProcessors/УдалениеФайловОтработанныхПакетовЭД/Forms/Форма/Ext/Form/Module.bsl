﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗаполнитьТаблицуФайловОтработанныхПакетовЭД()
	
	ОтработанныеПакеты.Очистить();
	
	ЗапросПакетов = Новый Запрос;
	
	УдаляемыеСтатусыПакетов = Новый СписокЗначений;
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Отменен);
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Доставлен);
	УдаляемыеСтатусыПакетов.Добавить(Перечисления.СтатусыПакетовЭД.Распакован);
	
	ЗапросПакетов.УстановитьПараметр("СтатусПакета", УдаляемыеСтатусыПакетов);
	
	ЗапросПакетов.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
	|	ПакетЭДПрисоединенныеФайлы.Ссылка КАК Документ,
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла.СтатусПакета КАК Статус,
	|	ЛОЖЬ КАК Выбран,
	|	ПакетЭДПрисоединенныеФайлы.ДатаСоздания КАК ДатаПолучения,
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла.Организация КАК Организация,
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла.Контрагент КАК Контрагент,
	|	ПакетЭДПрисоединенныеФайлы.ВладелецФайла.Направление КАК Направление
	|ИЗ
	|	Справочник.ПакетЭДПрисоединенныеФайлы КАК ПакетЭДПрисоединенныеФайлы
	|ГДЕ
	|	ПакетЭДПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ
	|	И ПакетЭДПрисоединенныеФайлы.ВладелецФайла.СтатусПакета В (&СтатусПакета)";
	
	ЗначениеВРеквизитФормы(ЗапросПакетов.Выполнить().Выгрузить(), "ОтработанныеПакеты");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьДанные()
	
	Для Каждого СтрокаУдаления Из ОтработанныеПакеты Цикл
		Если СтрокаУдаления.Выбран Тогда
			ОбъектУдаления = СтрокаУдаления.Документ.ПолучитьОбъект();
			ОбъектУдаления.ПометкаУдаления = Истина;
			ОбъектУдаления.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияФлажков(ПараметрУстановки)
	
	Для Каждого Строка Из ОтработанныеПакеты Цикл
		Строка.Выбран = ПараметрУстановки;
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	УстановитьЗначенияФлажков(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	
	УстановитьЗначенияФлажков(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеОтмеченныеПЭД(Команда)
	
	УдалитьДанные();
	ОбновитьДанныеПоТаблицам(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПоТаблицам(Команда)
	
	ЗаполнитьТаблицуФайловОтработанныхПакетовЭД();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ОтработанныеПакетыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектронныеДокументыСлужебныйКлиент.ОткрытьЭДДляПросмотра(Элементы.ОтработанныеПакеты.ТекущиеДанные.Документ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуФайловОтработанныхПакетовЭД();
	
КонецПроцедуры
