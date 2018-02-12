/* 
Unidad 9. Consultas elaboradas en SQL Server Escribe las siguientes consultas sobre la base de datos NorthWind.
Pon el enunciado como comentario junta a cada una PROBLEMA 

*/

use Northwind

-- 1. Número de clientes de cada país. 

select Country, count(*) as [Number Of Customers]
from Customers
group by Country
order by Country

-- 2. Número de clientes diferentes que compran cada producto. 

select ProductID, count(distinct CustomerID) as DifferentCustomers from [Order Details] as OD 
inner join Orders as O on OD.OrderID = O.OrderID
group by ProductID
order by ProductID

-- 3. Número de países diferentes en los que se vende cada producto. 

select ProductID, count(distinct ShipCountry) Countries from Orders as O
inner join [Order Details] as OD on O.OrderID = OD.OrderID
group by ProductID

-- 4. Empleados que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”. 

select distinct EmployeeID from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
where P.ProductName in ('Gudbrandsdalsost','Lakkalikööri','Tourtière','Boston Crab Meat')

-- 5. Empleados que no han vendido nunca “Chartreuse verte” ni “Ravioli Angelo”. 

select EmployeeID from Employees
except 
select distinct EmployeeID from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
where P.ProductName in ('Chartreuse verte','Ravioli Angelo')

-- 6. Número de unidades de cada categoría de producto que ha vendido cada empleado. 

select O.EmployeeID, P.CategoryID, sum(Quantity) as SoldUnits from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
group by O.EmployeeID, P.CategoryID
order by O.EmployeeID, P.CategoryID

-- 7. Total de ventas (US$) de cada categoría en el año 97. 

select CategoryID, sum(OD.UnitPrice*Quantity) as Dollars from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
where year(o.OrderDate) = 1997
group by O.EmployeeID, P.CategoryID
order by O.EmployeeID, P.CategoryID

-- 8. Productos que han comprado más de un cliente del mismo país, indicando el nombre del producto, 
--	el país y el número de clientes distintos de ese país que lo han comprado. 

select P.ProductName, O.ShipCountry, count(distinct O.CustomerID) from Products as P
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
group by P.ProductName, O.ShipCountry
having count(distinct O.CustomerID) > 1

-- 9. Total de ventas (US$) en cada país cada año. 

select O.ShipCountry , year(O.OrderDate) as [Year], sum(OD.Quantity*OD.Quantity) as Dollars
from [Order Details] as OD 
inner join Orders as O on OD.OrderID = O.OrderID
group by O.ShipCountry , year(O.OrderDate)
order by O.ShipCountry , year(O.OrderDate)


-- 10. Producto superventas de cada año, indicando año, nombre del producto, categoría 
--	y cifra total de ventas. 

select P.ProductName, C.CategoryName ,year(O.OrderDate) as [Year], sum(OD.Quantity) as TotalPerProduct
from Categories as C
inner join Products as P on C.CategoryID = P.CategoryID
inner join [Order Details] as OD on P.ProductID = OD.ProductID
inner join Orders as O on OD.OrderID = O.OrderID
inner join (
	select [Year], max(TotalPerProduct) as MaxSold
	from (
		select P.ProductName, C.CategoryName ,year(O.OrderDate) as [Year], sum(OD.Quantity) as TotalPerProduct
		from Categories as C
		inner join Products as P on C.CategoryID = P.CategoryID
		inner join [Order Details] as OD on P.ProductID = OD.ProductID
		inner join Orders as O on OD.OrderID = O.OrderID
		group by P.ProductName, C.CategoryName ,year(O.OrderDate)
		) as MaxPerYear
	group by [Year]
	) as SuperVentas on year(O.OrderDate) = SuperVentas.Year
group by P.ProductName, C.CategoryName, year(O.OrderDate), SuperVentas.MaxSold
having SuperVentas.MaxSold = sum(OD.Quantity)
order by P.ProductName, C.CategoryName , year(O.OrderDate)


-- 11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución respecto al año anterior 
-- en US $ y en %. 

