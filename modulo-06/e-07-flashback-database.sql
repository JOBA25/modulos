--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 26 2024
--@Descripción: ejercicio 6 FB database
set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define user='jorge06'

prompt conectando como sys
connect &syslogon

prompt 1. verificando el scn actual
select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora1,
dbms_flashback.get_system_change_number() scnInicial from dual;
exec dbms_lock.sleep(5);

prompt 2. creando punto de restauración
create restore point punto_rest;

prompt 3. consultando vista v$restore_point
col name format a35
select scn, time, name from v$restore_point;

prompt 4. con el usuario jorge06 crear la tabla fb_database e insertar datos
prompt Conectando con jorge06
connect &user/&user

prompt creando tabla fb_database

create table fb_database(id number(2),dato varchar2(10) );
prompt insertando datos
insert into fb_database values(1,'dato1');
insert into fb_database values(2,'dato2');
insert into fb_database values(3,'dato3');
insert into fb_database values(4,'dato4');
commit;

prompt Mostrando contenido de fb_database

select * from fb_database;

prompt 5. reinicar la base en modo mount
connect &syslogon

shutdown immediate
startup mount

prompt 6. Regresando la BD al punto de restauración
flashback database to restore point punto_rest;

prompt 7. abrir la base y reiniciando redo log
alter database open resetlogs;


prompt 8. Verificando que hay regresado al punto marcado
prompt se espera error 
select * from jorge06.fb_database;

prompt 9. eliminando punto de restauración

drop restore point punto_rest;
exit;
