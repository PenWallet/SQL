/* Dinero total gastado por el cliente "Paco Merselo" */
SELECT * FROM TMClientes

SELECT TMC.Nombre, TMC.Apellidos, SUM(TMP.Importe) AS ImporteTotal
	FROM TMClientes AS TMC
		INNER JOIN TMPedidos AS TMP
			ON TMC.ID = TMP.IDCliente
	WHERE TMC.Nombre LIKE 'Paco' AND TMC.Apellidos = 'Merselo'
	GROUP BY TMC.Nombre, TMC.Apellidos
	

/* Dinero gastado en complementos por el cliente "Paco Merselo" */
SELECT * FROM TMPedidosComplementos

SELECT SUM(TMCom.Importe * TMPC.Cantidad) AS Total, TMC.Nombre, TMC.Apellidos
	FROM TMComplementos AS TMCom
		INNER JOIN TMPedidosComplementos AS TMPC
			ON TMCom.ID = TMPC.IDComplemento
		INNER JOIN TMPedidos AS TMP
			ON TMPC.IDPedido = TMP.ID
		INNER JOIN TMClientes AS TMC
			ON TMP.IDCliente = TMC.ID
	WHERE TMC.Nombre = 'Paco' AND TMC.Apellidos = 'Merselo'
	GROUP BY TMC.Nombre, TMC.Apellidos

-- Tiempo medio transcurrido (en minutos) entre la hora de envío y de llegada de los pedidos del
-- repartidor "Ana Conda" entre los meses 3 y 7 del año 2017
SELECT * FROM TM

SELECT AVG(DATEDIFF(minute, TMP.Recibido, TMP.Enviado)) AS [Tiempo medio]
	FROM TMRepartidores AS TMR
		INNER JOIN TMPedidos AS TMP
			ON TMR.ID = TMP.IDRepartidor
	WHERE TMR.Nombre = 'Ana' AND month(TMP.Enviado) BETWEEN 3 AND 7


-- Mes de mayor recaudacion de cada establecimiento durante el año 2015 y cantidad del mismo
SELECT CantidadPorMes.Denominacion, MAX(CantidadPorMes.[Total recaudado]) AS [Cantidad máxima]
FROM
(
SELECT E.Denominacion, month(P.Enviado) AS Mes, SUM(P.Importe) AS [Total recaudado]
	FROM TMEstablecimientos AS E
		INNER JOIN TMPedidos AS P
			ON E.ID = P.IDEstablecimiento
		INNER JOIN TMPedidosComplementos AS PC
			ON P.ID = PC.IDPedido
		INNER JOIN TMComplementos AS C
			ON PC.IDComplemento = C.ID
	WHERE year(P.Enviado) = '2015'
	GROUP BY month(P.Enviado), E.Denominacion
) AS CantidadPorMes
GROUP BY CantidadPorMes.Denominacion


SELECT ImportePorMes.Denominacion, max(ImportePorMes.ImporteTotalMensual) AS ImporteMaximoAnual 
	FROM
	(
        SELECT E.Denominacion, month(P.Enviado) AS Mes, sum(P.Importe) AS ImporteTotalMensual FROM TMEstablecimientos AS E
        INNER JOIN TMPedidos AS P ON E.ID = P.IDEstablecimiento
        WHERE year(P.Enviado) = 2015
        GROUP BY E.Denominacion, month(P.Enviado)
	) AS ImportePorMes
    GROUP BY ImportePorMes.Denominacion




	select ImportePorMes.Denominacion, ImportePorMes.ImporteTotalMensual, ImportePorMes.Mes 
	from
	(
    select ImportePorMes.Denominacion, max(ImportePorMes.ImporteTotalMensual) as ImporteMaximoAnual 
		from
		(
			select E.Denominacion, month(P.Enviado) as Mes, sum(P.Importe) as ImporteTotalMensual
				from TMEstablecimientos as E
					inner join TMPedidos as P on E.ID = P.IDEstablecimiento
				where year(P.Enviado) = 2015
				group by E.Denominacion, month(P.Enviado)
		) as ImportePorMes
    group by ImportePorMes.Denominacion
    ) as ImporteMaximo
inner join (
    select E.Denominacion, month(P.Enviado) as Mes, sum(P.Importe) as ImporteTotalMensual from TMEstablecimientos as E
    inner join TMPedidos as P on E.ID = P.IDEstablecimiento
    where year(P.Enviado) = 2015
    group by E.Denominacion, month(P.Enviado)
    ) as ImportePorMes on ImporteMaximo.Denominacion = ImportePorMes.Denominacion 
    and ImporteMaximo.ImporteMaximoAnual = ImportePorMes.ImporteTotalMensual