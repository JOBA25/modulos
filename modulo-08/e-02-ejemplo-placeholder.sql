connect jorge08/jorge08 
set serveroutput on 

begin
  for i in 100..10000 loop
    execute immediate  'insert into joba_test values(:ph1)' using  i; 
  end loop;
end;
/

prompt mostrando el número de registros
select count(*) from joba_test;