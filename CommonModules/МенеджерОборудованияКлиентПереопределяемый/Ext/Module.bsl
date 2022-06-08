﻿// Область ПрограммныйИнтерфейс

// Возвращает текущую дату, приведенную к часовому поясу сеанса.
// Предназначена для использования вместо функции ТекущаяДата().
//
// Возвращаемое значение:
//  Результат - текущая дата.
//
Функция ДатаСеанса() Экспорт
	
	Возврат ОбщегоНазначенияКлиент.ДатаСеанса();
	
КонецФункции

// Функция возвращает объект обработчика драйвера по его наименованию.
//
// Параметры:
//  ОбработчикДрайвера  - Перечисление, ссылка на обработчик драйвера подключаемого оборудования.
//  ЗагружаемыйДрайвер  - Булево, признак, что драйвер загружаемый
//  ТипОборудованияИмя  - Строка, представление типа оборудования.
//
// Возвращаемое значение:
//  Результат - Используемый модуль обработчика драйвера.
//
Функция ПолучитьОбработчикДрайвера(ОбработчикДрайвера, ЗагружаемыйДрайвер, ТипОборудованияИмя) Экспорт

//  Используем универсальный обработчик драйвера по стандарту "1С:Совместимо".
#Если ВебКлиент Тогда
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверАсинхронноКлиент; 
#Иначе
	Результат = ПодключаемоеОборудованиеУниверсальныйДрайверКлиент;
#КонецЕсли
	
	// Обработчики драйверов не удовлетворяющие стандарту "1С:Совместимо".
	Если Не ЗагружаемыйДрайвер И ОбработчикДрайвера <> Неопределено Тогда
		
		// Сканеры штрихкода
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудование1ССканерыШтрихкодаКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудованиеСканкодСканерыШтрихкодаКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода") Тогда
			Возврат ПодключаемоеОборудованиеАтолСканерыШтрихкодаКлиент;
		КонецЕсли;
		// Конец Сканеры штрихкода
		
		//++ НЕ ГОСИС
		// Считыватели магнитных карт
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССчитывателиМагнитныхКарт") Тогда
			Возврат ПодключаемоеОборудование1ССчитывателиМагнитныхКартКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСчитывателиМагнитныхКарт") Тогда
			Возврат ПодключаемоеОборудованиеАтолСчитывателиМагнитныхКартКлиент;
		КонецЕсли;
		// Конец Считыватели магнитных карт.

		// Фискальные регистраторы
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторы") Тогда
			Возврат ПодключаемоеОборудованиеАтолФискальныеРегистраторыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикВерсияТФискальныеРегистраторы") Тогда
			Возврат ПодключаемоеОборудованиеВерсияТФискальныеРегистраторыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСФискальныеРегистраторы") Тогда
			Возврат ПодключаемоеОборудованиеККСФискальныеРегистраторыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМФискальныеРегистраторы") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМФискальныеРегистраторыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикОРИОНФискальныеРегистраторы") Тогда
			Возврат ПодключаемоеОборудованиеОРИОНФискальныеРегистраторыКлиент;
		КонецЕсли;
		// Конец Фискальные регистраторы.
		
		// Дисплеи покупателя
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеАтолДисплеиПокупателяКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеСканкодДисплеиПокупателяКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМДисплеиПокупателяКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСДисплеиПокупателя") Тогда
			Возврат ПодключаемоеОборудованиеККСДисплеиПокупателяКлиент;
		КонецЕсли;
		// Конец Дисплеи покупателя
		
		// Терминалы сбора данных
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеАтолТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеСканкодТерминалыСбораДанныхКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалыСбораДанных") Тогда
			Возврат ПодключаемоеОборудованиеСканситиТерминалыСбораДанныхКлиент;
		КонецЕсли;
		// Конец Терминалы сбора данных.
		
		// Эквайринговые терминалы
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСБРФЭквайринговыеТерминалы") Тогда
			Возврат ПодключаемоеОборудованиеСБРФЭквайринговыеТерминалыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИНПАСЭквайринговыеТерминалыSmart") Тогда
			Возврат ПодключаемоеОборудованиеИНПАСЭквайринговыеТерминалыSmartКлиент;
		КонецЕсли;
		// Конец Эквайринговые терминалы.
		 
		// Электронные весы
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолЭлектронныеВесы") Тогда
			Возврат ПодключаемоеОборудованиеАтолЭлектронныеВесыКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМЭлектронныеВесы") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМЭлектронныеВесыКлиент;
		КонецЕсли;
		// Конец Электронные весы
		
		// Весы с печатью этикеток
		Если ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикACOMВесыСПечатьюЭтикеток") Тогда
			Возврат ПодключаемоеОборудованиеACOMВесыСПечатьюЭтикетокКлиент;
		ИначеЕсли ОбработчикДрайвера = ПредопределенноеЗначение("Перечисление.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМВесыСПечатьюЭтикеток") Тогда
			Возврат ПодключаемоеОборудованиеШтрихМВесыСПечатьюЭтикетокКлиент;
		КонецЕсли;
		// Конец Весы с печатью этикеток.
		
		//-- НЕ ГОСИС
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Процедура отправляет электронное сообщение на электронную почта и абонентский номер.
//
Процедура НачатьОтправкуЭлектронногоЧека(ПараметрыЧека, ТекстСообщения, ПокупательEmail, ПокупательНомер) Экспорт
	
КонецПроцедуры

// Переопределяет формируемый шаблон чека.
Функция СформироватьШаблонЧека(ВходныеПараметры, ДополнительныйТекст, СтандартнаяОбработка, ТипОборудования = "") Экспорт

КонецФункции

// Начинает рассылку или ставит задачу на рассылку нефискальных документов.
// Которые заданы в шаблоне чека.
Процедура НачатьРассылкуНефискальныхДокументов(Параметры) Экспорт
	
КонецПроцедуры

// КонецОбласти

// Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриОткрытии".
//
Процедура ЭкземплярОборудованияПриОткрытии(Объект, ЭтаФорма, Отказ) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗакрытием".
//
Процедура ЭкземплярОборудованияПередЗакрытием(Объект, ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписью".
//
Процедура ЭкземплярОборудованияПередЗаписью(Объект, ЭтаФорма, Отказ, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписи".
//
Процедура ЭкземплярОборудованияПослеЗаписи(Объект, ЭтаФорма, ПараметрыЗаписи) Экспорт
	
КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ТипОборудованияОбработкаВыбора".
//
Процедура ЭкземплярОборудованияТипОборудованияВыбор(Объект, ЭтаФорма, ЭтотОбъект, Элемент, ВыбранноеЗначение) Экспорт
	
	
КонецПроцедуры

// КонецОбласти

// Начать подключение необходимых типов оборудования при открытии формы.
//
// Параметры:
// Форма - УправляемаяФорма
// ПоддерживаемыеТипыПодключаемогоОборудования - Строка
//  Содержит перечень типов подключаемого оборудования, разделенных запятыми.
//
Процедура НачатьПодключениеОборудованиеПриОткрытииФормы(Форма, ПоддерживаемыеТипыПодключаемогоОборудования) Экспорт
	
	ОповещениеПриПодключении = ОписаниеОповещенияЕГАИС("ПодключитьОборудованиеЗавершение", МенеджерОборудованияКлиентПереопределяемый);
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(
		ОповещениеПриПодключении,
		Форма,
		ПоддерживаемыеТипыПодключаемогоОборудования);
	
КонецПроцедуры

// Начать отключать оборудование по типу при закрытии формы.
//
Процедура НачатьОтключениеОборудованиеПриЗакрытииФормы(Форма) Экспорт
	
	ОповещениеПриОтключении = ОписаниеОповещенияЕГАИС("ОтключитьОборудованиеЗавершение", МенеджерОборудованияКлиентПереопределяемый);
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(ОповещениеПриОтключении, Форма);
	
КонецПроцедуры

Процедура СообщитьОбОшибке(РезультатВыполнения) Экспорт
	
	ТекстСообщения = НСтр("ru = 'При выполнении операции произошла ошибка:""%ОписаниеОшибки%"".'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатВыполнения.ОписаниеОшибки);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
	
	Если НЕ РезультатВыполнения.Результат Тогда
		ТекстСообщения = НСтр( "ru = 'При отключении оборудования произошла ошибка: ""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

Функция ЕстьНеобработанноеСобытие() Экспорт
	
	Возврат (глПодключаемоеОборудованиеСобытиеОбработано = Ложь);
	
КонецФункции

Процедура ОбработатьСобытие() Экспорт
	
	глПодключаемоеОборудованиеСобытиеОбработано = Истина;
	
КонецПроцедуры