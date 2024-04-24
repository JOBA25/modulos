#!/bin/bash

echo "creando archivo de passwords"

echo "asignando el valor a ORACLE_SID: "travdip1"
export ORACLE_SID=travdip1

echo "ORACLE_SID: ${ORACLE_SID}"

archivoPwd="${ORACLE_HOME}/dbs/orapw${ORACLE_SID}"


echo "Validando si el archivo existe"

if [ -f "${archivoPwd}" ]; then
  echo "el archivo ya existe presione Enter para sobreescribir"
  echo "Ctrl c - cancelar"
  read existe
fi;

echo "Creando archivo de passwords"
orapwd FORCE=Y \
  FILE=${archivoPwd} \
  FORMAT=12.2 \
  SYS=Hola1234*

echo "Comprobando la creación del archivo"

ls -l ${archivoPwd}