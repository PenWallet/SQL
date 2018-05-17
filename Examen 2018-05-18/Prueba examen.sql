USE ChiringLeo

/*

 Ejercicio 4: Armando Bronca Segura ha pedido en el establecimiento Levante:

 --Tio Robustiano 2 (vino)
 -- Pulpo a la gallega (plato racion)
 --Choco Frito 2 (plato media) 29.10
 --Zanahoria aliñana 3 (plato tapa)
 -- Nestea 2 (complementos)
 --Botella agua 1 (complementos)

 Le ha atendido Margarita Padera

 */
SELECT * FROM CLPlatos WHERE Nombre = 'Zanahoria aliñada'
SELECT * FROM CLPlatos WHERE Nombre = 'Pulpo a la gallega'
SELECT * FROM CLPlatos WHERE Nombre = 'Choco Frito'
SELECT * FROM CLClientes WHERE Nombre = 'Aitor'
SELECT * FROM CLCamarers
SELECT * FROM CLPedidos
SELECT * FROM CLComplementos
delete from CLClientes
where ID = 102

BEGIN TRANSACTION
INSERT INTO CLPedidos(Fecha, IDCliente, IDEstablecimiento, IDCamarer)
	SELECT CAST(CURRENT_TIMESTAMP as smalldatetime), Cli.ID, Cam.IDEstablecimiento, Cam.ID
		FROM CLClientes AS Cli
			CROSS JOIN CLCamarers AS Cam
		WHERE Cli.Nombre = 'Armando' AND Cli.Apellidos = 'Bronca Segura' AND Cam.Nombre = 'Margarita' AND Cam.Apellidos = 'Padera'

DECLARE @ID int = @@IDENTITY

INSERT INTO CLPedidosVinos (IDPedido, IDVino, Cantidad)
	SELECT @ID, ID, 2
		FROM CLVinos
		WHERE Nombre = 'Tio Robustiano'

INSERT INTO CLPedidosComplementos (IDPedido, IDComplemento, Cantidad)
	SELECT @ID, ID, 2
		FROM CLComplementos 
		WHERE Complemento = 'Nestea'

INSERT INTO CLPedidosComplementos (IDPedido, IDComplemento, Cantidad)
	SELECT @ID, ID, 1
		FROM CLComplementos
		WHERE Complemento = 'Botella agua'

INSERT INTO CLPedidosPlatos
	SELECT @ID, ID, 0, 0, 1
		FROM CLPlatos
		WHERE Nombre = 'Pulpo a la gallega'

INSERT INTO CLPedidosPlatos
	SELECT @ID, ID, 0, 2, 0
		FROM CLPlatos
		WHERE Nombre = 'Choco Frito'

INSERT INTO CLPedidosPlatos
	SELECT @ID, ID, 3, 0, 0
		FROM CLPlatos
		WHERE Nombre = 'Zanahoria aliñada'

DECLARE @TotalCuenta smallmoney

SET @TotalCuenta = (SELECT V.PVP * PV.Cantidad
					FROM CLPedidosVinos AS PV
						INNER JOIN CLVinos AS V
							ON PV.IDVino = V.ID
					WHERE PV.IDPedido = @ID)

SET @TotalCuenta += (SELECT SUM(PC.Cantidad * C.Importe)
						FROM CLPedidosComplementos AS PC
							INNER JOIN CLComplementos AS C
								ON PC.IDComplemento = C.ID
						WHERE PC.IDPedido = @ID)

SET @TotalCuenta += (SELECT SUM(PP.CantidadTapas * P.PVPTapaRecomendado) + SUM(PP.CantidadMedias * P.PVPMediaRecomendado) + SUM(PP.CantidadRaciones * P.PVPRacionRecomendado) 
						FROM CLPedidosPlatos AS PP
							INNER JOIN CLPlatos AS P
								ON PP.IDPlato = P.ID
						WHERE PP.IDPedido = @ID)

UPDATE CLPedidos
	SET Importe = @TotalCuenta
	WHERE ID = @ID

	SELECT * FROM CLPedidos
COMMIT
--ROLLBACK

BEGIN TRANSACTION
--UPDATE CLPedidos
--	SET Importe = (SELECT SUM(Vi.PVP * PV.Cantidad) + SUM(C.Importe * PC.Cantidad) + SUM(PP.CantidadTapas * Pla.PVPTapaRecomendado) + SUM(PP.CantidadMedias * Pla.PVPMediaRecomendado) + SUM(PP.CantidadRaciones * Pla.PVPRacionRecomendado)
--					FROM CLPedidos AS P
--						INNER JOIN CLPedidosVinos AS PV
--							ON P.ID = PV.IDPedido
--						INNER JOIN CLVinos AS Vi
--							ON PV.IDVino = Vi.ID
--						INNER JOIN CLPedidosComplementos AS PC
--							ON P.ID = PC.IDPedido
--						INNER JOIN CLComplementos AS C
--							ON PC.IDComplemento = C.ID
--						INNER JOIN CLPedidosPlatos AS PP
--							ON P.ID = PP.IDPedido
--						INNER JOIN CLPlatos AS Pla
--							ON PP.IDPlato = Pla.ID
--					WHERE P.ID = 1)

BEGIN TRANSACTION
DECLARE @TotalCuenta smallmoney

SET @TotalCuenta = (SELECT V.PVP * PV.Cantidad
					FROM CLPedidosVinos AS PV
						INNER JOIN CLVinos AS V
							ON PV.IDVino = V.ID
					WHERE PV.IDPedido = 1)

SET @TotalCuenta += (SELECT SUM(PC.Cantidad * C.Importe)
						FROM CLPedidosComplementos AS PC
							INNER JOIN CLComplementos AS C
								ON PC.IDComplemento = C.ID
						WHERE PC.IDPedido = 1)

SET @TotalCuenta += (SELECT SUM(PP.CantidadTapas * P.PVPTapaRecomendado) + SUM(PP.CantidadMedias * P.PVPMediaRecomendado) + SUM(PP.CantidadRaciones * P.PVPRacionRecomendado) 
						FROM CLPedidosPlatos AS PP
							INNER JOIN CLPlatos AS P
								ON PP.IDPlato = P.ID
						WHERE PP.IDPedido = 1)

UPDATE CLPedidos
	SET Importe = @TotalCuenta
	WHERE ID = 1




begin transaction
    update CLPedidos
    set Importe = (
        select sum(Subtotales.subtotal) from (
            select sum(ImporteVinos.Cantidad * ImporteVinos.PVP) as subtotal
            from (
                select PV.IDVino as Producto, PV.Cantidad, V.PVP  from CLVinos as V
                inner join CLPedidosVinos as PV on V.ID = PV.IDVino
                where PV.IDPedido = 4 --Cambiar a variable @ID
            ) as ImporteVinos
            union
            select (
                    sum(isnull(ImportePlatos.CantidadRaciones, 0)isnull(ImportePlatos.PVPRacionRecomendado,0))
                    + sum(isnull(ImportePlatos.CantidadMedias, 0)isnull(ImportePlatos.PVPMediaRecomendado,0))
                    + sum(isnull(ImportePlatos.CantidadTapas, 0)isnull(ImportePlatos.PVPTapaRecomendado,0))
                    ) as subtotal
            from (
                select PP.IDPlato as Producto, 
                        PP.CantidadRaciones, P.PVPRacionRecomendado,
                        PP.CantidadMedias, P.PVPMediaRecomendado,
                        PP.CantidadTapas, P.PVPTapaRecomendado 
                from  CLPlatos as P
                inner join CLPedidosPlatos as PP on P.ID = PP.IDPlato
                where PP.IDPedido = 4 --Cambiar a variable @ID
            ) as ImportePlatos
            union
            select sum(ImporteComplementos.Cantidad ImporteComplementos.Importe) as subtotal
            from (
                select C.ID as Producto, C.Importe, PC.Cantidad from CLComplementos as C
                inner join CLPedidosComplementos as PC on C.ID = PC.IDComplemento
                where PC.IDPedido = 4 --Cambiar a variable @ID
            ) as ImporteComplementos
        ) as Subtotales
    )
    where ID = 4 --Cambiar a variable ID