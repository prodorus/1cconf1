
// Функция возвращает счет прочих расходов из плана счетов Хозрасчетный
//
// Параметры
//  ОтражениеНаСчетеЕНВД  - Булево. Параметр, уточняющий, какой счет возвращать
//
Функция ПолучитьСчетПрочихРасходов(ОтражениеНаСчетеЕНВД) Экспорт
	
	Если ОтражениеНаСчетеЕНВД Тогда
	
		Возврат ПланыСчетов.Хозрасчетный.ПрочиеРасходыОблагаемыеЕНВД
	
	Иначе
	
		Возврат ПланыСчетов.Хозрасчетный.ПрочиеРасходыНеОблагаемыеЕНВД
	
	КонецЕсли;
	
КонецФункции // ПолучитьСчетПрочихРасходов()


// Функция проверяет программу бухучета и налоговый режим, для проверки и 
// заполнения строк отражения в учете
Функция ПолучитьСтруктураПараметровПеременныхВеденияУчета(Организация, ПериодРегистрации) Экспорт

	СтруктураЗначенияПеременных = Новый Структура;
	
	// определим налоговый режим
	НалоговыйУчет.ОбновитьДанныеУчетнойПолитикиПоНалоговомуУчету(глЗначениеПеременной("УчетнаяПолитикаОтраженияЗарплатыВУчете"), КонецМесяца(ПериодРегистрации), Организация);
	УчетнаяПолитика = глЗначениеПеременной("УчетнаяПолитикаОтраженияЗарплатыВУчете")[КонецМесяца(ПериодРегистрации)][Организация];
	УСН = УчетнаяПолитика.УСН;
	СтруктураЗначенияПеременных.Вставить("УСН", УСН);
	СтруктураЗначенияПеременных.Вставить("ОбъектНалогообложенияУСН", УчетнаяПолитика.ОбъектНалогообложенияУСН);
	СтруктураЗначенияПеременных.Вставить("ОрганизацияЯвляетсяПлательщикомЕНВД", УчетнаяПолитика.ОрганизацияЯвляетсяПлательщикомЕНВД);
	СтруктураЗначенияПеременных.Вставить("УплачиватьДобровольныеВзносыВФСС", УчетнаяПолитика.УплачиватьДобровольныеВзносыВФСС);
	
	ПредпринимательНаОСН = Не УСН и ОбщегоНазначенияЗК.ПолучитьЗначениеРеквизита(Организация, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ФизЛицо;
	СтруктураЗначенияПеременных.Вставить("ПредпринимательНаОСН", ПредпринимательНаОСН);
	СтруктураЗначенияПеременных.Вставить("ВариантУчетаРасходовПоНалогамСФОТВНалоговомУчете", УчетнаяПолитика.ВариантУчетаРасходовПоНалогамСФОТВНалоговомУчете);
	
	ЗаполнятьДанныеНУ = Не (УСН или ПредпринимательНаОСН); 
	СтруктураЗначенияПеременных.Вставить("ЗаполнятьДанныеНУ", ЗаполнятьДанныеНУ);
	
	ЗаполнятьСчетаНУ  = Истина;
	СтруктураЗначенияПеременных.Вставить("ЗаполнятьСчетаНУ", ЗаполнятьСчетаНУ);
	
	ЗаполнятьОКАТОКПП  = Ложь;
	СтруктураЗначенияПеременных.Вставить("ЗаполнятьОКАТОКПП", ЗаполнятьОКАТОКПП);
	
	УчетПоПодразделениямНаСчетах = Ложь;
	СтруктураЗначенияПеременных.Вставить("УчетПоПодразделениямНаСчетах", УчетПоПодразделениямНаСчетах);
	
	СтруктураЗначенияПеременных.Вставить("ПорядокПризнанияРасходовПоОтпускам", ПолучитьПорядокПризнанияРасходовПоОтпускам(Организация, ПериодРегистрации));
	
	УчетнаяПолитикаПоОценочнымОбязательствам = ПолучитьУчетнуюПолитикуПоОценочнымОбязательствам(Организация, ПериодРегистрации);
	
	СтруктураЗначенияПеременных.Вставить("ОценочныеОбязательстваФормироватьБУ", УчетнаяПолитикаПоОценочнымОбязательствам.ФормироватьБУ);
	СтруктураЗначенияПеременных.Вставить("ОценочныеОбязательстваФормироватьНУ", УчетнаяПолитикаПоОценочнымОбязательствам.ФормироватьНУ);
	СтруктураЗначенияПеременных.Вставить("ОценочныеОбязательстваПорядокРасчета", УчетнаяПолитикаПоОценочнымОбязательствам.ПорядокРасчета);
	СтруктураЗначенияПеременных.Вставить("ОценочноеОбязательствоДляОтпуска", УчетнаяПолитикаПоОценочнымОбязательствам.ОценочноеОбязательствоДляОтпуска);
	
	Возврат СтруктураЗначенияПеременных;
	
КонецФункции

Функция ПолучитьУчетнуюПолитикуПоОценочнымОбязательствам(Организация, Период)
	
	УчетнаяПолитикаПоОценочнымОбязательствам = Новый Структура;
	
	Если НЕ ЗначениеЗаполнено(Период) или Период < ДатаДействияПриказа186Н() или Не ЗначениеЗаполнено(Организация) Тогда
		
		//если не заполнены параметры или до 2011 года, учетная политика не применялась
		
		УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ФормироватьБУ", Ложь);
		УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ФормироватьНУ", Ложь);
		УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ПорядокРасчета", Перечисления.ПорядокРасчетаОценочныхОбязательств.ПустаяСсылка());
		УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ОценочноеОбязательствоДляОтпуска", Справочники.Резервы.ПустаяСсылка());
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаСреза", КонецГода(Период));
		Запрос.УстановитьПараметр("Организация", ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетнаяПолитикаПоРБП.ФормироватьБУ,
		|	УчетнаяПолитикаПоРБП.ФормироватьНУ,
		|	УчетнаяПолитикаПоРБП.ПорядокРасчета,
		|	УчетнаяПолитикаПоРБП.ОценочноеОбязательствоДляОтпуска
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаПоОценочнымОбязательствам.СрезПоследних(&ДатаСреза, Организация = &Организация) КАК УчетнаяПолитикаПоРБП";
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			//значение по умолчанию
			
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ФормироватьБУ", Ложь);
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ФормироватьНУ", Ложь);
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ПорядокРасчета", Перечисления.ПорядокРасчетаОценочныхОбязательств.НачисленияИВзносы);
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ОценочноеОбязательствоДляОтпуска", Справочники.Резервы.ПустаяСсылка());
			
		Иначе
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ФормироватьБУ", Выборка.ФормироватьБУ);
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ФормироватьНУ", Выборка.ФормироватьНУ);
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ПорядокРасчета", Выборка.ПорядокРасчета);
			УчетнаяПолитикаПоОценочнымОбязательствам.Вставить("ОценочноеОбязательствоДляОтпуска", Выборка.ОценочноеОбязательствоДляОтпуска);
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат УчетнаяПолитикаПоОценочнымОбязательствам;

КонецФункции // УчетнаяПолитикаПоОценочнымОбязательствам()

Функция ПолучитьПорядокПризнанияРасходовПоОтпускам(Организация, Период)

	Если НЕ ЗначениеЗаполнено(Период) или Период < ДатаДействияПриказа186Н() или Не ЗначениеЗаполнено(Организация) Тогда
		
		Возврат Перечисления.ПорядокПризнанияРасходовПоОтпускам.ВМесяцеНачисления; //значение по умолчанию
		
	Иначе
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДатаСреза", КонецГода(Период));
		Запрос.УстановитьПараметр("Организация", ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчетнаяПолитикаПоРБП.РасходыПоОтпускам
		|ИЗ
		|	РегистрСведений.УчетнаяПолитикаПоРБП.СрезПоследних(&ДатаСреза, Организация = &Организация) КАК УчетнаяПолитикаПоРБП";
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			Возврат Перечисления.ПорядокПризнанияРасходовПоОтпускам.ВМесяцеНачисления; //значение по умолчанию
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.РасходыПоОтпускам;
		КонецЕсли;	
		
	КонецЕсли;

КонецФункции // ПолучитьПорядокПризнанияРасходовПоОтпускам()    

Функция ДатаДействияПриказа186Н() Экспорт

	Возврат Дата('20110101');

КонецФункции // ДатаДействияПриказа186Н()

////////////////////////////////////////////////

// Функция формирует текст запроса для получения временной таблицы - списка начислений, которые входят в базу оценочного обязательства (резерва),
// и размеры ОО в разрезе видов расчета
// Источник данных - регистры БУОсновныеНачисления и БУДополнительныеНачисления
//
// Параметры
//  ОценочныеОбязательстваПорядокРасчета - ПеречислениеСсылка.ПорядокРасчетаОценочныхОбязательств
//
// Возвращаемое значение:
//   Текст запроса
//
Функция ПолучитьТекстЗапросаРасчетОценочныхОбязательств(ОценочныеОбязательстваПорядокРасчета) Экспорт

	// параметры запроса
	// ЕстьЕНВД - булево, наличие ЕНВД в периоде регистрации
	// Организация - Организация
	// ПоВсемРезервам - булево, признак формирования запроса без отбора по конкртетному резерву
	// Резерв - СправочникСсылка.Резервы
	// парамПериодРегистрации - период регистрации
	
	// создается таблица ВТСписокНачислений
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Организации.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Организации.Ссылка
	|		ИНАЧЕ Организации.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация
	|ПОМЕСТИТЬ ВТГоловнаяОрганизация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БУНачисления.Резерв КАК Резерв,
	|	БУНачисления.ВидРасчета КАК ВидРасчета,
	|	БУНачисления.СчетДт КАК СчетДт,
	|	БУНачисления.СубконтоДт1 КАК СубконтоДт1,
	|	БУНачисления.СубконтоДт2 КАК СубконтоДт2,
	|	БУНачисления.СубконтоДт3 КАК СубконтоДт3,
	|	БУНачисления.СчетДтНУ,
	|	БУНачисления.СубконтоДтНУ1,
	|	БУНачисления.СубконтоДтНУ2,
	|	БУНачисления.СубконтоДтНУ3,
	|	БУНачисления.ПодразделениеДт КАК ПодразделениеДт,
	|	БУНачисления.ПодразделениеКт,
	|	БУНачисления.ФизЛицо КАК ФизЛицо,
	|	ВЫБОР
	|		КОГДА НЕ &ЕстьЕНВД
	|			ТОГДА ЛОЖЬ
	|		КОГДА СчетаУчетаПоДеятельностиЕНВД.Счет ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ОблагаетсяЕНВД,
	|	СУММА(БУНачисления.Результат) КАК Результат,
	|	БУНачисления.ПроцентОтчислений
	|ПОМЕСТИТЬ ВТСписокНачислений
	|ИЗ
	|	(ВЫБРАТЬ
	|		БУНачисления.СчетДт КАК СчетДт,
	|		БУНачисления.СубконтоДт1 КАК СубконтоДт1,
	|		БУНачисления.СубконтоДт2 КАК СубконтоДт2,
	|		БУНачисления.СубконтоДт3 КАК СубконтоДт3,
	|		БУНачисления.СчетДтНУ КАК СчетДтНУ,
	|		БУНачисления.СубконтоДтНУ1 КАК СубконтоДтНУ1,
	|		БУНачисления.СубконтоДтНУ2 КАК СубконтоДтНУ2,
	|		БУНачисления.СубконтоДтНУ3 КАК СубконтоДтНУ3,
	|		БУНачисления.Результат КАК Результат,
	|		РазмерыОтчисленийВРезервы.Резерв КАК Резерв,
	|		РазмерыОтчисленийВРезервы.Размер КАК ПроцентОтчислений,
	|		БУНачисления.ПодразделениеДт КАК ПодразделениеДт,
	|		БУНачисления.ПодразделениеКт КАК ПодразделениеКт,
	|		БУНачисления.ВидРасчета КАК ВидРасчета,
	|		БУНачисления.ФизЛицо КАК ФизЛицо
	|	ИЗ
	|		РегистрРасчета.БУОсновныеНачисления КАК БУНачисления
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмерыОтчисленийВРезервы.СрезПоследних(
	|					&парамПериодРегистрации,
	|					Организация В
	|							(ВЫБРАТЬ
	|								ВТГоловнаяОрганизация.ГоловнаяОрганизация
	|							ИЗ
	|								ВТГоловнаяОрганизация)
	|						И (&ПоВсемРезервам
	|							ИЛИ Резерв = &Резерв)) КАК РазмерыОтчисленийВРезервы
	|			ПО (РазмерыОтчисленийВРезервы.Размер > 0)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Резервы.БазовыеВидыРасчета КАК БазовыеВидыРасчета
	|			ПО (РазмерыОтчисленийВРезервы.Резерв = БазовыеВидыРасчета.Ссылка)
	|				И ((ВЫРАЗИТЬ(БазовыеВидыРасчета.ВидРасчета КАК ПланВидовРасчета.ОсновныеНачисленияОрганизаций)) = БУНачисления.ВидРасчета)
	|	ГДЕ
	|		БУНачисления.ПериодРегистрации = &парамПериодРегистрации
	|		И БУНачисления.ОбособленноеПодразделение = &Организация
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		БУНачисления.СчетДт,
	|		БУНачисления.СубконтоДт1,
	|		БУНачисления.СубконтоДт2,
	|		БУНачисления.СубконтоДт3,
	|		БУНачисления.СчетДтНУ,
	|		БУНачисления.СубконтоДтНУ1,
	|		БУНачисления.СубконтоДтНУ2,
	|		БУНачисления.СубконтоДтНУ3,
	|		БУНачисления.Результат,
	|		РазмерыОтчисленийВРезервы.Резерв,
	|		РазмерыОтчисленийВРезервы.Размер,
	|		БУНачисления.ПодразделениеДт,
	|		БУНачисления.ПодразделениеКт,
	|		БУНачисления.ВидРасчета,
	|		БУНачисления.ФизЛицо
	|	ИЗ
	|		РегистрРасчета.БУДополнительныеНачисления КАК БУНачисления
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РазмерыОтчисленийВРезервы.СрезПоследних(
	|					&парамПериодРегистрации,
	|					Организация В
	|							(ВЫБРАТЬ
	|								ВТГоловнаяОрганизация.ГоловнаяОрганизация
	|							ИЗ
	|								ВТГоловнаяОрганизация)
	|						И (&ПоВсемРезервам
	|							ИЛИ Резерв = &Резерв)) КАК РазмерыОтчисленийВРезервы
	|			ПО (РазмерыОтчисленийВРезервы.Размер > 0)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Резервы.БазовыеВидыРасчета КАК БазовыеВидыРасчета
	|			ПО (РазмерыОтчисленийВРезервы.Резерв = БазовыеВидыРасчета.Ссылка)
	|				И ((ВЫРАЗИТЬ(БазовыеВидыРасчета.ВидРасчета КАК ПланВидовРасчета.ДополнительныеНачисленияОрганизаций)) = БУНачисления.ВидРасчета)
	|	ГДЕ
	|		НАЧАЛОПЕРИОДА(БУНачисления.ПериодРегистрации, МЕСЯЦ) = &парамПериодРегистрации
	|		И БУНачисления.ОбособленноеПодразделение = &Организация) КАК БУНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СчетаУчетаПоДеятельностиЕНВД КАК СчетаУчетаПоДеятельностиЕНВД
	|		ПО БУНачисления.СчетДт = СчетаУчетаПоДеятельностиЕНВД.Счет
	|
	|СГРУППИРОВАТЬ ПО
	|	БУНачисления.ВидРасчета,
	|	БУНачисления.Резерв,
	|	БУНачисления.ФизЛицо,
	|	БУНачисления.СубконтоДтНУ3,
	|	БУНачисления.ПодразделениеКт,
	|	БУНачисления.ПодразделениеДт,
	|	БУНачисления.СубконтоДтНУ1,
	|	БУНачисления.СубконтоДтНУ2,
	|	БУНачисления.СчетДтНУ,
	|	БУНачисления.СубконтоДт3,
	|	БУНачисления.СчетДт,
	|	БУНачисления.СубконтоДт2,
	|	БУНачисления.СубконтоДт1,
	|	БУНачисления.ПроцентОтчислений,
	|	ВЫБОР
	|		КОГДА НЕ &ЕстьЕНВД
	|			ТОГДА ЛОЖЬ
	|		КОГДА СчетаУчетаПоДеятельностиЕНВД.Счет ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо,
	|	ВидРасчета";
	
	Если ОценочныеОбязательстваПорядокРасчета = Перечисления.ПорядокРасчетаОценочныхОбязательств.Начисления Тогда
		
		ТекстЗапроса = ТекстЗапроса + ";"+
		"ВЫБРАТЬ
		|	РезервыПоВидамРасчета.Резерв,
		|	РезервыПоВидамРасчета.ВидРасчета,
		|	ВЫРАЗИТЬ(РезервыПоВидамРасчета.Результат * РезервыПоВидамРасчета.ПроцентОтчислений / 100 КАК ЧИСЛО(15, 2)) КАК РазмерОтчислений,
		|	0 КАК РазмерОтчисленийВзносы,
		|	0 КАК РазмерОтчисленийФССНесчастныеСлучаи,
		|	РезервыПоВидамРасчета.Результат,
		|	0 КАК РезультатВзносы,
		|	0 КАК РезультатВзносыФССНесчастныеСлучаи,
		|	РезервыПоВидамРасчета.ПроцентОтчислений,
		|	ВЫРАЗИТЬ(РезервыПоВидамРасчета.Результат * РезервыПоВидамРасчета.ПроцентОтчислений / 100 КАК ЧИСЛО(15, 2)) КАК ВсегоОтчислений
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВТСписокНачислений.Резерв КАК Резерв,
		|		ВТСписокНачислений.ВидРасчета КАК ВидРасчета,
		|		СУММА(ВТСписокНачислений.Результат) КАК Результат,
		|		ВТСписокНачислений.ПроцентОтчислений КАК ПроцентОтчислений
		|	ИЗ
		|		ВТСписокНачислений КАК ВТСписокНачислений
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ВТСписокНачислений.Резерв,
		|		ВТСписокНачислений.ВидРасчета,
		|		ВТСписокНачислений.ПроцентОтчислений) КАК РезервыПоВидамРасчета";
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + ";"+
		"ВЫБРАТЬ
		|	СписокНачислений.Резерв,
		|	СписокНачислений.ВидРасчета КАК ВидРасчета,
		|	СписокНачислений.ФизЛицо КАК ФизЛицо,
		|	СписокНачислений.ОблагаетсяЕНВД,
		|	СУММА(СписокНачислений.Результат) КАК Результат
		|ПОМЕСТИТЬ ВТБУДоходыСвод
		|ИЗ
		|	ВТСписокНачислений КАК СписокНачислений
		|
		|СГРУППИРОВАТЬ ПО
		|	СписокНачислений.ВидРасчета,
		|	СписокНачислений.ФизЛицо,
		|	СписокНачислений.ОблагаетсяЕНВД,
		|	СписокНачислений.Резерв
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо,
		|	ВидРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписокНачислений.ФизЛицо КАК ФизЛицо,
		|	СписокНачислений.Резерв,
		|	СписокНачислений.ВидРасчета КАК ВидРасчета,
		|	СУММА(СписокНачислений.Результат) КАК Результат
		|ПОМЕСТИТЬ ВТБУДоходыСводПоВР
		|ИЗ
		|	ВТСписокНачислений КАК СписокНачислений
		|
		|СГРУППИРОВАТЬ ПО
		|	СписокНачислений.ФизЛицо,
		|	СписокНачислений.ВидРасчета,
		|	СписокНачислений.Резерв
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо,
		|	ВидРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТСписокНачислений.ФизЛицо КАК ФизЛицо
		|ПОМЕСТИТЬ ВТСписокФизлиц
		|ИЗ
		|	ВТСписокНачислений КАК ВТСписокНачислений
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтраховыеВзносыИсчисленные.ФизЛицо КАК ФизЛицо,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРСтраховая) КАК ПФРСтраховая,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРСтраховаяЕНВД) КАК ПФРСтраховаяЕНВД,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРПоСуммарномуТарифу + СтраховыеВзносыИсчисленные.ПФРДоПредельнойВеличины + СтраховыеВзносыИсчисленные.ПФРСПревышения) КАК ПФРПоСуммарномуТарифу,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРПоСуммарномуТарифуЕНВД + СтраховыеВзносыИсчисленные.ПФРДоПредельнойВеличиныЕНВД + СтраховыеВзносыИсчисленные.ПФРСПревышенияЕНВД) КАК ПФРПоСуммарномуТарифуЕНВД,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРНакопительная) КАК ПФРНакопительная,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРНакопительнаяЕНВД) КАК ПФРНакопительнаяЕНВД,
		|	СУММА(СтраховыеВзносыИсчисленные.ФСС) КАК ФСС,
		|	СУММА(СтраховыеВзносыИсчисленные.ФССЕНВД) КАК ФССЕНВД,
		|	СУММА(СтраховыеВзносыИсчисленные.ФФОМС) КАК ФФОМС,
		|	СУММА(СтраховыеВзносыИсчисленные.ФФОМСЕНВД) КАК ФФОМСЕНВД,
		|	СУММА(СтраховыеВзносыИсчисленные.ТФОМС) КАК ТФОМС,
		|	СУММА(СтраховыеВзносыИсчисленные.ТФОМСЕНВД) КАК ТФОМСЕНВД,
		|	СУММА(СтраховыеВзносыИсчисленные.ФССНесчастныеСлучаи) КАК ФССНесчастныеСлучаи,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРПоДополнительномуТарифу) КАК ПФРПоДополнительномуТарифу,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРНаДоплатуКПенсииШахтерам) КАК ПФРНаДоплатуКПенсииШахтерам,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботах) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3,
		|	СУММА(СтраховыеВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4
		|ПОМЕСТИТЬ ВТВзносыИсчисленные
		|ИЗ
		|	РегистрНакопления.СтраховыеВзносыИсчисленные КАК СтраховыеВзносыИсчисленные
		|ГДЕ
		|	СтраховыеВзносыИсчисленные.ОбособленноеПодразделение = &Организация
		|	И НАЧАЛОПЕРИОДА(СтраховыеВзносыИсчисленные.Период, МЕСЯЦ) = &парамПериодРегистрации
		|	И СтраховыеВзносыИсчисленные.ФизЛицо В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВТСписокФизлиц.ФизЛицо
		|			ИЗ
		|				ВТСписокФизлиц)
		|
		|СГРУППИРОВАТЬ ПО
		|	СтраховыеВзносыИсчисленные.ФизЛицо
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СтраховыеВзносыСведенияОДоходах.ФизЛицо КАК ФизЛицо,
		|	СтраховыеВзносыСведенияОДоходах.ВидРасчета,
		|	СУММА(СтраховыеВзносыСведенияОДоходах.Результат - СтраховыеВзносыСведенияОДоходах.Скидка) КАК Результат,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуФОМС КАК ВходитВБазуФОМС,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуФСС КАК ВходитВБазуФСС,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуПФР КАК ВходитВБазуПФР,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяПоДополнительномуТарифу КАК ОблагаетсяПоДополнительномуТарифу,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам КАК ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяЕНВД,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией КАК ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	СтраховыеВзносыСведенияОДоходах.КлассУсловийТруда,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуФСС_НС КАК ВходитВБазуФСС_НС
		|ПОМЕСТИТЬ ВТВзносыДоходыПоВР
		|ИЗ
		|	РегистрНакопления.СтраховыеВзносыСведенияОДоходах КАК СтраховыеВзносыСведенияОДоходах
		|ГДЕ
		|	СтраховыеВзносыСведенияОДоходах.ОбособленноеПодразделение = &Организация
		|	И НАЧАЛОПЕРИОДА(СтраховыеВзносыСведенияОДоходах.Период, МЕСЯЦ) = &парамПериодРегистрации
		|	И СтраховыеВзносыСведенияОДоходах.ФизЛицо В
		|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|				ВТСписокФизлиц.ФизЛицо
		|			ИЗ
		|				ВТСписокФизлиц)
		|	И СтраховыеВзносыСведенияОДоходах.Результат - СтраховыеВзносыСведенияОДоходах.Скидка <> 0
		|
		|СГРУППИРОВАТЬ ПО
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяПоДополнительномуТарифу,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуФОМС,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуФСС,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуПФР,
		|	СтраховыеВзносыСведенияОДоходах.ФизЛицо,
		|	СтраховыеВзносыСведенияОДоходах.ВидРасчета,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяЕНВД,
		|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	СтраховыеВзносыСведенияОДоходах.КлассУсловийТруда,
		|	СтраховыеВзносыСведенияОДоходах.ВидДохода.ВходитВБазуФСС_НС
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТВзносыДоходыПоВР.ФизЛицо,
		|	СУММА(ВТВзносыДоходыПоВР.Результат) КАК Результат,
		|	ВТВзносыДоходыПоВР.ОблагаетсяЕНВД,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаПФР,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ВходитВБазуФОМС
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаФОМС,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ВходитВБазуФСС
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаФСС,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ВходитВБазуФСС_НС
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаФСС_НС,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ОблагаетсяПоДополнительномуТарифу
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаДопТариф,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией = ЗНАЧЕНИЕ(Перечисление.ВидыРаботСДосрочнойПенсией.ПодземныеИВредныеРаботы)
		|					И ВТВзносыДоходыПоВР.КлассУсловийТруда В (ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный1), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный2), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный3), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный4), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Опасный))
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаДопТарифПодземныеИВредныеРаботы,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией = ЗНАЧЕНИЕ(Перечисление.ВидыРаботСДосрочнойПенсией.ТяжелыеИПрочиеРаботы)
		|					И ВТВзносыДоходыПоВР.КлассУсловийТруда В (ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.ПустаяСсылка), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный1), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный2), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный3), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Вредный4), ЗНАЧЕНИЕ(Перечисление.КлассыУсловийТрудаПоРезультатамСпециальнойОценки.Опасный))
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаДопТарифТяжелыеИПрочиеРаботы,
		|	СУММА(ВЫБОР
		|			КОГДА ВТВзносыДоходыПоВР.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам
		|				ТОГДА ВТВзносыДоходыПоВР.Результат
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК БазаШахтеры
		|ПОМЕСТИТЬ ВТВзносыДоходыСвод
		|ИЗ
		|	ВТВзносыДоходыПоВР КАК ВТВзносыДоходыПоВР
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТВзносыДоходыПоВР.ФизЛицо,
		|	ВТВзносыДоходыПоВР.ОблагаетсяЕНВД
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТСписокНачислений.Резерв,
		|	ВТСписокНачислений.ВидРасчета,
		|	ВТСписокНачислений.СчетДт,
		|	ВТСписокНачислений.СубконтоДт1,
		|	ВТСписокНачислений.СубконтоДт2,
		|	ВТСписокНачислений.СубконтоДт3,
		|	ВТСписокНачислений.СчетДтНУ,
		|	ВТСписокНачислений.СубконтоДтНУ1,
		|	ВТСписокНачислений.СубконтоДтНУ2,
		|	ВТСписокНачислений.СубконтоДтНУ3,
		|	ВТСписокНачислений.ПодразделениеДт,
		|	ВТСписокНачислений.ПодразделениеКт,
		|	ВТСписокНачислений.ФизЛицо,
		|	ВТСписокНачислений.ОблагаетсяЕНВД,
		|	ВТСписокНачислений.Результат КАК РезультатБУ,
		|	ВТСписокНачислений.ПроцентОтчислений,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ИЛИ ВТВзносыДоходыСвод.БазаПФР = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаПФР
		|	КОНЕЦ КАК БазаПФР,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуФОМС
		|				ИЛИ ВТВзносыДоходыСвод.БазаФОМС = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаФОМС
		|	КОНЕЦ КАК БазаФОМС,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуФСС
		|				ИЛИ ВТВзносыДоходыСвод.БазаФСС = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаФСС
		|	КОНЕЦ КАК БазаФСС,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуФСС_НС
		|				ИЛИ ВТВзносыДоходыСвод.БазаФСС_НС = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаФСС_НС
		|	КОНЕЦ КАК БазаФСС_НС,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ИЛИ ВТВзносыДоходыСвод.БазаДопТариф = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаДопТариф
		|	КОНЕЦ КАК БазаДопТариф,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ИЛИ ВТВзносыДоходыСвод.БазаШахтеры = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаШахтеры
		|	КОНЕЦ КАК БазаШахтеры,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ИЛИ ВТВзносыДоходыСвод.БазаДопТарифПодземныеИВредныеРаботы = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаДопТарифПодземныеИВредныеРаботы
		|	КОНЕЦ КАК БазаДопТарифПодземныеИВредныеРаботы,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ИЛИ ВТВзносыДоходыСвод.БазаДопТарифТяжелыеИПрочиеРаботы = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТВзносыДоходыПоВР.Результат / ВТВзносыДоходыСвод.БазаДопТарифТяжелыеИПрочиеРаботы
		|	КОНЕЦ КАК БазаДопТарифТяжелыеИПрочиеРаботы,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуПФР
		|				ИЛИ ВТБУДоходыСвод.Результат = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТСписокНачислений.Результат / ВТБУДоходыСвод.Результат
		|	КОНЕЦ КАК ДоляБУПФР,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуФОМС
		|				ИЛИ ВТБУДоходыСвод.Результат = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТСписокНачислений.Результат / ВТБУДоходыСвод.Результат
		|	КОНЕЦ КАК ДоляБУФОМС,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуФСС
		|				ИЛИ ВТБУДоходыСвод.Результат = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТСписокНачислений.Результат / ВТБУДоходыСвод.Результат
		|	КОНЕЦ КАК ДоляБУФСС,
		|	ВЫБОР
		|		КОГДА НЕ ВТВзносыДоходыПоВР.ВходитВБазуФСС_НС
		|				ИЛИ ВТБУДоходыСвод.Результат = 0
		|			ТОГДА 0
		|		ИНАЧЕ ВТСписокНачислений.Результат / ВТБУДоходыСвод.Результат
		|	КОНЕЦ КАК ДоляБУФСС_НС,
		|	ВТБУДоходыСводПоВР.Результат
		|ПОМЕСТИТЬ ВТВзносыДоходыБУДоходы
		|ИЗ
		|	ВТСписокНачислений КАК ВТСписокНачислений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВзносыДоходыПоВР КАК ВТВзносыДоходыПоВР
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВзносыДоходыСвод КАК ВТВзносыДоходыСвод
		|			ПО ВТВзносыДоходыПоВР.ФизЛицо = ВТВзносыДоходыСвод.ФизЛицо
		|				И ВТВзносыДоходыПоВР.ОблагаетсяЕНВД = ВТВзносыДоходыСвод.ОблагаетсяЕНВД
		|		ПО ВТСписокНачислений.ФизЛицо = ВТВзносыДоходыПоВР.ФизЛицо
		|			И ВТСписокНачислений.ВидРасчета = ВТВзносыДоходыПоВР.ВидРасчета
		|			И ВТСписокНачислений.ОблагаетсяЕНВД = ВТВзносыДоходыПоВР.ОблагаетсяЕНВД
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТБУДоходыСвод КАК ВТБУДоходыСвод
		|		ПО ВТСписокНачислений.ФизЛицо = ВТБУДоходыСвод.ФизЛицо
		|			И ВТСписокНачислений.ВидРасчета = ВТБУДоходыСвод.ВидРасчета
		|			И ВТСписокНачислений.ОблагаетсяЕНВД = ВТБУДоходыСвод.ОблагаетсяЕНВД
		|			И ВТСписокНачислений.Резерв = ВТБУДоходыСвод.Резерв
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБУДоходыСводПоВР КАК ВТБУДоходыСводПоВР
		|		ПО ВТСписокНачислений.ФизЛицо = ВТБУДоходыСводПоВР.ФизЛицо
		|			И ВТСписокНачислений.ВидРасчета = ВТБУДоходыСводПоВР.ВидРасчета
		|			И ВТСписокНачислений.Резерв = ВТБУДоходыСводПоВР.Резерв
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Коэффициенты.Резерв,
		|	Коэффициенты.ПроцентОтчислений,
		|	Коэффициенты.ФизЛицо,
		|	Коэффициенты.ВидРасчета,
		|	СписокНачислений.Результат,
		|	Коэффициенты.ПФРСтраховая,
		|	Коэффициенты.ПФРСтраховаяЕНВД,
		|	Коэффициенты.ПФРПоСуммарномуТарифу,
		|	Коэффициенты.ПФРПоСуммарномуТарифуЕНВД,
		|	Коэффициенты.ПФРНакопительная,
		|	Коэффициенты.ПФРНакопительнаяЕНВД,
		|	Коэффициенты.ФФОМС,
		|	Коэффициенты.ФФОМСЕНВД,
		|	Коэффициенты.ТФОМС,
		|	Коэффициенты.ТФОМСЕНВД,
		|	Коэффициенты.ФСС,
		|	Коэффициенты.ФССЕНВД,
		|	Коэффициенты.ФССНесчастныеСлучаи,
		|	Коэффициенты.ФССНесчастныеСлучаиЕНВД,
		|	Коэффициенты.ПФРПоДополнительномуТарифу,
		|	Коэффициенты.ПФРНаДоплатуКПенсииШахтерам,
		|	Коэффициенты.ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,
		|	Коэффициенты.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах,
		|	Коэффициенты.СчетДт,
		|	Коэффициенты.СубконтоДт1,
		|	Коэффициенты.СубконтоДт2,
		|	Коэффициенты.СубконтоДт3,
		|	Коэффициенты.СчетДтНУ,
		|	Коэффициенты.СубконтоДтНУ1,
		|	Коэффициенты.СубконтоДтНУ2,
		|	Коэффициенты.СубконтоДтНУ3,
		|	Коэффициенты.ПодразделениеДт,
		|	Коэффициенты.ПодразделениеКт
		|ПОМЕСТИТЬ ВТКоэффициенты
		|ИЗ
		|	ВТСписокНачислений КАК СписокНачислений
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВзносыДоходыБУДоходы.Резерв КАК Резерв,
		|			ВзносыДоходыБУДоходы.ПроцентОтчислений КАК ПроцентОтчислений,
		|			ВзносыДоходыБУДоходы.ФизЛицо КАК ФизЛицо,
		|			ВзносыДоходыБУДоходы.ВидРасчета КАК ВидРасчета,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ПФРСтраховая, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаПФР
		|				КОНЕЦ) КАК ПФРСтраховая,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ПФРСтраховаяЕНВД, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаПФР
		|				КОНЕЦ) КАК ПФРСтраховаяЕНВД,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ПФРПоСуммарномуТарифу, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаПФР
		|				КОНЕЦ) КАК ПФРПоСуммарномуТарифу,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ПФРПоСуммарномуТарифуЕНВД, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаПФР
		|				КОНЕЦ) КАК ПФРПоСуммарномуТарифуЕНВД,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ПФРНакопительная, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаПФР
		|				КОНЕЦ) КАК ПФРНакопительная,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ПФРНакопительнаяЕНВД, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаПФР
		|				КОНЕЦ) КАК ПФРНакопительнаяЕНВД,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ФФОМС, 0) * ВзносыДоходыБУДоходы.ДоляБУФОМС * ВзносыДоходыБУДоходы.БазаФОМС
		|				КОНЕЦ) КАК ФФОМС,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ФФОМСЕНВД, 0) * ВзносыДоходыБУДоходы.ДоляБУФОМС * ВзносыДоходыБУДоходы.БазаФОМС
		|				КОНЕЦ) КАК ФФОМСЕНВД,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ТФОМС, 0) * ВзносыДоходыБУДоходы.ДоляБУФОМС * ВзносыДоходыБУДоходы.БазаФОМС
		|				КОНЕЦ) КАК ТФОМС,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ТФОМСЕНВД, 0) * ВзносыДоходыБУДоходы.ДоляБУФОМС * ВзносыДоходыБУДоходы.БазаФОМС
		|				КОНЕЦ) КАК ТФОМСЕНВД,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ФСС, 0) * ВзносыДоходыБУДоходы.ДоляБУФСС * ВзносыДоходыБУДоходы.БазаФСС
		|				КОНЕЦ) КАК ФСС,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ФССЕНВД, 0) * ВзносыДоходыБУДоходы.ДоляБУФСС * ВзносыДоходыБУДоходы.БазаФСС
		|				КОНЕЦ) КАК ФССЕНВД,
		|			СУММА(ВЫБОР
		|					КОГДА ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ФССНесчастныеСлучаи, 0) * ВзносыДоходыБУДоходы.ДоляБУФСС_НС * ВзносыДоходыБУДоходы.БазаФСС_НС
		|				КОНЕЦ) КАК ФССНесчастныеСлучаи,
		|			СУММА(ВЫБОР
		|					КОГДА НЕ ВзносыДоходыБУДоходы.ОблагаетсяЕНВД
		|						ТОГДА 0
		|					ИНАЧЕ ЕСТЬNULL(ВзносыИсчисленные.ФССНесчастныеСлучаи, 0) * ВзносыДоходыБУДоходы.ДоляБУФСС_НС * ВзносыДоходыБУДоходы.БазаФСС_НС
		|				КОНЕЦ) КАК ФССНесчастныеСлучаиЕНВД,
		|			СУММА(ЕСТЬNULL(ВзносыИсчисленные.ПФРПоДополнительномуТарифу, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаДопТариф) КАК ПФРПоДополнительномуТарифу,
		|			СУММА(ЕСТЬNULL(ВзносыИсчисленные.ПФРНаДоплатуКПенсииШахтерам, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаШахтеры) КАК ПФРНаДоплатуКПенсииШахтерам,
		|			СУММА(ЕСТЬNULL(ВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботах + ВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный + ВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1 + ВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2 + ВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3 + ВзносыИсчисленные.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаДопТарифПодземныеИВредныеРаботы) КАК ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,
		|			СУММА(ЕСТЬNULL(ВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах + ВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный + ВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1 + ВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2 + ВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3 + ВзносыИсчисленные.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4, 0) * ВзносыДоходыБУДоходы.ДоляБУПФР * ВзносыДоходыБУДоходы.БазаДопТарифТяжелыеИПрочиеРаботы) КАК ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах,
		|			ВзносыДоходыБУДоходы.СчетДт КАК СчетДт,
		|			ВзносыДоходыБУДоходы.СубконтоДт1 КАК СубконтоДт1,
		|			ВзносыДоходыБУДоходы.СубконтоДт2 КАК СубконтоДт2,
		|			ВзносыДоходыБУДоходы.СубконтоДт3 КАК СубконтоДт3,
		|			ВзносыДоходыБУДоходы.СчетДтНУ КАК СчетДтНУ,
		|			ВзносыДоходыБУДоходы.СубконтоДтНУ1 КАК СубконтоДтНУ1,
		|			ВзносыДоходыБУДоходы.СубконтоДтНУ2 КАК СубконтоДтНУ2,
		|			ВзносыДоходыБУДоходы.СубконтоДтНУ3 КАК СубконтоДтНУ3,
		|			ВзносыДоходыБУДоходы.ПодразделениеДт КАК ПодразделениеДт,
		|			ВзносыДоходыБУДоходы.ПодразделениеКт КАК ПодразделениеКт
		|		ИЗ
		|			ВТВзносыДоходыБУДоходы КАК ВзносыДоходыБУДоходы
		|				ЛЕВОЕ СОЕДИНЕНИЕ ВТВзносыИсчисленные КАК ВзносыИсчисленные
		|				ПО ВзносыДоходыБУДоходы.ФизЛицо = ВзносыИсчисленные.ФизЛицо
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ВзносыДоходыБУДоходы.Резерв,
		|			ВзносыДоходыБУДоходы.ПроцентОтчислений,
		|			ВзносыДоходыБУДоходы.ФизЛицо,
		|			ВзносыДоходыБУДоходы.ВидРасчета,
		|			ВзносыДоходыБУДоходы.СчетДт,
		|			ВзносыДоходыБУДоходы.СубконтоДт1,
		|			ВзносыДоходыБУДоходы.СубконтоДт2,
		|			ВзносыДоходыБУДоходы.СубконтоДт3,
		|			ВзносыДоходыБУДоходы.СчетДтНУ,
		|			ВзносыДоходыБУДоходы.СубконтоДтНУ1,
		|			ВзносыДоходыБУДоходы.СубконтоДтНУ2,
		|			ВзносыДоходыБУДоходы.СубконтоДтНУ3,
		|			ВзносыДоходыБУДоходы.ПодразделениеДт,
		|			ВзносыДоходыБУДоходы.ПодразделениеКт) КАК Коэффициенты
		|		ПО СписокНачислений.Резерв = Коэффициенты.Резерв
		|			И СписокНачислений.ВидРасчета = Коэффициенты.ВидРасчета
		|			И СписокНачислений.ФизЛицо = Коэффициенты.ФизЛицо
		|			И СписокНачислений.СчетДт = Коэффициенты.СчетДт
		|			И СписокНачислений.СубконтоДт1 = Коэффициенты.СубконтоДт1
		|			И СписокНачислений.СубконтоДт2 = Коэффициенты.СубконтоДт2
		|			И СписокНачислений.СубконтоДт3 = Коэффициенты.СубконтоДт3
		|			И СписокНачислений.ПодразделениеДт = Коэффициенты.ПодразделениеДт
		|			И СписокНачислений.СчетДтНУ = Коэффициенты.СчетДтНУ
		|			И СписокНачислений.СубконтоДтНУ1 = Коэффициенты.СубконтоДтНУ1
		|			И СписокНачислений.СубконтоДтНУ2 = Коэффициенты.СубконтоДтНУ2
		|			И СписокНачислений.СубконтоДтНУ3 = Коэффициенты.СубконтоДтНУ3
		|			И СписокНачислений.ПодразделениеКт = Коэффициенты.ПодразделениеКт
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РезервыПоВидамРасчета.Резерв,
		|	РезервыПоВидамРасчета.ВидРасчета,
		|	ВЫРАЗИТЬ(РезервыПоВидамРасчета.Результат * РезервыПоВидамРасчета.ПроцентОтчислений / 100 КАК ЧИСЛО(15, 2)) КАК РазмерОтчислений,
		|	ВЫРАЗИТЬ(РезервыПоВидамРасчета.РезультатВзносы * РезервыПоВидамРасчета.ПроцентОтчислений / 100 КАК ЧИСЛО(15, 2)) КАК РазмерОтчисленийВзносы,
		|	ВЫРАЗИТЬ(РезервыПоВидамРасчета.РезультатВзносыФССНесчастныеСлучаи * РезервыПоВидамРасчета.ПроцентОтчислений / 100 КАК ЧИСЛО(15, 2)) КАК РазмерОтчисленийФССНесчастныеСлучаи,
		|	РезервыПоВидамРасчета.Результат,
		|	РезервыПоВидамРасчета.РезультатВзносы КАК РезультатВзносы,
		|	РезервыПоВидамРасчета.РезультатВзносыФССНесчастныеСлучаи КАК РезультатВзносыФССНесчастныеСлучаи,
		|	РезервыПоВидамРасчета.ПроцентОтчислений
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВТКоэффициенты.Резерв КАК Резерв,
		|		ВТКоэффициенты.ВидРасчета КАК ВидРасчета,
		|		ВТКоэффициенты.ПроцентОтчислений КАК ПроцентОтчислений,
		|		СУММА(ВТКоэффициенты.Результат) КАК Результат,
		|		СУММА(ВТКоэффициенты.ФССНесчастныеСлучаи + ВТКоэффициенты.ФССНесчастныеСлучаиЕНВД) КАК РезультатВзносыФССНесчастныеСлучаи,
		|		СУММА(ВТКоэффициенты.ПФРПоСуммарномуТарифу + ВТКоэффициенты.ПФРПоСуммарномуТарифуЕНВД + ВТКоэффициенты.ПФРСтраховая + ВТКоэффициенты.ПФРСтраховаяЕНВД + ВТКоэффициенты.ПФРНакопительная + ВТКоэффициенты.ПФРНакопительнаяЕНВД + ВТКоэффициенты.ФФОМС + ВТКоэффициенты.ФФОМСЕНВД + ВТКоэффициенты.ТФОМС + ВТКоэффициенты.ТФОМСЕНВД + ВТКоэффициенты.ФСС + ВТКоэффициенты.ФССЕНВД + ВТКоэффициенты.ПФРПоДополнительномуТарифу + ВТКоэффициенты.ПФРНаДоплатуКПенсииШахтерам + ВТКоэффициенты.ПФРЗаЗанятыхНаПодземныхИВредныхРаботах + ВТКоэффициенты.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах) КАК РезультатВзносы
		|	ИЗ
		|		ВТКоэффициенты КАК ВТКоэффициенты
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ВТКоэффициенты.ВидРасчета,
		|		ВТКоэффициенты.ПроцентОтчислений,
		|		ВТКоэффициенты.Резерв) КАК РезервыПоВидамРасчета";
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;

КонецФункции // ПолучитьТекстЗапросаРасчетОценочныхОбязательств()
