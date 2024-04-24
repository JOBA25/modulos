#!/bin/bash

mkdir /dip/u02

chmod 744 /dip

cd /dip

chown oracle:oinstall /dip/u02

chmod 640 /dip/u02


export ORACLE_SID=dev
pfile="/dip/u02/init${ORACLE_SID}.ora"

echo \
"
    db_name=${ORACLE_SID}
    memory_target=3G

" > ${pfile}


su -l oracle
export ORACLE_SID=dev

sqlplus / as sysdba

startup nomunt pfile = /dip/u02/initdev.ora














