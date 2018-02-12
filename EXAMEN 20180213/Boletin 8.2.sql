/*
Boletin 8.2
Consultas sobre una sola Tabla con agregados
Escribe el c�digo SQL necesario para realizar las siguientes operaciones
sobre la base de datos "pubs�
*/

use pubs
go

-- 1. Numero de libros que tratan de cada tema

select [type], count(*) as [Books]
from titles
group by [type]
order by [type]

-- 2. N�mero de autores diferentes en cada ciudad y estado

select [state], city, count(*) as [Authors]
from authors
group by [state], city
order by [state], city

-- 3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.

select fname, lname, job_lvl, year(CURRENT_TIMESTAMP - hire_date)-1900 as [Years in the business]
from employee
where job_lvl between 100 and 150

-- 4. N�mero de editoriales en cada pa�s. Incluye el pa�s.

select country, count(*) [Publishers]
from publishers
group by country
order by country

-- 5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).

select title_id, year(ord_date) as [Year], count(*) as [Units]
from sales
group by title_id, year(ord_date)
order by title_id, year(ord_date)

-- 6. N�mero de autores que han escrito cada libro (title_id y numero de autores).

--Version 1
select title_id, count(*) as [NumberOfAuthors]
from titleauthor
group by title_id
order by title_id

--Version 2
select title_id, max(au_ord) as [NumberOfAuthors]
from titleauthor
group by title_id
order by title_id

-- 7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior 
--	a $7.000, ordenado por tipo y t�tulo.

select title_id, title ,[type], price
from titles
where
	advance > 7000.00
order by [type], title_id