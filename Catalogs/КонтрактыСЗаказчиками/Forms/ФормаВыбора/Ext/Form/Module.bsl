﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбщегоНазначения275КлиентСервер.ПроверитьИспользованиеПодсистемы(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Перем Отбор;

	Если Параметры.Свойство("Отбор", Отбор) Тогда
		Если Отбор.Свойство("ГосударственныйКонтракт", ГосударственныйКонтракт) Тогда
			Шаблон = НСтр("ru = 'Контракты с заказчиками по государственному контракту: %1'");
			АвтоЗаголовок = Ложь;
			Заголовок = СтрШаблон(Шаблон, ?(ЗначениеЗаполнено(ГосударственныйКонтракт), ГосударственныйКонтракт, НСтр("ru = '<не указан>'")));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
