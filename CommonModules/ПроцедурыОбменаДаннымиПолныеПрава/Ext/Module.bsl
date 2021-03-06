
// ОБМЕН ДАННЫМИ

Процедура ВыполнитьОбменДаннымиПоНастройкеАвтоматическогоОбменаПодПолнымиПравамиНаСервере(НастройкаОбменаДанными, РучнойЗапускОбменов = Истина, 
	ОбработкаАвтообменаНаКлиенте = Неопределено, Знач СоответствиеТекстовЭлектронныхПисем = Неопределено, Знач ОбменПриВходеВПрограмму = Ложь) Экспорт
	
	ПроцедурыОбменаДанными.ВыполнитьОбменПоНастройкеАвтоматическогоОбмена(НастройкаОбменаДанными, РучнойЗапускОбменов, 
		ОбработкаАвтообменаНаКлиенте, СоответствиеТекстовЭлектронныхПисем, ОбменПриВходеВПрограмму);
	
КонецПроцедуры

Процедура ВыполнитьОбменДаннымиПоНастройкеОбменаПодПолнымиПравамиНаСервере(НастройкаОбменаДанными, РучнойЗапускОбменов = Истина, 
	ОбработкаАвтообменаНаКлиенте = Неопределено, Знач СоответствиеТекстовЭлектронныхПисем = Неопределено, Знач ОбменПриВходеВПрограмму = Ложь) Экспорт
	
	ПроцедурыОбменаДанными.ВыполнитьОбменПоНастройке(НастройкаОбменаДанными, РучнойЗапускОбменов, 
		ОбработкаАвтообменаНаКлиенте, СоответствиеТекстовЭлектронныхПисем, ОбменПриВходеВПрограмму);
	
КонецПроцедуры

Процедура ВыполнитьОтложенныеДвиженияПоНастройкеОбменаПодПолнымиПравамиНаСервере(НастройкаОбменаДанными) Экспорт
	
	ПроцедурыОбменаДанными.ВыполнитьОтложенныеДвиженияПоНастройкеОбмена(НастройкаОбменаДанными);
	
КонецПроцедуры	

Функция ВыполнитьОтложенныеДвиженияПоПараметрамПодПолнымиПравамиНаСервере(УзелОбмена, 
	ПрекратитьПроведениеДокументовВСлучаеОшибки, КоличествоОшибокОбменаДляПрекращенияПроведения) Экспорт
	
	СтрокаРезультата = ПроцедурыОбменаДанными.ВыполнитьОтложенныеДвиженияПоПараметрам(УзелОбмена, 
		ПрекратитьПроведениеДокументовВСлучаеОшибки, КоличествоОшибокОбменаДляПрекращенияПроведения);	
		
	Возврат СтрокаРезультата;
	
КонецФункции