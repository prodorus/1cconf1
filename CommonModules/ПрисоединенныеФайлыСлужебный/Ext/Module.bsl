////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Размещает файлы из сформированного образа.
Процедура ДобавитьФайлыВТомаПриРазмещении(Знач СоответствиеПутейФайлов,
                                          Знач ТипХраненияФайлов,
                                          Знач Файлы) Экспорт
	
	Для Каждого ЭлементСоответствия Из СоответствиеПутейФайлов Цикл
		
		Позиция = Найти(ЭлементСоответствия.Ключ, "CatalogRef");
		
		Если Позиция = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПолныйПутьФайлаНаДиске = СоответствиеПутейФайлов.Получить(ЭлементСоответствия.Ключ);
		
		Если ПолныйПутьФайлаНаДиске = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		УникальныйИдентификатор = Новый УникальныйИдентификатор(Лев(ЭлементСоответствия.Ключ, Позиция - 1));
		
		ИмяСправочника = Прав(ЭлементСоответствия.Ключ, СтрДлина(ЭлементСоответствия.Ключ) - Позиция -10);
		Ссылка = Справочники[ИмяСправочника].ПолучитьСсылку(УникальныйИдентификатор);
		
		Если Ссылка.Пустая() Тогда
			Продолжить;
		КонецЕсли;
		
		Объект = Ссылка.ПолучитьОбъект();
		
		Если Объект.ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
			Продолжить;
		КонецЕсли;
		
		Если Файлы.Найти(ТипЗнч(Объект)) = Неопределено Тогда
			Файлы.Добавить(ТипЗнч(Объект));
		КонецЕсли;
		
		// Размещение файлов в базе-приемнике внутри базы, независимо от хранения в базе-источнике.
		Если ТипХраненияФайлов = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
			
			Объект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
			Объект.ПутьКФайлу = "";
			Объект.Том = Справочники.ТомаХраненияФайлов.ПустаяСсылка();
			
			ДвоичныеДанные = Новый ДвоичныеДанные(ПолныйПутьФайлаНаДиске);
			
			ОбновитьДвоичныеДанныеФайлаНаСервере(Объект, ПоместитьВоВременноеХранилище(ДвоичныеДанные));
			
		Иначе // Размещение файлов в базе-приемнике внутри тома, независимо от хранения в базе-источнике.
			
			ФайлИсх = Новый Файл(ПолныйПутьФайлаНаДиске);
			РазмерФайла = ФайлИсх.Размер();
			
			ВремяИзмененияУниверсальное = Объект.ДатаМодификацииУниверсальная;
			ИмяБезРасширения = Объект.Наименование;
			Расширение = Объект.Расширение;
			Зашифрован = Объект.Зашифрован;
			
			ПолныйПутьНовый = ФайлИсх.Путь + ИмяБезРасширения + "." + Объект.Расширение;
			ПереместитьФайл(ПолныйПутьФайлаНаДиске, ПолныйПутьНовый);
			
			ПутьКФайлуНаТоме = "";
			СсылкаНаТом = Неопределено;
			
			// Добавление файла в один из томов (где есть свободное место).
			
			ФайловыеФункции.ДобавитьНаДиск(
				ПолныйПутьНовый,
				ПутьКФайлуНаТоме,
				СсылкаНаТом,
				ВремяИзмененияУниверсальное,
				"",
				ИмяБезРасширения,
				Расширение,
				РазмерФайла,
				Зашифрован);
			
			Объект.ПутьКФайлу = ПутьКФайлуНаТоме;
			Объект.Том = СсылкаНаТом.Ссылка;
			
		КонецЕсли;
		
		Объект.Записать();
		
		Если НЕ ПустаяСтрока(ПолныйПутьНовый) Тогда
			УдалитьФайлы(ПолныйПутьНовый);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Проверяет, что переданный элемент данных - это объект присоединенного файла.
Функция ЭтоЭлементПрисоединенныеФайлы(ЭлементДанных) Экспорт
	
	Если ТипЗнч(ЭлементДанных) = Тип("УдалениеОбъекта") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МетаданныеЭлемента = ЭлементДанных.Метаданные();
	
	Возврат ОбщегоНазначения.ЭтоСправочник(МетаданныеЭлемента)
	      И ВРег(Прав(МетаданныеЭлемента.Имя, СтрДлина("ПрисоединенныеФайлы"))) = ВРег("ПрисоединенныеФайлы");
	
КонецФункции

// Возвращает свойства присоединенного файла: двоичные данные и подпись.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на присоединенный файл.
//  АдресПодписи       - Строка - адрес подписи во временном хранилище.
//
// Возвращаемое значение:
//  Структура со свойствами:
//    ДвоичныеДанные        - ДвоичныеДанные присоединенного файла.
//    ДвоичныеДанныеПодписи - ДвоичныеДанные подписи.
//
Функция ПолучитьДвоичныеДанныеФайлаИПодписи(Знач ПрисоединенныйФайл, Знач АдресПодписи) Экспорт
	
	Свойства = Новый Структура;
	
	Свойства.Вставить("ДвоичныеДанные", ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(
		ПрисоединенныйФайл));
	
	Свойства.Вставить("ДвоичныеДанныеПодписи", ПолучитьИзВременногоХранилища(АдресПодписи));
	
	Возврат Свойства;
	
КонецФункции

