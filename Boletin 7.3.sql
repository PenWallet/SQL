-- Ejercicio 1: Nombre, numero de producto, precio y color de los productos de color
-- rojo o amarillo cuyo precio esté comprendido entre 50 y 500
SELECT * FROM Production.Product
WHERE Name LIKE 'HL Headset'

SELECT Name, ProductNumber, ListPrice, Color 
	FROM Production.Product
	WHERE Color IN ('Red', 'Yellow') AND ListPrice BETWEEN 50 AND 500


-- Ejercicio 2: Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total 
-- y margen de beneficios en % del precio de venta de los productos de categorías inferiores a 16
SELECT Name, ProductID, StandardCost, ListPrice, (ListPrice-StandardCost) AS MargenDeBeneficios, (((ListPrice/StandardCost)-1)*100) AS MargenDeBeneficiosPorcentaje
	FROM Production.Product
	WHERE ProductSubcategoryID < 16

-- Ejercicio 3: Empleados cuyo nombre o apellidos contenga la letra "r".
-- Los empleados son los que tienen el valor "EM" en la columna PersonType de la tabla Person
SELECT * FROM HumanResources.Employee

-- Ejercicio 4: LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados
-- (tabla Employees) de sexo femenino que tengan más de cinco años de antigüedad
SELECT LoginID, NationalIDNumber, (year(CURRENT_TIMESTAMP) - year(BirthDate)) AS Age, JobTitle
	FROM HumanResources.Employee
	WHERE Gender = 'M' AND (year(CURRENT_TIMESTAMP) - year(HireDate)) > 5
	ORDER BY Age

-- Ejercicio 5: Ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address
SELECT * FROM Person.Address WHERE StateProvinceID = 11 ORDER BY StateProvinceID

SELECT DISTINCT(City), StateProvinceID
	FROM Person.Address
	WHERE StateProvinceID IN (11, 14, 35, 70)
	ORDER BY StateProvinceID, City