--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 13 2024
--@Descripción: ejercicio 10

set pagesize 100
set linesize window
define syslogon="sys/system2 as sysdba"
define t_user= 'm05_store_user'
define t_user_logon='&t_user/&t_user'


prompt 11.2. Consultando datafiles empleando dba_data_files
connect &syslogon

col file_name format a20
select file_name, file_id, relative_fno, tablespace_name,
  bytes/(1024*1024) bytes_mb,
  status, autoextensible, increment_by, 
  user_bytes/(1024*1024) user_bytes_mb,
  (bytes-user_bytes)/1024 header_kb,
  online_status
from dba_data_files;

--status del data_file: online, available, invalid
--status_online: sysoff,system, offline,online, recover

prompt 11.3. consultando data_file de v$datafile
col name format a20
select name, file#, creation_change#, 
    to_char(creation_time,'dd/mm/yyyy hh24:mi:ss') creation_time,
    checkpoint_change#, 
    to_char(checkpoint_time,'dd/mm/yyyy hh24:mi:ss') checkpoint_time,
    last_change#,
    to_char(last_time,'dd/mm/yyyy hh24:mi:ss') last_time
from v$datafile;

pause 11.4. Analizar salidas [Enter] para continuar

prompt 11.5 Mostrando datos del header de un datafile


col name format a20
select file#, name, recover, checkpoint_change#,
    to_char(checkpoint_time,'dd/mm/yyyy hh24:mi:ss') checkpoint_time
from v$datafile_header;

pause  [Enter] para continuar

prompt 11.6. Mostrar datos referentes a los archivos temporales de la base de datos
col tablespace_name format a20
select file_id, file_name
    tablespace_name,status, bytes/(1024*1024) bytes_mb
from dba_temp_files;

pause  [Enter] para continuar