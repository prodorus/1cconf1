////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ БЛОКИРОВКИ И ЗАВЕРШЕНИЯ СОЕДИНЕНИЙ С ИБ

// Устанавливает блокировку соединений ИБ.
//
// Параметры
//  ТекстСообщения  – Строка – текст, который будет частью сообщения об ошибке
//                             при попытке установки соединения с заблокированной
//                             информационной базой.
// 
//  КодРазрешения - Строка -   строка, которая должна быть добавлена к параметру
//                             командной строки "/uc" или к параметру строки
//                             соединения "uc", чтобы установить соединение с
//                             информационной базой несмотря на блокировку.
//
// Возвращаемое значение:
//   Булево   – Истина, если блокировка установлена успешно.
//              Ложь, если для выполнения блокировки недостаточно прав.
//
Функция УстановитьБлокировкуСоединений(Знач ТекстСообщения = "",
                                       Знач КодРазрешения = "КодРазрешения") Экспорт
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаСеансов;
	Блокировка.Установлена = Истина;
	Блокировка.Начало = ТекущаяДатаСеанса();
	Блокировка.КодРазрешения = КодРазрешения;
	Блокировка.Сообщение = СформироватьСообщениеБлокировки(ТекстСообщения, КодРазрешения);
	УстановитьБлокировкуСеансов(Блокировка);
	Возврат Истина;
	
КонецФункции

// Определяет, установлена ли блокировка соединений при пакетном 
// обновлении конфигурации информационной базы
//
Функция УстановленаБлокировкаСоединений() Экспорт
	
	ТекущийРежим = ПолучитьБлокировкуСеансов();
	Возврат ТекущийРежим.Установлена;
	
КонецФункции

// Возвращает параметры блокировки соединений ИБ.
//
// Параметры:
//  ПолучитьКоличествоСеансов - Булево - если Истина, то в возвращаемой структуре
//                                       заполняется поле КоличествоСеансов.
//
Функция ПараметрыБлокировкиСеансов(Знач ПолучитьКоличествоСеансов = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущийРежим = ПолучитьБлокировкуСеансов();
	
	Возврат Новый Структура(
		"Установлена,Начало,Конец,Сообщение,ИнтервалОжиданияЗавершенияРаботыПользователей,КоличествоСеансов,ТекущаяДатаСеанса",
		ТекущийРежим.Установлена,
		ТекущийРежим.Начало,
		ТекущийРежим.Конец,
		ТекущийРежим.Сообщение,
		5 * 60, // 5 минут; интервал ожидания завершения пользователей после установки
		        // блокировки информационной базы (в секундах).
		?(ПолучитьКоличествоСеансов, КоличествоСеансовИнформационнойБазы(), 0),
		ТекущаяДатаСеанса()
	);

КонецФункции

// Снять блокировку информационной базы.
//
// Возвращаемое значение:
//   Булево   – Истина, если операция выполнена успешно.
//              Ложь, если для выполнения операции недостаточно прав.
//
Функция РазрешитьРаботуПользователей() Экспорт
	
	Если НЕ ПравоДоступа("Администрирование", Метаданные) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекущийРежим = ПолучитьБлокировкуСеансов();
	Если ТекущийРежим.Установлена Тогда
		НовыйРежим = Новый БлокировкаСеансов;
		НовыйРежим.Установлена = Ложь;
		УстановитьБлокировкуСеансов(НовыйРежим);
	КонецЕсли;
	Возврат Истина;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПРИНУДИТЕЛЬНОГО ОТКЛЮЧЕНИЯ СЕАНСОВ ИБ

// Отключает сеанс по номеру сеанса
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ
//  НомерСеанса - Число - номер сеанса для отключения
// 
// Возвращаемое значение:
//  Булево – результат отключения сеанса.
//
Функция ОтключитьСеанс(НомерСеанса, Сообщение) Экспорт
	
	Возврат СоединенияИБКлиентСервер.ОтключитьСеанс(НомерСеанса, Сообщение);
	
КонецФункции

// Отключить все активные соединения ИБ (кроме текущего сеанса).
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ.  
//
// Возвращаемое значение:
//   Булево   – результат отключения соединений.
//
Функция ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ) Экспорт
	
	Возврат СоединенияИБКлиентСервер.ОтключитьСоединенияИБ(ПараметрыАдминистрированияИБ);
	
КонецФункции

// Осуществляет попытку подключиться к кластеру серверов и получить список 
// активных соединений к ИБ и использованием указанных параметров администрирования.
//
// Параметры
//  ПараметрыАдминистрированияИБ  – Структура – параметры администрирования ИБ
//  ВыдаватьСообщения             – Булево    – разрешить вывод интерактивных сообщений.
//
// Возвращаемое значение:
//   Булево   – Истина, если проверка завершена успешно.
//
Процедура ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ,
	Знач ПодробноеСообщениеОбОшибке = Ложь) Экспорт
	
	СоединенияИБКлиентСервер.ПроверитьПараметрыАдминистрированияИБ(ПараметрыАдминистрированияИБ,
		ПодробноеСообщениеОбОшибке);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЕРВИСНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 
//

// Возвращает текст сообщения блокировки сеансов.
//
// Возвращаемое значение:
//   Строка
//
Функция СформироватьСообщениеБлокировки(Знач Сообщение, Знач КодРазрешения) Экспорт

	ПараметрыАдминистрированияИБ = СоединенияИБПовтИсп.ПолучитьПараметрыАдминистрированияИБ();
	ПризнакФайловогоРежима = Ложь;
	ПутьКИБ = СоединенияИБКлиентСервер.ПутьКИнформационнойБазе(ПризнакФайловогоРежима, 
		?(ПараметрыАдминистрированияИБ.Свойство("ПортКластераСерверов"), ПараметрыАдминистрированияИБ.ПортКластераСерверов, 0));
	СтрокаПутиКИнформационнойБазе = ?(ПризнакФайловогоРежима = Истина, "/F", "/S") + ПутьКИБ; 
	ТекстСообщения = "";                                 
	Если НЕ ПустаяСтрока(Сообщение) Тогда
		ТекстСообщения = Сообщение + Символы.ПС + Символы.ПС;
	КонецЕсли;
	
	ТекстСообщения = ТекстСообщения +
	    НСтр("ru = '%1
	               |Для того чтобы принудительно разблокировать информационную базу, воспользуйтесь консолью кластера серверов или запустите ""1С:Предприятие"" с параметрами:
	               |ENTERPRISE %2 /CРазрешитьРаботуПользователей /UC%3'");
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
		СоединенияИБКлиентСервер.ТекстДляАдминистратора(), СтрокаПутиКИнформационнойБазе, НСтр("ru = '<код разрешения>'"));
	
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает текстовую строку со списком активных соединений ИБ.
// Названия соединений разделены символом переноса строки.
//
// Возвращаемое значение:
//   Строка
//
Функция ПолучитьНазванияСоединенийИБ(Знач Сообщение) Экспорт
	
	Результат = Сообщение;
	Для каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса <> НомерСеансаИнформационнойБазы() Тогда
			Результат = Результат + Символы.ПС + " - " + Сеанс;
		КонецЕсли;
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

// Получить сохраненные параметры администрирования кластера серверов.
// 
// Возвращаемое значение:
//   Структура – с полями, возвращаемыми функцией НовыеПараметрыАдминистрированияИБ.
//
Функция ПолучитьПараметрыАдминистрированияИБ() Экспорт

	Результат = СоединенияИБКлиентСервер.НовыеПараметрыАдминистрированияИБ();
	СтруктураНастроек = Константы.ПараметрыАдминистрированияИБ.Получить().Получить();
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Результат, СтруктураНастроек);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Сохранить параметры администрирования кластера серверов в ИБ.
//
// Параметры:
//		Параметры - структура с полями, возвращаемыми функцией НовыеПараметрыАдминистрированияИБ.
//
Процедура ЗаписатьПараметрыАдминистрированияИБ(Параметры) Экспорт
	
	Константы.ПараметрыАдминистрированияИБ.Установить(Новый ХранилищеЗначения(Параметры));
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

// Получить число активных сеансов ИБ.
//
// Параметры:
//   УчитыватьКонсоль               - Булево - если Ложь, то исключить сеансы консоли кластера серверов.
//                                             сеансы консоли кластера серверов не препятствуют выполнению 
//                                             административных операций (установке монопольного режима и т.п.).
//   СообщенияДляЖурналаРегистрации - СписокЗначений - пакета сообщения для журнала регистрации
//                                                     сформированных на клиенте.
//
// Возвращаемое значение:
//   Число   – количество активных сеансов ИБ.
//
Функция КоличествоСеансовИнформационнойБазы(УчитыватьКонсоль = Истина, 
	СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ОбщегоНазначения.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	СеансыИБ = ПолучитьСеансыИнформационнойБазы();
	Если УчитыватьКонсоль Тогда
		Возврат СеансыИБ.Количество();
	КонецЕсли;
	
	Результат = 0;
	Для каждого СеансИБ Из СеансыИБ Цикл
		Если СеансИБ.ИмяПриложения <> "SrvrConsole" Тогда
			Результат = Результат + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

// Возвращает строковую константу для формирования сообщений журнала регистрации.
//
// Возвращаемое значение:
//   Строка
//
Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Завершение работы пользователей'");
	
КонецФункции

// Записать в журнал регистрации список сеансов ИБ.
//
// Параметры:
//   ТекстСообщения - Строка - опциональный текст с пояснениями.
//
Процедура ЗаписатьНазванияСоединенийИБ(Знач ТекстСообщения) Экспорт
	Сообщение = ПолучитьНазванияСоединенийИБ(ТекстНеУдалосьЗавершитьРаботуПользователей(ТекстСообщения));
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Предупреждение, , , Сообщение);
КонецПроцедуры

Функция ТекстНеУдалосьЗавершитьРаботуПользователей(Знач Сообщение) 
	
	Если Не ПустаяСтрока(Сообщение) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось завершить работу пользователей (%1):'"),
			Сообщение);
	Иначе		
		ТекстСообщения = НСтр("ru = 'Не удалось завершить работу пользователей:'");
	КонецЕсли;
	Возврат ТекстСообщения;
	
КонецФункции

