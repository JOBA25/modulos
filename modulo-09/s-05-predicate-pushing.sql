--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Marzo 23 2024
--@Descripción: ejercicio 3 ejercicio predicate-pushing

define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='&1'


Prompt conectando como &t_user
connect &userlogon

Prompt Generando índices
create index receta_medicamento_id_ix on receta(medicamento_id);
create index receta_cita__id_ix on receta(cita_id);
create index medicamento_subclave on medicamento(subclave);
create index cita_consultorio on cita(consultorio);



Prompt conectando como SYS
connect &syslogon

Prompt B. Recolectando estadísticas
begin
  dbms_stats.gather_schema_stats (
      ownname => 'CONTROL_MEDICO',      
      degree  => 2
  );
end;
/

Prompt conectando como &t_user
connect &userlogon

Prompt Configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

set linesize window

Prompt ====  Consulta 1 
create table medico_suplente as 
select * from medico
where cedula like '1%';

prompt === Consulta 2 sin predicate pushing (manual por optimizador)

select medico_id, nombre
from (
  select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
  from medico
  union all
  select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
  from medico_suplente
)
where nombre like 'A%' or cedula like '15%';

prompt === Consulta 3 con predicate pushing 

select medico_id, nombre
from (
  select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
  from medico
  where nombre like 'A%' or cedula like '15%'
  union all
  select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
  from medico_suplente
  where nombre like 'A%' or cedula like '15%'
);


prompt eliminando indices 
drop index receta_medicamento_id_ix ;
drop index receta_cita__id_ix ;
drop index medicamento_subclave ;
drop index cita_consultorio ;
drop table medico_suplente;
