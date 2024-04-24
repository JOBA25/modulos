--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Marzo 15 2024
--@Descripción: creación de ua plication container
spool /unam-diplomado-bd/modulos/modulo-07/lab-1.txt
Prompt iniciando en  jbadip03
connect sys/system3@jbadip03 as sysdba

Prompt Creando application container jbadip03_appVentas
--TODO: Crear  PDB
create pluggable database jbadip03_appVentas as application container 
  admin user admin identified by admin
  file_name_convert=(
    '/u01/app/oracle/oradata/JBADIP03/pdbseed',
    '/u01/app/oracle/oradata/JBADIP03/jbadip03_appVentas'
);

prompt abriendo jbadip03_appVentas
alter pluggable database jbadip03_appVentas open read write;

prompt conectando a jbadip03_appVentas
alter session set container=jbadip03_appVentas;

prompt mostrando datos del contenedor
show con_id
show con_name

pause Analizar resultados, [Enter] para continuar

Prompt crear PDB jbadip03_appVentas_Provedores

create pluggable database jbadip03_appVentas_Provedores
 admin user admin identified by admin
 file_name_convert=(
  '/u01/app/oracle/oradata/JBADIP03/pdbseed',
  '/u01/app/oracle/oradata/JBADIP03/jbadip03_appVentas/jbadip03_appVentas_Provedores'
 );

Prompt Abrir  jbadip03_appVentas_Provedores
alter pluggable database jbadip03_appVentas_Provedores open read write;

Prompt  realizar sync entre pdb y app container
--TODO Realizar sync
alter session set container=jbadip03_appVentas_Provedores;
alter pluggable database application all sync;

Prompt  Crear un application  jbadip03_appVentas_app1
alter session set container=jbadip03_appVentas;

alter pluggable database application jbadip03_appVentas_app1 begin install '1.0';

Prompt creando objetos compartidos

Prompt creando un TS
alter system set db_create_file_dest='/u01/app/oracle/oradata' scope=memory;
create tablespace ventas_app_ts
datafile size 1m autoextend on next 1m;

Prompt creando usuario
create user admin_ventas identified by jorge
  default tablespace ventas_app_ts
  quota unlimited on ventas_app_ts
  container=all;

grant create session, create table, create procedure 
  to admin_ventas;

Prompt creando una tabla
create table admin_ventas.compras(
  id number(10,0) constraint carrera_pk primary key,
  nombre varchar2(40)
);

Prompt Insertando datos
insert into admin_ventas.compras(id,nombre) values (1,'Computadoras');
insert into admin_ventas.compras(id,nombre) values (2,'Termos');
insert into admin_ventas.compras(id,nombre) values (3,'Coca');
commit;

Prompt asociando objetos comunes
alter pluggable database application jbadip03_appVentas_app1 end install;

prompt Probando realizando sync
alter session set container=jbadip03_appVentas_Provedores;
alter pluggable database application jbadip03_appVentas_app1 sync;

prompt Mostrando datos de objetos comunes
select * from admin_ventas.compras;

pause Revisar resultados, [Enter] para continuar