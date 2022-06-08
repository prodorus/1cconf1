﻿// Процедура предназначена для заполнения общих реквизитов документов,
// вызывается в обработчиках событий "ПриОткрытии" в модулех форм всех документов.
//
// Параметры:
//  ДокументОбъект                 - объект редактируемого документа,
//  ТекПользователь                - ссылка на справочник, определяет текущего пользователя  
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//
Процедура ЗаполнитьШапкуДокумента(ДокументОбъект, ТекПользователь, ВалютаРегламентированногоУчета = Неопределено) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();

	Если МетаданныеДокумента.Реквизиты.Найти("Ответственный") <> Неопределено Тогда
		ДокументОбъект.Ответственный = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнойОтветственный");
	КонецЕсли;
	
	// Флаги принадлежности к учету заполняем, только если оба не заполнены
	Если МетаданныеДокумента.Реквизиты.Найти("ОтражатьВУправленческомУчете") <> Неопределено
		И МетаданныеДокумента.Реквизиты.Найти("ОтражатьВБухгалтерскомУчете") <> Неопределено Тогда
		Если Не (ДокументОбъект.ОтражатьВУправленческомУчете 
			или ДокументОбъект.ОтражатьВБухгалтерскомУчете) Тогда
			
			ДокументОбъект.ОтражатьВУправленческомУчете = Ложь;
			ДокументОбъект.ОтражатьВБухгалтерскомУчете  = Истина;
			
			Если МетаданныеДокумента.Реквизиты.Найти("ОтражатьВНалоговомУчете") <> Неопределено Тогда
				ДокументОбъект.ОтражатьВНалоговомУчете = Истина;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если МетаданныеДокумента.Реквизиты.Найти("Подразделение") <> Неопределено 
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.Подразделение)) Тогда
		ДокументОбъект.Подразделение = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеПодразделение");
	КонецЕсли;
	
	ПроверятьСоответствиеПодразделенияОрганизации = Ложь;
	Если МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено Тогда
		ЭтоУпрДокумент =  МетаданныеДокумента.Реквизиты.Найти("ОтражатьВУправленческомУчете") <> Неопределено И ДокументОбъект.ОтражатьВУправленческомУчете;
		Если Не ЭтоУпрДокумент Тогда
			ПроверятьСоответствиеПодразделенияОрганизации = Истина;
			Если (НЕ ЗначениеЗаполнено(ДокументОбъект.Организация)) Тогда
				ДокументОбъект.Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновнаяОрганизация");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если МетаданныеДокумента.Реквизиты.Найти("ВидОперации") <> Неопределено
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.ВидОперации)) Тогда
		ДокументОбъект.ВидОперации = Перечисления[ДокументОбъект.ВидОперации.Метаданные().Имя][0];
	КонецЕсли;

	Если МетаданныеДокумента.Реквизиты.Найти("СчетОрганизации") <> Неопределено
		И (НЕ ЗначениеЗаполнено(ДокументОбъект.СчетОрганизации))
		И (ЗначениеЗаполнено(ДокументОбъект.Организация.ЮрФизЛицо)) Тогда
		СчетПоУмолчанию = ДокументОбъект.Организация.ОсновнойБанковскийСчет;
		ДокументОбъект.СчетОрганизации = СчетПоУмолчанию;
		Если МетаданныеДокумента.Реквизиты.Найти("ВалютаДокумента") <> Неопределено
			И (НЕ ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента)) Тогда
			ДокументОбъект.ВалютаДокумента =  СчетПоУмолчанию.ВалютаДенежныхСредств;
		КонецЕсли;
	КонецЕсли;
	
	Если МетаданныеДокумента.Реквизиты.Найти("ПодразделениеОрганизации") <> Неопределено
	   И (НЕ ЗначениеЗаполнено(ДокументОбъект.ПодразделениеОрганизации)) Тогда
	   ПодразделениеПоУмолчанию = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ТекПользователь, "ОсновноеПодразделениеОрганизации");;
	   Если ПроверятьСоответствиеПодразделенияОрганизации Тогда
		   Если ПодразделениеПоУмолчанию.Владелец = ДокументОбъект.Организация Тогда
			   ДокументОбъект.ПодразделениеОрганизации = ПодразделениеПоУмолчанию;
		   КонецЕсли;
	   Иначе 	
		   ДокументОбъект.ПодразделениеОрганизации = ПодразделениеПоУмолчанию;
	   КонецЕсли;
	КонецЕсли;
		
	Если МетаданныеДокумента.Реквизиты.Найти("ВалютаДокумента") <> Неопределено
	   И (НЕ ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента)) Тогда
		ДокументОбъект.ВалютаДокумента = ВалютаРегламентированногоУчета;
	КонецЕсли;

	Если МетаданныеДокумента.Реквизиты.Найти("КурсДокумента") <> Неопределено
	   И (НЕ ЗначениеЗаполнено(ДокументОбъект.КурсДокумента)) Тогда
	    СтруктураКурсаДокумента      = МодульВалютногоУчета.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента, ДокументОбъект.Дата);
		ДокументОбъект.КурсДокумента = СтруктураКурсаДокумента.Курс;

		Если МетаданныеДокумента.Реквизиты.Найти("КратностьДокумента") <> Неопределено Тогда
			ДокументОбъект.КратностьДокумента = СтруктураКурсаДокумента.Кратность;
		КонецЕсли;
	КонецЕсли;

	Если МетаданныеДокумента.Реквизиты.Найти("ПериодРегистрации") <> Неопределено
	   И (НЕ ЗначениеЗаполнено(ДокументОбъект.ПериодРегистрации)) Тогда
		ДокументОбъект.ПериодРегистрации = НачалоМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьШапкуДокумента()

Процедура ДобавитьТаблицыВЗапросПолученияДействийСНачислениями(ТекстЗапроса) Экспорт
	
	//	В этой конфигурации дополнительных таблиц не предусмотрено
	
КонецПроцедуры

Процедура ДобавитьОбъединенияВЗапросПолученияДействийСНачислениями(ТекстЗапроса, ЧастьЗапроса) Экспорт
	
	Если ЧастьЗапроса = 1 Тогда
		ПолеПодразделение 	= "СтароеПодразделениеОрганизации";
		ПолеДолжность		= "СтараяДолжность";
	Иначе
		ПолеПодразделение 	= "Подразделение";
		ПолеДолжность		= "Должность";
	КонецЕсли;
	
	ЗаполнениеНачислениямиДополнительный.ДобавитьОбъединенияВЗапросПолученияДействийСНачислениями(ТекстЗапроса, ПолеПодразделение, ПолеДолжность);
	
КонецПроцедуры

Функция ВалютаПоказателяИмяПоляЗапроса() Экспорт
	
	ИмяПоляЗапроса = ЗаполнениеНачислениямиДополнительный.ВалютаПоказателяИмяПоляЗапроса();
	
	Возврат ?(ЗначениеЗаполнено(ИмяПоляЗапроса), ИмяПоляЗапроса, "");
	
КонецФункции

Процедура ДополнитьЗапросПолученияДействийСНачислениями(Запрос, ТекстЗапроса) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДополнитьЗапросПоНачислениямОтбором(ТекстЗапроса, ДокументСсылка) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДополнитьЗапросПоЗаписямПлановыхНачислений(ТекстЗапроса) Экспорт

	// В этой конфигурации дополнительных действий не предусмотрено

КонецПроцедуры // ДополнитьЗапросПоЗаписямПлановыхНачислений()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОЛУЧЕНИЯ СВЕДЕНИЙ О ВИДАХ РАСЧЕТА
	
Процедура ДополнитьСведенияПВРПоТипуВР(СведенияПВРПоТипуВР) Экспорт
	
	СведенияПВРПоТипуВР.Вставить(Тип("ПланВидовРасчетаСсылка.УправленческиеНачисления"),	ЗаполнениеДокументовЗК.СтруктураСведенийПВР("УправленческиеНачисления", Истина, Ложь, Ложь));
	СведенияПВРПоТипуВР.Вставить(Тип("ПланВидовРасчетаСсылка.УправленческиеУдержания"),		ЗаполнениеДокументовЗК.СтруктураСведенийПВР("УправленческиеУдержания", Ложь, Ложь, Ложь));
	
КонецПроцедуры

Функция СкрыватьПредопределенныйПоказатель(Показатель, Режим) Экспорт
	
	Возврат Истина;
	
КонецФункции

// Проверяет способ расчета на предмет поддержке в этой конфигурации, если поддерживается
// возвращает Истина
//
// Параметры
//  СпособРасчета  		  - Перечисление.СпособыРасчетаОплатыТруда
//
// Возвращаемое значение:
//   Булево   - Истина - Поддерживается, Ложь - не поддерживается
//
Функция ЕстьЧемДополнитьСведенияОСпособеРасчета(СпособРасчета) Экспорт

	Возврат Ложь;

КонецФункции

// Дополняет структуру сведений о показателях для предопределенного способа расчета
//
// Параметры
//  СпособРасчета  		  - Перечисление.СпособыРасчетаОплатыТруда
//  СведенияОВидеРасчета  - Структура, содержащия сведения о виде расчета
//
Процедура ДополнитьСведенияОСпособеРасчета(СпособРасчета, СведенияОВидеРасчета) Экспорт
	
	// В этой конфигурации дополнительных действий не предусмотрено
	
КонецПроцедуры

Процедура ДополнитьСведенияОВидеРасчета(СведенияОВидеРасчета, ВидРасчета = Неопределено) Экспорт
	
	Если СведенияОВидеРасчета.СпособРасчета = Перечисления.СпособыРасчетаОплатыТруда.ДоначислениеПоУправленческомуУчету Тогда
		СведенияОВидеРасчета.Вставить("Показатель1Наименование", "Сумма");
		СведенияОВидеРасчета.Вставить("Показатель1Видимость", Истина);
		СведенияОВидеРасчета.Вставить("Показатель1НаименованиеВидимость", Истина);
		СведенияОВидеРасчета.Вставить("Валюта1Видимость", Ложь);
		СведенияОВидеРасчета.Вставить("КоличествоПоказателей",0);
		СведенияОВидеРасчета.Вставить("Показатель1Точность", 2);
	КонецЕсли;
	
	Если ВидРасчета = ПланыВидовРасчета.УправленческиеУдержания.УдержаноПоБухгалтерии Тогда
		СведенияОВидеРасчета.Вставить("Показатель1Наименование", "Удержано по бухгалтерии");
		СведенияОВидеРасчета.Вставить("Показатель1Видимость", Истина);
		СведенияОВидеРасчета.Вставить("Показатель1НаименованиеВидимость", Ложь);
		СведенияОВидеРасчета.Вставить("Валюта1Видимость", Ложь);
		СведенияОВидеРасчета.Вставить("Показатель1Точность", 2);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОбъединенияВЗапросВидыРасчета(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УправленческиеНачисления.Ссылка,
	|	УправленческиеНачисления.СпособРасчета,
	|	ЛОЖЬ,
	|	УправленческиеНачисления.ЗачетОтработанногоВремени
	|ИЗ
	|	ПланВидовРасчета.УправленческиеНачисления КАК УправленческиеНачисления
	|ГДЕ
	|	УправленческиеНачисления.Ссылка В(&Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УправленческиеУдержания.Ссылка,
	|	УправленческиеУдержания.СпособРасчета,
	|	ЛОЖЬ,
	|	ЛОЖЬ
	|ИЗ
	|	ПланВидовРасчета.УправленческиеУдержания КАК УправленческиеУдержания
	|ГДЕ
	|	УправленческиеУдержания.Ссылка В(&Ссылка)";

КонецПроцедуры

Процедура ДобавитьОбъединенияВЗапросПоказатели(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УправленческиеНачисленияПоказатели.Ссылка,
	|	УправленческиеНачисленияПоказатели.Показатель,
	|	УправленческиеНачисленияПоказатели.НомерСтроки,
	|	УправленческиеНачисленияПоказатели.ЗапрашиватьПриКадровыхПеремещениях
	|ИЗ
	|	ПланВидовРасчета.УправленческиеНачисления.Показатели КАК УправленческиеНачисленияПоказатели
	|ГДЕ
	|	УправленческиеНачисленияПоказатели.Ссылка В(&Ссылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	УправленческиеУдержанияПоказатели.Ссылка,
	|	УправленческиеУдержанияПоказатели.Показатель,
	|	УправленческиеУдержанияПоказатели.НомерСтроки,
	|	УправленческиеУдержанияПоказатели.ЗапрашиватьПриКадровыхПеремещениях
	|ИЗ
	|	ПланВидовРасчета.УправленческиеУдержания.Показатели КАК УправленческиеУдержанияПоказатели
	|ГДЕ
	|	УправленческиеУдержанияПоказатели.Ссылка В(&Ссылка)";

КонецПроцедуры

Функция ПолеЗапросаВводВалютныхЗначений() Экспорт
	
	Возврат "
	|	ВЫБОР
	|		КОГДА Показатели.Валюта В (ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка), Константы.ВалютаУправленческогоУчета)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ВводВалютныхЗначений,
	|";
	
КонецФункции

Функция ПолеЗапросаТочностьПредставленияПоказателя() Экспорт
	
	Возврат УправлениеПоказателямиСхемМотивации.ПолеЗапросаТочностьПредставленияПоказателя();
	
КонецФункции
