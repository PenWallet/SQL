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
-- Ejercicio 1
SELECT * FROM authors

INSERT INTO authors VALUES ('648-77-1178', 'Wallet', 'Pennyless', 697804795, '4104 Falso St.', 'Sevilla', 'AN', 41013, 1)

-- Ejercicio 2
SELECT * FROM titles

INSERT INTO titles(title_id, title, type, pub_id, price) VALUES ('PW0001', 'Como ser una diva', 'divasa', 