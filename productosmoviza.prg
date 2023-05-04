Define Class productosmoviza as producto  Of 'd:\capass\modelos\productos.prg'
	Function calcularstockproductogmoviza(nidart,nalma,ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	 SELECT a.tcompras-a.tventas as saldo
	 FROM (SELECT b.idart,SUM(IF(b.tipo='C',b.cant*b.kar_equi,0)) AS tcompras,
	 SUM(IF(b.tipo='V',b.cant*b.kar_equi,0)) AS tventas,b.alma 
	 FROM fe_kar AS b
	 INNER JOIN fe_rcom AS e ON e.idauto=b.idauto 
	 WHERE b.acti<>'I'  AND e.acti='A' and b.alma=<<nalma>> and b.idart=<<nidart>> 
	 GROUP BY  idart,alma) AS a
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
