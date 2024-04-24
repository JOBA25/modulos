--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio hacer una pdb proxy
spool /unam-diplomado-bd/modulos/modulo-07/s-037-crea-pdb-spool.txt
Prompt Creando proxy PDB

Prompt iniciar jbadip03
!sh s-030-start-cdb.sh jbadip03 system3

Prompt iniciar jbadip04
!sh s-030-start-cdb.sh jbadip04 system4

Prompt Preparando jbadip03_s2

connect sys/system3@jbadip03 as sysdba

prompt creando common user 
create user c##jorge_remote identified by jorge container=all;
grant create session,create pluggable database to c##jorge_remote
  container=all;

Prompt Abriendo PDB
alter pluggable database jbadip03_s2 open read write;

alter session set container=jbadip03_s2;

--TODO Crear un tablespace de prueba
create tablespace test_proxy_ts
datafile '/u01/app/oracle/oradata/JBADIP03/jbadip03_s2/test_proxy_ts.dbf'
size 1M autoextend on next 1M;

Prompt Creando un usuario de prueba
create user jorge_proxy identified by jorge 
 default tablespace test_proxy_ts
 quota unlimited on test_proxy_ts;

grant create session, create table to jorge_proxy;

Prompt creando tabla  test_proxy

create table jorge_proxy.test_proxy(id number);

Prompt insertando datos de prueba

insert into jorge_proxy.test_proxy values (1);
commit;

select * from jorge_proxy.test_proxy;

pause Revisar datos, [Enter] para continuar

Prompt conectando  a jbadip04 para crear liga y proxy PDB
connect sys/system4@jbadip04 as sysdba

Prompt creando liga
--TODO: Crear  liga
create database link clone_link
    connect to c##jorge_remote identified by jorge
    using 'JBADIP03_S2';


Prompt creando Proxy PDB
-- TODO: Creando proxy PDB
create pluggable database jbadip04_p1 as proxy
  from jbadip03_s2@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/JBADIP03/jbadip03_s2',
    '/u01/app/oracle/oradata/JBADIP04/jbadip04_p1'
  );
  

pause Probando proxy PDB [Enter] para continuar

Prompt abrir la proxy PDB
alter pluggable database jbadip04_p1 open read write;

Prompt accediendo a jbadip03_s2 a través de la Proxy PDB
connect jorge_proxy/jorge@jbadip04_p1

Prompt mostrando dastos desde proxy
--TODO: Mostrar los datos desde proxy

select * from test_proxy;

Prompt insertando datos desde proxy
--TODO: Insetar los datos desde proxy
insert into test_proxy values(2);
commit;


select * from test_proxy;


Prompt validando en jbadip03_s2
connect sys/system3@jbadip03_s2 as sysdba

select * from jorge_proxy.test_proxy;

pause Analizar resultados [Enter] para hacer limpieza

prompt limpieza en jbadip03_s2
alter session set container=cdb$root;
drop user c##jorge_remote cascade;

--eliminar tablespace
alter session set container=jbadip03_s2;
drop tablespace test_proxy_ts including contents and datafiles;

--eliminar al usuario jorge_proxy
drop user jorge_proxy cascade;

Prompt limpieza en jbadip04
connect sys/system4@jbadip04 as sysdba

alter pluggable database jbadip04_p1 close immediate;
drop pluggable database jbadip04_p1 including datafiles;

drop database link clone_link;













