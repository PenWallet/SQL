-- 1. El nombre completo de cada jugador que hayan apostado por el caballo con mayor número de victorias nacido en 2009
DROP DATABASE LeoTurfTest


--Nombre del hipodromo donde se haya hecho la apuesta mas grande a un caballo que llevase numero par
SELECT A.Importe, C.Hipodromo
	FROM LTApuestas AS A
		INNER JOIN LTCarreras AS C
			ON A.IDCarrera = C.ID
		INNER JOIN LTCaballosCarreras AS CC
			ON A.IDCaballo = CC.IDCaballo AND A.IDCarrera = CC.IDCarrera
	WHERE A.Importe =	(
							SELECT MAX(Importe) 
								FROM LTApuestas AS A 
									INNER JOIN LTCaballosCarreras AS CC 
										ON A.IDCaballo = CC.IDCaballo AND A.IDCarrera = CC.IDCarrera 
								WHERE CC.Numero % 2 = 0
						)


--Precio del los primeros premios que se hayan ganado en las segundas carreras del Gran Hipodromo de Andalucia


