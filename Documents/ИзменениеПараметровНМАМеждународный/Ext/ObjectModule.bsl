﻿Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
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
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
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


Процедура ОбработкаПроведения(Отказ)
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Для Каждого ТекСтрокаНематериальныеАктивы Из НематериальныеАктивы Цикл
		СрезСведенийМежд = РегистрыСведений.НематериальныеАктивыМеждународныйУчет.ПолучитьПоследнее(Дата, Новый Структура("НематериальныйАктив", ТекСтрокаНематериальныеАктивы.НематериальныйАктив));
		
		// регистр НематериальныеАктивыМеждународныйУчет 
		Движение = Движения.НематериальныеАктивыМеждународныйУчет.Добавить();
		Движение.Период = Дата;
		Движение.НематериальныйАктив = ТекСтрокаНематериальныеАктивы.НематериальныйАктив;
		Движение.СчетУчета = СрезСведенийМежд.СчетУчета;
		Движение.СрокПолезногоИспользования = ТекСтрокаНематериальныеАктивы.СрокПолезногоИспользованияНов;
		Движение.НачислятьАмортизацию = ТекСтрокаНематериальныеАктивы.НачислятьАмортизациюНов;
		Движение.МетодНачисленияАмортизации = ТекСтрокаНематериальныеАктивы.МетодНачисленияАмортизацииНов;
		Движение.СчетНачисленияАмортизации = СрезСведенийМежд.СчетНачисленияАмортизации;
		Движение.СчетЗатрат = ТекСтрокаНематериальныеАктивы.СчетЗатратНов;
		Движение.Субконто1 = ТекСтрокаНематериальныеАктивы.Субконто1Нов;
		Движение.Субконто2 = ТекСтрокаНематериальныеАктивы.Субконто2Нов;
		Движение.Субконто3 = ТекСтрокаНематериальныеАктивы.Субконто3Нов;
		Движение.ПредполагаемыйОбъемПродукции = ТекСтрокаНематериальныеАктивы.ПредполагаемыйОбъемПродукцииНов;
		Движение.ФактическийОбъемПродукции = СрезСведенийМежд.ФактическийОбъемПродукции;
		Движение.СуммаНачисленнойАмортизации = СрезСведенийМежд.СуммаНачисленнойАмортизации;
		Движение.ПервоначальнаяСтоимость = СрезСведенийМежд.ПервоначальнаяСтоимость;
		Движение.СправедливаяСтоимость = СрезСведенийМежд.СправедливаяСтоимость;
		Движение.ЛиквидационнаяСтоимость = СрезСведенийМежд.ЛиквидационнаяСтоимость;
		Движение.ДатаПринятияКУчету = СрезСведенийМежд.ДатаПринятияКУчету;
		Движение.СчетСниженияСтоимости = СрезСведенийМежд.СчетСниженияСтоимости;
		Движение.УбытокОтОбесценения = СрезСведенийМежд.УбытокОтОбесценения;
	КонецЦикла;
	
	// записываем движения регистров
	Движения.НематериальныеАктивыМеждународныйУчет.Записать();
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью



