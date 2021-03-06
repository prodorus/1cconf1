
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ И ЗАПИСИ ДОКУМЕНТА

Процедура ДополнительныеДействияПередЗаписью(ДокументОбъект) Экспорт
	
	// очистим табличные части документа
	Если НачалоМесяца(ДокументОбъект.ПериодРегистрации) < НачалоМесяца(ПроведениеРасчетовДополнительный.ПолучитьДатуВступленияВСилуИзмененийПоСоциальнымПособиям2006()) Тогда
		ДокументОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет.Очистить();
		ДокументОбъект.ПособияСоциальномуСтрахованию.Очистить();
	КонецЕсли;

КонецПроцедуры

Процедура ДополнительныеДействияОбработкиПроведения(ДокументОбъект, ВыборкаПоШапкеДокумента, Заголовок, Отказ) Экспорт

	Если НачалоМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации) >= НачалоМесяца(ПроведениеРасчетовДополнительный.ПолучитьДатуВступленияВСилуИзмененийПоСоциальнымПособиям2006()) Тогда
		
		ДокументОбъект.Движения.ПособияСоциальномуСтрахованию.мВыполнятьДополнительныеДвижения	= Истина;
		ДокументОбъект.Движения.ПособияПоУходуЗаРебенкомДоПолутораЛет.мВыполнятьДополнительныеДвижения	= Истина;
			
		Для каждого СтрокаТЧ Из ДокументОбъект.ПособияСоциальномуСтрахованию Цикл
			// проверим очередную строку табличной части
			РасчетЕСНДополнительный.ПроверитьЗаполнениеСтрокиПособияСоциальномуСтрахованию(СтрокаТЧ, Отказ, Заголовок);
		КонецЦикла; 
		
		Если НЕ Отказ Тогда
			Выборка = РасчетЕСНДополнительный.СформироватьЗапросПоПособияСоциальномуСтрахованию(ДокументОбъект.Ссылка).Выбрать();
			Пока Выборка.Следующий() Цикл 
				ЗаполнитьЗначенияСвойств(ДокументОбъект.Движения.ПособияСоциальномуСтрахованию.Добавить(), Выборка);
			КонецЦикла;
		КонецЕсли;
		
		Для каждого СтрокаТЧ Из ДокументОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет Цикл
			// проверим очередную строку табличной части
			РасчетЕСНДополнительный.ПроверитьЗаполнениеСтрокиПособияПоУходуЗаРебенкомДоПолутораЛет(СтрокаТЧ, Отказ, Заголовок);
		КонецЦикла; 
		
		Если НЕ Отказ Тогда
			Выборка = РасчетЕСНДополнительный.СформироватьЗапросПоПособияПоУходуЗаРебенкомДоПолутораЛет(ДокументОбъект.Ссылка).Выбрать();
			Пока Выборка.Следующий() Цикл 
				ЗаполнитьЗначенияСвойств(ДокументОбъект.Движения.ПособияПоУходуЗаРебенкомДоПолутораЛет.Добавить(),Выборка);
			КонецЦикла;
			Выборка = РасчетЕСНДополнительный.СформироватьЗапросЗаработкиПолучателейПособияПоУходуЗаРебенкомДоПолутораЛет(ДокументОбъект.Ссылка).Выбрать();
			Пока Выборка.Следующий() Цикл 
				ЗаполнитьЗначенияСвойств(ДокументОбъект.Движения.ЗаработкиПолучателейПособияПоУходуЗаРебенкомДоПолутораЛет.Добавить(),Выборка);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура СформироватьДвиженияПоДоходам(ДокументОбъект, ВыборкаПоШапкеДокумента, Заголовок, Отказ, НаборЗаписей = Неопределено) Экспорт
	
	ВыборкаПоДоходам = РасчетЕСНДополнительный.СформироватьЗапросПоДоходам(ВыборкаПоШапкеДокумента).Выбрать();
	Пока ВыборкаПоДоходам.Следующий() Цикл
		РасчетЕСНДополнительный.ПроверитьЗаполнениеСтрокиДохода(ВыборкаПоДоходам, Отказ, Заголовок);
		Если Не Отказ Тогда
			Если НаборЗаписей = Неопределено Тогда
				РасчетЕСНДополнительный.ДобавитьСтрокуВДвиженияПоДоходам(ДокументОбъект, ВыборкаПоДоходам, ВыборкаПоШапкеДокумента);
			Иначе
				СтрокаНабора = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора,ВыборкаПоДоходам);
				ЗаполнитьЗначенияСвойств(СтрокаНабора,ВыборкаПоШапкеДокумента);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАСЧЕТА ЕСН

Процедура РасчетСкидок(ДокументОбъект, ВыборкаПоШапкеДокумента) Экспорт
	
	Отказ = Ложь;
	
	// Запишем данные о доходах из табличной части в регистр расчета
	НаборЗаписейДополнительный = РегистрыРасчета.ЕСНДополнительныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписейДополнительный.Отбор.Регистратор.Значение = ВыборкаПоШапкеДокумента.Ссылка;
	
	ВыборкаПоДоходам = РасчетЕСНДополнительный.СформироватьЗапросПоДоходам(ВыборкаПоШапкеДокумента).Выбрать();
	
	Пока ВыборкаПоДоходам.Следующий() Цикл
		Если ВыборкаПоДоходам.ТипСтроки = "Дополнительные начисления" Тогда
			РасчетЕСНДополнительный.ПроверитьЗаполнениеСтрокиДохода(ВыборкаПоДоходам, Отказ);
			Если Не Отказ Тогда
				СтрокаНабора = НаборЗаписейДополнительный.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора,ВыборкаПоДоходам);
				ЗаполнитьЗначенияСвойств(СтрокаНабора,ВыборкаПоШапкеДокумента);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// запишем движения
	НаборЗаписейДополнительный.Записать();

	// Вызовем функцию расчета скидок по набору записей регистра о дополнительных доходах 
	РасчетЕСНДополнительный.РасчетСкидокКДоходам(ВыборкаПоШапкеДокумента, НаборЗаписейДополнительный);
	ДокументОбъект.ДополнительныеНачисления.Загрузить(НаборЗаписейДополнительный.Выгрузить());
	
	// Очистим ранее записанные в регистры расчетов сведения о доходах
	НаборЗаписейДополнительный.Очистить();
	НаборЗаписейДополнительный.Записать();
	
КонецПроцедуры // РасчетСкидокКДоходам()

// заполнение доходов и расчет документа
//
Процедура Автозаполнение(ДокументОбъект, ВыборкаПоШапкеДокумента, ОграничениеНаСотрудников, Отказ) Экспорт
	
	// Создадим ссылки на наборы записей о доходах
	НаборЗаписейОсновной = РегистрыРасчета.ЕСНОсновныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписейОсновной.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
	
	НаборЗаписейДополнительный = РегистрыРасчета.ЕСНДополнительныеНачисления.СоздатьНаборЗаписей();
	НаборЗаписейДополнительный.Отбор.Регистратор.Значение = ДокументОбъект.Ссылка;
	
	ПособияСоциальномуСтрахованию 		  = ДокументОбъект.ПособияСоциальномуСтрахованию;
	ПособияПоУходуЗаРебенкомДоПолутораЛет = ДокументОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет;
	
	ОсновныеНачисления 		 = ДокументОбъект.ОсновныеНачисления;
	ДополнительныеНачисления = ДокументОбъект.ДополнительныеНачисления;
	
	//подготовим таблицу для регистрации ошибок
	ТаблицаОшибок = Новый ТаблицаЗначений;
	ТаблицаОшибок.Колонки.Добавить("Сотрудник");
	ТаблицаОшибок.Колонки.Добавить("ВидРасчета");
	ТаблицаОшибок.Колонки.Добавить("ПериодДействияНачало");
	ТаблицаОшибок.Колонки.Добавить("ПериодДействияКонец");
	ТаблицаОшибок.Колонки.Добавить("Сторно");
	ТаблицаОшибок.Колонки.Добавить("КодОшибки");
	ТаблицаОшибок.Колонки.Добавить("Регистратор");
	ТаблицаОшибок.Колонки.Добавить("НомерСтроки");
	ТаблицаОшибок.Колонки.Добавить("ВидПособияСоциальногоСтрахования");
	
	// Автозаполним наборы записей о доходах
	Отказ = РасчетЕСНДополнительный.АвтозаполнениеНаборовЗаписейОДоходах(ДокументОбъект, ВыборкаПоШапкеДокумента, НаборЗаписейОсновной, НаборЗаписейДополнительный, ОграничениеНаСотрудников, ТаблицаОшибок);
	
	// Расчет скидок к доходам
	НаборЗаписейДополнительный.Прочитать();
	РасчетЕСНДополнительный.РасчетСкидокКДоходам(ВыборкаПоШапкеДокумента, НаборЗаписейДополнительный);
	НаборЗаписейДополнительный.Записать();
	
	Если НачалоМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации) < НачалоМесяца(ПроведениеРасчетовДополнительный.ПолучитьДатуВступленияВСилуИзмененийПоСоциальнымПособиям2006()) Тогда
		
		// Считаем наборы записей о доходах и выгрузим их в табличные части документа
		НаборЗаписейОсновной.Прочитать();
		
		ВременнаяТаблица = НаборЗаписейОсновной.Выгрузить();
		ВременнаяТаблица.Свернуть("ВидРасчета,Сотрудник,ФизЛицо,КодДоходаЕСН,ОблагаетсяЕНВД,ПериодДействияНачало,ПериодДействияКонец,Сторно, ДокументОснование","Результат");
		ДокументОбъект.ОсновныеНачисления.Загрузить(ВременнаяТаблица);
		
		// НаборЗаписейДополнительный уже считан, не сворачиваем записи, нам нужды детальные записи по доп. начислениям
		ДокументОбъект.ДополнительныеНачисления.Загрузить(НаборЗаписейДополнительный.Выгрузить());
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("парамРегистратор", ДокументОбъект.Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСНОсновныеНачисления.ВидРасчета,
		|	ЕСНОсновныеНачисления.ПериодДействияНачало,
		|	ЕСНОсновныеНачисления.ПериодДействияКонец,
		|	ЕСНОсновныеНачисления.Сторно,
		|	ЕСНОсновныеНачисления.Сотрудник,
		|	ЕСНОсновныеНачисления.Сотрудник.Физлицо КАК Физлицо,
		|	ЕСНОсновныеНачисления.Организация,
		|	СУММА(ЕСНОсновныеНачисления.Результат) КАК Результат,
		|	ЕСНОсновныеНачисления.КодДоходаЕСН,
		|	ЕСНОсновныеНачисления.ОблагаетсяЕНВД,
		|	ЕСНОсновныеНачисления.ДокументОснование
		|ИЗ
		|	РегистрРасчета.ЕСНОсновныеНачисления КАК ЕСНОсновныеНачисления
		|ГДЕ
		|	ЕСНОсновныеНачисления.Регистратор = &парамРегистратор
		|	И ЕСНОсновныеНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЕСНОсновныеНачисления.ВидРасчета,
		|	ЕСНОсновныеНачисления.ПериодДействияНачало,
		|	ЕСНОсновныеНачисления.ПериодДействияКонец,
		|	ЕСНОсновныеНачисления.Сторно,
		|	ЕСНОсновныеНачисления.Сотрудник,
		|	ЕСНОсновныеНачисления.Сотрудник.Физлицо,
		|	ЕСНОсновныеНачисления.Организация,
		|	ЕСНОсновныеНачисления.КодДоходаЕСН,
		|	ЕСНОсновныеНачисления.ОблагаетсяЕНВД,
		|	ЕСНОсновныеНачисления.ДокументОснование";
		
		ДокументОбъект.ОсновныеНачисления.Загрузить(Запрос.Выполнить().Выгрузить());
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСНДополнительныеНачисления.ВидРасчета,
		|	ЕСНДополнительныеНачисления.Сторно,
		|	ЕСНДополнительныеНачисления.Сотрудник,
		|	ЕСНДополнительныеНачисления.Сотрудник.Физлицо КАК Физлицо,
		|	ЕСНДополнительныеНачисления.Организация,
		|	СУММА(ЕСНДополнительныеНачисления.Результат) КАК Результат,
		|	ЕСНДополнительныеНачисления.КодДоходаЕСН,
		|	ЕСНДополнительныеНачисления.ОблагаетсяЕНВД,
		|	ЕСНДополнительныеНачисления.ДокументОснование,
		|	СУММА(ЕСНДополнительныеНачисления.Скидка) КАК Скидка
		|ИЗ
		|	РегистрРасчета.ЕСНДополнительныеНачисления КАК ЕСНДополнительныеНачисления
		|ГДЕ
		|	ЕСНДополнительныеНачисления.Регистратор = &парамРегистратор
		|	И ЕСНДополнительныеНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЕСНДополнительныеНачисления.ВидРасчета,
		|	ЕСНДополнительныеНачисления.Сторно,
		|	ЕСНДополнительныеНачисления.Сотрудник,
		|	ЕСНДополнительныеНачисления.Сотрудник.Физлицо,
		|	ЕСНДополнительныеНачисления.Организация,
		|	ЕСНДополнительныеНачисления.КодДоходаЕСН,
		|	ЕСНДополнительныеНачисления.ОблагаетсяЕНВД,
		|	ЕСНДополнительныеНачисления.ДокументОснование";
		
		ДокументОбъект.ДополнительныеНачисления.Загрузить(Запрос.Выполнить().Выгрузить());
		
	КонецЕсли;
	
	Для Каждого Набор Из ДокументОбъект.Движения Цикл
		Если ТипЗнч(Набор)=Тип("РегистрРасчетаНаборЗаписей.ЕСНОсновныеНачисления") 
			или ТипЗнч(Набор)=Тип("РегистрРасчетаНаборЗаписей.ЕСНДополнительныеНачисления") Тогда
			
			// Удаляем движения
			Набор.Очистить();
			Набор.Записать();
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		
		// есть ошибки в сборе данных по отражению начислений
		                                            
		ТекстСообщения = "Расчет ЕСН не произведен! Для автоматического учета начислений при расчете ЕСН не хватает данных.";
		ОбщегоНазначенияЗК.КомментарийРасчета(ТекстСообщения, , , , Перечисления.ВидыСообщений.Ошибка);
		
		Если ТаблицаОшибок.Количество() > 0 Тогда
			// сообщим пользователю об ошибках
			
			//отсортируем таблицу ошибок по кодам
			ТаблицаОшибок.Сортировать("КодОшибки, ВидРасчета");
			
			НовыйУчетПособий = НачалоМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации) >= НачалоМесяца(ПроведениеРасчетовДополнительный.ПолучитьДатуВступленияВСилуИзмененийПоСоциальнымПособиям2006());
			
			СтруктураПоискаНачисления = Новый Структура("Сотрудник,ВидРасчета,ПериодДействияНачало,ПериодДействияКонец,ДокументОснование,Сторно");
			СтруктураПоискаДополнительныеНачисления = Новый Структура("Сотрудник,ВидРасчета,ДокументОснование,Сторно");
			
			// коды ошибок
			// 1 - сторно, нет данных отражения в учете начисления в прошлых периодах
			// 2 - нет доли ЕНВД для пособий, доля ЕНВД по базовым начислениям
			// 3 - нет данных по базе, нужен код ЕСН и доля ЕНВД
			// 4 - нет данных по базе, нужен код ЕСН 
			// 5 - нет данных по базе, нужна доля ЕНВД
			// 6 - не заполнен код дохода ЕСН у вида расчета
			// 7 - не заполнен код дохода ЕСН у вида расчета, нужна доля ЕНВД
			
			ТекущийКодОшибки = 0;
			ТекущийВидРасчета = ПланыВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка();
			
			Для каждого СтрокаТаблицыОшибок Из ТаблицаОшибок Цикл
				
				Если ТекущийКодОшибки <> СтрокаТаблицыОшибок.КодОшибки или ТекущийВидРасчета <> СтрокаТаблицыОшибок.ВидРасчета Тогда
					//выведем описание ошибки
					ТекстСообщенияРекомендации = "";
					ТекстСообщения = "Начисление: """ + СтрокаТаблицыОшибок.ВидРасчета.Наименование + """. ";
					
					Если СтрокаТаблицыОшибок.КодОшибки = 1 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для учета сторно записи. Отсутствуют данные отражения в учете ЕСН этого начисления в прошлых периодах";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 2 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения доли ЕНВД пособия. Стратегия определения доли ЕНВД - ""по базовым начислениям "" задана в начислении. ";
						Если СтрокаТаблицыОшибок.ВидРасчета.ВидПособияСоциальногоСтрахования <> Перечисления.ВидыПособийСоциальногоСтрахования.ПоУходуЗаРебенкомДоПолутораЛет Тогда
							ТекстСообщенияРекомендации = "Рекомендуется зарегистрировать отражение пособия в учете документом ""Начисление по больничному листу"".
							|На закладке ""Отражение пособия в учете"" установите ""Отражать в учете по данным текущего документа""
							|и заполните таблицу ""Проводки и данные для ЕСН""";
						КонецЕсли;
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 3 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения кода дохода ЕСН и доли ЕНВД. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 4 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения кода дохода ЕСН. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 5 Тогда
						ТекстСообщения = ТекстСообщения + "Нет данных для определения доли ЕНВД. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 6 Тогда
						ТекстСообщения = ТекстСообщения + "Не задан код дохода ЕСН у начисления";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную. Рекомендуется указать порядок учета
													|начисления для целей исчисления ЕСН в форме начисления на закладке ""Учет""";
					ИначеЕсли СтрокаТаблицыОшибок.КодОшибки = 7 Тогда
						ТекстСообщения = ТекстСообщения + "Не задан код дохода ЕСН у начисления. Нет данных для определения доли ЕНВД. Отсутствуют данные о базовых начислениях";
						ТекстСообщенияРекомендации = "Необходимо зарегистрировать данные вручную. Рекомендуется указать порядок учета
													|начисления для целей исчисления ЕСН в форме начисления на закладке ""Учет""";
					Иначе //для этого кода нет текста сообщения
						Продолжить;
					КонецЕсли;	
					
					РодительскаяСтрока = ОбщегоНазначенияЗК.КомментарийРасчета(ТекстСообщения, , , , Перечисления.ВидыСообщений.ВажнаяИнформация);
					Если ЗначениеЗаполнено(ТекстСообщенияРекомендации) Тогда
						ОбщегоНазначенияЗК.КомментарийРасчета(ТекстСообщенияРекомендации, РодительскаяСтрока);	
					КонецЕсли;
					
					ТекущийКодОшибки  = СтрокаТаблицыОшибок.КодОшибки;
					ТекущийВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
					
				КонецЕсли;	
				
				// выведем информацию о том, в каких строках табличных частей проблемы
				Если НовыйУчетПособий Тогда
					//поиск пособий делаем в "новых" табличных частях
					
					Если СтрокаТаблицыОшибок.ВидПособияСоциальногоСтрахования = Перечисления.ВидыПособийСоциальногоСтрахования.ПоУходуЗаРебенкомДоПолутораЛет Тогда
						ТекстТабличнаяЧасть = """Пособия по уходу за ребенком"", ";
						СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ПособияПоУходуЗаРебенкомДоПолутораЛет.НайтиСтроки(СтруктураПоискаНачисления);
					ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицыОшибок.ВидПособияСоциальногоСтрахования)Тогда
						ТекстТабличнаяЧасть = """Пособия по социальному страхованию"", ";
						СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ПособияСоциальномуСтрахованию.НайтиСтроки(СтруктураПоискаНачисления);
					ИначеЕсли ЗначениеЗаполнено(СтрокаТаблицыОшибок.ПериодДействияНачало) Тогда
						ТекстТабличнаяЧасть = """Основные начисления"", ";
                        СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ОсновныеНачисления.НайтиСтроки(СтруктураПоискаНачисления);
					Иначе
						ТекстТабличнаяЧасть = """Дополнительные начисления"", ";
						СтруктураПоискаДополнительныеНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаДополнительныеНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаДополнительныеНачисления.ДокументОснование = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаДополнительныеНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ДополнительныеНачисления.НайтиСтроки(СтруктураПоискаДополнительныеНачисления);
					КонецЕсли;	
					
				Иначе
					
					Если ЗначениеЗаполнено(СтрокаТаблицыОшибок.ПериодДействияНачало) Тогда
						СтруктураПоискаНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаНачисления.ПериодДействияНачало = СтрокаТаблицыОшибок.ПериодДействияНачало;
						СтруктураПоискаНачисления.ПериодДействияКонец  = НачалоДня(СтрокаТаблицыОшибок.ПериодДействияКонец);
						СтруктураПоискаНачисления.ДокументОснование    = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ОсновныеНачисления.НайтиСтроки(СтруктураПоискаНачисления);
						ТекстТабличнаяЧасть = """Основные начисления"", ";
					Иначе
						СтруктураПоискаДополнительныеНачисления.Сотрудник  = СтрокаТаблицыОшибок.Сотрудник;	
						СтруктураПоискаДополнительныеНачисления.ВидРасчета = СтрокаТаблицыОшибок.ВидРасчета;
						СтруктураПоискаДополнительныеНачисления.ДокументОснование = СтрокаТаблицыОшибок.Регистратор;
						СтруктураПоискаДополнительныеНачисления.Сторно     = СтрокаТаблицыОшибок.Сторно;
						НайденныеСтроки = ДополнительныеНачисления.НайтиСтроки(СтруктураПоискаДополнительныеНачисления);
						ТекстТабличнаяЧасть = """Дополнительные начисления"", ";
					КонецЕсли;
					
				КонецЕсли;
				
				Для каждого СтрокаТЧ Из НайденныеСтроки Цикл
					ТекстСообщенияПоСтрокеТЧ = ТекстТабличнаяЧасть + "строка: " + СтрокаТЧ.НомерСтроки;
					ОбщегоНазначенияЗК.КомментарийРасчета(ТекстСообщенияПоСтрокеТЧ, РодительскаяСтрока);
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры // Автозаполнение()

