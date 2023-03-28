Define Class fletes As Odata Of "d:\capass\database\data.prg"
	Function mostrarfletes(np1, ccursor)
	Local lc, lp
	m.lc		 ='PROMUESTRAFLETES'
	goapp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine