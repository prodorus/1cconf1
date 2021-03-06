////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

// По строке выборок из результатов запроса по документу формируем движения по регистрам
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента				- спозиционированная на определеной строке выборка 
//				  							  из результата запроса к ТЧ документа, 
//	НаборЗаписей							- набор записей для УдержанияРаботниковОрганизации 
// Возвращаемое значение:
//  Нет.
//
Процедура ДобавитьСтрокуУдержаний(ВыборкаПоСтрокамДокумента, ВыборкаПоШапкеДокумента, НаборЗаписей)

	Движение = НаборЗаписей.Добавить();

	ЗаполнитьЗначенияСвойств(Движение,ВыборкаПоШапкеДокумента);   // ПериодРегистрации, ОбособленноеПодразделение
	ЗаполнитьЗначенияСвойств(Движение,ВыборкаПоСтрокамДокумента); // БазовыйПериодНачало, БазовыйПериодКонец, ВидРасчета, Сторно
	                                                              // ФизЛицо, Организация, 
	                                                              // Результат, Размер, ДокументОснование, Авторасчет, ПорядокРасчетаБазы
КонецПроцедуры // ДобавитьСтрокуУдержаний

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

//Выполняет автоматическое заполнение показателей в строке
//
Процедура ЗаполнитьПоказателиСтроки(СотрудникФизлицо, ВидРасчета, НомерСтроки, Подразделение = Неопределено, ГоловнаяОрганизация, ИмяТЧ = "", ДатаНачала, РучныеИзмененияСтроки = Неопределено) Экспорт 
	
	ПоказателиСтроки = ЗаполнениеДокументовЗК.ПоказателиСтроки(СотрудникФизлицо, ВидРасчета, Подразделение, ГоловнаяОрганизация, ДатаНачала);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект[ИмяТЧ][НомерСтроки - 1], ПоказателиСтроки, , ЗаполнениеДокументовЗК.ИзмененныеВручнуюПоказатели(РучныеИзмененияСтроки));
	
КонецПроцедуры // ЗаполнитьПоказателиСтроки

Процедура Автозаполнение(СписокРаботников, ЗначенияЗаполнения, ГоловнаяОрганизация) Экспорт
	
	ЭтотОбъект.Удержания.Загрузить(ЗаполнениеДокументовЗК.РазовыеНачисленияУдержания(СписокРаботников, ЗначенияЗаполнения, ГоловнаяОрганизация, Ложь));
	
КонецПроцедуры // Автозаполнение
	
// Выполняет расчет удержаний
Процедура РассчитатьУдержания() Экспорт
	
	Отказ = Ложь;
	
	// Перечитаем объект и соберем данные для заполнения наборов записей регистров
	НачатьТранзакцию();
	Прочитать();
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();
	// позиционируем выборку
	ВыборкаПоШапкеДокумента.Следующий();
	ВыборкаПоУдержаниям = СформироватьЗапросПоУдержания(ВыборкаПоШапкеДокумента).Выбрать();

	ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ);
	
	// создадим наборы записей для выполнения движений
	НаборУдержания = РегистрыРасчета.УдержанияРаботниковОрганизаций.СоздатьНаборЗаписей();
	НаборУдержания.Отбор.Регистратор.Значение = Ссылка;
	
	// сформируем движения удержаний по данным табличной части без записи (запись делается процедурой РассчитатьЗаписиРегистраРасчета)
	Пока ВыборкаПоУдержаниям.Следующий() Цикл 
		ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоУдержаниям, Отказ);
		Если НЕ Отказ Тогда
			ДобавитьСтрокуУдержаний(ВыборкаПоУдержаниям, ВыборкаПоШапкеДокумента, НаборУдержания);
		КонецЕсли;	
	КонецЦикла;
	
	Если Отказ Тогда
		Если ТранзакцияАктивна() Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		Возврат;
	КонецЕсли; 

	// рассчитываем записи
	ПроведениеРасчетовПереопределяемый.РассчитатьЗаписиРегистраРасчета("УдержанияРаботниковОрганизаций", НаборУдержания, , , ВыборкаПоШапкеДокумента.ГоловнаяОрганизация, ВыборкаПоШапкеДокумента.ОбособленноеПодразделение, Удержания);
	
	// Удаляем движения
	НаборУдержания.Очистить();
	НаборУдержания.Записать();
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

