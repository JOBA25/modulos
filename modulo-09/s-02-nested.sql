--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Abril 11 2024
--@Descripción:M03-Ejercicio 02 -  Nested loop

define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='&1'

create index cita_medico_id_ix on cita(medico_id);

Prompt conectando como &t_user
connect &userlogon

Prompt Configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

set linesize window


select c.medico_id, c.fecha_cita
from cita c
join medico m on m.cita_id = r.cita_id
where m.nombre like '%A%' ;



prompt limpieza
drop index cita_medico_id_ix;