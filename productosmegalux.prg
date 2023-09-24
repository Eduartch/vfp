Define Class productosmegalux As Producto Of 'd:\capass\modelos\productos'
	Function ActualizaMargenesVtasyfletes(np1, np2, np3, np4, np5, np6)
	Local lc, lp
*:Global ccur
	lc			 = "ProActualizaMargenesVta"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	Endtext
	If This.EJECUTARP(lc, lp, "") < 0 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosDescCod(np1, np2, np3, np4, ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Local lc, lp
	m.lc		 = 'PROMUESTRAPRODUCTOS1'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	goApp.npara4 = m.np4
	goApp.npara5 = This.tipovista
	Text To m.lp Noshow
   (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	Endtext
	If This.EJECUTARP10(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine





