////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет проверку заполненности реквизитов.
//
// Параметры
//	Заголовок - заголовок сообщения об ошибке
//
// Возвращаемое значение
//	Истина  - все проверяемые реквизиты заполнены
//	Ложь	- не все проверяемые реквизиты заполнены
Функция РеквизитыЗаполнены(Знач Заголовок) Экспорт
	
	Отказ = Ложь;
	
	Возврат НЕ Отказ;
		
КонецФункции

// Подготавливает заголовок сообщений об ошибках при записи
//
// Возвращаемое значение
//  Строка, заголовок сообщений
Функция ЗаголовокПриЗаписи() Экспорт
	
	Возврат "Запись настройки расчета себестоимости """ + Наименование + """";
	
КонецФункции

// Возвращает имя объекта метаданных для создания регл. задания
//
// Возвращаемое значение
//	Строка  - имя объекта метаданных
Функция ИмяРегламентногоЗадания() Экспорт
	
	Возврат "РасчетСебестоимости";
	
КонецФункции
