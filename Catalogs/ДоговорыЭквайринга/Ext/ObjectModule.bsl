﻿// Обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ)

	Если Не ОбменДанными.Загрузка Тогда
		Если НЕ ЗначениеЗаполнено(Эквайрер) Тогда
			#Если Клиент Тогда
			РаботаСДиалогами.СообщитьПользователюНезаполненРеквизит(Ссылка, "Эквайрер");
			#КонецЕсли
			Отказ = Истина;
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(ДоговорВзаиморасчетов) Тогда
			#Если Клиент Тогда
			РаботаСДиалогами.СообщитьПользователюНезаполненРеквизит(Ссылка, "ДоговорВзаиморасчетов");
			#КонецЕсли
			Отказ = Истина;
		КонецЕсли;

		Заголовок = "Справочник ""Договоры эквайринга"": ";

		СтруктураОбязательныхПолей = Новый Структура("ВидОплаты");
		ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "ТарифыЗаРасчетноеОбслуживание", СтруктураОбязательныхПолей, Отказ, Заголовок);

		ПредставлениеТабличнойЧасти = Метаданные().ТабличныеЧасти["ТарифыЗаРасчетноеОбслуживание"].Представление();

		СтрокаОкончанияСообщенияОбОшибке = "Выбран вид оплаты неверного типа!";

		Для Каждого СтрокаТарифа Из ТарифыЗаРасчетноеОбслуживание Цикл
			Если СтрокаТарифа.ВидОплаты.ТипОплаты <> Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта Тогда
				СтрокаНачалаСообщенияОбОшибке = "В строке номер """+ СокрЛП(СтрокаТарифа.НомерСтроки)
				   + """ табличной части """ + ПредставлениеТабличнойЧасти + """: ";
				ОбщегоНазначения.СообщитьОбОшибке(СтрокаНачалаСообщенияОбОшибке + СтрокаОкончанияСообщенияОбОшибке,
				                    Отказ, Заголовок);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры // ПередЗаписью()


