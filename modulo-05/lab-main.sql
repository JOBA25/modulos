--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 18 2024
--@Descripción: laboratorio del doc modulo 05 / 05 estructuras físicas



define syslogon="sys/system2 as sysdba"
define t_user= ' m05_911_user'
define t_user_logon='&t_user/&t_user'

set linesize window

prompt Conectando como sys
connect &syslogon

prompt creando TS m05_911_ts
create tablespace m05_911_ts
    datafile 
        '/disk-mod5/u21/app/oracle/oradata/JBADIP02/m05_911_ts_01.dbf' size 15M ,
        '/disk-mod5/u22/app/oracle/oradata/JBADIP02/m05_911_ts_02.dbf' size 15M ,
        '/disk-mod5/u23/app/oracle/oradata/JBADIP02/m05_911_ts_03.dbf' size 15M ,
        '/disk-mod5/u24/app/oracle/oradata/JBADIP02/m05_911_ts_04.dbf' size 15M ,
        '/disk-mod5/u25/app/oracle/oradata/JBADIP02/m05_911_ts_05.dbf' size 15M 
    extent management local autoallocate
    segment space management auto
;

prompt creando TS m05_911_ix_ts
create tablespace m05_911_ix_ts
    datafile 
        '/disk-mod5/u31/app/oracle/oradata/JBADIP02/m05_911_ts_05.dbf' size 5M 
    autoextend on next 1M maxsize 30M
    extent management local autoallocate
    segment space management auto
;

Prompt creando usuario m05_911_user
create user &t_user identified by &t_user quota 
quota unlimited on m05_store_tbs1
default tablespace m05_store_tbs1;

grant create table, create session  to &t_user;

prompt Conectando como m05_911_user
connect &t_user_logon

create table llamada_911(
  address varchar2(50),
  type    varchar2(50),
  call_ts  date,
  latitude number(10,6),
  longitude number(10,6),
  report_location varchar2(40),
  incident_number varchar2(12)
   );

prompt Crando un indices
create index ix1_llamada_911_incident_number on llamada_911(incident_number) tablespace m05_911_ix_ts ;
create index ix1_llamada_911_address on llamada_911(address) tablespace m05_911_ix_ts ;

Pause [Enter] para continuar

Prompt Creando tabla externa (llamada_911_ext) desde un csv

create table llamada_911_ext(
  address varchar2(50),
  type    varchar2(50),
  call_ts  date,
  latitude number(10,6),
  longitude number(10,6),
  report_location varchar2(40),
  incident_number varchar2(12)
)organization external (
  type oracle_loader
  default directory ext_tab_data
  access parameters (
    records delimited by newline
    badfile ext_tab_data: 'llamada_911_bad.log'
    logfile ext_tab_data: 'llamada_911_err.log'
    fields terminated by ',' 
    optionally enclosed by '"' 
    date_format date mask "mm/dd/yyyy hh:mi:ss am"
    lrtrim
    missing field values are null
    (
      address,type,call_ts,latitude,longitude,report_location,incident_number
    )
  )
  location ('calls-911-50m.csv') 
)
reject limit 100;

Prompt Validando tabla externa

select * from llamada_911_ext where rownum <=3;

Prompt poblando tabla llamada_911 desde la tabla externa
insert /*+ append */ into llamada_911 select * from llamada_911_ext;

commit;

Prompt Validando tabla permanente 
select * from llamada_911 where rownum <=3;

Pause [Enter] para continuar

Prompt Mostrnado datos de segmentos 
col segment_name format a30
select segment_name, tablespace_name, extents, trunc(bytes/1024/1024,2) bytes_mb
from user_segments
where segment_name like'%911%'

prompt Mostrando datos Tablespaces y data files
col tablespace_name format a20
select tablespace_name,  file_id, file_name,  
    bytes/(1024*1024) bytes_mb,  Blocks, online_status, 
    autoextensible
from dba_data_files;


prompt Mostrando datos Segmentos, extensiones y data files
select t.tablespace_name, 
s.SEGMENT_NAME, 
t.file_name,
count(EXTENT_ID)  number_extents_DF


from dba_data_files t
left outer join dba_segments s
on t.tablespace_name = s.tablespace_name
left outer join dba_extents e
on t.tablespace_name = e.tablespace_name
group by t.FILE_NAME
order by 2 desc;