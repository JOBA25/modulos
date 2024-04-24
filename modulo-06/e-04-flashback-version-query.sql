--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 26 2024
--@Descripción: ejercicio 3 flashback version query

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define user='jorge06'


prompt 1. conectando como jorge06
connect &user/&user



prompt Creando la tabla fb_version
create table fb_version(id number(2), dato varchar2(15), fechaHora varchar2(30));

exec dbms_lock.sleep(5);

prompt insertando tres registros
insert into fb_version values(1, 'valor1', to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss'));
insert into fb_version values(2, 'valor2', to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss'));
insert into fb_version values(3, 'valor3', to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss'));
commit;

prompt mostrando info
select * from fb_version; 

prompt 2. configurando el scn actual
select current_scn scn1 from v$database;

exec dbms_lock.sleep(5);

prompt 3. realizando actualización

update fb_version set dato = 'cambio1', fechaHora=to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')
where id=1;
commit;

prompt mostrando info
select * from fb_version; 
exec dbms_lock.sleep(5);

prompt 4. realizando nuevo cambio

update fb_version set dato = 'cambio2', fechaHora=to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')
where id=1;
commit;

prompt mostrando info
select * from fb_version; 
exec dbms_lock.sleep(5);

prompt 5. eliminando registro 
delete from fb_version where id = 1;
commit;

prompt mostrando info
select * from fb_version; 
exec dbms_lock.sleep(5);


prompt 6. obteniendo scn actual

select current_scn scn2 from v$database;

prompt 7. Mostrando el historico de los eventos en la tabla
prompt consulta con fechaHora

select *
from fb_version
versions between timestamp minvalue and maxvalue
where id = 1;


prompt consulta con scn
select *
from fb_version
versions between scn &scn1 and &scn2
where id = 1;

exit