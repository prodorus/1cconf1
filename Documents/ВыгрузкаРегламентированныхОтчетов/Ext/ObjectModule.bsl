
Процедура ОбработкаПроведения(Отказ, Режим)
	
	//Сохраним сформированный файл сведений в регистре сведений
	Запись = Движения.АрхивДанныхРегламентированнойОтчетности.Добавить();
	Запись.Объект = Ссылка;
	Запись.ОписаниеДанных = "Групповая выгрузка регл. отчетности";
	
	Для Каждого Стр Из Выгрузки Цикл
		Запись.Данные = Запись.Данные + Стр.Текст;
	КонецЦикла;
		
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	ОбщегоНазначения.ДобавитьПрефиксОрганизации(ЭтотОбъект, Префикс);
	//ОбщегоНазначения.ДобавитьПрефиксУзла(Префикс);
	
КонецПроцедуры
