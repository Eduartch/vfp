Define Class productosmegalux As Producto Of 'd:\capass\modelos\productos'
	Function ActualizaMargenesVtasyfletes(np1, np2, np3, np4, np5)
	Local lc, lp
*:Global ccur
	lc			 = "ProActualizaMargenesVta"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	Endtext
	If this.EJECUTARP(lc, lp, "") < 0 Then
       RETURN 
	ENDIF
	RETURN 1
	Endfunc
Enddefine



