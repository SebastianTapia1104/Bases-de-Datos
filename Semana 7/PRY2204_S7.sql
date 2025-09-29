/* =========================================================
   CASO 1 : IMPLEMENTACIÓN DEL MODELO
   ========================================================= */
/* =========================================================
   LIMPIEZA DE TABLAS 
   ========================================================= */
DROP TABLE DOMINIO CASCADE CONSTRAINTS;
DROP TABLE TITULACION CASCADE CONSTRAINTS;
DROP TABLE PERSONAL CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE TITULO CASCADE CONSTRAINTS;
DROP TABLE GENERO CASCADE CONSTRAINTS;
DROP TABLE ESTADO_CIVIL CASCADE CONSTRAINTS;
DROP TABLE COMPANIA CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;

/* =========================================================
   TABLAS INDEPENDIENTES / FUERTES
   ========================================================= */

--En cada tabla, las PK no se escribieron como NOT NULL, ya que al ser PK, es automático la obligatoriedad.

CREATE TABLE REGION (
    id_region NUMBER(2) GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2),
    nombre_region VARCHAR2(25) NOT NULL,
    CONSTRAINT REGION_PK PRIMARY KEY (id_region) 
);


CREATE TABLE COMUNA (
    id_comuna NUMBER(5),
    nombre_comuna VARCHAR2(25) NOT NULL,
    id_region NUMBER(2) NOT NULL,
    CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna),
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (id_region) REFERENCES REGION (id_region)
);


CREATE TABLE COMPANIA (
    id_empresa NUMBER(2),
    nombre_empresa VARCHAR2(25) NOT NULL,
    calle VARCHAR2(50) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    renta_promedio NUMBER(10) NOT NULL,
    pct_aumento NUMBER(4,3), --opcional
    id_comuna NUMBER(5) NOT NULL,
    id_region NUMBER(2) NOT NULL,
    CONSTRAINT COMPANIA_PK PRIMARY KEY (id_empresa),
    CONSTRAINT UN_COMPANIA_NOMBRE UNIQUE (nombre_empresa),
    CONSTRAINT COMPANIA_FK_COMUNA FOREIGN KEY (id_comuna) REFERENCES COMUNA (id_comuna),
    CONSTRAINT COMPANIA_FK_REGION FOREIGN KEY (id_region) REFERENCES REGION (id_region)
);


CREATE TABLE ESTADO_CIVIL (
    id_estado_civil VARCHAR2(2),
    descripcion_est_civil VARCHAR2(25) NOT NULL,
    CONSTRAINT ESTADO_CIVIL_PK PRIMARY KEY (id_estado_civil)
);


CREATE TABLE GENERO (
    id_genero VARCHAR2(3),
    descripcion_genero VARCHAR2(25) NOT NULL,
    CONSTRAINT GENERO_PK PRIMARY KEY (id_genero)
);


CREATE TABLE TITULO (
    id_titulo VARCHAR2(3),
    descripcion_titulo VARCHAR2(60) NOT NULL,
    CONSTRAINT TITULO_PK PRIMARY KEY (id_titulo)
);


CREATE TABLE IDIOMA (
    id_idioma NUMBER(3) GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3),
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT IDIOMA_PK PRIMARY KEY (id_idioma)
);


CREATE TABLE PERSONAL (
    rut_persona NUMBER(8),
    dv_persona CHAR(1) NOT NULL,
    primer_nombre VARCHAR2(25) NOT NULL,
    segundo_nombre VARCHAR2(25), 
    primer_apellido VARCHAR2(25) NOT NULL,
    segundo_apellido VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    email VARCHAR2(100), 
    calle VARCHAR2(50) NOT NULL,
    numeracion NUMBER(5) NOT NULL,
    sueldo NUMBER(5) NOT NULL,
    id_comuna NUMBER(5) NOT NULL,
    id_genero VARCHAR2(3),
    id_estado_civil VARCHAR2(2),
    id_empresa NUMBER(2) NOT NULL,
    encargado_rut NUMBER(8),
    CONSTRAINT PERSONAL_PK PRIMARY KEY (rut_persona),
    CONSTRAINT FK_PERSONAL_EMPRESA FOREIGN KEY (id_empresa) REFERENCES COMPANIA (id_empresa),
    CONSTRAINT FK_PERSONAL_COMUNA FOREIGN KEY (id_comuna) REFERENCES COMUNA (id_comuna),
    CONSTRAINT FK_PERSONAL_ESTADOCIVIL FOREIGN KEY (id_estado_civil) REFERENCES ESTADO_CIVIL (id_estado_civil),
    CONSTRAINT FK_PERSONAL_GENERO FOREIGN KEY (id_genero) REFERENCES GENERO (id_genero),
    CONSTRAINT FK_PERSONAL_PERSONAL FOREIGN KEY (encargado_rut) REFERENCES PERSONAL (rut_persona)
);
/* =========================================================
   TABLAS DEPENDIENTES / DÉBILES
   ========================================================= */

CREATE TABLE TITULACION (
    id_titulo VARCHAR2(3),
    persona_rut NUMBER(8),
    fecha_titulacion DATE NOT NULL,
    CONSTRAINT TITULACION_PK PRIMARY KEY (id_titulo, persona_rut),
    CONSTRAINT FK_TITULACION_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL (rut_persona),
    CONSTRAINT FK_TITULACION_TITULO FOREIGN KEY (id_titulo) REFERENCES TITULO (id_titulo)
);


CREATE TABLE DOMINIO (
    id_idioma NUMBER(3),
    persona_rut NUMBER(8),
    nivel VARCHAR2(25) NOT NULL,
    CONSTRAINT DOMINIO_PK PRIMARY KEY (id_idioma, persona_rut),
    CONSTRAINT FK_DOMINIO_IDIONA FOREIGN KEY (id_idioma) REFERENCES IDIOMA (id_idioma),
    CONSTRAINT FK_DOMINIO_PERSONAL FOREIGN KEY (persona_rut) REFERENCES PERSONAL (rut_persona)
);

/* =========================================================
   CASO 2 : MODIFICACIÓN DEL MODELO
   ========================================================= */

ALTER TABLE PERSONAL
ADD CONSTRAINT UN_PERSONAL_EMAIL UNIQUE (email);


ALTER TABLE PERSONAL
ADD CONSTRAINT CK_PERSONAL_DV CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K'));


ALTER TABLE PERSONAL
ADD CONSTRAINT CK_PERSONAL_SUELDO CHECK (sueldo >= 450000);

/* =========================================================
   CASO 3 : POBLAMIENTO DEL MODELO
   ========================================================= */

/* ===== TABLA REGION ===== */
INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('REGION METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');


-- Secuencia para COMUNA
DROP SEQUENCE SEQ_COMUNA;
CREATE SEQUENCE SEQ_COMUNA START WITH 1101 INCREMENT BY 6;

/* ===== TABLA COMUNA ===== */
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Arica', 7);
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Santiago', 9);
INSERT INTO COMUNA (id_comuna, nombre_comuna, id_region) VALUES (SEQ_COMUNA.NEXTVAL, 'Temuco', 11);


/* ===== TABLA IDIOMA ===== */
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Chino');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Aleman');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');


-- Secuencia para COMPANIA
DROP SEQUENCE SEQ_COMPANIA;
CREATE SEQUENCE SEQ_COMPANIA START WITH 10 INCREMENT BY 5;

/* ===== TABLA COMPANIA ===== */
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'CCyRojas', 'Amapolas', 506, 1857000, 0.5, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'SenTTy', 'Los Alamos', 3490, 897000, 0.025, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'Praxia LTDA', 'Las Camelias', 11098, 2157000, 0.035, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'TIC spa', 'FLORES S.A.', 4357, 857000, NULL, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757000, 0.015, 1101, 7);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589000, 0.015, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D.32', 509, 1857000, 0.025, 1113, 11);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA', 206, 1857000, NULL, 1107, 9);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113, 11);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, id_comuna, id_region)
VALUES (SEQ_COMPANIA.NEXTVAL, 'FRIENDS P. S.A', 'SUECIA', 506, 857000, 0.015, 1113, 11);

/* =========================================================
   CASO 4 : RECUPERACION DE DATOS
   ========================================================= */

/* =========================================================
   INFORME 1 – Empresas pertenecientes
   ========================================================= */
   
SELECT 
    nombre_empresa       AS "Nombre Empresa",
    calle || ' ' || numeracion AS "Dirección",
    renta_promedio       AS "Renta Promedio",
    CASE 
        WHEN pct_aumento IS NOT NULL 
        THEN renta_promedio + (renta_promedio * pct_aumento)
        ELSE NULL
    END                  AS "Simulación de Renta"
FROM COMPANIA
ORDER BY 
    "Renta Promedio" DESC,
    "Nombre Empresa" ASC;

/* =========================================================
   INFORME 2 – Empresas con renta promedio simulada
   ========================================================= */

-- La indicación de la actividad dice "La renta promedio incrementada, es decir, la renta aumentada tras aplicar el porcentaje adicional."   
-- Énfasis en "tras aplicar", por lo tanto, corresponde a esta tabla
SELECT
    id_empresa                AS "CODIGO",
    nombre_empresa            AS "EMPRESA",
    renta_promedio            AS "PROM RENTA ACTUAL",
    CASE 
        WHEN pct_aumento IS NOT NULL 
        THEN pct_aumento + 0.15
        ELSE NULL
    END                       AS "PCT AUMENTADO EN 15%",
    CASE 
        WHEN pct_aumento IS NOT NULL 
        THEN renta_promedio * (1 + pct_aumento + 0.15)
        ELSE NULL
    END                       AS "PROM RENTA INCREMENTADA"
FROM COMPANIA
ORDER BY 
    "PROM RENTA ACTUAL" ASC,
    "EMPRESA" DESC;

-- Sin embargo, la tabla adjuntada en la actividad es esta otra de acá:
-- Donde se deja cuánto aumentó solamente, no el resultado
SELECT
    id_empresa       AS "CODIGO",
    nombre_empresa   AS "EMPRESA",
    renta_promedio   AS "PROM RENTA ACTUAL",
    CASE
        WHEN pct_aumento IS NOT NULL
        THEN pct_aumento + 0.15
    END              AS "PCT AUMENTADO EN 15%",
    CASE
        WHEN pct_aumento IS NOT NULL
        THEN renta_promedio * (pct_aumento + 0.15)   -- SOLO el aumento
    END              AS "RENTA AUMENTADA"
FROM COMPANIA
ORDER BY
    "PROM RENTA ACTUAL" ASC,
    "EMPRESA" DESC;