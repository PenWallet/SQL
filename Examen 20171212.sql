USE master
GO
CREATE DATABASE Examen20171212
GO
USE Examen20171212

SET DATEFORMAT 'YMD'

CREATE TABLE SicariosMatonesGanchos (
ID int NOT NULL,
Nombre varChar(20) NOT NULL,
Apellidos varChar(40) NULL,
Nacionalidad varChar(20) NULL,
ArmaFavorita varChar(15) NULL,
FechaNacimiento date NULL,
CONSTRAINT PK_SicariosMatonesGanchos PRIMARY KEY (ID) )

CREATE TABLE Apodos (
Nombre varChar(20) NOT NULL, --Le pongo varChar porque aunque es PK, sigue siendo un apodo y puede cambiar
ID_SMG int NOT NULL,
CONSTRAINT PK_Apodos PRIMARY KEY (Nombre),
CONSTRAINT FK_Apodos_SMG FOREIGN KEY (ID_SMG) REFERENCES SicariosMatonesGanchos(ID) )

CREATE TABLE Idiomas (
Nombre_Idioma char(15) NOT NULL,
Nivel varChar(5) NOT NULL, -- El nivel será alto, medio o bajo, y es NOT NULL porque si fuera NULL significaría que no tiene nivel, por lo que no sabría ese idioma
ID_SMG int NOT NULL,
CONSTRAINT PK_Idiomas PRIMARY KEY (Nombre_Idioma),
CONSTRAINT FK_Idiomas_SMG FOREIGN KEY (ID_SMG) REFERENCES SicariosMatonesGanchos(ID) )

CREATE TABLE Victima (
ID int NOT NULL,
Nombre varChar(20) NOT NULL,
Apellidos varChar(40) NULL,
Nacionalidad varChar(20) NULL,
FechaNac date NOT NULL,
Estatura decimal(3,2) NULL,
TallaRopa tinyint NOT NULL, -- Como chulos, es su deber saber qué ropa les va a quedar más ajustada, así que NOT NULL
Raza char(15) NULL, --Char porque no te puedes cambiar de raza a menos que seas Michael Jackson
ColorPelo varChar(15) NULL,
ContornoPecho smallint NOT NULL, --Quién sabe, a lo mejor tinyint es poco para una de ellas, y deben saber su contorno para extorsionarlas mejor
ID_SMG int NOT NULL,
Promesa varChar(100) NOT NULL, --Les tuvieron que hacer una promesa para traerla a las tierras de la libertad
CantidadDebida smallmoney NOT NULL,
CONSTRAINT PK_Victima PRIMARY KEY (ID),
CONSTRAINT FK_Victima_SMG FOREIGN KEY (ID_SMG) REFERENCES SicariosMatonesGanchos(ID) )

CREATE TABLE Familiar (
ID int NOT NULL,
Nombre varChar(20) NOT NULL,
Apellidos varChar(40) NULL,
Domicilio varChar(50) NOT NULL, --Deben saber el domicilio para poder ir a extorsionarlos
Parentesco varChar(20) NULL,
ID_Victima int NOT NULL,
CONSTRAINT PK_Familiar PRIMARY KEY (ID) )

CREATE TABLE Servicios (
ID int NOT NULL,
FechaHora datetime NOT NULL, --Deben tener controladas a sus putas
ImporteAbonado smallmoney NOT NULL, --No pueden no saber cuánto cobran
NombrePutero varChar(20) NOT NULL,
ImporteVictima smallmoney NOT NULL,
ID_Victima int NOT NULL,
ImporteCobrado smallmoney NOT NULL,
CONSTRAINT PK_Servicios PRIMARY KEY (ID),
CONSTRAINT FK_Servicios_Victima FOREIGN KEY (ID_Victima) REFERENCES Victima(ID) )

CREATE TABLE Lugares (
ID int NOT NULL,
Denominacion varChar(20) NULL,
Direccion varChar(50),
CONSTRAINT PK_Lugar PRIMARY KEY (ID) )

CREATE TABLE Habitacion (
NombreHotel char(20) NOT NULL,
NumeroHabitacion smallint NOT NULL, --tinyint solo llega hasta el 128, y los hoteles suelen tener 201, 301, etc.
Superficie smallint NULL,
ID_Servicios int NOT NULL,
Direccion_Sitio char(50) NOT NULL,
CONSTRAINT PK_Habitacion PRIMARY KEY (NombreHotel, NumeroHabitacion),
CONSTRAINT FK_Habitacion_Servicios FOREIGN KEY (ID_Servicios) REFERENCES Servicios(ID),
CONSTRAINT UQ_Habitacion_Servicios UNIQUE(ID_Servicios) )

CREATE TABLE Sitio (
Direccion char(50) NOT NULL )

CREATE TABLE LugarVictima (
ID_Lugares int NOT NULL,
ID_Victima int NOT NULL,
FechaIngreso date NOT NULL,
FechaSalida date NULL )

CREATE TABLE MatonLugarVictima (
ID_Sicario int NOT NULL,
ID_Victima int NOT NULL,
Agresion varChar(30) NOT NULL )

--Ejercicio 5
CREATE TABLE Envios (
ID_Victima int NOT NULL,
ID_Familiar int NOT NULL,
Importe smallmoney NOT NULL,
FechaEntrega date NOT NULL )

ALTER TABLE Familiar ADD CONSTRAINT FK_Familiar_Victima FOREIGN KEY (ID_Victima) REFERENCES Victima(ID) ON UPDATE CASCADE ON DELETE CASCADE

ALTER TABLE Sitio ADD CONSTRAINT PK_Sitio PRIMARY KEY (Direccion)

ALTER TABLE Habitacion ADD CONSTRAINT FK_Habitacion_Sitio FOREIGN KEY (Direccion_Sitio) REFERENCES Sitio(Direccion)

ALTER TABLE LugarVictima ADD CONSTRAINT FK_LugarVictima_Lugar FOREIGN KEY (ID_Lugares) REFERENCES Lugares(ID)
ALTER TABLE LugarVictima ADD CONSTRAINT FK_LugarVictima_Victima FOREIGN KEY (ID_Victima) REFERENCES Victima(ID)
ALTER TABLE LugarVictima ADD CONSTRAINT PK_LugarVictima PRIMARY KEY (ID_Lugares, ID_Victima)

ALTER TABLE MatonLugarVictima ADD CONSTRAINT FK_MLV_SMG FOREIGN KEY (ID_Sicario) REFERENCES SicariosMatonesGanchos(ID)
ALTER TABLE MatonLugarVictima ADD CONSTRAINT FK_MLV_Victima FOREIGN KEY (ID_Victima) REFERENCES Victima(ID)
ALTER TABLE MatonLugarVictima ADD CONSTRAINT PK_MLV PRIMARY KEY (ID_Sicario, ID_Victima)

ALTER TABLE Idiomas ADD CONSTRAINT CK_NivelIngles CHECK (Nivel IN ('bajo', 'medio', 'alto'))

--Ejercicio 3
ALTER TABLE Victima ADD CONSTRAINT CK_MayorDe18 CHECK ((Year(Current_Timestamp -CAST('2001-10-13' AS SmallDateTime))-1900) >= 18)
ALTER TABLE Victima ADD CONSTRAINT CK_TallaRopa CHECK (TallaRopa BETWEEN 36 AND 46)
ALTER TABLE LugarVictima ADD CONSTRAINT CK_BackToTheFuture CHECK ((FechaSalida > FechaIngreso) OR FechaSalida = NULL)
ALTER TABLE Servicios ADD CONSTRAINT CK_LoTuyoPaMi CHECK (ImporteVictima <= (ImporteAbonado * 0.2))