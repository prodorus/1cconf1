﻿
Функция ВидыПодтверждающиеИсполнениеКонтракта() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВидыДокументов.Ссылка
	|ИЗ
	|	Справочник.ВидыДокументов КАК ВидыДокументов
	|ГДЕ
	|	ВидыДокументов.ПодтверждаетИсполнениеКонтракта";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции 

Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	МакетПоставляемыеДанные = Справочники.ВидыДокументов.ПолучитьМакет("ПоставляемыеДанные").ПолучитьТекст();
	ТаблицаПоставляемыхДанных = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетПоставляемыеДанные).Данные;
	
	Для Каждого СтрокаПоставляемыхДанных Из ТаблицаПоставляемыхДанных Цикл 
		ЭлементОбъект = Справочники.ВидыДокументов[СтрокаПоставляемыхДанных.Имя].ПолучитьОбъект();
		
		ЗаполнитьЗначенияСвойств(ЭлементОбъект, СтрокаПоставляемыхДанных, "КраткоеНаименование, ПодтверждаетИсполнениеКонтракта");
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлементОбъект);
	КонецЦикла;
КонецПроцедуры
