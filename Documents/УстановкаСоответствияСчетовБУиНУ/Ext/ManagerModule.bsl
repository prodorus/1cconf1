﻿
// Заполняет регистр сведений СоответствиеСчетовБУиНУ новыми соответствиями
//
Процедура СоздатьНовыеСоответствияСчетовБУиНУ(ПричинаДобавления) Экспорт
    
    ДокументУстановкаСоответствияСчетовБУиНУ = Документы.УстановкаСоответствияСчетовБУиНУ.СоздатьДокумент();
    
    Если ПричинаДобавления = "ДляВидаРасходовНИОКРПоПеречнюПравительстваРФ" Тогда
        // добавление соответствия счетов:
        // БУ: 20.01.1 НУ: 20.01.2 Вид: НИОКР по перечню правительства РФ
        // БУ: 23.01   НУ: 23.02   Вид: НИОКР по перечню правительства РФ
        // БУ: 25.01   НУ: 25.02   Вид: НИОКР по перечню правительства РФ
        // БУ: 26.01   НУ: 26.02   Вид: НИОКР по перечню правительства РФ
        // БУ: 28.01   НУ: 28.02   Вид: НИОКР по перечню правительства РФ
        // БУ: 29.01   НУ: 29.02   Вид: НИОКР по перечню правительства РФ
        
        Дата = '20120101';
        ДокументУстановкаСоответствияСчетовБУиНУ.Дата = Дата;
        ОсновноеПроизводствоНеОблагаемоеЕНВД        = ПланыСчетов.Хозрасчетный.ОсновноеПроизводствоНеОблагаемоеЕНВД;
        ВспомогательныеПроизводстваНеОблагаемоеЕНВД = ПланыСчетов.Хозрасчетный.ВспомогательныеПроизводстваНеОблагаемоеЕНВД;
        ОбщепроизводственныеРасходыНеОблагаемыеЕНВД = ПланыСчетов.Хозрасчетный.ОбщепроизводственныеРасходыНеОблагаемыеЕНВД;
        ОбщехозяйственныеРасходыНеОблагаемыеЕНВД    = ПланыСчетов.Хозрасчетный.ОбщехозяйственныеРасходыНеОблагаемыеЕНВД;
        БракВПроизводствеНеОблагаемоеЕНВД           = ПланыСчетов.Хозрасчетный.БракВПроизводствеНеОблагаемоеЕНВД;
        ОбслуживающиеПроизводстваНеОблагаемоеЕНВД   = ПланыСчетов.Хозрасчетный.ОбслуживающиеПроизводстваНеОблагаемоеЕНВД;
        
        ОсновноеПроизводствоНеОблагаемоеЕНВДСчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ, ВидЗатратНУ",
        ОсновноеПроизводствоНеОблагаемоеЕНВД, Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ),, КонецДня(Дата));
        Если ОсновноеПроизводствоНеОблагаемоеЕНВДСчетНУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = ОсновноеПроизводствоНеОблагаемоеЕНВД;
            Строка.СчетНУ = Планысчетов.Налоговый.КосвенныеРасходыОсновногоПроизводства;
            Строка.ВидЗатратНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
        ВспомогательныеПроизводстваНеОблагаемоеЕНВДСчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ, ВидЗатратНУ",
        ВспомогательныеПроизводстваНеОблагаемоеЕНВД, Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ),, КонецДня(Дата));
        Если ВспомогательныеПроизводстваНеОблагаемоеЕНВДСчетНУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = ВспомогательныеПроизводстваНеОблагаемоеЕНВД;
            Строка.СчетНУ = Планысчетов.Налоговый.КосвенныеРасходыВспомогательныхПроизводств;
            Строка.ВидЗатратНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
        ОбщепроизводственныеРасходыНеОблагаемыеЕНВДСчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ, ВидЗатратНУ",
        ОбщепроизводственныеРасходыНеОблагаемыеЕНВД, Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ),, КонецДня(Дата));
        Если ОсновноеПроизводствоНеОблагаемоеЕНВДСчетНУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = ОбщепроизводственныеРасходыНеОблагаемыеЕНВД;
            Строка.СчетНУ = Планысчетов.Налоговый.КосвенныеОбщепроизводственныеРасходы;
            Строка.ВидЗатратНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
        ОбщехозяйственныеРасходыНеОблагаемыеЕНВДСчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ, ВидЗатратНУ",
        ОбщехозяйственныеРасходыНеОблагаемыеЕНВД, Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ),, КонецДня(Дата));
        Если ОбщехозяйственныеРасходыНеОблагаемыеЕНВДСчетНУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = ОбщехозяйственныеРасходыНеОблагаемыеЕНВД;
            Строка.СчетНУ = Планысчетов.Налоговый.КосвенныеОбщехозяйственныеРасходы;
            Строка.ВидЗатратНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
        БракВПроизводствеНеОблагаемоеЕНВДСчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ, ВидЗатратНУ",
        БракВПроизводствеНеОблагаемоеЕНВД, Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ),, КонецДня(Дата));
        Если БракВПроизводствеНеОблагаемоеЕНВДСчетНУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = БракВПроизводствеНеОблагаемоеЕНВД;
            Строка.СчетНУ = Планысчетов.Налоговый.КосвенныеРасходыПоВыявленномуБраку;
            Строка.ВидЗатратНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
        ОбслуживающиеПроизводстваНеОблагаемоеЕНВДСчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ, ВидЗатратНУ",
        ОбслуживающиеПроизводстваНеОблагаемоеЕНВД, Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ),, КонецДня(Дата));
        Если ОбслуживающиеПроизводстваНеОблагаемоеЕНВДСчетНУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = ОбслуживающиеПроизводстваНеОблагаемоеЕНВД;
            Строка.СчетНУ = Планысчетов.Налоговый.КосвенныеРасходыОбслуживающихПроизводств;
            Строка.ВидЗатратНУ = Перечисления.ВидыРасходовНУ.НИОКРПоПеречнюПравительстваРФ;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
    КонецЕсли;
    
    Если ПричинаДобавления = "ДляСчета76_01_9" Тогда
        // добавление соответствия счетов:
        // БУ: 76.01.9 НУ: 97.21
        
        Дата = '20110101';
        ДокументУстановкаСоответствияСчетовБУиНУ.Дата = Дата;
        СтрахованиеБУ = ПланыСчетов.Хозрасчетный.ПлатежиПоПрочимВидамСтрахования;
        РБП_НУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ",СтрахованиеБУ),, КонецДня(Дата));
        Если РБП_НУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = СтрахованиеБУ;
            Строка.СчетНУ = ПланыСчетов.Налоговый.ПрочиеРасходыБудущихПериодов;
            Строка.Учитывается = Истина;
        КонецЕсли;
        
    КонецЕсли;
    
	// добавление соответствия для 08.11, 08.12 
	Если ПричинаДобавления = "ДляСчетовПоисковыхАктивов" Тогда
		Дата = '20120101';
        ДокументУстановкаСоответствияСчетовБУиНУ.Дата = Дата;
        СчетБУ = ПланыСчетов.Хозрасчетный.НематериальныеПоисковыеАктивы;
        РБП_НУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ",СтрахованиеБУ),, КонецДня(Дата));
        Если РБП_НУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = СчетБУ;
            Строка.СчетНУ = ПланыСчетов.Налоговый.НематериальныеПоисковыеАктивы;
            Строка.Учитывается = Истина;
		КонецЕсли;
		
        СчетБУ = ПланыСчетов.Хозрасчетный.МатериальныеПоисковыеАктивы;
        РБП_НУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
        Новый Структура("СчетБУ",СтрахованиеБУ),, КонецДня(Дата));
        Если РБП_НУ.Пустая() Тогда
            Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
            Строка.СчетБУ = СчетБУ;
            Строка.СчетНУ = ПланыСчетов.Налоговый.МатериальныеПоисковыеАктивы;
            Строка.Учитывается = Истина;
        КонецЕсли;
	КонецЕсли;
	
    Если ПричинаДобавления = "ДляСубсчетов69" Тогда
        // добавление соответствия счетов:
        // БУ: 69.02.3 НУ: 69.02.3
		// БУ: 69.02.4 НУ: 69.02.4
		// БУ: 69.02.5 НУ: 69.02.5
		// БУ: 69.02.6 НУ: 69.02.6
        
        Дата = '20120101';
        ДокументУстановкаСоответствияСчетовБУиНУ.Дата = Дата;
		
		СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп;
		СчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
		Новый Структура("СчетБУ",СчетБУ),, КонецДня(Дата));
		Если СчетНУ.Пустая() Тогда
			Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
			Строка.СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп;
			Строка.СчетНУ = ПланыСчетов.Налоговый.ПФР_доп;
			Строка.Учитывается = Истина;
		КонецЕсли;
		
		СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп_шахтеры;
		СчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
		Новый Структура("СчетБУ",СчетБУ),, КонецДня(Дата));
		Если СчетНУ.Пустая() Тогда
			Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
			Строка.СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп_шахтеры;
			Строка.СчетНУ = ПланыСчетов.Налоговый.ПФР_доп_шахтеры;
			Строка.Учитывается = Истина;
		КонецЕсли;
		
		СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп_ВредныеУсловияТруда;
		СчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
		Новый Структура("СчетБУ",СчетБУ),, КонецДня(Дата));
		Если СчетНУ.Пустая() Тогда
			Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
			Строка.СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп_ВредныеУсловияТруда;
			Строка.СчетНУ = ПланыСчетов.Налоговый.ПФР_доп_ВредныеУсловияТруда;
			Строка.Учитывается = Истина;
		КонецЕсли;
		
		СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп_ТяжелыеУсловияТруда;
		СчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
		Новый Структура("СчетБУ",СчетБУ),, КонецДня(Дата));
		Если СчетНУ.Пустая() Тогда
			Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
			Строка.СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_доп_ТяжелыеУсловияТруда;
			Строка.СчетНУ = ПланыСчетов.Налоговый.ПФР_доп_ТяжелыеУсловияТруда;
			Строка.Учитывается = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
    Если ПричинаДобавления = "ДляСубсчетов69_ОПС" Тогда
        // добавление соответствия счетов:
        // БУ: 69.02.7 НУ: 69.02.7
        
        Дата = '20140101';
        ДокументУстановкаСоответствияСчетовБУиНУ.Дата = Дата;
		
		СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_ОПС;
		СчетНУ = БухгалтерскийУчет.ПреобразоватьСчетаБУвСчетНУ(
		Новый Структура("СчетБУ",СчетБУ),, КонецДня(Дата));
		Если СчетНУ.Пустая() Тогда
			Строка = ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Добавить();
			Строка.СчетБУ = ПланыСчетов.Хозрасчетный.ПФР_ОПС;
			Строка.СчетНУ = ПланыСчетов.Налоговый.ПФР_ОПС;
			Строка.Учитывается = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ДокументУстановкаСоответствияСчетовБУиНУ.СоответствиеСчетовБУиНУ.Количество() = 0 Тогда
        Возврат;
    КонецЕсли;
    
    ДокументУстановкаСоответствияСчетовБУиНУ.УстановитьНовыйНомер();
    
    Попытка
        ДокументУстановкаСоответствияСчетовБУиНУ.Записать(РежимЗаписиДокумента.Запись);
    Исключение
        Возврат;
    КонецПопытки;
    
    Попытка
        ДокументУстановкаСоответствияСчетовБУиНУ.Записать(РежимЗаписиДокумента.Проведение);
    Исключение
    КонецПопытки;
    
КонецПроцедуры

