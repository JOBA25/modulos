connect sys/system1 as sysdba

create user u01 identified by u01 quota 10G on users; 

grant create session, create table, select on admin.t01 to u01;

create table admin.test(id number);

grant sysdba to admin;

select * from dba_sys_privs
where GRANTEE = 'ADMIN';

alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';

alter system set nls_date_format='dd-mm-yyyy hh24:mi:ss'
scope= spfile ;


alter system reset nls_date_format scope=spfile;
revoke sysdba from admin;
drop table admin.test;
drop user u01 cascade;