// Заполняет документ по перерассчитываемому документу
// ИсходныйДокумент - тип ДокументОбъект.НачислениеОтпускаРаботникамОрганизаций
//
Процедура ЗаполнитьПоПерерассчитываемомуДокументу(ИсходныйДокумент, Физлица = Неопределено) Экспорт
	
	ПерерассчитываемыйДокумент = ИсходныйДокумент.Ссылка;
 	ЗаполнитьЗначенияСвойств(ЭтотОбъект,ИсходныйДокумент,,
		"Проведен, Номер, Дата, ПометкаУдаления, ПерерассчитываемыйДокумент, ПериодРегистрации, Комментарий, Ответственный"); // кроме указанных
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ПерерассчитываемыйДокумент", ПерерассчитываемыйДокумент);
	Запрос.УстановитьПараметр("Физлица", Физлица);
	Запрос.УстановитьПараметр("ПоВсемСотрудникам", Физлица = Неопределено);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РазовыеУдержания.Физлицо,
	|	-РазовыеУдержания.Результат КАК Результат,
	|	ИСТИНА КАК Сторно,
	|	ЛОЖЬ КАК Авторасчет,
	|	РазовыеУдержания.НомерСтроки КАК НомерСтроки,
	|	РазовыеУдержания.ВидРасчета,
	|	РазовыеУдержания.ДатаНачала,
	|	РазовыеУдержания.ДатаОкончания,
	|	РазовыеУдержания.Показатель1,
	|	РазовыеУдержания.Показатель2,
	|	РазовыеУдержания.Показатель3,
	|	РазовыеУдержания.Показатель4,
	|	РазовыеУдержания.Показатель5,
	|	РазовыеУдержания.Показатель6
	|ИЗ
	|	Документ.РегистрацияРазовыхУдержанийРаботниковОрганизаций.Удержания КАК РазовыеУдержания
	|ГДЕ
	|	РазовыеУдержания.Ссылка = &ПерерассчитываемыйДокумент
	|	И (НЕ РазовыеУдержания.Сторно)
	|	И РазовыеУдержания.Ссылка.Проведен
	|	И (&ПоВсемСотрудникам
	|			ИЛИ РазовыеУдержания.Физлицо В (&Физлица))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РазовыеУдержания.Физлицо,
	|	0,
	|	ЛОЖЬ,
	|	ИСТИНА,
	|	РазовыеУдержания.НомерСтроки,
	|	РазовыеУдержания.ВидРасчета,
	|	РазовыеУдержания.ДатаНачала,
	|	РазовыеУдержания.ДатаОкончания,
	|	РазовыеУдержания.Показатель1,
	|	РазовыеУдержания.Показатель2,
	|	РазовыеУдержания.Показатель3,
	|	РазовыеУдержания.Показатель4,
	|	РазовыеУдержания.Показатель5,
	|	РазовыеУдержания.Показатель6
	|ИЗ
	|	Документ.РегистрацияРазовыхУдержанийРаботниковОрганизаций.Удержания КАК РазовыеУдержания
	|ГДЕ
	|	РазовыеУдержания.Ссылка = &ПерерассчитываемыйДокумент
	|	И (НЕ РазовыеУдержания.Сторно)
	|	И (&ПоВсемСотрудникам
	|			ИЛИ РазовыеУдержания.Физлицо В (&Физлица))
	|	И РазовыеУдержания.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сторно УБЫВ,
	|	НомерСтроки";
	
	Удержания.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры // ЗаполнитьПоПерерассчитываемомуДокументу()

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Заполняет показатели
//
Функция ЗаполнитьПоказатели(ТекущийСотрудник, Источник) Экспорт 
	
	Если ТекущийСотрудник = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Удержания.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТЗУдержания		= Удержания.Выгрузить(,"ФизЛицо,ВидРасчета, ДатаОкончания");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Удержания",ТЗУдержания);
	Запрос.УстановитьПараметр("ПарамДата",НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ПарамГоловнаяОрганизация",ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Удержания.ВидРасчета,
	|	Удержания.ФизЛицо КАК ФизЛицо,
	|	Удержания.ДатаОкончания
	|ПОМЕСТИТЬ ВТУдержания
	|ИЗ
	|	&Удержания КАК Удержания
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.ВидДоговора,
	|	СотрудникиОрганизаций.Физлицо,
	|	СотрудникиОрганизаций.ВидЗанятости КАК ВидЗанятости
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Организация = &ПарамГоловнаяОрганизация
	|	И СотрудникиОрганизаций.Физлицо В
	|			(ВЫБРАТЬ
	|				Удержания.ФизЛицо КАК ФизЛицо
	|			ИЗ
	|				ВТУдержания КАК Удержания)
	|	И СотрудникиОрганизаций.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник";
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РаботникиОсновноеМесто.Сотрудник КАК Сотрудник,
	|	СотрудникиОрганизаций.Физлицо КАК Физлицо,
	|	СотрудникиОрганизаций.ВидЗанятости КАК ВидЗанятости
	|ПОМЕСТИТЬ ВТДанныеОРаботниках
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|			&ПарамДата,
	|			Сотрудник В
	|				(ВЫБРАТЬ
	|					Сотрудники.Сотрудник
	|				ИЗ
	|					ВТСотрудники КАК Сотрудники)) КАК РаботникиОсновноеМесто
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК СотрудникиОрганизаций
	|		ПО РаботникиОсновноеМесто.Сотрудник = СотрудникиОрганизаций.Сотрудник
	|ГДЕ
	|	ВЫБОР
	|			КОГДА РаботникиОсновноеМесто.ПериодЗавершения <= &ПарамДата
	|					И РаботникиОсновноеМесто.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА РаботникиОсновноеМесто.ПричинаИзмененияСостоянияЗавершения
	|			ИНАЧЕ РаботникиОсновноеМесто.ПричинаИзмененияСостояния
	|		КОНЕЦ <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидЗанятости,
	|	Физлицо";			
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Показатели.Показатель КАК Показатель,
	|	Показатели.Показатель.ВидПоказателя КАК ВидПоказателя,
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Удержания.ДатаОкончания
	|ИЗ
	|	ВТУдержания КАК Удержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели
	|		ПО Удержания.ВидРасчета = Показатели.Ссылка
	|			И ((НЕ Показатели.Показатель.Предопределенный))
	|			И (Показатели.Показатель.ВозможностьИзменения <> ЗНАЧЕНИЕ(Перечисление.ИзменениеПоказателейСхемМотивации.НеИзменяется))
	|			И (Показатели.Показатель.ВозможностьИзменения <> ЗНАЧЕНИЕ(Перечисление.ИзменениеПоказателейСхемМотивации.ПустаяСсылка))
	|			И (Показатели.Показатель.ТипПоказателя <> ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ОценочнаяШкалаЧисловая))
	|			И (Показатели.Показатель.ТипПоказателя <> ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ОценочнаяШкалаПроцентная))
	|			И (Показатели.Показатель.ТипПоказателя <> ЗНАЧЕНИЕ(Перечисление.ТипыПоказателейСхемМотивации.ТарифныйРазряд))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СписокСотрудников.Сотрудник КАК Сотрудник,
	|			СписокСотрудников.Физлицо КАК Физлицо
	|		ИЗ
	|			(ВЫБРАТЬ
	|				МАКСИМУМ(РаботникиОсновноеМесто.Сотрудник) КАК Сотрудник,
	|				РаботникиОсновноеМесто.Физлицо КАК Физлицо,
	|				1 КАК Приоритет
	|			ИЗ
	|				ВТДанныеОРаботниках КАК РаботникиОсновноеМесто
	|			ГДЕ
	|				РаботникиОсновноеМесто.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РаботникиОсновноеМесто.Физлицо
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				МАКСИМУМ(РаботникиСовместительство.Сотрудник),
	|				РаботникиСовместительство.Физлицо,
	|				2
	|			ИЗ
	|				ВТДанныеОРаботниках КАК РаботникиСовместительство
	|			ГДЕ
	|				РаботникиСовместительство.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.Совместительство)
	|			
	|			СГРУППИРОВАТЬ ПО
	|				РаботникиСовместительство.Физлицо
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				МАКСИМУМ(СотрудникиДУ.Сотрудник),
	|				СотрудникиДУ.Физлицо,
	|				ВЫБОР
	|					КОГДА СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|						ТОГДА 4
	|					ИНАЧЕ 5
	|				КОНЕЦ
	|			ИЗ
	|				ВТСотрудники КАК СотрудникиДУ
	|			
	|			СГРУППИРОВАТЬ ПО
	|				СотрудникиДУ.Физлицо,
	|				ВЫБОР
	|					КОГДА СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|						ТОГДА 4
	|					ИНАЧЕ 5
	|				КОНЕЦ) КАК СписокСотрудников
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					СписокФизическихЛиц.Физлицо КАК Физлицо,
	|					МИНИМУМ(СписокФизическихЛиц.Приоритет) КАК Приоритет
	|				ИЗ
	|					(ВЫБРАТЬ
	|						РаботникиОсновноеМесто.Физлицо КАК Физлицо,
	|						1 КАК Приоритет
	|					ИЗ
	|						ВТДанныеОРаботниках КАК РаботникиОсновноеМесто
	|					ГДЕ
	|						РаботникиОсновноеМесто.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)
	|					
	|					ОБЪЕДИНИТЬ
	|					
	|					ВЫБРАТЬ
	|						РаботникиСовместительство.Физлицо,
	|						2
	|					ИЗ
	|						ВТДанныеОРаботниках КАК РаботникиСовместительство
	|					ГДЕ
	|						РаботникиСовместительство.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.Совместительство)
	|					
	|					ОБЪЕДИНИТЬ
	|					
	|					ВЫБРАТЬ
	|						СотрудникиДУ.Физлицо,
	|						ВЫБОР
	|							КОГДА СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|								ТОГДА 4
	|							ИНАЧЕ 5
	|						КОНЕЦ
	|					ИЗ
	|						ВТСотрудники КАК СотрудникиДУ) КАК СписокФизическихЛиц
	|				
	|				СГРУППИРОВАТЬ ПО
	|					СписокФизическихЛиц.Физлицо) КАК СписокФизическихЛиц
	|				ПО СписокСотрудников.Физлицо = СписокФизическихЛиц.Физлицо
	|					И СписокСотрудников.Приоритет = СписокФизическихЛиц.Приоритет) КАК Сотрудники
	|		ПО Удержания.ФизЛицо = Сотрудники.Физлицо
	|ГДЕ
	|	Показатели.Показатель ЕСТЬ НЕ NULL 
	|	И Сотрудники.Сотрудник ЕСТЬ НЕ NULL ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		
		ТаблицаЗапроса = Результат.Выгрузить();
		Показатели = ТаблицаЗапроса.ВыгрузитьКолонку("Показатель");
		Сотрудники = ТаблицаЗапроса.ВыгрузитьКолонку("Сотрудник");
		
		ФормаВводаПоказателей = РегистрыСведений.ЗначенияПоказателейСхемМотивации.ПолучитьФорму("ФормаВводаЗначенийПоказателей");
		ФормаВводаПоказателей.Организация			= Организация;
		ФормаВводаПоказателей.ПериодДействия		= НачалоМесяца(ПериодРегистрации);
		ФормаВводаПоказателей.ФормаАвтозаполнение(ТаблицаЗапроса, Сотрудники, Показатели);
		ФормаВводаПоказателей.мСотрудникДляОткрытия	= ТекущийСотрудник;
		ФормаВводаПоказателей.мИсточник				= Источник;
		ФормаВводаПоказателей.Открыть();		
		
		Возврат Истина;
		
	КонецЕсли;

КонецФункции //ЗаполнитьПоказатели

#КонецЕсли

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
Функция СформироватьЗапросПоШапке()

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	Запрос.УстановитьПараметр("парамПустаяОрганизация", Справочники.Организации.ПустаяСсылка());

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.Дата,
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.ПериодРегистрации,
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.Организация,
	|	ВЫБОР
	|		КОГДА РегистрацияРазовыхУдержанийРаботниковОрганизации.Организация.ГоловнаяОрганизация = &парамПустаяОрганизация
	|			ТОГДА РегистрацияРазовыхУдержанийРаботниковОрганизации.Организация
	|		ИНАЧЕ РегистрацияРазовыхУдержанийРаботниковОрганизации.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.ПерерассчитываемыйДокумент.ПериодРегистрации КАК ПериодПерерасчета,
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.ПерерассчитываемыйДокумент.Организация КАК ОрганизацияПерерасчета,
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.Организация КАК ОбособленноеПодразделение,
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.Ссылка
	|ИЗ
	|	Документ.РегистрацияРазовыхУдержанийРаботниковОрганизаций КАК РегистрацияРазовыхУдержанийРаботниковОрганизации
	|ГДЕ
	|	РегистрацияРазовыхУдержанийРаботниковОрганизации.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "Удержания" документа
