
Процедура ПеренестиДатыПроизводственногоКалендаря(ТаблицаРегистра, СтрокаНабораЗаписей) Экспорт
		
	Суббота		= Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота;
	Воскресенье	= Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье;

	СтрокаТаблицыВыходного	= ТаблицаРегистра.Найти(СтрокаНабораЗаписей.ВыходнойДень, "ДатаКалендаря");
	СтрокаТаблицыРабочего	= ТаблицаРегистра.Найти(СтрокаНабораЗаписей.РабочийДень, "ДатаКалендаря");
	
	Если СтрокаТаблицыВыходного = Неопределено Или СтрокаТаблицыРабочего = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ДеньНеделиВыходного	= ДеньНедели(СтрокаНабораЗаписей.ВыходнойДень);
	ДеньНеделиРабочего	= ДеньНедели(СтрокаНабораЗаписей.РабочийДень);
	
	Если ДеньНеделиВыходного = 6 Или ДеньНеделиВыходного = 7 Тогда
		
		Если СтрокаТаблицыВыходного.ВидДня = Суббота Или СтрокаТаблицыВыходного.ВидДня = Воскресенье Тогда
			// на субботы и воскресения (не праздники) переносим рабочие, предпраздничные дни
			СтрокаТаблицыВыходного.ВидДня = СтрокаТаблицыРабочего.ВидДня;
		КонецЕсли;
		
		Если ДеньНеделиВыходного = 6 Тогда
			СтрокаТаблицыРабочего.ВидДня = Суббота;
		Иначе
			СтрокаТаблицыРабочего.ВидДня = Воскресенье
		КонецЕсли;
			
	ИначеЕсли ДеньНеделиРабочего = 6 Или ДеньНеделиРабочего = 7 Тогда
		
		Если СтрокаТаблицыРабочего.ВидДня = Суббота Или СтрокаТаблицыРабочего.ВидДня = Воскресенье Тогда
			// на субботы и воскресения (не праздники) переносим рабочие, предпраздничные дни
			СтрокаТаблицыРабочего.ВидДня = СтрокаТаблицыВыходного.ВидДня;
		КонецЕсли;
		
		Если ДеньНеделиРабочего = 6 Тогда
			СтрокаТаблицыВыходного.ВидДня = Суббота;
		Иначе
			СтрокаТаблицыВыходного.ВидДня = Воскресенье
		КонецЕсли;
		
	Иначе
		
		ВременнаяПеременная = СтрокаТаблицыРабочего.ВидДня;
		СтрокаТаблицыРабочего.ВидДня = СтрокаТаблицыВыходного.ВидДня;
		СтрокаТаблицыВыходного.ВидДня = ВременнаяПеременная;
		
	КонецЕсли;
	
КонецПроцедуры	

Функция ПраздничныеДниДляПереноса(КалендарныйГод)
	
	СписокПраздников = РегламентированнаяОтчетность.ПолучитьСписокПраздниковРФ(КалендарныйГод);
	ПервоеЯнваря = НачалоГода(Дата(Формат(КалендарныйГод,"ЧГ=0")+"0101"));
	СписокПраздниковВВыходные = Новый СписокЗначений;
	Для НомерДня = 1 По ДеньГода(КонецГода(ПервоеЯнваря)) Цикл
		ЗаписываемаяДата = НачалоДня(ПервоеЯнваря + 86400 * (НомерДня - 1));
		ПраздничныйДень = СписокПраздников.НайтиПоЗначению("" + Формат(ЗаписываемаяДата, "ДФ = 'ММ'") + Формат(ЗаписываемаяДата, "ДФ = 'дд'"));
		Если ПраздничныйДень <> Неопределено И ДеньНедели(ЗаписываемаяДата) > 5 Тогда
			СписокПраздниковВВыходные.Добавить(ЗаписываемаяДата, ПраздничныйДень);
		КонецЕсли; 
	КонецЦикла;
	
	Возврат СписокПраздниковВВыходные

КонецФункции 


Процедура ЗаполнитьПереченьПеренесенныхДней(КалендарныйГод, ПеренесенныеРабочиеДни) Экспорт

	Если КалендарныйГод = 2001 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20010108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20010107';
		
	ИначеЕсли КалендарныйГод = 2002 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20020225';
		СтрокаНабораЗаписей.ВыходнойДень	= '20020223';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20020503';
		СтрокаНабораЗаписей.ВыходнойДень	= '20020427';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20020510';
		СтрокаНабораЗаписей.ВыходнойДень	= '20020518';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20021108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20021110';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20021213';
		СтрокаНабораЗаписей.ВыходнойДень	= '20021215';
		
	ИначеЕсли КалендарныйГод = 2003 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20030103';
		СтрокаНабораЗаписей.ВыходнойДень	= '20030104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20030106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20030105';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20030224';
		СтрокаНабораЗаписей.ВыходнойДень	= '20030223';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20030310';
		СтрокаНабораЗаписей.ВыходнойДень	= '20030308';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20030613';
		СтрокаНабораЗаписей.ВыходнойДень	= '20030621';
		
	ИначеЕсли КалендарныйГод = 2004 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20040503';
		СтрокаНабораЗаписей.ВыходнойДень	= '20040501';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20040504';
		СтрокаНабораЗаписей.ВыходнойДень	= '20040502';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20040510';
		СтрокаНабораЗаписей.ВыходнойДень	= '20040509';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20040614';
		СтрокаНабораЗаписей.ВыходнойДень	= '20040612';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20041108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20041107';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20041213';
		СтрокаНабораЗаписей.ВыходнойДень	= '20041212';
		
	ИначеЕсли КалендарныйГод = 2005 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20050106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20050101';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20050110';
		СтрокаНабораЗаписей.ВыходнойДень	= '20050102';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20050307';
		СтрокаНабораЗаписей.ВыходнойДень	= '20050305';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20050502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20050501';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20050510';
		СтрокаНабораЗаписей.ВыходнойДень	= '20050514';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20050613';
		СтрокаНабораЗаписей.ВыходнойДень	= '20050612';
		
	ИначеЕсли КалендарныйГод = 2006 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20060106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20060101';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20060109';
		СтрокаНабораЗаписей.ВыходнойДень	= '20060107';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20060224';
		СтрокаНабораЗаписей.ВыходнойДень	= '20060226';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20060508';
		СтрокаНабораЗаписей.ВыходнойДень	= '20060506';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20061106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20061104';
		
	ИначеЕсли КалендарныйГод = 2007 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20070108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20070107';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20070430';
		СтрокаНабораЗаписей.ВыходнойДень	= '20070428';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20070611';
		СтрокаНабораЗаписей.ВыходнойДень	= '20070609';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20071105';
		СтрокаНабораЗаписей.ВыходнойДень	= '20071104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20071231';
		СтрокаНабораЗаписей.ВыходнойДень	= '20071229';
		
	ИначеЕсли КалендарныйГод = 2008 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20080108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20080105';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20080225';
		СтрокаНабораЗаписей.ВыходнойДень	= '20080223';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20080310';
		СтрокаНабораЗаписей.ВыходнойДень	= '20080308';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20080502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20080504';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20080613';
		СтрокаНабораЗаписей.ВыходнойДень	= '20080607';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20081103';
		СтрокаНабораЗаписей.ВыходнойДень	= '20081101';
		
	ИначеЕсли КалендарныйГод = 2009 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20090106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20090103';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20090108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20090104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20090109';
		СтрокаНабораЗаписей.ВыходнойДень	= '20090111';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20090309';
		СтрокаНабораЗаписей.ВыходнойДень	= '20090308';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20090511';
		СтрокаНабораЗаписей.ВыходнойДень	= '20090509';
		
	ИначеЕсли КалендарныйГод = 2010 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20100106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20100102';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20100108';
		СтрокаНабораЗаписей.ВыходнойДень	= '20100103';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20100222';
		СтрокаНабораЗаписей.ВыходнойДень	= '20100227';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20100503';
		СтрокаНабораЗаписей.ВыходнойДень	= '20100501';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20100510';
		СтрокаНабораЗаписей.ВыходнойДень	= '20100509';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20100614';
		СтрокаНабораЗаписей.ВыходнойДень	= '20100612';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20101105';
		СтрокаНабораЗаписей.ВыходнойДень	= '20101113';
		
	ИначеЕсли КалендарныйГод = 2011 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20110106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20110101';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20110110';
		СтрокаНабораЗаписей.ВыходнойДень	= '20110102';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20110307';
		СтрокаНабораЗаписей.ВыходнойДень	= '20110305';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20110502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20110501';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20110613';
		СтрокаНабораЗаписей.ВыходнойДень	= '20110612';
		
	ИначеЕсли КалендарныйГод = 2012 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120101';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120109';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120107';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120309';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120311';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120430';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120428';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120505';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120507';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120512';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120508';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20120611';
		СтрокаНабораЗаписей.ВыходнойДень	= '20120609';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20121105';
		СтрокаНабораЗаписей.ВыходнойДень	= '20121104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20121231';
		СтрокаНабораЗаписей.ВыходнойДень	= '20121229';
		
	ИначеЕсли КалендарныйГод = 2013 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20130502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20130105';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20130503';
		СтрокаНабораЗаписей.ВыходнойДень	= '20130106';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20130510';
		СтрокаНабораЗаписей.ВыходнойДень	= '20130223';
		
	ИначеЕсли КалендарныйГод = 2014 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20140502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20140104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20140613';
		СтрокаНабораЗаписей.ВыходнойДень	= '20140105';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20140310';
		СтрокаНабораЗаписей.ВыходнойДень	= '20140308';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20140224';
		СтрокаНабораЗаписей.ВыходнойДень	= '20140223';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20141103';
		СтрокаНабораЗаписей.ВыходнойДень	= '20140224';
		
	ИначеЕсли КалендарныйГод = 2015 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20150109';
		СтрокаНабораЗаписей.ВыходнойДень	= '20150103';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20150504';
		СтрокаНабораЗаписей.ВыходнойДень	= '20150104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20150309';
		СтрокаНабораЗаписей.ВыходнойДень	= '20150308';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20150511';
		СтрокаНабораЗаписей.ВыходнойДень	= '20150509';
		
	ИначеЕсли КалендарныйГод = 2016 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20160503';
		СтрокаНабораЗаписей.ВыходнойДень	= '20160102';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20160307';
		СтрокаНабораЗаписей.ВыходнойДень	= '20160103';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20160222';
		СтрокаНабораЗаписей.ВыходнойДень	= '20160220';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20160502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20160501';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20160613';
		СтрокаНабораЗаписей.ВыходнойДень	= '20160612';
		
	ИначеЕсли КалендарныйГод = 2017 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20170224';
		СтрокаНабораЗаписей.ВыходнойДень	= '20170101';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20170508';
		СтрокаНабораЗаписей.ВыходнойДень	= '20170107';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20171106';
		СтрокаНабораЗаписей.ВыходнойДень	= '20171104';
		
	ИначеЕсли КалендарныйГод = 2018 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20180309';
		СтрокаНабораЗаписей.ВыходнойДень	= '20180106';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20180430';
		СтрокаНабораЗаписей.ВыходнойДень	= '20180428';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20180502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20180107';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20180611';
		СтрокаНабораЗаписей.ВыходнойДень	= '20180609';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20181105';
		СтрокаНабораЗаписей.ВыходнойДень	= '20181104';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20181231';
		СтрокаНабораЗаписей.ВыходнойДень	= '20181229';
		
	ИначеЕсли КалендарныйГод = 2019 Тогда
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20190502';
		СтрокаНабораЗаписей.ВыходнойДень	= '20190105';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20190503';
		СтрокаНабораЗаписей.ВыходнойДень	= '20190106';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20190510';
		СтрокаНабораЗаписей.ВыходнойДень	= '20190223';
		
	ИначеЕсли КалендарныйГод = 2020 Тогда
		
		//СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		//СтрокаНабораЗаписей.РабочийДень		= '20200501';
		//СтрокаНабораЗаписей.ВыходнойДень	= '20200104';
		//
		//СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		//СтрокаНабораЗаписей.РабочийДень		= '202005??';
		//СтрокаНабораЗаписей.ВыходнойДень	= '20200105';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20200224';
		СтрокаНабораЗаписей.ВыходнойДень	= '20200223';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20200309';
		СтрокаНабораЗаписей.ВыходнойДень	= '20200308';
		
		СтрокаНабораЗаписей = ПеренесенныеРабочиеДни.Добавить();
		СтрокаНабораЗаписей.РабочийДень		= '20200511';
		СтрокаНабораЗаписей.ВыходнойДень	= '20200509';
		
	Иначе
		
	КонецЕсли;	

КонецПроцедуры

Функция ЗаполнениеКалендаряБезПереносов(КонтрольнаяДата) Экспорт
	
	ТаблицаРегистра = Новый ТаблицаЗначений();
	ТаблицаРегистра.Колонки.Добавить("ДатаКалендаря");
	ТаблицаРегистра.Колонки.Добавить("ВидДня");
	ТаблицаРегистра.Индексы.Добавить("ДатаКалендаря");

	мДлинаСуток = 86400;
	
	// Заполнение регистра за год
	ПервоеЯнваря = НачалоГода(КонтрольнаяДата);
	
	СписокПраздников = РегламентированнаяОтчетность.ПолучитьСписокПраздниковРФ(Год(КонтрольнаяДата));
	
	Для НомерДня = 1 По ДеньГода(КонецГода(КонтрольнаяДата)) Цикл
		
		ЗаписываемаяДата 	= НачалоДня(ПервоеЯнваря + мДлинаСуток * (НомерДня - 1));
		ПраздничныйДень = СписокПраздников.НайтиПоЗначению("" + Формат(ЗаписываемаяДата, "ДФ = 'ММ'") + Формат(ЗаписываемаяДата, "ДФ = 'дд'"));
		
		НоваяЗаписьРегистраВидДня =Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий; 
		
		Если ПраздничныйДень <> Неопределено Тогда
			
			НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник;
			
			// Предпраздничные дни
			Если НомерДня > 1 Тогда
				
				СтрокаТаблицы = ТаблицаРегистра.Найти(ЗаписываемаяДата - мДлинаСуток,"ДатаКалендаря");
				Если СтрокаТаблицы.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
					СтрокаТаблицы.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный;
				КонецЕсли; 
				
			КонецЕсли;
			
		Иначе
			
			Если ДеньНедели(ЗаписываемаяДата) = 6 Тогда
				НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота
			ИначеЕсли ДеньНедели(ЗаписываемаяДата) = 7 Тогда
				НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье
			Иначе
				НоваяЗаписьРегистраВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий
			КонецЕсли; 
			
		КонецЕсли; 
		
		// Запишем в таблицу значений
		НоваяСтрокаТаблицыРегистра = ТаблицаРегистра.Добавить();
		НоваяСтрокаТаблицыРегистра.ДатаКалендаря = ЗаписываемаяДата;
		НоваяСтрокаТаблицыРегистра.ВидДня        = НоваяЗаписьРегистраВидДня;
		
	КонецЦикла; 
	
	// 31 декабря предпраздничный день в таблице
	Если НоваяСтрокаТаблицыРегистра.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
		НоваяСтрокаТаблицыРегистра.ВидДня = Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный;
	КонецЕсли;
	Возврат ТаблицаРегистра
	
КонецФункции

Функция ЗаполнениеКалендаряСПереносами(КонтрольнаяДата, ТаблицаПеренесенныхДней, Сообщать = Истина) Экспорт
	
	ТаблицаРегистра = ЗаполнениеКалендаряБезПереносов(КонтрольнаяДата);
	СписокПраздниковВВыходные = ПраздничныеДниДляПереноса(Год(КонтрольнаяДата));
	ТаблицаПеренесенныхДней.Очистить();
	ЗаполнитьПереченьПеренесенныхДней(Год(КонтрольнаяДата), ТаблицаПеренесенныхДней);
	Для Каждого СтрокаНабораЗаписей Из ТаблицаПеренесенныхДней Цикл
		ПраздничныйДень = СписокПраздниковВВыходные.НайтиПоЗначению(СтрокаНабораЗаписей.ВыходнойДень);
		Если ПраздничныйДень <> Неопределено Тогда
			СписокПраздниковВВыходные.Удалить(ПраздничныйДень);
		КонецЕсли;
		ПеренестиДатыПроизводственногоКалендаря(ТаблицаРегистра, СтрокаНабораЗаписей);
	КонецЦикла;
	// Не все попавшие на выходные праздники подлежат переносу: в период с 1 по 8 января переносится только два праздника, а на выходные в некоторые годы может попасть 3 дня. Тогда
	// В 2017 году 8 января переносить не надо, скорректируем список недоделок.
	НайденныйЭлемент = СписокПраздниковВВыходные.НайтиПоЗначению('20170108');
	Если НайденныйЭлемент <> Неопределено Тогда
		СписокПраздниковВВыходные.Удалить(НайденныйЭлемент);
	КонецЕсли;
	Если Сообщать И СписокПраздниковВВыходные.Количество() > 0 Тогда
		Сообщить("При заполнении календаря на " + Формат(Год(КонтрольнаяДата),"ЧЦ=4; ЧГ=0") + " год обнаружены государственные праздники, попадающие на выходные дни:"); 
		Для Сч = 1 По СписокПраздниковВВыходные.Количество() Цикл
			Сообщить("   " + Формат(СписокПраздниковВВыходные[Сч - 1].Значение, "ДФ ='дд ММММ'") + " - " + СписокПраздниковВВыходные[Сч - 1])
		КонецЦикла; 
		Сообщить("Необходимо перенести эти выходные дни на рабочие дни.", СтатусСообщения.Внимание)
	КонецЕсли; 
	
	Возврат ТаблицаРегистра
	
КонецФункции

