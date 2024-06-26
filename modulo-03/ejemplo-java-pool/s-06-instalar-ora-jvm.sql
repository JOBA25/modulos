--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 24 2023
--@Descripción: ejercicio 6 instalando oracle jvm

prompt conectando como sys
connect sys/system2 as sysdba

Prompt instalando Oracle JVM

alter system set "_system_trig_enabled" = false scope=memory;
@?/javavm/install/initjvm.sql
@?/rdbms/admin/catjava.sql

Prompt comprobando la instalación, El status debe ser  VALID

col comp_name format a30
col status format a15
select comp_name, version, status from dba_registry 
where comp_name like '%JAVA%' ;

Prompt mostrando objetos de la instalación
select count(*), object_type from all_objects
   where object_type like '%JAVA%' group by object_type;

Pause Listo! Reiniciando instancia, [enter] para continuar
shutdown immediate
startup

