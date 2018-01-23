USE pubs

--1. Numero de libros que tratan de cada tema
SELECT * FROM titles

SELECT type, COUNT(*) AS [Numero de libros]
	FROM titles
	GROUP BY type
	ORDER BY type

--2. N�mero de autores diferentes en cada ciudad y estado
SELECT * FROM authors

SELECT state, city, COUNT(*) AS [Numero de autores]
	FROM authors
	GROUP BY state, city
	ORDER BY state, city

--3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT * FROM employee

SELECT lname, fname, job_lvl, (year(CURRENT_TIMESTAMP - hire_date)- 1900) AS [Antig�edad]
	FROM employee
	WHERE job_lvl BETWEEN 100 AND 150
	ORDER BY lname, fname

--4. N�mero de editoriales en cada pa�s. Incluye el pa�s.
SELECT * FROM publishers

SELECT country, COUNT(*) AS [N�mero de editoriales]
	FROM publishers
	GROUP BY country
	ORDER BY country

--5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).
SELECT * FROM sales

SELECT title_id, SUM(qty) AS [Cantidad vendida], year(ord_date) AS [A�o]
	FROM sales
	GROUP BY title_id, year(ord_date)
	ORDER BY A�o

--6. N�mero de autores que han escrito cada libro (title_id y numero de autores).
SELECT * FROM titleauthor
ORDER BY title_id

SELECT title_id, COUNT(title_id) AS [N�mero de autores]
	FROM titleauthor
	GROUP BY title_id
	ORDER BY title_id

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance)
--tenga un valor superior a $7.000, ordenado por tipo y t�tulo
SELECT * FROM titles

SELECT title_id, type, price, advance
	FROM titles
	WHERE advance > 7000
	ORDER BY type, title_id