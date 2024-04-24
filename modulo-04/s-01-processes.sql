--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 8 Dec 2023
--@Descripción: ejercicio 1 tipos de procesos

set linesize window

prompt mostrando user y server processes con instancia detenida, nadie empleando sqlplus
!ps -ef | grep -e jbadip02 -e sqlplus | grep  -v grep

--prompt accediendo a sqlplus sin autenticar
--sqlplus /nolog

pause Mostrando muevamente los procesos. ¿Qué debería mostrarse? [Enter] para continuar
!ps -ef | grep -e jbadip02 -e sqlplus | grep -v grep

prompt conectando como sysdba
connect sys/system2 as sysdba 
--archivo de passwords

pause Mostrando nuevamente los procesos [Enter] para continuar
--user proces server process
--no background proces
!ps -ef | grep -e jbadip02 -e sqlplus | grep -v grep 


prompt Mostrando el proceso asociado con el listener
!ps -ef | grep -e listener | grep -v grep


pause Analizar resultado, [Enter] para continuar
prompt iniciando instancia en modo nomount

startup nomount
pause Mostrando procesos. ¿ Qué se obtendrá? [Enter] para continuar
!ps -ef | grep -e jbadip02 -e sqlplus | grep -v grep

pause Analizar resultado, [Enter] para continuar

prompt abriendo BD.
alter database mount; 
alter database open;

prompt cerrando sesión como sysdba
disconnect 

prompt creando una nueva sesión como sysdba
connect sys/system2 as sysdba

prompt mostrando los procesos de esta nueva conexión a nivel s.o.
!ps -ef | grep -i -e "local=yes" -e sqlplus | grep -v grep
--conexion local

prompt Anotar los IDs de los procesos En SQL Developer ejectuar el reporte. 
pause Presionar [Enter] hasta que se haya visualizado el reporte.


/**
select sosid,pid,pname,username,program,tracefile,background,
 trunc(pga_used_mem/1024/1024,2) pga_used_mem_mb
from v$process where sosid in('43037','40738');

*/