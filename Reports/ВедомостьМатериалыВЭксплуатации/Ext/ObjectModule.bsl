﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Настройка общих параметров универсального отчета
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	// Содержит признак необходимости отображения надписи и поля выбора раздела учета в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	// Содержит имя регистра, по метаданным которого будет выполняться заполнение настроек отчета.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.ИмяРегистра = "ТоварыНаСкладах";
	УниверсальныйОтчет.ИмяРегистра = "";
	
	// Содержит значение используемого режима ввода периода.
	// Тип: Число.
	// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
	// Значение по умолчанию: 0
	// Пример:
	// УниверсальныйОтчет.мРежимВводаПериода = 0;
	УниверсальныйОтчет.мРежимВводаПериода = 0;
	
	// Содержит признак необходимости вывода отрицательных значений показателей красным цветом.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	// Содержит признак необходимости вывода в отчет общих итогов.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьОбщиеИтоги = Ложь;
	
	// Содержит признак необходимости вывода детальных записей в отчет.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	
	// Содержит признак необходимости отображения флага использования свойств и категорий в форме настройки.
	// Тип: Булево.
	// Значение по умолчанию: Истина.
	// Пример:
	// УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Истина;
	
	// Содержит признак использования свойств и категорий при заполнении настроек отчета.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.ИспользоватьСвойстваИКатегории = Истина;
	
	// Содержит признак использования простой формы настроек отчета без группировок колонок.
	// Тип: Булево.
	// Значение по умолчанию: Ложь.
	// Пример:
	// УниверсальныйОтчет.мРежимФормыНастройкиБезГруппировокКолонок = Истина;
	
	// Дополнительные параметры, переданные из отчета, вызвавшего расшифровку.
	// Информация, передаваемая в переменной ДополнительныеПараметры, может быть использована
	// для реализации специфичных для данного отчета параметрических настроек.
	
	// Описание исходного текста запроса.
	// При написании текста запроса рекомендуется следовать правилам, описанным в следующем шаблоне текста запроса:
	//
	//ВЫБРАТЬ
	//	<ПсевдонимТаблицы.Поле> КАК <ПсевдонимПоля>,
	//	ПРЕДСТАВЛЕНИЕ(<ПсевдонимТаблицы>.<Поле>),
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//{ВЫБРАТЬ
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//ИЗ
	//	<Таблица> КАК <ПсевдонимТаблицы>
	//	//СОЕДИНЕНИЯ
	//{ГДЕ
	//	<ПсевдонимТаблицы.Поле>.* КАК <ПсевдонимПоля>,
	//	<ПсевдонимТаблицы.Показатель> КАК <ПсевдонимПоказателя>,
	//	<ПсевдонимТаблицы>.Регистратор КАК Регистратор,
	//	<ПсевдонимТаблицы>.Период КАК Период,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕНЬ) КАК ПериодДень,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ДЕКАДА) КАК ПериодДекада,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, МЕСЯЦ) КАК ПериодМесяц,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, КВАРТАЛ) КАК ПериодКвартал,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	//	НАЧАЛОПЕРИОДА(<ПсевдонимТаблицы>.Период, ГОД) КАК ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//{УПОРЯДОЧИТЬ ПО
	//	<ПсевдонимПоля>.*,
	//	<ПсевдонимПоказателя>,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//УПОРЯДОЧИТЬ_СВОЙСТВА
	//	//УПОРЯДОЧИТЬ_КАТЕГОРИИ
	//}
	//ИТОГИ
	//	АГРЕГАТНАЯ_ФУНКЦИЯ(<ПсевдонимПоказателя>)
	//	//ИТОГИ_СВОЙСТВА
	//	//ИТОГИ_КАТЕГОРИИ
	//ПО
	//	ОБЩИЕ
	//{ИТОГИ ПО
	//	<ПсевдонимПоля>.*,
	//	Регистратор,
	//	Период,
	//	ПериодДень,
	//	ПериодНеделя,
	//	ПериодДекада,
	//	ПериодМесяц,
	//	ПериодКвартал,
	//	ПериодПолугодие,
	//	ПериодГод
	//	//ПОЛЯ_СВОЙСТВА
	//	//ПОЛЯ_КАТЕГОРИИ
	//}
	//АВТОУПОРЯДОЧИВАНИЕ
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РегМатериалы.Подразделение,
		|	ПРЕДСТАВЛЕНИЕ(РегМатериалы.Подразделение),
		|	РегМатериалы.Номенклатура,
		|	ПРЕДСТАВЛЕНИЕ(РегМатериалы.Номенклатура),
		|	РегМатериалы.ХарактеристикаНоменклатуры,
		|	ПРЕДСТАВЛЕНИЕ(РегМатериалы.ХарактеристикаНоменклатуры),
		|	РегМатериалы.СерияНоменклатуры,
		|	ПРЕДСТАВЛЕНИЕ(РегМатериалы.СерияНоменклатуры),
		|	РегМатериалы.ФизЛицо,
		|	ПРЕДСТАВЛЕНИЕ(РегМатериалы.ФизЛицо),
		|	РегМатериалы.КоличествоНачальныйОстаток КАК КолНачОст,
		|	РегМатериалы.КоличествоКонечныйОстаток КАК КолКонОст,
		|	РегМатериалы.КоличествоПриход КАК КолПриход,
		|	РегМатериалы.КоличествоРасход КАК КолРасход,
		|	РегМатериалы.Регистратор,
		|	ПРЕДСТАВЛЕНИЕ(РегМатериалы.Регистратор),
		|	РегМатериалы.Период,
		|	РегМатериалы.КоличествоНачальныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолНачОстЕдОтчетов,
		|	РегМатериалы.КоличествоПриход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолПриходЕдОтчетов,
		|	РегМатериалы.КоличествоРасход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолРасходЕдОтчетов,
		|	РегМатериалы.КоличествоКонечныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолКонОстЕдОтчетов,
		|	РегМатериалы.КоличествоНачальныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолНачОстБазовЕд,
		|	РегМатериалы.КоличествоПриход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолПриходБазовЕд,
		|	РегМатериалы.КоличествоРасход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолРасходБазовЕд,
		|	РегМатериалы.КоличествоКонечныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолКонОстБазовЕд,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ДЕНЬ) КАК ПериодДень,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, НЕДЕЛЯ) КАК ПериодНеделя,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ДЕКАДА) КАК ПериодДекада,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, МЕСЯЦ) КАК ПериодМесяц,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, КВАРТАЛ) КАК ПериодКвартал,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ГОД) КАК ПериодГод
		|	//ПОЛЯ_СВОЙСТВА
		|	//ПОЛЯ_КАТЕГОРИИ
		|{ВЫБРАТЬ
		|	Подразделение.*,
		|	Номенклатура.*,
		|	ХарактеристикаНоменклатуры.*,
		|	СерияНоменклатуры.*,
		|	ФизЛицо.*,
		|	Регистратор.*,
		|	Период,
		|	ПериодДень,
		|	ПериодНеделя,
		|	ПериодДекада,
		|	ПериодМесяц,
		|	ПериодКвартал,
		|	ПериодПолугодие,
		|	ПериодГод,
		|	КолНачОстЕдОтчетов,
		|	КолПриходЕдОтчетов,
		|	КолРасходЕдОтчетов,
		|	КолКонОстЕдОтчетов,
		|	КолНачОстБазовЕд,
		|	КолПриходБазовЕд,
		|	КолРасходБазовЕд,
		|	КолКонОстБазовЕд,
		|	КолНачОст,
		|	КолКонОст,
		|	КолПриход,
		|	КолРасход
		|	//ПСЕВДОНИМЫ_СВОЙСТВА
		|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
		|}

		|ИЗ
		|	РегистрНакопления.МатериалыВЭксплуатации.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор {&Периодичность}, ,
		|		{Подразделение.*              КАК Подразделение,
		|		 Номенклатура.*               КАК Номенклатура,
		|		 ХарактеристикаНоменклатуры.* КАК ХарактеристикаНоменклатуры,
		|		 СерияНоменклатуры.*          КАК СерияНоменклатуры,
		|		 ФизЛицо.*                    КАК ФизЛицо}) КАК РегМатериалы
		|	//СОЕДИНЕНИЯ
		|{ГДЕ
		|	РегМатериалы.КоличествоНачальныйОстаток КАК КолНачОст,
		|	РегМатериалы.КоличествоКонечныйОстаток КАК КолКонОст,
		|	РегМатериалы.КоличествоПриход КАК КолПриход,
		|	РегМатериалы.КоличествоРасход КАК КолРасход,
		|	РегМатериалы.КоличествоНачальныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолНачОстЕдОтчетов,
		|	РегМатериалы.КоличествоПриход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолПриходЕдОтчетов,
		|	РегМатериалы.КоличествоРасход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолРасходЕдОтчетов,
		|	РегМатериалы.КоличествоКонечныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент / ВЫБОР
		|		КОГДА РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент = 0
		|			ТОГДА 1
		|		ИНАЧЕ ЕСТЬNULL(РегМатериалы.Номенклатура.ЕдиницаДляОтчетов.Коэффициент, 1)
		|	КОНЕЦ КАК КолКонОстЕдОтчетов,
		|	РегМатериалы.КоличествоНачальныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолНачОстБазовЕд,
		|	РегМатериалы.КоличествоПриход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолПриходБазовЕд,
		|	РегМатериалы.КоличествоРасход * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолРасходБазовЕд,
		|	РегМатериалы.КоличествоКонечныйОстаток * РегМатериалы.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент КАК КолКонОстБазовЕд,
		|	РегМатериалы.Регистратор.*,
		|	РегМатериалы.Период,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ДЕНЬ) КАК ПериодДень,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, НЕДЕЛЯ) КАК ПериодНеделя,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ДЕКАДА) КАК ПериодДекада,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, МЕСЯЦ) КАК ПериодМесяц,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, КВАРТАЛ) КАК ПериодКвартал,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
		|	НАЧАЛОПЕРИОДА(РегМатериалы.Период, ГОД) КАК ПериодГод
		|	//УСЛОВИЯ_СВОЙСТВА
		|	//УСЛОВИЯ_КАТЕГОРИИ
		|}

		|{УПОРЯДОЧИТЬ ПО
		|	Подразделение.*,
		|	Номенклатура.*,
		|	ХарактеристикаНоменклатуры.*,
		|	СерияНоменклатуры.*,
		|	ФизЛицо.*,
		|	Регистратор.*,
		|	Период,
		|	ПериодДень,
		|	ПериодНеделя,
		|	ПериодДекада,
		|	ПериодМесяц,
		|	ПериодКвартал,
		|	ПериодПолугодие,
		|	ПериодГод,
		|	КолНачОстЕдОтчетов,
		|	КолПриходЕдОтчетов,
		|	КолРасходЕдОтчетов,
		|	КолКонОстЕдОтчетов,
		|	КолНачОстБазовЕд,
		|	КолПриходБазовЕд,
		|	КолРасходБазовЕд,
		|	КолКонОстБазовЕд,
		|	КолНачОст,
		|	КолКонОст,
		|	КолПриход,
		|	КолРасход
		|	//ПСЕВДОНИМЫ_СВОЙСТВА
		|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
		|}

		|ИТОГИ
		|	СУММА(КолНачОст),
		|	СУММА(КолКонОст),
		|	СУММА(КолПриход),
		|	СУММА(КолРасход),
		|	СУММА(КолНачОстЕдОтчетов),
		|	СУММА(КолПриходЕдОтчетов),
		|	СУММА(КолРасходЕдОтчетов),
		|	СУММА(КолКонОстЕдОтчетов),
		|	СУММА(КолНачОстБазовЕд),
		|	СУММА(КолПриходБазовЕд),
		|	СУММА(КолРасходБазовЕд),
		|	СУММА(КолКонОстБазовЕд)
		|	//ИТОГИ_СВОЙСТВА
		|	//ИТОГИ_КАТЕГОРИИ
		|ПО
		|	ОБЩИЕ
		|{ИТОГИ ПО
		|	Подразделение.*,
		|	Номенклатура.*,
		|	ХарактеристикаНоменклатуры.*,
		|	СерияНоменклатуры.*,
		|	ФизЛицо.*,
		|	Регистратор.*,
		|	Период,
		|	ПериодДень,
		|	ПериодНеделя,
		|	ПериодДекада,
		|	ПериодМесяц,
		|	ПериодКвартал,
		|	ПериодПолугодие,
		|	ПериодГод
		|	//ПСЕВДОНИМЫ_СВОЙСТВА
		|	//ПСЕВДОНИМЫ_КАТЕГОРИИ
		|}

		|
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>, <Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РегМатериалы.Номенклатура" ,               "Номенклатура",               "Номенклатура",                ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Номенклатура);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РегМатериалы.Подразделение" ,              "Подразделение",              "Подразделение",               ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Подразделения);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("РегМатериалы.ХарактеристикаНоменклатуры" , "ХарактеристикаНоменклатуры", "Характеристика номенклатуры", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры);
		
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
		
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "ХарактеристикаНоменклатуры", "Характеристика номенклатуры");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "СерияНоменклатуры",          "Серия номенклатуры");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "ФизЛицо",                    "Работник");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолНачОст",          "Количество нач. остаток (ед. хран.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолПриход",          "Количество приход (ед. хран.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолРасход",          "Количество расход (ед. хран.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолКонОст",          "Количество кон. остаток (ед. хран.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолНачОстБазовЕд",   "Количество нач. остаток (баз. ед. изм.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолПриходБазовЕд",   "Количество приход (баз. ед. изм.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолРасходБазовЕд",   "Количество расход (баз. ед. изм.)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолКонОстБазовЕд",   "Количество кон. остаток (баз. ед. изм.)");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолНачОстЕдОтчетов", "Количество нач. остаток (ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолПриходЕдОтчетов", "Количество приход (ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолРасходЕдОтчетов", "Количество расход (ед. отчетов)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить( "КолКонОстЕдОтчетов", "Количество кон. остаток (ед. отчетов)");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель( "КолНачОст",          "Начальный остаток",   Ложь, "ЧЦ=15; ЧДЦ=3", "КолХран", "Количество (ед. хран.)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолПриход",          "Приход",              Ложь, "ЧЦ=15; ЧДЦ=3", "КолХран", "Количество (ед. хран.)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолРасход",          "Расход",              Ложь, "ЧЦ=15; ЧДЦ=3", "КолХран", "Количество (ед. хран.)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолКонОст",          "Конечный остаток",    Ложь, "ЧЦ=15; ЧДЦ=3", "КолХран", "Количество (ед. хран.)");
	
	УниверсальныйОтчет.ДобавитьПоказатель( "КолНачОстБазовЕд",   "Начальный остаток",   Ложь, "ЧЦ=15; ЧДЦ=3", "КолБазЕд", "Количество (баз. ед. изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолПриходБазовЕд",   "Приход",              Ложь, "ЧЦ=15; ЧДЦ=3", "КолБазЕд", "Количество (баз. ед. изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолРасходБазовЕд",   "Расход",              Ложь, "ЧЦ=15; ЧДЦ=3", "КолБазЕд", "Количество (баз. ед. изм.)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолКонОстБазовЕд",   "Конечный остаток",    Ложь, "ЧЦ=15; ЧДЦ=3", "КолБазЕд", "Количество (баз. ед. изм.)");
	
	УниверсальныйОтчет.ДобавитьПоказатель( "КолНачОстЕдОтчетов", "Начальный остаток", Истина, "ЧЦ=15; ЧДЦ=3", "КолЕдОтчетов", "Количество (ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолПриходЕдОтчетов", "Приход",            Истина, "ЧЦ=15; ЧДЦ=3", "КолЕдОтчетов", "Количество (ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолРасходЕдОтчетов", "Расход",            Истина, "ЧЦ=15; ЧДЦ=3", "КолЕдОтчетов", "Количество (ед. отчетов)");
	УниверсальныйОтчет.ДобавитьПоказатель( "КолКонОстЕдОтчетов", "Конечный остаток",  Истина, "ЧЦ=15; ЧДЦ=3", "КолЕдОтчетов", "Количество (ед. отчетов)");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Подразделение");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Подразделение");
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	УниверсальныйОтчет.ДобавитьОтбор("ФизЛицо");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>);
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формирование отчета можно установить необходимые параметры универсального отчета.
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент,,, ЭтотОбъект);

КонецПроцедуры // СформироватьОтчет()

Функция ПолучитьТекстСправкиФормы() Экспорт
	
	Возврат "";
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = Неопределено;
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
