﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Формирование печатной формы для внутренней сертификации
// 
Функция ПечатьАналитическогоПаспорта() Экспорт

	ТабДок = Новый ТабличныйДокумент;
	Макет  = ПолучитьМакет("АналитическийПаспорт");
	Секция = Макет.ПолучитьОбласть("Шапка");
	Секция.Параметры.Организация = Организация;
	ФильтрОтбораИнф = Новый Структура( "Объект, Тип, Вид",
		Организация,
		Перечисления.ТипыКонтактнойИнформации.Адрес,
		Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации);
		
	Выборка = РегистрыСведений.КонтактнаяИнформация.Получить(ФильтрОтбораИнф);
	Секция.Параметры.Адрес             = Выборка.Представление;
	АттестатКонтрагента                = УправлениеСертификациейНоменклатуры.ПолучитьАттестатАккредитации(Организация,Дата);
	Секция.Параметры.Аттестат          = АттестатКонтрагента;
	Секция.Параметры.НомерДок          = Строка(Номер) + " от " + Строка(Формат(Дата,"ДЛФ=DD"));
	Секция.Параметры.Номенклатура      = Номенклатура;
	Секция.Параметры.СерияНоменклатуры = СерияНоменклатуры.Наименование;
	Секция.Параметры.СерияНоменклатурыРасшифровка = СерияНоменклатуры;
	Секция.Параметры.СрокГодности      = Формат(СерияНоменклатуры.СрокГодности, "ДЛФ=DD");
	Секция.Параметры.ДатаИзготовления  = Формат(УправлениеСертификациейНоменклатуры.ПолучитьДатуЗавершенияПроизводстваСерии(СерияНоменклатуры), "ДЛФ=DD");
	
	Если ЗначениеЗаполнено(СерияНоменклатуры) Тогда
		КолвоСерии = УправлениеСертификациейНоменклатуры.ПолучитьОбщееКоличествоПоступленияПоСериям( СерияНоменклатуры);
		Если КолвоСерии = 0 Тогда
			Секция.Параметры.Количество = " - ";
		Иначе
			Секция.Параметры.Количество = Строка(Формат( КолвоСерии, "ЧДЦ=3")) + "  "
										+ Строка(Номенклатура.ЕдиницаХраненияОстатков);
		КонецЕсли;
	Иначе
		Секция.Параметры.Количество = " - ";
	КонецЕсли;
	
	Секция.Параметры.НормативныйДокумент  = НормативныйДокумент;
	Секция.Параметры.РегистрационныйНомер = СерияНоменклатуры.Наименование;
	ТабДок.Вывести(Секция);
	
	Диапазон = "";
	
	Если ДатаНачалаИспытаний <> '00010101' Тогда
		Диапазон = Диапазон + Формат(ДатаНачалаИспытаний, "ДФ=dd.MM.yy");
	КонецЕсли;
	
	Если ДатаОкончанияИспытаний <> '00010101' Тогда
		Если Диапазон = "" Тогда
			Диапазон = Диапазон + Формат( ДатаНачалаИспытаний, "ДФ=dd.MM.yy");
		Иначе
			Диапазон = Диапазон + " - " + Формат( ДатаОкончанияИспытаний, "ДФ=dd.MM.yy");
		КонецЕсли;
	КонецЕсли;
	
	Секция = Макет.ПолучитьОбласть("Строка");
	
	Для Каждого СтрокаИспытаний из Анализы Цикл
		Секция.Параметры.ДатаИспытаний           = Диапазон;
		Секция.Параметры.НаименованиеПоказателей = СтрокаИспытаний.ПоказательАнализа;
		
		Если СтрокаИспытаний.ПоказательАнализа.ВидРезультатаАнализа = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры.Поддиапазон Тогда
			Секция.Параметры.РезультатАнализа    = Строка(СтрокаИспытаний.ЗначениеПоказателя) + "..." + Строка(СтрокаИспытаний.МаксЗначениеПоказателя);
		Иначе
			Секция.Параметры.РезультатАнализа    = СтрокаИспытаний.ЗначениеПоказателя;
		КонецЕсли;
		
		Если СтрокаИспытаний.ПоказательАнализа.ВидРезультатаАнализа = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры.ЧислоВИнтервале Тогда
			Секция.Параметры.НормаНД = Строка(СтрокаИспытаний.ПоказательАнализа.МинЗначение) + "..." + Строка(СтрокаИспытаний.ПоказательАнализа.МаксЗначение);
		ИначеЕсли СтрокаИспытаний.ПоказательАнализа.ВидРезультатаАнализа = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры.Погрешность Тогда
			Секция.Параметры.НормаНД = Строка(СтрокаИспытаний.ПоказательАнализа.МинЗначение) + " ± " + Строка(СтрокаИспытаний.ПоказательАнализа.МаксЗначение);
		ИначеЕсли СтрокаИспытаний.ПоказательАнализа.ВидРезультатаАнализа = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры.Поддиапазон Тогда
			Секция.Параметры.НормаНД = Строка(СтрокаИспытаний.ПоказательАнализа.МинЗначение) + "..." + Строка(СтрокаИспытаний.ПоказательАнализа.МаксЗначение);
		ИначеЕсли СтрокаИспытаний.ПоказательАнализа.ВидРезультатаАнализа = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры.ЗначениеИзСписка Тогда
			ТекстНД = "";
			Для Каждого ЗначСписка Из СтрокаИспытаний.ПоказательАнализа.ДопустимыеЗначенияПоказателей Цикл
				ТекстНД = ТекстНД + ?(ПустаяСтрока(ТекстНД), "", "," + Символы.ПС) + Строка(ЗначСписка.ЗначениеПоказателя.Наименование);
			КонецЦикла;
			Секция.Параметры.НормаНД = ТекстНД;
		Иначе
			Секция.Параметры.НормаНД = "";
		КонецЕсли;
		
		ТабДок.Вывести(Секция);
		Диапазон = "";
	КонецЦикла;
	
	Секция = Макет.ПолучитьОбласть("Подвал");
	Секция.Параметры.Заключение = Заключение;
	ТабДок.ОтображатьЗаголовки  = Ложь;
	ТабДок.ОтображатьСетку      = Ложь;
	ТабДок.ТолькоПросмотр       = Истина;
	ТабДок.Вывести(Секция);
	
	Возврат ТабДок;
	
