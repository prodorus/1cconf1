////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
Процедура ПриОткрытииДополнительно(ЭтаФорма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПоДополнительномуСпособуЗаполнения(ЭтаФорма, Запрос) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Функция ПолучитьВидимостьДополнительногоСпособаЗаполнения(ЭтаФорма, Запрос, ПоШаблону) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено

	ВидимостьДополнительногоСпособаЗаполнения = Ложь;
	
	Возврат ВидимостьДополнительногоСпособаЗаполнения;
	
КонецФункции

Функция ДополнитьИнформационнуюСтроку(ИнфСтрока, График) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
	Возврат Ложь;
	
КонецФункции

Процедура ПриЗаписиПоШаблону(ЭтаФорма) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПриЗаписиПоДополнительномуСпособуЗаполнения(ЭтаФорма) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПоШаблонуПриИзмененииДополнительно(ЭтаФорма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

Процедура ПриИзмененииПоШаблону(ЭтаФорма) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры

#КонецЕсли