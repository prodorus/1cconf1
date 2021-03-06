Перем мУдалятьДвижения;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходимое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  НазваниеМакета - строка, название макета.
//
Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт

	Если ЭтоНовый() Тогда
		Предупреждение("Документ можно распечатать только после его записи");
		Возврат;
	ИначеЕсли Не УправлениеДопПравамиПользователей.РазрешитьПечатьНепроведенныхДокументов(Проведен) Тогда
		Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
		Возврат;
	КонецЕсли;

	Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ИмяМакета) = Тип("ДвоичныеДанные") Тогда

		ТабДокумент = УниверсальныеМеханизмы.НапечататьВнешнююФорму(Ссылка, ИмяМакета);
		
		Если ТабДокумент = Неопределено Тогда
			Возврат
		КонецЕсли; 
		
	КонецЕсли;

	УниверсальныеМеханизмы.НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, ОбщегоНазначения.СформироватьЗаголовокДокумента(ЭтотОбъект), Ссылка);

КонецПроцедуры // Печать

#КонецЕсли

// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	Возврат Новый Структура;

КонецФункции // ПолучитьСтруктуруПечатныхФорм()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Проверяет правильность заполнения шапки документа.
// Если какой-то из реквизитов шапки, влияющий на проведение не заполнен или
// заполнен не корректно, то выставляется флаг отказа в проведении.
// Проверяется также правильность заполнения реквизитов ссылочных полей документа.
// Проверка выполняется по объекту и по выборке из результата запроса по шапке.
//
// Параметры: 
//  СтруктураШапкиДокумента - выборка из результата запроса по шапке документа,
//  Отказ                   - флаг отказа в проведении,
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
//
Процедура ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("Организация");
    Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		СтруктураОбязательныхПолей.Вставить("СпособОтраженияРасходовБУ");
	КонецЕсли; 
	
    Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда
		СтруктураОбязательныхПолей.Вставить("СпособОтраженияРасходовНУ");
	КонецЕсли; 
	
	// Документ должен принадлежать хотя бы к одному виду учета (управленческий, бухгалтерский, налоговый)
	ОбщегоНазначения.ПроверитьПринадлежностьКВидамУчета(СтруктураШапкиДокумента, Отказ, Заголовок, Истина);
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);

КонецПроцедуры // ПроверитьЗаполнениеШапки()

// Проверяет правильность заполнения строк табличной части "НМА".
//
Процедура ПроверитьЗаполнениеТабличнойЧастиНМА(Отказ, Заголовок)

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = Новый Структура("НематериальныйАктив");
	
	// Теперь вызовем общую процедуру проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураОбязательныхПолей, Отказ, Заголовок);

	//Проверка дублирования строк
	ПроверкаНМА = НМА.Выгрузить();
	ПроверкаНМА.Свернуть("НематериальныйАктив");
	Если ПроверкаНМА.Количество() < НМА.Количество() тогда
		ОбщегоНазначения.СообщитьОбОшибке("Обнаружены повторяющиеся объекты нематериальных активов.",Отказ,Заголовок);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеТабличнойЧастиТовары()


// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоНМА)

	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента,ТаблицаПоНМА)
	
КонецПроцедуры // ДвиженияПоРегистрам

Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента,ТаблицаПоНМА)

	ДатаДока       = СтруктураШапкиДокумента.Дата;
	ТекОрганизация = СтруктураШапкиДокумента.Организация;

	Если СтруктураШапкиДокумента.ОтражатьВБухгалтерскомУчете Тогда
		
		НаправленияНМА = Движения.СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет;
	
		Для каждого СтрокаТЧ Из ТаблицаПоНМА Цикл

			Движение = НаправленияНМА.Добавить();
			Движение.Период           = ДатаДока;
			Движение.Организация      = ТекОрганизация;
			Движение.НематериальныйАктив = СтрокаТЧ.НематериальныйАктив;
			Движение.СпособОтраженияРасходов = СтруктураШапкиДокумента.СпособОтраженияРасходовБУ;

		КонецЦикла;
	КонецЕсли;
	
	Если СтруктураШапкиДокумента.ОтражатьВНалоговомУчете Тогда

		НаправленияНМА = Движения.СпособыОтраженияРасходовПоАмортизацииНМАНалоговыйУчет;

		Для каждого СтрокаТЧ Из ТаблицаПоНМА Цикл

			Движение = НаправленияНМА.Добавить();

			Движение.Период           = ДатаДока;
			Движение.Организация      = ТекОрганизация;
			Движение.НематериальныйАктив = СтрокаТЧ.НематериальныйАктив;
			Движение.СпособОтраженияРасходов = СтруктураШапкиДокумента.СпособОтраженияРасходовНУ;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ)

	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);

	ПроверитьЗаполнениеШапки(СтруктураШапкиДокумента, Отказ, Заголовок);
	ПроверитьЗаполнениеТабличнойЧастиНМА(Отказ, Заголовок);
	СтруктураПолей = Новый Структура("НематериальныйАктив", "НематериальныйАктив");

	РезультатЗапросаПоНМА = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураПолей);
	ТаблицаПоНМА          = РезультатЗапросаПоНМА.Выгрузить();
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоНМА);
	КонецЕсли;

КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	 
	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью




