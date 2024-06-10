Define Class ventaspsysw As 'ventas' Of 'd:\capass\modelos\ventas'
	Function grabarvta()
	cTdoc = .Tdoc
	cform = Left(.Forma, 1)
	cndoc = xvtas.Ndoc
	dFecha = .Fecha
	dfechav = .Fechavto
	Nt = xvtas.Importe
	ndolar = fe_gene.dola
	ccodp = .Codigo
	cdeta = .Detallecreditos
	cdetalle = Alltrim(.razon)
	nt1 = xvtas.Importe
	nidusua = goApp.nidusua
	nidtda = .Tienda
	tgratuitas = xvtas.gratuitas
	If .Tdoc = '01' Or .Tdoc = '03' Then
		nidcta1 = fe_gene.idctav
		nidcta2 = fe_gene.idctai
		nidcta3 = fe_gene.idctat
	Else
		nidcta1 = 0
		nidcta2 = 0
		nidcta3 = 0
	Endif
	Set Procedure To CapaDatos, rnw Additive
	Local Obj As SerieProducto
	Obj = Createobject("serieproducto")
	If fe_gene.gene_exon = 'N' Then
		Tigv = fe_gene.igv
		nv = Round(xvtas.Importe / Tigv, 2)
		nigv = Round(xvtas.Importe - Round(xvtas.Importe / Tigv, 2), 2)
		If xvtas.gratuitas > 0 Then
			.Auto = IngresaDocumentoElectronicoVtas10(.Tdoc, cform, xvtas.Ndoc, .Fecha, .Detallecreditos, nv, nigv, Nt, .Guia, .Moneda, ndolar, Tigv, 'k', ccodp, tgratuitas, goApp.nidusua, goApp.Tienda, nidcta1, nidcta2, nidcta3, .Codv, 0, 0, 0)
		Else
			If goApp.Clientesconretencion = 'S' Then
				nretencion = 0
				If This.Conretencion  = 'S'  And xvtas.Importe >= fe_gene.Montoretencion Then
					nretencion = Round((xvtas.Importe * fe_gene.retencion) / 100, 2)
				Else
					nretencion = 0
				Endif
				.Auto = IngresaDocumentoElectronicoconretencion10(.Tdoc, cform, xvtas.Ndoc, .Fecha, .Detallecreditos, nv, nigv, Nt, .Guia, .Moneda, ndolar, Tigv, 'k', ccodp, 0, goApp.nidusua, goApp.Tienda, nidcta1, nidcta2, nidcta3, .Codv, 0, 0, 0, nretencion)
			Else
				.Auto = IngresaDocumentoElectronico(.Tdoc, cform, xvtas.Ndoc, .Fecha, .Detallecreditos, nv, nigv, Nt, .Guia, .Moneda, ndolar, Tigv, 'k', ccodp, 'V', goApp.nidusua, goApp.Tienda, nidcta1, nidcta2, nidcta3, .Codv, 0, 0, 0)
			Endif
		Endif
	Else
		If This.Tipovta = 'N' Then
			Tigv = fe_gene.igv
			nv = Round(xvtas.Importe / Tigv, 2)
			nigv = Round(xvtas.Importe - Round(xvtas.Importe / Tigv, 2), 2)
			nexon = 0
		Else
			Tigv = 1
			nigv = 0
			nv = 0
			nexon = xvtas.Importe
		Endif
		.Auto = IngresaDocumentoElectronico(.Tdoc, cform, xvtas.Ndoc, .Fecha, .Detallecreditos, nv, nigv, Nt, .Guia, .Moneda, ndolar, Tigv, 'k', ccodp, 'V', goApp.nidusua, goApp.Tienda, nidcta1, nidcta2, nidcta3, .Codv, 0, nexon, 0)
	Endif

	If .Auto <= 0 Then
		DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(.Fecha, "", .razon, nidcta3, Nt, 0, 'S', fe_gene.dola, goApp.nidusua, ccodp, .Auto, cform, xvtas.Ndoc, .Tdoc, goApp.Tienda) = 0 Then
		DEshacerCambios()
		Return 0
	Endif
	If cform = 'E' Then
		If IngresaRvendedores(.Auto, .Codigo, .Codv, cform) = 0 Then
			DEshacerCambios()
			Return 0
		Endif
	Endif
	If cform = 'C' Or cform = 'D' Then
		If .grabacreditos(.Auto, Nt, cndoc) = 0 Then
			DEshacerCambios()
			Return 0
		Endif
	Endif
	calma = goApp.Tienda
	If goApp.Todoenuno = 'S' Then
		nidtda = 1
	Else
		nidtda = This.Tienda
	Endif
	Sw = 1
	Ts = 0
	Select vtas2
	Set Filter To Auto = xvtas.Auto And coda > 0
	Go Top
	Do While !Eof()
		ncomision = vtas2.comi
		ncoda = vtas2.coda
		cdescri = vtas2.Desc
		If !Empty(vtas2.SerieProducto) Then
			nidkar = INGRESAKARDEX1(.Auto, ncoda, 'V', vtas2.Prec, 1, 'I', 'K', .Codv, nidtda, 0, ncomision)
			If nidkar < 1 Then
				Sw = 0
				Exit
			Endif
			Obj.AsignaValores(vtas2.SerieProducto, .Auto, nidkar, vtas2.coda)
			If Obj.RegistraDseries(vtas2.Idseriep) <= 0 Then
				Sw = 0
				Exit
			Endif
		Else
			nidkar = INGRESAKARDEX1(.Auto, vtas2.coda, 'V', vtas2.Prec, vtas2.cant, 'I', 'K', .Codv, nidtda, Iif(vtas2.costoref > 0, vtas2.costoref, vtas2.costo), ncomision)
			If nidkar < 1
				Sw = 0
				Exit
			Endif
		Endif
		If fe_gene.alma_nega = 0 Then
			If DevuelveStocks(vtas2.coda, "St") = 0 Then
				Sw = 0
				Exit
			Else
				If goApp.Todoenuno = 'S' Then
					Ts = st.uno + st.Dos
				Else
					Do Case
					Case goApp.Tienda = 1
						Ts = st.uno
					Case goApp.Tienda = 2
						Ts = st.Dos
					Case goApp.Tienda = 3
						Ts = st.tre
					Case goApp.Tienda = 4
						Ts = st.cua
					Endcase
				Endif
				If vtas2.cant > Ts Then
					Sw = 0
					Exit
				Endif
			Endif
		Endif
		If ActualizaStock(vtas2.coda, nidtda, vtas2.cant, 'V') = 0 Then
			Sw = 0
			Exit
		Endif
		Select vtas2
		Skip
	Enddo
	If Sw = 0 Then
		DEshacerCambios()
		Messagebox("El Item:" + Alltrim(cdescri) + " NO Tiene Stock Disponible Para Venta", 16, MSGTITULO)
		Return 0
	Endif
	If This.IDautoP > 0 Then
		If ActualizaPedidoFacturado(This.IDautoP) = 0 Then
			Messagebox("NO se Actualizo el estado de Pedido a Facturado", 16, MSGTITULO)
			Return 0
		Endif
	Endif
	If Sw = 0 Then
		Return 0
	Else
		Insert Into cabecera(idcab)Values(This.Auto)
		Return 1
	Endif
	Endfunc
Enddefine