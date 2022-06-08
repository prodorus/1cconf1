﻿
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБРАБОТКИ

Функция Автозаполнение() Экспорт

	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(НалоговыйПериод) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	МассивКодов = Новый Массив;
	МассивКодов.Добавить("");
	МассивКодов.Добавить("           ");
	Запрос.УстановитьПараметр("ПустыеКоды",МассивКодов);
	Запрос.УстановитьПараметр("ПустойКодКороткий","");
	Запрос.УстановитьПараметр("КодОрганизации", ОбщегоНазначенияЗК.ПолучитьЗначениеРеквизита(Организация, "КодПоОКТМО"));
	Запрос.УстановитьПараметр("ПустойКодДлинный","           ");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("НалоговыйПериод", НалоговыйПериод);
	Запрос.УстановитьПараметр("НачалоПериода", Дата(НалоговыйПериод, 1, 1));
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецГода(Дата(НалоговыйПериод, 1, 1)));
	Запрос.Текст =
    "ВЫБРАТЬ
    |	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка) КАК Подразделение,
    |	&КодОрганизации КАК КодПоОКТМО
    |ПОМЕСТИТЬ ВТКодыСправочников
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |	ПодразделенияОрганизаций.Ссылка,
    |	ПодразделенияОрганизаций.КодПоОКТМО
    |ИЗ
    |	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
    |ГДЕ
    |	НЕ ПодразделенияОрганизаций.КодПоОКТМО В (ЕСТЬNULL(ПодразделенияОрганизаций.Родитель.КодПоОКТМО, &ПустойКодКороткий), &КодОрганизации, &ПустойКодКороткий, &ПустойКодДлинный)
    |	И ПодразделенияОрганизаций.Владелец = &Организация
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ РАЗРЕШЕННЫЕ
    |	НДФЛСведенияОДоходах.КодПоОКТМО
    |ПОМЕСТИТЬ ВТДанныеУчета
    |ИЗ
    |	РегистрНакопления.НДФЛСведенияОДоходах КАК НДФЛСведенияОДоходах
    |ГДЕ
    |	НДФЛСведенияОДоходах.Организация = &ГоловнаяОрганизация
    |	И НДФЛСведенияОДоходах.ОбособленноеПодразделение = &Организация
    |	И НДФЛСведенияОДоходах.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
    |	И НЕ НДФЛСведенияОДоходах.КодПоОКТМО В (&ПустыеКоды)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |	НДФЛРасчетыСБюджетом.КодПоОКТМО
    |ИЗ
    |	РегистрНакопления.НДФЛРасчетыСБюджетом КАК НДФЛРасчетыСБюджетом
    |ГДЕ
    |	НДФЛРасчетыСБюджетом.Организация = &ГоловнаяОрганизация
    |	И НДФЛРасчетыСБюджетом.ОбособленноеПодразделение = &Организация
    |	И НДФЛРасчетыСБюджетом.МесяцНалоговогоПериода МЕЖДУ &НачалоПериода И &ОкончаниеПериода
    |	И НЕ НДФЛРасчетыСБюджетом.КодПоОКТМО В (&ПустыеКоды)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |	НДФЛИмущественныеВычетыФизлиц.КодПоОКТМО
    |ИЗ
    |	РегистрНакопления.НДФЛИмущественныеВычетыФизлиц КАК НДФЛИмущественныеВычетыФизлиц
    |ГДЕ
    |	НДФЛИмущественныеВычетыФизлиц.Организация = &ГоловнаяОрганизация
    |	И НДФЛИмущественныеВычетыФизлиц.ОбособленноеПодразделение = &Организация
    |	И НДФЛИмущественныеВычетыФизлиц.Год = &НалоговыйПериод
    |	И НЕ НДФЛИмущественныеВычетыФизлиц.КодПоОКТМО В (&ПустыеКоды)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКТМО
    |ИЗ
    |	РегистрНакопления.НДФЛПредоставленныеСтандартныеВычетыФизЛиц КАК НДФЛПредоставленныеСтандартныеВычетыФизЛиц
    |ГДЕ
    |	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Организация = &ГоловнаяОрганизация
    |	И НДФЛПредоставленныеСтандартныеВычетыФизЛиц.ОбособленноеПодразделение = &Организация
    |	И НДФЛПредоставленныеСтандартныеВычетыФизЛиц.МесяцНалоговогоПериода МЕЖДУ &НачалоПериода И &ОкончаниеПериода
    |	И НЕ НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКТМО В (&ПустыеКоды)
    |
    |ОБЪЕДИНИТЬ ВСЕ
    |
    |ВЫБРАТЬ
    |	ПОДСТРОКА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП, 1, 11)
    |ИЗ
    |	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
    |ГДЕ
    |	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Организация = &Организация
    |	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода МЕЖДУ &НачалоПериода И &ОкончаниеПериода
    |	И НЕ ПОДСТРОКА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП, 1, 11) В (&ПустыеКоды)
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ РАЗЛИЧНЫЕ
    |	КодыСправочников.КодПоОКТМО
    |ПОМЕСТИТЬ ВТВсеКоды
    |ИЗ
    |	ВТКодыСправочников КАК КодыСправочников
    |
    |ОБЪЕДИНИТЬ
    |
    |ВЫБРАТЬ РАЗЛИЧНЫЕ
    |	ДанныеУчета.КодПоОКТМО
    |ИЗ
    |	ВТДанныеУчета КАК ДанныеУчета
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |	ВсеКоды.КодПоОКТМО КАК КодВУчете,
    |	ЛОЖЬ КАК Отметка,
    |	МАКСИМУМ(КодыСправочников.Подразделение.Наименование) КАК Описание
    |ИЗ
    |	ВТВсеКоды КАК ВсеКоды
    |		ЛЕВОЕ СОЕДИНЕНИЕ ВТКодыСправочников КАК КодыСправочников
    |		ПО ВсеКоды.КодПоОКТМО = КодыСправочников.КодПоОКТМО
    |
    |СГРУППИРОВАТЬ ПО
    |	ВсеКоды.КодПоОКТМО
    |
    |УПОРЯДОЧИТЬ ПО
    |	Описание";
	
	МассивЗапросов = Новый Массив;
	#Если ТолстыйКлиентОбычноеПриложение тогда
	ФормированиеПечатныхФорм.ЗапомнитьПараметрыЗапроса(Запрос, МассивЗапросов);
	#КонецЕсли
	Попытка
	
		Результаты = Запрос.ВыполнитьПакет();
	
	Исключение
		#Если ТолстыйКлиентОбычноеПриложение тогда
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ПроверитьОшибкуЗапрос(МассивЗапросов, ИнформацияОбОшибке);
		#КонецЕсли
		Возврат Ложь;
	КонецПопытки;

	ТаблицаКодовОКТМО.Загрузить(Результаты[3].Выгрузить());
	
	Возврат Истина;
	
КонецФункции

Процедура ОбновитьДанные(Форма = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Организация) Или Не ЗначениеЗаполнено(НалоговыйПериод) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	МассивКодов = Новый Массив;
	МассивКодов.Добавить("");
	МассивКодов.Добавить("           ");
	Запрос.УстановитьПараметр("ПустыеКоды",МассивКодов);
	Запрос.УстановитьПараметр("ТаблицаСоответствияКодов", ТаблицаКодовОКТМО);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ОбщегоНазначенияЗК.ГоловнаяОрганизация(Организация));
	Запрос.УстановитьПараметр("НалоговыйПериод", НалоговыйПериод);
	Запрос.УстановитьПараметр("НачалоПериода", Дата(НалоговыйПериод, 1, 1));
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецГода(Дата(НалоговыйПериод, 1, 1)));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСоответствияКодов.НовыйКод КАК НовыйКодПоОКТМО,
	|	ТаблицаСоответствияКодов.КодВУчете КАК СтарыйКодПоОКТМО
	|ПОМЕСТИТЬ ВТТаблицаСоответствияКодов
	|ИЗ
	|	&ТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|ГДЕ
	|	ТаблицаСоответствияКодов.Отметка
	|	И НЕ ТаблицаСоответствияКодов.НовыйКод В (&ПустыеКоды)";
	Запрос.Выполнить();
	
	Если ПравоДоступа("Изменение", Метаданные.Справочники.Организации) Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка КАК Ссылка,
		|	ТаблицаОрганизаций.НовыйКодПоОКТМО КАК КодПоОКТМО
		|ИЗ
		|	Справочник.Организации КАК Организации
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаОрганизаций
		|		ПО Организации.КодПоОКТМО = ТаблицаОрганизаций.СтарыйКодПоОКТМО
		|ГДЕ
		|	Организации.Ссылка = &Организация
		|	И ТаблицаОрганизаций.НовыйКодПоОКТМО ЕСТЬ НЕ NULL ";
	
		ОбновитьОбъектыПоЗапросу(Запрос, "Организации", Форма);
		
	КонецЕсли;
	
	Если ПравоДоступа("Изменение", Метаданные.Справочники.ПодразделенияОрганизаций) Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПодразделенияОрганизаций.Ссылка,
		|	ТаблицаСоответствияКодов.НовыйКодПоОКТМО КАК КодПоОКТМО
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
		|		ПО ПодразделенияОрганизаций.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
		|ГДЕ
		|	ПодразделенияОрганизаций.Владелец = &Организация
		|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL ";
		
		ОбновитьОбъектыПоЗапросу(Запрос, "Подразделения", Форма);
		
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДФЛСведенияОДоходах.Регистратор
	|ПОМЕСТИТЬ ВТРегистраторы
	|ИЗ
	|	РегистрНакопления.НДФЛСведенияОДоходах КАК НДФЛСведенияОДоходах
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛСведенияОДоходах.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛСведенияОДоходах.Организация = &ГоловнаяОрганизация
	|	И НДФЛСведенияОДоходах.ОбособленноеПодразделение = &Организация
	|	И НДФЛСведенияОДоходах.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДФЛРасчетыСБюджетом.Регистратор
	|ИЗ
	|	РегистрНакопления.НДФЛРасчетыСБюджетом КАК НДФЛРасчетыСБюджетом
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛРасчетыСБюджетом.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛРасчетыСБюджетом.Организация = &ГоловнаяОрганизация
	|	И НДФЛРасчетыСБюджетом.ОбособленноеПодразделение = &Организация
	|	И НДФЛРасчетыСБюджетом.МесяцНалоговогоПериода МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДФЛИмущественныеВычетыФизлиц.Регистратор
	|ИЗ
	|	РегистрНакопления.НДФЛИмущественныеВычетыФизлиц КАК НДФЛИмущественныеВычетыФизлиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛИмущественныеВычетыФизлиц.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛИмущественныеВычетыФизлиц.Организация = &ГоловнаяОрганизация
	|	И НДФЛИмущественныеВычетыФизлиц.ОбособленноеПодразделение = &Организация
	|	И НДФЛИмущественныеВычетыФизлиц.Год = &НалоговыйПериод
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Регистратор
	|ИЗ
	|	РегистрНакопления.НДФЛПредоставленныеСтандартныеВычетыФизЛиц КАК НДФЛПредоставленныеСтандартныеВычетыФизЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Организация = &ГоловнаяОрганизация
	|	И НДФЛПредоставленныеСтандартныеВычетыФизЛиц.ОбособленноеПодразделение = &Организация
	|	И НДФЛПредоставленныеСтандартныеВычетыФизЛиц.МесяцНалоговогоПериода МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО (ПОДСТРОКА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП, 1, 11) = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО)
	|ГДЕ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Организация = &Организация
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Регистраторы.Регистратор КАК Документ
	|ПОМЕСТИТЬ ВТРегистраторыКОбработке
	|ИЗ
	|	ВТРегистраторы КАК Регистраторы";
    Результат = Запрос.Выполнить().Выгрузить();
	Если Результат[0].Количество = 0 Тогда // количество документов к обработке
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			ОбновитьИнформационнуюСтроку(Форма, "Обработка выбранных кодов ОКТМО завершена.");
		#КонецЕсли
		Возврат 
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПеречислениеНДФЛвБюджет.Ссылка,
	|	ТаблицаСоответствияКодов.НовыйКодПоОКТМО + ПОДСТРОКА(ПеречислениеНДФЛвБюджет.ОКТМО_КПП, 12, 10) КАК ОКТМО_КПП
	|ИЗ
	|	Документ.ПеречислениеНДФЛвБюджет КАК ПеречислениеНДФЛвБюджет
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО (ПОДСТРОКА(ПеречислениеНДФЛвБюджет.ОКТМО_КПП, 1, 11) = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО)
	|ГДЕ
	|	ПеречислениеНДФЛвБюджет.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СправкаПоНДФЛВНалоговыйОрган.Ссылка,
	|	ТаблицаСоответствияКодов.НовыйКодПоОКТМО + ПОДСТРОКА(СправкаПоНДФЛВНалоговыйОрган.ОКТМО_КПП, 12, 10)
	|ИЗ
	|	Документ.СправкаПоНДФЛВНалоговыйОрган КАК СправкаПоНДФЛВНалоговыйОрган
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО (ПОДСТРОКА(СправкаПоНДФЛВНалоговыйОрган.ОКТМО_КПП, 1, 11) = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО)
	|ГДЕ
	|	СправкаПоНДФЛВНалоговыйОрган.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|	И ТаблицаСоответствияКодов.НовыйКодПоОКТМО ЕСТЬ НЕ NULL";
	ОбновитьОбъектыПоЗапросу(Запрос, "Документы по перечислению НДФЛ", Форма);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛСведенияОДоходах.Период,
	|	НДФЛСведенияОДоходах.Регистратор КАК Регистратор,
	|	НДФЛСведенияОДоходах.НомерСтроки КАК НомерСтроки,
	|	НДФЛСведенияОДоходах.Активность,
	|	НДФЛСведенияОДоходах.Организация,
	|	НДФЛСведенияОДоходах.ФизЛицо,
	|	НДФЛСведенияОДоходах.КодДохода,
	|	НДФЛСведенияОДоходах.ПериодРегистрации,
	|	НДФЛСведенияОДоходах.СуммаДохода,
	|	НДФЛСведенияОДоходах.СуммаВычета,
	|	НДФЛСведенияОДоходах.КодВычета,
	|	НДФЛСведенияОДоходах.ОбособленноеПодразделение,
	|	НДФЛСведенияОДоходах.ИсчисленоИзЗарплаты,
	|	НДФЛСведенияОДоходах.КодПоОКАТО,
	|	НДФЛСведенияОДоходах.КПП,
	|	НДФЛСведенияОДоходах.ПодразделениеОрганизации,
	|	НДФЛСведенияОДоходах.КоличествоДетей,
	|	НДФЛСведенияОДоходах.ВидРасчета,
	|	НДФЛСведенияОДоходах.ЗарегистрированоДляПромежуточногоРасчета,
	|	НДФЛСведенияОДоходах.ДатаПолученияДохода,
	|	ВЫБОР
	|		КОГДА НДФЛСведенияОДоходах.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛСведенияОДоходах.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО, *
	|ИЗ
	|	РегистрНакопления.НДФЛСведенияОДоходах КАК НДФЛСведенияОДоходах
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛСведенияОДоходах.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛСведенияОДоходах.Регистратор В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	ПереписатьНаборыЗаписейПоРегистраторам(РегистрыНакопления.НДФЛСведенияОДоходах, Запрос, "Данные о доходах", Форма);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛРасчетыСБюджетом.Период,
	|	НДФЛРасчетыСБюджетом.Регистратор КАК Регистратор,
	|	НДФЛРасчетыСБюджетом.НомерСтроки КАК НомерСтроки,
	|	НДФЛРасчетыСБюджетом.Активность,
	|	НДФЛРасчетыСБюджетом.ВидДвижения,
	|	НДФЛРасчетыСБюджетом.ФизЛицо,
	|	НДФЛРасчетыСБюджетом.Организация,
	|	НДФЛРасчетыСБюджетом.СтавкаНалогообложенияРезидента,
	|	НДФЛРасчетыСБюджетом.МесяцНалоговогоПериода,
	|	НДФЛРасчетыСБюджетом.Налог,
	|	НДФЛРасчетыСБюджетом.ОбособленноеПодразделение,
	|	НДФЛРасчетыСБюджетом.ВидСтроки,
	|	НДФЛРасчетыСБюджетом.ИсчисленоИзЗарплаты,
	|	НДФЛРасчетыСБюджетом.КодПоОКАТО,
	|	НДФЛРасчетыСБюджетом.КПП,
	|	НДФЛРасчетыСБюджетом.ПодразделениеОрганизации,
	|	НДФЛРасчетыСБюджетом.КодДохода,
	|	ВЫБОР
	|		КОГДА НДФЛРасчетыСБюджетом.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛРасчетыСБюджетом.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО, *
	|ИЗ
	|	РегистрНакопления.НДФЛРасчетыСБюджетом КАК НДФЛРасчетыСБюджетом
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛРасчетыСБюджетом.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛРасчетыСБюджетом.Регистратор В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	ПереписатьНаборыЗаписейПоРегистраторам(РегистрыНакопления.НДФЛРасчетыСБюджетом, Запрос, "Данные о начисленном (удержанном) налоге", Форма);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Период,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Регистратор КАК Регистратор,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.НомерСтроки КАК НомерСтроки,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Активность,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.ФизЛицо,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Организация,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.МесяцНалоговогоПериода,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодВычета,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.ПримененныйВычет,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКАТО,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КПП,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.ОбособленноеПодразделение,
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО
	|ИЗ
	|	РегистрНакопления.НДФЛПредоставленныеСтандартныеВычетыФизЛиц КАК НДФЛПредоставленныеСтандартныеВычетыФизЛиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛПредоставленныеСтандартныеВычетыФизЛиц.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛПредоставленныеСтандартныеВычетыФизЛиц.Регистратор В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	ПереписатьНаборыЗаписейПоРегистраторам(РегистрыНакопления.НДФЛПредоставленныеСтандартныеВычетыФизЛиц, Запрос, "Данные о вычетах", Форма);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛИмущественныеВычетыФизлиц.Период,
	|	НДФЛИмущественныеВычетыФизлиц.Регистратор КАК Регистратор,
	|	НДФЛИмущественныеВычетыФизлиц.НомерСтроки КАК НомерСтроки,
	|	НДФЛИмущественныеВычетыФизлиц.Активность,
	|	НДФЛИмущественныеВычетыФизлиц.ВидДвижения,
	|	НДФЛИмущественныеВычетыФизлиц.ФизЛицо,
	|	НДФЛИмущественныеВычетыФизлиц.Организация,
	|	НДФЛИмущественныеВычетыФизлиц.КодВычетаИмущественный,
	|	НДФЛИмущественныеВычетыФизлиц.Год,
	|	НДФЛИмущественныеВычетыФизлиц.Размер,
	|	НДФЛИмущественныеВычетыФизлиц.КодПоОКАТО,
	|	НДФЛИмущественныеВычетыФизлиц.КПП,
	|	НДФЛИмущественныеВычетыФизлиц.ОбособленноеПодразделение,
	|	НДФЛИмущественныеВычетыФизлиц.ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА НДФЛИмущественныеВычетыФизлиц.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛИмущественныеВычетыФизлиц.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО
	|ИЗ
	|	РегистрНакопления.НДФЛИмущественныеВычетыФизлиц КАК НДФЛИмущественныеВычетыФизлиц
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛИмущественныеВычетыФизлиц.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛИмущественныеВычетыФизлиц.Регистратор В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	ПереписатьНаборыЗаписейПоРегистраторам(РегистрыНакопления.НДФЛИмущественныеВычетыФизлиц, Запрос, "Данные о вычетах", Форма);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Период,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор КАК Регистратор,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.НомерСтроки КАК НомерСтроки,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Активность,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ВидДвижения,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ФизЛицо,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Организация,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Ставка,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКАТО_КПП,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП, 1, 11) = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО + ПОДСТРОКА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП, 12, 10)
	|		ИНАЧЕ РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП
	|	КОНЕЦ КАК ОКТМО_КПП,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО (ПОДСТРОКА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ОКТМО_КПП, 1, 11) = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО)
	|ГДЕ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор,
	|	НомерСтроки";
	ПереписатьНаборыЗаписейПоРегистраторам(РегистрыНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ, Запрос, "Данные об уплаченном налоге", Форма);	
	
	ИзмененныеДокументы = Новый Соответствие;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛВозвратНалогаРаботникиОрганизации.Ссылка,
	|	НДФЛВозвратНалогаРаботникиОрганизации.НомерСтроки,
	|	НДФЛВозвратНалогаРаботникиОрганизации.ФизЛицо,
	|	НДФЛВозвратНалогаРаботникиОрганизации.СуммаВозвратаПоСтавке13,
	|	НДФЛВозвратНалогаРаботникиОрганизации.СуммаВозвратаПоСтавке09,
	|	НДФЛВозвратНалогаРаботникиОрганизации.СуммаВозвратаПоСтавке35,
	|	НДФЛВозвратНалогаРаботникиОрганизации.КодПоОКАТО,
	|	НДФЛВозвратНалогаРаботникиОрганизации.КПП,
	|	ВЫБОР
	|		КОГДА НДФЛВозвратНалогаРаботникиОрганизации.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛВозвратНалогаРаботникиОрганизации.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО, *
	|ИЗ
	|	Документ.НДФЛВозвратНалога.РаботникиОрганизации КАК НДФЛВозвратНалогаРаботникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛВозвратНалогаРаботникиОрганизации.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛВозвратНалогаРаботникиОрганизации.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НДФЛВозвратНалогаРаботникиОрганизации.Ссылка,
	|	НДФЛВозвратНалогаРаботникиОрганизации.НомерСтроки";
	ОбновитьТабличнуюЧастьОбъектаПоЗапросу(Запрос, "РаботникиОрганизации", "Документы на возврат налога", ИзмененныеДокументы, Форма);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.НомерСтроки,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.ФизЛицо,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.ДатаДохода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.МесяцНалоговогоПериода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.ПериодРегистрации,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КодДохода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.СуммаДохода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КодВычета,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.СуммаВычета,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.СуммаНалогаИсчисленная,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КПП,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КодПоОКАТО,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КоличествоДетей,
	|	ВЫБОР
	|		КОГДА НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО, *
	|ИЗ
	|	Документ.НДФЛиЕСНДоходыИНалоги.НДФЛСведенияОДоходах КАК НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛСведенияОДоходах.НомерСтроки";
	ОбновитьТабличнуюЧастьОбъектаПоЗапросу(Запрос, "НДФЛСведенияОДоходах", "Документы корректировки НДФЛ", ИзмененныеДокументы, Форма);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.НомерСтроки,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.ФизЛицо,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.ПериодРегистрации,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.МесяцНалоговогоПериода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.Налог,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.КодПоОКАТО,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.КПП,
	|	ВЫБОР
	|		КОГДА НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО, *
	|ИЗ
	|	Документ.НДФЛиЕСНДоходыИНалоги.НДФЛИсчисленный13 КАК НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛИсчисленный13.НомерСтроки";
	ОбновитьТабличнуюЧастьОбъектаПоЗапросу(Запрос, "НДФЛИсчисленный13", "Документы корректировки", ИзмененныеДокументы, Форма);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.НомерСтроки,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.ФизЛицо,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.ПериодРегистрации,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.МесяцНалоговогоПериода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.КодВычета,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.ПримененныйВычет,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.КодПоОКАТО,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.КПП,
	|	ВЫБОР
	|		КОГДА НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО
	|ИЗ
	|	Документ.НДФЛиЕСНДоходыИНалоги.НДФЛПредоставленныеВычеты КАК НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛПредоставленныеВычеты.НомерСтроки";
	ОбновитьТабличнуюЧастьОбъектаПоЗапросу(Запрос, "НДФЛПредоставленныеВычеты", "Документы корректировки", ИзмененныеДокументы, Форма);

	Запрос.Текст =
	"ВЫБРАТЬ
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.НомерСтроки,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.ФизЛицо,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.ПериодРегистрации,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.МесяцНалоговогоПериода,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.СтавкаНалогообложения,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.Налог,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.КодПоОКАТО,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.КПП,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.КодДохода,
	|	ВЫБОР
	|		КОГДА НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|			ТОГДА ТаблицаСоответствияКодов.НовыйКодПоОКТМО
	|		ИНАЧЕ НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.КодПоОКТМО
	|	КОНЕЦ КАК КодПоОКТМО, *
	|ИЗ
	|	Документ.НДФЛиЕСНДоходыИНалоги.НДФЛУдержанный КАК НДФЛиЕСНДоходыИНалогиНДФЛУдержанный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСоответствияКодов КАК ТаблицаСоответствияКодов
	|		ПО НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.КодПоОКТМО = ТаблицаСоответствияКодов.СтарыйКодПоОКТМО
	|ГДЕ
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.Ссылка В
	|			(ВЫБРАТЬ
	|				РегистраторыКОбработке.Документ
	|			ИЗ
	|				ВТРегистраторыКОбработке КАК РегистраторыКОбработке)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.Ссылка,
	|	НДФЛиЕСНДоходыИНалогиНДФЛУдержанный.НомерСтроки";
	ОбновитьТабличнуюЧастьОбъектаПоЗапросу(Запрос, "НДФЛУдержанный", "Документы корректировки", ИзмененныеДокументы, Форма);
	
	ТекстСообщения = "Запись документов";
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВсегоДоков = ИзмененныеДокументы.Количество();
		Номер = 1;
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано 0 из " + ВсегоДоков);
	#КонецЕсли
	Для каждого Элемент Из ИзмененныеДокументы Цикл
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			Если Номер % 30 = 0 Тогда
				ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + Номер + " из " + ВсегоДоков);
			КонецЕсли;
			Номер = Номер + 1;
		#КонецЕсли
		Элемент.Значение.Записать();
	КонецЦикла;
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ОбновитьИнформационнуюСтроку(Форма, "Обработка выбранных кодов ОКТМО завершена.");
	#КонецЕсли
	
КонецПроцедуры

Процедура ОбновитьОбъектыПоЗапросу(Запрос, ТекстСообщения, Форма = Неопределено) 

	Если Запрос = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": подготовка данных ...");
	#КонецЕсли
	ВыборкаОбъектов = Запрос.Выполнить().Выбрать();
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВсегоДоков = ВыборкаОбъектов.Количество();
		Номер = 1;
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано 0 из " + ВсегоДоков);
	#КонецЕсли
	Пока ВыборкаОбъектов.Следующий() Цикл
		Объект = ВыборкаОбъектов.Ссылка.ПолучитьОбъект();
		Объект.ОбменДанными.Загрузка = Истина;
		ЗаполнитьЗначенияСвойств(Объект,ВыборкаОбъектов);
		#Если ТолстыйКлиентОбычноеПриложение Тогда
			Если Номер % 30 = 0 Тогда
				ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + Номер + " из " + ВсегоДоков);
			КонецЕсли;
			Номер = Номер + 1;
		#КонецЕсли
		Объект.Записать();
	КонецЦикла;
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + ВсегоДоков + " из " + ВсегоДоков);
	#КонецЕсли
	
КонецПроцедуры

// Переписывает реквизиты некоторых строк табличной части исправляемых объектов.
//
// Параметры: 
//  Запрос - исполняемый запрос, в котором обязательно присутствуют поля Ссылка и НомерСтроки
//			 остальные поля должны содержать исправленные данные, имена полей 
//           должны соответствовать именам исправляемых реквизитов;
//           кроме того, результат запроса должен быть упорядочен по полю Ссылка
//  ИмяТЧ - строка, имя табличной части объекта
//  ТекстСообщения - строка, начало сообщения, выводимого в строке состояния
//
// Возвращаемое значение:
//  Нет
//
Процедура ОбновитьТабличнуюЧастьОбъектаПоЗапросу(Запрос, ИмяТЧ, ТекстСообщения, ИзмененныеДокументы, Форма = Неопределено) 

	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": подготовка данных ...");
	#КонецЕсли
	ВыборкаОбъектов = Запрос.Выполнить().Выбрать();
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВсегоДоков = ВыборкаОбъектов.Количество();
		Номер = 1;
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано 0 из " + ВсегоДоков);
	#КонецЕсли

	Пока ВыборкаОбъектов.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Объект = ИзмененныеДокументы[ВыборкаОбъектов.Ссылка];
		Если Объект = Неопределено Тогда
			Объект = ВыборкаОбъектов.Ссылка.ПолучитьОбъект();
			Объект.ОбменДанными.Загрузка = Истина;
		    ИзмененныеДокументы.Вставить(ВыборкаОбъектов.Ссылка, Объект)
		КонецЕсли;
		
		Объект[ИмяТЧ].Очистить();
		Пока ВыборкаОбъектов.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект[ИмяТЧ].Добавить(), ВыборкаОбъектов);
			#Если ТолстыйКлиентОбычноеПриложение Тогда
				Если Номер % 30 = 0 Тогда
					ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + Номер + " из " + ВсегоДоков);
				КонецЕсли;
				Номер = Номер + 1;
			#КонецЕсли
		КонецЦикла;
		
	КонецЦикла;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + ВсегоДоков + " из " + ВсегоДоков);
	#КонецЕсли
	
КонецПроцедуры

// Перезаполняет наборы записей регистраторов исправленными данными и записывает их.
//
// Параметры: 
//  МенеджерРегистра - Регистр<Сведений,...>Менеджер.<Имя> - менеджер переписываемого регистра
//  Запрос - исполняемый запрос, в котором обязательно присутствует поле Регистратор
//			 остальные поля должны соответствовать полям записи заполняемого регистра;
//			 кроме того, результат запроса должен быть упорядочен, 
//			 первое поле упорядочивания - Регистратор
//  ТекстЗаголовка - строка, начало сообщения, выводимого в строке состояния
//
// Возвращаемое значение:
//  Нет
//
Процедура ПереписатьНаборыЗаписейПоРегистраторам(МенеджерРегистра, Запрос, ТекстЗаголовка, Форма = Неопределено) 

	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ТекстСообщения = ТекстЗаголовка;
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": подготовка данных ...");
	#КонецЕсли
	ВыборкаРегистраторов = Запрос.Выполнить().Выбрать();
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ВсегоДоков = ВыборкаРегистраторов.Количество();
		Номер = 1;
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано 0 из " + ВсегоДоков);
	#КонецЕсли
	Пока ВыборкаРегистраторов.СледующийПоЗначениюПоля("Регистратор") Цикл
		НаборЗаписей = МенеджерРегистра.СоздатьНаборЗаписей();
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегистраторов.Регистратор);
		Пока ВыборкаРегистраторов.Следующий() Цикл
		    ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(),ВыборкаРегистраторов);
			#Если ТолстыйКлиентОбычноеПриложение Тогда
				Если Номер % 30 = 0 Тогда
					ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + Номер + " из " + ВсегоДоков);
				КонецЕсли;
				Номер = Номер + 1;
			#КонецЕсли
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецЦикла;
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения + ": обработано " + ВсегоДоков + " из " + ВсегоДоков);
	#КонецЕсли
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

Процедура ПроверитьОшибкуЗапрос(Запрос, ИнформацияОбОшибке) 
	                                                                        
	Если Не (ПолныеПрава.ИспользуетсяОграниченияПравДоступаНаУровнеЗаписей() И ПолныеПрава.ОшибкаДоступа(Запрос)) Тогда
		ОбщегоНазначенияЗК.ПоказатьДиалогСИнформациейОбОшибке(ИнформацияОбОшибке);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьИнформационнуюСтроку(Форма, ТекстСообщения = "", ВажностьСообщения = "Информация")  Экспорт
	
	Если Форма = Неопределено Тогда
		Состояние(ТекстСообщения);
	Иначе
		
		ЭлементыФормы = Форма.ЭлементыФормы;
		
		ВидимостьСообщения = ЗначениеЗаполнено(ТекстСообщения); 
		ЭлементыФормы.НадписьИнформацияОРезультатах.Видимость = ВидимостьСообщения;
		ЭлементыФормы.ПолеКартинкиИнформацияОРезультатах.Видимость = ВидимостьСообщения;
		Если ВидимостьСообщения Тогда
			РаботаСДиалогамиЗК.ПоказатьИнформациюОДокументе(ЭлементыФормы.НадписьИнформацияОРезультатах, ЭлементыФормы.ПолеКартинкиИнформацияОРезультатах, ТекстСообщения, ВажностьСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
#КонецЕсли

