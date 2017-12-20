USE master
GO

-- Punto 1
CREATE DATABASE Laboratorio Quimico
USE Laboratorio Quimico

GO

-- Punto 2
CREATE TABLE LQ_Elementos (
simbolo char(2) NOT NULL,
nombre varChar(15) NOT NULL,
CONSTRAINT PK_Elementos PRIMARY KEY (simbolo) )

-- Punto 3
CREATE TABLE LQ_Tipos_Compuesto (
tipo smallint NOT NULL,
denominacion varChar(30) NOT NULL,
CONSTRAINT PK_Tipos_Compuesto PRIMARY KEY (tipo),
CONSTRAINT CK_Tipos_Compuesto ALTERNATE KEY (denominacion) )

-- Punto 4
CREATE TABLE LQ_Moleculas (
nombre_clasico varChar(30) NOT NULL,
nombre_IUPAC varChar(30) NOT NULL,
color varChar(20),
densidad real,
punto_fusion real NOT NULL,
punto_ebullicion real NOT NULL,
CONSTRAINT LQ_TempFCorrecta CHECK (punto_fusion > 0),
CONSTRAINT LQ_TempECorrecta CHECK (punto_ebullicion > 0),
CONSTRAINT LQ_EmayorqueF CHECK (punto_ebullicion > punto_fusion) )

-- Punto 5
ALTER TABLE LQ_Elementos ADD COLUMN numero_atomico smallint NOT NULL
ALTER TABLE LQ_Elementos ADD COLUMN masa_atomica real NOT NULL

-- Punto 6
ALTER TABLE LQ_Moleculas ADD COLUMN codigo int IDENTITY PRIMARY KEY 

-- Punto 7
