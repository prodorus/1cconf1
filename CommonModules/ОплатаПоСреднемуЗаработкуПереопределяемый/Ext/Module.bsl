﻿
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции объекта

Процедура ВыполнитьПрочиеДвиженияДокумента(ДокументОбъект, ВыборкаПоШапкеДокумента, Отказ, Заголовок, ВыборкаПоНачислениям = Неопределено) Экспорт 
	
	Если НЕ Отказ Тогда
		
		Движения = ДокументОбъект.Движения;
		
		Начисления = ДокументОбъект.Начисления.Выгрузить();
		Начисления.Колонки.Добавить("Сотрудник",Новый ОписаниеТипов("СправочникСсылка.СотрудникиОрганизаций"));
		Начисления.ЗаполнитьЗначения(ВыборкаПоШапкеДокумента.Сотрудник,"Сотрудник");
		НачислениеОтпускаРаботникамОрганизацийПереопределяемый.СформироватьДоходыПоКодамНДФЛ(Начисления, ВыборкаПоШапкеДокумента, Движения.НДФЛСведенияОДоходах, КонецМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации), Ложь);
		
		ВыборкаПоНачислениям.Сбросить();
		Пока ВыборкаПоНачислениям.Следующий() Цикл 
			
			Если Не ВыборкаПоНачислениям.ЯвляетсяДоходомВНатуральнойФорме Тогда
				
				Движение = Движения.ВзаиморасчетыСРаботникамиОрганизаций.Добавить();
				
				// Свойства
				Движение.Период					= КонецМесяца(ВыборкаПоШапкеДокумента.ПериодРегистрации);
				Движение.ВидДвижения			= ВидДвиженияНакопления.Приход;
				
				// Измерения
				Движение.Организация			= ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;
				Движение.ФизЛицо				= ВыборкаПоШапкеДокумента.ФизЛицо;
				Движение.ПериодВзаиморасчетов	= ВыборкаПоШапкеДокумента.ПериодРегистрации;
				
				// Ресурсы
				Движение.СуммаВзаиморасчетов	= ВыборкаПоНачислениям.Результат;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьДополнительныеПроверкиСтрокиНачислений(ДокументОбъект,ВыборкаПоСтрокамДокумента,Отказ, Заголовок, СтрокаНачалаСообщенияОбОшибке) Экспорт 

	// В этой конфигурации дополнительные действия не выполняются

КонецПроцедуры

