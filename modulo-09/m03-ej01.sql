--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Abril 11 2024
--@Descripción: M03-Ejercicio 01 -  Métodos de acceso por índice

define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='&1'


Prompt conectando como &t_user
connect &userlogon


create index paciente_nombre_ix on paciente(nombre);
create index medicamento_unidades_envase_concentracion_idx
on medicamento(unidades_envase,concentracion);
create index medico_nombre_ix on medico(nombre); 
create index medico_cedula_ix on medico(cedula);


Prompt Configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

set linesize window

prompt =============== unique index scan

select *
from paciente
where paciente_id = 2;

prompt =============== range index scan
select *
from paciente
where paciente_id > 2 and paciente_id < 5;



prompt =============== full index scan

select nombre
from paciente
order by nombre ;

prompt ===============  Index skip Scan

select *
from medicamento
where concentracion='600 mg';

prompt ===============     join index scan

select cedula, nombre  
from medico 
where nombre like 'D%';


Prompt haciendo limpieza

drop index paciente_nombre_ix ;
drop index medicamento_unidades_envase_concentracion_idx;
drop index medico_nombre_ix;
drop index medico_cedula_ix;