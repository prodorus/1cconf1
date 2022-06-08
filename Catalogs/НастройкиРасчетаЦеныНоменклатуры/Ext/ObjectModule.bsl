﻿////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет проверку заполненности реквизитов.
//
// Параметры
//	Заголовок - заголовок сообщения об ошибке
//
// Возвращаемое значение
//	Истина  - все проверяемые реквизиты заполнены
//	Ложь	- не все проверяемые реквизиты заполнены
Функция РеквизитыЗаполнены(Знач Заголовок) Экспорт
	
	Отказ = Ложь;
	
	// Должны быть заполнены обязательные реквизиты
	СтруктураОбязательныхПолей = Новый Структура();
	СтруктураОбязательныхПолей.Вставить("ТипЦен",			"Не указан тип цен, который будет заполняться информацией о себестоимости");
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	Возврат НЕ Отказ;
		
КонецФункции

// Подготавливает заголовок сообщений об ошибках при записи
//
// Возвращаемое значение
//  Строка, заголовок сообщений
Функция ЗаголовокПриЗаписи() Экспорт
	
	Возврат "Запись настройки расчета цены номенклатуры """ + Наименование + """";
	
КонецФункции

// Возвращает имя объекта метаданных для создания регл. задания
//
// Возвращаемое значение
//	Строка  - имя объекта метаданных
Функция ИмяРегламентногоЗадания() Экспорт
	
	Возврат "РасчетЦеныНоменклатуры";
	
КонецФункции	
