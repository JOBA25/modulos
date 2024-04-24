--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 5 privilefios de administración

/*
    Crear una sesión empleando el privilegio de administración sysdba
    Crear al usuario user01 con permisos de crear sesión y crear tablas
    Otorgarle los siguientes privilegios de administración:
        sysdba
        sysoper
    Crear a los usuarios user02 y user03. Asignarles únicamente privilegios para crear sesiones.
    Crear sesión como usuario user01 sin privilegio de administración
        Ejecutar las sentencias necesarias para mostrar el usuario y esquema asignado.
        Crear una tabla de prueba, inserta un registro, hacer commit.
        Otorgar el privilegio correspondiente a la tabla de prueba para que cualquier usuario pueda consultar sus datos.
    Empleando al usuario user01 autenticar como sysdba
        Ejecutar las sentencias necesarias para mostrar el usuario y esquema asignado.
        Ejecutar la sentencia correspondiente para mostrar los datos de la tabla de prueba creada anteriormente.
    Empleando al usuario user01 autenticar como sysoper
        Ejecutar las sentencias necesarias para mostrar el usuario y esquema asignado.
        ¿Qué sucederá al consultar los datos de la tabla test ?
    Empleando a los usuario user02 y user03 para comprobar que se puede leer el contenido de la tabla user01.test a través del esquema PUBLIC
    Aplicar propiedad de idempotencia.
*/

prompt ++++++++++conectando como sys
connect sys/system1 as sysdba

prompt ++++++++++creando al usario user01
create user user01 identified by user01 quota unlimited on users;
--default tablespace user01;

prompt ++++++++++Asignando permisos de sesion y creacion tablas a user01
grant create session, create table to user01;

prompt ++++++++++otorgando privilegios de administración as user01
grant sysdba,sysoper to user01;

prompt ++++++++++creando user02 y user03
create user user02 identified by user02;
create user user03 identified by user03;

prompt ++++++++++Asignando roles de inicio de sesion
grant create session to user02 ;
grant create session to user03 ;

prompt ++++++++++iniciando sesion como user01 sin permisos de admin
connect user01/user01

prompt ++++++++++mostrando esquema y usuario actuales
col esquema format A20
select sys_context('USERENV','CURRENT_SCHEMA') as esquema from dual;


accept v_resultado prompt ' ¿qué valor se espera del nombre de usuario? '
prompt Respuesta: &v_resultado
--valor esperado user01
--usuario en sesion 
show user

--creando tabla test01...
prompt creando tabla test01 del usuario user01
create table test01(id number);
insert into test01 values(1);

--permisos para que cualquier pueda consultar
prompt ++++++otorgando permisos select al esquema public para hcer publica la tabla
grant select on test01 to public;

prompt +++++++Empleando al usuario user01 autenticar como sysdba
connect user01/user01 as sysdba
prompt mostrando esquema y usuario actuales

select sys_context('USERENV','CURRENT_SCHEMA') as esquema from dual;
accept v_resultado_sys prompt ' ¿qué valor se espera del nombre de usuario?'
prompt ++++++++++Respuesta: &v_resultado_sys
--valor esperado sys
--usuario en sesion 
show user  
-- valor esperado sys

--consultando la tabla test
prompt ++++++++++consultando la tabla user01.test
accept v_sys_test prompt ' ¿Marcara error?'
prompt ++++++++++Respuesta: &v_sys_test
select * from user01.test01;  
--¿marcara error ?

prompt ++++++++++Empleando al usuario user01 autenticar como sysoper
connect user01/user01 as sysoper
prompt ++++++++++mostrando esquema y usuario actuales
select sys_context('USERENV','CURRENT_SCHEMA') as esquema from dual;
--valor esperado public
--usuario en sesion 
select sys_context('USERENV','CURRENT_SCHEMA') as esquema from dual;
accept v_resultado_sysop prompt ' ¿qué valor se espera del nombre de usuario?'
prompt ++++++++++Respuesta: &v_resultado_sysop
show user  
-- valor esperado public

-- mostrando los datos de la tabla test
prompt ++++++++++consultando la tabla user01.test
accept v_sysop_test prompt ' ¿Marcara error?'
prompt ++++++++++Respuesta: &v_sysop_test
select * from user01.test01;
--resultado esperado ? fucionarà..

--funcionará la sig instrucciòn ?
accept v_test prompt ' ¿Marcara error consultar test01?'
prompt Respuesta: &v_test
select * from test01;  
--- debido a que es publica ? NO. 

prompt Empleando a los usuario user02 y user03 para comprobar que se 
prompt puede leer el contenido de la tabla user01.test a través del
prompt esquema PUBLIC
prompt  

connect user02/user02
prompt ++++++++++resultado usando user02
select * from user01.test01;  
--- funcionará ? SI

connect user03/user03
prompt ++++++++++resultado usando user03
select * from user01.test01;  
--- funcionará ? SI

prompt ++++++++++limpieza
connect sys/system1 as sysdba
drop user user03;
drop user user02;
drop user user01 cascade;