USE Northwind

-- Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos
--seguros si se ha insertado o no.
-- El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es
--"Pack 6 latas” "Discontinued” toma el valor 0 y el resto de columnas se dejarán a NULL.
-- Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo,
--actualizará el precio y en caso negativo insertarlo.

IF (SELECT * FROM Products WHERE ProductName = 'Cruzcampo lata') = 'Cruzcampo lata'
	BEGIN
		Print('Existe')
	END
ELSE
	BEGIN
		INSERT INTO Products (ProductName, UnitPrice, CategoryID, QuantityPerUnit, Discontinued)
			VALUES('Cruzcampo lata', 4.40, 1, 'Pack de 6 latas', 0)
	END

-- Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID,
--el Nombre, el Precio unitario, el número total de unidades vendidas y el total de dinero
--facturado con ese producto. Si no existe, créala
IF OBJECT_ID('ProductSales') IS NULL
	BEGIN
		CREATE TABLE ProductSales(
		ProductID int NOT NULL,
		ProductName nvarchar(40) NOT NULL,
		UnitPrice money,
		UnitsSold int,
		MoneyEarned money,
		CONSTRAINT PK_ProductSales PRIMARY KEY (ProductID),
		CONSTRAINT FK_ProductSales_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE NO ACTION ON UPDATE CASCADE )
	END
ELSE
	BEGIN
		Print('Ya existe')
	END

-- Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID,
--el Nombre de la compañía, el número total de envíos que ha efectuado y el número de países diferentes
--a los que ha llevado cosas. Si no existe, créala
IF OBJECT_ID('ShipShip') IS NULL
	BEGIN
		CREATE TABLE ShipShip (
		ShipperID int NOT NULL,
		CompanyName nvarchar(40) NOT NULL,
		DaliveriesMade int,
		CountriesVisited int,
		CONSTRAINT PK_ShipShip PRIMARY KEY (ShipperID),
		CONSTRAINT FK_ShipShip_Shippers FOREIGN KEY (ShipperID) REFERENCES Shippers(ShipperID) ON DELETE NO ACTION ON UPDATE CASCADE )
	END
ELSE
	BEGIN
		Print('Ya existe')
	END


--Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido.
--Queremos cambiar el precio unitario según la siguiente tabla:

SELECT P.ProductID,  
	FROM Orders AS O
		INNER JOIN [Order Details] AS OD
			ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P
			ON OD.ProductID = P.ProductID