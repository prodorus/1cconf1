﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Проверим вид договора
	Для Каждого СтрДокОснования Из Объект.ДокументыОснования Цикл
		Если ЗначениеЗаполнено(СтрДокОснования.ДокументОснование) И
			СтрДокОснования.ДокументОснование.Метаданные().Имя = "ПоступлениеТоваровУслуг" И
			СтрДокОснования.ДокументОснование.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ВПереработку Тогда
				ТекстСообщения = НСтр("ru = 'Нельзя вводить счет-фактуру полученную на основании поступления материалов в переработку'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Объект,,, Отказ);
				Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		// Это существующий документ. 
		// Проверим, что его можно менять.
		НастройкаПравДоступа.ОпределитьДоступностьВозможностьИзмененияДокументаПоДатеЗапрета(РеквизитФормыВЗначение("Объект"), ЭтаФорма);

	КонецЕсли;
	ВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	
	// ЭлектронныеДокументы
	ИспользоватьОбменЭД = ЭлектронныеДокументыСлужебныйВызовСервера.ПолучитьЗначениеФункциональнойОпции("ИспользоватьОбменЭД");
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	// Конец ЭлектронныеДокументы
	
	СоставленОтИмени = ЗначениеЗаполнено(Объект.Продавец);
	
	УстановитьПредставлениеКППКонтрагента();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.ДокументыОснования.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	СтрокаСообщения = ТекущийОбъект.ПроверитьВозможностьЗаписиСФ(Отказ);
	Если СтрокаСообщения <> "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, ТекущийОбъект,,, Отказ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ЭлектронныеДокументы
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		УстановитьТекстСостоянияЭДНаСервере();
	ИначеЕсли ИмяСобытия = "ОбновитьДокументИБПослеЗаполнения" Тогда
		ЭтаФорма.Прочитать();
	КонецЕсли;
	// Конец ЭлектронныеДокумент
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстСостоянияЭДНаСервере()
	
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("КППКонтрагента") Тогда
		Модифицированность	= Истина;
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		УстановитьПредставлениеКППКонтрагента();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// ЭлектронныеДокументы
	ТекстСостоянияЭД = ЭлектронныеДокументыКлиентСервер.ПолучитьТекстСостоянияЭД(Объект.Ссылка, ЭтаФорма);
	// Конец ЭлектронныеДокументы
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОВТОРЯЮЩИЕСЯ ДЕЙСТВИЯ ПРИ ИЗМЕНЕНИИ РАЗНЫХ РЕКВИЗИТОВ

// Процедура устанавливает доступность элементов формы
//
&НаКлиенте
Процедура УстановитьДоступность()
	
	УказанДокументОснование = Объект.ДокументыОснования.Количество() > 0 И ЗначениеЗаполнено(Объект.ДокументыОснования[0].ДокументОснование);
	Элементы.Организация.ТолькоПросмотр			= УказанДокументОснование;
	Элементы.Контрагент.ТолькоПросмотр			= УказанДокументОснование;
	Элементы.ДоговорКонтрагента.ТолькоПросмотр	= УказанДокументОснование;
	Элементы.Продавец.ТолькоПросмотр 			= УказанДокументОснование И СоставленОтИмени;
	Элементы.СуммаДокумента.Заголовок = "Всего" + ?(ЗначениеЗаполнено(Объект.ВалютаДокумента), ", " + Объект.ВалютаДокумента, "");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ ДАННЫХ В ШАПКЕ

&НаСервере
Функция ИзменениеКонтрагентаСервер(ДанныеДляЗаполнения)
	
	УстановитьКППКонтрагента();

	СтруктураПараметровДляПолученияДоговора = ЗаполнениеДокументов.ПолучитьСтруктуруПараметровДляПолученияДоговораПродажи();
	
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ПриИзмененииЗначенияКонтрагента(ДанныеДляЗаполнения, СтруктураПараметровДляПолученияДоговора);
	Возврат ЗначенияДляЗаполнения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ИзменениеДоговораСервер(ДанныеДляЗаполнения)
	ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ПриИзмененииЗначенияДоговора(ДанныеДляЗаполнения);
	Возврат ЗначенияДляЗаполнения;
КонецФункции

&НаСервере
Процедура УстановитьКППКонтрагента()
	
	Если Объект.ДокументыОснования.Количество() > 0 Тогда
		Объект.КППКонтрагента	= УчетНДС.ПолучитьКПППодразделенияКонтрагента(Объект.ДокументыОснования[0].ДокументОснование, "Грузоотправитель");
	Иначе
		Объект.КППКонтрагента	= "";
	КонецЕсли;
	
	УстановитьПредставлениеКППКонтрагента();
	
	Элементы.ПредставлениеКППКонтрагента.Видимость	=
		НЕ ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Контрагент, "ЮрФизЛицо") = Перечисления.ЮрФизЛицо.ФизЛицо;
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьПредставлениеКППКонтрагента()
	
	Перем ЗначениеКППКонтрагента;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ПредставлениеКППКонтрагента	= "";
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Объект.КППКонтрагента) Тогда
		ЗначениеКППКонтрагента	= Объект.КППКонтрагента;
	Иначе
		ЗначениеКППКонтрагента	= ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Контрагент, "КПП");
	КонецЕсли;
	
	ПредставлениеКППКонтрагента	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'КПП %1'"), ?(ПустаяСтрока(ЗначениеКППКонтрагента), "<не задан>", ЗначениеКППКонтрагента));
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	ДанныеОбменаССервером = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ЗначенияДляЗаполнения = ИзменениеКонтрагентаСервер(ДанныеОбменаССервером);
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияДляЗаполнения);
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ДанныеОбменаССервером = Новый Структура("ДоговорКонтрагента, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ЗначенияДляЗаполнения = ИзменениеДоговораСервер(ДанныеОбменаССервером);
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияДляЗаполнения);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ ПустаяСтрока(Объект.Номер) Тогда
		ПрефиксацияОбъектовСобытия.ОчиститьНомерОбъекта(Объект.Номер, Объект.Организация);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеКППКонтрагентаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьТекстСообщения(
			"Поле", "Заполнение", "Контрагент");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Контрагент", "Объект");
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров	= Новый Структура("Контрагент, КППКонтрагента, РольКонтрагента");
	СтруктураПараметров.РольКонтрагента	= "Покупатель";
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, Объект);
	ОткрытьФормуМодально("ОбщаяФорма.ФормаВыбораКППУправляемая", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставленОтИмениПриИзменении(Элемент)
	
	Если НЕ СоставленОтИмени Тогда
		Объект.Продавец = Неопределено;
	КонецЕсли;
	
	УстановитьДоступность();	
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстСостоянияЭДНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Уникальность", 	Объект.Ссылка.УникальныйИдентификатор());
	ПараметрыОткрытия.Вставить("Источник", 		ЭтаФорма);
	
	ЭлектронныеДокументыКлиент.ОткрытьДеревоЭД(Объект.Ссылка, ПараметрыОткрытия);
	
КонецПроцедуры
