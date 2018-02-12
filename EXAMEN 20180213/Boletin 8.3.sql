/*Consultas 8.3
Base de datos: AdventureWorks2012
*/

use AdventureWorks2012
go


--		Consultas sencillas
-- 1.Nombre del producto, c�digo y precio, ordenado de mayor a menor precio

select Name, ProductID, ListPrice
from Production.Product
order by ListPrice desc

-- 2.N�mero de direcciones de cada Estado/Provincia

select City, count(*) as [Addresses]
from Person.Address
group by city
order by city


-- 3.Nombre del producto, c�digo, n�mero, tama�o y peso de los productos que 
--		estaban a la venta durante todo el mes de septiembre de 2002. No queremos 
--		que aparezcan aquellos cuyo peso sea superior a 2000.

-- Misi�n abortada; AW es demasiado aburrido.

-- 4.Margen de beneficio de cada producto (Precio de venta menos el coste), 
--		y porcentaje que supone respecto del precio de venta.


--		Consultas de dificultad media
-- 5.N�mero de productos de cada categor�a
-- 6.Igual a la anterior, pero considerando las categor�as 
--		generales (categor�as de categor�as).
-- 7.N�mero de unidades vendidas de cada producto cada a�o.
-- 8.Nombre completo, compa��a y total facturado a cada cliente
-- 9.N�mero de producto, nombre y precio de todos aquellos en cuya 
--		descripci�n aparezcan las palabras "race�, "competition� o "performance�


--		Consultas avanzadas
-- 10.Facturaci�n total en cada pa�s
-- 11.Facturaci�n total en cada Estado
-- 12.Margen medio de beneficios y total facturado en cada pa�s