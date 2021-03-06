
// Функция ищет резюме кандидата
//
// В параметр ТиповаяАнкета будет передана ссылка на найденную типовую анкету
Функция НайтиРезюмеКандидата(ЗаявкаКандидата, ТиповаяАнкета = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ЗаявкаКандидата",	ЗаявкаКандидата);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА Должности.АнкетаРезюмеКандидата ЕСТЬ NULL 
	|				ИЛИ Должности.АнкетаРезюмеКандидата = ЗНАЧЕНИЕ(Справочник.ТиповыеАнкеты.ПустаяСсылка)
	|			ТОГДА Константы.АнкетаРезюмеКандидата
	|		ИНАЧЕ Должности.АнкетаРезюмеКандидата
	|	КОНЕЦ КАК ТиповаяАнкета
	|ИЗ
	|	Константы КАК Константы
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаявкиКандидатов.Должность.АнкетаРезюмеКандидата КАК АнкетаРезюмеКандидата
	|		ИЗ
	|			Справочник.ЗаявкиКандидатов КАК ЗаявкиКандидатов
	|		ГДЕ
	|			ЗаявкиКандидатов.Ссылка = &ЗаявкаКандидата) КАК Должности
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА Должности.АнкетаРезюмеКандидата ЕСТЬ NULL 
	|					ИЛИ Должности.АнкетаРезюмеКандидата = ЗНАЧЕНИЕ(Справочник.ТиповыеАнкеты.ПустаяСсылка)
	|				ТОГДА Константы.АнкетаРезюмеКандидата
	|			ИНАЧЕ Должности.АнкетаРезюмеКандидата
	|		КОНЕЦ <> ЗНАЧЕНИЕ(Справочник.ТиповыеАнкеты.ПустаяСсылка)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ТиповаяАнкета	= Выборка.ТиповаяАнкета;
		
	Иначе
		Возврат Неопределено;
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТиповаяАнкета",		ТиповаяАнкета);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Опрос.Ссылка
	|ИЗ
	|	Документ.Опрос КАК Опрос
	|ГДЕ
	|	Опрос.ОпрашиваемоеЛицо = &ЗаявкаКандидата
	|	И Опрос.ТиповаяАнкета = &ТиповаяАнкета
	|
	|УПОРЯДОЧИТЬ ПО
	|	Опрос.Дата УБЫВ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
		
	Иначе
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

Функция ПечатьСведенийОФизлицеТекстЗапросаРезультатыАнкетирования() Экспорт
	
	Возврат  
	"ВЫБРАТЬ
	|	РезультатыАнкетирования.Ссылка.ТиповаяАнкета.Представление КАК Анкета,
	|	РезультатыАнкетирования.Вопрос.ПолнаяФормулировка КАК Вопрос,
	|	РезультатыАнкетирования.ТиповойОтвет КАК Ответ,
	|	РезультатыАнкетирования.Ссылка.Представление КАК РегистраторПредставление,
	|	ВариантыОтветовОпросов.ОценкаОтвета
	|ИЗ
	|	Документ.Опрос.Вопросы КАК РезультатыАнкетирования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтветовОпросов КАК ВариантыОтветовОпросов
	|		ПО РезультатыАнкетирования.ТиповойОтвет = ВариантыОтветовОпросов.Ссылка
	|
	|ГДЕ
	|	РезультатыАнкетирования.Ссылка.ОпрашиваемоеЛицо = &ФизЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	РезультатыАнкетирования.Ссылка.Дата";
	
КонецФункции

Процедура ЗаполнитьФизическоеЛицоПоОпросу(Форма, ФизическоеЛицо, Опрос) Экспорт
	
	Анкетирование.ЗаполнитьФизическоеЛицоПоОпросу(Форма, ФизическоеЛицо, Опрос);

КонецПроцедуры

Процедура ИменаДополнительныхТиповДополнитьОбъектамиАнкетирования(ИменаДополнительныхТипов) Экспорт
	
	ИменаДополнительныхТипов.Добавить(Тип("ДокументОбъект.ЗаявкаНаОбучение"));
	ИменаДополнительныхТипов.Добавить(Тип("ДокументОбъект.Опрос"));
	ИменаДополнительныхТипов.Добавить(Тип("ДокументОбъект.РассылкаАнкет"));
	
КонецПроцедуры
	