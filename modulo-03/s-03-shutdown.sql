--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 24 2023
--@Descripción: ejercicio 3 modos de shutdown

define syslogon='sys/system2 as sysdba'

Prompt conectando como sys
connect &syslogon

declare
  v_count number;
begin
  select count(*) into v_count from dba_users where username='USER01';
  if v_count > 0 then
    execute immediate 'drop user user01 cascade';
  end if;
end;
/


Prompt creando usuario de prueba
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;

col username format a10
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

pause Realizar shutdown abort - Ejecutar scripts en terminales [Enter] para continuar
Prompt mostrando datos de sesiones
select s.sid,s.serial#,s.username,s.logon_time,t.xid,t.start_date
from  v$session s
left outer join v$transaction t
  on s.saddr = t.ses_addr
where username is not null;

shutdown abort

--------------------------------------
Prompt iniciando nuevamente
startup

pause Realizar shutdown immediate - Ejecutar scripts en terminales [Enter] para continuar
Prompt mostrando datos de sesiones
select s.sid,s.serial#,s.username,s.logon_time,t.xid,t.start_date
from v$session s 
left outer join v$transaction t
  on s.saddr= t.ses_addr
where username is not null;

shutdown immediate

----------------------------------------
Prompt iniciando nuevamente
startup

pause Realizar shutdown transactional - Ejecutar scripts en terminales [Enter] para continuar
Prompt mostrando datos de sesiones
select s.sid,s.serial#,s.username,s.logon_time,t.xid,t.start_date
from v$session s 
left outer join v$transaction t
  on s.saddr= t.ses_addr
where username is not null;

Prompt ¿Qué cambios mínimos se tendrían que hacer para que shutdown transactional termine?
--la transacción del script 3c debe hacer commit
shutdown transactional

------------------------------------------
Prompt iniciando nuevamente
startup

pause Realizar shutdown normal - Ejecutar scripts en terminales [Enter] para continuar
Prompt mostrando datos de sesiones

select s.sid,s.serial#,s.username,s.logon_time,t.xid,t.start_date
from v$session s 
left outer join v$transaction t
  on s.saddr= t.ses_addr
where username is not null;

Prompt ¿Qué  cambios se tendrían que hacer para que shutdown normal termine?
--todos los usarios deben salir de sesion
shutdown normal

Prompt reiniciando para realizar limpieza
startup
drop user user01 cascade;

Prompt Listo!
