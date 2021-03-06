
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура Автозаполнение(ТаблицаФизлиц = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаДокумента",		Дата);
	Запрос.УстановитьПараметр("ПериодРегистрации",	ПериодРегистрации);
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация",ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("ПоВсемФизлицам",		ТаблицаФизлиц = Неопределено);
	Запрос.УстановитьПараметр("ТаблицаФизлиц",		ТаблицаФизлиц);
	
	Если ТаблицаФизлиц = Неопределено Тогда
		Запрос.Текст =  
		"ВЫБРАТЬ
		|	НЕОПРЕДЕЛЕНО КАК ФизЛицо,
		|	0 КАК ВзносыРаботодателя
		|ПОМЕСТИТЬ ВТТаблицаФизлиц";
	Иначе
		Запрос.Текст =  
		"ВЫБРАТЬ
		|	ТаблицаФизлиц.ФизЛицо КАК ФизЛицо,
		|	ТаблицаФизлиц.ВзносыРаботодателя
		|ПОМЕСТИТЬ ВТТаблицаФизлиц
		|ИЗ
		|	&ТаблицаФизлиц КАК ТаблицаФизлиц
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ФизЛицо";
	КонецЕсли;
	Запрос.Выполнить();
	
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	УдержанияРаботниковОрганизаций.ФизЛицо КАК ФизЛицо,
	|	СУММА(УдержанияРаботниковОрганизаций.Результат) КАК ВзносыРаботника
	|ПОМЕСТИТЬ ВТФизЛица
	|ИЗ
	|	РегистрРасчета.УдержанияРаботниковОрганизаций КАК УдержанияРаботниковОрганизаций
	|ГДЕ
	|	УдержанияРаботниковОрганизаций.Организация = &ГоловнаяОрганизация
	|	И УдержанияРаботниковОрганизаций.ОбособленноеПодразделение = &Организация
	|	И УдержанияРаботниковОрганизаций.ПериодРегистрации = &ПериодРегистрации
	|	И УдержанияРаботниковОрганизаций.ВидРасчета.ЯвляетсяДСВ
	|	И (&ПоВсемФизлицам
	|			ИЛИ УдержанияРаботниковОрганизаций.ФизЛицо В
	|				(ВЫБРАТЬ
	|					ФизЛица.ФизЛицо
	|				ИЗ
	|					ВТТаблицаФизлиц КАК ФизЛица))
	|
	|СГРУППИРОВАТЬ ПО
	|	УдержанияРаботниковОрганизаций.ФизЛицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОтобранныеФизлица.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТВсеФизлица
	|ИЗ
	|	ВТТаблицаФизлиц КАК ОтобранныеФизлица
	|ГДЕ
	|	ОтобранныеФизлица.ФизЛицо <> НЕОПРЕДЕЛЕНО
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ФизЛицаУплатившиеВзносы.ФизЛицо
	|ИЗ
	|	ВТФизЛица КАК ФизЛицаУплатившиеВзносы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеФизлица.ФизЛицо КАК ФизЛицо,
	|	ВсеФизлица.ФизЛицо.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	ОтобранныеФизлица.ВзносыРаботодателя,
	|	ФизЛицаУплатившиеВзносы.ВзносыРаботника,
	|	ФИОФизЛицСрезПоследних.Фамилия КАК Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя,
	|	ФИОФизЛицСрезПоследних.Отчество
	|ИЗ
	|	ВТВсеФизлица КАК ВсеФизлица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаФизлиц КАК ОтобранныеФизлица
	|		ПО ВсеФизлица.ФизЛицо = ОтобранныеФизлица.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизЛица КАК ФизЛицаУплатившиеВзносы
	|		ПО ВсеФизлица.ФизЛицо = ФизЛицаУплатившиеВзносы.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(
	|				&ДатаДокумента,
	|				ФизЛицо В
	|					(ВЫБРАТЬ
	|						ФизЛица.ФизЛицо
	|					ИЗ
	|						ВТВсеФизлица КАК ФизЛица)) КАК ФИОФизЛицСрезПоследних
	|		ПО ВсеФизлица.ФизЛицо = ФИОФизЛицСрезПоследних.ФизЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Фамилия,
	|	ФизЛицо";
	
	РаботникиОрганизации.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

// Заполняет в строке документа по физлицу его "кадровые" данные 
//
// Параметры: 
//  СтрокаТабличнойЧасти - строка, в которой изменилось физлицо
//
// Возвращаемое значение:
//  Нет
//
Процедура ЗаполнитьДанныеПоФизЛицу(СтрокаТабличнойЧасти) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизЛицо",			СтрокаТабличнойЧасти.ФизЛицо);
	Запрос.УстановитьПараметр("ДатаАктуальности" , 	Дата);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ФИОФизЛицСрезПоследних.Фамилия КАК Фамилия,
	|	ФИОФизЛицСрезПоследних.Имя КАК Имя,
	|	ФИОФизЛицСрезПоследних.Отчество КАК Отчество,
	|	ФизическиеЛица.СтраховойНомерПФР
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизЛиц.СрезПоследних(&ДатаАктуальности, ФизЛицо = &ФизЛицо) КАК ФИОФизЛицСрезПоследних
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ФизическиеЛица.Ссылка = &ФизЛицо";
				   
	ВыборкаПоРаботнику = Запрос.Выполнить().Выбрать();

	Если ВыборкаПоРаботнику.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаПоРаботнику);
	КонецЕсли;

КонецПроцедуры

// собирает суммы уплаченных взносов для указанных в документе физлиц
Процедура Рассчитать() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаДокумента",		Дата);
	Запрос.УстановитьПараметр("ПериодРегистрации",	ПериодРегистрации);
	Запрос.УстановитьПараметр("Организация",		ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("ТаблицаФизлиц",		РаботникиОрганизации.Выгрузить());
	
	Запрос.Текст =  
	"ВЫБРАТЬ
	|	ТаблицаФизлиц.НомерСтроки КАК НомерСтроки,
	|	ТаблицаФизлиц.СтраховойНомерПФР,
	|	ТаблицаФизлиц.Фамилия,
	|	ТаблицаФизлиц.Имя,
	|	ТаблицаФизлиц.Отчество,
	|	ТаблицаФизлиц.ВзносыРаботодателя,
	|	ТаблицаФизлиц.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТТаблицаФизлиц
	|ИЗ
	|	&ТаблицаФизлиц КАК ТаблицаФизлиц
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УдержанияРаботниковОрганизаций.ФизЛицо КАК ФизЛицо,
	|	СУММА(УдержанияРаботниковОрганизаций.Результат) КАК ВзносыРаботника
	|ПОМЕСТИТЬ ВТФизЛица
	|ИЗ
	|	РегистрРасчета.УдержанияРаботниковОрганизаций КАК УдержанияРаботниковОрганизаций
	|ГДЕ
	|	УдержанияРаботниковОрганизаций.Организация = &Организация
	|	И УдержанияРаботниковОрганизаций.ПериодРегистрации = &ПериодРегистрации
	|	И УдержанияРаботниковОрганизаций.ВидРасчета.ЯвляетсяДСВ
	|	И УдержанияРаботниковОрганизаций.ФизЛицо В
	|			(ВЫБРАТЬ
	|				ФизЛица.ФизЛицо
	|			ИЗ
	|				ВТТаблицаФизлиц КАК ФизЛица)
	|
	|СГРУППИРОВАТЬ ПО
	|	УдержанияРаботниковОрганизаций.ФизЛицо
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Взносы.ВзносыРаботника,
	|	ФизЛица.НомерСтроки КАК НомерСтроки,
	|	ФизЛица.СтраховойНомерПФР,
	|	ФизЛица.Фамилия,
	|	ФизЛица.Имя,
	|	ФизЛица.Отчество,
	|	ФизЛица.ВзносыРаботодателя,
	|	ФизЛица.ФизЛицо
	|ИЗ
	|	ВТТаблицаФизлиц КАК ФизЛица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизЛица КАК Взносы
	|		ПО ФизЛица.ФизЛицо = Взносы.ФизЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РаботникиОрганизации.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
//Процедура вывода сведений на печать
Функция Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	Если ИмяМакета = "ФормаДСВ_3" Или ИмяМакета = "ФормаДСВ_3_2016" Тогда
		
		ДокументовВПачке = РаботникиОрганизации.Количество();
		Если ДокументовВПачке = 0 Тогда
			РаботаСДиалогами.ВывестиПредупреждение("Не обнаружено данных для печати!");
			Возврат Неопределено
		КонецЕсли;
		
		НомерПачкиРаботодателя = НомерПачки;
		
		ДокументСписокЗастрахованныхЛиц = Новый ТабличныйДокумент;
		ДокументСписокЗастрахованныхЛиц.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РеестрДСВ3";
		
		Макет = ПолучитьМакет("Реестр" + ?(ИмяМакета = "ФормаДСВ_3_2016","2016",""));
		ОбластьШапкаСписка = Макет.ПолучитьОбласть("Шапка");
		ОбластьСтрокаСписка = Макет.ПолучитьОбласть("СтрокаРаботника");
		ОбластьПодвалСписка = Макет.ПолучитьОбласть("Подвал");
		ПовторятьПриПечатиСтроки = Макет.ПолучитьОбласть("ПовторятьПриПечати"); // повторяющаяся шапка страницы
		// массив с двумя строками - для разбиения на страницы
	    ВыводимыеОбласти = Новый Массив();
		ВыводимыеОбласти.Добавить(ОбластьСтрокаСписка);
		
		// шапка реестра
		Запрос = Новый Запрос;
		// Установим параметры запроса
		Запрос.УстановитьПараметр("Организация" , Организация);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Наименование,
		|	ВЫБОР
		|		КОГДА Организации.ЮрФизЛицо = ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
		|			ТОГДА Организации.ИндивидуальныйПредприниматель.ИНН
		|		ИНАЧЕ Организации.ИНН
		|	КОНЕЦ КАК ИНН,
		|	Организации.КПП,
		|	Организации.РегистрационныйНомерПФР
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ОбластьШапкаСписка.Параметры,Выборка);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ОбластьШапкаСписка.Параметры,ЭтотОбъект);

		ДокументСписокЗастрахованныхЛиц.Вывести(ОбластьШапкаСписка);
		
		//Цикл по документам файла
		Для Каждого СтрокаДСВ Из РаботникиОрганизации Цикл
			
			// Список застрахованных лиц
			ЗаполнитьЗначенияСвойств(ОбластьСтрокаСписка.Параметры,СтрокаДСВ);
			ОбластьСтрокаСписка.Параметры.ФИО = СтрокаДСВ.Фамилия + " " + СтрокаДСВ.Имя + ?(ПустаяСтрока(СтрокаДСВ.Отчество),""," " + СтрокаДСВ.Отчество);
			
			// Проверим, уместится ли строка на странице или надо открывать новую страницу
			ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументСписокЗастрахованныхЛиц, ВыводимыеОбласти);
			Если Не ВывестиПодвалЛиста и СтрокаДСВ.НомерСтроки = ДокументовВПачке Тогда
				ВыводимыеОбласти.Добавить(ОбластьПодвалСписка);
				ВывестиПодвалЛиста = Не ФормированиеПечатныхФорм.ПроверитьВыводТабличногоДокумента(ДокументСписокЗастрахованныхЛиц, ВыводимыеОбласти);
			КонецЕсли;
			Если ВывестиПодвалЛиста Тогда
				ДокументСписокЗастрахованныхЛиц.ВывестиГоризонтальныйРазделительСтраниц();
				ДокументСписокЗастрахованныхЛиц.Вывести(ПовторятьПриПечатиСтроки);
			КонецЕсли;
			
			ДокументСписокЗастрахованныхЛиц.Вывести(ОбластьСтрокаСписка);
			
		КонецЦикла; // по документам

		// подвал реестра
		ОбластьПодвалСписка.Параметры.ВзносыРаботника = РаботникиОрганизации.Итог("ВзносыРаботника");
		ОбластьПодвалСписка.Параметры.ВзносыРаботодателя = РаботникиОрганизации.Итог("ВзносыРаботодателя");
		ОбластьПодвалСписка.Параметры.ВзносыВсего = ОбластьПодвалСписка.Параметры.ВзносыРаботника + ОбластьПодвалСписка.Параметры.ВзносыРаботодателя;
		ОбластьПодвалСписка.Параметры.Дата = Дата;
		
		// Получим сведения об ответственных лицах
		ОтветственныеЛица = Новый Структура("Руководитель, РуководительДолжность, ГлавныйБухгалтер");
		
		ЗапросПоЛицам = Новый Запрос();
		ЗапросПоЛицам.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		ЗапросПоЛицам.УстановитьПараметр("Организация",	Организация);
		ЗапросПоЛицам.УстановитьПараметр("ДатаСреза",	Дата);
		
		ЗапросПоЛицам.Текст = ФормированиеПечатныхФормЗК.ПолучитьТекстЗапросаПоОтветственнымЛицам(
			"ДатаСреза",
			"ОтветственноеЛицо В (ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.Руководитель), ЗНАЧЕНИЕ(Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер))
			|И СтруктурнаяЕдиница = &Организация");
		ЗапросПоЛицам.Выполнить();
		
		ЗапросПоЛицам.Текст =
		"ВЫБРАТЬ
		|	ВТОтветственные.ОтветственноеЛицо,
		|	ВТОтветственные.Должность КАК Должность,
		|	ВТОтветственные.НаименованиеОтветственногоЛица КАК ФИОПолное
		|ИЗ
		|	ВТДанныеОбОтветственномЛице КАК ВТОтветственные";
		Выборка = ЗапросПоЛицам.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель Тогда
				ОтветственныеЛица.Руководитель            = Выборка.ФИОПолное;
				ОтветственныеЛица.РуководительДолжность   = Выборка.Должность;
			КонецЕсли;
			Если Выборка.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер Тогда
				ОтветственныеЛица.ГлавныйБухгалтер        = Выборка.ФИОПолное;
			КонецЕсли;
			
		КонецЦикла;

		ЗаполнитьЗначенияСвойств(ОбластьПодвалСписка.Параметры,ОтветственныеЛица);
		
		ДокументСписокЗастрахованныхЛиц.Вывести(ОбластьПодвалСписка);
		
		Возврат УниверсальныеМеханизмы.НапечататьДокумент(ДокументСписокЗастрахованныхЛиц,КоличествоЭкземпляров, НаПринтер,"Реестр ДСВ-3; пачка №" + НомерПачкиРаботодателя);
		
	КонецЕсли;
	
КонецФункции // Печать()

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ФормаДСВ_3, ФормаДСВ_3_2016", "ДСВ-3, форма 2009 года", "ДСВ-3, форма 2016 года");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Формирует файл, который можно будет записать на дискетку
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Строка - содержимое файла
//
Функция СформироватьВыходнойФайл(Отказ) Экспорт

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);

    ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапке().Выбрать();
	Если Не ВыборкаПоШапкеДокумента.Следующий() Тогда
		Отказ = Истина;
		Возврат "";
	КонецЕсли;	

    ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);
	Если Отказ Тогда
		Возврат "";
	КонецЕсли;	 

	ВыборкаПоРаботникиОрганизации =	СформироватьЗапросПоРаботникиОрганизации().Выбрать(ОбходРезультатаЗапроса.Прямой);

	ТекстФайла	=	"";
	НомерДокументаВПачке = 0;

	ДатаЗаполнения 			= ВыборкаПоШапкеДокумента.Дата;
	КоличествоДокументов 	= ВыборкаПоРаботникиОрганизации.Количество();

	НомерДокументаВПачке = 1;
	// Загружаем формат файла сведений
	МакетФормата = ПолучитьОбщийМакет("ФорматПФР70");
	
	// Создаем начальное дерево
	ДеревоВыгрузки = ПроцедурыПерсонифицированногоУчета.СоздатьДеревоXML();
	
	Атрибуты = Новый Соответствие;
	Атрибуты.Вставить("xmlns", "http://schema.pfr.ru");
	УзелПФР = ПроцедурыПерсонифицированногоУчета.ДобавитьУзелВДеревоXML(ДеревоВыгрузки, "ФайлПФР", "", Атрибуты);
	
	ПроцедурыПерсонифицированногоУчета.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, МакетФормата, ПроцедурыПерсонифицированногоУчета.ПолучитьИмяФайлаПФ(Ссылка, Год(ДатаЗаполнения), ВыборкаПоШапкеДокумента));
	
	// Добавляем реквизит ПачкаВходящихДокументов
	УзелПачкаВходящихДокументов = ПроцедурыПерсонифицированногоУчета.ЗаполнитьНаборЗаписейВходящаяОпись(УзелПФР, МакетФормата, "РЕЕСТР_ДСВ_РАБОТОДАТЕЛЬ", ВыборкаПоШапкеДокумента, КоличествоДокументов, НомерПачки, НомерДокументаВПачке,,,"ВХОДЯЩАЯ_ОПИСЬ_РЕЕСТРА");
	
	ФорматЗаявлениеДСВ = ПроцедурыПерсонифицированногоУчета.ЗагрузитьФорматНабораЗаписейдляПФР(МакетФормата, "РЕЕСТР_ДСВ_РАБОТОДАТЕЛЬ");
	
	ОписаниеРаботодателя = ПроцедурыПерсонифицированногоУчета.СкопироватьСтруктуруДанных(ФорматЗаявлениеДСВ.Работодатель.Значение);
	ПроцедурыПерсонифицированногоУчета.ЗаполнитьСоставительПачки(ОписаниеРаботодателя, ВыборкапоШапкеДокумента);
	
	Пока ВыборкаПоРаботникиОрганизации.Следующий()	Цикл
		
		ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоРаботникиОрганизации, Отказ ,Заголовок);
		
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		НомерДокументаВПачке = 	НомерДокументаВПачке + 1;
		
		НаборЗаписейЗаявлениеДСВ = ПроцедурыПерсонифицированногоУчета.СкопироватьСтруктуруДанных(ФорматЗаявлениеДСВ);
		
		НаборЗаписейЗаявлениеДСВ.НомерВпачке.Значение = НомерДокументаВПачке;
		НаборЗаписейЗаявлениеДСВ.СтраховойНомер.Значение = ВыборкаПоРаботникиОрганизации.СтраховойНомерПФР;
		
		НаборЗаписейФИО = НаборЗаписейЗаявлениеДСВ.ФИО.Значение;
		НаборЗаписейФИО.Фамилия = ВРег(СокрЛП(ВыборкаПоРаботникиОрганизации.Фамилия));
		НаборЗаписейФИО.Имя = ВРег(СокрЛП(ВыборкаПоРаботникиОрганизации.Имя));
		НаборЗаписейФИО.Отчество = ВРег(СокрЛП(ВыборкаПоРаботникиОрганизации.Отчество));
		
		НаборЗаписейЗаявлениеДСВ.Работодатель.Значение = ОписаниеРаботодателя;
		
		НаборЗаписейЗаявлениеДСВ.СуммаДСВРаботника.Значение = ВыборкаПоРаботникиОрганизации.ВзносыРаботника;
		НаборЗаписейЗаявлениеДСВ.СуммаДСВРаботодателя.Значение = ВыборкаПоРаботникиОрганизации.ВзносыРаботодателя;
		
		ПроцедурыПерсонифицированногоУчета.ДобавитьИнформациюВДерево(ПроцедурыПерсонифицированногоУчета.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "РЕЕСТР_ДСВ_РАБОТОДАТЕЛЬ",""), НаборЗаписейЗаявлениеДСВ);
		
	КонецЦикла;
	
	// Преобразуем дерево в строковое описание XML
	ТекстФайла = ПроцедурыПерсонифицированногоУчета.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки,  "Окружение=""В составе файла"" Стадия=""До обработки"" ДобровольныеПравоотношения=""ДСВ""");
	
	Возврат ТекстФайла;
	
КонецФункции // СформироватьВыходнойФайл()

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
	|	Реестр.Дата,
	|	Реестр.Номер,
	|	Реестр.Ссылка,
	|	Реестр.Организация.Код,
	|	ВЫБОР
	|		КОГДА Реестр.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоГоловнаяОрганизация,
	|	Реестр.Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ФорматФайлаПФР.Версия07) КАК ФорматФайла,
	|	Реестр.Организация.РегистрационныйНомерПФР,
	|	Реестр.Организация.Наименование,
	|	Реестр.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	Реестр.Организация.НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное,
	|	Реестр.Организация.ИНН,
	|	Реестр.Организация.КПП,
	|	Реестр.Организация.ЮрФизЛицо,
	|	Реестр.Организация.ОГРН,
	|	Реестр.Организация.НаименованиеОКОПФ,
	|	ИтоговыеДанныеРеестра.ВзносыРаботника + ИтоговыеДанныеРеестра.ВзносыРаботодателя КАК СуммаДСВОбщая,
	|	ИтоговыеДанныеРеестра.ВзносыРаботника КАК СуммаДСВРаботника,
	|	ИтоговыеДанныеРеестра.ВзносыРаботодателя КАК СуммаДСВРаботодателя,
	|	ИтоговыеДанныеРеестра.НомерСтроки КАК КоличествоСтрок,
	|	ГОД(Реестр.ПериодРегистрации) КАК Год,
	|	Реестр.НомерПлатежногоПоручения КАК НомерПоручения,
	|	Реестр.ДатаПлатежногоПоручения КАК ДатаПоручения,
	|	Реестр.ДатаИсполненияПлатежногоПоручения КАК ДатаИсполненияПоручения,
	|	Реестр.НомерПачки
	|ИЗ
	|	Документ.РеестрДСВ3 КАК Реестр
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СУММА(РеестрДСВ3РаботникиОрганизации.ВзносыРаботника) КАК ВзносыРаботника,
	|			СУММА(РеестрДСВ3РаботникиОрганизации.ВзносыРаботодателя) КАК ВзносыРаботодателя,
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ РеестрДСВ3РаботникиОрганизации.НомерСтроки) КАК НомерСтроки
	|		ИЗ
	|			Документ.РеестрДСВ3.РаботникиОрганизации КАК РеестрДСВ3РаботникиОрганизации
	|		ГДЕ
	|			РеестрДСВ3РаботникиОрганизации.Ссылка = &ДокументСсылка) КАК ИтоговыеДанныеРеестра
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Реестр.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Выбирает данные, необходимые для заполнения утвержденных форм как из спр-ка
//  физлиц, так и из соотв. регистров сведений
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоРаботникиОрганизации()
	
	Запрос = Новый Запрос;
    Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	Ссылка);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтрокиДокумента.Ссылка КАК Ссылка,
	|	СтрокиДокумента.НомерСтроки КАК НомерСтроки,
	|	СтрокиДокумента.ФизЛицо КАК ФизЛицо,
	|	СтрокиДокумента.Фамилия КАК Фамилия,
	|	СтрокиДокумента.Имя КАК Имя,
	|	СтрокиДокумента.Отчество КАК Отчество,
	|	СтрокиДокумента.ФизЛицо.Наименование КАК ФизЛицоНаименование,
	|	СтрокиДокумента.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	СтрокиДокумента.ВзносыРаботника,
	|	СтрокиДокумента.ВзносыРаботодателя
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	Документ.РеестрДСВ3.РаботникиОрганизации КАК СтрокиДокумента
	|ГДЕ
	|	СтрокиДокумента.Ссылка = &ДокументСсылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ФизЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиДокумента.Ссылка КАК Ссылка,
	|	СтрокиДокумента.НомерСтроки КАК НомерСтроки,
	|	СтрокиДокумента.ФизЛицо КАК ФизЛицо,
	|	СтрокиДокумента.Фамилия КАК Фамилия,
	|	СтрокиДокумента.Имя КАК Имя,
	|	СтрокиДокумента.Отчество КАК Отчество,
	|	СтрокиДокумента.ФизЛицоНаименование,
	|	СтрокиДокумента.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	МИНИМУМ(ПовторяющиесяСтроки.НомерСтроки) КАК НомерКонфликтнойСтроки,
	|	СтрокиДокумента.ВзносыРаботника,
	|	СтрокиДокумента.ВзносыРаботодателя
	|ИЗ
	|	ВТДанныеДокумента КАК СтрокиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеДокумента КАК ПовторяющиесяСтроки
	|		ПО СтрокиДокумента.ФизЛицо = ПовторяющиесяСтроки.ФизЛицо
	|			И СтрокиДокумента.НомерСтроки < ПовторяющиесяСтроки.НомерСтроки
	|
	|СГРУППИРОВАТЬ ПО
	|	СтрокиДокумента.Ссылка,
	|	СтрокиДокумента.НомерСтроки,
	|	СтрокиДокумента.ФизЛицо,
	|	СтрокиДокумента.Фамилия,
	|	СтрокиДокумента.Имя,
	|	СтрокиДокумента.Отчество,
	|	СтрокиДокумента.ФизЛицоНаименование,
	|	СтрокиДокумента.СтраховойНомерПФР,
	|	СтрокиДокумента.ВзносыРаботника,
	|	СтрокиДокумента.ВзносыРаботодателя";
		
	Возврат Запрос.Выполнить();
	
КонецФункции

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

	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.Организация) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана организация, которая подает сведения!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.НомерПоручения) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указан номер платежного поручения!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаПоручения) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана дата платежного поручения!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВыборкаПоШапкеДокумента.ДатаИсполненияПоручения) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не указана дата исполнения платежного поручения!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "РаботникиОрганизации" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определеной строке выборка 
//  							  из результата запроса по работникам, 
//  Отказ 						- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиРаботникаОрганизации(ВыборкаПоСтрокамДокумента, Отказ ,Заголовок)
	
	СтрокаНачалаСообщенияОбОшибке = "В строке № "+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) + " табл. части: ";
	
	// ФизЛицо
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ФизЛицо) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не выбран сотрудник!", Отказ ,Заголовок);
	Иначе	
		
		СтрокаНачалаСообщенияОбОшибке = СтрокаНачалаСообщенияОбОшибке + " по сотруднику " + ВыборкаПоСтрокамДокумента.ФизЛицоНаименование + " ";
		
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Фамилия) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не задана фамилия!", Отказ ,Заголовок);
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Имя) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не задано имя!", Отказ ,Заголовок);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.НомерКонфликтнойСтроки) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Указанный сотрудник повторяется в строке " + ВыборкаПоСтрокамДокумента.НомерКонфликтнойСтроки + "!", Отказ ,Заголовок);
		КонецЕсли;
	КонецЕсли;

	СтраховойНомерПФР = ВыборкаПоСтрокамДокумента.СтраховойНомерПФР;
	Если Не ЗначениеЗаполнено(СтраховойНомерПФР) тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не указан страховой номер!", Отказ, Заголовок);
		
	ИначеЕсли Не РегламентированнаяОтчетность.СтраховойНомерПФРСоответствуетТребованиям(СтраховойНомерПФР) тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Задан неверный страховой номер!", Отказ, Заголовок);
		
	КонецЕсли;
	
	Если ВыборкаПоСтрокамДокумента.ВзносыРаботника = 0 И ВыборкаПоСтрокамДокумента.ВзносыРаботодателя = 0 Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "- Не указаны суммы дополнительных взносов!", Отказ, Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеСтрокиРаботникаОрганизации()

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

		Если Отказ Тогда
			ОбработкаКомментариев.ПоказатьСообщения();
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	//При проведении файл формируем заново 
	ТекстФайла = СформироватьВыходнойФайл(Отказ);
	
	ОбработкаКомментариев.ПоказатьСообщения();
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	//Сохраним сформированный файл сведений в регистре сведений
	Запись = Движения.АрхивДанныхРегламентированнойОтчетности.Добавить();
	Запись.Объект = Ссылка;
	Запись.ОписаниеДанных = "Файл-пачка форм ДСВ-3";
	Запись.Данные = ТекстФайла;
	
КонецПроцедуры	

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроцедурыПерсонифицированногоУчета.ПроставитьНомерПачки(ЭтотОбъект);
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(РаботникиОрганизации);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Физлицо");
	Если ФорматФайла.Пустая() Тогда
		ФорматФайла = Перечисления.ФорматФайлаПФР.Версия07
	КонецЕсли;
	
КонецПроцедуры



