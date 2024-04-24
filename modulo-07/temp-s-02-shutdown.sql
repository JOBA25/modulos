
--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Febrero 16 2024
--@Descripción: ejercicio shutdown 

spool /unam-diplomado-bd/modulos/modulo-07/s-02-shutdown-spool.txt

pause Antes de continuar asegurarse que la CDB esté iniciada, asi como oracle_sid= jbadip03
pause [enter] para continuar

prompt conectando a jbadip03_s1

connect sys/system3@jbadip03_s1 as sysdba
-- usando listener
pause ¿que sucederá al ejecutar shutdown immediate? [enter]
shutdown immediate

prompt pregunta 2
alter session set container=cdb$root;
col name format a20
select con_id, name,open_mode from v$pdbs;
pause Analizar resultados [enter] para continuar

prompt pregunta 3 detener a la CDB
--TODO: Completar
shutdown immediate


prompt pregunta 4 , iniciando nuevamente
-------------------------------------------------------------
-- Analizar la siguiente instrucción ¿Será correta?, ¿ A qué PDB se conectará?
!echo "ORACLE_SID= $ORACLE_SID"
pause Asegurar que ORACLE_SID =  jbadip03, [Enter] para continuar
connect sys/system3 as sysdba
startup

prompt ejecutando nuevamente consulta 2
--alter session set container=cdb$root;
col name format a20
select con_id, name,open_mode from v$pdbs;
pause Analizar resultados [enter] para continuar

--TODO: Completar para modificar el valor de open_mode,
-- hacer el cambio permanente

--alter pluggable database jbadip03_s1 open
prompt abriendo todas las pdb
alter pluggable database all open;

prompt haciendo permanente el cambio

alter pluggable database all save state;

prompt reiniciando CDB
shutdown immediate
prompt iniciando
startup

prompt mostrando consulta 2 nuevamente
select con_id, name,open_mode from v$pdbs;
pause Analizar resultados [enter] para continuar
