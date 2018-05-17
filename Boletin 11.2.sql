USE LeoTurf

--1.Escribe un procedimiento para dar de alta un nuevo jugador. Los parámetros de entrada serán todos los datos 
--del jugador y la cantidad de su aportación inicial para apostar.
--El procedimiento insertará al jugador y generará su primer apunte.
GO
CREATE PROCEDURE DarDeAlta (@ID int, @Nombre varchar(20), @Apellidos varchar(30), @Direccion varchar(50), @Telefono char(9), @Ciudad varchar(20), @Importe smallmoney)
AS
	BEGIN
		BEGIN TRANSACTION
			INSERT INTO LTJugadores (ID, Nombre, Apellidos, Direccion, Telefono, Ciudad)
							VALUES (@ID, @Nombre, @Apellidos, @Direccion, @Telefono, @Ciudad)

			INSERT INTO LTApuntes (IDJugador, Orden, Fecha, Importe, Saldo, Concepto)
						VALUES (@ID, 1, CAST(CURRENT_TIMESTAMP AS date), @Importe, @Importe, 'Ingreso inicial')
		COMMIT
	END
GO

BEGIN TRANSACTION
	EXECUTE DarDeAlta 999, 'Ludo', 'Pata', 'c/Falsa 123', '666999666', 'Springfield', 500
COMMIT
ROLLBACK

SELECT * FROM LTApuntes
--2.Escribe un procedimiento para inscribir un caballo en una carrera. El procedimiento tendrá como parámetros 
--de entrada el ID de la carrera y el ID del caballo, y devolverá un parámetro de salida que indicará el número
--asignado al caballo en esa carrera. El número estará comprendido entre 1 y 99 y lo puedes asignar por el método
--que quieras, aunque teniendo en cuenta que no puede haber dos caballos con el mismo número en una carrera. 
--Si la carrera no existe, si hay ocho caballos ya inscritos o si el caballo no existe o está ya inscrito en 
--esa carrera, el parámetro de salida devolverá NULL.
GO
ALTER PROCEDURE InscribirCaballo (@IDCarrera int, @IDCaballo int, @NumeroAsignado int OUTPUT)
AS
	BEGIN
		IF(
			EXISTS(SELECT ID FROM LTCarreras WHERE ID = @IDCarrera) AND
			(SELECT COUNT(IDCaballo) FROM LTCaballosCarreras WHERE IDCarrera = @IDCarrera) < 8 AND
			EXISTS(SELECT ID FROM LTCaballos WHERE ID = @IDCaballo) AND
			NOT EXISTS(SELECT IDCaballo FROM LTCaballosCarreras WHERE IDCaballo = @IDCaballo AND IDCarrera = @IDCarrera) 
			)
		BEGIN
			SET @NumeroAsignado = 1
			WHILE(@NumeroAsignado IN (SELECT Numero FROM LTCaballosCarreras WHERE IDCarrera = @IDCarrera))
			BEGIN
				SET @NumeroAsignado = @NumeroAsignado + 1
			END

			INSERT INTO LTCaballosCarreras (IDCaballo, IDCarrera, Numero)
									VALUES (@IDCaballo, @IDCarrera, @NumeroAsignado)

		END
		ELSE
		BEGIN
			SET @NumeroAsignado = NULL
			PRINT 'Hola Oscar'
		END
	END
GO

BEGIN TRANSACTION
DECLARE @Salida int
EXECUTE InscribirCaballo 3, 11, @Salida OUTPUT
PRINT 'Salida: '+CAST(@Salida AS varchar)

SELECT IDCarrera, IDCaballo, Numero FROM LTCaballosCarreras ORDER BY IDCarrera, IDCaballo
--COMMIT
--ROLLBACK



--Añade a la tabla LTJugadores una nueva columna llamada LimiteCredito de tipo SmallMoney con el valor por defecto 50.
--Este valor indicará el máximo saldo negativo que se permite al jugador. El saldo del jugador más el valor de esa
--columna no puede ser nunca inferior a 0.
--Escribe un procedimiento para grabar una apuesta. El procedimiento recibirá como parámetros el jugador, la carrera,
--el caballo y el importe a apostar y devolverá con return un código de terminación según la siguiente tabla:

BEGIN TRANSACTION
ALTER TABLE LTJugadores
	ADD LimiteCredito smallmoney NOT NULL
		CONSTRAINT LTJ_LC_DefaultValue DEFAULT 50
COMMIT

GO
CREATE PROCEDURE GrabarApuesta (@IDJugador int, @IDCarrera int, @IDCaballo int, @Apuesta smallmoney, @Codigo int = 0 OUTPUT)
AS
	IF(EXISTS (SELECT ID FROM LTCarreras WHERE ID = @IDCarrera))
		BEGIN
			IF((SELECT Fecha FROM LTCarreras WHERE ID = @IDCarrera) < CAST(CURRENT_TIMESTAMP AS date))
				BEGIN
					IF(EXISTS (SELECT IDCaballo FROM LTCaballosCarreras WHERE IDCarrera = @IDCarrera AND IDCaballo = @IDCaballo))
						BEGIN
							IF(((SELECT TOP 1 Saldo FROM LTApuntes WHERE IDJugador = @IDJugador ORDER BY Fecha desc) + (SELECT LimiteCredito FROM LTJugadores AS J WHERE ID = @IDJugador)) < 0)
								BEGIN
									INSERT INTO LTApuestas (Clave, IDCaballo, IDCarrera, Importe, IDJugador)
										VALUES('watisthis', @IDCaballo, @IDCarrera, @Apuesta, @IDJugador)

									--DECLARE @NuevoOrden int = SELECT(TOP 1 Orden FROM LTApuntes WHERE IDJugador = @IDJugador ORDER BY Fecha desc) + 1

									INSERT INTO LTApuntes (IDJugador, Orden, Fecha, Importe, Saldo, Concepto)
													VALUES(@IDJugador, (SELECT TOP 1 Orden+1 FROM LTApuntes WHERE IDJugador = @IDJugador ORDER BY Fecha desc), CAST(CURRENT_TIMESTAMP as date), @Apuesta, (SELECT TOP 1 Saldo FROM LTApuntes WHERE IDJugador = @IDJugador ORDER BY Fecha desc) - @Apuesta, CONCAT('Apuesta ',@@IDENTITY))
								END
							ELSE
								SET @Codigo = 10
						END
					ELSE
						SET @Codigo = 5
				END
			ELSE
				SET @Codigo = 3
		END
	ELSE
		SET @Codigo = 2 
GO

--PRUEBAS
SELECT Nombre WHERE Sexo = H

--LEL
SELECT * FROM LTApuntes ORDER BY Fecha desc
SELECT TOP 1 Saldo FROM LTApuntes WHERE IDJugador = 13 ORDER BY Fecha desc
SELECT * FROM LTJugadores
SELECT * FROM LTApuestas ORDER BY ID desc
SELECT * FROM LTApuntes
SELECT * FROM LTApuntes WHERE IDJugador = 1
SELECT TOP 1 Orden FROM LTApuntes WHERE IDJugador = 1 ORDER BY Fecha desc

BEGIN TRANSACTION
INSERT INTO LTApuestas (Clave, IDCaballo, IDCarrera, Importe, IDJugador)
				VALUES('watisthis', 1, 1, 11, 1)
ROLLBACK