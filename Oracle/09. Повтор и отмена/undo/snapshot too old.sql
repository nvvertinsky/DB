/*
Причины:
  - Сегменты отмены слишком малы для работы
  - Пересекающиеся commit
  - Очистка блоков

Решения: 
  - Значение параметра UNDO_RETENTION должно превышать продолжительность самой длительной транзакции. 
    - Самые длительные можно определить v$undostat
    - С помощью параметра мы говорим насколько долго следует удерживать информацию в undo
    - Если доступное пространство будет израсходовано, то будет расширит сегменты отмены
    - Значение в секундах
- Увеличьте размер или добавьте больше сегментов undo
  - Сократите время выполнения запроса. 
  - Соберите статистику 

Сценарий:
  - Каждая транзакция генерирует 8 Кбайт информации undo
  - Происходит 5 транзакций в секунду (40 Кбайт в сек, 2400 Кбайт в мин)
  - Есть транзакция которая генерирует 1 мбайт в мин
  - Итого генериться 3,5 мбайт информации undo в минуту
  - В системе сконфигурировано 15 мбайт под undo
  - Сегменты undo повторно задействуют пространство каждые 3-4 минуты
  - Появилась необходимость в формировании отчета. Длительность 5 мин
  - Т.к запрос берет информацию из undo, чтобы получить данные на время начала запроса, то можешь возникнуть ошибка.
  - Потому что информация в undo будет перезаписана, запрос не сможет показать согласованные данные на время начала запроса.

Решения для этого сценария: 
  - Уменьшить время выполнения запроса
  - Увеличить размер undo, чтобы перезаписование было каждые 10 мин









*/