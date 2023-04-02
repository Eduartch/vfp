Define Class marcas As Odata Of "d:\capass\database\data.prg"
	Function mostrarmarcas(np1,ccursor)
	Local lc, lp
	IF this.idsesion>0 then
	   SET DATASESSION TO this.idsesion
	ENDIF    
	m.lc		 = 'PROMUESTRAMARCAS'
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