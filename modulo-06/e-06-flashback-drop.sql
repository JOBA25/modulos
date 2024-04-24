--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 26 2024
--@Descripción: ejercicio 5 realizar configuraciones y probar el flashback drop
--utilizando datos UNDO y la Recycle Bin
set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define user='jorge06'

prompt conectando como sys
connect &syslogon

prompt 1. Activando la papelera de reciclado y verificando contenido
alter session set recyclebin=on;
col object_name format a35
col original_name format a35

select object_name, original_name, CREATETIME 
from recyclebin;


prompt 2.Conectando con usario jorge06

connect &user/&user


prompt creando tabla fb_drop
create table fb_drop(id number(2), dato varchar2(10) );

prompt insertando registros
insert into fb_drop values(1,'dato1');
insert into fb_drop values(2,'dato2');
insert into fb_drop values(3,'dato3');
insert into fb_drop values(4,'dato4');
commit;

prompt mostrando contenido
select * from fb_drop;

prompt 3. eliminando tabla 

Drop table fb_drop;

prompt verificando borrado
select * from fb_drop;

prompt 4. Mostrando contenido de papelera
col object_name format a35
col original_name format a35
select object_name, original_name, CREATETIME 
from recyclebin;


prompt 5. Mostrando contenido 

select * from "&object_name";

pause [enter]

prompt 6. Recuperando tabla eliminada
flashback table fb_drop to before drop;
prompt mostrando contenido
select * from fb_drop;

prompt 7.eliminando nuevamente la tabla 

Drop table fb_drop;

prompt verificando borrado
select * from fb_drop;

prompt 8. Crear la misma tabla con datos distintos

create table fb_drop(id number(2), dato varchar2(10) );

prompt insertando registros
insert into fb_drop values(5,'dato5');
insert into fb_drop values(6,'dato6');
insert into fb_drop values(7,'dato7');
insert into fb_drop values(8,'dato8');
commit;

prompt mostrnado nueva tabla
select * from fb_drop;

prompt 9. consultando papelera
col object_name format a35
col original_name format a35
select object_name, original_name, CREATETIME 
from recyclebin;


prompt 10. Elimnar nuevamente y verificar 
Drop table fb_drop;

prompt verificando borrado
select * from fb_drop;

prompt 11.consultando papelera
col object_name format a35
col original_name format a35
select object_name, original_name, CREATETIME 
from recyclebin;


prompt 12.Recuperando las tablas 
flashback table "&object_name1" to before drop rename to fb_drop1;

prompt consultando fb_drop1
select * from fb_drop1;

flashback table "&object_name2" to before drop rename to fb_drop2;

prompt consultando fb_drop1
select * from fb_drop2;

prompt 13. Desactivar la papelera


alter session set recyclebin=off;
connect &user/&user



prompt 14.eliminando ambas tablas
drop table fb_drop1;
drop table fb_drop2;
purge recyclebin;

prompt verificando que ya no existe la papelera

select object_name, original_name, CREATETIME 
from recyclebin;


exit;