--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 10 2023
--@Descripción: ejercicio 1 creación de usuario


drop user jorge02 cascade;

prompt conectando como sysdba
connect sys/system1 as sysdba

--creando usuario
create user jorge02 identified by jorge quota unlimited on users;

--otorgar privs de sistema
grant create session, create table to jorge02;

prompt entrando a sesión con jorge02
connect jorge02/jorge

prompt creando una tabla de prueba
create table test (id number);

prompt conectando como sysdba
connect sys/system1 as sysdba

prompt verificando privilegios en dba_sys_privs
col grantee format a20
set linesize window
select grantee,privilege, admin_option
from dba_sys_privs
where grantee='JORGE02';

pause actividades de limpieza [Enter] para continuar
drop user jorge02 cascade;
