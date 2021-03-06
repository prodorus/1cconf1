////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры, функции


////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

Процедура ДополнитьСтруктуруПечатныхФорм(СтруктураПечатныхФорм, ДокументОбъект) Экспорт
	
	// В этой конфигурации структура печатных форм не дополняется
	
КонецПроцедуры

Функция ПечатьДополнительныхФорм(ИмяМакета, Объект) Экспорт
	
	Возврат Новый ТабличныйДокумент;
	
КонецФункции

Процедура ОбработкаЗаполненияПоДругимОснованиям(Объект, Основание) Экспорт
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.КадровоеПеремещение") Тогда
		
		// Заполним реквизиты из стандартного набора.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(Объект, Основание);

		Если Основание.Проведен Тогда
			
			Запрос = Новый Запрос;
			
			Запрос.УстановитьПараметр("Основание",	Основание);
			Запрос.УстановитьПараметр("Организация",Объект.Организация);
			
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КадровоеПеремещениеРаботники.Сотрудник,
			|	КадровоеПеремещениеРаботники.ФизЛицо,
			|	КадровоеПеремещениеРаботники.ДатаНачала,
			|	КадровоеПеремещениеРаботники.ДатаОкончания,
			|	КадровоеПеремещениеРаботники.НапомнитьПоЗавершении,
			|	СоответствиеПодразделенийИПодразделенийОрганизаций.ПодразделениеОрганизации,
			|	КадровоеПеремещениеРаботники.НоваяДолжность КАК Должность,
			|	КадровоеПеремещениеРаботники.ЗанимаемыхСтавок,
			|	КадровоеПеремещениеРаботники.ГрафикРаботы
			|ИЗ
			|	Документ.КадровоеПеремещение.Работники КАК КадровоеПеремещениеРаботники
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеПодразделенийИПодразделенийОрганизаций КАК СоответствиеПодразделенийИПодразделенийОрганизаций
			|		ПО КадровоеПеремещениеРаботники.НовоеПодразделение = СоответствиеПодразделенийИПодразделенийОрганизаций.Подразделение
			|			И (СоответствиеПодразделенийИПодразделенийОрганизаций.Организация = &Организация)
			|ГДЕ
			|	КадровоеПеремещениеРаботники.Ссылка = &Основание";
			
			Объект.РаботникиОрганизации.Загрузить(Запрос.Выполнить().Выгрузить());
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаЗаполненияПоДругимОснованиям()

Процедура ДополнительныеПроверкиКадровыхДвижений(ВыборкаПоСтрокамДокумента, СтрокаНачалаСообщенияОбОшибке, Отказ, Заголовок) Экспорт

	// В этой конфигурации других проверок не предусмотрено	
	
КонецПроцедуры

// Возвращает текст поля запроса
//
// Параметры
//  нет
//
// Возвращаемое значение:
//   строка
//
Функция ПолучитьДополнительноеПолеОписанияСотрудника() Экспорт 
	
	Возврат	"НЕОПРЕДЕЛЕНО КАК ДополнительноеПоле"

КонецФункции // ПолучитьПоле()

Процедура ДобавитьДополнительноПоСтроке(ДокументОбъект, СтрокаТабличнойЧасти) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДобавитьДополнительныеДвижения(ДокументОбъект, Отказ, Заголовок) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы документа

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
Процедура ФормаДокументаПередОткрытиемДополнительно(Форма, ДополнительныеДействия, ДополнительныеОбработчики) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ФормаДокументаРаботникиПриПолученииДанныхДополнительно(ПолеРаботники, ОформленияСтрок) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // ФормаДокументаРаботникиПриПолученииДанныхДополнительно()

Процедура ДозаполнитьСтрокуДаннымиРаботникаДоНазначения(СтрокаТабличнойЧасти, Выборка) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ВыполнитьДополнительныеДействия(Форма, Кнопка) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ОбработатьДополнительноПриИзменении(Форма, Элемент) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура УдалитьДополнительноПоСтроке(Форма, Сотрудник) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ФормаДокументаРаботникиПослеУдаленияСтрокиДополнительно(Форма) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы списка

Процедура ФормаСпискаПередОткрытиемДополнительно(ФормаСписка) Экспорт
		
    // В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры // ФормаСпискаПередОткрытиемДополнительно

#КонецЕсли

Функция СформироватьЗапросПоДаннымРаботникаДоНазначения(Запрос, Ссылка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(Работники.Период) КАК Период,
	|	ТаблицаСотрудников.Сотрудник КАК Сотрудник
	|ПОМЕСТИТЬ ДатыПоследнихДвиженийРаботников
	|ИЗ
	|	ВТ_ТаблицаСотрудников КАК ТаблицаСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК Работники
	|		ПО (Работники.Период <= ТаблицаСотрудников.ДатаНачала)
	|			И ТаблицаСотрудников.Сотрудник = Работники.Сотрудник
	|			И (Работники.ПервичныйДокумент <> &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСотрудников.Сотрудник
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДатыПоследнихДвиженийРаботников.Период КАК Период,
	|	ДанныеПоРаботникуДоНазначения.ПериодЗавершения КАК ПериодЗавершения,
	|	ДатыПоследнихДвиженийРаботников.Сотрудник КАК Сотрудник,
	|	ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок КАК ЗанимаемыхСтавок,
	|	ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|	ДанныеПоРаботникуДоНазначения.Должность КАК Должность,
	|	ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения КАК ЗанимаемыхСтавокЗавершения,
	|	ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизацииЗавершения КАК ПодразделениеОрганизацииЗавершения,
	|	ДанныеПоРаботникуДоНазначения.ДолжностьЗавершения КАК ДолжностьЗавершения
	|ПОМЕСТИТЬ ДанныеПоРаботникуДоНазначения
	|ИЗ
	|	ДатыПоследнихДвиженийРаботников КАК ДатыПоследнихДвиженийРаботников
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ДанныеПоРаботникуДоНазначения
	|		ПО (ДанныеПоРаботникуДоНазначения.Период = ДатыПоследнихДвиженийРаботников.Период)
	|			И ДатыПоследнихДвиженийРаботников.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник
	|			И (ДанныеПоРаботникуДоНазначения.ПервичныйДокумент <> &Ссылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСотрудников.Сотрудник,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТаблицаСотрудников.ДатаНачала
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавокЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ЗанимаемыхСтавок
	|	КОНЕЦ КАК ЗанимаемыхСтавок,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТаблицаСотрудников.ДатаНачала
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизацииЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.ПодразделениеОрганизации
	|	КОНЕЦ КАК ПодразделениеОрганизации,
	|	ВЫБОР
	|		КОГДА ДанныеПоРаботникуДоНазначения.ПериодЗавершения <= ТаблицаСотрудников.ДатаНачала
	|				И ДанныеПоРаботникуДоНазначения.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|			ТОГДА ДанныеПоРаботникуДоНазначения.ДолжностьЗавершения
	|		ИНАЧЕ ДанныеПоРаботникуДоНазначения.Должность
	|	КОНЕЦ КАК Должность
	|ИЗ
	|	ВТ_ТаблицаСотрудников КАК ТаблицаСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеПоРаботникуДоНазначения КАК ДанныеПоРаботникуДоНазначения
	|		ПО ТаблицаСотрудников.Сотрудник = ДанныеПоРаботникуДоНазначения.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка",	Ссылка);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить();

КонецФункции
