--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: 9 Dec 2023
--@Descripción: ejercicio 4 Consultas de procesos y sesiones 



---3 Generar una consulta que muestre el total de procesos de la instancia. 
select *
from v$process;

--4 consulta que muestre los datos de los procesos que no sean procesos de background

select *
from v$process
where pname is null;
--5 consulta que muestre los datos de todos los procesos que sean de background
select *
from v$process
where pname is not null;

--6 consulta que permita identificar los datos de la sesión iniciada en SQL developer.
select * 
from v$session
where program like '%eveloper%';


---7 mostrar los datos del proceso asciado a la sesión creada en SQL Developer
select *
from v$process
where addr = '0000000075834028';

--8 datos de monitoreo contenidas en el ASH buffer para la sesión creada en SQL developer.
select *
from v$active_session_history
where program like '%eveloper%';
