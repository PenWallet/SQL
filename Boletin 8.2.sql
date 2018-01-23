USE pubs

--1. Numero de libros que tratan de cada tema
SELECT * FROM titles

SELECT type, COUNT(*) AS [Numero de libros]
	FROM titles
	GROUP BY type
	ORDER BY type

--2. Número de autores diferentes en cada ciudad y estado
SELECT * FROM authors

SELECT state, city, COUNT(*) AS [Numero de autores]
	FROM authors
	GROUP BY state, city
	ORDER BY state, city

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT * FROM employee

SELECT lname, fname, job_lvl, (year(CURRENT_TIMESTAMP - hire_date)- 1900) AS [Antigüedad]
	FROM employee
	WHERE job_lvl BETWEEN 100 AND 150
	ORDER BY lname, fname

--4. Número de editoriales en cada país. Incluye el país.
SELECT * FROM publishers

SELECT country, COUNT(*) AS [Número de editoriales]
	FROM publishers
	GROUP BY country
	ORDER BY country

--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT * FROM sales

SELECT title_id, SUM(qty) AS [Cantidad vendida], year(ord_date) AS [Año]
	FROM sales
	GROUP BY title_id, year(ord_date)
	ORDER BY Año

--6. Número de autores que han escrito cada libro (title_id y numero de autores).
SELECT * FROM titleauthor
ORDER BY title_id

SELECT title_id, COUNT(title_id) AS [Número de autores]
	FROM titleauthor
	GROUP BY title_id
	ORDER BY title_id

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance)
--tenga un valor superior a $7.000, ordenado por tipo y título
SELECT * FROM titles

SELECT title_id, type, price, advance
	FROM titles
	WHERE advance > 7000
	ORDER BY type, title_id