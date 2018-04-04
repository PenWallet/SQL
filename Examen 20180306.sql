--Ejercicio 1
--Queremos saber cuál es la cantidad media apostada y la mayor cantidad apostada a cada caballo.
--Columnas: ID Caballo, Nombre, Edad, Número de carreras disputadas, cantidad mayor apostada y cantidad media apostada a su favor

-- SELECT de la cantidad media de cada caballo
GO
CREATE VIEW AMedia AS
SELECT AVG(Importe) AS ApuestaMedia, C.Nombre
	FROM LTApuestas AS A
		INNER JOIN LTCaballos as C
			ON A.IDCaballo = C.ID
	GROUP BY C.Nombre
GO

-- SELECT de la cantidad máxima de cada caballo
GO
CREATE VIEW AMaxima AS
SELECT MAX(Importe) AS ApuestaMaxima, C.Nombre
	FROM LTApuestas AS A
		INNER JOIN LTCaballos as C
			ON A.IDCaballo = C.ID
	GROUP BY C.Nombre
GO

-- SELECT de ambas tablas
SELECT C.ID, AMedia.Nombre, (year(CURRENT_TIMESTAMP) - year(C.FechaNacimiento)) AS Edad, COUNT(CC.IDCarrera) AS [Numero de carreras],AMedia.ApuestaMedia, AMaxima.ApuestaMaxima
	FROM AMaxima
		INNER JOIN AMedia
			ON AMedia.Nombre = AMaxima.Nombre
		INNER JOIN LTCaballos AS C
			ON AMaxima.Nombre = C.Nombre AND AMedia.Nombre = C.Nombre
		INNER JOIN LTCaballosCarreras AS CC
			ON C.ID	= CC.IDCaballo
	GROUP BY C.ID, AMedia.Nombre, (year(CURRENT_TIMESTAMP) - year(C.FechaNacimiento)), AMedia.ApuestaMedia, AMaxima.ApuestaMaxima

--Ejercicio 2
--Tenemos sospechas de que algún jugador pueda estar intentando amañar las carreras. 
--Queremos detectar los jugadores que son especialmente afortunados. 
--Haz una consulta que calcule, para cada jugador, la rentabilidad que obtiene con el menor riesgo posible.
--La rentabilidad se mide dividiendo el total de dinero ganado entre el dinero apostado y multiplicando el resultado por 100.
--Ten en cuenta solo el dinero que haya ganado por premios, no los ingresos que haya podido hacer en su cuenta.
--Columnas: ID, nombre y apellidos del jugador, total de dinero apostado, total de dinero ganado, rentabilidad.
SELECT *
	FROM LTApuntes AS A
		INNER JOIN LTJugadores AS J
			ON A.IDJugador = J.ID

--SELECT del dinero ganado por cada jugador
GO
CREATE VIEW DGanado AS
SELECT A.IDJugador, SUM(Importe) AS [DineroGanado]
	FROM LTApuntes AS A
		INNER JOIN LTJugadores AS J
			ON A.IDJugador = J.ID
	WHERE A.Concepto LIKE ('Premio%')
	GROUP BY A.IDJugador
GO

--SELECT del dinero perdido apostando (Dividido entre -1 para hacer el porcentaje positivo)
GO
CREATE VIEW DPerdido AS
SELECT A.IDJugador, (-1 * SUM(Importe)) AS [DineroPerdido]
	FROM LTApuntes AS A
		INNER JOIN LTJugadores AS J
			ON A.IDJugador = J.ID
	WHERE A.Concepto LIKE ('Apuesta%')
	GROUP BY A.IDJugador
GO

--SELECT con las dos vistas
SELECT J.ID, J.Nombre, J.Apellidos, DGanado.DineroGanado, DPerdido.DineroPerdido, ((DGanado.DineroGanado / DPerdido.DineroPerdido) * 100) AS Rentabilidad
	FROM LTJugadores AS J
		INNER JOIN DGanado
			ON J.ID = DGanado.IDJugador
		INNER JOIN DPerdido
			ON J.ID = DPerdido.IDJugador


