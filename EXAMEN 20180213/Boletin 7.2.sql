/*

Boletin 7.2
Consultas sobre una sola Tabla sin agregados
Sobre la base de datos "pubs” (En la plataforma aparece como "Ejemplos 2000").

*/

use pubs

-- 1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.

select title, price, notes
from titles
where [type] like '%cook%'
order by price desc

-- 2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.

select job_id, job_desc, min_lvl, max_lvl
from jobs
where 
	110 between min_lvl and max_lvl

-- 3. Título, ID y tema de los libros que contengan la palabra "and” en las notas

select title, title_id, [type]
from titles
where 
	notes like '%and%'

-- 4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas

select pub_name, city
from publishers
where 
	country = 'USA' and
	[state] not in ('TX','CA')

-- 5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.

select title, price, title_id
from titles
where 
	type in ('Psychology','Business') and
	price between 10.00 and 20.00 --> Numeros decimales ¿Cómo?

-- 6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.

select au_fname, au_lname, [address], city, [state]
from authors
where
	[state] not in ('CA','OR')

-- 7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.

select au_fname, au_lname, [address], city, [state]
from authors
where
	au_lname like '[DGS]%'

-- 8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente

select emp_id, job_lvl, fname, lname
from employee
where
	job_lvl < 100
order by lname, fname desc

--		Modificaciones de datos

-- 9. Inserta un nuevo autor.

insert into authors(au_id, au_lname, au_fname, phone, [address], city, [state], zip, [contract])
values ('123-45-6789','Flowered','Sefransito','619 699-6969','123 False Street', 'Seville','SP','41001','1') 

-- select * from authors where au_lname = 'Flowered'

-- 10. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.

--Averiguamos cual es la ID de Ramona Publishers
select pub_id from publishers where pub_name = 'Ramona Publishers' --> 1756

insert into titles(title_id, title, type, pub_id, pubdate)
values 
	('PS1234','Deconstrucción de la educación emocional en las relaciones abiertas','Psychology', 1756, CURRENT_TIMESTAMP)
	, ('NT1234','El maravilloso mundo de los osos','Nature', 1756, CURRENT_TIMESTAMP)

insert into titleauthor(au_id, title_id, au_ord, royaltyper)
values ('123-45-6789','PS1234',1,100)
, ('123-45-6789', 'NT1234',1,100)

select * from titles  
select * from titleauthor --> au_ord: orden de los autores / royaltyper: porcentaje de los beneficios


-- 11. Modifica (¿Los datos de?) la tabla jobs para que el nivel mínimo sea 90.

update jobs
set min_lvl = 90
where min_lvl < 90

-- 12. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.

insert into publishers(pub_id, pub_name, city, [state], country)
values ('9908', 'Mostachon Books', 'Utrera', null, 'Spain')

-- 13. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart

update publishers
set pub_name = 'Machen Wücher', city = 'Stuttgart'
where country = 'Germany'
