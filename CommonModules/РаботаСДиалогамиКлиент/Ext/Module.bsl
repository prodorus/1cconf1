////////////////////////////////////////////////////////////////////////////////
// ВЫБОР ЗНАЧЕНИЙ В ФОРМЕ

// СПЕЦИФИКАЦИИ

// Процедура выполняет стандартные действия при начале выбора спецификации в формах документов.
//
// Параметры:
//  Номенклатура - ссылка на справочник, определяет продукцию, которая указана в спецификации;
//  ЭлементФормы             - элемент формы документа, который надо заполнить; 
//  СтандартнаяОбработка,    - булево, признак выполнения стандартной (системной) обработки события 
//                             начала выбора для данного элемента формы документа.
//
Процедура НачалоВыбораЗначенияСпецификации(Номенклатура, ЭлементФормы, СтандартнаяОбработка, ТолькоАктивные = Истина) Экспорт
	СтандартнаяОбработка    = Ложь;
	ПараметрыФормы = Новый Структура("Номенклатура", Номенклатура);
	ПараметрыФормы.Вставить("ТолькоАктивные", ТолькоАктивные);
	ОткрытьФорму("Справочник.СпецификацииНоменклатуры.Форма.ФормаВыбораУправляемая", ПараметрыФормы, ЭлементФормы);
КонецПроцедуры // НачалоВыбораЗначенияСпецификации()

////////////////////////////////////////////////////////////////////////////////
// ИНТЕРАКТИВНЫЕ ДЕЙСТВИЯ ПРИ ЗАПОЛНЕНИИ ЗНАЧЕНИЙ В ДОКУМЕНТАХ

// ПОДРАЗДЕЛЕНИЯ ОРГАНИЗАЦИЙ

Процедура ЗаполнитьПодразделениеОрганизации(Объект) Экспорт
	
	// Получим с сервера подходящее подразделение организации
	ПодразделениеОрганизации = РаботаСДиалогамиСервер.ПодразделениеОрганизации(Объект.Подразделение, Объект.Организация);
	
	Если НЕ ЗначениеЗаполнено(ПодразделениеОрганизации) Тогда
		Возврат;
	КонецЕсли;

	Если Объект.ПодразделениеОрганизации = ПодразделениеОрганизации Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ПодразделениеОрганизации = ПодразделениеОрганизации;
	
КонецПроцедуры

// ЕДИНИЦЫ ИЗМЕРЕНИЯ МЕСТ

// Если не задана единица мест, то количество мест не имеет смысла и должно быть очищено
// Следует вызывать при изменении единицы мест
Процедура ОчиститьКоличествоМестПриОчисткеЕдиницыМест(СтрокаТабличнойЧасти) Экспорт
	
	Если СтрокаТабличнойЧасти.КоличествоМест <> 0 И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест) Тогда
		СтрокаТабличнойЧасти.КоличествоМест = 0;
	КонецЕсли;
	
КонецПроцедуры

// Рассчитывает количество исходя из количества мест
Процедура РассчитатьКоличествоТабЧасти(СтрокаТабличнойЧасти, СведенияЕдиницаИзмеренияМест = Неопределено) Экспорт
	
	// Рассчитываем, только если указана единица измерения мест
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// Если не указана единица измерения и коэффициент, то количество не имеет смысла
	Если СтрокаТабличнойЧасти.Коэффициент = 0 Тогда
		СтрокаТабличнойЧасти.Количество = 0;
		Возврат;
	КонецЕсли;
	
	// Получим с сервера сведения об единице измерения мест
	Если СведенияЕдиницаИзмеренияМест = Неопределено Тогда
		СведенияЕдиницаИзмеренияМест = РаботаСДиалогамиСервер.СведенияЕдиницаИзмеренияМест(СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест);
	КонецЕсли;
	
	// Количество мест не имеет смысла
	Если СведенияЕдиницаИзмеренияМест.Коэффициент = 0 Тогда
		СтрокаТабличнойЧасти.Количество = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест Тогда
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.КоличествоМест;
	Иначе
		СтрокаТабличнойЧасти.Количество = 
			СтрокаТабличнойЧасти.КоличествоМест
		  * СведенияЕдиницаИзмеренияМест.Коэффициент
		  / СтрокаТабличнойЧасти.Коэффициент;
	КонецЕсли;

КонецПроцедуры // РассчитатьКоличествоТабЧасти()

// Рассчитывает количество мест исходя из количества
Процедура РассчитатьКоличествоМестТабЧасти(СтрокаТабличнойЧасти, СведенияЕдиницаИзмеренияМест = Неопределено) Экспорт

	// Рассчитываем, только если указана единица измерения мест
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест) Тогда
		
		// Без указания единицы мест больше ничего не делаем
		Возврат;
		
	КонецЕсли;
	
	// Если не указана единица измерения и коэффициент, пересчет невозможен
	Если СтрокаТабличнойЧасти.Коэффициент = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Получим с сервера сведения об единице измерения мест
	Если СведенияЕдиницаИзмеренияМест = Неопределено Тогда
		СведенияЕдиницаИзмеренияМест = РаботаСДиалогамиСервер.СведенияЕдиницаИзмеренияМест(СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест);
	КонецЕсли;
	
	// Количество мест не имеет смысла
	Если СведенияЕдиницаИзмеренияМест.Коэффициент = 0 Тогда
		СтрокаТабличнойЧасти.КоличествоМест = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтрокаТабличнойЧасти.ЕдиницаИзмеренияМест Тогда
		// Используем переменную, так как в неё потребуется записать неокругленное значение, а затем округлить по специальным правилам.
		КоличествоМест = СтрокаТабличнойЧасти.Количество;
	Иначе
		КоличествоМест = 
			  СтрокаТабличнойЧасти.Количество 
			* СтрокаТабличнойЧасти.Коэффициент
			/ СведенияЕдиницаИзмеренияМест.Коэффициент;
	КонецЕсли;
	
	Если Цел(КоличествоМест) <> КоличествоМест Тогда
		
		//Округление КоличествоМест в соответствии с настройками единицы ЕдиницаИзмеренияМест
		Если СведенияЕдиницаИзмеренияМест.ПредупреждатьОНецелыхМестах Тогда
			
			//Формирование предупреждения о нецелом количестве мест
			ПоказатьОповещениеПользователя(Нстр("ru='Расчет количества мест'"), , Нстр("ru='Количество мест округлено'"));
			
		КонецЕсли;
		
		Если СведенияЕдиницаИзмеренияМест.ПорогОкругления = 0 Тогда
			
			//Округление в сторону уменьшения
			КоличествоМест = Цел(КоличествоМест);
			
		Иначе
			
			//расчет количества в базовых единицах, не поместившегося в целое количество мест - ОстатокВБазовыхЕИ
			КоличествоВБазовыхЕИ = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Коэффициент;
			ОстатокВБазовыхЕИ    = КоличествоВБазовыхЕИ - Цел(КоличествоМест) * СведенияЕдиницаИзмеренияМест.Коэффициент;
			
			Если ОстатокВБазовыхЕИ < СведенияЕдиницаИзмеренияМест.ПорогОкругления Тогда
				
				КоличествоМест = Цел(КоличествоМест);
				
			Иначе
				
				КоличествоМест = Цел(КоличествоМест)+1;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли; // Конец обработки нецелого значения
	
	СтрокаТабличнойЧасти.КоличествоМест = КоличествоМест;

КонецПроцедуры // РассчитатьКоличествоМестТабЧасти()

// СКЛАД ОРДЕР

// Процедура в зависимости от вида поступления устанавливает тип для реквизита "СкладОрдер"
//
// Параметры:
//  ДокументОбъект - объект документа,
//  ЭлементыФормы  - элементы формы,
//	ЭтоПоступлениеПоОрдеру - булево, признак того что ВидПоступления = ПоОрдеру
//		передается в виде параметра, чтобы не пришлось использовать ПредопределенноеЗначение() для определения вида поступления
//  ВидОперации    - строка, определяет вид операции,возможнве значения "Поступление", "Возврат",
//                   по умолчанию "Поступление".
//
Процедура УстановитьТипСкладаОрдера(ДокументОбъект, ЭлементыФормы, ЭтоПоступлениеПоОрдеру, ВидОперации = "Поступление") Экспорт
	Если ЭтоПоступлениеПоОрдеру Тогда
		Если ТипЗнч(ДокументОбъект.СкладОрдер)<>Тип("ДокументСсылка.ПриходныйОрдерНаТовары") Тогда
			ОписаниеТипов = Новый ОписаниеТипов("ДокументСсылка.ПриходныйОрдерНаТовары");
			ДокументОбъект.СкладОрдер = ОписаниеТипов.ПривестиЗначение(ДокументОбъект.СкладОрдер);
		КонецЕсли;
		ЭлементыФормы.СкладОрдер.Подсказка = НСтр("ru = 'В этом поле необходимо указать приходный ордер, по которому ранее было оформлено поступление товаров.'");
	Иначе
		Если ТипЗнч(ДокументОбъект.СкладОрдер)<>Тип("СправочникСсылка.Склады") Тогда
			ОписаниеТипов = Новый ОписаниеТипов("СправочникСсылка.Склады");
			ДокументОбъект.СкладОрдер = ОписаниеТипов.ПривестиЗначение(ДокументОбъект.СкладОрдер);
		КонецЕсли;

		ТекстПодсказки = НСтр("ru = 'В этом поле необходимо указать склад'");

		Если      ВидОперации = "Поступление" Тогда
			ТекстПодсказки = ТекстПодсказки + НСтр("ru = ', на который необходимо оформить поступление товаров'")
		ИначеЕсли ВидОперации = "Возврат"     Тогда
			ТекстПодсказки = ТекстПодсказки + НСтр("ru = ', на который оформляется возврат товаров'");
		КонецЕсли;

		ЭлементыФормы.СкладОрдер.Подсказка = ТекстПодсказки + ".";
	КонецЕсли;

КонецПроцедуры // УстановитьТипСкладаОрдера()

// Рассчитывает сумму в строке табличной части документа
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//  СтруктураПараметров - структура, содержащая сведения о наличии реквизитов таб.части
//  ВидРасчета           - "Со всеми скидками", сумма минус скидки;
//                         "Без учета ручной скидки", сумма минус автоматические скидки;
//                         "Без учета скидок", сумма (Цена * Количество);
//
Процедура РассчитатьСуммуТабЧасти(СтрокаТабличнойЧасти, СтруктураПараметров = Неопределено) Экспорт

	Сумма = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
	СуммаСкидки = 0;

	Если СтруктураПараметров <> Неопределено И СтруктураПараметров.Свойство("ЕстьПроцентАвтоматическихСкидок") Тогда
		СуммаСкидки = Сумма * СтрокаТабличнойЧасти.ПроцентАвтоматическихСкидок / 100;
	КонецЕсли;

	Если СтруктураПараметров <> Неопределено И СтруктураПараметров.Свойство("ЕстьПроцентСкидкиНаценки") Тогда
		СуммаСкидки = СуммаСкидки + (Сумма * СтрокаТабличнойЧасти.ПроцентСкидкиНаценки / 100);
	КонецЕсли;

	СтрокаТабличнойЧасти.Сумма = Сумма - СуммаСкидки;
КонецПроцедуры // РассчитатьСуммуТабЧасти()

// Расчет суммы НДС
//
// Параметры:
//  СтрокаТабличнойЧасти - строка табличной части документа,
//  ПроцентыСтавокНДС 		- соответствие между элементами перечисления СтавкиНДС и числом (% ставки)
//  СтруктураПараметров       - структура, содержащая сведения из реквизитов шапки.
//
Процедура РассчитатьСуммуНДСТабЧасти(СтрокаТабличнойЧасти, ПроцентыСтавокНДС, СтруктураПараметров) Экспорт

	Если НЕ СтруктураПараметров.УчитыватьНДС ИЛИ СтрокаТабличнойЧасти.Сумма = 0 Тогда
		СтрокаТабличнойЧасти.СуммаНДС = 0;
		Возврат;
	КонецЕсли;
	ПроцентНДС = ПроцентыСтавокНДС.Получить(СтрокаТабличнойЧасти.СтавкаНДС);
	Если ПроцентНДС = Неопределено Тогда
		ПроцентНДС = 0;
	КонецЕсли;
	
	Если СтруктураПараметров.СуммаВключаетНДС Тогда
		СуммаБезНДС = 100 * СтрокаТабличнойЧасти.Сумма / (100 + ПроцентНДС);
		СуммаНДС = СтрокаТабличнойЧасти.Сумма - СуммаБезНДС;
	Иначе
		СуммаНДС = СтрокаТабличнойЧасти.Сумма * ПроцентНДС / 100;
	КонецЕсли;
	СтрокаТабличнойЧасти.СуммаНДС = СуммаНДС;
КонецПроцедуры // РассчитатьСуммуНДСТабЧасти()

// Процедура выполняет стандартные действия при изменении суммы 
// в строке табличной части документа.
//
// Параметры:
//  СтрокаТабличнойЧасти 					- строка табличной части документа,
//  ПересчитыватьСкидку				 		- признак необходимости пересчета скидки для данного пользователя,
Процедура ПриИзмененииСуммыТабЧасти(СтрокаТабличнойЧасти, ПересчитыватьСкидкуДокумента = Ложь) Экспорт
	ЕстьРеквизитПроцентСкидкиНаценки = СтрокаТабличнойЧасти.Свойство("ПроцентСкидкиНаценки");
	ЕстьРеквизитПроцентАвтоматическихСкидок = СтрокаТабличнойЧасти.Свойство("ПроцентАвтоматическихСкидок");
	Если СтрокаТабличнойЧасти.Количество=0 Тогда
		СтрокаТабличнойЧасти.Цена = 0;
		Возврат;
	ИначеЕсли НЕ ЕстьРеквизитПроцентСкидкиНаценки Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
		Возврат;
	КонецЕсли;
	//Обработка ситуации когда ЕстьРеквизитПроцентСкидкиНаценки
	ПроцентАвтоматическихСкидок = 0;
	Если ЕстьРеквизитПроцентАвтоматическихСкидок Тогда
		ПроцентАвтоматическихСкидок = СтрокаТабличнойЧасти.ПроцентАвтоматическихСкидок;
	КонецЕсли;
	Если ПересчитыватьСкидкуДокумента Тогда
		Если (СтрокаТабличнойЧасти.Цена = 0) Тогда
			СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = 0;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Цена равна 0, после изменения суммы установлена нулевая скидка!'"));
		Иначе
			СуммаСоСкидками = СтрокаТабличнойЧасти.Сумма;
			СуммаБезСкидок  = СтрокаТабличнойЧасти.Цена * СтрокаТабличнойЧасти.Количество;
			ПроцентСкидки   = 100 - (СуммаСоСкидками*100)/СуммаБезСкидок;
			СтрокаТабличнойЧасти.ПроцентСкидкиНаценки = ПроцентСкидки - ПроцентАвтоматическихСкидок;
		КонецЕсли;
	Иначе
		ПроцентСкидки = СтрокаТабличнойЧасти.ПроцентСкидкиНаценки + ПроцентАвтоматическихСкидок;
		Если ПроцентСкидки >= 100 Тогда
			СтрокаТабличнойЧасти.Цена = 0;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Скидка больше или равна 100%, после изменения суммы установлена нулевая цена!'"));
		Иначе
			СуммаБезСкидок  = СтрокаТабличнойЧасти.Сумма * 100/
							  (100 - ПроцентСкидки);
			СтрокаТабличнойЧасти.Цена = СуммаБезСкидок / СтрокаТабличнойЧасти.Количество;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // ПриИзмененииСуммыТабЧасти()

