////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Получает текст из хранилища регистра
//
// Параметры:
//  КлючЗаписи - РегистрСведенийКлючЗаписи - запись из которой нужно получить данные.
//
// Возвращаемое значение:
//  Строка - Текст с данными
//
Функция ТекстСообщения(КлючЗаписи) Экспорт
	
	Менеджер = РегистрыСведений.ЖурналАудитаСбербанк.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Менеджер, КлючЗаписи);
	Менеджер.Прочитать();
	Возврат Менеджер.ТекстСообщения.Получить();
	
КонецФункции

#КонецЕсли