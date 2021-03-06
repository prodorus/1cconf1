////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы

#Если ТолстыйКлиентОбычноеПриложение Тогда

Функция ПолучитьПредставлениеСпособаОтражения(СпособОтражения) Экспорт
	
	Если Не СпособОтражения.Предопределенный Тогда
		
		// для не предопределенных способов отражения возвращаем наименование способа,
		//как пользователь задал его в справочнике
		Возврат СпособОтражения.Наименование;
		
	Иначе
		
		//для предопределенных способов сформируем представление
		
		Если СпособОтражения = Справочники.СпособыОтраженияЗарплатыВРеглУчете.БольничныйЗаСчетРаботодателя 
			и (Не ЗначениеЗаполнено(СпособОтражения.СчетДт) или Не ЗначениеЗаполнено(СпособОтражения.СчетКт)) Тогда
			Возврат "Распределение по базовым начислениям";
		КонецЕсли;	
		
		ПредставлениеСпособаОтражения = "Дт" + СпособОтражения.СчетДт + " Кт" + СпособОтражения.СчетКт;
		
		Возврат ПредставлениеСпособаОтражения;
		
	КонецЕсли;

КонецФункции

Процедура ПолучитьСпособыОтраженияПоУмолчанию(Организация, ОтражениеНачисленийПоУмолчанию, БольничныйЗаСчетРаботодателяПоУмолчанию, ПодпадаетПодЕНВД) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Организация);
	СрезПоследних   = РегистрыСведений.УчетОсновногоЗаработкаОрганизации.СрезПоследних(ТекущаяДата(), Отбор);
	
	Если СрезПоследних.Количество() > 0 Тогда
		Если ЗначениеЗаполнено(СрезПоследних[0].СпособОтраженияВБухучете) Тогда
			ПодпадаетПодЕНВД = СрезПоследних[0].ПодпадаетПодЕНВД;
			ОтражениеНачисленийПоУмолчанию = СрезПоследних[0].СпособОтраженияВБухучете;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СрезПоследних[0].СпособОтраженияВБухучетеБольничногоЗаСчетРаботодателя) Тогда
			БольничныйЗаСчетРаботодателяПоУмолчанию = СрезПоследних[0].СпособОтраженияВБухучетеБольничногоЗаСчетРаботодателя;
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры

#КонецЕсли