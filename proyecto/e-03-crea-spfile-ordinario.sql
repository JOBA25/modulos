--@Autor: Jorge Octaviop Barcenas Avelar
-- Angel Eduardo Oropeza Castañeda
-- Ulises Eduardo Antonio García
--@Fecha creación: 
--@Descripción: creacion spfile en la nueva base

!echo "mostrando valor de ORACLE_SID: ${ORACLE_SID}"
pause ¿Es correcto?  Enter para continuar 


Prompt conectando como sysdba

--el password corresponde al que se configuró en el archivo de passwords
connect sys/Hola1234* as sysdba

Prompt creando SPFILE
create spfile from pfile;

Prompt comprobando la existencia del archivo
!ls -l ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora

prompt Listo!

exit