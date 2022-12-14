Существуют:
1. Локальные префиксные индексы
2. Локальные непрефиксные индексы


create table partitioned_table (a int, b int, data char(20))
partition by range (a) 
(
partition part_1 values less than(2) tablespace p1,
partition part_2 values less than(3) tablespace p2
);

-- Создадим индексы
create index local_prefixed on partitioned_table (a, b) local;
create index local_nonprefixed on partitioned_table (b) local;

-- Вставляем данные
insert into partitioned_table select mod(rownum - 1, 2) + 1, rownum, 'x' from dual connect by level <= 7000;

-- Собираем статистику
begin
  dbms_stats.gather_table_stats(user, 'PARTITIONED_TABLE', cascade => true);
end;

-- Имитируем отказ диска с табличным пространством p2
alter tablespace p2 offline;

-- Индекс local_prefixed отработает без ошибок, т.к. не будет пытаться читать не нужные секции
select * from partitioned_table where a = 1 and b = 1;

-- А вот local_nonprefixed будет читать все секции. Соответственно будет ошибка при чтении секции p2
select * from partitioned_table where b = 1;


-- Локальные индесы обеспечивают уникальность только внутри одной индексной секции - и никогда между секциями.