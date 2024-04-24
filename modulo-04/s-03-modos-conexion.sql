--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 9 Dec 2023
--@Descripción: ejercicio 3 Configuración modo dedicado y compartido 

prompt configurando modo compartido.
connect sys/system2 as sysdba
set linesize window
prompt Configurando modo compartido

prompt configurando dispatchers
alter system set dispatchers='(ADDRESS=(PROTOCOL=TCP)(PORT=5000))','(ADDRESS=(PROTOCOL=TCP)(PORT=5001))'
  scope=memory;

prompt configurando shared servers
alter system set shared_servers = 3 scope =  memory;

prompt inicando el DRCP por default 
exec dbms_connection_pool.start_pool();

Prompt min pooled servers
exec dbms_connection_pool.alter_param ('','MINSIZE','5');

Prompt max pooled servers
exec dbms_connection_pool.alter_param ('','MAXSIZE','10');

prompt tiempo máximo de vida sin uso en el pool (seg) - 1h
exec dbms_connection_pool.alter_param ('','INACTIVITY_TIMEOUT','3600');
--1 hora de inactividad para cada server processes sin ser asignado a un user p.

prompt tiempo máximo de inactividad del pooled server -5 min
exec dbms_connection_pool.alter_param ('','MAX_THINK_TIME','300');
--ya que el server p fue asignado a un user p tiene 5 minutos de inactividad máximo


Prompt Mostrando  db_domain:
show parameter db_domain

Prompt Notificando al listener los servicios disponibles
alter system register;

prompt mostrando los servicios que ofrece el listener
!lsnrctl services

pause Abrir netmgr, agregar nombres de servicio en tnsnames.ora [Enter] al terminar
Pause  Explorar tnsnames.ora, [Enter] al terminar
--con usuario oracle usar el comando netmgr
--pc-joba.fi.unam hostname
--jbadip02.fi.unam service name

prompt probando conexión en modo dedicado
connect sys/system2@JBADIP02_DEDICATED as sysdba
select sysdate from dual;
pause [Enter] para continuar



prompt probando conexión en modo compartido
connect sys/system2@JBADIP02_SHARED as sysdba
select sysdate from dual;
pause [Enter] para continuar


prompt mostrando datos de v$circuit
select circuit,dispatcher,status, bytes/1024 kbs from v$circuit;

prompt probando conexión en modo pooled
connect sys/system2@JBADIP02_POOLED as sysdba
select sysdate from dual;
pause [Enter] para continuar