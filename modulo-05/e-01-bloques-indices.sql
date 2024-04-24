--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 5 2024
--@Descripción: ejercicio 1 creación de un índice B* tree


whenever sqlerror exit rollback;

Prompt conectando como sys
connect sys/system2 as sysdba

Prompt revisando si el usario JORGE05 existe, en caso de exisitir se elimina y se crea de nuevo
declare
  v_count number;
begin
  select count(*) into v_count
  from all_users
  where username = 'JORGE05';

-- ddl es con sql dinamico
  if v_count > 0 then
    execute immediate 'drop user jorge05 cascade';
  end if;
end;
/

Prompt creando usuario
create user jorge05 identified by jorge quota unlimited on users;
grant create table, create session  to jorge05;

Prompt conectando como jorge05
connect jorge05/jorge

create table t01_id(
  id number(10,0) constraint t01_id_pk primary key
);

Prompt insertando registro 1
insert into t01_id(id) values(1);

Prompt mostrando datos del índice.
set linesize window
col table_name format a20
select  index_type,table_name,uniqueness,tablespace_name,status,
  blevel, distinct_keys
from user_indexes
where  index_name='T01_ID_PK';

Pause Analizar resultados, presionar [Enter] para continuar

Prompt Recolectando estadísticas
begin
  dbms_stats.gather_index_stats(
    ownname => 'JORGE05',
    indname => 'T01_ID_PK'
  );
end;
/

Prompt mostrando datos del índice despues de la recolección
set linesize window
col table_name format a20
select  index_type,table_name,uniqueness,tablespace_name,status,
  blevel, distinct_keys
from user_indexes
where  index_name='T01_ID_PK';

Pause Analizar resultados, presionar [Enter] para realizar la carga

--1000000
begin
  for v_index in 2..9000 loop
    --insert into t01_id values(v_index);
    execute immediate 'insert into t01_id(id) values (:ph1)' using v_index;
  end loop;
end;
/

Prompt recolectando estadisticas despues de la carga
begin
  dbms_stats.gather_index_stats(
    ownname => 'JORGE05',
    indname => 'T01_ID_PK'
  );
end;
/

Prompt mostrar los datos del índice despues de la carga
select  index_type,table_name,uniqueness,tablespace_name,status,
  blevel, distinct_keys, leaf_blocks
from user_indexes
where  index_name='T01_ID_PK';

exit
