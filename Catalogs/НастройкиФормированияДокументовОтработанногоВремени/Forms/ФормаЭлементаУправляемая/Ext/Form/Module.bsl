﻿&НаКлиенте
Перем НужноУдалитьРегламентноеЗадание Экспорт; // Ответ пользователя на вопрос о необходимости удалять регл. задание (булево или неопределено)

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция сравнивает период детализации настройки со значением периодичности "Месяц".
//
// Возвращаемое значение:
//   Булево   - Истина, если период детализации настройки задан "Месяц", 
//				в противном случае Ложь.
//
&НаСервере
Функция ПериодДетализацииМесяц()

	Возврат Объект.ПериодДетализации = Перечисления.Периодичность.Месяц;

КонецФункции // ПериодДетализацииМесяц()

&НаКлиенте
Процедура УстановитьДоступность()
	
	Если ТолькоПросмотр Тогда
		Элементы.ПредставлениеРасписания.Доступность 				= Ложь;
		Возврат;
	КонецЕсли;

	Элементы.ПредставлениеРасписания.Доступность 			   = Объект.ФормироватьДокументыАвтоматически;
	Элементы.НеОбрабатыватьВсеДокументы.Доступность 		   = Объект.ФормироватьДокументыАвтоматически;
	Элементы.НадписьПояснениеЗадержка.Видимость 			   = Объект.ФормироватьДокументыАвтоматически;
	Элементы.Задержка.Доступность 							   = Объект.ФормироватьДокументыАвтоматически И Объект.НеОбрабатыватьВсеДокументы;
	
	Элементы.СпособВводаДанных.Доступность			= ПериодДетализацииМесяц();
	
КонецПроцедуры

// Устанавливает подпись к полю Задержка с учетом формы множественного числа
&НаКлиенте
Процедура НастроитьНадписьЗадержка()
	
	Если Объект.НеОбрабатыватьВсеДокументы Тогда
	
		Если Объект.Задержка = 0 Тогда 
			ПояснениеЗадержка = Нстр("ru = 'Не обрабатывать документы за сегодня'");
		Иначе
			ПояснениеЗадержка = "";
		КонецЕсли;
		
	Иначе
		
		ПояснениеЗадержка = Нстр("ru = 'Обрабатывать все введенные документы'");
		
	КонецЕсли;
	Элементы.НадписьПояснениеЗадержка.Заголовок = ПояснениеЗадержка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Расписание = РегламентныеПроцедуры.ПолучитьРасписаниеРегламентногоЗадания(Объект.РегламентноеЗадание);
	РегламентныеПроцедуры.НастроитьПредставлениеРасписания(ЭтаФорма);
	ДатаНачалаОбработки		= ?(ЗначениеЗаполнено(Объект.ГраницаОбработки), КонецДня(Объект.ГраницаОбработки) + 1,'0001-01-01');
	
	СправочникОбъект = РеквизитФормыВЗначение("Объект");
	Если СправочникОбъект.ЭтоНовый() Тогда
        Объект.СпособВводаДанных = Перечисления.СпособыВводаДанныхОВремени.ПоДням
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	НастроитьНадписьЗадержка();
	Элементы.ПредставлениеРасписания.Заголовок = ПредставлениеРасписания;
	ФормироватьДокументыАвтоматически = Объект.ФормироватьДокументыАвтоматически;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("НужноУдалитьРегламентноеЗадание", НужноУдалитьРегламентноеЗадание);
	ПараметрыЗаписи.Вставить("Расписание", Расписание);
	ПараметрыЗаписи.Вставить("НачалоОбработки", ДатаНачалаОбработки);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.НужноУдалитьРегламентноеЗадание = Истина Тогда
		ЗаголовокСообщения = ТекущийОбъект.ЗаголовокПриЗаписи();
		РегламентныеПроцедуры.УдалитьРегламентноеЗаданиеПриЗаписиНастройки(ТекущийОбъект,ЗаголовокСообщения,Отказ);
	КонецЕсли;	
	ТекущийОбъект.ГраницаОбработки = ?(ЗначениеЗаполнено(ПараметрыЗаписи.НачалоОбработки), НачалоДня(ПараметрыЗаписи.НачалоОбработки) - 1,'0001-01-01');
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обрабатываем расписание регл. задания
	Если НЕ ТекущийОбъект.ФормироватьДокументыАвтоматически Тогда 
		Возврат;
	КонецЕсли;
	
	ЗаголовокСообщения = ТекущийОбъект.ЗаголовокПриЗаписи();
	РегламентныеПроцедуры.ИзменитьРегламентноеЗаданиеПриЗаписиНастройки(ТекущийОбъект,ПараметрыЗаписи.Расписание,ЗаголовокСообщения,Отказ);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура ДатаНачалаОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДетализацииОчистка(Элемент, СтандартнаяОбработка)
	
	// Очищать это поле нельзя
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДетализацииПриИзменении(Элемент)
	УстановитьДоступность()
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьДокументыАвтоматическиПриИзменении(Элемент)
	
	ФормироватьДокументыАвтоматически = Объект.ФормироватьДокументыАвтоматически;
	НужноУдалитьРегламентноеЗадание = РегламентныеПроцедуры.ПриИзмененииФлагаФормироватьДокументыАвтоматически(ЭтаФорма);
	Элементы.ПредставлениеРасписания.Заголовок = ПредставлениеРасписания;
	Если НЕ Объект.ФормироватьДокументыАвтоматически И Объект.НеОбрабатыватьВсеДокументы Тогда
		Объект.НеОбрабатыватьВсеДокументы = Ложь;
		Объект.Задержка = 0;
	КонецЕсли;
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРасписанияНажатие(Элемент)
	
	РегламентныеПроцедуры.РедактироватьРасписаниеРегламентногоЗадания(ЭтаФорма);
	Элементы.ПредставлениеРасписания.Заголовок = ПредставлениеРасписания;
	УстановитьДоступность();

КонецПроцедуры

&НаКлиенте
Процедура НеОбрабатыватьВсеДокументыПриИзменении(Элемент)
	
	УстановитьДоступность();
	
	Если Объект.НеОбрабатыватьВсеДокументы Тогда
		ТекущийЭлемент = Элементы.Задержка;
	КонецЕсли;

	НастроитьНадписьЗадержка();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадержкаПриИзменении(Элемент)
	НастроитьНадписьЗадержка();
КонецПроцедуры

