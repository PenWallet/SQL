USE master
GO
DROP DATABASE huertosEcologicosDB
GO
CREATE DATABASE huertosEcologicosDB
GO
USE huertosEcologicosDB
GO

/* 
Agricultores (DNI[PK], Direcci�n, Tel�fono)
Plantas (Tipo[PK],Nombre, �poca siembra, �poca cosecha)
Parecelas (Referencia catastral{PK}, Direcci�n, DNI_Agricultores, Tipo_Plantas)
*/

CREATE TABLE Agricultores (
DNI Char(9) Not Null
,Direcci�n VarChar(40) Not Null
,Constraint PK_Agricultores Primary Key (DNI)
)

CREATE TABLE Plantas (
Tipo Char(20) Not Null
,Nombre VarChar(20)
,EpocaDeSiembra datetime
,�pocaDeCosecha datetime
,Constraint PK_Plantas Primary Key (Tipo)
)

GO

CREATE TABLE Parcelas (
refCatastral Char(20) Not Null
,Direcci�n varChar(40) Not Null
,DNI_Agricultores Char(9) Not Null
,Tipo_Plantas Char(20)
,Constraint FK_Agricultores Foreign Key (DNI_Agricultores) REFERENCES Agricultores(DNI) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint FK_Plantas Foreign Key (Tipo_Plantas) REFERENCES Plantas(Tipo) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint PK_Parcelas Primary Key (refCatastral)
)