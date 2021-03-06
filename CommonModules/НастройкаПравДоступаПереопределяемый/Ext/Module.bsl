/////////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАНИЯ МЕХАНИЗМА НАСТРОЙКИ ПРАВ ДОСТУПА

// Проверка доступности роли расчетчика
// это или РасчетчикРегламентированнойЗарплаты или полные права
// Применяется для проверки прав на доступ к расчетным регистрам, например, 
// в формах и при выводе на печать
// Возвращаемое значение:
//	булево - истина если есть доступ к "расчетным" данным
Функция ДоступнаРольРасчетчикаРегл() Экспорт
	Возврат РольДоступна("РасчетчикРегламентированнойЗарплаты")
			или ОбщегоНазначенияЗКПереопределяемый.ДоступнаУстаревшаяРоль("УдалитьРасчетчикРегламентированнойЗарплатыБезОграниченияПрав")
			или РольДоступна("ПолныеПрава");
	
КонецФункции  //ДоступнаРольРасчетчика
		
// Проверка доступности роли кадровика
// это или КадровикРегламентированныхДанных или полные права
// Применяется для проверки прав на доступ к расчетным регистрам, например, 
// в формах и при выводе на печать
// Возвращаемое значение:
//	булево - истина если есть доступ к "расчетным" данным
Функция ДоступнаРольКадровикаРегл() Экспорт
	Возврат РольДоступна("КадровикРегламентированныхДанных")
			или ОбщегоНазначенияЗКПереопределяемый.ДоступнаУстаревшаяРоль("УдалитьКадровикРегламентированныхДанныхБезОграниченияПрав")
			или РольДоступна("ПолныеПрава");
	
КонецФункции  //ДоступнаРольКадровикаРегл

// Проверка доступности роли менеджера по набору персонала 
// это или МенеджерПоНаборуПерсонала или полные права
// Применяется для проверки прав на доступ к соотв. даннам
// Возвращаемое значение:
//	булево - истина если есть доступ
Функция ДоступнаРольМенеджераПоНабору() Экспорт
	Возврат РольДоступна("МенеджерПоНаборуПерсонала")
			или ОбщегоНазначенияЗКПереопределяемый.ДоступнаУстаревшаяРоль("УдалитьМенеджерПоНаборуПерсоналаБезОграниченияПрав")
			или РольДоступна("ПолныеПрава");
	
КонецФункции // ДоступнаРольМенеджераПоНабору


//
Функция ПолучитьВидОбъектаДоступа(ОбъектДоступа) Экспорт

	Если ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.Организации") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.Организации;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ГруппыЗаявокКандидатов") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.ЗаявкиКандидатов;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ГруппыДоступаФизическихЛиц") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.ФизическиеЛица;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.ВнешниеОбработки;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.Подразделения") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.Подразделения;
	ИначеЕсли ТипЗнч(ОбъектДоступа) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		Возврат Перечисления.ВидыОбъектовДоступа.ПодразделенияОрганизаций;
	Иначе
		Возврат Перечисления.ВидыОбъектовДоступа.ПустаяСсылка();
	КонецЕсли;

КонецФункции

// Функция создает структуру объектов доступа
//
// Параметры
//
// Возвращаемое значение:
//   Структура   - Ключ: строка, Значение: описание объекта доступа типа ссылка
//
Функция ПолучитьСтруктуруТипыОбъектовДоступа() Экспорт

	ТипыОбъектовДоступа = Новый Структура;
	
	ТипыОбъектовДоступа.Вставить("Организации",					Тип("СправочникСсылка.Организации"));
	ТипыОбъектовДоступа.Вставить("ФизическиеЛица",				Тип("СправочникСсылка.ГруппыДоступаФизическихЛиц"));
	ТипыОбъектовДоступа.Вставить("ЗаявкиКандидатов",			Тип("СправочникСсылка.ГруппыЗаявокКандидатов"));
	ТипыОбъектовДоступа.Вставить("ВнешниеОбработки",			Тип("СправочникСсылка.ВнешниеОбработки"));
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	Если ИспользоватьУправленческийУчетЗарплаты Тогда
		ТипыОбъектовДоступа.Вставить("Подразделения",				Тип("СправочникСсылка.Подразделения"));
	КонецЕсли;
	
	ТипыОбъектовДоступа.Вставить("ПодразделенияОрганизаций",	Тип("СправочникСсылка.ПодразделенияОрганизаций"));
	
	Возврат ТипыОбъектовДоступа;

КонецФункции // ПолучитьСтруктуруТипыОбъектовДоступа()

// Функция определяет список областей данных,
// которые соответствуют переданному типу данных
//
// Параметры
//  ТИпДанных - Тип, Анализируемый тип
//
// Возвращаемое значение:
//   СписокЗначений
//
Функция ПолучитьСписокОбластейДанных(ТипДанных) Экспорт

	СписокОбластей = Новый СписокЗначений;
	Если ТипДанных = Тип("СправочникСсылка.Организации") Тогда
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.Организации);
	ИначеЕсли ТипДанных = Тип("СправочникСсылка.ГруппыЗаявокКандидатов") Тогда
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.ЗаявкиКандидатов);
	ИначеЕсли ТипДанных = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.ВнешниеОбработки);
	ИначеЕсли ТипДанных = Тип("СправочникСсылка.ГруппыДоступаФизическихЛиц") Тогда
		СписокОбластей.Добавить(Перечисления.ОбластиДанныхОбъектовДоступа.ФизическиеЛицаСписок);
		СписокОбластей.Добавить(Перечисления.ОбластиДанныхОбъектовДоступа.ФизическиеЛицаДанные);
	ИначеЕсли ТипДанных = Тип("СправочникСсылка.Подразделения") Тогда
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.Подразделения);
	ИначеЕсли ТипДанных = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.ПодразделенияОрганизаций);
	ИначеЕсли ТипДанных = Тип("СправочникСсылка.ГруппыПользователей") Тогда
		// Добавим только те виды объектов доступа, для которых нет областей данных
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.ЗаявкиКандидатов);
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.Организации);
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.ВнешниеОбработки);
		ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
		Если ИспользоватьУправленческийУчетЗарплаты Тогда
			СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.Подразделения);
		КонецЕсли;
		СписокОбластей.Добавить(Перечисления.ВидыОбъектовДоступа.ПодразделенияОрганизаций);
		// Добавим все области данных
		Для каждого Перечисление Из Перечисления.ОбластиДанныхОбъектовДоступа Цикл
			СписокОбластей.Добавить(Перечисление);
		КонецЦикла;
	КонецЕсли;
	
	НастройкаПравДоступаДополнительный.ДополнитьСписокОбластейДанных(СписокОбластей, ТипДанных);
	
	Возврат СписокОбластей;

КонецФункции // ПолучитьСписокОбластейДанных()

// Функция возвращает значение из соответствия по переданному ключу
//
// Параметры
//  СоответствиеОбластейДанных  - Соответствие из которого получается значение
//  Запись  - запись набора записей НастройкиПравДоступаПользователей, реквизит записи является ключем
//
// Возвращаемое значение:
//   Строка   - значение соответсвия, полученное по ключу
//
Функция ПолучитьЗначениеИзСоответствияОбластейДанных(СоответствиеОбластейДанных, Запись) Экспорт
	
	Возврат СоответствиеОбластейДанных[?(ЗначениеЗаполнено(Запись.ОбластьДанных), Запись.ОбластьДанных, Запись.ВидОбъектаДоступа)];

КонецФункции // ПолучитьЗначениеИзСоответствияОбластейДанных()

// Процедура заполняет реквизиты новой записи Регистра сведений НастройкиПравДоступаПользователей
// по переданным данным ЭлементОбластиДанных
//
// Параметры
//  НоваяЗапись  		 - запись набора записей регистра сведений НастройкиПравДоступаПользователей
//  СтрокаТаблицы  		 - строка табличной части ТаблицаПравДоступа обработки НастройкаПравДоступа
//  ЭлементОбластиДанных - значение из соответсвия СоответствиеОбластейДанных обработки НастройкаПравДоступа
//  Индекс				 - порядковый номер значения ЭлементОбластиДанных из соответсвия СоответствиеОбластейДанных обработки НастройкаПравДоступа
//
Процедура ЗаполнитьСтрокуПраваДоступаПользователей(НоваяЗапись, СтрокаТаблицы, ЭлементОбластиДанных, Индекс) Экспорт
	
	НоваяЗапись.ОбъектДоступа       = СтрокаТаблицы.ОбъектДоступа;
	НоваяЗапись.ВладелецПравДоступа = СтрокаТаблицы.ВладелецПравДоступа;
	НоваяЗапись.ОбластьДанных       = ?(ТипЗнч(ЭлементОбластиДанных.Значение) = Тип("ПеречислениеСсылка.ОбластиДанныхОбъектовДоступа"), ЭлементОбластиДанных.Значение, Перечисления.ОбластиДанныхОбъектовДоступа.ПустаяСсылка());
	НоваяЗапись.Пользователь        = СтрокаТаблицы.Пользователь;
	НоваяЗапись.Запись              = СтрокаТаблицы["Запись_" + Индекс];
	НоваяЗапись.ВидНаследованияПравДоступаИерархическихСправочников = СтрокаТаблицы.ВидНаследованияПравДоступаИерархическихСправочников;
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда
	
Процедура ДополнитьСоставСтраницФормыОбработки(ЭтаФорма, НазначаемыеДействия) Экспорт
	
	// уточним таблицу настройки доступа по физлицам
	ЭтаФорма.ЭлементыФормы.ТаблицаПравДоступа_ФизическиеЛица.Колонки.Чтение_1.ТолькоПросмотр = Ложь;
	ЭтаФорма.ЭлементыФормы.ТаблицаПравДоступа_ФизическиеЛица.Колонки.Чтение_1.ТекстШапки = "Видимость в списке";
	ЭтаФорма.ЭлементыФормы.ТаблицаПравДоступа_ФизическиеЛица.Колонки.Запись_1.Видимость = Ложь;
	
	КолонкиТабличногоПоля = ЭтаФорма.ЭлементыФормы.ТаблицаПравДоступа_ФизическиеЛица.Колонки;
	
	КолонкаЧтение = КолонкиТабличногоПоля.Добавить("Чтение_2", "Просмотр данных в форме");
	КолонкаЧтение.Имя				= "Чтение_2";
	КолонкаЧтение.ДанныеФлажка		= "Чтение_2";
	КолонкаЧтение.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
	КолонкаЧтение.Ширина = 7;
	КолонкаЗапись = КолонкиТабличногоПоля.Добавить("Запись_2", "Редактирование данных");
	КолонкаЗапись.Имя				= "Запись_2";
	КолонкаЗапись.ДанныеФлажка		= "Запись_2";
	КолонкаЗапись.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
	КолонкаЗапись.Ширина = 7;

	//назначение обработчиков
	Для Каждого НазначаемоеДействие Из НазначаемыеДействия Цикл
		ЭтаФорма.ЭлементыФормы.ТаблицаПравДоступа_ФизическиеЛица.УстановитьДействие(НазначаемоеДействие.Ключ, НазначаемоеДействие.Значение);
	КонецЦикла;	
	
	НастройкаПравДоступаДополнительный.ДополнитьСоставЭлементовФормы(ЭтаФорма, НазначаемыеДействия);
	
	ИспользоватьУправленческийУчетЗарплаты = глЗначениеПеременной("глИспользоватьУправленческийУчетЗарплаты");
	
	Если НЕ ИспользоватьУправленческийУчетЗарплаты Тогда
		Возврат;
	КонецЕсли;

	ЭлементыФормы			= ЭтаФорма.ЭлементыФормы;
	ПанельОбластейДанных	= ЭлементыФормы.ПанельОбластейДанных;
	Страницы 				= ПанельОбластейДанных.Страницы;
	
	//добавление страницы
	СтраницаПодразделения = Страницы.Вставить(Страницы.Индекс(Страницы.Найти("ПодразделенияОрганизаций")), "Подразделения", "Подразделения");
	ПанельОбластейДанных.ТекущаяСтраница = СтраницаПодразделения;
	
	//добавление табличного поля
	ТаблицаПравДоступа_Подразделения	= ЭлементыФормы.Добавить(Тип("ТабличноеПоле"), "ТаблицаПравДоступа_Подразделения", Истина, ПанельОбластейДанных);
	ТаблицаПравДоступа_Подразделения.Данные = "ТаблицаПравДоступа";
	ТаблицаПравДоступа_Подразделения.СоздатьКолонки();
	
	//расположение табличного поля
	ТаблицаПравДоступа_Подразделения.Лево	= 6;
	ТаблицаПравДоступа_Подразделения.Верх	= 53;
	ТаблицаПравДоступа_Подразделения.Ширина	= 726;
	ТаблицаПравДоступа_Подразделения.Высота	= 280;
	
	//удаление неиспользуемых в табличном поле колонок "Запись_.." и "Чтение_.."
	НомерКолонки = 0;
	КолонкиТабличногоПоля = ТаблицаПравДоступа_Подразделения.Колонки;
	КолонкиТабличногоПоля.Удалить(КолонкиТабличногоПоля["НомерСтроки"]);
	КолонкиТабличногоПоля.Удалить(КолонкиТабличногоПоля["ТипОбъектаДоступа"]);
	Пока НомерКолонки < КолонкиТабличногоПоля.Количество() Цикл
		Если Найти(КолонкиТабличногоПоля[НомерКолонки].Имя, "Чтение") > 0 
		 ИЛИ Найти(КолонкиТабличногоПоля[НомерКолонки].Имя, "Запись") > 0 Тогда
			 КолонкиТабличногоПоля.Удалить(НомерКолонки);
		Иначе
			НомерКолонки = НомерКолонки + 1;
		КонецЕсли;
	КонецЦикла;
	
	//добавление колонки "Картинка"
	КолонкаКартинка = КолонкиТабличногоПоля.Вставить(0, "");
	КолонкаКартинка.Имя	= "Картинка";
	КолонкаКартинка.КартинкиСтрок = БиблиотекаКартинок.РегистрСведенийЗапись;
	КолонкаКартинка.Ширина = 2;
	
	//добавление колонок Чтение и Запись
	КолонкаЧтение = КолонкиТабличногоПоля.Добавить("Чтение", "Чтение");
	КолонкаЧтение.Имя				= "Чтение_1";
	КолонкаЧтение.ДанныеФлажка		= "Чтение_1";
	КолонкаЧтение.ТолькоПросмотр	= Истина;
	КолонкаЗапись = КолонкиТабличногоПоля.Добавить("Запись", "Запись");
	КолонкаЗапись.Имя				= "Запись_1";
	КолонкаЗапись.ДанныеФлажка		= "Запись_1";
	КолонкаЗапись.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
	
	//прочие параметры табличного поля
	КолонкиТабличногоПоля["ВладелецПравДоступа"].Видимость = Ложь;
	ТаблицаПравДоступа_Подразделения.ТолькоПросмотр = Ложь;
	
	//назначение обработчиков
	Для Каждого НазначаемоеДействие Из НазначаемыеДействия Цикл
		ТаблицаПравДоступа_Подразделения.УстановитьДействие(НазначаемоеДействие.Ключ, НазначаемоеДействие.Значение);
	КонецЦикла;	
	
	//установка привязок
	ТаблицаПравДоступа_Подразделения.УстановитьПривязку(ГраницаЭлементаУправления.Право, ПанельОбластейДанных, ГраницаЭлементаУправления.Право);
	ТаблицаПравДоступа_Подразделения.УстановитьПривязку(ГраницаЭлементаУправления.Низ, ПанельОбластейДанных, ГраницаЭлементаУправления.Низ);
	
	// добавление надписей с картинками
	
	// КартинкаИнфо
	КартинкаИнфо = ЭлементыФормы.Добавить(Тип("ПолеКартинки"), "_Картинка_Инфо", Истина, ПанельОбластейДанных);
	КартинкаИнфо.Лево	= 6;
	КартинкаИнфо.Верх	= 6;
	КартинкаИнфо.Ширина	= 21;
	КартинкаИнфо.Высота	= 17;
	КартинкаИнфо.Картинка = БиблиотекаКартинок.СообщениеИнформация;
	// Информационная надпись
	НадписьИнфо = ЭлементыФормы.Добавить(Тип("Надпись"), "_Надпись_Инфо", Истина, ПанельОбластейДанных);
	НадписьИнфо.Лево	= 33;
	НадписьИнфо.Верх	= 6;
	НадписьИнфо.Ширина	= 380;
	НадписьИнфо.Высота	= 40;
	НадписьИнфо.Заголовок = "Подразделения компании, по которым пользователю доступна информация о вакансиях и кандидатах.";
	НадписьИнфо.ВертикальноеПоложение = ВертикальноеПоложение.Верх;
	НадписьИнфо.УстановитьПривязку(ГраницаЭлементаУправления.Право, ПанельОбластейДанных, ГраницаЭлементаУправления.Право);
	
	// КартинкаВнимание
	КартинкаВнимание = ЭлементыФормы.Добавить(Тип("ПолеКартинки"), "_Картинка_Внимание", Истина, ПанельОбластейДанных);
	КартинкаВнимание.Лево	= 437;
	КартинкаВнимание.Верх	= 6;
	КартинкаВнимание.Ширина	= 21;
	КартинкаВнимание.Высота	= 17;
	КартинкаВнимание.Картинка = БиблиотекаКартинок.СообщениеОПроблемах;
	КартинкаВнимание.УстановитьПривязку(ГраницаЭлементаУправления.Лево, ПанельОбластейДанных, ГраницаЭлементаУправления.Право);
	КартинкаВнимание.УстановитьПривязку(ГраницаЭлементаУправления.Право, КартинкаВнимание, ГраницаЭлементаУправления.Лево);
	// Важная информационная надпись
	НадписьВнимание = ЭлементыФормы.Добавить(Тип("Надпись"), "_Надпись_Внимание", Истина, ПанельОбластейДанных);
	НадписьВнимание.Лево	= 463;
	НадписьВнимание.Верх	= 6;
	НадписьВнимание.Ширина	= 269;
	НадписьВнимание.Высота	= 40;
	НадписьВнимание.Заголовок = "Доступ к кадровым данным, персональным данным сотрудников и данным о начислении зарплаты не разграничивается по подразделениям!";
	НадписьВнимание.УстановитьПривязку(ГраницаЭлементаУправления.Лево, ПанельОбластейДанных, ГраницаЭлементаУправления.Право);
	НадписьВнимание.УстановитьПривязку(ГраницаЭлементаУправления.Право, НадписьВнимание, ГраницаЭлементаУправления.Лево);
	
	ПанельОбластейДанных.ТекущаяСтраница = ПанельОбластейДанных.Страницы[0];
	
КонецПроцедуры

#КонецЕсли

/////////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАНИЯ МЕХАНИЗМА ДАТЫ ЗАПРЕТА РЕДАКТИРОВАНИЯ


Функция ПолучитьДатуПроверкиПоТипуДокумента(ДокументОбъект, ПараметрыПроверкиДокумента)Экспорт
	
	Если ПараметрыПроверкиДокумента.МетаданныеДокумента = Метаданные.Документы.ЗарплатаКВыплатеОрганизаций Тогда
		Возврат ДокументОбъект.Дата;
	ИначеЕсли ПараметрыПроверкиДокумента.МетаданныеДокумента = Метаданные.Документы.ВводПроцентаДеятельностиЕНВД Тогда
		Если НЕ ДокументОбъект.ВводДанныхПоПериодам Тогда
			Возврат Мин(ДокументОбъект.Дата, ДокументОбъект.Период);
		Иначе
			Если ТипЗнч(ДокументОбъект) = Тип("ВыборкаИзРезультатаЗапроса") Тогда
				ТаблЧасть = ДокументОбъект.РаботникиОрганизации.Выгрузить();
			Иначе
				ТаблЧасть = ДокументОбъект.РаботникиОрганизации.Выгрузить(, "МесяцРегистрации");
			КонецЕсли;
			ТаблЧасть.Сортировать("МесяцРегистрации Возр");
			Если ТаблЧасть.Количество() > 0 Тогда
				Возврат Мин(ТаблЧасть[0].МесяцРегистрации, ДокументОбъект.Дата);
			Иначе
				Возврат ДокументОбъект.Дата;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Процедура проверки версии документа на нарушение даты запрета
