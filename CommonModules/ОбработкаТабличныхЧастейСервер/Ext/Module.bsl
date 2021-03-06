// Проверяет, заполнена ли единица измерения мест. Она должна быть заполнено, если указано количество мест
// 
// Параметры:
//  ДанныеТабличнойЧасти - строка табличной части или табличная часть, в которой нужно проверить.
//    В табличной части должны быть колонки КоличествоМест и ЕдиницаИзмеренияМест
//  Объект - объект, в табличной части которого выполняется проверка
//  Отказ  - переменная, в которую при ошибке будет возвращено Истина
Процедура ПроверитьЗаполненаЕдиницаИзмеренияМест(ДанныеТабличнойЧасти, Объект, Отказ = Ложь) Экспорт
	
	ИмяТабличнойЧасти = ОбщегоНазначения.ПолучитьИмяТабличнойЧастиПоСсылкеНаСтроку(ДанныеТабличнойЧасти);
	ИмяСписка         = Объект.Метаданные().ТабличныеЧасти[ИмяТабличнойЧасти].Синоним;
	
	Если Объект[ИмяТабличнойЧасти] = ДанныеТабличнойЧасти Тогда
		// Передали табличную часть
		КоллекцияОбрабатываемыхСтрок = ДанныеТабличнойЧасти;
	Иначе
		// Передали строку табличной части
		КоллекцияОбрабатываемыхСтрок = Новый Массив;
		КоллекцияОбрабатываемыхСтрок.Добавить(ДанныеТабличнойЧасти);
	КонецЕсли;
	
	ОбразецСообщения = Нстр("ru = 'Не задана единица измерения мест, но указано количество мест в строке &НомерСтроки списка ""&ИмяСписка""'");
	Для Каждого СтрокаТабличнойЧасти Из КоллекцияОбрабатываемыхСтрок Цикл
	
		Если СтрокаТабличнойЧасти.КоличествоМест <> 0 И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест) Тогда
			
			ТекстСообщения = СтрЗаменить(ОбразецСообщения, "&НомерСтроки", "" + СтрокаТабличнойЧасти.НомерСтроки);
			ТекстСообщения = СтрЗаменить(ТекстСообщения,   "&ИмяСписка",   ИмяСписка);
			
			ИмяПоля = ИмяТабличнойЧасти + "["+ Объект[ИмяТабличнойЧасти].Индекс(СтрокаТабличнойЧасти) +"].ЕдиницаИзмеренияМест";
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект, ИмяПоля ,, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

// Процедура осуществляет удаление строк, в которых есть незаполненные обязательные поля
//
Процедура УдалитьНезаполненныеСтроки(ТаблицаДанных, ОбязательныеПоля) Экспорт

	СтруктураОбязательныхПолей = Новый Структура(ОбязательныеПоля);
	
	КоличествоСтрок = ТаблицаДанных.Количество();
	
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		
		ТекущаяСтрока = ТаблицаДанных[КоличествоСтрок - НомерСтроки];
		
		Для каждого ОбязательноеПоле Из СтруктураОбязательныхПолей Цикл
			Если НЕ ЗначениеЗаполнено(ТекущаяСтрока[ОбязательноеПоле.Ключ]) Тогда
				ТаблицаДанных.Удалить(ТекущаяСтрока);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры	

