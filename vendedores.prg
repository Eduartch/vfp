Define Class vendedores As Odata Of 'd:\capass\database\data.prg'
	Function MuestraVendedores(np1, ccursor)
	Local lc, lp
	m.lc		 ='PROMUESTRAVENDEDORES'
	goapp.npara1 =m.np1
	Text To m.lp NOSHOW TEXTMERGE 
     (?goapp.npara1)
	ENDTEXT
	If this.EJECUTARP(m.lc, m.lp, m.ccursor) <1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine
