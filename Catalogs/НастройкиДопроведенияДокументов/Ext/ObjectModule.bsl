// Подготавливает заголовок сообщений об ошибках при записи
//
// Возвращаемое значение
//  Строка, заголовок сообщений
Функция ЗаголовокПриЗаписи() Экспорт
	
	Возврат "Запись настройки допроведения документов """ + Наименование + """";
	
КонецФункции

// Выполняет проверку заполненности реквизитов.
//
// Параметры
//	Заголовок - заголовок сообщения об ошибке
//
// Возвращаемое значение
//	Истина  - все проверяемые реквизиты заполнены
//	Ложь	- не все проверяемые реквизиты заполнены
Функция РеквизитыЗаполнены(Знач Заголовок) Экспорт
	
	Отказ = НЕ ЗначениеЗаполнено(Наименование);
	
	Возврат НЕ Отказ;
		
КонецФункции

// Возвращает имя объекта метаданных для создания регл. задания
//
// Возвращаемое значение
//	Строка  - имя объекта метаданных
Функция ИмяРегламентногоЗадания() Экспорт
	
	Возврат "ДопроведениеДокументов";
	
КонецФункции	


Процедура ПередЗаписью(Отказ)
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указано наименование", Отказ, ЗаголовокПриЗаписи());
	КонецЕсли;
КонецПроцедуры

