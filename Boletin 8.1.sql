--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT * FROM Customers ORDER BY Country

SELECT country, COUNT(CustomerID) AS 'how many pipol' FROM Customers 
	GROUP BY country
	ORDER BY country

--2. ID de producto y número de unidades vendidas de cada producto. 
SELECT * FROM [Order Details] ORDER BY ProductID

SELECT ProductID, SUM(Quantity) AS [Cantidad comprada]
	FROM [Order Details]
	GROUP BY ProductID

--3. ID del cliente y número de pedidos que nos ha hecho.
SELECT * FROM Orders ORDER BY CustomerID

SELECT CustomerID, COUNT(CustomerID) AS [Cantidad de pedidos]
	FROM Orders
	GROUP BY CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT * FROM Orders ORDER BY CustomerID

SELECT CustomerID, year(OrderDate) AS OrderDate, COUNT(OrderID) AS Numero de pedidos
	FROM Orders
	GROUP BY CustomerID, year(OrderDate)

--5. ID del producto, precio unitario y total facturado de ese producto, 
--ordenado por cantidad facturada de mayor a menor. Si hay varios precios 
--unitarios para el mismo producto tomaremos el mayor.
SELECT * FROM [Order Details] ORDER BY ProductID

SELECT ProductID, MAX(UnitPrice), SUM(UnitPrice * Quantity) AS [Total Facturado]
	FROM [Order Details]
	GROUP BY ProductID
	ORDER BY [Total Facturado] desc
	


--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT * FROM Products

SELECT SupplierID, SUM(UnitPrice * UnitsInStock) AS [Importe total de stock]
	FROM Products
	GROUP BY SupplierID

--7. Número de pedidos registrados mes a mes de cada año.



--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.


--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.


--10. ID de cada proveedor y número de productos distintos que nos suministra.

