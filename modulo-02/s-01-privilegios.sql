--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 10 2023
--@Descripción: ejercicio 1 creación de usuario



prompt conectando como sysdba
connect sys/system1 as sysdba

--creando usuario
create user jorge02 identified by jorge quota unlimited on users;

--otorgar privs de sistema
grant create session, create table to jorge02;

prompt entrando a sesión con jorge02
connect jorge02/jorge

prompt creando una tabla de prueba
create table test (id number);

prompt conectando como sysdba
connect sys/system1 as sysdba

prompt verificando privilegios en dba_sys_privs
col grantee format a20
set linesize window
select grantee,privilege, admin_option
from dba_sys_privs
where grantee='JORGE02';

pause actividades de limpieza [Enter] para continuar
drop user jorge02 cascade;


/*

    Crear una sesión con el privilegio sysdba
    Crear un usuario <nombre>01. Asignarle una cuota ilimitada en el tablespace users
    Asignar los privilegios de sistema correspondientes para que el usuario pueda crear sesiones y tablas.
    Crear una sesión empleando al nuevo usuario.
    Crear una tabla de prueba para verificar su correcta creación
    Crear una sesión como sysdba
    Generar una consulta que muestre los siguientes datos asociados a los privilegios asignados al usuario:
        Nombre del usuario
        privilegio asignado
        Verificar si el privilegio tiene activada la condición with admin option
    Realizar las acciones necesarias para que el script tenga la característica de idempotencia, es decir, si el script se ejecuta N veces, se deberá obtener exactamente el mismo resultado.
    Ejecutar el script, revisar resultados.

*/