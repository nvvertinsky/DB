# UGA


### Описание: 
  - Область памяти связанная с конкретным сеансом
  - Если подключение к БД выполнено через разделяемый сервер, то память распологается в SGA. Таким образом памятью можно пользоваться любой из разделяемых процессов, посколько любой из них может считывать и записывать данные сеанса.
  - Иначе в PGA.