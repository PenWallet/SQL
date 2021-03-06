GO
CREATE DATABASE tiendaCafeBD
GO
USE tiendaCafeBD
GO
CREATE TABLE Cafeses (
Nombre Char(20) Not Null
,Origen Char(20) Null
,Constraint PK_Cafeses Primary Key (Nombre)
)

CREATE TABLE Propiedades (
ID smallint Not Null
,Nombre varChar(20) Not Null
,Descripción varChar(240) Null
,Constraint PK_Propiedades Primary Key (ID)
)

CREATE TABLE Clientes (
DNI Char(9) Not Null
,Nombre varChar(20) Not Null
,Dirección varChar(40) Not Null
,Constraint PK_Clientes Primary Key (DNI)
)
GO
CREATE TABLE Mezclas (
Codigo int Not Null
,Nombre varChar(20) Not Null
,DNI_Clientes Char(9) Not Null
,Constraint PK_Mezclas Primary Key (Codigo)
,Constraint FK_ClientesM Foreign Key (DNI_Clientes) REFERENCES Clientes(DNI) ON DELETE NO ACTION ON UPDATE CASCADE
)
GO
CREATE TABLE CafesesPropiedades (
Nombre_Cafeses Char(20) Not Null
,ID_Propiedades smallint Not Null
,Constraint FK_CafesesP Foreign Key (Nombre_Cafeses) REFERENCES Cafeses(Nombre) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint FK_Propiedades Foreign Key (ID_Propiedades) REFERENCES Propiedades(ID) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint PK_CafesesPropiedades Primary Key (Nombre_Cafeses,ID_Propiedades)
)

CREATE TABLE CafesesMezclas (
Nombre_Cafeses Char(20) Not Null
,Codigo_Mezclas int Not Null
,Constraint FK_CafesesM Foreign Key (Nombre_Cafeses) REFERENCES Cafeses(Nombre) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint FK_MezclasC Foreign Key (Codigo_Mezclas) REFERENCES Mezclas(Codigo) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint PK_CafesesMezclas Primary Key (Nombre_Cafeses, Codigo_Mezclas)
)

CREATE TABLE MezclasClientes (
Codigo_Mezclas int Not Null
,DNI_Clientes Char(9)
,Constraint FK_MezclasCl Foreign Key (Codigo_Mezclas) REFERENCES Mezclas(Codigo) ON DELETE NO ACTION ON UPDATE CASCADE
,Constraint FK_Clientes Foreign Key (DNI_Clientes) REFERENCES Clientes(DNI) ON DELETE NO ACTION ON UPDATE NO ACTION
,Constraint PK_MezclasClientes Primary Key (Codigo_Mezclas, DNI_Clientes)
)