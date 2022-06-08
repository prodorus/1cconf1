﻿#Если Клиент Тогда
	
Перем НП Экспорт;

// Выполняет запрос и формирует таблицу соответствующую базе распределения
// косвенных расходов
//
Процедура ВывестиВОтчетДанныеПоБазеРаспределения(ДокументРезультат, Макет)
	
	// Подсчитываем выручку от реализации
	ВыручкаЕНВД                 = 0;
	ВыручкаБезНДС               = 0;
	ВыручкаНДС0                 = 0;
	ВыручкаНДС                  = 0;
	ВыручкаНДС0ТоварыНесырьевые = 0;
	
	УчетНДС.РассчитатьВыручкуДляНДС(
		Организация, ДатаНач, ДатаКон, 
		ВыручкаЕНВД, ВыручкаБезНДС, ВыручкаНДС0, ВыручкаНДС, ВыручкаНДС0ТоварыНесырьевые);
	
	ВсегоВыручка = ВыручкаЕНВД + ВыручкаБезНДС + ВыручкаНДС0 + ВыручкаНДС;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				   |	РаспределениеНДСКосвенныхРасходов.Ссылка КАК ДокументРаспределения,
	               |	СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаЕНВД) КАК ВыручкаЕНВД,
	               |	СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаБезНДС) КАК ВыручкаБезНДС,
	               |	СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаНДС0) КАК ВыручкаНДС0,
	               |	СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаНДС) КАК ВыручкаНДС,
	               |	СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаЕНВД) + СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаБезНДС) + СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаНДС0) + СУММА(РаспределениеНДСКосвенныхРасходов.ВыручкаНДС) КАК ВсегоВыручка
	               |ИЗ
	               |	Документ.РаспределениеНДСКосвенныхРасходов КАК РаспределениеНДСКосвенныхРасходов
				   |";
				   
	Если НЕ ЗначениеЗаполнено(ДокументРаспределения) Тогда
		Запрос.Текст = Запрос.Текст +  "ГДЕ
	               					   |	РаспределениеНДСКосвенныхРасходов.Организация = &Организация
	               					   |" + ?(НЕ ЗначениеЗаполнено(ДатаНач), "",	"И РаспределениеНДСКосвенныхРасходов.НачалоПериода МЕЖДУ &НачалоПериодаОтчета И &КонецПериодаОтчета") + "
	               					   |" + ?(НЕ ЗначениеЗаполнено(ДатаКон), "",	"И РаспределениеНДСКосвенныхРасходов.Дата МЕЖДУ &НачалоПериодаОтчета И &КонецПериодаОтчета") + "
	               					   |	И РаспределениеНДСКосвенныхРасходов.Проведен = &Проведен
									   |";
	Иначе
		Запрос.Текст = Запрос.Текст +  "ГДЕ
									   |	РаспределениеНДСКосвенныхРасходов.Ссылка = &Ссылка
									   |";
	КонецЕсли;									   
	
	Запрос.Текст = Запрос.Текст + "СГРУППИРОВАТЬ ПО
				   				  |	РаспределениеНДСКосвенныхРасходов.Ссылка";
					
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("НачалоПериодаОтчета", НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("КонецПериодаОтчета",  ?(НЕ ЗначениеЗаполнено(ДатаКон), ДатаКон, КонецДня(ДатаКон)));
	Запрос.УстановитьПараметр("Проведен",	   Истина);
	Запрос.УстановитьПараметр("Ссылка", ДокументРаспределения);

	Результат = Запрос.Выполнить().Выбрать();
	
	// Сравнение выручки по регистрам учета с выручкой в документе
	Пока Результат.Следующий() Цикл
		Если Результат.ВыручкаБезНДС <> ВыручкаБезНДС Тогда
			Сообщить(Результат.ДокументРаспределения);
			Сообщить("Выручка, не облагаемая НДС по документу (" + Результат.ВыручкаБезНДС + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")" +
					" не соответствует выручке по регистрам учета подсистемы НДС (" + ВыручкаБезНДС + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")", СтатусСообщения.Внимание);
		КонецЕсли;
		Если Результат.ВыручкаЕНВД <> ВыручкаЕНВД Тогда
			Сообщить(Результат.ДокументРаспределения);
			Сообщить("Выручка, по деятельности облагаемой ЕНВД по документу (" + Результат.ВыручкаЕНВД + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")" +
					" не соответствует выручке по регистрам учета подсистемы НДС (" + ВыручкаЕНВД + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")", СтатусСообщения.Внимание);
		КонецЕсли;
		Если Результат.ВыручкаНДС0 <> ВыручкаНДС0 Тогда
			Сообщить(Результат.ДокументРаспределения);
			Сообщить("Выручка, облагаемая НДС по ставке 0% по документу (" + Результат.ВыручкаНДС0 + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")" +
					" не соответствует выручке по регистрам учета подсистемы НДС (" + ВыручкаНДС0 + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")", СтатусСообщения.Внимание);
		КонецЕсли;
		Если Результат.ВыручкаНДС <> ВыручкаНДС Тогда
			Сообщить(Результат.ДокументРаспределения);
			Сообщить("Выручка, облагаемая НДС по обычным ставкам по документу (" + Результат.ВыручкаНДС + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")" +
					" не соответствует выручке по регистрам учета подсистемы НДС (" + ВыручкаНДС + " " + глЗначениеПеременной("ВалютаРегламентированногоУчета") + ")", СтатусСообщения.Внимание);
		КонецЕсли;
	КонецЦикла;
				
	ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ПараметрыБазыРаспределения");
	ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
	Если ВыручкаПоДокументам Тогда
		Результат.Сбросить();
		Пока Результат.Следующий() Цикл
			ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ДокументБазыРаспределения");
			ОбластьШапкаТаблицы.Параметры.Заполнить(Результат);
			ОбластьШапкаТаблицы.Параметры.Расшифровка = Результат.ДокументРаспределения;
			ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
			
			ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("СтрокаБазыРаспределения");
			ОбластьШапкаТаблицы.Параметры.Заполнить(Результат);
			ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
		КонецЦикла;
	Иначе
			ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("СтрокаБазыРаспределения");
			ОбластьШапкаТаблицы.Параметры.ВсегоВыручка 	= ВсегоВыручка;
			ОбластьШапкаТаблицы.Параметры.ВыручкаБезНДС = ВыручкаБезНДС;
			ОбластьШапкаТаблицы.Параметры.ВыручкаЕНВД 	= ВыручкаЕНВД;
			ОбластьШапкаТаблицы.Параметры.ВыручкаНДС0	= ВыручкаНДС0;
			ОбластьШапкаТаблицы.Параметры.ВыручкаНДС 	= ВыручкаНДС;
			ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиСтрокуТабличнойЧасти(ДокументРезультат, ОбластьСтрока, Выборка)
	
	Если ТипЗнч(Выборка.СчетФактура) = Тип("ДокументСсылка.СчетФактураПолученный") Тогда
		ОбластьСтрока.Параметры.ДатаОперации = "" + Формат(Выборка.СчетФактура.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy") + ", №" + Выборка.СчетФактура.НомерВходящегоДокумента;
	Иначе
		Документ = УчетНДС.НайтиПодчиненныйСчетФактуру(Выборка.СчетФактура, "СчетФактураПолученный");
		Если Документ = Неопределено Тогда
			Попытка
				ОбластьСтрока.Параметры.ДатаОперации = "" + Формат(Выборка.СчетФактура.Дата, "ДФ=dd.MM.yyyy") + ", №" + Выборка.СчетФактура.Номер;
			Исключение
				ОбластьСтрока.Параметры.ДатаОперации = "";
			КонецПопытки; 
		Иначе
			ОбластьСтрока.Параметры.ДатаОперации = "" + Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy") + ", №" + Документ.НомерВходящегоДокумента;
		КонецЕсли;
	КонецЕсли;
	
	ОбластьСтрока.Параметры.Заполнить(Выборка);
	ДокументРезультат.Вывести(ОбластьСтрока);
	
КонецПроцедуры

// Выполняет запрос к регистру НДСПоКосвеннымРасходам
// и выбирает информацию по косвенным расходам текущего периода, которые были
// распределены на соответствующие ставки реализации
//
Процедура ВывестиВОтчетДанныеПоРаспределениюКосвенныхРасходов(ДокументРезультат, Макет)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка КАК ДокументРаспределения,
	               |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.ВидЦенности,
	               |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Поставщик,
	               |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СчетФактура,
	               |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СтавкаНДС,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СуммаВсего) КАК ВсегоСумма,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.НДСВсего) КАК ВсегоНДС,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.БезНДССумма) КАК БезНДССумма,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.БезНДС) КАК БезНДС,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.НДС0Сумма) КАК НДС0Сумма,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.НДС0) КАК НДС0,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.ЕНВДСумма) КАК ЕНВДСумма,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.ЕНВДНДС) КАК ЕНВДНДС,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.НДССумма) КАК Сумма,
	               |	СУММА(РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.НДС) КАК НДС,
				   |	СУММА(ВЫБОР КОГДА НДСВключенныйВСтоимостьОбороты.НДСОборот > 0 ТОГДА НДСВключенныйВСтоимостьОбороты.НДСОборот ИНАЧЕ 0 КОНЕЦ) КАК НДСВключен,
				   |	СУММА(ВЫБОР КОГДА НДСВключенныйВСтоимостьОбороты.НДСОборот < 0 ТОГДА -НДСВключенныйВСтоимостьОбороты.НДСОборот ИНАЧЕ 0 КОНЕЦ) КАК НДСИсключен
	               |ИЗ
	               |	Документ.РаспределениеНДСКосвенныхРасходов.СоставКосвенныхРасходов КАК РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.НДСВключенныйВСтоимость.Обороты(, , Регистратор, ) КАК НДСВключенныйВСтоимостьОбороты
	               |		ПО РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка = НДСВключенныйВСтоимостьОбороты.Регистратор
	               |			И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка.Организация = НДСВключенныйВСтоимостьОбороты.Организация
	               |			И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.ВидЦенности = НДСВключенныйВСтоимостьОбороты.ВидЦенности
	               |			И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СчетФактура = НДСВключенныйВСтоимостьОбороты.СчетФактура
	               |			И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СтавкаНДС = НДСВключенныйВСтоимостьОбороты.СтавкаНДС
	               |			И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СчетУчетаНДС = НДСВключенныйВСтоимостьОбороты.СчетУчетаНДС
	               |			И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Поставщик = НДСВключенныйВСтоимостьОбороты.Поставщик
	               |";
				   
	Если НЕ ЗначениеЗаполнено(ДокументРаспределения) Тогда
		Запрос.Текст = Запрос.Текст +  "ГДЕ
						               |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка.Проведен = &Проведен
						               |	И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка.Организация = &Организация
						               |" + ?(НЕ ЗначениеЗаполнено(ДатаНач), "",	"И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка.НачалоПериода МЕЖДУ &НачалоПериодаОтчета И &КонецПериодаОтчета") + "
						               |" + ?(НЕ ЗначениеЗаполнено(ДатаКон), "",	"И РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка.Дата МЕЖДУ &НачалоПериодаОтчета И &КонецПериодаОтчета");
	Иначе
		Запрос.Текст = Запрос.Текст +  "ГДЕ
									   |	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка = &Ссылка";
	КонецЕсли;									   
								   
									   
	Запрос.Текст = Запрос.Текст +   "
									|СГРУППИРОВАТЬ ПО
									|	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Ссылка,
									|	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.ВидЦенности,
									|	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.Поставщик,
									|	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СчетФактура,
									|	РаспределениеНДСКосвенныхРасходовСоставКосвенныхРасходов.СтавкаНДС
									|АВТОУПОРЯДОЧИВАНИЕ
									|";
		
	Запрос.Текст = Запрос.Текст +  "ИТОГИ
								   |	СУММА(ВсегоСумма),
								   |	СУММА(ВсегоНДС),
								   |	СУММА(БезНДССумма),
								   |	СУММА(БезНДС),
								   |	СУММА(НДС0Сумма),
								   |	СУММА(НДС0),
								   |	СУММА(ЕНВДСумма),
								   |	СУММА(ЕНВДНДС),
								   |	СУММА(Сумма),
								   |	СУММА(НДС),
								   |	СУММА(НДСВключен),
								   |	СУММА(НДСИсключен)
								   |ПО
								   |	ОБЩИЕ
								   |";
	Если ВыручкаПоДокументам Тогда
	    Запрос.Текст = Запрос.Текст + "	,ДокументРаспределения";
 
	КонецЕсли;									
	
	Запрос.УстановитьПараметр("Организация", 			Организация);
	Запрос.УстановитьПараметр("НачалоПериодаОтчета", 	НачалоДня(ДатаНач));
	Запрос.УстановитьПараметр("КонецПериодаОтчета",  	?(НЕ ЗначениеЗаполнено(ДатаКон), ДатаКон, КонецДня(ДатаКон)));
	Запрос.УстановитьПараметр("Проведен",	  			Истина);
	Запрос.УстановитьПараметр("Ссылка", ДокументРаспределения);
	
	Результат = Запрос.Выполнить();
	ВыборкаИтоги = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицыРаспределения");
	ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
	ОбластьСтрокаДокумента = Макет.ПолучитьОбласть("СтрокаДокументРаспределения");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьИтоги  = Макет.ПолучитьОбласть("Итоги");
	
	Пока ВыборкаИтоги.Следующий() Цикл
		
		Если ВыручкаПоДокументам Тогда
			
			ВыборкаДокументы = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			Пока ВыборкаДокументы.Следующий() Цикл
				
				ОбластьСтрокаДокумента.Параметры.Заполнить(ВыборкаДокументы);
				ОбластьСтрокаДокумента.Параметры.Расшифровка = ВыборкаДокументы.ДокументРаспределения;
				ДокументРезультат.Вывести(ОбластьСтрокаДокумента);
				
				ВыборкаСтроки = ВыборкаДокументы.Выбрать();
				Пока ВыборкаСтроки.Следующий() Цикл
	            	ВывестиСтрокуТабличнойЧасти(ДокументРезультат, ОбластьСтрока, ВыборкаСтроки);
				КонецЦикла;
				
			КонецЦикла;
			
		Иначе
			
			ВыборкаСтроки = ВыборкаИтоги.Выбрать();
			Пока ВыборкаСтроки.Следующий() Цикл
            	ВывестиСтрокуТабличнойЧасти(ДокументРезультат, ОбластьСтрока, ВыборкаСтроки);
			КонецЦикла;
			
		КонецЕсли;
		
		ОбластьИтоги.Параметры.Заполнить(ВыборкаИтоги);
		ДокументРезультат.Вывести(ОбластьИтоги);
	
	КонецЦикла;

КонецПроцедуры
	
// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом
//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
//  ДокументОбъект - если указан, то печать отчета по документу
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	НачалоПериода = ДатаНач;
	КонецПериода = ДатаКон;
	
	ДокументРезультат.Очистить();
	
	Макет = ПолучитьМакет("Таблица");	

	ОбластьЗаголовок  = Макет.ПолучитьОбласть("Заголовок");

	Заголовок = "Распределение сумм НДС по приобретенным ценностям, относящимся к косвенным расходам";
	
	НачалоПериода = ?(НЕ ЗначениеЗаполнено(ДокументРаспределения), НачалоПериода, ДокументРаспределения.НачалоПериода);
	КонецПериода  = ?(НЕ ЗначениеЗаполнено(ДокументРаспределения), КонецПериода, УчетНДС.ПолучитьКонецПериодаПоУчетнойПолитике(ДокументРаспределения.Организация, ДокументРаспределения.НачалоПериода));
	
	ОбластьЗаголовок.Параметры.Период = "Период: " + ПредставлениеПериода(НачалоДня(НачалоПериода), КонецДня(КонецПериода)) + ?(НЕ ЗначениеЗаполнено(ДокументРаспределения), "", " по документу """ + ДокументРаспределения + """");
	ОбластьЗаголовок.Параметры.НазваниеОрганизации = ?(НЕ ЗначениеЗаполнено(ДокументРаспределения), Организация.НаименованиеПолное,
																					  			   ДокументРаспределения.Организация.НаименованиеПолное);
	ОбластьЗаголовок.Параметры.Заголовок 		   = Заголовок;
	ОбластьЗаголовок.Параметры.ИННОрганизации      = "" + ?(НЕ ЗначениеЗаполнено(ДокументРаспределения), Организация.ИНН, ДокументРаспределения.Организация.ИНН)+ " / " + 
														  ?(НЕ ЗначениеЗаполнено(ДокументРаспределения), Организация.КПП, ДокументРаспределения.Организация.КПП);
	ДокументРезультат.Вывести(ОбластьЗаголовок);

	// Параметр для показа заголовка
	ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;

	// Когда нужен только заголовок:
	Если ТолькоЗаголовок Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
		ДокументРезультат.Область("R1:R" + ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;

	ВывестиВОтчетДанныеПоБазеРаспределения(ДокументРезультат, Макет);
	
	ВывестиВОтчетДанныеПоРаспределениюКосвенныхРасходов(ДокументРезультат, Макет);

КонецПроцедуры // СформироватьОтчет

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

НП           = Новый НастройкаПериода;

#КонецЕсли