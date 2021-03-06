// Выполняет проверку учетной записи
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//					которую нужно проверить
//
Процедура ПроверитьУчетнуюЗапись(знач УчетнаяЗапись) Экспорт
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Проверка учетной записи'"),,НСтр("ru = 'Выполняется проверка учетной записи. Подождите...'"));
	
	Если ЭлектроннаяПочта.ПарольЗадан(УчетнаяЗапись) Тогда
		ПарольПараметр = Неопределено;
	Иначе
		ПараметрУчетнаяЗапись = Новый Структура("УчетнаяЗапись", УчетнаяЗапись);
		ПарольПараметр = ОткрытьФормуМодально("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи", ПараметрУчетнаяЗапись);
		Если ТипЗнч(ПарольПараметр) <> Тип("Строка") Тогда
			Возврат
		КонецЕсли;
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	ЭлектроннаяПочта.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр, СообщениеОбОшибке, ДополнительноеСообщение);
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками:
								   |%1'"), СообщениеОбОшибке ),,
						НСтр("ru = 'Проверка учетной записи'"));
	Иначе
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Проверка параметров учетной записи завершилась успешно!%1'"),
						ДополнительноеСообщение ),,
						НСтр("ru = 'Проверка учетной записи'"));
	КонецЕсли;
	
КонецПроцедуры // ПроверитьУчетнуюЗапись()
