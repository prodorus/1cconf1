﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мМассивРасчетовПоИсполнительнымЛистам Экспорт;
Перем мДлинаСуток;
Перем СоответствиеВалютныеСпособыРасчета;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Добавляет строки в таблицу удержаний на основе данных регистра сведений "ПлановыеУдержанияРаботниковОрганизаций"
//
// Параметры
//
Процедура ДобавитьСтрокиНачисленийПоРаботнику(Физлица, ГоловнаяОрганизация) Экспорт
	
	ЗапросУдержания = Новый Запрос;
	ЗапросУдержания.УстановитьПараметр("ГоловнаяОрганизация", ГоловнаяОрганизация);
	ЗапросУдержания.УстановитьПараметр("Физлица", Физлица);
	ЗапросУдержания.УстановитьПараметр("Период",  Дата);
	ЗапросУдержания.УстановитьПараметр("Регистратор", Ссылка);
	
	ЗапросУдержания.Текст =
	"ВЫБРАТЬ
	|	Удержания.ФизЛицо,
	|	Удержания.ВидРасчета,
	|	Удержания.Показатель1,
	|	Удержания.Показатель2,
	|	Удержания.Показатель3,
	|	Удержания.Показатель4,
	|	Удержания.Показатель5,
	|	Удержания.Показатель6,
	|	Удержания.Валюта1,
	|	Удержания.Валюта2,
	|	Удержания.Валюта3,
	|	Удержания.Валюта4,
	|	Удержания.Валюта5,
	|	Удержания.Валюта6,
	|	Удержания.ДокументОснование
	|ИЗ
	|	РегистрСведений.ПлановыеУдержанияРаботниковОрганизаций.СрезПоследних(
	|			&Период,
	|			Организация = &ГоловнаяОрганизация
	|				И Физлицо В (&Физлица)
	|				И Регистратор <> &Регистратор) КАК Удержания
	|ГДЕ
	|	(Удержания.Показатель1 <> 0
	|			ИЛИ Удержания.Показатель2 <> 0
	|			ИЛИ Удержания.Показатель3 <> 0
	|			ИЛИ Удержания.Показатель4 <> 0
	|			ИЛИ Удержания.Показатель5 <> 0
	|			ИЛИ Удержания.Показатель6 <> 0)
	|	И (НЕ Удержания.ДокументОснование ССЫЛКА Документ.ИсполнительныйЛист)";
	
	Выборка = ЗапросУдержания.Выполнить().Выбрать();
	
	СтруктураПоиска = Новый Структура("Физлицо, ВидРасчета, ДокументОснование, Действие");
	СтруктураПоиска.Действие = Перечисления.ВидыДействияСНачислением.НеИзменять;
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Выборка);
		
		МассивУдержаний = Удержания.НайтиСтроки(СтруктураПоиска);
		
		Если МассивУдержаний.Количество() <> 0 Тогда
			Продолжить;
		КонецЕсли;

		НоваяСтрокаТЧ = Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, Выборка);
		
		НоваяСтрокаТЧ.Действие		= Перечисления.ВидыДействияСНачислением.НеИзменять;
		НоваяСтрокаТЧ.ДатаДействия	= Дата;
		
	КонецЦикла;

КонецПроцедуры // ДобавитьСтрокиНачисленийПоРаботнику()

// Удаляет строки удержаний по РаботникиОрганизации
//
Процедура УдалитьСтрокиНачисленийПоРаботнику(Физлицо) Экспорт
	
	СтруктураПоиска = Новый Структура("Физлицо", Физлицо);
	
	МассивСтрок = Удержания.НайтиСтроки(СтруктураПоиска);
	Для Каждого СтрокаТабличнойЧасти Из МассивСтрок Цикл
		Удержания.Удалить(СтрокаТабличнойЧасти);
	КонецЦикла;
	
КонецПроцедуры // УдалитьСтрокиНачисленийПоРаботнику()

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
	Запрос.УстановитьПараметр("ПустаяОрганизация", Справочники.Организации.ПустаяСсылка());

	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Дата,
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Организация,
	|	ВЫБОР
	|		КОГДА ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Организация.ГоловнаяОрганизация = &ПустаяОрганизация
	|			ТОГДА ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Организация
	|		ИНАЧЕ ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Организация.ГоловнаяОрганизация
	|	КОНЕЦ КАК ГоловнаяОрганизация,
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Ссылка
	|ИЗ
	|	Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций КАК ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций
	|ГДЕ
	|	ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Ссылка = &ДокументСсылка";

	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоШапке()

