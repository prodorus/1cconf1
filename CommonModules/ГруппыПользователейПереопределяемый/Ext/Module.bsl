////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции формы элемента

Процедура ДополнитьТекстЗапроса(ТекстЗапроса) Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	Если НЕ ИспользоватьУправленческийУчетЗарплаты Тогда
		ТекстЗапроса = ТекстЗапроса + "
		|ГДЕ
		| ВидыОбъектовДоступа.Ссылка <> ЗНАЧЕНИЕ(Перечисление.ВидыОбъектовДоступа.Подразделения)";
	КонецЕсли;

КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура ФормаЭлементаПередОткрытиемДополнительно(Форма, ДополнительныеДействия) Экспорт
	
	ГруппыПользователейДополнительный.ФормаЭлементаПередОткрытиемДополнительно(Форма, ДополнительныеДействия);
	
КонецПроцедуры

Процедура ФормаЭлементаПриОткрытииДополнительно(Форма) Экспорт
	
	ГруппыПользователейДополнительный.ФормаЭлементаПриОткрытииДополнительно(Форма);
	
КонецПроцедуры

Процедура ФормаЭлементаПередЗаписьюДополнительно(Форма, Отказ) Экспорт
	
	ГруппыПользователейДополнительный.ФормаЭлементаПередЗаписьюДополнительно(Форма, Отказ);
	
КонецПроцедуры

Процедура ФормаЭлементаПриЗаписиДополнительно(Форма, Отказ) Экспорт
	
	ГруппыПользователейДополнительный.ФормаЭлементаПриЗаписиДополнительно(Форма, Отказ);
	
КонецПроцедуры

Процедура ФормаЭлементаВыполнитьДополнительныеДействия(Элемент, Форма) Экспорт
	
	ГруппыПользователейДополнительный.ФормаЭлементаВыполнитьДополнительныеДействия(Элемент, Форма);
	
КонецПроцедуры

#КонецЕсли