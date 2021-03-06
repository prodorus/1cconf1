////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Реквизиты                   = СтруктураСоответсвтияНастройкиОтборовРеквизитамФормы();
	РеквизитыБазыКорреспондента = СтруктураСоответсвтияНастройкиОтборовКорреспондентаРеквизитамФормы();

	ОбменДаннымиСервер.ФормаНастройкиУзловПриСозданииНаСервере(ЭтаФорма, Отказ);
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
	ЗаполнитьСкладыИОрганизации();
	
	ОбменДаннымиКлиентСервер.ЗаполнитьДанныеСтруктуры(ЭтаФорма);
	
	ПолучитьОписаниеКонтекста();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьОрганизацийИСкладов(Элемент)

УстановитьДоступностьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбъектОрганизацииПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбъектРазделыУчетаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	ПолучитьОписаниеКонтекста();
	ОбменДаннымиКлиент.ФормаНастройкиУзловКомандаЗакрытьФорму(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ

&НаСервере
Функция СтруктураСоответсвтияНастройкиОтборовКорреспондентаРеквизитамФормы()
	
	СтруктураНастроек = Новый Структура;
	
		//СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",      "ИспользоватьОтборПоОрганизациямУП");
		//СтруктураНастроек.Вставить("ВыгружатьУправленческуюОрганизацию",   "ВыгружатьУправленческуюОрганизацию");
		СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",         "ДатаНачалаВыгрузкиДокументовБК");
		СтруктураНастроек.Вставить("ПравилаОтправкиДокументов",            "ПравилаОтправкиДокументовБК");
		СтруктураНастроек.Вставить("ПравилаОтправкиСправочников",          "ПравилаОтправкиСправочниковБК");
		//СтруктураНастроек.Вставить("РежимВыгрузкиСправочников",            "РежимВыгрузкиСправочниковУП");
		//СтруктураНастроек.Вставить("РежимВыгрузкиДокументов",              "РежимВыгрузкиДокументовУП");
		//СтруктураНастроек.Вставить("УправленческаяОрганизация",            "УправленческаяОрганизация");
		//СтруктураНастроек.Вставить("Организации",                          "ОрганизацииУП");
		//СтруктураНастроек.Вставить("ВыгружатьАналитикуПоСкладам",          "ВыгружатьАналитикуПоСкладамУП");
		//СтруктураНастроек.Вставить("ПравилаСозданияДоговоровКонтрагентов", "ПравилаСозданияДоговоровКонтрагентов");
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаСервере
Функция СтруктураСоответсвтияНастройкиОтборовРеквизитамФормы()
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям", "ИспользоватьОтборПоОрганизациям");
	СтруктураНастроек.Вставить("ИспользоватьОтборПоСкладам",      "ИспользоватьОтборПоСкладам");
	СтруктураНастроек.Вставить("ДатаНачалаВыгрузкиДокументов",    "ДатаНачалаВыгрузкиДокументов");
	СтруктураНастроек.Вставить("Организации",                     "Организации");
	СтруктураНастроек.Вставить("Склады",                          "Склады");
	СтруктураНастроек.Вставить("РазделыУчета",                    "РазделыУчета");
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)

Форма.Элементы.Организации.Доступность = Форма.ИспользоватьОтборПоОрганизациям;
Форма.Элементы.Склады.Доступность      = Форма.ИспользоватьОтборПоСкладам;

КонецПроцедуры // УстановитьДоступностьЭлементов()

&НаСервере
Процедура ПолучитьОписаниеКонтекста()

		ОписаниеКонтекста = (""
			+ ОписаниеОграниченийПередачиДанных()
			+ Символы.ПС + Символы.ПС
			+ ОписаниеОграниченийПередачиДанныхКорреспондента()
		);
	
КонецПроцедуры

