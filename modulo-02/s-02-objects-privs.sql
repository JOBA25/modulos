--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 2 creación de usuarios para signar permisos de objetos


prompt conectando como sys
connect sys/system1 as sysdba

prompt creando usuarios
create user user01 identified by user01 quota unlimited on users;
create user guest01 identified by guest01 quota unlimited on users;

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

prompt conectando como user01
connect user01/user01

prompt creando tabla test01
create table test01(id number);
insert into test01 values(1);

prompt verificar que guest01 no puede acceder a datos de user01

connect guest01/guest01
select * from user01.test01;

pause ¿qué sucedio? ¿guest01 pudo acceder a la tabla user01.test01? No deberia

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

prompt intentando insertar en user01.test01 
insert into user01.test01 values(2222);

select * from user01.test01;

prompt limpieza
connect sys/system1 as sysdba

drop user user01 cascade;
drop user guest01 cascade;
drop user guest02 cascade;

/*

    Crear una sesión como sysdba
    Crear usuarios de prueba user01, guest01, con cuota ilimitada en el tablespace users.
    Otorgar privilegios de sistema para crear sesión y tablas al usuario user01
    Otorgar únicamente privilegios para crear sesión a guest01
    Crear un usuario guest02 a partir de la instrucción grant <priv> <user> identified by <password>, asignarle 10 MB de cuota en el tablespace users.
    Permitirle al guest02 la posibilidad de otorgar privilegios de objeto de cualquier esquema a otros usuarios.
    Conectarse con el usuario user01
    Crear una tabla e insertar un registro
    Verificar que el usuario guest01 no puede acceder a los datos de user01
    Otorgar permisos a guest01 para que pueda consultar los datos de la tabla de prueba creada por el usuario user01.
    Comprobar el acceso a la tabla test01 empleando el usuario guest01
    Conectarse como usuario guest02.
    Generar una sentencia en la que el usuario guest02 le permita al usuario guest01 hacer inserciones en la tabla de prueba del usuario user01
    Comprobar los permisos de inserción otorgados en el punto anterior.
    Aplicar propiedad de idempotencia al script.

*/