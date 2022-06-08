﻿
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СотрудникиОрганизацийПереопределяемый.ОбработкаПолученияДанныхВыбораДополнительно(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

// Функция формирует уникальный номер трудового договора
// уникальность в пределах года
// 
Функция ПолучитьНомерТрудовогоДоговора(Организация, ВидДоговора, ДатаДоговора, НомерДоговора) Экспорт
	
	Если Организация.Пустая() Тогда
		Возврат НомерДоговора;
	КонецЕсли;
	
	ВидыДоговоров	= Новый Массив;
	ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор);

	СотрудникиОрганизацийПереопределяемый.ДополнитьВидыДоговоровДляПолученияНомера(ВидыДоговоров);

	Если ВидыДоговоров.Найти(ВидДоговора) = Неопределено Тогда
		Возврат НомерДоговора;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ДатаДоговораДляЗапроса = ?(ЗначениеЗаполнено(ДатаДоговора), ДатаДоговора, ОбщегоНазначенияЗК.ПолучитьРабочуюДату());
	
	Запрос.УстановитьПараметр("парамОрганизация",Организация);
	Запрос.УстановитьПараметр("парамНачалоГода" ,НачалоГода(НачалоДня(ДатаДоговораДляЗапроса)));
	Запрос.УстановитьПараметр("парамКонецГода"  ,КонецГода(КонецДня(ДатаДоговораДляЗапроса)));
	Запрос.УстановитьПараметр("парамВидДоговора" ,ВидДоговора);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	МАКСИМУМ(СотрудникиОрганизаций.НомерДоговора) КАК НомерДок
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Организация = &парамОрганизация
	|	И СотрудникиОрганизаций.ВидДоговора = &парамВидДоговора
	|	И СотрудникиОрганизаций.ДатаДоговора МЕЖДУ &парамНачалоГода И &парамКонецГода";
	
	Запрос.Текст = ТекстЗапроса;
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Организация.Префикс + "0000001";
	Иначе
		
		СтрокаРезультата = Запрос.Выполнить().Выгрузить()[0];
		Если НЕ ЗначениеЗаполнено(СтрокаРезультата.НомерДок) Тогда
			Возврат Организация.Префикс + "0000001";
		Иначе
			Возврат ПроцедурыУправленияПерсоналом.ПолучитьСледующийНомер(СокрП(СтрокаРезультата.НомерДок));
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции // ПолучитьНомерТрудовогоДоговора()

Процедура ПроверитьНомерТрудовогоДоговора(Организация, ВидДоговора, НачальнаяДатаДокумента, ДатаДоговора, НомерДоговора) Экспорт
	
	//определяем разность старой и новой даты договора
	РазностьДат = НачалоГода(НачальнаяДатаДокумента) - НачалоГода(ДатаДоговора);
	
	Если РазностьДат <> 0 Тогда
		НомерДоговора = ПолучитьНомерТрудовогоДоговора(Организация, ВидДоговора, ДатаДоговора, НомерДоговора);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьНомерТрудовогоДоговора() 
