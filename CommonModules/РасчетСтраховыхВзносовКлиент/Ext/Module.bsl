
Процедура РассчитатьВзносы(ДокументОбъект, ФормаДокумента = Неопределено) Экспорт
	
	Если ДокументОбъект.ИсчисленныеСтраховыеВзносы.Количество() <> 0 Тогда
		
		ТекстВопроса1 = "Текущие данные о взносах будут удалены. Продолжить?";
		Если РаботаСДиалогами.ЗадатьВопрос(ТекстВопроса1, РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
		
	ДокументОбъект.ИсчисленныеСтраховыеВзносы.Очистить();
	
	Если ФормаДокумента <> Неопределено Тогда
		ФормаДокумента.Обновить();
	КонецЕсли;
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();
	
	ДокументОбъект.ЗаполнитьИРассчитать(Ложь, Истина);
	
	ОбработкаКомментариев.ПоказатьСообщения();

КонецПроцедуры

Процедура ЗаполнитьИРассчитать(ДокументОбъект, ФормаДокумента) Экспорт
	
	ТабличныеЧасти = ДокументОбъект.Метаданные().ТабличныеЧасти;
	
	СтрокДанных = 0;
	Для каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		Если ТабличнаяЧасть.Имя = "ФизическиеЛица" Тогда
			Продолжить;	
		КонецЕсли;
		СтрокДанных = СтрокДанных + ДокументОбъект[ТабличнаяЧасть.Имя].Количество();
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СтрокДанных) Тогда
		
		ТекстВопроса1 = "Текущие данные о доходах и взносах будут удалены. Продолжить?";
		Если РаботаСДиалогами.ЗадатьВопрос(ТекстВопроса1, РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
		
	Если ДокументОбъект.ЭтоНовый() Тогда //запишем документ
		Попытка
			ФормаДокумента.ЗаписатьВФорме(РежимЗаписиДокумента.Запись);
		Исключение
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ОбщегоНазначенияЗК.ПолучитьПричинуОшибки(ИнформацияОбОшибке()).Описание);
			Возврат 
		КонецПопытки;
	КонецЕсли;
	
	Для каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		ДокументОбъект[ТабличнаяЧасть.Имя].Очистить();
	КонецЦикла;
	
	ФормаДокумента.Обновить();
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();

	ДокументОбъект.ЗаполнитьИРассчитать(Истина, Истина);
	
	Если ОбработкаКомментариев.Сообщения.Строки.Количество() = 0 Тогда
		// проверим заполнение табличных частей документа
		ЕстьДанные = Ложь;
		Для каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
			ЕстьДанные = ЕстьДанные Или ДокументОбъект[ТабличнаяЧасть.Имя].Количество() > 0;
			Если ЕстьДанные Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Не ЕстьДанные Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не обнаружены данные для записи в документ.", , , Перечисления.ВидыСообщений.Информация);
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();

КонецПроцедуры

Процедура РассчитатьСкидку(ДокументОбъект, ФормаДокумента) Экспорт
	
	Если ДокументОбъект.НеоблагаемыеСуммыДоходов.Количество() > 0 Тогда
		
		ТекстВопроса1 = "Текущие данные о скидках по материальной помощи будут пересчитаны. Продолжить?";
		Если РаботаСДиалогами.ЗадатьВопрос(ТекстВопроса1, РежимДиалогаВопрос.ДаНет) <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбработкаКомментариев = глЗначениеПеременной("глОбработкаСообщений");
	ОбработкаКомментариев.УдалитьСообщения();

	ДокументОбъект.ЗаполнитьИРассчитать(Истина, Ложь);
	
	Если ОбработкаКомментариев.Сообщения.Строки.Количество() = 0 Тогда
		// проверим заполнение табличных частей документа
		ЕстьДанные = ДокументОбъект.НеоблагаемыеСуммыДоходов.Количество() > 0;
		Если Не ЕстьДанные Тогда
			ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Не обнаружены данные для записи в документ.", , , Перечисления.ВидыСообщений.Информация);
		КонецЕсли;
	КонецЕсли;
	
	ОбработкаКомментариев.ПоказатьСообщения();

КонецПроцедуры

Процедура ТабличноеПолеВзносовПриПолученииДанных(Элемент, ОформленияСтрок, ИмяДатыПолученияДохода = "ДатаПолученияДохода", ГруппировочныеКолонки = Неопределено) Экспорт 
	
	Если ГруппировочныеКолонки = Неопределено Тогда
		ГруппировочныеКолонки = Новый Массив;
	КонецЕсли;
	ГруппировочныеКолонки.Добавить("КолонкаФСС");
	ГруппировочныеКолонки.Добавить("КолонкаПФР");
	ГруппировочныеКолонки.Добавить("Колонка2016");
	ГруппировочныеКолонки.Добавить("Колонка2014_2015");
	ГруппировочныеКолонки.Добавить("Колонка2010_2013");
	ГруппировочныеКолонки.Добавить("ПФРПоДопТарифуЗаЗанятыхНаПодземныхИВредныхРаботах");
	ГруппировочныеКолонки.Добавить("ПФРПоДопТарифуЗаЗанятыхНаТяжелыхИПрочихРаботах");
	
	Колонки = Элемент.Колонки;
	Для Каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		
		МесяцНалоговогоПериодаТЧ = ОформлениеСтроки.ДанныеСтроки[ИмяДатыПолученияДохода];
		Ячейки = ОформлениеСтроки.Ячейки;
		
		Для каждого ИмяКолонки Из ГруппировочныеКолонки Цикл
			Ячейки[ИмяКолонки].Видимость = Ложь;
		КонецЦикла;
		
		Ячейки.МесяцРасчетногоПериода.Значение = РаботаСДиалогами.ДатаКакМесяцПредставление(МесяцНалоговогоПериодаТЧ);
		ПоказыватьКолонкиПревышения = МесяцНалоговогоПериодаТЧ >= РасчетСтраховыхВзносов.ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины();
		ПоказыватьКолонкиСуммарногоТарифа = МесяцНалоговогоПериодаТЧ >= РасчетСтраховыхВзносов.ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР() И МесяцНалоговогоПериодаТЧ < РасчетСтраховыхВзносов.ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины();
		ПоказыватьКолонкиСтраховойНакопительной = МесяцНалоговогоПериодаТЧ < РасчетСтраховыхВзносов.ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР();
		Если Колонки.ПФРДоПредельнойВеличины.Видимость Тогда
			Ячейки.ПФРДоПредельнойВеличины.Видимость = ПоказыватьКолонкиПревышения;
			Ячейки.ПФРДоПредельнойВеличины.ТолькоПросмотр = Не ПоказыватьКолонкиПревышения;
		КонецЕсли;
		Если Колонки.ПФРДоПредельнойВеличиныЕНВД.Видимость Тогда
			Ячейки.ПФРДоПредельнойВеличиныЕНВД.Видимость = ПоказыватьКолонкиПревышения;
			Ячейки.ПФРДоПредельнойВеличиныЕНВД.ТолькоПросмотр = Не ПоказыватьКолонкиПревышения;
		КонецЕсли;
		Если Колонки.ПФРСПревышения.Видимость Тогда
			Ячейки.ПФРСПревышения.Видимость = ПоказыватьКолонкиПревышения;
			Ячейки.ПФРСПревышения.ТолькоПросмотр = Не ПоказыватьКолонкиПревышения;
		КонецЕсли;
		Если Колонки.ПФРСПревышенияЕНВД.Видимость Тогда
			Ячейки.ПФРСПревышенияЕНВД.Видимость = ПоказыватьКолонкиПревышения;
			Ячейки.ПФРСПревышенияЕНВД.ТолькоПросмотр = Не ПоказыватьКолонкиПревышения;
		КонецЕсли;
		Если Колонки.ПФРПоСуммарномуТарифу.Видимость Тогда
			Ячейки.ПФРПоСуммарномуТарифу.Видимость = ПоказыватьКолонкиСуммарногоТарифа;
			Ячейки.ПФРПоСуммарномуТарифу.ТолькоПросмотр = Не ПоказыватьКолонкиСуммарногоТарифа;
		КонецЕсли;
		Если Колонки.ПФРПоСуммарномуТарифуЕНВД.Видимость Тогда
			Ячейки.ПФРПоСуммарномуТарифуЕНВД.Видимость = ПоказыватьКолонкиСуммарногоТарифа;
			Ячейки.ПФРПоСуммарномуТарифуЕНВД.ТолькоПросмотр = Не ПоказыватьКолонкиСуммарногоТарифа;
		КонецЕсли;
		Если Колонки.Найти("ПФРПоСуммарномуТарифуСПревышения") <> Неопределено И Колонки.ПФРПоСуммарномуТарифуСПревышения.Видимость Тогда
			Ячейки.ПФРПоСуммарномуТарифуСПревышения.Видимость = ПоказыватьКолонкиСуммарногоТарифа;
			Ячейки.ПФРПоСуммарномуТарифуСПревышения.ТолькоПросмотр = Не ПоказыватьКолонкиСуммарногоТарифа;
		КонецЕсли;
		Если Колонки.ПФРСтраховая.Видимость Тогда
			Ячейки.ПФРСтраховая.Видимость = ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРСтраховая.ТолькоПросмотр = Не ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРСтраховаяЕНВД.Видимость Тогда
			Ячейки.ПФРСтраховаяЕНВД.Видимость = ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРСтраховаяЕНВД.ТолькоПросмотр = Не ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.Найти("ПФРСтраховаяСПревышения") <> Неопределено И Колонки.ПФРСтраховаяСПревышения.Видимость Тогда
			Ячейки.ПФРСтраховаяСПревышения.Видимость = ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРСтраховаяСПревышения.ТолькоПросмотр = Не ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРНакопительная.Видимость Тогда
			Ячейки.ПФРНакопительная.Видимость = ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРНакопительная.ТолькоПросмотр = Не ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРНакопительнаяЕНВД.Видимость Тогда
			Ячейки.ПФРНакопительнаяЕНВД.Видимость = ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРНакопительнаяЕНВД.ТолькоПросмотр = Не ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		Если Колонки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4.Видимость Тогда
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4.Видимость = Не ПоказыватьКолонкиСтраховойНакопительной;
			Ячейки.ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4.ТолькоПросмотр = ПоказыватьКолонкиСтраховойНакопительной;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПоказатьКолонкиИсчисленныхВзносовПоГодам(ДокументОбъект, ФормаДокумента) Экспорт

	ПериодРегистрации = ДокументОбъект.ПериодРегистрации;
	ИсчисленныеСтраховыеВзносы = ДокументОбъект.ИсчисленныеСтраховыеВзносы;
	ЭлементыФормы = ФормаДокумента.ЭлементыФормы;
	
	Если ПериодРегистрации < ПроведениеРасчетов.ДатаРасширенияПеречняЛьготныхТарифовСтраховыхВзносов() Тогда
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ТФОМСЕНВД.Видимость = Ложь;
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ФФОМСЕНВД.Видимость = Ложь;
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ФССЕНВД.Видимость = Ложь;
	КонецЕсли;
	
	ПоказыватьКолонки = ПериодРегистрации < ПроведениеРасчетов.ДатаСниженияТарифовСтраховыхВзносов();
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ТФОМСЕНВД.Видимость = ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ТФОМСЕНВД.Видимость И ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ТФОМС.Видимость = ПоказыватьКолонки;
	
	ПоказаноПодгрупп = 0;
	
	ПоказыватьКолонки = ПериодРегистрации < РасчетСтраховыхВзносов.ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР() Или ИсчисленныеСтраховыеВзносы.Итог("ПФРНакопительная") <> 0 Или ИсчисленныеСтраховыеВзносы.Итог("ПФРНакопительнаяЕНВД") <> 0 Или ИсчисленныеСтраховыеВзносы.Итог("ПФРСтраховая") <> 0 Или ИсчисленныеСтраховыеВзносы.Итог("ПФРСтраховаяЕНВД") <> 0;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСтраховаяЕНВД.Видимость = ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСтраховаяЕНВД.Видимость И ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСтраховая.Видимость = ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРНакопительнаяЕНВД.Видимость = ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСтраховаяЕНВД.Видимость;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРНакопительная.Видимость = ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2010_2013.Видимость = ПоказыватьКолонки;
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2010_2013.Видимость Тогда
		ПоказаноПодгрупп = ПоказаноПодгрупп + 1;
	КонецЕсли;
	
	ПоказыватьКолонки = ПериодРегистрации >= РасчетСтраховыхВзносов.ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР() И ПериодРегистрации < РасчетСтраховыхВзносов.ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины() Или ИсчисленныеСтраховыеВзносы.Итог("ПФРПоСуммарномуТарифу") <> 0 Или ИсчисленныеСтраховыеВзносы.Итог("ПФРПоСуммарномуТарифуЕНВД") <> 0;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифуЕНВД.Видимость = ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифуЕНВД.Видимость И ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифу.Видимость = ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2014_2015.Видимость = ПоказыватьКолонки И ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифуЕНВД.Видимость;
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2014_2015.Видимость Тогда
		ПоказаноПодгрупп = ПоказаноПодгрупп + 1;
	КонецЕсли;
	
	ПоказыватьКолонки = ПериодРегистрации >= РасчетСтраховыхВзносов.ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины();
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСПревышенияЕНВД.Видимость = ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСПревышенияЕНВД.Видимость И ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРДоПредельнойВеличиныЕНВД.Видимость = ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСПревышенияЕНВД.Видимость;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСПревышения.Видимость = ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРДоПредельнойВеличины.Видимость = ПоказыватьКолонки;
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2016.Видимость = ПоказыватьКолонки;
	
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2016.Видимость Тогда
		ПоказаноПодгрупп = ПоказаноПодгрупп + 1;
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2016.Положение = ?(ПоказаноПодгрупп > 1, ПоложениеКолонки.НаСледующейСтроке, ПоложениеКолонки.НоваяКолонка);
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2016.ТекстШапки = ?(ПоказаноПодгрупп > 1, "С 2016 года", "Взносы в ПФР");
	КонецЕсли;
	
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2014_2015.Видимость Тогда
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2014_2015.Положение = ?(ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2016.Видимость,ПоложениеКолонки.ВТойЖеКолонке, ?(ПоказаноПодгрупп > 1,ПоложениеКолонки.НаСледующейСтроке,ПоложениеКолонки.НоваяКолонка));
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2014_2015.ТекстШапки = ?(ПоказаноПодгрупп > 1, "2014, 2015 годы", "Взносы в ПФР");
	КонецЕсли;
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифу.Видимость Тогда
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифу.ТекстШапки = ?(ПоказаноПодгрупп = 0,"Взносы в ПФР на ОПС","на ОПС");
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРПоСуммарномуТарифу.Положение = ?(ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2014_2015.Видимость,?(ПоказаноПодгрупп > 1,ПоложениеКолонки.ВТойЖеКолонке,ПоложениеКолонки.НаСледующейСтроке), ПоложениеКолонки.НоваяКолонка);
	КонецЕсли;
	
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2010_2013.Видимость Тогда
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2010_2013.Положение = ?(ПоказаноПодгрупп > 1,ПоложениеКолонки.ВТойЖеКолонке, ПоложениеКолонки.НоваяКолонка);
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.Колонка2010_2013.ТекстШапки = ?(ПоказаноПодгрупп > 1, "2010-2013 годы", "Взносы в ПФР");
	КонецЕсли;
	Если ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСтраховая.Видимость Тогда
		ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.ПФРСтраховая.Положение = ?(ПоказаноПодгрупп > 1,ПоложениеКолонки.ВТойЖеКолонке, ПоложениеКолонки.НаСледующейСтроке);
	КонецЕсли;
	
	ЭлементыФормы.ИсчисленныеСтраховыеВзносы.Колонки.КолонкаПФР.Видимость = ПоказаноПодгрупп > 1;
	
КонецПроцедуры
