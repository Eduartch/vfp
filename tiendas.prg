Define Class Tienda As Odata Of 'd:\capass\database\data.prg'
	Function Muestratiendas(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	lC = "PROMUESTRAALMACENES"
	lp = ""
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Muestratiendasx(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	lC = "PROMUESTRAALMACENES"
	If This.EJECUTARP(lC, "", Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function almacenesmovizatrujillo(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu  WHERE idalma IN(1,2) ORDER BY nomb 
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine


