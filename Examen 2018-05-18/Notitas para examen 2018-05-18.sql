--Para saber si una tabla existe:
IF OBJECT_ID('ProductSales') IS NULL

--Para crear un procedimiento
GO
CREATE PROCEDURE Nombre (@Variables int, @Variable2 date = 9 OUTPUT)
AS
	--Código
GO

--Función inline
GO
CREATE FUNCTION NombreInLine(Variables)
RETURNS TABLE AS
RETURN (SELECT * FROM X)
GO

--Para ejecutar una InLine
SELECT * FROM NombreInLine()


--Función escalar
GO
CREATE FUNCTION NombreEscalar(Variables)
	RETURNS int AS
		BEGIN
			RETURN @Variable
		END
GO

--Para ejecutar una escalar
SELECT NombreEscalar()

--Ejemplo
USE LeoMetro
GO
CREATE FUNCTION FnCuentaParadas (@IDTren Int, @Inicio Date, @Fin Date)
	RETURNS Int AS
		BEGIN
			DECLARE @Veces Int = 0
			SELECT @Veces = Count(*) FROM LM_Recorridos
				WHERE Tren = @IDTren AND CAST (Momento AS DATE) Between @Inicio AND @Fin
			RETURN @Veces
		END
GO