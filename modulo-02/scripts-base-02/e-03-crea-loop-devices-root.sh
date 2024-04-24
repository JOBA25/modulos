#!/bin/bash
echo "Creando archivos binarios para asociarlos a loop devices"

echo "creando carpetas (puntos de montaje)"
disk_loop="/unam-diplomado-bd/loop-devices"

echo "creando Carpetas"
mkdir -p ${disk_loop}

echo "creando archivos binarios"
cd ${disk_loop}
dd if=/dev/zero of=disk-01.img bs=100M count=10
dd if=/dev/zero of=disk-02.img bs=100M count=10
dd if=/dev/zero of=disk-03.img bs=100M count=10

echo "Comprobando la creación"
du -sh disk*.img

echo "Asociando Archivos binarios a loopdevices"
losetup -fP disk-01.img
losetup -fP disk-02.img
losetup -fP disk-03.img

echo "Confirmar asociación"
losetup -a

echo "Formateando nuevos dispositivos"
mkfs.ext4 disk-01.img
mkfs.ext4 disk-02.img
mkfs.ext4 disk-03.img

echo "Creando puntos de montaje"
mkdir -p /unam-diplomado-bd/disk-01
mkdir -p /unam-diplomado-bd/disk-02
mkdir -p /unam-diplomado-bd/disk-03

