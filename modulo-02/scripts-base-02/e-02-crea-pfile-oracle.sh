#!/bin/bash

echo "creando archivo pfile"
echo ""

echo "asignando el valor a ORACLE_SID: jbadip02"
export ORACLE_SID=jbadip02
pfile="${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora"

echo \
"
db_name=${ORACLE_SID}
memory_target=1G
control_files=(
  /unam-diplomado-bd/disk-01/app/oracle/oradata/${ORACLE_SID^^}/control01.ctl,
  /unam-diplomado-bd/disk-02/app/oracle/oradata/${ORACLE_SID^^}/control02.ctl,
  /unam-diplomado-bd/disk-03/app/oracle/oradata/${ORACLE_SID^^}/control03.ctl
)
" > ${pfile}

echo "comprobando creación"
echo ""

echo "-l"
ls -l ${pfile}
#cat ${pfile}
