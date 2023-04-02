Define Class lineas As Odata Of "d:\capass\database\data.prg"
	Function mostrarlineas(np1, np2, ccursor)
	Local lc, lp
	IF this.idsesion>0 then
	   SET DATASESSION TO this.idsesion
	ENDIF    
	m.lc		 = 'PROMUESTRALINEAS'
	goapp.npara1 = m.np1
	goapp.npara2 = m.np2
	Text To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine