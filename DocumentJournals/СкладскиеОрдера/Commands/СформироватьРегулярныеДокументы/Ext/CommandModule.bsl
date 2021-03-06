&НаСервере
Функция ПолучитьСсылкуПоКлючуТекущейНастройки(КлючТекущейНастройки, КлючТекущегоВладельца)
	Возврат ХранилищаНастроек.НастройкиФормированияРегулярныхДокументов.ПолучитьСсылкуПоКлючуТекущейНастройки(КлючТекущейНастройки, КлючТекущегоВладельца);
КонецФункции
	
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ИмяФормы	= ПараметрыВыполненияКоманды.Источник.ИмяФормы;
	Элемент		= ПолучитьСсылкуПоКлючуТекущейНастройки(ПараметрыВыполненияКоманды.Источник.КлючТекущейНастройки, ИмяФормы).НастройкаСсылка;
	
	Если НЕ ЗначениеЗаполнено(Элемент) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрана настройка");
		Возврат;
	Иначе
		Ответ = Вопрос("Будет выполнено формирование регулярных документов на основании складских ордеров " + Символы.ПС
					 + "в соответствии с настройкой: """ + Строка(Элемент) + """" + Символы.ПС
					 + "После этого будет открыт список сформированных документов." + Символы.ПС
					 + "Продолжить?", РежимДиалогаВопрос.ДаНет,,
					 КодВозвратаДиалога.Нет, "Формирование регулярных документов");
					 
		Если Не Ответ = КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;		
	КонецЕсли;	
	
	ДатаФормированияДокументов = ТекущаяДата();
	
	ДатаНачалаФормированияДокументов = ПараметрыВыполненияКоманды.Источник.Элементы.Список.Период.ДатаНачала;
	Если ЗначениеЗаполнено(ПараметрыВыполненияКоманды.Источник.Элементы.Список.Период.ДатаОкончания) ТОгда
		ДатаОкончанияФормированияДокументов = ПараметрыВыполненияКоманды.Источник.Элементы.Список.Период.ДатаОкончания;
	Иначе
		ДатаОкончанияФормированияДокументов = ТекущаяДата();
	КонецЕсли;	
	
	Состояние("Выполняется формирование регулярных документов на основании складских ордеров");
	
	СтруктраДокументов = ФормированиеРегулярныхДокументов.СформироватьРегулярныеДокументы(Элемент,ДатаНачалаФормированияДокументов,ДатаОкончанияФормированияДокументов);
	
	СтрокаСообщения = "Формирование регулярных документов завершено";
	
	// Добавим 2 отбора в список ордеров. По умолчанию отборы не установлены
	
	
	// 1. По обработанным документам
	Если СтруктраДокументов.ОбработанныеДокументы.Количество() > 0 Тогда
		СтруктраПараметров = Новый Структура("МассивСсылок, Представление, Использование",СтруктраДокументов.ОбработанныеДокументы, "Обработанные документы " + Строка(ДатаФормированияДокументов), Ложь);
		РаботаСДиалогамиСервер.УстановитьОтборыВДинамическомСписке(ПараметрыВыполненияКоманды.Источник.Список, Новый Структура("ОтборПоСпискуСсылок", СтруктраПараметров));		
		СтрокаСообщения = СтрокаСообщения + Символы.ПС + "Обработано " + Строка(СтруктраДокументов.ОбработанныеДокументы.Количество()) + " ордеров";
	КонецЕсли;	
	
	// 2. По необработанным документам
	Если СтруктраДокументов.НеОбработанныеДокументы.Количество() > 0 Тогда
		СтруктраПараметров = Новый Структура("МассивСсылок, Представление, Использование",СтруктраДокументов.НеОбработанныеДокументы, "Не обработанные документы " + Строка(ДатаФормированияДокументов), Ложь);
		РаботаСДиалогамиСервер.УстановитьОтборыВДинамическомСписке(ПараметрыВыполненияКоманды.Источник.Список, Новый Структура("ОтборПоСпискуСсылок", СтруктраПараметров));		
		СтрокаСообщения = СтрокаСообщения + Символы.ПС + "Не удалось обработать " + Строка(СтруктраДокументов.НеОбработанныеДокументы.Количество()) + " ордеров";
	КонецЕсли;	
	
	// Откроем список регулярных документов
	Если СтруктраДокументов.СозданныеДокументы.Количество() > 0 Тогда
		Состояние(СтрокаСообщения + Символы.ПС + "Создано " + Строка(СтруктраДокументов.СозданныеДокументы.Количество()) + " регулярных документов");
		
		// В списке установим отбор по сформированным документам
		МассивСозданныхДокументов = Новый Массив();
		ПараметрыОткрытия = Новый Структура("ОтборПоСпискуСсылок, НепроведенныеДокументы", Новый Структура("МассивСсылок", СтруктраДокументов.СозданныеДокументы), СтруктраДокументов.НепроведенныеДокументы);
		
		ОткрытьФорму("ЖурналДокументов.РегулярныеДокументы.ФормаСписка", ПараметрыОткрытия, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	Иначе
		Состояние("Регулярные документы не созданы");
	КонецЕсли;	
	
КонецПроцедуры
