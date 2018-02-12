/*

Sobre la base de datos BICHOS.

*/

use bichos
go

-- 1. Introduce dos nuevos clientes. Asígnales los códigos que te parezcan adecuados.

select * from bi_clientes
insert into bi_clientes(Codigo, Telefono, Direccion, NumeroCuenta, Nombre)
values (107, 689876000, 'En el asiento de al lado', 'ES1112223334445556667778', 'Oscar Funes To'),
	(108, 666999111, 'En el otro lado de mi asiento', 'ES1112223334445556667779', 'Yerai Fuerza Oscura')
	
-- 2. Introduce una mascota para cada uno de ellos. Asígnales los códigos que te parezcan adecuados.
begin transaction

insert into BI_Mascotas(Codigo, Raza, Especie, FechaNacimiento, FechaFallecimiento, Alias, CodigoPropietario)
values ('GH001','Cartujo','Gato', cast(CURRENT_TIMESTAMP as date),null,'Neko-chan',107),
	('PH001','Salchicha','Perro', cast(current_timestamp as date), null, 'Batman', 108)

-- commit
rollback
-- 3. Escribe un SELECT para obtener los IDs de las enfermedades que ha sufrido alguna mascota 
--		(una cualquiera). Los IDs no deben repetirse.

select distinct IDEnfermedad
from BI_Mascotas_Enfermedades
where
	IDEnfermedad is not null
	
-- 4. El cliente Josema Ravilla ha llevado a visita a todas sus mascotas.
--		Escribe un SELECT para averiguar el código de Josema Ravilla. */

select Codigo 
from BI_Clientes
where 
	Nombre = 'Josema Ravilla' 

-- ID = 102

-- 5. Escribe otro SELECT para averiguar los códigos de las mascotas de Josema Ravilla.

select Codigo
from BI_Mascotas
where
	CodigoPropietario = 102

-- IDs GM002 y PH002

-- 6. Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes 
--		en la tabla BI_Visitas. La fecha y hora se tomarán del sistema.
begin transaction

insert into BI_Visitas(Fecha, Temperatura, Peso, Mascota)
values (CURRENT_TIMESTAMP, 38, 18, 'GM002'),
	(CURRENT_TIMESTAMP, 39, 15, 'PH002')

rollback
-- commit

-- 7. Todos los perros del cliente 104 han enfermado el 20 de diciembre de sarna.
--		Escribe un SELECT para averiguar los códigos de todos los perros del cliente 104

select Codigo 
from BI_Mascotas
where
	CodigoPropietario = 104 and
	codigo like ('P%')

-- PH004, PH104, PM004

-- 8. Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Mascotas_Enfermedades

select ID 
from BI_Enfermedades
where Nombre = 'Sarna'

-- ID de sarna = 4

begin transaction

insert into BI_Mascotas_Enfermedades(IDEnfermedad, Mascota, FechaInicio, FechaCura)
values 
	(4, 'PH004', CURRENT_TIMESTAMP, null) ,
	(4, 'PH104', CURRENT_TIMESTAMP, null) ,
	(4, 'PM004', CURRENT_TIMESTAMP, null)

-- commit 
rollback 


-- 9. Escribe una consulta para obtener el nombre, especie y raza de todas las mascotas, ordenados por edad.

select Alias, Especie, Raza, year(CURRENT_TIMESTAMP-cast(FechaNacimiento as datetime))-1900 as Edad 
from BI_Mascotas
order by Edad

-- 10. Escribe los códigos de todas las mascotas que han ido alguna vez al veterinario un lunes o un viernes. 
--		Para averiguar el dia de la semana de una fecha se usa la función DATEPART (WeekDay, fecha) que devuelve un entero 
--		entre 1 y 7 donde el 1 corresponde al lunes, el dos al martes y así sucesivamente.
-- . NOTA: El servidor se puede configurar para que la semana empiece en lunes o domingo.

select distinct Mascota, Fecha, DATEPART(weekday, fecha) as DiaSemana
from BI_Visitas
where datepart(weekday , Fecha) = 1 or datepart(week , Fecha) = 5




