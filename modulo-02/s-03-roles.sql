--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: ejercicio 3 jerarquia de roles

/*

    Conectarse como sysdba
    Crear los roles web_admin_role y web_root_role
    Asignar privilegios para crear sesiones, crear tablas y secuencias al rol web_admin_role.
    Escribir la sentencia que le permita al rol web_root_role adquirir los todos los privilegios que contiene el rol web_admin_role.
    Crear un usuario j_admin y asignarle el rol web_admin_role. De forma adicional, se requiere que el usuario j_admin pueda otorgar este rol a otros usuarios.
    Comprobar que el usuario j_admin puede crear sesiones a través de su rol
    Crear un usuario j_os_admin, sin privilegios, sin cuota.
    Conectarse como usuario j_admin y otorgarle el rol web_admin_role al usuario j_os_admin
    Comprobar que el usuario j_os_admin puede crear sesiones a través de su rol asignado.
    Aplicar propiedad de idempotencia.

*/

connect sys/system1 as sysdba

prompt 2. Creando roles
create role web_admin_role;
create role web_root_role;

prompt 3. Asignando roles
grant create session, create table, create sequence to web_admin_role;

prompt 4 asociar roles
grant web_admin_role to web_root_role;

prompt 5. Creando j_admin
--with admin option 
--permite a j_admin propagar el rol
create user j_admin identified by j_admin;
prompt asignando rol 
grant web_admin_role to j_admin with admin option;

prompt 6. comprobando privilegios para j_admin
connect j_admin/j_admin

accept v_paso6 prompt '¿Fue posible entrar a sesión con j_admin ?' 
prompt Respuesta obtenida: &v_paso6

prompt 7. creando usuario j_os_admin
connect sys/system1 as sysdba
create user j_os_admin identified by j_os_admin;

prompt 8 conectando como j_admin, y validar que puede otorgar privilegios 
prompt    ya que se asignó la cláusula with admin option
connect j_admin/j_admin
grant web_admin_role to j_os_admin;

accept v_paso8 prompt '¿Fue posible otorgar el privilegio desde j_admin ?' 
prompt Respuesta obtenida: &v_paso8

prompt 9 comprobando que j_os_admin puede  crear sessiones
connect j_os_admin/j_os_admin
accept v_paso9 prompt '¿Fue posible crear sesiones con j_os_admin ?' 
prompt Respuesta obtenida: &v_paso9


prompt 10 hacer script idempotente
connect sys/system1 as sysdba
--borrar primero los usarios y luego los roles
drop user j_admin cascade;
drop user j_os_admin cascade;
drop role  web_admin_role;
drop role web_root_role;



