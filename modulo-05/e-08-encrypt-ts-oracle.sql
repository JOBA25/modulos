--@Autor: Jorge Octavio Barcenas Avelar
--@Fecha creación: Enero 12 2024
--@Descripción: ejercicio 8

Prompt  conectando como sys
connect sys/system2 as sysdba

Prompt 2. crear y abrir el wallet
alter system set encryption key identified by "wallet_password";

/*
Los wallets deben ser abiertos cada vez que la instancia se inicia.
De ser necesario pueden cerrarse para evitar que usuarios accedan a 
los datos cifrados empleando alguna de las siguientes instrucciones:

alter system set encryption wallet open identified by "mypassword";
alter system set encryption wallet close;

*/

Prompt 3. Crear un nuevo tablespace empleando la cláusula encryption y de forma opcional el algoritmo a emplear.
create tablespace m05_encrypted_ts
datafile '/u01/app/oracle/oradata/JBADIP02/m05_encrypted_ts01.dbf' size 10M
autoextend on next 64k
encryption using 'aes256'
default storage(encrypt);

prompt 4 signarle cuota de almacenamiento al usuario jorge05
alter user jorge05 quota unlimited on m05_encrypted_ts;

Prompt 5 
select tablespace_name, encrypted
from dba_tablespaces;

pause [Enter] para continuar

Prompt 6 Empleando al usuario jorge05, crear algunos objetos para comprobar que los datos contenidos serán cifrados
connect jorge05/jorge

create table mensaje_seguro(
    id number,
    mensaje varchar(20)
) tablespace m05_encrypted_ts;


create index mensaje_seguro_ix on mensaje_seguro(mensaje)
tablespace m05_encrypted_ts;

insert into mensaje_seguro(id,mensaje) values (1,'mensaje 1');
insert into mensaje_seguro(id,mensaje) values (2,'mensaje 2');

Prompt 7. creando la misma tabla en ts users
create table mensaje_inseguro(
    id number,
    mensaje varchar(20)
);

insert into mensaje_inseguro(id,mensaje) values (1,'mensaje 1');
insert into mensaje_inseguro(id,mensaje) values (2,'mensaje 2');

commit;

Prompt 8. forzando sincronización con checkpoint 
connect sys/system2 as sysdba

alter system checkpoint;

Prompt 9. busqueda en ts cifrado
!strings /u01/app/oracle/oradata/JBADIP02/m05_encrypted_ts01.dbf | grep "mensaje"


pause [Enter] para continuar

Prompt 10. busqueda en ts users
!strings /u01/app/oracle/oradata/JBADIP02/users01.dbf | grep "mensaje"


prompt 11 reiniciando 
shutdown immediate 
startup

prompt consultando datos nuevamente
connect jorge05/jorge

select * from mensaje_seguro;


pause [Enter] para arreglar el error (abirendo el wallet) y continuar


connect sys/system2 as sysdba
alter system set encryption wallet open identified by "wallet_password";

prompt 11 mostrando datos nuevamente
connect jorge05/jorge

select * from mensaje_seguro;


pause [Enter] para continuar
prompt 12 limpieza

drop table mensaje_seguro;
drop table mensaje_inseguro;

connect sys/system2 as sysdba
drop tablespace m05_encrypted_ts including contents and datafiles;