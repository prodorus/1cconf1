﻿
//#Область СлужебныеПроцедурыИФункции

// Функция - Код классификатора номенклатуры ЕГАИС
//
// Параметры:
//  ШтрихкодАкцизнойМарки - Строка - Штрихкод акцизной марки
// 
// Возвращаемое значение:
//  Строка - строка с кодом номенклатуры по классификатору егаис
//
Функция КодКлассификатораНоменклатурыЕГАИС(ШтрихкодАкцизнойМарки) Экспорт
	
	Если Сред(ШтрихкодАкцизнойМарки, 4, 5) = "00000" Тогда
		
		Значение = Сред(ШтрихкодАкцизнойМарки, 9, 11);
		КоличествоИтераций = 11;
		
	Иначе
		
		Значение = Сред(ШтрихкодАкцизнойМарки, 8, 12);
		КоличествоИтераций = 12;
		
	КонецЕсли;
	
	Результат = 0;
	
	Для Итерация = 1 По КоличествоИтераций Цикл
		
		Сумматор = 1;
		Для Индекс = 1 По КоличествоИтераций - Итерация Цикл
			Сумматор = Сумматор * 36;
		КонецЦикла;
		
		Результат = Результат + Сумматор * (Найти("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", Сред(Значение, Итерация, 1)) - 1);
		
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧЦ=19; ЧВН=; ЧГ=0");
	
КонецФункции

// Заполняет сопоставленную номенклатуру и данные классификатора по считанной акцизной марке.
//
Процедура ЗаполнитьСопоставленнуюНоменклатуруПоАкцизнойМарке(Штрихкод, ДанныеШтрихкода) Экспорт
	
	КодАлкогольнойПродукции = КодКлассификатораНоменклатурыЕГАИС(Штрихкод);
	
	ПустаяНоменклатура         = Справочники.Номенклатура.ПустаяСсылка();
	ПустаяХарактеристика       = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	ПустаяСерия                = Справочники.СерииНоменклатуры.ПустаяСсылка();
	ПустаяСправка2             = Справочники.Справки2ЕГАИС.ПустаяСсылка();
	ПустаяАлкогольнаяПродукция = Справочники.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка                                 КАК АлкогольнаяПродукция,
	|	ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.Номенклатура,   &ПустаяНоменклатура)   КАК Номенклатура,
	|	ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.Характеристика, &ПустаяХарактеристика) КАК Характеристика,
	|	ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.Серия,          &ПустаяСерия)          КАК Серия,
	|	ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.Справка2,       &ПустаяСправка2)       КАК Справка2,
	|	ЕСТЬNULL(СоответствиеНоменклатурыЕГАИС.ИдентификаторУпаковки, """")           КАК ИдентификаторУпаковки
	|ПОМЕСТИТЬ СоответствиеНоменклатурыЕГАИС
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПРАВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторАлкогольнойПродукцииЕГАИС КАК КлассификаторАлкогольнойПродукцииЕГАИС
	|		ПО СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция = КлассификаторАлкогольнойПродукцииЕГАИС.Ссылка
	|ГДЕ
	|	КлассификаторАлкогольнойПродукцииЕГАИС.Код = &КодАлкогольнойПродукции
	|;
	|
	|/////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция  КАК АлкогольнаяПродукция,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура          КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика        КАК Характеристика,
	|	СоответствиеНоменклатурыЕГАИС.Серия                 КАК Серия,
	|	СоответствиеНоменклатурыЕГАИС.Справка2              КАК Справка2,
	|	СоответствиеНоменклатурыЕГАИС.ИдентификаторУпаковки КАК ИдентификаторУпаковки
	|ИЗ
	|	СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|;
	|
	|/////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 2
	|	СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура         КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика       КАК Характеристика
	|ИЗ
	|	СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|");
	
	Запрос.УстановитьПараметр("КодАлкогольнойПродукции", КодАлкогольнойПродукции);
	Запрос.УстановитьПараметр("ПустаяНоменклатура",      ПустаяНоменклатура);
	Запрос.УстановитьПараметр("ПустаяХарактеристика",    ПустаяХарактеристика);
	Запрос.УстановитьПараметр("ПустаяСерия",             ПустаяСерия);
	Запрос.УстановитьПараметр("ПустаяСправка2",          ПустаяСправка2);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаВсеСопоставление   = РезультатЗапроса[1].Выбрать();
	ВыборкаТолькоНоменклатура = РезультатЗапроса[2].Выбрать();
	
	Если ВыборкаВсеСопоставление.Количество() = 1 Тогда
		
		ВыборкаВсеСопоставление.Следующий();
		
		ДанныеШтрихкода.КодАлкогольнойПродукции = КодАлкогольнойПродукции;
		ДанныеШтрихкода.АлкогольнаяПродукция    = ВыборкаВсеСопоставление.АлкогольнаяПродукция;
		ДанныеШтрихкода.Номенклатура            = ВыборкаВсеСопоставление.Номенклатура;
		ДанныеШтрихкода.Характеристика          = ВыборкаВсеСопоставление.Характеристика;
		ДанныеШтрихкода.Серия                   = ВыборкаВсеСопоставление.Серия;
		ДанныеШтрихкода.Справка2                = ВыборкаВсеСопоставление.Справка2;
		
	ИначеЕсли ВыборкаТолькоНоменклатура.Количество() = 1 Тогда
		
		ВыборкаТолькоНоменклатура.Следующий();
		
		ДанныеШтрихкода.КодАлкогольнойПродукции = КодАлкогольнойПродукции;
		ДанныеШтрихкода.АлкогольнаяПродукция    = ВыборкаТолькоНоменклатура.АлкогольнаяПродукция;
		ДанныеШтрихкода.Номенклатура            = ВыборкаТолькоНоменклатура.Номенклатура;
		ДанныеШтрихкода.Характеристика          = ВыборкаТолькоНоменклатура.Характеристика;
		ДанныеШтрихкода.Серия                   = ПустаяСерия;
		ДанныеШтрихкода.Справка2                = ПустаяСправка2;
		
	Иначе
		
		ДанныеШтрихкода.КодАлкогольнойПродукции = КодАлкогольнойПродукции;
		ДанныеШтрихкода.АлкогольнаяПродукция    = ПустаяАлкогольнаяПродукция;
		ДанныеШтрихкода.Номенклатура            = ПустаяНоменклатура;
		ДанныеШтрихкода.Характеристика          = ПустаяХарактеристика;
		ДанныеШтрихкода.Серия                   = ПустаяСерия;
		ДанныеШтрихкода.Справка2                = ПустаяСправка2;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет штрихкод акцизной марки
//
// Параметры:
//  Штрихкод - Строка - проверяемый штрихкод.
//  ТипШтрихКода - Перечисление.ТипыШтрихКодов - тип штрихкода акцизной марки (PDF417 или DataMatrix) (возвращаемое значение)
// 
// Возвращаемое значение:
//   Булево - признак штрихкод является акцизной маркой.
Функция ЭтоШтрихкодАкцизнойМарки(Штрихкод, ТипШтрихкода = Неопределено) Экспорт
	
	ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ЧекККМ;
	ТипШтрихкодМарки = ФабрикаXDTO.Тип(
		Перечисления.ВидыДокументовЕГАИС.ПространствоИмен(
			ВидДокумента, Перечисления.ФорматыОбменаЕГАИС.ПустаяСсылка()), "BK");
	
	Попытка
		ТипШтрихкодМарки.Проверить(Штрихкод);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Если СтрДлина(Штрихкод) = 150 Тогда
		ТипШтрихкода = Перечисления.ТипыШтрихкодов.DataMatrix;
	Иначе 
		ТипШтрихкода = Перечисления.ТипыШтрихкодов.PDF417;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(РезультатВыбора, РезультатОбработкиШтрихкода) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеШтрихкода = ПолучитьИзВременногоХранилища(РезультатОбработкиШтрихкода.АдресДанныхШтрихкода);
	
	Если Не ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
		ДанныеШтрихкода.АлкогольнаяПродукция    = РезультатВыбора.АлкогольнаяПродукция;
		ДанныеШтрихкода.КодАлкогольнойПродукции = РезультатВыбора.КодАлкогольнойПродукции;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура) Тогда
		
		ДанныеШтрихкода.Номенклатура   = РезультатВыбора.Номенклатура;
		ДанныеШтрихкода.Характеристика = РезультатВыбора.Характеристика;
		ДанныеШтрихкода.Серия          = РезультатВыбора.Серия;
		
		Если ДанныеШтрихкода.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			
			Если ЗначениеЗаполнено(ДанныеШтрихкода.ШтрихкодУпаковки) Тогда
				ШтрихкодУпаковкиОбъект = ДанныеШтрихкода.ШтрихкодУпаковки.ПолучитьОбъект();
				ШтрихкодУпаковкиОбъект.Номенклатура   = РезультатВыбора.Номенклатура;
				ШтрихкодУпаковкиОбъект.Характеристика = РезультатВыбора.Характеристика;
				ШтрихкодУпаковкиОбъект.Серия          = РезультатВыбора.Серия;
				ШтрихкодУпаковкиОбъект.Записать();
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция) Тогда
				СоответствиеНоменклатурыЕГАИС = РегистрыСведений.СоответствиеНоменклатурыЕГАИС.СоздатьМенеджерЗаписи();
				СоответствиеНоменклатурыЕГАИС.АлкогольнаяПродукция = ДанныеШтрихкода.АлкогольнаяПродукция;
				СоответствиеНоменклатурыЕГАИС.Номенклатура         = ДанныеШтрихкода.Номенклатура;
				СоответствиеНоменклатурыЕГАИС.Характеристика       = ДанныеШтрихкода.Характеристика;
				СоответствиеНоменклатурыЕГАИС.Серия                = ДанныеШтрихкода.Серия;
				СоответствиеНоменклатурыЕГАИС.Справка2             = ДанныеШтрихкода.Справка2;
				СоответствиеНоменклатурыЕГАИС.Записать();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ДанныеМаркированногоТовара Из ДанныеШтрихкода.МаркированныеТовары Цикл
		
		Если Не ЗначениеЗаполнено(ДанныеМаркированногоТовара.Номенклатура) Тогда
			ДанныеМаркированногоТовара.Номенклатура   = РезультатВыбора.Номенклатура;
			ДанныеМаркированногоТовара.Характеристика = РезультатВыбора.Характеристика;
			ДанныеМаркированногоТовара.Серия          = РезультатВыбора.Серия;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеМаркированногоТовара.АлкогольнаяПродукция) Тогда
			ДанныеМаркированногоТовара.АлкогольнаяПродукция    = РезультатВыбора.АлкогольнаяПродукция;
			ДанныеМаркированногоТовара.КодАлкогольнойПродукции = РезультатВыбора.КодАлкогольнойПродукции;
		КонецЕсли;
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(ДанныеШтрихкода, РезультатОбработкиШтрихкода.АдресДанныхШтрихкода);
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

Функция ОбработатьДанныеШтрихкодаПослеВыбораСправки2(РезультатВыбора, РезультатОбработкиШтрихкода) Экспорт
	
	ДанныеШтрихкода = ПолучитьИзВременногоХранилища(РезультатОбработкиШтрихкода.АдресДанныхШтрихкода);
	
	ЗаполнитьДанныеШтрихкодаПоСправке2(ДанныеШтрихкода, РезультатВыбора);
	
	ПоместитьВоВременноеХранилище(ДанныеШтрихкода, РезультатОбработкиШтрихкода.АдресДанныхШтрихкода);
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

Функция ПолучитьДанныеПоШтрихкодам(СписокШтрихкодов, ПараметрыСканированияАкцизныхМарок, КэшированныеЗначения, УникальныйИдентификатор) Экспорт
	
	ДанныеПоШтрихкодам = АкцизныеМаркиЕГАИС.ПолучитьДанныеПоШтрихкодам(СписокШтрихкодов, ПараметрыСканированияАкцизныхМарок, КэшированныеЗначения);
	
	Если ДанныеПоШтрихкодам.ЕстьОшибкиВДеревеУпаковок Тогда
		АдресДереваУпаковок = ПоместитьВоВременноеХранилище(ДанныеПоШтрихкодам.ВложенныеШтрихкоды.ДеревоУпаковок, УникальныйИдентификатор);
	Иначе
		АдресДереваУпаковок = Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ОбработанныеШтрихкоды",         ДанныеПоШтрихкодам.ОбработанныеШтрихкоды);
	ВозвращаемоеЗначение.Вставить("НеобработанныеШтрихкоды",       ДанныеПоШтрихкодам.НеобработанныеШтрихкоды);
	ВозвращаемоеЗначение.Вставить("РезультатыОбработкиШтрихкодов", Новый Соответствие);
	
	Для Каждого КлючЗначение Из ДанныеПоШтрихкодам.ОбработанныеШтрихкоды Цикл
		
		ДанныеШтрихкода = КлючЗначение.Значение;
		
		РезультатОбработки = АкцизныеМаркиЕГАИС.РезультатОбработкиШтрихкода(ДанныеШтрихкода);
		РезультатОбработки.АдресДереваУпаковок       = АдресДереваУпаковок;
		РезультатОбработки.ЕстьОшибкиВДеревеУпаковок = ДанныеПоШтрихкодам.ЕстьОшибкиВДеревеУпаковок;
		РезультатОбработки.АдресДанныхШтрихкода      = ПоместитьВоВременноеХранилище(ДанныеШтрихкода, УникальныйИдентификатор);
		РезультатОбработки.ТекстОшибки               = ДанныеШтрихкода.ТекстОшибки;
		
		Если ДанныеШтрихкода.ТипШтрихкода = Перечисления.ТипыШтрихкодов.DataMatrix
			И ДанныеШтрихкода.Справки2.Количество() > 0
			И Не ЗначениеЗаполнено(ДанныеШтрихкода.Справка2) Тогда
			
			РезультатОбработки.ТребуетсяВыборСправки2 = Истина;
			
			Для Каждого ДанныеСправки2 Из ДанныеШтрихкода.Справки2 Цикл
				РезультатОбработки.Справки2.Добавить(ДанныеСправки2.Справка2);
			КонецЦикла;
			
		ИначеЕсли Не ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура)
			И ПараметрыСканированияАкцизныхМарок.ЗапрашиватьНоменклатуру
			И (ДанныеШтрихкода.ТипШтрихкода = Перечисления.ТипыШтрихкодов.DataMatrix
				Или ДанныеШтрихкода.ТипШтрихкода = Перечисления.ТипыШтрихкодов.PDF417) Тогда
			
				Если ДанныеШтрихкода.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар
					И ПараметрыСканированияАкцизныхМарок.Номенклатура <> Неопределено Тогда
					
					ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(ПараметрыСканированияАкцизныхМарок,РезультатОбработки);
					
				Иначе
					
					РезультатОбработки.ТребуетсяВыборНоменклатуры = Истина;
					РезультатОбработки.ПараметрыВыбораНоменклатуры.Вставить("АлкогольнаяПродукция",    ДанныеШтрихкода.АлкогольнаяПродукция);
					РезультатОбработки.ПараметрыВыбораНоменклатуры.Вставить("КодАлкогольнойПродукции", ДанныеШтрихкода.КодАлкогольнойПродукции);
					РезультатОбработки.ПараметрыВыбораНоменклатуры.Вставить("АкцизнаяМарка",           ДанныеШтрихкода.ШтрихкодУпаковки);
					РезультатОбработки.ПараметрыВыбораНоменклатуры.Вставить("ТипШтрихкода",            ДанныеШтрихкода.ТипШтрихкода);
					
				КонецЕсли;
			
			
		КонецЕсли;
		
		ВозвращаемоеЗначение.РезультатыОбработкиШтрихкодов.Вставить(КлючЗначение.Ключ, РезультатОбработки);
		
	КонецЦикла;
	
	Для Каждого КлючЗначение Из ДанныеПоШтрихкодам.НеобработанныеШтрихкоды Цикл
		
		ДанныеШтрихкода = КлючЗначение.Значение;
		
		РезультатОбработки = АкцизныеМаркиЕГАИС.РезультатОбработкиШтрихкода(ДанныеШтрихкода);
		РезультатОбработки.АдресДанныхШтрихкода = ПоместитьВоВременноеХранилище(ДанныеШтрихкода, УникальныйИдентификатор);
		
		ВозвращаемоеЗначение.РезультатыОбработкиШтрихкодов.Вставить(КлючЗначение.Ключ, РезультатОбработки);
		
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Получает тип акцизной марки из классификатора.
//
Функция ТипАкцизнойМарки(Код) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Код"         , "");
	Результат.Вставить("Наименование", "");
	Результат.Вставить("ВидМарки"    , "");
	
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	СтрокаТаблицы = ТаблицаКлассификатора.Найти(Код, "Код");
	Если СтрокаТаблицы <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, СтрокаТаблицы);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает список найденных типов марок по введенному коду.
//
Функция ДанныеВыбораТипаМарки(Код) Экспорт
	
	Результат = Новый СписокЗначений;
	
	ТаблицаКлассификатора = АкцизныеМаркиЕГАИС.КлассификаторТиповАкцизныхМарок();
	
	Для Каждого СтрокаТаблицы Из ТаблицаКлассификатора Цикл
		
		Если СтрНайти(СтрокаТаблицы.Код, СокрЛП(Код)) <> 0 Тогда
			Результат.Добавить(СтрокаТаблицы.Код, СтрокаТаблицы.ВидМарки + " " + СтрокаТаблицы.Наименование + " (" + СтрокаТаблицы.Код + ")");
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьДанныеШтрихкодаПоСправке2(ДанныеШтрихкода, Справка2) Экспорт
	
	ДанныеШтрихкода.Справка2 = Справка2;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Справки2ЕГАИС.АлкогольнаяПродукция           КАК АлкогольнаяПродукция,
	|	Справки2ЕГАИС.АлкогольнаяПродукция.Код       КАК КодАлкогольнойПродукции,
	|	Справки2ЕГАИС.ДокументОснование              КАК ДокументОснование,
	|	СоответствиеНоменклатурыЕГАИС.Номенклатура   КАК Номенклатура,
	|	СоответствиеНоменклатурыЕГАИС.Характеристика КАК Характеристика,
	|	СоответствиеНоменклатурыЕГАИС.Серия          КАК Серия
	|ПОМЕСТИТЬ ВтДанные
	|ИЗ
	|	Справочник.Справки2ЕГАИС КАК Справки2ЕГАИС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыЕГАИС КАК СоответствиеНоменклатурыЕГАИС
	|		ПО СоответствиеНоменклатурыЕГАИС.Справка2 = Справки2ЕГАИС.Ссылка
	|ГДЕ
	|	Справки2ЕГАИС.Ссылка = &Справка2
	|
	|;
	|ВЫБРАТЬ
	|	1                               КАК Приоритет,
	|	Товары.Справка2                 КАК Справка2,
	|	Товары.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция.Код КАК КодАлкогольнойПродукции,
	|	Товары.Номенклатура             КАК Номенклатура,
	|	Товары.Характеристика           КАК Характеристика,
	|	Товары.Серия                    КАК Серия
	|ПОМЕСТИТЬ ВтСопоставлениеНоменклатуры
	|ИЗ
	|	Документ.ТТНВходящаяЕГАИС.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтДанные КАК ВтДанные
	|		ПО ВтДанные.ДокументОснование = Товары.Ссылка
	|ГДЕ
	|	Товары.Справка2 = &Справка2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1                               КАК Приоритет,
	|	Товары.Справка2                 КАК Справка2,
	|	Товары.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	Товары.АлкогольнаяПродукция.Код КАК КодАлкогольнойПродукции,
	|	Товары.Номенклатура             КАК Номенклатура,
	|	Товары.Характеристика           КАК Характеристика,
	|	Товары.Серия                    КАК Серия
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтДанные КАК ВтДанные
	|		ПО ВтДанные.ДокументОснование = Товары.Ссылка
	|ГДЕ
	|	Товары.Справка2 = &Справка2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2                                КАК Приоритет,
	|	ВтДанные.АлкогольнаяПродукция    КАК АлкогольнаяПродукция,
	|	ВтДанные.КодАлкогольнойПродукции КАК КодАлкогольнойПродукции,
	|	ВтДанные.ДокументОснование       КАК ДокументОснование,
	|	ВтДанные.Номенклатура            КАК Номенклатура,
	|	ВтДанные.Характеристика          КАК Характеристика,
	|	ВтДанные.Серия                   КАК Серия
	|ИЗ
	|	ВтДанные КАК ВтДанные
	|
	|;
	|ВЫБРАТЬ
	|	ВтСопоставлениеНоменклатуры.Приоритет               КАК Приоритет,
	|	ВтСопоставлениеНоменклатуры.АлкогольнаяПродукция    КАК АлкогольнаяПродукция,
	|	ВтСопоставлениеНоменклатуры.КодАлкогольнойПродукции КАК КодАлкогольнойПродукции,
	|	ВтСопоставлениеНоменклатуры.Номенклатура            КАК Номенклатура,
	|	ВтСопоставлениеНоменклатуры.Характеристика          КАК Характеристика,
	|	ВтСопоставлениеНоменклатуры.Серия                   КАК Серия
	|ИЗ
	|	ВтСопоставлениеНоменклатуры
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет ВОЗР
	|");
	
	Запрос.УстановитьПараметр("Справка2", Справка2);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		
		ДанныеШтрихкода.АлкогольнаяПродукция    = Выборка.АлкогольнаяПродукция;
		ДанныеШтрихкода.КодАлкогольнойПродукции = Выборка.КодАлкогольнойПродукции;
		
		Если Выборка.Количество() = 1
			Или Выборка.Приоритет = 1 Тогда
			ДанныеШтрихкода.Номенклатура   = Выборка.Номенклатура;
			ДанныеШтрихкода.Характеристика = Выборка.Характеристика;
			ДанныеШтрихкода.Серия          = Выборка.Серия;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//#КонецОбласти