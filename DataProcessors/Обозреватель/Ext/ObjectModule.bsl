#Если Клиент Тогда

Перем СерверИсточник Экспорт;
Перем КаталогОбновлений Экспорт;


КаталогОбновлений = КаталогВременныхФайлов() + "tempIPP8";
СоздатьКаталог(КаталогОбновлений);
СерверИсточник = "http://users.v8.1c.ru";

#КонецЕсли