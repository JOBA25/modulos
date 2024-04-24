--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--
spool /unam-diplomado-bd/modulos/modulo-07/s-034-crea-pdb-spool.txt

prompt Hacer Clon jbadip02 -> jbadip03_s3  Ahora con DB links

prompt Iniciando jbadip03
!sh s-030-start-cdb.sh jbadip03 system3

prompt Iniciando jbadip02
!sh s-030-start-cdb.sh jbadip02 system2

prompt conectando a jbadip02
connect sys/system2@JBADIP02 as sysdba

-- TODO: Crear un usuario en común (nivel CDB) para realizar conexiones a través
-- de un DB link
prompt creando usuario en jbadip02
create user jorge_remote identified by jorge ;
grant create session, create pluggable database to jorge_remote ;
alter system set encryption wallet open identified by "wallet_password";

prompt conectando a jbadip03 para crear DB Link
--TODO:  realizar la conexión

pause [enter] para continuar
connect sys/system3@jbadip03 as sysdba


--TODO: Crear el DB Link, agregar el alias de servicio de ser necesario
create database link clone_link
    connect to jorge_remote identified by jorge
    using 'JBADIP02';

prompt Creando pdb jbadip03_s3
--TODO:  clonar la PDB en  jbadip03_s3
create pluggable database jbadip03_s3
 from jbadip02@clone_link
 file_name_convert=(
    '/u01/app/oracle/oradata/JBADIP02',
    '/u01/app/oracle/oradata/JBADIP03/jbadip03_s3'
 );

alter session set container=jbadip03_s3;


prompt ejecutando el script noncdb_to_pdb.SQL
@$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql


prompt Abriendo y verificando la nueva pdb
alter pluggable database jbadip03_s3 open read write;
show pdbs

Prompt mostrando datafiles de la CDB
set linesize window
col file_name format A60
select file_id, file_name from cdb_data_files;

pause Analizar resultados, [Enter] para continuar con Limpieza

prompt borrar PDB
alter pluggable database jbadip03_s3 close;
drop  pluggable database jbadip03_s3 including datafiles;

drop database link clone_link;

prompt eliminando usuario en jbadip03
connect sys/system2@jbadip02 as sysdba

--TODO: ELiminar al common usuario 

drop user jorge_remote cascade;

spool off
exit


 