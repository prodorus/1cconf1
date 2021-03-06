////////////////////////////////////////////////////////////////////////////////

// Функция возвращает список работающих физлиц
// Используется документом Отсутствие на рабочем месте, что бы сообщить, работает физическое лицо или нет
//
Функция ПолучитьТаблицуРаботающихФизическихЛиц(ДатаСреза, СписокФизическихЛиц) Экспорт
	
	Запрос = Новый Запрос;
	
	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДатаСреза",				ДатаСреза);
	Запрос.УстановитьПараметр("СписокФизическихЛиц",	СписокФизическихЛиц);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РаботникиСрезПоследних.ФизЛицо КАК ФизЛицо
	|ИЗ
	|	РегистрСведений.Работники.СрезПоследних(&ДатаСреза, Физлицо В (&СписокФизическихЛиц)) КАК РаботникиСрезПоследних
	|ГДЕ
	|	РаботникиСрезПоследних.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	РаботникиСрезПоследних.Сотрудник.Физлицо
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(&ДатаСреза, Сотрудник.Физлицо В (&СписокФизическихЛиц)) КАК РаботникиСрезПоследних
	|ГДЕ
	|	РаботникиСрезПоследних.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Физлицо");
	
КонецФункции

// Процедура предназначена для записи наборов записей перерасчета для тех документов, которые затронуты
// данным набором записей регистра
// Если набор записей НадбавкиПоШтатномуРасписаниюОрганизаций записывается с датами, после которых проводились 
// начисления зарплаты (по тем же физлицам, по которым записываем начисления), то нужно переначислить 
// зарплату (т.е. перезаполнить соответствующие документы Начисление зарплаты)
// 
// Параметры:
//	нет
// Возвращаемое значение:
//	нет
//
Процедура ЗаписьПерерасчетовДляНадбавокПоШтатномуРасписанию(Отбор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	УсловиеТекст = "";
	Для Каждого ЭлементОтбора из Отбор Цикл
		
			Если не ПустаяСтрока(УсловиеТекст) Тогда
				УсловиеТекст = УсловиеТекст + " И ";
			КонецЕсли;
			УсловиеТекст = УсловиеТекст + "Надбавки." + ЭлементОтбора.Ключ + " = &" + ЭлементОтбора.Ключ;
			Запрос.УстановитьПараметр(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
		
	КонецЦикла;
	Если Не ПустаяСтрока(УсловиеТекст) Тогда
		УсловиеТекст = "ГДЕ " + УсловиеТекст;
	КонецЕсли;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Надбавки.ПодразделениеОрганизации,
	|	Надбавки.Должность,
	|	МИНИМУМ(Надбавки.Период) КАК Период,
	|	ВЫБОР
	|		КОГДА Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Надбавки.ПодразделениеОрганизации.Владелец
	|		ИНАЧЕ Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация
	|	КОНЕЦ КАК Организация
	|ПОМЕСТИТЬ ВТДанныеШтатногоРасписания
	|ИЗ
	|	РегистрСведений.НадбавкиПоШтатномуРасписаниюОрганизаций КАК Надбавки " + УсловиеТекст 
	+ "
	|
	|СГРУППИРОВАТЬ ПО
	|	Надбавки.ПодразделениеОрганизации,
	|	Надбавки.Должность,
	|	ВЫБОР
	|		КОГДА Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			ТОГДА Надбавки.ПодразделениеОрганизации.Владелец
	|		ИНАЧЕ Надбавки.ПодразделениеОрганизации.Владелец.ГоловнаяОрганизация
	|	КОНЕЦ ";
	Запрос.Выполнить();
	
	ЗапросТекст = 
	"ВЫБРАТЬ
	|	ВыбранныеЗаписи.Регистратор КАК Регистратор,
	|	ВыбранныеЗаписи.ФизЛицо,
	|	ВыбранныеЗаписи.Сотрудник,
	|	ВыбранныеЗаписи.Организация
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		Расчеты.Регистратор КАК Регистратор,
	|		Расчеты.ФизЛицо КАК ФизЛицо,
	|		Расчеты.Сотрудник КАК Сотрудник,
	|		Расчеты.Организация КАК Организация
	|	ИЗ
	|		ВТДанныеШтатногоРасписания КАК Надбавки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				РаботникиОрганизации.ПодразделениеОрганизации КАК ПодразделениеОрганизации,
	|				РаботникиОрганизации.Должность КАК Должность,
	|				РаботникиОрганизации.Сотрудник КАК Сотрудник
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизации
	|			ГДЕ
	|				РаботникиОрганизации.Организация В
	|						(ВЫБРАТЬ
	|							Надбавки.Организация
	|						ИЗ
	|							ВТДанныеШтатногоРасписания КАК Надбавки)
	|			
	|			ОБЪЕДИНИТЬ ВСЕ
	|			
	|			ВЫБРАТЬ
	|				Работники.ПодразделениеОрганизацииЗавершения,
	|				Работники.ДолжностьЗавершения,
	|				Работники.Сотрудник
	|			ИЗ
	|				РегистрСведений.РаботникиОрганизаций КАК Работники
	|					ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РаботникиОрганизаций КАК ПериодыПерекрытия
	|					ПО (ПериодыПерекрытия.Период <= Работники.ПериодЗавершения)
	|						И (ПериодыПерекрытия.Период > Работники.Период)
	|						И (ПериодыПерекрытия.Сотрудник = Работники.Сотрудник)
	|			ГДЕ
	|				Работники.Организация В
	|						(ВЫБРАТЬ
	|							Надбавки.Организация
	|						ИЗ
	|							ВТДанныеШтатногоРасписания КАК Надбавки)
	|				И Работники.ПериодЗавершения <> ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
	|				И ПериодыПерекрытия.Период ЕСТЬ NULL ) КАК РаботникиОрганизации
	|			ПО (РаботникиОрганизации.ПодразделениеОрганизации = Надбавки.ПодразделениеОрганизации)
	|				И (РаботникиОрганизации.Должность = Надбавки.Должность)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций КАК Расчеты
	|			ПО (Расчеты.Сотрудник = РаботникиОрганизации.Сотрудник)
	|				И (Расчеты.ПериодДействияНачало >= Надбавки.Период)) КАК ВыбранныеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ОсновныеНачисленияРаботниковОрганизаций.ПерерасчетОсновныхНачислений КАК Перерасчеты
	|		ПО (Перерасчеты.ОбъектПерерасчета = ВыбранныеЗаписи.Регистратор)
	|			И (Перерасчеты.ФизЛицо = ВыбранныеЗаписи.ФизЛицо)
	|			И (Перерасчеты.ВидРасчета = ЗНАЧЕНИЕ(ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ПустаяСсылка))
	|ГДЕ
	|	Перерасчеты.ОбъектПерерасчета ЕСТЬ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор";
	
	Запрос.Текст = ЗапросТекст;
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПроведениеРасчетов.ДописатьПерерасчетыОсновныхНачислений(Выборка);
	

КонецПроцедуры // ЗаписьПерерасчетовДляНадбавокПоШтатномуРасписанию()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ДЛЯ ЗАПИСИ ТЕКУЩИХ КАДРОВЫХ ДАННЫХ СОТРУДНИКА КОМПАНИИ

Процедура УстановитьРеквизитыИЗаписатьСотрудника(Выборка, Отказ)

	Пока Выборка.Следующий() Цикл
		
		СотрудникОбъект = Выборка.Сотрудник.ПолучитьОбъект();
		
		Если СотрудникОбъект = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		СотрудникОбъект.ТекущееПодразделениеКомпании	= Выборка.Подразделение;
		СотрудникОбъект.ТекущаяДолжностьКомпании		= Выборка.Должность;
		СотрудникОбъект.ДатаПриемаНаРаботуВКомпанию		= Выборка.ДатаПриемаНаРаботу;
		СотрудникОбъект.ДатаУвольненияИзКомпании		= Выборка.ДатаУвольнения;
		
		Попытка	
			СотрудникОбъект.Заблокировать();
		Исключение
			ОбщегоНазначенияЗК.СообщитьОбъектЗаблокирован(Строка(Выборка.Сотрудник), "сотрудника");
			Возврат;
		КонецПопытки;
		СотрудникОбъект.ПолучитьКадровыеДанныеФизлица = Ложь;
		СотрудникОбъект.Записать();
		
	КонецЦикла;

КонецПроцедуры

