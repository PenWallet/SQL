--Ejercicio 1
--Escribe un procedimiento EliminarUsuario que reciba como par�metro el DNI de un usuario, 
--le coloque un NULL en la columna Sex y borre todas las reservas futuras de ese usuario. 
--Ten en cuenta que si alguna de esas reservas tiene asociado un alquiler de material habr� que borrarlo tambi�n.
GO
CREATE PROCEDURE EliminarUsuario (@DNI char(9))
AS
	BEGIN
		BEGIN TRANSACTION
			UPDATE Usuarios
				SET Sex = NULL
				WHERE DNI = @DNI

			DELETE FROM ReservasMateriales
				WHERE CodigoReserva = (SELECT Codigo
										FROM Reservas AS R
											INNER JOIN Usuarios AS U
												ON R.ID_Usuario = U.ID
										WHERE U.DNI = @DNI AND R.Fecha_Hora > CURRENT_TIMESTAMP )

			DELETE FROM Reservas
				WHERE ID_Usuario = (SELECT ID
										FROM Usuarios
										WHERE DNI = @DNI) AND Fecha_Hora > CURRENT_TIMESTAMP
		COMMIT
	END
GO

BEGIN TRANSACTION
EXECUTE EliminarUsuario '40587936R'
ROLLBACK

--Ejercicio 2
--Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y una fecha/hora 
--(SmallDateTime) y devuelva en otro par�metro de salida el ID del usuario que la ten�a alquilada si en ese 
--momento la instalaci�n estaba ocupada. Si estaba libre, devolver� un NULL.
GO
CREATE PROCEDURE QuienEstaUsandoMiPista (@IDInst int, @date smalldatetime, @IDUsuario char(12) OUTPUT)
AS
	BEGIN
		SET @IDUsuario = (SELECT id
							FROM Usuarios AS U
								INNER JOIN Reservas AS R
									ON U.ID = R.ID_Usuario
							WHERE R.Cod_Instalacion = @IDInst AND R.Fecha_Hora = @date)
	END
GO

DECLARE @Salida varChar(12)
EXECUTE QuienEstaUsandoMiPista @IDInst = 2, @date = '2008-12-12 14:00:00', @Salida OUTPUT

SELECT * FROM Reservas

--Ejercicio 3
--Escribe un procedimiento que reciba como par�metros el c�digo de una instalaci�n y dos fechas (DATE) y 
--devuelva en otro par�metro de salida el n�mero de horas que esa instalaci�n ha estado alquilada entre esas 
--dos fechas, ambas incluidas. Si se omite la segunda fecha, se tomar� la actual con GETDATE().

--Devuelve con return c�digos de error si el c�digo de la instalaci�n es err�neo  o si la fecha de inicio
-- es posterior a la de fin.
GO
CREATE PROCEDURE CuantasHoritas (@IDInst int, @date1 smalldatetime, @date2 datetime /*No puedo poner = getdate()*/, @Error varchar(15) OUTPUT, @horas int OUTPUT)
AS
	BEGIN
		IF(@IDInst > (SELECT MAX(Codigo) FROM Instalaciones) OR @IDInst < (SELECT MIN(Codigo) FROM Instalaciones))
			BEGIN
				SET @Error = 'IDInst erroneo'
			END
		ELSE
			BEGIN
				IF(@date1 > @date2)
					BEGIN
						SET @Error = 'Fechas erroneas'
					END
				ELSE
					BEGIN
						SET @horas = (SELECT SUM(Tiempo)
										FROM Reservas
										WHERE Fecha_Hora BETWEEN @date1 AND @date2 )
					END
			END
	END
GO

DECLARE @ErrorOP varchar(15), @horasOP int
EXECUTE CuantasHoritas @IDInst = 2, @date1 = '2008-12-13 16:00:00', @date2 = '2008-12-13 17:00:00', @Error = @ErrorOP, @horas = @horasOP
PRINT 'Errores: '+ @ErrorOP
PRINT 'Horas: '+ CAST(@horasOP AS varchar(2))

SELECT * FROM Reservas ORDER BY Fecha_Hora
--Ejercicio 4
--Escribe un procedimiento EfectuarReserva que reciba como par�metro el DNI de un usuario, 
--el c�digo de la instalaci�n, la fecha/hora de inicio de la reserva y la fecha/hora final.

--El procedimiento comprobar� que los datos de entradas son correctos y grabar� la correspondiente reserva. 
--Devolver� el c�digo de reserva generado mediante un par�metro de salida. Para obtener el valor generado usar 
--la funci�n @@identity tras el INSERT.

--Devuelve un cero si la operaci�n se realiza con �xito y un c�digo de error seg�n la lista siguiente:

--3: La instalaci�n est� ocupada para esa fecha y hora
--4: El c�digo de la instalaci�n es incorrecto
--5: El usuario no existe
--8: La fecha/hora de inicio del alquiler es posterior a la de fin
--11: La fecha de inicio y de fin son diferentes
SELECT * FROM Reservas
GO
CREATE PROCEDURE EfectuarReserva (@DNI char(9), @codInst int, @fechaInicio smalldatetime, @fechaFinal smalldatetime, @codReserva int OUTPUT, @Error int = 0 OUTPUT)
AS
	BEGIN
		IF(NOT EXISTS(SELECT Cod_Instalacion FROM Reservas WHERE Fecha_Hora BETWEEN @fechaInicio AND @fechaFinal))
			BEGIN
				IF(EXISTS(SELECT Codigo FROM Instalaciones WHERE Codigo = @codInst))
					BEGIN
						IF(EXISTS(SELECT DNI FROM Usuarios WHERE DNI = @DNI))
							BEGIN
								IF(@fechaInicio < @fechaFinal)
									BEGIN
										IF(CAST(@fechaInicio AS date) = CAST(@fechaFinal AS date))
											BEGIN
												INSERT INTO Reservas(Tiempo, Fecha_Hora, ID_Usuario, Cod_Instalacion)
												VALUES( DATEPART(hour, @fechaFinal) - DATEPART(hour, @fechaInicio),
														@fechaInicio,
														(SELECT ID FROM Usuarios WHERE DNI = @DNI),
														@codInst ) --Tiene que ir entre par�ntesis 
												SET @codReserva = @@IDENTITY
											END
										ELSE
											SET @Error = 11
									END
								ELSE
									SET @Error = 8
							END
						ELSE
							SET @Error = 5
					END
				ELSE
					SET @Error = 4
			END
		ELSE
			SET @Error = 3
	END
GO

SELECT * FROM Reservas
SELECT * FROM Usuarios
SELECT * FROM Instalaciones

BEGIN TRANSACTION
DECLARE @codReserva int
DECLARE @Error int
EXECUTE EfectuarReserva '59544420G',10,2018-05-13 16:00:00,2018-05-13 19:00:00, @codReserva OUTPUT, @Error OUTPUT
PRINT 'Codigo de reserva: '+CAST(@codReserva AS varchar)
PRINT 'Error: '+CAST(@Error AS varchar)

