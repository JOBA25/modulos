--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Marzo 22 2024
--@Descripción: ejercicio 3 ejercicio Simple view merging

define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='&1'

prompt conectando con control_medico
connect &userlogon

prompt ejemplo transformacion OR
prompt Generando inidces

create index receta_medicamento_id_ix on receta(medicamento_id);
create index receta_cita__id_ix on receta(cita_id);
create index medicamento_subclave on medicamento(subclave);
create index cita_consultorio on cita(consultorio);

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

prompt configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

prompt === Consulta 1 sin subconsulta

select m.nombre_generico, r.receta_id, r.cantidad, c.fecha_cita
from medicamento m
join receta r
    on m.medicamento_id = r.medicamento_id
join cita c
    on r.cita_id = c.cita_id
and m.subclave like '010%'
and c.consultorio like 'C-6%';

prompt consulta 2 con subconsulta y con hint no_merge

select /*+ no merge(q) */ q.nombre_generico, q.receta_id, q.cantidad,  c.fecha_cita
from cita c
join (
    select r.medicamento_id , r.receta_id, r.cantidad, m.nombre_generico, r.cita_id
    from receta r
    join  medicamento m
        on r.medicamento_id = m.medicamento_id    
    where  m.subclave like '010%'
)q
on q.cita_id = c.cita_id
    where c.consultorio like 'C-6%';


prompt consulta 3 con subconsulta y sin hint no_merge

select  m.nombre_generico, c.receta_id, c.cantidad, c.fecha_cita
from medicamento m
join (
    select r.medicamento_id, r.receta_id, r.cantidad, c.fecha_cita
    from receta r
    join cita c
        on r.cita_id = c.cita_id
    where c.consultorio like 'C-6%'
)c
on c.medicamento_id = m.medicamento_id    
where  m.subclave like '010%';


prompt eliminando indices 
drop index receta_medicamento_id_ix ;
drop index receta_cita__id_ix ;
drop index medicamento_subclave ;
drop index cita_consultorio ;
