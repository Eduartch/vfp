Define Class Transportista As Odata Of 'd:\capass\database\data.prg'
	Placa = ""
	nombre = ""
	Direccion = ""
	Ruc = ""
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
	dni = ""
	Function listarTransportistax(np1, np2, ccur)
	Local lC, lp
	m.lC		 = 'ProMuestraTransportista'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	Text To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, m.ccur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
**********************************
	Function VAlidar()
	Do Case
	Case Len(Alltrim(This.nombre)) = 0
		This.Cmensaje = "Ingrese Nombre de Transportista"
		Return 0
	Case !ValidaRuc(This.Ruc)
		This.Cmensaje = "Ruc NO Válido"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
************
	Function  crear()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	m.lC		 = 'FUNCREATRANSPORTISTA'
	If This.activofijo = 'S' Then
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>',<<this.npropio>>)
		Endtext
	Else
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<goapp.nidusua>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
		Endtext
	Endif
	nidt = This.EJECUTARf(lC, lp, 'trax')
	If nidt < 1 Then
		Return 0
	Endif
	Return nidt
	Endfunc
	Function Actualizar()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	m.lC		 = 'PROACTUALIZATRANSPORTISTA'
	If This.activofijo = 'S' Then
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>',<<this.npropio>>)
		Endtext
	Else
		Text To lp Noshow Textmerge
    ('<<this.placa>>','<<this.nombre>>','<<this.direccion>>','<<this.ruc>>','<<this.chofer>>','<<this.brevete>>','<<this.marca>>','<<this.registromtc>>',<<this.idtr>>,'<<this.placa1>>','<<this.tipot>>','<<this.constancia>>')
		Endtext
	Endif
	If This.EJECUTARP(lC, lp) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ProcesaTransportista(Cruc, crazo, cdire, cbreve, ccons, cmarca, cplaca, idtr, optt, cchofer, nidus, cplaca1)
	If optt = 0 Then
		If SQLExec(goApp.bdConn, "SELECT FUNCREATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?nidus,?cplaca1) as nid", "yy") < 1 Then
			Errorbd(ERRORPROC + 'Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1)") < 1 Then
			Errorbd(ERRORPROC + 'Actualizando Transportista')
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
			Errorbd(ERRORPROC + ' Ingresando Transportista')
			Return 0
		Else
			Return yy.nid
		Endif
	Else
		If SQLExec(goApp.bdConn, "CALL PROACTUALIZATRANSPORTISTA1(?cplaca,?crazo,?cdire,?cruc,?cchofer,?cbreve,?cmarca,?ccons,?idtr,?cplaca1,?cfono,?ccontacto)") < 1 Then
			Errorbd(ERRORPROC + ' Actualizando Transportista')
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function quitar(Idtran, opt)
	If opt = 0 Then
		Text To lC Noshow Textmerge
	        UPDATE fe_tra SET tran_acti='I'  WHERE idtra=<<idtran>>
		Endtext
	Else
		Text To lC Noshow Textmerge
	        UPDATE fe_tra SET tran_acti='A'  WHERE idtra=<<idtran>>
		Endtext
	Endif
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarplaca()
	cplaca = This.Placa
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
        select placa FROM fe_tra WHERE placa='<<cplaca>>' limit 1
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Select (Ccursor)
	If Reccount() > 0
		This.Cmensaje = "NÚMERO  de Placa Ya Registrada"
		Return 0
	Endif
	Return 1
	ENDFUNC
    Function buscaruc(cmodo, Cruc, nidtra)
	If Len(Alltrim(Cruc)) <> 11 Or  !ValidaRuc(Cruc) Then
		This.Cmensaje = 'RUC NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow
	\select ructr as nruc FROM fe_tra WHERE ructr='<<cruc>>'
	If cmodo <> "N"
	 \ And idtra<><<nidtra>>
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, "ya") < 1
		Return 0
	Endif
	If ya.nruc = Cruc
		This.Cmensaje = "Nº de Ruc Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine












