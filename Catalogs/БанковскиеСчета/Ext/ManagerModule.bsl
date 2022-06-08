﻿
Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		ЗаполнитьОграничениеВыбора(Параметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗаполнитьОграничениеВыбора(Параметры);
	
КонецПроцедуры

Процедура ЗаполнитьОграничениеВыбора(Параметры)
	
	ТребуемыеСвойства = Новый Структура("ОтдельныйСчетГОЗ, ГосударственныйКонтракт", Ложь, Неопределено);
	ЗаполнитьЗначенияСвойств(ТребуемыеСвойства, Параметры);
	
	Если ТребуемыеСвойства.ОтдельныйСчетГОЗ Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Параметры.Отбор, ТребуемыеСвойства);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьБанковскийСчетГосКонтрактаПоУмолчанию(Владелец, ГосударственныйКонтракт) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	БанковскиеСчета.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	НЕ БанковскиеСчета.ПометкаУдаления
	|	И БанковскиеСчета.Владелец = &Владелец
	|	И БанковскиеСчета.ОтдельныйСчетГОЗ
	|	И БанковскиеСчета.ГосударственныйКонтракт = &ГосударственныйКонтракт";
	
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ГосударственныйКонтракт", ГосударственныйКонтракт);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.БанковскийСчет;
	Иначе
		Результат = Справочники.БанковскиеСчета.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;

КонецФункции
