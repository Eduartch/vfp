Define Class tramos As Odata Of 'd:\capass\database\data'
	nidart = 0
	Function listartramos(nidart, Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT sum(if(tram_tipo='C',tram_cant,-tram_cant)) as cantidad,tram_idin
      FROM fe_tramos f
      where tram_acti='A' AND tram_idar=<<nidart>> group by tram_idin having cantidad>0 ORDER BY cantidad;
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificartramos(nidart, Ccursor)
	TEXT To lC Noshow Textmerge
      SELECT sum(if(tram_tipo='C',tram_cant,-tram_cant)) as cantidad
      FROM fe_tramos f
      where tram_acti='A' AND tram_idar=<<nidart>> group by tram_idin,tram_idtr having cantidad>0;
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Cantidad > 0 Then
		Return 2
	Else
		Return 1
	Endif
	Endfunc
	Function ajustetramos()
	TEXT To lC Noshow Textmerge
    SELECT MAX(idkar) as idkar FROM fe_kar  WHERE tipo='C' AND acti='A' AND idart=<<this.nidart>>
	ENDTEXT
	If This.EjecutaConsulta(lC, 'lkk') < 1 Then
		Return 0
	Endif
	If This.listartramos(This.nidart, 'ltramos') < 1 Then
		Return 0
	Endif
	Sw = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Select ltramos
	If REgdvto("ltramos") > 0 Then
		Select ltramos
		Scan All
			If This.RegistraTramosSalidas(ltramos.Cantidad, 'V', 0, This.nidart, 0, ltramos.tram_idin) < 1 Then
				Sw = 0
				Exit
			Endif
		Endscan
	Endif
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select * From tramos  Into Cursor itramos
	If REgdvto("itramos") > 0 Then
		Select itramos
		Go Top
		Scan All
			If This.registraTramos(itramos.Cantidad, 'C', 0, This.nidart, itramos.medida) < 1 Then
				Sw = 0
				Exit
			Endif
		Endscan
	Endif
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Sw = 1 Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		Return 1
	Endif
	Endfunc
*********************************************
	Function registraTramos(np1, np2, np3, np4, np5)
	lC = 'ProRegistratramos'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
***********************************************
	Function RegistraTramosSalidas(np1, np2, np3, np4, np5, np6)
	lC = 'ProRegistratramosSalidas'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validartramosycantidades(ccursort, ccursorc)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Select (ccursorc)
	If Fsize("descri")=0 Then
		Select  Sum(Cantidad) As Cantidad, idart, b.cant, b.Desc From (ccursort) As a;
			inner Join (ccursorc) As b On b.coda = a.idart  Into Cursor ttramos Group By idart,a.nitem
	Else
		Select  Sum(Cantidad) As Cantidad, idart, b.cant, b.Descri As Desc From (ccursort) As a;
			inner Join (ccursorc) As b On b.coda = a.idart  Into Cursor ttramos Group By idart,a.nitem
	Endif
	Sw = 1
	Select ttramos
	Scan All
		If cant <> Cantidad Then
			Sw = 0
			This.Cmensaje = ' El Item ' + Alltrim(ttramos.Desc) + ' No Coniciden la cantidad de Tramos'
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return  0
	Endif
	Return 1
	Endfunc
Enddefine
