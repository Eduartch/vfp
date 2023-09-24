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
	Cruc			 = ""
	ntotalnc		 = 0
	ctdoc = ""
	cformapago = ""
	cmotivo = ""
	nvalor = 0
	nigv = 0
	ntotal = 0
	ndolar = fe_gene.dola
	ncodigocliente = 0
	nidven = 0
	cmoneda = ""
	Function Validar
	Do Case
	Case This.ntotal = 0  And This.ctiponotacredito <> '13'
		This.Cmensaje = "Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(This.cserie)) < 3 Or Len(Alltrim(This.cnumero)) < 7
		This.Cmensaje = "Falta Ingresar Correctamente el Número del  Documento"
		Return 0
	Case This.nidclie = 0
		This.Cmensaje = "Ingrese Un Cliente"
		Return 0
	Case Year(This.dFecha) <> Val(goApp.año) Or This.dFecha > fe_gene.fech
		This.Cmensaje = "La Fecha No es Válida"
		Return 0
	Case !validaruc(This.Cruc)  And This.ctdocref = '01'
		This.Cmensaje = "RUC no Válido"
		Return 0
	Case (Len(Alltrim(This.cnombrecliente)) < 5 Or Len(Alltrim(This.cdni)) <> 8) And This.ctdocref = '03'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, DNI Válidos"
		Return 0
	Case  PermiteIngresox(This.dFecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case This.ctiponotacredito = '13' And  This.nformapago <> 2
		This.Cmensaje = "El documento se debe ingresar como Crédito y fecha de vencimiento "
		Return 0
	Case This.ctiponotacredito = '13' And  This.nformapago = 2  And This.dfechavto <= This.dFecha
		This.Cmensaje = "la fecha de vencimiento  Tienen que ser mayor a la fecha de emisión"
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
		This.Cmensaje = "El Importe No Puede Ser Mayor al del Documento"
		Return 0
	Otherwise
		Return 1
	Endcase
	Function registrarncpsysw()
	Local Obj As SerieProducto
	Obj = Createobject("serieproducto")
	Create Cursor tmpv(coda N(10), Desc c(100), Unid c(4), cant N(12, 2), Prec N(12, 7), ndoc c(12), cletras c(180), ;
		  Nitem N(5), hash c(30), fech d, codc N(5), guia c(10), direccion c(120), dni c(8), Forma c(30), fono c(15), Tdoc c(2), ;
		  vendedor c(60), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', fech1 d, tdoc1 c(2), dcto c(12), Referencia c(60), archivo c(120))
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If fe_gene.gene_exon = 'N' Then
		NAuto = IngresaDocumentoElectronico(This.ctdoc, This.cformapago, This.cserie + This.cnumero, This.dFecha, This.cmotivo, This.nvalor, This.nigv, This.ntotal, "", This.cmoneda, ;
			  This.ndolar, fe_gene.igv, 'k', This.ncodigocliente, 'V', goApp.nidusua, goApp.Tienda, fe_gene.idctav, fe_gene.idctai, fe_gene.idctat, This.nidven, 0, 0, 0)
	Else
		NAuto = IngresaDocumentoElectronico(This.ctdoc, This.cformapago, This.cserie + This.cnumero, This.cserie + This.cnumero, This.cmotivo, 0, 0, This.ntotal, "", This.cmoneda, ;
			  This.ndolar, 1, 'k', This.ncodigocliente, 'V', goApp.nidusua, goApp.Tienda, fe_gene.idctav, fe_gene.idctai, fe_gene.idctat, This.nidven, 0, This.nvalor, 0)
	Endif
	If NAuto < 1
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.dFecha, "", This.cnombrecliente, fe_gene.idctat, nt, 0, 'S', fe_gene.dola, goApp.nidusua, This.ncodigocliente, NAuto, This.cformapago, This.cserie + This.cnumero, ;
			  This.ctdo, goApp.Tienda) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If this.cformapago='E' then
		If IngresaRvendedores(NAuto, this.ncodigocliente, this.nidven, "E") = 0 Then
			this.DEshacerCambios()
			RETURN 0
		Endif
	Else
		If  this.ctdoc = '07' Then
			If IngresaRvendedores(NAuto,  this.ncodigocliente, this.nidven, "E") = 0 Then
				this.DEshacerCambios()
				RETURN 0
			Endif
		Endif
	Endif
	If this.cformapago='C'  Then
		If xtdoc = '08' Then
			If this.ingresarcreditos() = 0 Then
				this.DEshacerCambios()
				RETURN 0
			Endif
		Else
			nidpagos = this.ingresapagos()
			If nidpagos = 0 Then
				this.DEshacerCambios()
				RETURN 0
			Endif
		Endif
	Endif
	Cmensaje = ""
	If .optdetalles.optagrupada.Value = 1
		Go Top In tmpn
		If xtdoc = "07"
			Insert Into tmpv(Desc, cant, Prec, ndoc)Values("Descuento Adicional", 1, 1 * .txttOTAL.Value, cndcto)
		Else
			Insert Into tmpv(Desc, cant, Prec, ndoc)Values(Alltrim(.txtmodifica.Value), 1, 1 * .txttOTAL.Value, cndcto)
		Endif
		If INGRESAKARDEX1(NAuto, tmpn.coda, 'V', 0, 0, 'I', 'K', lv.idven, goApp.Tienda, 0, ncomision) = 0 Then
			Cmensaje = 'Al Regitrar Descuento'
			this.DEshacerCambios()
			aviso(Cmensaje)
			RETURN 0
		Endif
	Else
		Select tmpn
		Go Top
		p = 0
		Do While !Eof()
			If tmpn.dsct = 0 Or tmpn.devo = 0 Then
				Select tmpn
				Skip
				Loop
			Endif
			p = p + 1
			Do Case
			Case .cmbdcto.ListIndex = 2  And tmpn.dsct > 0
				Insert Into tmpv(coda, Desc, Unid, cant, Prec, ndoc)Values(tmpn.coda, tmpn.Desc, tmpn.Unid, 1, tmpn.dsct, cndcto)
				If INGRESAKARDEX1(.NAuto, tmpn.coda, 'V', tmpn.Prec, 0, 'I', 'K', lv.idven, tmpn.alma, 0, tmpn.comi) = 0
					Sw = 0
					Cmensaje = 'Al Regitrar Devolucion 1'
					Exit
				Endif
			Case tmpn.devo > 0 And .cmbdcto.ListIndex = 1
				Insert Into tmpv(coda, Desc, Unid, cant, Prec, ndoc)Values(tmpn.coda, tmpn.Desc, tmpn.Unid, - tmpn.devo, tmpn.dsct, cndcto)
				nidkar = INGRESAKARDEX1(.NAuto, tmpn.coda, 'V', tmpn.Prec, - tmpn.devo, 'I', 'K', lv.idven, tmpn.alma, 0, tmpn.comi)
				If nidkar = 0
					Sw = 0
					Cmensaje = 'Al Regitrar Devolucion 2'
					Exit
				Endif
				If !Empty(tmpn.SerieProducto)
					Obj.AsignaValores(tmpn.SerieProducto, .NAuto, nidkar, tmpn.coda)
					If Obj.RegistraDseries(tmpn.Idseriep) <= 0 Then
						Sw = 0
						Cmensaje = 'Al Regitrar Series '
						Exit
					Endif
				Endif
				If ActualizaStock(tmpn.coda, tmpn.alma, tmpn.devo, 'C') = 0 Then
					Cmensaje = 'Al Regitrar Stock'
					Sw = 0
					Exit
				Endif
			Case  .cmbdcto.ListIndex = 1 And tmpn.dsct > 0
				Insert Into tmpv(coda, Desc, Unid, cant, Prec, ndoc)Values(tmpn.coda, tmpn.Desc, tmpn.Unid, 1, tmpn.dsct, cndcto)
				If INGRESAKARDEX1(.NAuto, tmpn.coda, 'V', tmpn.Prec, 0, 'I', 'K', lv.idven, tmpn.alma, 0, tmpn.comi) = 0
					Sw = 0
					Cmensaje = 'Al Regitrar Devolucion 3'
					Exit
				Endif
			Endcase
			Select tmpn
			Skip
		Enddo
	Endif
	If Sw = 0 Then
		this.DEshacerCambios()
		aviso(Cmensaje)
		RETURN 0
	Endif
	Select idauto From tmpn Where idauto > 0 Into Cursor Xt Group By idauto
	Select Xt
	Scan All
		If IngresarNotasCreditoVentas1(NAuto, Xt.idauto, nidpagos) = 0 Then
			Cmensaje = 'Al Regitrar Pago'
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		this.DEshacerCambios()
		aviso(Cmensaje)
		RETURN 0
	Endif
	If .GeneraNumero() = 0 Then
		this.DEshacerCambios()
		aviso('Al Generar Correlativo')
		RETURN 0
	Endif
	If PermiteIngresoVentas1(cndcto, ctdoc, .NAuto, dfvta) < 1 Then
		this.DEshacerCambios()
		aviso('Dcto Ya Registrado ' + cndcto + ' ' + ctdoc)
		RETURN 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

