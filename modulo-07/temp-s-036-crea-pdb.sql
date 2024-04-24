--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio hacer una pdb refresable
spool /unam-diplomado-bd/modulos/modulo-07/s-036-crea-pdb-spool.txt
Prompt Creando PDB tipo refreshable

Prompt iniciar jbadip03
!sh s-030-start-cdb.sh jbadip03 system3

Prompt iniciar jbadip04
!sh s-030-start-cdb.sh jbadip04 system4

Prompt conectando jbadip03
connect sys/system3@jbadip03 as sysdba

prompt abriendo jbadip03_s1
alter pluggable database jbadip03_s1 open read write;

prompt creando un usuario común

create user c##jorge_remote identified by jorge container=all;
grant create table, create session, create pluggable database to c##jorge_remote
container = all; 


----cambiamos a dip04
Prompt conectando a jbadip04 para crear la liga
connect sys/system4@jbadip04 as sysdba

Prompt crear liga

create database link clone_link
    connect to c##jorge_remote identified by jorge
    using 'JBADIP03_S1';


Prompt crear PDB tipo refreshable
---- crear PDB
create pluggable database jbadip04_r3
    from jbadip03_s1@clone_link
    file_name_convert=(
        '/u01/app/oracle/oradata/JBADIP03/jbadip03_s1',
        '/u01/app/oracle/oradata/JBADIP04/jbadip04_r3'
    ) refresh mode manual;




prompt consultando el último refresh
--consultar último refresh
select last_refresh_scn
from dba_pdbs
where pdb_name = 'JBADIP04_R3';

pause Analizar el valor del SCN [enter] para continuar

-----conectando a dip03
Prompt Crear una tabla y un registro en jbadip03_s1
connect sys/system3@jbadip03_s1 as sysdba

----- Crear tablespace
create tablespace test_refresh_ts
datafile '/u01/app/oracle/oradata/JBADIP03/jbadip03_s1/test_refresh_ts.dbf'
size 1M autoextend on next 1M;



Prompt Creando un usuario de prueba *
create user jorge_refresh identified by jorge 
 default tablespace test_refresh_ts
 quota unlimited on test_refresh_ts;

grant create session, create table to jorge_refresh;

Prompt creando tabla  test_refresh

create table jorge_refresh.test_refresh(id number);

Prompt insertando datos de prueba

insert into jorge_refresh.test_refresh values (1);
commit;

select * from jorge_refresh.test_refresh;

pause Revisar tabla y datos creados [Enter] para continuar
Prompt conectando a la jbadip04_r3

---conectando a dip04
connect sys/system4@jbadip04 as sysdba

Prompt abrir jbadip04_r3 en modo read only para hcer refresh
-- Abrir en modo read only
alter pluggable database jbadip04_r3 open read only;

Prompt verificando datos
alter session set container = jbadip04_r3;

pause ¿Qué se obtendría  al intentar consultar la tabla ? [Enter] para continuar

select * from jorge_refresh.test_refresh;

Prompt Hacer refresh (desde root)
--TODO: Agregar las instrucciones necesarias para hacer refresh
alter session set container = cdb$root;
alter pluggable database jbadip04_r3 close immediate;
alter system set db_create_file_dest='/u01/app/oracle/oradata' scope=memory;
alter pluggable database jbadip04_r3 refresh;

Prompt consultando datos nuevamente 
pause ¿qué se esperaría ?[Enter] para continuar
alter pluggable database jbadip04_r3 open read only;

alter session set container = jbadip04_r3;
select * from jorge_refresh.test_refresh;

prompt consultando el último refresh
select last_refresh_scn
from dba_pdbs
where pdb_name='JRCDIP04_R3';


Pause Analizar resultados, [Enter] para realizar limpieza

alter session set container = cdb$root;
alter pluggable database jbadip04_r3 close immediate;
drop pluggable database jbadip04_r3 including datafiles;

drop database link clone_link;

Prompt limpiar al usuario en común
connect sys/system3@jbadip03 as sysdba
drop user c##jorge_remote cascade;

Prompt Eliminar tablespace
--TODO: Eliminar tablespace
alter session set container = jbadip03_s1;
drop tablespace test_refresh_ts including contents and datafiles;

Prompt Eliminar al usuario jorge_refresh
drop user jorge_refresh cascade;

spool off


