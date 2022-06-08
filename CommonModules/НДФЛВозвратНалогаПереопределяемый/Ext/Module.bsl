﻿
////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

// Возвращает текст поля запроса (для предложения ВЫБРАТЬ)
//
// Параметры
//  нет
//
// Возвращаемое значение:
//   строка
//
Функция ПолучитьДополнительноеПолеОписанияСтроки() Экспорт 
	
	Возврат	""

КонецФункции // ПолучитьПоле()

Процедура ДобавитьСтрокуВДвиженияПоРегистрамНакопленияДополнительно(ВыборкаПоШапкеДокумента, ВыборкаПоТЧ) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено	
	
КонецПроцедуры

// Создает дополнительное движение по строке ТЧ
//
// Параметры
//	ВыборкаПоШапкеДокумента
//	ВыборкаПоТЧ
//	СтавкаНалогообложения
//	СуммаВозврата
//
Процедура ДобавитьСтрокуДвиженийПоСтавкеДополнительно(Движения, ВыборкаПоШапкеДокумента, ВыборкаПоТЧ, СтавкаНалогообложения, СуммаВозврата) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено	
	
КонецПроцедуры // ДобавитьСтрокуДвиженийПоСтавкеДополнительно
////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы документа

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
// Добавляет колонки, соответствующие уникальным реквизитам т.ч. документа
//
// Параметры
//  Колонки - КолонкиТабличногоПоля - колонки т.п., редактирующего
//                 табличную часть документа
//
Процедура ДополнитьКолонкиТабличногоПоля(ТабличноеПоле) Экспорт 
	
	// В этой конфигурации дополнительных колонок не предусмотрено	

КонецПроцедуры // ДополнитьКолонкиТабличнойЧасти()

#КонецЕсли

 