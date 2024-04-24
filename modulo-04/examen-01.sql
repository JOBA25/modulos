--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 8 Enero 2024


connect sys/system2 as sysdba 

prompt creando usuarios
create user usuario identified by usuario quota unlimited on users;
grant create table, create session to usuario;



prompt configurando dispatchers
alter system set dispatchers='(ADDRESS=(PROTOCOL=TCP)(PORT=5000))','(ADDRESS=(PROTOCOL=TCP)(PORT=5001))'
  scope=both;

prompt configurando shared servers
alter system set shared_servers = 3 scope =  both;

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