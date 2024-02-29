Define Class cliente As Odata Of 'd:\capass\database\data.prg'
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
	encontrado = ""
	Function Validar()
	Do Case
	Case Empty(This.nombre)
		This.Cmensaje = "Ingrese Nombre del Cliente"
		Return .F.
	Case This.encontrado = 'S'
		This.Cmensaje = "El RUC o El Nombre del Cliente Ya Estan Registrados"
		Return .F.
	Case !Empty(This.nruc) And !ValidaRuc(This.nruc)
		This.Cmensaje = "El RUC es Inv�lido"
		Return .F.
	Case Len(Alltrim(This.ndni)) > 1 And Len(Alltrim(This.ndni)) <> 8
		This.Cmensaje = "DNI es Inv�lido"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Procedure AsignaValores
	Lparameters Codigo, cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz
	This.Codigo	   = m.Codigo
	This.nruc	   = m.cnruc
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
	Function CreaCliente
	Local lC, lp
*:Global Cmensaje, cur
	m.lC		  = 'FUNCREACLIENTE'
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
	If !Pemstatus(goApp, 'clientesconsegmento', 5)
		goApp.AddProperty("clientesconsegmento", "")
	Endif
	If goApp.clientesconsegmento = 'S' Then
		goApp.npara18 = This.idsegmento
		Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
		Endtext
	Else
		Text To m.lp Noshow
	    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		Endtext
	Endif
	nidc = This.EJECUTARf(m.lC, m.lp, cur)
	If nidc < 1 Then
		Return 0
	Else
		Return nidc
	Endif
	Endfunc
	Procedure ActualizaCliente
	Local lC, lp
*:Global cur
	m.lC		  = 'PROACTUALIZACLIENTE'
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
	If !Pemstatus(goApp, 'clientesconsegmento', 5)
		goApp.AddProperty("clientesconsegmento", "")
	Endif
	If goApp.clientesconsegmento = 'S' Then
		goApp.npara18 = This.idsegmento
		Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
		Endtext
	Else
		Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		Endtext
	Endif
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Listarclientes
	Lparameters	np1, np2, np3, nombrecursor
	Local lparametros
*:Global cproc
	cproc		 = ""
	cproc		 = 'PROMUESTRACLIENTES'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	Text To m.lparametros Noshow
          (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext

	If This.EJECUTARP10(cproc, m.lparametros, m.nombrecursor) < 1 Then
		Return 0
	Endif
	Return 1
	Function ActualizaClienteRetenedor(np1, np2)
	Local lC
	Text To m.lC Noshow Textmerge
         UPDATE fe_clie SET clie_rete='<<np2>>' where idclie=<<np1>>
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscardni(Cruc, nid, modo)
	If modo = "N"
		Text To lC Noshow Textmerge
        SELECT idclie FROM fe_clie WHERE tRIM(ndni)='<<cruc>>' AND clie_acti<>'I'
		Endtext
	Else
		Text To lC Noshow Textmerge
        SELECT idclie FROM fe_clie WHERE TRIM(ndni)='<<cruc>>' AND idclie<><<nid>> AND clie_acti<>'I'
		Endtext
	Endif
	If This.EjecutaConsulta(lC, "ya") < 1
		Return 0
	Endif
	If ya.idclie > 0 Then
		This.Cmensaje = 'DNI Ya est� Registrado '
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaruc(cmodo, Cruc, nidclie)
	If Len(Alltrim(Cruc)) <> 11 Or  !ValidaRuc(Cruc) Then
		This.Cmensaje = 'RUC NO V�lido'
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
		This.Cmensaje = "N� de Ruc Ya Registrado"
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarclientesy(np1, np2, np3, Ccursor)
	lC = 'PROMUESTRACLIENTES1'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
***************************************
Define Class clientex As cliente
	dias			  = 0
	contacto		  = ""
	direccion1		  = ""
	Codigov			  = 0
	Usuario			  = 0
	AutorizadoCredito = 0
	Procedure AsignaValores
	Lparameters Codigo, cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz, ndias, cContacto, cdireccion1, nidsegmento
	This.Codigo		= m.Codigo
	This.nruc		= m.cnruc
	This.nombre		= m.crazo
	This.Direccion	= m.cdire
	This.ciudad		= m.cciud
	This.fono		= m.cfono
	This.fax		= m.cfax
	This.ndni		= m.cdni
	This.Tipo		= m.ctipo
	This.correo		= m.cemail
	This.Vendedor	= m.nidven
	This.Usuario	= m.cusua
	This.pc			= m.cidpc
	This.Celular	= m.ccelu
	This.Refe		= m.crefe
	This.linea		= m.linea
	This.Rpm		= m.crpm
	This.zona		= m.nidz
	This.dias		= m.ndias
	This.contacto	= m.cContacto
	This.direccion1	= m.cdireccion1
	This.idsegmento	= m.nidsegmento
	Endproc
	Function CreaCliente
	Local lC, lp
*:Global cur
	m.lC		  = 'FUNCREACLIENTE'
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
	goApp.npara18 = This.dias
	goApp.npara19 = This.contacto
	goApp.npara20 = This.direccion1
	goApp.npara21 = This.idsegmento
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	nidcliente = This.EJECUTARf(m.lC, m.lp, cur)
	If  nidcliente < 1 Then
		Return 0
	Else
		Return nidcliente
	Endif
	Endfunc
	Procedure ActualizaCliente
	Local lC, lp
*:Global cur
	m.lC		  = 'PROACTUALIZACLIENTE'
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
	goApp.npara18 = This.dias
	goApp.npara19 = This.contacto
	goApp.npara20 = This.direccion1
	goApp.npara21 = This.idsegmento

	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,
	      ?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure CreaVinculoCliente
	Local lC, lp
*:Global cur
	m.lC		 = 'ProCreaVinculoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	goApp.npara2 = This.Codigov
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) = 0 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure EditaVinculoCliente
	Local lC, lp
*:Global cur
	m.lC		 = 'ProEditaVinculoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	Text To m.lp Noshow
	     (?goapp.npara1)
	Endtext
	If EJECUTARP(m.lC, m.lp, cur) = 0 Then
*	errorbd(ERRORPROC+ ' Actualizando Clientes con Otros Clientes')
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarVinculos
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigov
	Text To m.lC Noshow Textmerge Pretext 7
		Select  c.razo,	ifnull(Sum(v.saldo), 0) As saldo,c.idclie,clie_idvi	From fe_clie c
		            Left Join	(Select  Sum(Impo - acta) As saldo, rcre_idcl As idclie
					 From fe_cred x
					 inner Join fe_rcred Y  On Y.rcre_idrc=x.cred_idrc
					 inner Join fe_clie As c  On c.idclie=Y.rcre_idcl
					 Where x.Acti='A'  And Y.rcre_acti = 'A'  And clie_idvi =<<goapp.npara1>>  Group By idclie, x.ncontrol) As v On v.idclie = c.idclie
			         Where c.clie_idvi= <<goapp.npara1>> Group By c.idclie 	Order By razo
	Endtext
	If This.EjecutaConsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Autorizacreditocliente
	Local lC, lp
*:Global cur
	m.lC		 = 'ProAutorizaCreditoCliente'
	cur			 = ""
	goApp.npara1 = This.Codigo
	goApp.npara2 = This.Usuario
	goApp.npara3 = This.AutorizadoCredito
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) = 0 Then
		Return 0
	Else
		If This.AutorizadoCredito = 1 Then
			Mensaje("Autorizado")
		Endif
		Return  1
	Endif
	Endproc
	Procedure CreditosAutorizados
	Lparameters ccur
	Local lC
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge
		   Select  nomb, logc_fope From fe_acrecli F
			   inner Join fe_usua u   On u.idusua=F.logc_idus
			   Where logc_idcl =<<goapp.npara1>>   Order By logc_fope Desc;
	Endtext
	If This.EjecutaConsulta(m.lC, m.ccur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarProyectosxcliente
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge Pretext 7
		Select  proy_nomb,proy_idcl,proy_idpr From fe_proyectos Where proy_idcl= <<goapp.npara1>> 		And proy_acti = 'A'
	Endtext
	If This.EjecutaConsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Endif
	Return  1
	Endproc
	Procedure MostrarSucursalesxcliente
	Lparameters ccur
	Local lC
	m.lC		 = ''
	goApp.npara1 = This.Codigo
	Text To m.lC Noshow Textmerge Pretext 7
		 Select  succ_nomb, succ_dire, succ_ciud, succ_idcl, succ_id From fe_succliente	 Where succ_idcl= <<goapp.npara1>>	 And succ_acti = 'A'
	Endtext
	If This.EjecutaConsulta(m.lC, m.ccur) < 1  Then
		Return 0
	Endif
	Return  1
	Endproc

	Function CreaSucursalcliente(np1, np2, np3, np4)
	Local lC
	Text To m.lC Noshow Textmerge Pretext 7
	   INSERT INTO fe_succliente(succ_nomb,succ_dire,succ_ciud,succ_idcl)values('<<np1>>','<<np2>>','<<np3>>',<<np4>>)
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Mensaje("Creado Ok")
	Return 1
	Endfunc
	Function EditaSucursalcliente(np1, np2, np3, np4, np5, np6)
	Local lC
	If m.np6 = 0 Then
		Text To m.lC Noshow Textmerge Pretext 7
	   		UPDATE  fe_succliente  SET succ_acti='I' WHERE succ_id=<<np5>>
		Endtext
	Else
		Text To m.lC Noshow Textmerge Pretext 7
	   		UPDATE  fe_succliente  SET succ_nomb='<<np1>>',succ_dire='<<np2>>',succ_ciud='<<np3>>' WHERE succ_id=<<np5>>
		Endtext
	Endif
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Mensaje("Actualizado Ok")
	Return 1
	Endfunc
	Function ActualizaSegmentoCliente(np1, np2)
	Local lC
	Text To m.lC Noshow Textmerge
	      UPDATE fe_clie SET clie_idse=<<np2>> WHERE idclie=<<np1>>
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine
*****************************************



