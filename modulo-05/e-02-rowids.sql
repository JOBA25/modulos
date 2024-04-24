--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 5 2024
--@Descripción: ejercicio 2 Explorar el contenido de un ROWID
connect jorge05/jorge

Prompt  mostrando los primeros 10 registros y sus rowids.
--subconsulta para ordenar
/*
Generar una sentencia SQL que muestre el valor de la columna id y 
el rowid asignado al registro. Incluir únicamente los primeros 10 
registros ordenados por el valor de la columna id.
*/
select row_id,id 
from (
  select rowid as row_id,id
  from t01_id
  order by id
) where rownum <=10;

Prompt mostrando segmentos generados
select substr(rowid,1,6) segmento, 
       count(*) as total_registros
from t01_id
group by substr(rowid,1,6);
Pause [Enter] para continuar

Prompt mostrando data file y registros asignados
select substr(rowid,7,3) data_file, 
       count(*) as total_registros
from t01_id
group by substr(rowid,7,3);
Pause [Enter] para continuar

Prompt mostrando bloque de datos y registros incluidos en el.
select substr(rowid,10,6) bloque, 
       count(*) as total_registros
from t01_id
group by substr(rowid,10,6);