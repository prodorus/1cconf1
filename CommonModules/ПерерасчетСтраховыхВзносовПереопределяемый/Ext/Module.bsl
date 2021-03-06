
// заполнение доходов и расчет документа
//
Процедура АвтозаполнениеДоходов(ДокументОбъект, ВыборкаПоШапкеДокумента, ОграничениеНаСотрудников, Отказ) Экспорт
	
	Если ДокументОбъект.ПериодРегистрации < '20180101' Тогда
		АвтозаполнениеДоходовДо2018(ДокументОбъект, ВыборкаПоШапкеДокумента, ОграничениеНаСотрудников, Отказ);
		Возврат;
	КонецЕсли;

	Если ОграничениеНаСотрудников.Количество() = 0 Тогда // пересматривать данные не у кого
		ДокументОбъект.СведенияОДоходах.Очистить();
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ОграничениеНаСотрудников);
	Запрос.УстановитьПараметр("Организация", ВыборкаПоШапкеДокумента.Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудников.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТСписокСотрудников
	|ИЗ
	|	&ТаблицаСотрудников КАК ТаблицаСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.Физлицо
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо В
	|			(ВЫБРАТЬ
	|				СписокСотрудников.ФизЛицо
	|			ИЗ
	|				ВТСписокСотрудников КАК СписокСотрудников)
	|	И СотрудникиОрганизаций.Организация = &Организация";
	ОграничениеНаСотрудников = Запрос.Выполнить().Выгрузить();
	
	ТаблицаДоходов = ДокументОбъект.СведенияОДоходах.ВыгрузитьКолонки();
	НаборЗаписей = РегистрыНакопления.СтраховыеВзносыСведенияОДоходах.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	
	ДокОбъект = Документы.РасчетСтраховыхВзносов.СоздатьДокумент();
	ДокОбъект.Организация = ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;
	ДокОбъект.Дата = ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
	ДокОбъект.УстановитьНовыйНомер();
	ДокОбъект.УстановитьСсылкуНового(Документы.РасчетСтраховыхВзносов.ПолучитьСсылку());
	
	ОписаниеДокумента = Новый Структура;
	ОписаниеДокумента.Вставить("Организация",				ВыборкаПоШапкеДокумента.Организация);
	ОписаниеДокумента.Вставить("ОбособленноеПодразделение",	ВыборкаПоШапкеДокумента.ОбособленноеПодразделение);
	ОписаниеДокумента.Вставить("Ссылка",					ДокОбъект.Ссылка);
	ОписаниеДокумента.Вставить("Год",						ВыборкаПоШапкеДокумента.РасчетныйПериод);
	
    Для СчМесяцев = 1 По Месяц(ВыборкаПоШапкеДокумента.ПериодРегистрации) Цикл
		
		ТекущийПериод = Дата(ВыборкаПоШапкеДокумента.РасчетныйПериод, СчМесяцев, 1);
		ОписаниеДокумента.Вставить("Период", ТекущийПериод);
		ОписаниеДокумента.Вставить("ПериодРегистрации", ТекущийПериод);
		ДокОбъект.ПериодРегистрации = ТекущийПериод;
		
		НачатьТранзакцию();
		
		ДокОбъект.Записать();
		РасчетСтраховыхВзносовПереопределяемый.Автозаполнение(ДокОбъект, ОписаниеДокумента, ОграничениеНаСотрудников, Отказ, Ложь);
		
		ОтменитьТранзакцию();
		
		Если Отказ Тогда
			Возврат
		КонецЕсли;
		
		РасчетСтраховыхВзносовПереопределяемый.СформироватьДвиженияПоДоходам(ДокОбъект, ОписаниеДокумента, "", Отказ, НаборЗаписей);	
		Если Отказ Тогда
			Возврат
		КонецЕсли;
		
		ОбщегоНазначенияЗК.ЗагрузитьВТаблицуЗначений(НаборЗаписей,ТаблицаДоходов);
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("ДанныеУчета", НаборЗаписей);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	"""" КАК ТипСтроки,
		|	ДополнительныеНачисления.НомерСтроки,
		|	ДополнительныеНачисления.ВидРасчета,
		|	ДополнительныеНачисления.ВидДохода,
		|	ДополнительныеНачисления.ОблагаетсяЕНВД,
		|	ДополнительныеНачисления.ОблагаетсяПоДополнительномуТарифу,
		|	ДополнительныеНачисления.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
		|	ДополнительныеНачисления.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	ДополнительныеНачисления.КлассУсловийТруда,
		|	ДополнительныеНачисления.ЯвляетсяДоходомФармацевта,
		|	ДополнительныеНачисления.ЛьготныйТерриториальныйТариф,
		|	ДополнительныеНачисления.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
		|	ДополнительныеНачисления.ДатаПолученияДохода КАК ПериодДействияНачало,
		|	ВЫБОР
		|		КОГДА ДополнительныеНачисления.Результат < 0
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Сторно,
		|	ДополнительныеНачисления.Физлицо КАК Физлицо,
		|	ДополнительныеНачисления.Результат КАК Результат,
		|	ДополнительныеНачисления.Скидка,
		|	ДополнительныеНачисления.ДокументОснование
		|ПОМЕСТИТЬ ВТДополнительныеНачисления
		|ИЗ
		|	&ДанныеУчета КАК ДополнительныеНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.ТипСтроки,
		|	Начисления.НомерСтроки,
		|	Начисления.ВидРасчета,
		|	Начисления.ВидДохода,
		|	Начисления.ОблагаетсяЕНВД,
		|	Начисления.ОблагаетсяПоДополнительномуТарифу,
		|	Начисления.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
		|	Начисления.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	Начисления.КлассУсловийТруда,
		|	Начисления.ЯвляетсяДоходомФармацевта,
		|	Начисления.ЛьготныйТерриториальныйТариф,
		|	Начисления.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
		|	Начисления.ПериодДействияНачало,
		|	Начисления.Сторно,
		|	Начисления.Физлицо,
		|	Начисления.Результат,
		|	Начисления.Скидка,
		|	Начисления.ДокументОснование
		|ПОМЕСТИТЬ ВТНачисления
		|ИЗ
		|	ВТДополнительныеНачисления КАК Начисления
		|ГДЕ
		|	Начисления.ВидДохода В
		|			(ВЫБРАТЬ
		|				СтраховыеВзносыСкидкиКДоходам.ВидДохода
		|			ИЗ
		|				РегистрСведений.СтраховыеВзносыСкидкиКДоходам КАК СтраховыеВзносыСкидкиКДоходам)";
		Результат = Запрос.Выполнить().Выгрузить();
		РассчитыватьСкидки = Результат[0].Количество > 0;
		Если РассчитыватьСкидки Тогда
			
			ВременнаяТаблица = НаборЗаписей.СкопироватьКолонки();
			РасчетСтраховыхВзносов.СформироватьДоходыВУчетеПоСтраховымВзносам(ВременнаяТаблица, Запрос.МенеджерВременныхТаблиц, ОписаниеДокумента, , Истина);
			ТаблицаКОбработке = ВременнаяТаблица.Скопировать(,"Физлицо,ВидДохода,ДатаПолученияДохода,Скидка");
			ТаблицаКОбработке.Свернуть("Физлицо,ВидДохода,ДатаПолученияДохода", "Скидка");
			
			Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			Запрос.УстановитьПараметр("ДанныеУчета", ТаблицаДоходов);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ДоходыПоМесяцам.ФизЛицо,
			|	ДоходыПоМесяцам.ВидДохода,
			|	ДоходыПоМесяцам.ДатаПолученияДохода,
			|	ДоходыПоМесяцам.Результат,
			|	ДоходыПоМесяцам.Скидка
			|ПОМЕСТИТЬ ВТДанныеУчета
			|ИЗ
			|	&ДанныеУчета КАК ДоходыПоМесяцам";
			Запрос.Выполнить();
			РасчетСтраховыхВзносов.РасчетСкидок(НачалоГода(ВыборкаПоШапкеДокумента.ПериодРегистрации), ТаблицаКОбработке, Запрос.МенеджерВременныхТаблиц);
			
			ОбщегоНазначенияЗК.ЗагрузитьВТаблицуЗначений(ДокОбъект.НеоблагаемыеСуммыДоходов.Выгрузить(),ТаблицаКОбработке);
			ТаблицаКОбработке.Свернуть("Физлицо,ВидДохода,ДатаПолученияДохода", "Скидка");
			
			РасчетСтраховыхВзносов.СформироватьДвиженияПоСкидкам(ТаблицаДоходов, ОписаниеДокумента, ТаблицаКОбработке, НаборЗаписей);
			
		КонецЕсли;
		
		НаборЗаписей.Очистить();
		
		ДокОбъект.ОсновныеНачисления.Очистить();
		ДокОбъект.ДополнительныеНачисления.Очистить();
		ДокОбъект.НеоблагаемыеСуммыДоходов.Очистить();
		ДокОбъект.ПособияПоСоциальномуСтрахованию.Очистить();
		ДокОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет.Очистить();
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ОграничениеНаСотрудников);
	Запрос.УстановитьПараметр("ОбособленноеПодразделение",	ВыборкаПоШапкеДокумента.ОбособленноеПодразделение);
	Запрос.УстановитьПараметр("Регистратор",	ВыборкаПоШапкеДокумента.Ссылка);
	Запрос.УстановитьПараметр("Организация", ВыборкаПоШапкеДокумента.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Дата(ВыборкаПоШапкеДокумента.РасчетныйПериод, 1, 1));
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецМесяца(ДокументОбъект.ПериодРегистрации));
	
	// добавляем данные о сдельном заработке
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудников.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТСписокСотрудников
	|ИЗ
	|	&ТаблицаСотрудников КАК ТаблицаСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОДоходах.Регистратор
	|ИЗ
	|	РегистрНакопления.СтраховыеВзносыСведенияОДоходах КАК СведенияОДоходах
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СдельныйНаряд КАК СдельныйНаряд
	|		ПО СведенияОДоходах.Регистратор = СдельныйНаряд.Ссылка
	|ГДЕ
	|	СведенияОДоходах.ФизЛицо В
	|			(ВЫБРАТЬ
	|				СписокСотрудников.ФизЛицо
	|			ИЗ
	|				ВТСписокСотрудников КАК СписокСотрудников)
	|	И СведенияОДоходах.Организация = &Организация
	|	И СведенияОДоходах.ОбособленноеПодразделение = &ОбособленноеПодразделение
	|	И СведенияОДоходах.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И НЕ СведенияОДоходах.ПоАктуПроверки
	|	И СдельныйНаряд.Ссылка ЕСТЬ НЕ NULL "; 
	
	СтруктураДвижений = Новый Структура("БУОсновныеНачисления, ЕСНОсновныеНачисления, СтраховыеВзносыСведенияОДоходах, ЕСНСведенияОДоходах");
	СтруктураДвижений.БУОсновныеНачисления = РегистрыРасчета.БУОсновныеНачисления.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.ЕСНОсновныеНачисления = РегистрыРасчета.ЕСНОсновныеНачисления.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.СтраховыеВзносыСведенияОДоходах = РегистрыНакопления.СтраховыеВзносыСведенияОДоходах.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.ЕСНСведенияОДоходах = РегистрыНакопления.ЕСНСведенияОДоходах.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.СтраховыеВзносыСведенияОДоходах.Индексы.Добавить("ФизЛицо");
	Выборка = Запрос.Выполнить().Выбрать();
	СтруктураПоиска = Новый Структура("ФизЛицо");
	Пока Выборка.Следующий() Цикл
		
		СдельныйНаряд = Выборка.Регистратор.ПолучитьОбъект();
		СтруктураШапкиДокумента = ОбщегоНазначенияЗК.СформироватьСтруктуруШапкиДокумента(СдельныйНаряд);
		СдельныйНаряд.ЗаполнитьЗначенияПеременныхВеденияУчета(СтруктураШапкиДокумента);
		СдельныйНаряд.ДвиженияРегистровБУиНУРегл(СтруктураДвижений, СтруктураШапкиДокумента, СдельныйНаряд.СформироватьЗапросПоИсполнителиРегл(СтруктураШапкиДокумента).Выбрать(), СдельныйНаряд.СформироватьЗапросПоВыработкаРегл().Выгрузить());
		
		Для каждого СтрокаТЗ Из ОграничениеНаСотрудников Цикл
		    ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТЗ);
			СтрокиДоходов = СтруктураДвижений.СтраховыеВзносыСведенияОДоходах.НайтиСтроки(СтруктураПоиска);
		    Для каждого СтрокаДоходов Из СтрокиДоходов Цикл
				СтрокаДоходов.ДатаПолученияДохода = НачалоДня(КонецМесяца(СтрокаДоходов.Период));
				ЗаполнитьЗначенияСвойств(ТаблицаДоходов.Добавить(),СтрокаДоходов)
			КонецЦикла;
		КонецЦикла;
		
		СтруктураДвижений.БУОсновныеНачисления.Очистить();
		СтруктураДвижений.ЕСНОсновныеНачисления.Очистить();
		СтруктураДвижений.СтраховыеВзносыСведенияОДоходах.Очистить();
		СтруктураДвижений.ЕСНСведенияОДоходах.Очистить();
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаДоходов", ТаблицаДоходов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтраховыеВзносыСведенияОДоходах.ФизЛицо,
	|	СтраховыеВзносыСведенияОДоходах.ВидДохода,
	|	СтраховыеВзносыСведенияОДоходах.ДатаПолученияДохода,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяЕНВД,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|	СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомФармацевта,
	|	СтраховыеВзносыСведенияОДоходах.ЛьготныйТерриториальныйТариф,
	|	СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	СтраховыеВзносыСведенияОДоходах.КлассУсловийТруда,
	|	СтраховыеВзносыСведенияОДоходах.Результат,
	|	СтраховыеВзносыСведенияОДоходах.Скидка,
	|	СтраховыеВзносыСведенияОДоходах.ВидРасчета
	|ПОМЕСТИТЬ ВТНовыеДоходы
	|ИЗ
	|	&ТаблицаДоходов КАК СтраховыеВзносыСведенияОДоходах
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеОДоходах.ФизЛицо КАК ФизЛицо,
	|	ДанныеОДоходах.ВидДохода КАК ВидДохода,
	|	ДанныеОДоходах.ДатаПолученияДохода КАК ДатаПолученияДохода,
	|	ДанныеОДоходах.ОблагаетсяЕНВД,
	|	ДанныеОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|	ДанныеОДоходах.ЯвляетсяДоходомФармацевта,
	|	ДанныеОДоходах.ЛьготныйТерриториальныйТариф,
	|	ДанныеОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	ДанныеОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	ДанныеОДоходах.КлассУсловийТруда,
	|	СУММА(ДанныеОДоходах.Результат) КАК Результат,
	|	СУММА(ДанныеОДоходах.Скидка) КАК Скидка,
	|	ДанныеОДоходах.ВидРасчета КАК ВидРасчета,
	|	ДанныеОДоходах.ФизЛицо.Наименование КАК ФизЛицоНаименование
	|ИЗ
	|	(ВЫБРАТЬ
	|		СведенияОДоходах.ФизЛицо КАК ФизЛицо,
	|		СведенияОДоходах.ВидДохода КАК ВидДохода,
	|		СведенияОДоходах.ДатаПолученияДохода КАК ДатаПолученияДохода,
	|		СведенияОДоходах.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|		СведенияОДоходах.ОблагаетсяПоДополнительномуТарифу КАК ОблагаетсяПоДополнительномуТарифу,
	|		СведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам КАК ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|		СведенияОДоходах.ЯвляетсяДоходомФармацевта КАК ЯвляетсяДоходомФармацевта,
	|		СведенияОДоходах.ЛьготныйТерриториальныйТариф КАК ЛьготныйТерриториальныйТариф,
	|		СведенияОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ КАК ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|		СведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией КАК ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|		СведенияОДоходах.КлассУсловийТруда КАК КлассУсловийТруда,
	|		-СведенияОДоходах.Результат КАК Результат,
	|		-СведенияОДоходах.Скидка КАК Скидка,
	|		СведенияОДоходах.ВидРасчета КАК ВидРасчета
	|	ИЗ
	|		РегистрНакопления.СтраховыеВзносыСведенияОДоходах КАК СведенияОДоходах
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.НДФЛиЕСНДоходыИНалоги КАК НДФЛиЕСНДоходыИНалоги
	|			ПО СведенияОДоходах.Регистратор = НДФЛиЕСНДоходыИНалоги.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереносДанных КАК ПереносДанных
	|			ПО СведенияОДоходах.Регистратор = ПереносДанных.Ссылка
	|	ГДЕ
	|		СведенияОДоходах.ФизЛицо В
	|				(ВЫБРАТЬ
	|					СписокСотрудников.ФизЛицо
	|				ИЗ
	|					ВТСписокСотрудников КАК СписокСотрудников)
	|		И СведенияОДоходах.Организация = &Организация
	|		И СведенияОДоходах.ОбособленноеПодразделение = &ОбособленноеПодразделение
	|		И СведенияОДоходах.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|		И НЕ СведенияОДоходах.ПоАктуПроверки
	|		И СведенияОДоходах.Регистратор <> &Регистратор
	|		И НДФЛиЕСНДоходыИНалоги.Ссылка ЕСТЬ NULL 
	|		И ПереносДанных.Ссылка ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтраховыеВзносыСведенияОДоходах.ФизЛицо,
	|		СтраховыеВзносыСведенияОДоходах.ВидДохода,
	|		СтраховыеВзносыСведенияОДоходах.ДатаПолученияДохода,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяЕНВД,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|		СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомФармацевта,
	|		СтраховыеВзносыСведенияОДоходах.ЛьготныйТерриториальныйТариф,
	|		СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|		СтраховыеВзносыСведенияОДоходах.КлассУсловийТруда,
	|		СтраховыеВзносыСведенияОДоходах.Результат,
	|		СтраховыеВзносыСведенияОДоходах.Скидка,
	|		СтраховыеВзносыСведенияОДоходах.ВидРасчета
	|	ИЗ
	|		ВТНовыеДоходы КАК СтраховыеВзносыСведенияОДоходах) КАК ДанныеОДоходах
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОДоходах.ФизЛицо,
	|	ДанныеОДоходах.ВидДохода,
	|	ДанныеОДоходах.ДатаПолученияДохода,
	|	ДанныеОДоходах.ОблагаетсяЕНВД,
	|	ДанныеОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|	ДанныеОДоходах.ЯвляетсяДоходомФармацевта,
	|	ДанныеОДоходах.ЛьготныйТерриториальныйТариф,
	|	ДанныеОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	ДанныеОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	ДанныеОДоходах.КлассУсловийТруда,
	|	ДанныеОДоходах.ВидРасчета,
	|	ДанныеОДоходах.ФизЛицо.Наименование
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДанныеОДоходах.Результат) <> 0
	|		ИЛИ СУММА(ДанныеОДоходах.Скидка) <> 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицоНаименование,
	|	ФизЛицо,
	|	ДатаПолученияДохода,
	|	ВидДохода,
	|	ВидРасчета";
	
	ДокументОбъект.СведенияОДоходах.Загрузить(Запрос.Выполнить().Выгрузить())
	
КонецПроцедуры 

// заполнение доходов и расчет документа до 2018 года
//
Процедура АвтозаполнениеДоходовДо2018(ДокументОбъект, ВыборкаПоШапкеДокумента, ОграничениеНаСотрудников, Отказ) Экспорт
	
	Если ОграничениеНаСотрудников.Количество() = 0 Тогда // пересматривать данные не у кого
		ДокументОбъект.СведенияОДоходах.Очистить();
		Возврат
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ОграничениеНаСотрудников);
	Запрос.УстановитьПараметр("Организация", ВыборкаПоШапкеДокумента.Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудников.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТСписокСотрудников
	|ИЗ
	|	&ТаблицаСотрудников КАК ТаблицаСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.Физлицо
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо В
	|			(ВЫБРАТЬ
	|				СписокСотрудников.ФизЛицо
	|			ИЗ
	|				ВТСписокСотрудников КАК СписокСотрудников)
	|	И СотрудникиОрганизаций.Организация = &Организация";
	ОграничениеНаСотрудников = Запрос.Выполнить().Выгрузить();
	
	ТаблицаДоходов = ДокументОбъект.СведенияОДоходах.ВыгрузитьКолонки();
	НаборЗаписей = РегистрыНакопления.СтраховыеВзносыСведенияОДоходах.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	
	ДокОбъект = Документы.РасчетСтраховыхВзносов.СоздатьДокумент();
	ДокОбъект.Организация = ВыборкаПоШапкеДокумента.ОбособленноеПодразделение;
	ДокОбъект.Дата = ОбщегоНазначенияЗК.ПолучитьРабочуюДату();
	ДокОбъект.УстановитьНовыйНомер();
	ДокОбъект.УстановитьСсылкуНового(Документы.РасчетСтраховыхВзносов.ПолучитьСсылку());
	
	ОписаниеДокумента = Новый Структура;
	ОписаниеДокумента.Вставить("Организация",				ВыборкаПоШапкеДокумента.Организация);
	ОписаниеДокумента.Вставить("ОбособленноеПодразделение",	ВыборкаПоШапкеДокумента.ОбособленноеПодразделение);
	ОписаниеДокумента.Вставить("Ссылка",					ДокОбъект.Ссылка);
	ОписаниеДокумента.Вставить("Год",						ВыборкаПоШапкеДокумента.РасчетныйПериод);
	
    Для СчМесяцев = 1 По Месяц(ВыборкаПоШапкеДокумента.ПериодРегистрации) Цикл
		
		ТекущийПериод = Дата(ВыборкаПоШапкеДокумента.РасчетныйПериод, СчМесяцев, 1);
		ОписаниеДокумента.Вставить("Период", ТекущийПериод);
		ОписаниеДокумента.Вставить("ПериодРегистрации", ТекущийПериод);
		ДокОбъект.ПериодРегистрации = ТекущийПериод;
		
		НачатьТранзакцию();
		
		ДокОбъект.Записать();
		РасчетСтраховыхВзносовПереопределяемый.Автозаполнение(ДокОбъект, ОписаниеДокумента, ОграничениеНаСотрудников, Отказ, Ложь);
		
		ОтменитьТранзакцию();
		
		Если Отказ Тогда
			Возврат
		КонецЕсли;
		
		РасчетСтраховыхВзносовПереопределяемый.СформироватьДвиженияПоДоходам(ДокОбъект, ОписаниеДокумента, "", Отказ, НаборЗаписей);	
		Если Отказ Тогда
			Возврат
		КонецЕсли;
		
		ОбщегоНазначенияЗК.ЗагрузитьВТаблицуЗначений(НаборЗаписей,ТаблицаДоходов);
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("ДанныеУчета", НаборЗаписей);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	"""" КАК ТипСтроки,
		|	ДополнительныеНачисления.НомерСтроки,
		|	ДополнительныеНачисления.ВидРасчета,
		|	ДополнительныеНачисления.ВидДохода,
		|	ДополнительныеНачисления.ОблагаетсяЕНВД,
		|	ДополнительныеНачисления.ОблагаетсяПоДополнительномуТарифу,
		|	ДополнительныеНачисления.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
		|	ДополнительныеНачисления.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	ДополнительныеНачисления.КлассУсловийТруда,
		|	ДополнительныеНачисления.ЯвляетсяДоходомФармацевта,
		|	ДополнительныеНачисления.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
		|	ДополнительныеНачисления.ДатаПолученияДохода КАК ПериодДействияНачало,
		|	ВЫБОР
		|		КОГДА ДополнительныеНачисления.Результат < 0
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК Сторно,
		|	ДополнительныеНачисления.Физлицо КАК Физлицо,
		|	ДополнительныеНачисления.Результат КАК Результат,
		|	ДополнительныеНачисления.Скидка,
		|	ДополнительныеНачисления.ДокументОснование
		|ПОМЕСТИТЬ ВТДополнительныеНачисления
		|ИЗ
		|	&ДанныеУчета КАК ДополнительныеНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Начисления.ТипСтроки,
		|	Начисления.НомерСтроки,
		|	Начисления.ВидРасчета,
		|	Начисления.ВидДохода,
		|	Начисления.ОблагаетсяЕНВД,
		|	Начисления.ОблагаетсяПоДополнительномуТарифу,
		|	Начисления.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
		|	Начисления.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
		|	Начисления.КлассУсловийТруда,
		|	Начисления.ЯвляетсяДоходомФармацевта,
		|	Начисления.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
		|	Начисления.ПериодДействияНачало,
		|	Начисления.Сторно,
		|	Начисления.Физлицо,
		|	Начисления.Результат,
		|	Начисления.Скидка,
		|	Начисления.ДокументОснование
		|ПОМЕСТИТЬ ВТНачисления
		|ИЗ
		|	ВТДополнительныеНачисления КАК Начисления
		|ГДЕ
		|	Начисления.ВидДохода В
		|			(ВЫБРАТЬ
		|				СтраховыеВзносыСкидкиКДоходам.ВидДохода
		|			ИЗ
		|				РегистрСведений.СтраховыеВзносыСкидкиКДоходам КАК СтраховыеВзносыСкидкиКДоходам)";
		Результат = Запрос.Выполнить().Выгрузить();
		РассчитыватьСкидки = Результат[0].Количество > 0;
		Если РассчитыватьСкидки Тогда
			
			ВременнаяТаблица = НаборЗаписей.СкопироватьКолонки();
			РасчетСтраховыхВзносов.СформироватьДоходыВУчетеПоСтраховымВзносам(ВременнаяТаблица, Запрос.МенеджерВременныхТаблиц, ОписаниеДокумента, , Истина);
			ТаблицаКОбработке = ВременнаяТаблица.Скопировать(,"Физлицо,ВидДохода,ДатаПолученияДохода,Скидка");
			ТаблицаКОбработке.Свернуть("Физлицо,ВидДохода,ДатаПолученияДохода", "Скидка");
			
			Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			Запрос.УстановитьПараметр("ДанныеУчета", ТаблицаДоходов);
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ДоходыПоМесяцам.ФизЛицо,
			|	ДоходыПоМесяцам.ВидДохода,
			|	ДоходыПоМесяцам.ДатаПолученияДохода,
			|	ДоходыПоМесяцам.Результат,
			|	ДоходыПоМесяцам.Скидка
			|ПОМЕСТИТЬ ВТДанныеУчета
			|ИЗ
			|	&ДанныеУчета КАК ДоходыПоМесяцам";
			Запрос.Выполнить();
			РасчетСтраховыхВзносов.РасчетСкидок(НачалоГода(ВыборкаПоШапкеДокумента.ПериодРегистрации), ТаблицаКОбработке, Запрос.МенеджерВременныхТаблиц);
			
			ОбщегоНазначенияЗК.ЗагрузитьВТаблицуЗначений(ДокОбъект.НеоблагаемыеСуммыДоходов.Выгрузить(),ТаблицаКОбработке);
			ТаблицаКОбработке.Свернуть("Физлицо,ВидДохода,ДатаПолученияДохода", "Скидка");
			
			РасчетСтраховыхВзносов.СформироватьДвиженияПоСкидкам(ТаблицаДоходов, ОписаниеДокумента, ТаблицаКОбработке, НаборЗаписей);
			
		КонецЕсли;
		
		НаборЗаписей.Очистить();
		
		ДокОбъект.ОсновныеНачисления.Очистить();
		ДокОбъект.ДополнительныеНачисления.Очистить();
		ДокОбъект.НеоблагаемыеСуммыДоходов.Очистить();
		ДокОбъект.ПособияПоСоциальномуСтрахованию.Очистить();
		ДокОбъект.ПособияПоУходуЗаРебенкомДоПолутораЛет.Очистить();
		
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаСотрудников", ОграничениеНаСотрудников);
	Запрос.УстановитьПараметр("ОбособленноеПодразделение",	ВыборкаПоШапкеДокумента.ОбособленноеПодразделение);
	Запрос.УстановитьПараметр("Регистратор",	ВыборкаПоШапкеДокумента.Ссылка);
	Запрос.УстановитьПараметр("Организация", ВыборкаПоШапкеДокумента.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", Дата(ВыборкаПоШапкеДокумента.РасчетныйПериод, 1, 1));
	Запрос.УстановитьПараметр("ОкончаниеПериода", КонецМесяца(ДокументОбъект.ПериодРегистрации));
	
	// добавляем данные о сдельном заработке
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСотрудников.ФизЛицо КАК ФизЛицо
	|ПОМЕСТИТЬ ВТСписокСотрудников
	|ИЗ
	|	&ТаблицаСотрудников КАК ТаблицаСотрудников
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияОДоходах.Регистратор
	|ИЗ
	|	РегистрНакопления.СтраховыеВзносыСведенияОДоходах КАК СведенияОДоходах
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СдельныйНаряд КАК СдельныйНаряд
	|		ПО СведенияОДоходах.Регистратор = СдельныйНаряд.Ссылка
	|ГДЕ
	|	СведенияОДоходах.ФизЛицо В
	|			(ВЫБРАТЬ
	|				СписокСотрудников.ФизЛицо
	|			ИЗ
	|				ВТСписокСотрудников КАК СписокСотрудников)
	|	И СведенияОДоходах.Организация = &Организация
	|	И СведенияОДоходах.ОбособленноеПодразделение = &ОбособленноеПодразделение
	|	И СведенияОДоходах.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|	И НЕ СведенияОДоходах.ПоАктуПроверки
	|	И СдельныйНаряд.Ссылка ЕСТЬ НЕ NULL "; 
	
	СтруктураДвижений = Новый Структура("БУОсновныеНачисления, ЕСНОсновныеНачисления, СтраховыеВзносыСведенияОДоходах, ЕСНСведенияОДоходах");
	СтруктураДвижений.БУОсновныеНачисления = РегистрыРасчета.БУОсновныеНачисления.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.ЕСНОсновныеНачисления = РегистрыРасчета.ЕСНОсновныеНачисления.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.СтраховыеВзносыСведенияОДоходах = РегистрыНакопления.СтраховыеВзносыСведенияОДоходах.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.ЕСНСведенияОДоходах = РегистрыНакопления.ЕСНСведенияОДоходах.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	СтруктураДвижений.СтраховыеВзносыСведенияОДоходах.Индексы.Добавить("ФизЛицо");
	Выборка = Запрос.Выполнить().Выбрать();
	СтруктураПоиска = Новый Структура("ФизЛицо");
	Пока Выборка.Следующий() Цикл
		
		СдельныйНаряд = Выборка.Регистратор.ПолучитьОбъект();
		СтруктураШапкиДокумента = ОбщегоНазначенияЗК.СформироватьСтруктуруШапкиДокумента(СдельныйНаряд);
		СдельныйНаряд.ЗаполнитьЗначенияПеременныхВеденияУчета(СтруктураШапкиДокумента);
		СдельныйНаряд.ДвиженияРегистровБУиНУРегл(СтруктураДвижений, СтруктураШапкиДокумента, СдельныйНаряд.СформироватьЗапросПоИсполнителиРегл(СтруктураШапкиДокумента).Выбрать(), СдельныйНаряд.СформироватьЗапросПоВыработкаРегл().Выгрузить());
		
		Для каждого СтрокаТЗ Из ОграничениеНаСотрудников Цикл
		    ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаТЗ);
			СтрокиДоходов = СтруктураДвижений.СтраховыеВзносыСведенияОДоходах.НайтиСтроки(СтруктураПоиска);
		    Для каждого СтрокаДоходов Из СтрокиДоходов Цикл
				СтрокаДоходов.ДатаПолученияДохода = НачалоДня(КонецМесяца(СтрокаДоходов.Период));
				ЗаполнитьЗначенияСвойств(ТаблицаДоходов.Добавить(),СтрокаДоходов)
			КонецЦикла;
		КонецЦикла;
		
		СтруктураДвижений.БУОсновныеНачисления.Очистить();
		СтруктураДвижений.ЕСНОсновныеНачисления.Очистить();
		СтруктураДвижений.СтраховыеВзносыСведенияОДоходах.Очистить();
		СтруктураДвижений.ЕСНСведенияОДоходах.Очистить();
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТаблицаДоходов", ТаблицаДоходов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтраховыеВзносыСведенияОДоходах.ФизЛицо,
	|	СтраховыеВзносыСведенияОДоходах.ВидДохода,
	|	СтраховыеВзносыСведенияОДоходах.ДатаПолученияДохода,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяЕНВД,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|	СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомФармацевта,
	|	СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	СтраховыеВзносыСведенияОДоходах.КлассУсловийТруда,
	|	СтраховыеВзносыСведенияОДоходах.Результат,
	|	СтраховыеВзносыСведенияОДоходах.Скидка,
	|	СтраховыеВзносыСведенияОДоходах.ВидРасчета
	|ПОМЕСТИТЬ ВТНовыеДоходы
	|ИЗ
	|	&ТаблицаДоходов КАК СтраховыеВзносыСведенияОДоходах
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеОДоходах.ФизЛицо КАК ФизЛицо,
	|	ДанныеОДоходах.ВидДохода КАК ВидДохода,
	|	ДанныеОДоходах.ДатаПолученияДохода КАК ДатаПолученияДохода,
	|	ДанныеОДоходах.ОблагаетсяЕНВД,
	|	ДанныеОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|	ДанныеОДоходах.ЯвляетсяДоходомФармацевта,
	|	ДанныеОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	ДанныеОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	ДанныеОДоходах.КлассУсловийТруда,
	|	СУММА(ДанныеОДоходах.Результат) КАК Результат,
	|	СУММА(ДанныеОДоходах.Скидка) КАК Скидка,
	|	ДанныеОДоходах.ВидРасчета КАК ВидРасчета,
	|	ДанныеОДоходах.ФизЛицо.Наименование КАК ФизЛицоНаименование
	|ИЗ
	|	(ВЫБРАТЬ
	|		СведенияОДоходах.ФизЛицо КАК ФизЛицо,
	|		СведенияОДоходах.ВидДохода КАК ВидДохода,
	|		СведенияОДоходах.ДатаПолученияДохода КАК ДатаПолученияДохода,
	|		СведенияОДоходах.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|		СведенияОДоходах.ОблагаетсяПоДополнительномуТарифу КАК ОблагаетсяПоДополнительномуТарифу,
	|		СведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам КАК ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|		СведенияОДоходах.ЯвляетсяДоходомФармацевта КАК ЯвляетсяДоходомФармацевта,
	|		СведенияОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ КАК ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|		СведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией КАК ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|		СведенияОДоходах.КлассУсловийТруда КАК КлассУсловийТруда,
	|		-СведенияОДоходах.Результат КАК Результат,
	|		-СведенияОДоходах.Скидка КАК Скидка,
	|		СведенияОДоходах.ВидРасчета КАК ВидРасчета
	|	ИЗ
	|		РегистрНакопления.СтраховыеВзносыСведенияОДоходах КАК СведенияОДоходах
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.НДФЛиЕСНДоходыИНалоги КАК НДФЛиЕСНДоходыИНалоги
	|			ПО СведенияОДоходах.Регистратор = НДФЛиЕСНДоходыИНалоги.Ссылка
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереносДанных КАК ПереносДанных
	|			ПО СведенияОДоходах.Регистратор = ПереносДанных.Ссылка
	|	ГДЕ
	|		СведенияОДоходах.ФизЛицо В
	|				(ВЫБРАТЬ
	|					СписокСотрудников.ФизЛицо
	|				ИЗ
	|					ВТСписокСотрудников КАК СписокСотрудников)
	|		И СведенияОДоходах.Организация = &Организация
	|		И СведенияОДоходах.ОбособленноеПодразделение = &ОбособленноеПодразделение
	|		И СведенияОДоходах.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|		И НЕ СведенияОДоходах.ПоАктуПроверки
	|		И СведенияОДоходах.Регистратор <> &Регистратор
	|		И НДФЛиЕСНДоходыИНалоги.Ссылка ЕСТЬ NULL 
	|		И ПереносДанных.Ссылка ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтраховыеВзносыСведенияОДоходах.ФизЛицо,
	|		СтраховыеВзносыСведенияОДоходах.ВидДохода,
	|		СтраховыеВзносыСведенияОДоходах.ДатаПолученияДохода,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяЕНВД,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|		СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомФармацевта,
	|		СтраховыеВзносыСведенияОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|		СтраховыеВзносыСведенияОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|		СтраховыеВзносыСведенияОДоходах.КлассУсловийТруда,
	|		СтраховыеВзносыСведенияОДоходах.Результат,
	|		СтраховыеВзносыСведенияОДоходах.Скидка,
	|		СтраховыеВзносыСведенияОДоходах.ВидРасчета
	|	ИЗ
	|		ВТНовыеДоходы КАК СтраховыеВзносыСведенияОДоходах) КАК ДанныеОДоходах
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеОДоходах.ФизЛицо,
	|	ДанныеОДоходах.ВидДохода,
	|	ДанныеОДоходах.ДатаПолученияДохода,
	|	ДанныеОДоходах.ОблагаетсяЕНВД,
	|	ДанныеОДоходах.ОблагаетсяПоДополнительномуТарифу,
	|	ДанныеОДоходах.ОблагаетсяВзносамиНаДоплатуКПенсииШахтерам,
	|	ДанныеОДоходах.ЯвляетсяДоходомФармацевта,
	|	ДанныеОДоходах.ЯвляетсяДоходомЧленаЭкипажаСуднаПодФлагомРФ,
	|	ДанныеОДоходах.ОблагаетсяВзносамиЗаЗанятыхНаРаботахСДосрочнойПенсией,
	|	ДанныеОДоходах.КлассУсловийТруда,
	|	ДанныеОДоходах.ВидРасчета,
	|	ДанныеОДоходах.ФизЛицо.Наименование
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДанныеОДоходах.Результат) <> 0
	|		ИЛИ СУММА(ДанныеОДоходах.Скидка) <> 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицоНаименование,
	|	ФизЛицо,
	|	ДатаПолученияДохода,
	|	ВидДохода,
	|	ВидРасчета";
	
	ДокументОбъект.СведенияОДоходах.Загрузить(Запрос.Выполнить().Выгрузить())
	
КонецПроцедуры 
