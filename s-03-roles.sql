--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 3 jerarquia de roles



prompt conectando como sys
connect sys/system1 as sysdba

prompt creando roles
create role web_admin_role;
create role web_root_role;