// Формирует запрос по таблице "РаботникиОрганизации" документа
//
// Параметры: 
//  Режим - режим проведения
//
// Возвращаемое значение:
//  Результат запроса. В запросе данные документа дополняются значениями
//  проверяемых параметров из связанного с
//
Функция СформироватьЗапросПоРаботникиОрганизации(Режим)

	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ИсполнительныйЛист", ПланыВидовРасчета.УдержанияОрганизаций.ИЛФиксированнойСуммой);
	Запрос.УстановитьПараметр("МассивСпоcобовРасчетаНеТребующихВалюты",ПроведениеРасчетовПереопределяемый.ПолучитьСписокСпособовРасчетаНеТребующихУказанияВалюты());
	Запрос.УстановитьПараметр("ВалютаРегУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Если Не ЗначениеЗаполнено(мМассивРасчетовПоИсполнительнымЛистам) Тогда
		мМассивРасчетовПоИсполнительнымЛистам = ПроведениеРасчетов.МассивРасчетовПоИсполнительнымЛистам();
	КонецЕсли;
	Запрос.УстановитьПараметр("ВсеИсполнительныеЛисты", мМассивРасчетовПоИсполнительнымЛистам);
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;	
	
	// получим временную таблицу с показателями начислений
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Удержания.ВидРасчета				КАК ВидРасчета,
	|	МАКСИМУМ(Показатели.НомерСтроки)			КАК КоличествоПоказателей,
	|	Показатели1.Показатель.Предопределенный		КАК Показатель1Предопределенный,
	|	Показатели1.Показатель.Наименование			КАК Показатель1Наименование,
	|	Показатели1.Показатель.ТипПоказателя		КАК Показатель1ТипПоказателя,
	|	Показатели1.Показатель.ВозможностьИзменения КАК Показатель1ВозможностьИзменения,
	|	Показатели2.Показатель.Предопределенный		КАК Показатель2Предопределенный,
	|	Показатели2.Показатель.Наименование			КАК Показатель2Наименование,
	|	Показатели2.Показатель.ТипПоказателя		КАК Показатель2ТипПоказателя,
	|	Показатели2.Показатель.ВозможностьИзменения КАК Показатель2ВозможностьИзменения,
	|	Показатели3.Показатель.Предопределенный		КАК Показатель3Предопределенный,
	|	Показатели3.Показатель.Наименование			КАК Показатель3Наименование,
	|	Показатели3.Показатель.ТипПоказателя 		КАК Показатель3ТипПоказателя,
	|	Показатели3.Показатель.ВозможностьИзменения КАК Показатель3ВозможностьИзменения,
	|	Показатели4.Показатель.Предопределенный		КАК Показатель4Предопределенный,
	|	Показатели4.Показатель.Наименование 		КАК Показатель4Наименование,
	|	Показатели4.Показатель.ТипПоказателя 		КАК Показатель4ТипПоказателя,
	|	Показатели4.Показатель.ВозможностьИзменения КАК Показатель4ВозможностьИзменения,
	|	Показатели5.Показатель.Предопределенный		КАК Показатель5Предопределенный,
	|	Показатели5.Показатель.Наименование 		КАК Показатель5Наименование,
	|	Показатели5.Показатель.ТипПоказателя 		КАК Показатель5ТипПоказателя,
	|	Показатели5.Показатель.ВозможностьИзменения КАК Показатель5ВозможностьИзменения,
	|	Показатели6.Показатель.Предопределенный		КАК Показатель6Предопределенный,
	|	Показатели6.Показатель.Наименование 		КАК Показатель6Наименование,
	|	Показатели6.Показатель.ТипПоказателя 		КАК Показатель6ТипПоказателя,
	|	Показатели6.Показатель.ВозможностьИзменения КАК Показатель6ВозможностьИзменения,
	|	Показатели1.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель1ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели2.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель2ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели3.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель3ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели4.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель4ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели5.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель5ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели6.ЗапрашиватьПриКадровыхПеремещениях КАК Показатель6ЗапрашиватьПриКадровыхПеремещениях
	|ПОМЕСТИТЬ ВТПоказателиУдержаний
	|ИЗ
	|	Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Удержания КАК Удержания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели
	|		ПО Удержания.ВидРасчета = Показатели.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели1
	|		ПО Удержания.ВидРасчета = Показатели1.Ссылка
	|			И (Показатели1.НомерСтроки = 1)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели2
	|		ПО Удержания.ВидРасчета = Показатели2.Ссылка
	|			И (Показатели2.НомерСтроки = 2)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели3
	|		ПО Удержания.ВидРасчета = Показатели3.Ссылка
	|			И (Показатели3.НомерСтроки = 3)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели4
	|		ПО Удержания.ВидРасчета = Показатели4.Ссылка
	|			И (Показатели4.НомерСтроки = 4)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели5
	|		ПО Удержания.ВидРасчета = Показатели5.Ссылка
	|			И (Показатели5.НомерСтроки = 5)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.УдержанияОрганизаций.Показатели КАК Показатели6
	|		ПО Удержания.ВидРасчета = Показатели6.Ссылка
	|			И (Показатели6.НомерСтроки = 6)
	|ГДЕ
	|	Удержания.Ссылка = &ДокументСсылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Удержания.ВидРасчета,
	|	Показатели1.Показатель,
	|	Показатели2.Показатель,
	|	Показатели3.Показатель,
	|	Показатели4.Показатель,
	|	Показатели5.Показатель,
	|	Показатели6.Показатель,
	|	Показатели1.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели2.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели3.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели4.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели5.ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели6.ЗапрашиватьПриКадровыхПеремещениях	
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВидРасчета";		

	Запрос.Выполнить();	
	
	ВТПоказателиУдержаний = "ВТПоказателиУдержаний";	
	
	//
	// Описание текста запроса:
	//
	// 1. Выборка "Удержания":
	//		Выборка строк ТЧ Удержания. Проверка наличия строк-дублей.
	// 2. Выборка "СуществующиеДвижения":
	//		Проверяем на наличие существующих конфликтных движений в регистре сведений.
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Удержания.НомерСтроки,
	|	Удержания.Физлицо,
	|	Удержания.Физлицо.Наименование,
	|	Удержания.ВидРасчета,
	|	Удержания.ВидРасчета.ПроизвольнаяФормулаРасчета КАК ПроизвольнаяФормулаРасчета,
	|	Удержания.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	Удержания.Действие,
	|	Удержания.ДатаДействия,
	|	Удержания.ДатаДействияКонец,
	|	Удержания.Показатель1,
	|	Удержания.Показатель2,
	|	Удержания.Показатель3,
	|	Удержания.Показатель4,	
	|	Удержания.Показатель5,
	|	Удержания.Показатель6,
	|	Удержания.ДокументОснование,
	|	ВЫБОР
	|		КОГДА Удержания.ВидРасчета В (&ВсеИсполнительныеЛисты)
	|				И (НЕ Удержания.ДокументОснование ССЫЛКА Документ.ИсполнительныйЛист)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ДокументОснованиеУказанВерно,
	|	ВЫБОР
	|		КОГДА Удержания.ВидРасчета.СпособРасчета В (&МассивСпоcобовРасчетаНеТребующихВалюты)
	|				ИЛИ Удержания.ВидРасчета = &ИсполнительныйЛист
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ТребуетВалюту,
	|	Удержания.Валюта1,
	|	Удержания.Валюта2,
	|	Удержания.Валюта3,
	|	Удержания.Валюта4,
	|	Удержания.Валюта5,
	|	Удержания.Валюта6,		
	|	ЕСТЬNULL(Показатели.КоличествоПоказателей,0) КоличествоПоказателей,
	|	Показатели.Показатель1Предопределенный,
	|	Показатели.Показатель1Наименование,
	|	Показатели.Показатель1ТипПоказателя,
	|	Показатели.Показатель1ВозможностьИзменения,
	|	Показатели.Показатель2Предопределенный,
	|	Показатели.Показатель2Наименование,
	|	Показатели.Показатель2ТипПоказателя,
	|	Показатели.Показатель2ВозможностьИзменения,
	|	Показатели.Показатель3Предопределенный,
	|	Показатели.Показатель3Наименование,
	|	Показатели.Показатель3ТипПоказателя,
	|	Показатели.Показатель3ВозможностьИзменения,		
	|	Показатели.Показатель4Предопределенный,
	|	Показатели.Показатель4Наименование,
	|	Показатели.Показатель4ТипПоказателя,
	|	Показатели.Показатель4ВозможностьИзменения,		
	|	Показатели.Показатель5Предопределенный,
	|	Показатели.Показатель5Наименование,
	|	Показатели.Показатель5ТипПоказателя,
	|	Показатели.Показатель5ВозможностьИзменения,		
	|	Показатели.Показатель6Предопределенный,
	|	Показатели.Показатель6Наименование,
	|	Показатели.Показатель6ТипПоказателя,
	|	Показатели.Показатель6ВозможностьИзменения,	
	|	Удержания.КонфликтныйНомерСтроки,
	|	Показатели.Показатель1ЗапрашиватьПриКадровыхПеремещениях КАК Показатель1ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель2ЗапрашиватьПриКадровыхПеремещениях КАК Показатель2ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель3ЗапрашиватьПриКадровыхПеремещениях КАК Показатель3ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель4ЗапрашиватьПриКадровыхПеремещениях КАК Показатель4ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель5ЗапрашиватьПриКадровыхПеремещениях КАК Показатель5ЗапрашиватьПриКадровыхПеремещениях,
	|	Показатели.Показатель6ЗапрашиватьПриКадровыхПеремещениях КАК Показатель6ЗапрашиватьПриКадровыхПеремещениях
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТЧУдержания.НомерСтроки КАК НомерСтроки,
	|		ТЧУдержания.Физлицо КАК Физлицо,
	|		ТЧУдержания.ВидРасчета КАК ВидРасчета,
	|		ТЧУдержания.Действие КАК Действие,
	|		ТЧУдержания.ДатаДействия КАК ДатаДействия,
	|		ТЧУдержания.ДатаДействияКонец КАК ДатаДействияКонец,
	|		ТЧУдержания.Показатель1 КАК Показатель1,
	|		ТЧУдержания.Показатель2 КАК Показатель2,
	|		ТЧУдержания.Показатель3 КАК Показатель3,
	|		ТЧУдержания.Показатель4 КАК Показатель4,
	|		ТЧУдержания.Показатель5 КАК Показатель5,
	|		ТЧУдержания.Показатель6 КАК Показатель6,
	|		ТЧУдержания.Валюта1 КАК Валюта1,
	|		ТЧУдержания.Валюта2 КАК Валюта2,
	|		ТЧУдержания.Валюта3 КАК Валюта3,	
	|		ТЧУдержания.Валюта4 КАК Валюта4,	
	|		ТЧУдержания.Валюта5 КАК Валюта5,
	|		ТЧУдержания.Валюта6 КАК Валюта6,		
	|		МИНИМУМ(ПовторяющиесяСтроки.НомерСтроки) КАК КонфликтныйНомерСтроки,
	|		ТЧУдержания.ДокументОснование КАК ДокументОснование,
	|		ТЧУдержания.Ссылка КАК Ссылка
	|	ИЗ
	|		Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Удержания КАК ТЧУдержания
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.Удержания КАК ПовторяющиесяСтроки
	|			ПО ТЧУдержания.Ссылка = ПовторяющиесяСтроки.Ссылка
	|				И ТЧУдержания.НомерСтроки < ПовторяющиесяСтроки.НомерСтроки
	|				И ТЧУдержания.ВидРасчета = ПовторяющиесяСтроки.ВидРасчета
	|				И ТЧУдержания.ДатаДействия = ПовторяющиесяСтроки.ДатаДействия
	|				И ТЧУдержания.ДокументОснование = ПовторяющиесяСтроки.ДокументОснование
	|				И ТЧУдержания.Физлицо = ПовторяющиесяСтроки.Физлицо
	|	ГДЕ
	|		ТЧУдержания.Ссылка = &ДокументСсылка
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТЧУдержания.НомерСтроки,
	|		ТЧУдержания.ВидРасчета,
	|		ТЧУдержания.Действие,
	|		ТЧУдержания.ДатаДействия,
	|		ТЧУдержания.ДатаДействияКонец,
	|		ТЧУдержания.Показатель1,
	|		ТЧУдержания.Показатель2,	
	|		ТЧУдержания.Показатель3,	
	|		ТЧУдержания.Показатель4,
	|		ТЧУдержания.Показатель5,
	|		ТЧУдержания.Показатель6,		
	|		ТЧУдержания.Валюта1,
	|		ТЧУдержания.Валюта2,	
	|		ТЧУдержания.Валюта3,
	|		ТЧУдержания.Валюта4,
	|		ТЧУдержания.Валюта5,
	|		ТЧУдержания.Валюта6,		
	|		ТЧУдержания.ДокументОснование,
	|		ТЧУдержания.Ссылка,
	|		ТЧУдержания.Физлицо) КАК Удержания
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВТПоказателиУдержаний КАК Показатели
	|	ПО Удержания.ВидРасчета = Показатели.ВидРасчета";
	
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции // СформироватьЗапросПоРаботникиОрганизации()

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
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПреобразоватьСтрокуИнтерфейса("Не указана организация, в которой работает сотрудник!"), Отказ, Заголовок);
	КонецЕсли;

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения реквизитов в строке ТЧ "Удержания" документа.
// Если какой-то из реквизитов, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверка выполняется по выборке из результата запроса по строке ТЧ документа,
// все проверяемые реквизиты должны быть включены в выборку.
//
// Параметры: 
//  ВыборкаПоШапкеДокумента		- выборка из результата запроса по шапке документа,
//  ВыборкаПоСтрокамДокумента	- спозиционированная на определенной строке выборка 
//  							  из результата запроса
//  Отказ 						- флаг отказа в проведении.
//	Заголовок				- Заголовок для сообщений об ошибках проведения
//
Процедура ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоСтрокамДокумента, Отказ, Заголовок)

	СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(ВыборкаПоСтрокамДокумента.НомерСтроки) +
									""" табл. части ""Удержания"": ";
	
	// Физлицо
	НетФизлица = НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Физлицо);
	Если НетФизлица Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не выбрано физическое лицо!", Отказ, Заголовок);
	КонецЕсли;

	// Вид расчета
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ВидРасчета) И ВыборкаПоСтрокамДокумента.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указано удержание!", Отказ, Заголовок);
	КонецЕсли;
	
	// Действие
	Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.Действие) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указано действие с удержанием!", Отказ, Заголовок);
	ИначеЕсли ВыборкаПоСтрокамДокумента.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять Тогда	
	
		// ДатаДействия
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаДействия) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указана дата действия удержания!", Отказ, Заголовок);
		КонецЕсли;
		
		// Одинаковые строки
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.КонфликтныйНомерСтроки) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке  + "по сотруднику " + ВыборкаПоСтрокамДокумента.ФизлицоНаименование + " обнаружено повторное назначение того же удержания в строке №" + ВыборкаПоСтрокамДокумента.КонфликтныйНомерСтроки + "!", Отказ, Заголовок);
		КонецЕсли;
		
		Если ВыборкаПоСтрокамДокумента.Действие <> Перечисления.ВидыДействияСНачислением.Прекратить И  ВыборкаПоСтрокамДокумента.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять Тогда
			ИспользуютсяНачисленияВВалюте = ПроцедурыУправленияПерсоналом.ЗначениеУчетнойПолитикиПоПерсоналуОрганизации(глЗначениеПеременной("глУчетнаяПолитикаПоПерсоналуОрганизации"), Организация, "ИспользуютсяНачисленияВВалюте");
			ПроведениеРасчетовПереопределяемый.ПроверкаПоказателейВПлановыхНачислениях(ВыборкаПоСтрокамДокумента, СтрокаНачалаСообщенияОбОшибке, Ложь, Отказ, Заголовок, ИспользуютсяНачисленияВВалюте,СоответствиеВалютныеСпособыРасчета);
		КонецЕсли;

		// Основание
		Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДокументОснование) Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "не указано основание удержания!", Отказ, Заголовок);
			
		ИначеЕсли Не ВыборкаПоСтрокамДокумента.ДокументОснованиеУказанВерно Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "в основании указан недопустимый документ (требуется Исполнительный лист)!", Отказ, Заголовок);
			
		КонецЕсли;
		
		// Перид действия
		Если ЗначениеЗаполнено(ВыборкаПоСтрокамДокумента.ДатаДействияКонец) И ВыборкаПоСтрокамДокумента.ДатаДействия > ВыборкаПоСтрокамДокумента.ДатаДействияКонец Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(СтрокаНачалаСообщенияОбОшибке + "дата окончания действия не должна быть меньше даты начала!", Отказ, Заголовок);
		КонецЕсли; 
		
	КонецЕсли;
		
КонецПроцедуры // ПроверитьЗаполнениеСтрокиУдержания()

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
	СтруктураПроведенияПоРегистрамСведений.Вставить("ПлановыеУдержанияРаботниковОрганизаций");

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
Процедура ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, 
		  СтруктураПроведенияПоРегистрамСведений, СтруктураПараметров = "")

	// Если документ нужно проводить по регистру, то для него есть ключ в структуре
	ИмяРегистра = "ПлановыеУдержанияРаботниковОрганизаций";
	Если СтруктураПроведенияПоРегистрамСведений.Свойство(ИмяРегистра) Тогда

		Если ВыборкаПоРаботникиОрганизации.Действие <> Перечисления.ВидыДействияСНачислением.НеИзменять тогда
			
			Движение = Движения[ИмяРегистра].Добавить();
			
			// Свойства
			Движение.Период				= ВыборкаПоРаботникиОрганизации.ДатаДействия;
			
			// Измерения
			Движение.Физлицо			= ВыборкаПоРаботникиОрганизации.Физлицо;
			Движение.ВидРасчета			= ВыборкаПоРаботникиОрганизации.ВидРасчета;
			Движение.Организация		= ВыборкаПоШапкеДокумента.ГоловнаяОрганизация;
			Движение.ДокументОснование	= ВыборкаПоРаботникиОрганизации.ДокументОснование;
			
			// Ресурсы
			Движение.Действие			= ВыборкаПоРаботникиОрганизации.Действие;
			
			Если ВыборкаПоРаботникиОрганизации.Действие <> Перечисления.ВидыДействияСНачислением.Прекратить Тогда
				Для Сч = 1 По 6 Цикл
					Если ВыборкаПоРаботникиОрганизации.ПроизвольнаяФормулаРасчета Тогда
						Если Сч <= ВыборкаПоРаботникиОрганизации.КоличествоПоказателей Тогда
							Если ВыборкаПоРаботникиОрганизации["Показатель" + Сч + "ЗапрашиватьПриКадровыхПеремещениях"] Тогда
								Движение["Показатель"+Сч]			= ВыборкаПоРаботникиОрганизации["Показатель"+Сч];
								Движение["Валюта"+Сч]				= ВыборкаПоРаботникиОрганизации["Валюта"+Сч];
							Иначе
								Движение["Показатель"+Сч]			= 0;
								Движение["Валюта"+Сч]				= Справочники.Валюты.ПустаяСсылка();
							КонецЕсли;
						Иначе
							Движение["Показатель"+Сч]			= 0;
							Движение["Валюта"+Сч]				= Справочники.Валюты.ПустаяСсылка();
						КонецЕсли;
					Иначе
						Движение["Показатель"+Сч]			= ВыборкаПоРаботникиОрганизации["Показатель"+Сч];
						Движение["Валюта"+Сч]				= ВыборкаПоРаботникиОрганизации["Валюта"+Сч];
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Если ЗначениеЗаполнено(ВыборкаПоРаботникиОрганизации.ДатаДействияКонец) Тогда
				Движение.ПериодЗавершения   = ВыборкаПоРаботникиОрганизации.ДатаДействияКонец + мДлинаСуток;
				Движение.ДействиеЗавершения	= Перечисления.ВидыДействияСНачислением.Прекратить;
				// не заполняются
				//СпособОтраженияВБухучетеЗавершения
				//РазмерЗавершения
				//ВалютаЗавершения
			КонецЕсли;
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры // ДобавитьСтрокуВДвиженияПоРегистрамСведений

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	
	//структура, содержащая имена регистров сведений по которым надо проводить документ
	Перем СтруктураПроведенияПоРегистрамСведений;

	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначенияЗК.ПредставлениеДокументаПриПроведении(Ссылка);
	
	СоответствиеВалютныеСпособыРасчета = ПроведениеРасчетов.ПолучитьСоответствиеСпособовРасчетаТребующихВалюту();

	РезультатЗапросаПоШапке = СформироватьЗапросПоШапке(Режим);

	// Получим реквизиты шапки из запроса
	ВыборкаПоШапкеДокумента = РезультатЗапросаПоШапке.Выбрать();

	Если ВыборкаПоШапкеДокумента.Следующий() Тогда

		//Надо позвать проверку заполнения реквизитов шапки
		ПроверитьЗаполнениеШапки(ВыборкаПоШапкеДокумента, Отказ, Заголовок);

		// Движения стоит добавлять, если в проведении еще не отказано (отказ =ложь)
		Если НЕ Отказ Тогда

			// Создадим и заполним структуры, содержащие имена регистров, по которым в зависимости от типа учета
			// проводится документ. В дальнейшем будем считать, что если для регистра не создан ключ в структуре,
			// то проводить по нему не надо.
			ЗаполнитьСтруктуруПроведенияПоРегистрамСведений(ВыборкаПоШапкеДокумента, СтруктураПроведенияПоРегистрамСведений);

			// получим реквизиты табличной части
			РезультатЗапросаПоРаботники = СформироватьЗапросПоРаботникиОрганизации(Режим);
			ВыборкаПоРаботникиОрганизации = РезультатЗапросаПоРаботники.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

			Пока ВыборкаПоРаботникиОрганизации.Следующий() Цикл

				// проверим очередную строку табличной части
				ПроверитьЗаполнениеСтрокиУдержания(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, Отказ, Заголовок);

				Если НЕ Отказ Тогда

					// Заполним записи в наборах записей регистров
					ДобавитьСтрокуВДвиженияПоРегистрамСведений(ВыборкаПоШапкеДокумента, ВыборкаПоРаботникиОрганизации, СтруктураПроведенияПоРегистрамСведений);
					
				КонецЕсли;

			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;

	ОбработкаКомментариев.ПоказатьСообщения();
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Не ЗначениеЗаполнено(мМассивРасчетовПоИсполнительнымЛистам) Тогда
		мМассивРасчетовПоИсполнительнымЛистам = ПроведениеРасчетов.МассивРасчетовПоИсполнительнымЛистам();
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивТЧ = Новый Массив();
	МассивТЧ.Добавить(Удержания);
	
	КраткийСоставДокумента = ПроцедурыУправленияПерсоналом.ЗаполнитьКраткийСоставДокумента(МассивТЧ, "Физлицо");
	
	Если Ссылка.Пустая() Тогда
		СcылкаОбъекта = Документы.ВводСведенийОПлановыхУдержанияхРаботниковОрганизаций.ПолучитьСсылку();
		УстановитьСсылкуНового(СcылкаОбъекта);
		
	Иначе
		СcылкаОбъекта = Ссылка;
		
	КонецЕсли;
	
	// Для каждого удержания (не исполнительного листа) в поле "Основание", для незаполненного 
	// значения подставим ссылку на документ
	Для Каждого СтрокаТЧ Из Удержания Цикл
	
		Если мМассивРасчетовПоИсполнительнымЛистам.Найти(СтрокаТЧ.ВидРасчета) = Неопределено Тогда
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ДокументОснование) Тогда
				Если ТипЗнч(СтрокаТЧ.ДокументОснование) <> Тип("ДокументСсылка.ВводПостоянногоНачисленияИлиУдержанияСотрудникамОрганизации") Тогда
					Если СтрокаТЧ.ДокументОснование = Неопределено Тогда
						СтрокаТЧ.ДокументОснование = СcылкаОбъекта;
					ИначеЕсли СтрокаТЧ.ДокументОснование.Удержания.Количество() = 0 И НЕ ЗначениеЗаполнено(СтрокаТЧ.ДокументОснование.Дата) Тогда
						СтрокаТЧ.ДокументОснование = СcылкаОбъекта;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры // ПередЗаписью()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мДлинаСуток = 86400;