Процедура ОбработатьДанныеДляРасчетаЕСН(ДокументОбъект, ДанныеДляРасчетаЕСН, Отказ) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ДокументОбъект.ИсчисленныйЕСН.Загрузить(ДанныеДляРасчетаЕСН.Выгрузить());	

КонецПроцедуры

Функция ПолучитьТекстЗапросаУчетнаяПолитика() Экспорт
	
	// УчетнаяПолитикаНалоговыйУчет
	// Таблица УчетнаяПолитикаНалоговыйУчет - это список периодов, когда организация переходила на УСН
	// поля:
	//		УСН, 
	//		Месяц - месяц налогового периода
	// Описание:	
	//	Выбираем Из Периоды (таблица - список периодов с начала года по текущий период)
	//	Внутреннее соединение с "псевдосрезом" последних регистра УчетнаяПолитикаНалоговыйУчет
	//	по равенству периодов
	//  условие: что организация использует УСН
	
 	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МЕСЯЦ(Периоды.Период) КАК Месяц,
	|	""поле УСН"" КАК УСН
	|ПОМЕСТИТЬ ВТУчетнаяПолитикаНалоговыйУчет
	|ИЗ
	|	(ВЫБРАТЬ
	|		Периоды.Период КАК Период,
	|		МАКСИМУМ(УчетнаяПолитикаНалоговыйУчет.Период) КАК ПериодРегистра
	|	ИЗ
	|		ВТПериоды КАК Периоды
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчет
	|			ПО Периоды.Период >= УчетнаяПолитикаНалоговыйУчет.Период
	|				И (УчетнаяПолитикаНалоговыйУчет.Организация = &парамГоловнаяОрганизация)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Периоды.Период) КАК Периоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчет
	|		ПО Периоды.ПериодРегистра = УчетнаяПолитикаНалоговыйУчет.Период
	|			И (УчетнаяПолитикаНалоговыйУчет.Организация = &парамГоловнаяОрганизация)
	|			И &ДопУсловие
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Месяц";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"РегистрСведений.УчетнаяПолитикаНалоговыйУчет", ЗаполнениеРегламентированнойОтчетностиПереопределяемый.ИмяУчетнойПолитики()); 
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, """поле УСН""", ЗаполнениеРегламентированнойОтчетностиПереопределяемый.ТекстПоляУСН4аФСС());      
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ДопУсловие", ЗаполнениеРегламентированнойОтчетностиПереопределяемый.ТекстПоляУсловияУСН());

	Возврат ТекстЗапроса;

КонецФункции // ПолучитьТекстЗапросаУчетнаяПолитика()