//
// Параметры: 
//	нет
//
// Возвращаемое значение:
//  Результат запроса.
//
Функция СформироватьЗапросПоУдержания(ВыборкаПоШапкеДокумента)

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",				Ссылка);
	Запрос.УстановитьПараметр("ПериодРегистрации",			ПериодРегистрации);
	Запрос.УстановитьПараметр("КонецПериодаРегистрации",	КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",		ВыборкаПоШапкеДокумента.ГоловнаяОрганизация);
	Запрос.УстановитьПараметр("ПриемНаРаботу",				Перечисления.ПричиныИзмененияСостояния.ПриемНаРаботу);
	Запрос.УстановитьПараметр("ВнутреннееСовместительство",	Перечисления.ВидыЗанятостиВОрганизации.ВнутреннееСовместительство);
	Запрос.УстановитьПараметр("ЗаВесьПериод",				Перечисления.ПорядокРасчетаБазы.ЗаВесьПериод);
	Запрос.УстановитьПараметр("ПриПриемеНаРаботу",			Перечисления.ПорядокРасчетаБазы.ПриПриемеНаРаботу);
	Запрос.УстановитьПараметр("ПриУвольнении",				Перечисления.ПорядокРасчетаБазы.ПриУвольнении);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтрокиУдержания.Ссылка,
	|	СтрокиУдержания.НомерСтроки,
	|	СтрокиУдержания.Физлицо,
	|	СтрокиУдержания.ВидРасчета,
	|	СтрокиУдержания.Показатель1,
	|	СтрокиУдержания.Показатель2,
	|	СтрокиУдержания.Показатель3,
	|	СтрокиУдержания.Показатель4,
	|	СтрокиУдержания.Показатель5,
	|	СтрокиУдержания.Показатель6,
	|	СтрокиУдержания.ДатаНачала,
	|	СтрокиУдержания.ДатаОкончания,
	|	СтрокиУдержания.Результат,
	|	СтрокиУдержания.Сторно,
	|	СтрокиУдержания.Авторасчет
	|ПОМЕСТИТЬ ВТУдержания
	|ИЗ
	|	Документ.РегистрацияРазовыхУдержанийРаботниковОрганизаций.Удержания КАК СтрокиУдержания
	|ГДЕ
	|	СтрокиУдержания.Ссылка = &ДокументСсылка";
	Запрос.Выполнить();

	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.НомерСтроки КАК НомерСтроки,
	|	МАКСИМУМ(РаботникиОрганизаций.Период) КАК Период
	|ПОМЕСТИТЬ ВТПринятыеВТекущемМесяце
	|ИЗ
	|	ВТУдержания КАК РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.Физлицо = РаботникиОрганизаций.Сотрудник.Физлицо
	|ГДЕ
	|	РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.ДатаНачала > &ПериодРегистрации
	|	И РаботникиОрганизаций.Организация = &ГоловнаяОрганизация
	|	И РаботникиОрганизаций.Период > &ПериодРегистрации
	|	И РаботникиОрганизаций.Период <= &КонецПериодаРегистрации
	|	И РаботникиОрганизаций.ПричинаИзмененияСостояния = &ПриемНаРаботу
	|	И РаботникиОрганизаций.Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство
	|
	|СГРУППИРОВАТЬ ПО
	|	РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.НомерСтроки КАК НомерСтроки,
	|	РаботникиОрганизаций.ПричинаИзмененияСостоянияЗавершения КАК ПричинаИзмененияСостоянияЗавершения,
	|	РаботникиОрганизаций.ПериодЗавершения КАК ПериодЗавершения,
	|	МИНИМУМ(РаботникиОрганизаций.Период) КАК Период
	|ПОМЕСТИТЬ ВТУволенныеВТекущемМесяце
	|ИЗ
	|	ВТУдержания КАК РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	|		ПО РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.Физлицо = РаботникиОрганизаций.Сотрудник.Физлицо
	|ГДЕ
	|	РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|	И РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.ДатаОкончания < &КонецПериодаРегистрации
	|	И РаботникиОрганизаций.Организация = &ГоловнаяОрганизация
	|	И РаботникиОрганизаций.Период >= &ПериодРегистрации
	|	И РаботникиОрганизаций.Период < &КонецПериодаРегистрации
	|	И РаботникиОрганизаций.ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|	И РаботникиОрганизаций.Сотрудник.ВидЗанятости <> &ВнутреннееСовместительство
	|
	|СГРУППИРОВАТЬ ПО
	|	РегистрацияРазовыхУдержанийРаботниковОрганизацийУдержания.НомерСтроки,
	|	РаботникиОрганизаций.ПричинаИзмененияСостоянияЗавершения,
	|	РаботникиОрганизаций.ПериодЗавершения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ГоловнаяОрганизация КАК Организация,
	|	СтрокиУдержания.Физлицо,
	|	СтрокиУдержания.ВидРасчета,
	|	СтрокиУдержания.ДатаНачала,
	|	СтрокиУдержания.ДатаОкончания,
	|	СтрокиУдержания.ДатаНачала КАК БазовыйПериодНачало,
	|	ВЫБОР
	|		КОГДА СтрокиУдержания.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА СтрокиУдержания.ДатаОкончания
	|		ИНАЧЕ КОНЕЦПЕРИОДА(СтрокиУдержания.ДатаОкончания, ДЕНЬ)
	|	КОНЕЦ КАК БазовыйПериодКонец,
	|	СтрокиУдержания.НомерСтроки КАК НомерСтроки,
	|	СтрокиУдержания.Показатель1,
	|	СтрокиУдержания.Показатель2,
	|	СтрокиУдержания.Показатель3,
	|	СтрокиУдержания.Показатель4,
	|	СтрокиУдержания.Показатель5,
	|	СтрокиУдержания.Показатель6,
	|	СтрокиУдержания.Результат,
	|	СтрокиУдержания.Сторно,
	|	СтрокиУдержания.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	СтрокиУдержания.Авторасчет КАК Авторасчет,
	|	ВЫБОР
	|		КОГДА СтрокиУдержания.ДатаНачала > &ПериодРегистрации
	|				И ПринятыеВТекущемМесяце.Период ЕСТЬ НЕ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА СтрокиУдержания.ДатаНачала = ПринятыеВТекущемМесяце.Период
	|						ТОГДА &ПриПриемеНаРаботу
	|					ИНАЧЕ &ЗаВесьПериод
	|				КОНЕЦ
	|		КОГДА СтрокиУдержания.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА &ЗаВесьПериод
	|		КОГДА КОНЕЦПЕРИОДА(СтрокиУдержания.ДатаОкончания, ДЕНЬ) < &КонецПериодаРегистрации
	|				И УволенныеВТекущемМесяце.ПричинаИзмененияСостоянияЗавершения = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|				И УволенныеВТекущемМесяце.ПериодЗавершения <= &КонецПериодаРегистрации
	|				И УволенныеВТекущемМесяце.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА &ПриУвольнении
	|		КОГДА КОНЕЦПЕРИОДА(СтрокиУдержания.ДатаОкончания, ДЕНЬ) < &КонецПериодаРегистрации
	|				И УволенныеВТекущемМесяце.Период ЕСТЬ НЕ NULL 
	|			ТОГДА ВЫБОР
	|					КОГДА НАЧАЛОПЕРИОДА(СтрокиУдержания.ДатаОкончания, ДЕНЬ) = НАЧАЛОПЕРИОДА(УволенныеВТекущемМесяце.Период, ДЕНЬ)
	|						ТОГДА &ПриУвольнении
	|					ИНАЧЕ &ЗаВесьПериод
	|				КОНЕЦ
	|		ИНАЧЕ &ЗаВесьПериод
	|	КОНЕЦ КАК ПорядокРасчетаБазы
	|ИЗ
	|	ВТУдержания КАК СтрокиУдержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПринятыеВТекущемМесяце КАК ПринятыеВТекущемМесяце
	|		ПО СтрокиУдержания.НомерСтроки = ПринятыеВТекущемМесяце.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТУволенныеВТекущемМесяце КАК УволенныеВТекущемМесяце
	|		ПО СтрокиУдержания.НомерСтроки = УволенныеВТекущемМесяце.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоУдержания()

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение, не заполнен или
// заполнен некорректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по шапке,
// все проверяемые реквизиты должны быть включены в выборку по шапке.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента	- выборка из результата запроса по шапке документа,
//  Отказ 					- флаг отказа в проведении,
//	Заголовок				- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок = "")

	//  Организация
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Не указана организация, в которой выполняются удержания!"), Отказ, Заголовок);
	КонецЕсли;
	
	//  ПериодРегистрации
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ПериодРегистрации) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан месяц, в котором выполняются удержания!", Отказ, Заголовок);
	КонецЕсли;
	
	// соответствие организаций документа и перерассчитываемого документа
	Если ВыборкаПоШапкеДокумента.ОрганизацияПерерасчета <> null 
		и ВыборкаПоШапкеДокумента.ОбособленноеПодразделение <> ВыборкаПоШапкеДокумента.ОрганизацияПерерасчета Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Организация, заданная для документа, должна совпадать с организацией исправляемого документа!"), Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Удержания" документа.
