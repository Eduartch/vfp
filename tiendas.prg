Define Class Tienda As Odata Of 'd:\capass\database\data.prg'
	Function Muestratiendas(Ccursor)
	If This.Muestratiendasx(Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function Muestratiendasx(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Alltrim(goApp.datostdas) <> 'S' Then
		lC = "PROMUESTRAALMACENES"
		If This.EJECUTARP(lC, "", Ccursor) < 1 Then
			Return 0
		Endif
		Select (Ccursor)
		nCount = Afields(cfieldsfesucu)
		Select * From (Ccursor) Into Cursor a_tdas
		cdata = nfcursortojson(.T.)
		rutajson = Addbs(Sys(5) + Sys(2003)) + 'a' + Alltrim(Str(goApp.Xopcion)) + '.json'
		Strtofile (cdata, rutajson)
		goApp.datostdas = 'S'
	Else
		If Type("cfieldsfesucu") <> 'U' Then
*!*		       wait WINDOW cfieldsfesucu[1,1]
		Endif
		Create Cursor b_tdas From Array cfieldsfesucu
		responseType1 = Addbs(Sys(5) + Sys(2003)) + 'a' + Alltrim(Str(goApp.Xopcion)) + '.json'
		oResponse = nfJsonRead( m.responseType1 )
		For Each oRow In  oResponse.Array
			Insert Into b_tdas From Name oRow
		Endfor
		Select * From b_tdas Into Cursor (Ccursor)
	Endif
	Return 1
	Endfunc
	Function almacenesmovizatrujillo(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu  WHERE idalma IN(1,2) ORDER BY nomb
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function almaceneslyg(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   SELECT nomb,idalma,dire,ciud,sucuidserie FROM fe_sucu  WHERE idalma IN(1,2,3,4,5,6,7,8) ORDER BY idalma
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine



