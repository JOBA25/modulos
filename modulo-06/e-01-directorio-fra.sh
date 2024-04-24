#!/bin/bash

echo "1. creando directorio para la FRA"

mkdir -p /unam-diplomado-bd/fast-recovery-area

echo "2 Cambiando usuario y permisos"
chown oracle:oinstall /unam-diplomado-bd/fast-recovery-area
chmod 750 /unam-diplomado-bd/fast-recovery-area

echo "3 mostrando estructura de directorios "
tree /unam-diplomado-bd/fast-recovery-area

exit