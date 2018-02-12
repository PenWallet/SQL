/*Boletin 9.1
Escribe las siguientes consultas sobre la base de datos NorthWind.
*/
use Northwind
go 

-- 1. Nombre de los proveedores y número de productos que nos vende cada uno

select CompanyName, count (productID) as [Number Of Products]
from Suppliers as S
inner join Products as P on S.SupplierID = P.SupplierID
group by CompanyName

-- 2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, 
--		Columbia, Los Angeles, Redmond o Atlanta.

select distinct E.FirstName, E.LastName, E.HomePhone from Territories as T
inner join EmployeeTerritories as ET on T.TerritoryID = ET.TerritoryID
inner join Employees as E on ET.EmployeeID = E.EmployeeID
where TerritoryDescription in ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atlanta')


-- 3. Número de productos de cada categoría y nombre de la categoría.

select C.CategoryName, count(P.ProductID) as [Products] from Categories as C
inner join Products as P on C.CategoryID = P.CategoryID
group by C.CategoryName
order by C.CategoryName

-- 4. Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.

select distinct C.CompanyName, P.ProductName from Customers as C
inner join Orders as O on C.CustomerID = O.CustomerID
inner join [Order Details] as OD on O.OrderID = OD.OrderID
inner join Products as P on OD.ProductID = P.ProductID
where 
	ProductName in ('Queso cabrales', 'Tofu')
order by C.CompanyName

-- 5. Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

select distinct E.EmployeeID, E.FirstName, E.LastName, E.HomePhone, CompanyName from Employees as E
inner join Orders as O on E.EmployeeID = O.EmployeeID
inner join Customers as C on O.CustomerID = C.CustomerID
where 
	C.CompanyName in ('Bon app''', 'Meter Franken')
order by E.EmployeeID
	

-- 6. Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca 
--		nada a ningún cliente de Francia. *

select EmployeeID, FirstName, LastName, month(BirthDate) as Mes, day(BirthDate) as Dia from Employees 
where EmployeeID not in (
select distinct E.EmployeeID from Employees as E
inner join Orders as O on E.EmployeeID = O.EmployeeID
inner join Customers as C on O.CustomerID = C.CustomerID
where C.Country = 'France')

-- 7. Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

select P.ProductID, P.CategoryID, sum(OD.Quantity * (OD.UnitPrice - (OD.UnitPrice*OD.Discount/100))) as TotalMoney$ from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
group by P.ProductID, P.CategoryID
order by P.CategoryID, P.ProductID

-- 8. Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).

select E.FirstName, E.LastName, E.Address, year(O.OrderDate) as Year, sum(OD.Quantity*(OD.UnitPrice-OD.UnitPrice*OD.Discount/100)) as total 
from Employees as E
inner join Orders as O on E.EmployeeID = o.EmployeeID
inner join [Order Details] as OD on O.OrderID = OD.OrderID
group by E.FirstName, E.LastName, E.Address, year(O.OrderDate)
order by E.FirstName, E.LastName, E.Address, year(O.OrderDate)

-- 9. Ventas de cada producto en el año 97. Nombre del producto y unidades.

select P.ProductName, sum(OD.Quantity) as TotalQuantityIn1997 from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
where year(O.OrderDate) = 1997
group by P.ProductName
order by P.ProductName

-- 10. Cuál es el producto del que hemos vendido más unidades en cada país. *
select SoldUnits.Country, SoldUnits.ProductName, SoldUnits.Units from (
	select SoldUnits.Country, max(SoldUnits.Units) as MaxPerCountry 
	from (
		select C.Country, P.ProductName ,sum(OD.Quantity) as Units 
		from Products as P
		inner join [Order Details] as OD on P.ProductID = OD.ProductID
		inner join Orders as O on OD.OrderID = O.OrderID
		inner join Customers as C on O.CustomerID = C.CustomerID
		group by C.Country, P.ProductName
	) as SoldUnits
	group by SoldUnits.Country
) as MaxUnits
inner join (
	select C.Country, P.ProductName ,sum(OD.Quantity) as Units 
	from Products as P
	inner join [Order Details] as OD on P.ProductID = OD.ProductID
	inner join Orders as O on OD.OrderID = O.OrderID
	inner join Customers as C on O.CustomerID = C.CustomerID
	group by C.Country, P.ProductName
) as SoldUnits on MaxUnits.Country = SoldUnits.Country
where SoldUnits.Units = MaxUnits.MaxPerCountry

-- 11. Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.

select emp.EmployeeID, emp.FirstName, emp.LastName from Employees as Emp
inner join Employees as Boss on EMP.ReportsTo = boss.EmployeeID
where emp.ReportsTo = (
	select EmployeeID from Employees
	where FirstName = 'Andrew' and LastName = 'Fuller'
	)

-- 12. Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. 
--		Nombre, apellidos, ID.

select EmployeeID, E.FirstName, E.LastName, NumeroSubordinados.Subordinados from Employees as E
left join (
	select ReportsTo as Boss, COUNT(EmployeeID) as Subordinados from Employees
	group by ReportsTo
) as NumeroSubordinados on E.EmployeeID = NumeroSubordinados.Boss


