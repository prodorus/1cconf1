﻿// Обработчик события ПередЗаписью .
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли;
	
	Если Коэффициент = 0 Тогда
		//ОбщегоНазначения.СообщитьОбОшибке("Для транспортной упаковки: " + Наименование + " не задан коэффициент! Он будет установлен равным 1.");
		Коэффициент = 1;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()
