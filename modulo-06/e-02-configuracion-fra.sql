--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 26 2024
--@Descripción: ejercicio 1 configuración del FRA
set linesize window
set verify off

define syslogon='sys/system2 as sysdba'

prompt conectando como sys
connect &syslogon

prompt 1. verificando el parámetro db_recovery
show parameter db_recovery;

prompt 2. verificando modo archive log habilitado 

archive log list;

pause [Enter] para continuar

prompt 3. especificando tamaño y ubicación de la FRA
alter system set db_recovery_file_dest_size =20G scope=both;

alter system set db_recovery_file_dest = '/unam-diplomado-bd/fast-recovery-area' scope=both ;

prompt 4. reiniciando la BD
shutdown immediate
startup mount

prompt 5. configurando el periodo de retención para flashback
alter system set db_flashback_retention_target=1440 scope=both;

prompt 6. habilitando el modo flashback
alter database flashback on;

prompt 7. abriendo la BD
alter database  open;

prompt 8. Verificando modo flashback activado
select flashback_on from v$database;

prompt 9. mostrando tiempo de retención de datos undo y modicando a 30 mins
show parameter undo_ret;

alter system set undo_retention = 1800;

prompt 10. Mostrando nuevamente tiempo de retención de datos undo
show parameter undo_ret;
