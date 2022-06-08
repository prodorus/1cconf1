﻿
// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоГруппа Тогда
		
		Если ВидЗатрат.Пустая() Тогда
			Сообщить("Укажите вид затрат!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если ВидЗатрат = Перечисления.ВидыЗатрат.Материальные 
		   И ХарактерЗатрат = Перечисления.ХарактерЗатрат.ПроизводственныеРасходы
		   И СтатусМатериальныхЗатрат.Пустая() Тогда
			Сообщить("Укажите статус материальных затрат!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если ХарактерЗатрат.Пустая() Тогда
			Сообщить("Укажите характер затрат!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если ВидРасходовНУ.Пустая() Тогда
			Сообщить("Укажите вид расходов (НУ)!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если Не ЭтоНовый() Тогда

			Если (ВидЗатрат <> Ссылка.ВидЗатрат
					ИЛИ СтатусМатериальныхЗатрат <> Ссылка.СтатусМатериальныхЗатрат
					ИЛИ ХарактерЗатрат <> Ссылка.ХарактерЗатрат)
			   И ПолныеПрава.СтатьяЗатрат_СуществуютСсылкиВРегистрахНакопления(Ссылка)
			Тогда
				ТекстСообщения = "
				|Статья затрат """ + СокрЛП(Ссылка) + """ указана в проведенных документах.
				|Реквизиты ""Характер затрат"", ""Вид затрат"", ""Статус мат. затрат"" не могут быть изменены!";
				ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

