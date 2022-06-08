﻿Перем мУдалятьДвижения;

// Текущие курс и кратность валюты документа для расчетов
Перем КурсДокумента Экспорт;
Перем КратностьДокумента Экспорт;

Перем мВалютаРегламентированногоУчета Экспорт;
Перем АвтоЗначенияРеквизитов Экспорт;

// Хранят группировочные признаки вида операции
Перем ЕстьРасчетыСКонтрагентами Экспорт;
Перем ЕстьРасчетыПоКредитам Экспорт;

// Хранит таблицу, использующуюся при проведении документа
Перем ТаблицаПлатежейУпр;

//Определение периода движений документа
Перем ДатаДвижений;

Перем мСтруктураПараметровДенежныхСредств;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда

// Формирует печатную форму 
// платежного поручения
//
// Параметры:
//  ТабДок - табличный документ
//
Функция ПечатьПлатежногоТребования() Экспорт

	Если Организация.Пустая() Тогда
		Сообщить("Не указана организация.", СтатусСообщения.Важное);
		Возврат Неопределено;
	КонецЕсли;

	Если Контрагент.Пустая() Тогда
		Сообщить("Не указан контрагент.", СтатусСообщения.Важное);
		Возврат Неопределено;
	КонецЕсли;
	
	НомерПечать=ОбщегоНазначения.ПолучитьНомерНаПечать(ЭтотОбъект);
	
	Если Прав(НомерПечать,3)="000" И Дата < '20120709' Тогда
		Сообщить("Номер платежного требования не может оканчиваться на ""000""!", СтатусСообщения.Важное);
		Возврат Неопределено;
	КонецЕсли;

	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПлатежноеТребование_ПлатежноеТребование";
	
	Макет = ПолучитьОбщийМакет("ПлатежноеТребование");
	Обл   = Макет.ПолучитьОбласть("ЗаголовокТаблицы");

	МесяцПрописью   = СчетОрганизации.МесяцПрописью;
	СуммаБезКопеек  = СчетОрганизации.СуммаБезКопеек;
	ФорматДаты      = "ДФ=" + ?(МесяцПрописью = 1,"'дд ММММ гггг'","'дд.ММ.гггг'");
	БанкОрганизации = ?(НЕ ЗначениеЗаполнено(СчетОрганизации.БанкДляРасчетов), СчетОрганизации.Банк, СчетОрганизации.БанкДляРасчетов);
	БанкКонтрагента = ?(НЕ ЗначениеЗаполнено(СчетКонтрагента.БанкДляРасчетов), СчетКонтрагента.Банк, СчетКонтрагента.БанкДляРасчетов);

	Обл.Параметры.НаименованиеНомер       = "ПЛАТЕЖНОЕ ТРЕБОВАНИЕ № " + НомерПечать;
	Обл.Параметры.ДатаДокумента           = Формат(Дата,ФорматДаты);
	Обл.Параметры.ВидПлатежа              = ВидПлатежа;
	Обл.Параметры.СуммаЧислом             = ФорматироватьСумму(СуммаДокумента,СуммаБезКопеек);
	Обл.Параметры.СуммаПрописью           = ФорматироватьСуммуПрописи(СуммаДокумента,СуммаБезКопеек);

	Обл.Параметры.ПлательщикИНН           = "ИНН " + ?(ПустаяСтрока(ИННПлательщика), Контрагент.ИНН, СокрЛП(ИННПлательщика));
	Обл.Параметры.Плательщик              = ?(ПустаяСтрока(ТекстПлательщика),Контрагент.НаименованиеПолное,СокрЛП(ТекстПлательщика));
	Обл.Параметры.БанкПлательщика         = "" + БанкКонтрагента + " " + БанкКонтрагента.Город;

	Обл.Параметры.НомерСчетаПлательщика   = ВернутьРасчетныйСчет(СчетКонтрагента);

	Обл.Параметры.БикБанкаПлательщика     = БанкКонтрагента.Код;
	Обл.Параметры.СчетБанкаПлательщика    = БанкКонтрагента.КоррСчет;

	Обл.Параметры.ПолучательИНН           = "ИНН " + ?(ПустаяСтрока(ИННПолучателя), Организация.ИНН, СокрЛП(ИННПолучателя));
	Обл.Параметры.Получатель              = ?(ПустаяСтрока(ТекстПолучателя),Организация.НаименованиеПолное,СокрЛП(ТекстПолучателя));

	Обл.Параметры.БанкПолучателя          = "" + БанкОрганизации + " " + БанкОрганизации.Город;
	Обл.Параметры.БикБанкаПолучателя      = БанкОрганизации.Код;
	Обл.Параметры.СчетБанкаПолучателя     = БанкОрганизации.КоррСчет;

    Обл.Параметры.НомерСчетаПолучателя    = ВернутьРасчетныйСчет(СчетОрганизации);

	Обл.Параметры.НазначениеПлатежа       = СокрЛП(НазначениеПлатежа);
	Обл.Параметры.Очередность             = ОчередностьПлатежа;

	Обл.Параметры.УсловиеОплаты = ?(УсловиеОплаты=Перечисления.УсловияОплатыРасчетныхДокументов.САкцептом, Формат(ВидАкцепта,"ЧН='с акцептом'"), "" + УсловиеОплаты+Символы.ПС+ОснованиеДляБезакцептногоСписания);
	Обл.Параметры.СрокДляАкцепта=?(СрокДляАкцепта>0,СрокДляАкцепта,"");
	Обл.Параметры.ДатаОтсылкиДокументов= Формат(ДатаОтсылкиДокументов,ФорматДаты);

	ТабДокумент.Вывести(Обл);

	Возврат ТабДокумент;

КонецФункции // ПечатьПлатежногоПоручения()

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
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

		// Получить экземпляр документа на печать
	Если ИмяМакета = "Платежное требование" ИЛИ ИмяМакета = "ПлатежноеТребование" Тогда

		// Управленческая печатная форма документа
		ТабДокумент = ПечатьПлатежногоТребования();
		
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат;
		КонецЕсли;
	
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Ссылка);

КонецПроцедуры // Печать

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура("ПлатежноеТребование","Платежное требование");

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

// Процедура заполняет данные по УСН
//
Процедура ЗаполнитьНастройкуКнигиУСН() Экспорт

	Если РучнаяНастройка_УСН Тогда
		ТекстВороса = 
		"Отражение платежа в Книге учета доходов и расходов настроено вручную.
		|Перезаполнить показатели Книги учета доходов и расходов?";
		Если Вопрос(ТекстВороса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да) = КодВозвратаДиалога.Да Тогда
			РучнаяНастройка_УСН = Ложь;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	СуммаДляКУДиР = СуммаДокумента;

	Если НЕ ВалютаДокумента = глЗначениеПеременной("ВалютаРегламентированногоУчета") Тогда
		КурсВалюты    = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
		СуммаДляКУДиР = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СуммаДляКУДиР, ВалютаДокумента, глЗначениеПеременной("ВалютаРегламентированногоУчета"), КурсВалюты.Курс, 1, КурсВалюты.Кратность, 1);
	КонецЕсли;

	Если НалоговыйУчетУСН.ПрименениеУСНДоходы(Организация, Дата) Тогда

		Графа4_УСН      = СуммаДляКУДиР;
		Графа5_УСН      = СуммаДляКУДиР;
		Графа6_УСН      = 0;
		Графа7_УСН      = 0;
		НДС_УСН         = 0;
		ДоходыЕНВД_УСН  = Ложь;
		РасходыЕНВД_УСН = Ложь;
		Содержание_УСН  = "" + ВидОперации + ".";

		Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком Тогда
			Содержание_УСН = "Возврат денежных средств поставщиком.";
			Графа4_УСН      = 0;
			Графа5_УСН      = 0;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры // ЗаполнитьНастройкуКнигиУСН()

#КонецЕсли

// Форматирует сумму прописью документа
//
// Параметры:
//  СуммаДок - число - реквизит, который надо представить прописью 
//  СуммаБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированную строку
//
Функция ФорматироватьСуммуПрописи(СуммаДок,СуммаБезКопеек)
	
	Результат     = СуммаДок;
	ЦелаяЧасть    = Цел(СуммаДок);
	ФорматСтрока  = "Л=ru_RU; ДП=Ложь";
	ПарамПредмета = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж";
	
	Если (Результат - ЦелаяЧасть) = 0 Тогда
		Если СуммаБезКопеек Тогда
			Результат = ЧислоПрописью(Результат,ФорматСтрока,ПарамПредмета);
			Результат = Лев(Результат,Найти(Результат,"0")-1);
		Иначе
			Результат = ЧислоПрописью(Результат,ФорматСтрока,ПарамПредмета);
		КонецЕсли;
	Иначе
		Результат = ЧислоПрописью(Результат,ФорматСтрока,ПарамПредмета);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ФорматироватьСуммуПрописи()

// Форматирует сумму  документа
//
// Параметры:
//  СуммаДок - число - реквизит, который надо отформатировать
//  СуммаБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированную строку
//
Функция ФорматироватьСумму(СуммаДок,СуммаБезКопеек)
	
	Результат  = СуммаДок;
	ЦелаяЧасть = Цел(СуммаДок);
	
	Если (Результат - ЦелаяЧасть) = 0 Тогда
		Если СуммаБезКопеек Тогда
			Результат = Формат(Результат,"ЧДЦ=2; ЧРД='='; ЧГ=0");
			Результат = Лев(Результат,Найти(Результат,"="));
		Иначе
			Результат = Формат(Результат,"ЧДЦ=2; ЧРД='-'; ЧГ=0");
		КонецЕсли;
	Иначе
		Результат = Формат(Результат,"ЧДЦ=2; ЧРД='-'; ЧГ=0");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ФорматироватьСумму()

// Определяет номер расчетного счета по
// переданному банковскому счету
//
// Параметры:
//  СчетКонтра - справочник.БанковскиеСчета
//
// Возвращаемое значение
//  Номер расчетного счета
//
Функция ВернутьРасчетныйСчет(СчетКонтрагента)
	
	БанкДляРасчетов = СчетКонтрагента.БанкДляРасчетов;
	Результат       = ?(БанкДляРасчетов.Пустая(), СчетКонтрагента.НомерСчета, СчетКонтрагента.Банк.КоррСчет);

	Возврат Результат;
	
КонецФункции // ВернутьРасчетныйСчет()

// Формирует структуру полей, обязательных для заполнения при отражении фактического
// движения средств по банку.
//
// Возвращаемое значение:
//   СтруктураОбязательныхПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейОплатаУпр()

	СтруктураПолей=Новый Структура;
	СтруктураПолей.Вставить("СчетОрганизации");
	СтруктураПолей.Вставить("СуммаДокумента");
	СтруктураПолей.Вставить("ДатаОплаты","Не указана дата оплаты документа банком!");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейОплатаУпр()

// Формирует структуру полей, обязательных для заполнения при отражении операции во 
// взаиморасчетах
// Возвращаемое значение:
//   СтруктурахПолей   – структура для проверки
//
Функция СтруктураОбязательныхПолейРасчетыУпр()

	СтруктураПолей = Новый Структура("Организация, Контрагент, СуммаДокумента, Ответственный");
	СтруктураПолей.Вставить("СчетОрганизации","Не указан банковский счет организации!");

	Возврат СтруктураПолей;

КонецФункции // СтруктураОбязательныхПолейРасчетыУпр()

