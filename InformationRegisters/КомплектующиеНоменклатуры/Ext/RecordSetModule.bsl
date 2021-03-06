
Процедура ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Для каждого ЗаписьРегистра Из ЭтотОбъект Цикл

		Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.Номенклатура) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Номенклатура должна быть заполнена обязательно!", Отказ);
		ИначеЕсли ЗаписьРегистра.Номенклатура.Услуга Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Номенклатура не может быть услугой!", Отказ);
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(ЗаписьРегистра.Комплектующая) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Комплектующая должна быть заполнена обязательно!", Отказ);
		ИначеЕсли ЗаписьРегистра.Комплектующая.Услуга Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Комплектующая не может быть услугой!", Отказ);
		ИначеЕсли ЗаписьРегистра.Комплектующая.Набор Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Комплектующая не может быть набором!", Отказ);
		ИначеЕсли ЗаписьРегистра.Комплектующая.Комплект Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Комплектующая не может быть набором-комплектом!", Отказ);
		КонецЕсли;
		
		Если (ЗаписьРегистра.Комплектующая = ЗаписьРегистра.Номенклатура)
		   И ЗначениеЗаполнено(ЗаписьРегистра.Номенклатура) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Номенклатура не может совпадать с комплектующей!", Отказ);
		КонецЕсли;

		Если ЗаписьРегистра.Количество = 0 Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Количество не должно быть нулевым!", Отказ);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры



