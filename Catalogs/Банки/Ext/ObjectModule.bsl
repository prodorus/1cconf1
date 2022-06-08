﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа И НЕ ОбменДанными.Загрузка Тогда
	
		СтрокаОшибки = "Элемент справочника ""Банки"" " + Наименование + " не записан!";
		
		Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(КоррСчет) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("В составе Корр.счета банка должны быть только цифры без пробелов.",, СтрокаОшибки);
			Отказ = Истина;
		КонецЕсли; 
	
		Если НЕ ОбщегоНазначения.ТолькоЦифрыВСтроке(Код) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("В составе БИК банка должны быть только цифры без пробелов.",, СтрокаОшибки);
			Отказ = Истина;
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

