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
SELECT * FROM Person.Person


--Consultas de dificultad media
--5.Número de productos de cada categoría
--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).
--7.Número de unidades vendidas de cada producto cada año.
--8.Nombre completo, compañía y total facturado a cada cliente
SELECT * FROM Sales.Store

--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, "competition” o "performance”