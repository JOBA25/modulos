Prompt Procedimiento para crear el application container del proyecto Travesia Vacacional
Prompt Integrantes:
Prompt Jorge Octavio Barcenas Avelar
Prompt Angel Eduardo Oropeza Castañeda
Prompt Ulises Eduardo Antonio García



define syslogon='sys/systemproy as sysdba'
define t_user='userproy'
define userlogon='&t_user/&t_user'
define app_admin='app_admin'
define app_container='app_container'
define pd1_admin='pdb1_admin'
define pdb1_container='negocios'
define pdb2_admin='pdb2_admin'
define pdb2_container='administracion'


Prompt Conectando como SYS
connect &syslogon

Prompt Cambiando sesión a cdb$root
alter session set container = cdb$root;

Prompt Creando el aplication container
CREATE PLUGGABLE DATABASE &app_container as application container
  ADMIN USER &app_admin IDENTIFIED BY &app_admin;
  --FILE_NAME_CONVERT=('/u01/app/oracle/oradata/<DB_SID>/pdbseed/','/u01/app/oracle/oradata/<DB_SID>/appcontainer/');
  
Prompt Apertura del app container
alter pluggable database &app_container open;

Pause Creando las application pdb containers [Enter] para continuar

alter session set container = &app_container;

create pluggable database &pdb1_container admin user &pdb1_admin identified by &pd1_admin
  --FILE_NAME_CONVERT=('/u01/app/oracle/oradata/<DB_SID>/pdbseed/','/u01/app/oracle/oradata/<DB_SID>/pdbcontainer/');
  
create pluggable database &pdb2_container admin user &pdb2_admin identified by &pd2_admin

alter pluggable database application all sync;

Pause Limpieza [Enter] para continuar o [Ctrl + c] para terminar

alter session set container = &app_container;
alter pluggable database &pdb1_container close;
alter pluggable database &pdb2_container close;
drop pluggable database &pdb1_container including datafiles;
drop pluggable database &pdb2_container including datafiles;
alter session set container = cdb$root;
alter pluggable database &app_container close;
drop pluggable database &app_container including datafiles;
exit
