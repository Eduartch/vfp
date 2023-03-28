Define Class transportista As Odata Of 'd:\capass\database\data.prg'
	placa=""
	nombre=""
	direccion=""
	ruc=""
	chofer=""
	brevete=""
	marca=""
	registromtc=""
	idtr=0
	placa1=""
	constancia=""
	tipot=""
	Function listarTransportistax(np1, np2, ccur)
	Local lc, lp
	m.lc		 ='ProMuestraTransportista'
	goapp.npara1 =m.np1
	goapp.npara2 =m.np2
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
**********************************
	Function validar()
	Do Case
	Case Len(Alltrim(This.nombre))=0
		This.cmensaje="Ingrese Nombre de Transportista"
		Return 0
	Case !validaruc(This.ruc)
		This.cmensaje="Ruc No Válido"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
************
	Function  crear()
	If This.validar()<1 Then
		Return 0
	Endif
	m.lc		 ='FUNCREATRANSPORTISTA'
	TEXT TO lp NOSHOW TEXTMERGE
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
	ENDTEXT
	nidt=This.ejecutarf(lc,lp,'trax')
	If nidt<1 Then
		Return 0
	Endif
	Return nidt
	Endfunc
	Function actualizar()
	If This.validar()<1 Then
		Return 0
	Endif
	m.lc		 ='PROACTUALIZATRANSPORTISTA'
	TEXT TO lp NOSHOW TEXTMERGE
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
	ENDTEXT
	If This.EJECUTARP(lc,lp)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ProcesaTransportista(cruc,crazo,cdire,cbreve,ccons,cmarca,cplaca,idtr,optt,cchofer,nidus,cplaca1)
	If optt=0 Then
		If SQLExec(goapp.bdconn,"SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1) as nid","yy")<1 Then
			errorbd(ERRORPROC+'Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goapp.bdconn,"CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1)")<1 Then
			errorbd(ERRORPROC+'Actualizando Transportista')
			Return 0
		Else
			Return idtr
		Endif
	Endif
	Endfunc
************************************
	Function ProcesaTransportista1(cruc,crazo,cdire,cbreve,ccons,cmarca,cplaca,idtr,optt,cchofer,nidus,cplaca1,cfono,ccontacto)
	If optt=0 Then
		If SQLExec(goapp.bdconn,"SELECT FUNCREATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1,?cfono,?ccontacto) as nid","yy")<1 Then
			errorbd(ERRORPROC+' Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goapp.bdconn,"CALL PROACTUALIZATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1,?cfono,?ccontacto)")<1 Then
			errorbd(ERRORPROC+' Actualizando Transportista')
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function quitar(idtran,opt)
	If opt=0 Then
		TEXT TO lc NOSHOW TEXTMERGE
	        UPDATE fe_tra SET tran_acti='I'  WHERE idtra=<<idtran>>
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
	        UPDATE fe_tra SET tran_acti='A'  WHERE idtra=<<idtran>>
		ENDTEXT
	Endif
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


