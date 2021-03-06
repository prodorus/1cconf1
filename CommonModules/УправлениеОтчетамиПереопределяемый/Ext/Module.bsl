#Если ТолстыйКлиентОбычноеПриложение Тогда
	
Процедура УстановитьОтбор(Отчет, Поле, Значение)
		Если Отчет.ЗначенияНастроекПанелиПользователя = Неопределено тогда
			Возврат;
		КонецЕсли;
		ЗначениеПользовательскойНастройки = Отчет.ЗначенияНастроекПанелиПользователя.Получить();
		Если ЗначениеПользовательскойНастройки = Неопределено тогда
			Возврат;
		КонецЕсли;
		Если ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле) <> Неопределено тогда
			Если ТипЗнч(ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).Значение) <> Тип("СписокЗначений") тогда
				ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).Значение = Значение;
				ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).Использование = истина;
			Иначе
				ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).Значение.Очистить();
				ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).Значение.Добавить(Значение);
				ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).Использование = истина;
				Если ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).ВидСравнения = "" Тогда
					ЗначениеПользовательскойНастройки.ДинамическиеОтборы.Получить(Поле).ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Отчет.ЗначенияНастроекПанелиПользователя = Новый ХранилищеЗначения(ЗначениеПользовательскойНастройки);
КонецПроцедуры
	
	
// Открывает форму отчета "РасчетныеЛистки" с переданным параметром
//
// Параметры: 
//  ТекущиеДанные -  строка в форме списка регистра расчетов
//  ИмяФормы - имя формы, из которой вызывается отчет
//
Процедура ВызовРасчетногоЛисткаИзФормыСпискаРР(ТекущиеДанные,ИмяФормы) Экспорт
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если Найти(ИмяФормы,"Организаций") > 0 Тогда 			
			РасчетныйЛисток	= Отчеты.РасчетныеЛисткиОрганизаций.Создать();
			РасчетныйЛисток.СохраненнаяНастройка = Справочники.СохраненныеНастройки.РасчетныеЛисткиОрганизаций;
			РасчетныйЛисток.ПрименитьНастройку();
			РасчетныйЛистокФорма = РасчетныйЛисток.ПолучитьФорму();
			РасчетныйЛистокФорма.Открыть();
			Если РасчетныйЛисток.ЗначенияНастроекПанелиПользователя = Неопределено тогда
				Если РасчетныйЛисток.ЗначенияНастроекПанелиПользователя.Получить().ДинамическиеОтборы.Количество() = 0 тогда
					РасчетныйЛисток.ЗначенияНастроекПанелиПользователя = Новый ХранилищеЗначения(ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователя(РасчетныйЛисток, РасчетныйЛистокФорма))
				КонецЕсли;
			КонецЕСли;
			РасчетныйЛистокФорма.ЭтоОтработкаРасшифровки = истина;
			УстановитьОтбор(РасчетныйЛисток, "Организация", ТекущиеДанные.ОбособленноеПодразделение);
		Иначе
			РасчетныйЛисток	= Отчеты.РасчетныеЛистки.Создать();	
			РасчетныйЛисток.СохраненнаяНастройка = Справочники.СохраненныеНастройки.РасчетныеЛистки;
			РасчетныйЛисток.ПрименитьНастройку();
			РасчетныйЛистокФорма = РасчетныйЛисток.ПолучитьФорму();
			РасчетныйЛистокФорма.Открыть();
			Если РасчетныйЛисток.ЗначенияНастроекПанелиПользователя = Неопределено тогда
				Если РасчетныйЛисток.ЗначенияНастроекПанелиПользователя.Получить().ДинамическиеОтборы.Количество() = 0 тогда
					РасчетныйЛисток.ЗначенияНастроекПанелиПользователя = Новый ХранилищеЗначения(ТиповыеОтчеты.ПолучитьЗначенияНастроекПанелиПользователя(РасчетныйЛисток, РасчетныйЛистокФорма))
				КонецЕсли;
			КонецЕСли;
			РасчетныйЛистокФорма.ЭтоОтработкаРасшифровки = истина;
			УстановитьОтбор(РасчетныйЛисток, "Подразделение", ТекущиеДанные.Подразделение);
			
		КонецЕсли;
		
		ЗначенияНастроекПанелиПользователя = РасчетныйЛисток.ЗначенияНастроекПанелиПользователя.Получить();
		ЗначенияНастроекПанелиПользователя.СтандартныйПериод.ДатаНачала   = НачалоМесяца(ТекущиеДанные.ПериодРегистрации);
		ЗначенияНастроекПанелиПользователя.СтандартныйПериод.ДатаОкончания = КонецМесяца(ТекущиеДанные.ПериодРегистрации);
		РасчетныйЛисток.ЗначенияНастроекПанелиПользователя = Новый ХранилищеЗначения(ЗначенияНастроекПанелиПользователя);
		
		ТиповыеОтчеты.УстановитьПараметр(РасчетныйЛисток.КомпоновщикНастроек,  "Группировать",  ложь);
		
		Если Найти(ИмяФормы,"Удержания") > 0 или Найти(ИмяФормы,"Организаций") = 0 Тогда
			ТиповыеОтчеты.ДобавитьОтбор(РасчетныйЛисток.КомпоновщикНастроек, "ФизЛицо", ТекущиеДанные.ФизЛицо);
		Иначе
			УстановитьОтбор(РасчетныйЛисток, "Сотрудник", ТекущиеДанные.Сотрудник);
		КонецЕсли;
		
		ДокументРезультат = РасчетныйЛистокФорма.ЭлементыФормы.Результат;
		РасчетныйЛистокФорма.ОбновлениеОтображения();
		РасчетныйЛисток.СформироватьОтчет(ДокументРезультат);
		
	КонецЕсли;
	
КонецПроцедуры // ВызовРасчетногоЛисткаИзФормыСпискаРР()

#КонецЕсли
///////////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЛЕНИЯ ОТЧЕТОВ УСТАНОВЛЕНЫХ НА ПОДДЕРЖКУ

Процедура ИсполнениеКадровогоПланаПриСозданииОтчета(ОтчетОбъект) Экспорт
	
	РежимНабораПерсонала = ПроцедурыУправленияПерсоналомДополнительный.ПолучитьРежимНабораПерсонала();

	Если РежимНабораПерсонала = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности Тогда
		ОтчетОбъект.СхемаКомпоновкиДанных = ОтчетОбъект.ПолучитьМакет("ПоЦентрамОтветственности");
	Иначе
		ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ИсполнениеКадровогоПлана.Запрос = СтрЗаменить(ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ИсполнениеКадровогоПлана.Запрос, "ШтатноеРасписаниеОрганизацийСрезПоследних.Должность", "ШтатноеРасписаниеОрганизацийСрезПоследних.Должность.Должность");
		ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ИсполнениеКадровогоПлана.Запрос = СтрЗаменить(ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ИсполнениеКадровогоПлана.Запрос, "ШтатноеРасписаниеОрганизаций.Должность", "ШтатноеРасписаниеОрганизаций.Должность.Должность");
		ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ИсполнениеКадровогоПлана.Запрос = СтрЗаменить(ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ИсполнениеКадровогоПлана.Запрос, "ЗанятыеШтатныеЕдиницыОрганизаций.Должность", "ЗанятыеШтатныеЕдиницыОрганизаций.Должность.Должность");
		ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры


// Процедура устанавливает параметр СКД отчета Вид договора соответсвующим списком значений видов трудовых договоров

Процедура ОценкиКомпетенцийРаботниковДоработкаКомпоновщика(ОтчетОбъект) Экспорт
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ДоговорУправленческий);
	СписокЗначений.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор);
	Параметр = ТиповыеОтчеты.УстановитьПараметр(ОтчетОбъект.КомпоновщикНастроек, "ВидДоговора", СписокЗначений);
	Параметр.Использование = истина;
	#КонецЕсли
КонецПроцедуры

