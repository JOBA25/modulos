--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 24 2023
--@Descripción: ejercicio 3 modos de shutdown

connect user01/user01

set serveroutput on
declare
  v_count number;
begin
  select count(*) into v_count from user_tables where table_name='TEST3';
  if v_count = 0 then
    execute immediate 'create table test3(id number)';
  else
    dbms_output.put_line('La tabla existe');
  end if;  
end;
/

Prompt sesion que crea una tabla e inserta un registro, hacer commit
insert into test3 values(100);
commit;

Prompt mostrando los datos de la tabla:
select * from test3;