Перем СохраненнаяНастройка Экспорт;
Перем ТаблицаВариантовОтчета Экспорт;     // Таблица вариантов доступных текущему пользователю
Перем НастрокаПриВыводеОтчета Экспорт;    // Настрока которая применялась при выводе отчета
Перем СоответствиеНаборовДанныхИЗапросов;

	
Функция ПолучитьДополнительныеНастройкиОтчета() Экспорт
	МассивДополнительныхНастроек = Новый Массив;
	МассивДополнительныхНастроек.Добавить(Новый Структура("Имя, Заголовок, ЗначениеПоУмолчанию", "ВыводитьДиаграммуГанта", "Выводить диаграмму", истина));
	Возврат МассивДополнительныхНастроек;
КонецФункции	
                            
Функция СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина) Экспорт
	
	ЗначениеПанелипользователя = ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователяОбъекта(ЭтотОбъект);
	НастрокаПоУмолчанию        = КомпоновщикНастроек.ПолучитьНастройки();
	ТиповыеОтчеты.ПолучитьПримененуюНастройку(ЭтотОбъект);
	
	ТиповыеОтчеты.СформироватьТиповойОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета);
	
	РезультатФормированияОтчета = Результат;
	
	// получи параметр компоновки данных
	
	Если ((ТипЗнч(РезультатФормированияОтчета) = Тип("ТабличныйДокумент") 
		ИЛИ ТипЗнч(РезультатФормированияОтчета) = Тип("ПолеТабличногоДокумента"))) И ЗначениеПанелипользователя <> Неопределено И ЗначениеПанелипользователя.ВыводитьДиаграммуГанта тогда
		ДобавитьДиаграммуГантаВТабличныйДокумент(РезультатФормированияОтчета, КомпоновщикНастроек.Настройки);
	КонецЕсли;
	
	КомпоновщикНастроек.ЗагрузитьНастройки(НастрокаПоУмолчанию);
	
	УправлениеОтчетамиЗК.УстановитьЗапросыСКДПоСоответсвию(СхемаКомпоновкиДанных.НаборыДанных, СоответствиеНаборовДанныхИЗапросов);
 	
	Возврат РезультатФормированияОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом() Экспорт
	
	ПараметрНачалоПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат;
	Иначе
		НачалоПериода = ?(ПараметрНачалоПериода.Значение <> Неопределено, Дата(ПараметрНачалоПериода.Значение), '00010101');
		КонецПериода  = ?(ПараметрКонецПериода.Значение <> Неопределено, Дата(ПараметрКонецПериода.Значение), '00010101');
		Если НачалоПериода = '00010101'  тогда
			НачалоПериода = НачалоМесяца(ТекущаяДата());
		КонецЕсли;
		Если КонецПериода = '00010101' тогда
			КонецПериода = КонецМесяца(ТекущаяДата());
		КонецЕсли;
		ПараметрКонецПериода.Использование = Истина;
		ПараметрНачалоПериода.Использование = Истина;
		
		ПараметрКонецПериода.Значение  = КонецПериода;
		ПараметрНачалоПериода.Значение = НачалоПериода;
	КонецЕсли;
 	СоответствиеНаборовДанныхИЗапросов = Новый Соответствие;

	
	Если НачалоПериода <> Неопределено и КонецПериода <> Неопределено тогда
		ЗаменитьВСКДТекстЗапросКалендаря(СхемаКомпоновкиДанных, НачалоПериода, КонецПериода, СоответствиеНаборовДанныхИЗапросов);
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ЗаменитьВСКДТекстЗапросКалендаря(СКД, НачалоПериода, КонецПериода, СоответствиеНаборовДанныхИЗапросов) Экспорт
	
	СоответствиеНаборовДанныхИЗапросов =  Новый Соответствие;
	
	ДтНачМесяца = НачалоМесяца(НачалоПериода);
	
	ТекстЗапросаЗамены = "ВЫБРАТЬ
	|	ДАТАВРЕМЯ("+Формат(ДтНачМесяца, "ДФ=yyyy")+", "+Месяц(ДтНачМесяца)+", "+День(ДтНачМесяца)+") КАК ДатаКалендаря";
	ДтНачМесяца = ДтНачМесяца + 86400;
	
	Пока ДтНачМесяца <= КонецПериода Цикл
		ТекстЗапросаЗамены =  ТекстЗапросаЗамены + "
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДАТАВРЕМЯ("+Формат(ДтНачМесяца, "ДФ=yyyy")+", "+Месяц(ДтНачМесяца)+", "+День(ДтНачМесяца)+") КАК ДатаКалендаря
		|";
		ДтНачМесяца = ДтНачМесяца + 86400;
	КонецЦикла;
	
	ЗаменитьЗапросККалендарю(СКД.НаборыДанных, ТекстЗапросаЗамены);
	
КонецПроцедуры

Процедура ЗаменитьЗапросККалендарю(НаборыДанных, ТекстЗапросЗамены)
	
	Для каждого НаборДанных из НаборыДанных Цикл
		
		Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных") тогда
			СоответствиеНаборовДанныхИЗапросов.Вставить(НаборДанных.Имя, НаборДанных.Запрос);
			НаборДанных.Запрос = СтрЗаменить(НаборДанных.Запрос, "РегистрСведений.РегламентированныйПроизводственныйКалендарь", "("+ТекстЗапросЗамены+")");
		ИначеЕсли ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных") тогда
			ЗаменитьЗапросККалендарю(НаборДанных.Элементы, ТекстЗапросЗамены)
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


Функция ПолучитьВидСравнения(ВидСравненияКД)
	Если ВидСравненияКД = ВидСравненияКомпоновкиДанных.Равно тогда 
		возврат ВидСравнения.Равно
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеРавно тогда 
		возврат ВидСравнения.НеРавно
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.ВСписке тогда 
		возврат ВидСравнения.ВСписке
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии тогда 
		возврат ВидСравнения.ВСпискеПоИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.ВИерархии тогда 
		возврат ВидСравнения.ВИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВИерархии тогда 
		возврат ВидСравнения.НеВИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии тогда 
		возврат ВидСравнения.НеВСпискеПоИерархии
	ИначеЕсли ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке тогда 
		возврат ВидСравнения.НеВСписке
	Иначе 
		возврат Неопределено
	КонецЕсли;
КонецФункции


Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
КонецПроцедуры
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры


// Процедура заполняет параметры отчета по элементу справочника из переменной СохраненнаяНастройка.
Процедура ПрименитьНастройку() Экспорт
	
	Если СохраненнаяНастройка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	 
	СтруктураПараметров = СохраненнаяНастройка.ХранилищеНастроек.Получить();
	ТиповыеОтчеты.ПрименитьСтруктуруПараметровОтчета(ЭтотОбъект, СтруктураПараметров);
	
КонецПроцедуры

Процедура ИнициализацияОтчета() Экспорт
	
	ТиповыеОтчеты.ИнициализацияТиповогоОтчета(ЭтотОбъект);
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
		
	КонецЕсли;
	
	ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
		
		ЗначениеПараметра.Значение = ОбщегоНазначенияЗК.ПолучитьРабочуюДату() + 7*86400;
		
	КонецЕсли;
	
	//ЗначениеПараметра = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	//
	//Если ЗначениеПараметра <> Неопределено и ЗначениеПараметра.Значение = '00010101' тогда
	//	
	//	ЗначениеПараметра.Значение = КонецМесяца(ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
	//	
	//КонецЕсли;

КонецПроцедуры

Процедура ДобавитьДиаграммуГантаВТабличныйДокумент(ТабличныйДокумент, Настройка)
	
	//получим период формирования отчета
	КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрНачалоПериода = Настройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	ПараметрКонецПериода = Настройка.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	
	Если ПараметрНачалоПериода = Неопределено или ПараметрКонецПериода = Неопределено тогда
		Возврат;
	Иначе
		НачалоПериода = ПараметрНачалоПериода.Значение;
		КонецПериода  = ПараметрКонецПериода.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура("ВидОтчета, Периодичность, мСтильДиаграммыПланУтвержденный, мСтильДиаграммыФакт, мСтильДиаграммыПланНеУтвержденный, ПостроительОтчета, ДатаНач, ДатаКон, мМассивПараметров");
	ПараметрыОтчета.ДатаНач = НачалоПериода;
	ПараметрыОтчета.ДатаКон = КонецПериода;
	ПараметрыОтчета.ВидОтчета = "Планируемая занятость помещений";
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить("Факт");
	ПараметрыОтчета.мМассивПараметров = МассивПараметров;
	ПараметрыОтчета.ПостроительОтчета = Новый ПостроительОтчета;
	ЗаполнитьНачальныеНастройки(ПараметрыОтчета);
	
	
	//настроем отборы в отчете
	Для каждого СтрокаОтбора  из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		Если СтрокаОтбора.Использование 
		   и ПараметрыОтчета.ПостроительОтчета.ДоступныеПоля.Найти(Строка(СтрокаОтбора.ЛевоеЗначение)) <> Неопределено тогда
			ЭлементОтбора = ПараметрыОтчета.ПостроительОтчета.Отбор.Добавить(Строка(СтрокаОтбора.ЛевоеЗначение));
			ЭлементОтбора.Значение = СтрокаОтбора.ПравоеЗначение;
			ЭлементОтбора.ВидСравнения = ПолучитьВидСравнения(СтрокаОтбора.ВидСравнения);
			ЭлементОтбора.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
	// добавим нужные группировки
	Если Настройка.Структура.Количество() = 0 тогда
		Возврат;
	КонецЕсли;
	СписокПолей = ТиповыеОтчеты.ПолучитьМассивГруппировок(Настройка.Структура[0], КомпоновщикНастроек);
	
	БылаГруппировкаПомещений = ложь;
	ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Очистить();
	Для каждого Поле из СписокПолей Цикл
		Если ПараметрыОтчета.ПостроительОтчета.ДоступныеПоля.Найти(Поле) <> Неопределено тогда
			ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Добавить(Поле);
			Если Поле = "Помещение" тогда
				БылаГруппировкаПомещений = истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// проверим нет ли детальных записей
	СписокПолей = ТиповыеОтчеты.ПолучитьГруппировки(КомпоновщикНастроек);
	
	КоличествоГруппировок = СписокПолей.Количество();
	Если КоличествоГруппировок > 0 тогда
		Если СписокПолей[КоличествоГруппировок-1].Значение.ПоляГруппировки.Элементы.Количество() = 0 И Не БылаГруппировкаПомещений тогда
			ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Добавить("Помещение");
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыОтчета.мСтильДиаграммыПланНеУтвержденный = ЦветаСтиля.ПлановыйНеутвержденныйПоказатель;
	ПараметрыОтчета.мСтильДиаграммыПланУтвержденный   = ЦветаСтиля.ПлановыйУтвержденныйПоказатель;
	ПараметрыОтчета.мСтильДиаграммыФакт               = ЦветаСтиля.ФактическийПоказатель;
	
	ДиаграммаГанта = ТабличныйДокумент.Рисунки.Добавить(ТипРисункаТабличногоДокумента.ДиаграммаГанта);
	ДиаграммаГанта.Объект.ОтображатьЗаголовок = ложь;
	ДиаграммаГанта.Объект.ОтображатьЛегенду   = ложь;
	ДиаграммаГанта.Объект.ЕдиницаПериодическогоВарианта = ТипЕдиницыШкалыВремени.Неделя;
	ДиаграммаГанта.Объект.ОтображениеИнтервала          = ОтображениеИнтервалаДиаграммыГанта.Плоский;

	ДиаграммаГанта.Объект.АвтоОпределениеПолногоИнтервала = ложь;
	ДиаграммаГанта.Объект.УстановитьПолныйИнтервал(НачалоПериода, КонецПериода);
	УправлениеОтчетамиЗК.СформироватьДиаграмму(ДиаграммаГанта.Объект, ПараметрыОтчета);
	ДиаграммаГанта.Объект.ЦветФона = Новый Цвет(255,255,255); 
	ДиаграммаГанта.Линия = Новый Линия(ТипЛинииРисункаТабличногоДокумента.НетЛинии, 0);
	
	
	Если ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт тогда
		ОбластьЯчеек = ТабличныйДокумент.Область(ТабличныйДокумент.ВысотаТаблицы + 3, 1, ТабличныйДокумент.ВысотаТаблицы + 20, ТабличныйДокумент.ШиринаТаблицы + 7);
	Иначе
		ОбластьЯчеек = ТабличныйДокумент.Область(ТабличныйДокумент.ВысотаТаблицы + 3, 1, ТабличныйДокумент.ВысотаТаблицы + 20, ТабличныйДокумент.ШиринаТаблицы + 3);
	КонецЕсли;
	ДиаграммаГанта.Расположить(ОбластьЯчеек);
КонецПроцедуры


Процедура ЗаполнитьНачальныеНастройки(ПараметрыОтчета) Экспорт

	мСписокОтборы = Новый СписокЗначений;
	мСписокГруппировки = Новый СписокЗначений;
	
	// Пустой период - без ограничения
	Если ПараметрыОтчета.ДатаНач = '00010101000000' И ПараметрыОтчета.ДатаКон = '00010101000000' Тогда
		ТекстОграничениеПериода = "";
	Иначе
		Если ПараметрыОтчета.ДатаНач = '00010101000000' Тогда
			ТекстОграничениеПериода = "Период <= &ДатаКон";
		ИначеЕсли ПараметрыОтчета.ДатаКон = '00010101000000' Тогда
			ТекстОграничениеПериода = "Период >= &ДатаНач";
		Иначе
			ТекстОграничениеПериода = "Период МЕЖДУ &ДатаНач И &ДатаКон";
		КонецЕсли;
	КонецЕсли; 

	ВыборкаСотрудников = "ВЫБРАТЬ 
	|	СписокСотрудников.Сотрудник КАК Сотрудник,
	|	СписокСотрудников.Физлицо КАК Физлицо
	|ИЗ
	|	(ВЫБРАТЬ
	|		МАКСИМУМ(РаботникиОсновноеМесто.Сотрудник) КАК Сотрудник,
	|		РаботникиОсновноеМесто.Сотрудник.Физлицо КАК Физлицо,
	|		1 КАК Приоритет
	|	ИЗ
	|		РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|				&ДатаСведений,
	|				Сотрудник.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|					И Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)) КАК РаботникиОсновноеМесто
	|	ГДЕ
	|		РаботникиОсновноеМесто.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаботникиОсновноеМесто.Сотрудник.Физлицо
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		МАКСИМУМ(РаботникиСовместительство.Сотрудник),
	|		РаботникиСовместительство.Сотрудник.Физлицо,
	|		2
	|	ИЗ
	|		РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|				&ДатаСведений,
	|				Сотрудник.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|					И Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.Совместительство)) КАК РаботникиСовместительство
	|	ГДЕ
	|		РаботникиСовместительство.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		РаботникиСовместительство.Сотрудник.Физлицо
	|	
	|	ОБЪЕДИНИТЬ
	|	
	|	ВЫБРАТЬ
	|		МАКСИМУМ(СотрудникиДУ.Ссылка),
	|		СотрудникиДУ.Физлицо,
	|		3
	|	ИЗ
	|		Справочник.СотрудникиОрганизаций КАК СотрудникиДУ
	|	ГДЕ
	|		(СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ДоговорУправленческий)
	|				ИЛИ СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор))
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СотрудникиДУ.Физлицо) КАК СписокСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СписокФизическихЛиц.Физлицо КАК Физлицо,
	|			МИНИМУМ(СписокФизическихЛиц.Приоритет) КАК Приоритет
	|		ИЗ
	|			(ВЫБРАТЬ
	|				РаботникиОсновноеМесто.Сотрудник.Физлицо КАК Физлицо,
	|				1 КАК Приоритет
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|						&ДатаСведений,
	|						Сотрудник.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|							И Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)) КАК РаботникиОсновноеМесто
	|			ГДЕ
	|				РаботникиОсновноеМесто.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				РаботникиСовместительство.Сотрудник.Физлицо,
	|				2
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|						&ДатаСведений,
	|						Сотрудник.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор)
	|							И Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.Совместительство)) КАК РаботникиСовместительство
	|			ГДЕ
	|				РаботникиСовместительство.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|			
	|			ОБЪЕДИНИТЬ
	|			
	|			ВЫБРАТЬ
	|				СотрудникиДУ.Физлицо,
	|				3
	|			ИЗ
	|				Справочник.СотрудникиОрганизаций КАК СотрудникиДУ
	|			ГДЕ
	|				(СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ДоговорУправленческий)
	|						ИЛИ СотрудникиДУ.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровСФизЛицами.ТрудовойДоговор))) КАК СписокФизическихЛиц
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СписокФизическихЛиц.Физлицо) КАК СписокФизическихЛиц
	|		ПО СписокСотрудников.Физлицо = СписокФизическихЛиц.Физлицо
	|			И СписокСотрудников.Приоритет = СписокФизическихЛиц.Приоритет";
	
		//Планируемая занятость помещений
		ОсновнаяВыборка = "ВЫБРАТЬ
		|	ПланируемаяЗанятостьПомещений.Помещение,
		|	ПланируемаяЗанятостьПомещений.Помещение.Владелец КАК Территория,
		|	ПланируемаяЗанятостьПомещений.Занятость,
		|	ПланируемаяЗанятостьПомещений.Период КАК НачалоИнтервала,
		|	ПланируемаяЗанятостьПомещений.ПериодЗавершения КАК КонецИнтервала,
		|	ПланируемаяЗанятостьПомещений.Регистратор
		|ИЗ
		|	РегистрСведений.ПланируемаяЗанятостьПомещений КАК ПланируемаяЗанятостьПомещений
		|ГДЕ
		|	ПланируемаяЗанятостьПомещений.Занятость <> ЗНАЧЕНИЕ(Перечисление.Занятость.Свободно)" + ?(ТекстОграничениеПериода <> ""," И " + ТекстОграничениеПериода,"");

		Если ТекстОграничениеПериода <> "" тогда
			ОсновнаяВыборка = ОсновнаяВыборка + "
			|
			|			ОБЪЕДИНИТЬ ВСЕ
			
			|
			|           //Срез занятых на дату начала периоду
			|			ВЫБРАТЬ
			|				ПланируемаяЗанятостьПомещений.Помещение,
			|				ПланируемаяЗанятостьПомещений.Помещение.Владелец КАК Территория,
			|				ПланируемаяЗанятостьПомещений.Занятость,
			|				ПланируемаяЗанятостьПомещений.Период,
			|				ПланируемаяЗанятостьПомещений.ПериодЗавершения,
			|				ПланируемаяЗанятостьПомещений.Регистратор
			|			ИЗ
			|  				РегистрСведений.ПланируемаяЗанятостьПомещений.СрезПоследних(&ДатаНач) КАК ПланируемаяЗанятостьПомещений
			|
			|			ГДЕ
			|				Занятость <> ЗНАЧЕНИЕ(Перечисление.Занятость.Свободно) ";
		КонецЕсли;	 

		ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Основная.Помещение,
		|	Основная.Территория,
		|	Основная.Регистратор,
		|	Основная.НачалоИнтервала,
		|	Основная.КонецИнтервала,
		|	""Факт"" КАК Серия
		|ИЗ
		|	(" + ОсновнаяВыборка + ") КАК Основная
		|
		|{ГДЕ 
		|	Основная.Помещение.* КАК Помещение,
		|	Основная.Регистратор КАК Регистратор,
		|	Основная.Территория.* КАК Территория
		|	}
		|
		|{УПОРЯДОЧИТЬ ПО 
		|	Основная.Территория.* КАК Территория,
		|	Основная.Помещение.* КАК Помещение}
		|
		|{ИТОГИ  ПО 
		|	Основная.Территория.* КАК Территория,
		|	Основная.Помещение.* КАК Помещение}";
		
		мСписокГруппировки.Добавить("Помещение");
		мСписокОтборы.Добавить("Помещение");

	// Очистим прежние настройки отчета
	ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Очистить();
	ПараметрыОтчета.ПостроительОтчета.Порядок.Очистить();
	Пока ПараметрыОтчета.ПостроительОтчета.Отбор.Количество()>0 Цикл
		ПараметрыОтчета.ПостроительОтчета.Отбор.Удалить(0);
	КонецЦикла; 
	
	ПараметрыОтчета.ПостроительОтчета.Текст = ТекстЗапроса;
	
	// Установим группировки по умолчанию
	Для Каждого ЭлементСписка Из мСписокГруппировки Цикл
		ПараметрыОтчета.ПостроительОтчета.ИзмеренияСтроки.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
	// Установим отборы по умолчанию
	Для Каждого ЭлементСписка Из мСписокОтборы Цикл
		ПараметрыОтчета.ПостроительОтчета.Отбор.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
	ПараметрыОтчета.Периодичность = 0; // ДЕНЬ ЧАС
	
КонецПроцедуры // ЗаполнитьНачальныеНастройки()

// Описание дополнитльеных настроек отчета
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт

	СтруктураНаcтроек = Новый Структура("ДополнительныеНастройкиОтчета", истина);
	Возврат СтруктураНаcтроек;

КонецФункции


Если СохраненнаяНастройка = Неопределено Тогда
	СохраненнаяНастройка =  Справочники.СохраненныеНастройки.ПустаяСсылка();
КонецЕсли;


