Функция ПолучитьИтогиЗаПериодКнигаПродаж(СтруктураПараметров) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДополнительныйЛистКнигиПродаж.ВсегоПродаж,
	|	ДополнительныйЛистКнигиПродаж.СуммаБезНДС18,
	|	ДополнительныйЛистКнигиПродаж.НДС18,
	|	ДополнительныйЛистКнигиПродаж.СуммаБезНДС10,
	|	ДополнительныйЛистКнигиПродаж.НДС10,
	|	ДополнительныйЛистКнигиПродаж.НДС0,
	|	ДополнительныйЛистКнигиПродаж.СуммаБезНДС20,
	|	ДополнительныйЛистКнигиПродаж.НДС20,
	|	ДополнительныйЛистКнигиПродаж.СуммаСовсемБезНДС,
	|	ДополнительныйЛистКнигиПродаж.Дата КАК Дата,
	|	ДополнительныйЛистКнигиПродаж.Ссылка
	|ПОМЕСТИТЬ ПоследнийДополнительныйЛист
	|ИЗ
	|	Документ.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде КАК ДополнительныйЛистКнигиПродаж
	|ГДЕ
	|	ДополнительныйЛистКнигиПродаж.Организация = &Организация
	|	И ДополнительныйЛистКнигиПродаж.НалоговыйПериод = &НалоговыйПериод
	|	И ДополнительныйЛистКнигиПродаж.Дата < &Дата
	|	И ДополнительныйЛистКнигиПродаж.Ссылка <> &ТекущийДокумент
	|	И ДополнительныйЛистКнигиПродаж.Проведен
	|	И НЕ ДополнительныйЛистКнигиПродаж.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПродаж.ВсегоПродаж,
	|	КнигаПродаж.СуммаБезНДС18,
	|	КнигаПродаж.НДС18,
	|	КнигаПродаж.СуммаБезНДС10,
	|	КнигаПродаж.НДС10,
	|	КнигаПродаж.НДС0,
	|	КнигаПродаж.СуммаБезНДС20,
	|	КнигаПродаж.НДС20,
	|	КнигаПродаж.СуммаСовсемБезНДС,
	|	КнигаПродаж.Дата
	|ПОМЕСТИТЬ КнигаПродажЗаКорректируемыйПериод
	|ИЗ
	|	Документ.КнигаПродажДляПередачиВЭлектронномВиде КАК КнигаПродаж
	|ГДЕ
	|	КнигаПродаж.Организация = &Организация
	|	И КнигаПродаж.НалоговыйПериод = &НалоговыйПериод
	|	И КнигаПродаж.Проведен
	|	И НЕ КнигаПродаж.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследнийДополнительныйЛист.ВсегоПродаж КАК ВсегоПродаж,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС18,
	|	ПоследнийДополнительныйЛист.НДС18,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС10,
	|	ПоследнийДополнительныйЛист.НДС10,
	|	ПоследнийДополнительныйЛист.НДС0,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС20,
	|	ПоследнийДополнительныйЛист.НДС20,
	|	ПоследнийДополнительныйЛист.СуммаСовсемБезНДС,
	|	ПоследнийДополнительныйЛист.Дата КАК ДатаОформления,
	|	0 КАК НДС
	|ИЗ
	|	ПоследнийДополнительныйЛист КАК ПоследнийДополнительныйЛист
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПродажЗаКорректируемыйПериод.ВсегоПродаж,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаБезНДС18,
	|	КнигаПродажЗаКорректируемыйПериод.НДС18,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаБезНДС10,
	|	КнигаПродажЗаКорректируемыйПериод.НДС10,
	|	КнигаПродажЗаКорректируемыйПериод.НДС0,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаБезНДС20,
	|	КнигаПродажЗаКорректируемыйПериод.НДС20,
	|	КнигаПродажЗаКорректируемыйПериод.СуммаСовсемБезНДС,
	|	КнигаПродажЗаКорректируемыйПериод.Дата,
	|	0
	|ИЗ
	|	КнигаПродажЗаКорректируемыйПериод КАК КнигаПродажЗаКорректируемыйПериод";
			 
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("НалоговыйПериод", СтруктураПараметров.НалоговыйПериод);
	Запрос.УстановитьПараметр("Дата", СтруктураПараметров.ДатаФормированияДопЛиста);
	Запрос.УстановитьПараметр("ТекущийДокумент", СтруктураПараметров.Ссылка);
	
	ИтогЗаПериод = Запрос.Выполнить();
	
	Если НЕ ИтогЗаПериод.Пустой() Тогда
		
		Возврат ИтогЗаПериод.Выгрузить()[0];
		
	Иначе
		
		// Получим итоги по данным информационной базы
		Возврат Отчеты.КнигаПродаж1137.ПолучитьИтогиЗаПериодКнигаПродаж(СтруктураПараметров);
			
		
	КонецЕсли;
	
КонецФункции	