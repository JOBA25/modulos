--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: tarea 1 administración de usuarios 

prompt + conectando como sys
connect sys/system1 as sysdba

prompt + creando usuario
create user joba01 identified by joba01 quota 1G on users
password expire;

prompt + creando rol
create role app_rol;


prompt + Asignando privilegios al roles
grant create session, create table, create sequence to app_rol;


prompt + asignando rol a joba01
grant app_rol to joba01 ;


prompt + conectando como joba01
connect joba01/joba01

prompt + creando tabla amigo 
create table amigo(id number, nombre varchar(40));

prompt + insertando registro
insert into amigo values(1, 'jorge octavio');
prompt 

prompt + hacemos commit
commit;

prompt + conectando como sys
connect sys/system1 as sysdba

prompt + creando  profile
create profile session_limit_worker_profile limit 
    sessions_per_user 1
    connect_time 1;

prompt + creando usuario worker con perfil session_limit_worker_profile
create user joba_worker01 identified by joba_worker01 quota 1G on users
    profile session_limit_worker_profile;

prompt + asignando permisos de sesión
grant create session to joba_worker01;
prompt

prompt + conectando como sys
connect sys/system1 as sysdba

prompt + asignando permisos de inserción para joba_worker01 en joba01.amigo
grant insert on joba01.amigo to joba_worker01;

prompt + conectando como joba_worker01
connect joba_worker01/joba_worker01 

prompt + insertando 3 registros
insert into joba01.amigo values(2, 'Angel');
insert into joba01.amigo values(3, 'Luis');
insert into joba01.amigo values(4, 'Danna');



prompt + vamos a domrir 70 segundos
exec dbms_session.sleep(70);
prompt

--se espera que no se pueda insertar ya que va expirar la sesión
prompt + se intenta volver a insertar
insert into joba01.amigo values(5, 'Jose');

/*
Crear un usuario <iniciales>_slave. A este usuario se le deberán otorgar 
los privilegios correspondientes para realizar la siguiente actividad: 
6.1 Crear una sesión y permitirle al usuario <iniciales>_worker01 
eliminar registros de la tabla <iniciales>01.amigo 6.2 Iniciar 
sesión como usuario <iniciales>_worker01 y eliminar los registros 
de la tabla para verificar que puede realizar la eliminación.
*/

prompt + conectando como sys
connect sys/system1 as sysdba

prompt + creando usuario joba_slave
create user joba_slave identified by joba_slave quota 1G on users;

prompt + asignado permisos a joba_slave
grant create session to joba_slave;
---como darle permisos para otorgar permisos de borrar datos de una 
---tabla
grant delete on joba01.amigo to joba_slave with grant option;

prompt + conectando como joba_slave
connect joba_slave/joba_slave

prompt +asignando permisos de delete a joba_worker01
grant delete on joba01.amigo to joba_worker01;
prompt

prompt + conectando como joba_worker01
connect joba_worker01/joba_worker01

prompt +borrando registros de joba01.amigo
delete from joba01.amigo;

prompt
prompt limpieza
connect sys/system1 as sysdba

prompt Comprobando tabla  joba01.amigo
select *
from joba01.amigo;

drop user joba_slave;
drop user joba_worker01;
drop user joba01 cascade;
drop role app_rol;
drop profile session_limit_worker_profile;
















