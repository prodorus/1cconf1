// Уничтожению подлежат только данные кандидатов, не являющихся сотрудниками
// 
// Параметры:
//  нет
//
// Возвращаемое значение:
//  ПричинаНевозможностиУничтожения - строка, заполняется в случае невозможности текстом причины
//
Функция ПроверитьВозможностьУничтоженияСубъекта()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо = &Субъект");
	
	Запрос.УстановитьПараметр("Субъект", Субъект);
	
	ПричинаНевозможностиУничтожения = "";
	Если Не Запрос.Выполнить().Пустой() Тогда
		ПричинаНевозможностиУничтожения = "на субъекта есть ссылки в справочнике Сотрудники";
	КонецЕсли;
	
	Возврат ПричинаНевозможностиУничтожения;
	
КонецФункции // ПроверитьВозможностьУничтоженияСубъекта

Процедура ПрочитатьСведенияОПерсональныхДанных() Экспорт
	
	// прочитаем сведения о персональных данных
	Если НЕ ЗначениеЗаполнено(СведенияОПерсональныхДанных) Тогда
		СведенияОПерсональныхДанных = НастройкаЗащитыПерсональныхДанных.ПолучитьСведенияОПерсональныхДанных();
	КонецЕсли;
	
КонецПроцедуры

Функция СклеитьМассивы(ПервыйМассив, ВторойМассив)
	
	МассивРезультат = Новый Массив;
	
	Для Каждого ЭлементМассива Из ПервыйМассив Цикл
		МассивРезультат.Добавить(ЭлементМассива);
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из ВторойМассив Цикл
		МассивРезультат.Добавить(ЭлементМассива);
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

Функция УничтожитьПерсональныеДанныеСубъекта() Экспорт
	
	ПричинаНевозможностиУничтожения = ПроверитьВозможностьУничтоженияСубъекта();
	Если ЗначениеЗаполнено(ПричинаНевозможностиУничтожения) Тогда
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке("Персональные данные субъекта невозможно удалить по причине: " + ПричинаНевозможностиУничтожения);
		Возврат Истина;
	КонецЕсли;
	
	ПрочитатьСведенияОПерсональныхДанных();
	
	УничтожаемыеДанные = СведенияОПерсональныхДанных.НайтиСтроки(Новый Структура("Уничтожать", Истина));
	
	Если УничтожаемыеДанные.Количество() = 0 Тогда
		ТекстОшибки = "В системе не определены области персональных данных, подлежащих уничтожению";
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки);
		Возврат Истина;
	КонецЕсли;
	
	// тип субъекта
	ТипСубъекта = ТипЗнч(Субъект);
	
	ОтобранныеКлючи = Новый Массив;
	
	КлючиТабличныхЧастей = Новый ТаблицаЗначений;
	КлючиТабличныхЧастей.Колонки.Добавить("ИмяТабличнойЧасти");
	КлючиТабличныхЧастей.Колонки.Добавить("ИмяКлюча");
	КлючиТабличныхЧастей.Колонки.Добавить("СодержитТипСубъекта");
	
	ПоляТабличныхЧастей = Новый ТаблицаЗначений;
	ПоляТабличныхЧастей.Колонки.Добавить("ИмяТабличнойЧасти");
	ПоляТабличныхЧастей.Колонки.Добавить("ИмяПоля");
	ПоляТабличныхЧастей.Колонки.Добавить("ОписаниеТипов");
	
	ТабличныеЧасти = Новый Массив;
	
	ЕстьОшибки = Ложь;	ОписаниеОшибок = "";
	
	ПроверятьУсловиеУничтожения = СведенияОПерсональныхДанных.Колонки.Найти("УсловиеУничтожения") <> Неопределено;
	
	Для Каждого ОбластьПерсДанных Из УничтожаемыеДанные Цикл
		
		Если НЕ ЗначениеЗаполнено(ОбластьПерсДанных.ВидМетаданных) Тогда
			Продолжить;
		КонецЕсли;
		
		МетаданныеОбъекта = Метаданные[ОбластьПерсДанных.ВидМетаданных][ОбластьПерсДанных.ИмяОбъектаМетаданных];
		
		ТабличныеЧасти.Очистить();
		КлючиТабличныхЧастей.Очистить();
		ОтобранныеКлючи.Очистить();
		
		Если ПроверятьУсловиеУничтожения И ЗначениеЗаполнено(ОбластьПерсДанных.УсловиеУничтожения) Тогда
			
			ОтобранныеКлючи.Добавить(ОбластьПерсДанных.УсловиеУничтожения);
			
		Иначе
		
			Для Каждого ИмяПоляКлюча Из ОбластьПерсДанных.ПоляРегистрации Цикл
				ЧастиИмениКлюча = ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ИмяПоляКлюча, ".");
				Если ЧастиИмениКлюча.Количество() = 1 Тогда
					// реквизит, измерение или ресурс
					ИмяКлюча = ЧастиИмениКлюча[0];
					Если ИмяКлюча = "Ссылка" Тогда
						Если Метаданные.НайтиПоТипу(ТипСубъекта) = МетаданныеОбъекта Тогда
							// этот ключ имеет значения субъекта - совпадают типы
							ОтобранныеКлючи.Добавить(ИмяКлюча);
						КонецЕсли;
					Иначе
						МетаданныеКлюча = МетаданныеОбъекта.Реквизиты.Найти(ИмяКлюча);
						Если МетаданныеКлюча = Неопределено Тогда
							Если Найти(ОбластьПерсДанных.ВидМетаданных, "Регистр") > 0 Тогда
								МетаданныеКлюча = МетаданныеОбъекта.Измерения.Найти(ИмяКлюча);
								Если МетаданныеКлюча = Неопределено Тогда
									МетаданныеКлюча = МетаданныеОбъекта.Ресурсы.Найти(ИмяКлюча);
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
						Если МетаданныеКлюча <> Неопределено И МетаданныеКлюча.Тип.СодержитТип(ТипСубъекта) Тогда
							// этот ключ имеет значения субъекта - совпадают типы
							ОтобранныеКлючи.Добавить(ИмяКлюча);
						КонецЕсли;
					КонецЕсли;
				ИначеЕсли ЧастиИмениКлюча.Количество() >  1 Тогда
					// реквизит табличной части
					ИмяТабличнойЧасти = ЧастиИмениКлюча[0];
					ИмяКлюча = ЧастиИмениКлюча[1];
					МетаданныеКлюча = МетаданныеОбъекта.ТабличныеЧасти[ИмяТабличнойЧасти].Реквизиты[ИмяКлюча];
					// соберем в отдельную таблицу для групповой обработки в отобранных строках
					КлючТабличнойЧасти = КлючиТабличныхЧастей.Добавить();
					КлючТабличнойЧасти.ИмяТабличнойЧасти = ИмяТабличнойЧасти;
					КлючТабличнойЧасти.ИмяКлюча = ИмяКлюча;
					КлючТабличнойЧасти.СодержитТипСубъекта = МетаданныеКлюча.Тип.СодержитТип(ТипСубъекта);
					// отдельно соберем упоминаемые табличные части
					Если ТабличныеЧасти.Найти(ИмяТабличнойЧасти) = Неопределено Тогда
						ТабличныеЧасти.Добавить(ИмяТабличнойЧасти);
					КонецЕсли;
				Иначе
					// ошибка
					ТекстОшибки = "Имя ключа " + ИмяПоляКлюча + " для таблицы " + ОбластьПерсДанных.ИмяОбъектаМетаданных + " задано неверно!";
					ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
					Продолжить;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		ОтобранныеКлючиТаблЧастей = КлючиТабличныхЧастей.НайтиСтроки(Новый Структура("СодержитТипСубъекта", Истина));
		Если ОтобранныеКлючи.Количество() ИЛИ ОтобранныеКлючиТаблЧастей.Количество() Тогда
			ТекстЗапроса = "";
			Если ОтобранныеКлючи.Количество() Тогда
				Если ОбластьПерсДанных.ВидМетаданных = "Справочники" ИЛИ ОбластьПерсДанных.ВидМетаданных = "Документы" Тогда
					// запрос для справочников и документов
					ТекстЗапроса = ТекстЗапроса + 
					"ВЫБРАТЬ РАЗЛИЧНЫЕ Таблица.Ссылка ИЗ " + ОбластьПерсДанных.ИмяТаблицыИБ + " КАК Таблица
					|ГДЕ Таблица." + ОтобранныеКлючи[0] + " = &Субъект";
					Если ОтобранныеКлючи.Количество() > 1 Тогда
						Для Каждого ОтобранныйКлюч Из ОтобранныеКлючи Цикл
							ТекстЗапроса = ТекстЗапроса + "
							|ИЛИ Таблица." + ОтобранныйКлюч + " = &Субъект";
						КонецЦикла;
					КонецЕсли;
					Если ОтобранныеКлючиТаблЧастей.Количество() Тогда
						ТекстЗапроса = ТекстЗапроса + "
						|
						|ОБЪЕДИНИТЬ
						|";
					КонецЕсли;
				Иначе
					// запрос для записей регистров
					ТекстЗапроса = 
					"ВЫБРАТЬ * 
					|ИЗ " +	ОбластьПерсДанных.ИмяТаблицыИБ + " КАК Таблица
					|ГДЕ
					|	Таблица." + ОтобранныеКлючи[0] + " = &Субъект";
					Если ОтобранныеКлючи.Количество() > 1 Тогда
						Для Каждого ОтобранныйКлюч Из ОтобранныеКлючи Цикл
							ТекстЗапроса = ТекстЗапроса + "
							|ИЛИ Таблица." + ОтобранныйКлюч + " = &Субъект";
						КонецЦикла;
					КонецЕсли;
					
					// определяем способ отбора набора записей
					Если ОбластьПерсДанных.ВидМетаданных = "РегистрыСведений" Тогда
						ПодчиненРегистратору = МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору;
					Иначе
						ПодчиненРегистратору = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если ОтобранныеКлючиТаблЧастей.Количество() Тогда
				ТекстЗапроса = ТекстЗапроса + 
				"ВЫБРАТЬ РАЗЛИЧНЫЕ Таблица.Ссылка ИЗ " + ОбластьПерсДанных.ИмяТаблицыИБ + "." + ОтобранныеКлючиТаблЧастей[0].ИмяТабличнойЧасти + " КАК Таблица
				|ГДЕ Таблица." + ОтобранныеКлючиТаблЧастей[0].ИмяКлюча + " = &Субъект";
				Если ОтобранныеКлючиТаблЧастей.Количество() > 1 Тогда
					Для Каждого ОтобранныйКлюч Из ОтобранныеКлючиТаблЧастей Цикл
						ТекстЗапроса = ТекстЗапроса + "
						|ИЛИ Таблица." + ОтобранныйКлюч.ИмяКлюча + " = &Субъект";
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Субъект", Субъект);
			Запрос.Текст = ТекстЗапроса;
			РезультатЗапроса = Запрос.Выполнить();
			Выборка = РезультатЗапроса.Выбрать();
			Если ОбластьПерсДанных.ВидМетаданных = "Справочники" ИЛИ ОбластьПерсДанных.ВидМетаданных = "Документы" Тогда
				// для объектных сущностей
				Пока Выборка.Следующий() Цикл
					Объект = Выборка.Ссылка.ПолучитьОбъект();
					ПоляТабличныхЧастей.Очистить();
					
					// уничтожить сведения в полях доступа и полях регистрации
					ВсеЗащищаемыеПоляОбъекта = СклеитьМассивы(ОбластьПерсДанных.ПоляДоступа, ОбластьПерсДанных.ПоляРегистрации);
					Для Каждого ПолноеИмяПоля Из ВсеЗащищаемыеПоляОбъекта Цикл
						Если ПолноеИмяПоля = "Ссылка" 
						 Или ПолноеИмяПоля = "Наименование" 
						 Или ПолноеИмяПоля = "Код" 
						 Или ПолноеИмяПоля = "Номер" 
						 Или ПолноеИмяПоля = "Дата" 
						 Тогда
							Продолжить;
						КонецЕсли;
						ЧастиИмениПоля = ОбщегоНазначенияЗК.РазложитьСтрокуВМассивПодстрок(ПолноеИмяПоля, ".");
						Если ЧастиИмениПоля.Количество() = 1 Тогда
							// реквизит
							// установим пустое значение реквизита
							ИмяПоля = ЧастиИмениПоля[0];
							Объект[ИмяПоля] = МетаданныеОбъекта.Реквизиты[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
						ИначеЕсли ЧастиИмениПоля.Количество() >  1 Тогда
							// реквизит табличной части
							// соберем в отдельную таблицу для групповой обработки в отобранных строках
							ПолеТабличнойЧасти = ПоляТабличныхЧастей.Добавить();
							ПолеТабличнойЧасти.ИмяТабличнойЧасти = ЧастиИмениПоля[0];
							ПолеТабличнойЧасти.ИмяПоля = ЧастиИмениПоля[1];
							ПолеТабличнойЧасти.ОписаниеТипов = МетаданныеОбъекта.ТабличныеЧасти[ЧастиИмениПоля[0]].Реквизиты[ЧастиИмениПоля[1]].Тип;
							Если ТабличныеЧасти.Найти(ЧастиИмениПоля[0]) = Неопределено Тогда
								ТабличныеЧасти.Добавить(ЧастиИмениПоля[0]);
							КонецЕсли;
						Иначе
							// ошибка
							ТекстОшибки = "Имя поля " + ПолноеИмяПоля + " для таблицы " + ОбластьПерсДанных.ИмяОбъектаМетаданных + " задано неверно!";
							ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
							ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
							Продолжить;
						КонецЕсли;
					КонецЦикла;
					
					// поля табличных частей обработаем отдельно
					// здесь для всех табличных частей, в которых встречали поля
					// посмотрим - поля во всех ли строках нужно менять? есть ли ключ, имеющий тип субъекта 
					Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
						ПоляТабличнойЧасти = ПоляТабличныхЧастей.НайтиСтроки(Новый Структура("ИмяТабличнойЧасти", ТабличнаяЧасть));
						Если ПоляТабличнойЧасти.Количество() Тогда
							КлючиТабличнойЧасти = КлючиТабличныхЧастей.НайтиСтроки(Новый Структура("СодержитТипСубъекта", Истина));
							Если КлючиТабличнойЧасти.Количество() Тогда
								// в табличной части есть ключи - нужно выполнить поиск по всем ключам подходящего типа
								Для Каждого КлючТабличнойЧасти Из КлючиТабличнойЧасти Цикл
									// этот ключ имеет тип субъекта
									СтрокиТабличнойЧасти = Объект[ТабличнаяЧасть].НайтиСтроки(Новый Структура(КлючТабличнойЧасти.ИмяКлюча, Субъект));
									Для Каждого СтрокаТабличнойЧасти Из СтрокиТабличнойЧасти Цикл
										Для Каждого ПолеТабличнойЧасти Из ПоляТабличнойЧасти Цикл
											СтрокаТабличнойЧасти[ПолеТабличнойЧасти.ИмяПоля] = ПолеТабличнойЧасти.ОписаниеТипов.ПривестиЗначение(Неопределено);
										КонецЦикла;
									КонецЦикла;
								КонецЦикла;
							Иначе
								// в табличной части нет ключей - уничтожаем данные по всем строкам	
								Для Каждого СтрокаТабличнойЧасти Из Объект[ТабличнаяЧасть] Цикл
									Для Каждого ПолеТабличнойЧасти Из ПоляТабличнойЧасти Цикл
										СтрокаТабличнойЧасти[ПолеТабличнойЧасти.ИмяПоля] = ПолеТабличнойЧасти.ОписаниеТипов.ПривестиЗначение(Неопределено);
									КонецЦикла;
								КонецЦикла;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;
					
					// запись измененного объекта
					Объект.ОбменДанными.Загрузка = Истина;
					Попытка
						Объект.Записать();
					Исключение
						// ошибка
						ТекстОшибки = "Не удалось записать объект " + Объект + " по причине: " + Символы.ПС + ОписаниеОшибки();
						ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
						ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
						Продолжить;
					КонецПопытки;
					
				КонецЦикла;
				
			Иначе
				// для регистров
				Если ОбластьПерсДанных.ВидМетаданных = "РегистрыСведений" Тогда
					НаборЗаписей = РегистрыСведений[ОбластьПерсДанных.ИмяОбъектаМетаданных].СоздатьНаборЗаписей();
				ИначеЕсли ОбластьПерсДанных.ВидМетаданных = "РегистрыНакопления" Тогда
					НаборЗаписей = РегистрыНакопления[ОбластьПерсДанных.ИмяОбъектаМетаданных].СоздатьНаборЗаписей();
				ИначеЕсли ОбластьПерсДанных.ВидМетаданных = "РегистрыРасчета" Тогда
					НаборЗаписей = РегистрыРасчета[ОбластьПерсДанных.ИмяОбъектаМетаданных].СоздатьНаборЗаписей();
				Иначе
					// ошибка
					ТекстОшибки = "Имя таблицы " + ОбластьПерсДанных.ВидМетаданных + " " + ОбластьПерсДанных.ИмяОбъектаМетаданных + " задано неверно!";
					ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
					ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
					Продолжить;
				КонецЕсли;
				
				Если ПодчиненРегистратору Тогда
					Если НЕ РезультатЗапроса.Пустой() Тогда
						РезультатТаблица = РезультатЗапроса.Выгрузить();
						
						// получим набор различных регистраторов
						ТаблицаРегистраторов = РезультатТаблица.Скопировать();
						ТаблицаРегистраторов.Свернуть("Регистратор");
						РазличныеРегистраторы = ТаблицаРегистраторов.ВыгрузитьКолонку("Регистратор");
						
						Для Каждого Регистратор Из РазличныеРегистраторы Цикл
							// считываем набор с отбором по регистратору
							НаборЗаписей.Отбор.Регистратор.Установить(Регистратор);
							НаборЗаписей.Прочитать();
							ЗаписиРегистратора = РезультатТаблица.НайтиСтроки(Новый Структура("Регистратор", Регистратор));
							Для Каждого ЗаписьРегистратора Из ЗаписиРегистратора Цикл
								Для Каждого Запись Из НаборЗаписей Цикл
									Если ЗаписьРегистратора.НомерСтроки = Запись.НомерСтроки Тогда
										Для Каждого ИмяПоля Из ОбластьПерсДанных.ПоляДоступа Цикл
											МетаданныеПоля = МетаданныеОбъекта.Реквизиты.Найти(ИмяПоля);
											Если МетаданныеПоля = Неопределено Тогда 
												МетаданныеПоля = МетаданныеОбъекта.Ресурсы.Найти(ИмяПоля);
												Если МетаданныеПоля = Неопределено Тогда 
													МетаданныеПоля = МетаданныеОбъекта.Измерения.Найти(ИмяПоля);
													Если МетаданныеПоля = Неопределено Тогда 
														// ошибка
														ТекстОшибки = "Поле " + ИмяПоля + " для таблицы " + ОбластьПерсДанных.ИмяОбъектаМетаданных + " задано неверно!";
														ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
														ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
													Иначе
														Запись[ИмяПоля] = МетаданныеОбъекта.Измерения[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
													КонецЕсли;
												Иначе
													Запись[ИмяПоля] = МетаданныеОбъекта.Ресурсы[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
												КонецЕсли;
											Иначе
												Запись[ИмяПоля] = МетаданныеОбъекта.Реквизиты[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
											КонецЕсли;
										КонецЦикла;	
									КонецЕсли;
								КонецЦикла;
							КонецЦикла;
							// запись измененного набора регистра
							НаборЗаписей.ОбменДанными.Загрузка = Истина;
							Попытка
								НаборЗаписей.Записать(Истина);
							Исключение
								// ошибка
								ТекстОшибки = "Не удалось записать набор записей регистра " + ОбластьПерсДанных.ИмяТаблицыИБ + " по причине: " + Символы.ПС + ОписаниеОшибки();
								ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
								ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
							КонецПопытки;
						КонецЦикла;
					КонецЕсли;
				Иначе
					Пока Выборка.Следующий() Цикл
						// ключ состоит из набора измерений
						Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
							НаборЗаписей.Отбор[Измерение.Имя].Установить(Выборка[Измерение.Имя]);
						КонецЦикла;
						НаборЗаписей.Прочитать();
						// для всех записей набора очищаем значения защищаемых полей
						Для Каждого Запись Из НаборЗаписей Цикл
							Для Каждого ИмяПоля Из ОбластьПерсДанных.ПоляДоступа Цикл
								МетаданныеПоля = МетаданныеОбъекта.Реквизиты.Найти(ИмяПоля);
								Если МетаданныеПоля = Неопределено Тогда 
									МетаданныеПоля = МетаданныеОбъекта.Ресурсы.Найти(ИмяПоля);
									Если МетаданныеПоля = Неопределено Тогда 
										МетаданныеПоля = МетаданныеОбъекта.Измерения.Найти(ИмяПоля);
										Если МетаданныеПоля = Неопределено Тогда 
											// ошибка
											ТекстОшибки = "Поле " + ИмяПоля + " для таблицы " + ОбластьПерсДанных.ИмяОбъектаМетаданных + " задано неверно!";
											ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
											ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
										Иначе
											Запись[ИмяПоля] = МетаданныеОбъекта.Измерения[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
										КонецЕсли;
									Иначе
										Запись[ИмяПоля] = МетаданныеОбъекта.Ресурсы[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
									КонецЕсли;
								Иначе
									Запись[ИмяПоля] = МетаданныеОбъекта.Реквизиты[ИмяПоля].Тип.ПривестиЗначение(Неопределено);
								КонецЕсли;
							КонецЦикла;	
						КонецЦикла;
						
						// запись измененного набора регистра
						НаборЗаписей.ОбменДанными.Загрузка = Истина;
						Попытка
							НаборЗаписей.Записать(Истина);
						Исключение
							// ошибка
							ТекстОшибки = "Не удалось записать набор записей регистра " + ОбластьПерсДанных.ИмяТаблицыИБ + " по причине: " + Символы.ПС + ОписаниеОшибки();
							ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
							ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
						КонецПопытки;
						
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;				
		КонецЕсли;
		
	КонецЦикла;
	
	// уничтожим наименование в самом субъекте
	СубъектОбъект = Субъект.ПолучитьОбъект();
	СубъектОбъект.Наименование = Субъект.Метаданные().Синоним + " " + Строка(Субъект.Код);
	Попытка
		СубъектОбъект.Записать();
	Исключение
		// ошибка
		ТекстОшибки = "Не удалось записать объект " + Субъект + " по причине: " + Символы.ПС + ОписаниеОшибки();
		ОписаниеОшибок = ОписаниеОшибок + ТекстОшибки + Символы.ПС;
		ОбщегоНазначенияЗК.ВывестиИнформациюОбОшибке(ТекстОшибки, ЕстьОшибки);
	КонецПопытки;
	
	ЗаписьЖурналаРегистрации("Уничтожение персональных данных", УровеньЖурналаРегистрации.Информация, Субъект.Метаданные(), Субъект);

	Если ЕстьОшибки Тогда
		ЗаписьЖурналаРегистрации("Ошибки при уничтожении персональных данных", УровеньЖурналаРегистрации.Ошибка, Субъект.Метаданные(), Субъект, ОписаниеОшибок);
	КонецЕсли;
	
	Возврат ЕстьОшибки;
	
КонецФункции

