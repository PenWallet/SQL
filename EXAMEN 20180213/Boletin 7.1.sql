/*

Lenguaje SQL. Consultas 

Escribe el c�digo SQL necesario para realizar las siguientes operaciones sobre la base de datos �NorthWind�
De la 1 a la 7 se pueden hacer sin usar funciones de agregados. 

Consultas sobre una sola Tabla 

*/

use Northwind

-- 1. Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los clientes que no sean de los Estados Unidos.  

select CustomerID, CompanyName, [Address], City, Country
from Customers
where 
	Country <> 'USA'

-- 2. La consulta anterior ordenada por pa�s y ciudad. 

select CustomerID, CompanyName, [Address], City, Country
from Customers
where 
	Country <> 'USA'
order by Country, City

-- 3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en la empresa. 

select FirstName, LastName, City, year(CURRENT_TIMESTAMP - BirthDate)-1900 as Age
from Employees
order by HireDate

-- 4. Nombre y precio de cada producto, ordenado de mayor a menor precio.

select ProductName, UnitPrice
from Products
order by UnitPrice desc
 
-- 5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de Am�rica del Norte. 

select CompanyName, [Address], City, Country
from Suppliers
where
	Country in ('Mexico', 'USA', 'Canada')

-- 6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los productos que no sean de la categor�a 4. 

select ProductName, UnitsInStock, UnitPrice*UnitsInStock as TotalValueInStock
from Products
where
	CategoryID <> 4

-- 7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no residan en un pa�s de Am�rica del Norte 
-- y que la persona de contacto no sea el propietario de la compa��a

select  ContactName, CompanyName, [Address], City, Country
from Customers
where 
	Country not in ('Mexico', 'USA', 'Canada') and
	ContactTitle <> 'Owner'
	
-- 8. ID del cliente y n�mero de pedidos realizados por cada cliente, ordenado de mayor a menor n�mero de pedidos. 

select CustomerID, count(*) as NumberOfOrders
from Orders
group by CustomerID
order by NumberOfOrders desc

-- 9. N�mero de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad. 

select ShipCountry, count(*) as TotalOrders
from Orders
group by ShipCountry
order by ShipCountry

-- 10. N�mero de productos de cada categor�a. 

select CategoryID, count(*) as NumberOfProducts
from Products
group by CategoryID
order by CategoryID