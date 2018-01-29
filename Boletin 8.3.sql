USE AdventureWorks2012

--Consultas sencillas
--1.Nombre del producto, código y precio, ordenado de mayor a menor precio
SELECT * FROM Production.Product

SELECT Name, ProductID, ListPrice
	FROM Production.Product
	ORDER BY ListPrice desc

--2.Número de direcciones de cada Estado/Provincia
SELECT * FROM Person.Address

SELECT StateProvinceID, City, COUNT(*) AS [Numero de direcciones]
	FROM Person.Address
	GROUP BY City, StateProvinceID
	ORDER BY StateProvinceID, City

--3.Nombre del producto, código, número, tamaño y peso de los productos que estaban 
--a la venta durante todo el mes de septiembre de 2002. 
--No queremos que aparezcan aquellos cuyo peso sea superior a 2000.
SELECT * FROM Production.Product

SELECT Name, ProductID, SellStartDate, ProductNumber, Size, Weight
	FROM Production.Product
	WHERE year(SellStartDate) = 2002 AND month(SellStartDate) = 09 AND Weight < 2000
	ORDER BY Name


--4.Margen de beneficio de cada producto (Precio de venta menos el coste),
--y porcentaje que supone respecto del precio de venta.
SELECT * FROM Production.Product

SELECT ProductID, Name, ListPrice, StandardCost, ListPrice-StandardCost AS [Margen de Beneficio], ((ListPrice-StandardCost)/ListPrice)*100 AS [Porcentaje]
	FROM Production.Product
	WHERE ListPrice > 0

--Consultas de dificultad media
--5.Número de productos de cada categoría
SELECT * FROM Production.Product

SELECT ProductSubcategoryID, COUNT(*) AS [Numero de productos]
	FROM Production.Product
	GROUP BY ProductSubcategoryID
	ORDER BY ProductSubcategoryID

--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).
SELECT * FROM Production.Product

SELECT COUNT(PP.ProductID) AS [Numero de productos], PPC.ProductCategoryID
	FROM Production.Product AS PP
		INNER JOIN Production.ProductSubcategory AS PPS
			ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
		INNER JOIN Production.ProductCategory AS PPC
			ON PPS.ProductCategoryID = PPC.ProductCategoryID
	GROUP BY PPC.ProductCategoryID
	ORDER BY PPC.ProductCategoryID

--7.NúmSaero de unidades vendidas de cada producto cada año.
SELECT * FROM Sales.SalesOrderDetail

SELECT year(SOH.OrderDate) AS Año, SUM(SOD.OrderQty) AS [Cantidad vendida]
	FROM Sales.SalesOrderDetail AS SOD
		INNER JOIN Sales.SalesOrderHeader AS SOH
			ON SOD.SalesOrderID = SOH.SalesOrderID
	GROUP BY YEAR(SOH.OrderDate)


--8.Nombre completo, compañía y total facturado a cada cliente
SELECT * FROM Sales.Customer
SELECT * FROM Person.Person

SELECT LastName, MiddleName, FirstName, BusinessEntityID, 
	FROM Person.Person AS PP
		INNER JOIN Sales.Customer AS SC
			ON PP.


--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, "competition” o "performance”