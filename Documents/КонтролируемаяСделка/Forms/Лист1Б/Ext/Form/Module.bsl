﻿&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	Если ПроверитьЗаполнение() Тогда
		Модифицированность = Ложь;
		Закрыть(ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеЗаполнения);
	
	ВерсияУведомления = Параметры.ВерсияУведомления;
	ТипПредметаСделки = Параметры.ТипПредметаСделки;
	
	Если ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018() Тогда
		Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
	Иначе
		Валюта = Параметры.Валюта;
	КонецЕсли;
	
	НастроитьЭлементыПоВерсииФормата();
	
	СписокКодовПоставки = КонтролируемыеСделкиПовтИсп.ПолучитьКодыУсловийПоставки();
	Элементы.КодУсловийПоставки.СписокВыбора.Очистить();
	Для Каждого Код Из СписокКодовПоставки Цикл
		НовыйКод = Элементы.КодУсловийПоставки.СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйКод, Код);
	КонецЦикла;
	
КонецПроцедуры

Функция ТипПоказателяКоличество(ВерсияУведомления)
	
	Если ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018() Тогда
		Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0));
	Иначе
		Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(14, 5));
	КонецЕсли;
	
КонецФункции

Функция ТипПоказателяЦена(ВерсияУведомления)
	
	Если ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018() Тогда
		Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0));
	Иначе
		Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(18, 4));
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура НастроитьЭлементыПоВерсииФормата()
	
	Элементы.ПроцентнаяСтавка.Видимость = 
		ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018()
		И ТипПредметаСделки = Перечисления.ТипыПредметовКонтролируемыхСделок.ДолговоеОбязательство;
	
	Элементы.ГруппаЦена.Видимость = 
		ВерсияУведомления < КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018()
		Или ТипПредметаСделки <> Перечисления.ТипыПредметовКонтролируемыхСделок.ДолговоеОбязательство;
	
	Версия2018ИВыше = ВерсияУведомления >= КонтролируемыеСделкиКлиентСервер.ВерсияУведомления_2018();
	Элементы.ГородОтправкиТовара.Видимость = Не Версия2018ИВыше;
	Элементы.ГородСовершенияСделки.Видимость = Не Версия2018ИВыше;
	
	Элементы.Количество.ОграничениеТипа = ТипПоказателяКоличество(ВерсияУведомления);
	
	Элементы.Цена.ОграничениеТипа = ТипПоказателяЦена(ВерсияУведомления);
	
КонецПроцедуры