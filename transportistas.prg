Define Class Transportista As Odata Of 'd:\capass\database\data.prg'
	Placa = ""
	nombre = ""
	direccion = ""
	ruc = ""
	chofer = ""
	brevete = ""
	marca = ""
	registromtc = ""
	idtr = 0
	placa1 = ""
	Constancia = ""
	TipoT = ""
	npropio = 0
	activofijo = ""
	Function listarTransportistax(np1, np2, ccur)
	Local lc, lp
	m.lc		 = 'ProMuestraTransportista'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	Text To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(m.lc, m.lp, m.ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
**********************************
	Function Validar()
	Do Case
	Case Len(Alltrim(This.nombre)) = 0
		This.Cmensaje = "Ingrese Nombre de Transportista"
		Return 0
	Case !ValidaRuc(This.ruc)
		This.Cmensaje = "Ruc NO Válido"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
************
	Function  crear()
	If This.Validar() < 1 Then
		Return 0
	Endif
	m.lc		 = 'FUNCREATRANSPORTISTA'
	If This.activofijo = 'S' Then
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>',<<this.npropio>>)
		Endtext
	Else
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
		Endtext
	Endif
	nidt = This.EJECUTARf(lc, lp, 'trax')
	If nidt < 1 Then
		Return 0
	Endif
	Return nidt
	Endfunc
	Function actualizar()
	If This.Validar() < 1 Then
		Return 0
	Endif
	m.lc		 = 'PROACTUALIZATRANSPORTISTA'
	If This.activofijo = 'S' Then
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>',<<this.npropio>>)
		Endtext
	Else
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
		Endtext
	Endif
	If This.EJECUTARP(lc, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ProcesaTransportista(Cruc, crazo, cdire, cbreve, ccons, cmarca, cplaca, idtr, optt, cchofer, nidus, cplaca1)
	If optt = 0 Then
		If SQLExec(goApp.bdConn, "SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1) as nid", "yy") < 1 Then
			errorbd(ERRORPROC + 'Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1)") < 1 Then
			errorbd(ERRORPROC + 'Actualizando Transportista')
			Return 0
		Else
			Return idtr
		Endif
	Endif
	Endfunc
************************************
	Function ProcesaTransportista1(Cruc, crazo, cdire, cbreve, ccons, cmarca, cplaca, idtr, optt, cchofer, nidus, cplaca1, cfono, cContacto)
	If optt = 0 Then
		If SQLExec(goApp.bdConn, "SELECT FUNCREATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1,?cfono,?ccontacto) as nid", "yy") < 1 Then
			errorbd(ERRORPROC + ' Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1,?cfono,?ccontacto)") < 1 Then
			errorbd(ERRORPROC + ' Actualizando Transportista')
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function quitar(idtran, opt)
	If opt = 0 Then
		Text To lc Noshow Textmerge
	        UPDATE fe_tra SET tran_acti='I'  WHERE idtra=<<idtran>>
		Endtext
	Else
		Text To lc Noshow Textmerge
	        UPDATE fe_tra SET tran_acti='A'  WHERE idtra=<<idtran>>
		Endtext
	Endif
	If This.Ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






