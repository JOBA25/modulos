--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 6 2024
--@Descripción: programa 1 espacio no usado

whenever sqlerror exit rollback
Prompt Conectando como Jorge05 para  crear tabla con datos.
connect jorge05/jorge
set serveroutput on

--Programa 1
declare
  v_query varchar2(1000);
  v_index number;
begin  
  begin
    execute immediate 'drop table numeros';
  exception
    when others then
      if sqlcode = -942 then
        dbms_output.put_line('La tabla  numeros no existe, se creará');
      else
        raise;
      end if; 
  end;

  execute immediate 
    'create table numeros(
      id number constraint numeros_pk primary key,
      numero_aleatorio number
    )';
  
  --inserta 10,000 registros
  for v_index in 1..10000 loop
    execute immediate 'insert into numeros values(:id,:num_aleatorio)'
      using v_index, dbms_random.random;
  end loop;

  commit;
  dbms_output.put_line('Ok, '||v_index||' insertados');     
end;
/