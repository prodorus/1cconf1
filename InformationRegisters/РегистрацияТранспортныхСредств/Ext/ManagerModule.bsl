﻿// Заполнение кодов экологических классов для транспортных средств
//
Функция ЗаполнитьКодыЭкологическихКлассов() Экспорт
	
	НаборЗаписей = РегистрыСведений.РегистрацияТранспортныхСредств.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	Для каждого СтрокаНабора Из НаборЗаписей Цикл
		Если Не ЗначениеЗаполнено(СтрокаНабора.ЭкологическийКласс) Тогда
			СтрокаНабора.ЭкологическийКласс = "0"				
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ШаблонОшибки = НСтр("ru = 'Не удалось установить код экологического класса для %1, рекомендуется установить самостоятельно'");
		ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонОшибки, СтрокаНабора.ОсновноеСредство);
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки);
	КонецПопытки;
	
КонецФункции