КонецФункции // ПечатьАналитическогоПаспорта()

// В зависимости от выбранного пользователем элемента из динамического списка печатных форм
// активизирует соответствующую процедуру печати
// 
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли; 

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяМакета = "АналитическийПаспорт" Тогда
		ТабДокумент = ПечатьАналитическогоПаспорта();	
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;
	
	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);
	
КонецПроцедуры // Печать()

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("АналитическийПаспорт", "Аналитический паспорт");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

#КонецЕсли

// Процедура проверки заполненности реквизитов документа
//
Процедура ПроверкаРеквизитов(Отказ, Заголовок)
	
	Если НЕ ЗначениеЗаполнено(Номенклатура) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнена Номенклатура!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ Номенклатура.ТребуетсяВнешняяСертификация И НЕ Номенклатура.ТребуетсяВнутренняяСертификация Тогда
		
		ОбщегоНазначения.СообщитьОбОшибке("Для номенклатуры не требуется сертификация номенклатуры!", Отказ, Заголовок);
		
	ИначеЕсли НЕ Номенклатура.ТребуетсяВнешняяСертификация И ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.Внешняя Тогда
		
		ОбщегоНазначения.СообщитьОбОшибке("Для номенклатуры не требуется внешняя сертификация номенклатуры!", Отказ, Заголовок);
		
	ИначеЕсли НЕ Номенклатура.ТребуетсяВнутренняяСертификация И ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.Внутренняя Тогда
		
		ОбщегоНазначения.СообщитьОбОшибке("Для номенклатуры не требуется внутренняя сертификация номенклатуры!", Отказ, Заголовок);
		
	КонецЕсли;  

	Если НЕ ЗначениеЗаполнено(СерияНоменклатуры) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнена Серия номенклатуры!", Отказ, Заголовок);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РезультатСертификации) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан результат сертификации! Документ не записан", Отказ, Заголовок);
		Возврат;
	КонецЕсли;
	
	РеквизитыТаб = "ПоказательАнализа";
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти( ЭтотОбъект, "Анализы", Новый Структура(РеквизитыТаб), Отказ, Заголовок);
	
	Если НЕ Отказ Тогда
		
		ПВХ = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры;
		
		Для Каждого СтрокаТЧ Из Анализы Цикл
			
			ВидРезультата = СтрокаТЧ.ПоказательАнализа.ВидРезультатаАнализа;
			
			Если ВидРезультата = ПВХ.ЗначениеИзСписка Тогда
				
				Если НЕ ЗначениеЗаполнено(СтрокаТЧ.ЗначениеПоказателя) Тогда
					ОбщегоНазначения.СообщитьОбОшибке("Укажите значение показателя (строка № " + СтрокаТЧ.НомерСтроки + ")", Отказ, Заголовок);
				КонецЕсли;
				
			ИначеЕсли ВидРезультата = ПВХ.Поддиапазон Тогда
				
				Если СтрокаТЧ.ЗначениеПоказателя = Неопределено Тогда
					ОбщегоНазначения.СообщитьОбОшибке("Не указано начало диапазона (строка № " + СтрокаТЧ.НомерСтроки + ")", Отказ, Заголовок);
				КонецЕсли;
				
				Если СтрокаТЧ.МаксЗначениеПоказателя = Неопределено Тогда
					ОбщегоНазначения.СообщитьОбОшибке("Не указан конец диапазона (строка № " + СтрокаТЧ.НомерСтроки + ")", Отказ, Заголовок);
				КонецЕсли;
				
				Если СтрокаТЧ.ЗначениеПоказателя <> Неопределено
					И СтрокаТЧ.МаксЗначениеПоказателя <> Неопределено
					И СтрокаТЧ.МаксЗначениеПоказателя < СтрокаТЧ.ЗначениеПоказателя Тогда
					ОбщегоНазначения.СообщитьОбОшибке("Конец диапазона должен быть больше начала диапазона (строка № " + СтрокаТЧ.НомерСтроки + ")", Отказ, Заголовок);
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверкаРеквизитов()

