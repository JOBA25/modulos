--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio hacer unplug y plug de una pdb
spool /unam-diplomado-bd/modulos/modulo-07/s-035-crea-pdb-spool.txt

Prompt hacer unplug en jbadip03_s3  -> plug en jbadip04_s3

--directorios donde están los datafiles
define unplug_jbadip03_s3='/u01/app/oracle/oradata/JBADIP03/jbadip03_s3'
define plug_jbadip04_s3='/u01/app/oracle/oradata/JBADIP04/jbadip04_s3'
define jbadip03_seed='/u01/app/oracle/oradata/JBADIP03/pdbseed'

prompt Iniciar jbadip03
!sh s-030-start-cdb.sh jbadip03 system3

Prompt Connectar a jbadip03 a cdb$root
connect sys/system3@jbadip03 as sysdba

Prompt Crear PDB  jbadip03_s3  a partir de Seed
--TODO: crear PDB 
create pluggable database jbadip03_s3 
    admin user admin_s3 identified by admin_s3
    file_name_convert=(
        '&jbadip03_seed' ,
        '&unplug_jbadip03_s3'
    );

Prompt hacer unplug de  jbadip03_s3, no se requiere cerrarla ya que no ha sido abierta
--TODO: realizar unplug
alter pluggable database jbadip03_s3 unplug
    into '&unplug_jbadip03_s3/jbadip03_s3.xml';



Prompt Mostrando datos de las PDBs
show pdbs

Prompt  Mostrando datos de las PDBs  (dba_pdbs)
col pdb_name format a30
select pdb_id,pdb_name,status from dba_pdbs;
pause Analizar [enter] para continuar

prompt mostrando metadatos
!sudo chmod 777 &unplug_jbadip03_s3/jbadip03_s3.xml
!cat &unplug_jbadip03_s3/jbadip03_s3.xml

pause Revisar XML, revisar rutas [enter] para continuar


prompt El siguiente paso es hacer plug en jbadip04

prompt Iniciar jbadip04
!sh s-030-start-cdb.sh jbadip04 system4

prompt  Validar compatibilidad, conectando a jbadip04
connect sys/system4@jbadip04 as sysdba 

show con_id
show con_name 
-- TODO: Agregar programa PL/SQL
set serveroutput on
declare
  v_compatible boolean;
begin
  v_compatible := dbms_pdb.check_plug_compatibility(
    pdb_descr_file => '&unplug_jbadip03_s3/jbadip03_s3.xml'
    pdb_name => 'jbadip03_s3'
  );
    if v_compatible then
        dbms_output.put_line('PDB jbadip03_s3 es compatible con jbadip04');
    else
        raise_application_error(-20001, 'PDB jbadip03_s3 NO es compatible con jbadip04')
    end if;
end;
/


pause Validar resultados [enter] para continuar

prompt agregar la nueva PDB
---------------------------------------------------
create pluggable database jbadip04_s3 
    using  '&unplug_jbadip03_s3/jbadip03_s3.xml'
    file_name_convert=(
        '&unplug_jbadip03_s3',
        '&plug_jbadip04_s3'
    );
------------------------------------------------------------

prompt mostrando datafiles en origen

!sudo ls -l &unplug_jbadip03_s3/

pause [Enter] para continuar


prompt mostrando datos de las PDBS

show pdbs

select pdb_id,pdb_name,status from dba_pdbs;
pause Analizar [enter] para continuar

prompt Abriendo jbadip04_s3
alter pluggable database jbadip04_s3 open read write;

prompt conectar a jbadip04_s3
alter session set container=jbadip04_s3;

prompt mostrando datos de la nueva PDB
show con_id
show con_name

pause Analizar resultado [Enter] para comenzar con Limpieza
-----------------------------------------------------------

----TAREA: Cambiar esta técnica. Es decir, hacer:
---- unplug jrcdip04_s3 --->  plug jrcdip03_s3


Prompt eliminar jbadip03_s3
connect sys/system3@jbadip03 as sysdba 
alter pluggable database jbadip03_s3 close;
drop pluggable database jbadip03_s3 including datafiles;



Prompt eliminar jbadip04_s3
connect sys/system4@jbadip04 as sysdba 
alter pluggable database jbadip04_s3 close;
drop pluggable database jbadip04_s3 including datafiles;
Prompt eliminando archivo XML
!sudo rm &unplug_jbadip03_s3/jbadip03_s3.xml


spool off 
exit