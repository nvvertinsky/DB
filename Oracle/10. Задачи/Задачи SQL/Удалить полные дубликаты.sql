3. В таблице ниже появились полные дубликаты. Нужно дубликаты удалить и оставить только 1 запись от них.
Таблица: client_balance(cl_id /*ID клиента*/, cl_name /*Имя клиента*/, dt /*Остаток на день*/, balance /*Баланс на эту дачу*/);

create table client_balance(cl_id number, cl_name varchar2(240), dt date, balance number(12));
insert into client_balance values (1, 'nikolay', to_date('01.01.2024', 'dd.mm.yyyy'), 100);
insert into client_balance values (2, 'nikolay2', to_date('01.01.2024', 'dd.mm.yyyy'), 200);
insert into client_balance values (2, 'nikolay2', to_date('01.01.2024', 'dd.mm.yyyy'), 200);
insert into client_balance values (2, 'nikolay2', to_date('01.01.2024', 'dd.mm.yyyy'), 200);
insert into client_balance values (3, 'nikolay3', to_date('02.01.2024', 'dd.mm.yyyy'), 300);
insert into client_balance values (3, 'nikolay3', to_date('02.01.2024', 'dd.mm.yyyy'), 300);
insert into client_balance values (3, 'nikolay3', to_date('02.01.2024', 'dd.mm.yyyy'), 300);
insert into client_balance values (4, 'nikolay4', to_date('03.01.2024', 'dd.mm.yyyy'), 400);






delete
  from client_balance cl
 where cl.rowid not in (select min(rowid)
                          from client_balance cl
                         group by cl.cl_id,
                                  cl.cl_name,
                                  cl.dt,
                                  cl.balance) 