// В процедуре всем сотрудникам, которые есть в документе регистраторе,
// устанавливаются текущие кадровые данные
// Перед записью данных необходимо отобрать данные без учета регистратора
// При записи данных необходимо отбирать данные с учетом регистратора
//
Процедура ЗаписатьТекущиеКадровыеДанныеСотрудника(Отказ, Замещение, БезРегистратора, Регистратор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Работники.ФизЛицо КАК Физлицо
	|ПОМЕСТИТЬ ВТФизлица
	|ИЗ
	|	РегистрСведений.Работники КАК Работники
	|ГДЕ
	|	Работники.Регистратор = &Регистратор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиОрганизаций.Ссылка КАК Сотрудник,
	|	СотрудникиОрганизаций.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлица КАК Физлица)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудник,
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РаботникиПодразделение.ФизЛицо,
	|	РаботникиПодразделение.Подразделение,
	|	РаботникиПодразделение.Должность
	|ПОМЕСТИТЬ ВТ_РаботникиПодразделениеДолжность
	|ИЗ
	|	РегистрСведений.Работники.СрезПоследних(
	|			,
	|			Физлицо В
	|					(ВЫБРАТЬ
	|						Физлица.Физлицо
	|					ИЗ
	|						ВТФизлица КАК Физлица)
	|					" + ?(БезРегистратора, "И Регистратор <> &Регистратор", "") + ") КАК РаботникиПодразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сотрудники.Сотрудник,
	|	Сотрудники.Сотрудник.Физлицо КАК Физлицо,
	|	РаботникиСрезПоследних.Подразделение КАК Подразделение,
	|	РаботникиСрезПоследних.Должность КАК Должность,
	|	ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриемаНаРаботу,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		КОГДА ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1)) > ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1))
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(РаботникиУвольнение.Период, ДЕНЬ, -1)
	|	КОНЕЦ КАК ДатаУвольнения
	|ИЗ
	|	ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_РаботникиПодразделениеДолжность КАК РаботникиСрезПоследних
	|		ПО Сотрудники.Физлицо = РаботникиСрезПоследних.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(
	|				,
	|				Физлицо В
	|						(ВЫБРАТЬ
	|							Физлица.Физлицо
	|						ИЗ
	|							ВТФизлица КАК Физлица)
	|					И ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу)
	|					" + ?(БезРегистратора, "И Регистратор <> &Регистратор", "") + ") КАК РаботникиПрием
	|		ПО Сотрудники.Физлицо = РаботникиПрием.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(
	|				,
	|				Физлицо В
	|						(ВЫБРАТЬ
	|							Физлица.Физлицо
	|						ИЗ
	|							ВТФизлица КАК Физлица)
	|					И ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)
	|					" + ?(БезРегистратора, "И Регистратор <> &Регистратор", "") + ") КАК РаботникиУвольнение
	|		ПО Сотрудники.Физлицо = РаботникиУвольнение.ФизЛицо
	|ГДЕ
	|	(Сотрудники.Сотрудник.ТекущееПодразделениеКомпании <> ЕСТЬNULL(РаботникиСрезПоследних.Подразделение, ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ТекущаяДолжностьКомпании <> ЕСТЬNULL(РаботникиСрезПоследних.Должность, ЗНАЧЕНИЕ(Справочник.ДолжностиОрганизаций.ПустаяСсылка))
	|			ИЛИ Сотрудники.Сотрудник.ДатаПриемаНаРаботуВКомпанию <> ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1))
	|			ИЛИ Сотрудники.Сотрудник.ДатаУвольненияИзКомпании <> ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)))";
	
	// временная таблица ВТ_РаботникиПодразделениеДолжность используется в переопределяемой части запроса
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	УстановитьРеквизитыИЗаписатьСотрудника(Выборка, Отказ);
	ФизлицаВторичныеДанныеПереопределяемый.УстановитьРеквизитыИЗаписатьФизлицо(Запрос, Отказ);
	
КонецПроцедуры

Функция ПолучитьТекущиеКадровыеДанныеФизлица(Физлицо, Отказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Физлицо", Физлицо);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РаботникиСрезПоследних.Подразделение КАК Подразделение,
	|	РаботникиСрезПоследних.Должность КАК Должность,
	|	ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПриемаНаРаботу,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1)) = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		КОГДА ЕСТЬNULL(РаботникиПрием.Период, ДАТАВРЕМЯ(1, 1, 1)) > ЕСТЬNULL(РаботникиУвольнение.Период, ДАТАВРЕМЯ(1, 1, 1))
	|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
	|		ИНАЧЕ ДОБАВИТЬКДАТЕ(РаботникиУвольнение.Период, ДЕНЬ, -1)
	|	КОНЕЦ КАК ДатаУвольнения
	|ИЗ
	|	РегистрСведений.Работники.СрезПоследних(, Физлицо = &Физлицо) КАК РаботникиСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(
	|				,
	|				Физлицо = &Физлицо
	|					И ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.ПриемНаРаботу)) КАК РаботникиПрием
	|		ПО РаботникиСрезПоследних.ФизЛицо = РаботникиПрием.ФизЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Работники.СрезПоследних(
	|				,
	|				Физлицо = &Физлицо
	|					И ПричинаИзмененияСостояния = ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)) КАК РаботникиУвольнение
	|		ПО РаботникиСрезПоследних.ФизЛицо = РаботникиУвольнение.ФизЛицо";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтруктураКадровыеДанные = Новый Структура("ТекущееПодразделениеКомпании, ТекущаяДолжностьКомпании, ДатаПриемаНаРаботуВКомпанию, ДатаУвольненияИзКомпании");
	
	Если Выборка.Следующий() Тогда
		СтруктураКадровыеДанные.ТекущееПодразделениеКомпании	= Выборка.Подразделение;
		СтруктураКадровыеДанные.ТекущаяДолжностьКомпании		= Выборка.Должность;
		СтруктураКадровыеДанные.ДатаПриемаНаРаботуВКомпанию		= Выборка.ДатаПриемаНаРаботу;
		СтруктураКадровыеДанные.ДатаУвольненияИзКомпании		= Выборка.ДатаУвольнения;
	КонецЕсли;
	
	Возврат СтруктураКадровыеДанные;
	
КонецФункции
