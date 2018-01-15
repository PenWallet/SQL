USE pubs
GO

-- Ejercicio 1
SELECT title, price, notes
	FROM titles
	WHERE [type] LIKE ('%cook%')
	ORDER BY price desc

-- Ejercicio 2
SELECT * FROM jobs

SELECT job_id, job_desc, min_lvl, max_lvl
	FROM jobs
	WHERE min_lvl >= 110

-- Ejercicio 3
SELECT * FROM titles

SELECT title, title_id, [type], notes
	FROM titles
	WHERE notes LIKE '%and%'

-- Ejercicio 4
SELECT * FROM publishers

SELECT pub_name, city
	FROM publishers
	WHERE country LIKE 'USA' AND [state] NOT IN ('CA','TX')

-- Ejercicio 5
SELECT * FROM titles

SELECT title, price, title_id
	FROM titles
	WHERE [type] IN ('business', 'psychology') AND price BETWEEN 10 AND 20
	ORDER BY price desc

-- Ejercicio 6
SELECT * FROM authors

SELECT au_fname, au_lname, [state], city, [address]
	FROM authors
	WHERE [state] NOT LIKE '[CA,OR]%'

-- Ejercicio 7
SELECT * FROM authors

SELECT au_fname, au_lname, [state], city, [address]
	FROM authors
	WHERE au_lname LIKE '[DGS]%'

-- Ejercicio 8
SELECT * FROM employee

SELECT lname, fname, emp_id, job_lvl
	FROM employee
	WHERE job_lvl < 100
	ORDER BY lname, fname


-- MODIFICACIONES DE DATOS
-- Ejercicio 1: Inserta un nuevo autor
SELECT * FROM authors ORDER BY au_lname asc
SELECT * FROM titleauthor

INSERT INTO authors VALUES ('648-77-1178', 'Wallet', 'Pennyless', 697804795, '4104 Falso St.', 'Sevilla', 'AN', 41013, 1)

-- Ejercicio 2: Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
SELECT * FROM titles WHERE title_id LIKE 'PW%'

INSERT INTO titles(title_id, title, type, pub_id, price) VALUES ('PW0001', 'Como ser una diva', 'divasa', 1756, 69.6)
INSERT INTO titles(title_id, title, type, pub_id, price) VALUES ('PW0002', 'Guia 101: Ser esclavo de tu gato', 'guide', 1756, 42.0)

INSERT INTO titleauthor VALUES ('648-77-1178', 'PW0001', 1, 200)
INSERT INTO titleauthor VALUES ('648-77-1178', 'PW0002', 1, 200)

-- Ejercicio 3: Modifica la tabla jobs para que el nivel mínimo sea 90.
SELECT * FROM jobs

BEGIN TRANSACTION

UPDATE jobs
	SET min_lvl = 90
	WHERE min_lvl < 90

ROLLBACK

COMMIT

-- Ejercicio 4: Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
SELECT * FROM publishers

INSERT INTO publishers(pub_id, pub_name, city, state, country) VALUES (9908, 'Mostachon Books', 'Utrera', 'AN', 'Spain')


-- Ejercicio 5:Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart

BEGIN TRANSACTION

UPDATE publishers
	SET pub_name = 'Machen Wücher', city = 'Stuttgart'
	WHERE country LIKE 'Germany'

COMMIT