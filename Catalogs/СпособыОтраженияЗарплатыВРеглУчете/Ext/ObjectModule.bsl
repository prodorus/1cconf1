
Процедура УстановитьТипыСубконто(Счет, ДтКт) Экспорт

	ВидыСубконтоСчета = Счет.ВидыСубконто;

	Для Ном = 1 по 3 Цикл
		Если Ном <= ВидыСубконтоСчета.Количество() и ЗначениеЗаполнено(Счет) и
			ВидыСубконтоСчета[Ном-1].ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ЭтотОбъект["Субконто"+ДтКт+Ном])) Тогда
			// Без изменений
		ИначеЕсли Ном <= ВидыСубконтоСчета.Количество() тогда
			ЭтотОбъект["Субконто"+ДтКт+Ном] = Новый(ВидыСубконтоСчета[Ном-1].ВидСубконто.ТипЗначения.Типы()[0]);
		ИначеЕсли  ЭтотОбъект["Субконто"+ДтКт+Ном] <> Неопределено Тогда
			ЭтотОбъект["Субконто"+ДтКт+Ном] = Неопределено;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не ЭтоГруппа Тогда
		
		УстановитьТипыСубконто(СчетДт,   "Дт");
		УстановитьТипыСубконто(СчетДтНУ, "ДтНУ");
		УстановитьТипыСубконто(СчетКт,   "Кт");
		УстановитьТипыСубконто(СчетКтНУ, "КтНУ");
		
	КонецЕсли;
	
КонецПроцедуры