// Процедура формирует движения документа по регистрам
//
Процедура ДвиженияПоРегистрам()
	
	// Движение по регистру "СертификацияНоменклатуры"
	НаборЗаписей = Движения.СертификацияНоменклатуры;
	Движение = НаборЗаписей.Добавить();
	Движение.Период = Дата;
	Движение.ВидСертификата = ?( ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.Внешняя,
											Перечисления.ВидыСертификацииНоменклатуры.ВнешняяСертификация,
											Перечисления.ВидыСертификацииНоменклатуры.ВнутренняяСертификация);
	Движение.СерияНоменклатуры     = СерияНоменклатуры;
	Движение.СостояниеСертификации = ?( РезультатСертификации = Перечисления.РезультатыСертификацииНоменклатуры.Сертификат,
		Перечисления.СостоянияСертификацииНоменклатуры.Есть,
		Перечисления.СостоянияСертификацииНоменклатуры.Отказ);
	Если РезультатСертификации = Перечисления.РезультатыСертификацииНоменклатуры.Сертификат Тогда
		Движение.ДатаСертификата  = Дата;
		Движение.НомерСертификата = НомерСертификата;
		Движение.ДатаНачала       = ДатаСертификата;
		Движение.ДатаОкончания    = СрокГодностиСертификата;
	Иначе
		Движение.ДатаСертификата  = '00010101';
		Движение.НомерСертификата = "";
	КонецЕсли;
	
	// Движение по регистру "РезультатыСертификацииНоменклатуры"
	
	ПВХ = ПланыВидовХарактеристик.ВидыРезультатовАнализаНоменклатуры;
	
	НаборЗаписей = Движения.РезультатыСертификацииНоменклатуры;
	Для Каждого СтрокаТЧ Из Анализы Цикл
		
		Движение = НаборЗаписей.Добавить();
		Движение.Период                 = Дата;
		Движение.НомерСтрокиДокумента   = СтрокаТЧ.НомерСтроки;
		Движение.СерияНоменклатуры      = СерияНоменклатуры;
		Движение.ПоказательАнализа      = СтрокаТЧ.ПоказательАнализа;
		Движение.СоответствуетНормативу = СтрокаТЧ.СоответствуетНормативу;
		
		Если СтрокаТЧ.ПоказательАнализа.ВидРезультатаАнализа = ПВХ.ЧислоВИнтервале
		 ИЛИ СтрокаТЧ.ПоказательАнализа.ВидРезультатаАнализа = ПВХ.Погрешность Тогда
			
			Движение.ЕдиницаИзмерения   = СтрокаТЧ.ЕдиницаИзмерения;
			Движение.ЗначениеПоказателя = СтрокаТЧ.ЗначениеПоказателя;
			
		ИначеЕсли СтрокаТЧ.ПоказательАнализа.ВидРезультатаАнализа = ПВХ.Поддиапазон Тогда
			  
			Движение.ЕдиницаИзмерения   = СтрокаТЧ.ЕдиницаИзмерения;
			Движение.ЗначениеПоказателя = СтрокаТЧ.ЗначениеПоказателя;
			Движение.МаксЗначений       = СтрокаТЧ.МаксЗначениеПоказателя;
			  
		ИначеЕсли СтрокаТЧ.ПоказательАнализа.ВидРезультатаАнализа = ПВХ.ЗначениеИзСписка Тогда
			
			Движение.ЗначениеПоказателя = СтрокаТЧ.ЗначениеПоказателя;
			
		Иначе
			
			Движение.ЗначениеПоказателя = СтрокаТЧ.ЗначениеПоказателя;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ДвиженияПоРегистрам()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура обработки проведения проверяет корректность заполнения реквизитов документа
// Документ проводится по одному из двух регистров сведений ВнешняяСертификацияНоменклатуры или ВнутренняяСертификацияНоменклатуры
// в зависимости от вида операции
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	ПроверкаРеквизитов(Отказ, Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПоРегистрам();
	
КонецПроцедуры // ОбработкаПроведения()

// Документ может вводится на основании Поступления товаров услуг, Акта отбора проб, заявки на сертификацию
// 
Процедура ОбработкаЗаполнения(Основание) Экспорт

	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗаявкаНаСертификациюНоменклатуры") Тогда
		
		Номенклатура = Основание.Номенклатура;
		Организация = Основание.Организация;
		Подразделение = Основание.Подразделение;
		СерияНоменклатуры = Основание.СерияНоменклатуры;
		НормативныйДокумент = Основание.НормативныйДокумент;
		
		Если Основание.ВидОперации = Перечисления.ВидыОперацийЗаявкаНаСертификациюНоменклатуры.внешняя Тогда
			ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.внешняя;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.внутренняя;
		КонецЕсли;
		
		ДокументОснование = Основание.Ссылка;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.АктОтбораПробНоменклатуры") Тогда
	
		Номенклатура        = Основание.Номенклатура;
		Организация         = Основание.Организация;
		Подразделение       = Основание.Подразделение;
		СерияНоменклатуры   = Основание.СерияНоменклатуры;
		НормативныйДокумент = Основание.НормативныйДокумент;
		
		Если Основание.ВидОперации = Перечисления.ВидыОперацийАктОтбораПробНоменклатуры.ДляВнешнейСертификации Тогда
			ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.Внешняя;
		Иначе
			ВидОперации = Перечисления.ВидыОперацийСертификацияНоменклатуры.Внутренняя;
			// Берем первое подразделение из табличной части
			Если Основание.РаспределениеПоЛабораториям.Количество() > 0 Тогда
				Подразделение = Основание.РаспределениеПоЛабораториям[0].Подразделение;
			КонецЕсли;
		КонецЕсли;
		
		ДокументОснование = Основание.Ссылка;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
	
		Организация       = Основание.Организация;
		Подразделение     = Основание.Подразделение;
		ДокументОснование = Основание.Ссылка;
		ВидОперации       = Перечисления.ВидыОперацийСертификацияНоменклатуры.внешняя;
		
	ИначеЕсли ТипЗнч(Основание) = Тип("СправочникСсылка.СерииНоменклатуры") Тогда
	
		Номенклатура          = Основание.Владелец;
		СерияНоменклатуры     = Основание;
		Организация           = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
		Подразделение         = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновноеПодразделение");
		ВидОперации           = Перечисления.ВидыОперацийСертификацияНоменклатуры.Внутренняя;
		РезультатСертификации = Перечисления.РезультатыСертификацииНоменклатуры.Сертификат;
		
	КонецЕсли;	
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ПриКопировании
// 
Процедура ПриКопировании(ОбъектКопирования)

	ДокументОснование = Неопределено;
	
КонецПроцедуры // ПриКопировании()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью


Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры


