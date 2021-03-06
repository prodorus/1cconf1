Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Проверяет, что счет является субсчетом
//
// Параметры:
//	Проверяемый счет, Счет-родитель, общая структура параметров.
//
// Возвращаемое значение:
//	
//
Функция СчетВИерархииЛок(ПроверяемыйСчет, СчетРодитель, СтруктураПараметров)
	
	Перем СоотвИерархияСчетов;
	
	Если НЕ ЗначениеЗаполнено(ПроверяемыйСчет) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// В свойстве СоотвИерархияСчетов кэшируются данные об иерархии счетов
	Если НЕ СтруктураПараметров.Свойство("СоотвИерархияСчетов", СоотвИерархияСчетов) Тогда
		СоотвИерархияСчетов = Новый Соответствие;
		СтруктураПараметров.Вставить("СоотвИерархияСчетов", СоотвИерархияСчетов);
	КонецЕсли;
	
	// Иерархия для каждого отдельного счета
	СоотвИерархия = СоотвИерархияСчетов[СчетРодитель];
	
	Если ТипЗнч(СоотвИерархия) <> Тип("Соответствие") Тогда
		СоотвИерархия = Новый Соответствие;
		
		// Определим иерархию счетов
		ИмяПланаСчетов = ПроверяемыйСчет.Метаданные().Имя;
		
		ЗапросСчета = Новый Запрос(
		"ВЫБРАТЬ
		|	ПланСчетовРегистра.Ссылка КАК Ссылка
		|ИЗ
		|	ПланСчетов."+ИмяПланаСчетов+" КАК ПланСчетовРегистра
		|
		|ГДЕ
		|	ПланСчетовРегистра.Ссылка В ИЕРАРХИИ (&Ссылка)
		|");
		
		ЗапросСчета.УстановитьПараметр("Ссылка", СчетРодитель);
		
		ВыборкаСчета = ЗапросСчета.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
		
		Пока ВыборкаСчета.Следующий() Цикл
			СоотвИерархия.Вставить(ВыборкаСчета.Ссылка, ВыборкаСчета.Ссылка);
		КонецЦикла;
		
		СоотвИерархияСчетов.Вставить(СчетРодитель, СоотвИерархия);
	КонецЕсли;
	
	// Собственно проверка
	Возврат НЕ (СоотвИерархия[ПроверяемыйСчет] = Неопределено);
	
КонецФункции // СчетВИерархииЛок()

// Процедура считывает контрагента договора по ссылке без чтения всего объекта
//
Функция ПолучитьКонтрагентаИзДоговораЛок(ДоговорКонтрагента);
	
	Если ТипЗнч(ДоговорКонтрагента) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
		И ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ Владелец КАК Контрагент ИЗ Справочник.ДоговорыКонтрагентов ГДЕ Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", ДоговорКонтрагента);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			Возврат Выборка.Контрагент;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Процедура считывает контрагента из документа по ссылке без чтения всего объекта
//
Функция ПолучитьКонтрагентаИзДокументаОприходованияЛок(ДокументОприходования)
	
	// Получаем контрагента из документа партии
	Если ЗначениеЗаполнено(ДокументОприходования) Тогда
		
		МетаданныеДокумента = Метаданные.НайтиПоТипу(ТипЗнч(ДокументОприходования));
		
		Если МетаданныеДокумента <> Неопределено Тогда
			Если МетаданныеДокумента.Реквизиты.Найти("Контрагент")<>Неопределено Тогда
				
				Запрос = Новый Запрос("Выбрать Контрагент Из Документ."+МетаданныеДокумента.Имя+" ГДЕ Ссылка = &Ссылка");
				Запрос.УстановитьПараметр("Ссылка", ДокументОприходования);
				Выборка = Запрос.Выполнить().Выбрать();
				Если Выборка.Следующий() Тогда
					
					Возврат Выборка.Контрагент;
					
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ЗаполнитьСубконтоПоРеквизитамЛок(ВидСубконто, Субконто, ЗначениеСубконто1, ЗначениеСубконто2=Неопределено, ЗначениеСубконто3=Неопределено, ЗаполнятьТолькоПустые = Ложь)
	
	Если ЗаполнятьТолькоПустые Тогда // в этом режиме заполняются только пустые
		Если ЗначениеЗаполнено(Субконто[ВидСубконто.Видсубконто]) Тогда
			
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначениеСубконто1) И ВидСубконто.ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ЗначениеСубконто1)) Тогда
		
		Субконто.Вставить(ВидСубконто.ВидСубконто, ЗначениеСубконто1);
		
	ИначеЕсли ЗначениеЗаполнено(ЗначениеСубконто2) И ВидСубконто.ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ЗначениеСубконто2)) Тогда
		
		Субконто.Вставить(ВидСубконто.ВидСубконто, ЗначениеСубконто2);
		
	ИначеЕсли ЗначениеЗаполнено(ЗначениеСубконто3) И ВидСубконто.ВидСубконто.ТипЗначения.СодержитТип(ТипЗнч(ЗначениеСубконто3)) Тогда
		
		Субконто.Вставить(ВидСубконто.ВидСубконто, ЗначениеСубконто3);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает субконто на счете. Если такое субконто не счете
// отсутствует, то ничего не делается.
//
// Параметры:
//		Счет - Счет, к которому относится субконто
//      Субконто - вид субконто
//		Номер или имя установливаемого субконто
//      Значение субконто - значение устанавливаемого субконто
//
Процедура ЗаполнитьСубконтоПоСписаниюТоваровЛок(Проводка, СтрокаДокумента, Движение, СтруктураПараметров)
	
	ЗаполнитьСубконтоПоСписаниюТоваровРеглЛок(Проводка, СтрокаДокумента, Движение, СтруктураПараметров);
	ЗаполнитьСубконтоПоСписаниюТоваровМеждЛок(Проводка, СтрокаДокумента, Движение, СтруктураПараметров);
	
КонецПроцедуры // ЗаполнитьСубконтоПоСписаниюТоваров()

Процедура ЗаполнитьСубконтоПоСписаниюТоваровРеглЛок(Проводка, СтрокаДокумента, Движение, СтруктураПараметров)
	
	// По бухгалтерскому учету и налоговому учету - одинаково - используются одни и те же виды субконто
	Если СтрокаДокумента.ОтражатьВБухгалтерскомУчете
		ИЛИ СтрокаДокумента.ОтражатьВНалоговомУчете
		
		Тогда
		
		ВидСубконтоНоменклатура = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура;
		ВидСубконтоНоменклатурныеГруппы = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы;
		ВидСубконтоСклады       = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады;
		ВидСубконтоПодразделения= ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Подразделения;
		ВидСубконтоСтатьиЗатрат = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат;
		ВидСубконтоДоговоры     = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;
		ВидСубконтоКонтрагенты  = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты;
		ВидСубконтоКомиссионеры = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Комиссионеры;
		ВидСубконтоОбъектыСтроительства = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства;
		ВидСубконтоОсновныеСредства = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства;
		
		Если СтрокаДокумента.ОтражатьВБухгалтерскомУчете Тогда
			//СчетТоварыОтгруженные = ПланыСчетов.Хозрасчетный.ТоварыОтгруженные;
			СчетТоварыПринятые    = ПланыСчетов.Хозрасчетный.ТоварыПринятыеНаКомиссию;
		ИначеЕсли СтрокаДокумента.ОтражатьВНалоговомУчете Тогда
			//СчетТоварыОтгруженные = ПланыСчетов.Налоговый.ТоварыОтгруженные;
			СчетТоварыПринятые    = ПланыСчетов.Налоговый.ТоварыПринятыеНаКомиссию;
		КонецЕсли;
		
		// Заполняем дебет:
		Если ЗначениеЗаполнено(Проводка.СчетДт) Тогда
			
			Для каждого ВидСубконто Из Проводка.СчетДт.ВидыСубконто Цикл
				
				Если ВидСубконто.ВидСубконто = ВидСубконтоНоменклатура Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Номенклатура);
					
					Если ЗначениеЗаполнено(СтрокаДокумента.НоменклатураНовая) Тогда
						
						Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.НоменклатураНовая);
						
					КонецЕсли;
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоПодразделения Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ПодразделениеОрганизации);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСклады Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Склад);
					
					Если ЗначениеЗаполнено(СтрокаДокумента.СкладПолучатель) ИЛИ СтрокаДокумента.ИзменитьСклад Тогда
						
						Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.СкладПолучатель);
						
					КонецЕсли;
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСтатьиЗатрат Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.СтатьяЗатрат);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоНоменклатурныеГруппы Тогда
					
					Если ЗначениеЗаполнено(СтрокаДокумента.НоменклатурнаяГруппа) Тогда
						
						Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.НоменклатурнаяГруппа);
						
					КонецЕсли;
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоДоговоры Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ДоговорКонтрагента);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоКонтрагенты Тогда
					
					Контрагент = Неопределено;
					
					// Для товаров принятых субконто Контрагент - это комитент
					Если СчетВИерархииЛок(Проводка.СчетДт, СчетТоварыПринятые, СтруктураПараметров) Тогда
						
						Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
							Если Движение<>Неопределено Тогда
								Контрагент = ПолучитьКонтрагентаИзДокументаОприходованияЛок(Движение.ДокументОприходования);
							КонецЕсли;
						КонецЕсли;
						
					Иначе
						
						Если ЗначениеЗаполнено(СтрокаДокумента.ДоговорКонтрагента) Тогда
							Контрагент = ПолучитьКонтрагентаИзДоговораЛок(СтрокаДокумента.ДоговорКонтрагента);
						КонецЕсли;
						
					КонецЕсли;
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, Контрагент);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоКомиссионеры Тогда
					
					Комиссионер = Неопределено;
					
					Если ЗначениеЗаполнено(СтрокаДокумента.ДоговорКонтрагента) Тогда
						Комиссионер = ПолучитьКонтрагентаИзДоговораЛок(СтрокаДокумента.ДоговорКонтрагента);
					КонецЕсли;
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, Комиссионер);
					
				КонецЕсли;
				
				Если Метаданные.НайтиПоТипу(ТипЗнч(Проводка.СчетДт)) = Метаданные.ПланыСчетов.Хозрасчетный 
					ИЛИ Метаданные.НайтиПоТипу(ТипЗнч(Проводка.СчетДт)) = Метаданные.ПланыСчетов.Налоговый Тогда
					
					ЗаполнитьСубконтоПоРеквизитамЛок(ВидСубконто, Проводка.СубконтоДт, СтрокаДокумента.КорСубконтоБУ1, СтрокаДокумента.КорСубконтоБУ2, СтрокаДокумента.КорСубконтоБУ3);
					
				КонецЕсли;
				
			КонецЦикла; 
			
		КонецЕсли;
		
		// Заполняем кредит
		Если ЗначениеЗаполнено(Проводка.СчетКт) Тогда
			
			Для каждого ВидСубконто Из Проводка.СчетКт.ВидыСубконто Цикл
				
				Если ВидСубконто.ВидСубконто = ВидСубконтоНоменклатура Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Номенклатура);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоПодразделения Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ПодразделениеОрганизации);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСклады Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Склад);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСтатьиЗатрат Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.СтатьяЗатрат);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоДоговоры Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ДоговорКонтрагента);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоКонтрагенты Тогда
					
					Контрагент = Неопределено;
					
					// Для товаров принятых субконто Контрагент - это комитент
					Если СчетВИерархииЛок(Проводка.СчетКт, СчетТоварыПринятые, СтруктураПараметров) Тогда
						
						Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
							Если Движение<>Неопределено Тогда
								Контрагент = ПолучитьКонтрагентаИзДокументаОприходованияЛок(Движение.ДокументОприходования);
							КонецЕсли;
						КонецЕсли;
						
					Иначе
						
						Если ЗначениеЗаполнено(СтрокаДокумента.ДоговорКонтрагента) Тогда
							Контрагент = ПолучитьКонтрагентаИзДоговораЛок(СтрокаДокумента.ДоговорКонтрагента);
						КонецЕсли;
						
					КонецЕсли;
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, Контрагент);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоКомиссионеры Тогда
					
					Комиссионер = Неопределено;
					
					Если ЗначениеЗаполнено(СтрокаДокумента.ДоговорКонтрагента) Тогда
						Комиссионер = ПолучитьКонтрагентаИзДоговораЛок(СтрокаДокумента.ДоговорКонтрагента);
					КонецЕсли;
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, Комиссионер);
					
				КонецЕсли;
				
				Если Метаданные.НайтиПоТипу(ТипЗнч(Проводка.СчетКт)) = Метаданные.ПланыСчетов.Хозрасчетный 
					ИЛИ Метаданные.НайтиПоТипу(ТипЗнч(Проводка.СчетКт)) = Метаданные.ПланыСчетов.Налоговый Тогда
					
					ЗаполнитьСубконтоПоРеквизитамЛок(ВидСубконто, Проводка.СубконтоКт, СтрокаДокумента.КорСубконтоБУ1, СтрокаДокумента.КорСубконтоБУ2, СтрокаДокумента.КорСубконтоБУ3, Истина);
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
		
КонецПроцедуры

Процедура ЗаполнитьСубконтоПоСписаниюТоваровмеждЛок(Проводка, СтрокаДокумента, Движение, СтруктураПараметров)
	
	Если СтрокаДокумента.ОтражатьВМеждународномУчете
		
		Тогда
		
		ВидСубконтоНоменклатура         = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Номенклатура;
		ВидСубконтоНоменклатурныеГруппы = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НоменклатурныеГруппы;
		ВидСубконтоСклады       = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Склады;
		ВидСубконтоПодразделения= ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Подразделения;
		ВидСубконтоСтатьиЗатрат = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.СтатьиЗатрат;
		ВидСубконтоДоговоры     = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Договоры;
		ВидСубконтоКонтрагенты  = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Контрагенты;
		ВидСубконтоОбъектыСтроительства = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОбъектыСтроительства;
		ВидСубконтоОсновныеСредства = ПланыВидовХарактеристик.ВидыСубконтоМеждународные.ОсновныеСредства;
		
		// Заполняем дебет:
		Если ЗначениеЗаполнено(Проводка.СчетДт) Тогда
			
			Для каждого ВидСубконто Из Проводка.СчетДт.ВидыСубконто Цикл
				
				Если ВидСубконто.ВидСубконто = ВидСубконтоНоменклатура Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Номенклатура);
					
					Если ЗначениеЗаполнено(СтрокаДокумента.НоменклатураНовая) Тогда
						
						Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.НоменклатураНовая);
						
					КонецЕсли;
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоПодразделения Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ПодразделениеОрганизации);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСклады Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Склад);
					
					Если ЗначениеЗаполнено(СтрокаДокумента.СкладПолучатель) Тогда
						
						Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.СкладПолучатель);
						
					КонецЕсли;
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСтатьиЗатрат Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.СтатьяЗатрат);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоНоменклатурныеГруппы Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.НоменклатурнаяГруппа);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоДоговоры Тогда
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ДоговорКонтрагента);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоКонтрагенты Тогда
					
					Контрагент = Неопределено;
					
					Если ЗначениеЗаполнено(СтрокаДокумента.ДоговорКонтрагента) Тогда
						Контрагент = ПолучитьКонтрагентаИзДоговораЛок(СтрокаДокумента.ДоговорКонтрагента);
					КонецЕсли;
					
					Проводка.СубконтоДт.Вставить(ВидСубконто.ВидСубконто, Контрагент);
					
				КонецЕсли;
				
				Если Метаданные.НайтиПоТипу(ТипЗнч(Проводка.СчетДт)) = Метаданные.ПланыСчетов.Международный Тогда
					
					ЗаполнитьСубконтоПоРеквизитамЛок(ВидСубконто, Проводка.СубконтоДт, СтрокаДокумента.КорСубконтоМУ1, СтрокаДокумента.КорСубконтоМУ2, СтрокаДокумента.КорСубконтоМУ3);
					
				КонецЕсли;
				
			КонецЦикла; 
			
		КонецЕсли;
		
		// Заполняем кредит
		Если ЗначениеЗаполнено(Проводка.СчетКт) Тогда
			
			Для каждого ВидСубконто Из Проводка.СчетКт.ВидыСубконто Цикл
				
				Если ВидСубконто.ВидСубконто = ВидСубконтоНоменклатура Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Номенклатура);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоПодразделения Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ПодразделениеОрганизации);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСклады Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.Склад);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоСтатьиЗатрат Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.СтатьяЗатрат);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоДоговоры Тогда
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, СтрокаДокумента.ДоговорКонтрагента);
					
				ИначеЕсли ВидСубконто.ВидСубконто = ВидСубконтоКонтрагенты Тогда
					
					Контрагент = Неопределено;
					
					Если ЗначениеЗаполнено(СтрокаДокумента.ДоговорКонтрагента) Тогда
						Контрагент = ПолучитьКонтрагентаИзДоговораЛок(СтрокаДокумента.ДоговорКонтрагента);
					КонецЕсли;
					
					Проводка.СубконтоКт.Вставить(ВидСубконто.ВидСубконто, Контрагент);
					
				КонецЕсли;
				
				Если Метаданные.НайтиПоТипу(ТипЗнч(Проводка.СчетКт)) = Метаданные.ПланыСчетов.Международный Тогда
					
					ЗаполнитьСубконтоПоРеквизитамЛок(ВидСубконто, Проводка.СубконтоКт, СтрокаДокумента.КорСубконтоМУ1, СтрокаДокумента.КорСубконтоМУ2, СтрокаДокумента.КорСубконтоМУ3, Истина);
					
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Запрос = Новый Запрос;
	
	Запрос.Текст ="ВЫБРАТЬ
	              |	СписанныеТовары.Регистратор КАК Регистратор,
	              |	ПартииТоваровНаСкладах.ДокументОприходования КАК ДокументОприходования,
	              |	ПартииТоваровНаСкладах.Номенклатура,
				  |	СписанныеТовары.НоменклатурнаяГруппа,
				  |	СписанныеТовары.ПодразделениеОрганизации,
				  |	СписанныеТовары.КодОперацииПартииТоваров,
	              |	СписанныеТовары.Склад,
				  |	СписанныеТовары.СкладПолучатель,
				  |	СписанныеТовары.ФизЛицо,
				  |	СписанныеТовары.НазначениеИспользования,
	              |	ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры,
	              |	ПартииТоваровНаСкладах.СерияНоменклатуры,
	              |	ПартииТоваровНаСкладах.Качество,
	              |	ПартииТоваровНаСкладах.Заказ,
	              |	ПартииТоваровНаСкладах.Количество,
	              |	ПартииТоваровНаСкладах.СчетУчета КАК СчетУчетаБУ,
	              |	ПартииТоваровНаСкладах.Организация,
	              |	СписанныеТовары.Период КАК Период,
	              |	ПартииТоваровНаСкладах.КорСчет КАК КорСчетБУ,
				  |	СписанныеТовары.СтатьяЗатрат КАК СтатьяЗатрат,
				  |	СписанныеТовары.ОсновноеСредство КАК ОсновноеСредство,
				  |	СписанныеТовары.КорСубконтоБУ1 КАК Субконто1,
				  |	СписанныеТовары.КорСубконтоБУ2 КАК Субконто2,
				  |	СписанныеТовары.КорСубконтоБУ3 КАК Субконто3
	              |ИЗ
	              |	(ВЫБРАТЬ
	              |		СписанныеТовары.Регистратор КАК Регистратор,
	              |		СписанныеТовары.Номенклатура КАК Номенклатура,
				  |		СписанныеТовары.НоменклатурнаяГруппа,
				  |		СписанныеТовары.ПодразделениеОрганизации,
				  |		СписанныеТовары.КодОперацииПартииТоваров,
				  |		СписанныеТовары.Склад,
				  |		СписанныеТовары.СкладПолучатель,
				  |		СписанныеТовары.ФизЛицо,
				  |		СписанныеТовары.НазначениеИспользования,
	              |		СписанныеТовары.СерияНоменклатуры КАК СерияНоменклатуры,
	              |		СписанныеТовары.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	              |		СписанныеТовары.ЗаказПартии КАК ЗаказПартии,
	              |		СписанныеТовары.ЗаказСписания КАК ЗаказСписания,
	              |		СписанныеТовары.Качество КАК Качество,
	              |		СписанныеТовары.КодОперацииПартииТоваров КАК КодОперацииПартииТоваров,
	              |		СписанныеТовары.СписыватьТолькоПоЗаказу КАК СписыватьТолькоПоЗаказу,
				  |		СписанныеТовары.СтатьяЗатрат,
				  |		СписанныеТовары.ОсновноеСредство,
				  |		СписанныеТовары.КорСубконтоБУ1,
				  |		СписанныеТовары.КорСубконтоБУ2,
				  |		СписанныеТовары.КорСубконтоБУ3,
	              |		СписанныеТовары.Период КАК Период
	              |	ИЗ
	              |		РегистрСведений.СписанныеТовары КАК СписанныеТовары
	              |	ГДЕ
	              |		СписанныеТовары.Период МЕЖДУ &ПериодНачало И &ПериодКонец
	              |	
	              |	СГРУППИРОВАТЬ ПО
	              |		СписанныеТовары.Регистратор,
	              |		СписанныеТовары.Номенклатура,
				  |		СписанныеТовары.НоменклатурнаяГруппа,
				  |		СписанныеТовары.ПодразделениеОрганизации,
				  |		СписанныеТовары.КодОперацииПартииТоваров,
	              |		СписанныеТовары.СерияНоменклатуры,
	              |		СписанныеТовары.ХарактеристикаНоменклатуры,
	              |		СписанныеТовары.ЗаказПартии,
	              |		СписанныеТовары.ЗаказСписания,
	              |		СписанныеТовары.Качество,
	              |		СписанныеТовары.КодОперацииПартииТоваров,
				  |		СписанныеТовары.Склад,
				  |		СписанныеТовары.СкладПолучатель,
				  |		СписанныеТовары.ФизЛицо,
				  |		СписанныеТовары.НазначениеИспользования,
	              |		СписанныеТовары.СписыватьТолькоПоЗаказу,
				  |		СписанныеТовары.СтатьяЗатрат,
				  |		СписанныеТовары.ОсновноеСредство,
				  |		СписанныеТовары.КорСубконтоБУ1,
				  |		СписанныеТовары.КорСубконтоБУ2,
				  |		СписанныеТовары.КорСубконтоБУ3,				  
	              |		СписанныеТовары.Период) КАК СписанныеТовары
	              |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Регистратор КАК Регистратор,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Номенклатура КАК Номенклатура,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Склад КАК Склад,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.СерияНоменклатуры КАК СерияНоменклатуры,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.ДокументОприходования КАК ДокументОприходования,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Заказ КАК Заказ,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Качество КАК Качество,
	              |			СУММА(ПартииТоваровНаСкладахБухгалтерскийУчет.Количество) КАК Количество,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.СчетУчета КАК СчетУчета,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Организация КАК Организация,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.КорСчет КАК КорСчет
	              |		ИЗ
	              |			РегистрНакопления.ПартииТоваровНаСкладахБухгалтерскийУчет КАК ПартииТоваровНаСкладахБухгалтерскийУчет
	              |		ГДЕ
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Период МЕЖДУ &ПериодНачало И &ПериодКонец
	              |			И ПартииТоваровНаСкладахБухгалтерскийУчет.СчетУчета.Забалансовый = ЛОЖЬ
	              |			И ПартииТоваровНаСкладахБухгалтерскийУчет.Организация = &Организация
				  |			И ПартииТоваровНаСкладахБухгалтерскийУчет.ВидДвижения = &ВидДвижения
	              |		
	              |		СГРУППИРОВАТЬ ПО
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Регистратор,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Склад,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.СерияНоменклатуры,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Заказ,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Качество,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Номенклатура,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.ХарактеристикаНоменклатуры,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.ДокументОприходования,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.СчетУчета,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.Организация,
	              |			ПартииТоваровНаСкладахБухгалтерскийУчет.КорСчет) КАК ПартииТоваровНаСкладах
	              |		ПО ПартииТоваровНаСкладах.Регистратор = СписанныеТовары.Регистратор
	              |			И ПартииТоваровНаСкладах.Номенклатура = СписанныеТовары.Номенклатура
	              |			И ПартииТоваровНаСкладах.ХарактеристикаНоменклатуры = СписанныеТовары.ХарактеристикаНоменклатуры
	              |			И (ПартииТоваровНаСкладах.Качество = СписанныеТовары.Качество
	              |				ИЛИ СписанныеТовары.Качество = &ПустоеКачество)
	              |			И (ВЫБОР
	              |				КОГДА СписанныеТовары.КодОперацииПартииТоваров <> &РезервированиеПодЗаказ
	              |						И СписанныеТовары.КодОперацииПартииТоваров <> &СнятиеРезерваПодЗаказ
	              |					ТОГДА ПартииТоваровНаСкладах.СерияНоменклатуры = СписанныеТовары.СерияНоменклатуры
	              |							ИЛИ ПартииТоваровНаСкладах.СерияНоменклатуры = &ПустаяСерияНоменклатуры
	              |				ИНАЧЕ ИСТИНА
	              |			КОНЕЦ)
	              |			И (ВЫБОР
	              |				КОГДА СписанныеТовары.СписыватьТолькоПоЗаказу = ИСТИНА
	              |					ТОГДА ВЫБОР
	              |							КОГДА ПартииТоваровНаСкладах.Заказ <> СписанныеТовары.ЗаказПартии
	              |								ТОГДА ВЫБОР
	              |										КОГДА (НЕ СписанныеТовары.ЗаказПартии = НЕОПРЕДЕЛЕНО)
	              |											ТОГДА ЛОЖЬ
	              |										ИНАЧЕ ПартииТоваровНаСкладах.Заказ = &ПустойЗаказ
	              |									КОНЕЦ
	              |							ИНАЧЕ ИСТИНА
	              |						КОНЕЦ
	              |				ИНАЧЕ ВЫБОР
	              |						КОГДА ПартииТоваровНаСкладах.Заказ <> СписанныеТовары.ЗаказПартии
	              |							ТОГДА ПартииТоваровНаСкладах.Заказ = &ПустойЗаказ
	              |						ИНАЧЕ ИСТИНА
	              |					КОНЕЦ
	              |			КОНЕЦ)
	              |			И (СписанныеТовары.СерияНоменклатуры = ПартииТоваровНаСкладах.СерияНоменклатуры
	              |				ИЛИ ПартииТоваровНаСкладах.СерияНоменклатуры = &ПустаяСерияНоменклатуры)
	              |
	              |УПОРЯДОЧИТЬ ПО
	              |	Период";

	Запрос.УстановитьПараметр("ПериодНачало", ПериодНачало);
	Запрос.УстановитьПараметр("ПериодКонец", ПериодКонец);
	Запрос.УстановитьПараметр("ПустаяСерияНоменклатуры", Справочники.СерииНоменклатуры.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустойЗаказ", Документы.ЗаказПокупателя.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустоеКачество", Справочники.Качество.ПустаяСсылка());
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("РезервированиеПодЗаказ", Перечисления.КодыОперацийПартииТоваров.РезервированиеПодЗаказ);
	Запрос.УстановитьПараметр("СнятиеРезерваПодЗаказ", Перечисления.КодыОперацийПартииТоваров.СнятиеРезерваПодЗаказ);
	Запрос.УстановитьПараметр("ВидДвижения", ВидДвиженияНакопления.Расход);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();

	Ном = 0;
	
	ОперацияХоз = РегистрыБухгалтерии.Хозрасчетный.СоздатьНаборЗаписей();
	Проводка = ОперацияХоз.Добавить();
	
	ТаблицаСчетовМСФО = Новый ТаблицаЗначений;
	ТаблицаСчетовМСФО.Колонки.Добавить("Период");
	ТаблицаСчетовМСФО.Колонки.Добавить("СчетБУ");	
	ТаблицаСчетовМСФО.Колонки.Добавить("Субконто1");
	ТаблицаСчетовМСФО.Колонки.Добавить("Субконто2");
	ТаблицаСчетовМСФО.Колонки.Добавить("Субконто3");	
	ТаблицаСчетовМСФО.Колонки.Добавить("СчетМСФО");
	
	СписанныеТовары = Движения.СписанныеТовары;
	
	Пока Выборка.Следующий() Цикл
		
		Ном = Ном + 1;
		Движение = СписанныеТовары.Добавить();
		
		ЗаполнитьЗначенияСвойств(Движение,Выборка);
		
		Движение.НомерСтрокиДокумента = Ном;
		
		Движение.ОтражатьВМеждународномУчете = Истина;
	    Движение.ОтражатьВБухгалтерскомУчете = Ложь;
	    Движение.ОтражатьВНалоговомУчете = Ложь;
	    Движение.ОтражатьВУправленческомУчете = Ложь;
		
		// Повтор процедуры формирования проводок в бух.учете
		Проводка.СчетКт        = Движение.СчетУчетаБУ;
		
		// Не заполняем счет кредита, если дебет и кредит балансовый и забалансовый
		Если ЗначениеЗаполнено(Движение.КорСчетБУ)
			И Проводка.СчетКт.Забалансовый = Движение.КорСчетБУ.Забалансовый Тогда
			
			Проводка.СчетДт    = Движение.КорСчетБУ;
			
			// Для перемещения счет кредита не задается
		ИначеЕсли НЕ ЗначениеЗаполнено(Движение.КорСчетБУ)
			И УправлениеЗапасамиПартионныйУчет.ПолучитьНаправлениеСписанияПоКодуОперации(Движение.КодОперацииПартииТоваров) = "НаСкладах" Тогда
			
			Проводка.СчетДт    = Проводка.СчетКт;
			
		КонецЕсли;
		
		// Перемещение комиссионных товаров
		Если Проводка.СчетКт.Забалансовый
			И (ЗначениеЗаполнено(Движение.ПринятыеКорСчетБУ)) Тогда
			
			Проводка.СчетДт    = Движение.ПринятыеКорСчетБУ;
			
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура;
		
		ЗаполнитьСубконтоПоСписаниюТоваровЛок(Проводка, Движение, Неопределено, СтруктураПараметров);
		
		// Повтор процедуры формирования проводок в бух.учете
		
		ВидыСубконтоКт = Проводка.СчетКт.ВидыСубконто;
		
		СубконтоКт1 = ?(ВидыСубконтоКт.Количество()>0, ВидыСубконтоКт[0].ВидСубконто, Неопределено);
		СубконтоКт2 = ?(ВидыСубконтоКт.Количество()>1, ВидыСубконтоКт[1].ВидСубконто, Неопределено);
		СубконтоКт3 = ?(ВидыСубконтоКт.Количество()>2, ВидыСубконтоКт[2].ВидСубконто, Неопределено);
		
		СтруктураПоискаМСФО = Новый Структура("Период, СчетБУ, Субконто1, Субконто2, Субконто3", Выборка.Период, Проводка.СчетКт, СубконтоКт1, СубконтоКт2, СубконтоКт3);
		РезультатПоиска = ТаблицаСчетовМСФО.НайтиСтроки(СтруктураПоискаМСФО);
		ЕСли РезультатПоиска.Количество() = 0 Тогда
			Структура = МеждународныйУчет.ПреобразоватьСчетаБУвСчетМСФО(Проводка.СчетКт, Выборка.Субконто1, Выборка.Субконто2, Выборка.Субконто3, Выборка.Период);
			СтрокаСчетаМСФО = ТаблицаСчетовМСФО.Добавить();
			СтрокаСчетаМСФО.Период = Выборка.Период;
			СтрокаСчетаМСФО.СчетБУ = Проводка.СчетКт;
			СтрокаСчетаМСФО.Субконто1 = Структура.Субконто1;
			СтрокаСчетаМСФО.Субконто2 = Структура.Субконто2;
			СтрокаСчетаМСФО.Субконто3 = Структура.Субконто3;
			СтрокаСчетаМСФО.СчетМСФО = Структура.Счет;
			
			Движение.СчетУчетаМУ = Структура.Счет;
			Движение.КорСубконтоМУ1 = Структура.Субконто1;
			Движение.КорСубконтоМУ2 = Структура.Субконто2;
			Движение.КорСубконтоМУ3 = Структура.Субконто3;
			
			Если Структура.Счет = Неопределено Тогда
				Сообщить("Не найден счет МСФО, соответствующй счету " + Проводка.СчетКт);
				СписанныеТовары.Удалить(Движение);
				Продолжить;
			КонецЕсли;
			
		Иначе
			Движение.СчетУчетаМУ = РезультатПоиска[0].СчетМСФО;
			Движение.КорСубконтоМУ1 = РезультатПоиска[0].Субконто1;
			Движение.КорСубконтоМУ2 = РезультатПоиска[0].Субконто2;
			Движение.КорСубконтоМУ3 = РезультатПоиска[0].Субконто3;
		КонецЕсли;
		
		ВидыСубконтоДт = Проводка.СчетДт.ВидыСубконто;
		
		СубконтоДт1 = ?(ВидыСубконтоДт.Количество()>0, ВидыСубконтоДт[0].ВидСубконто, Неопределено);
		СубконтоДт2 = ?(ВидыСубконтоДт.Количество()>1, ВидыСубконтоДт[1].ВидСубконто, Неопределено);
		СубконтоДт3 = ?(ВидыСубконтоДт.Количество()>2, ВидыСубконтоДт[2].ВидСубконто, Неопределено);
		
		СтруктураПоискаМСФО = Новый Структура("Период, СчетБУ, Субконто1, Субконто2, Субконто3", Выборка.Период, Проводка.СчетДт, СубконтоДт1, СубконтоДт2, СубконтоДт3);
		РезультатПоиска = ТаблицаСчетовМСФО.НайтиСтроки(СтруктураПоискаМСФО);
		Если РезультатПоиска.Количество() = 0 Тогда
			Структура = МеждународныйУчет.ПреобразоватьСчетаБУвСчетМСФО(Проводка.СчетДт, Выборка.Субконто1, Выборка.Субконто2, Выборка.Субконто3, Выборка.Период);
			СтрокаСчетаМСФО = ТаблицаСчетовМСФО.Добавить();
			СтрокаСчетаМСФО.Период = Выборка.Период;
			СтрокаСчетаМСФО.СчетБУ = Проводка.СчетДт;
			СтрокаСчетаМСФО.Субконто1 = Структура.Субконто1;
			СтрокаСчетаМСФО.Субконто2 = Структура.Субконто2;
			СтрокаСчетаМСФО.Субконто3 = Структура.Субконто3;
			СтрокаСчетаМСФО.СчетМСФО = Структура.Счет;
			
			Движение.КорСчетМУ = Структура.Счет;
			Движение.КорСубконтоМУ1 = Структура.Субконто1;
			Движение.КорСубконтоМУ2 = Структура.Субконто2;
			Движение.КорСубконтоМУ3 = Структура.Субконто3;
			
			Если Структура.Счет = Неопределено Тогда
				Сообщить("Не найден счет МСФО, соответствующй счету " + Проводка.СчетДт);
				СписанныеТовары.Удалить(Движение);
				Продолжить;
			КонецЕсли;
			
		Иначе
			Движение.КорСчетМУ = РезультатПоиска[0].СчетМСФО;
			Движение.КорСубконтоМУ1 = РезультатПоиска[0].Субконто1;
			Движение.КорСубконтоМУ2 = РезультатПоиска[0].Субконто2;
			Движение.КорСубконтоМУ3 = РезультатПоиска[0].Субконто3;
		КонецЕсли;
			
		
	КонецЦикла;
	
	ОперацияХоз.Очистить();
	
	// записываем движения регистров
	Движения.СписанныеТовары.Записать();
	
	ТаблицаСписания = Движения.СписанныеТовары.Выгрузить();
	
	УправлениеЗапасамиПартионныйУчет.ДвижениеПартийТоваров(Ссылка, ТаблицаСписания,, Ложь, Ложь, Ложь, Ложь, Ложь,ПериодКонец);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью



