--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 12 2024
--@Descripción: ejercicio 9


define syslogon="sys/system2 as sysdba"
define t_user= 'm05_store_user'
define t_user_logon='&t_user/&t_user'

set linesize window

prompt Conectando como sys
connect &syslogon

prompt 1. Crear un tablespace llamado m05_store_tbs1
create tablespace m05_store_tbs1
datafile '/u01/app/oracle/oradata/JBADIP02/m05_store_tbs01.dbf' size 30M 
extent management local
autoallocate
segment space management auto
;

prompt 2. Crear un tablespace llamado m05_store_multiple_tbs
create tablespace m05_store_multiple_tbs
    datafile 
        '/u01/app/oracle/oradata/JBADIP02/m05_store_multiple_tbs_01.dbf' size 15M ,
        '/u01/app/oracle/oradata/JBADIP02/m05_store_multiple_tbs_02.dbf' size 15M ,
        '/u01/app/oracle/oradata/JBADIP02/m05_store_multiple_tbs_03.dbf' size 15M 
    extent management local
    autoallocate
    segment space management auto
;

prompt 3. Crear un tablespace llamado m05_store_tbs_custom
create tablespace m05_store_tbs_custom
    datafile '/u01/app/oracle/oradata/JBADIP02/m05_store_tbs_custom_01.dbf' size 15M 
    reuse
    autoextend on next 2M maxsize 40M
    nologging
    blocksize 8k
    offline
    extent management local uniform size 64k
    segment space management auto
;

prompt 4. Mostrar el nombre del tablespace, status, tipo de contenido que almacena para todos los tablespaces existentes
select tablespace_name, status, contents
from dba_tablespaces;

pause [enter] para continuar

prompt 5. Crear un usuario llamado m05_store_user. 

create user &t_user identified by &t_user 
quota unlimited on m05_store_tbs1
default tablespace m05_store_tbs1;
grant create session, create table, create procedure to &t_user;


prompt 6. Empleando al usuario m05_store_user, crear una tabla llamada store_data
connect &t_user_logon

create table store_data(
    c1 char(1024),
    c2 char(1024)
) segment creation deferred;

prompt 7. llenado de una TS store_data

create or replace procedure sp_e6_reserva_extensiones is
v_total_espacio number;
v_extenciones number;
begin
v_extenciones :=0;
    loop
        begin
        execute immediate 'alter table store_data allocate extent';
        exception
        when others then 
            if sqlcode = -1653 then
            dbms_output.put_line('===> Sin espacio en TS');
            dbms_output.put_line('===> Código error  ' ||sqlcode);
            dbms_output.put_line('===> Mensaje error ' ||sqlerrm);
            dbms_output.put_line('===>'||dbms_utility.format_error_backtrace);
            exit;
            end if;
        end;
    end loop;
    --total espacio reservado
    select sum (bytes)/1024/1024, count(*)
    into v_total_espacio, v_extenciones
    from user_extents
    where segment_name ='STORE_DATA';

dbms_output.put_line('Total de extenciones reservadas:  '||v_extenciones);
dbms_output.put_line('Total de espacio reservado  MB  '||v_total_espacio);
end;
/

show errors 

Prompt ejecutar procedimiento sp_e6_reserva_extensiones
set serveroutput on
exec sp_e6_reserva_extensiones

pause [Enter] para continuar


prompt 8. Modificando TS para poder seguir almacenando

connect &syslogon
alter tablespace m05_store_tbs1 
add datafile '/u01/app/oracle/oradata/JBADIP02/m05_store_tbs02.dbf' size 10M ;


prompt 9. Ejecutando nuevamente sp_e6_reserva_extensiones
connect &t_user_logon
set serveroutput on
exec sp_e6_reserva_extensiones
pause [Enter] para continuar

prompt 10. ejecutando consultas 
connect &syslogon
set linesize window

select t.tablespace_name, count(s.tablespace_name) as total_segmentos
from dba_tablespaces t 
left outer join dba_segments s 
on t.tablespace_name = s.tablespace_name
group by t.tablespace_name
order by 2 desc 
;

pause [Enter] para continuar

prompt 11 llamando script e-10-data-files
@e-10-data-files.sql


prompt 12 limpieza
connect &syslogon

drop tablespace m05_store_tbs1 including contents and datafiles;
drop tablespace m05_store_multiple_tbs including contents and datafiles;
drop tablespace m05_store_tbs_custom including contents and datafiles;
drop user &t_user cascade;

Prompt Amonos!!!!

