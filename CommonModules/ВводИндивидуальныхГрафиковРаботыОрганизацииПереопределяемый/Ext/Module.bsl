
Функция ДополнитьСтруктуруПечатныхФорм(СтруктураМакетов) Экспорт

	Возврат СтруктураМакетов
	
КонецФункции

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
// Возвращает "длинное" описание печатной формы
//
// Параметры
//  ИмяМакета - строка, идентификатор печатной формы
//
// Возвращаемое значение:
//   строка
//
Функция ПолучитьОписаниеПечатнойФормы(ИмяМакета) Экспорт

	Если ИмяМакета = "Т13" Тогда
		Возврат Метаданные.Отчеты.УнифицированнаяФормаТ13.Синоним
	Иначе
		Возврат ""
	КонецЕсли;

КонецФункции // ПолучитьОписаниеПечатнойФормы()

// Для переданного документа формирует указанную печатную форму
//
// Параметры
//  ИмяМакета - строка, идентификатор печатной формы
//
// Возвращаемое значение:
//   табличный документ или Неопределено
//
Функция СформироватьПечатнуюФорму(ИмяМакета, ДокументОбъект, СписокСотрудников) Экспорт

	Возврат Неопределено;
	
КонецФункции // СформироватьПечатнуюФорму()

#КонецЕсли


