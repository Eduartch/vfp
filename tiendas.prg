Define Class tienda As Odata Of 'd:\capass\database\data.prg'
	Function Muestratiendas(ccursor)
	If This.idsesion>1 Then
		Set DataSession To This.idsesion
	Endif
	lc="PROMUESTRAALMACENES"
	lp=""
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Muestratiendasx(ccursor)
	If This.idsesion>1 Then
		Set DataSession To This.idsesion
	Endif
	lc="PROMUESTRAALMACENES"
	If This.EJECUTARP(lc,"",ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
