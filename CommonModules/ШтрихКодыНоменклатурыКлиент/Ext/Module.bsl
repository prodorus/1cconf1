Функция ВвестиШтрихкод(Штрихкод) Экспорт

	Результат = Ложь;

	Штрихкод = "";
	Если ВвестиЗначение(Штрихкод, НСтр("ru = 'Введите штрихкод'")) Тогда
		Если Не ПустаяСтрока(Штрихкод) Тогда
			Результат = Истина;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции
