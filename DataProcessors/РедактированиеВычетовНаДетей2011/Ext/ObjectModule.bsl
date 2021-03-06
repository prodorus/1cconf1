
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ МЕТОДЫ

Процедура Заполнение() Экспорт 

	СотрудникиСДетьми.Очистить();
	ВычетыСотрудниковСДетьми.Очистить();
	НовыеВычетыСотрудниковСДетьми.Очистить();
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат
	КонецЕсли;	

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаАктуальности", Дата(2011,1,1));
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДФЛПрименениеВычетовСрезПоследних.Физлицо
	|ПОМЕСТИТЬ ВТФизлица
	|ИЗ
	|	РегистрСведений.НДФЛПрименениеВычетов.СрезПоследних(&ДатаАктуальности, ) КАК НДФЛПрименениеВычетовСрезПоследних
	|ГДЕ
	|	НДФЛПрименениеВычетовСрезПоследних.Организация = &Организация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДФЛПрименениеВычетов.Физлицо
	|ИЗ
	|	РегистрСведений.НДФЛПрименениеВычетов КАК НДФЛПрименениеВычетов
	|ГДЕ
	|	НДФЛПрименениеВычетов.Организация = &Организация
	|	И НДФЛПрименениеВычетов.Период >= &ДатаАктуальности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.Период,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.Физлицо,
	|	НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета,
	|	ВЫБОР
	|		КОГДА НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код101)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код102)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код111)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьЗаменяемыеВычеты,
	|	ВЫБОР
	|		КОГДА НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код115)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код119)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетейСрезПоследних.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код123)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЕстьНовыеВычеты
	|ПОМЕСТИТЬ ВТСтрокиРегистра
	|ИЗ
	|	РегистрСведений.НДФЛСтандартныеВычетыНаДетей.СрезПоследних(
	|			&ДатаАктуальности,
	|			Физлицо В
	|				(ВЫБРАТЬ
	|					Физлица.Физлицо
	|				ИЗ
	|					ВТФизлица КАК Физлица)) КАК НДФЛСтандартныеВычетыНаДетейСрезПоследних
	|ГДЕ
	|	ВЫБОР
	|			КОГДА НДФЛСтандартныеВычетыНаДетейСрезПоследних.ПериодЗавершения <= &ДатаАктуальности
	|					И НДФЛСтандартныеВычетыНаДетейСрезПоследних.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА НДФЛСтандартныеВычетыНаДетейСрезПоследних.КоличествоДетейЗавершения
	|			ИНАЧЕ НДФЛСтандартныеВычетыНаДетейСрезПоследних.КоличествоДетей
	|		КОНЕЦ <> 0
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	НДФЛСтандартныеВычетыНаДетей.Период,
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо,
	|	НДФЛСтандартныеВычетыНаДетей.КодВычета,
	|	ВЫБОР
	|		КОГДА НДФЛСтандартныеВычетыНаДетей.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код101)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетей.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код102)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетей.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код111)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА НДФЛСтандартныеВычетыНаДетей.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код115)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетей.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код119)
	|				ИЛИ НДФЛСтандартныеВычетыНаДетей.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код123)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ
	|ИЗ
	|	РегистрСведений.НДФЛСтандартныеВычетыНаДетей КАК НДФЛСтандартныеВычетыНаДетей
	|ГДЕ
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлица КАК Физлица)
	|	И НДФЛСтандартныеВычетыНаДетей.Период >= &ДатаАктуальности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	СтрокиРегистра.Физлицо,
	|	СтрокиРегистра.Физлицо.ИНН
	|ПОМЕСТИТЬ ВТФизлицаСОбычнымиВычетами
	|ИЗ
	|	ВТСтрокиРегистра КАК СтрокиРегистра
	|
	|СГРУППИРОВАТЬ ПО
	|	СтрокиРегистра.Физлицо,
	|	СтрокиРегистра.Физлицо.ИНН
	|
	|ИМЕЮЩИЕ
	|	МАКСИМУМ(СтрокиРегистра.ЕстьЗаменяемыеВычеты) = ИСТИНА И
	|	МАКСИМУМ(СтрокиРегистра.ЕстьНовыеВычеты) = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиРегистра.Период,
	|	СтрокиРегистра.Физлицо,
	|	СтрокиРегистра.КодВычета,
	|	СтрокиРегистра.КодВычета.Код КАК КодВычетаКод,
	|	НДФЛСтандартныеВычетыНаДетей.КоличествоДетей,
	|	НДФЛСтандартныеВычетыНаДетей.ПериодЗавершения,
	|	НДФЛСтандартныеВычетыНаДетей.Основание,
	|	НДФЛСтандартныеВычетыНаДетей.КоличествоДетейЗавершения
	|ПОМЕСТИТЬ ВТВсеСтрокиРегистра
	|ИЗ
	|	ВТСтрокиРегистра КАК СтрокиРегистра
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НДФЛСтандартныеВычетыНаДетей КАК НДФЛСтандартныеВычетыНаДетей
	|		ПО СтрокиРегистра.Период = НДФЛСтандартныеВычетыНаДетей.Период
	|			И СтрокиРегистра.Физлицо = НДФЛСтандартныеВычетыНаДетей.Физлицо
	|			И СтрокиРегистра.КодВычета = НДФЛСтандартныеВычетыНаДетей.КодВычета
	|ГДЕ
	|	СтрокиРегистра.Физлицо В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлицаСОбычнымиВычетами КАК Физлица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА СтрокиРегистра.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА СтрокиРегистра.Период
	|			ИНАЧЕ СтрокиРегистра.ПериодЗавершения
	|		КОНЕЦ) КАК Период
	|ИЗ
	|	ВТВсеСтрокиРегистра КАК СтрокиРегистра";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Период) Тогда
		ПоследнийМесяц = ДобавитьМесяц(НачалоМесяца(Выборка.Период),1)
	Иначе
		ПоследнийМесяц = '20111201'
	КонецЕсли;
	
	НачМесяца = '20110101';
	ДатыПоМесяцамТекст = "ВЫБРАТЬ ДАТАВРЕМЯ(" + Формат(НачМесяца,"ДФ=гггг,М,д,Ч,м,с") + ") КАК Период";
	ДатыПоМесяцамТекст = ДатыПоМесяцамТекст + "
	|ПОМЕСТИТЬ ВТДатыПоМесяцам";
	Пока НачМесяца < НачалоМесяца(ПоследнийМесяц) Цикл
		НачМесяца = НачалоМесяца(КонецМесяца(НачМесяца) + 1);
		ДатыПоМесяцамТекст = ДатыПоМесяцамТекст +"
		|ОБЪЕДИНИТЬ ВСЕ ВЫБРАТЬ ДАТАВРЕМЯ(" + Формат(НачМесяца,"ДФ=гггг,М,д,Ч,м,с") + ")";
	КонецЦикла;
	Запрос.Текст = ДатыПоМесяцамТекст;
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Даты.Период,
	|	Даты.Физлицо,
	|	СУММА(ВЫБОР
	|			КОГДА СтрокиКоличестваВычетов.ПериодЗавершения <= &ДатаАктуальности
	|					И СтрокиКоличестваВычетов.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				ТОГДА СтрокиКоличестваВычетов.КоличествоДетейЗавершения
	|			ИНАЧЕ СтрокиКоличестваВычетов.КоличествоДетей
	|		КОНЕЦ) КАК КоличествоВычетов
	|ПОМЕСТИТЬ ВТКоличествоВычетовПоМесяцам
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДатыПоМесяцам.Период КАК Период,
	|		СтрокиСКоличеством.Физлицо КАК Физлицо,
	|		СтрокиСКоличеством.КодВычета КАК КодВычета,
	|		МАКСИМУМ(СтрокиСКоличеством.Период) КАК ПериодСтроки
	|	ИЗ
	|		ВТДатыПоМесяцам КАК ДатыПоМесяцам
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТВсеСтрокиРегистра КАК СтрокиСКоличеством
	|			ПО ДатыПоМесяцам.Период >= СтрокиСКоличеством.Период
	|	ГДЕ
	|		(СтрокиСКоличеством.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код101)
	|				ИЛИ СтрокиСКоличеством.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код102)
	|				ИЛИ СтрокиСКоличеством.КодВычета = ЗНАЧЕНИЕ(Справочник.ВычетыНДФЛ.Код111))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СтрокиСКоличеством.Физлицо,
	|		ДатыПоМесяцам.Период,
	|		СтрокиСКоличеством.КодВычета) КАК Даты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВсеСтрокиРегистра КАК СтрокиКоличестваВычетов
	|		ПО Даты.Физлицо = СтрокиКоличестваВычетов.Физлицо
	|			И Даты.ПериодСтроки = СтрокиКоличестваВычетов.Период
	|			И Даты.КодВычета = СтрокиКоличестваВычетов.КодВычета
	|
	|СГРУППИРОВАТЬ ПО
	|	Даты.Физлицо,
	|	Даты.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоличествоВычетовПоМесяцам.Физлицо,
	|	МАКСИМУМ(КоличествоВычетовПоМесяцам.КоличествоВычетов) КАК КоличествоВычетов
	|ПОМЕСТИТЬ ВТМаксимальноеКоличествоВычетов
	|ИЗ
	|	ВТКоличествоВычетовПоМесяцам КАК КоличествоВычетовПоМесяцам
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоВычетовПоМесяцам.Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ФизическиеЛицаСоставСемьи.Ссылка КАК Физлицо,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ФизическиеЛицаСоставСемьи.ДатаРождения >= ДАТАВРЕМЯ(1994, 1, 1, 0, 0, 0)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ЕстьДетиМладше18,
	|	КОЛИЧЕСТВО(ФизическиеЛицаСоставСемьи.НомерСтроки) КАК ВсегоДетей
	|ПОМЕСТИТЬ ВТДети
	|ИЗ
	|	Справочник.ФизическиеЛица.СоставСемьи КАК ФизическиеЛицаСоставСемьи
	|ГДЕ
	|	ФизическиеЛицаСоставСемьи.Ссылка В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлицаСОбычнымиВычетами КАК Физлица)
	|	И ФизическиеЛицаСоставСемьи.СтепеньРодства.Код В (""05"", ""06"", ""42"", ""43"")
	|
	|СГРУППИРОВАТЬ ПО
	|	ФизическиеЛицаСоставСемьи.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиРегистра.Период КАК Период,
	|	СтрокиРегистра.Физлицо КАК Физлицо,
	|	СтрокиРегистра.КодВычета КАК КодВычета,
	|	СтрокиРегистра.КодВычетаКод КАК КодВычетаКод,
	|	СтрокиРегистра.КоличествоДетей,
	|	СтрокиРегистра.ПериодЗавершения,
	|	СтрокиРегистра.Основание,
	|	СтрокиРегистра.КоличествоДетейЗавершения
	|ИЗ
	|	ВТВсеСтрокиРегистра КАК СтрокиРегистра
	|
	|УПОРЯДОЧИТЬ ПО
	|	Физлицо,
	|	КодВычетаКод,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиРегистра.Физлицо,
	|	СтрокиРегистра.Физлицо.Наименование КАК Наименование,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(Дети.ЕстьДетиМладше18, ЛОЖЬ)
	|					И ЕСТЬNULL(Дети.ВсегоДетей, 0) >= 2
	|				ИЛИ ЕСТЬNULL(МаксимальноеКоличествоВычетов.КоличествоВычетов, 0) >= 2
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КОбязательнойОбработке
	|ИЗ
	|	ВТФизлицаСОбычнымиВычетами КАК СтрокиРегистра
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДети КАК Дети
	|		ПО СтрокиРегистра.Физлицо = Дети.Физлицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТМаксимальноеКоличествоВычетов КАК МаксимальноеКоличествоВычетов
	|		ПО СтрокиРегистра.Физлицо = МаксимальноеКоличествоВычетов.Физлицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	КОбязательнойОбработке УБЫВ,
	|	Наименование";
	Результаты = Запрос.ВыполнитьПакет();
	ВсегоРезультатов = Результаты.Количество();
	ВычетыСотрудниковСДетьми.Загрузить(Результаты[ВсегоРезультатов - 2].Выгрузить());
	СотрудникиСДетьми.Загрузить(Результаты[ВсегоРезультатов - 1].Выгрузить());
	
КонецПроцедуры

Процедура ЗаменаКодаВычета(Вычеты, ПорядокОбработки, ЗаменяемыйКод, КодВторогоРебенка, КодТретьегоРебенка) Экспорт

	Если ПорядокОбработки = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДатаНачалаПримененияВычетов = '20110101';
	СтрокиКОбработке = Вычеты.НайтиСтроки(Новый Структура("КодВычета",ЗаменяемыйКод));
	
	Если ПорядокОбработки = 1 Тогда // выделяем вычеты на первого и второго ребенка
		
		СтрокиЕщеНеВводились = Истина;
		Для каждого СтрокаТЧ Из СтрокиКОбработке Цикл
			
			ОставлятьВычетов = 1;
			Если СтрокаТЧ.КоличествоДетей <= ОставлятьВычетов И СтрокаТЧ.КоличествоДетейЗавершения <= ОставлятьВычетов И СтрокиЕщеНеВводились Тогда
				Продолжить;
			КонецЕсли;
			
			КоличествоДетей = СтрокаТЧ.КоличествоДетей;
			КоличествоДетейЗавершения = СтрокаТЧ.КоличествоДетейЗавершения;
			Если КоличествоДетей > ОставлятьВычетов Или КоличествоДетейЗавершения > ОставлятьВычетов Тогда
				Если СтрокаТЧ.Период >= ДатаНачалаПримененияВычетов Тогда
					Если СтрокаТЧ.КоличествоДетей > ОставлятьВычетов Тогда
						СтрокаТЧ.КоличествоДетей = ОставлятьВычетов;
					КонецЕсли;
					Если СтрокаТЧ.КоличествоДетейЗавершения > ОставлятьВычетов Тогда
						СтрокаТЧ.КоличествоДетейЗавершения = ОставлятьВычетов;
					КонецЕсли;
				Иначе
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					Если СтрокаТЧ.КоличествоДетей > ОставлятьВычетов Тогда
						СтрокаКОбработке.КоличествоДетей = ОставлятьВычетов;
					КонецЕсли;
					Если СтрокаТЧ.КоличествоДетейЗавершения > ОставлятьВычетов Тогда
						СтрокаКОбработке.КоличествоДетейЗавершения = ОставлятьВычетов;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ПериодЗавершения) Или СтрокаТЧ.ПериодЗавершения >= ДатаНачалаПримененияВычетов Тогда
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
				СтрокаКОбработке.Период = Макс(СтрокаКОбработке.Период, ДатаНачалаПримененияВычетов);
				СтрокаКОбработке.КоличествоДетей = Мин(Макс(КоличествоДетей - ОставлятьВычетов, 0), 1);
				СтрокаКОбработке.КодВычета = КодВторогоРебенка;
			ИначеЕсли КоличествоДетейЗавершения <= ОставлятьВычетов Тогда
			Иначе
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
				СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
				СтрокаКОбработке.КодВычета = КодВторогоРебенка;
				СтрокаКОбработке.КоличествоДетей = Мин(Макс(КоличествоДетейЗавершения - ОставлятьВычетов, 0), 1);
			КонецЕсли;
			
			ОставлятьВычетов = 2;
			Если КоличествоДетей <= ОставлятьВычетов И КоличествоДетейЗавершения <= ОставлятьВычетов И СтрокиЕщеНеВводились Тогда
				СтрокиЕщеНеВводились = Ложь;
				Продолжить;
			КонецЕсли;
			
			СтрокиЕщеНеВводились = Ложь;
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ПериодЗавершения) Или СтрокаТЧ.ПериодЗавершения >= ДатаНачалаПримененияВычетов Тогда
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
				СтрокаКОбработке.Период = Макс(СтрокаКОбработке.Период, ДатаНачалаПримененияВычетов);
				СтрокаКОбработке.КоличествоДетей = Макс(КоличествоДетей - ОставлятьВычетов, 0);
				СтрокаКОбработке.КодВычета = КодТретьегоРебенка;
			ИначеЕсли КоличествоДетейЗавершения <= ОставлятьВычетов Тогда
				Продолжить;
			Иначе
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
				СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
				СтрокаКОбработке.КодВычета = КодТретьегоРебенка;
				СтрокаКОбработке.КоличествоДетей = Макс(КоличествоДетейЗавершения - ОставлятьВычетов, 0);
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ПорядокОбработки = 2 Тогда // оставляем вычет только на второго ребенка
		
		ОставлятьВычетов = 1;
		
		СтрокиЕщеНеВводились = Истина;
		Для каждого СтрокаТЧ Из СтрокиКОбработке Цикл
			
			Если СтрокаТЧ.КоличествоДетей <= ОставлятьВычетов И СтрокаТЧ.КоличествоДетейЗавершения <= ОставлятьВычетов И СтрокиЕщеНеВводились Тогда
				Если Не ЗначениеЗаполнено(СтрокаТЧ.ПериодЗавершения) Или СтрокаТЧ.ПериодЗавершения >= ДатаНачалаПримененияВычетов Тогда
					Если СтрокаТЧ.Период < ДатаНачалаПримененияВычетов Тогда
						СтрокаКОбработке = Вычеты.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
						СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
						СтрокаКОбработке.КоличествоДетей = 0;
						СтрокаКОбработке = Вычеты.Добавить();
						ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
						СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					Иначе
						СтрокаКОбработке = СтрокаТЧ
					КонецЕсли;
					СтрокаКОбработке.КодВычета = КодВторогоРебенка;
				Иначе
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					СтрокаКОбработке.КоличествоДетей = 0;
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					СтрокаКОбработке.КодВычета = КодВторогоРебенка;
					СтрокаКОбработке.КоличествоДетей = СтрокаТЧ.КоличествоДетейЗавершения;
				КонецЕсли;
				Продолжить;
			КонецЕсли;
			
			КоличествоДетей = СтрокаТЧ.КоличествоДетей;
			КоличествоДетейЗавершения = СтрокаТЧ.КоличествоДетейЗавершения;
			Если КоличествоДетей > ОставлятьВычетов Или КоличествоДетейЗавершения > ОставлятьВычетов Тогда
				Если СтрокаТЧ.Период >= ДатаНачалаПримененияВычетов Тогда
					Если СтрокаТЧ.КоличествоДетей > ОставлятьВычетов Тогда
						СтрокаТЧ.КоличествоДетей = ОставлятьВычетов;
					КонецЕсли;
					Если СтрокаТЧ.КоличествоДетейЗавершения > ОставлятьВычетов Тогда
						СтрокаТЧ.КоличествоДетейЗавершения = ОставлятьВычетов;
					КонецЕсли;
					СтрокаТЧ.КодВычета = КодВторогоРебенка;
				Иначе
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"КоличествоДетей,ПериодЗавершения,КоличествоДетейЗавершения");
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					Если СтрокаТЧ.КоличествоДетей > ОставлятьВычетов Тогда
						СтрокаКОбработке.КоличествоДетей = ОставлятьВычетов;
					КонецЕсли;
					Если СтрокаТЧ.КоличествоДетейЗавершения > ОставлятьВычетов Тогда
						СтрокаКОбработке.КоличествоДетейЗавершения = ОставлятьВычетов;
					КонецЕсли;
					СтрокаКОбработке.КодВычета = КодВторогоРебенка;
				КонецЕсли;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ПериодЗавершения) Или СтрокаТЧ.ПериодЗавершения >= ДатаНачалаПримененияВычетов Тогда
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
				СтрокаКОбработке.Период = Макс(СтрокаКОбработке.Период, ДатаНачалаПримененияВычетов);
				СтрокаКОбработке.КоличествоДетей = Макс(КоличествоДетей - ОставлятьВычетов, 0);
				СтрокаКОбработке.КодВычета = КодТретьегоРебенка;
			ИначеЕсли КоличествоДетейЗавершения <= ОставлятьВычетов Тогда
				Продолжить;
			Иначе
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
				СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
				СтрокаКОбработке.КодВычета = КодТретьегоРебенка;
				СтрокаКОбработке.КоличествоДетей = Макс(КоличествоДетейЗавершения - ОставлятьВычетов, 0);
			КонецЕсли;
			СтрокиЕщеНеВводились = Ложь;
		КонецЦикла;
		
	ИначеЕсли ПорядокОбработки = 3 Или ПорядокОбработки = 4 Или ПорядокОбработки = 5 Тогда // все вычеты заменяем
		
		Если ПорядокОбработки = 4 Тогда
			ЗаменяющийКод = КодВторогоРебенка;
		Иначе
			ЗаменяющийКод = КодТретьегоРебенка;
		КонецЕсли;
		
		Для каждого СтрокаТЧ Из СтрокиКОбработке Цикл
			СтрокаКОбработке = СтрокаТЧ;
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ПериодЗавершения) Или СтрокаТЧ.ПериодЗавершения >= ДатаНачалаПримененияВычетов Тогда
				Если СтрокаТЧ.Период < ДатаНачалаПримененияВычетов Тогда
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
					СтрокаКОбработке.КоличествоДетей = 0;
					СтрокаКОбработке = Вычеты.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ);
					СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
				КонецЕсли;
				СтрокаКОбработке.КодВычета = ЗаменяющийКод;
			Иначе
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
				СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
				СтрокаКОбработке.КоличествоДетей = 0;
				СтрокаКОбработке = Вычеты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаКОбработке,СтрокаТЧ,,"ПериодЗавершения,КоличествоДетейЗавершения");
				СтрокаКОбработке.Период = ДатаНачалаПримененияВычетов;
				СтрокаКОбработке.КодВычета = ЗаменяющийКод;
				СтрокаКОбработке.КоличествоДетей = СтрокаТЧ.КоличествоДетейЗавершения;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаВычетовСотрудника(ФизЛицо) Экспорт
	
	СтрокаФизЛица = СотрудникиСДетьми.Найти(ФизЛицо, "ФизЛицо");
	Если СтрокаФизЛица = Неопределено Тогда
		Возврат
	КонецЕсли;
	СтрокаФизЛица.ЕстьОшибкиВВычетах = Ложь;
	
	СтрокиДляПроверки = НовыеВычетыСотрудниковСДетьми.Выгрузить(Новый Структура("ФизЛицо", ФизЛицо));
	Для каждого СтрокаТЗ Из СтрокиДляПроверки  Цикл
		Если Не ЗначениеЗаполнено(СтрокаТЗ.КодВычета) Тогда
			СтрокаФизЛица.ЕстьОшибкиВВычетах = Истина;
			Возврат
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЗ.Период) Тогда
			СтрокаФизЛица.ЕстьОшибкиВВычетах = Истина;
			Возврат
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТЗ.ПериодЗавершения) И СтрокаТЗ.Период > СтрокаТЗ.ПериодЗавершения Тогда
			СтрокаФизЛица.ЕстьОшибкиВВычетах = Истина;
			Возврат
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВычетыНаДетей.НомерСтроки,
	|	ВычетыНаДетей.Период,
	|	ВычетыНаДетей.КодВычета
	|ПОМЕСТИТЬ ВТСтроки
	|ИЗ
	|	&СтрокиДляПроверки КАК ВычетыНаДетей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Строки.Период,
	|	Строки.КодВычета
	|ИЗ
	|	ВТСтроки КАК Строки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСтроки КАК СтрокиПроверки
	|		ПО Строки.Период = СтрокиПроверки.Период
	|			И Строки.КодВычета = СтрокиПроверки.КодВычета
	|			И Строки.НомерСтроки <> СтрокиПроверки.НомерСтроки";
	Запрос.УстановитьПараметр("СтрокиДляПроверки", СтрокиДляПроверки);
	Результат = Запрос.Выполнить();
	
	СтрокаФизЛица.ЕстьОшибкиВВычетах = Не Результат.Пустой();
	
КонецПроцедуры

Процедура СохранениеДанных() Экспорт

	МассивФизлиц = Новый Массив;
	СтрокиФизлиц = СотрудникиСДетьми.НайтиСтроки(Новый Структура("УжеОбработано", Истина));
	Для каждого СтрокаТЧ Из СтрокиФизлиц Цикл
		МассивФизлиц.Добавить(СтрокаТЧ.ФизЛицо)
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Физлица", МассивФизлиц);
	Запрос.УстановитьПараметр("ВычетыСотрудниковСДетьми", ВычетыСотрудниковСДетьми.Выгрузить());
	Запрос.УстановитьПараметр("НовыеВычетыСотрудниковСДетьми", НовыеВычетыСотрудниковСДетьми.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДФЛСтандартныеВычетыНаДетей.Период,
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо,
	|	НДФЛСтандартныеВычетыНаДетей.КодВычета
	|ПОМЕСТИТЬ ВТВычетыСотрудниковСДетьми
	|ИЗ
	|	&ВычетыСотрудниковСДетьми КАК НДФЛСтандартныеВычетыНаДетей
	|ГДЕ
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо В(&Физлица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДФЛСтандартныеВычетыНаДетей.Период,
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо,
	|	НДФЛСтандартныеВычетыНаДетей.КодВычета,
	|	НДФЛСтандартныеВычетыНаДетей.КоличествоДетей,
	|	НДФЛСтандартныеВычетыНаДетей.ПериодЗавершения,
	|	НДФЛСтандартныеВычетыНаДетей.Основание
	|ПОМЕСТИТЬ ВТНовыеВычетыСотрудниковСДетьми
	|ИЗ
	|	&НовыеВычетыСотрудниковСДетьми КАК НДФЛСтандартныеВычетыНаДетей
	|ГДЕ
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо В(&Физлица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДФЛСтандартныеВычетыНаДетей.Период,
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо КАК Физлицо,
	|	НДФЛСтандартныеВычетыНаДетей.КодВычета
	|ПОМЕСТИТЬ ВТСтрокиВРегистр
	|ИЗ
	|	РегистрСведений.НДФЛСтандартныеВычетыНаДетей КАК НДФЛСтандартныеВычетыНаДетей
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВычетыСотрудниковСДетьми КАК ВычетыСотрудниковСДетьми
	|		ПО НДФЛСтандартныеВычетыНаДетей.Период = ВычетыСотрудниковСДетьми.Период
	|			И НДФЛСтандартныеВычетыНаДетей.Физлицо = ВычетыСотрудниковСДетьми.Физлицо
	|			И НДФЛСтандартныеВычетыНаДетей.КодВычета = ВычетыСотрудниковСДетьми.КодВычета
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНовыеВычетыСотрудниковСДетьми КАК НовыеВычетыСотрудниковСДетьми
	|		ПО НДФЛСтандартныеВычетыНаДетей.Период = НовыеВычетыСотрудниковСДетьми.Период
	|			И НДФЛСтандартныеВычетыНаДетей.Физлицо = НовыеВычетыСотрудниковСДетьми.Физлицо
	|			И НДФЛСтандартныеВычетыНаДетей.КодВычета = НовыеВычетыСотрудниковСДетьми.КодВычета
	|ГДЕ
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо В(&Физлица)
	|	И ВычетыСотрудниковСДетьми.Физлицо ЕСТЬ NULL 
	|	И НовыеВычетыСотрудниковСДетьми.Физлицо ЕСТЬ NULL 
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	НДФЛСтандартныеВычетыНаДетей.Период,
	|	НДФЛСтандартныеВычетыНаДетей.Физлицо,
	|	НДФЛСтандартныеВычетыНаДетей.КодВычета
	|ИЗ
	|	ВТНовыеВычетыСотрудниковСДетьми КАК НДФЛСтандартныеВычетыНаДетей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтрокиВРегистр.Период,
	|	СтрокиВРегистр.Физлицо КАК Физлицо,
	|	СтрокиВРегистр.КодВычета,
	|	ЕСТЬNULL(НовыеВычетыСотрудниковСДетьми.КоличествоДетей, НДФЛСтандартныеВычетыНаДетей.КоличествоДетей) КАК КоличествоДетей,
	|	ЕСТЬNULL(НовыеВычетыСотрудниковСДетьми.ПериодЗавершения, НДФЛСтандартныеВычетыНаДетей.ПериодЗавершения) КАК ПериодЗавершения,
	|	ЕСТЬNULL(НовыеВычетыСотрудниковСДетьми.Основание, НДФЛСтандартныеВычетыНаДетей.Основание) КАК Основание
	|ИЗ
	|	ВТСтрокиВРегистр КАК СтрокиВРегистр
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНовыеВычетыСотрудниковСДетьми КАК НовыеВычетыСотрудниковСДетьми
	|		ПО СтрокиВРегистр.Период = НовыеВычетыСотрудниковСДетьми.Период
	|			И СтрокиВРегистр.Физлицо = НовыеВычетыСотрудниковСДетьми.Физлицо
	|			И СтрокиВРегистр.КодВычета = НовыеВычетыСотрудниковСДетьми.КодВычета
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НДФЛСтандартныеВычетыНаДетей КАК НДФЛСтандартныеВычетыНаДетей
	|		ПО СтрокиВРегистр.Период = НДФЛСтандартныеВычетыНаДетей.Период
	|			И СтрокиВРегистр.Физлицо = НДФЛСтандартныеВычетыНаДетей.Физлицо
	|			И СтрокиВРегистр.КодВычета = НДФЛСтандартныеВычетыНаДетей.КодВычета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Физлицо";
	
	НаборЗаписей = РегистрыСведений.НДФЛСтандартныеВычетыНаДетей.СоздатьНаборЗаписей();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Физлицо") Цикл
		НаборЗаписей.Отбор.Физлицо.Установить(Выборка.Физлицо);
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЦикла;
		НаборЗаписей.Записать();
		НаборЗаписей.Очистить();
	КонецЦикла;

КонецПроцедуры

Функция ЕстьИзмененияВычетов() Экспорт
	
	СтруктураОтбора = Новый Структура("ФизЛицо");
	СтрокиФизлиц = СотрудникиСДетьми.НайтиСтроки(Новый Структура("УжеОбработано", Истина));
	
	Для каждого СтрокаТЧ Из СтрокиФизлиц Цикл
		
		СтруктураОтбора.ФизЛицо = СтрокаТЧ.ФизЛицо;
		СтрокаКолонок = "Период,ФизЛицо,КодВычета,КоличествоДетей,ПериодЗавершения,Основание";
		ДоОбработки = ВычетыСотрудниковСДетьми.Выгрузить(СтруктураОтбора, СтрокаКолонок);
		ДоОбработки.Сортировать("Период, КодВычета");
		ПослеОбработки = НовыеВычетыСотрудниковСДетьми.Выгрузить(СтруктураОтбора, СтрокаКолонок);
		ПослеОбработки.Сортировать("Период, КодВычета");
		
		Если Не ОбщегоНазначенияЗК.ТаблицыИдентичны(ДоОбработки, ПослеОбработки) Тогда
			Возврат Истина
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь 

КонецФункции // ЕстьИзмененияВычетов()

