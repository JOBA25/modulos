--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 8 Enero 2024

prompt probando conexión en modo dedicado usuario sys 
connect sys/system2@dip_de as sysdba
select sysdate from dual;
pause [Enter] para continuar



prompt probando conexión en modo compartido usuario sys
connect sys/system2@dip_sh as sysdba
select sysdate from dual;
pause [Enter] para continuar



prompt probando conexión en modo pooled usuario sys
connect sys/system2@dip_pooled as sysdba
select sysdate from dual;


prompt probando conexión en modo dedicado usuario usuario 
connect usuario/usuario@dip_de 
select sysdate from dual;
pause [Enter] para continuar



prompt probando conexión en modo compartido usuario usuario
connect usuario/usuario@dip_sh 
select sysdate from dual;
pause [Enter] para continuar



prompt probando conexión en modo pooled usuario usuario
connect usuario/usuario@dip_pooled 
select sysdate from dual;