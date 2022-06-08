﻿//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
//Конец РаботаСВнешнимОборудованием

Перем глСерверТО Экспорт;

// СтандартныеПодсистемы

// БазоваяФункциональность

// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт; 
// Признак того, что в данном сеансе не нужно повторно предлагать установку
Перем ПредлагатьУстановкуРасширенияРаботыСФайлами Экспорт;
// Признак того, что в данном сеансе не нужно запрашивать стандартное подтверждение при выходе
Перем ПропуститьПредупреждениеПередЗавершениемРаботыСистемы Экспорт;
// Структура, содержащая в себе время начала и окончания обновления программы.
Перем ПараметрыРаботыКлиентаПриОбновлении Экспорт;

// Конец БазоваяФункциональность

// ОбновлениеКонфигурации

// Информация о доступном обновлении конфигурации, обнаруженном в Интернете
// при запуске программы.
Перем ДоступноеОбновлениеКонфигурации Экспорт;
// Структура с параметрами помощника обновления конфигурации.
Перем НастройкиОбновленияКонфигурации Экспорт; 

// Конец ОбновлениеКонфигурации

// ФайловыеФункции
Перем ПроверкаДоступаКРабочемуКаталогуВыполнена Экспорт; // Кэшируется, чтобы в данном сеансе повторно не делать проверку доступа к каталогу на диске

// Конец СтандартныеПодсистемы

// ЭлектронныеДокументы
Перем глWSОпределениеСбербанк Экспорт; 
Перем глКриптоДЛЛСбербанк Экспорт;
Перем глПинКодСбербанк Экспорт;
Перем глНомерКонтейнераСбербанк Экспорт;
Перем глТекущееСоглашениеСбербанк Экспорт;
Перем глУстановленКаналСоСберБанком Экспорт;
Перем глВыполненаАвторизацияСбербанк Экспорт;
Перем ПараметрыПодсистемыОбменСБанками Экспорт;
// При соответствующих настройках сертификата ЭП в соответствии будут храниться пары Сертификат-Пароль (в данном сеансе)
Перем СоответствиеСертификатаИПароля Экспорт;
// Конец ЭлектронныеДокументы

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередНачаломРаботыСистемы(Отказ)
	
	// СтандартныеПодсистемы
	
	// Получим параметры работы клиента за одно обращение к серверу
	// Чтобы при повторном вызове этой функции не было обращений к серверу
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
	
	Если НЕ ПараметрыРаботыКлиента.ПользователюРазрешенЗапускКонфигурации Тогда
		Предупреждение(НСтр("ru = 'Вам не назначена роль ""Пользователь"". Запуск конфигурации невозможен.'"));
		Отказ = Истина;		
		Возврат; //Дальше нет необходимости выполнения, т.к. могут быть ошибки нарушения прав
	КонецЕсли; 	
	
	Если Не Отказ Тогда
		СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
		
		// ПодключаемоеОборудование
		МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
		// Конец ПодключаемоеОборудование
		
	КонецЕсли;
	
	// Конец СтандартныеПодсистемы
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	
	СтандартныеПодсистемыКлиент.УстановитьПроизвольныйЗаголовокПриложения();
	
	// ОбновлениеВерсииИБ
	ОбновлениеИнформационнойБазыКлиент.ВыполнитьОбновлениеИнформационнойБазы();
	// Конец ОбновлениеВерсииИБ
	
	// отработка параметров запуска системы
	Если ОбработатьПараметрыЗапуска(ПараметрЗапуска) Тогда
		Возврат;
	КонецЕсли;
	
	// ОбновлениеКонфигурации
	ОбновлениеКонфигурацииКлиент.ПроверитьОбновлениеКонфигурации();
	// Конец ОбновлениеКонфигурации
	
	// ЗавершениеРаботыПользователей
	СоединенияИБКлиент.УстановитьКонтрольРежимаЗавершенияРаботыПользователей();
	// Конец ЗавершениеРаботыПользователей
	
	// Конец СтандартныеПодсистемы
	
	//РаботаСВнешнимОборудованием
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	//РаботаСВнешнимОборудованием
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	//РаботаСВнешнимОборудованием
	// Подготовить данные
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";

	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);

	// Передать на обработку данные
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'")
		                                                 + Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	//Конец РаботаСВнешнимОборудованием
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция возвращает объект для взаимодействия с торговым оборудованием.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  <ОбработкаОбъект> - Объект для взаимодействия с торговым оборудованием.
//
Функция ПолучитьСерверТО() Экспорт

	Если глСерверТО = Неопределено Тогда
		глСерверТО = ИнтеграцияЕГАИСВызовСервера.ПолучитьСерверТОНаСервере();
	КонецЕсли;

	Возврат глСерверТО;

КонецФункции // ПолучитьСерверТО()


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обработать параметр запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры
//  ПараметрЗапуска  – Строка – параметр запуска, переданный в конфигурацию 
//                              с помощью ключа командной строки /C.
//
// Возвращаемое значение:
//   Булево   – Истина, если необходимо прервать выполнение процедуры ПриНачалеРаботыСистемы.
//
Функция ОбработатьПараметрыЗапуска(Знач ПараметрЗапуска)

	Перем Результат;
	Результат = Ложь;
	
	// СтандартныеПодсистемы
	
	// Есть ли параметры запуска
	Если ПустаяСтрока(ПараметрЗапуска) Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Параметр может состоять из частей, разделенных символом ";".
	// Первая часть - главное значение параметра запуска. 
	// Наличие дополнительных частей определяется логикой обработки главного параметра.
	ПараметрыЗапуска = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПараметрЗапуска, ";");
	ЗначениеПараметраЗапуска = Врег(ПараметрыЗапуска[0]);
	
	// ЗавершениеРаботыПользователей
	Результат = СоединенияИБКлиент.ОбработатьПараметрыЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска);
	// Конец ЗавершениеРаботыПользователей
	
	// Конец СтандартныеПодсистемы
	
	// Код конфигурации
	// ...
	// Конец кода конфигурации

	// СтандартныеПодсистемы
	Возврат Результат;
	// Конец СтандартныеПодсистемы

КонецФункции
