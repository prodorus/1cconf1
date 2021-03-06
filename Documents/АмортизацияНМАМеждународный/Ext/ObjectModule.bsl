Перем мУдалятьДвижения;

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


Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = "	
	|ВЫБРАТЬ
	|	ТабЧасть.НематериальныйАктив,
	|	ТабЧасть.КоличествоВыпущеннойПродукции,
	|	ТабЧасть.МетодНачисленияАмортизации,
	|	СведенияСрезПоследних.НачислятьАмортизацию,
	|	СведенияСрезПоследних.ДатаПринятияКУчету,
	|	СведенияСрезПоследних.СрокПолезногоИспользования,
	|	СведенияСрезПоследних.СчетУчета,
	|	СведенияСрезПоследних.СчетЗатрат,
	|	СведенияСрезПоследних.СчетНачисленияАмортизации,
	|	СведенияСрезПоследних.СчетСниженияСтоимости,
	|	СведенияСрезПоследних.ЛиквидационнаяСтоимость,
	|	СведенияСрезПоследних.ДатаПринятияКУчету,
	|	СведенияСрезПоследних.КоэффициентУскорения,
	|	СведенияСрезПоследних.СрокПолезногоИспользования,
	|	СведенияСрезПоследних.ПредполагаемыйОбъемПродукции,
	|	СведенияСрезПоследних.СправедливаяСтоимость,
	|	СведенияСрезПоследних.ПервоначальнаяСтоимость,
	|	СведенияСрезПоследних.Субконто1,
	|	СведенияСрезПоследних.Субконто2,
	|	СведенияСрезПоследних.Субконто3,
	|	СведенияСрезПоследних.МетодНачисленияАмортизации,
	|	СведенияСрезПоследних.СуммаНачисленнойАмортизации,
	|	СведенияСрезПоследних.ЛиквидационнаяСтоимость,
	|	СведенияСрезПоследних.УбытокОтОбесценения
	|ИЗ
	|	Документ.АмортизацияНМАМеждународный.НематериальныеАктивы КАК ТабЧасть
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(&КонецМесяца) КАК СведенияСрезПоследних
	|		ПО СведенияСрезПоследних.НематериальныйАктив = ТабЧасть.НематериальныйАктив
	|
	|ГДЕ
	|	ТабЧасть.Ссылка = &Ссылка И
	|	(СведенияСрезПоследних.НачислятьАмортизацию)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("КонецМесяца", КонецМесяца(ПериодРегистрации));
	
	Выборка = Запрос.Выполнить().Выбрать();	
		
	Пока Выборка.Следующий() Цикл		
				
		ДатаУстановки = НачалоМесяца(Выборка.ДатаПринятияКУчету);
		ОставшеесяЧислоМесяцев = Выборка.СрокПолезногоИспользования - Окр((НачалоМесяца(ПериодРегистрации)-ДатаУстановки)/60/60/24/30,0);

		СчетУчета = Выборка.СчетУчета;
		СчетЗатрат = Выборка.СчетЗатрат;
		СчетНачисленияАмортизации = Выборка.СчетНачисленияАмортизации;
		СчетСниженияСтоимости = Выборка.СчетСниженияСтоимости;
		
		Сумма = 0;
		
		БухИтоги = Обработки.БухгалтерскиеИтоги.Создать();
		БухИтоги.РассчитатьИтоги("Международный", "НачальныйОстатокКт", "Сумма", "Счет,Субконто1", КонецМесяца(ПериодРегистрации), КонецМесяца(ПериодРегистрации), , СчетНачисленияАмортизации, ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы, , ,"Организация", Организация);
		СуммаНачисленнойРанееАмортизации = БухИтоги.ПолучитьИтог("СуммаНачальныйОстатокКт", "Счет,Субконто1", СчетНачисленияАмортизации, Выборка.НематериальныйАктив);
		
		Если Выборка.МетодНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный Тогда
			МассивСчетов = Новый Массив();
			МассивСчетов.Добавить(СчетУчета);
			МассивСчетов.Добавить(СчетНачисленияАмортизации);
			МассивСчетов.Добавить(СчетСниженияСтоимости);
			БухИтоги = Обработки.БухгалтерскиеИтоги.Создать();
			БухИтоги.РассчитатьИтоги("Международный", "КонечныйОстатокДт,КонечныйОстатокКт", "Сумма", "Счет,Субконто1", КонецМесяца(ПериодРегистрации), КонецМесяца(ПериодРегистрации), , МассивСчетов, ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы, , ,"Организация", Организация);
			Сумма = (БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокДт", "Счет,Субконто1", СчетУчета, Выборка.НематериальныйАктив) - 
					БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", СчетНачисленияАмортизации, Выборка.НематериальныйАктив) -
					БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", СчетСниженияСтоимости, Выборка.НематериальныйАктив) -
					Выборка.ЛиквидационнаяСтоимость) / ОставшеесяЧислоМесяцев;

		ИначеЕсли Выборка.МетодНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
			//определим дату, на которую нужно определить остаточную стоимость объекта
			//если объект принят к учету в этом году - то это дата принятия, а стоимость - первоначальная
			Если Год(Выборка.ДатаПринятияКУчету)=Год(ПериодРегистрации) Тогда
				ДатаБазыАмортизации = Выборка.ДатаПринятияКУчету
			Иначе
				//иначе - начало текущего года
			    ДатаБазыАмортизации = НачалоГода(ПериодРегистрации);
			КонецЕсли;
			//если объект переоценивался или модернизировался в текущем году, то - дата последней переоценки или модернизации, которую
			//получаем из регистра сведений об объекте ОС
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
		        |СведенияОбОбъекте.Период,
				|СведенияОбОбъекте.ПервоначальнаяСтоимость,
				|СведенияОбОбъекте.СправедливаяСтоимость
				|ИЗ
				|	РегистрСведений.НематериальныеАктивыМеждународныйУчет КАК СведенияОбОбъекте
                |ГДЕ
				|	СведенияОбОбъекте.НематериальныйАктив=&ТекущийНМА И
				|	СведенияОбОбъекте.МетодНачисленияАмортизации =&МетодАмортизации И
				|	СведенияОбОбъекте.Период<=&Дата");
			Запрос.УстановитьПараметр("ТекущийНМА",Выборка.НематериальныйАктив);
			Запрос.УстановитьПараметр("МетодАмортизации",Выборка.МетодНачисленияАмортизации);
			Запрос.УстановитьПараметр("Дата",КонецМесяца(ПериодРегистрации));
			СписокЗаписей = Запрос.Выполнить().Выгрузить();
			ПервСт = 0; СпрСт = 0;
			Для каждого СтрокаТЗ из СписокЗаписей Цикл
				Если ((НЕ (СтрокаТЗ.ПервоначальнаяСтоимость=ПервСт))
					ИЛИ (НЕ (СтрокаТЗ.СправедливаяСтоимость=СпрСт))) И 
					(Год(СтрокаТЗ.Период)= Год(ПериодРегистрации)) Тогда
					ПервСт = СтрокаТЗ.ПервоначальнаяСтоимость;
					СпрСт = СтрокаТЗ.СправедливаяСтоимость;
					ДатаБазыАмортизации = СтрокаТЗ.Период;
				КонецЕсли;
			КонецЦикла;
			ВыборкаНаДатуБазы = РегистрыСведений.НематериальныеАктивыМеждународныйУчет.ПолучитьПоследнее(ДатаБазыАмортизации, Новый Структура("НематериальныйАктив", Выборка.НематериальныйАктив));
			СчетУчетаНаДатуБазы = ВыборкаНаДатуБазы.СчетУчета;
			СчетАмортизацииНаДатуБазы = ВыборкаНаДатуБазы.СчетНачисленияАмортизации;
			СчетСниженияСтоимостиНаДатуБазы = ВыборкаНаДатуБазы.СчетСниженияСтоимости;

			//теперь рассчитываем остаток по данным учета, принимаемый за базу амортизации
			МассивСчетов = Новый Массив();
			МассивСчетов.Добавить(СчетУчетаНаДатуБазы);
			МассивСчетов.Добавить(СчетАмортизацииНаДатуБазы);
			МассивСчетов.Добавить(СчетСниженияСтоимостиНаДатуБазы);
			БухИтоги = Обработки.БухгалтерскиеИтоги.Создать();
			БухИтоги.РассчитатьИтоги("Международный", "КонечныйОстатокДт,КонечныйОстатокКт", "Сумма", "Счет,Субконто1", ДатаБазыАмортизации, ДатаБазыАмортизации, , МассивСчетов, ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы, , ,"Организация", Организация);
			Сумма = (БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокДт", "Счет,Субконто1", СчетУчетаНаДатуБазы, Выборка.НематериальныйАктив)-
					БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", СчетАмортизацииНаДатуБазы, Выборка.НематериальныйАктив) -
					БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", СчетСниженияСтоимостиНаДатуБазы, Выборка.НематериальныйАктив) ) * Выборка.КоэффициентУскорения * 12/Выборка.СрокПолезногоИспользования / (12 - Месяц(ДатаБазыАмортизации)+1);
        
		ИначеЕсли Выборка.МетодНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
			Если Выборка.ПредполагаемыйОбъемПродукции = 0 Тогда
				Сообщить("По объекту НМА '"+Выборка.НематериальныйАктив+"' амортизация не начислена:");
				Сообщить("	в регистре сведений не указан предполагаемый объем продукции");
			ИначеЕсли Выборка.КоличествоВыпущеннойПродукции >	Выборка.ПредполагаемыйОбъемПродукции Тогда
				Сообщить("По объекту НМА '"+Выборка.НематериальныйАктив+"' амортизация не начислена:");
				Сообщить("	в регистре сведений указан предполагаемый объем продукции "+Выборка.ПредполагаемыйОбъемПродукции+", в документе - больше: "+Выборка.КоличествоВыпущеннойПродукции);
			ИначеЕсли НЕ (Выборка.СправедливаяСтоимость = 0) Тогда
				Сумма = Выборка.СправедливаяСтоимость * Выборка.КоличествоВыпущеннойПродукции / Выборка.ПредполагаемыйОбъемПродукции;
			Иначе
				Сумма = Выборка.ПервоначальнаяСтоимость * Выборка.КоличествоВыпущеннойПродукции / Выборка.ПредполагаемыйОбъемПродукции;
			КонецЕсли;
		КонецЕсли;
		
		//Теперь проверим, не завышена ли по каким-либо причинам сумма амортизации - то есть она в любом случае
		//не должна превышать остаточную стоимость объекта по данным международного учета
		МассивСчетов = Новый Массив();
		МассивСчетов.Добавить(СчетУчета);
		МассивСчетов.Добавить(СчетНачисленияАмортизации);
		МассивСчетов.Добавить(СчетСниженияСтоимости);
		БухИтоги = Обработки.БухгалтерскиеИтоги.Создать();
		БухИтоги.РассчитатьИтоги("Международный", "КонечныйОстатокДт,КонечныйОстатокКт", "Сумма", "Счет,Субконто1", КонецМесяца(ПериодРегистрации), КонецМесяца(ПериодРегистрации), , МассивСчетов, ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы, , ,"Организация", Организация);
        ОстаточнаяСтоимость = БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокДт", "Счет,Субконто1", СчетУчета, Выборка.НематериальныйАктив)-
					БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", СчетНачисленияАмортизации, Выборка.НематериальныйАктив) -
					БухИтоги.ПолучитьИтог("СуммаКонечныйОстатокКт", "Счет,Субконто1", СчетСниженияСтоимости, Выборка.НематериальныйАктив);
		Сумма = Мин (Сумма, ОстаточнаяСтоимость);

		
		Если (ЗначениеЗаполнено(СчетЗатрат)) и (ЗначениеЗаполнено(СчетНачисленияАмортизации)) и (Сумма > 0) Тогда
			Движение = Движения.Международный.Добавить();
			Движение.Период = КонецМесяца(ПериодРегистрации);
			Движение.СчетДт = СчетЗатрат;
			Движение.СчетКт = СчетНачисленияАмортизации;
			Движение.Организация = Организация;
			Движение.Сумма = Сумма;
			Движение.Содержание = "Амортизация НМА";
			Движение.НомерЖурнала = "Рег";
			
			Для Ном = 1 по Движение.СчетДт.ВидыСубконто.Количество() Цикл
				Движение.СубконтоДт[Движение.СчетДт.ВидыСубконто[Ном-1].ВидСубконто] = Выборка["Субконто" + Ном];
			КонецЦикла;
			
			Если не Движение.СчетКт.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы,) = Неопределено Тогда
				Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоМеждународные.НематериальныеАктивы] = Выборка.НематериальныйАктив;
			КонецЕсли;
			
			// регистр НематериальныеАктивыМеждународныйУчет 
			Движение = Движения.НематериальныеАктивыМеждународныйУчет.Добавить();
			Движение.Период = КонецМесяца(ПериодРегистрации);
			Движение.НематериальныйАктив = Выборка.НематериальныйАктив;
			Движение.СчетУчета = Выборка.СчетУчета;
			Движение.СрокПолезногоИспользования = Выборка.СрокПолезногоИспользования;
			Движение.НачислятьАмортизацию = Выборка.НачислятьАмортизацию;
			Движение.МетодНачисленияАмортизации = Выборка.МетодНачисленияАмортизации;
			Движение.СчетНачисленияАмортизации = Выборка.СчетНачисленияАмортизации;
			Движение.СчетЗатрат = Выборка.СчетЗатрат;
			Движение.Субконто1 = Выборка.Субконто1;
			Движение.Субконто2 = Выборка.Субконто2;
			Движение.Субконто3 = Выборка.Субконто3;
			Движение.ПредполагаемыйОбъемПродукции = Выборка.ПредполагаемыйОбъемПродукции;
			Движение.ФактическийОбъемПродукции = Выборка.КоличествоВыпущеннойПродукции;
			Движение.СуммаНачисленнойАмортизации = Выборка.СуммаНачисленнойАмортизации + Сумма;
			Движение.ПервоначальнаяСтоимость = Выборка.ПервоначальнаяСтоимость;
			Движение.СправедливаяСтоимость = Выборка.СправедливаяСтоимость;
			Движение.ЛиквидационнаяСтоимость = Выборка.ЛиквидационнаяСтоимость;
			Движение.ДатаПринятияКУчету = Выборка.ДатаПринятияКУчету;
			Движение.СчетСниженияСтоимости = Выборка.СчетСниженияСтоимости;
			Движение.КоэффициентУскорения = Выборка.КоэффициентУскорения;
			Движение.УбытокОтОбесценения = Выборка.УбытокОтОбесценения;
		КонецЕсли;

	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью






