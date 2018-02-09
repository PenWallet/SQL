USE Northwind

--1. N�mero de clientes de cada pa�s.
SELECT Country, COUNT(*) AS [Numero de clientes]
	FROM Customers
	GROUP BY Country

--2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre
--del producto
SELECT P.ProductName, COUNT(DISTINCT O.CustomerID) AS [Numero de clientes]
	FROM Orders AS O
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P 
			ON OD.ProductID = P.ProductID
	GROUP BY P.ProductName
		

--3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el
--nombre del producto
SELECT P.ProductName, COUNT(DISTINCT S.Country) AS [Numero de pa�ses]
	FROM Products AS P
		INNER JOIN Suppliers AS S
			ON P.SupplierID = S.SupplierID
	GROUP BY P.ProductName, S.Country
	ORDER BY P.ProductName


--4. Empleados (nombre y apellido) que han vendido alguna vez
--�Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�.
SELECT E.LastName, E.FirstName, P.ProductName
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P
			ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Gudbrandsdalsost', 'Lakkalik��ri', 'Tourti�re', 'Boston Crab Meat')


--5. Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o
--�Carnarvon Tigers�.
SELECT E.FirstName, E.LastName
	FROM Employees AS E
		INNER JOIN Orders AS O
			ON E.EmployeeID = O.EmployeeID
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P
			ON OD.ProductID = P.ProductID
	WHERE P.ProductName IN ('Northwoods Cranberry Sauce', 'Carnarvon Tigers')


--6. N�mero de unidades de cada categor�a de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categor�a.


--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a.


--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado.


--9. Total de ventas (US$) en cada pa�s cada a�o.


--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.


--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.


--12. Mejor cliente (el que m�s nos compra) de cada pa�s.


--13. N�mero de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su direcci�n completa.


--14. Clientes que nos compran m�s de cinco productos diferentes.


--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el a�o 97.


--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento