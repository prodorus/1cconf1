﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИсточникКадровыхСведений = Число(Объект.ИсточникКадровыхСведенийРегламентированныйУчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникКадровыхСведенийПриИзменении(Элемент)
	
	Объект.ИсточникКадровыхСведенийРегламентированныйУчет = Булево(ИсточникКадровыхСведений);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиКлиент.ФормаНастройкиПередЗакрытием(Отказ, ЭтаФорма);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры
