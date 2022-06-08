﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьРеквизитыПоставляемыхДанных() Экспорт
	МакетПоставляемыеДанные = Справочники.ТоварыРаботыУслугиСТарифнымРегулированием.ПолучитьМакет("МакетТоварыРаботыУслугиСТарифнымРегулированием").ПолучитьТекст();
	ПоставляемыеДанные = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетПоставляемыеДанные).Данные;
	
	Для Каждого СтрокаПоставляемыхДанных Из ПоставляемыеДанные Цикл 
		ЭлементОбъект = Справочники.ТоварыРаботыУслугиСТарифнымРегулированием[СтрокаПоставляемыхДанных.Имя].ПолучитьОбъект();
		ЭлементОбъект.Код = СтрокаПоставляемыхДанных.Код;
		ЭлементОбъект.ПолноеНаименование = СтрокаПоставляемыхДанных.ПолноеНаименование;
		ЭлементОбъект.ОписаниеПунктаЗакона = СтрокаПоставляемыхДанных.ОписаниеПунктаЗакона;
			
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлементОбъект);
	КонецЦикла;
КонецПроцедуры

#КонецЕсли