Select OD.ProductID, sum(OD.Quantity*OD.UnitPrice) as TotalDolaresEn1997,
SoldIn1996.TotalDollars as TotalDolaresEn1996,
sum(OD.Quantity*OD.UnitPrice)-SoldIn1996.TotalDollars as DiferenciaDolares,
100-cast(SoldIn1996.TotalDollars/(sum(OD.Quantity*OD.UnitPrice)*0.01) as decimal(5,2)) as DiferenciaPorcentual
from Orders as O
inner join [Order Details] as OD on O.OrderID = OD.OrderID
inner join (
	Select OD.ProductID, sum(OD.Quantity*OD.UnitPrice) as TotalDollars from Orders as O
	inner join [Order Details] as OD on O.OrderID = OD.OrderID
	where year(O.OrderDate) = 1996
	group by OD.ProductID
	) as SoldIn1996 on OD.ProductID = SoldIn1996.ProductID
where year(O.OrderDate) = 1997
group by OD.ProductID, TotalDollars
order by OD.ProductID, TotalDollars


-- 12. Mejor cliente (el que más nos compra) de cada país. 


select ComprasPorCliente.Country, ComprasPorCliente.NumeroCompras, ComprasPorCliente.ContactName from (
	select Country, max(NumeroCompras) as MaximoNumCompras  from (
		select C.ContactName, C.Country, count(O.OrderID) as NumeroCompras from Customers as C
		inner join Orders as O on C.CustomerID = O.CustomerID
		group by C.ContactName, C.Country
		) as ComprasPorCliente
	group by Country
	) as ComprasMaxPais
inner join (
	select C.ContactName, C.Country, count(O.OrderID) as NumeroCompras from Customers as C
	inner join Orders as O on C.CustomerID = O.CustomerID
	group by C.ContactName, C.Country
	) as ComprasPorCliente on ComprasMaxPais.Country = ComprasPorCliente.Country
where ComprasMaxPais.MaximoNumCompras = ComprasPorCliente.NumeroCompras


-- 13. Número de productos diferentes que nos compra cada cliente. 

select O.CustomerID, count(distinct OD.ProductID) as ProductosDistintosComprados from Orders as O
inner join [Order Details] as OD on O.OrderID = OD.OrderID
group by O.CustomerID
order by O.CustomerID

-- 14. Clientes que nos compran más de cinco productos diferentes. 

select O.CustomerID, count(distinct OD.ProductID) as ProductosDistintosComprados from Orders as O
inner join [Order Details] as OD on O.OrderID = OD.OrderID
group by O.CustomerID
having count(distinct OD.ProductID) > 5
order by O.CustomerID

-- 15. Vendedores que han vendido una mayor cantidad que la media en US $ en el año 97. 

select O.EmployeeID, sum(OD.Quantity*OD.UnitPrice) as TotalVentas97 from Orders as O
inner join [Order Details] as OD on O.OrderID = OD.OrderID
where year(O.OrderDate) = 1997 
group by O.EmployeeID
having sum(OD.Quantity*OD.UnitPrice) >
	(
	select avg(Total97.TotalVentas97) as Media from (
		select O.EmployeeID, sum(OD.Quantity*OD.UnitPrice) as TotalVentas97 from Orders as O
		inner join [Order Details] as OD on O.OrderID = OD.OrderID
		where year(O.OrderDate) = 1997
		group by O.EmployeeID
		) as Total97
	) 
order by O.EmployeeID

-- 16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos años consecutivos, 
-- indicando el año en que se produjo el aumento. 

select O.EmployeeID, year(O.OrderDate) as [Year], sum(OD.Quantity*OD.UnitPrice) as TotalVentas from Orders as O
inner join [Order Details] as OD on O.OrderID = OD.OrderID
inner join (
	select O.EmployeeID, year(O.OrderDate) as [Year], sum(OD.Quantity*OD.UnitPrice) as TotalVentas from Orders as O
	inner join [Order Details] as OD on O.OrderID = OD.OrderID
	group by O.EmployeeID, year(O.OrderDate)
	) as TwoYearsAgo on O.EmployeeID = TwoYearsAgo.EmployeeID and year(O.OrderDate)-1 = TwoYearsAgo.Year
group by O.EmployeeID, year(O.OrderDate), TwoYearsAgo.TotalVentas
having sum(OD.Quantity*OD.UnitPrice) > (TwoYearsAgo.TotalVentas+TwoYearsAgo.TotalVentas*0.1)
order by O.EmployeeID, year(O.OrderDate)
