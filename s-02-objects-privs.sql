--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 2 creación de usuarios para signar permisos de objetos


prompt creando usaurios
connect sys/system1 as sysdba

prompt creando usuarios
create user user01 udentified by user01 quota unlimited on users;
create user guest01 udentified by guest01 quota unlimited on users;

prompt asignando privilegios de sistema a user01
grant create session, create table to user01;

prompt asignando privilegios a guste01
grant create session to guest01;

prompt creando el usuario guest02 a partir de la instruccion grant
grant create session to guest02 identified by guest02;

alter user guest02 quota 10M on users;

prompt Permitirle al guest02 pueda otorgar privilegios de objeto a cualquier usuario
--va a poder asignar privilegios de objetos a cualquier usuario
--sobre cualquier 
-- el nombre del privilegio es "grant any object privilege"
grant grant any object privilege to guest02;

pompt conectando como user01
connect user01/user01

prompt creando tabla test01
create table test01(id number);
insert into test01 values(1);

prompt verificar que guest01 no puede acceder a datos de user01

connect guest01/guest01
select * from user01.test01;

puase ¿qué sucedio? ¿guest01 pudo acceder a la tabla user01.test01? No deberia

prompt otorgar permisos a guest01 para ver la tabla test01 usando user01 
connect user01/user01
grant select on test01 to guest01;

prompt comporbando acceso a test01 con guest01
connect guest01/guest01
select * from user01.test01;

prompt conectando como guest02
connect guest02/guest02

prompt guest02 otrogará permisos de inserción a guest01 sobre test01
grant insert on user01.test01 to guest01;

prompt comprobando que guest01 puede insertar en test01
connect guest01/guest01

prompt intentando indertar en user01.test01 
insert into user01.test01 values(2222);
select * from user01.test01

prompt limpieza
connect sys/system1 as sysdba

drop user01 cascade;
drop guest01 cascade;
drop guest02 cascade;