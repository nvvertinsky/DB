# Как выполняется фаза execute



### При SELECT + FULL SCAN
  1. В PGA в курсорной области создается курсор.
  2. Серверный процесс считывает блок с данными в буферный кеш.
  3. В блоке ищем нужную нам запись
  4. Если нашли нужную запись, то вытаскиваем ее и переносим ее в курсор
  
  
### SELECT + INDEX B-TREE
  1. Берем первый блок индекса (корень) в буферный кеш
  2. В считанном блоке есть информация о том какой следующий блок брать (ветви)
  3. Таким образом доходим до того, что считываем с диска листовой блок индекса.
  4. В листовом блоке есть rowid нужной нам записи.
  5. Считываем с диска по rowid нужный нам блок. 
  6. В блоке находим нужную запись
  7. Если нашли нужную запись, то вытаскиваем ее и переносим в курсор. Если нужно отсортировать, то сначала в область сортировки, а потом в курсор

### При UPDATE: 
  1. Серверный процесс считывает блок с данными в буферный кеш
  2. Блок копируется в буферном кеше. Для того чтобы другие транзации UPDATE могли изменять другие строки в этом блоке. Ведь на исходном блоке защелка. Опция таблицы MAXTRANS 255 контролирует сколько таких копий можно сделать.
  2. DBWR записывает неизмененный блок в UNDO. Чтобы другие запросы могли читать неизменненные данные. 
  3. Меняет данные в блоке.
  4. LGWR записывает изнеменение в блоке в REDO журнал в памяти
  5. Пользователь нажимает commit
  6. Транзакции присваивается SCN
  7. LGWR скидывает данные об операции в файл логов REDO на диске и SCN. Эта запись на диске будет определять что транзакция реально зафиксирована.
  8. CKPT создает контрольную точку в conrol file. А именно записывает scn коммита. И сообщает DBWR что блоки можно скидывать на диск. 
  9. DBWR скидывает грязный блок на диск.
  

### Восстановление
Допустим scn контрольной точки 10. 
Текущий scn 90.

Сервер отрубается.

Сервер запускается и начинает сам востанавливать данные, а именно:
  - lgwr вычитывает данные из scn 90 до scn 10
  - Загоняет данные обратно к буферный кеш
  - а из буферного кеша потом dbwr скинет данные на диск