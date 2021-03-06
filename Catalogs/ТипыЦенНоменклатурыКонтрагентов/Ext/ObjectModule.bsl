////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПередЗаписью" формы.
//
Процедура ПередЗаписью(Отказ)

	// среди всех типов цен одного контрагента не может быть более одного,
	// ссылающегося на данный тип цен компании
	Если НЕ ОбменДанными.Загрузка И ЗначениеЗаполнено(ТипЦеныНоменклатуры) Тогда
		Отбор = Новый Структура("ТипЦеныНоменклатуры",ТипЦеныНоменклатуры);
		Выборка = Справочники.ТипыЦенНоменклатурыКонтрагентов.Выбрать(,Владелец,Отбор,);
		Пока Выборка.Следующий() Цикл
			Если Ссылка <> Выборка.Ссылка Тогда
				// такой тип цен уже встречался
				#Если Клиент Тогда
				Предупреждение("Тип цен номенклатуры "+Выборка.ТипЦеныНоменклатуры.Наименование+" уже использовался "
				              +"в типе цен номенклатуры контрагента "+Выборка.Наименование+"!");
				#КонецЕсли			  
				Отказ = Истина;
				Возврат;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()

