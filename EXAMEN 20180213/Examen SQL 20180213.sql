SELECT *
	FROM TMPedidos AS P
		INNER JOIN TMEstablecimientos AS E
			ON P.IDEstablecimiento = E.ID

-- Ejercicio 1
GO
CREATE VIEW ListaPedidosCadaMes AS
SELECT E.ID ,E.Denominacion, year(P.Enviado) AS Anyo, month(P.Enviado) as Mes, P.Importe
	FROM TMPedidos AS P
		INNER JOIN TMEstablecimientos AS E
			ON P.IDEstablecimiento = E.ID
	GROUP BY E.Denominacion, year(P.Enviado), month(P.Enviado), E.ID, P.Importe
GO

GO
CREATE VIEW ListaPedidosMax AS
	SELECT ListaPedidosCadaMes.ID, ListaPedidosCadaMes.Anyo, ListaPedidosCadaMes.Mes, MAX(ListaPedidosCadaMes.Importe) AS [Pedido máximo del mes]
	FROM ListaPedidosCadaMes
	GROUP BY ListaPedidosCadaMes.ID, ListaPedidosCadaMes.Anyo, ListaPedidosCadaMes.Mes
GO

SELECT E.Denominacion, E.Ciudad, LPCM.Mes, LPCM.Anyo, AVG(LPCM.Importe) AS [Importe medio], LPM.[Pedido máximo del mes]
	FROM ListaPedidosCadaMes AS LPCM
		INNER JOIN ListaPedidosMax AS LPM
			ON LPCM.ID = LPM.ID AND LPCM.Anyo = LPM.Anyo AND LPCM.Mes = LPM.Mes
		INNER JOIN TMEstablecimientos AS E
			ON LPM.ID = E.ID
	GROUP BY E.Denominacion, E.Ciudad, LPCM.Mes, LPCM.Anyo, LPM.[Pedido máximo del mes]


-- Ejercicio 2
GO
CREATE VIEW ListaTodasHarinasClientes AS
SELECT C.ID, C.Nombre, C.Apellidos, M.Harina, COUNT(M.Harina) AS [Numero de veces]
	FROM TMClientes AS C
		INNER JOIN TMPedidos AS P
			ON C.ID = P.IDCliente
		INNER JOIN TMMostachones AS M
			ON P.ID = M.IDPedido
		INNER JOIN TMTiposMostachon AS TM
			ON M.Harina = TM.Harina
		INNER JOIN TMMostachonesToppings AS MT
			ON M.ID = MT.IDMostachon
		INNER JOIN TMToppings AS T
			ON MT.IDTopping = T.ID
	GROUP BY C.ID, C.Nombre, C.Apellidos, M.Harina
GO

GO
CREATE VIEW ListaTodosToppingsClientes AS
SELECT C.ID, C.Nombre, C.Apellidos, T.Topping, COUNT(T.Topping) AS [Numero de veces]
	FROM TMClientes AS C
		INNER JOIN TMPedidos AS P
			ON C.ID = P.IDCliente
		INNER JOIN TMMostachones AS M
			ON P.ID = M.IDPedido
		INNER JOIN TMTiposMostachon AS TM
			ON M.Harina = TM.Harina
		INNER JOIN TMMostachonesToppings AS MT
			ON M.ID = MT.IDMostachon
		INNER JOIN TMToppings AS T
			ON MT.IDTopping = T.ID
	GROUP BY C.ID, C.Nombre, C.Apellidos, T.Topping
GO

GO
CREATE VIEW ListaHarinasFavoritasMax AS
SELECT ListaTodasHarinasClientes.ID, ListaTodasHarinasClientes.Nombre, ListaTodasHarinasClientes.Apellidos, MAX(ListaTodasHarinasClientes.[Numero de veces]) AS [Veces que ha pedido su harina favorita]
	FROM ListaTodasHarinasClientes
	GROUP BY ListaTodasHarinasClientes.ID, ListaTodasHarinasClientes.Nombre, ListaTodasHarinasClientes.Apellidos
GO

GO
CREATE VIEW ListaToppingsFavoritosMax AS
SELECT ListaTodosToppingsClientes.ID, ListaTodosToppingsClientes.Nombre, ListaTodosToppingsClientes.Apellidos, MAX(ListaTodosToppingsClientes.[Numero de veces]) AS [Veces que ha pedido su topping favorito]
	FROM ListaTodosToppingsClientes
	GROUP BY ListaTodosToppingsClientes.ID, ListaTodosToppingsClientes.Nombre, ListaTodosToppingsClientes.Apellidos
