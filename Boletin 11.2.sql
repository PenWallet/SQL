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
CREATE PROCEDURE InscribirCaballo (@IDCarrera int, @IDCaballo int, @NumeroAsignado int OUTPUT)
AS
	BEGIN
		IF(
			EXISTS(SELECT ID FROM LTCarreras WHERE ID = @IDCarrera) AND
			(SELECT COUNT(IDCaballo) FROM LTCaballosCarreras WHERE IDCarrera = @IDCarrera) < 8 AND
			EXISTS(SELECT ID FROM LTCaballos WHERE ID = @IDCaballo) AND
			NOT EXISTS(SELECT IDCaballo FROM LTCaballosCarreras WHERE IDCaballo = @IDCaballo AND IDCarrera = @IDCarrera) 
			)
		BEGIN
			DECLARE @Contador int = 1
			WHILE(@Contador IN (SELECT Numero FROM LTCaballosCarreras WHERE IDCarrera = @IDCarrera))
			BEGIN
				SET @Contador = @Contador + 1
			END

			INSERT INTO LTCaballosCarreras (IDCaballo, IDCarrera, Numero)
									VALUES (@IDCaballo, @IDCarrera, @Contador)

		END
	END
GO
