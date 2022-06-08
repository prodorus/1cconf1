﻿
Процедура ДобавитьОбъединенияВЗапросПолученияДействийСНачислениями(ТекстЗапроса, ПолеПодразделение, ПолеДолжность) Экспорт
		
	ТекстЗапроса = ТекстЗапроса + "
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ДанныеСотрудников.Сотрудник,
	|	СхемыМотивацииРаботников.ВидРасчета,
	|	СхемыМотивацииРаботников.Показатель1,
	|	СхемыМотивацииРаботников.Показатель2,
	|	СхемыМотивацииРаботников.Показатель3,
	|	СхемыМотивацииРаботников.Показатель4,
	|	СхемыМотивацииРаботников.Показатель5,
	|	СхемыМотивацииРаботников.Показатель6,
	|	СхемыМотивацииРаботников.Валюта1,
	|	СхемыМотивацииРаботников.Валюта2,
	|	СхемыМотивацииРаботников.Валюта3,
	|	СхемыМотивацииРаботников.Валюта4,
	|	СхемыМотивацииРаботников.Валюта5,
	|	СхемыМотивацииРаботников.Валюта6,
	|	ДанныеСотрудников.ДатаДействия,
	|	СхемыМотивацииРаботников.ТарифныйРазряд1,
	|	СхемыМотивацииРаботников.ТарифныйРазряд2,
	|	СхемыМотивацииРаботников.ТарифныйРазряд3,
	|	СхемыМотивацииРаботников.ТарифныйРазряд4,
	|	СхемыМотивацииРаботников.ТарифныйРазряд5,
	|	СхемыМотивацииРаботников.ТарифныйРазряд6
	|ИЗ
	|	ДанныеСотрудников КАК ДанныеСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СхемыМотивацииРаботников КАК СхемыМотивацииРаботников
	|		ПО ДанныеСотрудников." + ПолеПодразделение + " = СхемыМотивацииРаботников.Подразделение
	|			И ДанныеСотрудников." + ПолеДолжность + " = СхемыМотивацииРаботников.Должность
	|			И ДанныеСотрудников.Организация = СхемыМотивацииРаботников.Организация
	|";

КонецПроцедуры

Процедура ДобавитьТаблицыВЗапросПолученияДействийСУправленческимиНачислениями(ТекстЗапроса) Экспорт
		
	ТекстЗапроса = ТекстЗапроса +  "
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ДанныеСотрудников.Физлицо КАК Физлицо,
	|	СхемыМотивацииРаботников.ВидРасчета КАК ВидРасчета,
	|	СхемыМотивацииРаботников.Показатель1,
	|	СхемыМотивацииРаботников.Показатель2,
	|	СхемыМотивацииРаботников.Показатель3,
	|	СхемыМотивацииРаботников.Показатель4,
	|	СхемыМотивацииРаботников.Показатель5,
	|	СхемыМотивацииРаботников.Показатель6,
	|	СхемыМотивацииРаботников.Валюта1,
	|	СхемыМотивацииРаботников.Валюта2,
	|	СхемыМотивацииРаботников.Валюта3,
	|	СхемыМотивацииРаботников.Валюта4,
	|	СхемыМотивацииРаботников.Валюта5,
	|	СхемыМотивацииРаботников.Валюта6,
	|	ДанныеСотрудников.ДатаДействия,
	|	СхемыМотивацииРаботников.ТарифныйРазряд1,
	|	СхемыМотивацииРаботников.ТарифныйРазряд2,
	|	СхемыМотивацииРаботников.ТарифныйРазряд3,
	|	СхемыМотивацииРаботников.ТарифныйРазряд4,
	|	СхемыМотивацииРаботников.ТарифныйРазряд5,
	|	СхемыМотивацииРаботников.ТарифныйРазряд6
	|ПОМЕСТИТЬ НачисленияСтаройПозицииСрезПоследних
	|ИЗ
	|	ДанныеСотрудников КАК ДанныеСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СхемыМотивацииРаботников КАК СхемыМотивацииРаботников
	|		ПО (СхемыМотивацииРаботников.ВидРасчета ССЫЛКА ПланВидовРасчета.УправленческиеНачисления
	|				ИЛИ СхемыМотивацииРаботников.ВидРасчета ССЫЛКА ПланВидовРасчета.УправленческиеУдержания)
	|			И (СхемыМотивацииРаботников.ВидСхемыМотивации = ЗНАЧЕНИЕ(Справочник.ВариантыCхемМотивации.ПустаяСсылка))
	|			И (ВЫБОР
	|				КОГДА СхемыМотивацииРаботников.Подразделение = НЕОПРЕДЕЛЕНО
	|					ТОГДА ДанныеСотрудников.СтараяДолжность = СхемыМотивацииРаботников.Должность
	|				ИНАЧЕ ДанныеСотрудников.СтароеПодразделение = СхемыМотивацииРаботников.Подразделение
	|						И ДанныеСотрудников.СтараяДолжность = СхемыМотивацииРаботников.Должность
	|			КОНЕЦ)
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеСотрудников.Сотрудник КАК Сотрудник,
	|	ДанныеСотрудников.Физлицо КАК Физлицо,
	|	СхемыМотивацииРаботников.ВидРасчета КАК ВидРасчета,
	|	СхемыМотивацииРаботников.Показатель1,
	|	СхемыМотивацииРаботников.Показатель2,
	|	СхемыМотивацииРаботников.Показатель3,
	|	СхемыМотивацииРаботников.Показатель4,
	|	СхемыМотивацииРаботников.Показатель5,
	|	СхемыМотивацииРаботников.Показатель6,
	|	СхемыМотивацииРаботников.Валюта1,
	|	СхемыМотивацииРаботников.Валюта2,
	|	СхемыМотивацииРаботников.Валюта3,
	|	СхемыМотивацииРаботников.Валюта4,
	|	СхемыМотивацииРаботников.Валюта5,
	|	СхемыМотивацииРаботников.Валюта6,
	|	ДанныеСотрудников.ДатаДействия,
	|	СхемыМотивацииРаботников.ТарифныйРазряд1,
	|	СхемыМотивацииРаботников.ТарифныйРазряд2,
	|	СхемыМотивацииРаботников.ТарифныйРазряд3,
	|	СхемыМотивацииРаботников.ТарифныйРазряд4,
	|	СхемыМотивацииРаботников.ТарифныйРазряд5,
	|	СхемыМотивацииРаботников.ТарифныйРазряд6
	|ПОМЕСТИТЬ НачисленияНовойПозицииСрезПоследних
	|ИЗ
	|	ДанныеСотрудников КАК ДанныеСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СхемыМотивацииРаботников КАК СхемыМотивацииРаботников
	|		ПО (СхемыМотивацииРаботников.ВидРасчета ССЫЛКА ПланВидовРасчета.УправленческиеНачисления
	|				ИЛИ СхемыМотивацииРаботников.ВидРасчета ССЫЛКА ПланВидовРасчета.УправленческиеУдержания)
	|			И (СхемыМотивацииРаботников.ВидСхемыМотивации = ЗНАЧЕНИЕ(Справочник.ВариантыCхемМотивации.ПустаяСсылка))
	|			И (ВЫБОР
	|				КОГДА СхемыМотивацииРаботников.Подразделение = НЕОПРЕДЕЛЕНО
	|					ТОГДА ДанныеСотрудников.Должность = СхемыМотивацииРаботников.Должность
	|				ИНАЧЕ ДанныеСотрудников.Подразделение = СхемыМотивацииРаботников.Подразделение
	|						И ДанныеСотрудников.Должность = СхемыМотивацииРаботников.Должность
	|			КОНЕЦ)
	|
	|;
	|";
	
КонецПроцедуры

Функция ВалютаПоказателяИмяПоляЗапроса() Экспорт
	
	// В этой конфигурации не переопределяется
	
	Возврат "";
	
КонецФункции
