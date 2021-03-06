Процедура СвернутьДокументыОснования() Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Основания.Ссылка КАК Ссылка,
	|	КОЛИЧЕСТВО(Основания.ДокументОснование) КАК КоличествоОснований
	|ПОМЕСТИТЬ КОбработке
	|ИЗ
	|	Документ.ЭлектронныйДокументИсходящий.ДокументыОснования КАК Основания
	|
	|СГРУППИРОВАТЬ ПО
	|	Ссылка
	|;
	|///////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КОбработке.Ссылка КАК Ссылка
	|ИЗ
	|	КОбработке КАК КОбработке
	|ГДЕ
	|	КОбработке.КоличествоОснований > 1
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Документ.ЭлектронныйДокументИсходящий");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			ЭлектронныйДокумент = Выборка.Ссылка.ПолучитьОбъект();
			ЭлектронныйДокумент.ДокументыОснования.Свернуть("ДокументОснование");
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭлектронныйДокумент);
				
			ЗафиксироватьТранзакцию();
				
		Исключение
			ОтменитьТранзакцию();
			Операция = НСтр("ru = 'Обновление подсистемы обмена с контрагентами'");
			ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронныеДокументыСлужебныйВызовСервера.ОбработатьОшибку(Операция, ПодробныйТекстОшибки);
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////
// Обработчики обновления

// Обработчик обновления 1.1.25.47.
Процедура ПеренестиИсходящиеЭлектронныеДокументы() Экспорт
	
	Документы.ЭлектронныйДокументВходящий.ПеренестиЭлектронныеДокументы(
		Метаданные.Документы.УдалитьЭлектронныйДокументИсходящий.Имя,
		Метаданные.Документы.ЭлектронныйДокументИсходящий.Имя,
		НСтр("ru = 'Перенос данных исходящих электронных документов'"));
	
КонецПроцедуры

#КонецЕсли