// Если какой-то из реквизитов, влияющий на проведение, не заполнен или
// заполнен некорректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса к ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса к ТЧ документа, 
//  Отказ 						- флаг отказа в проведении,
//	Заголовок					- Заголовок для сообщений об ошибках проведения.
//
Процедура ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок = "")

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Удержания"": ";
	
	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрано физическое лицо!", Отказ, Заголовок);
	КонецЕсли;

	// ВидРасчета
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидРасчета) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указан вид расчета!", Отказ, Заголовок);
		
	ИначеЕсли ВыборкаПоСтрокамДокумента.СпособРасчета <> Перечисления.СпособыРасчетаОплатыТруда.УдержаниеФиксированнойСуммой и 
		ВыборкаПоСтрокамДокумента.СпособРасчета <> Перечисления.СпособыРасчетаОплатыТруда.ИсполнительныйЛистФиксСуммойДоПредела Тогда
		// Дата начала
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаНачала) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата начала удержания!", Отказ, Заголовок);
		КонецЕсли;

		// Дата окончания
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаОкончания) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата окончания удержания!", Отказ, Заголовок);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеСтрокиУдержания()

// Вычисляет разницу между начислениями и удержаниями работника и формирует
// движения по взаиморасчетам с работниками
//
// Параметры:
//		ВыборкаПоШапкеДокумента - спозиционированная выборка по шапке документа
//		НаборЗаписей - набор записей 
//      Перерасчет - признак проведения перерасчетов, по умолчанию - Ложь
//      Физлица - список физлиц, по которым производится расчет, по умолчанию - отсутствует
//
// Возвращаемое значение:
//  Нет.
//		
Процедура СформироватьВзаиморасчетыСРаботниками(ВыборкаПоШапкеДокумента, НаборЗаписей, Перерасчет = Ложь, Физлица = НеОпределено)
	
	УдержанияРаботниковТекст = 
	"ВЫБРАТЬ
	|	ТЧУдержания.Физлицо КАК Физлицо,
	|	СУММА(ТЧУдержания.Результат) КАК СуммаУдержания
	|ИЗ
	|	Документ.РегистрацияРазовыхУдержанийРаботниковОрганизаций.Удержания КАК ТЧУдержания
	|
	|ГДЕ
	|	ТЧУдержания.Ссылка = &парамСсылка И
	|	(ТЧУдержания.Результат <> 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТЧУдержания.Физлицо";
	
	Запрос = Новый Запрос(УдержанияРаботниковТекст);
		
	// Установим параметры запроса
	Запрос.УстановитьПараметр("парамСсылка" , Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	// сформируем движения ВзаиморасчетыСРаботникамиОрганизаций
	Пока Выборка.Следующий() Цикл
		Движение = НаборЗаписей.Добавить();
		
		// свойства
		Движение.Период 				= КонецМесяца(ПериодРегистрации);
		Движение.ВидДвижения			= ВидДвиженияНакопления.Приход;
		
		// измерения 
		Движение.Физлицо 				= Выборка.Физлицо;
		Движение.Организация 			= Организация;
		Движение.ПериодВзаиморасчетов 	= ПериодРегистрации;
		
		// ресурсы
		Движение.СуммаВзаиморасчетов 	= - Выборка.СуммаУдержания;
		
	КонецЦикла;
	
КонецПроцедуры   // СформироватьВзаиморасчетыСРаботниками

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			////////////////////////////////////////////////////////////////////////
			// Удержания

			// получим реквизиты табличной части
			ВыборкаПоУдержаниям = СформироватьЗапросПоУдержания(ВыборкаПоШапкеДокумента).Выбрать();

			Пока ВыборкаПоУдержаниям.Следующий() Цикл 

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоУдержаниям, Отказ, Заголовок);
				Если НЕ Отказ Тогда
					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуУдержаний(ВыборкаПоУдержаниям, ВыборкаПоШапкеДокумента, Движения.УдержанияРаботниковОрганизаций);
				КонецЕсли;
			КонецЦикла;

			////////////////////////////////////////////////////////////////////////
			// взаиморасчеты с работниками
			
			// сформируем начисления к выплате по начислениям документа
			СформироватьВзаиморасчетыСРаботниками(ВыборкаПоШапкеДокумента, Движения.ВзаиморасчетыСРаботникамиОрганизаций);
			
			ПроведениеРасчетов.СформироватьСоциальныеВычетыПоНДФЛ(ВыборкаПоШапкеДокумента, Неопределено, Движения.НДФЛПредоставленныеСтандартныеВычетыФизЛиц, Метаданные().Имя);	
		КонецЕсли;

	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(Удержания);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Физлицо");
	
КонецПроцедуры
