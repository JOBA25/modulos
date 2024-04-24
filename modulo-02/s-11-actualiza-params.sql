--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 17 2023
--@Descripción: ejerccio 11 actualización de parámetros

/*

    Generar una consulta que muestre nombre, valor, bandera que indica si el parámetro puede ser modificado a nivel sesión, valor que indica la forma en la que puede emplearse la instrucción alter system para los siguientes parámetros:
        nls_date_format
        db_domain
        deferred_segment_creation
    Crear un respaldo del SPFILE a través de la creación de un PFILE.
    Para cada uno de estos 3 parámetros escribir las siguientes instrucciones que permitan verificar si es posible o no realizar un cambio de parámetro. Seleccionar un valor diferente al default.
        Intentar aplicar el cambio a nivel sesión
        Intentar aplicar el cambio a nivel instancia
        Intentar aplicar el cambio a nivel spfile
        Intentar aplicar el cambio a nivel spfile y nivel instancia.
    Aplicar las instrucciones necesarias para restablecer los valores de los parámetros a sus valores por default.
    Generar una consulta que muestre el valor de estos 3 parámetros para confirmar resultados a nivel sesión
    Generar una consulta que muestre el valor de estos 3 parámetros para confirmar resultados a nivel spfile.

*/
connect sys/system1 as sysdba

prompt 1 consultando v$parameter

col name format a30
col value format a30
col isses_modifiable format a10
col issys_modifiable format a12
set linesize window

select name,value,isses_modifiable, issys_modifiable
from v$parameter
where name in (
  'nls_date_format',
  'db_domain',
  'deferred_segment_creation'
);

/*

NAME			       VALUE			      ISSES ISSYS_MOD
------------------------------ ------------------------------ ----- ---------
nls_date_format 	       DD-MON-RR		   TRUE  FALSE
db_domain		       fi.unam			       FALSE FALSE
deferred_segment_creation      TRUE			   TRUE  IMMEDIATE


1)modificable a nivel de sesión y con spfile
2) solo modificable con spfile
3)modificable a nivel de sesión, memoria y spifile (dinámico)
*/

prompt 2 respaldo del spfile

create pfile from spfile;

prompt intentando modificar parámetros
prompt nls_date_format

pause nivel sesión valor esperado: OK  enter para comprobar
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
--en alter session NO se usa el scope

--si la BD se inicio con spfile --default para scope = both
--si la BD se inicio con pfile  --default para scope = memory
pause nivel memory valor esperado: error  enter para comprobar
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss'
scope= memory  ;

pause nivel both valor esperado: error  enter para comprobar
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss'
scope= both  ;

pause nivel spfile valor esperado: OK  enter para comprobar
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss'
scope= spfile ;

prompt db_domain
pause NIVEL SESION: valor esperado: ERROR enter para comprobar
alter session set db_domain='jorge.fi';

pause NIVEL MEMORY: valor esperado: ERROR enter para comprobar
alter system set db_domain='jorge.fi' scope=memory;

pause NIVEL BOTH: valor esperado: ERROR enter para comprobar
alter system set db_domain='jorge.fi' scope=both;

pause NIVEL SPFILE: valor esperado: OK enter para comprobar
alter system set db_domain='jorge.fi' scope=spfile;

prompt deferred_segment_creation
pause NIVEL SESION: valor esperado: OK enter para comprobar
alter session set deferred_segment_creation=FALSE;

pause NIVEL MEMORY: valor esperado: OK enter para comprobar
alter system set deferred_segment_creation=FALSE scope=memory;

pause NIVEL BOTH: valor esperado: OK enter para comprobar
alter system set deferred_segment_creation=FALSE scope=both;

pause NIVEL SPFILE: valor esperado: OK enter para comprobar
alter system set deferred_segment_creation=FALSE scope=spfile;


---- Hacer reset de los parametro realizarlo a nivel memory, both, spfile

prompt reset para nls_date_format
prompt reset para nls_date_format scope=spfile
alter system reset nls_date_format scope=spfile;
alter system reset nls_date_format scope=memory;
alter system reset nls_date_format scope=both;

prompt reset para db_domain scope=spfile
alter system reset db_domain scope=spfile;
alter system reset db_domain scope=memory;
alter system reset db_domain scope=both;

prompt reset para deferred_segment_creation scope=spfile
alter system reset deferred_segment_creation scope=spfile;
alter system reset deferred_segment_creation scope=memory;
alter system reset deferred_segment_creation scope=both;