//Процедура заполняет реквизиты КурсВзаиморасчетов и КратностьВзаиморасчетов
Процедура ЗаполнитьКурсИКратностьДокумента(ДокументОбъект, ВалютаРегламентированногоУчета) Экспорт
	ЗначенияДляЗаполнения = Новый Структура("КурсВзаиморасчетов, КратностьВзаиморасчетов", 0, 0);
	Если ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда
		Если ДокументОбъект.ВалютаДокумента = ВалютаРегламентированногоУчета Тогда
			ЗначенияДляЗаполнения.КурсВзаиморасчетов = 1;
			ЗначенияДляЗаполнения.КратностьВзаиморасчетов = 1;
		Иначе
			ДанныеОбменаССервером = Новый Структура("ВалютаДокумента, Дата");
			ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, ДокументОбъект);
			ЗначенияДляЗаполнения = РаботаСДиалогамиСервер.ПолучитьКурсВалюты(ДанныеОбменаССервером);
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ЗначенияДляЗаполнения);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЗАПОЛНЕНИЕ ДОКУМЕНТОВ

// Инициирует выбор пользователем настройки, затем открывает форму объекта, 
// заполненного по выбранной настройке
// 
// Параметры:
//  КлючОбъекта - ключ заполняемого объекта, например - "Документ.ОтчетМастераСмены", "Справочник.Номенклатура"
Процедура ОткрытьФормуЗаполненнуюПоНастройке(КлючОбъекта) Экспорт
	
	// Откроем форму выбора настройки с "отбором" по виду документа
	ИмяФормы = "ХранилищеНастроек.ДанныеФорм.Форма.ФормаЗагрузки";
	ВыборНастроек = ОткрытьФормуМодально(ИмяФормы,	Новый Структура("КлючОбъекта", КлючОбъекта));
	
	Если ВыборНастроек <> Неопределено Тогда
		// Если пользователь выбрал настройку, то откроем форму нового объекта, заполненного на основании выбранной настройки
		ОткрытьФорму(КлючОбъекта + ".ФормаОбъекта", Новый Структура("Основание", ВыборНастроек.КлючНастроек));
	КонецЕсли;
	
КонецПроцедуры

// Универсальная процедура, которая инициирует механизм подбора
// номенклатуры в документы (открывает основную форму обработки подбор).
//
// Параметры:
//  ФормаДокумента - форма документа, в который осуществляется подбор,
//  СтруктураПараметров - параметры, которые передаются в форму подбора.
//
Процедура ОткрытьПодборНоменклатуры(ФормаДокумента, СтруктураПараметров) Экспорт

	СтруктураПараметров.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	// По умолчанию услуги нелья подбирать
	Если НЕ СтруктураПараметров.Свойство("ОтборУслугПоСправочнику") Тогда
		СтруктураПараметров.Вставить("ОтборУслугПоСправочнику", Истина);
	КонецЕсли; 
	Если НЕ СтруктураПараметров.Свойство("ПодбиратьУслуги") Тогда
		СтруктураПараметров.Вставить("ПодбиратьУслуги", Ложь);
	КонецЕсли; 
	
	ОткрытьФормуМодально("ОбщаяФорма.ФормаПодбораНоменклатурыУправляемая", СтруктураПараметров, ФормаДокумента);
	
КонецПроцедуры //
 
// Спрашивает пользователя, перезаполнять ли табличную часть, если
// в ней уже есть данные.
//
// Параметры
//  ТабличнаяЧасть - заполняемая табличная часть
// 
// Возвращаемое значение
//  Истина - пользователь отказался от заполнения
//  Ложь   - в табличной части нет строк или пользователь согласился с их удалением
Функция ПользовательОтказалсяПерезаполнитьТабличнуюЧасть(ТабличнаяЧасть) Экспорт
	
	Если ТабличнаяЧасть.Количество() > 0 Тогда
		ТекстВопроса = Нстр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

