--Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT T.title, T.type
	FROM titles AS T
		INNER JOIN titleauthor AS TA
			ON T.title_id = TA.title_id
		INNER JOIN authors AS A
			ON TA.au_id = A.au_id
	WHERE A.state LIKE 'CA'

--Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT T.title, T.type
	FROM titles AS T
EXCEPT
SELECT T.title, T.type
	FROM titles AS T
		INNER JOIN titleauthor AS TA
			ON T.title_id = TA.title_id
		INNER JOIN authors AS A
			ON TA.au_id = A.au_id
	WHERE A.state LIKE 'CA'


--Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT A.au_fname, A.au_lname, COUNT(*) AS [Numero de libros]
	FROM titles AS T
		LEFT JOIN titleauthor AS TA
			ON T.title_id = TA.title_id
		LEFT JOIN authors AS A
			ON TA.au_id = A.au_id
	GROUP BY A.au_fname, A.au_lname

--Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.



--Número de empleados de cada editorial.



--Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.



--Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”



--Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.



--Número de ejemplares vendidos de cada libro, especificando el título y el tipo.



--10.  Número de ejemplares de todos sus libros que ha vendido cada autor.



--11.  Número de empleados de cada categoría (jobs).



--12.  Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.



--13.  Autores que han escrito libros de dos o más tipos diferentes



--14.  Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and”