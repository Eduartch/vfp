Define Class vendedores As Odata Of 'd:\capass\database\data.prg'
	Function MuestraVendedores(np1, ccursor)
	Local lc, lp
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	m.lc		 ='PROMUESTRAVENDEDORES'
	goapp.npara1 =m.np1
	TEXT To m.lp NOSHOW TEXTMERGE
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) <1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
