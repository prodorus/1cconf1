// Функция возвращает соответствие имени "подчиненного" бизнес-процесса
// точке "родительского" бизнес-процесса
// 
// Возвращаемое значение: соответствие, 
//  ключ     - точка маршрута,
//  значение - имя подчиненного бизнес-процесса
Функция ПодчиненныеБизнесПроцессы() Экспорт
	
	Соответствие = Новый Соответствие();
	Соответствие.Вставить(БизнесПроцессы.ЗакрытиеМесяца.ТочкиМаршрута.РассчитатьНДС, "РасчетНДС");
	
	Возврат Соответствие;
	
КонецФункции
