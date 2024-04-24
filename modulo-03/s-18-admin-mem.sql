

prompt conectando como sys
connect sys/system2 as sysdba

/**
Consulta de áreas de memoria obtenidas para esta instancia a partir de la
cual se realiza la configuración

Session altered.

        ID FECHA               TOTAL_SGA_1 TOTAL_SGA_2 TOTAL_SGA_3   SGA_FREE  PGA_PARAM PGA_TOTAL_2 PGA_RESERVADA PGA_RESERVADA_MAX PGA_EN_USO  PGA_LIBRE PGA_AUTO_W_AREAS PGA_MANUAL_W_AREAS LOG_BUFFER DB_BUFFER_CACHE SHARED_POOL LARGE_POOL  JAVA_POOL STREAM_POOL  INMEMORY
---------- ------------------- ----------- ----------- ----------- ---------- ---------- ----------- ------------- ----------------- ---------- ---------- ---------------- ------------------ ---------- --------------- ----------- ---------- ---------- -----------  --------
         1 19/10/2022 13:57:16      499.99      499.99      499.99        268        268         268        168.79               319     133.75      17.31                0                  0        7.5              48         312         20          4           0       100
        21 19/10/2022 14:19:15      499.99      499.99      499.99        268        268         268        192.93               319     163.44      10.12                0                  0        7.5              48         312         20          4           0       100


	ID         FECHA	       TOTAL_SGA_1 TOTAL_SGA_2 TOTAL_SGA_3   SGA_FREE  PGA_PARAM PGA_TOTAL_2 PGA_RESERVADA PGA_RESERVADA_MAX PGA_EN_USO  PGA_LIBRE PGA_AUTO_W_AREAS PGA_MANUAL_W_AREAS LOG_BUFFER DB_BUFFER_CACHE SHARED_POOL LARGE_POOL  JAVA_POOL STREAM_POOL   INMEMORY
---------- ------------------- ----------- ----------- ----------- ---------- ---------- ----------- ------------- ----------------- ---------- ---------- ---------------- ------------------ ---------- --------------- ----------- ---------- ---------- ----------- ----------
	 1     02/12/2023 09:40:31	    535.99	531.99	    531.99	        488	     492	       488	    294.65	      501.32	       206.66      64.18		  0		     0	                 7.5	      140	             268	       4	  4	      0            100
	21     02/12/2023 11:59:38	    555.99	555.99	    555.99	        468	     468	       468	    203.52	      501.32	       151.17      30.62		  0		     0	                 7.5	      160	             272	       4	  4	      0            100



*/

-----------------------------------------------------------------------
prompt configurando administración Automatic Shared Memory Management
-----------------------------------------------------------------------

--se toma el valor de  TOTAL_SGA_1 + INMEMORY
alter system set sga_target=636M scope=spfile;
--se toma el valor de  PGA_RESERVADA_MAX
alter system set pga_aggregate_target=501M scope=spfile;
--se toma  TOTAL_SGA_1+ PGA_RESERVADA_MAX
alter system set memory_max_target=1137M scope = spfile;

--valores en cero
alter system set memory_target=0 scope = spfile;

alter system set shared_pool_size=0 scope=spfile;
alter system set large_pool_size=0 scope=spfile;
alter system set java_pool_size=0 scope=spfile;
alter system set db_cache_size=0 scope=spfile;
alter system set streams_pool_size=0 scope=spfile;

Prompt Reiniciando instancia para probar modo Automatic Shared Memory Management
pause [Enter] para comenzar con el reinicio
shutdown immediate
startup
Prompt mostrando parametros modo Automatic Shared Memory Management
select (
  select value/1024/1024 from v$spparameter where name='memory_target'
) memory_target, (
  select value/1024/1024 from v$spparameter where name='memory_max_target'
) memory_max_target, (
  select value/1024/1024 from v$spparameter where name='sga_target'
) sga_target, (
  select value/1024/1024 from v$spparameter where name='pga_aggregate_target'
) pga_aggregate_target, (
  select value/1024/1024 from v$spparameter where name='shared_pool_size'
) shared_pool_size, (
  select value/1024/1024 from v$spparameter where name='large_pool_size'
) large_pool_size, (
  select value/1024/1024 from v$spparameter where name='java_pool_size'
) java_pool_size, (
  select value/1024/1024 from v$spparameter where name='db_cache_size'
) db_cache_size, (
  select value/1024/1024 from v$spparameter where name='streams_pool_size'
) streams_pool_size
from dual;

Prompt Invocando nuevamente al script s-14-monitor-mem.sql
start s-14-monitor-mem.sql

Pause Analizar resultados [Enter] para continuar con  modo manual

-----------------------------------------------------------------------
Prompt configurando Manual Shared Memory Management
-----------------------------------------------------------------------

--se toma  TOTAL_SGA_1+ PGA_RESERVADA_MAX+INMEMORY
alter system set memory_max_target=1137M scope = spfile;
--se toma el valor de  PGA_RESERVADA_MAX
alter system set pga_aggregate_target=501M scope=spfile;

--se toma de SHARED_POOL
alter system set shared_pool_size=271M scope=spfile;
--se toma de LARGE_POOL
alter system set large_pool_size=4M scope=spfile;
--se toma de JAVA_POOL
alter system set java_pool_size=4M scope=spfile;
--Se toma de DB_BUFFER_CACHE
alter system set db_cache_size=160M scope=spfile;
--Se toma de STREAM_POOL
alter system set streams_pool_size=0 scope=spfile;

--valores en cero
alter system set sga_target=0 scope=spfile;
--valores en cero
alter system set memory_target=0 scope=spfile;

Prompt Reiniciando instancia para probar modo Manual Shared Memory Management
pause [Enter] para comenzar con el reinicio
shutdown immediate
startup
Prompt mostrando parametros modo Manual Shared Memory Management
select (
  select value/1024/1024 from v$spparameter where name='memory_target'
) memory_target, (
  select value/1024/1024 from v$spparameter where name='memory_max_target'
) memory_max_target, (
  select value/1024/1024 from v$spparameter where name='sga_target'
) sga_target, (
  select value/1024/1024 from v$spparameter where name='pga_aggregate_target'
) pga_aggregate_target, (
  select value/1024/1024 from v$spparameter where name='shared_pool_size'
) shared_pool_size, (
  select value/1024/1024 from v$spparameter where name='large_pool_size'
) large_pool_size, (
  select value/1024/1024 from v$spparameter where name='java_pool_size'
) java_pool_size, (
  select value/1024/1024 from v$spparameter where name='db_cache_size'
) db_cache_size, (
  select value/1024/1024 from v$spparameter where name='streams_pool_size'
) streams_pool_size
from dual;

Prompt Invocando nuevamente al script s-14-monitor-mem.sql
start s-14-monitor-mem.sql

Pause Analizar resultados [Enter] para continuar - Restaurar modo automático

-----------------------------------------------------------------------
Prompt restaurando a modo automático
-----------------------------------------------------------------------

--SUponer que solo tenemos 1GB de ram para la BD
alter system set memory_max_target=1G scope = spfile;
alter system set memory_target=768M scope=spfile;

--valores en reset
alter system reset sga_target scope=spfile;
alter system reset pga_aggregate_target scope=spfile;
alter system reset shared_pool_size scope=spfile;

alter system reset large_pool_size scope=spfile;
alter system reset java_pool_size scope=spfile;
alter system reset db_cache_size scope=spfile;
alter system reset streams_pool_size scope=spfile;


Prompt Reiniciando instancia para restaurar el modo automático
pause [Enter] para comenzar con el reinicio
shutdown immediate
startup
Prompt mostrando parametros modo Automático
select (
  select value/1024/1024 from v$spparameter where name='memory_target'
) memory_target, (
  select value/1024/1024 from v$spparameter where name='memory_max_target'
) memory_max_target, (
  select value/1024/1024 from v$spparameter where name='sga_target'
) sga_target, (
  select value/1024/1024 from v$spparameter where name='pga_aggregate_target'
) pga_aggregate_target, (
  select value/1024/1024 from v$spparameter where name='shared_pool_size'
) shared_pool_size, (
  select value/1024/1024 from v$spparameter where name='large_pool_size'
) large_pool_size, (
  select value/1024/1024 from v$spparameter where name='java_pool_size'
) java_pool_size, (
  select value/1024/1024 from v$spparameter where name='db_cache_size'
) db_cache_size, (
  select value/1024/1024 from v$spparameter where name='streams_pool_size'
) streams_pool_size
from dual;

Prompt Invocando nuevamente al script s-14-monitor-mem.sql
start s-14-monitor-mem.sql

Prompt revisar resultados.
