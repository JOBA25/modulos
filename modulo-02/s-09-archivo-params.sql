--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 17 2023
--@Descripción: creacion de archivos de parámetros

prompt Autenticación como sys
connect sys/system1 as sysdba

prompt 1 crear archivo pfile en /tmp/pfile
create pfile='/tmp/pfile-spfile.ora' from spfile;

prompt 2 crear archivo pfile desde memoria
create pfile='/tmp/pfile-memory.ora' from memory;

prompt cambiando permisos al archivo
!sudo chmod 777 /tmp/pfile-memory.ora

prompt 4 mostrar el parametro undo_retention
show parameter undo_retention

pause 5 modificar el archivo pfile-memory.ora, enter para continuar
--5
!echo "undo_retention=1000" >> /tmp/pfile-memory.ora

pause Reiniciando BD, enter para continuar
shutdown immediate

--6
prompt iniciando instancia con pfile
startup pfile=/tmp/pfile-memory.ora

prompt 8 cambiar param con alter
accept v_res prompt '¿qué pasará con la siguiente instrucción?'
prompt respuesta: &v_res
alter system undo_retention=1500 scope=spfile; --no se puede, porque en el
-- paso 6, se levantó con pfile

--no podemos escribir en un spifile si la base se levanto con un pfile