// Возвращает путь к файлу на диске. Если файл хранится в информационной базе,
// предварительно сохраняет его.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на присоединенный файл.
//
// Возвращаемое значение:
//  Строка - полный путь к файлу на диске.
//
Функция ПолучитьИмяФайлаСПутемКДвоичнымДанным(Знач ПрисоединенныйФайл) Экспорт
	
	ИмяФайлаСПутем = ПолучитьИмяВременногоФайла(ПрисоединенныйФайл.Расширение);
	
	Если ПрисоединенныйФайл.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПрисоединенныеФайлы.ПрисоединенныйФайл,
		|	ПрисоединенныеФайлы.ХранимыйФайл
		|ИЗ
		|	РегистрСведений.ПрисоединенныеФайлы КАК ПрисоединенныеФайлы
		|ГДЕ
		|	ПрисоединенныеФайлы.ПрисоединенныйФайл = &ПрисоединенныйФайл";
		
		Запрос.УстановитьПараметр("ПрисоединенныйФайл", ПрисоединенныйФайл.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ДвоичныеДанные = Выборка.ХранимыйФайл.Получить();
			ДвоичныеДанные.Записать(ИмяФайлаСПутем);
		Иначе
			ВызватьИсключение ФайловыеФункцииКлиентСервер.ОшибкаФайлНеНайденВХранилищеФайлов(
				ПрисоединенныйФайл.Наименование + "." + ПрисоединенныйФайл.Расширение);
		КонецЕсли;
	Иначе
		Если НЕ ПрисоединенныйФайл.Том.Пустая() Тогда
			ИмяФайлаСПутем = ФайловыеФункции.ПолныйПутьТома(ПрисоединенныйФайл.Том) + ПрисоединенныйФайл.ПутьКФайлу;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИмяФайлаСПутем;
	
КонецФункции

// Записывает присоединенный файл.
// 
// Параметры:
//  ФайлОбъект   - Объект присоединенного файла.
// 
Процедура ЗаписатьИзвлеченныйТекст(ФайлОбъект) Экспорт
	
	Попытка
		ФайлОбъект.Записать();
	Исключение
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обновляет свойства файла при окончании редактирования.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на присоединенный файл.
//  ИнформацияОФайле   - Структура со свойствами:
//                       <обязательные>
//                         АдресФайлаВоВременномХранилище - Строка - адрес новых двоичных данных файла.
//                         АдресВременногоХранилищаТекста - Строка - адрес новых двоичных данных текста,
//                                                          извлеченного из файла.
//                       <необязательные>
//                         ДатаМодификацииУниверсальная   - Дата - дата последнего изменения файла, если
//                                                          свойство не указано или не заполнено, тогда будет
//                                                          установлена текущая дата сеанса.
//                         Расширение                     - Строка - новое расширение файла.
//
Процедура ПоместитьФайлВХранилищеИОсвободить(Знач ПрисоединенныйФайл, Знач ИнформацияОФайле) Экспорт
	
	ИнформацияОФайле.Вставить("Редактирует", Справочники.Пользователи.ПустаяСсылка());
	
	ПрисоединенныеФайлы.ОбновитьПрисоединенныйФайл(ПрисоединенныйФайл, ИнформацияОФайле)
	
КонецПроцедуры

// Отменяет редактирование файла.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка или Объект присоединенного файла, который требуется освободить.
//
Процедура ОсвободитьФайл(Знач ПрисоединенныйФайл) Экспорт
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
	Иначе
		ФайлОбъект = ПрисоединенныйФайл;
	КонецЕсли;
	
	Если НЕ ФайлОбъект.Редактирует.Пустая() Тогда
		ФайлОбъект.Редактирует = Справочники.Пользователи.ПустаяСсылка();
		ФайлОбъект.Записать();
	Конецесли;
	
КонецПроцедуры

// Отмечает файл, как редактируемый.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка или Объект присоединенного файла, который требуется отметить.
//
Процедура ЗанятьФайлДляРедактированияСервер(Знач ПрисоединенныйФайл) Экспорт
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
	Иначе
		ФайлОбъект = ПрисоединенныйФайл;
	КонецЕсли;
	
	ФайлОбъект.Редактирует = ПользователиСервер.ТекущийПользователь();
	ФайлОбъект.Записать();
	
КонецПроцедуры

// Помещает зашифрованные данные файла в хранилище и устанавливает файлу признак Зашифрован.
//
// Параметры:
//  ПрисоединенныйФайл  - Ссылка на присоединенный файл.
//  ЗашифрованныеДанные - Структура со свойством:
//                          АдресВременногоХранилища - Строка - адрес зашифрованных двоичных данных.
//  МассивОтпечатков    - Массив Структур отпечатков по сертификатам.
// 
Процедура Зашифровать(Знач ПрисоединенныйФайл, Знач ЗашифрованныеДанные, Знач МассивОтпечатков) Экспорт
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ПрисоединенныйФайлОбъект.Заблокировать();
	Иначе
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл;
	КонецЕсли;
	
	Для Каждого ОтпечатокСтруктура Из МассивОтпечатков Цикл
		НоваяСтрока = ПрисоединенныйФайлОбъект.СертификатыШифрования.Добавить();
		НоваяСтрока.Отпечаток = ОтпечатокСтруктура.Отпечаток;
		НоваяСтрока.Представление = ОтпечатокСтруктура.Представление;
		НоваяСтрока.Сертификат = Новый ХранилищеЗначения(ОтпечатокСтруктура.Сертификат);
	КонецЦикла;
	
	РеквизитыЗначения = Новый Структура;
	РеквизитыЗначения.Вставить("Зашифрован", Истина);
	РеквизитыЗначения.Вставить("ТекстХранилище", Новый ХранилищеЗначения(""));
	ОбновитьДвоичныеДанныеФайлаНаСервере(ПрисоединенныйФайлОбъект, ЗашифрованныеДанные.АдресВременногоХранилища, РеквизитыЗначения);
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ПрисоединенныйФайлОбъект.Записать();
		ПрисоединенныйФайлОбъект.Разблокировать();
	КонецЕсли;
	
КонецПроцедуры

// Помещает расшифрованные данные файла в хранилище и снимает файлу признак Зашифрован.
// 
// Параметры:
//  ПрисоединенныйФайл  - Ссылка на присоединенный файл.
//  ЗашифрованныеДанные - Структура со свойством:
//                          АдресВременногоХранилища - Строка - адрес расшифрованных двоичных данных.
//
Процедура Расшифровать(Знач ПрисоединенныйФайл, Знач РасшифрованныеДанные) Экспорт
	
	Перем Отказ;
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ПрисоединенныйФайлОбъект.Заблокировать();
	Иначе
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл;
	КонецЕсли;
	
	ПрисоединенныйФайлОбъект.СертификатыШифрования.Очистить();
	
	РеквизитыЗначения = Новый Структура;
	РеквизитыЗначения.Вставить("Зашифрован", Ложь);
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(РасшифрованныеДанные.АдресВременногоХранилища);
	СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
	ИзвлеченныйТекст = "";
	
	Если ЭтоАдресВременногоХранилища(РасшифрованныеДанные.АдресВременногоХранилищаТекста) Тогда
		ИзвлеченныйТекст = ФайловыеФункции.ПолучитьСтрокуИзВременногоХранилища(РасшифрованныеДанные.АдресВременногоХранилищаТекста);
		СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.Извлечен;
		
	ИначеЕсли НЕ ФайловыеФункции.ИзвлекатьТекстыФайловНаСервере() Тогда
		// Тексты извлекаются сразу, а не в фоновом задании.
		СтатусИзвлеченияТекста = ИзвлечьТекст(ДвоичныеДанные, ПрисоединенныйФайл.Расширение, ИзвлеченныйТекст);
	КонецЕсли;
	
	ПрисоединенныйФайлОбъект.СтатусИзвлеченияТекста = СтатусИзвлеченияТекста;
	
	РеквизитыЗначения.Вставить("ТекстХранилище", Новый ХранилищеЗначения(ИзвлеченныйТекст, Новый СжатиеДанных(9)));
	
	ОбновитьДвоичныеДанныеФайлаНаСервере(ПрисоединенныйФайлОбъект, ДвоичныеДанные, РеквизитыЗначения);
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ПрисоединенныйФайлОбъект.Записать();
		ПрисоединенныйФайлОбъект.Разблокировать();
	КонецЕсли;
	
КонецПроцедуры

// Заменяет двоичные данные файла в ИБ на данные во временном хранилище.
Процедура ОбновитьДвоичныеДанныеФайлаНаСервере(Знач ПрисоединенныйФайл,
                                               Знач АдресФайлаВоВременномХранилищеДвоичныеДанные,
                                               Знач РеквизитыЗначения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
		ФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
		ФайлСсылка = ПрисоединенныйФайл;
	Иначе
		ФайлОбъект = ПрисоединенныйФайл;
		ФайлСсылка = ФайлОбъект.Ссылка;
	КонецЕсли;
	
	Если ТипЗнч(АдресФайлаВоВременномХранилищеДвоичныеДанные) = Тип("ДвоичныеДанные") Тогда
		ДвоичныеДанные = АдресФайлаВоВременномХранилищеДвоичныеДанные;
	Иначе
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилищеДвоичныеДанные);
	КонецЕсли;
	
	ФайлОбъект.Изменил = ПользователиСервер.ТекущийПользователь();
	
	Если ТипЗнч(РеквизитыЗначения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ФайлОбъект, РеквизитыЗначения);
	КонецЕсли;
	
	ТранзакцияАктивна = Ложь;
	
	Попытка
		Если ФайлОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
			НачатьТранзакцию();
			ТранзакцияАктивна = Истина;
			МенеджерЗаписи = РегистрыСведений.ПрисоединенныеФайлы.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ПрисоединенныйФайл = ФайлСсылка;
			МенеджерЗаписи.Прочитать();
			МенеджерЗаписи.ПрисоединенныйФайл = ФайлСсылка;
			МенеджерЗаписи.ХранимыйФайл = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
			МенеджерЗаписи.Записать();
		Иначе
			ПолныйПуть = ФайловыеФункции.ПолныйПутьТома(ФайлОбъект.Том) + ФайлОбъект.ПутьКФайлу;
			
			Попытка
				ФайлНаДиске = Новый Файл(ПолныйПуть);
				ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ПолныйПуть);
				
				ФайловыеФункции.ДобавитьНаДиск(
					ДвоичныеДанные,
					ФайлОбъект.ПутьКФайлу,
					ФайлОбъект.Том,
					ФайлОбъект.ДатаМодификацииУниверсальная,
					"",
					ФайлОбъект.Наименование,
					ФайлОбъект.Расширение,
					ДвоичныеДанные.Размер(),
					ФайлОбъект.Зашифрован);
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Файлы.Запись файла на диск'"),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники[ФайлСсылка.Метаданные().Имя],
					ФайлСсылка,
					ТекстОшибкиПриСохраненииФайлаВТоме(
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке), ФайлСсылка));
				
				ВызватьИсключение ТекстОшибкиПриСохраненииФайлаВТоме(КраткоеПредставлениеОшибки(ИнформацияОбОшибке), ФайлСсылка);
			КонецПопытки;
			
		КонецЕсли;
		
		ФайлОбъект.Размер = ДвоичныеДанные.Размер();
		
		ФайлОбъект.Записать();
		
		Если Справочники.ТипВсеСсылки().СодержитТип(ТипЗнч(ПрисоединенныйФайл)) Тогда
			ФайлОбъект.Разблокировать();
		КонецЕсли;
		
		Если ТранзакцияАктивна Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
		
	Исключение
		Если ТранзакцияАктивна Тогда
			ОтменитьТранзакцию();
		КонецЕсли;
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Файлы.Обновление данных присоединенного файла в хранилище файлов'"),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Записывает двоичные данные файла в информационную базу.
//
// Параметры:
//  ПрисоединенныйФайл - Ссылка на присоединенный файл.
//  ДвоичныеДанные     - ДвоичныеДанные, которые требуется записать.
//
Процедура ЗаписатьФайлВИнформационнуюБазу(Знач ПрисоединенныйФайл, Знач ДвоичныеДанные) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ПрисоединенныеФайлы.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ПрисоединенныйФайл = ПрисоединенныйФайл;
	МенеджерЗаписи.ХранимыйФайл = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

// Определяет, что к объекту присоединен по крайней мере один файл.
Функция ОбъектИмеетФайлы(Знач ВладелецФайлов, Знач ФайлИсключение = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ВладелецФайлов", ВладелецФайлов);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПрисоединенныеФайлы.Ссылка
	|ИЗ
	|	&ИмяСправочника КАК ПрисоединенныеФайлы
	|ГДЕ
	|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайлов";
	
	Если ФайлИсключение <> Неопределено Тогда
		ТекстЗапроса =  ТекстЗапроса +
		"
		|	И ПрисоединенныеФайлы.Ссылка <> &Ссылка";
		
		Запрос.Параметры.Вставить("Ссылка", ФайлИсключение);
	КонецЕсли;
	
	ИменаСправочников = ИменаСправочниковХраненияФайлов(ВладелецФайлов);
	
	Для каждого КлючИЗначение Из ИменаСправочников Цикл
		Запрос.Текст = СтрЗаменить(
			ТекстЗапроса, "&ИмяСправочника", "Справочник." + КлючИЗначение.Ключ);
		
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Возвращает массив присоединенных файлов для указанного владельца.
//
// Параметры:
//  ВладелецФайлов - Ссылка на владельца присоединенных файлов.
//
// Возвращаемое значение:
//  Массив ссылок на присоединенные файлы.
//
Функция ПолучитьВсеПодчиненныеФайлы(Знач ВладелецФайлов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИменаСправочников = ИменаСправочниковХраненияФайлов(ВладелецФайлов);
	ТекстЗапросов = "";
	
	Для каждого КлючИЗначение Из ИменаСправочников Цикл
		Если ЗначениеЗаполнено(ТекстЗапросов) Тогда
			ТекстЗапросов = ТекстЗапросов + 
			"
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|";
		КонецЕсли;
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПрисоединенныеФайлы.Ссылка
		|ИЗ
		|	&ИмяСправочника КАК ПрисоединенныеФайлы
		|ГДЕ
		|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайлов";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", "Справочник." + КлючИЗначение.Ключ);
		ТекстЗапросов = ТекстЗапросов + ТекстЗапроса;
	КонецЦикла;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВладелецФайлов", ВладелецФайлов);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// Извлекает текст из двоичных данных, возвращает статус извлечения.
Функция ИзвлечьТекст(Знач ДвоичныеДанные, Знач Расширение, ИзвлеченныйТекст) Экспорт
	
	Если ФайловыеФункции.ЭтоПлатформаWindows()
	   И ФайловыеФункции.ИзвлекатьТекстыФайловНаСервере() Тогда
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Расширение);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		Отказ = Ложь;
		ИзвлеченныйТекст = ФайловыеФункцииКлиентСервер.ИзвлечьТекстВоВременноеХранилище(ИмяВременногоФайла, , Отказ);
		
		Попытка
			УдалитьФайлы(ИмяВременногоФайла);
		Исключение
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Файлы.Извлечение текста'"),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		Если Отказ Тогда
			Возврат Перечисления.СтатусыИзвлеченияТекстаФайлов.ИзвлечьНеУдалось;
		Иначе
			Возврат Перечисления.СтатусыИзвлеченияТекстаФайлов.Извлечен;
		КонецЕсли;
	Иначе
		ИзвлеченныйТекст = "";
		Возврат Перечисления.СтатусыИзвлеченияТекстаФайлов.НеИзвлечен;
	КонецЕсли;
	
КонецФункции


// Возвращает соответствие имен справочников и значения Истина
// для указанного владельца.
// 
// Параметры:
//  ВладелецФайлов - Ссылка - объект, к которому добавляется файл.
// 
Функция ИменаСправочниковХраненияФайлов(ВладелецФайлов, НеВызыватьИсключение = Ложь) Экспорт
	
	Если ТипЗнч(ВладелецФайлов) = Тип("Тип") Тогда
		ТипВладельцаФайлов = ВладелецФайлов;
	Иначе
		ТипВладельцаФайлов = ТипЗнч(ВладелецФайлов);
	КонецЕсли;
	
	МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладельцаФайлов);
	
	ИменаСправочников = Новый Соответствие;
	ИмяСтандартногоОсновногоСправочника = МетаданныеВладельца.Имя + "ПрисоединенныеФайлы";
	ИменаСправочников.Вставить(ИмяСтандартногоОсновногоСправочника, Истина);
	
	ПрисоединенныеФайлыПереопределяемый.ПриОпределенииСправочниковХраненияФайлов(
		ТипВладельцаФайлов, ИменаСправочников);
	
	Для каждого КлючИЗначение Из ИменаСправочников Цикл
		
		Если Метаданные.Справочники.Найти(КлючИЗначение.Ключ) = Неопределено Тогда
			
			Если НеВызыватьИсключение
			   И ИменаСправочников.Количество() = 1
			   И ВРег(КлючИЗначение.Ключ) = ВРег(ИмяСтандартногоОсновногоСправочника) Тогда
				
				Возврат Новый Соответствие;
			КонецЕсли;
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при определении имен справочников для хранения файлов.
				           |У владельца файлов типа ""%1""
				           |указан несуществующий справочник ""%2"".'"),
				Строка(ТипВладельцаФайлов),
				Строка(КлючИЗначение.Ключ));
				
		ИначеЕсли Прав(КлючИЗначение.Ключ, СтрДлина("ПрисоединенныеФайлы"))<> "ПрисоединенныеФайлы" Тогда
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при определении имен справочников для хранения файлов.
				           |У владельца файлов типа ""%1""
				           |указано имя справочника ""%2""
				           |без окончания ""ПрисоединенныеФайлы"".'"),
				Строка(ТипВладельцаФайлов),
				Строка(КлючИЗначение.Ключ));
			
		ИначеЕсли КлючИЗначение.Значение = Неопределено Тогда
			ИменаСправочников.Вставить(КлючИЗначение.Ключ, Ложь);
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаСправочников.Количество() = 0 Тогда
		
		Если НеВызыватьИсключение Тогда
			Возврат Новый Соответствие;
		КонецЕсли;
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка при определении имен справочников для хранения файлов.
			           |У владельца файлов типа ""%1""
			           |не имеется справочников для хранения файлов.'"),
			Строка(ТипВладельцаФайлов));
	КонецЕсли;
	
	Возврат ИменаСправочников;
	
КонецФункции

// Возвращает имя справочника для указанного владельца или вызывает исключение,
// если их более одного.
// 
// Параметры:
//  ВладелецФайлов  - Ссылка - объект, к которому добавляется файл.
//  ИмяСправочника  - Строка, если заполнено, то выполняется проверка
//                    наличия справочника среди справочников владельца для хранения файлов.
//  ЗаголовокОшибки - Строка - заголовок ошибки.
//                  - Неопределено - не вызывать исключение, а вернуть пустую строку.
//  ИмяПараметра    - Строка - имя требуемого параметра для определения имени справочника.
//  ОкончаниеОшибки - Строка - окончание ошибки (только для случая, когда ИмяПараметра = Неопределено).
// 
Функция ИмяСправочникаХраненияФайлов(ВладелецФайлов,
                                     ИмяСправочника = "",
                                     ЗаголовокИсключения = Неопределено,
                                     ИмяПараметра = "ИмяСправочника",
                                     ОкончаниеОшибки = Неопределено) Экспорт
	
	НеВызыватьИсключение = (ЗаголовокИсключения = Неопределено);
	ИменаСправочников = ИменаСправочниковХраненияФайлов(ВладелецФайлов, НеВызыватьИсключение);
	
	Если ЗначениеЗаполнено(ИмяСправочника)
	   И ИменаСправочников[ИмяСправочника] = Неопределено Тогда
	
		Если НеВызыватьИсключение Тогда
			Возврат "";
		КонецЕсли;
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокИсключения +
			НСтр("ru = '
			           |У владельца файлов ""%1"" типа ""%2""
			           |нет справочника ""%3"" для хранения файлов.'"),
			Строка(ВладелецФайлов),
			Строка(ТипЗнч(ВладелецФайлов)),
			Строка(ИмяСправочника));
	КонецЕсли;
	
	ОсновнойСправочник = "";
	ОсновнойСправочникНайден = Ложь;
	Для каждого КлючИЗначение Из ИменаСправочников Цикл
		Если КлючИЗначение.Значение = Истина Тогда
			Если ОсновнойСправочникНайден Тогда
				// Если основной справочник указан дважды, значит не указан.
				ОсновнойСправочник = "";
			Иначе
				ОсновнойСправочник = КлючИЗначение.Ключ;
				ОсновнойСправочникНайден = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаСправочников.Количество() > 1
	   И ИменаСправочников[ИмяСправочника] = Неопределено
	   И НЕ ЗначениеЗаполнено(ОсновнойСправочник) Тогда
		
		Если НеВызыватьИсключение Тогда
			Возврат "";
		КонецЕсли;
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ЗаголовокИсключения +
			НСтр("ru = '
			           |У владельца файлов ""%1"" типа ""%2""
			           |имеется более одного справочника для хранения файлов.
			           |'") + ?(ИмяПараметра = Неопределено, ОкончаниеОшибки,
			НСтр("ru = 'В этом случае параметр ""%3"" должен быть указан.'")),
			Строка(ВладелецФайлов),
			Строка(ТипЗнч(ВладелецФайлов)),
			Строка(ИмяПараметра));
	КонецЕсли;
	
	Если ИменаСправочников[ИмяСправочника] = Неопределено Тогда
		Если ЗначениеЗаполнено(ОсновнойСправочник) Тогда
			ИмяСправочника = ОсновнойСправочник;
		Иначе
			Для каждого КлючИЗначение Из ИменаСправочников Цикл
				ИмяСправочника = КлючИЗначение.Ключ;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИмяСправочника;
	
КонецФункции

// Возвращает текст сообщения об ошибке, добавляя к нему ссылку на элемент
// справочника хранимого файла.
//
Функция ТекстОшибкиПриСохраненииФайлаВТоме(Знач СообщениеОбОшибке, Знач Файл)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка, при сохранении файла в томе:
		           |""%1"".
		           |
		           |Ссылка на файл: ""%2"".'"),
		СообщениеОбОшибке,
		ПолучитьНавигационнуюСсылку(Файл) );
	
КонецФункции

