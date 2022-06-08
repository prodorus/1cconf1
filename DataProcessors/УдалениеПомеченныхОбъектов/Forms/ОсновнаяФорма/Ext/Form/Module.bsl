﻿///////////////////////////////////////////////////////////////
// Обработки событий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РежимУдаления = "Полный";
КонецПроцедуры

&НаКлиенте
Процедура РежимУдаленияПриИзменении(Элемент)
	ДоступностьКнопок();
КонецПроцедуры

// Обработчик события "при изменнии" поля "Пометка"
// Вызывает рекурсивную функцию, устанавливающую зависимые флажки пометок
// в родительских и дочерних элементах
//
&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокПомеченныхНаУдаление.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПометкуВСписке(ТекущиеДанные, ТекущиеДанные.Пометка, Истина);
	
КонецПроцедуры

// Обработчик нажания на кнопку "установить все" командной панели списка
// дерева СписокПомеченныхНаУдаление.
// Устанавливает пометку всем найденым объектам
//
&НаКлиенте
Процедура КомандаСписокПомеченныхУстановитьВсе()
	ЭлементыСписка = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		УстановитьПометкуВСписке(Элемент, Истина, Истина);
		Родитель = Элемент.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			ПроверитьРодителя(Элемент)
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Обработчик нажания на кнопку "снять все" командной панели списка
// дерева СписокПомеченныхНаУдаление.
// Снимает пометку у всех найденых объектов
//
&НаКлиенте
Процедура КомандаСписокПомеченныхСнятьВсе()
	ЭлементыСписка = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
	Для Каждого Элемент Из ЭлементыСписка Цикл
		УстановитьПометкуВСписке(Элемент, Ложь, Истина);
		Родитель = Элемент.ПолучитьРодителя();
		Если Родитель = Неопределено Тогда
			ПроверитьРодителя(Элемент)
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

// Обработчик события "выбор" строки дерева ДеревоОставшихсяОбъектов
// Пытается открыть выбранное значение
//
&НаКлиенте
Процедура ДеревоОставшихсяОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоОставшихсяОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТипЗнч(ТекущиеДанные.Значение) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	// это строка отображает объект, из-за которого не удалось удалить помеченный и выбранный
	СтандартнаяОбработка = Ложь;
	ОткрытьЗначение(ТекущиеДанные.Значение);
	
КонецПроцедуры

// Обработчик события "выбор" строки дерева СписокПомеченныхНаУдаление
// Пытается открыть выбранное значение
//
&НаКлиенте
Процедура СписокПомеченныхНаУдалениеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокПомеченныхНаУдаление.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПолучитьЭлементы().Количество() = 0 Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьЗначение(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Далее" командной панели формы
// 
&НаКлиенте
Процедура ВыполнитьДалее()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ВыборРежимаУдаления Тогда
		Состояние(НСтр("ru = 'Выполняется поиск помеченных на удаление объектов'"));
		
		ЗаполнениеДереваПомеченныхНаУдаление();
		
		Если КоличествоУровнейПомеченныхНаУдаление = 1 Тогда
			Для Каждого Элемент Из СписокПомеченныхНаУдаление.ПолучитьЭлементы() Цикл
				Идентификатор = Элемент.ПолучитьИдентификатор();
				Элементы.СписокПомеченныхНаУдаление.Развернуть(Идентификатор, Ложь);
			КонецЦикла;
		КонецЕсли;
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПомеченныеНаУдаление;
		ДоступностьКнопок();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Назад" командной панели формы
//
&НаКлиенте
Процедура ВыполнитьНазад()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	Если ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
		ДоступностьКнопок();
	ИначеЕсли ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления Тогда
		Если РежимУдаления = "Полный" Тогда
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыборРежимаУдаления;
		Иначе
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПомеченныеНаУдаление;
		КонецЕсли;
		ДоступностьКнопок();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Удалить" командной панели формы
//
&НаКлиенте
Процедура ВыполнитьУдаление()
	
	Перем ТипыУдаленныхОбъектов;
	
	Если РежимУдаления = "Полный" Тогда
		Состояние(НСтр("ru = 'Выполняется поиск и удаление помеченных объектов'"));
	Иначе
		Состояние(НСтр("ru = 'Выполняется удаление выбранных объектов'"));
	КонецЕсли;
	
	СообщениеОбОшибке = "";
	Если УдалениеВыбранныхНаСервере(СообщениеОбОшибке, ТипыУдаленныхОбъектов) Тогда
		Для Каждого ТипУдаленногоОбъекта Из ТипыУдаленныхОбъектов Цикл
			ОповеститьОбИзменении(ТипУдаленногоОбъекта);
		КонецЦикла;
	Иначе
		Предупреждение(СообщениеОбОшибке);
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПомеченных = Истина;
	Если КоличествоНеУдаленныхОбъектов = 0 Тогда
		Если УдаленныхОбъектов = 0 Тогда
			Текст = НСтр("ru = 'Не помечено на удаление ни одного объекта. Удаление объектов не выполнялось'");
			ОбновитьДеревоПомеченных = Ложь;
		Иначе
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			             НСтр("ru = 'Удаление помеченных объектов успешно завершено.
			                        |Удалено объектов: %1.'"),
			             УдаленныхОбъектов);
		КонецЕсли;
		Предупреждение(Текст);
	Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления;
		Для Каждого Элемент Из ДеревоОставшихсяОбъектов.ПолучитьЭлементы() Цикл
			Идентификатор = Элемент.ПолучитьИдентификатор();
			Элементы.ДеревоОставшихсяОбъектов.Развернуть(Идентификатор, Ложь);
		КонецЦикла;
		ДоступностьКнопок();
		Предупреждение(СтрокаРезультатов);
	КонецЕсли;
	
	Если ОбновитьДеревоПомеченных Тогда
		ЗаполнениеДереваПомеченныхНаУдаление();
		
		Если КоличествоУровнейПомеченныхНаУдаление = 1 Тогда 
			Для Каждого Элемент Из СписокПомеченныхНаУдаление.ПолучитьЭлементы() Цикл
				Идентификатор = Элемент.ПолучитьИдентификатор();
				Элементы.СписокПомеченныхНаУдаление.Развернуть(Идентификатор, Ложь);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

// Изменяет доступность кнопок на форме в зависимости от
// текущей страницы и состояния реквизитов формы
//
&НаКлиенте
Процедура ДоступностьКнопок()
	
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ВыборРежимаУдаления Тогда
		Элементы.КомандаНазад.Доступность   = Ложь;
		Если РежимУдаления = "Полный" Тогда
			Элементы.КомандаДалее.Доступность   = Ложь;
			Элементы.КомандаУдалить.Доступность = Истина;
		ИначеЕсли РежимУдаления = "Выборочный" Тогда
			Элементы.КомандаДалее.Доступность 	= Истина;
			Элементы.КомандаУдалить.Доступность = Ложь;
		КонецЕсли;
	ИначеЕсли ТекущаяСтраница = Элементы.ПомеченныеНаУдаление Тогда
		Элементы.КомандаНазад.Доступность   = Истина;
		Элементы.КомандаДалее.Доступность   = Ложь;
		Элементы.КомандаУдалить.Доступность = Истина;
	ИначеЕсли ТекущаяСтраница = Элементы.ПричиныНевозможностиУдаления Тогда
		Элементы.КомандаНазад.Доступность   = Истина;
		Элементы.КомандаДалее.Доступность   = Ложь;
		Элементы.КомандаУдалить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает веть дерева в ветви СтрокиДерева по значениею Значние
// Если ветвь не найдена - создается новая
//
&НаСервере
Функция НайтиИлиДобавитьВетвьДерева(СтрокиДерева, Значение, Представление, Пометка)
	
	// Попытка найти существующую ветвь в СтрокиДерева без вложенных
	Ветвь = СтрокиДерева.Найти(Значение, "Значение", Ложь);
	
	Если Ветвь = Неопределено Тогда
		// Такой ветки нет, создадим новую
		Ветвь = СтрокиДерева.Добавить();
		Ветвь.Значение      = Значение;
		Ветвь.Представление = Представление;
		Ветвь.Пометка       = Пометка;
	КонецЕсли;
	
	Возврат Ветвь;
	
КонецФункции

&НаСервере
Функция НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокиДерева, Значение, Представление, НомерКартинки)
	// Попытка найти существующую ветвь в СтрокиДерева без вложенных
	Ветвь = СтрокиДерева.Найти(Значение, "Значение", Ложь);
	Если Ветвь = Неопределено Тогда
		// Такой ветки нет, создадим новую
		Ветвь = СтрокиДерева.Добавить();
		Ветвь.Значение      = Значение;
		Ветвь.Представление = Представление;
		Ветвь.НомерКартинки = НомерКартинки;
	КонецЕсли;

	Возврат Ветвь;
КонецФункции

// Заполняет дерево объектов помеченных на удаление
//
&НаСервере
Процедура ЗаполнениеДереваПомеченныхНаУдаление()
	
	// Заполнение дерева помеченных на удаление
	ДеревоПомеченных = РеквизитФормыВЗначение("СписокПомеченныхНаУдаление");
	
	ДеревоПомеченных.Строки.Очистить();
	
	// обработка помеченных
	МассивПомеченных = Обработки.УдалениеПомеченныхОбъектов.ПолучитьПомеченныеНаУдаление();
	
	Для Каждого МассивПомеченныхЭлемент Из МассивПомеченных Цикл
		ОбъектМетаданныхЗначение = МассивПомеченныхЭлемент.Метаданные().ПолноеИмя();
		ОбъектМетаданныхПредставление = МассивПомеченныхЭлемент.Метаданные().Представление();
		СтрокаОбъектаМетаданных = НайтиИлиДобавитьВетвьДерева(ДеревоПомеченных.Строки, ОбъектМетаданныхЗначение, ОбъектМетаданныхПредставление, Истина);
		НайтиИлиДобавитьВетвьДерева(СтрокаОбъектаМетаданных.Строки, МассивПомеченныхЭлемент, Строка(МассивПомеченныхЭлемент) + " - " + ОбъектМетаданныхПредставление, Истина);
	КонецЦикла;
	
	ДеревоПомеченных.Строки.Сортировать("Значение", Истина);
	
	Для Каждого СтрокаОбъектаМетаданных Из ДеревоПомеченных.Строки Цикл
		// создать представление для строк, отображающих ветвь объекта метаданных
		СтрокаОбъектаМетаданных.Представление = СтрокаОбъектаМетаданных.Представление + " (" + СтрокаОбъектаМетаданных.Строки.Количество() + ")";
	КонецЦикла;
	
	КоличествоУровнейПомеченныхНаУдаление = ДеревоПомеченных.Строки.Количество();
	
	ЗначениеВРеквизитФормы(ДеревоПомеченных, "СписокПомеченныхНаУдаление");
	
КонецПроцедуры

// Рекурсивная функция, снимающая / устанавливающая пометки
// для зависимых родительских и дочерних элементов
//
&НаКлиенте
Процедура УстановитьПометкуВСписке(Данные, Пометка, ПроверятьРодителя)
	
	// Устанавливаем подчиненным
	ЭлементыСтроки = Данные.ПолучитьЭлементы();
	
	Для Каждого Элемент Из ЭлементыСтроки Цикл
		Элемент.Пометка = Пометка;
		УстановитьПометкуВСписке(Элемент, Пометка, Ложь);
	КонецЦикла;
	
	// Проверяем родителя
	Родитель = Данные.ПолучитьРодителя();
	
	Если проверятьРодителя И Родитель <> Неопределено Тогда 
		ПроверитьРодителя(Родитель);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьРодителя(Родитель)
	ПометкаРодителя = Истина;
		ЭлементыСтроки = Родитель.ПолучитьЭлементы();
		Для Каждого Элемент Из ЭлементыСтроки Цикл
			Если Не Элемент.Пометка Тогда
				ПометкаРодителя = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Родитель.Пометка = ПометкаРодителя;
КонецПроцедуры


// Производит попытку удаления выбранных объектов
// Объекты, которые не были удалены показываются в отдельной таблице
//
&НаСервере
Функция УдалениеВыбранныхНаСервере(СообщениеОбОшибке, ТипыУдаленныхОбъектов)
	
	Удаляемые = Новый Массив;
	
	Если РежимУдаления = "Полный" Тогда
		// При полном удалении получаем весь список помеченных на удаление
		Удаляемые = Обработки.УдалениеПомеченныхОбъектов.ПолучитьПомеченныеНаУдаление();
	Иначе
		// Заполняем массив ссылками на выбранные элементы, помеченные на удаление
		КоллекцияСтрокМетаданных = СписокПомеченныхНаУдаление.ПолучитьЭлементы();
		Для Каждого СтрокаОбъектаМетаданных Из КоллекцияСтрокМетаданных Цикл
			КоллекцияСтрокСсылок = СтрокаОбъектаМетаданных.ПолучитьЭлементы();
			Для Каждого СтрокаСсылки Из КоллекцияСтрокСсылок Цикл
				Если СтрокаСсылки.Пометка Тогда
					Удаляемые.Добавить(СтрокаСсылки.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	КоличествоУдаляемых = Удаляемые.Количество();
	
	// Выполняем удаление
	Результат = Обработки.УдалениеПомеченныхОбъектов.УдалитьПомеченныеОбъекты(Удаляемые, ТипыУдаленныхОбъектов);
	
	Если Не Результат.Статус Тогда
		СообщениеОбОшибке = Результат.Значение;
		Возврат Ложь;
	КонецЕсли;
	
	Найденные   = Результат.Значение.Найденные;
	НеУдаленные = Результат.Значение.НеУдаленные;
	
	КоличествоНеУдаленныхОбъектов = НеУдаленные.Количество();
	
	// Создадим таблицу оставшихся (не удаленных) объектов
	ДеревоОставшихсяОбъектов.ПолучитьЭлементы().Очистить();
	
	Дерево = РеквизитФормыВЗначение("ДеревоОставшихсяОбъектов");
	
	Для Каждого Найденный Из Найденные Цикл
		НеУдаленный = Найденный[0];
		Ссылающийся = Найденный[1];
		ОбъектМетаданныхСсылающегося = Найденный[2].Представление();
		ОбъектМетаданныхНеУдаленногоЗначение = НеУдаленный.Метаданные().ПолноеИмя();
		ОбъектМетаданныхНеУдаленногоПредставление = НеУдаленный.Метаданные().Представление();
		//ветвь метаданного
		СтрокаОбъектаМетаданных = НайтиИлиДобавитьВетвьДереваСКартинкой(Дерево.Строки, ОбъектМетаданныхНеУдаленногоЗначение, ОбъектМетаданныхНеУдаленногоПредставление, 0);
		//ветвь не удаленного объекта
		СтрокаСсылкиНаНеУдаленныйОбъектБД = НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокаОбъектаМетаданных.Строки, НеУдаленный, Строка(НеУдаленный), 2);
		//ветвь ссылки на не удаленный объект
		НайтиИлиДобавитьВетвьДереваСКартинкой(СтрокаСсылкиНаНеУдаленныйОбъектБД.Строки, Ссылающийся, Строка(Ссылающийся) + " - " + ОбъектМетаданныхСсылающегося, 1);
	КонецЦикла;
	
	Дерево.Строки.Сортировать("Значение", Истина);
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоОставшихсяОбъектов");
	
	УдаленныхОбъектов = КоличествоУдаляемых - КоличествоНеУдаленныхОбъектов;
	
	Если УдаленныхОбъектов = 0 Тогда
		СтрокаРезультатов = НСтр("ru = 'Не удален ни один из объектов, так как в информационной базе существуют ссылки на удаляемые объекты'");
	Иначе
		СтрокаРезультатов = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Удаление помеченных объектов завершено.
							|Удалено объектов: %1.'"),
							Строка(УдаленныхОбъектов));
	КонецЕсли;
	
	Если КоличествоНеУдаленныхОбъектов > 0 Тогда
		СтрокаРезультатов = СтрокаРезультатов + Символы.ПС +
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалено объектов: %1.
							|Объекты не удалены для сохранения целостности информационной базы, т.к. на них еще имеются ссылки.
							|Нажмите ОК для просмотра списка оставшихся (не удаленных) объектов.'"),
				Строка(КоличествоНеУдаленныхОбъектов));
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции
