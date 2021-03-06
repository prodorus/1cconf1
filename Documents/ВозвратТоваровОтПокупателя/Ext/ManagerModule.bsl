
Функция ТекстЗапросаТоварныеПозицииЧека() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВозвратТоваровОтПокупателяТовары.ЕдиницаИзмерения,
	|	ВозвратТоваровОтПокупателяТовары.Номенклатура,
	|	ВозвратТоваровОтПокупателяТовары.ХарактеристикаНоменклатуры КАК Характеристика,
	|	ВозвратТоваровОтПокупателяТовары.СерияНоменклатуры КАК Серия,
	|	ВозвратТоваровОтПокупателяТовары.Количество,
	|	ВозвратТоваровОтПокупателяТовары.Коэффициент,
	|	ВозвратТоваровОтПокупателяТовары.СтавкаНДС,
	|	ВЫБОР
	|		КОГДА ВозвратТоваровОтПокупателяТовары.Ссылка.СуммаВключаетНДС
	|			ТОГДА ВозвратТоваровОтПокупателяТовары.Сумма
	|		ИНАЧЕ ВозвратТоваровОтПокупателяТовары.Сумма + ВозвратТоваровОтПокупателяТовары.СуммаНДС
	|	КОНЕЦ КАК Сумма,
	|	ВозвратТоваровОтПокупателяТовары.СуммаНДС,
	|	ВЫБОР
	|		КОГДА ВозвратТоваровОтПокупателяТовары.Ссылка.СуммаВключаетНДС
	|			ТОГДА ВозвратТоваровОтПокупателяТовары.Цена
	|		ИНАЧЕ ВозвратТоваровОтПокупателяТовары.Цена + ВозвратТоваровОтПокупателяТовары.СуммаНДС / ВозвратТоваровОтПокупателяТовары.Количество
	|	КОНЕЦ КАК Цена,
	|	ВозвратТоваровОтПокупателяТовары.Номенклатура.Наименование КАК Наименование,
	|	ВЫБОР
	|		КОГДА ВозвратТоваровОтПокупателяТовары.Склад <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА ВозвратТоваровОтПокупателяТовары.Склад.НомерСекции
	|		КОГДА ТИПЗНАЧЕНИЯ(ВозвратТоваровОтПокупателяТовары.Ссылка.СкладОрдер) = ТИП(Справочник.Склады)
	|				И ВозвратТоваровОтПокупателяТовары.Ссылка.СкладОрдер <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ТОГДА ВозвратТоваровОтПокупателяТовары.Ссылка.СкладОрдер.НомерСекции
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НомерСекции
	|ИЗ
	|	Документ.ВозвратТоваровОтПокупателя.Товары КАК ВозвратТоваровОтПокупателяТовары
	|ГДЕ
	|	ВозвратТоваровОтПокупателяТовары.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции
