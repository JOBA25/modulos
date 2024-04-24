--@Autor: Jorge Octaviop Barcenas Avelar
-- Angel Eduardo Oropeza Castañeda
-- Ulises Eduardo Antonio García
--@Fecha creación: 
--@Descripción: creacion directorio

!echo "mostrando valor de ORACLE_SID: ${ORACLE_SID}"
pause ¿Es correcto?  Enter para continuar 

prompt conectando como sys
connect sys/systemproy as sysdba

prompt script catalog
@?/rdbms/admin/catalog.sql

prompt script catproc
@?/rdbms/admin/catproc.sql

prompt script utlrp
@?/rdbms/admin/utlrp.sql

prompt conectando como system
connect system/systemproy

prompt pupbld
@?/sqlplus/admin/pupbld.sql

prompt listo!!
exit