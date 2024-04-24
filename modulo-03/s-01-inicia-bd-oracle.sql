--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 24 2023
--@Descripción: ejercicio 1 modos de startup

/*
Detener la instancia
Crear un directorio de respaldos /home/oracle/backups/modulo-03
Para ilustrar los archivos que son requeridos para iniciar, montar y abrir 
una base de datos, el script deberá simular la pérdida de algunos archivos. Para ello, mover los siguientes archivos al directorio de respaldos:

    SPFILE
    PFILE
    Un archivo de control
    REDO logs. ¿Què archivos de REDO se tendrían que mover al directorio 
    de respaldos para que la instancia falle? Discutir la pregunta y mover 
    los archivos correspondientes.
    El datafile del tablespace system
    El datafile del tablespace users

Intentar iniciar, montar y abrir la instancia asumiendo la inexistencia de los archivos anteriores. El comportamiento es la obtención de un error.
Posterior a aparición del error, ejecutar las instrucciones correspondientes para restaurar el o los archivos faltantes y volver a intentar la operación. Ejecutar los pasos 4 y 5 repetidamente hasta que la base de datos pueda ser abierta sin errores.

*/

connect sys/system2 as sysdba
Prompt deteniendo instancia
shutdown immediate

define backup_dir='/home/oracle/backups/modulo-03'
Prompt creando directorio de respaldos
!mkdir -p &backup_dir

Prompt Moviendo spfile y pfile
!mv  $ORACLE_HOME/dbs/spfilejbadip02.ora &backup_dir
!mv  $ORACLE_HOME/dbs/initjbadip02.ora &backup_dir

Prompt Moviendo un solo archivo de control
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/JBADIP02/control01.ctl &backup_dir

Prompt Moviendo un archivo redo log de cada grupo
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/JBADIP02/redo01a.log &backup_dir
!mv /unam-diplomado-bd/disk-02/app/oracle/oradata/JBADIP02/redo01b.log &backup_dir
!mv /unam-diplomado-bd/disk-03/app/oracle/oradata/JBADIP02/redo01c.log &backup_dir

Prompt Moviendo  datafiles
!mv $ORACLE_BASE/oradata/JBADIP02/system01.dbf &backup_dir
!mv $ORACLE_BASE/oradata/JBADIP02/users01.dbf &backup_dir

Prompt mostrando archivos en el directorio de respaldos ( verificar 8 archivos)
!ls -lh &backup_dir

Pause [Archivos en directorio de respaldos, enter para continuar]

Prompt intentando iniciar instancia modo nomount
startup nomount

Pause [Enter para corregir y reintentar]
Prompt restaurando archivos de parámetros
!mv  &backup_dir/spfilejbadip02.ora  $ORACLE_HOME/dbs
!mv  &backup_dir/initjbadip02.ora  $ORACLE_HOME/dbs

Prompt iniciando instancia
startup nomount
pause [¿ Se corrigió el error? Enter para continuar]

Prompt Intentando pasar al modo mount
alter database mount;

pause [Enter para corregir y reintentar]
Prompt restaurando el archivo de control
!mv &backup_dir/control01.ctl /unam-diplomado-bd/disk-01/app/oracle/oradata/JBADIP02/

Prompt cambiando al modo mount
alter database mount;
Pause [¿ Se corrigió el error? Enter para continuar]

prompt intentar pasar al modo open
alter database open;

pause [Enter para restaurar datafile del tablespace system]
prompt restaurando datafile para el tablespace system 
!mv &backup_dir/system01.dbf  $ORACLE_BASE/oradata/JBADIP02


prompt intentando abrir nuevamente 
alter database open;

pause [¿Se corrigió el error? Enter para restaurar datafile del TS users]
!mv &backup_dir/users01.dbf  $ORACLE_BASE/oradata/JBADIP02

prompt intentando abrir nuevamente 
alter database open;

pause [¿Se corrigió el error?, Revisar alert Log!, Enter - Restaurar Redo Logs]
prompt restaurando redo logs 
!mv &backup_dir/redo01a.log /unam-diplomado-bd/disk-01/app/oracle/oradata/JBADIP02
!mv &backup_dir/redo01b.log /unam-diplomado-bd/disk-02/app/oracle/oradata/JBADIP02
!mv &backup_dir/redo01c.log /unam-diplomado-bd/disk-03/app/oracle/oradata/JBADIP02

prompt intentando iniciar nuevamente en modo OPEN, requiere autenticar y volver a iniciar
connect sys/system2 as sysdba
startup open; 

prompt Mostrando status
select status from v$instance;

Pause [¿La Base ha regresado a la normalidad ? Enter para terminar]
