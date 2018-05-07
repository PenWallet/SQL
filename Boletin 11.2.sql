USE LeoTurf

--1.Escribe un procedimiento para dar de alta un nuevo jugador. Los par�metros de entrada ser�n todos los datos 
--del jugador y la cantidad de su aportaci�n inicial para apostar.
--El procedimiento insertar� al jugador y generar� su primer apunte.
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
--2.Escribe un procedimiento para inscribir un caballo en una carrera. El procedimiento tendr� como par�metros 
--de entrada el ID de la carrera y el ID del caballo, y devolver� un par�metro de salida que indicar� el n�mero
--asignado al caballo en esa carrera. El n�mero estar� comprendido entre 1 y 99 y lo puedes asignar por el m�todo
--que quieras, aunque teniendo en cuenta que no puede haber dos caballos con el mismo n�mero en una carrera. 
--Si la carrera no existe, si hay ocho caballos ya inscritos o si el caballo no existe o est� ya inscrito en 
--esa carrera, el par�metro de salida devolver� NULL.
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



--A�ade a la tabla LTJugadores una nueva columna llamada LimiteCredito de tipo SmallMoney con el valor por defecto 50.
--Este valor indicar� el m�ximo saldo negativo que se permite al jugador. El saldo del jugador m�s el valor de esa
--columna no puede ser nunca inferior a 0.
--Escribe un procedimiento para grabar una apuesta. El procedimiento recibir� como par�metros el jugador, la carrera,
--el caballo y el importe a apostar y devolver� con return un c�digo de terminaci�n seg�n la siguiente tabla:

BEGIN TRANSACTION
ALTER TABLE LTJugadores
	ADD LimiteCredito smallmoney NOT NULL
		CONSTRAINT LTJ_LC_DefaultValue DEFAULT 50
COMMIT

GO
CREATE PROCEDURE GrabarApuesta (@IDJugador int, @IDCarrera int, @IDCaballo int, @Apuesta smallmoney, @Codigo int OUTPUT)
AS
	BEGIN
		IF(NOT EXISTS(SELECT ID FROM LTCarreras WHERE ID = @IDCarrera))
			SET @Codigo = 2
		ELSE
			BEGIN
				IF( (SELECT Fecha FROM LTCarreras WHERE ID = @IDCarrera) < CAST(GETDATE() AS date) )
					SET @Codigo = 3
				ELSE
					BEGIN
						IF( @IDCaballo != (SELECT IDCaballo FROM LTCaballosCarreras WHERE IDCarrera = @IDCarrera AND IDCaballo = @IDCaballo) )
							SET @Codigo = 5
						ELSE
							BEGIN
								IF( @Apuesta > (SELECT --�MAX(saldo)?
													FROM LTJugadores AS J
														INNER JOIN LTApuntes as A
															ON J.ID = A.IDJugador) )
							END
					END

			END
	END
GO
