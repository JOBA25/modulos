--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 8 Enero 2024

set linesize window

connect sys/system2 as sysdba 
Prompt A- mostrando principales parámetros del modo compartido 

show parameter shared_servers

show parameter max_shared_servers

show parameter shared_server_sessions

show parameter dispatchers

show parameter max_dispatchers

show parameter circuits

Prompt B- Mostrando principales parámetros del modo pooled  dentro de la vista dba_cpool_info
col CONNECTION_POOL format a30
select * from dba_cpool_info;


prompt C- mostrando procesos tipo Server processes
!ps -ef | grep -e jbadip02 -e sqlplus | grep -v ora_ | grep -v grep


prompt D- mostrando procesos tipo Background processes
!ps -ef | grep -e jbadip02 -e sqlplus | grep -e ora_ | grep -v grep

Prompt E- Mostrando info de conexiones 
col USERNAME format a30
select sid, P.serial#, PADDR, STATUS, SERVER, PROCESS,PGA_MAX_MEM, S.USERNAME
from v$session S
left join v$process P
on S.SADDR  = P.ADDR;