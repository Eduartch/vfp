#Define MSGTITULO 'SISVEN'
Define Class correlativo As Odata Of 'd:\capass\database\data.prg'
	ndoc=""
	nsgte=0
	idserie=0
	Function validarserie(cserie, nidtda, ctdoc)
	Local lc
*:Global ccursor
	ccursor=Sys(2015)
*If Isdigit(Substr(cserie,2,1)) Then
	nidserie=Val(Substr(cserie,2))
*	Endif
*	Wait Window nidserie
	TEXT To m.lc Noshow Textmerge
		Select  serie From fe_serie Where serie=<<m.nidserie>>	And codt=<<m.nidtda>> And tdoc ='<<ctdoc>>' limit 1
	ENDTEXT
	If This.EjecutaConsulta(m.lc, ccursor) < 1 Then
		Return 0
	Endif
	Select (ccursor)
*Wait Window serie
	If serie > 0 Then
		Return 1
	Else
		This.Cmensaje='La Serie No Pertenece a esta Tienda'
		Return 0
	Endif
	Endfunc
	Function generacorrelativo()
	If Len(Alltrim(This.ndoc))<=8 Then
		nnumero=Val(This.ndoc)
	Else
		nnumero=Val(Substr(This.ndoc,5))
	Endif
	If nnumero>=This.nsgte Then
		lc="ProGeneraCorrelativo"
		goapp.npara1=This.nsgte+1
		goapp.npara2=This.idserie
		cur=""
		TEXT to lp noshow
        (?goapp.npara1,?goapp.npara2)
		ENDTEXT
		If This.EJECUTARP(lc,lp,cur)<1 Then
			Return 0
		Endif
		Return 1
	Else
		Return 1
	Endif
	Endfunc
Enddefine
