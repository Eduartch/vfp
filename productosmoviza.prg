Define Class productosmoviza As Producto  Of 'd:\capass\modelos\productos.prg'
	Function calcularstockproductogmoviza(nidart, nalma, ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lc Noshow Textmerge
	 SELECT a.tcompras-a.tventas as saldo
	 FROM (SELECT b.idart,SUM(IF(b.tipo='C',b.cant*b.kar_equi,0)) AS tcompras,
	 SUM(IF(b.tipo='V',b.cant*b.kar_equi,0)) AS tventas,b.alma 
	 FROM fe_kar AS b
	 INNER JOIN fe_rcom AS e ON e.idauto=b.idauto 
	 WHERE b.acti<>'I'  AND e.acti='A' and b.alma=<<nalma>> and b.idart=<<nidart>> 
	 GROUP BY  idart,alma) AS a
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosCstock(np1, np2, np3, ccursor)
	lc = 'ProMuestraProductosConStock'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lc, lp, ccursor) = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine

