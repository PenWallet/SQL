USE LeoTurf
SET DATEFORMAT ymd

--1.Crea una funci�n inline llamada FnCarrerasCaballo que reciba un rango de fechas (inicio y fin) y nos devuelva el 
--n�mero de carreras disputadas por cada caballo entre esas dos fechas. Las columnas ser�n ID (del caballo), nombre, 
--sexo, fecha de nacimiento y n�mero de carreras disputadas.
GO
CREATE FUNCTION FnCarrerasCaballo(@FInicio date, @FFin date)
RETURNS TABLE AS
RETURN (SELECT C.ID, C.Nombre, C.Sexo, C.FechaNacimiento, COUNT(CC.IDCarrera) AS [Carreras disputadas]
			FROM LTCaballos AS C
				INNER JOIN LTCaballosCarreras AS CC
					ON C.ID = CC.IDCaballo
				INNER JOIN LTCarreras AS Ca
					ON CC.IDCarrera = Ca.ID
			WHERE Ca.Fecha BETWEEN @FInicio AND @FFin
			GROUP BY C.ID, C.Nombre, C.Sexo, C.FechaNacimiento )
GO
--FIN FUNCI�N

SELECT * FROM LTCarreras
SELECT * FROM FnCarrerasCaballo('2018-01-01', '2018-02-01')


--2. Crea una funci�n escalar llamada FnTotalApostadoCC que reciba como par�metros el ID de un caballo y el ID de una 
--carrera y nos devuelva el dinero que se ha apostado a ese caballo en esa carrera.
GO
CREATE FUNCTION FnTotalApostadoCC (@IDCab smallint, @IDCar smallint)
	RETURNS smallmoney AS
		BEGIN
			RETURN (SELECT SUM(Importe) AS TotalApostado
						FROM LTApuestas
							WHERE @IDCab = IDCaballo AND @IDCar = IDCarrera )
		END
GO

--DROP FUNCTION FnTotalApostadoCC

SELECT dbo.FnTotalApostadoCC(1, 1)


--3. Crea una funci�n escalar llamada FnPremioConseguido que reciba como par�metros el ID de una apuesta y nos 
--devuelva el dinero que ha ganado dicha apuesta. Si todav�a no se conocen las posiciones de los caballos, devolver� un NULL
GO
CREATE FUNCTION FnPremioConseguido (@IDApuesta smallint)
	RETURNS smallmoney AS
		BEGIN
			RETURN(SELECT CASE
							WHEN CC.Posicion = NULL THEN NULL
							WHEN CC.Posicion = 1 THEN A.Importe * CC.Premio1
							WHEN CC.Posicion = 2 THEN A.Importe * CC.Premio2
							ELSE -1 * A.Importe 
							END
					FROM LTApuestas AS A
					INNER JOIN LTCaballosCarreras AS CC
						ON A.IDCaballo = CC.IDCaballo AND A.IDCarrera = CC.IDCarrera
					WHERE A.ID = @IDApuesta)
		END
GO

SELECT dbo.FnPremioConseguido(3) AS Premio



--4.El procedimiento para calcular los premios en las apuestas de una carrera (los valores que deben figurar en la columna
--Premio1 y Premio2) es el siguiente:

--a.Se calcula el total de dinero apostado en esa carrera
--b.El valor de la columna Premio1 para cada caballo se calcula dividiendo el total de dinero apostado entre (lo apostado a 
--ese caballo) y se multiplica el resultado por 0.6
--c.El valor de la columna Premio2 para cada caballo se calcula dividiendo el total de dinero apostado entre (lo apostado a 
--ese caballo) y se multiplica el resultado por 0.2
--d.Si a alg�n caballo no ha apostado nadie tanto el Premio1 como el Premio2 se ponen a 100.

--Crea una funci�n que devuelva una tabla con tres columnas: ID del caballo, Premio1 y Premio2.
--El par�metro de entrada ser� el ID de la carrera.

--Debes usar la funci�n del Ejercicio 2. Si lo estimas oportuno puedes crear otras funciones para realizar parte de los c�lculos.

SELECT * FROM LTCarreras ORDER BY ID

GO
CREATE FUNCTION FnTotalApostado (@IDCarrera int)
	RETURNS smallmoney AS
		BEGIN
			RETURN (SELECT SUM(Importe) AS TotalApostado
						FROM LTApuestas
							WHERE IDCarrera = @IDCarrera )
		END
GO

GO
CREATE FUNCTION FnCalcularPremios (@IDCarrera int)
RETURNS TABLE AS
RETURN (SELECT CC.IDCaballo, ((dbo.FnTotalApostado(@IDCarrera) / dbo.FnTotalApostadoCC(CC.IDCaballo, @IDCarrera)) * 0.6) AS Premio1, ((dbo.FnTotalApostado(@IDCarrera) / dbo.FnTotalApostadoCC(CC.IDCaballo, @IDCarrera)) * 0.2) AS Premio2
		FROM LTCaballosCarreras AS CC
			INNER JOIN LTApuestas AS A
				ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
		WHERE CC.IDCarrera = @IDCarrera )
GO

SELECT * FROM LTCaballosCarreras WHERE IDCarrera = 2 ORDER BY IDCaballo
SELECT * FROM FnCalcularPremios(2) ORDER BY IDCaballo


--5.Crea una funci�n FnPalmares que reciba un ID de caballo y un rango de fechas y nos devuelva el palmar�s de ese caballo en
--ese intervalo de tiempo.

--El palmar�s es el n�mero de victorias, segundos puestos, etc. Se devolver� una tabla con dos columnas: Posici�n y NumVeces,
--que indicar�n, respectivamente, cada una de las posiciones y las veces que el caballo ha obtenido ese resultado.

--Queremos que aparezcan 8 filas con las posiciones de la 1 a la 8. Si el caballo nunca ha finalizado en alguna de esas
--posiciones, aparecer� el valor 0 en la columna NumVeces.
GO
CREATE FUNCTION FnPalmares (@IDCaballo int)
RETURNS TABLE AS
RETURN (SELECT Posicion, COUNT(Posicion) AS NumeroVeces
			FROM LTCaballosCarreras
			WHERE IDCaballo = @IDCaballo
			GROUP BY Posicion )
GO



SELECT Posicion, SUM(Posicion) AS NumVeces
	FROM LTCaballosCarreras
	WHERE IDCaballo = 2
	GROUP BY Posicion