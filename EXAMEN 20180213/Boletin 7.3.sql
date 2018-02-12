/*

Boletin 7.3
Consultas sobre una sola Tabla sin agregados
Sobre la base de Datos AdventureWorks


*/

use AdventureWorks2012

-- 1. Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio esté comprendido entre 50 y 500

select Name, ProductNumber, ListPrice, Color
from Production.Product
where
	Color in ('Red','Yellow','Purple') and 
	ListPrice between 50 and 500

-- 2. Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios 
--		en % del precio de venta de los productos de categorías inferiores a 16

select Name, ProductNumber, ListPrice, StandardCost, listPrice-StandardCost as Profit, (listPrice/(StandardCost/100))-100 as ProfitPerfect
from Production.Product
where ProductSubcategoryID < 16

-- 3. Empleados cuyo nombre o apellidos contenga la letra "r". Los empleados son los que tienen el valor "EM" en la columna 
--		PersonType de la tabla Person

select FirstName, MiddleName, LastName
from person.Person
where 
	PersonType in ('EM') and
	(FirstName like '%r%' or MiddleName like '%r%' or LastName like '%r%')


-- 4. LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados (tabla Employees) de sexo femenino 
--		que tengan más de cinco años de antigüedad

select LoginID, NationalIDNumber, JobTitle, year(CURRENT_TIMESTAMP - cast(BirthDate as datetime)) - 1900 as Age,
	(year(CURRENT_TIMESTAMP - cast(HireDate as datetime)) - 1900) as [Seniority]
from HumanResources.Employee
where Gender = 'F' and
	(year(CURRENT_TIMESTAMP - cast(HireDate as datetime)) - 1900) > 5

-- 5a. Nombres de las ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address

select distinct StateProvinceID, City
from Person.Address
where StateProvinceID in (11,14,35,70)
order by StateProvinceID, City

-- 5b. Número de ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address

select StateProvinceID, count(distinct City) as NumberOfCities
from person.Address
where StateProvinceID in (11,14,35,70)
group by StateProvinceID
