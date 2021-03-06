#Если Клиент Тогда

Перем ИмяРегистраБухгалтерии Экспорт;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ПЕЧАТНОЙ ФОРМЫ ОТЧЕТА
//

// Формирует табличный документ с заголовком отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт

	ОписаниеПериода = БухгалтерскиеОтчеты.СформироватьСтрокуВыводаПараметровПоДатам(ДатаНач, ДатаКон);
	
	Макет = ПолучитьМакет("Макет");
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");

	НазваниеОрганизации = Организация.НаименованиеПолное;
	Если ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = Организация;
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;
	
	ЗаголовокОтчета.Параметры.Заголовок = ЗаголовокОтчета();

	ЗаголовокОтчета.Параметры.ОписаниеПериода = ОписаниеПериода;

	ТекстСписокПоказателей = "Выводимые данные: сумма";
	Если ПоВалютам Тогда
		ТекстСписокПоказателей = ТекстСписокПоказателей + ", валютная сумма";
	КонецЕсли;

	// Добавление единицы измерения
	Если ВыводитьЕдиницуИзмерения Тогда
		БухгалтерскиеОтчеты.ДобавитьТекстПроЕдиницуИзмерения(ТекстСписокПоказателей);
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.СписокПоказателей = ТекстСписокПоказателей;

	Возврат(ЗаголовокОтчета);
	
КонецФункции // СформироватьЗаголовок()

// Выводит подписи отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьПодписи() Экспорт

	ОбластьПодписи = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета").ПолучитьОбласть("Подписи");
	
	ДополнительныеПараметры = Новый Структура("Период,Организация,ОтветственноеЛицо", 
		ДатаКон, 
		Организация, 
		Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
		
	ДанныеОтветственногоЛица = БухгалтерскиеОтчеты.ПолучитьДанныеОтветственногоЛица(ДополнительныеПараметры);
	ОбластьПодписи.Параметры.Заполнить(ДанныеОтветственногоЛица);
	
	Возврат ОбластьПодписи;	

КонецФункции

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом
//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0, ПоказыватьПодписи = Ложь) Экспорт

	ОграничениеПоДатамКорректно = БухгалтерскиеОтчеты.ПроверитьКорректностьОграниченийПоДатам(ДатаНач, ДатаКон);
	Если НЕ ОграничениеПоДатамКорректно Тогда
        Возврат;
	КонецЕсли;

	ДокументРезультат.Очистить();

	БухгалтерскиеОтчеты.СформироватьИВывестиЗаголовокОтчета(ЭтотОбъект, ДокументРезультат, ВысотаЗаголовка, ПоказыватьЗаголовок);	

	Макет  = ПолучитьМакет("Макет");
	
	Запрос = Новый Запрос;
	
	СтрокаОграниченийПоРеквизитам = "";
	БухгалтерскиеОтчеты.ДополнитьСтрокуОграниченийПоРеквизитам(СтрокаОграниченийПоРеквизитам, "Организация", Организация);
			
	ТекстОтборСчетДт = ?(НЕ ПоЗабалансовымСчетам, " НЕ СчетДт.Забалансовый", "");
	ТекстОтборСчетКт = ?(НЕ ПоЗабалансовымСчетам, " НЕ СчетКт.Забалансовый", "");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХозрасчетныйОборотыДтКт.СчетДт КАК СчетДт,
	|	ХозрасчетныйОборотыДтКт.СчетКт КАК СчетКт,
	|	ХозрасчетныйОборотыДтКт.ВалютаДт КАК ВалютаДт,
	|	ХозрасчетныйОборотыДтКт.ВалютаДт.Представление КАК ВалютаДтПредставление,
	|	ХозрасчетныйОборотыДтКт.ВалютаКт КАК ВалютаКт,
	|	ХозрасчетныйОборотыДтКт.ВалютаКт.Представление КАК ВалютаКтПредставление,
	|	ХозрасчетныйОборотыДтКт.СчетДт.Представление КАК СчетДтПредставление,
	|	ХозрасчетныйОборотыДтКт.СчетКт.Представление КАК СчетКтПредставление,
	|	ХозрасчетныйОборотыДтКт.СчетДт.Валютный КАК СчетДтВалютный,
	|	ХозрасчетныйОборотыДтКт.СчетКт.Валютный КАК СчетКтВалютный,
	|	ХозрасчетныйОборотыДтКт.СуммаОборот КАК СуммаОборот,
	|	ХозрасчетныйОборотыДтКт.ВалютнаяСуммаОборотДт КАК ВалютнаяСуммаОборотДт,
	|	ХозрасчетныйОборотыДтКт.ВалютнаяСуммаОборотКт КАК ВалютнаяСуммаОборотКт
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&ДатаНач, &ДатаКон, , " 
	+ ТекстОтборСчетДт + ", , " 
	+ ТекстОтборСчетКт + ", , "
	+ СтрокаОграниченийПоРеквизитам +"
	|) КАК ХозрасчетныйОборотыДтКт
	|
	|ИТОГИ СУММА(СуммаОборот), СУММА(ВалютнаяСуммаОборотДт), СУММА(ВалютнаяСуммаОборотКт) 
	|	ПО ОБЩИЕ,
	|	СчетДт ИЕРАРХИЯ,
	|	СчетКт ИЕРАРХИЯ,
	|	ВалютаДт, 
	|	ВалютаКт
	|
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	
	Если ДатаКон <> '00010101000000' Тогда
		Запрос.УстановитьПараметр("ДатаКон", КонецДня(ДатаКон));
	Иначе
		Запрос.УстановитьПараметр("ДатаКон", ДатаКон);
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	СоотвСчетаВерхнегоУровня = Новый Соответствие;
	Если Не ПоСубсчетам Тогда
		
		ЗапросСчетаВерх = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Хозрасчетный.Ссылка
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|
		|ГДЕ
		|	Хозрасчетный.Родитель = &ПустойРодитель");
		ЗапросСчетаВерх.УстановитьПараметр("ПустойРодитель", ПланыСчетов.Хозрасчетный.ПустаяСсылка());
		ВыборкаСчетов=ЗапросСчетаВерх.Выполнить().Выбрать();
		Пока ВыборкаСчетов.Следующий() Цикл
			СоотвСчетаВерхнегоУровня.Вставить(ВыборкаСчетов.Ссылка, ВыборкаСчетов.Ссылка)
		КонецЦикла;
		
	КонецЕсли;
	
	ОблНачалоТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы|ПерваяКолонка");
	ОблСчетКт = Макет.ПолучитьОбласть("ШапкаТаблицы|Оборот");
	ОблСчетДт = Макет.ПолучитьОбласть("СтрокаСчет|ПерваяКолонка");
	ОблОборот = Макет.ПолучитьОбласть("СтрокаСчет|Оборот");
	
	// Макеты для валютных счетов
	ОблСчетКтВал = Макет.ПолучитьОбласть("ШапкаТаблицы|ОборотВалюта");
	ОблСчетДтВал = Макет.ПолучитьОбласть("СтрокаСчетВалюта|ПерваяКолонка");
	
	// Если валютный счет Кт
	ОблОборотКтВал = Макет.ПолучитьОбласть("СтрокаСчет|ОборотВалюта");
	// Если валютный счет Дт
	ОблОборотДтВал = Макет.ПолучитьОбласть("СтрокаСчетВалюта|Оборот");
	// Если валютные оба счета
	ОблОборотДтКтВал = Макет.ПолучитьОбласть("СтрокаСчетВалюта|ОборотВалюта");
	ОблИтогоОборот = Макет.ПолучитьОбласть("СтрокаСчет|ИтогоОборотДт");
	ОблИтогоОборотДтВал = Макет.ПолучитьОбласть("СтрокаСчетВалюта|ИтогоОборотДт");
	
	СоответствиеСчетовКтИВалют = Новый Соответствие;
	
	ДокументРезультат.НачатьАвтогруппировкуКолонок();
	
	// Вывод шапки таблицы
	ДокументРезультат.Вывести(ОблНачалоТаблицы,0);
	
	ВыборкаСчетаКт = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СчетКт", "Все");
	Пока ВыборкаСчетаКт.Следующий() Цикл
		
		Если НЕ ПоСубсчетам И СоотвСчетаВерхнегоУровня[ВыборкаСчетаКт.СчетКт] = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВыводимаяОбласть = ОблСчетКт;
		
		ВыводимаяОбласть.Параметры.Заполнить(ВыборкаСчетаКт);
		ДокументРезультат.Присоединить(ВыводимаяОбласть, ВыборкаСчетаКт.Уровень() + 1);
		
		// Вывод валют по кредиту
		Если ПоВалютам
			И ВыборкаСчетаКт.СчетКтВалютный = Истина Тогда
			
			ВыборкаВалютыКт = ВыборкаСчетаКт.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ВалютаКт");
			
			СоответствиеВалютКт = Новый Соответствие;
			
			Пока ВыборкаВалютыКт.Следующий() Цикл
				
				ВыводимаяОбласть = ОблСчетКтВал;
				
				ВыводимаяОбласть.Параметры.Заполнить(ВыборкаВалютыКт);
				
				// Параметры для расшифровки
				ВыводимаяОбласть.Параметры.Расшифровка = Новый Структура("СчетКт, ВалютаКт", ВыборкаВалютыКт.СчетКт, ВыборкаВалютыКт.ВалютаКт);
				
				ДокументРезультат.Присоединить(ВыводимаяОбласть, ВыборкаВалютыКт.Уровень() + 1);
				
				СоответствиеВалютКт.Вставить(ВыборкаВалютыКт.ВалютаКт, 1);
				
			КонецЦикла;
			
			// Запомним валюты, по которым есть итоги на данном счете, чтобы при выводить нужное количество ячеек в строках
			СоответствиеСчетовКтИВалют.Вставить(ВыборкаСчетаКт.СчетКт, СоответствиеВалютКт);
			
		КонецЕсли;

	КонецЦикла;
	
	ДокументРезультат.Присоединить(Макет.ПолучитьОбласть("ШапкаТаблицы|ИтогоОборотДт"), 0);
	ДокументРезультат.ЗакончитьАвтогруппировкуКолонок();
	
	// Вывод строк таблицы
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	
	ВыборкаСчетаДт = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СчетДт");
	
	Пока ВыборкаСчетаДт.Следующий() Цикл
		
		Если НЕ ПоСубсчетам 
			И СоотвСчетаВерхнегоУровня[ВыборкаСчетаДт.СчетДт] = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// вывели заголовки строк
		ОблСчетДт.Параметры.Заполнить(ВыборкаСчетаДт);
		ДокументРезультат.Вывести(ОблСчетДт, ВыборкаСчетаДт.Уровень() + 1);
		
		// вывод реальных оборотов
		ВывестиОборот(ВыборкаСчетаДт, СоотвСчетаВерхнегоУровня, Ложь, СоответствиеСчетовКтИВалют, ДокументРезультат, 
			ОблОборотДтКтВал, ОблОборотДтВал, ОблОборотКтВал, ОблОборот, ОблИтогоОборот, ОблИтогоОборотДтВал);
		
		
		// Вывод валют по дебету
		Если ПоВалютам 
			И ВыборкаСчетаДт.СчетДтВалютный = Истина Тогда
			
			ВыборкаВалютыДт = ВыборкаСчетаДт.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ВалютаДт");
			
			Пока ВыборкаВалютыДт.Следующий() Цикл
				
				ВыводимаяОбласть = ОблСчетДтВал;
				
				ВыводимаяОбласть.Параметры.Заполнить(ВыборкаВалютыДт);
				
				// Параметры для расшифровки
				ВыводимаяОбласть.Параметры.Расшифровка = Новый Структура("СчетДт, ВалютаДт", ВыборкаВалютыДт.СчетДт, ВыборкаВалютыДт.ВалютаДт);
				
				ДокументРезультат.Вывести(ВыводимаяОбласть, ВыборкаВалютыДт.Уровень() + 1);
				
				ВывестиОборот(ВыборкаВалютыДт, СоотвСчетаВерхнегоУровня, Истина, СоответствиеСчетовКтИВалют, ДокументРезультат, 
					ОблОборотДтКтВал, ОблОборотДтВал, ОблОборотКтВал, ОблОборот, ОблИтогоОборот, ОблИтогоОборотДтВал);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Вывод итога
	ВыборкаОборот = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Общие");
	ВыборкаОборот.Следующий();
	ДокументРезультат.Вывести(Макет.ПолучитьОбласть("ИтогоОборотКт|ПерваяКолонка"), 0);
	ВывестиОборот(ВыборкаОборот, СоотвСчетаВерхнегоУровня, Ложь, СоответствиеСчетовКтИВалют, ДокументРезультат, 
		ОблОборотДтКтВал, ОблОборотДтВал, ОблОборотКтВал, ОблОборот, ОблИтогоОборот, ОблИтогоОборотДтВал);
	
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	ТолстаяЛиния = ОблНачалоТаблицы.Область(2, 2).ГраницаСверху;
	
	ДокументРезультат.Область(ВысотаЗаголовка + 2, 2, ДокументРезультат.ВысотаТаблицы, ДокументРезультат.ШиринаТаблицы).Обвести(ТолстаяЛиния, ТолстаяЛиния, ТолстаяЛиния, ТолстаяЛиния);
	
	// Вывод подписей отчета
	БухгалтерскиеОтчеты.СформироватьИВывестиПодписиОтчета(ЭтотОбъект, ДокументРезультат, ВысотаЗаголовка, ПоказыватьПодписи);


	// Заполним общую расшифровку:
	СтруктураНастроекОтчета = Новый Структура;

	СтруктураНастроекОтчета.Вставить("ДатаНач", ДатаНач);
	СтруктураНастроекОтчета.Вставить("ДатаКон", ДатаКон);
	СтруктураНастроекОтчета.Вставить("Организация", Организация);
	СтруктураНастроекОтчета.Вставить("ПоказыватьЗаголовок", ПоказыватьЗаголовок);

	ДокументРезультат.Область(1, 1).Расшифровка = СтруктураНастроекОтчета;

	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 2;
	// Зафиксируем первую колонку отчета
	ДокументРезультат.ФиксацияСлева = 2;

	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1, 1, ДокументРезультат.ВысотаТаблицы, ДокументРезультат.ШиринаТаблицы);
	
	ДокументРезультат.ПовторятьПриПечатиКолонки = ДокументРезультат.Область(, 1, , 2);
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(6, , 6, );
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "Шахматка" + ИмяРегистраБухгалтерии;

КонецПроцедуры // СформироватьОтчет()

// Обработка расшифровки
//
// Параметры:
//	Нет.
//
Процедура ОбработкаРасшифровкиСтандартногоОтчета(Расшифровка) Экспорт
	
	Отчет = Отчеты.ОтчетПоПроводкамХозрасчетный.Создать();
	
	ФормаОтчета = Отчет.ПолучитьФорму(, , Новый УникальныйИдентификатор());
	
	Попытка
		
		Отчет.Настроить(Расшифровка);
		
		ФормаОтчета.ПоказыватьЗаголовок = Расшифровка["ПоказыватьЗаголовок"];
		
		ФормаОтчета.ОбновитьОтчет();
		
	Исключение
		
	КонецПопытки;
	
	ФормаОтчета.Открыть();
	
КонецПроцедуры // ОбработкаРасшифровкиСтандартногоОтчета()

Процедура ВывестиОборот(ВыборкаСчетаДт, СоотвСчетаВерхнегоУровня, СчетДтПоВалюте, СоответствиеСчетовКтИВалют, ДокументРезультат, 
	ОблОборотДтКтВал, ОблОборотДтВал, ОблОборотКтВал, ОблОборот, ОблИтогоОборот, ОблИтогоОборотДтВал)
	
	ВыборкаОборот = ВыборкаСчетаДт.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СчетКт", "Все");
	Пока ВыборкаОборот.Следующий() Цикл
		
		Если НЕ ПоСубсчетам И СоотвСчетаВерхнегоУровня[ВыборкаОборот.СчетКт] = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВыводимаяОбласть = ?(СчетДтПоВалюте, ОблОборотДтВал, ОблОборот);
				
		// нужная строка записывается на пересечении
		ВыводимаяОбласть.Параметры.Заполнить(ВыборкаОборот);
		ДокументРезультат.Присоединить(ВыводимаяОбласть);
		
		// Вывод валют по кредиту
		Если ПоВалютам 
			И ВыборкаОборот.СчетКтВалютный = Истина Тогда
			
			ВыборкаВалютыКт = ВыборкаОборот.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ВалютаКт", "Все");
			
			ВыводимаяОбласть = ?(СчетДтПоВалюте, ОблОборотДтКтВал, ОблОборотКтВал);
			
			Пока ВыборкаВалютыКт.Следующий() Цикл
				
				// Не выводим ячейки для тех валют, по которым не было итогов
				Если СоответствиеСчетовКтИВалют[ВыборкаВалютыКт.СчетКт][ВыборкаВалютыКт.ВалютаКт] = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ВыводимаяОбласть.Параметры.Заполнить(ВыборкаВалютыКт);
				
				ДокументРезультат.Присоединить(ВыводимаяОбласть, ВыборкаВалютыКт.Уровень() + 1);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Вывод итога
	ВыводимаяОбласть = ?(СчетДтПоВалюте, ОблИтогоОборотДтВал, ОблИтогоОборот);
		
	// итог по строке записывается
	ВыводимаяОбласть.Параметры.Заполнить(ВыборкаСчетаДт);
	ДокументРезультат.Присоединить(ВыводимаяОбласть, ВыборкаСчетаДт.Уровень() + 1);	
	
КонецПроцедуры // ВывестиОборот()

Функция ЗаголовокОтчета() Экспорт
	Возврат "Шахматная оборотная ведомость";
КонецФункции // ЗаголовокОтчета()

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

// Константа - имя регистра бухгалтерии
ИмяРегистраБухгалтерии = "Хозрасчетный";

#КонецЕсли