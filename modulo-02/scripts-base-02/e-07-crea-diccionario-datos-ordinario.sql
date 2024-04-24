--@Autor: Jorge Octaviop Barcenas Avelar
--@Fecha creación: Nov 11 2023
--@Descripción: creacion de bd

!echo "mostrando valor de ORACLE_SID: ${ORACLE_SID}"
pause ¿Es correcto?  Enter para continuar 

prompt conectando como sys
connect sys/system2 as sysdba

prompt script catalog
@?/rdbms/admin/catalog.sql

prompt script catproc
@?/rdbms/admin/catproc.sql

prompt script utlrp
@?/rdbms/admin/utlrp.sql

prompt conectando como system
connect system/system2

prompt pupbld
@?/sqlplus/admin/pupbld.sql

prompt listo!!
exit