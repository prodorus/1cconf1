
// Проверяет уникальность кадровых номеров
//
// Параметры: 
//	Организация - нет
//  СообщатьОбОшибке - булево, определяет необходимость сообщения об ошибке при выполнении функции
//  СообщениеОбОшибке - сюда помещается текст сообщения об ошибке
//
// Возвращаемое значение:
//  Истина	- если номера уникальные
//	Ложь	- если номера не уникальные
Функция НомераКадровыхДокументовУникальны(Организация, СообщатьОбОшибке = Истина, СообщениеОбОшибке = "") Экспорт
	
	Отказ = Ложь;
	ЗаголовокСообщения = "Включить единый кадровый нумератор невозможно, т.к. следующие номера используются в нескольких кадровых документах: ";
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыОрганизации.Номер
	|ИЗ
	|	(ВЫБРАТЬ
	|		ГОД(КадровоеПеремещениеОрганизаций.Дата) КАК Год,
	|		КадровоеПеремещениеОрганизаций.Номер КАК Номер,
	|		КадровоеПеремещениеОрганизаций.Ссылка КАК Ссылка
	|	ИЗ
	|		Документ.КадровоеПеремещениеОрганизаций КАК КадровоеПеремещениеОрганизаций
	|	ГДЕ
	|		КадровоеПеремещениеОрганизаций.Организация = &Организация
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ГОД(ПриемНаРаботуВОрганизацию.Дата),
	|		ПриемНаРаботуВОрганизацию.Номер,
	|		ПриемНаРаботуВОрганизацию.Ссылка
	|	ИЗ
	|		Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
	|	ГДЕ
	|		ПриемНаРаботуВОрганизацию.Организация = &Организация
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ГОД(УвольнениеИзОрганизаций.Дата),
	|		УвольнениеИзОрганизаций.Номер,
	|		УвольнениеИзОрганизаций.Ссылка
	|	ИЗ
	|		Документ.УвольнениеИзОрганизаций КАК УвольнениеИзОрганизаций
	|	ГДЕ
	|		УвольнениеИзОрганизаций.Организация = &Организация) КАК ДокументыОрганизации
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ГОД(КадровоеПеремещениеОрганизаций.Дата) КАК Год,
	|			КадровоеПеремещениеОрганизаций.Номер КАК Номер,
	|			КадровоеПеремещениеОрганизаций.Ссылка КАК Ссылка
	|		ИЗ
	|			Документ.КадровоеПеремещениеОрганизаций КАК КадровоеПеремещениеОрганизаций
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ГОД(ПриемНаРаботуВОрганизацию.Дата),
	|			ПриемНаРаботуВОрганизацию.Номер,
	|			ПриемНаРаботуВОрганизацию.Ссылка
	|		ИЗ
	|			Документ.ПриемНаРаботуВОрганизацию КАК ПриемНаРаботуВОрганизацию
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ГОД(УвольнениеИзОрганизаций.Дата),
	|			УвольнениеИзОрганизаций.Номер,
	|			УвольнениеИзОрганизаций.Ссылка
	|		ИЗ
	|			Документ.УвольнениеИзОрганизаций КАК УвольнениеИзОрганизаций) КАК ВсеКадровыеДокументы
	|		ПО ДокументыОрганизации.Год = ВсеКадровыеДокументы.Год
	|			И ДокументыОрганизации.Номер = ВсеКадровыеДокументы.Номер
	|			И ДокументыОрганизации.Ссылка <> ВсеКадровыеДокументы.Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация",Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если СообщатьОбОшибке Тогда
			ОбщегоНазначенияЗК.СообщитьОбОшибке(Выборка.Номер,Отказ,ЗаголовокСообщения);
		Иначе
			Отказ = Истина;
			Если ПустаяСтрока(СообщениеОбОшибке) Тогда
				СообщениеОбОшибке = ЗаголовокСообщения + Выборка.Номер;
			Иначе
				СообщениеОбОшибке = СообщениеОбОшибке + ", " + Выборка.Номер;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	СообщениеОбОшибке = СообщениеОбОшибке + ".";
	
	Возврат Не Отказ;
	
КонецФункции //НомераКадровыхДокументовУникальны()

// Процедура производит синхронирзацию наименований сотрудников
Процедура СинхронизироватьНаименованияСотрудников(Физлицо, Сотрудник = Неопределено) Экспорт
	
	Если Сотрудник = Неопределено Тогда
		Сотрудник = Справочники.СотрудникиОрганизаций.ПустаяСсылка();
	КонецЕсли; 

	Запрос = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СотрудникиОрганизаций.Наименование,
	|	СотрудникиОрганизаций.ПостфиксНаименования,
	|	СотрудникиОрганизаций.Ссылка
	|ИЗ
	|	Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|ГДЕ
	|	СотрудникиОрганизаций.Физлицо = &парамФизлицо";	
	
	Запрос.УстановитьПараметр("парамФизлицо", Физлицо);
	Запрос.Текст = ТекстЗапроса;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Ссылка = Сотрудник Тогда
			// не обрабатываем сотрудника, из которого вызвана синхронизация
			Продолжить;
		КонецЕсли; 
		
		НовоеНаименование = Физлицо.Наименование + ?(ЗначениеЗаполнено(Выборка.ПостфиксНаименования), " " + Выборка.ПостфиксНаименования, "");
		Если Выборка.Наименование <> НовоеНаименование Тогда
			СотрудникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			Попытка	
				СотрудникОбъект.Заблокировать();
			Исключение
				Продолжить;
			КонецПопытки;
			СотрудникОбъект.Наименование = НовоеНаименование;
			СотрудникОбъект.ОбменДанными.Загрузка = Истина;
			СотрудникОбъект.Записать();
			СотрудникОбъект.Разблокировать();
		КонецЕсли;
		
	КонецЦикла; 

КонецПроцедуры
