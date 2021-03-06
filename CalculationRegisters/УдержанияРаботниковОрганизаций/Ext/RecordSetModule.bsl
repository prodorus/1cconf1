////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Управление необходимостью делать движения по фактическим отпускам
Перем мВыполнятьСписаниеФактическогоОтпуска Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Процедура ПриЗаписи(Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если мВыполнятьСписаниеФактическогоОтпуска Тогда
		ОстаткиОтпусков.СписатьФактическиеОтпускаУдержаниями(Отбор.Регистратор.Значение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мВыполнятьСписаниеФактическогоОтпуска	= Ложь;
