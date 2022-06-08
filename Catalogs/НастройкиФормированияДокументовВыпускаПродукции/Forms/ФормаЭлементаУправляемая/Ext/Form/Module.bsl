﻿&НаКлиенте
Перем НужноУдалитьРегламентноеЗадание Экспорт; // Ответ пользователя на вопрос о необходимости удалять регл. задание (булево или неопределено)

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Расписание = РегламентныеПроцедуры.ПолучитьРасписаниеРегламентногоЗадания(Объект.РегламентноеЗадание);
	РегламентныеПроцедуры.НастроитьПредставлениеРасписания(ЭтаФорма);
	
	СписокВидовРегулярныхДокументов = РегламентноеФормированиеДокументов.РегламентФормированияДокументовВыпуска_СписокВидовРегулярныхДокументов();
	ТребуетсяОтражатьМатериалы = Ложь;
	Для Каждого ВидДокумента Из СписокВидовРегулярныхДокументов Цикл
		ТребуетсяОтражатьМатериалы = ТребуетсяОтражатьМатериалы 
		    ИЛИ РегламентноеФормированиеДокументов.РегламентФормированияДокументовВыпуска_ЗаполнятьМатериалы(ВидДокумента.Значение);
	КонецЦикла;
	
	Если НЕ ТребуетсяОтражатьМатериалы Тогда
		Элементы.ОтразитьВыпуск.Видимость    = Ложь;
		Элементы.ОтразитьМатериалы.Видимость = Ложь;
		Элементы.НадписьОтразить.Видимость   = Ложь;
	КонецЕсли;
	ДатаНачалаОбработки		= ?(ЗначениеЗаполнено(Объект.ГраницаОбработки), КонецДня(Объект.ГраницаОбработки) + 1,'0001-01-01');
	
	СписокВидовРегулярныхДокументов = РегламентноеФормированиеДокументов.РегламентФормированияДокументовВыпуска_СписокВидовРегулярныхДокументов();
	// Настроим список выбор вида регулярного документа
	Для Каждого ЭлементСписка Из СписокВидовРегулярныхДокументов Цикл
		Элементы.ВидРегулярногоДокумента.СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступность();
	НастроитьНадписьЗадержка();
	Элементы.ПредставлениеРасписания.Заголовок = ПредставлениеРасписания;
	ФормироватьДокументыАвтоматически = Объект.ФормироватьДокументыАвтоматически;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	Если ТолькоПросмотр Тогда
		Элементы.ПредставлениеРасписания.Доступность 				= Ложь;
		Возврат;
	КонецЕсли;

	Элементы.НеОбрабатыватьПериодДоЗавершенияСмен.Доступность = НЕ Объект.Подразделение.Пустая();
	Элементы.ПредставлениеРасписания.Доступность 			   = Объект.ФормироватьДокументыАвтоматически;
	Элементы.НеОбрабатыватьВсеДокументы.Доступность 		   = Объект.ФормироватьДокументыАвтоматически;
	Элементы.НадписьПояснениеЗадержка.Видимость 			   = Объект.ФормироватьДокументыАвтоматически;
	Элементы.Задержка.Доступность 							   = Объект.ФормироватьДокументыАвтоматически И Объект.НеОбрабатыватьВсеДокументы;
	МожноОтразитьМатериалы = РегламентноеФормированиеДокументов.РегламентФормированияДокументовВыпуска_ЗаполнятьМатериалы(Объект.ВидРегулярногоДокумента);
	Элементы.ОтразитьВыпуск.Доступность                       = МожноОтразитьМатериалы;
	Элементы.ОтразитьМатериалы.Доступность                    = МожноОтразитьМатериалы;
	
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

// Обработчик события ПриИзменении поля ввода Подразделение
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Объект.Подразделение.Пустая() И Объект.НеОбрабатыватьПериодДоЗавершенияСмен Тогда
		// Такая настройка не допускается
		НеОбрабатыватьПериодДоЗавершенияСмен = Ложь;
	КонецЕсли;
	
	// Изменим доступность флага
	УстановитьДоступность();
	
	// Попробуем заполнить подразделение организации
	РаботаСДиалогамиКлиент.ЗаполнитьПодразделениеОрганизации(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВидРегулярногоДокументаПриИзменении(Элемент)
	
	Элементы.ВидРегулярногоДокумента.ОтметкаНезаполненного = НЕ ЗначениеЗаполнено(Объект.ВидРегулярногоДокумента);
	
	// Не во всех формируемых документах заполняются материалы
	Если НЕ РегламентноеФормированиеДокументов.РегламентФормированияДокументовВыпуска_ЗаполнятьМатериалы(Объект.ВидРегулярногоДокумента) Тогда
		ОтразитьВыпуск    = Истина;
		ОтразитьМатериалы = Ложь;
	КонецЕсли;
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидРегулярногоДокументаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПериодДетализацииОчистка(Элемент, СтандартнаяОбработка)
	
	// Очищать это поле нельзя
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	// Попробуем заполнить подразделение организации
	РаботаСДиалогамиКлиент.ЗаполнитьПодразделениеОрганизации(Объект);
	
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
	ТекущийОбъект.ОтражатьВНалоговомУчете = ТекущийОбъект.ОтражатьВБухгалтерскомУчете;
	
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
