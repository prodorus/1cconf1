
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронныеДокументы
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "ВыполненоСопоставлениеНоменклатуры" И ТипЗнч(Параметр) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
		ЭлектронныеДокументыКлиент.ПерезаполнитьДокумент(Параметр, , Истина);
	КонецЕсли;
	// Конец ЭлектронныеДокументы
	
КонецПроцедуры
