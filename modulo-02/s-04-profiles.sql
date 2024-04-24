--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 4 creación de un user profile

/*  Crear un user profile para evitar que un usuario realice más de 2 conexiones simultáneas en el servidor.
    Crear el usuario user01 con permisos de crear sesión y asignarle el perfil de usuario creado anteriormente.
    Abrir 3 terminales e intentar crear 3 sesiones con el usuario user01, verificar el correcto funcionamiento de perfil de usuario
    Antes de cerrar las terminales anteriores, en la sesión del usuario sys generar una consulta que muestre los siguientes datos de las sesiones del usuario user01
        sid
        serial#
        username
        status
        schemaname
    Aplicar propiedad de idempotencia.
*/
prompt ***conectando como sysdba
connect sys/system1 as sysdba

prompt ***crear el profile
create profile session_limit_profile limit 
    sessions_per_user 2;


prompt ***creando usuario user01
create user user01 identified by user01
    profile session_limit_profile;

prompt ***asignando permisos de creacion de sesiones
grant create session to user01;

prompt Abrir 3 terminales e intentar inicar sesion con user01
prompt En cada termianl mostra datos de la sesion del usuario

accept v_resultado prompt ' ¿qué sucedio con la tercer sesion?  '
prompt Respuesta: &v_resultado

col username format A20
col schemaname format A20
prompt Mostrando las sesiones del usuario user01
select sid, serial#, username, status,schemaname
from v$session
where username = 'USER01';

accept v_sesiones prompt '¿cuántas sesiones se obtuvieron ?'
prompt respuesta: &v_sesiones


pause cerrar sesión en las terminales, despues presionar [Enter]
prompt limpieza

drop user user01 cascade;
drop profile session_limit_profile;