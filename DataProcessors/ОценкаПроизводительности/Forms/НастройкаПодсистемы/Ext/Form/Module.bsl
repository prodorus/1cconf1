
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьНастройки(ВыполнятьЗамерыПроизводительности);
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройки(ВыполнятьЗамеры)
	
	Константы.ВыполнятьЗамерыПроизводительности.Установить(ВыполнятьЗамеры);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВыполнятьЗамерыПроизводительности = Константы.ВыполнятьЗамерыПроизводительности.Получить();
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры
