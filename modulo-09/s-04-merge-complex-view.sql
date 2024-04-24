--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Marzo 23 2024
--@Descripción: ejercicio 3 ejercicio Simple view merging

define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='&1'


Prompt conectando como &t_user
connect &userlogon

Prompt Ejemplo Transformación OR

Prompt Generando índices

create index receta_medicamento_id_ix on receta(medicamento_id);
create index receta_cita_id_ix on receta(cita_id);
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

select m.*, q1.cantidad
from medicamento m, ( 
  select medicamento_id, count(*) cantidad
  from receta 
  group by medicamento_id
)q1
where m.medicamento_id = q1.medicamento_id
and m.subclave like '040%'
and  q1.cantidad <50; 

Prompt ====== Consulta 2
select m.*, count(*) cantidad
from medicamento m, receta r
where m.subclave like '040%'
and  m.medicamento_id = r.medicamento_id
group by m.medicamento_id,num_grupo_terapeutico,grupo_terapeutico,clave_cbcm,
  subclave, nombre_generico,forma_farmaceutica,concentracion,presentacion,
  principal_indicacion,indicacion_secundaria,contraindicaciones,unidades_envase,
  dosis_diaria,nombre_general
having count(*) <50;


Prompt ============== Consulta 3
select /*+ no_merge(q) */ m.*, q.cantidad
from medicamento m, ( 
  select medicamento_id, count(*) cantidad
  from receta 
  group by medicamento_id
) q
where m.medicamento_id = q.medicamento_id
and m.subclave like '040%'
and  q.cantidad <50; 


Prompt ====== Consulta 4
select m.medicamento_id,num_grupo_terapeutico,grupo_terapeutico,clave_cbcm,
  subclave, nombre_generico,forma_farmaceutica,concentracion,presentacion,
  principal_indicacion,indicacion_secundaria,contraindicaciones,unidades_envase,
  dosis_diaria,nombre_general, count(*) cantidad
from medicamento m, receta r
where m.subclave like '040%'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
having count(*) <50;

Prompt Eliminando índices
drop index receta_medicamento_id_ix;
drop index receta_cita_id_ix;
drop index medicamento_subclave;
drop index cita_consultorio;


