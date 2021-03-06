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

Функция ОпределитьКорректностьСсылки(ПроверяемаяСсылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПроверяемаяСсылка) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1 ИСТИНА ИЗ";
	ИмяМетаданные = ПроверяемаяСсылка.Метаданные().Имя;
	ТипЗначения = ТипЗнч(ПроверяемаяСсылка);
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	Справочник.";
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	Документ.";
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	ПланВидовХарактеристик.";
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	ПланСчетов.";
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
		Запрос.Текст = Запрос.Текст + "
		|	Перечисление.";
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + ИмяМетаданные + "
	| ГДЕ Ссылка = &ПроверяемаяСсылка";
	Запрос.УстановитьПараметр("ПроверяемаяСсылка", ПроверяемаяСсылка);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Процедура ПроверитьСуществованиеОбъектов(ТекСтрока, Отказ)

	Колонки = Новый Структура("СчетХозрасчетный, СубконтоХозр1, СубконтоХозр2, СубконтоХозр3, СчетМеждународный, СубконтоМежд1, СубконтоМежд2, СубконтоМежд3"
							  , "Счет хозрасчетный: "
							  , "Субконто хозр. 1: "
							  , "Субконто хозр. 2: "
							  , "Субконто хозр. 3: "
							  , "Счет международный: "
							  , "Субконто межд. 1: "
							  , "Субконто межд. 2: "
							  , "Субконто межд. 3: ");
	СтрокаСообщения = "";
	СтрокаОшибки    = "";
	ЕстьОшибки      = Ложь;
	Для каждого Колонка Из Колонки Цикл
		Если ЗначениеЗаполнено(ТекСтрока[Колонка.Ключ])
			И (НЕ Перечисления.ТипВсеСсылки().СодержитТип(ТипЗнч(ТекСтрока[Колонка.Ключ]))
//			    И ТекСтрока[Колонка.Ключ].ПолучитьОбъект() = Неопределено) Тогда
				И НЕ ОпределитьКорректностьСсылки(ТекСтрока[Колонка.Ключ])) Тогда
				СтрокаОшибки = СтрокаОшибки + "
				|Для колонки """ + Колонка.Значение + """ установлено некорректное значение";
				ЕстьОшибки = Истина;
		Иначе
			СтрокаСообщения = СтрокаСообщения + "
			|" + Колонка.Значение + ?(ЗначениеЗаполнено(ТекСтрока[Колонка.Ключ]), ТекСтрока[Колонка.Ключ], "Не заполнено");
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		СтрокаСообщения = "В строке "+ТекСтрока.НомерСтроки+" " + СтрокаОшибки + "
		|" + СтрокаСообщения + "
		|Необходимо установить соответствие вручную.";
		Сообщить(СтрокаСообщения, СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСуществованиеОбъектовДляИсключения(ТекСтрока, Отказ)

	Колонки = Новый Структура("СчетДт, СубконтоДт1, СубконтоДт2, СубконтоДт3, СчетКт, СубконтоКт1, СубконтоКт2, СубконтоКт3"
							  , "Счет Дт"
							  , "Субконто Дт 1"
							  , "Субконто Дт 2"
							  , "Субконто Дт 3"
							  , "Счет Кт"
							  , "Субконто Кт 1"
							  , "Субконто Кт 2"
							  , "Субконто Кт 3");
	СтрокаСообщения = "";
	СтрокаОшибки    = "";
	ЕстьОшибки      = Ложь;
	
	Для каждого Колонка Из Колонки Цикл
		
		Если ЗначениеЗаполнено(ТекСтрока[Колонка.Ключ])
//			И ТекСтрока[Колонка.Ключ].ПолучитьОбъект() = Неопределено Тогда
			И НЕ ОпределитьКорректностьСсылки(ТекСтрока[Колонка.Ключ]) Тогда
			СтрокаОшибки = СтрокаОшибки + "
			|Для колонки """ + Колонка.Значение + """ установлено некорректное значение";
			ЕстьОшибки = Истина;
		Иначе
			СтрокаСообщения = СтрокаСообщения + "
			|" + Колонка.Значение + ?(ЗначениеЗаполнено(ТекСтрока[Колонка.Ключ]), ТекСтрока[Колонка.Ключ], "Не заполнено");
		КонецЕсли;
	
	КонецЦикла;
	
	Если ЕстьОшибки Тогда
		СтрокаСообщения = "В строке "+ТекСтрока.НомерСтроки+" " + СтрокаОшибки + "
		|" + СтрокаСообщения + "
		|Необходимо установить соответствие вручную.";
		Сообщить(СтрокаСообщения, СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Для Каждого ТекСтрокаСоответствиеСчетовБУиМСФО Из СоответствиеСчетовБУиМСФО Цикл
		Приоритет = Перечисления.ПриоритетПравилПереносаСчетов.Низкий;
		
		Если (ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоХозр1)) или (ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоХозр2)) или (ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоХозр3)) Тогда
			Приоритет = Перечисления.ПриоритетПравилПереносаСчетов.Высокий;
		ИначеЕсли ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиМСФО.Значение) Тогда
			Приоритет = Перечисления.ПриоритетПравилПереносаСчетов.Средний;
		КонецЕсли;
		
		ПроверитьСуществованиеОбъектов(ТекСтрокаСоответствиеСчетовБУиМСФО, Отказ);
		
		Движение = Движения.СоответствиеСчетовБУиМСФО.Добавить();
		Движение.Период                = Дата;
		Движение.СчетХозрасчетный      = ТекСтрокаСоответствиеСчетовБУиМСФО.СчетХозрасчетный;
		Движение.ВидДвижения           = ТекСтрокаСоответствиеСчетовБУиМСФО.ВидДвижения;
		Движение.СубконтоХозр1         = ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоХозр1;
		Движение.СубконтоХозр2         = ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоХозр2;
		Движение.СубконтоХозр3         = ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоХозр3;
		Движение.Реквизит              = ТекСтрокаСоответствиеСчетовБУиМСФО.Реквизит;
		Движение.Значение              = ТекСтрокаСоответствиеСчетовБУиМСФО.Значение;
		Движение.СчетМеждународный     = ТекСтрокаСоответствиеСчетовБУиМСФО.СчетМеждународный;
		Движение.СубконтоМежд1         = ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоМежд1;
		Движение.СубконтоМежд2         = ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоМежд2;
		Движение.СубконтоМежд3         = ТекСтрокаСоответствиеСчетовБУиМСФО.СубконтоМежд3;
		Движение.Учитывается           = ТекСтрокаСоответствиеСчетовБУиМСФО.Учитывается;
		Движение.Комментарий           = ТекСтрокаСоответствиеСчетовБУиМСФО.Комментарий;
		Движение.РеквизитПредставление = ТекСтрокаСоответствиеСчетовБУиМСФО.РеквизитПредставление;
		Движение.Приоритет             = Приоритет;
	КонецЦикла;
	
	Для Каждого ТекИсключениеПроводок Из ИсключениеПроводок Цикл
		
		ПроверитьСуществованиеОбъектовДляИсключения(ТекИсключениеПроводок, Отказ);
		
		Движение = Движения.ИсключениеПроводок.Добавить();
		Движение.Период      = Дата;
		Движение.СчетДт      = ТекИсключениеПроводок.СчетДт;
		Движение.СубконтоДт1 = ТекИсключениеПроводок.СубконтоДт1;
		Движение.СубконтоДт2 = ТекИсключениеПроводок.СубконтоДт2;
		Движение.СубконтоДт3 = ТекИсключениеПроводок.СубконтоДт3;
		Движение.СчетКт      = ТекИсключениеПроводок.СчетКт;
		Движение.СубконтоКт1 = ТекИсключениеПроводок.СубконтоКт1;
		Движение.СубконтоКт2 = ТекИсключениеПроводок.СубконтоКт2;
		Движение.СубконтоКт3 = ТекИсключениеПроводок.СубконтоКт3;
		Движение.Учитывается = ТекИсключениеПроводок.Учитывается;
		Движение.Комментарий = ТекИсключениеПроводок.Комментарий;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью






