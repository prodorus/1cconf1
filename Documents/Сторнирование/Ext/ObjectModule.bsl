﻿/////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Копирует значения движения в строку сторно нового движения
// для измерений и реквизитов. Ресурсы инвертируются
//
Процедура ЗаполнитьДвижениеСторно(Движение, Строка, МетаданныеОбъект)

	// измерения
	Для Каждого МДОбъект из МетаданныеОбъект.Измерения Цикл
		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
	КонецЦикла;

	// ресурсы
	Для Каждого МДОбъект из МетаданныеОбъект.Ресурсы Цикл
		Движение[МДОбъект.Имя] = - Строка[МДОбъект.Имя];
	КонецЦикла;

	// реквизиты
	Для Каждого МДОбъект из МетаданныеОбъект.Реквизиты Цикл
		Движение[МДОбъект.Имя] = Строка[МДОбъект.Имя];
	КонецЦикла;

КонецПроцедуры // ЗаполнитьДвижениеСторно

// Заполняет набор записей по указанному регистру сторнирующими движениями
//
Процедура ЗаполнитьНаборЗаписей(ЗаполняемыйНаборЗаписей, МетаданныеРегистр) Экспорт

	ЭтоРегистрРасчета     = Ложь;
	ЭтоРегистрБухгалтерии = Ложь;
	ЭтоРегистрНакопления  = Ложь;
	ЕстьРеквизитСторнируемыйДокумент = Ложь;

	Если ОбщегоНазначенияЗК.ПринадлежностьКлассуМетаданных("РегистрыРасчета", МетаданныеРегистр) Тогда
		ЭтоРегистрРасчета     = Истина;
		НаборЗаписей          = РегистрыРасчета[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
		ЕстьРеквизитСторнируемыйДокумент = МетаданныеРегистр.Имя = "ОсновныеНачисленияРаботниковОрганизаций" или МетаданныеРегистр.Имя = "ДополнительныеНачисленияРаботниковОрганизаций"	
	ИначеЕсли ОбщегоНазначенияЗК.ПринадлежностьКлассуМетаданных("РегистрыНакопления", МетаданныеРегистр) Тогда
		ЭтоРегистрНакопления  = Истина;
		НаборЗаписей          = РегистрыНакопления[МетаданныеРегистр.Имя].СоздатьНаборЗаписей();
	КонецЕсли;

	НаборЗаписей.Отбор.Регистратор.Значение = СторнируемыйДокумент;
	НаборЗаписей.Прочитать();
	
	// для регистров накопления
	ПериодРегистрацииДляРегистровНакопления = ?(Дата > КонецМесяца(ПериодРегистрации), КонецМесяца(ПериодРегистрации),?(Дата < ПериодРегистрации, ПериодРегистрации, Дата));

	Для Каждого ДвижениеСторнируемое Из НаборЗаписей Цикл

		// реквизиты
		Если ЭтоРегистрРасчета Тогда

			ДвижениеСторно = ЗаполняемыйНаборЗаписей.Добавить();

			ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);

			ДвижениеСторно.ПериодРегистрации = ПериодРегистрации;
			ДвижениеСторно.ВидРасчета        = ДвижениеСторнируемое.ВидРасчета;
			ДвижениеСторно.Сторно            = НЕ ДвижениеСторнируемое.Сторно;
			Если ЕстьРеквизитСторнируемыйДокумент Тогда
				ДвижениеСторно.СторнируемыйДокумент = ДвижениеСторнируемое.Регистратор;
			КонецЕсли;
                               
			Если МетаданныеРегистр.ПериодДействия Тогда
				ДвижениеСторно.ПериодДействияНачало = ДвижениеСторнируемое.ПериодДействияНачало;
				ДвижениеСторно.ПериодДействияКонец  = ДвижениеСторнируемое.ПериодДействияКонец;
			КонецЕсли;

			Если МетаданныеРегистр.БазовыйПериод Тогда
				ДвижениеСторно.БазовыйПериодНачало = ДвижениеСторнируемое.БазовыйПериодНачало;
				ДвижениеСторно.БазовыйПериодКонец  = ДвижениеСторнируемое.БазовыйПериодКонец;
			КонецЕсли;

		ИначеЕсли ЭтоРегистрНакопления Тогда

			ДвижениеСторно = ЗаполняемыйНаборЗаписей.Добавить();

			ЗаполнитьДвижениеСторно(ДвижениеСторно, ДвижениеСторнируемое, МетаданныеРегистр);
			
			Если МетаданныеРегистр.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
				ДвижениеСторно.ВидДвижения = ДвижениеСторнируемое.ВидДвижения
			КонецЕсли;
			
			Если МетаданныеРегистр.Имя = "НДФЛСведенияОДоходах" Тогда
				ДвижениеСторно.Период = ДвижениеСторнируемое.Период;
				ДвижениеСторно.ПериодРегистрации = ПериодРегистрации;
			ИначеЕсли МетаданныеРегистр.Имя = "ВнутрисменноеВремяРаботниковОрганизаций"   Тогда
				ДвижениеСторно.Период = ДвижениеСторнируемое.Период;
			Иначе
				ДвижениеСторно.Период = ПериодРегистрацииДляРегистровНакопления;
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры // ЗаполнитьНаборЗаписей()

Процедура ИзменитьПериодРегистрацииЗаписей(ЗаполняемыйНаборЗаписей, МетаданныеРегистр) Экспорт
	
	Если ОбщегоНазначенияЗК.ПринадлежностьКлассуМетаданных("РегистрыРасчета", МетаданныеРегистр) ИЛИ МетаданныеРегистр.Имя = "НДФЛСведенияОДоходах" Тогда
    	Для Каждого Движение Из ЗаполняемыйНаборЗаписей Цикл
            Движение.ПериодРегистрации = ПериодРегистрации;
		КонецЦикла;
	ИначеЕсли ОбщегоНазначенияЗК.ПринадлежностьКлассуМетаданных("РегистрыНакопления", МетаданныеРегистр) Тогда
		НовыйПериодРегистрации = ?(Дата > КонецМесяца(ПериодРегистрации), КонецМесяца(ПериодРегистрации),?(Дата < ПериодРегистрации, ПериодРегистрации, Дата));
		Для Каждого Движение Из ЗаполняемыйНаборЗаписей Цикл
            Движение.Период = НовыйПериодРегистрации;
		КонецЦикла;	
    КонецЕсли; 

КонецПроцедуры

Функция ЯвляетсяИсправлением(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументыИсправления.ПерерассчитываемыйДокумент КАК ОбъектПерерасчета
	|ИЗ
	|	Документ." + Ссылка.Метаданные().Имя + " КАК ДокументыИсправления
	|ГДЕ
	|	ДокументыИсправления.Ссылка = &Исправление";
	Запрос.УстановитьПараметр("Исправление", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат ЗначениеЗаполнено(Выборка.ОбъектПерерасчета);
	
КонецФункции // ЯвляетсяИсправлением()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СторнируемыйДокумент) Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СторнируемыйДокумент.Ссылка
		|ИЗ
		|	Документ." + СторнируемыйДокумент.Метаданные().Имя + " КАК СторнируемыйДокумент
		|ГДЕ
		|	СторнируемыйДокумент.Ссылка = &СторнируемыйДокумент
		|	И СторнируемыйДокумент.ПериодРегистрации < &ПериодРегистрации");
		Запрос.УстановитьПараметр("ПериодРегистрации",		ПериодРегистрации);
		Запрос.УстановитьПараметр("СторнируемыйДокумент",	СторнируемыйДокумент);
		Если Запрос.Выполнить().Пустой() Тогда
			#Если ТолстыйКлиентОбычноеПриложение Тогда
				Предупреждение("Сторнировать можно только документы прошлых периодов");
			#Иначе
				ОбщегоНазначенияЗК.СообщитьОбОшибке("Сторнировать можно только документы прошлых периодов");
			#КонецЕсли
			Отказ = Истина;
		ИначеЕсли ЯвляетсяИсправлением(СторнируемыйДокумент) Тогда
			#Если ТолстыйКлиентОбычноеПриложение Тогда
				Предупреждение("Сторнировать документы-исправления запрещено! Такие документы следует исправлять повторно.");
			#Иначе
				ОбщегоНазначенияЗК.СообщитьОбОшибке("Сторнировать документы-исправления документы запрещено! Такие документы следует исправлять повторно.");
			#КонецЕсли
			Отказ = Истина;
		ИначеЕсли ЗначениеЗаполнено(ПроведениеРасчетов.ПолучитьДокументИсправление(СторнируемыйДокумент)) Тогда
			#Если ТолстыйКлиентОбычноеПриложение Тогда
				Предупреждение("Сторнировать ранее исправленные документы запрещено! Такие документы следует исправлять повторно.");
			#Иначе
				ОбщегоНазначенияЗК.СообщитьОбОшибке("Сторнировать ранее исправленные документы запрещено! Такие документы следует исправлять повторно.");
			#КонецЕсли
			Отказ = Истина;
		Иначе
			ДругоеСторно = ПроведениеРасчетов.ПолучитьДокументСторнирование(СторнируемыйДокумент);
			Если ЗначениеЗаполнено(ДругоеСторно) и ДругоеСторно <> Ссылка Тогда
				#Если ТолстыйКлиентОбычноеПриложение Тогда
					Предупреждение("Дважды сторнировать документы запрещено!");
				#Иначе
					ОбщегоНазначенияЗК.СообщитьОбОшибке("Дважды сторнировать документы запрещено!");
				#КонецЕсли
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

