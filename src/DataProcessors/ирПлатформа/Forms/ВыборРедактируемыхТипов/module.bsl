﻿Перем мСоответствиеСтруктурТипа;

Функция ПолучитьОтобранныеСтрокиТаблицы() Экспорт

	ВременнныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременнныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаРедактируемыхТипов);
	ирОбщий.СкопироватьОтборПостроителяЛкс(ВременнныйПостроительЗапроса.Отбор, ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок);
	ВременнныйПостроительЗапроса.ВыбранныеПоля.Добавить("Имя");
	ВременнныйПостроительЗапроса.Выполнить();
	Результат = ВременнныйПостроительЗапроса.Результат.Выгрузить();
	Возврат Результат;

КонецФункции // ПолучитьОтобранныеСтрокиТаблицы()

Функция ПолучитьПомеченныеСтрокиТаблицы() Экспорт

	ВременнныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременнныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаРедактируемыхТипов);
	ВременнныйПостроительЗапроса.Отбор.Добавить("Пометка").Установить(Истина);
	ВременнныйПостроительЗапроса.ВыбранныеПоля.Добавить("Имя");
	//ВременнныйПостроительЗапроса.Выполнить();
	Результат = ВременнныйПостроительЗапроса.Результат.Выгрузить();
	Возврат Результат;

КонецФункции // ПолучитьПомеченныеСтрокиТаблицы()

Процедура УстановитьСнятьПометка(Признак, ИзменятьМодифицированность = Истина)
	
	Если ИзменятьМодифицированность Тогда 
		Модифицированность = Истина;
	КонецЕсли;
	ВременнаяТаблица = ПолучитьОтобранныеСтрокиТаблицы();
	Для каждого ВременнаяСтрока Из ВременнаяТаблица Цикл
		СтрокаТипа = ТаблицаРедактируемыхТипов.Найти(ВременнаяСтрока.Имя);
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаТипа.Пометка, Признак);
	КонецЦикла;
	ЭлементыФормы.ТаблицаРедактируемыхТипов.ОбновитьСтроки();
	
КонецПроцедуры

Процедура УстановитьПометкуДерева(СтрокиДереваТипов, Признак)

	Для каждого СтрокаДереваТипа Из СтрокиДереваТипов Цикл
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(СтрокаДереваТипа.Пометка, Признак);
		УстановитьПометкуДерева(СтрокаДереваТипа.Строки, Признак);
	КонецЦикла;

КонецПроцедуры // УстановитьСПометкуДерева()

Процедура ЗакрытьССохранением()

	МассивТипов = Новый Массив();
	ВыбранныеСтроки = ТаблицаРедактируемыхТипов.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для Каждого ВыбраннаяСтрока Из ВыбранныеСтроки Цикл
		МассивТипов.Добавить(СериализаторXDTO.ИзXMLТипа(ВыбраннаяСтрока.Имя, ВыбраннаяСтрока.URIПространстваИмен));
	КонецЦикла;
	Если МассивТипов.Найти(Тип("Строка")) <> Неопределено Тогда 
		КвалификаторыСтроки = Новый КвалификаторыСтроки(ДлинаСтроки, ?(Фиксированная, ДопустимаяДлина.Фиксированная, ДопустимаяДлина.Переменная));
	КонецЕсли; 
	Если МассивТипов.Найти(Тип("Число")) <> Неопределено Тогда 
		КвалификаторыЧисла = Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ?(Неотрицательное, ДопустимыйЗнак.Неотрицательный, ДопустимыйЗнак.Любой));
	КонецЕсли; 
	Если МассивТипов.Найти(Тип("Дата")) <> Неопределено Тогда 
		КвалификаторыДаты = Новый КвалификаторыДаты(СоставДаты);
	КонецЕсли;
	ОграничениеТипа = Новый ОписаниеТипов(МассивТипов, ,,КвалификаторыЧисла, КвалификаторыСтроки, КвалификаторыДаты);
	Модифицированность = Ложь;
	Если МножественныйВыбор Тогда
		НовоеЗначение = ОграничениеТипа;
	Иначе
		Типы = ОграничениеТипа.Типы();
		Если Типы.Количество() > 0 Тогда
			НовоеЗначение = Типы[0];
		Иначе
			НовоеЗначение = Неопределено
		КонецЕсли; 
	КонецЕсли; 
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);

КонецПроцедуры // ЗакрытьССохранением()

Процедура КнопкаОКНажатие(Кнопка)
	
	ЗакрытьССохранением();

КонецПроцедуры

Процедура КоманднаяПанельФормаУстановитьФлажки(Кнопка)
	
	УстановитьСнятьПометка(Истина);

КонецПроцедуры

Процедура КоманднаяПанельФормаСнятьФлажки(Кнопка)
	
	УстановитьСнятьПометка(Ложь);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ТаблицаРедактируемыхТипов.Количество() = 0 Тогда
		ЗаполнитьТаблицуРедактируемыхТипов();
	КонецЕсли;
	
	ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Представление.Значение = "";
	СброситьПометкиУПомеченных();
	Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("Тип") Тогда
		ВыбранныеТипы = Новый Массив();
		ВыбранныеТипы.Добавить(НачальноеЗначениеВыбора);
	ИначеЕсли ТипЗнч(НачальноеЗначениеВыбора) = Тип("ОписаниеТипов") Тогда
		ВыбранныеТипы = НачальноеЗначениеВыбора.Типы();
	Иначе
		ВыбранныеТипы = Новый Массив();
	КонецЕсли; 
	Для Каждого ВыбранныйТип Из ВыбранныеТипы Цикл
		Если ТипЗнч(НачальноеЗначениеВыбора) = Тип("Тип") Тогда
			Если ВыбранныйТип = Тип("Неопределено") Тогда
				Продолжить;
			КонецЕсли; 
		КонецЕсли; 
		ТипXML = СериализаторXDTO.XMLТип(ВыбранныйТип);
		Если ТипXML = Неопределено Тогда
			ТекстСообщения = "Для типа """ + ВыбранныйТип + """ не предусмотрена сериализация";
			//ВызватьИсключение ТекстСообщения;
			Сообщить(ТекстСообщения);
			Продолжить;
		КонецЕсли; 
		ЭлементСписка = ТаблицаРедактируемыхТипов.Найти(ТипXML.ИмяТипа, "Имя");
		Если ЭлементСписка = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		ЭлементСписка.Пометка = Истина;
		Если Не МножественныйВыбор Тогда
			ЭлементыФормы.ТаблицаРедактируемыхТипов.ТекущаяСтрока = ЭлементСписка;
		КонецЕсли; 
	КонецЦикла;
	ЭлементыФормы.РазрешитьСоставнойТип.Доступность = МножественныйВыбор;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = МножественныйВыбор;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.СнятьФлажки.Доступность = МножественныйВыбор;
	Если МножественныйВыбор Тогда
		РазрешитьСоставнойТип = Истина;
		Если ВыбранныеТипы.Количество() > 0 Тогда
			КоманднаяПанельТиповТолькоВыбранные(ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
			Если ВыбранныеТипы.Количество() = 1 Тогда
				РазрешитьСоставнойТип = Ложь;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ДопустимыеТипы = ОграничениеТипа.Типы();
		Если ДопустимыеТипы.Количество() > 0 Тогда
			ЭлементОтбораИмя = ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Имя;
			ЭлементОтбораИмя.ВидСравнения = ВидСравнения.ВСписке;
			ЭлементОтбораИмя.Использование = Истина;
			СписокОтбора = ЭлементОтбораИмя.Значение;
			Для Каждого РазрешенныйТип Из ДопустимыеТипы Цикл
				ТипXML = СериализаторXDTO.XMLТип(РазрешенныйТип);
				Если ТипXML = Неопределено Тогда
					// Например НаправлениеСортировки
					Продолжить;
				КонецЕсли; 
				СписокОтбора.Добавить(ТипXML.ИмяТипа)
			КонецЦикла;
		КонецЕсли; 
	КонецЕсли; 
	ЭтаФорма.ЭлементыФормы.ПанельКвалификаторов.Доступность = МножественныйВыбор;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = РазрешитьСоставнойТип;

	Если МножественныйВыбор Тогда
		Если ВыбранныеТипы.Найти(Тип("Строка")) <> Неопределено Тогда
			Квалификаторы = НачальноеЗначениеВыбора.КвалификаторыСтроки;
			ДлинаСтроки = Квалификаторы.Длина;
			Фиксированная = Квалификаторы.ДопустимаяДлина = ДопустимаяДлина.Фиксированная;
		КонецЕсли; 
		Если ВыбранныеТипы.Найти(Тип("Число")) <> Неопределено Тогда
			Квалификаторы = НачальноеЗначениеВыбора.КвалификаторыЧисла;
			Разрядность = Квалификаторы.Разрядность;
			РазрядностьДробнойЧасти = Квалификаторы.РазрядностьДробнойЧасти;
			Неотрицательное = Квалификаторы.ДопустимыйЗнак = ДопустимыйЗнак.Неотрицательный;
		КонецЕсли; 
		Если ВыбранныеТипы.Найти(Тип("Дата")) <> Неопределено Тогда
			Квалификаторы = НачальноеЗначениеВыбора.КвалификаторыДаты;
			СоставДаты = Квалификаторы.ЧастиДаты;
		КонецЕсли; 
	КонецЕсли; 
	
	ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Пометка.Значение = Истина;
	
	ЭлементОтбораПредставление = ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Представление;
	ЭлементОтбораПредставление.ВидСравнения = ВидСравнения.Содержит;
	ЭлементОтбораПредставление.Использование = Истина; 

КонецПроцедуры

Процедура КоманднаяПанельТиповТолькоВыбранные(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Пометка.Использование = Кнопка.Пометка;
	
КонецПроцедуры

Процедура ТаблицаТиповПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Попытка
		ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(Вычислить("ПолучитьНастройкуКартинки(глПолучитьПиктограммуСсылочногоОбъекта(ПолучитьСсылкуТипа(ДанныеСтроки)))"));
	Исключение
	КонецПопытки;
	Если Ложь
		Или ОформлениеСтроки.Ячейки.Представление.Картинка.Вид = ВидКартинки.Пустая 
	Тогда
		ОформлениеСтроки.Ячейки.Представление.ОтображатьКартинку = Истина;
		XMLТип = Новый ТипДанныхXML(ДанныеСтроки.Имя, ДанныеСтроки.URIПространстваИмен);
		Тип = СериализаторXDTO.ИзXMLТипа(XMLТип);
		Если Тип <> Неопределено Тогда
			КартинкаТипа = ирОбщий.ПолучитьПиктограммуТипаЛкс(Тип);
		КонецЕсли; 
		Если КартинкаТипа <> Неопределено Тогда
			ОформлениеСтроки.Ячейки.Представление.УстановитьКартинку(КартинкаТипа);
		Иначе
			ОформлениеСтроки.Ячейки.Представление.ИндексКартинки = ДанныеСтроки.ИндексКартинки;
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ТаблицаТиповПриИзмененииФлажка(Элемент, Колонка)

	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	НоваяПометка = ТекущаяСтрока.Пометка;
	Если Не РазрешитьСоставнойТип Тогда
		СброситьПометкиУПомеченных();
	КонецЕсли;
	ТекущаяСтрока.Пометка = НоваяПометка;
	ирОбщий.ПрисвоитьЕслиНеРавноЛкс(Элемент.ТекущаяСтрока, ТекущаяСтрока);
	
КонецПроцедуры

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Функция ОпределитьТекущуюСтроку()


	
КонецФункции // ОпределитьТекущуюСтроку()

Процедура КоманднаяПанельДереваСправка(Кнопка)
	
	ТекущаяСтрока = ЭлементыФормы.ТаблицаРедактируемыхТипов.ТекущаяСтрока;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТипXML = Новый ТипДанныхXML(ТекущаяСтрока.Имя, ТекущаяСтрока.URIПространстваИмен);
	Тип = СериализаторXDTO.ИзXMLТипа(ТипXML);
	СтруктураТипа = ирКэш.Получить().ПолучитьСтруктуруТипаИзКонкретногоТипа(Тип);
	СтрокаОбщегоТипа = ирКэш.Получить().ТаблицаОбщихТипов.Найти(СтруктураТипа.ИмяОбщегоТипа);
	Если СтрокаОбщегоТипа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ирОбщий.ОткрытьСтраницуСинтаксПомощникаЛкс(СтрокаОбщегоТипа.ПутьКОписанию, , ЭтаФорма);

КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Данные были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена);
		Если Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
			Закрыть(Ложь);
		Иначе
			ЗакрытьССохранением();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьФильтрНажатие(Элемент)
	
	ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Имя.Значение = "";
	
КонецПроцедуры

Процедура СброситьПометкиУПомеченных(ВременнаяТаблица = Неопределено)

	Если ВременнаяТаблица = Неопределено Тогда
		ВременнаяТаблица = ПолучитьПомеченныеСтрокиТаблицы();
	КонецЕсли;
	Признак = Ложь;
	Для каждого ВременнаяСтрока Из ВременнаяТаблица Цикл
		СтрокаТипа = ТаблицаРедактируемыхТипов.Найти(ВременнаяСтрока.Имя);
		СтрокаТипа.Пометка = Признак;
	КонецЦикла;
	// Антибаг платформы 8.2.15. Непомеченные строки лишались текста в колонке "Представление" при выводе строки
	// http://partners.v8.1c.ru/forum/thread.jsp?id=1016721#1016721
	ЭлементыФормы.ТаблицаРедактируемыхТипов.ОбновитьСтроки();

КонецПроцедуры // СброситьПометкиУПомеченных()

Процедура РазрешитьСоставнойТипПриИзменении(Элемент)
	
	Если Не РазрешитьСоставнойТип Тогда
		ВременнаяТаблица = ПолучитьПомеченныеСтрокиТаблицы();
		Если ВременнаяТаблица.Количество() > 1 Тогда
			ВременнаяТаблица.Удалить(0);
			СброситьПометкиУПомеченных(ВременнаяТаблица);
		КонецЕсли;
	КонецЕсли;
	ЭлементыФормы.КоманднаяПанельТипов.Кнопки.УстановитьФлажки.Доступность = РазрешитьСоставнойТип;
	
КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеKeyDown(Элемент, KeyCode, Shift)
	
	Если Shift Тогда 
		Если KeyCode.Value = 16 Тогда // F4
			ЭлементыФормы.ТаблицаРедактируемыхТипов.ОтборСтрок.Имя.Значение = "";
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ТаблицаТиповВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Не ТолькоПросмотр Тогда
		Элемент.ТекущаяСтрока.Пометка = Истина;
		ТаблицаТиповПриИзмененииФлажка(Элемент, Колонка);
		ЗакрытьССохранением();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолеВвода1ПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	
	КнопкаФильтра = ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные;
	Если КнопкаФильтра.Пометка Тогда
		КоманднаяПанельТиповТолькоВыбранные(ЭтаФорма.ЭлементыФормы.КоманднаяПанельТипов.Кнопки.ТолькоВыбранные);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолеВвода1НачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицаТиповПриАктивизацииСтроки(Элемент)
	
	Если Истина
		И Элемент.ТекущиеДанные <> Неопределено
		И (Ложь
			Или Элемент.ТекущиеДанные.Имя = "string"
			Или Элемент.ТекущиеДанные.Имя = "datetime"
			Или Элемент.ТекущиеДанные.Имя = "decimal")
	Тогда
		ИмяСтраницы = Элемент.ТекущиеДанные.Имя;
		ЭлементыФормы.ПанельКвалификаторов.ТекущаяСтраница = ЭлементыФормы.ПанельКвалификаторов.Страницы[ИмяСтраницы];
		ЭлементыФормы.ПанельКвалификаторов.Видимость = Истина;
	Иначе
		ЭлементыФормы.ПанельКвалификаторов.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура НеограниченнаяПриИзменении(Элемент)
	
	Если Элемент.Значение Тогда
		ДлинаСтроки = 0;
	КонецЕсли; 
	ЭлементыФормы.ДлинаСтроки.Доступность = Не Элемент.Значение;
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура СоставДатыПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();

КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура УстановитьПометкуВТекущейСтроке()

	ТекущаяСтрока = ЭлементыФормы.ТаблицаРедактируемыхТипов.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущаяСтрока.Пометка = Истина;
	ТаблицаТиповПриИзмененииФлажка(ЭлементыФормы.ТаблицаРедактируемыхТипов,);

КонецПроцедуры // УстановитьПометкуВТекущейСтроке()

Процедура РазрядностьПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура РазрядностьДробнойЧастиПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();

КонецПроцедуры

Процедура НеотрицательноеПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ДлинаСтрокиПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Процедура ФиксированнаяПриИзменении(Элемент)
	
	УстановитьПометкуВТекущейСтроке();
	
КонецПроцедуры

Функция ПолучитьСсылкуТипа(ДанныеСтроки = Неопределено)

	Если ДанныеСтроки = Неопределено Тогда
		ТабличноеПоле = ЭлементыФормы.ТаблицаРедактируемыхТипов;
		ДанныеСтроки = ТабличноеПоле.ТекущаяСтрока;
	КонецЕсли; 
	Если ДанныеСтроки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИмяТипа = ДанныеСтроки.Имя;
	
	ОбъектСистемы = Вычислить("глКэш.СсылкиОбъектовСистемыПоОбщемуТипу[ИмяТипа]");
	Если ЗначениеЗаполнено(ОбъектСистемы) Тогда
		Возврат ОбъектСистемы;
	КонецЕсли; 
	Попытка
		Тип = Тип(ИмяТипа);
	Исключение
		Возврат Неопределено;
	КонецПопытки; 
	ДопМетаданные = Вычислить("глПолучитьМетаданныеТипа(Тип)");
	Если Истина
		И ДопМетаданные <> Неопределено
		И ЗначениеЗаполнено(ДопМетаданные.СсылкаОбъектаМД) 
	Тогда
		Возврат ДопМетаданные.СсылкаОбъектаМД;
	КонецЕсли; 
	Возврат Неопределено;

КонецФункции // ПолучитьСсылкуТипа()

Процедура КоманднаяПанельТиповОткрыть(Кнопка)
	
	Если ирКэш.Получить().Это2iS Тогда 
		СсылкаТипа = ПолучитьСсылкуТипа();
		Если ЗначениеЗаполнено(СсылкаТипа) Тогда
			ОткрытьЗначение(СсылкаТипа);
		КонецЕсли; 
	Иначе
		ТабличноеПоле = ЭлементыФормы.ТаблицаРедактируемыхТипов;
		ДанныеСтроки = ТабличноеПоле.ТекущаяСтрока;
		Если ДанныеСтроки = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ИмяТипа = ДанныеСтроки.Имя;
		Попытка
			Тип = Тип(ИмяТипа);
		Исключение
			Возврат;
		КонецПопытки; 
		ОбъектМД = Метаданные.НайтиПоТипу(Тип);
		Если ОбъектМД <> Неопределено Тогда
			ирОбщий.ОткрытьОбъектМетаданныхЛкс(ОбъектМД);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПолеВвода1АвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	ирОбщий.ПромежуточноеОбновлениеСтроковогоЗначенияПоляВводаЛкс(Элемент, Текст);
	ПолеВвода1ПриИзменении(Элемент);

КонецПроцедуры

Процедура ПолеВвода1Очистка(Элемент, СтандартнаяОбработка)
	
	ПолеВвода1ПриИзменении(Элемент);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ВыборРедактируемыхТипов");

СписокВыбора = ЭлементыФормы.СоставДаты.СписокВыбора;
СписокВыбора.Добавить(ЧастиДаты.Время);
СписокВыбора.Добавить(ЧастиДаты.Дата);
СписокВыбора.Добавить(ЧастиДаты.ДатаВремя);
СоставДаты = ЧастиДаты.ДатаВремя;

// Антибаг платформы. Очищаются свойство данные, если оно указывает на отбор табличной части
ЭлементыФормы.ПодстрокаОтбораПоПредставлению.Данные = "ЭлементыФормы.ТаблицаРедактируемыхТипов.Отбор.Представление.Значение";
ЭлементыФормы.ПодстрокаОтбораПоПредставлению.КнопкаВыбора = Ложь;
ЭлементыФормы.ПодстрокаОтбораПоПредставлению.КнопкаСпискаВыбора = Истина;
