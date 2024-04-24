--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 26 2024
--@Descripción: ejercicio 4 realizar configuraciones y probar el flashback table

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define user='jorge06'


prompt 1. conectando como jorge06
connect &user/&user

prompt creando tabla
create table venta(idVenta number(2), monto number(10,2) );

exec dbms_lock.sleep(5);

prompt 2. configurando tabla con enable row movement

alter table venta enable row movement;

exec dbms_lock.sleep(5);


prompt 3. tomando scn actual y tiempo

select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora1,
dbms_flashback.get_system_change_number() scn1 from dual;
exec dbms_lock.sleep(5);

prompt 4. agregar primer registro a la tabla venta
insert into venta values(1,10);

commit;
exec dbms_lock.sleep(5);


prompt 5. tomando tiempo  y scn
select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora2,
dbms_flashback.get_system_change_number() scn2 from dual;
exec dbms_lock.sleep(5);


prompt 6. repitiendo paso 4 y 5 dos veces
insert into venta values(2,11);

select * from venta;
commit;
exec dbms_lock.sleep(5);

select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora3,
dbms_flashback.get_system_change_number() scn3 from dual;




insert into venta values(3,100000);

select * from venta;
commit;
exec dbms_lock.sleep(5);

select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora4,
dbms_flashback.get_system_change_number() scn4 from dual;

prompt 7. Mostrando datos de tabla, eliminando y confirmando cambios

prompt mostrando
select * from venta;
prompt borrando
delete from venta;

commit;
exec dbms_lock.sleep(5);

prompt mostrando

select * from venta;

prompt 8.tomando hora y scn

select  to_char(sysdate,'dd-mm-yyyy hh24:mi:ss') fechaHora5,
dbms_flashback.get_system_change_number() scn5 from dual;

prompt 9.
prompt con scn 
flashback table venta  to scn &scn;
select * from venta;


prompt con fecha hora
flashback table venta to timestamp  to_timestamp('&fechaHora','dd-mm-yyyy hh24:mi:ss');
select * from venta;

prompt 10. mostrando tabla por ultima vez

select * from venta;


exit

