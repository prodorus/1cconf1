////////////////////////////////////////////////////////////////////////////////
//              МОДУЛЬ ФОРМЫ ЭЛЕМЕНТА СПРАВОЧНИКА ПОЛЬЗОВАТЕЛИ                //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Блок обработчиков событий формы
//

// Обработчик события "ПриСоздании" формы.
// Производит считывание данных пользователя ИБ и заполняет соответствующие
// реквизиты формы. При необходимости данные для нового пользователя
// копируются из существующего.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РассогласованиеДанных = 0;
	
	Если СокрЛП(Объект.Код) = "<Не указан>" Тогда
		ЭтаФорма.Доступность = Ложь;
	КонецЕсли;

	ПравоАдминистрирования = УправлениеПользователямиСервер.ПроверитьПравоАдминистрирования();
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЭтоНовыйПользователь = Ложь;
		ПроверитьСинхронизациюДанныхПользователя();
	Иначе
		ЭтоНовыйПользователь = Истина;
	КонецЕсли;
	
	// Если пользователь редактирует своего пользователя ИБ
	// то необходимо после записи обновить интерфейс
	Если ПараметрыСеанса.ТекущийПользователь = Объект.Ссылка Тогда
		ОбновлятьИнтерфейс = Истина;
	Иначе
		ОбновлятьИнтерфейс = Ложь;
	КонецЕсли;
	
	//////////////////////////////////////////////////////////////////
	// Заполнение данных формы
	
	// Заполнение списка выбора интерфейса
	СписокВыбораИнтерфейса = Элементы.ОсновнойИнтерфейс.СписокВыбора;
	Для Каждого ДоступныйИнтерфейс Из Метаданные.Интерфейсы Цикл
		СписокВыбораИнтерфейса.Добавить(ДоступныйИнтерфейс.Имя, ДоступныйИнтерфейс.Синоним);
	КонецЦикла; 
	
	// Заполнение списка выбора языка
	СписокВыбораЯзыка = Элементы.Язык.СписокВыбора;
	СписокВыбораЯзыка.Очистить();

	Для Каждого ДоступныйЯзык ИЗ Метаданные.Языки Цикл
		СписокВыбораЯзыка.Добавить(ДоступныйЯзык.Имя, ДоступныйЯзык.Синоним);
	КонецЦикла;
	
	// сбрасываем флаг изменённости пароля для доступа пользователя в режиме
	// Аутентификации 1с Предприятия
	Пароль1СПредприятияБылИзменен = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Язык) Тогда
		Язык = Метаданные.Языки.Русский;
	КонецЕсли;
	
	Если ПравоАдминистрирования Тогда

		// Если новый элемент справочника создаётся копированием с существующего
		// то необходимо скопировать так же данные пользователя ИБ с которого
		// производится копирование.
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ЗаполнитьДанныеПользователяИБВРеквизиты(Параметры.ЗначениеКопирования);
			Объект.Код = "";
			Объект.Наименование = "";
			Объект.ИдентификаторПользователяИБ = "";
		Иначе // создание нового пользователя или открытие существующего
			Если ЗначениеЗаполнено(Объект.Ссылка)
			   И ЗаполнитьДанныеПользователяИБВРеквизиты() Тогда
				// заполнили данные формы по пользователю
			Иначе
				// устанавливаем значения "по умолчанию"
				Аутентификация1СПредприятия = Истина;
				ПоказыватьВСпискеВыбора     = Истина;
				ЗапрещеноИзменятьПароль     = Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.ГруппаНетПраваАдминистрирования.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСвойства.Видимость = Ложь;
	КонецЕсли;
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
		// Доп. сведения доступны только в обычном приложении
		Элементы.ДополнительныеСведения.Видимость = Истина;
		
		мНаличиеПраваАдминистрирования = УправлениеДопПравамиПользователей.ЕстьПравоАдминистрированияПользователей();
		Если НЕ мНаличиеПраваАдминистрирования Тогда 
			Элементы.Администрирование.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьЭлементыПриРассинхронизации();
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСинхронизациюДанныхПользователя()
	
	РассогласованиеДанных = 0;
	
	Если Не ЗначениеЗаполнено(Объект.ИдентификаторПользователяИБ) Тогда
		РассогласованиеДанных = 1;
	ИначеЕсли НЕ ПользователиПолныеПрава.ПользовательСуществует(Объект.ИдентификаторПользователяИБ) Тогда
		РассогласованиеДанных = 2;
	ИначеЕсли ПользователиПолныеПрава.РассинхронизацияИмениПользователя(Объект.Ссылка) Тогда
		РассогласованиеДанных = 3;
	КонецЕсли;
	
КонецПроцедуры

//	Устанавливает видимость предупреждений на форме в случае рассогласования
//	данных пользователя ИБ и элемента справочника Пользователи.
//	РассогласованиеБудетСнято - булево - флаг используется
//	для сигнализации того, что флаг в настоящее время установлен
//	но будет снят после выполнения функции (значение реквизита
//	РассогласованиеДанных еще будет использоваться)
//
&НаСервере
Процедура УстановитьЭлементыПриРассинхронизации(знач РассогласованиеБудетСнято = Ложь)
	
	Элементы.ГруппаПредупреждение.Видимость = Ложь;
	Элементы.ВыполнитьСинхронизацию.Видимость = Ложь;
	
	Если РассогласованиеБудетСнято Тогда
		Возврат;
	КонецЕсли;
	
	// Сбросим видимость
	Элементы.ДекорацияНеСопоставленПользовательИБ.Видимость = Ложь;
	Элементы.ДекорацияРассогласованиеДанных.Видимость = Ложь;
	Элементы.ВыполнитьСинхронизацию.Видимость = Ложь;
	Элементы.ДекорацияРолиНеСоответствуютПрофилю.Видимость = Ложь;
	Элементы.ДекорацияНетРолиПользователь.Видимость = Ложь;
		
	Если РассогласованиеДанных = 1 Или РассогласованиеДанных = 2 Тогда
		// Не смогли найти пользователя ИБ
		Элементы.ГруппаПредупреждение.Видимость = Истина;
		Элементы.ДекорацияНеСопоставленПользовательИБ.Видимость = Истина;
		Элементы.УдалитьПользователяИБ.Доступность = Ложь;
		
	ИначеЕсли РассогласованиеДанных = 3 Тогда
		// Пользователь ИБ найден, но есть рассогласование данных
		Элементы.ГруппаПредупреждение.Видимость = Истина;
		
		ИмяПолноеИмя = УправлениеПользователямиСервер.ПолучитьИмяПолноеИмя(Объект.ИдентификаторПользователяИБ);
		
		Элементы.ДекорацияРассогласованиеДанных.Видимость = Истина;
		Элементы.ДекорацияРассогласованиеДанных.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Элементы.ДекорацияРассогласованиеДанных.Заголовок,
				ИмяПолноеИмя.Имя, ИмяПолноеИмя.ПолноеИмя);
		
		Элементы.ВыполнитьСинхронизацию.Видимость = Истина;
	КонецЕсли;
		
	Если РолиНеСоответствуютПрофилю Тогда
		Элементы.ГруппаПредупреждение.Видимость = Истина;
		Элементы.ДекорацияРолиНеСоответствуютПрофилю.Видимость = Истина;
	КонецЕсли;
	
	Если НетРолиПользователь Тогда
		Элементы.ГруппаПредупреждение.Видимость = Истина;
		Элементы.ДекорацияНетРолиПользователь.Видимость = Истина;
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик события "ПриОткрытии" формы.
// Устанавливает доступность элементов управления аутентификацией.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
	Элементы.ПользовательОС.КнопкаВыбора = Ложь;
	#КонецЕсли
	
	Если ПравоАдминистрирования Тогда
		УстановитьВидимостьПараметровАутентификации1СПредприятия();
		Элементы.ПользовательОС.Доступность = ?(АутентификацияОС, Истина, Ложь);
		УстановитьДоступностьИзмененияРолей();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "ПередЗаписью" формы
// Проверяет, что пользователю установлена хотя бы одна роль,
// а так же корректность заполнения других реквизитов.
//
&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	ОчиститьСообщения();
	
	// Если не пользователь не сопоставлен с учетной записью в информационной базе
	// предупредить, что сохранение создаст пользователя ИБ
	Если РассогласованиеДанных = 1 Или РассогласованиеДанных = 2 Тогда
		ТекстВопроса = НСтр("ru = 'Внимание! Запись пользователя приведет к созданию учетной записи в информационной базе. Продолжить?'");
		Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , ,
							НСтр("ru = 'Запись пользователя информационной базы'"));
		
		Если Результат = КодВозвратаДиалога.Нет Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ПравоАдминистрирования Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Код) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							НСтр("ru = 'Не заполнено имя пользователя'"), ,
							"Код",,
							Отказ);
			Возврат;
		КонецЕсли;
		
		Если Аутентификация1СПредприятия 
		   И Пароль1СПредприятияБылИзменен 
		   И Пароль1СПредприятия <> Пароль1СПредприятияПодтверждение Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							НСтр("ru = 'Пароль и подтверждение пароля не совпадают.'"), ,
							"Пароль1СПредприятия", ,
							Отказ);
			Возврат;
		КонецЕсли;
		
		// Если указана аутентификация ОС, то должен быть указан пользователь ОС
		Если АутентификацияОС И ПустаяСтрока(ПользовательОС) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							НСтр("ru = 'Укажите пользователя операционной системы или запретите аутентификацию операционной системы!'"), ,
							"ПользовательОС", ,
							Отказ);
			Возврат;
		КонецЕсли;
		
		Если НЕ ПроверитьРолиНазначены() Тогда
			ТекстВопроса = НСтр("ru = 'Пользователю информационной базы не установлено ни одной роли. Продолжить?'");
			Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , ,
								НСтр("ru = 'Запись пользователя информационной базы'"));
			
			Если Результат = КодВозвратаДиалога.Нет Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.Ссылка)
		   И ПользователиПолныеПрава.ПользовательСуществует(СокрЛП(Объект.Код)) Тогда
			ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Пользователь с именем ""%1"" уже существует.'"),
										СокрЛП(Объект.Код) );
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						ТекстСообщенияОбОшибке, ,
						"Код",,
						Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	ЗаписатьПользователяИБ(Отказ, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьПользователяИБ(Отказ, ТекущийОбъект)
	
	Перем СообщениеОбОшибке;
	
	Если ПравоАдминистрирования Тогда
		СообщениеОбОшибке = "";
		
		Отказ = Ложь;
		
		ДанныеПользователяИБ = ПодготовитьДанныеПользователяИБДляЗаписи();
		
		СписокРолей = Новый ТаблицаЗначений;
		СписокРолей.Колонки.Добавить("ИмяРоли");
		СписокРолей.Колонки.Добавить("Пометка");
		
		Если Объект.ПрофильПолномочийПользователя.Пустая() Тогда
			Для Каждого ЭлементКоллекции Из РолиПользователя Цикл
				НоваяСтрока = СписокРолей.Добавить();
				НоваяСтрока.ИмяРоли = ЭлементКоллекции.ИмяРоли;
				НоваяСтрока.Пометка = Истина;
			КонецЦикла;
		Иначе
			КоллекцияРолей = ПолучитьСписокРолейПрофиля(Объект.ПрофильПолномочийПользователя);
			Для Каждого ЭлементКоллекции Из КоллекцияРолей Цикл
				НоваяСтрока = СписокРолей.Добавить();
				НоваяСтрока.ИмяРоли = ЭлементКоллекции.Имя;
				НоваяСтрока.Пометка = Истина;
			КонецЦикла;
		КонецЕсли;
		
		// Роль "Пользователь" добавляем автоматически
		Если СписокРолей.Найти("Пользователь", "ИмяРоли") = Неопределено Тогда
			НоваяСтрока = СписокРолей.Добавить();
			НоваяСтрока.ИмяРоли = "Пользователь";
			НоваяСтрока.Пометка = Истина;
		КонецЕсли; 
		
		Если Не Отказ Тогда
			// Идентификатор не валидный, пытаемся идентифицироваться по имени
			Если РассогласованиеДанных = 1 ИЛИ РассогласованиеДанных = 2 Тогда
				Идентификатор = УправлениеПользователямиСервер.ЗаписатьПользователяИБ(
										СокрЛП(ТекущийОбъект.Ссылка.ПолучитьОбъект().Код),
										ДанныеПользователяИБ,
										СообщениеОбОшибке,
										СписокРолей);
			Иначе
				Идентификатор = УправлениеПользователямиСервер.ЗаписатьПользователяИБ(
										ТекущийОбъект.ИдентификаторПользователяИБ,
										ДанныеПользователяИБ,
										СообщениеОбОшибке,
										СписокРолей);
			КонецЕсли;
			
			Если Идентификатор = Неопределено Тогда
				Отказ = Истина;
			Иначе
				ТекущийОбъект.ИдентификаторПользователяИБ = Идентификатор;
			КонецЕсли;
		КонецЕсли;
		
		Если Отказ Тогда
			Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
				ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                           НСтр("ru = 'Ошибка записи пользователя ИБ: %1'"),
				                           СообщениеОбОшибке );
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОбОшибке);
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Пользователь информационной базы не был записан'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "ПослеЗаписи" формы.
// Обновляет интерфес, а так же оповещает о записи объекта.
//
&НаКлиенте
Процедура ПослеЗаписи()
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	Если РассогласованиеДанных <> 0 Тогда
		РассогласованиеДанных = 0;
		Элементы.УдалитьПользователяИБ.Доступность = Истина;
		Оповестить("ИзмененПользовательИБ", Объект.Ссылка, ЭтаФорма);
	КонецЕсли;
	
	// При записи роли обновляются
	РолиНеСоответствуютПрофилю = Ложь;
	НетРолиПользователь = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если РассогласованиеДанных <> 0 
		ИЛИ РолиНеСоответствуютПрофилю 
		ИЛИ НетРолиПользователь Тогда
		
		УстановитьЭлементыПриРассинхронизации(Истина);
	КонецЕсли;
	
	// Роли пользователя могут измениться при изменении профиля
	ЗаполнитьСписокРолейПользователяИБ();
	
	Если ЭтоНовыйПользователь Тогда
		ПользователиПолныеПрава.УстановитьНастройкиПоУмолчанию(ТекущийОбъект.Ссылка); 
		ЭтоНовыйПользователь = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Блок обработчиков события элементов формы
//

// Обработчик события "ПриИзменении" поля Код
// Устанавливает полное имя пользователя таким же, как его краткое имя
//
&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = СокрЛП(Объект.Код);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "ПриИзменении" поля Пароль1СПредприятия.
// Устанавливает флаг того, что пароль был изменен.
//
&НаКлиенте
Процедура Пароль1СПредприятияПриИзменении(Элемент)
	
	Пароль1СПредприятияБылИзменен = Истина;
	
КонецПроцедуры

// Обработчик события "ПриИзменении" поля ввода Пароль1СПредприятияПодтверждение.
// Устанавливает флаг того, что пароль был изменен.
&НаКлиенте
Процедура Пароль1СПредприятияПодтверждениеПриИзменении(Элемент)
	
	Пароль1СПредприятияБылИзменен = Истина;
	
КонецПроцедуры

// Процедура открывает форму выбора пользователя ОС и в случае успешного
// выбора возвращает строку соединения.
//
// Возвращаемое значение
// СтрокаСоединения - Строка соединения пользователя ОС при аутентификации ОС
//
&НаКлиенте
Процедура ПользовательОСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если НЕ ВебКлиент Тогда
	Результат = ОткрытьФормуМодально("Справочник.Пользователи.Форма.ФормаВыбораПользователяОС");
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ПользовательОС = Результат;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофильПолномочийПользователяПриИзменении(Элемент)
	
	УстановитьДоступностьИзмененияРолей();
	
	ЗаполнитьСписокРолейПрофиля();
	
	// Если пользователь изменил профиль, то не будем обращать внимание на рассинхронизацию
	Если РолиНеСоответствуютПрофилю ИЛИ НетРолиПользователь Тогда
		РолиНеСоответствуютПрофилю = Ложь;
		НетРолиПользователь = Ложь;	
		УстановитьЭлементыПриРассинхронизации(Истина);
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик события "ПриИзменении" поля флажка Аутентификация1СПредприятия
// Включает либо отключает доступность полей соответственно установленности
// либо сброшенности флажка.
//
&НаКлиенте
Процедура Аутентификация1СПредприятияПриИзменении(Элемент)
	
	УстановитьВидимостьПараметровАутентификации1СПредприятия();
	
КонецПроцедуры

// Обработчик события "ПриИзменении" поля флажка АутентификацияОС
// Включает либо отключает доступность полей соответственно
// установленности либо сброшенности флажка.
//
&НаКлиенте
Процедура АутентификацияОСПриИзменении(Элемент)
	
	Элементы.ПользовательОС.Доступность = ?(АутентификацияОС, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура РолиПользователяПриИзменении(Элемент)
	
	Этаформа.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РолиПользователяПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если НЕ Объект.ПрофильПолномочийПользователя.Пустая() Тогда
		Предупреждение(НСтр("ru = 'Редактирование ролей осуществляется через профиль пользователя'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РолиПользователяПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	УдалитьВыбранныеРоли();
	
КонецПроцедуры

&НаКлиенте
Процедура РолиПользователяПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ОткрытьПодборРолей();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ ФОРМЫ
//

&НаКлиенте
Процедура ВыполнитьСинхронизацию(Команда)
	
	ИмяПолноеИмя = УправлениеПользователямиСервер.ПолучитьИмяПолноеИмя(Объект.ИдентификаторПользователяИБ);
	Объект.Код = ИмяПолноеИмя.Имя;
	Объект.Наименование = ИмяПолноеИмя.ПолноеИмя;
	Модифицированность = Истина;
	
	УстановитьЭлементыПриРассинхронизации(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСоставРолей(Команда)
	
	ОткрытьПодборРолей();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтактнаяИнформация(Команда)
	
	Если НЕ ЗаписатьПользователяПриМодифицированности() Тогда
		Возврат;
	КонецЕсли; 
	
	ФормаРедактрованияКИ = ПолучитьФорму("Справочник.Пользователи.Форма.РедактированиеКонтактнойИнформации");
	ФормаРедактрованияКИ.Ссылка = Объект.Ссылка;
	ФормаРедактрованияКИ.ОткрытьМодально();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыПользователя(Команда)
	
	Если НЕ ЗаписатьПользователяПриМодифицированности() Тогда
		Возврат;
	КонецЕсли; 
	
	ФормаНастройкиГруппПользователя = ПолучитьФорму("Справочник.Пользователи.Форма.ФормаНастройкиГруппПользователя");
	ФормаНастройкиГруппПользователя.Пользователь = Объект.Ссылка;
	ФормаНастройкиГруппПользователя.ОткрытьМодально();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПользователя(Команда)
	
	Если НЕ ЗаписатьПользователяПриМодифицированности() Тогда
		Возврат;
	КонецЕсли; 
	
	ФормаРедактрованияНастроек = ПолучитьФорму("РегистрСведений.НастройкиПользователей.Форма.ФормаРедактированияНастроек");
	ФормаРедактрованияНастроек.НачальноеЗначениеВыбора = Объект.Ссылка;
	ФормаРедактрованияНастроек.Открыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПрава(Команда)
	
	Если НЕ ЗаписатьПользователяПриМодифицированности() Тогда
		Возврат;
	КонецЕсли; 
	
	Если Объект.ПрофильПолномочийПользователя.Пустая() Тогда
		ФормаРедактирования = ПолучитьФорму("РегистрСведений.ЗначенияДополнительныхПравПользователя.Форма.ФормаРедактирования");
		ФормаРедактирования.Пользователь = Объект.Ссылка;
		ФормаРедактирования.Открыть();		
	Иначе
		Предупреждение("Пользователю назначен профиль.
					|Настройка дополнительных прав выполняется в форме профиля.",, "Дополнительные права");
	КонецЕсли; 
	
КонецПроцедуры
 
&НаКлиенте
Процедура ОткрытьСправкуПоРолям(Команда)
	
	ОткрытьСправку("ОбщаяФорма.ПодборРолейУправляемая");
	
КонецПроцедуры
   

////////////////////////////////////////////////////////////////////////////////
// БЛОК ВСПОМОГАТЕЛЬНЫХ ФУНКЦИЙ
//

// Устанавливает видимость параметров аутентификации 1С предприятия
//
&НаКлиенте
Процедура УстановитьВидимостьПараметровАутентификации1СПредприятия()
	
	Состояние = Аутентификация1СПредприятия;
	Элементы.Пароль1СПредприятия.Доступность = Состояние;
	Элементы.Пароль1СПредприятияПодтверждение.Доступность = Состояние;
	Элементы.ЗапрещеноИзменятьПароль.Доступность = Состояние;
	Элементы.ПоказыватьВСпискеВыбора.Доступность = Состояние;
	
КонецПроцедуры

// Процедура формирует структуру данныхпользователя ИБ для записи
//
&НаСервере
Функция ПодготовитьДанныеПользователяИБДляЗаписи()
	
	ПользовательИБ = Новый Структура;
	
	ПользовательИБ.Вставить("Имя",						СокрЛП(Объект.Код));
	ПользовательИБ.Вставить("ПолноеИмя",				Объект.Наименование);
	ПользовательИБ.Вставить("АутентификацияСтандартная",Аутентификация1СПредприятия);
	ПользовательИБ.Вставить("АутентификацияОС",			АутентификацияОС);
	ПользовательИБ.Вставить("ПользовательОС",			ПользовательОС);
	ПользовательИБ.Вставить("ПоказыватьВСпискеВыбора",	ПоказыватьВСпискеВыбора);
	ПользовательИБ.Вставить("ЗапрещеноИзменятьПароль",	ЗапрещеноИзменятьПароль);
	
	Если РежимЗапуска = НСтр("ru = 'Обычное приложение'") Тогда
		ПользовательИБ.Вставить("РежимЗапуска", РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение);
	ИначеЕсли РежимЗапуска = НСтр("ru = 'Управляемое приложение'") Тогда
		ПользовательИБ.Вставить("РежимЗапуска", РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение);
	Иначе
		ПользовательИБ.Вставить("РежимЗапуска", РежимЗапускаКлиентскогоПриложения.Авто);
	КонецЕсли;
	
	Если Аутентификация1СПредприятия И Пароль1СПредприятияБылИзменен Тогда
		ПользовательИБ.Вставить("Пароль", Пароль1СПредприятия);
	КонецЕсли;
	
	ПользовательИБ.Вставить("ОсновнойИнтерфейс", ОсновнойИнтерфейс);
	
	// Находим язык по имени и присваиваем его пользователю.
	ПользовательИБ.Вставить("Язык", Язык);
	
	Возврат ПользовательИБ;
	
КонецФункции

// Считывает информацию о параметрах аутентификации пользователя из метаданных ИБ
// и заполняет реквизиты соответственно.
//
&НаСервере
Функция ЗаполнитьДанныеПользователяИБВРеквизиты(знач ЗначениеКопирования = Неопределено)
	
	ПользовательИБ = ПолучитьПользователяИБ(ЗначениеКопирования);
	
	Если ПользовательИБ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Аутентификация1СПредприятия = ПользовательИБ.АутентификацияСтандартная;
	ПоказыватьВСпискеВыбора     = ПользовательИБ.ПоказыватьВСпискеВыбора;
	ЗапрещеноИзменятьПароль     = ПользовательИБ.ЗапрещеноИзменятьПароль;
	АутентификацияОС            = ПользовательИБ.АутентификацияОС;
	Язык                        = ПользовательИБ.Язык;
	ПользовательОС              = ПользовательИБ.ПользовательОС;
	
	Если ПользовательИБ.ОсновнойИнтерфейс <> Неопределено Тогда
		ОсновнойИнтерфейс = ПользовательИБ.ОсновнойИнтерфейс.Имя;
	КонецЕсли; 
	
	Если ПользовательИБ.РежимЗапуска = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
		РежимЗапуска = НСтр("ru = 'Обычное приложение'");
	ИначеЕсли ПользовательИБ.РежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		РежимЗапуска = НСтр("ru = 'Управляемое приложение'");
	Иначе
		РежимЗапуска = НСтр("ru = 'Авто'");
	КонецЕсли;

	Если ПользовательИБ.ПарольУстановлен Тогда
		Пароль1СПредприятия              = "**********";
		Пароль1СПредприятияПодтверждение = "**********";
	КонецЕсли;
	
	ЗаполнитьСписокРолейПользователяИБ(ПользовательИБ);
	
	Возврат Истина;
	
КонецФункции

// Проверяет что пользователю назначена хотя бы одна роль.
//
&НаКлиенте
Функция ПроверитьРолиНазначены()
	
	Если НЕ Объект.ПрофильПолномочийПользователя.Пустая() Тогда
		Возврат Истина;
	КонецЕсли; 
	
	ОднаРольУстановлена = Ложь;
	
	Для Каждого ЭлементКоллекции Из РолиПользователя Цикл
		Если ЭлементКоллекции.Пометка Тогда
			ОднаРольУстановлена = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОднаРольУстановлена;
	
КонецФункции

&НаКлиенте
Процедура УдалитьПользователяИБ(Команда)
	
	Результат = Вопрос(НСтр("ru = 'Внимание! Будет удален пользователь информационной базы 
					|(элемент справочника удален не будет). Продолжить?'"),
					РежимДиалогаВопрос.ОКОтмена, , 
					КодВозвратаДиалога.Отмена, 
					НСтр("ru = 'Удаление пользователя информационной базы'"));
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Результат = УдалитьПользователяИБНаСервере();
		Если Результат.Статус Тогда
			ОбновитьИнтерфейс();
			Предупреждение(НСтр("ru = 'Пользователь информационной базы успешно удален!'"));
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.СообщениеОбОшибке);
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьПользователяИБНаСервере()
	
	Результат = УправлениеПользователямиСервер.УдалитьПользователяИБ(Объект.ИдентификаторПользователяИБ);
	
	Если Результат.Статус Тогда
		ОбъектЗначение = РеквизитФормыВЗначение("Объект");
		ОбъектЗначение.ИдентификаторПользователяИБ = "";
		ЗначениеВРеквизитФормы(ОбъектЗначение, "Объект");
		ПроверитьСинхронизациюДанныхПользователя();
		УстановитьЭлементыПриРассинхронизации();
		Модификация = Ложь; // теперь пользователя нет, данные не менялись
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьПользователяИБ(ЗначениеКопирования = Неопределено)
	
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ЗначениеКопирования.ИдентификаторПользователяИБ);
	Иначе
		Если РассогласованиеДанных = 3 Тогда
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Объект.ИдентификаторПользователяИБ);
		Иначе
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(СокрЛП(Объект.Код));
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПользовательИБ;
	
КонецФункции // 

// Процедура заполняет роли, которые назначены пользователю ИБ
// Вызывается при создании формы и после записи
//
&НаСервере
Процедура ЗаполнитьСписокРолейПользователяИБ(Знач ПользовательИБ = Неопределено)
	
	// Если у пользователя нет административных прав, 
	// то на форме не отображаются свойства пользователя ИБ
	Если НЕ ПравоАдминистрирования Тогда
		Возврат;
	КонецЕсли;
	
	РолиНеСоответствуютПрофилю = Ложь;
	НетРолиПользователь = Ложь;
	
	РолиПользователя.Очистить();
	
	Если ПользовательИБ = Неопределено Тогда
		ПользовательИБ = ПолучитьПользователяИБ();
	КонецЕсли; 
	
	КоллекцияРолейПрофиля = ПолучитьСписокРолейПрофиля(Объект.ПрофильПолномочийПользователя);
	
	Если ПользовательИБ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// При заполнении ролей переменная будет расчитана заново
	НетРолиПользователь = Истина;
	
	// Есть пользователь ИБ. Покажем список его ролей
	Для Каждого РольПользователя ИЗ ПользовательИБ.Роли Цикл
		
		Если РольПользователя.Имя = "Пользователь" Тогда
			// Роль "Пользователь" не показываем в списке
			// Предполагается, что она есть у всех пользователей
			НетРолиПользователь = Ложь;
			Продолжить;
		КонецЕсли;
		
		СтрокаРоли = РолиПользователя.Добавить();
		СтрокаРоли.ИмяРоли = РольПользователя.Имя;
		СтрокаРоли.ПредставлениеРоли = РольПользователя.Синоним;
		СтрокаРоли.Пометка = Истина;
		
		// Определим есть ли роль в профиле
		// Если ее нет, то в списке она будет выделена цветом
		Если КоллекцияРолейПрофиля <> Неопределено Тогда
			Если КоллекцияРолейПрофиля.Найти(СтрокаРоли.ИмяРоли, "Имя") <> Неопределено Тогда
				СтрокаРоли.ПрофильСодержитРоль = Истина;
			Иначе
				РолиНеСоответствуютПрофилю = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры //

// Процедура заполняет роли, которые назначены профилю
// Вызывается при изменении профиля
//
&НаСервере
Процедура ЗаполнитьСписокРолейПрофиля()

	Если Объект.ПрофильПолномочийПользователя.Пустая() Тогда
		// Пользователь очистил профиль
		// Оставим список ролей профиля (список был заполнен ранее)
		Возврат;
	КонецЕсли; 
	
	РолиПользователя.Очистить();
	
	КоллекцияРолей = ПолучитьСписокРолейПрофиля(Объект.ПрофильПолномочийПользователя);
		
	Для Каждого РольПользователя ИЗ КоллекцияРолей Цикл
		СтрокаРоли = РолиПользователя.Добавить();
		СтрокаРоли.ИмяРоли = РольПользователя.Имя;
		СтрокаРоли.ПредставлениеРоли = РольПользователя.Синоним;
		СтрокаРоли.Пометка = Истина;
		СтрокаРоли.ПрофильСодержитРоль = Истина;
	КонецЦикла;
	
КонецПроцедуры //
 
// Процедура удаляет выбранные роли
//
&НаКлиенте
Процедура УдалитьВыбранныеРоли()
	
	СтрокиКУдалениюСпросить = Новый Массив;
	ТекстКУдалениюСпросить = "";
	
	СтрокиКУдалению = Новый Массив;
	Для каждого ИндексСтроки Из Элементы.РолиПользователя.ВыделенныеСтроки Цикл
		РольОбъекта = Элементы.РолиПользователя.ДанныеСтроки(ИндексСтроки);
		Если РольОбъекта.ИмяРоли = "Пользователь" Тогда
			// Роль "Пользователь" нельзя удалять
			Продолжить;
		КонецЕсли;
		
		Если РольОбъекта.ИмяРоли = "ПолныеПрава" 
			ИЛИ РольОбъекта.ИмяРоли = "Пользователь"
			ИЛИ РольОбъекта.ИмяРоли = "АдминистраторПользователей" Тогда
			
			СтрокиКУдалениюСпросить.Добавить(РольОбъекта);
			ТекстКУдалениюСпросить = ТекстКУдалениюСпросить + Символы.ПС + " - " + РольОбъекта.ПредставлениеРоли;
		Иначе
			СтрокиКУдалению.Добавить(РольОбъекта);
		КонецЕсли; 
	КонецЦикла;
	
	Если СтрокиКУдалениюСпросить.Количество() <> 0 Тогда
		ТекстВопроса = "Вы действительно хотите удалить роли?" + ТекстКУдалениюСпросить;
		Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Возврат;
		ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
			Для каждого ЭлКоллекции Из СтрокиКУдалениюСпросить Цикл
				СтрокиКУдалению.Добавить(ЭлКоллекции);
			КонецЦикла; 
		КонецЕсли;			 
	КонецЕсли; 
	
	Для каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
		РолиПользователя.Удалить(СтрокаКУдалению);	
	КонецЦикла; 
	
	Модифицированность = Истина;
	
КонецПроцедуры //

&НаКлиенте
Процедура ОткрытьПодборРолей()
	
	УправлениеПользователямиКлиент.ОткрытьПодборРолей(РолиПользователя, СокрЛП(Объект.Код));
	
КонецПроцедуры //

// Функция вызывается при выполнении команд из подменю "Долнительные сведения"
//
&НаКлиенте
Функция ЗаписатьПользователяПриМодифицированности()
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если НЕ Объект.Ссылка.Пустая() И НЕ Модифицированность Тогда
		Возврат Истина;
	КонецЕсли;
	
	ТекстВопроса = "Для выполнения данной операции необходимо записать пользователя. Записать?";
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	УспешноЗаписан = Ложь;
	Попытка
		
		УспешноЗаписан = Записать();
		
	Исключение
		
	КонецПопытки;
	
	Возврат УспешноЗаписан;
	
	#КонецЕсли

	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСписокРолейПрофиля(Профиль)
	
	Если Профиль.Пустая() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ПрофилиПолномочийПользователейСоставРолей.ИмяРоли КАК Имя,
	|	ПрофилиПолномочийПользователейСоставРолей.ПредставлениеРоли КАК Синоним
	|ИЗ
	|	Справочник.ПрофилиПолномочийПользователей.СоставРолей КАК ПрофилиПолномочийПользователейСоставРолей
	|ГДЕ
	|	ПрофилиПолномочийПользователейСоставРолей.Ссылка = &Ссылка";
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", Профиль);
	
	КоллекцияРолей = Запрос.Выполнить().Выгрузить();
	
	Возврат КоллекцияРолей;
	
КонецФункции // 

&НаКлиенте
Процедура УстановитьДоступностьИзмененияРолей()

	Если Объект.ПрофильПолномочийПользователя.Пустая() Тогда
		Элементы.ИзменитьСоставРолей.Доступность = Истина;
		Элементы.РолиПользователя.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.ИзменитьСоставРолей.Доступность = Ложь;
		Элементы.РолиПользователя.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
КонецПроцедуры //
