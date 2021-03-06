////////////////////////////////////////////////////////////////////////////////
// Содержит процедуры для заполнения форм отчетности:
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура ЗаполнитьРегламентированныйОтчет
//
// Описание:
//	Универсальная процедура для заполнения регламентированных отчетов
//
// Параметры:
//		ПараметрыОтчета - структура
//		Структура содержит свойство "ВидОтчета" 
//		ВидОтчета - строка - идентификатор регламентированного отчета получаемый из имени отчета и имени формы отчета
//		Например "РегламентированныйОтчетНДСФормаОтчета2015Кв1"
Процедура ЗаполнитьРегламентированныйОтчет(ПараметрыОтчета) Экспорт

	Если ПараметрыОтчета.Свойство("ВидОтчета") Тогда
		
		Если ПараметрыОтчета.ВидОтчета = "РегламентированныйОтчетНДСФормаОтчета2015Кв1" Тогда
			УчетНДСФормированиеОтчетности.ЗаполнитьОтчетНДСФормаОтчета2015Кв1(ПараметрыОтчета);
		ИначеЕсли ПараметрыОтчета.ВидОтчета = "РегламентированныйОтчетНДСФормаОтчета2017Кв1" Тогда
			УчетНДСФормированиеОтчетности.ЗаполнитьОтчетНДСФормаОтчета2017Кв1(ПараметрыОтчета);
		ИначеЕсли ПараметрыОтчета.ВидОтчета = "РегламентированныйОтчетНДСФормаОтчета2019Кв1" Тогда
			УчетНДСФормированиеОтчетности.ЗаполнитьОтчетНДСФормаОтчета2019Кв1(ПараметрыОтчета);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры
