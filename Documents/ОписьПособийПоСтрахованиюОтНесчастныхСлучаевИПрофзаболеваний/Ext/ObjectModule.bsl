﻿

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьДанныеСотрудника(ТекущаяСтрока)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиОрганизаций.Физлицо,
	|	СотрудникиОрганизаций.Ссылка
	|ПОМЕСТИТЬ ВТСотрудник
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Ссылка В(&Ссылки)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудник.Физлицо,
	|	ФИОФизЛицСрезПоследних.Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя,
	|	ФИОФизЛицСрезПоследних.Отчество
	|ИЗ
	|	ВТСотрудник КАК Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(
	|				&Дата,
	|				ФизЛицо В
	|					(ВЫБРАТЬ
	|						Сотрудник.Физлицо
	|					ИЗ
	|						ВТСотрудник КАК Сотрудник)) КАК ФИОФизЛицСрезПоследних
	|		ПО Сотрудник.Физлицо = ФИОФизЛицСрезПоследних.ФизЛицо";
	Запрос.УстановитьПараметр("Ссылки", ТекущаяСтрока.Сотрудник);
	Запрос.УстановитьПараметр("Дата", Дата);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Выборка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеБольничного(ТекущаяСтрока = Неопределено)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НачислениеПоБольничномуЛисту.Ссылка
	|ПОМЕСТИТЬ ВТДокументыЗаполнения
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту КАК НачислениеПоБольничномуЛисту
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОписьПособийПоСтрахованиюОтНесчастныхСлучаевИПрофзаболеваний.РаботникиОрганизации КАК СуществующиеДокументы
	|		ПО НачислениеПоБольничномуЛисту.Ссылка = СуществующиеДокументы.ЛистокНетрудоспособности
	|			И (СуществующиеДокументы.Ссылка <> &ТекущийРеестр)
	|			И (СуществующиеДокументы.Ссылка.Проведен)
	|ГДЕ
	|	НачислениеПоБольничномуЛисту.Проведен
	|	И НачислениеПоБольничномуЛисту.ПериодРегистрации >= &ДатаПередачиФССВыплатыПособий
	|	И &ЗаполнятьВсемиДокументами
	|	И НачислениеПоБольничномуЛисту.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ТравмаНаПроизводстве)
	|	И НачислениеПоБольничномуЛисту.Организация = &Организация
	|	И СуществующиеДокументы.Сотрудник ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НачислениеПоБольничномуЛисту.Ссылка
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту КАК НачислениеПоБольничномуЛисту
	|ГДЕ
	|	НачислениеПоБольничномуЛисту.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачислениеПоБольничномуЛисту.Сотрудник,
	|	НачислениеПоБольничномуЛисту.Физлицо,
	|	НачислениеПоБольничномуЛисту.Ссылка КАК ЛистокНетрудоспособности,
	|	НачислениеПоБольничномуЛисту.НомерВходящегоДокумента,
	|	НачислениеПоБольничномуЛисту.СерияВходящегоДокумента,
	|	НачислениеПоБольничномуЛисту.Фамилия,
	|	НачислениеПоБольничномуЛисту.Имя,
	|	НачислениеПоБольничномуЛисту.Отчество,
	|	НачислениеПоБольничномуЛисту.ДатаВыдачиБольничного,
	|	""Заявление о выплате пособия, Листок нетруд-ти № "" + НачислениеПоБольничномуЛисту.НомерВходящегоДокумента КАК ДокументыОснования,
	|	4 КАК КоличествоСтраниц
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту КАК НачислениеПоБольничномуЛисту
	|ГДЕ
	|	НачислениеПоБольничномуЛисту.Ссылка В
	|			(ВЫБРАТЬ
	|				ДокументыЗаполнения.Ссылка
	|			ИЗ
	|				ВТДокументыЗаполнения КАК ДокументыЗаполнения)";
	
	Запрос.УстановитьПараметр("ДатаПередачиФССВыплатыПособий", ПроцедурыУправленияПерсоналом.ЗначениеУчетнойПолитикиПоПерсоналуОрганизации(глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"), Организация, "ДатаПередачиФССВыплатыПособий"));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТекущийРеестр", Ссылка);
	Запрос.УстановитьПараметр("ЗаполнятьВсемиДокументами", ТекущаяСтрока = Неопределено);
	Если ТекущаяСтрока <> Неопределено Тогда
		Запрос.УстановитьПараметр("Ссылка", ТекущаяСтрока.ЛистокНетрудоспособности);
	Иначе
		Запрос.УстановитьПараметр("Ссылка", Документы.НачислениеПоБольничномуЛисту.ПустаяСсылка());
	КонецЕсли;
	Если ТекущаяСтрока <> Неопределено Тогда
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Выборка);
		КонецЕсли;
	Иначе
		РаботникиОрганизации.Загрузить(Запрос.Выполнить().Выгрузить())
	КонецЕсли;
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Печатает реестр сведений для назначения и выплаты пособий
//
// Параметры
//  нет
//
// Возвращаемое значение:
//   ТабличныйДокумент
//
Функция ПечатьОписьЗаявленийИДокументовВФСС(ИмяМакета)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
		
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента().Выбрать();
	ВыборкаПоШапкеДокумента.Следующий();
	
	ВыборкаПоТЧРаботникиОрганизации = СформироватьЗапросПоТЧРаботникиОрганизации().Выбрать();
	
	Отказ = Ложь;
	
	ПроверитьПравильностьЗаполненияДокумента(Отказ, Ложь, ВыборкаПоШапкеДокумента, ВыборкаПоТЧРаботникиОрганизации);
	
	Если Отказ Тогда
	
		ОбработкаКомментариев.ПоказатьСообщения();
		Возврат Неопределено;
	
	КонецЕсли; 
	
	ВыборкаПоТЧРаботникиОрганизации.Сбросить();
	
	Возврат ОбменСведениямиОПособияхСФСС.ПечатьОписьЗаявленийИДокументовВФСС(ВыборкаПоШапкеДокумента, ВыборкаПоТЧРаботникиОрганизации, ИмяМакета);
		

КонецФункции // ПечатьРеестрСведенийВФСС()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

//Процедура вывода сведений на печать
Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	Если Лев(ИмяМакета,29) = "ОписьЗаявленийИДокументовВФСС" Тогда
		
		ТабДокумент = Новый ТабличныйДокумент;
		
		УточненноеИмяМакета = "ОписьЗаявленийИДокументовВФСС" + ?(Дата < ОбменСведениямиОПособияхСФСС.ДатаВступленияВСилуФорм2012года(), "_2011", ?(Дата < ОбменСведениямиОПособияхСФСС.ДатаВступленияВСилуФорм2017года(), "_2012", "_2017"));
		ТабДокумент = ПечатьОписьЗаявленийИДокументовВФСС(УточненноеИмяМакета);
		
		Возврат УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, "Опись заявлений и документов в ФСС",,ТабДокумент);
		
	КонецЕсли;
	
КонецФункции // Печать() 
 
#КонецЕсли

Процедура Автозаполнение(Режим = Неопределено, ТекущаяСтрока = Неопределено) Экспорт
	
	Если Режим = "ДанныеСотрудника" Тогда
		ЗаполнитьДанныеСотрудника(ТекущаяСтрока)
	ИначеЕсли Режим = "ДанныеБольничного" Тогда	
		ТекущийСотрудник = ТекущаяСтрока.Сотрудник;
		ЗаполнитьДанныеБольничного(ТекущаяСтрока);
	Иначе	
		ЗаполнитьДанныеБольничного();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПравильностьЗаполненияДокумента(ЕстьОшибки, СообщатьОбУспехе = Истина, ВыборкаПоШапкеДокумента = Неопределено, ВыборкаПоРаботникиОрганизации = Неопределено) Экспорт
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);

	Обработка = глЗначениеПеременной("глОбработкаСообщений");
	СообщенияРазделПроверки = Обработка.ДобавитьСообщение(Заголовок, Перечисления.ВидыСообщений.Информация);

	Если ВыборкаПоШапкеДокумента = Неопределено Тогда
		ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента().Выбрать();
		ВыборкаПоШапкеДокумента.Следующий();
	КонецЕсли;
	Если ВыборкаПоШапкеДокумента = Неопределено Тогда
		ВыборкаПоРаботникиОрганизации = СформироватьЗапросПоТЧРаботникиОрганизации().Выбрать();
	КонецЕсли;
	
	Отказ = Ложь;
	
	ПроверкаЗаполненияШапкиДокумента(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
	
	Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл
		
		ПроверитьЗаполнениеСтрокиТЧРаботникиОрганизации(ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);
		
	КонецЦикла; 
	
	Если Отказ тогда
		ЕстьОшибки = Истина;
	КонецЕсли;	 
	
	Если СообщатьОбУспехе И Не ЕстьОшибки Тогда
		Обработка.ДобавитьСообщение("Ошибок не обнаружено.", Перечисления.ВидыСообщений.Информация, , СообщенияРазделПроверки);		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьПравильностьЗаполненияДокумента()


// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ОписьЗаявленийИДокументовВФСС", "Опись заявлений и документов");
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА


// Собирает сведения по щапке документа для вывода напечать и проверки заполнения
//
// Параметры
//  нет
//
// Возвращаемое значение:
//   результат выполнения запроса
//
Функция СформироватьЗапросПоШапкеДокумента()

	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.НаименованиеПолное КАК НаименованиеОрганизации,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Организация.НаименованиеСокращенное = """"
	|			ТОГДА ДанныеДокумента.Организация.НаименованиеПолное
	|		ИНАЧЕ ДанныеДокумента.Организация.НаименованиеСокращенное
	|	КОНЕЦ КАК ОрганизацияСокращенно,
	|	ДанныеДокумента.НаименованиеТерриториальногоОрганаФСС,
	|	ДанныеДокумента.РегистрационныйНомерФСС,
	|	ДанныеДокумента.ДополнительныйКодФСС,
	|	ДанныеДокумента.КодПодчиненностиФСС,
	|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, ДанныеДокумента.Руководитель.Наименование) КАК ФИОРуководителя,
	|	ДанныеДокумента.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителя,
	|	ДанныеДокумента.ИНН КАК ИННОрганизации,
	|	ДанныеДокумента.КПП КАК КППОрганизации,
	|	ДанныеДокумента.ТелефонСоставителя
	|ИЗ
	|	Документ.ОписьПособийПоСтрахованиюОтНесчастныхСлучаевИПрофзаболеваний КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&Дата, ФизЛицо = &Руководитель) КАК ФИОФизЛицСрезПоследних
	|		ПО ДанныеДокумента.Руководитель = ФИОФизЛицСрезПоследних.ФизЛицо
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка";

	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("Руководитель", Руководитель);
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Возврат Запрос.Выполнить();	

КонецФункции // СформироватьЗапросПоШапкеДокумента()

// Запрос по табличной части РаботникиОрганизации для вывода на печать и проверки корректности заполнения
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция СформироватьЗапросПоТЧРаботникиОрганизации()
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пособия.Фамилия + "" "" + Пособия.Имя + "" "" + Пособия.Отчество КАК ФИОСотрудника,
	|	Пособия.Ссылка,
	|	Пособия.НомерСтроки КАК НомерСтроки,
	|	Пособия.Сотрудник,
	|	Пособия.ФизЛицо,
	|	Пособия.КоличествоСтраниц,
	|	""6"" КАК ВидВыплаты,
	|	Пособия.ДокументыОснования,
	|	Пособия.Фамилия,
	|	Пособия.Имя,
	|	Пособия.Отчество
	|ИЗ
	|	Документ.ОписьПособийПоСтрахованиюОтНесчастныхСлучаевИПрофзаболеваний.РаботникиОрганизации КАК Пособия
	|ГДЕ
	|	Пособия.Ссылка = &ДокументСсылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоТЧРаботникиОрганизации()
 
// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен некорректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
//
// Параметры: 
//	ВыборкаПоШапкеДокумента	- выборка из результата запрос
//	Отказ 					- флаг отказа
//	Заголовок				- Заголовок для сообщений об ошибках
Процедура ПроверкаЗаполненияШапкиДокумента(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Не указана организация!"), Отказ, Заголовок);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ИННОрганизации) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан ИНН!", Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.НаименованиеТерриториальногоОрганаФСС) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указано наименование территориального органа ФСС!", Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.РегистрационныйНомерФСС) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан регистрационный номер в ФСС!", Отказ, Заголовок);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.КодПодчиненностиФСС) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан код подчиненности ФСС!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверкаЗаполненияШапкиДокумента()

// Проверяет заполненность полей табличной части "РаботникиОрганизации"
// Проверка ведется по строке выборки по табличной части
//
// Параметры
// Параметры: 
//	СтрокаВыборкиПоТЧРаботникиОрганизации	- выборка из результата запрос
//	Отказ 									- флаг отказа
//	Заголовок								- Заголовок для сообщений об ошибках
//
Процедура ПроверитьЗаполнениеСтрокиТЧРаботникиОрганизации(СтрокаВыборкиПоТЧРаботникиОрганизации, Отказ, Заголовок)

	ТекстОшибкиСНомеромСтроки = НСтр("ru='В строке номер %НомерСтроки% табличной части ""Сотрудники"": '");
	ТекстОшибкиСНомеромСтроки = СтрЗаменить(ТекстОшибкиСНомеромСтроки, "%НомерСтроки%", СтрокаВыборкиПоТЧРаботникиОрганизации.НомерСтроки);
	
	Если Не ЗначениеЗаполнено(СтрокаВыборкиПоТЧРаботникиОрганизации.ФИОСотрудника) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибкиСНомеромСтроки + "Не указано ФИО сотрудника!", Отказ, Заголовок);
	КонецЕсли;

	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиТЧРаботникиОрганизации()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	Для Каждого Набор Из Движения Цикл
		Набор.Очистить();
	КонецЦикла;
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента().Выбрать();
	ВыборкаПоШапкеДокумента.Следующий();
	
	ВыборкаПоРаботникиОрганизации = СформироватьЗапросПоТЧРаботникиОрганизации().Выбрать();
	ПроверитьПравильностьЗаполненияДокумента(Отказ, Ложь, ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации);
	
	Если Отказ тогда
		ОбработкаКомментариев.ПоказатьСообщения();
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Сотрудник");

КонецПроцедуры

