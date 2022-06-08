﻿Перем СохраненнаяНастройка Экспорт;
Перем Расшифровки Экспорт;

#Если Клиент Тогда

Процедура ОбработкаРезультатаОтчета(ОбъектОтчета, Результат)
	
	// Выводим надписи вертикально, если количество точек диаграмм больше 9
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
		    Рисунок.Объект.ОбластьПостроения.ВертикальныеМетки  = (Рисунок.Объект.Точки.Количество() > 9);
			Рисунок.Объект.ОбластьПостроения.ФорматШкалыЗначений = "ЧГ=3,0";
			Рисунок.Объект.ОбластьЛегенды.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная, 1);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСхемуКомпоновкиОбъекта(ОтчетОбъект)
	
	Если ЭтоПроизвольныйОтчет(ОтчетОбъект) Тогда
		Возврат ОтчетОбъект.СхемаКомпоновкиДанных.Получить();
	Иначе
		Возврат ОтчетОбъект.СхемаКомпоновкиДанных;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	СтруктураНатроек = Новый Структура();
	Возврат СтруктураНатроек;
	
КонецФункции  

Функция ПолучитьОписаниеРодительскойПричиныИнформацииОбОшибке(ИнформацияОбОшибке)
	
	Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
		ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
	КонецЦикла;
	Возврат ИнформацияОбОшибке.Описание;

КонецФункции

Функция ЭтоПроизвольныйОтчет(ОтчетОбъект = Неопределено)
	
	Если ОтчетОбъект <> Неопределено Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(ОтчетОбъект));
		Если ТипЗнч(ОтчетОбъект) = Тип("Структура") 
		 ИЛИ МетаданныеОбъекта <> Неопределено 
		   И Метаданные.Справочники.Найти(Метаданные.НайтиПоТипу(ТипЗнч(ОтчетОбъект)).Имя) <> Неопределено Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе
		Возврат (Найти(Метаданные.Имя, "Консолидация") > 0);
	КонецЕсли;
	
КонецФункции

Процедура ВывестиОтчет(ОтчетОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных)
	
	ОтчетОбъект.КомпоновщикНастроек.Восстановить();
	Схема = ПолучитьСхемуКомпоновкиОбъекта(ОтчетОбъект);
	
	//Сгенерируем макет компоновки данных при помощи компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Попытка
		
		//В качестве схемы компоновки будет выступать схема самого отчета
		//В качестве настроек отчета - текущие настройки отчета
		//Данные расшифровки будем помещать в ДанныеРасшифровки
		МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, ОтчетОбъект.КомпоновщикНастроек.Настройки, , ПолучитьМакет("МакетОформленияОтчетов"));
		//ДополнитьМакетыМакетаКомпоновкиРасшифровкойРесурсов(МакетКомпоновки, ОтчетОбъект.КомпоновщикНастроек);
		//Создадим и инициализируем процессор компоновки
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		Если ВнешниеНаборыДанных = Неопределено Тогда
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
		Иначе
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
		КонецЕсли;
		
		//Создадим и инициализируем процессор вывода результата
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(Результат);
		
		//Обозначим начало вывода
		ПроцессорВывода.НачатьВывод();
		Состояние(НСТР("ru='Если Вы хотите прервать вывод отчета, нажмите Ctrl+Break'"));
		
		ТаблицаЗафиксирована = Не ВыводВФормуОтчета;
		
		Результат.ФиксацияСверху = 0;
		//Основной цикл вывода отчета
		Пока Истина Цикл
			
			ОбработкаПрерыванияПользователя();
			//Получим следующий элемент результата компоновки
			ЭлементРезультата = ПроцессорКомпоновки.Следующий();
			
			Если ЭлементРезультата = Неопределено Тогда
				//Следующий элемент не получен - заканчиваем цикл вывода
				Прервать;
				
			Иначе
				
				// Зафиксируем шапку
				Если Не ОтчетОбъект.РасширеннаяНастройка 
					И Не ТаблицаЗафиксирована 
					И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
					И ТипЗнч(ОтчетОбъект.КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда
					ТаблицаЗафиксирована = Истина;
					Результат.ФиксацияСверху = Результат.ВысотаТаблицы;
				КонецЕсли;
				
				//Элемент получен - выведем его при помощи процессора вывода
				ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
				
			КонецЕсли;
			
		КонецЦикла;
		
		//Обозначем завершение вывода
		ПроцессорВывода.ЗакончитьВывод();
		
	Исключение
		Вопрос("Отчет не сформирован!" + Символы.ПС + ПолучитьОписаниеРодительскойПричиныИнформацииОбОшибке(ИнформацияОбОшибке()), РежимДиалогаВопрос.ОК);
	КонецПопытки;

КонецПроцедуры

Функция ОтчетыДляРуководителя_ПолучитьТекстЗаголовка(ОбъектОтчета, ЗаголовокТекст = "", ОрганизацияВНачале = Истина)
	
	ТекстОрганизации = "";
	
	Если ЗначениеЗаполнено(ОбъектОтчета.Организация) Тогда
		ТекстОрганизации = СокрЛП(ОбъектОтчета.Организация.НаименованиеПолное);
		Если ПустаяСтрока(ТекстОрганизации) Тогда
			ТекстОрганизации = СокрЛП(ОбъектОтчета.Организация.Наименование);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбъектОтчета.Метаданные().Реквизиты.Найти("Период") = Неопределено Тогда
		Попытка
			ТекстПериод = " за " + ПредставлениеПериода(НачалоДня(ОбъектОтчета.НачалоПериода), КонецДня(ОбъектОтчета.КонецПериода), "ФП");
		Исключение
			ТекстПериод = "";
		КонецПопытки;
	Иначе
		Если ЗначениеЗаполнено(ОбъектОтчета.Период) Тогда 
			ТекстПериод = " на " + Формат(ОбъектОтчета.Период, "ДФ=dd.MM.yyyy");
		Иначе
			ТекстПериод = "";
		КонецЕсли;
	КонецЕсли;
	
	ЗаголовокОтчета = "" + ЗаголовокТекст;
	
	Если ЗначениеЗаполнено(ТекстПериод) Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + ТекстПериод;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОрганизации) Тогда
		Если ОрганизацияВНачале Тогда
			ЗаголовокОтчета = ТекстОрганизации + Символы.ПС + ЗаголовокОтчета;
		Иначе
			ЗаголовокОтчета = ЗаголовокОтчета + " " + ТекстОрганизации;
		КонецЕсли;
	КонецЕсли;
		
	Возврат ЗаголовокОтчета;
	
КонецФункции
	
Процедура СформироватьОтчет(Результат = Неопределено, ДанныеРасшифровки = Неопределено, ВыводВФормуОтчета = Истина, ВнешниеНаборыДанных = Неопределено) Экспорт
	
	// Проверим заполнение обязательных реквизитов
	Если ПроверитьЗаполнениеОбязательныхРеквизитов() Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	ВыводЗаголовкаОтчета(ЭтотОбъект, Результат);
	ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных);
	ВывестиОтчет(ЭтотОбъект, Результат, ДанныеРасшифровки, ВыводВФормуОтчета, ВнешниеНаборыДанных);
	КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	// Выполним дополнительную обработку Результата отчета
	ОбработкаРезультатаОтчета(ЭтотОбъект, Результат);
	
	ВыводПодвалаОтчета(ЭтотОбъект, Результат);
	
	Если Результат.КоличествоУровнейГруппировокСтрок() > 2 Тогда
		Результат.ПоказатьУровеньГруппировокСтрок(Результат.КоличествоУровнейГруппировокСтрок() - 2);
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ДоработатьКомпоновщикПередВыводом(ВнешниеНаборыДанных) Экспорт
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(КонецПериода));
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ТиповыеОтчеты.ДобавитьОтбор(КомпоновщикНастроек, "Организация", Организация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыводЗаголовкаОтчета(ОтчетОбъект, Результат)
	
	МакетЗаголовок = ПолучитьМакет("Отчет");
	ОбластьЗаголовок = МакетЗаголовок.ПолучитьОбласть("Заголовок");
	
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета     = ЭтотОбъект.Метаданные().Синоним;
	ОбластьЗаголовок.Параметры.НазваниеОрганизации = Организация.НаименованиеПолное;
	ОбластьЗаголовок.Параметры.ИННОрганизации      = СокрЛП(Организация.ИНН) + "/" + СокрЛП(Организация.КПП);
	ОбластьЗаголовок.Параметры.НачалоПериода       = Формат(НачалоПериода, "ДФ=dd.MM.yyyy");
	ОбластьЗаголовок.Параметры.КонецПериода        = Формат(КонецПериода, "ДФ=dd.MM.yyyy");
	
	Результат.Вывести(ОбластьЗаголовок);
			
КонецПроцедуры

Процедура ВыводПодвалаОтчета(ОтчетОбъект, Результат)
	
	МакетЗаголовок = ПолучитьМакет("Отчет");
	ОбластьПодвал = МакетЗаголовок.ПолучитьОбласть("Подвал");
	
	СтруктураЛиц = РегламентированнаяОтчетность.ОтветственныеЛицаОрганизаций(Организация, КонецПериода);
	ОбластьПодвал.Параметры.ОтветственныйЗаРегистры = ОбщегоНазначения.ФамилияИнициалыФизЛица(СтруктураЛиц.ОтветственныйЗаРегистры);
	
	Результат.Вывести(ОбластьПодвал);
			
КонецПроцедуры

Функция ПолучитьТекстЗаголовка(ОрганизацияВНачале = Истина) Экспорт 
	
	ЗаголовокОтчета = ЭтотОбъект.Метаданные().Синоним;
	
	Возврат ОтчетыДляРуководителя_ПолучитьТекстЗаголовка(ЭтотОбъект, ЗаголовокОтчета, ОрганизацияВНачале);
	
КонецФункции

Функция ПроверитьЗаполнениеОбязательныхРеквизитов()
	
	Отказ = Ложь;
	Если НачалоПериода > КонецПериода Тогда
		Сообщить("Дата начала периода не может быть больше даты конца периода", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции
	
// Для настройки отчета (расшифровка и др.)
Процедура Настроить(Отбор, КомпоновщикНастроекОсновногоОтчета = Неопределено) Экспорт
	
	ТиповыеОтчеты.НастроитьТиповойОтчет(ЭтотОбъект, Отбор, КомпоновщикНастроекОсновногоОтчета);
	
КонецПроцедуры

Процедура СохранитьНастройку() Экспорт
	
	СтруктураНастроек = ТиповыеОтчеты.ПолучитьСтруктуруПараметровТиповогоОтчета(ЭтотОбъект);
	
	Если СохраненнаяНастройка = Неопределено Тогда
		СсылкаНаОбъект = ТиповыеОтчеты.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
		Настройка = Справочники.СохраненныеНастройки.СоздатьЭлемент();
		Настройка.НастраиваемыйОбъект = СсылкаНаОбъект;
		Настройка.ТипНастройки = Перечисления.ТипыНастроек.НастройкиПользователяНастройкиОтчета;
		//Настройка.Владелец = глЗначениеПеременной("глТекущийПользователь");
		Настройка.Наименование = "НастройкиПользователяНастройкиОтчета";
		Настройка.ИспользоватьПриОткрытии = Истина;
		НовыйПользователь = Настройка.Пользователи.Добавить();
		НовыйПользователь.Пользователь = глЗначениеПеременной("глТекущийПользователь");
		Настройка.Записать();
		
		СохраненнаяНастройка = Настройка.Ссылка;
	КонецЕсли;
	
	СохранениеНастроек.СохранитьНастройкуОбъекта(СохраненнаяНастройка, СтруктураНастроек);
	
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
	
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоПериода);
	ТиповыеОтчеты.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода",  КонецПериода);
	
КонецПроцедуры

Расшифровки = Новый СписокЗначений;

НастройкаПериода = Новый НастройкаПериода;

#КонецЕсли