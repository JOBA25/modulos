--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 8 Dec 2023
--@Descripción: ejercicio 2. Sesiones y conexiones

prompt conectando como sysdba
connect sys/system2 as sysdba
set linesize window
prompt creando user04

create user user04 identified by user04 quota unlimited on users;
grant create table, create session to user04;

pause Abrir nueva terminal, crear una nueva sesión como user04, [Enter] al terminar.

prompt mostrando datos de las sesiones de user04
col username format a30
select username, sid, serial#, server, paddr, status
from v$session
where username = 'USER04';


pause Analizar resultados, [Enter] para continuar

prompt configurando el rol plustrace
--@?/sqlplus/admin/plustrce.sql

prompt otorgando el rol plustrace a user04
grant plustrace to user04;

prompt En T2 reiniciar la sesión y habilitar el modo autotrace statistics
pause [Enter] al terminar
/* en T2 ejecutar:
  disconnect
  connect user04/user04
  set autotrace on statistics

*/
prompt mostrando datos de las sesiones creadas para user04
--2
select username, sid, serial#, server, paddr, status
from v$session
where username = 'USER04';

prompt ¿Qué diferencias se observan respecto a la primera consulta ?
pause [Enter] para continuar

pause En T2 deshabilitar la recolección automática de estadísticas [Enter] al terminar

prompt Mostrando datos de las sesiones nuevamente 
pause ¿Cuántos registros se esperan? [Enter] para continuar
--1
select username, sid, serial#, server, paddr, status
from v$session
where username = 'USER04';
pause Analizar resultados [Enter] para continuar


/*
 Para cerrar la sesión y mantener la conexión, en T2 ejecutar disconnect
*/
pause en T2 cerrar sesión, dejar la conexión de user04 activa [Enter] al terminar

prompt mostrando nuevamente las sesiones para user04 
--0
pause ¿Cuántos registros se esperan?  [Enter] para continuar
select username, sid, serial#, server, paddr, status
from v$session
where username = 'USER04';
pause Analizar resultados [Enter] para continuar

--Para esta consulta, el alumno deberá proporcionar el valor de PADDR
--obtenido en la última consulta donde la sesión aún existía, empleando para
--ello la variable de sustitución p_paddr
prompt mostrando los datos de la conexión, proporcionar el valor de PADDR
select sosid, username, program 
from v$process 
where addr = hextoraw('&p_paddr'); 
pause Analizar resultados [Enter] para continuar

--de forma simular, el alumno ahora deberá proporcionar el valor de la columna
--sosid empleando la variable de sustitución p_sosid
prompt mostrando los datos del server process a nivel s.o. Especificar SOSID
!ps -ef | grep -e &p_sosid  | grep -v grep

pause Realizar limpieza, [Enter] para continuar
drop user user04 cascade;