&НаСервере
Функция ОписаниеОграниченийПередачиДанных()
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
	ОграничениеОтборПоОрганизациям = "";
	ОграничениеОтборПоСкладам = "";
	
	Отбор = Новый Структура("Использовать", Истина);
	
	Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументов) Тогда
		ОграничениеДатаНачалаВыгрузкиДокументов = НСтр("ru = 'Документы выгружаются начиная с [ДатаНачалаВыгрузкиДокументов]'");
		ОграничениеДатаНачалаВыгрузкиДокументов = СтрЗаменить(ОграничениеДатаНачалаВыгрузкиДокументов, "[ДатаНачалаВыгрузкиДокументов]", Формат(ДатаНачалаВыгрузкиДокументов, "ДЛФ=DD"));
	Иначе
		ОграничениеДатаНачалаВыгрузкиДокументов = "Документы выгружаются за весь период";
	КонецЕсли;
	
	
	Если ИспользоватьОтборПоОрганизациям Тогда
		
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Организации.Выгрузить(Отбор).ВыгрузитьКолонку("Представление"), "; ");
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'Отбор по организациям: [СтрокаПредставленияОтбора]'");
		ОграничениеОтборПоОрганизациям = СтрЗаменить(ОграничениеОтборПоОрганизациям, "[СтрокаПредставленияОтбора]", СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'По всем организациям'");
	КонецЕсли;
	
	Если ИспользоватьОтборПоСкладам Тогда
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(Склады.Выгрузить(Отбор).ВыгрузитьКолонку("Представление"), "; ");
		ОграничениеОтборПоСкладам = НСтр("ru = 'Отбор по складам: [СтрокаПредставленияОтбора]'");
		ОграничениеОтборПоСкладам = СтрЗаменить(ОграничениеОтборПоСкладам, "[СтрокаПредставленияОтбора]", СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоСкладам = НСтр("ru = 'По всем складам'");
	КонецЕсли;
	
	ОграничениеОтборПоРазделам = "";
	
	Для Каждого РазделУчета Из РазделыУчета Цикл
		Если РазделУчета.Использовать Тогда
			ОграничениеОтборПоРазделам = ОграничениеОтборПоРазделам + Символы.ПС + Символы.Таб + РазделУчета.Представление;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ОграничениеОтборПоРазделам) Тогда
		ОграничениеОтборПоРазделам = Символы.ПС + НСтр("ru = 'Отбор по разделам:'") + ОграничениеОтборПоРазделам;
	КонецЕсли;
	
	Результат = НСтр("ru = 'Правила отправки данных из этой информационной базы:
							|Выгружать документы и справочную информацию:
							|[ОграничениеДатаНачалаВыгрузкиДокументов]
							|[ОграничениеОтборПоОрганизациям]
							|[ОграничениеОтборПоСкладам]'");
	
	Результат = СтрЗаменить(Результат, "[ОграничениеДатаНачалаВыгрузкиДокументов]", ОграничениеДатаНачалаВыгрузкиДокументов);
	Результат = СтрЗаменить(Результат, "[ОграничениеОтборПоОрганизациям]", ОграничениеОтборПоОрганизациям);
	Результат = СтрЗаменить(Результат, "[ОграничениеОтборПоСкладам]", ОграничениеОтборПоСкладам);
	Результат = Результат + ОграничениеОтборПоРазделам;
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ОписаниеОграниченийПередачиДанныхКорреспондента()
	
	ОграничениеДатаНачалаВыгрузкиДокументов = "";
	ОграничениеОтборПоОрганизациям = "";
	ОграничениеОтборПоСкладам = "";
	
	Если ЗначениеЗаполнено(ДатаНачалаВыгрузкиДокументовБК) Тогда
		ОграничениеДатаНачалаВыгрузкиДокументов = НСтр("ru = 'Документы выгружаются начиная с [ДатаНачалаВыгрузкиДокументов]'");
		ОграничениеДатаНачалаВыгрузкиДокументов = СтрЗаменить(ОграничениеДатаНачалаВыгрузкиДокументов, "[ДатаНачалаВыгрузкиДокументов]", Формат(ДатаНачалаВыгрузкиДокументовБК, "ДЛФ=DD"));
	Иначе
		ОграничениеДатаНачалаВыгрузкиДокументов = "Документы выгружаются за весь период";
	КонецЕсли;
	
	Если ИспользоватьОтборПоОрганизациямБК Тогда
		СтрокаПредставленияОтбора = СтроковыеФункцииКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(ОрганизацииБК.Выгрузить().ВыгрузитьКолонку("Представление"), "; ");
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'Отбор по организациям: [СтрокаПредставленияОтбора]'");
		ОграничениеОтборПоОрганизациям = СтрЗаменить(ОграничениеОтборПоОрганизациям, "[СтрокаПредставленияОтбора]", СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'По всем организациям'");
	КонецЕсли;
	
	Результат = НСтр("ru = 'Правила отправки данных из информационной базы-корреспондента:
							|Выгружать документы и справочную информацию:
							|[ОграничениеДатаНачалаВыгрузкиДокументов]
							|[ОграничениеОтборПоОрганизациям]'");
	
	Результат = СтрЗаменить(Результат, "[ОграничениеДатаНачалаВыгрузкиДокументов]", ОграничениеДатаНачалаВыгрузкиДокументов);
	Результат = СтрЗаменить(Результат, "[ОграничениеОтборПоОрганизациям]", ОграничениеОтборПоОрганизациям);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСкладыИОрганизации()
	Запрос = Новый Запрос();
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	Организации.Наименование КАК Представление
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Склады.Ссылка КАК Склад,
	|	Склады.Наименование КАК Представление
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	НЕ Склады.ЭтоГруппа
	|	И НЕ Склады.ПометкаУдаления";
	
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОрганизацииВыбор = РезультатЗапроса[0].Выбрать();
	СкладыВыбор = РезультатЗапроса[1].Выбрать();
	
	Пока ОрганизацииВыбор.Следующий() Цикл
		
		Отбор = Новый Структура("УникальныйИдентификаторСсылки", Строка(ОрганизацииВыбор.Организация.УникальныйИдентификатор()));
		
		НайденныеСтроки = Организации.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			НоваяСтрока = Организации.Добавить();
			НоваяСтрока.Использовать = Истина;
			НоваяСтрока.Представление = ОрганизацииВыбор.Представление;
			НоваяСтрока.УникальныйИдентификаторСсылки = ОрганизацииВыбор.Организация.УникальныйИдентификатор();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Пока СкладыВыбор.Следующий() Цикл
		
		Отбор = Новый Структура("УникальныйИдентификаторСсылки", Строка(СкладыВыбор.Склад.УникальныйИдентификатор()));
		
		НайденныеСтроки = Склады.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			
			НоваяСтрока = Склады.Добавить();
			НоваяСтрока.Использовать  = Истина;
			НоваяСтрока.Представление = СкладыВыбор.Представление;
			НоваяСтрока.Склад         = СкладыВыбор.Склад;
			НоваяСтрока.УникальныйИдентификаторСсылки = СкладыВыбор.Склад.УникальныйИдентификатор();
			
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры