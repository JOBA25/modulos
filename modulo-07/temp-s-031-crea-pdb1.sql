--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio creacion PDB con OMF


clear screen

--!mkdir -p /unam-diplomado-bd/modulos/modulo-07/e-crea-pdbs
spool /unam-diplomado-bd/modulos/modulo-07/s-031-crea-pdb-jrc-spool.txt
set linesize window
Prompt Creando  CDB a a partir de SEED  (from scratch)

Prompt 1. Iniciando CDB jbadip03
------------------------------------------
!sh s-030-start-cdb.sh jbadip03 system3

Prompt 2. Conectando como SYS en jbadip03
-------------------------------------------
connect sys/system3@jbadip03 as sysdba

Prompt 3. Configurando OMF
------------------------------------------
alter system set db_create_file_dest= '/u01/app/oracle/oradata' scope=memory;
-- TODO: Configurar el parámetro correspondiente para habilitar OMF


Prompt 4. Crear una PDB from scratch (desde cero) empleando OMF
------------------------------------------
--TODO: Empleando OMF, crear la nueva PDB
create pluggable database jbadip03_s3 admin user admin_s3 identified by admin_s3;
--create pluggable database jbadip03_s3 admin user admin_s3 identified by admin_s3;


Prompt Mostrando los datos de las PDBs con SQL*Plus
col file_name format A60

--TODO: Escribir el comando de SQL*Plus que muestra los datos de las PDBs
show pdbs
pause [Enter] para continuar


Prompt 5. Mostrando los datafiles a partir de bda_data_files
--------------------------------------------
select file_id, file_name from dba_data_files;

Prompt Mostrando los datafiles a partir  de cdb_data_files
select file_id, file_name from cdb_data_files;
Prompt Analizar resutados. ¿Qué sucede con los datafiles de la nueva pdb?
pause  [Enter] para continuar
--- Los datos de la nueva PDB no aparecen debido a que no se ha abierto.


Prompt 6. accediendo a la PDB
------------------------------------------

--TODO: Abrir la PDB y acceder
alter pluggable database jbadip03_s3 open;


Prompt 7. Mostrando datafiles de la CDB desde cdb_data_files
------------------------------------------
col file_name format A110
--TODO: Generar la consulta que muestre el id y el nombre del datafile
select file_id, file_name from cdb_data_files;

Prompt 8. Mostrando datos de las PDBs con comando de SQL*Plus
------------------------------------------
show pdbs
pause Analizar [enter] para continuar

--TODO: Mostrar el id y el nombre del contenedor actual
prompt id del contenedor
show con_id

prompt nombre del contenedor
show con_name


Prompt 9. Mostrando datafiles desde la nueva PDB empleando cdb_data_files
------------------------------------------
alter session set container=jbadip03_s3;

select file_id, file_name from cdb_data_files;
--TODO: mostrar id, nombre, con_id del  datafile.


pause 10. [Enter] para comenzar con la limpieza ...
------------------------------------------

prompt Cambiando a cdb$root
alter session set container=cdb$root;

--TODO: Para eliminar una PBD:  1. Cerrarla, 2 Hacer unplug, 3. hacer drop
alter pluggable database jbadip03_s3 close;


--dar permisos de escritura a oracle en la carpeta e-crea-pdbs
!chmod 777 /unam-diplomado-bd/modulos/modulo-07

--TODO: Hacer unplug de la PDB
alter pluggable database jbadip03_s3 unplug 
    into '/unam-diplomado-bd/modulos/modulo-07/metadata-jbadip03_s3.xml';

pause Mostrando contenido de los metadatos [enter] para ejecutar..
!cat /unam-diplomado-bd/modulos/modulo-07/metadata-jbadip03_s3.xml

pause Analizar XML, [enter] para continuar (se eliminarán los archivos)

--TODO: eliminar la PDB.
drop pluggable database jbadip03_s3 including datafiles;

!rm /unam-diplomado-bd/modulos/modulo-07/metadata-jbadip03_s3.xml

--TODO: Hacer limpieza para el parámetro db_create_file_dest

alter system reset db_create_file_dest scope=memory;

Prompt apagando spool
spool off
exit