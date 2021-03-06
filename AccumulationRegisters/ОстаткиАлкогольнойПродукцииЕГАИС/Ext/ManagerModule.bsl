
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//#Область СлужебныйПрограммныйИнтерфейс

// Записывает движения документа в регистр.
//
Процедура ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОстаткиАлкогольнойПродукцииЕГАИС;
	
	Если Отказ Или Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияОстаткиАлкогольнойПродукцииЕГАИС = Движения.ОстаткиАлкогольнойПродукцииЕГАИС;
	ДвиженияОстаткиАлкогольнойПродукцииЕГАИС.Записывать = Истина;
	ДвиженияОстаткиАлкогольнойПродукцииЕГАИС.Загрузить(Таблица);
	
КонецПроцедуры

//#КонецОбласти

//#Область ОбновлениеИнформационнойБазы

Функция ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию() Экспорт
	
	ДанныеКОбработке = Новый Массив;
	
	ПолноеИмяРегистра = "РегистрНакопления.ОстаткиАлкогольнойПродукцииЕГАИС";
	ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
	
	// Акт постановки на баланс
	ТекстЗапросаМеханизмаПроведения = Документы.АктПостановкиНаБалансЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.АктПостановкиНаБалансЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	// Акт списания
	ТекстЗапросаМеханизмаПроведения = Документы.АктСписанияЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.АктСписанияЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	// Возврат из регистра №2
	ТекстЗапросаМеханизмаПроведения = Документы.ВозвратИзРегистра2ЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ВозвратИзРегистра2ЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	// Запрос остатков
	ТекстЗапросаМеханизмаПроведения = Документы.ОстаткиЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ОстаткиЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	// Передача в регистр №2
	ТекстЗапросаМеханизмаПроведения = Документы.ПередачаВРегистр2ЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ПередачаВРегистр2ЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	// Входящая ТТН
	ТекстЗапросаМеханизмаПроведения = Документы.ТТНВходящаяЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ТТНВходящаяЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	// Исходящая ТТН
	ТекстЗапросаМеханизмаПроведения = Документы.ТТНИсходящаяЕГАИС.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	Регистраторы = ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения(
		ТекстЗапросаМеханизмаПроведения,
		ПолноеИмяРегистра,
		"Документ.ТТНИсходящаяЕГАИС");
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДанныеКОбработке,Регистраторы,Истина);
	
	Возврат ДанныеКОбработке;
	
КонецФункции

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(МассивСсылокРегистраторов) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.АктПостановкиНаБалансЕГАИС");
	Регистраторы.Добавить("Документ.АктСписанияЕГАИС");
	Регистраторы.Добавить("Документ.ВозвратИзРегистра2ЕГАИС");
	Регистраторы.Добавить("Документ.ОстаткиЕГАИС");
	Регистраторы.Добавить("Документ.ПередачаВРегистр2ЕГАИС");
	Регистраторы.Добавить("Документ.ТТНВходящаяЕГАИС");
	Регистраторы.Добавить("Документ.ТТНИсходящаяЕГАИС");
	
	ОбновлениеИнформационнойБазыЕГАИС.ПерезаписатьДвиженияИзОчереди(
		Регистраторы,
		"РегистрНакопления.ОстаткиАлкогольнойПродукцииЕГАИС",
		МассивСсылокРегистраторов);
	
КонецПроцедуры

//#КонецОбласти

#КонецЕсли