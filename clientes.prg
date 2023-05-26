Define Class cliente As Odata Of 'd:\capass\database\data.prg'
	Codigo	   = 0
	nruc	   = ""
	nombre	   = ""
	direccion  = ""
	ciudad	   = ""
	fono	   = ""
	fax		   = ""
	ndni	   = ""
	tipo	   = ""
	correo	   = ""
	Vendedor   = 0
	usuario	   = 0
	pc		   = ""
	Celular	   = ""
	Refe	   = ""
	linea	   = 0
	Rpm		   = ""
	zona	   = 0
	idsegmento = 0
	Cmensaje   = ""
	encontrado =""
	Function validar()
	Do Case
	Case Empty(This.nombre)
		This.Cmensaje="Ingrese Nombre del Cliente"
		Return .F.
	Case This.encontrado = 'S'
		This.Cmensaje="El RUC o El Nombre del Cliente Ya Estan Registrados"
		Return .F.
	Case !Empty(This.nruc) And !validaruc(This.nruc)
		This.Cmensaje="El RUC es Inválido"
		Return .F.
	Case Len(Alltrim(This.ndni)) > 1 And Len(Alltrim(This.ndni)) <> 8
		This.Cmensaje="DNI es Inválido"
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
	This.direccion = m.cdire
	This.ciudad	   = m.cciud
	This.fono	   = m.cfono
	This.fax	   = m.cfax
	This.ndni	   = m.cdni
	This.tipo	   = m.ctipo
	This.correo	   = m.cemail
	This.Vendedor  = m.nidven
	This.usuario   = m.cusua
	This.pc		   = m.cidpc
	This.Celular   = m.ccelu
	This.Refe	   = m.crefe
	This.linea	   = m.linea
	This.Rpm	   = m.crpm
	This.zona	   = m.nidz
	Endproc
	Function CreaCliente
	Local lc, lp
*:Global Cmensaje, cur
	m.lc		  = 'FUNCREACLIENTE'
	cur			  = "xt"
	goapp.npara1  = This.nruc
	goapp.npara2  = This.nombre
	goapp.npara3  = This.direccion
	goapp.npara4  = This.ciudad
	goapp.npara5  = This.fono
	goapp.npara6  = This.fax
	goapp.npara7  = This.ndni
	goapp.npara8  = This.tipo
	goapp.npara9  = This.correo
	goapp.npara10 = This.Vendedor
	goapp.npara11 = This.usuario
	goapp.npara12 = This.pc
	goapp.npara13 = This.Celular
	goapp.npara14 = This.Refe
	goapp.npara15 = This.linea
	goapp.npara16 = This.Rpm
	goapp.npara17 = This.zona
	If !Pemstatus(goapp, 'clientesconsegmento', 5)
		goapp.AddProperty("clientesconsegmento", "")
	Endif
	If goapp.clientesconsegmento='S' Then
		goapp.npara18=This.idsegmento
		TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
		ENDTEXT
	Else
		TEXT To m.lp Noshow
	    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		ENDTEXT
	Endif
	nidc=This.EJECUTARF(m.lc, m.lp, cur)
	If nidc < 1 Then
		Return 0
	Else
		Return nidc
	Endif
	Endfunc
	Procedure ActualizaCliente
	Local lc, lp
*:Global cur
	m.lc		  = 'PROACTUALIZACLIENTE'
	cur			  = ""
	goapp.npara1  = This.Codigo
	goapp.npara2  = This.nruc
	goapp.npara3  = This.nombre
	goapp.npara4  = This.direccion
	goapp.npara5  = This.ciudad
	goapp.npara6  = This.fono
	goapp.npara7  = This.fax
	goapp.npara8  = This.ndni
	goapp.npara9  = This.tipo
	goapp.npara10 = This.correo
	goapp.npara11 = This.Vendedor
	goapp.npara12 = This.usuario
	goapp.npara13 = This.Celular
	goapp.npara14 = This.Refe
	goapp.npara15 = This.linea
	goapp.npara16 = This.Rpm
	goapp.npara17 = This.zona
	If !Pemstatus(goapp, 'clientesconsegmento', 5)
		goapp.AddProperty("clientesconsegmento", "")
	Endif
	If goapp.clientesconsegmento='S' Then
		goapp.npara18=This.idsegmento
		TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
		ENDTEXT
	Else
		TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
		ENDTEXT
	Endif
	If This.EJECUTARP(m.lc, m.lp, cur)<1 Then
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
	goapp.npara1 = m.np1
	goapp.npara2 = m.np2
	goapp.npara3 = m.np3
	TEXT To m.lparametros Noshow
          (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT

	If This.EJECUTARP10(cproc, m.lparametros, m.nombrecursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Function ActualizaClienteRetenedor(np1, np2)
	Local lc
	TEXT To m.lc Noshow Textmerge
         UPDATE fe_clie SET clie_rete='<<np2>>' where idclie=<<np1>>
	ENDTEXT
	If This.ejecutarsql(m.lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscardni(cruc,nid,modo)
	If modo="N"
		TEXT TO lc NOSHOW TEXTMERGE
        SELECT idclie FROM fe_clie WHERE tRIM(ndni)='<<cruc>>' AND clie_acti<>'I'
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
        SELECT idclie FROM fe_clie WHERE TRIM(ndni)='<<cruc>>' AND idclie<><<nid>> AND clie_acti<>'I'
		ENDTEXT
	Endif
	If This.Ejecutaconsulta(lc,"ya")<1
		Return 0
	Endif
	If ya.idclie>0 Then
		This.Cmensaje='DNI Ya está Registrado '
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaruc(cmodo,cruc,nidclie)
	If Len(Alltrim(cruc))<>11 And !validaruc(cruc) Then
		This.Cmensaje='RUC NO Válido'
		Return 0
	Endif
	If cmodo="N"
		TEXT TO lc NOSHOW TEXTMERGE
          SELECT nruc FROM fe_clie WHERE nruc='<<cruc>>' AND clie_acti<>'I'
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
          SELECT nruc FROM fe_clie WHERE nruc='<<cruc>>' AND idclie<><<nidclie>> AND clie_acti<>'I'
		ENDTEXT
	Endif
	If This.Ejecutaconsulta(lc,"ya")<1
		Return 0
	Endif
	If ya.nruc=cruc
		This.Cmensaje="Nº de Ruc Ya Registrado"
		Return 0
	ENDIF
	RETURN 1
	Endfunc
Enddefine
***************************************
Define Class clientex As cliente
	dias			  = 0
	contacto		  = ""
	direccion1		  = ""
	Codigov			  = 0
	usuario			  = 0
	AutorizadoCredito = 0
	Procedure AsignaValores
	Lparameters Codigo, cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz, ndias, ccontacto, cdireccion1, nidsegmento
	This.Codigo		= m.Codigo
	This.nruc		= m.cnruc
	This.nombre		= m.crazo
	This.direccion	= m.cdire
	This.ciudad		= m.cciud
	This.fono		= m.cfono
	This.fax		= m.cfax
	This.ndni		= m.cdni
	This.tipo		= m.ctipo
	This.correo		= m.cemail
	This.Vendedor	= m.nidven
	This.usuario	= m.cusua
	This.pc			= m.cidpc
	This.Celular	= m.ccelu
	This.Refe		= m.crefe
	This.linea		= m.linea
	This.Rpm		= m.crpm
	This.zona		= m.nidz
	This.dias		= m.ndias
	This.contacto	= m.ccontacto
	This.direccion1	= m.cdireccion1
	This.idsegmento	= m.nidsegmento
	Endproc
	Function CreaCliente
	Local lc, lp
*:Global cur
	m.lc		  = 'FUNCREACLIENTE'
	cur			  = "xt"
	goapp.npara1  = This.nruc
	goapp.npara2  = This.nombre
	goapp.npara3  = This.direccion
	goapp.npara4  = This.ciudad
	goapp.npara5  = This.fono
	goapp.npara6  = This.fax
	goapp.npara7  = This.ndni
	goapp.npara8  = This.tipo
	goapp.npara9  = This.correo
	goapp.npara10 = This.Vendedor
	goapp.npara11 = This.usuario
	goapp.npara12 = This.pc
	goapp.npara13 = This.Celular
	goapp.npara14 = This.Refe
	goapp.npara15 = This.linea
	goapp.npara16 = This.Rpm
	goapp.npara17 = This.zona
	goapp.npara18 = This.dias
	goapp.npara19 = This.contacto
	goapp.npara20 = This.direccion1
	goapp.npara21 = This.idsegmento
	TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
	      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	ENDTEXT
	nidcliente=This.EJECUTARF(m.lc, m.lp, cur)
	If  nidcliente < 1 Then
		Return 0
	Else
		Return nidcliente
	Endif
	Endfunc
	Procedure ActualizaCliente
	Local lc, lp
*:Global cur
	m.lc		  = 'PROACTUALIZACLIENTE'
	cur			  = ""
	goapp.npara1  = This.Codigo
	goapp.npara2  = This.nruc
	goapp.npara3  = This.nombre
	goapp.npara4  = This.direccion
	goapp.npara5  = This.ciudad
	goapp.npara6  = This.fono
	goapp.npara7  = This.fax
	goapp.npara8  = This.ndni
	goapp.npara9  = This.tipo
	goapp.npara10 = This.correo
	goapp.npara11 = This.Vendedor
	goapp.npara12 = This.usuario
	goapp.npara13 = This.Celular
	goapp.npara14 = This.Refe
	goapp.npara15 = This.linea
	goapp.npara16 = This.Rpm
	goapp.npara17 = This.zona
	goapp.npara18 = This.dias
	goapp.npara19 = This.contacto
	goapp.npara20 = This.direccion1
	goapp.npara21 = This.idsegmento

	TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,
	      ?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure CreaVinculoCliente
	Local lc, lp
*:Global cur
	m.lc		 = 'ProCreaVinculoCliente'
	cur			 = ""
	goapp.npara1 = This.Codigo
	goapp.npara2 = This.Codigov
	TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) = 0 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure EditaVinculoCliente
	Local lc, lp
*:Global cur
	m.lc		 = 'ProEditaVinculoCliente'
	cur			 = ""
	goapp.npara1 = This.Codigo
	TEXT To m.lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If EJECUTARP(m.lc, m.lp, cur) = 0 Then
*	errorbd(ERRORPROC+ ' Actualizando Clientes con Otros Clientes')
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarVinculos
	Lparameters ccur
	Local lc
	m.lc		 = ''
	goapp.npara1 = This.Codigov
	TEXT To m.lc Noshow Textmerge Pretext 7
		Select  c.razo,	ifnull(Sum(v.saldo), 0) As saldo,c.idclie,clie_idvi	From fe_clie c
		            Left Join	(Select  Sum(Impo - acta) As saldo, rcre_idcl As idclie
					 From fe_cred x
					 inner Join fe_rcred Y  On Y.rcre_idrc=x.cred_idrc
					 inner Join fe_clie As c  On c.idclie=Y.rcre_idcl
					 Where x.Acti='A'  And Y.rcre_acti = 'A'  And clie_idvi =<<goapp.npara1>>  Group By idclie, x.ncontrol) As v On v.idclie = c.idclie
			         Where c.clie_idvi= <<goapp.npara1>> Group By c.idclie 	Order By razo
	ENDTEXT
	If This.Ejecutaconsulta(m.lc, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Autorizacreditocliente
	Local lc, lp
*:Global cur
	m.lc		 = 'ProAutorizaCreditoCliente'
	cur			 = ""
	goapp.npara1 = This.Codigo
	goapp.npara2 = This.usuario
	goapp.npara3 = This.AutorizadoCredito
	TEXT To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) = 0 Then
*	errorbd(ERRORPROC+ ' Autorizando Crédito a Cliente')
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
	Local lc
	goapp.npara1=This.Codigo
	TEXT To m.lc Noshow Textmerge
		   Select  nomb, logc_fope From fe_acrecli F
			   inner Join fe_usua u   On u.idusua=F.logc_idus
			   Where logc_idcl =<<goapp.npara1>>   Order By logc_fope Desc;
	ENDTEXT
	If This.Ejecutaconsulta(m.lc, m.ccur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarProyectosxcliente
	Lparameters ccur
	Local lc
	m.lc		 = ''
	goapp.npara1 = This.Codigo
	TEXT To m.lc Noshow Textmerge Pretext 7
		Select  proy_nomb,proy_idcl,proy_idpr From fe_proyectos Where proy_idcl= <<goapp.npara1>> 		And proy_acti = 'A'
	ENDTEXT
	If This.Ejecutaconsulta(m.lc, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure MostrarSucursalesxcliente
	Lparameters ccur
	Local lc
	m.lc		 = ''
	goapp.npara1 = This.Codigo
	TEXT To m.lc Noshow Textmerge Pretext 7
		 Select  succ_nomb, succ_dire, succ_ciud, succ_idcl, succ_id From fe_succliente	 Where succ_idcl= <<goapp.npara1>>	 And succ_acti = 'A'
	ENDTEXT
	If This.Ejecutaconsulta(m.lc, m.ccur) < 1  Then
		Return 0
	Else
		Return  1
	Endif
	Endproc

	Function CreaSucursalcliente(np1, np2, np3, np4)
	Local lc
	TEXT To m.lc Noshow Textmerge Pretext 7
	   INSERT INTO fe_succliente(succ_nomb,succ_dire,succ_ciud,succ_idcl)values('<<np1>>','<<np2>>','<<np3>>',<<np4>>)
	ENDTEXT
	If This.ejecutarsql(m.lc) < 1 Then
		Return 0
	Endif
	Mensaje("Creado Ok")
	Return 1
	Endfunc
	Function EditaSucursalcliente(np1, np2, np3, np4, np5, np6)
	Local lc
	If m.np6 = 0 Then
		TEXT To m.lc Noshow Textmerge Pretext 7
	   		UPDATE  fe_succliente  SET succ_acti='I' WHERE succ_id=<<np5>>
		ENDTEXT
	Else
		TEXT To m.lc Noshow Textmerge Pretext 7
	   		UPDATE  fe_succliente  SET succ_nomb='<<np1>>',succ_dire='<<np2>>',succ_ciud='<<np3>>' WHERE succ_id=<<np5>>
		ENDTEXT
	Endif
	If This.ejecutarsql(m.lc) < 1 Then
		Return 0
	Endif
	Mensaje("Actualizado Ok")
	Return 1
	Endfunc
	Function ActualizaSegmentoCliente(np1, np2)
	Local lc
	TEXT To m.lc Noshow Textmerge
	      UPDATE fe_clie SET clie_idse=<<np2>> WHERE idclie=<<np1>>
	ENDTEXT
	If This.ejecutarsql(m.lc) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine
*****************************************