GO

--No soy capaz de saber cómo relacionar el número de veces que ha pedido X con el nombre del mismo, ya sea harina o el topping
SELECT C.Nombre, C.Apellidos, C.Ciudad, H.[Veces que ha pedido su harina favorita], T.[Veces que ha pedido su topping favorito]
	FROM TMClientes AS C
		INNER JOIN ListaHarinasFavoritasMax AS H
			ON C.ID = H.ID
		INNER JOIN ListaToppingsFavoritosMax AS T
			ON C.ID = T.ID


-- Ejercicio 3
SELECT *
	FROM 


-- Ejercicio 4
INSERT INTO TMBases VALUES ('Bambú')

INSERT INTO TMToppings (ID, Topping) VALUES (9, 'Wasabi')

GO
CREATE VIEW ListaJapon AS
SELECT E.Ciudad, P.IDEstablecimiento, P.IDCliente, M.ID AS [ID Mostachones], MT.IDTopping, T.Topping, M.TipoBase
	FROM TMEstablecimientos AS E
		INNER JOIN TMPedidos AS P
			ON E.ID = P.IDEstablecimiento
		INNER JOIN TMMostachones AS M
			ON P.ID = M.IDPedido
		INNER JOIN TMMostachonesToppings AS MT
			ON M.ID = MT.IDMostachon
		INNER JOIN TMToppings AS T
			ON MT.IDTopping = T.ID
		INNER JOIN TMTiposMostachon AS TM
			ON M.Harina = TM.Harina
		INNER JOIN TMBases AS B
			ON M.TipoBase = B.Base
	WHERE E.Ciudad = 'Tokyo'
	ORDER BY TipoBase
GO

BEGIN TRANSACTION
UPDATE ListaJapon
	SET IDTopping = 9
	WHERE IDTopping = 1
COMMIT

BEGIN TRANSACTION
UPDATE ListaJapon
	SET TipoBase = 'Bambú'
	WHERE TipoBase = 'Tradicional'
COMMIT

ROLLBACK


-- Ejercicio 5
SELECT * FROM TMPedidos WHERE ID = 2501
SELECT * FROM TMClientes WHERE Nombre = 'Olga' AND Apellidos = 'Llinero'
SELECT * FROM TMEstablecimientos WHERE Denominacion = 'Sol Naciente'
SELECT * FROM TMComplementos WHERE Complemento = 'Café'
SELECT * FROM TMPedidosComplementos
SELECT * FROM TMMostachones
SELECT * FROM TMTiposMostachon
SELECT * FROM TMBases
SELECT * FROM TMToppings
SELECT * FROM TMMostachonesToppings
-- El importe será de 2€ * 2 mostachones + 0.60€ * 3 = 5.80€

--Insertamos el pedido
INSERT INTO TMPedidos (ID, IDCliente, Recibido, IDEstablecimiento, Importe)
	VALUES (2501, 307, CURRENT_TIMESTAMP, 22, 5.80)

--Insertamos los complementos añadidos al pedido
INSERT INTO TMPedidosComplementos (IDPedido, IDComplemento, Cantidad)
	VALUES(2501, 10, 1)

--Actualizamos el importe total del pedido
BEGIN TRANSACTION
UPDATE TMPedidos
	SET Importe = 7.00
	WHERE ID = 2501
COMMIT

--Definimos los mostachones de cada pedido
INSERT INTO TMMostachones (ID, IDPedido, TipoBase, Harina)
	VALUES (6236, 2501, 'Reciclado', 'Maíz')
INSERT INTO TMMostachones (ID, IDPedido, TipoBase, Harina)
	VALUES (6237, 2501, 'Cartulina', 'Espelta')

--Ahora los toppings de cada uno
--Pero a gracia de Leo, tenemos que introducir el topping de mermelada. Gracias Leo
INSERT INTO TMToppings VALUES (10, 'Mermelada')

--Ahora sí, introducimos los toppings de cada mostachón
INSERT INTO TMMostachonesToppings (IDMostachon, IDTopping)
	VALUES(6236, 10)
INSERT INTO TMMostachonesToppings (IDMostachon, IDTopping)
	VALUES(6237, 2)
INSERT INTO TMMostachonesToppings (IDMostachon, IDTopping)
	VALUES(6237, 6)