--Ejercicio 3
--Como todavía no estamos tranquilos, vamos a comprobar apuestas que se salgan de lo normal.
--Consideramos sospechosa una apuesta ganadora grande
--(al menos un 50% por encima del importe medio de las apuestas de esa carrera) a caballos que se pagasen a 2 o más.
--Columnas: ID Jugador, Nombre, apellidos, ID apuesta, Hipódromo, fecha de la carrera, caballo, premio, importe apostado e importe ganado.
--Si no devuelve ninguna fila no pasa nada. Nuestros clientes son honrados.
SELECT * FROM LTCaballosCarreras
	ORDER BY IDCaballo, IDCarrera

SELECT * FROM LTCaballosCarreras
	WHERE Premio1 >= 2
	ORDER BY IDCaballo, IDCarrera

--SELECT que nos indica la media apostada en cada carrera, multiplicada por 1.5 (límite)
GO
CREATE VIEW MApuesta AS
SELECT IDCarrera, AVG(Importe)*1.5 AS [MediaApuesta]
	FROM LTApuestas
	GROUP BY IDCarrera
GO

--SELECT que cumple las condiciones de gente sospechosa
GO
CREATE VIEW PrimerosPremios AS
SELECT A.IDJugador, A.IDCarrera, (A.Importe * CC.Premio1) AS [DineroGanado1]
	FROM LTCaballosCarreras AS CC
		INNER JOIN LTApuestas AS A
			ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
		INNER JOIN MApuesta
			ON A.IDCarrera = MApuesta.IDCarrera
	WHERE CC.Premio1 >= 2 AND (A.Importe * CC.Premio1) > (MApuesta.MediaApuesta)
	GROUP BY A.IDJugador,A.IDCarrera, A.Importe, CC.Premio1
GO

--SELECT que cumple las condiciones de gente sospechosa
GO
CREATE VIEW SegundosPremios AS
SELECT A.IDJugador, A.IDCarrera, (A.Importe * CC.Premio2) AS [DineroGanado2]
	FROM LTCaballosCarreras AS CC
		INNER JOIN LTApuestas AS A
			ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
		INNER JOIN MApuesta
			ON A.IDCarrera = MApuesta.IDCarrera
	WHERE CC.Premio2 >= 2 AND (A.Importe * CC.Premio2) > (MApuesta.MediaApuesta)
	GROUP BY A.IDJugador, A.IDCarrera, A.Importe, CC.Premio2
GO

--SELECTs separados, uno de los primeros premios, y otro del segundo premio
SELECT PP.IDJugador, J.Nombre, J.Apellidos, A.ID, Car.Hipodromo, Car.Fecha, Cab.Nombre, CC.Premio1, A.Importe, PP.DineroGanado1
	FROM LTJugadores AS J
		INNER JOIN LTApuestas AS A
			ON J.ID = A.IDJugador
		INNER JOIN LTCarreras AS Car
			ON A.IDCarrera = Car.ID
		INNER JOIN LTCaballos AS Cab
			ON A.IDCaballo = Cab.ID
		INNER JOIN LTCaballosCarreras AS CC
			ON A.IDCaballo = CC.IDCaballo AND A.IDCarrera = CC.IDCarrera
		INNER JOIN PrimerosPremios AS PP
			ON A.IDCarrera = PP.IDCarrera AND A.IDJugador = PP.IDJugador

SELECT PS.IDJugador, J.Nombre, J.Apellidos, A.ID, Car.Hipodromo, Car.Fecha, Cab.Nombre, CC.Premio2, A.Importe, PS.DineroGanado2
	FROM LTJugadores AS J
		INNER JOIN LTApuestas AS A
			ON J.ID = A.IDJugador
		INNER JOIN LTCarreras AS Car
			ON A.IDCarrera = Car.ID
		INNER JOIN LTCaballos AS Cab
			ON A.IDCaballo = Cab.ID
		INNER JOIN LTCaballosCarreras AS CC
			ON A.IDCaballo = CC.IDCaballo AND A.IDCarrera = CC.IDCarrera
		INNER JOIN SegundosPremios AS PS
			ON A.IDCarrera = PS.IDCarrera AND A.IDJugador = PS.IDJugador
	WHERE CC.Premio2 >= 2

--Ejercicio 5a
--Actualiza la tabla LTCaballosCarreras y genera los apuntes en LTApuntes correspondientes a los jugadores
--que hayan ganado utilizando dos instrucciones INSERT-SELECT, una para los que han acertado la ganadora
--y otra para los que han acertado la segunda.
SELECT * FROM LTCaballosCarreras WHERE IDCarrera = 21
SELECT * FROM LTCaballos

--Primero vamos a actualizar la tabla
BEGIN TRANSACTION

UPDATE LTCaballosCarreras
	SET Posicion = 1
	WHERE IDCaballo = (SELECT ID FROM LTCaballos WHERE Nombre = 'Fiona') AND IDCarrera = 21
UPDATE LTCaballosCarreras
	SET Posicion = 2
	WHERE IDCaballo = (SELECT ID FROM LTCaballos WHERE Nombre = 'Vetonia') AND IDCarrera = 21
UPDATE LTCaballosCarreras
	SET Posicion = 3
	WHERE IDCaballo = (SELECT ID FROM LTCaballos WHERE Nombre = 'Witiza') AND IDCarrera = 21
UPDATE LTCaballosCarreras
	SET Posicion = 4
	WHERE IDCaballo = (SELECT ID FROM LTCaballos WHERE Nombre = 'Sigerico') AND IDCarrera = 21
UPDATE LTCaballosCarreras
	SET Posicion = 5
	WHERE IDCaballo = (SELECT ID FROM LTCaballos WHERE Nombre = 'Galatea') AND IDCarrera = 21
UPDATE LTCaballosCarreras
	SET Posicion = 6
	WHERE IDCaballo = (SELECT ID FROM LTCaballos WHERE Nombre = 'Desdemona') AND IDCarrera = 21

--Ciclón no se cambia, ya que no ha terminado la carrera, se queda en NULL

COMMIT
--ROLLBACK
SELECT * FROM LTApuestas WHERE IDJugador = 25 AND IDCarrera = 21
SELECT * FROM LTApuntes WHERE IDJugador = 28

--Intento de hacer el SELECT del INSERT INTO :(
SELECT A.IDJugador, ((SELECT MAX(Orden) FROM LTApuntes WHERE IDJugador = A.IDJugador)  + 1),'2018-03-06', (A.Importe * CC.Premio1), ((SELECT Saldo FROM LTApuntes WHERE Orden = (SELECT MAX(Orden) FROM LTApuntes WHERE IDJugador = A.IDJugador)) + (A.Importe * CC.Premio1)), 'Premio por la apuesta 21'
	FROM LTCaballosCarreras AS CC
		INNER JOIN LTApuestas AS A
			ON CC.IDCaballo = A.IDCaballo AND CC.IDCarrera = A.IDCarrera
		INNER JOIN LTApuntes AS Ap
			ON A.IDJugador = Ap.IDJugador
	WHERE A.IDCarrera = 21 AND CC.Posicion = 1
	GROUP BY A.IDJugador, A.Importe, CC.Premio1, Ap.Saldo


INSERT INTO LTApuntes (IDJugador, Orden, Fecha, Importe, Saldo, Concepto)
	SELECT 
		FROM





























--Ejercicio 5b
--Debido a una reclamación, el caballo Ciclón ha sido descalificado en la carrera 11
--por utilizar herraduras de fibra de carbono, prohibidas por el reglamento.
--Actualiza la tabla LTCaballosCarreras haciendo que la posición de Ciclón sea NULL
--y todos los que entraron detrás de él suban un puesto. 
--Como Ciclón quedó segundo, este cambio afecta a los premios.
--Hay que anular (eliminar) todos los apuntes relativos a premios por ese caballo en esa carrera.
--Además, el segundo pasa a ser primero y el tercero pasa a ser segundo,
--lo que afecta a sus apuestas. Genera o modifica los apuntes correspondientes a esos premios.
SELECT * FROM LTCarreras WHERE I
