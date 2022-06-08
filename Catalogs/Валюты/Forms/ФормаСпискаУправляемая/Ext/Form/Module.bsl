﻿// Обработчик события ПриСоздании формы.
// Устанавливает параметр КонецПериода запроса равным текущей дате.
//
&НаСервере
Процедура ПриСоздании(Отказ, СтандартнаяОбработка)
	
	ДатаКурса = НачалоДня(ТекущаяДата());
	Список.Параметры.УстановитьЗначениеПараметра ("КонецПериода", ДатаКурса);
	
КонецПроцедуры

// Обработчик события "обработка выбора" формы
// Обработка выбора валюты при подборе из ОКВ
//
&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		ОткрытьФорму("Справочник.Валюты.ФормаЭлементаУправляемая", РезультатВыбора,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры
