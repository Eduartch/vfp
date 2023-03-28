Define Class grupos As Odata Of "d:\capass\database\data.prg"
	Function mostrargrupos(np1, ccursor)
	Local lc, lp
	m.lc='PROMUESTRAGRUPOS'
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