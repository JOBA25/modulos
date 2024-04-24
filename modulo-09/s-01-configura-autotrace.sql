define syslogon='sys/system2 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'

prompt configurando autotrace
prompt conectando como sys
connect &syslogon

prompt conectando con control_medico
connect &userlogon

prompt creando plan_table

declare
    v_count number;
begin
    select count(*) into v_count from user_tables where table_name='PLAN_TABLE';
    if v_count > 0 then
        execute immediate 'drop table plan_table';
    end if;
end;
/

@$ORACLE_HOME/rdbms/admin/utlxplan.sql

prompt ejemplo con set autotrace on
prompt contando registros de tabla citas

set autotrace on
select count(*) from cita;