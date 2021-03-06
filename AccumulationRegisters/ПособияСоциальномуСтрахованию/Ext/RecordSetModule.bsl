Перем мВыполнятьДополнительныеДвижения Экспорт;


Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;

	Если ЭтотОбъект.Количество() = 0 Или Не мВыполнятьДополнительныеДвижения Тогда
        Возврат;
    КонецЕсли;
	
	ДатаОтсечения = ОбменСведениямиОПособияхСФСС.ДатаПереходаНаПрямыеВыплаты();
	ЕстьСтрокиДоНаступленияПрямыхВыплат = Ложь;
	Для каждого СтрокаНабора Из ЭтотОбъект Цикл
		ЕстьСтрокиДоНаступленияПрямыхВыплат = СтрокаНабора.Период < ДатаОтсечения; 
	    Если ЕстьСтрокиДоНаступленияПрямыхВыплат Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если Не ЕстьСтрокиДоНаступленияПрямыхВыплат Тогда
        Возврат;
	КонецЕсли;
	
	Регистратор = Отбор.Регистратор.Значение;
	МетаданныеРегистратора = Регистратор.Метаданные();
	Если МетаданныеРегистратора.Движения.Содержит(Метаданные.РегистрыНакопления.РасчетыПоСтраховымВзносам) Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистратор", Регистратор);
		Запрос.УстановитьПараметр("ДатаОтсечения", ДатаОтсечения);
		Запрос.УстановитьПараметр("ДатаНачала",	 ПроведениеРасчетов.ДатаЗаменыЕСНСтраховымиВзносами());
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Пособия.Регистратор,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	Пособия.Период,
		|	Пособия.Организация КАК Организация,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыПлатежейВГосБюджет.РасходыПоСтрахованию) КАК ВидПлатежа,
		|	НАЧАЛОПЕРИОДА(Пособия.Период, МЕСЯЦ) КАК МесяцРасчетногоПериода,
		|	СУММА(ВЫБОР
		|			КОГДА НЕ Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев))
		|				ТОГДА Пособия.СуммаВсего
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФСС,
		|	СУММА(ВЫБОР
		|			КОГДА Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев))
		|				ТОГДА Пособия.СуммаВсего
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ФССНесчастныеСлучаи,
		|	Пособия.ОблагаетсяЕНВД
		|ИЗ
		|	РегистрНакопления.ПособияСоциальномуСтрахованию КАК Пособия
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаПоРасчетуЗарплатыОрганизацийИхПодразделений КАК УчетнаяПолитикаПоРасчетуЗарплатыОрганизацийИхПодразделений
		|		ПО Пособия.Организация = УчетнаяПолитикаПоРасчетуЗарплатыОрганизацийИхПодразделений.Организация
		|ГДЕ
		|	Пособия.Регистратор = &Регистратор
		|	И Пособия.ВидПособияСоциальногоСтрахования <> ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ПустаяСсылка)
		|	И Пособия.Период >= &ДатаНачала
		|	И ВЫБОР
		|			КОГДА Пособия.Период >= &ДатаОтсечения 
		|				ТОГДА ЛОЖЬ
		|			КОГДА УчетнаяПолитикаПоРасчетуЗарплатыОрганизацийИхПодразделений.ДатаПередачиФССВыплатыПособий ЕСТЬ NULL 
		|				ТОГДА ИСТИНА
		|			КОГДА УчетнаяПолитикаПоРасчетуЗарплатыОрганизацийИхПодразделений.ДатаПередачиФССВыплатыПособий = ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА ИСТИНА
		|			КОГДА УчетнаяПолитикаПоРасчетуЗарплатыОрганизацийИхПодразделений.ДатаПередачиФССВыплатыПособий > Пособия.Период
		|				ТОГДА ИСТИНА
		|			КОГДА Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.СтраховыеВзносыПоДопВыходнымПоУходуЗаДетьмиИнвалидами), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныеВыходныеДниПоУходуЗаДетьмиИнвалидами), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ВСвязиСоСмертью))
		|				ТОГДА ЛОЖЬ
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|СГРУППИРОВАТЬ ПО
		|	Пособия.Период,
		|	Пособия.Регистратор,
		|	Пособия.Организация,
		|	Пособия.ОблагаетсяЕНВД
		|
		|ИМЕЮЩИЕ
		|	(СУММА(ВЫБОР
		|				КОГДА НЕ Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев))
		|					ТОГДА Пособия.СуммаВсего
		|				ИНАЧЕ 0
		|			КОНЕЦ) <> 0
		|		ИЛИ СУММА(ВЫБОР
		|				КОГДА Пособия.ВидПособияСоциальногоСтрахования В (ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьНесчастныйСлучай), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.НетрудоспособностьПрофзаболевание), ЗНАЧЕНИЕ(Перечисление.ВидыПособийСоциальногоСтрахования.ДополнительныйОтпускПослеНесчастныхСлучаев))
		|					ТОГДА Пособия.СуммаВсего
		|				ИНАЧЕ 0
		|			КОНЕЦ) <> 0)";
		
		НаборЗаписейВторичногоРегистра = РегистрыНакопления.РасчетыПоСтраховымВзносам.СоздатьНаборЗаписей();
		НаборЗаписейВторичногоРегистра.Отбор.Регистратор.Установить(Регистратор);
		НаборЗаписейВторичногоРегистра.Загрузить(Запрос.Выполнить().Выгрузить());
		НаборЗаписейВторичногоРегистра.Записать(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

мВыполнятьДополнительныеДвижения = Ложь;