﻿#Если Клиент Тогда
Перем НП Экспорт;
	
Процедура ВывестиИтоговыеСтроки(ДокументРезультат, Макет, ВыборкаИсточник, ИтогоСуммаСписания, ИтогоНеСписаннаяСумма)
	
	НачалоПериода = НачалоДня(ДатаНач);
	КонецПериода = БухгалтерскийУчет.КонецПериодаОтчета(ДатаКон);
	
	ОбластьНаНачало		 = Макет.ПолучитьОбласть("НаНачало");
	ОбластьСтрока        = Макет.ПолучитьОбласть("Строка");

	ВыборкаСтрок = ВыборкаИсточник.Выбрать();
	Пока ВыборкаСтрок.Следующий() Цикл
		Если ВыборкаСтрок.Период = НачалоПериода И ВыборкаСтрок.Списано = 0  Тогда
			ОбластьНаНачало.Параметры.СуммаНаНачалоПериода = ВыборкаСтрок.Остаток;
			ДокументРезультат.Вывести(ОбластьНаНачало);
		ИначеЕсли ВыборкаСтрок.Период = КонецПериода И ВыборкаСтрок.Списано = 0 Тогда
			ИтогоНеСписаннаяСумма = ИтогоНеСписаннаяСумма + ВыборкаСтрок.Остаток;
		ИначеЕсли ВыборкаСтрок.Списано <= 0 Тогда
			Продолжить
		Иначе
			ОбластьСтрока.Параметры.ДатаОперации = ВыборкаСтрок.Период;
			ОбластьСтрока.Параметры.Док = ВыборкаСтрок.Регистратор;
			
			Начало = ВыборкаСтрок.ДатаНачалаСписания;
			Окончание = ВыборкаСтрок.Период;
			Если (ЗначениеЗаполнено(Начало)) 
				и (ЗначениеЗаполнено(Окончание))
				и (Начало <= Окончание) Тогда
				
				КоличествоМесяцев = (Год(Окончание) - Год(Начало)) * 12;
				КоличествоМесяцев = КоличествоМесяцев + Месяц(Окончание) - Месяц(Начало);
				Если День(Начало) - День(Окончание) <= 1 Тогда
					КоличествоМесяцев = КоличествоМесяцев + 1;
				КонецЕсли;
			Иначе
				КоличествоМесяцев = "";
			КонецЕсли;
			ОбластьСтрока.Параметры.КолвоМесяцевФактическогоСписания = КоличествоМесяцев;
			ОбластьСтрока.Параметры.СуммаСписания = ВыборкаСтрок.Списано;
			ОбластьСтрока.Параметры.НеСписаннаяСумма = ВыборкаСтрок.Остаток;
			ДокументРезультат.Вывести(ОбластьСтрока);
			ИтогоСуммаСписания = ИтогоСуммаСписания + ВыборкаСтрок.Списано;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
	
	
// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//	ДокументРезультат - табличный документ, формируемый отчетом
//	ПоказыватьЗаголовок - признак видимости строк с заголовком отчета
//	ВысотаЗаголовка - параметр, через который возвращается высота заголовка в строках 
//
Процедура СформироватьОтчет(ДокументРезультат, ПоказыватьЗаголовок, ВысотаЗаголовка, ТолькоЗаголовок = Ложь) Экспорт

	НачалоПериода = НачалоДня(ДатаНач);
	КонецПериода = БухгалтерскийУчет.КонецПериодаОтчета(ДатаКон);
	
	ДокументРезультат.Очистить();

	Макет = ПолучитьМакет("Отчет");

	ОбластьЗаголовок  = Макет.ПолучитьОбласть("Заголовок");
	
	Отбор = "";  ПоВсем = Истина;
	СписокВидовРБП = Новый СписокЗначений();
	Для каждого ЭлементСписка из ВидыРасходов Цикл
		Если ЭлементСписка.Пометка Тогда
			СписокВидовРБП.Добавить(ЭлементСписка.Значение); 
			Отбор = Отбор + ЭлементСписка.Значение + "; ";
		Иначе 
			ПоВсем = Ложь;
		КонецЕсли;
	КонецЦикла;
	Отбор = ?(ПоВсем, "По всем", Отбор);

	ОбластьЗаголовок.Параметры.НачалоПериода       = Формат(НачалоПериода, "ДФ=dd.MM.yyyy");
	ОбластьЗаголовок.Параметры.КонецПериода        = Формат(КонецПериода, "ДФ=dd.MM.yyyy");
	ОбластьЗаголовок.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
	ОбластьЗаголовок.Параметры.ИННОрганизации      = "" + Организация.ИНН + " / " + Организация.КПП;
	ОбластьЗаголовок.Параметры.ОтборВидовРБП       = Отбор;
	ДокументРезультат.Вывести(ОбластьЗаголовок);

	// Параметр для показа заголовка
	ВысотаЗаголовка = ДокументРезультат.ВысотаТаблицы;

	// Когда нужен только заголовок:
	Если ТолькоЗаголовок Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(ВысотаЗаголовка) Тогда
		ДокументРезультат.Область("R1:R" + ВысотаЗаголовка).Видимость = ПоказыватьЗаголовок;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНач", НачалоПериода);
	Запрос.УстановитьПараметр("ДатаКон", КонецПериода);
	Запрос.УстановитьПараметр("Счет",		  ПланыСчетов.Налоговый.РасходыБудущихПериодов);
	Запрос.УстановитьПараметр("СчетИсключение", ПланыСчетов.Налоговый.РасходыНаОплатуТрудаБудущихПериодов);
	Запрос.УстановитьПараметр("Организация",  Организация);
	Запрос.УстановитьПараметр("ВидУчета",     Перечисления.ВидыУчетаПоПБУ18.НУ);
	Запрос.УстановитьПараметр("ВидыРБП",     СписокВидовРБП);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НалоговыйОстаткиИОбороты.Субконто1 КАК Субконто1,
	|	НалоговыйОстаткиИОбороты.Период КАК Период,
	|	СУММА(НалоговыйОстаткиИОбороты.СуммаОборотКт) КАК Списано,
	|	СУММА(НалоговыйОстаткиИОбороты.СуммаКонечныйОстатокДт) КАК Остаток,
	|	НалоговыйОстаткиИОбороты.Регистратор,
	|	НалоговыйОстаткиИОбороты.Субконто1.ВидРБП КАК ВидРБП,
	|	НалоговыйОстаткиИОбороты.Субконто1.Наименование КАК Наименование,
	|	НалоговыйОстаткиИОбороты.Субконто1.ДатаНачалаСписания КАК ДатаНачалаСписания,
	|	НалоговыйОстаткиИОбороты.Субконто1.ДатаОкончанияСписания КАК ДатаОкончанияСписания,
	|	НалоговыйОстаткиИОбороты.Субконто1.Сумма КАК Сумма,
	|	ЕСТЬNULL(НалоговыйОстаткиИОбороты.Субконто2, 0) КАК Субконто2,
	|	ЕСТЬNULL(НалоговыйОстаткиИОбороты.Субконто3, 0) КАК Субконто3
	|ИЗ
	|	РегистрБухгалтерии.Налоговый.ОстаткиИОбороты(
	|			&ДатаНач,
	|			&ДатаКон,
	|			Регистратор,
	|			ДвиженияИГраницыПериода,
	|			Счет В ИЕРАРХИИ (&Счет) И Не Счет = &СчетИсключение,
	|			,
	|			Организация = &Организация
	|				И ВидУчета = &ВидУчета
	|				И Субконто1.ВидРБП В (&ВидыРБП)) КАК НалоговыйОстаткиИОбороты
	|
	|СГРУППИРОВАТЬ ПО
	|	НалоговыйОстаткиИОбороты.Субконто1,
	|	НалоговыйОстаткиИОбороты.Субконто2,
	|	НалоговыйОстаткиИОбороты.Субконто3,
	|	НалоговыйОстаткиИОбороты.Период,
	|	НалоговыйОстаткиИОбороты.Регистратор,
	|	НалоговыйОстаткиИОбороты.Субконто1.ВидРБП,
	|	НалоговыйОстаткиИОбороты.Субконто1.Наименование,
	|	НалоговыйОстаткиИОбороты.Субконто1.ДатаНачалаСписания,
	|	НалоговыйОстаткиИОбороты.Субконто1.ДатаОкончанияСписания,
	|	НалоговыйОстаткиИОбороты.Субконто1.Сумма
	|
	|УПОРЯДОЧИТЬ ПО
	|	Субконто1,
	|	Субконто2,
	|	Субконто3,
	|	Период
	|ИТОГИ ПО
	|	Субконто1,
	|	Субконто2,
	|	Субконто3";
	
	Результат = Запрос.Выполнить();
	
	ОбластьШапкаТаблицы  = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьЗаголовокРБП  = Макет.ПолучитьОбласть("ЗаголовокРБП");
	ОбластьГруппа		 = Макет.ПолучитьОбласть("Группа");
	ОбластьНаНачало		 = Макет.ПолучитьОбласть("НаНачало");
	ОбластьСтрока        = Макет.ПолучитьОбласть("Строка");
	ОбластьИтого         = Макет.ПолучитьОбласть("Итого");
	ОбластьВсего         = Макет.ПолучитьОбласть("Всего");
	ОбластьПодвал        = Макет.ПолучитьОбласть("Подвал");
    ДокументРезультат.Вывести(ОбластьШапкаТаблицы);
	
		ВсегоСуммаСписания = 0;
		ВсегоНеСписаннаяСумма = 0;
	
	ВыборкаРБП = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаРБП.Следующий() Цикл
		
		ИтогоСуммаСписания = 0;
		ИтогоНеСписаннаяСумма = 0;
		
		ОбластьЗаголовокРБП.Параметры.Статья = ВыборкаРБП.Наименование;
		ОбластьЗаголовокРБП.Параметры.РБП = ВыборкаРБП.Субконто1;
		ОбластьЗаголовокРБП.Параметры.ОбщаяСуммаРасходов = Формат(ВыборкаРБП.Сумма, "ЧДЦ=2");
		ОбластьЗаголовокРБП.Параметры.ВидРасхода = ВыборкаРБП.ВидРБП;
		ОбластьЗаголовокРБП.Параметры.СрокВключенияРасходов = Формат(ВыборкаРБП.ДатаОкончанияСписания, "ДФ=dd.MM.yyyy");
		ОбластьЗаголовокРБП.Параметры.ДатаНачалаУчета = Формат(ВыборкаРБП.ДатаНачалаСписания, "ДФ=dd.MM.yyyy");
		ДокументРезультат.Вывести(ОбластьЗаголовокРБП);
		
		ВыборкаРаботников = ВыборкаРБП.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Субконто2");
		Пока ВыборкаРаботников.Следующий() Цикл
			Отступ = "    ";
			Если ЗначениеЗаполнено(ВыборкаРаботников.Субконто2) Тогда
				ОбластьГруппа.Параметры.Группировка = Отступ + ВыборкаРаботников.Субконто2;
				ОбластьГруппа.Параметры.СуммаСписания = ВыборкаРаботников.Списано;
				ОбластьГруппа.Параметры.НеСписаннаяСумма = ВыборкаРаботников.Остаток;
				ДокументРезультат.Вывести(ОбластьГруппа);
				Отступ = Отступ + "    ";
			КонецЕсли;
			ВыборкаНачислений = ВыборкаРаботников.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Субконто3");
			Пока ВыборкаНачислений.Следующий() Цикл
				Если ЗначениеЗаполнено(ВыборкаНачислений.Субконто3) Тогда
					ОбластьГруппа.Параметры.Группировка = Отступ + ВыборкаНачислений.Субконто3;
					ОбластьГруппа.Параметры.СуммаСписания = ВыборкаНачислений.Списано;
					ОбластьГруппа.Параметры.НеСписаннаяСумма = ВыборкаНачислений.Остаток;
					ДокументРезультат.Вывести(ОбластьГруппа);
				КонецЕсли;
				ВывестиИтоговыеСтроки(ДокументРезультат, Макет, ВыборкаНачислений, ИтогоСуммаСписания, ИтогоНеСписаннаяСумма);
			КонецЦикла;
		КонецЦикла;
		
		ОбластьИтого.Параметры.ИтогоСуммаСписания = ИтогоСуммаСписания;
		ОбластьИтого.Параметры.НеСписаннаяСумма = ИтогоНеСписаннаяСумма;
		ДокументРезультат.Вывести(ОбластьИтого);
		
		ВсегоСуммаСписания = ВсегоСуммаСписания + ИтогоСуммаСписания;
		ВсегоНеСписаннаяСумма = ВсегоНеСписаннаяСумма + ИтогоНеСписаннаяСумма;
	КонецЦикла;
	
		ОбластьВсего.Параметры.ИтогоСуммаСписания = ВсегоСуммаСписания;
		ОбластьВсего.Параметры.НеСписаннаяСумма = ВсегоНеСписаннаяСумма;
		ДокументРезультат.Вывести(ОбластьВсего);

	СтруктураЛиц = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизаций(Организация, ДатаКон);
	ОбластьПодвал.Параметры.ОтветственныйЗаРегистры = СтруктураЛиц.ОтветственныйЗаРегистры;
	ДокументРезультат.Вывести(ОбластьПодвал);
	
КонецПроцедуры // СформироватьОтчет

////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ
// 

НП           = Новый НастройкаПериода;

#КонецЕсли
