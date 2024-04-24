#!/bin/bash
echo "Moviendo archivo de passwords para similar perdida"

echo "creando dir de respaldos"
mkdir -p /home/oracle/backups

archivoPwd="${ORACLE_HOME}/dbs/orapw${ORACLE_SID}"

echo "mover archivo de passwords"
mvn  ${archivoPwd} /home/oracle/backups

echo "Regenerando archivo de passwords"
orapwd \
  file='${archivoPwd}' \
  format=12.2 \
  sys=password

echo "comprobando la existencia del archivo de passwords"
ls -l ${archivoPwd}
