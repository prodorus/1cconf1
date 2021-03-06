Перем СоответствиеТиповИПредставлений;
Перем ТипыДокументов;
Перем ПараметрыСФ;
Перем мВалютаРегламентированногоУчета;

#Если Клиент Тогда

// Формирование отчета в виде табличного документа.
// Параметры:
//  ТабличныйДокумент - макет отчета.
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	МассивПрефиксовДляРИБиОрганизации = ОбщегоНазначения.СформироватьМассивПрефиксовДляРИБИОрганизации(Организация);
	
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Макет = ПолучитьМакет("Макет");

	// Вывод шапки
	Секция = Макет.ПолучитьОбласть("Шапка");
	Секция.Параметры.НачалоПериода = Формат(НачалоПериода, "ДФ=dd.MM.yyyy");
	Секция.Параметры.КонецПериода = Формат(КонецПериода, "ДФ=dd.MM.yyyy");
	Секция.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
	ТабличныйДокумент.Вывести(Секция);
	
	// Выполнение запроса.
	Результат = ПодготовитьОтчетКВыводуНаПечать();
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если Результат.Пустой() Тогда
	
		Секция = Макет.ПолучитьОбласть("Строка");
		УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(
			ТабличныйДокумент, , Строка(глЗначениеПеременной("глТекущийПользователь")));
	    Возврат;
		
	КонецЕсли; 
	
	Секция  = Макет.ПолучитьОбласть("Строка");
	Счетчик = 1;
	
	Если НЕ СформироватьОтчетПоСтандартнойФорме И ГруппироватьПоКонтрагентам Тогда
		
		//Режим построения с группировкой по контрагенту
		СекцияКонтрагента = Макет.ПолучитьОбласть("Контрагент");
		ГруппировкаПоКонтрагенту = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
		
		Пока ГруппировкаПоКонтрагенту.Следующий() Цикл
			СекцияКонтрагента.Параметры.Заполнить(ГруппировкаПоКонтрагенту);
			ТабличныйДокумент.Вывести(СекцияКонтрагента,1);
		
			СчетФактура = ГруппировкаПоКонтрагенту.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока СчетФактура.Следующий() Цикл
				
			Если ТипЗнч(СчетФактура.СчетФактура) = Тип("ДокументСсылка.СчетФактураПолученный") 
				И СчетФактура.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыПолученного.Корректировочный Тогда
					Документ = СчетФактура.Выбрать();
					Пока Документ.Следующий() Цикл
						Секция.Параметры.НПП = Счетчик;
						ВыводСтрокиКорректировочногоСФ(Документ, Секция, МассивПрефиксовДляРИБиОрганизации);
						ТабличныйДокумент.Вывести(Секция, 2);
						Счетчик = Счетчик + 1;
					КонецЦикла;
				Иначе
					Секция.Параметры.НПП = Счетчик;
					ВыводСтроки(СчетФактура, Секция, МассивПрефиксовДляРИБиОрганизации);
					ТабличныйДокумент.Вывести(Секция, 2);
					Счетчик = Счетчик + 1;
				КонецЕсли;
				
			КонецЦикла; 
			
		КонецЦикла; 
		
		ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
		
	Иначе
		
		// Простой режим
		СчетФактура = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока СчетФактура.Следующий() Цикл
			
			Если ТипЗнч(СчетФактура.СчетФактура) = Тип("ДокументСсылка.СчетФактураПолученный") 
				И СчетФактура.ВидСчетаФактуры = Перечисления.ВидСчетаФактурыПолученного.Корректировочный Тогда
					Документ = СчетФактура.Выбрать();
					Пока Документ.Следующий() Цикл
						Секция.Параметры.НПП = Счетчик;
						ВыводСтрокиКорректировочногоСФ(Документ, Секция, МассивПрефиксовДляРИБиОрганизации);
						ТабличныйДокумент.Вывести(Секция, 2);
						Счетчик = Счетчик + 1;
					КонецЦикла;
				Иначе
					Секция.Параметры.НПП = Счетчик;
					ВыводСтроки(СчетФактура, Секция, МассивПрефиксовДляРИБиОрганизации);
					ТабличныйДокумент.Вывести(Секция, 2);
					Счетчик = Счетчик + 1;
				КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТабличныйДокумент.ПовторятьПриПечатиСтроки = ТабличныйДокумент.Области.Шапка;
	
	УправлениеОтчетами.УстановитьКолонтитулыПоУмолчанию(ТабличныйДокумент, , Строка(глЗначениеПеременной("глТекущийПользователь")));
	
КонецПроцедуры

// Функция вызывается из тела процедуры "Сформировать".
// Функция осуществляет первичную обработку результатов запроса к движениям регистра НДСПродажи,
// и по данным запроса заполняет таблицу значений, на основании которой, будет напечатана книга продаж
// Параметры:
// 	Результат - ссылка на результаты выполнения запроса к данным регистра "НДСПродажи"
//  МоментОпределенияНалоговойБазыНДС
Функция ПодготовитьОтчетКВыводуНаПечать()
	
	// Документы с реквизитом Предъявлен счет-фактура
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	КонтрагентПоАО.Ссылка КАК АО,
	|	КонтрагентПоАО.СчетФактура КАК СчетФактура,
	|	КонтрагентПоАО.Контрагент КАК Контрагент
	|ПОМЕСТИТЬ ВТ_КонтрагентПоАО
	|ИЗ
	|	(ВЫБРАТЬ
	|		АвансовыйОтчетТовары.СчетФактура КАК СчетФактура,
	|		АвансовыйОтчетТовары.Поставщик КАК Контрагент,
	|		АвансовыйОтчетТовары.Ссылка КАК Ссылка
	|	ИЗ
	|		Документ.АвансовыйОтчет.Товары КАК АвансовыйОтчетТовары
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		АвансовыйОтчетПрочее.СчетФактура,
	|		АвансовыйОтчетПрочее.Поставщик,
	|		АвансовыйОтчетПрочее.Ссылка
	|	ИЗ
	|		Документ.АвансовыйОтчет.Прочее КАК АвансовыйОтчетПрочее) КАК КонтрагентПоАО
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетФактура,
	|	АО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СчетФактураПолученный.Ссылка КАК СчетФактура,
	|	СчетФактураПолученный.Ссылка.Дата КАК ДатаРегистрации,
	|	СчетФактураПолученный.ДокументОснование КАК ДокументОснование,
	|	ВЫБОР
	|		КОГДА СчетФактураПолученный.Ссылка.СформированПриВводеНачальныхОстатковНДС
	|			ТОГДА СчетФактураПолученный.Ссылка.СуммаДокумента
	|		КОГДА СчетФактураПолученный.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.НаАванс)
	|			ТОГДА СчетФактураПолученный.Ссылка.СуммаДокумента
	|		ИНАЧЕ СчетФактураПолученный.ДокументОснование.СуммаДокумента
	|	КОНЕЦ КАК СуммаДокумента,
	|	СчетФактураПолученный.Ссылка.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	|	СчетФактураПолученный.Ссылка.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	ВЫБОР
	|		КОГДА СчетФактураПолученный.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.НаАванс)
	|			ТОГДА СчетФактураПолученный.Ссылка.Контрагент
	|		КОГДА СчетФактураПолученный.ДокументОснование ССЫЛКА Документ.АвансовыйОтчет
	|			ТОГДА ВложенныйЗапрос.Контрагент
	|		ИНАЧЕ СчетФактураПолученный.ДокументОснование.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	СчетФактураПолученный.ДокументОснование.ВалютаДокумента КАК ВалютаДокумента,
	|	ВЫБОР
	|		КОГДА (НЕ СчетФактураПолученный.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.НаАванс))
	|					И СчетФактураПолученный.ДокументОснование ССЫЛКА Документ.АвансовыйОтчет
	|				ИЛИ СчетФактураПолученный.ДокументОснование ССЫЛКА Документ.ОтчетКомиссионераОПродажах
	|			ТОГДА ИСТИНА
	|		КОГДА (НЕ СчетФактураПолученный.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.НаАванс))
	|				И (СчетФактураПолученный.ДокументОснование.ДоговорКонтрагента.Владелец ЕСТЬ NULL 
	|					ИЛИ СчетФактураПолученный.ДокументОснование.СуммаДокумента ЕСТЬ NULL )
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОпределитьПараметрыСчетаФактуры,
	|	СчетФактураПолученный.ДокументОснование.Дата КАК ДокументОснованиеДата,
	|	СчетФактураПолученный.ДокументОснование.Номер КАК ДокументОснованиеНомер,
	|	СчетФактураПолученный.Ссылка.ВидСчетаФактуры КАК ВидСчетаФактуры
	|
	|ПОМЕСТИТЬ ВТ_НеКорректировочныеСФ
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК СчетФактураПолученный
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КонтрагентПоАО КАК ВложенныйЗапрос
	|		ПО СчетФактураПолученный.ДокументОснование = ВложенныйЗапрос.АО
	|			И СчетФактураПолученный.Ссылка = ВложенныйЗапрос.СчетФактура
	|ГДЕ
	|	(НЕ СчетФактураПолученный.Ссылка.ПометкаУдаления)
	|	И СчетФактураПолученный.Ссылка.Дата >= &НачалоПериода
	|	И СчетФактураПолученный.Ссылка.Дата <= &КонецПериода
	|	И СчетФактураПолученный.Ссылка.Организация = &Организация
	|	И (НЕ СчетФактураПолученный.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.Корректировочный))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КорректировочныйСчетФактураПолученный.Ссылка,
	|	КорректировочныйСчетФактураПолученный.Ссылка.Дата КАК Дата,
	|	КорректировочныйСчетФактураПолученный.ДокументОснование,
	|	КорректировочныйСчетФактураПолученный.Ссылка.СуммаУвеличение КАК СуммаУвеличение,
	|	КорректировочныйСчетФактураПолученный.Ссылка.СуммаУменьшение КАК СуммаУменьшение,
	|	КорректировочныйСчетФактураПолученный.Ссылка.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	|	КорректировочныйСчетФактураПолученный.Ссылка.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	КорректировочныйСчетФактураПолученный.Ссылка.Контрагент КАК Контрагент,
	|	КорректировочныйСчетФактураПолученный.Ссылка.ВалютаДокумента КАК ВалютаДокумента,
	|	КорректировочныйСчетФактураПолученный.ДокументОснование.Дата КАК ДокументОснованиеДата,
	|	КорректировочныйСчетФактураПолученный.ДокументОснование.Номер КАК ДокументОснованиеНомер,
	|	КорректировочныйСчетФактураПолученный.Ссылка.ВидСчетаФактуры КАК ВидСчетаФактуры
	|
	|ПОМЕСТИТЬ ВТ_КорректировочныеСФ
	|ИЗ
	|	Документ.СчетФактураПолученный.ДокументыОснования КАК КорректировочныйСчетФактураПолученный
	|ГДЕ
	|	(НЕ КорректировочныйСчетФактураПолученный.Ссылка.ПометкаУдаления)
	|	И КорректировочныйСчетФактураПолученный.Ссылка.Дата >= &НачалоПериода
	|	И КорректировочныйСчетФактураПолученный.Ссылка.Дата <= &КонецПериода
	|	И КорректировочныйСчетФактураПолученный.Ссылка.Организация = &Организация
	|	И КорректировочныйСчетФактураПолученный.Ссылка.ВидСчетаФактуры = ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.Корректировочный)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РеестрСчетовФактур.СчетФактура КАК СчетФактура,
	|	РеестрСчетовФактур.ДатаРегистрации КАК ДатаРегистрации,
	|	РеестрСчетовФактур.ДатаВходящегоДокумента,
	|	РеестрСчетовФактур.НомерВходящегоДокумента,
	|	РеестрСчетовФактур.СуммаДокумента КАК СуммаДокумента,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РеестрСчетовФактур.ВалютаДокумента, ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)) = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|			ТОГДА &ВалютаРегламентированногоУчета
	|		ИНАЧЕ РеестрСчетовФактур.ВалютаДокумента
	|	КОНЕЦ КАК ВалютаДокумента,
	|	РеестрСчетовФактур.Контрагент,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(РеестрСчетовФактур.Контрагент.НаименованиеПолное, 1, 250) = """"
	|			ТОГДА РеестрСчетовФактур.Контрагент.Наименование
	|		ИНАЧЕ ПОДСТРОКА(РеестрСчетовФактур.Контрагент.НаименованиеПолное, 1, 250)
	|	КОНЕЦ КАК КонтрагентНаименование,
	|	РеестрСчетовФактур.ДокументОснование,
	|	РеестрСчетовФактур.ДокументОснованиеДата,
	|	РеестрСчетовФактур.ДокументОснованиеНомер,
	|	РеестрСчетовФактур.ОпределитьПараметрыСчетаФактуры КАК ОпределитьПараметрыСчетаФактуры,
	|	РеестрСчетовФактур.ВидСчетаФактуры
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВТ_НеКорректировочныеСФ.СчетФактура,
	|		ВТ_НеКорректировочныеСФ.ДатаРегистрации,
	|		ВТ_НеКорректировочныеСФ.ДокументОснование,
	|		ВТ_НеКорректировочныеСФ.СуммаДокумента,
	|		ВТ_НеКорректировочныеСФ.ДатаВходящегоДокумента,
	|		ВТ_НеКорректировочныеСФ.НомерВходящегоДокумента,
	|		ВТ_НеКорректировочныеСФ.Контрагент,
	|		ВТ_НеКорректировочныеСФ.ВалютаДокумента КАК ВалютаДокумента,
	|		ВТ_НеКорректировочныеСФ.ОпределитьПараметрыСчетаФактуры,
	|		ВТ_НеКорректировочныеСФ.ДокументОснованиеДата,
	|		ВТ_НеКорректировочныеСФ.ДокументОснованиеНомер,
	|		ВТ_НеКорректировочныеСФ.ВидСчетаФактуры
	|	ИЗ
	|		ВТ_НеКорректировочныеСФ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ГТДИмпортТовары.Ссылка,
	|		ГТДИмпортТовары.Ссылка.Дата,
	|		ГТДИмпортТовары.Ссылка,
	|		СУММА(ГТДИмпортТовары.ФактурнаяСтоимость),
	|		NULL,
	|		ГТДИмпортТовары.Ссылка.НомерГТД,
	|		ГТДИмпортТовары.Ссылка.Контрагент,
	|		ГТДИмпортТовары.Ссылка.ВалютаДокумента,
	|		ЛОЖЬ,
	|		ГТДИмпортТовары.Ссылка.Дата,
	|		ГТДИмпортТовары.Ссылка.Номер,
	|		ЗНАЧЕНИЕ(Перечисление.ВидСчетаФактурыПолученного.ПустаяСсылка) КАК ВидСчетаФактуры
	|	ИЗ
	|		Документ.ГТДИмпорт.Товары КАК ГТДИмпортТовары
	|	ГДЕ
	|		(НЕ ГТДИмпортТовары.Ссылка.ПометкаУдаления)
	|		И ГТДИмпортТовары.Ссылка.Дата >= &НачалоПериода
	|		И ГТДИмпортТовары.Ссылка.Дата <= &КонецПериода
	|		И ГТДИмпортТовары.Ссылка.Организация = &Организация
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ГТДИмпортТовары.Ссылка,
	|		ГТДИмпортТовары.Ссылка.Дата,
	|		ГТДИмпортТовары.Ссылка.НомерГТД,
	|		ГТДИмпортТовары.Ссылка.Контрагент,
	|		ГТДИмпортТовары.Ссылка.Номер,
	|		ГТДИмпортТовары.Ссылка.ВалютаДокумента,
	|		ГТДИмпортТовары.Ссылка,
	|		ГТДИмпортТовары.Ссылка.Дата
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КорректировочныйСчетФактураПолученный.Ссылка,
	|		КорректировочныйСчетФактураПолученный.Дата,
	|		КорректировочныйСчетФактураПолученный.ДокументОснование,
	|		-КорректировочныйСчетФактураПолученный.СуммаУменьшение,
	|		КорректировочныйСчетФактураПолученный.ДатаВходящегоДокумента,
	|		КорректировочныйСчетФактураПолученный.НомерВходящегоДокумента,
	|		КорректировочныйСчетФактураПолученный.Контрагент,
	|		КорректировочныйСчетФактураПолученный.ВалютаДокумента,
	|		ЛОЖЬ КАК ОпределитьПараметрыСчетаФактуры,
	|		КорректировочныйСчетФактураПолученный.ДокументОснованиеДата,
	|		КорректировочныйСчетФактураПолученный.ДокументОснованиеНомер,
	|		КорректировочныйСчетФактураПолученный.ВидСчетаФактуры
	|	ИЗ
	|		ВТ_КорректировочныеСФ КАК КорректировочныйСчетФактураПолученный
	|	ГДЕ
	|		КорректировочныйСчетФактураПолученный.Ссылка.СуммаУменьшение > 0
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КорректировочныйСчетФактураПолученный.Ссылка,
	|		КорректировочныйСчетФактураПолученный.Дата,
	|		КорректировочныйСчетФактураПолученный.ДокументОснование,
	|		КорректировочныйСчетФактураПолученный.СуммаУвеличение,
	|		КорректировочныйСчетФактураПолученный.ДатаВходящегоДокумента,
	|		КорректировочныйСчетФактураПолученный.НомерВходящегоДокумента,
	|		КорректировочныйСчетФактураПолученный.Контрагент,
	|		КорректировочныйСчетФактураПолученный.ВалютаДокумента,
	|		ЛОЖЬ КАК ОпределитьПараметрыСчетаФактуры,
	|		КорректировочныйСчетФактураПолученный.ДокументОснованиеДата,
	|		КорректировочныйСчетФактураПолученный.ДокументОснованиеНомер,
	|		КорректировочныйСчетФактураПолученный.ВидСчетаФактуры
	|	ИЗ
	|		ВТ_КорректировочныеСФ КАК КорректировочныйСчетФактураПолученный
	|	ГДЕ
	|		(КорректировочныйСчетФактураПолученный.Ссылка.СуммаУвеличение > 0
	|				ИЛИ КорректировочныйСчетФактураПолученный.Ссылка.СуммаУвеличение = 0
	|					И КорректировочныйСчетФактураПолученный.Ссылка.СуммаУменьшение = 0)) КАК РеестрСчетовФактур
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ОтбиратьПоКонтрагенту
	|				ТОГДА РеестрСчетовФактур.Контрагент В ИЕРАРХИИ (&КонтрагентДляОтбора)
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаРегистрации,
	|	РеестрСчетовФактур.ДатаВходящегоДокумента
	|ИТОГИ
	|	СУММА(СуммаДокумента),
	|	МАКСИМУМ(ОпределитьПараметрыСчетаФактуры),
	|	МАКСИМУМ(ВидСчетаФактуры)
	|ПО СчетФактура";
	
	Если не СформироватьОтчетПоСтандартнойФорме и ГруппироватьПоКонтрагентам Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,
			"
			|ИТОГИ
			|	СУММА(СуммаДокумента),
			|	МАКСИМУМ(ОпределитьПараметрыСчетаФактуры),
			|	МАКСИМУМ(ВидСчетаФактуры)
			|ПО СчетФактура",
			"
			|ИТОГИ
			|	СУММА(СуммаДокумента),
			|	МАКСИМУМ(ОпределитьПараметрыСчетаФактуры),
			|	МАКСИМУМ(ВидСчетаФактуры)
			|ПО	Контрагент, СчетФактура");
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "УПОРЯДОЧИТЬ ПО", "УПОРЯДОЧИТЬ ПО
		|КонтрагентНаименование, ");
	КонецЕсли; 
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(КонецПериода));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", мВалютаРегламентированногоУчета);
	Запрос.УстановитьПараметр("ОтбиратьПоКонтрагенту", НЕ СформироватьОтчетПоСтандартнойФорме 
		И ОтбиратьПоКонтрагенту 
		И НЕ КонтрагентДляОтбора = Справочники.Контрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("КонтрагентДляОтбора", КонтрагентДляОтбора);

	Возврат Запрос.Выполнить();

КонецФункции

Процедура ВыводСтроки(СчетФактура, Секция, МассивПрефиксовДляРИБиОрганизации)

	Если СчетФактура.ОпределитьПараметрыСчетаФактуры Тогда
		УчетНДС.ПолучитьПараметрыСчетаФактуры(СчетФактура.СчетФактура, мВалютаРегламентированногоУчета, ПараметрыСФ);
		Секция.Параметры.Сумма = ?(ПараметрыСФ.СуммаДокумента = 0, 
			"", Формат(ПараметрыСФ.СуммаДокумента, "ЧЦ=19; ЧДЦ=2") + " " + Строка(ПараметрыСФ.ВалютаДокумента));
		ПредставлениеОснования = "";
		УстановитьПараметры = Истина;
		
		Документ = СчетФактура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока Документ.Следующий() Цикл
			Если УстановитьПараметры Тогда
				УстановитьПараметры = Ложь;
				Секция.Параметры.Заполнить(Документ);
			КонецЕсли;					
			Если ПустаяСтрока(ПредставлениеОснования) Тогда
				Секция.Параметры.ДокументОснование = Документ.ДокументОснование;
			Иначе
				ПредставлениеОснования = ПредставлениеОснования + Символы.ПС;
			КонецЕсли; 
					
			ПредставлениеТипа = ПолучитьПредставлениеПоТипу(ТипЗнч(Документ.ДокументОснование));
					
			Если Не ПредставлениеТипа = Неопределено Тогда
				ПредставлениеОснования = ПредставлениеОснования + ПредставлениеТипа 
					+ " № " + ОбщегоНазначения.ПолучитьНомерНаПечать(Документ.ДокументОснование, МассивПрефиксовДляРИБиОрганизации)
					+ " от "+ Формат(Документ.ДокументОснованиеДата, "ДФ=dd.MM.yyyy") + " г.";
			Иначе	
				ПредставлениеОснования = ПредставлениеОснования + Строка(Документ.ДокументОснование);
			КонецЕсли; 
			Секция.Параметры.ПредставлениеОснования = ПредставлениеОснования;
					
			Секция.Параметры.Контрагент = ПараметрыСФ.Контрагент;
			Если ЗначениеЗаполнено(ПараметрыСФ.Контрагент)  Тогда
				Секция.Параметры.КонтрагентНаименование = ?(ПустаяСтрока(ПараметрыСФ.Контрагент.НаименованиеПолное),
					СокрЛП(ПараметрыСФ.Контрагент), СокрЛП(ПараметрыСФ.Контрагент.НаименованиеПолное));
			КонецЕсли; 
			Если ТипЗнч(Документ.ДокументОснование) = Тип("ДокументСсылка.ГТДИмпорт") Тогда
			    Секция.Параметры.ДатаНомер = "ГТД № " + Документ.НомерВходящегоДокумента;
			Иначе
				Секция.Параметры.ДатаНомер = Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy") 
					+ ", № " + Документ.НомерВходящегоДокумента;
			КонецЕсли; 
		КонецЦикла;
		
	Иначе
		
		Документ = СчетФактура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		УстановитьПараметры = Истина;
		ПредставлениеОснования = "";
		
		Пока Документ.Следующий() Цикл
			Если УстановитьПараметры Тогда
				УстановитьПараметры = Ложь;
				Секция.Параметры.Заполнить(Документ);
				Секция.Параметры.Сумма = ?(СчетФактура.СуммаДокумента = 0, 
					"", Формат(СчетФактура.СуммаДокумента, "ЧЦ=19; ЧДЦ=2") + " " + Строка(Документ.ВалютаДокумента));
			КонецЕсли;					
			Если ПустаяСтрока(ПредставлениеОснования) Тогда
				Секция.Параметры.ДокументОснование = Документ.ДокументОснование;
			Иначе
				ПредставлениеОснования = ПредставлениеОснования+Символы.ПС;
			КонецЕсли; 
			ПредставлениеТипа = ПолучитьПредставлениеПоТипу(ТипЗнч(Документ.ДокументОснование));
			Если Не ПредставлениеТипа = Неопределено Тогда
				ПредставлениеОснования = ПредставлениеОснования + ПредставлениеТипа 
					+ " № " + ОбщегоНазначения.ПолучитьНомерНаПечать(
					Новый Структура("Организация, Номер", Организация, Документ.ДокументОснованиеНомер), 
					МассивПрефиксовДляРИБиОрганизации) 
					+ " от " + Формат(Документ.ДокументОснованиеДата, "ДФ=dd.MM.yyyy") + " г.";
			Иначе	
				ПредставлениеОснования = ПредставлениеОснования + Строка(Документ.ДокументОснование);
			КонецЕсли; 
			Если ТипЗнч(Документ.ДокументОснование) = Тип("ДокументСсылка.ГТДИмпорт") Тогда
			    Секция.Параметры.ДатаНомер = "ГТД № " + Документ.НомерВходящегоДокумента;
			Иначе
				Секция.Параметры.ДатаНомер = Формат(Документ.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy") 
					+ ", № " + Документ.НомерВходящегоДокумента;
			КонецЕсли; 
		КонецЦикла;
		Секция.Параметры.ПредставлениеОснования = ПредставлениеОснования;

	КонецЕсли;
	
КонецПроцедуры

Процедура ВыводСтрокиКорректировочногоСФ(СчетФактура, Секция, МассивПрефиксовДляРИБиОрганизации)
	
	ДатаСФ = Формат(СчетФактура.ДокументОснованиеДата, "ДФ=dd.MM.yyyy");
	ПредставлениеТипа = ПолучитьПредставлениеПоТипу(ТипЗнч(СчетФактура.ДокументОснование));
	Если Не ПредставлениеТипа = Неопределено Тогда
		ПредставлениеОснования = ПредставлениеТипа + " № " + СчетФактура.ДокументОснованиеНомер + " от " + ДатаСФ + " г.";
	Иначе	
		ПредставлениеОснования = Строка(СчетФактура.ДокументОснование);
	КонецЕсли; 
	
	Секция.Параметры.Заполнить(СчетФактура);
	Секция.Параметры.Сумма = ?(СчетФактура.СуммаДокумента = 0, 
		"", Формат(СчетФактура.СуммаДокумента, "ЧЦ=19; ЧДЦ=2") + " " + Строка(СчетФактура.ВалютаДокумента));
	Секция.Параметры.ДокументОснование      = СчетФактура.ДокументОснование;
	Секция.Параметры.ПредставлениеОснования = ПредставлениеОснования;
	Секция.Параметры.ДатаНомер = Формат(СчетФактура.ДатаВходящегоДокумента, "ДФ=dd.MM.yyyy") 
		+ ", № " + СчетФактура.НомерВходящегоДокумента;
	
КонецПроцедуры 

Функция ПолучитьПредставлениеПоТипу(ТипЗначения)

	Представление = СоответствиеТиповИПредставлений[ТипЗначения];
	Если Представление = Неопределено Тогда
		Если ТипЗначения <> ТипЗнч(Неопределено) И Документы.ТипВсеСсылки().СодержитТип(ТипЗначения) Тогда
			Представление = Метаданные.НайтиПоТипу(ТипЗначения).Представление();
		Иначе
			Представление = Неопределено;	
		КонецЕсли; 
		
		СоответствиеТиповИПредставлений.Вставить(ТипЗначения, Представление);
	КонецЕсли; 
	
	Возврат Представление; 

КонецФункции

#КонецЕсли

СоответствиеТиповИПредставлений = Новый Соответствие();
ТипыДокументов = Документы.ТипВсеСсылки();

мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();