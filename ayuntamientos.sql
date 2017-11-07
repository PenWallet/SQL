/*
Personas (DNI[PK], Nombre, Apellidos, FechaDeAlta, Tipo)
Alcaldes (DNI[FK y PK], Partido, Nº votos)
Secretarios (DNI[FK y PK])
Ayuntamientos (Dirección[PK], Nombre, Provincia)

*/

CREATE DATABASE ayuntamientoDB
GO
USE ayuntamientoDB
GO
CREATE TABLE Personas (
DNI char(9) Not null,
Nombre varChar(20) Not null,
Apellidos varChar (50) Not Null,
FechaDeAlta date Not Null,
Tipo varChar(15),
Constraint PK_Personas Primary Key (DNI) )

GO

CREATE TABLE Alcaldes (
DNI char(9) Not Null,
Partido varChar(20) Not Null,
NumeroDeVotos int Not Null,
Constraint PK_Alcaldes Primary Key (DNI),
Constraint FK_Alcaldes_Personas Foreign Key (DNI) REFERENCES Personas(DNI) ON DELETE NO ACTION ON UPDATE CASCADE )

GO

CREATE TABLE Secretarios (
DNI char(9) Not Null,
Constraint PK_Secretarios Primary Key (DNI),
Constraint FK_Secretarios_Personas Foreign Key (DNI) REFERENCES Personas(DNI) ON DELETE NO ACTION ON UPDATE CASCADE )

GO

CREATE TABLE Ayuntamientos (
Direccion char(40) Not Null,
Nombre char(20) Not Null,
Provincia char(20) Not Null,
DNI_Alcaldes char(9) Not Null,
DNI_Secretarios char(9) Not Null,
Constraint PK_Ayuntamientos Primary Key (Direccion),
Constraint FK_Ayuntamientos_Alcaldes Foreign Key (DNI_Alcaldes) REFERENCES Alcaldes(DNI),
Constraint FK_Ayuntamientos_Secretarios Foreign Key (DNI_Secretarios) REFERENCES Secretarios(DNI) )