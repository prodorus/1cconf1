﻿// Функция формирует табличный документ с печатной формой состава смены
//
// Возвращаемое значение:
//  Табличный документ - сформированная печатная форма
//
Функция ПечатьОтчетаОСоставеСмены(МассивОбъектов, ОбъектыПечати)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОтчетОСоставеСмены_Отчет";
	
	Макет = ПолучитьМакет("ОтчетОСоставеСмены");
	
	ПервыйДокумент = Истина;
	
	Для каждого Ссылка Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// ШАПКА
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОтчетОСоставеСмены.Номер,
		|	ОтчетОСоставеСмены.Дата,
		|	ОтчетОСоставеСмены.Подразделение,
		|	ОтчетОСоставеСмены.Ответственный,
		|	НЕОПРЕДЕЛЕНО КАК Организация,
		|	ОтчетОСоставеСмены.Смена,
		|	ОтчетОСоставеСмены.ГраницаСмены,
		|	ОтчетОСоставеСмены.Подразделение.Представление,
		|	ОтчетОСоставеСмены.Ответственный.Представление
		|ИЗ
		|	Документ.ОтчетОСоставеСмены КАК ОтчетОСоставеСмены
		|ГДЕ
		|	ОтчетОСоставеСмены.Ссылка = &Ссылка";
		

		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		// Выводим шапку
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ТекстЗаголовка 		= ОбщегоНазначения.СформироватьЗаголовокДокумента(Шапка, "Отчет о составе смены");
		ОбластьМакета.Параметры.ПредставлениеСмены 	= ОперативныйУчетПроизводства.ПредставлениеСмены(Шапка.ГраницаСмены, Шапка.Смена);
		
		ТабДокумент.Вывести(ОбластьМакета);

		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ОтчетОСоставеСменыСоставСмены.Явка КАК Явка,
		|	ОтчетОСоставеСменыСоставСмены.Сотрудник,
		|	ОтчетОСоставеСменыСоставСмены.ВремяЯвки,
		|	ОтчетОСоставеСменыСоставСмены.ОтработанноеВремя,
		|	ОтчетОСоставеСменыСоставСмены.НомерСтроки КАК НомерСтроки,
		|	ОтчетОСоставеСменыСоставСмены.Примечание,
		|	ОтчетОСоставеСменыСоставСмены.ЗамещающийСотрудник,
		|	ОтчетОСоставеСменыСоставСмены.Сотрудник.Наименование,
		|	ОтчетОСоставеСменыСоставСмены.ЗамещающийСотрудник.Наименование
		|ИЗ
		|	Документ.ОтчетОСоставеСмены.СоставСмены КАК ОтчетОСоставеСменыСоставСмены
		|ГДЕ
		|	ОтчетОСоставеСменыСоставСмены.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Явка УБЫВ,
		|	НомерСтроки
		|ИТОГИ ПО
		|	Явка";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		ВыборкаЯвки = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаЯвки.Следующий() Цикл
			
			Если ВыборкаЯвки.Явка = Истина Тогда
				ИмяОбласти = "Работали";
			Иначе
				ИмяОбласти = "Неявка";
			КонецЕсли;
				
			Выборка = ВыборкаЯвки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
			Если Выборка.Количество()>0 Тогда
				
				Область = Макет.ПолучитьОбласть("Заголовок" + ИмяОбласти);
				ТабДокумент.Вывести(Область);
				
				// Вывод строк таблицы
				Область = Макет.ПолучитьОбласть("Строка" + ИмяОбласти);
				Индекс = 0;
				Пока Выборка.Следующий() Цикл
			
					Индекс = Индекс + 1;
					
					Область.Параметры.Заполнить(Выборка);
					Область.Параметры.НомерСтроки  = Индекс;
					ТабДокумент.Вывести(Область);
		
				КонецЦикла;
				
				Область = Макет.ПолучитьОбласть("Итоги" + ИмяОбласти);
				ТабДокумент.Вывести(Область);
				
			КонецЕсли;
			
		КонецЦикла;
			
		//ПОДВАЛ
		Область = Макет.ПолучитьОбласть("Подвал");
		Область.Параметры.Заполнить(Шапка);
		ТабДокумент.Вывести(Область);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;

КонецФункции // ПечатьОтчетаОСоставеСмены()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст ошибки)
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя области в которой был выведен объект)
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОтчетОСоставеСмены") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОтчетОСоставеСмены", "Отчет о составе смены", ПечатьОтчетаОСоставеСмены(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

// Определяет смену исходя из реквизитов документа.
//
Функция ПолучитьСмену(Подразделение, Ответственный, Дата) Экспорт
	
	Смена = Неопределено;
	
	//Если уже введены отчеты о работе смены, то возьмем данные оттуда.
	//Т.е. берем самый последний отчет этого подразделения и этого мастера за незакрытую смену,
	//если за эту смену еще нет документа Отчет о составе смены.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КрайняяСмена.Смена,
	|	КрайняяСмена.ГраницаСмены
	|ИЗ
	|	(ВЫБРАТЬ ПЕРВЫЕ 1
	|		ОтчетМастераСмены.ГраницаСмены КАК ГраницаСмены,
	|		ОтчетМастераСмены.Смена КАК Смена
	|	ИЗ
	|		Документ.ОтчетМастераСмены КАК ОтчетМастераСмены
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗавершенныеСмены КАК ЗавершенныеСмены
	|			ПО ОтчетМастераСмены.Подразделение = ЗавершенныеСмены.Подразделение
	|			И ЗавершенныеСмены.Подразделение = &Подразделение
	|			И ОтчетМастераСмены.ГраницаСмены > ЕСТЬNULL(ЗавершенныеСмены.ГраницаСмены, ДАТАВРЕМЯ(1, 1, 1))
	|	ГДЕ
	|		(НЕ ОтчетМастераСмены.ПометкаУдаления)
	|		И ОтчетМастераСмены.Подразделение = &Подразделение
	|		И ОтчетМастераСмены.Ответственный = &Ответственный
	|	
	|	УПОРЯДОЧИТЬ ПО
	|		ГраницаСмены УБЫВ) КАК КрайняяСмена
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтчетОСоставеСмены КАК ОтчетОСоставеСмены
	|		ПО КрайняяСмена.ГраницаСмены = ОтчетОСоставеСмены.ГраницаСмены
	|			И ((НЕ ОтчетОСоставеСмены.ПометкаУдаления))
	|ГДЕ
	|	ОтчетОСоставеСмены.ГраницаСмены ЕСТЬ NULL "
	);
	Запрос.УстановитьПараметр("Ответственный",	Ответственный);
	Запрос.УстановитьПараметр("Подразделение",	Подразделение);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		//смена с этим бригадиром еще не началась.
		//мы можем попробовать определить смену из графика работы
		СменаПоГрафику = ОперативныйУчетПроизводства.ПолучитьСменуПоГрафику(Ответственный.ФизЛицо, Дата);
		Если ЗначениеЗаполнено(СменаПоГрафику) Тогда
			Смена = СменаПоГрафику;
		КонецЕсли;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий(); //в выборке будет ровно 1 запись
		Если ЗначениеЗаполнено(Выборка.Смена) Тогда
			Смена = Выборка.Смена;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Смена;
	
КонецФункции // УстановитьСмену()

// В функции описано, какие данные следует сохранять в шаблоне
Функция СтруктураДополнительныхДанныхФормы() Экспорт
	
	Возврат ХранилищаНастроек.ДанныеФорм.СформироватьСтруктуруДополнительныхДанных("СоставСмены");
	
КонецФункции
