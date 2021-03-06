////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

// Формирует запрос по документу
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросДляПечати(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	Если Режим = "ПоТабличнойЧастиДокумента" Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	АттестацияРаботникаСписокКомпетенций.НомерСтроки КАК НомерСтроки,
		|	АттестацияРаботникаСписокКомпетенций.Компетенция.Наименование КАК Компетенция,
		|	АттестацияРаботникаСписокКомпетенций.Компетенция.ШкалаОценок.Наименование КАК Шкала,
		|	СоставОценочныхШкалКомпетенций.ПриоритетОценки КАК ПриоритетОценки,
		|	СоставОценочныхШкалКомпетенций.Наименование КАК Оценка,
		|	СоставОценочныхШкалКомпетенций.Ссылка КАК СсылкаОценки
		|ИЗ
		|	Документ.АттестацияРаботника.СписокКомпетенций КАК АттестацияРаботникаСписокКомпетенций
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоставОценочныхШкалКомпетенций КАК СоставОценочныхШкалКомпетенций
		|		ПО АттестацияРаботникаСписокКомпетенций.Компетенция.ШкалаОценок = СоставОценочныхШкалКомпетенций.Владелец
		|ГДЕ
		|	АттестацияРаботникаСписокКомпетенций.Ссылка = &ДокументСсылка
		|	И АттестацияРаботникаСписокКомпетенций.Компетенция <> ЗНАЧЕНИЕ(Справочник.КомпетенцииРаботников.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки,
		|	ПриоритетОценки УБЫВ";

	Иначе
		Возврат Неопределено;
		
	КонецЕсли;

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросДляПечати()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	// Получить экземпляр документа на печать
	Если      ИмяМакета = "ОценочныйЛист" Тогда
		
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Аттестация_Работника";
		Макет = ПолучитьМакет("Макет");
		
		ВыборкаКомпетенций = СформироватьЗапросДляПечати("ПоТабличнойЧастиДокумента").Выбрать();
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Работник 	  = ФизЛицо;
		ОбластьМакета.Параметры.Ответственный = Ответственный;
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакетаКомпетенция = Макет.ПолучитьОбласть("Компетенция");
		ОбластьМакетаОценка = Макет.ПолучитьОбласть("Оценка");
		ОбластьМакетаОтбивка = Макет.ПолучитьОбласть("Отбивка");
		
		Пока ВыборкаКомпетенций.СледующийПоЗначениюПоля("НомерСтроки") Цикл
			
			ОбластьМакетаКомпетенция.Параметры.Заполнить(ВыборкаКомпетенций);
			ТабДокумент.Вывести(ОбластьМакетаКомпетенция);
			
			Пока ВыборкаКомпетенций.СледующийПоЗначениюПоля("СсылкаОценки") Цикл
				ОбластьМакетаОценка.Параметры.Заполнить(ВыборкаКомпетенций);
				ТабДокумент.Вывести(ОбластьМакетаОценка);
			КонецЦикла;
			
			// Вывод отбивки
			ТабДокумент.Вывести(ОбластьМакетаОтбивка);
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Конец");
		ТабДокумент.Вывести(ОбластьМакета);
		
		Возврат УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначенияЗК.СформироватьЗаголовокДокумента(ЭтотОбъект,"Оценочный лист"));
		
	КонецЕсли;

КонецФункции // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ОценочныйЛист","Оценочный лист");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	АттестацияРаботника.Сотрудник,
	|	АттестацияРаботника.Дата,
	|	АттестацияРаботника.Ссылка,
	|	АттестацияРаботника.Физлицо КАК Физлицо
	|ИЗ
	|	Документ.АттестацияРаботника КАК АттестацияРаботника
	|ГДЕ
	|	АттестацияРаботника.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "СписокКомпетенций" документа
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоОценкам()
	

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	Ссылка);
	Запрос.УстановитьПараметр("Работник",		Сотрудник.ФизЛицо);

	
		// Описание текста запроса:
		// 1. Выборка "ПерваяТаблица": 
		//      Выбираются строки документа
		// 2. Выборка "ВтораяТаблица": 
		//		Среди записей регистра "ОценкиКомпетенцийРаботников" ищем записи с совподающими  
		//      датами оценки и компетенций
		//
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПерваяТаблица.НомерСтроки,
		|	ПерваяТаблица.Компетенция,
		|	ПерваяТаблица.Оценка,
		|	ПерваяТаблица.ДатаОценки,
		|	ВложенныйЗапрос.НомерСтроки КАК КонфликтнаяСтрока,
		|	ВтораяТаблица.Регистратор КАК ДокументСуществующейОценки
		|ИЗ
		|	Документ.АттестацияРаботника.СписокКомпетенций КАК ПерваяТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			Регистр.Компетенция КАК Компетенция,
		|			Регистр.Период КАК Период,
		|			Регистр.Регистратор КАК Регистратор
		|		ИЗ
		|			РегистрСведений.ОценкиКомпетенцийРаботников КАК Регистр
		|		ГДЕ
		|			Регистр.ФизЛицо = &Работник) КАК ВтораяТаблица
		|		ПО ПерваяТаблица.Компетенция = ВтораяТаблица.Компетенция
		|			И ПерваяТаблица.ДатаОценки = ВтораяТаблица.Период
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			АттестацияРаботникаСписокКомпетенций.Компетенция КАК Компетенция,
		|			АттестацияРаботникаСписокКомпетенций.НомерСтроки КАК НомерСтроки
		|		ИЗ
		|			Документ.АттестацияРаботника.СписокКомпетенций КАК АттестацияРаботникаСписокКомпетенций
		|		ГДЕ
		|			АттестацияРаботникаСписокКомпетенций.Ссылка = &ДокументСсылка) КАК ВложенныйЗапрос
		|		ПО ПерваяТаблица.Компетенция = ВложенныйЗапрос.Компетенция
		|			И ПерваяТаблица.НомерСтроки > ВложенныйЗапрос.НомерСтроки
		|ГДЕ
		|	ПерваяТаблица.Ссылка = &ДокументСсылка";
				
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоОценкам()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ФизЛицо) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Работники" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса по работникам, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиОценки(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Список оцениваемых компетенций"": ";
	
	// Компетенция
	ЕстьКомпетенция = ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Компетенция);
	Если Не ЕстьКомпетенция Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана компетенция!", Отказ, Заголовок);
	КонецЕсли;

	// ДатаНачала
	ЕстьОценка = ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Оценка);
	Если Не ЕстьОценка Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрана оценка!", Отказ, Заголовок);
	КонецЕсли;

	// ДатаОкончания
	ЕстьДатаОценки = ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаОценки);
	Если Не ЕстьДатаОценки Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата оценки!", Отказ, Заголовок);
	КонецЕсли;

	Если ЕстьКомпетенция и ЕстьОценка и ЕстьДатаОценки Тогда
		
		Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока <> Null  Тогда
			СтрокаПродолжениеСообщенияОбОшибке = " компетенция не может быть указана в документе дважды (см. строку "  + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрока + " )!";
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаПродолжениеСообщенияОбОшибке, Отказ, Заголовок);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеСтрокиОценки()

// Создает и заполняет структуру, содержащую имена регистров сведений 
//  по которым надо проводить документ
//
// Параметры: 
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров сведений 
//                                           по которым надо проводить документ
//
// Возвращаемое значение:
//  Нет.
//
Процедура ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений)

	СтруктураПроведенияПоРегистрамСведений = Новый Структура();
	СтруктураПроведенияПоРегистрамСведений.Вставить("ОценкиКомпетенцийРаботников");
	
КонецПроцедуры // ЗаполнитьСтруктуруПроведенияПоРегистрамСведений

// По строке выборки результата запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоШапкеДокумента                - выборка из результата запроса по шапке документа,
//  СтруктураПроведенияПоРегистрамСведений - структура, содержащая имена регистров 
//                                           сведений по которым надо проводить документ,
//  СтруктураПараметров                    - структура параметров проведения,
//
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоОценкам,  
	СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")
	
	ИмяРегистра = "ОценкиКомпетенцийРаботников";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда
		
		// отразим начало
		Движение = Движения[ИмяРегистра].Добавить();
		
		// Свойства
		Движение.Период			= ВыборкаПоОценкам.ДатаОценки;
		
		// Измерения
		Движение.ФизЛицо		= ВыборкаПоШапкеДокумента.Физлицо;
		Движение.Компетенция	= ВыборкаПоОценкам.Компетенция;
		
		// Ресурсы
		Движение.Оценка			= ВыборкаПоОценкам.Оценка;
		
		
	КонецЕсли; 
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров накопления по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);	

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке();

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ = ложь)
		Если НЕ Отказ Тогда

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);

			// получим реквизиты табличной части
			РезультатЗапросаПоОценкам = СформироватьЗапросПоОценкам();
			
			ВыборкаПоОценкам = РезультатЗапросаПоОценкам.Выбрать();
				
			Пока ВыборкаПоОценкам.Следующий() Цикл

				ПроверитьЗаполнениеСтрокиОценки(ВыборкаПоШапкеДокумента, ВыборкаПоОценкам, Отказ, Заголовок);
				Если НЕ Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоОценкам, СтруктураПроведенияПоРегистрамСведений);
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры
