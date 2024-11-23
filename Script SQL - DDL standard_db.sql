-- Eliminar la base de datos si ya existe y crearla con utf8mb4
DROP DATABASE IF EXISTS standard_db;
CREATE DATABASE standard_db CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base de datos recién creada
USE standard_db;

-- Tabla API
CREATE TABLE API (
	ID_API VARCHAR (20) NOT NULL UNIQUE,
    NOMBRE VARCHAR (250) NOT NULL,
    LOTE_MP VARCHAR (20) NOT NULL,
    TITULO DEC(5,1) NOT NULL,
    VENCIMIENTO DATE NOT NULL,
    PROVEEDOR VARCHAR (50) NOT NULL,
    ORIGEN VARCHAR (50),
    PRIMARY KEY (ID_API)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla ESTANDAR 
CREATE TABLE ESTANDAR (
	LOTE_STD VARCHAR (20) NOT NULL UNIQUE,
    ID_API VARCHAR (20) NOT NULL,
    PRESENTACION INT NOT NULL,
    TITULO DEC(5,1) NOT NULL,
    VENCIMIENTO DATE NOT NULL,
	REANALISIS DATE NOT NULL,
    OBSERVACIONES VARCHAR (250),
    CATEGORIA VARCHAR (10),
    CANT_VIAL_TOTAL INT NOT NULL,
    PRIMARY KEY (LOTE_STD),
	CONSTRAINT FK_ID_API FOREIGN KEY (ID_API) REFERENCES API (ID_API)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla DEPARTAMENTO 
CREATE TABLE DEPARTAMENTO (
	ID_DEP VARCHAR (5) NOT NULL UNIQUE,
    NOMBRE VARCHAR (20) NOT NULL UNIQUE,
    PRIMARY KEY (ID_DEP)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla ANALISTA
CREATE TABLE ANALISTA (
	LEGAJO_ANALISTA INT NOT NULL UNIQUE,
    ID_DEP VARCHAR (5) NOT NULL,
    NOMBRE VARCHAR (30) NOT NULL,
    APELLIDO VARCHAR (30) NOT NULL,
    DNI INT NOT NULL UNIQUE,
    PRIMARY KEY (LEGAJO_ANALISTA),
    CONSTRAINT FK_ID_DEP FOREIGN KEY (ID_DEP) REFERENCES DEPARTAMENTO (ID_DEP)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla PEDIDO 
CREATE TABLE PEDIDO (
	ID_PEDIDO INT NOT NULL UNIQUE AUTO_INCREMENT,
    LEGAJO_ANALISTA INT NOT NULL,
    FECHA DATE NOT NULL,
    NOMBRE_API VARCHAR (250) NOT NULL,
    PRIMARY KEY (ID_PEDIDO),
    CONSTRAINT FK_LEGAJO_ANALISTA FOREIGN KEY (LEGAJO_ANALISTA) REFERENCES ANALISTA (LEGAJO_ANALISTA)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla CARACTERIZACION_API 
CREATE TABLE CARACTERIZACION_API (
	ID_ORDEN INT NOT NULL UNIQUE AUTO_INCREMENT,
    ID_PEDIDO INT NOT NULL UNIQUE,
    FECHA DATE NOT NULL,
    COMPLETO BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (ID_ORDEN),
    CONSTRAINT FK_ID_PEDIDO FOREIGN KEY (ID_PEDIDO) REFERENCES PEDIDO (ID_PEDIDO)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla ALMACENAMIENTO 
CREATE TABLE ALMACENAMIENTO (
	ID_ALMACENAMIENTO VARCHAR (5) NOT NULL UNIQUE,
	DESCRIPCION_ALM VARCHAR (20) NOT NULL UNIQUE,
	PRIMARY KEY (ID_ALMACENAMIENTO)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Tabla STOCK 
CREATE TABLE STOCK (
	ID_STOCK INT NOT NULL UNIQUE AUTO_INCREMENT,
	LOTE_STD VARCHAR (20) NOT NULL,
	ID_ALMACENAMIENTO VARCHAR (5) NOT NULL,
    CANT_VIALES INT NOT NULL,
	ID_ORDEN INT NOT NULL UNIQUE,
	PRIMARY KEY (ID_STOCK),
    CONSTRAINT FK_LOTE_STD FOREIGN KEY (LOTE_STD) REFERENCES ESTANDAR (LOTE_STD),
	CONSTRAINT FK_ID_ALMACENAMIENTO FOREIGN KEY (ID_ALMACENAMIENTO) REFERENCES ALMACENAMIENTO (ID_ALMACENAMIENTO),
    CONSTRAINT FK_ID_ORDEN FOREIGN KEY (ID_ORDEN) REFERENCES CARACTERIZACION_API (ID_ORDEN)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
