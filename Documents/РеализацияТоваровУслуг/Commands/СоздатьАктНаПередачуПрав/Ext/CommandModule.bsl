
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийРеализацияТоваров.АктНаПередачуПрав"));
	ОткрытьФорму("Документ.РеализацияТоваровУслуг.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры
