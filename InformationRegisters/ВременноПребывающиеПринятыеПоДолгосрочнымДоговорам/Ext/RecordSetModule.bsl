﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("НаборЗаписей", ЭтотОбъект.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НаборЗаписей.Период,
	|	НаборЗаписей.ФизЛицо,
	|	НаборЗаписей.Организация,
	|	НаборЗаписей.ПринятПоДолгосрочномуДоговору,
	|	НаборЗаписей.ПериодЗавершения,
	|	НаборЗаписей.ДатаРегистрацииИзменений,
	|	НаборЗаписей.Документ
	|ПОМЕСТИТЬ ВТНаборЗаписей
	|ИЗ
	|	&НаборЗаписей КАК НаборЗаписей
	|";
	Запрос.Выполнить(); 
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НаборЗаписей.Период,
	|	НаборЗаписей.ФизЛицо,
	|	ВЫБОР
	|		КОГДА НаборЗаписей.Организация.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА НаборЗаписей.Организация
	|		ИНАЧЕ НаборЗаписей.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК Организация,
	|	НаборЗаписей.ПринятПоДолгосрочномуДоговору,
	|	ВЫБОР
	|		КОГДА НаборЗаписей.ПериодЗавершения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА НаборЗаписей.ПериодЗавершения
	|		ИНАЧЕ КОНЕЦПЕРИОДА(НаборЗаписей.ПериодЗавершения, МЕСЯЦ)
	|	КОНЕЦ КАК ПериодЗавершения,
	|	ВЫБОР
	|		КОГДА НаборЗаписей.ДатаРегистрацииИзменений = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА НаборЗаписей.Период
	|		ИНАЧЕ НаборЗаписей.ДатаРегистрацииИзменений
	|	КОНЕЦ КАК ДатаРегистрацииИзменений,
	|	НаборЗаписей.Документ
	|ИЗ
	|	ВТНаборЗаписей КАК НаборЗаписей";
	ЭтотОбъект.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры
