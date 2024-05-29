connect sys/system2 as sysdba

prompt creando report_user

create user report_user identified by report_user quota unlimited on users;
GRANT CREATE SESSION TO report_user;
GRANT CREATE TABLE TO report_user;
GRANT CREATE SEQUENCE TO report_user;
GRANT CREATE TRIGGER TO report_user;
GRANT CREATE PROCEDURE TO report_user;
GRANT CREATE VIEW TO report_user;

prompt direccion y permisos de reporte
CREATE OR REPLACE DIRECTORY REPORT_DIR AS '/tmp';
GRANT READ, WRITE ON DIRECTORY REPORT_DIR TO report_user;


connect report_user/report_user 
prompt creacion tablas
CREATE TABLE TA_SMS_CAMPANIAS (
    id_campania NUMBER PRIMARY KEY,
    fecha DATE NOT NULL,
    costo NUMBER NOT NULL,
    sku VARCHAR2(50) NOT NULL
);

CREATE TABLE TA_SMS_DETALLE (
    id_detalle NUMBER PRIMARY KEY,
    id_campania NUMBER NOT NULL,
    empresa VARCHAR2(100),
    locacion VARCHAR2(100),
    telefono VARCHAR2(20),
    email VARCHAR2(100),
    CONSTRAINT fk_campania FOREIGN KEY (id_campania) REFERENCES TA_SMS_CAMPANIAS(id_campania)
);


prompt Crear secuencia para id_campania
CREATE SEQUENCE seq_id_campania
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

prompt Crear trigger para asignar el valor de la secuencia a id_campania
CREATE OR REPLACE TRIGGER trg_id_campania
BEFORE INSERT ON TA_SMS_CAMPANIAS
FOR EACH ROW
BEGIN
    :new.id_campania := seq_id_campania.NEXTVAL;
END;
/

prompt Crear secuencia para id_detalle
CREATE SEQUENCE seq_id_detalle
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

prompt Crear trigger para asignar el valor de la secuencia a id_detalle
CREATE OR REPLACE TRIGGER trg_id_detalle
BEFORE INSERT ON TA_SMS_DETALLE
FOR EACH ROW
BEGIN
    :new.id_detalle := seq_id_detalle.NEXTVAL;
END;
/

prompt Procedimiento para obtener campañas por fecha
CREATE OR REPLACE PROCEDURE SP_GET_DETALLES_BY_CAMPANIA (
    p_id_campania IN NUMBER,
    p_page_number IN NUMBER,
    p_page_size IN NUMBER,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT id_detalle, id_campania, empresa, locacion, telefono, email
    FROM (
        SELECT a.*, ROWNUM rnum
        FROM (SELECT * FROM TA_SMS_DETALLE WHERE id_campania = p_id_campania ORDER BY id_detalle) a
        WHERE ROWNUM <= p_page_number * p_page_size
    )
    WHERE rnum > (p_page_number - 1) * p_page_size;
END SP_GET_DETALLES_BY_CAMPANIA;
/

prompt Procedimiento para obtener detalles de una campaña con paginación
CREATE OR REPLACE PROCEDURE SP_GET_CAMPANIAS_BY_FECHA (
    p_fecha IN DATE,
    p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
    SELECT id_campania, fecha, costo, sku
    FROM TA_SMS_CAMPANIAS
    WHERE fecha = p_fecha;
END SP_GET_CAMPANIAS_BY_FECHA;
/









prompt Lógica para generación de reportes en archivos CSV o TXT
CREATE OR REPLACE PROCEDURE SP_GENERATE_REPORT (
    p_fecha IN DATE
) AS
    v_id_campania TA_SMS_CAMPANIAS.id_campania%TYPE;
    v_fecha TA_SMS_CAMPANIAS.fecha%TYPE;
    v_costo TA_SMS_CAMPANIAS.costo%TYPE;
    v_sku TA_SMS_CAMPANIAS.sku%TYPE;
    v_details SYS_REFCURSOR;
    v_id_detalle TA_SMS_DETALLE.id_detalle%TYPE;
    v_empresa TA_SMS_DETALLE.empresa%TYPE;
    v_locacion TA_SMS_DETALLE.locacion%TYPE;
    v_telefono TA_SMS_DETALLE.telefono%TYPE;
    v_email TA_SMS_DETALLE.email%TYPE;
    v_file UTL_FILE.FILE_TYPE;
    v_directory VARCHAR2(100) := 'REPORT_DIR';
    v_filename VARCHAR2(100);
    v_page_number NUMBER := 1;
    v_page_size NUMBER := 10000; -- Tamaño de página para la paginación
    v_record_count NUMBER := 0;
BEGIN
    FOR campania IN (SELECT id_campania, fecha, costo, sku FROM TA_SMS_CAMPANIAS WHERE fecha = p_fecha) LOOP
        v_id_campania := campania.id_campania;
        v_fecha := campania.fecha;
        v_costo := campania.costo;
        v_sku := campania.sku;

        v_filename := 'Report_Campania_' || v_id_campania || '_' || TO_CHAR(v_fecha, 'YYYYMMDD') || '.csv';
        v_file := UTL_FILE.FOPEN(v_directory, v_filename, 'W');

        -- Escribir cabecera del archivo
        UTL_FILE.PUT_LINE(v_file, 'id_detalle,id_campania,empresa,locacion,telefono,email');

        v_record_count := 0;
        LOOP
            -- Obtener detalles de la campaña con paginación
            SP_GET_DETALLES_BY_CAMPANIA(v_id_campania, v_page_number, v_page_size, v_details);
            LOOP
                FETCH v_details INTO v_id_detalle, v_id_campania, v_empresa, v_locacion, v_telefono, v_email;
                EXIT WHEN v_details%NOTFOUND;
                -- Escribir cada registro en el archivo
                UTL_FILE.PUT_LINE(v_file, v_id_detalle || ',' || v_id_campania || ',' || v_empresa || ',' || v_locacion || ',' || v_telefono || ',' || v_email);
                v_record_count := v_record_count + 1;
            END LOOP;
            CLOSE v_details;

            EXIT WHEN v_record_count < v_page_size; -- Salir del bucle si se obtiene menos registros que el tamaño de página
            v_page_number := v_page_number + 1;
        END LOOP;

        UTL_FILE.FCLOSE(v_file);
        v_page_number := 1; -- Resetear el número de página para la siguiente campaña
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores y cierre de archivo en caso de excepción
        IF UTL_FILE.IS_OPEN(v_file) THEN
            UTL_FILE.FCLOSE(v_file);
        END IF;
        RAISE;
END SP_GENERATE_REPORT;
/



-- Verificar datos en TA_SMS_CAMPANIAS
SELECT * FROM TA_SMS_CAMPANIAS WHERE fecha = TO_DATE('2024-05-22', 'YYYY-MM-DD');

-- Verificar datos en TA_SMS_DETALLE
SELECT * FROM TA_SMS_DETALLE WHERE id_campania IN (SELECT id_campania 
FROM TA_SMS_CAMPANIAS 
WHERE fecha = TO_DATE('2024-05-22', 'YYYY-MM-DD'))
order by 2 asc;


BEGIN
    SP_GENERATE_REPORT(TO_DATE('2024-05-22', 'YYYY-MM-DD'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/