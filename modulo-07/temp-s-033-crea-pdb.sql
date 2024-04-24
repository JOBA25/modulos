--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio clonar un pdb desde otra que se encuentre en otra cdb
spool /unam-diplomado-bd/modulos/modulo-07/s-033-crea-pdb-spool.txt

prompt Hacer Clon jbadip03_s1 -> jbadip04_s2  Ahora con DB links

prompt Iniciando jbadip03
!sh s-030-start-cdb.sh jbadip03 system3

prompt Iniciando jbadip04
!sh s-030-start-cdb.sh jbadip04 system4

prompt conectando a jbadip03
connect sys/system3@jbadip03 as sysdba

-- TODO: Crear un usuario en común (nivel CDB) para realizar conexiones a través
-- de un DB link
prompt creando usuario en jbadip03
create user c##jorge_remote identified by jorge container=all ;
grant create session, create pluggable database to c##jorge_remote container=ALL;


prompt conectando a jbadip04 para crear DB Link
--TODO:  realizar la conexión

!echo "ORACLE_SID= $ORACLE_SID"
prompt es correcto el valor ¿?
pause [enter] para continuar
connect sys/system4 as sysdba


--TODO: Crear el DB Link, agregar el alias de servicio de ser necesario
create database link clone_link
    connect to c##jorge_remote identified by jorge
    using 'JBADIP03';

prompt Creando pdb jbadip04_s2
--TODO:  clonar la PDB en  jbadip04_s2
create pluggable database jbadip04_s2
 from jbadip03_s1@clone_link
 file_name_convert=(
    '/u01/app/oracle/oradata/JBADIP03/jbadip03_s1',
    '/u01/app/oracle/oradata/JBADIP04/jbadip04_s2'
 );

prompt Abriendo y verificando la nueva pdb
alter pluggable database jbadip04_s2 open read write;
show pdbs

Prompt mostrando datafiles de la CDB
set linesize window
col file_name format A60
select file_id, file_name from cdb_data_files;

pause Analizar resultados, [Enter] para continuar con Limpieza

prompt borrar PDB
alter pluggable database jbadip04_s2 close;
drop  pluggable database jbadip04_s2 including datafiles;

drop database link clone_link;

prompt eliminando usuario en jbadip03
connect sys/system3@jbadip03 as sysdba

--TODO: ELiminar al common usuario 

drop user c##jorge_remote cascade;

spool off
exit


 