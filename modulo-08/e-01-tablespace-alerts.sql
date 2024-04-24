--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: 
--@Descripción: ejercicio 1 configuración de alertas
define syslogon='sys/system2 as sysdba'
define t_user='jorge08'
define t_userlogon='&t_user/&t_user'

set linesize window
spool /unam-diplomado-bd/modulos/modulo-08/s-01-alertas.txt
Prompt conectando como sys

connect &syslogon

Prompt creando usuario  &t_user en caso de no existir

declare
  v_count number;
begin
  select count(*) into v_count 
  from all_users
  where username=upper('&t_user');
  if v_count > 0 then
    execute immediate 'drop user &t_user cascade';
  end if;
end;
/

Prompt creando un nuevo TS
create tablespace m08_alerts_tbs
  datafile '/u01/app/oracle/oradata/JBADIP02/m08_alerts_tbs01.dbf'
    size 25m
  extent management local
    autoallocate
  segment space management auto;

Prompt creando usuario &t_user
create  user &t_user identified by &t_user  quota unlimited on users;
alter user &t_user quota unlimited on m08_alerts_tbs;
grant create session, create table to &t_user;

Prompt configurando alertas 
begin
  dbms_server_alert.set_threshold(
    metrics_id              => DBMS_SERVER_ALERT.TABLESPACE_BYT_FREE,
   warning_operator        => DBMS_SERVER_ALERT.OPERATOR_LE,
   warning_value           => '9240',
   critical_operator       => DBMS_SERVER_ALERT.OPERATOR_LE,
   critical_value          => '4048',
   observation_period      => 1,
   consecutive_occurrences => 1,
   instance_name           => null,
   object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_TABLESPACE,
   object_name             => 'M08_ALERTS_TBS'
    );
--configurando con porcentaje
dbms_server_alert.set_threshold(
   metrics_id              => DBMS_SERVER_ALERT.TABLESPACE_PCT_FULL,
   warning_operator        => DBMS_SERVER_ALERT.OPERATOR_GT,
   warning_value           => '70',
   critical_operator       => DBMS_SERVER_ALERT.OPERATOR_GT,
   critical_value          => '85',
   observation_period      => 1,
   consecutive_occurrences => 1,
   instance_name           => null,
   object_type             => DBMS_SERVER_ALERT.OBJECT_TYPE_TABLESPACE,
   object_name             => 'M08_ALERTS_TBS'
   );
end;
/

----Tarea proponer otra alerta

Prompt poblando tablespace

create table &t_user..mensaje(str char(1024)) nologging tablespace m08_alerts_tbs;

declare
  v_iter number:= 20*1000;
begin 
  for r in 1..v_iter loop
    insert /*+ append */ into &t_user..mensaje values('A');
  end loop;
end;
/
-- en algunos casos hay que esperar más tiempo para que aparezcan las métricas
Prompt esperando un minuto 130 seg
exec dbms_session.sleep(130);

commit;
col object_name format a20
col object_type format a15
col reason format a30
col suggested_action format a30
col time_suggested format a15
prompt mostrando alertas existentes

connect &syslogon

select object_name,object_type,reason,time_suggested,suggested_action,
  metric_value,message_type
from dba_outstanding_alerts;

pause [Enter] para limpieza 


Prompt reestableciendo alertas 
begin
dbms_server_alert.set_threshold(
    metrics_id            =>    dbms_server_alert.tablespace_byt_free,
    warning_operator      =>    null,
    warning_value         =>    null,
    critical_operator     =>    null,
    critical_value        =>    null,
    observation_period    =>    1,
    consecutive_occurrences =>  1,
    instance_name           => null,
    object_type           =>    dbms_server_alert.object_type_tablespace,
    object_name           =>     'M08_ALERTS_TBS'
  );
end;
/
prompt eliminando TS
drop tablespace m08_alerts_tbs including contents and datafiles;