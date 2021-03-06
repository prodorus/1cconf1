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

// Проверяет правильность заполнения строк табличной части "НМА".
//
// Параметры:
//  Отказ                   - флаг отказа в проведении.
//  Заголовок               - строка, заголовок сообщения об ошибке проведения.
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

// Выполняет движения по регистрам Регл
//
Процедура ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента,ТаблицаПоНМА)

	ДатаДок = Дата;
	
	Движение     = Движения.ВыработкаНМА;
	ТаблицаДвиженийБУ = Движение.Выгрузить();
	
	ТаблицаДвиженийБУ.Очистить();

	ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(ТаблицаПоНМА, ТаблицаДвиженийБУ);
	
	Движение.мПериод          = ДатаДок;
	Движение.мТаблицаДвижений = ТаблицаДвиженийБУ;

	Движение.ДобавитьДвижение();

КонецПроцедуры // ДвиженияПоРегистрамРегл

// Выполняет движения по регистрам 
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоНМА);
	
	ДвиженияПоРегистрамРегл(СтруктураШапкиДокумента,ТаблицаПоНМА);
	
КонецПроцедуры // ДвиженияПоРегистрам


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ


Процедура ОбработкаПроведения(Отказ)

	
	Если мУдалятьДвижения Тогда
		ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ);
	КонецЕсли;

	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);

	// Сформируем структуру реквизитов шапки документа
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("НематериальныйАктив", "НематериальныйАктив");
	СтруктураПолей.Вставить("Количество",       	"Количество");

	РезультатЗапросаПоНМА = УправлениеЗапасами.СформироватьЗапросПоТабличнойЧасти(ЭтотОбъект, "НМА", СтруктураПолей);
	ТаблицаПоНМА          = РезультатЗапросаПоНМА.Выгрузить();

	ПроверитьЗаполнениеТабличнойЧастиНМА(Отказ, Заголовок);
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,ТаблицаПоНМА);
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;


	мУдалятьДвижения = НЕ ЭтоНовый();
	
КонецПроцедуры // ПередЗаписью



