USE Northwind

--Nombre de los proveedores y n�mero de productos que nos vende cada uno
SELECT S.CompanyName, COUNT(P.ProductID) AS [Numero de productos]
	FROM Suppliers AS S
		INNER JOIN Products AS P
			ON S.SupplierID = P.SupplierID
	GROUP BY S.CompanyName

--Nombre completo y telefono de los vendedores que trabajen en 
--New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT * FROM Employees

SELECT LastName, FirstName, HomePhone
	FROM Employees
	WHERE City IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atlanta')


--N�mero de productos de cada categor�a y nombre de la categor�a.
SELECT C.CategoryName, COUNT(ProductID) AS [Numero de productos]
	FROM Products AS P
		INNER JOIN Categories AS C
			ON P.CategoryID = C.CategoryID
	GROUP BY C.CategoryName


--Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT * FROM Products

SELECT C.CompanyName
	FROM Products AS P
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
		INNER JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
	WHERE P.ProductName IN ('Queso Cabrales', 'Tofu')

--Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.
SELECT * FROM Customers

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
	WHERE C.CompanyName IN ('Bon App''', 'Meter Franken'

--Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os)
--que no han vendido nunca nada a ning�n cliente de Francia. *
SELECT * FROM Employees

SELECT E.EmployeeID, E.FirstName, E.LastName, day(E.BirthDate) AS [D�a cumplea�os], month(E.BirthDate) AS [Mes cumplea�os]
FROM Employees AS E
EXCEPT
SELECT E.EmployeeID, E.FirstName, E.LastName, day(E.BirthDate) AS [D�a cumplea�os], month(E.BirthDate) AS [Mes cumplea�os]
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
	WHERE C.Country = 'France'

--Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
SELECT * FROM [Order Details]

SELECT C.CategoryName, SUM((OD.UnitPrice * OD.Quantity) * (1 + OD.Discount))
	FROM Products AS P
		INNER JOIN Categories AS C
			ON P.CategoryID = C.CategoryID
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
	GROUP BY C.CategoryName

--Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
SELECT * FROM Employees

SELECT year(O.OrderDate) AS A�o, E.FirstName, E.LastName, E.Address, SUM((OD.UnitPrice * OD.Quantity) * (1 + OD.Discount)) AS [Total facturado]
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN Customers AS C
			ON O.CustomerID = C.CustomerID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
	GROUP BY E.FirstName, E.LastName, E.Address, year(O.OrderDate)
	ORDER BY E.FirstName, E.LastName, year(O.OrderDate)


--Ventas de cada producto en el a�o 97. Nombre del producto y unidades.
SELECT * FROM 

SELECT P.ProductName, (OD.Quantity) AS [Cantidad de producto], year(O.OrderDate)
	FROM Products AS P
		INNER JOIN [Order Details] AS OD
			ON P.ProductID = OD.ProductID
		INNER JOIN Orders AS O
			ON OD.OrderID = O.OrderID
	WHERE year(O.OrderDate) = 1997


--Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *



--Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.
SELECT * FROM Employees ORDER BY ReportsTo

SELECT LastName, FirstName
	FROM Employees
	WHERE ReportsTo = 2

SELECT Tr.FirstName, Tr.LastName
	FROM Employees AS Je
		INNER JOIN Employees AS Tr
			ON Tr.ReportsTo = Je.EmployeeID
		WHERE Je.FirstName = 'Andrew'

--N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT Tr.EmployeeID, Tr.FirstName, Tr.LastName
	FROM Employees AS Je
		INNER JOIN Employees AS Tr
			ON Tr.ReportsTo = Je.EmployeeID
	GROUP Je.