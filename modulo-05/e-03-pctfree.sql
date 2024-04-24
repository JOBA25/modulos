--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 5 2024
--@Descripción: ejercicio 3 Explorar configuración del pctfree

connect jorge05/jorge


whenever sqlerror exit  rollback;
drop table t02_random_str_0;
drop table t02_random_str_50;

Prompt creando tabla con pctfree 0
create table t02_random_str_0(
  str char(18)
) pctfree 0;

Prompt creando tabla con pctfree 50
create table t02_random_str_50(
  str char(18)
) pctfree 50;

Pause presione [Enter] para comenzar con la carga

declare
  v_str char(18);
begin
  v_str := rpad('A',18,'X');
  for v_index in 1..10000 loop
    insert into  t02_random_str_0 values(v_str);
    insert into  t02_random_str_50 values(v_str);
  end loop;
end;
/
commit;

Prompt consultando  bloques y sus registros para t02_random_str_0
select dbms_rowid.rowid_relative_fno(rowid) as file_number,
  dbms_rowid.rowid_block_number(rowid) as block_number, 
  count(*) total_registros
from t02_random_str_0
group by dbms_rowid.rowid_relative_fno(rowid), 
         dbms_rowid.rowid_block_number(rowid)
order by 1,2;


Prompt consultando  bloques y sus registros para t02_random_str_50
select dbms_rowid.rowid_relative_fno(rowid) as file_number,
  dbms_rowid.rowid_block_number(rowid) as block_number, 
  count(*) total_registros
from t02_random_str_50
group by dbms_rowid.rowid_relative_fno(rowid), dbms_rowid.rowid_block_number(rowid)
order by 1,2;
