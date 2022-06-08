﻿
Процедура ЗаполнитьСпособФЛК() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТорговоеОборудование.Ссылка
	|ИЗ
	|	Справочник.ТорговоеОборудование КАК ТорговоеОборудование
	|ГДЕ
	|	ТорговоеОборудование.ОбработкаОбслуживания.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыТорговогоОборудования.ККТ)
	|	И ТорговоеОборудование.СпособФЛК = ЗНАЧЕНИЕ(Перечисление.СпособыФорматоЛогическогоКонтроля.ПустаяСсылка)";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТО = Выборка.Ссылка.ПолучитьОбъект();
		ТО.СпособФЛК = ПредопределенноеЗначение("Перечисление.СпособыФорматоЛогическогоКонтроля.НеКонтролировать");
		ТО.ДопустимоеРасхождениеФЛК = 0.01;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТО, Истина);
	КонецЦикла;
КонецПроцедуры
