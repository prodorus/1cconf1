Перем мУдалятьДвижения;

// Строки, хранят реквизиты имеющие смысл только для бух. учета и упр. соответственно
// в случае если документ не отражается в каком-то виде учета, делаются невидимыми
Перем мСтрокаРеквизитыБухУчета Экспорт; // (Регл)
Перем мСтрокаРеквизитыУпрУчета Экспорт; // (Упр)
Перем мСтрокаРеквизитыНалУчета Экспорт; // (Регл)

Перем мВалютаРегламентированногоУчета Экспорт;
Перем мВалютаУправленческогоУчета     Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Процедура формирования печатной формы ПеремещенияМатериалов
//
Функция ПечатьПеремещениеМатериалов(ТипУчета)
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ПеремещениеМатериаловВЭксплуатации.Ссылка,
	               |	ПеремещениеМатериаловВЭксплуатации.Номер,
	               |	ПеремещениеМатериаловВЭксплуатации.Дата,
	               |	ПеремещениеМатериаловВЭксплуатации.Организация.Представление КАК ПечОрганизация,
	               |	ПеремещениеМатериаловВЭксплуатации.Организация КАК Организация,
	               |	ВЫБОР
	               |		КОГДА &ТипУчета = ""Упр""
	               |			ТОГДА ПеремещениеМатериаловВЭксплуатации.Подразделение
	               |		ИНАЧЕ ПеремещениеМатериаловВЭксплуатации.ПодразделениеОрганизации
	               |	КОНЕЦ КАК Подразделение,
	               |	ВЫБОР
	               |		КОГДА &ТипУчета = ""Упр""
	               |			ТОГДА ПеремещениеМатериаловВЭксплуатации.Подразделение.Представление
	               |		ИНАЧЕ ПеремещениеМатериаловВЭксплуатации.ПодразделениеОрганизации.Представление
	               |	КОНЕЦ КАК ПечПодразделение,
	               |	ПеремещениеМатериаловВЭксплуатации.Материалы.(
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура,
	               |		Номенклатура.Код КАК Код,
	               |		Номенклатура.Артикул КАК Артикул,
	               |		Номенклатура.Представление КАК ПечНоменклатура,
	               |		СерияНоменклатуры,
	               |		ХарактеристикаНоменклатуры,
	               |		ФизЛицо,
	               |		ФизЛицоПолучатель,
	               |		ФизЛицо.Представление КАК ПечФизЛицо,
	               |		ФизЛицоПолучатель.Представление КАК ПечФизЛицоПолучатель,
	               |		ВЫБОР
	               |			КОГДА &ТипУчета = ""Упр""
	               |				ТОГДА ПеремещениеМатериаловВЭксплуатации.Материалы.ПодразделениеПолучатель
	               |			ИНАЧЕ ПеремещениеМатериаловВЭксплуатации.Материалы.ПодразделениеОрганизацииПолучатель
	               |		КОНЕЦ КАК Подразделение,
	               |		ВЫБОР
	               |			КОГДА &ТипУчета = ""Упр""
	               |				ТОГДА ПеремещениеМатериаловВЭксплуатации.Материалы.ПодразделениеПолучатель.Представление
	               |			ИНАЧЕ ПеремещениеМатериаловВЭксплуатации.Материалы.ПодразделениеОрганизацииПолучатель.Представление
	               |		КОНЕЦ КАК ПечПодразделение,
	               |		ВЫБОР
	               |			КОГДА &ФиксСтоимость = ПеремещениеМатериаловВЭксплуатации.Материалы.ТипСтоимости
	               |				ТОГДА ВЫБОР
	               |						КОГДА &ТипУчета = ""Упр""
	               |							ТОГДА ПеремещениеМатериаловВЭксплуатации.Материалы.Сумма
	               |						ИНАЧЕ ПеремещениеМатериаловВЭксплуатации.Материалы.СуммаРегл
	               |					КОНЕЦ
	               |			ИНАЧЕ """"
	               |		КОНЕЦ КАК Сумма,
	               |		Количество КАК Количество,
	               |		СчетУчетаБУ КАК Счет,
	               |		СчетУчетаПолучательБУ КАК СчетПолучатель,
	               |		СчетУчетаБУ.Представление КАК ПечСчет,
	               |		СчетУчетаПолучательБУ.Представление КАК ПечСчетПолучатель,
	               |		ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |		ЕдиницаИзмерения.Представление КАК ПечЕдиницаИзмерения
	               |	)
	               |ИЗ
	               |	Документ.ПеремещениеМатериаловВЭксплуатации КАК ПеремещениеМатериаловВЭксплуатации
	               |ГДЕ
	               |	ПеремещениеМатериаловВЭксплуатации.Ссылка = &ТекДок
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр( "ТекДок",   Ссылка);
	Запрос.УстановитьПараметр( "ТипУчета", ТипУчета);
	Запрос.УстановитьПараметр( "ФиксСтоимость", Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная);
	
	РезультатЗапроса = Запрос.Выполнить();
	Шапка = РезультатЗапроса.Выбрать();
	Шапка.Следующий();
	
	// Вывод заголовка
	ТабДок  = Новый ТабличныйДокумент;
	Макет   = ПолучитьМакет("ПеремещениеМатериалов");
	Область = Макет.ПолучитьОбласть("Заголовок");
	Область.Параметры.Заголовок = ОбщегоНазначения.СформироватьЗаголовокДокумента( ЭтотОбъект);
	Область.Параметры.Организация      = Шапка.Организация;
	Область.Параметры.ПечОрганизация   = Шапка.ПечОрганизация;
	Область.Параметры.Подразделение    = Шапка.Подразделение;
	Область.Параметры.ПечПодразделение = Шапка.ПечПодразделение;
	
	ТабДок.Вывести(Область);
	
	ДопКолонка = Константы.ДополнительнаяКолонкаПечатныхФормДокументов.Получить();
	ФлагВыводКода = НЕ ПустаяСтрока(ДопКолонка) 
		И ДопКолонка <> Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.НеВыводить;
	Область = Макет.ПолучитьОбласть("ТабШапка" + ?(ФлагВыводКода, "", "Доп") + "|Материал");
	Если ФлагВыводКода Тогда
		Область.Параметры.КодАртикул = ?( ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Артикул, "Артикул",
							 		   ?( ДопКолонка = Перечисления.ДополнительнаяКолонкаПечатныхФормДокументов.Код,     "Код", ""));
	КонецЕсли;
	ТабДок.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("ТабШапка" + ?(ТипУчета = "Бух", "", "Доп") + "|Данные");
	ТабДок.Присоединить(Область);
	
	// Вывод таб. части
	ОбластьМат    = Макет.ПолучитьОбласть("ТабСтрока" + ?(ФлагВыводКода,    "", "Доп") + "|Материал");
	ОбластьДанные = Макет.ПолучитьОбласть("ТабСтрока" + ?(ТипУчета = "Бух", "", "Доп") + "|Данные");
	ТабЧасть = Шапка.Материалы.Выбрать();
	Пока ТабЧасть.Следующий() Цикл
		
		ОбластьМат.Параметры.ПечНом               = ТабЧасть.НомерСтроки;
		ОбластьМат.Параметры.Номенклатура         = ТабЧасть.Номенклатура;
		ОбластьМат.Параметры.ПечНоменклатура      = ТабЧасть.ПечНоменклатура;
		Если ФлагВыводКода Тогда
			ОбластьМат.Параметры.ПечКод = ТабЧасть[ДопКолонка];
		КонецЕсли;
		ТабДок.Вывести(ОбластьМат);
		
		ОбластьДанные.Параметры.ФизЛицо              = ТабЧасть.ФизЛицо;
		ОбластьДанные.Параметры.ПечФизЛицо           = ТабЧасть.ПечФизЛицо;
		ОбластьДанные.Параметры.ФизЛицоПолучатель    = ТабЧасть.ФизЛицоПолучатель;
		ОбластьДанные.Параметры.ПечФизЛицоПолучатель = ТабЧасть.ПечФизЛицоПолучатель;
		ОбластьДанные.Параметры.Подразделение        = ТабЧасть.Подразделение;
		ОбластьДанные.Параметры.ПечПодразделение     = ТабЧасть.ПечПодразделение;
		
		ОбластьДанные.Параметры.ПечКол            = ТабЧасть.Количество;
		ОбластьДанные.Параметры.ПечЕд             = ТабЧасть.ПечЕдиницаИзмерения;
		ОбластьДанные.Параметры.ЕдИзм             = ТабЧасть.ЕдиницаИзмерения;
		ОбластьДанные.Параметры.ПечСумма          = ТабЧасть.Сумма;
		
		Если ТипУчета = "Бух" Тогда
			
			ОбластьДанные.Параметры.Счет              = ТабЧасть.Счет;
			ОбластьДанные.Параметры.ПечСчет           = ТабЧасть.ПечСчет;
			ОбластьДанные.Параметры.СчетПолучатель    = ТабЧасть.СчетПолучатель;
			ОбластьДанные.Параметры.ПечСчетПолучатель = ТабЧасть.ПечСчетПолучатель;
			
		КонецЕсли;
		ТабДок.Присоединить(ОбластьДанные);
		
	КонецЦикла;
	
	Область = Макет.ПолучитьОбласть("ТабПодвал");
	ТабДок.Вывести(Область);
	
	Область = Макет.ПолучитьОбласть("Подвал");
	Область.Параметры.СтрокаИтог = "Всего наименований: " + ТабЧасть.Количество();
	ТабДок.Вывести( Область);
	
	Возврат ТабДок;
	
КонецФункции // ПечатьПеремещениеМатериалов()
	
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

	// Получить экземпляр документа на печать
	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли;
		
	ИначеЕсли ИмяМакета = "ПеремещениеМатериалов"
		  ИЛИ ИмяМакета = "ПеремещениеМатериаловУпр"
		  ИЛИ ИмяМакета = "ПеремещениеМатериаловБух" Тогда
		
		ТипУчета = ?( ИмяМакета = "ПеремещениеМатериаловУпр", "Упр",
				   ?( ИмяМакета = "ПеремещениеМатериаловБух", "Бух",
				   ?( ОтражатьВУправленческомУчете, "Упр", "Бух")));
		ТабДокумент = ПечатьПеремещениеМатериалов(ТипУчета);
		
	КонецЕсли;
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(Ссылка), Ссылка);
	
КонецПроцедуры // Печать()

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктПечФорм = Новый Структура;
	Если ОтражатьВУправленческомУчете И ОтражатьВБухгалтерскомУчете Тогда
		СтруктПечФорм.Вставить( "ПеремещениеМатериаловУпр", "Перемещение материалов в эксплуатации (упр.)");
		СтруктПечФорм.Вставить( "ПеремещениеМатериаловБух", "Перемещение материалов в эксплуатации (регл.)");
	Иначе
		СтруктПечФорм.Вставить( "ПеремещениеМатериалов", "Перемещение материалов в эксплуатации");
	КонецЕсли;
	
	Возврат СтруктПечФорм;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для определенного вида учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета() Экспорт
	
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр();
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл();
	
КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для упр. учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()
	
	мСтрокаРеквизитыУпрУчета = "Подразделение, НадписьПодразделение,
							   |Материалы.Сумма, Получатели.ПодразделениеПолучатель";
	
КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаУпр()

// Процедура заполняет структуры именами реквизитов, которые имеют смысл
// только для регл. учета
//
Процедура ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()
	
	мСтрокаРеквизитыБухУчета = "ПодразделениеОрганизации, НадписьПодразделениеОрганизации,
							   |Материалы.СуммаРегл, Получатели.ПодразделениеОрганизацииПолучатель";
	
	мСтрокаРеквизитыНалУчета = "";
	
КонецПроцедуры // ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчетаРегл()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	ОбязательныеРеквизитыШапки = "Организация, Подразделение, ПодразделениеОрганизации";
	
	УправлениеЗатратами.НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, ОбязательныеРеквизитыШапки, СтруктураШапкиДокумента, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета, мСтрокаРеквизитыНалУчета);
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, Новый Структура(ОбязательныеРеквизитыШапки), Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Процедура заполняет счета учета по бухгалтерскому и налоговому учету.
//
Процедура ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт

	ЗаполнитьСчетаУчетаВТабЧасти(СтрокаТЧ, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ);
	
КонецПроцедуры // ЗаполнитьСчетаУчетаВСтрокеТабЧастиРегл()

// Заполняет счета БУ и НУ в табличной части документа
//
Процедура ЗаполнитьСчетаУчетаВТабЧасти(ТабличнаяЧасть, ИмяТабЧасти, ЗаполнятьБУ, ЗаполнятьНУ) Экспорт
	
	СчетаУчетаВДокументах.ЗаполнитьСчетаУчетаТабличнойЧасти(ИмяТабЧасти, ТабличнаяЧасть, ЭтотОбъект, ЗаполнятьБУ, ЗаполнятьНУ);
	
КонецПроцедуры // ЗаполнитьСчетаУчетаВТабЧасти()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Функция проверяет правильность заполнения документа
// Возврат - структура с данными шапки документа
//
Функция ПроверкаРеквизитов(Отказ) Экспорт
	
	// Дерево значений, содержащее имена необходимых полей в запросе по шапке.
	Перем ДеревоПолейЗапросаПоШапке;
	
	ЗаполнитьСписокРеквизитовЗависимыхОтТиповУчета();
	
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	
	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);

	// Проверим правильность заполнения шапки документа
	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	
	РеквизитыТЧ = "Номенклатура, Количество, ЕдиницаИзмерения, ФизЛицо, ФизЛицоПолучатель, НазначениеИспользования, НазначениеИспользованияПолучатель, ТипСтоимости";
	
	УправлениеЗатратами.НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, РеквизитыТЧ, СтруктураШапкиДокумента, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета, мСтрокаРеквизитыНалУчета, "Материалы");
	
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Материалы", Новый Структура(РеквизитыТЧ), Отказ, Заголовок);
	УправлениеЗапасами.ПроверитьЧтоНетНаборов(ЭтотОбъект, "Материалы", , Отказ, Заголовок);

	РеквизитыТЧ = "ФизЛицоПолучатель, НазначениеИспользованияПолучатель,
		|ПодразделениеОрганизацииПолучатель, ПодразделениеПолучатель";
	УправлениеЗатратами.НепроверятьРеквизитыПоТипуУчета(ЭтотОбъект, РеквизитыТЧ, СтруктураШапкиДокумента, мСтрокаРеквизитыУпрУчета, мСтрокаРеквизитыБухУчета, мСтрокаРеквизитыНалУчета, "Получатели");
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Материалы", Новый Структура(РеквизитыТЧ), Отказ, Заголовок);
	
	// Проверим соответствие подразделения и организации.
	УправлениеЗатратами.ПроверитьПодразделениеОрганизации(ЭтотОбъект, Отказ, Заголовок);
	УправлениеЗатратами.ПроверитьПодразделениеОрганизацииВСтрокахТабЧасти(ЭтотОбъект, Материалы, "Материалы", "ПодразделениеОрганизацииПолучатель", Отказ, Заголовок);
	
	Для Каждого СтрокаТЧ Из Материалы Цикл
		Если СтрокаТЧ.ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная Тогда
			Если ОтражатьВУправленческомУчете И НЕ ЗначениеЗаполнено(СтрокаТЧ.Сумма) Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Не указана сумма. (Строка № " + СтрокаТЧ.НомерСтроки + ")", Отказ, Заголовок);
			КонецЕсли;
			Если ОтражатьВБухгалтерскомУчете И НЕ ЗначениеЗаполнено(СтрокаТЧ.СуммаРегл) Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Не указана сумма регл. (Строка № " + СтрокаТЧ.НомерСтроки + ")", Отказ, Заголовок);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураШапкиДокумента;
	
КонецФункции // ПроверкаРеквизитов()

// Дополняет полями, нужными для регл. учета
//
Процедура ДополнитьСтруктуруПолейТабличнойЧастиМатериалыРегл(СтруктураПолей)
	
	Если Не ОтражатьВБухгалтерскомУчете Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПолей.Вставить( "СчетУчетаБУ", "СчетУчетаБУ");
	СтруктураПолей.Вставить( "СчетУчетаНУ", "СчетУчетаНУ");
	СтруктураПолей.Вставить( "СчетУчетаПолучательБУ", "СчетУчетаПолучательБУ");
	СтруктураПолей.Вставить( "СчетУчетаПолучательНУ", "СчетУчетаПолучательНУ");

КонецПроцедуры // ДополнитьСтруктуруПолейТабличнойЧастиМатериалыРегл()

// Выгружает результат запроса в табличную часть, добавляет ей необходимые колонки для проведения.
//
// Параметры: 
//  РезультатЗапросаПоТоварам - результат запроса по табличной части "Товары",
//  СтруктураШапкиДокумента   - выборка по результату запроса по шапке документа.
//
// Возвращаемое значение:
//  Сформированная таблица значений.
//
Функция ПодготовитьТаблицуМатериалов(РезультатЗапросаПоМатериалам, СтруктураШапкиДокумента)

	ТаблицаМатериалов = РезультатЗапросаПоМатериалам.Выгрузить();
	
	Возврат ТаблицаМатериалов;

КонецФункции // ПодготовитьТаблицуМатериалов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ФОРМИРОВАНИЯ ДВИЖЕНИЙ ДОКУМЕНТА

// По результату запроса по шапке документа формируем движения по регистрам.
//
// Параметры: 
//  РежимПроведения           - режим проведения документа (оперативный или неоперативный),
//  СтруктураШапкиДокумента   - выборка из результата запроса по шапке документа,
//  ТаблицаПоТоварам          - таблица значений, содержащая данные для проведения и проверки ТЧ Товары
//  ТаблицаПоТаре             - таблица значений, содержащая данные для проведения и проверки ТЧ "Возвратная тара",
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок)
	
	ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок);
	ДвиженияПоРегистрамРегл(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок);
	
	ДвиженияПоРегиструСписанныеМатериалыИзЭксплуатации(СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок);
	
КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ЗаполнитьКолонкиРегистраСписанныеМатериалыИзЭксплуатацииУпр(ТаблицаДвижений, СтруктураШапкиДокумента, ТаблицаПоМатериалам)

	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Подразделение, "Подразделение");
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ОтражатьВУправленческомУчете, "ОтражатьВУправленческомУчете");
	
КонецПроцедуры // ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамУпр()

Процедура ЗаполнитьКолонкиРегистраСписанныеМатериалыИзЭксплуатацииРегл(ТаблицаДвижений, СтруктураШапкиДокумента, ТаблицаПоМатериалам)

	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете, "ОтражатьВБухгалтерскомУчете");
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ОтражатьВНалоговомУчете,	   "ОтражатьВНалоговомУчете");
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.Организация,                 "Организация");
	ТаблицаДвижений.ЗаполнитьЗначения(СтруктураШапкиДокумента.ПодразделениеОрганизации,    "ПодразделениеОрганизации");
	
КонецПроцедуры // ЗаполнитьКолонкиРегистраСписанныеТоварыПоТоварамРегл()

// Формирование движений по регистру СписанныеМатериалыИзЭксплуатации.
//
Процедура ДвиженияПоРегиструСписанныеМатериалыИзЭксплуатации(СтруктураШапкиДокумента, ИсходнаяТаблицаМатериалов, Отказ, Заголовок)
	
	ТаблицаПоМатериалам = ИсходнаяТаблицаМатериалов.Скопировать();
	
	СтруктураПоиска = Новый Структура("ВестиПартионныйУчетПоСериям", Ложь);
	МассивСтрок = ТаблицаПоМатериалам.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаТаблицы Из МассивСтрок Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.СерияНоменклатуры) Тогда
			СтрокаТаблицы.СерияНоменклатуры = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	// МАТЕРИАЛЫ ПО РЕГИСТРУ СписанныеМатериалыИзЭксплуатации.
	НаборДвижений = Движения.СписанныеМатериалыИзЭксплуатации;

	// Получим таблицу значений, совпадающую со структурой набора записей регистра.
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();

	// Заполним таблицу движений.
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоМатериалам, ТаблицаДвижений);
	
	// Недостающие поля.
	Инд = 0;
	Для каждого Строка Из ТаблицаДвижений Цикл
		Инд = Инд+1;
		Строка.НомерСтрокиДокумента = Инд;
	КонецЦикла;
	
	ТаблицаДвижений.ЗаполнитьЗначения(Дата,   "Период");
	ТаблицаДвижений.ЗаполнитьЗначения(Ссылка, "Регистратор");
	ТаблицаДвижений.ЗаполнитьЗначения(Истина, "Активность");
	
	ТаблицаДвижений.ЗаполнитьЗначения(Перечисления.КодыОперацийПартииМатериаловВЭксплуатации.ПеремещениеВЭксплуатации, "КодОперации");
    	
	ЗаполнитьКолонкиРегистраСписанныеМатериалыИзЭксплуатацииУпр(ТаблицаДвижений, СтруктураШапкиДокумента, ТаблицаПоМатериалам);
	ЗаполнитьКолонкиРегистраСписанныеМатериалыИзЭксплуатацииРегл(ТаблицаДвижений, СтруктураШапкиДокумента, ТаблицаПоМатериалам);
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.СписанныеМатериалыИзЭксплуатации.ВыполнитьДвижения();
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегиструСписанныеМатериалыИзЭксплуатации()

// Формирование движений по регистрам по управленческому учету.
//
Процедура ДвиженияПоРегистрамУпр(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок)
	
	Если Не СтруктураШапкиДокумента.ОтражатьВУправленческомУчете Тогда
		Возврат;
	КонецЕсли;
	
	// ТОВАРЫ ПО РЕГИСТРУ МатериалыВПроизводстве.
	НаборДвижений = Движения.МатериалыВЭксплуатации;
	
	// Проверка остатков при оперативном проведении.
	НаборДвижений.КонтрольОстатков(ЭтотОбъект, "Материалы", СтруктураШапкиДокумента, Отказ, Заголовок, РежимПроведения);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоМатериалам, ТаблицаДвижений);
	ТаблицаДвижений.ЗаполнитьЗначения( Подразделение, "Подразделение");
	ТаблицаДвижений.ЗаполнитьЗначения( Перечисления.КодыОперацийМатериалыВЭксплуатации.ПеремещениеВЭксплуатации, "КодОперации");
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.МатериалыВЭксплуатации.ВыполнитьРасход();
	КонецЕсли;
	
	ТаблицаДвижений.Очистить();
	
	ТабМат = ТаблицаПоМатериалам.Скопировать();
	ТабМат.Колонки["ПодразделениеПолучатель"].Имя = "Подразделение";
	ТабМат.Колонки.Удалить("ФизЛицо");
	ТабМат.Колонки["ФизЛицоПолучатель"].Имя = "ФизЛицо";
	ТабМат.Колонки.Удалить("НазначениеИспользования");
	ТабМат.Колонки["НазначениеИспользованияПолучатель"].Имя = "НазначениеИспользования";
	
	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТабМат, ТаблицаДвижений);
	ТаблицаДвижений.ЗаполнитьЗначения( Перечисления.КодыОперацийМатериалыВЭксплуатации.СписаниеПартийВЭксплуатацию, "КодОперации");
	
	НаборДвижений.мПериод          = Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;

	Если Не Отказ Тогда
		Движения.МатериалыВЭксплуатации.Записать();
		Движения.МатериалыВЭксплуатации.ВыполнитьПриход();
		Движения.МатериалыВЭксплуатации.Записать(Ложь);
	КонецЕсли;
	
КонецПроцедуры // ДвиженияПоРегистрамУпр()

// Формирование движений по регистрам по регламентированному учету.
//
Процедура ДвиженияПоРегистрамРегл(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок)
	
	Если Не СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		Возврат;
	КонецЕсли;
	
	Если УправлениеЗапасами.ИспользуетсяРасширеннаяАналитикаУчета(СтруктураШапкиДокумента.Дата) Тогда
		// При использовании РА проводки будут сформированы в модуле УправлениеЗапасамиРасширеннаяАналитика
		Возврат;
	КонецЕсли;
	
	// Формирование проводок.
	Операция = Движения.Хозрасчетный;
	ПроводкиНУ = Движения.Налоговый;
	
	Для Каждого СтрокаТЧ Из ТаблицаПоМатериалам Цикл
		
		ФиксированнаяСтоимость = СтрокаТЧ.ТипСтоимости = Перечисления.ВидыНормативнойСтоимостиПроизводства.Фиксированная;
		СодержаниеПроводки = "Перемещение материалов в эксплуатации";
		
		Если СтрокаТЧ.СчетУчетаБУ <> СтрокаТЧ.СчетУчетаПолучательБУ Тогда
		
			Проводка = Операция.Добавить();
			Проводка.Организация = СтруктураШапкиДокумента.Организация;
			Проводка.Период = СтруктураШапкиДокумента.Дата;
			Проводка.СчетДт = СтрокаТЧ.СчетУчетаПолучательБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, "Номенклатура", СтрокаТЧ.Номенклатура);
			
			Проводка.СчетКт = СтрокаТЧ.СчетУчетаБУ;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Номенклатура", СтрокаТЧ.Номенклатура);
				
			Если ФиксированнаяСтоимость Тогда
				Проводка.Сумма  = СтрокаТЧ.СтоимостьРегл;
			КонецЕсли;
			
			Проводка.КоличествоДт = БухгалтерскийУчет.КоличествоВПроводку(Проводка.СчетДт, СтрокаТЧ.Количество);
			Проводка.КоличествоКт = БухгалтерскийУчет.КоличествоВПроводку(Проводка.СчетКт, СтрокаТЧ.Количество);
			Проводка.Содержание   = СодержаниеПроводки;
			Проводка.НомерЖурнала = "";
			
		КонецЕсли;

		Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете И СтрокаТЧ.СчетУчетаНУ <> СтрокаТЧ.СчетУчетаПолучательНУ Тогда
			
			ПроводкаНУ = ПроводкиНУ.Добавить();
			ПроводкаНУ.Организация = СтруктураШапкиДокумента.Организация;
			ПроводкаНУ.Период = СтруктураШапкиДокумента.Дата;
			ПроводкаНУ.СчетДт = СтрокаТЧ.СчетУчетаПолучательНУ;
			БухгалтерскийУчет.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, "Номенклатура", СтрокаТЧ.Номенклатура);
			
			ПроводкаНУ.СчетКт = СтрокаТЧ.СчетУчетаНУ;
			БухгалтерскийУчет.УстановитьСубконто( ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, "Номенклатура", СтрокаТЧ.Номенклатура);
			
			ПроводкаНУ.КоличествоДт = БухгалтерскийУчет.КоличествоВПроводку(ПроводкаНУ.СчетДт, СтрокаТЧ.Количество);
			ПроводкаНУ.КоличествоКт = БухгалтерскийУчет.КоличествоВПроводку(ПроводкаНУ.СчетКт, СтрокаТЧ.Количество);
			ПроводкаНУ.Содержание   = СодержаниеПроводки;
			ПроводкаНУ.НомерЖурнала = "";
			
			Если ФиксированнаяСтоимость И СтрокаТЧ.СтоимостьРегл <> 0 Тогда
				
				ПроводкаНУ = ПроводкиНУ.Добавить();
				ПроводкаНУ.Организация = СтруктураШапкиДокумента.Организация;
				ПроводкаНУ.Период = СтруктураШапкиДокумента.Дата;
				ПроводкаНУ.СчетДт = СтрокаТЧ.СчетУчетаПолучательНУ;
				БухгалтерскийУчет.УстановитьСубконто(ПроводкаНУ.СчетДт, ПроводкаНУ.СубконтоДт, "Номенклатура", СтрокаТЧ.Номенклатура);
				
				ПроводкаНУ.СчетКт = СтрокаТЧ.СчетУчетаНУ;
				БухгалтерскийУчет.УстановитьСубконто(ПроводкаНУ.СчетКт, ПроводкаНУ.СубконтоКт, "Номенклатура", СтрокаТЧ.Номенклатура);
				
				ПроводкаНУ.Сумма = СтрокаТЧ.СтоимостьРегл;
				
				ПроводкаНУ.ВидУчетаДт = Перечисления.ВидыУчетаПоПБУ18.ВР;
				ПроводкаНУ.ВидУчетаКт = Перечисления.ВидыУчетаПоПБУ18.ВР;
				
				ПроводкаНУ.Содержание   = СодержаниеПроводки;
				ПроводкаНУ.НомерЖурнала = "";
				
			КонецЕсли;

		КонецЕсли;
			
	КонецЦикла;
		
	Операция.Записать();
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда
		ПроводкиНУ.Записать();
	КонецЕсли;
		
КонецПроцедуры // ДвиженияПоРегистрамРегл()

//////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события ОбработкаПроведения
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	СтруктураШапкиДокумента = ПроверкаРеквизитов(Отказ);
	
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	
	// Подготовим таблицу материалов для проведения.
	СтруктураПолей = Новый Структура();
	СтруктураПолей.Вставить( "Номенклатура", "Номенклатура");
	СтруктураПолей.Вставить( "Услуга",       "Номенклатура.Услуга");
	СтруктураПолей.Вставить( "Набор",        "Номенклатура.Набор");
	СтруктураПолей.Вставить( "ВестиПартионныйУчетПоСериям", "Номенклатура.ВестиПартионныйУчетПоСериям");
	СтруктураПолей.Вставить( "Количество",   "Количество * Коэффициент /Номенклатура.ЕдиницаХраненияОстатков.Коэффициент");
	
	СтруктураПолей.Вставить( "ХарактеристикаНоменклатуры", "ХарактеристикаНоменклатуры");
	СтруктураПолей.Вставить( "СерияНоменклатуры",          "СерияНоменклатуры");
	
	СтруктураПолей.Вставить( "ФизЛицо",                    "ФизЛицо");
	СтруктураПолей.Вставить( "НазначениеИспользования",    "НазначениеИспользования");
	
	СтруктураПолей.Вставить( "ТипСтоимости",  "ТипСтоимости");
	СтруктураПолей.Вставить( "Стоимость",     "Сумма");
	СтруктураПолей.Вставить( "СтоимостьРегл", "СуммаРегл");
	
	СтруктураПолей.Вставить( "ФизЛицоПолучатель",                  "ФизЛицоПолучатель");
	СтруктураПолей.Вставить( "НазначениеИспользованияПолучатель",  "НазначениеИспользованияПолучатель");
	СтруктураПолей.Вставить( "ПодразделениеПолучатель",            "ПодразделениеПолучатель");
	СтруктураПолей.Вставить( "ПодразделениеОрганизацииПолучатель", "ПодразделениеОрганизацииПолучатель");
	
	СтруктураПолей.Вставить( "ДокументПередачи", "ДокументПередачи");
	
	ДополнитьСтруктуруПолейТабличнойЧастиМатериалыРегл(СтруктураПолей);
	
	РезультатЗапросаПоМатериалам = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "Материалы", СтруктураПолей);
	ТаблицаПоМатериалам = ПодготовитьТаблицуМатериалов(РезультатЗапросаПоМатериалам, СтруктураШапкиДокумента);
	
	//Заполнение и проверка заполнения счетов учета номенклатуры и затрат
	СчетаУчетаВДокументах.ЗаполнитьИПроверитьЗаполнениеСчетовУчетаТабличнойЧасти("Материалы", ТаблицаПоМатериалам, 	СтруктураШапкиДокумента, Отказ, Заголовок);
	
	// Движения по документу.
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(РежимПроведения, СтруктураШапкиДокумента, ТаблицаПоМатериалам, Отказ, Заголовок);
	КонецЕсли;
	
	//Сделаем переменные доступными из подписок на события
	ДополнительныеСвойства.Вставить("СтруктураШапкиДокумента", СтруктураШапкиДокумента);
	ДополнительныеСвойства.Вставить("СтруктураТабличныхЧастей", Новый Структура("ТаблицаПоМатериалам", ТаблицаПоМатериалам));
	
КонецПроцедуры	// ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаЗаполнения(Основание)
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ПередачаМатериаловВЭксплуатацию") Тогда
		
		Организация                  = Основание.Организация;
		ОтражатьВБухгалтерскомУчете  = Основание.ОтражатьВБухгалтерскомУчете;
		ОтражатьВНалоговомУчете      = Основание.ОтражатьВНалоговомУчете;
		ОтражатьВУправленческомУчете = Основание.ОтражатьВУправленческомУчете;
		Подразделение                = Основание.Подразделение;
		ПодразделениеОрганизации     = Основание.ПодразделениеОрганизации;
		
		Ответственный                = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный");
		
		Для Каждого ТекСтрокаМатериалы Из Основание.Материалы Цикл
			
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.Номенклатура               = ТекСтрокаМатериалы.Номенклатура;
			НоваяСтрока.ХарактеристикаНоменклатуры = ТекСтрокаМатериалы.ХарактеристикаНоменклатуры;
			НоваяСтрока.СерияНоменклатуры          = ТекСтрокаМатериалы.СерияНоменклатуры;
			
			НоваяСтрока.Количество                 = ТекСтрокаМатериалы.Количество;
			НоваяСтрока.КоличествоМест             = ТекСтрокаМатериалы.КоличествоМест;
			
			НоваяСтрока.ЕдиницаИзмерения           = ТекСтрокаМатериалы.ЕдиницаИзмерения;
			НоваяСтрока.ЕдиницаИзмеренияМест       = ТекСтрокаМатериалы.ЕдиницаИзмеренияМест;
			НоваяСтрока.Коэффициент                = ТекСтрокаМатериалы.Коэффициент;
			
			НоваяСтрока.ФизЛицо                    = ТекСтрокаМатериалы.ФизЛицо;
			НоваяСтрока.НазначениеИспользования    = ТекСтрокаМатериалы.НазначениеИспользования;
			НоваяСтрока.ОтражениеВУСН              = ТекСтрокаМатериалы.ОтражениеВУСН;
			НоваяСтрока.ТипСтоимости               = Перечисления.ВидыНормативнойСтоимостиПроизводства.Рассчитывается;
			
			НоваяСтрока.СчетУчетаБУ                = ТекСтрокаМатериалы.СчетПередачиБУ;
			НоваяСтрока.СчетУчетаНУ                = ТекСтрокаМатериалы.СчетПередачиНУ;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры


мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
мВалютаУправленческогоУчета = глЗначениеПеременной("ВалютаУправленческогоУчета");

