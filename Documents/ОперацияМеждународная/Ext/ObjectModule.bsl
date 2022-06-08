﻿////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	ЭтоНовыйДокумент = Ссылка.Пустая();

	Если ЭтоНовыйДокумент Тогда
		РанееУстановленнаяПометкаУдаления = Ложь;

	Иначе
		Запрос = Новый Запрос();
		Запрос.Текст ="
		|ВЫБРАТЬ 
		|	0 
		|ИЗ
		|	Документ.ОперацияМеждународная КАК Операция
		|
		|ГДЕ
		|	(Операция.Ссылка = &СсылкаНаОперацию) И
		|	(Операция.ПометкаУдаления = Ложь)";

		Запрос.УстановитьПараметр("СсылкаНаОперацию", Ссылка); 
		Результат = Запрос.Выполнить();
		РанееУстановленнаяПометкаУдаления = Результат.Пустой();

	КонецЕсли;

	Если ПометкаУдаления <> РанееУстановленнаяПометкаУдаления Тогда

		ПроводкиДокумента = Движения.Международный;

		Если (НЕ ПроводкиДокумента.Модифицированность()) И 
				(НЕ ПроводкиДокумента.Выбран()) И
				(НЕ ЭтоНовыйДокумент) Тогда

			ПроводкиДокумента.Прочитать();

		КонецЕсли;

		КоличествоПроводок = ПроводкиДокумента.Количество();

		Если КоличествоПроводок > 0 Тогда

			// Определяем текущую активность проводок по первой проводке
			ТекущаяАктивностьПроводок = ПроводкиДокумента[0].Активность;
			НужнаяАктивностьПроводок  = НЕ ПометкаУдаления;

			Если ТекущаяАктивностьПроводок <> НужнаяАктивностьПроводок Тогда
				ПроводкиДокумента.УстановитьАктивность(НужнаяАктивностьПроводок);
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

