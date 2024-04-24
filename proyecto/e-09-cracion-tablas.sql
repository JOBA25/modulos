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



Prompt Cambiando sesión a &app_container
alter session set container = &app_container;

CREATE TABLE centro (
    centro_id NUMBER PRIMARY KEY,
    clave_centro NUMBER,
    calle_centro VARCHAR2(20),
    colonia_centro VARCHAR2(20),
    numero_centro NUMBER(5),
    estado_centro VARCHAR2(20),
    asociacion_id_rid NUMBER,
    FOREIGN KEY (asociacion_id_rid) REFERENCES asociacion(asociacion_id)
);



Prompt Cambiando sesión a &pdb1_container
alter session set container = &pdb1_container;


CREATE TABLE asociacion (
    asociacion_id NUMBER PRIMARY KEY,
    clave_asociacion NUMBER,
    calle_asociacion VARCHAR2(20),
    colonia_asociacion VARCHAR2(20),
    numero_asociacion NUMBER(5),
    estado_asociacion VARCHAR2(20),
    delegacion_asociacion VARCHAR2(20),
    telefono_asociacion NUMBER(13)
);

CREATE TABLE certificacion (
    certificacion_id NUMBER PRIMARY KEY,
    clave_certificacion NUMBER,
    nombre_certificacion VARCHAR2(20),
    asociacion_id NUMBER,
    FOREIGN KEY (asociacion_id) REFERENCES asociacion(asociacion_id)
);

CREATE TABLE empleado (
    empleado_id NUMBER PRIMARY KEY,
    clave_empleado NUMBER,
    nombre_empleado VARCHAR2(20),
    ap_pat_empleado VARCHAR2(20),
    ap_mat_empleado VARCHAR2(20),
    telefono_empleado NUMBER(13),
    encargado_id NUMBER,
    asociacion_id NUMBER,
    FOREIGN KEY (encargado_id) REFERENCES empleado(empleado_id),
    FOREIGN KEY (asociacion_id) REFERENCES asociacion(asociacion_id)
);

CREATE TABLE lider (
    empleado_id NUMBER PRIMARY KEY,
    FOREIGN KEY (empleado_id) REFERENCES empleado(empleado_id),
    clave_lider NUMBER,
    anios_experiencia NUMBER(2)
);

CREATE TABLE lider_centro (
    empleado_id NUMBER,
    centro_id NUMBER,
    PRIMARY KEY (empleado_id, centro_id),
    FOREIGN KEY (empleado_id) REFERENCES lider(empleado_id),
    FOREIGN KEY (centro_id) REFERENCES centro(centro_id)
);




Prompt Cambiando sesión a &pdb2_container
alter session set container = &pdb2_container;

CREATE TABLE visita (
    visita_id NUMBER PRIMARY KEY,
    fecha DATE,
    hora_llegada TIMESTAMP,
    hora_salida TIMESTAMP,
    centro_id NUMBER,
    cliente_id NUMBER,
    FOREIGN KEY (centro_id) REFERENCES centro(centro_id),
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
);

CREATE TABLE cliente (
    cliente_id NUMBER PRIMARY KEY,
    clave_cliente NUMBER,
    nombre_cliente VARCHAR2(20),
    ap_paterno VARCHAR2(20),
    ap_materno VARCHAR2(20),
    fecha_nacimiento DATE,
    edad_cliente NUMBER(3),
    curp_cliente VARCHAR2(18),
    estado_civil_cliente VARCHAR2(15),
    telefono_cliente NUMBER(13),
    ocupacion_cliente VARCHAR2(15),
    nivel_educativo_cliente VARCHAR2(10)
);
