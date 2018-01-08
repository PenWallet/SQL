USE pubs
GO

-- Ejercicio 1
SELECT title, price, notes
	FROM titles
	WHERE "type" IN (mod_cook OR trad_cook)

SELECT * FROM titles