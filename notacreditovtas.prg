Define Class notacreditovtas As Odata Of 'd:\capass\database\data'
	nvalor			 = 0
	cserie			 = ""
	cnumero			 = ""
	nidclie			 = 0
	dFecha			 = Date()
	cnombrecliente	 = ""
	cdni			 = ""
	ctdocref		 = ""
	ctiponotacredito = ''
	nformapago		 = 0
	dfechavto		 = Date()
	ntipodcto		 = 0
	ntotal			 = 0
	ntfactura		 = 0
	nformaplicar	 = 0
	cruc			 =""
	ntotalnc		 = 0
	Function validar
	Do Case
	Case This.ntotal = 0  And This.ctiponotacredito <> '13'
		This.Cmensaje="Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(This.cserie)) < 3 Or Len(Alltrim(This.cnumero)) < 7
		This.Cmensaje="Falta Ingresar Correctamente el Número del  Documento"
		Return 0
	Case This.nidclie = 0
		This.Cmensaje="Ingrese Un Cliente"
		Return 0
	Case Year(This.dFecha) <> Val(goapp.año) Or This.dFecha > fe_gene.fech
		This.Cmensaje="La Fecha No es Válida"
		Return 0
	Case !validaruc(This.cruc)  And This.ctdocref = '01'
		This.Cmensaje="RUC no Válido"
		Return 0
	Case (Len(Alltrim(This.cnombrecliente)) < 5 Or Len(Alltrim(This.cdni)) < 8) And This.ctdocref = '03'
		This.Cmensaje="Es Necesario Ingresar el Nombre Completo de Cliente, DNI Válidos"
		Return 0
	Case  permiteIngresox(This.dFecha) = 0
		This.Cmensaje="No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case This.ctiponotacredito = '13' And  This.nformapago <> 2
		This.Cmensaje="El documento se debe ingresar como Crédito y fecha de vencimiento "
		Return 0
	Case This.ctiponotacredito = '13' And  This.nformapago = 2  And This.dfechavto <= This.dFecha
		This.Cmensaje="la fecha de vencimiento  Tienen que ser mayor a la fecha de emisión"
		Return 0
	Case This.ctiponotacredito = '13' And This.nformaplicar = 0
		This.Cmensaje = "Tiene que seleccionar la opción  Agrupada para este documento"
		Return 0
	Case This.ctiponotacredito = '13' And This.ntotal > 0
		This.Cmensaje  = "Los Importes Deben de ser 0"
		Return 0
	Case This.ctiponotacredito = '13' And This.ntotalnc = 0
		This.Cmensaje  = "Ingrese Importe para Nota Crédito Tipo 13"
		Return 0
	Case This.ctiponotacredito = '13' And This.ntotalnc > This.ntfactura
		This.Cmensaje  = "Ingrese Importe para Nota Crédito Tipo 13"
		Return 0
	Case This.ntipodcto = 1 And  This.ntotal > This.ntfactura And This.ctiponotacredito <> '13'
		This.Cmensaje="El Importe No Puede Ser Mayor al del Documento"
		Return 0
	Otherwise
		Return 1
	Endcase

	Endfunc
Enddefine
