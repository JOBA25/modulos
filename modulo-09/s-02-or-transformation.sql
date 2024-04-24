

define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='&1'
--se crean los inidces antes de que se recolecten los datos

prompt conectando con control_medico
connect &userlogon

create index paciente_num_seguro_ix on paciente(num_seguro);
create index cita_paciente_id_ix on cita(paciente_id);
create index cita_medico_id_ix on cita(medico_id);


create index diagnostico_nombre_ix on diagnostico(nombre);
create index cita_diagnostico_id_ix on cita(diagnostico_id);

prompt conectando como &t_user
connect &syslogon

prompt B. concetando como sys
begin
    dbms_stats.gather_schema_stats(
        ownname => 'CONTROL_MEDICO',
        degree => 2
    );
end;
/

prompt conectando con control_medico
connect &userlogon
set linesize window

promt configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

prompt ====== Consulta 1

--el optimizador genera automaticamente una transformacion or -> costo menor
prompt => sin transformacion OR
select c.fecha_cita, cita_id, c.consultorio, p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and (c.medico_id=2999 or p.num_seguro like '33%');

--obligando al optimizador a no realizar la transformacion -> costo mayor
--se puede emplear el hint no_expand
prompt => sin transformacion OR
select /*+ no_query_transformation  */ c.fecha_cita, cita_id, c.consultorio, p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and (c.medico_id=2999 or p.num_seguro like '33%');

prompt => optimizando Consulta
--sentencia con transformacion or -> mismo plan que la primera sentencia
select c.fecha_cita, cita_id, c.consultorio, p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and c.medico_id=2999
union all
select c.fecha_cita, cita_id, c.consultorio, p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and p.num_seguro like '33%';

pause [enter] para continuar

prompt ==== consulta 2
prompt => sentencia sin transformacion
--el optimizador no realiza transformacion or -> mayor costo
select p.paciente_id, p.nombre, d.nombre
from paciente p, diagnostico d, cita c
where p.paciente_id =  c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and (p.num_seguro like '3%' or d.nombre like 'HIPER%');

prompt => sentencia con tranformacion
--se obtiene un costo menor al realizar esta trsnformacion
select p.paciente_id, p.nombre, d.nombre
from paciente p, diagnostico d, cita c
where p.paciente_id =  c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and p.num_seguro like '3%' 
union all 
select p.paciente_id, p.nombre, d.nombre
from paciente p, diagnostico d, cita c
where p.paciente_id =  c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and d.nombre like 'HIPER%' ;

pause [enter] para continuar

prompt ===  Consulta 3
-- el optimizador realizo una transformacion ->costo menor
prompt => sentencia sin transformacion
select p.paciente_id, p.nombre, d.nombre
from paciente p, diagnostico d, cita c
where p.paciente_id =  c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and (p.num_seguro like '33%' or d.nombre like 'HIPER%');


prompt eliminando inidces
drop index paciente_num_seguro_ix ;
drop index cita_paciente_id_ix ;
drop index cita_medico_id_ix ;
drop index diagnostico_nombre_ix ;
drop index cita_diagnostico_id_ix ;


