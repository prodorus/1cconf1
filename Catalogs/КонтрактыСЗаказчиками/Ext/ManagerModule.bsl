﻿
Функция ПолучитьЗначениеПоУмолчанию(Организация=Неопределено, Контрагент=Неопределено, ТекущееЗначение = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ТекущееЗначение) Тогда
		Возврат ТекущееЗначение;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	Т.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КонтрактыСЗаказчиками КАК Т
	|ГДЕ
	|	НЕ Т.ПометкаУдаления
	|	И (Т.Владелец = &Организация
	|		ИЛИ &Организация = Неопределено)
	|	И (Т.Контрагент = &Контрагент
	|		ИЛИ &Контрагент = Неопределено)";
	
	Запрос.УстановитьПараметр("Организация", ?(ЗначениеЗаполнено(Организация), Организация, Неопределено));
	Запрос.УстановитьПараметр("Контрагент", ?(ЗначениеЗаполнено(Контрагент), Контрагент, Неопределено));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		ВозвращаемоеЗначение = Выборка.Ссылка;
	Иначе
		ВозвращаемоеЗначение = Справочники.КонтрактыСЗаказчиками.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ОбработатьПрибыльИВозмещение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиКалькуляции.Ссылка,
		|	СтатьиКалькуляции.УдалитьТипСтатьи КАК ТипСтатьи
		|ИЗ
		|	Справочник.СтатьиКалькуляции КАК СтатьиКалькуляции";
	
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРеквизитовСтатей = РезультатЗапроса.Выгрузить();
	
	Выборка = Справочники.КонтрактыСЗаказчиками.Выбрать();
	Пока Выборка.Следующий() Цикл
		СправочникОбъект = Выборка.ПолучитьОбъект();
		КУдалению = Новый Массив;
		НужноСохранять = Ложь;
		Для Каждого СтрокаКалькуляции из СправочникОбъект.КалькуляцияЗатрат Цикл
			ТипСтатьи = ТаблицаРеквизитовСтатей.Найти(СтрокаКалькуляции.СтатьяКалькуляции, "Ссылка").ТипСтатьи;
			Если ТипСтатьи = Перечисления.УдалитьТипыСтатейКалькуляции.Прибыль Тогда
				СправочникОбъект.СуммаПрибыли = СправочникОбъект.СуммаПрибыли + СтрокаКалькуляции.Сумма;
				КУдалению.Добавить(СтрокаКалькуляции);
				НужноСохранять = Истина;
			ИначеЕсли ТипСтатьи = Перечисления.УдалитьТипыСтатейКалькуляции.ВозмещениеПонесенныхЗатрат Тогда
				СтрокаКалькуляции.СуммаКВозмещению = СтрокаКалькуляции.Сумма;
				НужноСохранять = Истина;
			КонецЕсли;
		КонецЦикла;
		Для Каждого УдаляемаяСтрока из КУдалению Цикл
			СправочникОбъект.КалькуляцияЗатрат.Удалить(УдаляемаяСтрока);
		КонецЦикла;
		Если НужноСохранять Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
