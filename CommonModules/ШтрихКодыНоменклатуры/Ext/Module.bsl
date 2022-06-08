﻿Функция ПолучитьСведенияПоШтрихКоду(ДанныеШтрихкода) Экспорт

	Если ДанныеШтрихкода.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РегШК.Владелец КАК Владелец,
		|	РегШК.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	РегШК.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	РегШК.СерияНоменклатуры КАК СерияНоменклатуры,
		|	РегШК.Качество КАК Качество
		|ИЗ
		|	РегистрСведений.Штрихкоды КАК РегШК
		|ГДЕ
		|	РегШК.Штрихкод = &Штрихкод
		|	И РегШК.Владелец ССЫЛКА Справочник.Номенклатура";
		
	Запрос.УстановитьПараметр("Штрихкод", ДанныеШтрихкода.Штрихкод);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	СведенияПоШтрихКоду = Новый Структура;
	СведенияПоШтрихКоду.Вставить("Номенклатура",               Выборка.Владелец);
	СведенияПоШтрихКоду.Вставить("ХарактеристикаНоменклатуры", Выборка.ХарактеристикаНоменклатуры);
	СведенияПоШтрихКоду.Вставить("СерияНоменклатуры",          Выборка.СерияНоменклатуры);
	СведенияПоШтрихКоду.Вставить("Качество",                   Выборка.Качество);
	СведенияПоШтрихКоду.Вставить("ЕдиницаИзмерения",           Выборка.ЕдиницаИзмерения);
	СведенияПоШтрихКоду.Вставить("Количество",                 1);

	Возврат СведенияПоШтрихКоду;

КонецФункции
