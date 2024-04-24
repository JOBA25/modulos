--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 6 archivo de passwords

--alter user sys identified by system1;

prompt 1 Autenticando como sysdba

connect sys/system1 as sysdba

​

prompt 2 creando usuarios

create user user01 identified by user01;

create user user02 identified by user02;

create user user03 identified by user03;

​

prompt 3 asignando privilegios de administracion

grant sysdba, sysoper, sysbackup to user01;

grant sysdba, sysoper, sysbackup to user02;

grant sysdba, sysoper, sysbackup to user03;

​

prompt 4 consultando vista v$pwfile_users

col account_status format A20

col username format A20

select * from v$pwfile_users;