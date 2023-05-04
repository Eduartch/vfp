Define Class tienda As Odata Of 'd:\capass\database\data.prg'
	Function Muestratiendas(ccursor)
	lc="PROMUESTRAALMACENES"
	lp=""
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Muestratiendasx(ccursor)
	Set DataSession To This.idsesion
	lc="PROMUESTRAALMACENES"
	If This.EJECUTARP(lc,"",ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
