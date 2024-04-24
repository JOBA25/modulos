--@Autor: Jorge Octaviop Barcenas Avelar
-- Angel Eduardo Oropeza Castañeda
-- Ulises Eduardo Antonio García
--@Fecha creación: 
--@Descripción:


define syslogon='sys/systemproy as sysdba'
--define t_user='userproy'
--define userlogon='&t_user/&t_user'
define app_admin='app_admin'
define app_container='app_container'
define pdb1_admin='admin_administracion_con'
define pdb1_container='administracion_con'


define pdb2_admin='admin_negocios_con'
define pdb2_container='negocio_con'


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

create pluggable database &pdb1_container admin user &pdb1_admin identified by &pdb1_admin
  --FILE_NAME_CONVERT=('/u01/app/oracle/oradata/<DB_SID>/pdbseed/','/u01/app/oracle/oradata/<DB_SID>/pdbcontainer/');
  
create pluggable database &pdb2_container admin user &pdb2_admin identified by &pd2_admin
