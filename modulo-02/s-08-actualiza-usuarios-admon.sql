--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 6 archivo de passwords

--alter user sys identified by system1;
connect sys/admin1234# as sysdba

​

prompt 1 consultando la vista v$pwfile_users

col account_status format A20

col username format A20

select * from v$pwfile_users;

​

prompt 2 reasignando privilegios a usuarios

grant sysdba,sysoper, sysbackup to user01;

grant sysdba,sysoper, sysbackup to user02;

grant sysdba,sysoper, sysbackup to user03;

​

prompt 3 consultando la vista v$pwfile_users

col account_status format A20

col username format A20

select * from v$pwfile_users;

​

prompt 4 reasignación de password

alter user sys identified by system1;

​

prompt idempotencia

drop user user01 cascade;

drop user user02 cascade;

drop user user03 cascade;