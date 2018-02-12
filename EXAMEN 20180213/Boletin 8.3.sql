/*Consultas 8.3
Base de datos: AdventureWorks2012
*/

use AdventureWorks2012
go


--		Consultas sencillas
-- 1.Nombre del producto, código y precio, ordenado de mayor a menor precio

select Name, ProductID, ListPrice
from Production.Product
order by ListPrice desc

-- 2.Número de direcciones de cada Estado/Provincia

select City, count(*) as [Addresses]
from Person.Address
group by city
order by city


-- 3.Nombre del producto, código, número, tamaño y peso de los productos que 
--		estaban a la venta durante todo el mes de septiembre de 2002. No queremos 
--		que aparezcan aquellos cuyo peso sea superior a 2000.

-- Misión abortada; AW es demasiado aburrido.

-- 4.Margen de beneficio de cada producto (Precio de venta menos el coste), 
--		y porcentaje que supone respecto del precio de venta.


--		Consultas de dificultad media
-- 5.Número de productos de cada categoría
-- 6.Igual a la anterior, pero considerando las categorías 
--		generales (categorías de categorías).
-- 7.Número de unidades vendidas de cada producto cada año.
-- 8.Nombre completo, compañía y total facturado a cada cliente
-- 9.Número de producto, nombre y precio de todos aquellos en cuya 
--		descripción aparezcan las palabras "race”, "competition” o "performance”


--		Consultas avanzadas
-- 10.Facturación total en cada país
-- 11.Facturación total en cada Estado
-- 12.Margen medio de beneficios y total facturado en cada país