////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Формирует запрос по шапке документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоШапке(Режим)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаОбучение.Дата,
	|	ЗаявкаНаОбучение.ДатаЗавершенияКурса КАК ДатаЗавершенияКурса,
	|	ЗаявкаНаОбучение.КурсОбучения КАК Курс,
	|	ЗаявкаНаОбучение.Ссылка
	|ИЗ
	|	Документ.ЗаявкаНаОбучение КАК ЗаявкаНаОбучение
	|ГДЕ
	|	ЗаявкаНаОбучение.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по всем местам работы физлица во всех организациях
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса
//
Функция СформироватьЗапросПоСпискуРаботников(ВыборкаПоШапкеДокумента,Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Сотрудник,
	|	Док.НомерСтроки КАК НомерСтроки,
	|	МИНИМУМ(ПересекающиесяСтроки.НомерСтроки) КАК КонфликтнаяСтрокаНомер
	|ИЗ
	|	Документ.ЗаявкаНаОбучение.ОбучающиесяРаботники КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОбучение.ОбучающиесяРаботники КАК ПересекающиесяСтроки
	|		ПО Док.Ссылка = ПересекающиесяСтроки.Ссылка
	|			И Док.НомерСтроки < ПересекающиесяСтроки.НомерСтроки
	|			И Док.Сотрудник.Физлицо = ПересекающиесяСтроки.Сотрудник.Физлицо
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Док.НомерСтроки,
	|	Док.Сотрудник";

	Возврат Запрос.Выполнить();
	
КонецФункции // СформироватьЗапросПоСпискуКурсов()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок)
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаЗавершенияКурса) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана дата окончания обучения!", Отказ, Заголовок);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Курс) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан курс обучения!", Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса по строкам. 
//  Отказ        - флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиТабличнойЧасти(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Обучающиеся сотрудники"": ";
	
	// Сотрудник
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Сотрудник) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбран сотрудник!", Отказ, Заголовок);
	КонецЕсли;
	
	// Проверка: противоречие другой строке документа
	Если ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер <> NULL Тогда
		СтрокаСообщениеОбОшибке = "Сотрудник не может быть указан в документе дважды (см. строку " + ВыборкаПоСтрокамДокумента.КонфликтнаяСтрокаНомер + ")!"; 
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаСообщениеОбОшибке, Отказ, Заголовок);
	КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиТабличнойЧасти()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров накопления по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамНакопления;

	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);	

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();
	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// ТЧ стоит проверять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда
			
			// Проверка строк.
			РезультатЗапросаПоСтрокамТЧ = СформироватьЗапросПоСпискуРаботников(ВыборкаПоШапкеДокумента, Режим);
			
			ВыборкаПоСтрокамТЧ = РезультатЗапросаПоСтрокамТЧ.Выбрать();

			Если ВыборкаПоСтрокамТЧ.Следующий() Тогда
				ПроверитьЗаполнениеСтрокиТабличнойЧасти(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамТЧ, Отказ, Заголовок);
			КонецЕсли;
			
			Если НЕ Отказ Тогда

				Движение = Движения.ПотребностиВОбучении.Добавить();
				
				Движение.Период = ВыборкаПоШапкеДокумента.ДатаЗавершенияКурса;
				Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
				
				// Измерения
				Движение.КурсОбучения = ВыборкаПоШапкеДокумента.Курс;
				Движение.ДокументПланирования = ВыборкаПоШапкеДокумента.Ссылка;

				// Ресурсы
				Движение.КоличествоРаботников = ВыборкаПоСтрокамТЧ.Количество();

			КонецЕсли;
		КонецЕсли;

	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(ОбучающиесяРаботники);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Физлицо");
	
КонецПроцедуры
