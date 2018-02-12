USE Northwind

--1. Número de clientes de cada país.
SELECT Country, COUNT(*) AS [Numero de clientes]
	FROM Customers
	GROUP BY Country

--2. Número de clientes diferentes que compran cada producto. Incluye el nombre
--del producto
SELECT P.ProductName, COUNT(DISTINCT O.CustomerID) AS [Numero de clientes]
	FROM Orders AS O
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P 
			ON OD.ProductID = P.ProductID
	GROUP BY P.ProductName
		

--3. Número de países diferentes en los que se vende cada producto. Incluye el
--nombre del producto
SELECT P.ProductName, COUNT(DISTINCT S.Country) AS [Numero de países]
	FROM Products AS P
		INNER JOIN Suppliers AS S
			ON P.SupplierID = S.SupplierID
	GROUP BY P.ProductName, S.Country
	ORDER BY P.ProductName


--4. Empleados (nombre y apellido) que han vendido alguna vez
--“Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”.
SELECT E.LastName, E.FirstName, P.ProductName
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P
			ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Gudbrandsdalsost', 'Lakkalikööri', 'Tourtière', 'Boston Crab Meat')


--5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o
--“Carnarvon Tigers”.
SELECT FirstName, LastName From Employees
EXCEPT
SELECT E.FirstName, E.LastName
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P
			ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Northwoods Cranberry Sauce', 'Carnarvon Tigers')


--6. Número de unidades de cada categoría de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categoría.
SELECT E.FirstName, E.LastName, C.CategoryName, SUM(OD.Quantity) AS [Cantidad vendida]
	FROM Categories AS C
		INNER JOIN Products AS P
			ON C.CategoryID = P.CategoryID
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		INNER JOIN Employees AS E
			ON O.EmployeeID = E.EmployeeID
	GROUP BY E.FirstName, E.LastName, C.CategoryName
	ORDER BY E.FirstName, E.LastName, C.CategoryName


--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la
--categoría.
SELECT C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS [Dinero total]
	FROM Categories AS C
		INNER JOIN Products AS P
			ON C.CategoryID = P.CategoryID
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
	WHERE year(O.OrderDate) = 1997
	GROUP BY C.CategoryName
	ORDER BY C.CategoryName
	 

--8. Productos que han comprado más de un cliente del mismo país, indicando el
--nombre del producto, el país y el número de clientes distintos de ese país que
--lo han comprado.
SELECT * FROM Customers

SELECT C.Country, COUNT(C.ContactName) AS [Numero de personas], P.ProductName
	FROM Products AS P
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
	GROUP BY C.Country, P.ProductName
	HAVING COUNT(C.ContactName) > 1

--9. Total de ventas (US$) en cada país cada año.


--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.


--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.


--12. Mejor cliente (el que más nos compra) de cada país.


--13. Número de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su dirección completa.


--14. Clientes que nos compran más de cinco productos diferentes. *
GO
CREATE VIEW Puntadelnabo2 AS
SELECT C.ContactName, P.ProductName
	FROM Products AS P
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
GO
SELECT ContactName, COUNT(*) AS [Numero de productos]
	FROM Puntadelnabo2
	GROUP BY ContactName
	HAVING COUNT(ProductName) > 5


--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el año 97.

SELECT SUM(OD.UnitPrice * OD.Quantity * (1-OD.Discount))/COUNT(E.EmployeeID) AS [Media US$]
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
	WHERE year(OrderDate) = 1997


/*SELECT E.LastName, E.FirstName, 
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID*/


--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento *

