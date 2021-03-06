Процедура ПередЗаписью(Отказ, Замещение)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьПерерасчетыПоФактическойВыработке();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЗарегистрироватьПерерасчетыПоФактическойВыработке();
	
КонецПроцедуры

Процедура ЗарегистрироватьПерерасчетыПоФактическойВыработке()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Основные.ФизЛицо,
	|	Основные.Регистратор КАК Регистратор,
	|	Основные.Организация,
	|	Основные.Сотрудник
	|ИЗ
	|	РегистрНакопления.ФактическаяВыработкаРаботниковОрганизаций КАК ФактическаяВыработка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК Основные
	|		ПО ФактическаяВыработка.Период >= Основные.ПериодДействияНачало
	|			И ФактическаяВыработка.Период <= Основные.ПериодДействияКонец
	|			И (Основные.ВидРасчета.СпособРасчета = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаОплатыТруда.СдельныйЗаработок))
	|			И ФактическаяВыработка.Сотрудник = Основные.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК Перерасчеты
	|		ПО (Перерасчеты.ОбъектПерерасчета = Основные.Регистратор)
	|			И (Перерасчеты.ФизЛицо = Основные.ФизЛицо)
	|			И (Перерасчеты.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка))
	|ГДЕ
	|	ФактическаяВыработка.Регистратор = &Регистратор
	|	И Перерасчеты.ФизЛицо ЕСТЬ NULL 
	|	И Основные.Регистратор ЕСТЬ НЕ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПроведениеРасчетов.ДописатьПерерасчетыОсновныхНачислений(Выборка);
	
КонецПроцедуры

