--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 26 2024
--@Descripción: ejercicio 2 uso de flashback query
set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define user='user06'


prompt conectando como sys
connect &syslogon


Prompt 1. creando usuario user06
create user &user identified by &user quota unlimited on users;

grant dba  to &user;

prompt 2. conectando como user06
connect &user/&user

prompt 3. creando tabla fb_query;
create table fb_query(id number(2), name varchar2(10));

prompt insertando 3 registros en fb_query

insert into fb_query values(1,'Jorge');
insert into fb_query values(2,'Danna');
insert into fb_query values(3,'Tavo');
commit;

prompt Mostrando datos de fb_query

select * from fb_query;

prompt esperando
exec dbms_lock.sleep(5);

prompt 4. Obtener el SCN y la marca de tiempo
select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora1
from dual;

select current_scn scn1 from v$database;

prompt 5. modificando datos en fb_query

update fb_query set name = 'cambio1' where id =1;
commit;
prompt Mostrando datos de fb_query

select * from fb_query;

prompt 6. Obtener el SCN y la marca de tiempo nuevamente
select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora2
from dual;
select current_scn scn2 from v$database;

prompt 7 eliminando registro de fb_query

delete from fb_query 
where id = 1;
commit;


prompt esperando
exec dbms_lock.sleep(5);

prompt 8. Obtener el SCN y la marca de tiempo nuevamente
select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora3
from dual;
select current_scn scn3 from v$database;

prompt 9. Mostrando info en diferentes momentos
select * from fb_query as of 
timestamp to_timestamp('&fechaHora1','dd-mm-yyyy hh24:mi:ss');


select * from fb_query as of scn &scn3;

prompt 10 recuperado 

insert into fb_query
select * from fb_query as of '&scn2'
where id=1;


prompt Mostrando datos de fb_query

select * from fb_query