//
Процедура ПроверитьВерсиюДокумента(ДокументОбъект, ПараметрыПроверкиДокумента, СоответствиеГраницЗапрета, Отказ, РежимЗаписи = Неопределено) Экспорт
	
	Если ПараметрыПроверкиДокумента.ПроверятьПроведениеДокумента Тогда		
		ДокументПроведен = ДокументОбъект.Проведен ИЛИ ?(РежимЗаписи = Неопределено, ЛОЖЬ, РежимЗаписи = РежимЗаписиДокумента.Проведение);
		Если Не ДокументПроведен Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	// Не выполняется проверка дат запрета редактирования
	Если НЕ ПараметрыПроверкиДокумента.ПроверятьУправленческуюДатуЗапрета и
		НЕ ПараметрыПроверкиДокумента.ПроверятьРегламентированнуюДатуЗапрета Тогда
		
		Возврат;
	КонецЕсли;	
	
	ДатаДляПроверки = НастройкаПравДоступа.ПолучитьДатуДляПроверкиДокумента(ДокументОбъект, ПараметрыПроверкиДокумента);
	
	// Проверка регламентированной даты запрета
	Если ПараметрыПроверкиДокумента.ПроверятьРегламентированнуюДатуЗапрета Тогда	
		ГраницаПоОрганизации = СоответствиеГраницЗапрета[ДокументОбъект.Организация];
		
		// Если регламентированная дата запрета для регламентного документа не определена
		// то используется общая дата запрета изменения данных
		Если ГраницаПоОрганизации = Неопределено Тогда
			ГраницаПоОрганизации = СоответствиеГраницЗапрета["ОбщаяДатаЗапретаРедактирования"];
		КонецЕсли;
		
		Если НЕ ГраницаПоОрганизации = Неопределено 
			И ДатаДляПроверки <= КонецДня(ГраницаПоОрганизации)	Тогда
			
			Отказ = Истина;			
		КонецЕсли;		
	КонецЕсли;		    
	
	// Проверка управленческой даты запрета
	Если ПараметрыПроверкиДокумента.ПроверятьУправленческуюДатуЗапрета Тогда        
		ГраницаПериода = СоответствиеГраницЗапрета[Справочники.Организации.ПустаяСсылка()];       
		// Если управленческая дата запрета для управленческого документа не определена
		// то используется общая дата запрета изменения данных
		Если ГраницаПоОрганизации = Неопределено Тогда
			ГраницаПоОрганизации = СоответствиеГраницЗапрета["ОбщаяДатаЗапретаРедактирования"];
		КонецЕсли;
		
		Если ГраницаПериода <> Неопределено Тогда
			
			Если ДатаДляПроверки <= КонецДня(ГраницаПериода) Тогда
				Отказ = Истина;				
			КонецЕсли;         			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьВерсиюДокумента()

// Функция возвращает из БД версию документа до его изменения
//
Функция ПолучитьВерсиюДокументаПередИзменением(ДокументОбъект, ПараметрыПроверкиДокумента) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ 
	|Дата" 
	+ ?(ПараметрыПроверкиДокумента.ЕстьОрганизация, "," + Символы.ПС + "Организация КАК Организация", "")
	+ ?(ПараметрыПроверкиДокумента.ЕстьУправленческийУчет, "," + Символы.ПС + "ОтражатьВУправленческомУчете КАК ОтражатьВУправленческомУчете", "")
	+ ?(ПараметрыПроверкиДокумента.ЕстьБухгалтерскийУчет, "," + Символы.ПС + "ОтражатьВБухгалтерскомУчете КАК ОтражатьВБухгалтерскомУчете", "")
	+ ?(ПараметрыПроверкиДокумента.Свойство("ИмяПоляПериодаРегистрации"), "," + Символы.ПС + ПараметрыПроверкиДокумента.ИмяПоляПериодаРегистрации + " КАК " + ПараметрыПроверкиДокумента.ИмяПоляПериодаРегистрации, "")
	+ ?(ПараметрыПроверкиДокумента.ПроверятьПроведениеДокумента, "," + Символы.ПС + "Проведен КАК Проведен", "");
	
	ДополнитьТекстЗапросаПоТипуДокумета(Запрос.Текст, ПараметрыПроверкиДокумента);
	
	Запрос.Текст = Запрос.Текст + "
	|ИЗ Документ." + ПараметрыПроверкиДокумента.МетаданныеДокумента.Имя + "
	|ГДЕ Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОбъект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;
	
КонецФункции // ПолучитьВерсиюДокументаПередИзменением()

Процедура ДополнитьТекстЗапросаПоТипуДокумета(ТекстЗапроса, ПараметрыПроверкиДокумента)
	Если ПараметрыПроверкиДокумента.МетаданныеДокумента = Метаданные.Документы.ВводПроцентаДеятельностиЕНВД Тогда
		ТекстЗапроса = ТекстЗапроса + ",
			|ВводДанныхПоПериодам КАК ВводДанныхПоПериодам,
			|РаботникиОрганизации.(МесяцРегистрации) КАК РаботникиОрганизации";
	Иначе
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ОпределитьНеобходимостьПроверкиПоПериодуРегистрации(ПараметрыПроверкиДокумента, МетаданныеДокумента)
	
	Если МетаданныеДокумента.Реквизиты.Найти("ПериодРегистрации") <> Неопределено Тогда
		ПараметрыПроверкиДокумента.Вставить("ИмяПоляПериодаРегистрации", "ПериодРегистрации");
		Возврат;
	КонецЕсли;
	
	ИмяПоляПериодРегистрацииДокуметнов = Новый Соответствие;
	ИмяПоляПериодРегистрацииДокуметнов.Вставить(Метаданные.Документы.ВводПроцентаДеятельностиЕНВД,								"Период");
	ИмяПоляПериодРегистрацииДокуметнов.Вставить(Метаданные.Документы.ВводРаспределенияОсновногоЗаработкаРаботниковОрганизации,	"Период");
	
	АльтернативноеИмяРеквизита = ИмяПоляПериодРегистрацииДокуметнов[МетаданныеДокумента];
	Если АльтернативноеИмяРеквизита <> Неопределено Тогда
		ПараметрыПроверкиДокумента.Вставить("ИмяПоляПериодаРегистрации", АльтернативноеИмяРеквизита);
	КонецЕсли;		
	
КонецПроцедуры

// Функция возвращает структуру с параметрами проверки документа по умолчанию
//
Функция ПолучитьПараметрыПроверкиДокумента(ДокументОбъект) Экспорт
	
	ПараметрыПроверкиДокумента = Новый Структура;
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	
	ПараметрыПроверкиДокумента.Вставить("МетаданныеДокумента", МетаданныеДокумента);
	
	// если  в документе есть реквизит организация, дата запрета оперделяется с учетом организации
	ПараметрыПроверкиДокумента.Вставить("ЕстьОрганизация", 			(МетаданныеДокумента.Реквизиты.Найти("Организация") <> Неопределено));	
	ПараметрыПроверкиДокумента.Вставить("ЕстьУправленческийУчет",	(МетаданныеДокумента.Реквизиты.Найти("ОтражатьВУправленческомУчете") <> Неопределено));
    ПараметрыПроверкиДокумента.Вставить("ЕстьБухгалтерскийУчет", 	(МетаданныеДокумента.Реквизиты.Найти("ОтражатьВБухгалтерскомУчете") <> Неопределено));
	
	// если в документ 
	ОпределитьНеобходимостьПроверкиПоПериодуРегистрации(ПараметрыПроверкиДокумента, МетаданныеДокумента);
	
	// Если для документа проведение запрещено, проверка на дату запрета редактирования
	//проверяется без учета проведенности
	ПараметрыПроверкиДокумента.Вставить("ПроверятьПроведениеДокумента", (МетаданныеДокумента.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить));
		
	Если НастройкаПравДоступа.ЗаполнитьПараметрыПроверкиПоВидуДокумента(ДокументОбъект, ПараметрыПроверкиДокумента) Тогда
		Возврат ПараметрыПроверкиДокумента;
	КонецЕсли;
	
	ПроверятьУправленческуюДатуЗапрета      = (НЕ ПараметрыПроверкиДокумента.ЕстьОрганизация) или (ПараметрыПроверкиДокумента.ЕстьУправленческийУчет и ДокументОбъект["ОтражатьВУправленческомУчете"]);
	ПроверятьРегламентированнуюДатуЗапрета  = ПараметрыПроверкиДокумента.ЕстьОрганизация и (Не ПараметрыПроверкиДокумента.ЕстьБухгалтерскийУчет или ДокументОбъект["ОтражатьВБухгалтерскомУчете"]);	
			
	ПараметрыПроверкиДокумента.Вставить("ПроверятьУправленческуюДатуЗапрета", 		ПроверятьУправленческуюДатуЗапрета);
	ПараметрыПроверкиДокумента.Вставить("ПроверятьРегламентированнуюДатуЗапрета", 	ПроверятьРегламентированнуюДатуЗапрета);	
	
	Возврат ПараметрыПроверкиДокумента;
	
КонецФункции // ПолучитьПараметрыПроверкиДокумента()

Функция ПолучитьИмяПоляПериодаДляРегистра(ВидРегистра, РегистрМетаданные) Экспорт 
	
	ПолеПериод = "Период";
	
	Если ВидРегистра = "РегистрРасчета" Тогда
		ПолеПериод = "ПериодРегистрации";		
	ИначеЕсли ВидРегистра = "РегистрСведений" Тогда
		Если РегистрМетаданные.Имя = "ПроцентДеятельностиЕНВДСотрудников" 
			Или РегистрМетаданные.Имя = "РаспределениеЗаработкаРаботников" 
			Или РегистрМетаданные.Имя = "РаспределениеОсновногоЗаработкаРаботниковОрганизаций" Тогда
			ПолеПериод = "ПериодРегистрации";
		КонецЕсли; 
	ИначеЕсли ВидРегистра = "РегистрНакопления" Тогда
		Если РегистрМетаданные.Имя = "НДФЛСведенияОДоходах" Тогда
			ПолеПериод = "ПериодРегистрации";
		КонецЕсли; 
	КонецЕсли;			
	
	Возврат ПолеПериод;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ  - ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ МЕХАНИЗМА ДАТЫ ЗАПРЕТА РЕДАКТИРОВАНИЯ


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ  - ОБРАБОТЧИКИ ПОДПИСОК НА СОБЫТИЯ МЕХАНИЗМА РЕГИСТРАЦИИ ОБЪЕКТОВ ПРАВ ДОСТУПА ДОКУМЕНТОВ


/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ СОБЫТИЯ ЭЛЕМЕНТОВ УПРАВЛЕНИЯ ФОРМ


/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБСЛУЖИВАЮЩИЕ НАСЛЕДСТВЕННОСТЬ ПРАВ ДОСТУПА ИЕРАРХИЧЕСКИХ СПРАВОЧНИКОВ


Процедура ДополнитьНаборПравДоступаУнаследованнымиЗаписями(ПраваДоступаПользователей, ОбъектДоступа, Родитель) Экспорт
	
	ОбъектДоступаМетаданные = ОбъектДоступа.Метаданные();
	
	// Добавим записи, унаследованные от родителей
	Родители = Новый Массив;
	ТекущийРодитель = Родитель;
	Пока ЗначениеЗаполнено(ТекущийРодитель) Цикл
		Родители.Добавить(ТекущийРодитель);
		ТекущийРодитель = ТекущийРодитель.Родитель;
	КонецЦикла;
	Родители.Добавить(ТекущийРодитель);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений.НастройкиПравДоступаПользователей КАК ПраваДоступаПользователей
	|ГДЕ
	|	ПраваДоступаПользователей.ОбъектДоступа В(&Родители)
	|	И ПраваДоступаПользователей.ВидНаследованияПравДоступаИерархическихСправочников = &РаспространитьНаПодчиненных";
		
	Если ПраваДоступаПользователей.Отбор.ОбластьДанных.Использование Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И ПраваДоступаПользователей.ОбластьДанных = &ОбластьДанных";
		Запрос.УстановитьПараметр("ОбластьДанных", ПраваДоступаПользователей.Отбор.ОбластьДанных.Значение);
	КонецЕсли;

	Если ПраваДоступаПользователей.Отбор.Пользователь.Использование Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И ПраваДоступаПользователей.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", ПраваДоступаПользователей.Отбор.Пользователь.Значение);
	КонецЕсли;
		
	Запрос.УстановитьПараметр("Родители", Родители);
	Запрос.УстановитьПараметр("РаспространитьНаПодчиненных", Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.РаспространитьНаПодчиненных);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Запись = ПраваДоступаПользователей.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Выборка,,"ОбъектДоступа, ВидНаследованияПравДоступаИерархическихСправочников");
		Запись.ОбъектДоступа = ОбъектДоступа;
		Запись.ВидНаследованияПравДоступаИерархическихСправочников = Перечисления.ВидыНаследованияПравДоступаИерархическихСправочников.НаследуетсяОтРодителя;
	КонецЦикла;
	
КонецПроцедуры // () 


