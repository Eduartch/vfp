Define Class Correlativo As Odata Of 'd:\capass\database\data.prg'
	ndoc = ""
	nsgte = 0
	Idserie = 0
	nserie = 0
	cTdoc = ""
	Items = 0
	numero = 0
	conletras = ""
	letras = ""
	Function Listar(Ccursor)
	TEXT To lC Noshow Textmerge
     select serie,t.nomb,serie,nume,ifnull(a.nomb,'') as nomb,items,s.tdoc,seri_idal,idserie
     FROM fe_serie s
     INNER JOIN fe_tdoc t ON t.tdoc=s.tdoc
     left join fe_sucu a on a.sucuidserie=s.serie
     ORDER BY serie
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listarx(Ccursor)
	TEXT To lC Noshow Textmerge
     select serie,t.nomb,serie,nume,ifnull(a.nomb,'') as nomb,items,letra,s.tdoc,seri_idal,idserie
     FROM fe_serie s
     INNER JOIN fe_tdoc t ON t.tdoc=s.tdoc
     left join fe_sucu a on a.sucuidserie=s.serie
     ORDER BY serie
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarSerie(Cserie, nidtda, cTdoc)
	Local lC, vdvto
	vdvto = 1
	For x = 1 To Len(Cserie)
		cvalor = Substr(Cserie, x, 1)
		If Asc(cvalor) <= 47 Or (Asc(cvalor) >= 58 And Asc(cvalor) <= 64) Or (Asc(cvalor) >= 91 And Asc(cvalor) <= 96) Or  Asc(cvalor) >= 122  Then
			vdvto = 0
			Exit
		Endif
	Next
	If vdvto = 0 Then
		This.Cmensaje = 'Formato de Serie no V�lido'
		Return 0
	Endif
	Ccursor = Sys(2015)
	This.nserie = Cserie
	lista = This.ObtenerSerie(Cserie)
	If This.conletras = 'S' Then
		TEXT To m.lC Noshow Textmerge
		Select  serie From fe_serie Where serie=<<lista.nserie>> And codt=<<m.nidtda>> And tdoc ='<<ctdoc>>' AND TRIM(letra)='<<lista.cletras>>'  limit 1
		ENDTEXT
	Else
		TEXT To m.lC Noshow Textmerge
		Select  serie From fe_serie Where serie=<<lista.nserie>>And codt=<<m.nidtda>> And tdoc ='<<ctdoc>>' limit 1
		ENDTEXT
	Endif
	If This.EjecutaConsulta(m.lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If serie > 0 Then
		Return 1
	Else
		This.Cmensaje = 'La Serie No Pertenece a esta Tienda'
		Return 0
	Endif
	Endfunc
	Function generacorrelativo()
	If Len(Alltrim(This.ndoc)) <= 8 Then
		nnumero = Val(This.ndoc)
	Else
		nnumero = Val(Substr(This.ndoc, 5))
	Endif
	If nnumero >= This.nsgte Then
		lC = "ProGeneraCorrelativo"
		goApp.npara1 = This.nsgte + 1
		goApp.npara2 = This.Idserie
		cur = ""
		TEXT To lp Noshow
        (?goapp.npara1,?goapp.npara2)
		ENDTEXT
		If This.EJECUTARP(lC, lp, cur) < 1 Then
			Return 0
		Endif
		Return 1
	Else
		Return 1
	Endif
	Endfunc
	Function sgte()
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
*!*		If Vartype(This.nserie) <> 'N' Then
*!*			If Val(This.nserie) = 0 Then
*!*				Cserie = ''
*!*				For i = 1 To Len(Alltrim(This.nserie))
*!*					If Isdigit(Substr(This.nserie, i, 1)) Then
*!*						Cserie = Cserie + Substr(This.nserie, i, 1)
*!*					Endif
*!*				Next
*!*				nroserie = Val(Cserie)
*!*			Else
*!*				nroserie = Val(This.nserie)
*!*			Endif
*!*		Else
*!*			nroserie = This.nserie
*!*		Endif
	lista = This.ObtenerSerie()
	Ccursor = 'c_' + Sys(2015)
	If This.conletras = 'S' Then
		TEXT To lC Noshow Textmerge
	     SELECT nume,items,idserie FROM fe_serie WHERE serie=<<lista.nserie>> AND tdoc='<<this.ctdoc>>' AND TRIM(letra)='<<lista.cletras>>' limit  1;
		ENDTEXT
	Else
		TEXT To lC Noshow Textmerge
	     SELECT nume,items,idserie FROM fe_serie WHERE serie=<<lista.nserie>> AND tdoc='<<this.ctdoc>>' limit  1;
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		This.ndoc = ""
		Return 0
	Endif
	Select (Ccursor)
	If nume < 1 Then
		This.ndoc = ""
		This.Cmensaje = 'No hay Serie Registrada'
		Return 0
	Endif
	This.ndoc = Alltrim(Str(nume))
	This.Idserie = Idserie
	This.nsgte = nume
	This.Items = Items
	This.numero = nume
	Return 1
	Endfunc
	Function validarguia(cndoc)
	oRegExp = Create("VBScript.RegExp")
	oRegExp.IgnoreCase = .F.
	oRegExp.Global = .F.
	oRegExp.Pattern = "^[A-Z]{1,1}[0-9]{3,3}\-[0-9]{1,8}$"
	oMatchs = oRegExp.Execute(cndoc)
	If oMatchs.Count < 1 Then
		This.Cmensaje = "El Formato de Guia No es el correcto. Debe de ser T001-1 por ejemplo"
		Return 0
	Endif
	npos = At("-", cndoc)
	If Val(Substr(cndoc, 6)) < 1 Then
		This.Cmensaje = "El Correlativo debe ser N�merico"
		Return 0
	Endif
	Return 1
	Endfunc
	Function BuscarSeries(ns, cTdoc, Ccursor)
	If This.conletras = 'S' Then
		TEXT To lC Noshow Textmerge
          SELECT nume,items,idserie FROM fe_serie WHERE serie=<<ns>> AND tdoc='<<ctdoc>>' AND TRIM(letra)='<<this.letras>>'
		ENDTEXT
	Else
		TEXT To lC Noshow Textmerge
         SELECT nume,items,idserie FROM fe_serie WHERE serie=<<ns>> AND tdoc='<<ctdoc>>'
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Do Case
	Case SERIES.Idserie > 0
		If cTdoc = '01' Or cTdoc = '03' Or cTdoc = '20' Or cTdoc = '09' Or cTdoc = "07" Or cTdoc = "08"  Or cTdoc = "12" Or cTdoc = "SC"  Then
			Try
				Do Case
				Case cTdoc = "01" Or cTdoc = '12'
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'factura' + Alltrim(Str(ns)) + '.frx'
				Case cTdoc = "03"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'boleta' + Alltrim(Str(ns)) + '.frx'
				Case cTdoc = "20" Or cTdoc = "SC"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'notasp.frx'
				Case cTdoc = "09"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'guia' + Alltrim(Str(ns)) + '.frx'
				Case cTdoc = "07" Or cTdoc = "08"
					cArchivo = Addbs(Sys(5) + Sys(2003) + '\comp') + 'notasc1.frx'
				Endcase
				goApp.reporte = cArchivo
				If !File(cArchivo)
				Endif
			Catch To oerror
				This.Cmensaje = "No es Posible Imprimir este Comprobante"
			Finally
			Endtry
		Else
			Return 1
		Endif
		Return 1
	Case SERIES.Idserie <= 0
		This.Cmensaje = "Serie NO Registrada"
		Return 0
	Endcase
	Return 1
	Endfunc
	Function ObtenerSerie(Cserie)
	nser = 0
	Clet = ""
	For x = 1 To Len(Alltrim(Cserie))
		cvalor = Substr(Cserie, x, 1)
		If Isdigit(cvalor) Then
			nser = Val(Substr(Cserie, x))
			Exit
		Endif
		If Isalpha(cvalor) Then
			Clet = Clet + Substr(Cserie, x, 1)
		Endif
	Next
	If nser = 0 Then
		This.Cmensaje = 'Formato de Serie no V�lido'
		Obj = Createobject("empty")
		AddProperty(Obj, 'estado', 0)
		AddProperty(Obj, 'nserie', 0)
		AddProperty(Obj, "cletras", "")
		Return Obj
	Endif
	Obj = Createobject("empty")
	AddProperty(Obj, "estado", '1')
	AddProperty(Obj, "nserie", nser)
	AddProperty(Obj, "cletras", Alltrim(Clet))
	Return Obj
	Endfunc
	Function Dserie()
	If Vartype(This.nserie) <> 'N' Then
		If Val(This.nserie) = 0 Then
			Cserie = ''
			For i = 1 To Len(Alltrim(This.nserie))
				If Isdigit(Substr(This.nserie, i, 1)) Then
					Cserie = Cserie + Substr(This.nserie, i, 1)
				Endif
			Next
			nroserie = Val(Cserie)
		Else
			nroserie = Val(This.nserie)
		Endif
	Else
		nroserie = This.nserie
	Endif
	Return nroserie
	Endfunc
	Function correlativosirecompras()
	TEXT To lC Textmerge Noshow
	 UPDATE fe_gene SET gene_corc=gene_corc+1 WHERE idgene=1
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Ccursor = 'c'+ Sys(2015)
	TEXT To lg Textmerge Noshow
	  select gene_corc FROM fe_gene WHERE idgene=1;
	ENDTEXT
	If This.EjecutaConsulta(lg, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return gene_corc
	Endfunc
	Function generacorrelativo1()
	lC = "ProGeneraCorrelativo"
	goApp.npara1 = This.nsgte + 1
	goApp.npara2 = This.Idserie
	TEXT To lp Noshow
        (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lC, lp,"") < 1 Then
		Return 0
	Endif
	this.nsgte=This.nsgte + 1
	Return 1
	Endfunc
Enddefine













































