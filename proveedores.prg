Define Class proveedor As Odata Of 'd:\capass\database\data'
	Codigo	   = 0
	nruc	   = ""
	nombre	   = ""
	Direccion  = ""
	ciudad	   = ""
	fono	   = ""
	fax		   = ""
	ndni	   = ""
	Tipo	   = ""
	correo	   = ""
	Vendedor   = 0
	Usuario	   = 0
	pc		   = ""
	Celular	   = ""
	Refe	   = ""
	linea	   = 0
	Rpm		   = ""
	zona	   = 0
	idsegmento = 0
	Cmensaje   = ""
	Procedure AsignaValores
	Lparameters Codigo, Cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz
	This.Codigo	   = m.Codigo
	This.nruc	   = m.Cnruc
	This.nombre	   = m.crazo
	This.Direccion = m.cdire
	This.ciudad	   = m.cciud
	This.fono	   = m.cfono
	This.fax	   = m.cfax
	This.ndni	   = m.cdni
	This.Tipo	   = m.ctipo
	This.correo	   = m.cemail
	This.Vendedor  = m.nidven
	This.Usuario   = m.cusua
	This.pc		   = m.cidpc
	This.Celular   = m.ccelu
	This.Refe	   = m.crefe
	This.linea	   = m.linea
	This.Rpm	   = m.crpm
	This.zona	   = m.nidz
	Endproc
	Function Creaproveedor
	Local lC, lp
*:Global Cmensaje, cur
	m.lC		  = 'funcreaproveedor'
	cur			  = "xt"
	goApp.npara1  = This.nruc
	goApp.npara2  = This.nombre
	goApp.npara3  = This.Direccion
	goApp.npara4  = This.ciudad
	goApp.npara5  = This.fono
	goApp.npara6  = This.fax
	goApp.npara7  = This.ndni
	goApp.npara8  = This.Tipo
	goApp.npara9  = This.correo
	goApp.npara10 = This.Vendedor
	goApp.npara11 = This.Usuario
	goApp.npara12 = This.pc
	goApp.npara13 = This.Celular
	goApp.npara14 = This.Refe
	goApp.npara15 = This.linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	If This.EJECUTARf(m.lC, m.lp, cur) = 0 Then
		Return 0
	Else
		Return Xt.Id
	Endif
	Endfunc
	Procedure Actualizaproveedor
	Local lC, lp
*:Global cur
	m.lC		  = 'proactualizaproveedor'
	cur			  = ""
	goApp.npara1  = This.Codigo
	goApp.npara2  = This.nruc
	goApp.npara3  = This.nombre
	goApp.npara4  = This.Direccion
	goApp.npara5  = This.ciudad
	goApp.npara6  = This.fono
	goApp.npara7  = This.fax
	goApp.npara8  = This.ndni
	goApp.npara9  = This.Tipo
	goApp.npara10 = This.correo
	goApp.npara11 = This.Vendedor
	goApp.npara12 = This.Usuario
	goApp.npara13 = This.Celular
	goApp.npara14 = This.Refe
	goApp.npara15 = This.linea
	goApp.npara16 = This.Rpm
	goApp.npara17 = This.zona
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) = 0 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Listarproveedores
	Lparameters	np1, np2, np3, nombrecursor
	Local lparametros
*:Global cproc
	cproc		 = ""
	cproc		 = 'promuestraproveedor'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	Text To m.lparametros Noshow
          (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP10(cproc, m.lparametros, m.nombrecursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endproc
	Function buscaruc(cmodo, Cruc, nidclie)
	If Len(Alltrim(Cruc)) <> 11 Or  !ValidaRuc(Cruc) Then
		This.Cmensaje = 'RUC NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow
	\Select nruc From fe_clie Where nruc='<<cruc>>' And clie_acti<>'I'
	If cmodo <> "N"
	 \And idclie<><<nidclie>>
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
	Function buscanombre(cmodo, Cruc, nidclie)
	Ccursor = 'c_' + Sys(2015)
	If Len(Alltrim(Cruc)) <= 3 Then
		This.Cmensaje = 'Nombre de Cliente NO Válido'
		Return 0
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC  Noshow
	\Select Razo From fe_clie Where Trim(Razo)='<<cruc>>' And clie_acti<>'I'
	If cmodo <> "N"
	 \And idclie<><<nidclie>>
	Endif
	\ limit 1
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Select (Ccursor)
	If Len(Alltrim(Razo)) > 0
		This.Cmensaje = "Nº de Ruc Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function Creaproveedor1
	Local lC, lp
*:Global Cmensaje, cur
	m.lC		  = 'funcreaproveedor'
	cur			  = "xt"
	goApp.npara1  = This.nruc
	goApp.npara2  = This.nombre
	goApp.npara3  = This.Direccion
	goApp.npara4  = This.ciudad
	goApp.npara5  = This.fono
	goApp.npara6  = This.fax
	goApp.npara7  = This.Refe
	goApp.npara8  = This.correo
	goApp.npara9 = This.Celular
	goApp.npara10 = This.Rpm
	goApp.npara11 = This.Usuario
	goApp.npara12 = Id()
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	If This.EJECUTARf(m.lC, m.lp, cur) = 0 Then
		Return 0
	Endif
	Return Xt.Id
	Endfunc
	Function EditaProveedor1()
	lC = 'PROACTUALIZAPROVEEDOR'
	Text To lp Noshow Textmerge
     (<<this.Codigo>>,'<<this.nruc>>','<<this.nombre>>','<<This.Direccion>>','<<This.ciudad>>','<<This.fono>>','<<This.fax>>','<<This.correo>>',<<This.Usuario>>,
     '<<This.Celular>>','<<This.Refe>>','<<This.Rpm>>')
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine




