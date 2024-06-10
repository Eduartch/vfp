Define Class notacreditovtas As Odata Of 'd:\capass\database\data'
	nvalor			 = 0
	Cserie			 = ""
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
	nTotal			 = 0
	ntfactura		 = 0
	nformaplicar	 = 0
	Cruc			 = ""
	ntotalnc		 = 0
	cTdoc = ""
	cformapago = ""
	cmotivo = ""
	nvalor = 0
	nigv = 0
	nTotal = 0
	ndolar = fe_gene.dola
	ncodigocliente = 0
	nidven = 0
	Cmoneda = ""
	Function VAlidar
	If This.nformaplicar = 0 Then
		Select Sum(devo) As tdevo From tmpn Into Cursor tdevol
		Sw = 1
		Select tmpn
		Scan All
			If tdevol.tdevo > 0 Then
				If (tmpn.devo * tmpn.dsct) = 0  And  (tmpn.devo > 0 Or tmpn.dsct > 0)  Then
					This.Cmensaje = "Los Importes del Item " + Alltrim(tmpn.Desc) + " No son Válidos"
					Sw = 0
					Exit
				Endif
			Endif
		Endscan
		If Sw = 0 Then
			Return 0
		Endif
	Endif
	Do Case
	Case This.nTotal = 0  And This.ctiponotacredito <> '13'
		This.Cmensaje = "Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(This.Cserie)) < 4 Or Len(Alltrim(This.cnumero)) < 8;
			Or This.Cserie = "0000" Or Val(This.cnumero) = 0
		This.Cmensaje = "Falta Ingresar Correctamente el Número del  Documento"
		Return 0
	Case This.nidclie = 0
		This.Cmensaje = "Ingrese Un Cliente"
		Return 0
	Case Year(This.dFecha) <> Val(goApp.año) Or This.dFecha > fe_gene.fech
		This.Cmensaje = "La Fecha No es Válida"
		Return 0
	Case This.ctdocref = '01' And  !'FN' $ Left(This.Cserie, 2) And This.cTdoc = '07'
		This.Cmensaje = "Número del  Documento NO Válido"
		Return 0
	Case This.ctdocref = '01' And  !'FD' $ Left(This.Cserie, 2) And This.cTdoc = '08'
		This.Cmensaje = "Número del  Documento NO Válido"
		Return 0
	Case !ValidaRuc(This.Cruc)  And This.ctdocref = '01'
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
	Case This.ctiponotacredito = '13' And This.nTotal > 0
		This.Cmensaje  = "Los Importes Deben de ser 0"
		Return 0
	Case This.ctiponotacredito = '13' And This.ntotalnc = 0
		This.Cmensaje  = "Ingrese Importe para Nota Crédito Tipo 13"
		Return 0
	Case This.ctiponotacredito = '13' And This.ntotalnc > This.ntfactura
		This.Cmensaje  = "Ingrese Importe para Nota Crédito Tipo 13"
		Return 0
	Case This.ntipodcto = 1 And  This.nTotal > This.ntfactura And This.ctiponotacredito <> '13'
		This.Cmensaje = "El Importe No Puede Ser Mayor al del Documento"
		Return 0
	Otherwise
		Return 1
	Endcase
	Function registrarncpsysw()
	Local Obj As SerieProducto
	Obj = Createobject("serieproducto")
	Create Cursor tmpv(coda N(10), Desc c(100), Unid c(4), cant N(12, 2), Prec N(12, 7), Ndoc c(12), cletras c(180), ;
		Nitem N(5), hash c(30), fech d, codc N(5), Guia c(10), Direccion c(120), dni c(8), Forma c(30), fono c(15), Tdoc c(2), ;
		Vendedor c(60), dias N(3), razon c(120), nruc c(11), Mone c(1) Default 'S', fech1 d, Tdoc1 c(2), dcto c(12), Referencia c(60), Archivo c(120))
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If fe_gene.gene_exon = 'N' Then
		NAuto = IngresaDocumentoElectronico(This.cTdoc, This.cformapago, This.Cserie + This.cnumero, This.dFecha, This.cmotivo, This.nvalor, This.nigv, This.nTotal, "", This.Cmoneda, ;
			This.ndolar, fe_gene.igv, 'k', This.ncodigocliente, 'V', goApp.nidusua, goApp.Tienda, fe_gene.idctav, fe_gene.idctai, fe_gene.idctat, This.nidven, 0, 0, 0)
	Else
		NAuto = IngresaDocumentoElectronico(This.cTdoc, This.cformapago, This.Cserie + This.cnumero, This.Cserie + This.cnumero, This.cmotivo, 0, 0, This.nTotal, "", This.Cmoneda, ;
			This.ndolar, 1, 'k', This.ncodigocliente, 'V', goApp.nidusua, goApp.Tienda, fe_gene.idctav, fe_gene.idctai, fe_gene.idctat, This.nidven, 0, This.nvalor, 0)
	Endif
	If NAuto < 1
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.dFecha, "", This.cnombrecliente, fe_gene.idctat, Nt, 0, 'S', fe_gene.dola, goApp.nidusua, This.ncodigocliente, NAuto, This.cformapago, This.Cserie + This.cnumero, ;
			This.ctdo, goApp.Tienda) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.cformapago = 'E' Then
		If IngresaRvendedores(NAuto, This.ncodigocliente, This.nidven, "E") = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If  This.cTdoc = '07' Then
			If IngresaRvendedores(NAuto,  This.ncodigocliente, This.nidven, "E") = 0 Then
				This.DEshacerCambios()
				Return 0
			Endif
		Endif
	Endif
	If This.cformapago = 'C'  Then
		If xtdoc = '08' Then
			If This.ingresarcreditos() = 0 Then
				This.DEshacerCambios()
				Return 0
			Endif
		Else
			nidpagos = This.ingresapagos()
			If nidpagos = 0 Then
				This.DEshacerCambios()
				Return 0
			Endif
		Endif
	Endif
	Cmensaje = ""
	If .Optdetalles.optagrupada.Value = 1
		Go Top In tmpn
		If xtdoc = "07"
			Insert Into tmpv(Desc, cant, Prec, Ndoc)Values("Descuento Adicional", 1, 1 * .txttOTAL.Value, cndcto)
		Else
			Insert Into tmpv(Desc, cant, Prec, Ndoc)Values(Alltrim(.txtmodifica.Value), 1, 1 * .txttOTAL.Value, cndcto)
		Endif
		If INGRESAKARDEX1(NAuto, tmpn.coda, 'V', 0, 0, 'I', 'K', lv.idven, goApp.Tienda, 0, ncomision) = 0 Then
			Cmensaje = 'Al Regitrar Descuento'
			This.DEshacerCambios()
			Aviso(Cmensaje)
			Return 0
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
				Insert Into tmpv(coda, Desc, Unid, cant, Prec, Ndoc)Values(tmpn.coda, tmpn.Desc, tmpn.Unid, 1, tmpn.dsct, cndcto)
				If INGRESAKARDEX1(.NAuto, tmpn.coda, 'V', tmpn.Prec, 0, 'I', 'K', lv.idven, tmpn.alma, 0, tmpn.comi) = 0
					Sw = 0
					Cmensaje = 'Al Regitrar Devolucion 1'
					Exit
				Endif
			Case tmpn.devo > 0 And .cmbdcto.ListIndex = 1
				Insert Into tmpv(coda, Desc, Unid, cant, Prec, Ndoc)Values(tmpn.coda, tmpn.Desc, tmpn.Unid, - tmpn.devo, tmpn.dsct, cndcto)
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
				Insert Into tmpv(coda, Desc, Unid, cant, Prec, Ndoc)Values(tmpn.coda, tmpn.Desc, tmpn.Unid, 1, tmpn.dsct, cndcto)
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
		This.DEshacerCambios()
		Aviso(Cmensaje)
		Return 0
	Endif
	Select Idauto From tmpn Where Idauto > 0 Into Cursor Xt Group By Idauto
	Select Xt
	Scan All
		If IngresarNotasCreditoVentas1(NAuto, Xt.Idauto, nidpagos) = 0 Then
			Cmensaje = 'Al Regitrar Pago'
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		Aviso(Cmensaje)
		Return 0
	Endif
	If .GeneraNumero() = 0 Then
		This.DEshacerCambios()
		Aviso('Al Generar Correlativo')
		Return 0
	Endif
	If PermiteIngresoVentas1(cndcto, cTdoc, .NAuto, dfvta) < 1 Then
		This.DEshacerCambios()
		Aviso('Dcto Ya Registrado ' + cndcto + ' ' + cTdoc)
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine



