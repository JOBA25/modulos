--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio 2 consultas dentro de las pdbs

spool s-01-spool.txt

set linesize window
col pdb_name format a30
col name format a30
col open_time format a40


prompt Consulta 1, conectando a  root
-------------------------------------
connect sys/system3@jbadip03 as sysdba
-- otra forma 
-- asumiendo que ORACLE_SID = jbadip03
--connect sys/system3 as sydba

select dbid,name,cdb,con_id,con_dbid
from v$database;

prompt Consulta 1, conectado jbadip03_s1
-----------------------------------------
connect sys/system3@jbadip03_s1 as sysdba 
-- para un pdb no podemos usar orecla sid sybda
select dbid,name,cdb,con_id,con_dbid
from v$database;

prompt Consulta 1, conectado jbadip03_s2
-----------------------------------------
connect sys/system3@jbadip03_s2 as sysdba
select dbid,name,cdb,con_id,con_dbid
from v$database;

pause Analizar resultados [enter] para continuar


prompt Consulta 2 en root - dba_pdbs
----------------------------------------------
connect sys/system3@jbadip03  as sysdba
select con_id, pdb_id, pdb_name, dbid, status 
from dba_pdbs;


prompt Consulta 2 en jbadip03_s2 - dba_pdbs
--------------------------------------------
connect sys/system3@jbadip03_s2  as sysdba

select con_id, pdb_id, pdb_name, dbid, status 
from dba_pdbs;

pause Analizar resultados [enter] para continuar


prompt Consulta 3 en root - v$pdbs 
-----------------------------------------------
connect sys/system3@jbadip03  as sysdba
select con_id, name, open_mode, open_time from v$pdbs;

prompt Consulta 3 en jbadip03_s1 - v$pdbs
------------------------------------------
connect sys/system3@jbadip03_s1  as sysdba
select con_id, name, open_mode, open_time from v$pdbs;

prompt Consulta 3 en jbadip03_s2 - v$pdbs
--------------------------------------------
connect sys/system3@jbadip03_s2  as sysdba
select con_id, name, open_mode, open_time from v$pdbs;

pause Analizar resultados [enter] para continuar


prompt pregunta 4 desde root empleando alter session
----------------------------------------------------
alter session set container=cdb$root;
show con_id
show con_name

prompt pregunta 4 desde jbadip03_s1 empleando alter session
----------------------------------------------------
alter session set container=jbadip03_s1;
show con_id
show con_name

prompt pregunta 4 desde jbadip03_s2 empleando alter session
----------------------------------------------------
alter session set container=jbadip03_s2;
show con_id
show con_name

pause Analizar resultados [enter] para continuar

Prompt pregunta 5, conectando a jbadip03_s1, creando una tabla
----------------------------------------------------
alter session set container=jbadip03_s1;
create user jorge07 identified by jorge quota unlimited on users;
grant create session,create table to jorge07;
create table jorge07.test(id number);

Prompt pregunta 5, conectando a jbadip03_s2, creando una tabla
----------------------------------------------------
alter session set container=jbadip03_s2;
create user jorge07 identified by jorge quota unlimited on users;
grant create session,create table to jorge07;
create table jorge07.test(id number);

prompt pregunta 5, creando un nuevo registro en  jbadip03_s1 para  jorge07.test
----------------------------------------------------
alter session set container=jbadip03_s1;
--aquí se genera una transacción
insert into jorge07.test values(100);
--TODO: Completar consulta en v$transaction
prompt verificando datos de la transacción desde jbadip03_s1
select xid, con_id,status, start_time  from v$transaction;

Prompt conectando a jbadip03_s2 sin hacer commit de esta transacción
----------------------------------------------------
pause ¿Se podrá hacer switch? [enter] para contunuar
alter session set container=jbadip03_s2;

prompt Verificando transacciones activas desde jbadip03_s2 
select xid, con_id,status, start_time  from v$transaction;

pause ¿fue posible ? [enter] para continuar

prompt intentando insertar en la tabla ¿Se genera otra transacción?
-------------------------------------------------------
insert into jorge07.test values(200);
prompt Verificando transacciones activas desde jbadip03_s2 
select xid, con_id,status, start_time  from v$transaction;
pause ¿fue posible ? [enter] para continuar

prompt conectando nuevamente a jbadip03_s1 ¿qué sucedió con la txn?
-------------------------------------------------------
alter session set container=jbadip03_s1;
prompt Verificando transacciones activas desde jbadip03_s1 
select xid, con_id,status, start_time  from v$transaction;

pause ¿qué mostrará al intentar consultar los datos de la tabla test? [enter]
select * from jorge07.test;


prompt pregunta 6 consulta del ejercicio 1  MD 02-conceptos-basicos.md
--------------------------------------------------------
-- TODO: completar
alter session set container=cdb$root;
prompt desde root
select  o.oracle_maintained, count(*) 
from sys.tab$ t , dba_objects o 
where t.obj#=o.object_id 
group by o.oracle_maintained;

alter session set container=jbadip03_s1;
prompt desde jbadip03_s1;
select  o.oracle_maintained, count(*) 
from sys.tab$ t , dba_objects o 
where t.obj#=o.object_id 
group by o.oracle_maintained;

Pause Analizar resultados


prompt 7 Limpieza
--alter session set container=jbadip03_s1;
drop user jorge07 cascade;
--eliminando en jbadip02_s2
alter session set container=jbadip03_s2;
drop user jorge07 cascade;

pause [enter] para continuar


prompt volviendo a ejecutar consilta de la pregunta 6 
--------------------------------------------------------
alter session set container=cdb$root;
prompt desde root
select  o.oracle_maintained, count(*) 
from sys.tab$ t , dba_objects o 
where t.obj#=o.object_id 
group by o.oracle_maintained;

alter session set container=jbadip03_s1;
prompt desde jbadip03_s1;
select  o.oracle_maintained, count(*) 
from sys.tab$ t , dba_objects o 
where t.obj#=o.object_id 
group by o.oracle_maintained;

Pause Analizar resultados



