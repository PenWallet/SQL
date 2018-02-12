/*
Escribe el c�digo SQL necesario para realizar las siguientes operaciones sobre la base de datos "NorthWind�

Consultas sobre una sola Tabla
*/

use Northwind
go

-- 1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.

select Country, count(*) as [Total of Customers]
from Customers
group by Country
order by Country

-- 2. ID de producto y n�mero de unidades vendidas de cada producto. 

select ProductID, sum(Quantity) as [Sold Units]
from [Order Details]
group by ProductID
order by ProductID

-- 3. ID del cliente y n�mero de pedidos que nos ha hecho.

select CustomerID, count(*) as [Total Orders]
from orders
group by CustomerID
order by CustomerID

-- 4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.

select CustomerID, year(OrderDate) as [Year],  count(*) as [Total Orders]
from orders
group by CustomerID,  year(OrderDate)
order by CustomerID,  year(OrderDate)

-- 5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

select ProductID, max(UnitPrice) as [Max Unit Price], sum(Quantity*UnitPrice) as [Total Invoiced]
from [Order Details] 
group by ProductID
order by [Max Unit Price]

-- 6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.

select SupplierID, sum(UnitPrice*UnitsInStock) as [Total Amount in Stock]
from Products
group by SupplierID
order by SupplierID

-- 7. N�mero de pedidos registrados mes a mes de cada a�o.

select year(OrderDate) as [Year], month(OrderDate) as [Month], count(*) as [Total Orders]
from Orders
group by year(OrderDate) , month(OrderDate)
order by [Year],[Month]

-- 8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en 
--		la que lo hemos enviado (ShipDate), en d�as para cada a�o.

select year(OrderDate) as [Year], avg(DATEDIFF(day, OrderDate, ShippedDate)) as [Average Time]
from Orders
group by year(OrderDate)
order by year(OrderDate)

-- 9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.

select ShipVia, count(*) as [Send Orders]
from Orders
group by ShipVia
order by ShipVia

-- 10. ID de cada proveedor y n�mero de productos distintos que nos suministra.

select * from Products

select SupplierID, count(*) as [Delivered Products]
from Products
group by SupplierID
order by SupplierID
