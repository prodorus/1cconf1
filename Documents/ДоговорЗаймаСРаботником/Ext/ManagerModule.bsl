﻿
Функция ПолучитьСтруктуруДляПечати(ДоговорЗайма) Экспорт

	СтруктураДляПечати = ОбщегоНазначенияЗК.ПолучитьЗначенияРеквизитов(ДоговорЗайма, "Организация,ФизЛицо,Дата,Номер,ПроцентЗаПользованиеЗаймом," +
	"НачалоПогашения,СрокПогашения,ПорядокПогашенияЗайма,ВалютаДокумента,СуммаЗайма,ОтражатьВУправленческомУчете");
	
	Возврат СтруктураДляПечати;

КонецФункции // ПолучитьСтруктуруДляПечати()

