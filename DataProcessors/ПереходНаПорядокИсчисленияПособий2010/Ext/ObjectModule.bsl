
Функция СформироватьЗапросДляЗаполненияКадровыхДанных() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка КАК Физлицо,
	|	ЛОЖЬ КАК РасширенныйСтраховойСтажДляБЛ,
	|	ИСТИНА КАК ИмеющиеЛьготыПриНачисленииПособий
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	(НЕ ФизическиеЛица.ЛьготаПриНачисленииПособий = ЗНАЧЕНИЕ(Перечисление.ВидыЛьготПриНачисленииБольничных.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ФизическиеЛицаСтажи.Ссылка,
	|	ИСТИНА,
	|	ЛОЖЬ
	|ИЗ
	|	Справочник.ФизическиеЛица.Стажи КАК ФизическиеЛицаСтажи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СотрудникиОрганизаций КАК СотрудникиОрганизаций
	|		ПО ФизическиеЛицаСтажи.Ссылка = СотрудникиОрганизаций.Физлицо
	|			И (СотрудникиОрганизаций.ДатаПриемаНаРаботу >= ДАТАВРЕМЯ(2007, 1, 1))
	|			И (СотрудникиОрганизаций.ДатаУвольнения = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|ГДЕ
	|	ФизическиеЛицаСтажи.ВидСтажа = ЗНАЧЕНИЕ(Справочник.ВидыСтажа.РасширенныйСтраховойСтажДляБЛ)";	
	
	Возврат Запрос.Выполнить();
	
КонецФункции 

Функция СформироватьЗапросДляЗаполненияРасчетныхДанных() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НачислениеПоБольничномуЛисту.ПерерассчитываемыйДокумент КАК ПерерассчитываемыйДокумент,
	|	ГОД(НачислениеПоБольничномуЛисту.ПериодРегистрации) КАК ГодРегистрации
	|ПОМЕСТИТЬ ИсправленияБольничных
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту КАК НачислениеПоБольничномуЛисту
	|ГДЕ
	|	ГОД(НачислениеПоБольничномуЛисту.ПериодРегистрации) >= 2009
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПерерассчитываемыйДокумент,
	|	ГодРегистрации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НачислениеПоБольничномуЛисту.Ссылка КАК РасчетныйДокумент,
	|	НачислениеПоБольничномуЛисту.Сотрудник,
	|	ВЫБОР
	|		КОГДА ИсправленияБольничныхВ2010.ПерерассчитываемыйДокумент ЕСТЬ NULL 
	|			ТОГДА ""Пересчитать""
	|		ИНАЧЕ ""Пересчет выполнен""
	|	КОНЕЦ КАК Действие,
	|	ВЫБОР
	|		КОГДА ИсправленияБольничныхВ2010.ПерерассчитываемыйДокумент ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Выполнено
	|ИЗ
	|	Документ.НачислениеПоБольничномуЛисту КАК НачислениеПоБольничномуЛисту
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсправленияБольничных КАК ИсправленияБольничныхВ2010
	|		ПО (ИсправленияБольничныхВ2010.ПерерассчитываемыйДокумент = НачислениеПоБольничномуЛисту.Ссылка)
	|			И (ИсправленияБольничныхВ2010.ГодРегистрации = 2010)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсправленияБольничных КАК ИсправленияБольничныхВ2009
	|		ПО (ИсправленияБольничныхВ2009.ПерерассчитываемыйДокумент = НачислениеПоБольничномуЛисту.Ссылка)
	|			И (ИсправленияБольничныхВ2009.ГодРегистрации = 2009)
	|ГДЕ
	|	НачислениеПоБольничномуЛисту.ПричинаНетрудоспособности = ЗНАЧЕНИЕ(Перечисление.ПричиныНетрудоспособности.ПоБеременностиИРодам)
	|	И НачислениеПоБольничномуЛисту.Проведен
	|	И ГОД(НачислениеПоБольничномуЛисту.ПериодРегистрации) = 2009
	|	И ГОД(НачислениеПоБольничномуЛисту.ДатаОкончания) = 2010
	|	И ИсправленияБольничныхВ2009.ПерерассчитываемыйДокумент ЕСТЬ NULL 
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтпускПоУходуЗаРебенком.ИсправляемыйДокумент КАК ИсправляемыйДокумент,
	|	ГОД(ОтпускПоУходуЗаРебенком.Дата) КАК ГодИсправления
	|ПОМЕСТИТЬ ИсправленияОтпусков
	|ИЗ
	|	Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
	|ГДЕ
	|	ГОД(ОтпускПоУходуЗаРебенком.Дата) >= 2009
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ИсправляемыйДокумент,
	|	ГодИсправления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтпускПоУходуЗаРебенком.Ссылка КАК РасчетныйДокумент,
	|	ОтпускПоУходуЗаРебенком.Сотрудник,
	|	ВЫБОР
	|		КОГДА ИсправленияОтпусковВ2010.ИсправляемыйДокумент ЕСТЬ NULL 
	|			ТОГДА ""Исправить""
	|		ИНАЧЕ ""Исправление выполнено""
	|	КОНЕЦ КАК Действие,
	|	ВЫБОР
	|		КОГДА ИсправленияОтпусковВ2010.ИсправляемыйДокумент ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Выполнено
	|ИЗ
	|	Документ.ОтпускПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсправленияОтпусков КАК ИсправленияОтпусковВ2009
	|		ПО ОтпускПоУходуЗаРебенком.Ссылка = ИсправленияОтпусковВ2009.ИсправляемыйДокумент
	|			И (ИсправленияОтпусковВ2009.ГодИсправления = 2009)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсправленияОтпусков КАК ИсправленияОтпусковВ2010
	|		ПО ОтпускПоУходуЗаРебенком.Ссылка = ИсправленияОтпусковВ2010.ИсправляемыйДокумент
	|			И (ИсправленияОтпусковВ2010.ГодИсправления = 2010)
	|ГДЕ
	|	ОтпускПоУходуЗаРебенком.Проведен
	|	И ГОД(ОтпускПоУходуЗаРебенком.ДатаНачала) = 2009
	|	И ГОД(ОтпускПоУходуЗаРебенком.ДатаОкончания) = 2010
	|	И ИсправленияОтпусковВ2009.ИсправляемыйДокумент ЕСТЬ NULL ";
	
	Возврат Запрос.ВыполнитьПакет();
	
КонецФункции