Процедура ОценкиКомпетенцийРаботниковПриСозданииОтчета(ОтчетОбъект) Экспорт
	ТЗ = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РаботникиСрезПоследних.ФизЛицо КАК Измерение,
	|	РаботникиСрезПоследних.Подразделение КАК Подразделение,
	|	РаботникиСрезПоследних.Должность КАК Должность
	|ПОМЕСТИТЬ ПодразделениеДолжность
	|ИЗ
	|	РегистрСведений.Работники.СрезПоследних(&КонецПериода, ) КАК РаботникиСрезПоследних";
		 
	СтрокаЗамены = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	"""" КАК Измерение,
	|	"""" КАК Подразделение,
	|	"""" КАК Должность
	|ПОМЕСТИТЬ ПодразделениеДолжность";
	ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ОценкиКомпетенцийРаботников.Запрос = СтрЗаменить(ОтчетОбъект.СхемаКомпоновкиДанных.НаборыДанных.ОценкиКомпетенцийРаботников.Запрос, СтрокаЗамены, ТЗ);
КонецПроцедуры

Процедура ПройденныеКурсыОбученияДоработкаКомпоновщика(ОтчетОбъект) Экспорт
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор);
	СписокЗначений.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ДоговорУправленческий);
	Параметр = ТиповыеОтчеты.УстановитьПараметр(ОтчетОбъект.КомпоновщикНастроек, "ВидДоговора", СписокЗначений);
	Параметр.Использование = истина;
	#КонецЕсли
КонецПроцедуры

Процедура РазвитиеКомпетенцийДоработкаКомпоновщика(ОтчетОбъект) Экспорт
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ТрудовойДоговор);
	СписокЗначений.Добавить(Перечисления.ВидыДоговоровСФизЛицами.ДоговорУправленческий);
	Параметр = ТиповыеОтчеты.УстановитьПараметр(ОтчетОбъект.КомпоновщикНастроек, "ВидДоговора", СписокЗначений);
	Параметр.Использование = истина;
	#КонецЕсли
КонецПроцедуры

Процедура ДобавитьУчетнуюПолитикуПОУСНДляРасчетаСреднесписочнойЧисленности(СхемаКомпоновкиДанных) Экспорт
	СхемаКомпоновкиДанных.НаборыДанных.МесяцыУСН.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.МесяцыУСН.Запрос, "ЛОЖЬ КАК УСН", "УчетнаяПолитикаНалоговыйУчет.УСН");
КонецПроцедуры


Процедура УстановитьСКДОтчетСостояниеКадровогоПлана(ОтчетОбъект) Экспорт 
	
	Если Константы.РежимНабораПерсонала.Получить() = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности Тогда
		ОтчетОбъект.СхемаКомпоновкиДанных = ОтчетОбъект.ПолучитьМакет("ПоЦентрамОтветственности");
		ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
Конецпроцедуры

Функция ДоступныеНастройкиДляСостоянияКадровогоПлана() Экспорт
	
	ИспользоватьУправленческийУчетЗарплаты = Константы.РежимНабораПерсонала.Получить() = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоЦентрамОтветственности;
	
	СписокНастроек = Новый СписокЗначений;
	Если ИспользоватьУправленческийУчетЗарплаты Тогда
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.СостояниеКадровогоПлана);
	Иначе
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.СостояниеКадровогоПланаОрганизации);
	КонецЕсли;	

	Возврат СписокНастроек;
КонецФункции

Функция ПодставитьЗапросДляПолученияНалоговойПолитики(ТекстЗапроса) Экспорт
	
	ТекстЗамены = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
				|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаРегистрацииИзменений,
				|	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) КАК Организация,
				|	ЗНАЧЕНИЕ(Перечисление.ТарифыСтраховыхВзносов.ПустаяСсылка) КАК ВидТарифаСтраховыхВзносов,
				|	ЛОЖЬ КАК УплачиватьДобровольныеВзносыВФСС
				|ПОМЕСТИТЬ ВТНалоговыйУчет";
	
	ТекстНовый = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	             |	УчетнаяПолитикаНалоговыйУчет.Период,
	             |	УчетнаяПолитикаНалоговыйУчет.Период КАК ДатаРегистрацииИзменений,
	             |	УчетнаяПолитикаНалоговыйУчет.Организация,
	             |	УчетнаяПолитикаНалоговыйУчет.ВидТарифаСтраховыхВзносов КАК ВидТарифаСтраховыхВзносов,
	             |	УчетнаяПолитикаНалоговыйУчет.УплачиватьДобровольныеВзносыВФСС,
	             |	ЕСТЬNULL(ВЫБОР
	             |			КОГДА УчетнаяПолитикаНалоговыйУчет.СистемаНалогообложения = ЗНАЧЕНИЕ(Перечисление.СистемыНалогообложения.Упрощенная)
	             |				ТОГДА ИСТИНА
	             |			ИНАЧЕ ЛОЖЬ
	             |		КОНЕЦ, ЛОЖЬ) КАК УСН,
	             |	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяПлательщикомЕНВД
	             |ПОМЕСТИТЬ ВТНалоговыйУчет
	             |ИЗ
	             |	РегистрСведений.УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаНалоговыйУчет";
	
	Возврат СтрЗаменить(ТекстЗапроса,ТекстЗамены, ТекстНовый);  
	
КонецФункции

Процедура НастроитьТипИДоступностьПолейОтчетаПоЗаявкамКандидатов(СхемаКомпоновкиДанных) Экспорт
	
	РежимНабораПерсонала = Константы.РежимНабораПерсонала.Получить();
	МассивТипов = Новый Массив;
	
	Если РежимНабораПерсонала = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		ПолеНабора = СхемаКомпоновкиДанных.НаборыДанных.ЗаявкиСоискателей.Поля.Найти("Организация");
		ПолеНабора.ОграничениеИспользования.Группировка = Истина; 
		ПолеНабора.ОграничениеИспользования.Поле        = Истина; 
		ПолеНабора.ОграничениеИспользования.Порядок     = Истина; 
		ПолеНабора.ОграничениеИспользования.Условие     = Истина; 
		МассивТипов.Добавить(Тип("СправочникСсылка.ПодразделенияОрганизаций"));
	Иначе
		МассивТипов.Добавить(Тип("СправочникСсылка.Подразделения"));
	КонецЕсли;	
	
	ПолеНабора = СхемаКомпоновкиДанных.НаборыДанных.ЗаявкиСоискателей.Поля.Найти("Подразделение");
	ОписаниеТипаПодразделения = Новый ОписаниеТипов(МассивТипов);			
	ПолеНабора.ТипЗначения = ОписаниеТипаПодразделения;
	
КонецПроцедуры

Процедура НастроитьДоступностьВариантовОтчетаПоЗаявкамКандидатов(СхемаКомпоновкиДанных, СтруктураНаcтроек) Экспорт
	
	СписокПолейПодстановкиОтборовПоУмолчанию = Новый Соответствие;
	
	РежимНабораПерсонала = Константы.РежимНабораПерсонала.Получить();
	
	СписокНастроек = Новый СписокЗначений;
	Если РежимНабораПерсонала = Перечисления.ВидыОрганизационнойСтруктурыПредприятия.ПоСтруктуреЮридическихЛиц Тогда
		СписокПолейПодстановкиОтборовПоУмолчанию.Вставить("Организация", "ОсновнаяОрганизация");
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ОтчетПоЗаявкамКандидатов);
	Иначе
		СписокНастроек.Добавить(Справочники.СохраненныеНастройки.ОтчетПоЗаявкамКандидатовУправленческий);
	КонецЕсли;	

	СтруктураНаcтроек.ЗаполнитьОтборыПоУмолчанию = истина;
	СтруктураНаcтроек.СписокПолейПодстановкиОтборовПоУмолчанию = СписокПолейПодстановкиОтборовПоУмолчанию;
	СтруктураНаcтроек.СписокДоступныхПредопределенныхНастроек = СписокНастроек;
	
КонецПроцедуры

