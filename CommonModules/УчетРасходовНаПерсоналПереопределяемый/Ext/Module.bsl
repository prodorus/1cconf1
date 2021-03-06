
Процедура ДополнитьДвиженияСведениямиДляУпрУчета(Движения, Выборка, ДатаС, ДатаПо = Неопределено, ИмяПоляПодразделение = "Подразделение", ПрефиксИмениПоля = "") Экспорт
	
	Если ЗначениеЗаполнено(Выборка.СпособОтраженияВУпрУчете) ИЛИ Выборка.УчетНачисленийПоОрганизации Тогда
		
		Движение = Движения.УчетЗаработкаРаботников.Добавить();
		// Свойства
		Движение.Период						= ДатаС;
		// Измерения
		Движение.Физлицо					= Выборка.Физлицо;
		// Ресурсы
		Движение.СпособОтраженияВУпрУчете	= Выборка[ПрефиксИмениПоля + "СпособОтраженияВУпрУчете"];
		Движение.УчетНачисленийПоОрганизации= Выборка[ПрефиксИмениПоля + "УчетНачисленийПоОрганизации"];
		
		// добавляем "пустую" запись "по завершении"
		Если ЗначениеЗаполнено(ДатаПо) Тогда
			Движение = Движения.УчетЗаработкаРаботников.Добавить();
			Движение.Период			= НачалоДня(ДатаПо) + 3600 * 24;
			Движение.Физлицо 		= Выборка.Физлицо;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура НастройкаПараметровУчетаПередОткрытиемФормы(ОбработкаНастройкаПараметровУчета, Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы подразделения

Процедура ПередОткрытиемФормыПодразделенияДополнительно(Форма, ДополнительныеДействия) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ВыполнитьДополнительныеДействияФормыПодразделения(Элемент, Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ОбработатьОповещениеФормыПодразделения(ИмяСобытия, Параметр, Источник, Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы форм объектов, участвующих в учете расходов на персонал

Процедура ФормаВидаРасчетаУстановитьВидимостьДополнительно(Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПередОткрытиемФормыКадровогоДокументаДополнительно(Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПриОткрытииФормыДокументаПланированияУчетаЗатратДополнительно(Форма, ТабличнаяЧасть) Экспорт

	// Управление видимостью элементов формы, связанных с методом планирования затрат
	МетодПланированияУчетаЗатратНаПерсонал = Константы.МетодПланированияУчетаЗатратНаПерсонал.Получить();
	
	ПоказыватьКатегориюЗатраты = МетодПланированияУчетаЗатратНаПерсонал = Перечисления.МетодыПланированияУчетаЗатратНаПерсонал.КассовыйМетодСВыделениемНалогов
								ИЛИ МетодПланированияУчетаЗатратНаПерсонал = Перечисления.МетодыПланированияУчетаЗатратНаПерсонал.МетодНачисленийСВыделениемНалогов;
	
	ТабличнаяЧасть.Колонки.КатегорияЗатраты.Видимость			= ПоказыватьКатегориюЗатраты;
	ТабличнаяЧасть.Колонки.КатегорияЗатраты.ИзменятьВидимость	= Ложь;
	

	// Управление доступностью категории затраты НДФЛ для выбора в документах
	МетодПланированияУчетаЗатратНаПерсонал = Константы.МетодПланированияУчетаЗатратНаПерсонал.Получить();
	
	// Скрывать категорию имеет смысл только если у пользователя установлен метод начислений с выделением налогов
	СкрытьКатегориюЗатратыНДФЛ = МетодПланированияУчетаЗатратНаПерсонал = Перечисления.МетодыПланированияУчетаЗатратНаПерсонал.МетодНачисленийСВыделениемНалогов;
	
	Если Не СкрытьКатегориюЗатратыНДФЛ Тогда
		Возврат;
	КонецЕсли;
	
	ДоступныеЗначения = ТабличнаяЧасть.Колонки.КатегорияЗатраты.ЭлементУправления.ДоступныеЗначения;
	
	// Переберем все значения через метаданные
	// Это позволит не дорабатывать функцию при появлении новых категорий
	Для Каждого Значение Из Перечисления.КатегорииЗатраты Цикл
		Если Значение = Перечисления.КатегорииЗатраты.НДФЛ Тогда
			Продолжить;
		КонецЕсли;
		
		ДоступныеЗначения.Добавить(Значение);
	КонецЦикла;
	
КонецПроцедуры

Процедура ФормаСценарияПланированияДополнительно(Форма) Экспорт
		
    // В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Прочие процедуры и функции

Процедура ИменаДополнительныхТиповДополнитьОбъектамиУчетаРасходов(ИменаДополнительныхТипов) Экспорт
	
	ИменаДополнительныхТипов.Добавить(Тип("ДокументОбъект.ВводРаспределенияЗаработкаРаботников"));
	ИменаДополнительныхТипов.Добавить(Тип("ДокументОбъект.ОтражениеЗарплатыВУпрУчете"));
	
КонецПроцедуры