Процедура ПереписатьПрочиеДвиженияПриПерерасчете(ДокументОбъект, ВыборкаПоШапкеДокумента) Экспорт 
	
	ДокументОбъект.Движения.НДФЛСведенияОДоходах.Очистить();
	ДокументОбъект.Движения.ВзаиморасчетыСРаботникамиОрганизаций.Очистить();
	ДокументОбъект.Движения.ФактическиеОтпускаОрганизаций.Очистить();
	ДокументОбъект.Движения.ВнутрисменноеВремяРаботниковОрганизаций.Очистить();
	
	ВыборкаПоНачислениям = ДокументОбъект.СформироватьЗапросПоНачислениям(ВыборкаПоШапкеДокумента).Выбрать();
	Пока ВыборкаПоНачислениям.Следующий() Цикл
		Если ВыборкаПоНачислениям.ЯвляетсяПочасовымОтклонением Тогда
			ДокументОбъект.ДобавитьСтрокуРабочегоВремени(ВыборкаПоШапкеДокумента, ВыборкаПоНачислениям, ДокументОбъект.Движения.ВнутрисменноеВремяРаботниковОрганизаций);
		КонецЕсли;
	КонецЦикла;
	
	ВыполнитьПрочиеДвиженияДокумента(ДокументОбъект, ВыборкаПоШапкеДокумента, Ложь, "", ВыборкаПоНачислениям);
	
	// записываем обновленные движения
	Для Каждого Набор Из ДокументОбъект.Движения Цикл
		ТипНабораЗаписей = ТипЗнч(Набор);
		Если ТипНабораЗаписей = Тип("РегистрНакопленияНаборЗаписей.НДФЛСведенияОДоходах") 
			Или ТипНабораЗаписей = Тип("РегистрНакопленияНаборЗаписей.ВзаиморасчетыСРаботникамиОрганизаций") 
			Или ТипНабораЗаписей = Тип("РегистрНакопленияНаборЗаписей.ВнутрисменноеВремяРаботниковОрганизаций") 
			Или ТипНабораЗаписей = Тип("РегистрНакопленияНаборЗаписей.ФактическиеОтпускаОрганизаций") Тогда
			Набор.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьДополнительноеПолеЗапросаПоНачислениям() Экспорт
	Возврат 
	"СтрокиНачисления.ВидРасчета.ЯвляетсяДоходомВНатуральнойФорме КАК ЯвляетсяДоходомВНатуральнойФорме,
	|	ВЫБОР
	|		КОГДА СтрокиНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыОбработкиЗаписиПриОтраженииВРеглУчете.ПустаяСсылка)
	|		КОГДА СтрокиНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныеВыходныеДниПоУходуЗаДетьмиИнвалидами)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыОбработкиЗаписиПриОтраженииВРеглУчете.ОтпускПоБеременностиИРодамПоУходуЗаРебенком)
	|		КОГДА СтрокиНачисления.ВидРасчета.ВидПособияСоциальногоСтрахования = ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев)
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВариантыОбработкиЗаписиПриОтраженииВРеглУчете.БольничныйТравмаНаПроизводстве)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВариантыОбработкиЗаписиПриОтраженииВРеглУчете.БольничныйПрочий)
	|	КОНЕЦ КАК ВариантОбработкиЗаписиПриОтраженииВРеглУчете,"
КонецФункции

Функция ПолучитьСтруктуруРегламентированныхФорм(ДокументОбъект) Экспорт
	
	СтруктураПечатныхФорм = Новый Структура;
	
	Возврат СтруктураПечатныхФорм
	
КонецФункции // ПолучитьСтруктуруПечатныхФорм()

Функция РасчетСреднегоЗаработка(ДокументОбъект, ИспользоватьСреднеЧасовойЗаработок, ПериодРасчетаСреднегоЗаработка, Начало, Окончание) Экспорт 
	
	ТаблицаСреднего = ДокументОбъект.РасчетСреднего;
	Если ТаблицаСреднего.Количество() = 0 Тогда
		Возврат 0;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ОсновнойЗаработок = Новый Массив(2);
	ОсновнойЗаработок[0] = ПланыВидовРасчета.СреднийЗаработок.ПоЗаработку;
	ОсновнойЗаработок[1] = ПланыВидовРасчета.СреднийЗаработок.ПоЗаработкуИндексируемые;
	ПоФиксПремиям = Новый Массив(1);
	ПоФиксПремиям[0] = ПланыВидовРасчета.СреднийЗаработок.ПоФиксПремиям;
	ПоПремиям = Новый Массив(3);
	ПоПремиям[0] = ПланыВидовРасчета.СреднийЗаработок.ПоПремиям;
	ПоПремиям[1] = ПланыВидовРасчета.СреднийЗаработок.ПоПремиямИндексируемые;
	ПоПремиям[2] = ПланыВидовРасчета.СреднийЗаработок.ПоГодовойПремииИндексируемые;
	ПоФиксПремиямНеИндексируемые = Новый Массив(3);
	ПоФиксПремиямНеИндексируемые[0] = ПланыВидовРасчета.СреднийЗаработок.ПоФиксГодовойПремии;
	ПоФиксПремиямНеИндексируемые[1] = ПланыВидовРасчета.СреднийЗаработок.ПоФиксГодовойПремииНеИндексируемые;
	ПоФиксПремиямНеИндексируемые[2] = ПланыВидовРасчета.СреднийЗаработок.ПоФиксПремиямНеИндексируемые;
	
	Запрос.УстановитьПараметр("ОсновнойЗаработок",				ОсновнойЗаработок); // Основной заработок индексируемый
	Запрос.УстановитьПараметр("ОсновнойЗаработокНеиндексируемый", ПланыВидовРасчета.СреднийЗаработок.ПоЗаработкуНеИндексируемые);
	Запрос.УстановитьПараметр("ПоПремиям",						ПоПремиям);  // Премии полностью учитываемые, индексируемые
	Запрос.УстановитьПараметр("ПоФиксПремиям",					ПоФиксПремиям); // Премии учитываемые частично, индексируемые
	Запрос.УстановитьПараметр("ПоФиксПремиямНеИндексируемые",	ПоФиксПремиямНеИндексируемые); // Премии учитываемые частично, не индексируемые
	Запрос.УстановитьПараметр("ТаблицаСреднего",				ТаблицаСреднего);
	Запрос.УстановитьПараметр("ПериодРасчетаСреднегоЗаработка",	ПериодРасчетаСреднегоЗаработка);
	Запрос.УстановитьПараметр("Начало",							Начало);  
	Запрос.УстановитьПараметр("Окончание",						КонецДня(Окончание));  
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетСреднегоЗаработка.ВидРасчета,
	|	РасчетСреднегоЗаработка.Результат,
	|	РасчетСреднегоЗаработка.ОтработаноДней,
	|	РасчетСреднегоЗаработка.ОтработаноЧасов,
	|	РасчетСреднегоЗаработка.НормаПоПятидневке,
	|	РасчетСреднегоЗаработка.ОтработаноПоПятидневке,
	|	РасчетСреднегоЗаработка.ЧислоМесяцев,
	|	РасчетСреднегоЗаработка.КоэффициентИндексации,
	|	РасчетСреднегоЗаработка.БазовыйПериодНачало,
	|	РасчетСреднегоЗаработка.БазовыйПериодКонец
	|ПОМЕСТИТЬ ВТРасчетСреднегоЗаработка
	|ИЗ
	|	&ТаблицаСреднего КАК РасчетСреднегоЗаработка";
	Запрос.Выполнить(); 
			
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(ВЫБОР
	|				КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ОсновнойЗаработок)
	|					ТОГДА РасчетСреднегоЗаработка.Результат * ВЫБОР
	|							КОГДА РасчетСреднегоЗаработка.КоэффициентИндексации < 1
	|								ТОГДА 1
	|							ИНАЧЕ РасчетСреднегоЗаработка.КоэффициентИндексации
	|						КОНЕЦ
	|				КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ОсновнойЗаработокНеиндексируемый)
	|					ТОГДА РасчетСреднегоЗаработка.Результат
	|				КОГДА РасчетСреднегоЗаработка.ЧислоМесяцев = 0
	|					ТОГДА 0
	|				ИНАЧЕ ВЫБОР
	|						КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ПоПремиям)
	|							ТОГДА РасчетСреднегоЗаработка.Результат * ВЫБОР
	|									КОГДА РасчетСреднегоЗаработка.КоэффициентИндексации < 1
	|										ТОГДА 1
	|									ИНАЧЕ РасчетСреднегоЗаработка.КоэффициентИндексации
	|								КОНЕЦ
	|						КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ПоФиксПремиям)
	|							ТОГДА РасчетСреднегоЗаработка.Результат * ВЫБОР
	|									КОГДА РасчетСреднегоЗаработка.КоэффициентИндексации < 1
	|										ТОГДА 1
	|									ИНАЧЕ РасчетСреднегоЗаработка.КоэффициентИндексации
	|								КОНЕЦ * ВЫБОР
	|									КОГДА РасчетСреднегоЗаработка.НормаПоПятидневке = 0
	|										ТОГДА 0
	|									ИНАЧЕ РасчетСреднегоЗаработка.ОтработаноПоПятидневке / РасчетСреднегоЗаработка.НормаПоПятидневке
	|								КОНЕЦ
	|						КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ПоФиксПремиямНеИндексируемые)
	|							ТОГДА РасчетСреднегоЗаработка.Результат * ВЫБОР
	|									КОГДА РасчетСреднегоЗаработка.НормаПоПятидневке = 0
	|										ТОГДА 0
	|									ИНАЧЕ РасчетСреднегоЗаработка.ОтработаноПоПятидневке / РасчетСреднегоЗаработка.НормаПоПятидневке
	|								КОНЕЦ
	|						ИНАЧЕ РасчетСреднегоЗаработка.Результат
	|					КОНЕЦ * ВЫБОР
	|						КОГДА РасчетСреднегоЗаработка.ЧислоМесяцев > &ПериодРасчетаСреднегоЗаработка
	|							ТОГДА &ПериодРасчетаСреднегоЗаработка / РасчетСреднегоЗаработка.ЧислоМесяцев
	|						ИНАЧЕ 1
	|					КОНЕЦ
	|			КОНЕЦ КАК ЧИСЛО(15, 2))) КАК СреднийЗаработок,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ОсновнойЗаработок)
	|					ИЛИ РасчетСреднегоЗаработка.ВидРасчета В (&ОсновнойЗаработокНеиндексируемый)
	|				ТОГДА РасчетСреднегоЗаработка.ОтработаноДней
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ОтработаноДней,
	|	СУММА(ВЫБОР
	|			КОГДА РасчетСреднегоЗаработка.ВидРасчета В (&ОсновнойЗаработок)
	|					ИЛИ РасчетСреднегоЗаработка.ВидРасчета В (&ОсновнойЗаработокНеиндексируемый)
	|				ТОГДА РасчетСреднегоЗаработка.ОтработаноЧасов
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ОтработаноЧасов
	|ИЗ
	|	ВТРасчетСреднегоЗаработка КАК РасчетСреднегоЗаработка
	|ГДЕ
	|	РасчетСреднегоЗаработка.БазовыйПериодНачало МЕЖДУ &Начало И &Окончание";	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Если ИспользоватьСреднеЧасовойЗаработок Тогда
			Возврат ?(Не ЗначениеЗаполнено(Выборка.ОтработаноЧасов), 0, Окр(Выборка.СреднийЗаработок / Выборка.ОтработаноЧасов,2));
		Иначе
			Возврат ?(Не ЗначениеЗаполнено(Выборка.ОтработаноДней), 0, Окр(Выборка.СреднийЗаработок / Выборка.ОтработаноДней,2));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат 0;

КонецФункции // РасчетСреднедневногоЗаработка()

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
Функция РегламентированнаяПечатнаяФорма(ДокументОбъект, ИмяМакета) Экспорт
	
	Возврат Неопределено
	
КонецФункции // РегламентированнаяПечатнаяФорма

Функция ОписаниеРегламентированнойПечатнойФормы(ДокументОбъект, ИмяМакета) Экспорт
	
	Возврат ""
		
КонецФункции // ОписаниеРегламентированнойПечатнойФормы

// Функция возвращает массив табличных частей документа, которые необходимо очистить
// перед расчетом
//
Функция ПолучитьМассивТабличныхЧастей(ДокументОбъект, ЧтоРассчитываем) Экспорт

	МассивТаблиц = Новый Массив;
	Если ЧтоРассчитываем = "ПолныйРасчет" или ЧтоРассчитываем = "РасчетСреднего" Тогда
		МассивТаблиц.Добавить(ДокументОбъект.Начисления);
		МассивТаблиц.Добавить(ДокументОбъект.РасчетСреднего);
	ИначеЕсли ЧтоРассчитываем = "РасчетНачислений" Тогда	
		МассивТаблиц.Добавить(ДокументОбъект.Начисления);
	КонецЕсли;	
	
	Возврат МассивТаблиц;

КонецФункции // ПолучитьМассивТабличныхЧастей()

////////////////////////////////////////////////////////////////////////////////
// Процедуры, функции для работы формы документа

Процедура ВыполнитьДействияПередОткрытиемФормы(ФормаДокумента) Экспорт
	
	// В этой конфигурации дополнительные действия не выполняются
	
КонецПроцедуры	

Процедура ВыполнитьДополнительныеДействияПриОткрытииФормы(ДокументОбъект, ФормаДокумента) Экспорт

	ЭлементыФормы = ФормаДокумента.ЭлементыФормы;
	ЭлементыФормы.ЗаголовокДополнительнойИнформационнойНадписи.Видимость = Ложь;
	ЭлементыФормы.ДополнительнаяИнформационнаяНадпись.Видимость = Ложь;
	
КонецПроцедуры

Процедура ВыполнитьДополнительныеДействияПриИзмененииПериодаРегистрации(ДокументОбъект, ФормаДокумента) Экспорт

	// В этой конфигурации дополнительные действия не выполняются
	
КонецПроцедуры

Процедура ВыполнитьДействияПриНачалеРедактированияНачисления(ФормаДокумента, Элемент, НоваяСтрока) Экспорт
	
	// В этой конфигурации дополнительные действия не выполняются

КонецПроцедуры

Процедура ВыполнитьДействияПослеРедактированияНачисления(ФормаДокумента, ТекущаяСтрока) Экспорт
	
	// В этой конфигурации дополнительные действия не выполняются
	
КонецПроцедуры

Процедура ВыполнитьДействияПередУдалениемНачисления(Элемент, ДокументОбъект, Отказ) Экспорт
	
	// В этой конфигурации дополнительные действия не выполняются
			
КонецПроцедуры

Процедура ВыполнитьДополнительныеДействияПриУдаленииНачислений(ДокументОбъект, ФормаДокумента) Экспорт
	
	// В этой конфигурации дополнительные действия не выполняются
	
КонецПроцедуры

Процедура НастроитьСпискиВыбораЭлементовУправления(ДокументОбъект, ФормаДокумента) Экспорт

	ЭлементыФормы = ФормаДокумента.ЭлементыФормы;
	 
	ЭтоПорядок2007года = ?(ЗначениеЗаполнено(ДокументОбъект.ДатаНачалаСобытия),ДокументОбъект.ДатаНачалаСобытия,ОбщегоНазначенияЗК.ПолучитьРабочуюДату()) < ПроведениеРасчетовДополнительный.ПолучитьДатуВступленияВСилуИзмененийПоОтпускам2008();
	
	// Список видов записей расчета среднего
	СписокВыбора = ПроведениеРасчетовПереопределяемый.ПолучитьПереченьСоставляющихСреднегоЗаработка(ЭтоПорядок2007года);
	ЭлементыФормы.РасчетСреднего.Колонки.ВидРасчета.ЭлементУправления.СписокВыбора = СписокВыбора;
	ЭлементыФормы.РасчетСреднего.Колонки.ВидРасчета.ЭлементУправления.ВысотаСпискаВыбора = СписокВыбора.Количество();
	
	ЭлементыФормы.РасчетСреднего.Колонки.ОтработаноПоПятидневке.ТекстШапки = ?(ЭтоПорядок2007года,"Отработано по пятидневке","Отработано за расчетный период");
	ЭлементыФормы.РасчетСреднего.Колонки.НормаПоПятидневке.ТекстШапки = ?(ЭтоПорядок2007года,"Норма по пятидневке","Норма за расчетный период");

КонецПроцедуры

Процедура ОбновитьДополнительнуюИнформационнуюНадпись(ДокументОбъект, ФормаДокумента) Экспорт

	// В этой конфигурации дополнительные действия не выполняются
	
КонецПроцедуры

Процедура ПоказатьДополнительнуюФорму(ДокументОбъект, ФормаДокумента) Экспорт
	
	// В этой конфигурации дополнительные действия не выполняются
	
КонецПроцедуры

#КонецЕсли