// Проверяет значение, необходимое при проведении
Процедура ПроверитьЗначение(Значение, Отказ, Заголовок, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(Значение) Тогда 
		
		ОбщегоНазначения.СообщитьОбОшибке("Не заполнено значение реквизита """+ИмяРеквизита+"""",Отказ, Заголовок);
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗначение()

// Проверяет заполнение табличной части документа
//
Процедура ПроверитьЗаполнениеТЧ(Отказ, Заголовок)

	Для Каждого Платеж Из РасшифровкаПлатежа Цикл

		ПроверитьЗначение(Платеж.ДоговорКонтрагента,Отказ, Заголовок,"Договор");
		ПроверитьЗначение(Платеж.СуммаВзаиморасчетов,Отказ, Заголовок,"Сумма взаиморасчетов");
		
		Если Не Отказ Тогда
			
			// Сделка должна быть заполнена, если учет взаиморасчетов ведется по заказам.
			Если Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Заказ покупателя","Заказ поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);
				
				Если Отказ Тогда
				
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по заказам""! 
					|Заполните поле """+ТекстСделка+"""!");
					
				КонецЕсли;
				
			ИначеЕсли Платеж.ДоговорКонтрагента.ВедениеВзаиморасчетов = Перечисления.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам Тогда
				
				ТекстСделка=?(УправлениеДенежнымиСредствами.ОпределитьПараметрыВыбораСделки(ВидОперации).ТипЗаказа="ЗаказПокупателя","Счет покупателя","Счет поставщику");
				ПроверитьЗначение(Платеж.Сделка,Отказ, Заголовок,ТекстСделка);

				Если Отказ Тогда
					Сообщить("По договору "+Строка(Платеж.ДоговорКонтрагента)+" установлен способ ведения взаиморасчетов ""по счетам""! 
					|Заполните поле """+ТекстСделка+"""!");
				КонецЕсли;
						
			КонецЕсли;

			Если ЗначениеЗаполнено(Организация) 
				И Организация <> Платеж.ДоговорКонтрагента.Организация Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Выбран договор контрагента, не соответствующий организации, указанной в документе!", Отказ, Заголовок);
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ПроверитьЗаполнениеТЧ

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//  Режим 					  - режим проведения документа
//
Процедура ДвиженияПоРегистрам(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)

	ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента);
	ДвиженияПоРегистрамРегл(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента);
	
	Если ЕстьРасчетыСКонтрагентами или ЕстьРасчетыПоКредитам Тогда
		ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента);
	КонецЕсли; 

КонецПроцедуры // ДвиженияПоРегистрам()

Процедура ДвиженияПоРегистрамУпр(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)

	мСтруктураПараметровДенежныхСредств.Вставить("ЕстьРасчетыСКонтрагентами", ЕстьРасчетыСКонтрагентами);
	мСтруктураПараметровДенежныхСредств.Вставить("ЕстьРасчетыПоКредитам",     ЕстьРасчетыПоКредитам);
	мСтруктураПараметровДенежныхСредств.Вставить("БанковскийСчетКасса",       СчетОрганизации);
	мСтруктураПараметровДенежныхСредств.Вставить("ДатаДвижений",              ДатаДвижений);
	
	УправлениеДенежнымиСредствами.ПровестиПоступлениеДенежныхСредствУпр(
		СтруктураШапкиДокумента, мСтруктураПараметровДенежныхСредств, ТаблицаПлатежейУпр, Движения, Отказ, Заголовок);
	
КонецПроцедуры

Процедура ДвиженияПоРегистрамОперативныхВзаиморасчетов(РежимПроведения, Отказ, Заголовок, СтруктураШапкиДокумента)
	
	Если НЕ (Оплачено И ОтраженоВОперУчете) Тогда
		Возврат;
	КонецЕсли;
	
	ВидДвижения = ВидДвиженияНакопления.Расход;
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ВозвратДенежныхСредствПоставщиком Тогда
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоПриобретению;
	ИначеЕсли СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ОплатаПокупателя Тогда
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.ПоРеализации;
	Иначе
		ВидРасчетовПоОперации = перечисления.ВидыРасчетовСКонтрагентами.Прочее;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("РежимПроведения", РежимПроведения);
	
	УправлениеВзаиморасчетами.ОтражениеОплатыВРегистреОперативныхРасчетовПоДокументам(СтруктураШапкиДокумента, ДатаДвижений, "РасшифровкаПлатежа", ВидРасчетовПоОперации, ВидДвижения, Движения, Отказ, Заголовок);

КонецПроцедуры

Процедура ДвиженияПоРегистрамРегл(РежимПроведения, Отказ, Заголовок,СтруктураШапкиДокумента)
	
	// Бухгалтерские проводки документа
	Если не (СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете и СтруктураШапкиДокумента.Оплачено) Тогда
		Возврат;
	КонецЕсли; 
	
	ДатаДока = ДатаДвижений;
	
	ПроводкиБУ	= Движения.Хозрасчетный;
	
	РасчетыВВалюте = Ложь;
	СчетДт = УправлениеДенежнымиСредствами.ОпределитьСчетУчетаДенежныхСредств(СтруктураШапкиДокумента.СчетОрганизации, мВалютаРегламентированногоУчета, РасчетыВВалюте);
	
	Если СтруктураШапкиДокумента.ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам Тогда
		
		Проводка = ПроводкиБУ.Добавить();
		
		Проводка.Период      = ДатаДока;
		Проводка.Организация = СтруктураШапкиДокумента.Организация;
		Проводка.Содержание  = "Расчеты по кредитам и займам";
		
		Проводка.СчетКт      = РасшифровкаПлатежа[0].СчетУчетаРасчетовСКонтрагентом;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтруктураШапкиДокумента.Контрагент);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, РасшифровкаПлатежа[0].ДоговорКонтрагента);
		
		Проводка.СчетДт      = СчетДт;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтруктураШапкиДокумента.СчетОрганизации);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, РасшифровкаПлатежа[0].СтатьяДвиженияДенежныхСредств);
		
		Если РасчетыВВалюте Тогда
			
			Если Проводка.СчетДт.Валютный Тогда
				Проводка.ВалютаДт        = СтруктураШапкиДокумента.ВалютаДокумента;
				Проводка.ВалютнаяСуммаДт = СтруктураШапкиДокумента.СуммаДокумента;
			КонецЕсли;
			
			Если Проводка.СчетКт.Валютный Тогда
				Проводка.ВалютаКт        = СтруктураШапкиДокумента.ВалютаДокумента;
				Проводка.ВалютнаяСуммаКт = СтруктураШапкиДокумента.СуммаДокумента;
			КонецЕсли;
			
			ВалютаРег       = мВалютаРегламентированногоУчета;
			ДанныеОВалюте   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРег, ДатаДока);
			
			Проводка.Сумма  = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаДокумента, СтруктураШапкиДокумента.ВалютаДокумента, ВалютаРег,
			СтруктураШапкиДокумента.КурсДокумента,      ДанныеОВалюте.Курс, 
			СтруктураШапкиДокумента.КратностьДокумента, ДанныеОВалюте.Кратность);
		Иначе
			Проводка.Сумма = СтруктураШапкиДокумента.СуммаДокумента;
		КонецЕсли;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств тогда
		
		Проводка = ПроводкиБУ.Добавить();
		
		Проводка.Период      = ДатаДока;
		Проводка.Организация = СтруктураШапкиДокумента.Организация;
		Проводка.Содержание  = "Прочее поступление денежных средств";
		
		Проводка.СчетКт      = СчетУчетаРасчетовСКонтрагентом;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 1, СтруктураШапкиДокумента.СубконтоКт1);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 2, СтруктураШапкиДокумента.СубконтоКт2);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, 3, СтруктураШапкиДокумента.СубконтоКт3);
		
		Проводка.СчетДт      = СчетДт;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 1, СтруктураШапкиДокумента.СчетОрганизации);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт, 2, РасшифровкаПлатежа[0].СтатьяДвиженияДенежныхСредств);
		
		Если РасчетыВВалюте Тогда
			
			Если Проводка.СчетДт.Валютный Тогда
				Проводка.ВалютаДт        = СтруктураШапкиДокумента.ВалютаДокумента;
				Проводка.ВалютнаяСуммаДт = СтруктураШапкиДокумента.СуммаДокумента;
			КонецЕсли;
			
			Если Проводка.СчетКт.Валютный Тогда
				Проводка.ВалютаКт        = СтруктураШапкиДокумента.ВалютаДокумента;
				Проводка.ВалютнаяСуммаКт = СтруктураШапкиДокумента.СуммаДокумента;
			КонецЕсли;
			
			ВалютаРег       = мВалютаРегламентированногоУчета;
			ДанныеОВалюте   = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаРег, ДатаДока);
			
			Проводка.Сумма  = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(СтруктураШапкиДокумента.СуммаДокумента, СтруктураШапкиДокумента.ВалютаДокумента, ВалютаРег,
			СтруктураШапкиДокумента.КурсДокумента,      ДанныеОВалюте.Курс, 
			СтруктураШапкиДокумента.КратностьДокумента, ДанныеОВалюте.Кратность);
		Иначе
			Проводка.Сумма = СтруктураШапкиДокумента.СуммаДокумента;
		КонецЕсли;
		
	Иначе
		
		СтруктураПараметровДДС = БухгалтерскийУчетРасчетовСКонтрагентами.ПодготовкаСтруктурыПараметровДляДвиженияДенег(Ссылка, мВалютаРегламентированногоУчета, Заголовок,СчетДт);
		Если Не (СтруктураПараметровДДС = Ложь) тогда
			БухгалтерскийУчетРасчетовСКонтрагентами.БухгалтерскийУчетРасчетыСКонтрагентами_Оплата(СтруктураПараметровДДС, СтруктураШапкиДокумента, Движения, Отказ, Заголовок, ПринадлежностьПоследовательностям);
		Иначе
			БухгалтерскийУчетРасчетовСКонтрагентами.ДвижениеДенегПрочийПриход(ЭтотОбъект, РасчетыВВалюте, СчетДт, СтруктураШапкиДокумента, Отказ, Заголовок);
		Конецесли;
		
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчетеУСН Тогда
		
		НалоговыйУчетУСН.ДвиженияУСН(Ссылка, РежимПроведения);
	ИначеЕсли СтруктураШапкиДокумента.ОтражатьВНалоговомУчетеУСНДоходы Тогда
		
		НалоговыйУчетУСН.ПрочееДДС(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок)

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа")= СуммаДокумента Тогда
		Сообщить(Заголовок+" 
		|не совпадают сумма документа и ее расшифровка.");

		Отказ = Истина;

	КонецЕсли;

	Если Оплачено Тогда
		ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейОплатаУпр(), Отказ, Заголовок);
	КонецЕсли;

	Если ОтраженоВОперУчете ИЛИ (ОтражатьВБухгалтерскомУчете И Оплачено) Тогда
		
		ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолейРасчетыУпр(), Отказ, Заголовок);
		
		Если ЕстьРасчетыСКонтрагентами ИЛИ ЕстьРасчетыПоКредитам Тогда
			
			ПроверитьЗаполнениеТЧ(Отказ, Заголовок);
			
			Если Не Отказ Тогда
				УправлениеДенежнымиСредствами.КонтрольОстатковПоТЧ(Дата, ТаблицаПлатежейУпр, Отказ, Заголовок,,Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеДокументаРегл(Отказ, Заголовок)

	Если ОтражатьВБухгалтерскомУчете Тогда
		
		СтруктураПолей = Новый Структура("СчетУчетаРасчетовСКонтрагентом");
		
		Если ВидОперации=Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда

			ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект,СтруктураПолей, Отказ, Заголовок);
			
		Иначе

			ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "РасшифровкаПлатежа", СтруктураПолей, Отказ, Заголовок);
			
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	// Заполним по шапке документа дерево параметров, нужных при проведении.
	ДеревоПолейЗапросаПоШапке      = УправлениеЗапасами.СформироватьДеревоПолейЗапросаПоШапке();
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВедениеВзаиморасчетов"                         , "ВедениеВзаиморасчетов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВалютаВзаиморасчетов"                          , "ВалютаВзаиморасчетов");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "Организация"                       			, "ДоговорОрганизация");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "ВидДоговора"                       			, "ВидДоговора");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "ДоговорКонтрагента"  , "КонтролироватьДенежныеСредстваКомитента"       , "КонтролироватьДенежныеСредстваКомитента");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "УчетнаяПолитика"     , "ВедениеУчетаПоПроектам"                     , "ВедениеУчетаПоПроектам");
	УправлениеЗапасами.ДобавитьСтрокуВДеревоПолейЗапросаПоШапке(ДеревоПолейЗапросаПоШапке, "Организация"         , "ОтражатьВРегламентированномУчете"              , "ОтражатьВРегламентированномУчете");

	// Сформируем запрос на дополнительные параметры, нужные при проведении, по данным шапки документа
	СтруктураШапкиДокумента = УправлениеЗапасами.СформироватьЗапросПоДеревуПолей(ЭтотОбъект, ДеревоПолейЗапросаПоШапке, СтруктураШапкиДокумента, мВалютаРегламентированногоУчета);
	СтруктураШапкиДокумента.Вставить("ОтражатьВУправленческомУчете",Истина); // Банковские документы всегда отражаются в упр. учете
	
	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочиеРасчетыСКонтрагентами ИЛИ
		ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам Тогда
		
		КурсДокумента      = РасшифровкаПлатежа[0].КурсВзаиморасчетов;
		КратностьДокумента = РасшифровкаПлатежа[0].КратностьВзаиморасчетов;

	Иначе	
		СтруктураКурсаДокумента = МодульВалютногоУчета.ПолучитьКурсВалюты(ВалютаДокумента,Дата);
		
		КурсДокумента      = СтруктураКурсаДокумента.Курс;
		КратностьДокумента = СтруктураКурсаДокумента.Кратность;
	КонецЕсли;
	СтруктураШапкиДокумента.Вставить("КурсДокумента"		, КурсДокумента);
	СтруктураШапкиДокумента.Вставить("КратностьДокумента"	, КратностьДокумента);
	
	ДатаДвижений=?(Оплачено,УправлениеДенежнымиСредствами.ПолучитьДатуДвижений(Дата,ДатаОплаты),Дата);
	СтруктураШапкиДокумента.Вставить("ДатаОплаты",ДатаДвижений);

КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если (Основание <> Неопределено) И (Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(Основание))) Тогда
		// Заполним реквизиты из стандартного набора по документу основанию.
		ЗаполнениеДокументов.ЗаполнитьШапкуДокументаПоОснованию(ЭтотОбъект, Основание);
		УправлениеДенежнымиСредствами.ЗаполнитьПриходПоОснованию(ЭтотОбъект, Основание, УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнойОтветственный"));
	КонецЕсли;

	Если НалоговыйУчетУСН.ПрименениеУСН(Организация, Дата) Тогда
		НалоговыйУчетУСН.ЗаполнитьНастройкуКУДиР(ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, Режим)

	Перем Заголовок, СтруктураШапкиДокумента;
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ПодготовитьСтруктуруШапкиДокумента(Заголовок, СтруктураШапкиДокумента);
	
	ЕстьРасчетыСКонтрагентами=УправлениеДенежнымиСредствами.ЕстьРасчетыСКонтрагентами(ВидОперации);
	ЕстьРасчетыПоКредитам=УправлениеДенежнымиСредствами.ЕстьРасчетыПоКредитам(ВидОперации);
	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок);

	Если НЕ ОтраженоВОперУчете И НЕ Оплачено Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не выбрано правило проведения (""Отразить в опер. учете"",""Оплачено"")",Отказ, Заголовок);
	КонецЕсли;
	
	ТаблицаПлатежейУпр = УправлениеДенежнымиСредствами.ПолучитьТаблицуПлатежейУпр(ДатаДвижений,ВалютаДокумента,Ссылка, "ПлатежноеТребованиеВыставленное");
	
	ПроверитьЗаполнениеДокументаУпр(Отказ, Заголовок);
	ПроверитьЗаполнениеДокументаРегл(Отказ, Заголовок);

	//Проверим на возможность проведения в БУ и НУ
	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете или СтруктураШапкиДокумента.ОтражатьВНалоговомУчете тогда
		Для каждого СтрокаОплаты из РасшифровкаПлатежа Цикл
			УправлениеВзаиморасчетами.ПроверкаВозможностиПроведенияВ_БУ_НУ(СтрокаОплаты.ДоговорКонтрагента, СтруктураШапкиДокумента.ВалютаДокумента,
			СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете,СтруктураШапкиДокумента.ОтражатьВНалоговомУчете,
			мВалютаРегламентированногоУчета, Истина,Отказ, Заголовок,"Строка "+СтрокаОплаты.НомерСтроки+" - ");
		КонецЦикла;
	КонецЕсли;
	
	// Движения по документу
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Режим, Отказ, Заголовок, СтруктураШапкиДокумента);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	НалоговыйУчетУСН.ЗаполнитьНастройкуКУДиР(ЭтотОбъект);

	НомерПечать=ОбщегоНазначения.ПолучитьНомерНаПечать(ЭтотОбъект);
	
	Если Прав(НомерПечать,3)="000" И Дата < '20120709' Тогда
		Сообщить("Номер платежного требования не может оканчиваться на ""000""!", СтатусСообщения.Важное);
		Отказ=Истина;
	КонецЕсли;
	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры

// Процедура - обработчик события "ПриЗаписи"
//
Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ЧастичнаяОплата Тогда
		Сообщить("По документу "+ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка)+" уже прошла частичная оплата.
		|Перед отменой проведения документа необходимо отменить проведение платежных ордеров.");
		Отказ=Истина;
	КонецЕсли;
	
	
КонецПроцедуры

// Процедура - обработчик события "ПриКопировании" объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	ЧастичнаяОплата   = Ложь;
	Оплачено		  = Ложь;
	ДатаОплаты		  = Дата('00010101000000');

КонецПроцедуры

мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");

мСтруктураПараметровДенежныхСредств = Новый Структура;
мСтруктураПараметровДенежныхСредств.Вставить("ВидДенежныхСредств", Перечисления.ВидыДенежныхСредств.Безналичные);
