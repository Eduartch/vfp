#Define Url "http://companiasysven.com/"
Define Class GuiaRemision As Odata Of 'd:\capass\database\data'
	Fecha				= ""
	fechat				= .F.
	Referencia			= ""
	tref				= ""
	ptop				= ""
	ptoll				= ""
	Idcliente			= 0
	razon				= ""
	nruc				= ""
	conductor			= ""
	marca				= ""
	Placa				= ""
	brevete				= ""
	razont				= ""
	ructr				= ""
	Motivo				= ""
	Idautog				= 0
	Idtransportista		= ""
	tipotransporte      = 0
	Detalle				= ""
	Idauto				= ""
	Ndoc				= ""
	Items				= 0
	Titems				= 0
	Constancia			= ""
	Archivo				= ""
	Multiempresa		= ""
	Nsgte				= 0
	Idserie				= 0
	Tdoc				= ""
	Cmulti				= ""
	Codigo				= 0
	Total				= ""
	Fracciones			= .F.
	ndni				= ""
	TipoCursor			= "1 Id Numerico 2 id Caracter"
	Fechafacturacompra	= Date()
	numerofacturacompra	= ""
	actualizaguia		= ""
	placa1				= ""
	fechafactura		= ""
	Ndo2				= ""
	sucursal1			= 0
	sucursal2			= 0
	Archivointerno		= "Nombre del Traspaso a Imprimir No ELECTRONICO"
	Coningresosucursal	= "Para Ingresar a Sucursal"
	Conseries			= ""
	conserieproductos	= ""
	nautor				= 0
	nidguia				= 0
	Calias				= ""
	idvendedor			= 0
	Tpeso               = 0
	mensajerptasunat    = ""
	ubigeocliente       = ""
	urlenvio            = Url + "app88/envioguia.php"
	urlenviod           =  Url + "app88/envioguiadesktop.php"
	urlconsultacdr      = Url + "app88/envioticketguia.php"
	urlconsultacdrservidor = Url + "app88/envioticketnube.php"
	ticket              = ""
	recibido            = ""
	idprov              = 0
	Proyecto            = ""
	codt                = 0
	nvalor = 0
	nigv = 0
	nTotal = 0
	Tienda = 0
	Encontrado = ""
	Detalletraspaso = ""
	fechaautorizada = 0
	calmacen1 = ""
	calmacen2 = ""
	sinstock = ""
	motivootros = ''
	ticket = ""
	condsctostock=""
	Function VerificaSiguiaVtaEstaIngresada(np1)
	Local lC
	TEXT To m.lC Noshow Textmerge
	   Select  guia_idgui As idauto   From fe_guias  Where guia_ndoc='<<np1>>'   And guia_acti = 'A' limit 1
	ENDTEXT
	If This.EjecutaConsulta(m.lC, 'Ig') < 1 Then
		Return 0
	Endif
	If ig.Idauto > 0 Then
		This.Cmensaje = 'Número de Guia Ya Registrado'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaGuiasVtas(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lC, lp
*:Global cur
	m.lC		  = "ProActualizaGuiasVtas"
	cur			  = ""
	goApp.npara1  = m.np1
	goApp.npara2  = m.np2
	goApp.npara3  = m.np3
	goApp.npara4  = m.np4
	goApp.npara5  = m.np5
	goApp.npara6  = m.np6
	goApp.npara7  = m.np7
	goApp.npara8  = m.np8
	goApp.npara9  = m.np9
	goApp.npara10 = This.Idautog
	goApp.npara11 = m.np11
	goApp.npara12 = m.np12
	goApp.npara13 = This.ubigeocliente
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?this.idautog,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function  ActualizaDetalleGuiaCons1(np1, np2, np3, np4, np5, np6, np7)
	Local lC, lp
*:Global cur
	cur			 = ""
	m.lC		 = 'ProActualizaDetalleGuiasCons'
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	goApp.npara4 = m.np4
	goApp.npara5 = m.np5
	goApp.npara6 = m.np6
	goApp.npara7 = m.np7
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaDetalleGuiasVtas(Ccursor)
	Sw = 1
	Select (m.Ccursor)
	Set Filter To coda <> 0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc = Alltrim(tmpvg.Descri)
		If Deleted()
			If Nreg > 0 Then
				If ActualizaKardexUAl(This.Idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, tmpvg.alma, 0, tmpvg.Nreg, 0, tmpvg.equi, tmpvg.Unid, tmpvg.idepta, 0, tmpvg.pos, tmpvg.costo, tmpvg.Tigv) = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Desactivar Ingreso de Item - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.Nreg, This.Idautog, 0, '') = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If fe_gene.alma_nega = 0 And tmpvg.tipro = 'K' Then
				If DevuelveStocks2(tmpvg.coda, calma, "st") < 1 Then
					Sw			  = 0
					This.Cmensaje = "Al Obtener Stock - " + Alltrim(cdesc)
					Exit
				Endif
				If (tmpvg.cant * tmpvg.equi) > (Iif(goApp.Tienda = 1, st.uno + tmpvg.caant, st.Dos + tmpvg.caant))
					Sw			  = 0
					This.Cmensaje = "Al Obtener Stock " + Alltrim(cdesc)
					Exit
				Endif
			Endif
			If tmpvg.Nreg = 0 Then
				nidkar = INGRESAKARDEXUAl(This.Idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goApp.Tienda, 0, 0, tmpvg.equi, tmpvg.Unid, tmpvg.idepta, tmpvg.pos, tmpvg.costo, tmpvg.Tigv)
				If nidkar = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Registrar Producto - " + Alltrim(cdesc)
					Exit
				Endif
				If GrabaDetalleGuias(nidkar, tmpvg.cant, This.Idautog) = 0 Then
					s			  = 0
					This.Cmensaje = "Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If ActualizaKardexUAl(This.Idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goApp.Tienda, 0, tmpvg.Nreg, 1, tmpvg.equi, tmpvg.Unid, tmpvg.idepta, 0, tmpvg.pos, tmpvg.costo, tmpvg.Tigv) < 1 Then
					Sw			  = 0
					This.Cmensaje = "Al Actualizar Kardex  - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.Nreg, This.Idautog, 1, '') < 1 Then
					Sw			  = 0
					This.Cmensaje = Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
			If ActualizaStock12(tmpvg.coda, goApp.Tienda, tmpvg.cant, 'V', tmpvg.equi, tmpvg.caant) = 0 Then
				Sw			  = 0
				This.Cmensaje = "Al Actualizar Stock " + Alltrim(cdesc)
				Exit
			Endif
		Endif
		Select tmpvg
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaCabeceraGuiaventasdirectas()
	If This.ActualizaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, "", 0, 0, 0, "", 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0, This.nautor) < 1 Then
		Return 0
	Endif
	If This.ActualizaGuiasVtas(This.Fecha, This.ptop, This.ptoll, This.nautor, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, This.Idautog, goApp.Tienda, This.Codigo) < 1
		Return 0
	Endif
	Return 1
	Endfunc
************************
	Function ActualizaResumenDcto(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	Local lC, lp
*:Global cur
	m.lC		  = 'ProActualizaCabeceraCV'
	cur			  = ""
	goApp.npara1  = m.np1
	goApp.npara2  = m.np2
	goApp.npara3  = m.np3
	goApp.npara4  = m.np4
	goApp.npara5  = m.np5
	goApp.npara6  = m.np6
	goApp.npara7  = m.np7
	goApp.npara8  = m.np8
	goApp.npara9  = m.np9
	goApp.npara10 = m.np10
	goApp.npara11 = m.np11
	goApp.npara12 = m.np12
	goApp.npara13 = m.np13
	goApp.npara14 = m.np14
	goApp.npara15 = m.np15
	goApp.npara16 = m.np16
	goApp.npara17 = m.np17
	goApp.npara18 = m.np18
	goApp.npara19 = m.np19
	goApp.npara20 = m.np20
	goApp.npara21 = m.np21
	goApp.npara22 = m.np22
	goApp.npara23 = m.np23
	goApp.npara24 = m.np24
	goApp.npara25 = m.np25
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function Imprimir(cestilo)
	Local obji As "Imprimir"
	Select Count(*) As ti From tmpvg Into Cursor xitems
	Select tmpvg
	For x = 1 To This.Items - xitems.ti
		Insert Into tmpvg(Ndoc)Values(This.Ndoc)
	Next
	Replace All fech With This.Fecha, Ndoc With This.Ndoc, ;
		fect With This.fechat, ptop With This.ptop, ;
		ptoll With This.ptoll, razon With This.razon, ;
		nruc With This.nruc, conductor With This.conductor, ;
		marca With This.marca, Placa With This.Placa, placa1 With This.placa1, ;
		Constancia With This.Constancia, brevete With This.brevete, ;
		razont With This.razont, ructr With This.ructr, Motivo With This.Motivo, ;
		tref With This.tref, Refe With This.Referencia, Archivo With This.Archivo, tipotra With This.tipotransporte;
		Ndoc With This.Ndoc, ndni With This.ndni, fechafactura With This.Fechafacturacompra, Detalle With This.Detalle  In tmpvg
	If This.Cmulti = 'S' Then
		carpdf = Oempresa.nruc + "-" + This.Tdoc + "-" + Left(This.Ndoc, 4) + '-' + Substr(This.Ndoc, 5) + ".Pdf"
	Else
		carpdf = fe_gene.nruc + "-" + This.Tdoc  + "-" + Left(This.Ndoc, 4) + '-' + Substr(This.Ndoc, 5) + ".Pdf"
	Endif
	Select tmpvg
	Go Top In tmpvg
	Set Order To
	Set Filter To
	Set Procedure To Imprimir Additive
	m.obji			  = Createobject("Imprimir")
	m.obji.Tdoc		  = This.Tdoc
	m.obji.ArchivoPdf = carpdf
	m.obji.ElijeFormatoM()
	Do Form ka_ldctosg To Verdad
	Do Case
	Case m.cestilo = 'S'
		m.obji.ImprimeComprobanteM('S')
	Case m.cestilo = 'N'
		m.obji.ImprimeComprobanteM('N')
		m.obji.GeneraPDF("S")
	Otherwise
		m.obji.ImprimeComprobanteM('N')
		m.obji.GeneraPDF("")
	Endcase
	Endfunc
	Function ActualizaguiasRemitenteventas()
	This.contransaccion = 'S'
	
	If This.IniciaTransaccion() = 0
		This.contransaccion = ''
		Return 0
	Endif
	If This.ActualizaGuiasVtas(This.Fecha, This.ptop, This.ptoll, This.nautor, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, This.Idautog, goApp.Tienda, This.Codigo) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtasR(This.Calias) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		This.contransaccion = ""
		Return 0
	Endif
	This.Imprimir('S')
	Return 1
	Endfunc
	Function ActualizaDetalleGuiasVtasR(Ccursor)
*:Global cdesc, nidkar, s, sw
	Sw = 1
	Select (m.Ccursor)
	If Vartype(coda)='N' Then
		Set Filter To coda <> 0
	Else
		Set Filter To Len(Alltrim(coda)) > 0
	Endif
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc = Alltrim(tmpvg.Descri)
		If Deleted()
			If Nreg > 0 Then
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.Idautog, 0, '') = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If tmpvg.Nreg = 0 Then
				If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, This.Idautog) = 0 Then
					s			  = 0
					This.Cmensaje = "Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.Idautog, 1, '') = 0 Then
					Sw			  = 0
					This.Cmensaje = Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif

		Endif
		Select tmpvg
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualiaguiasventasdirectas()
	This.contransaccion = 'S'
	If This.IniciaTransaccion() = 0
		This.contransaccion = ''
		Return 0
	Endif
	If This.ActualizaCabeceraGuiaventasdirectas() < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtasGrifos(This.Calias) < 1 Then
		This.DEshacerCambios()
		This.contransaccion = ""
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		This.contransaccion = ""
		Return 0
	Endif
	This.Imprimir('S')
	Return 1
	Endfunc
	Function ActualizaDetalleGuiasVtasGrifos(Ccursor)
	Sw = 1
	Select (m.Ccursor)
	Set Filter To coda <> 0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc = Alltrim(tmpvg.Descri)
		If Deleted()
			If Nreg > 0 Then
				If ActualizaStock11(tmpvg.coda, tmpvg.alma, tmpvg.cant, 'C', tmpvg.caant) = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Actualizar Stock -  " + Alltrim(cdesc)
					Exit
				Endif
				If Actualizakardex1(This.Idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, tmpvg.alma, 0, tmpvg.Nreg, 0, 0) = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Desactivar Ingreso de Item - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.Nreg, This.Idautog, 0, '') = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If tmpvg.Nreg = 0 Then
				nidkar = IngresaKardexGrifo(This.Idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goApp.Tienda, 0, 0)
				If nidkar = 0 Then
					Sw			  = 0
					This.Cmensaje = "Al Registrar Producto - " + Alltrim(cdesc)
					Exit
				Endif
				If GrabaDetalleGuias(nidkar, tmpvg.cant, This.Idautog) = 0 Then
					s			  = 0
					This.Cmensaje = "Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If Actualizakardex1(This.Idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goApp.Tienda, 0, tmpvg.Nreg, 1, 1) < 1 Then
					Sw			  = 0
					This.Cmensaje = "Al Actualizar Kardex  - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.Nreg, This.Idautog, 1, '') = 0 Then
					Sw			  = 0
					This.Cmensaje = Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
			If ActualizaStock11(tmpvg.coda, goApp.Tienda, tmpvg.cant, 'V', tmpvg.caant) = 0 Then
				Sw			  = 0
				This.Cmensaje = "Al Actualizar Stock " + Alltrim(cdesc)
				Exit
			Endif
		Endif
		Select tmpvg
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	TEXT To lC Noshow Textmerge
     select guia_idgui as idauto FROM fe_guias WHERE guia_ndoc='<<this.ndoc>>' AND guia_acti='A' limit 1
	ENDTEXT
	If This.EjecutaConsulta(lC, 'ig') < 1 Then
		Return 0
	Endif
	If ig.Idauto > 0 Then
		cencontrado = 'S'
	Else
		cencontrado = 'N'
	Endif
	If This.Proyecto <> 'psysr' Then
		If  This.Verificacantidadantesvtas() = 0
			If !Empty(goApp.mensajeApp) Then
				This.Cmensaje = goApp.mensajeApp
				goApp.mensajeApp = ""
			Else
				This.Cmensaje = "Ingrese Cantidad es Obligatoria"
			Endif
			Return 0
		Endif
	Else
		If Verificacantidadantesvtasbat(This.Calias) = 0
			This.Cmensaje = "Ingrese Cantidad es Obligatoria"
			Return 0
		Endif
	Endif
	If  Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Do Case
	Case cencontrado = 'S' And This.Idautog = 0
		This.Cmensaje = "NÚMERO de Guia de Remisión Ya Registrado"
		Return 0
	Case Left(This.Ndoc, 4) = "0000"  Or Val(Substr(This.Ndoc, 4)) = 0
		This.Cmensaje = "Ingrese NÚMERO de Guia Remitente Válido"
		Return 0
	Case Len(Alltrim(Left(This.Ndoc, 4))) < 4 Or Len(Alltrim(Substr(This.Ndoc, 4))) < 8
		This.Cmensaje = "Ingrese el Nº de la Documento Válido"
		Return  0
	Case !esfechaValida(This.Fecha)
		This.Cmensaje = "La Fecha de emisón no es Válida"
		Return 0
	Case !esFechaValidaftraslado(This.fechat)
		This.Cmensaje = "La Fecha de Traslado no es Válida"
		Return 0
	Case This.fechat < This.Fecha
		This.Cmensaje = "La Fecha de Traslado no puede ser menor a la fecha de Emisión"
		Return 0
	Case This.fechat < This.Fecha
		This.Cmensaje = "La Fecha de Traslado No Puede Ser Antes que la Fecha de Emisión"
		Return 0
	Case Len(Alltrim(This.ptoll)) = 0
		This.Cmensaje = "Ingrese La dirección de LLegada"
		Return 0
	Case Len(Alltrim(This.ptop)) = 0
		This.Cmensaje = "Ingrese La dirección de Partida"
		Return 0
	Case  This.tref = '03' And Len(Alltrim(This.nruc)) <> 8
		This.Cmensaje = "Ingrese el documento del Destinatario"
		Return 0
	Case This.tref = '01' And !ValidaRuc(This.nruc)
		This.Cmensaje = "Ingrese el documento del Destinatario"
		Return 0
	Case Left(This.mensajerptasunat, 1) = '0'
		This.Cmensaje = "Este Documento Ya esta Informado a SUNAT no es posible Actualizar"
		Return 0
	Case This.Tpeso = 0 And This.Tdoc = '09'
		This.Cmensaje = "El Peso de los Productos es Obligatorio"
		Return 0
	Case This.Idtransportista = 0 And This.Tdoc = '09'
		This.Cmensaje = "El Transportista es Obligatorio"
		Return 0
	Case (Empty(This.razont) Or Len(Alltrim(This.ructr)) <> 11 Or  Len(Alltrim(This.Constancia)) = 0) And Left(This.tipotransporte, 2) = '01' And This.Tdoc = '09'
*!*			wait WINDOW this.razont
*!*			wait WINDOW this.ructr
*!*			wait WINDOW this.constancia
		This.Cmensaje = "Es obligatorio el RUC, el Nombre y el Registro MTC"
		Return 0
	Case Empty(This.razont) And Len(Alltrim(This.ructr)) <> 11 And Left(This.tipotransporte, 2) = '02' And Len(Alltrim(This.brevete)) <> 9 And Len(Alltrim(This.conductor)) = 0 And This.Tdoc = '09'
		This.Cmensaje = "Es obligatorio el nombre de Chofer y Brevete"
		Return 0
	Case This.tipotransporte = '02' And (!Isalpha(Left(This.brevete, 1))  Or  !Isdigit(Substr(This.brevete, 2))) And This.Tdoc = '09'
		This.Cmensaje = "El Brevete no es Válido... empieza con una Letra y lo demás son digitos"
		Return 0
	Case This.tipotransporte = '01' And This.ructr = Cruc
		This.Cmensaje = "El Ruc del Transporte es de la Empresa y el tipo de transporte debe ser Privado Tipo 02"
		Return 0
	Case Empty(This.ubigeocliente) And This.Tdoc = '09'
		This.Cmensaje = "Ingrese el Ubigeo del Punto de LLegada"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Grabarguiaremitente()
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			DEshacerCambios()
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasX(This.Fecha, This.ptop, Alltrim(This.ptoll), This.Idauto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.ubigeocliente)
	If nidg = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, nidg) = 0 Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.GeneraCorrelativo() = 1 And s = 1 Then
		If This.GRabarCambios() = 0 Then
			Return 0
		Endif
		If This.Proyecto = 'xsysz' Then
			This.Imprimirguiaxsysz("tmpvg", 'S')
		Else
			This.Imprimir('S')
		Endif
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
***
	Function grabarguiaremitentedirecta()
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto('09', 'E', This.Ndoc, This.Fecha, This.Fecha, "", 0, 0, 0, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasX(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.ubigeocliente)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If This.Proyecto = 'psysw' Or This.Proyecto = 'xmsys' Then
			nidkar = INGRESAKARDEX1(NAuto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0)
		Else
			nidkar = IngresaKardexGrifo(NAuto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, goApp.Tienda, 0, 0, 0)
		Endif
		If nidkar < 1 Then
			s = 0
			This.Cmensaje = "Al Ingresar al Kardex Detalle de Items"
			Exit
		Endif
		If GrabaDetalleGuias(nidkar, tmpvg.cant, nidg) = 0 Then
			s = 0
			This.Cmensaje = "Al Ingresar Detalle de Guia "
			Exit
		Endif
		If VerificaAlias("tramos") = 1
			Select * From tramos Where idart = tmpvg.coda  And Cantidad > 0  And Nitem = tmpvg.Nitem Into Cursor strasalidas
			If REgdvto("strasalidas") > 0 Then
				Select strasalidas
				Scan All
					If RegistraTramosSalidas(strasalidas.Cantidad, 'V', nidkar, strasalidas.idart, 0, strasalidas.idin) = 0 Then
						s = 0
						Exit
					Endif
				Endscan
			Endif
		Endif
		If ActualizaStock(tmpvg.coda, goApp.Tienda, tmpvg.cant, 'V') = 0 Then
			s = 0
			This.Cmensaje = "Al Actualizar Stock "
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If s = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GeneraCorrelativo() = 1 Then
		If This.GRabarCambios() = 0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasX(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
	Local lC, lp
	lC			  = "FUNINGRESAGUIAS"
	cur			  = "YY"
	goApp.npara1  = np1
	goApp.npara2  = np2
	goApp.npara3  = np3
	goApp.npara4  = np4
	goApp.npara5  = np5
	goApp.npara6  = np6
	goApp.npara7  = np7
	goApp.npara8  = np8
	goApp.npara9  = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
	ENDTEXT
	nidgg = This.EJECUTARf(lC, lp, cur)
	If nidgg < 1 Then
		Return 0
	Endif
	Return nidgg
	Endfunc
	Function GeneraCorrelativo()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	ocorr.Ndoc = This.Ndoc
	ocorr.Nsgte = This.Nsgte
	ocorr.Idserie = This.Idserie
	If ocorr.GeneraCorrelativo() < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function enviarasunat()
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	If goApp.Cdatos <> 'S' Then
		Cruc = fe_gene.nruc
		Cmulti = 'N'
	Else
		Cruc = Oempresa.nruc
		Cmulti = Iif(goApp.empresanube = 'rgm', 'S', '')
	Endif
	TEXT To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"idauto":<<this.idautog>>,
	"motivo":"<<this.motivo>>",
	"multiempresa":"<<cmulti>>",
	"empresa":"<<goapp.empresanube>>"
	}
	ENDTEXT
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenvio, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio " + Alltrim(This.urlenvio) + ' No Disponible' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
*!*		MESSAGEBOX(lcHTML)
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		This.Cmensaje = orpta.rpta
		If Left(orpta.rpta, 1) = '0' Then
			Return 1
		Else
			This.Cmensaje = orpta.rpta
			Return 0
		Endif
	Else
		This.Cmensaje = Alltrim(lcHTML)
		Return 0
	Endif
	Endfunc
	Function enviarservidor()
	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	Calias = 'c_' + Sys(2015)
	Do Case
	Case This.Motivo = 'V'
		If goApp.Cdatos <> 'S' Then
			TEXT To lC Noshow Textmerge
		    SELECT guia_ndoc AS ndoc,DATE_FORMAT(guia_fech,'%Y-%m-%d') AS fech,DATE_FORMAT(guia_fect,'%Y-%m-%d') AS fechat,
	        LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
	        a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
	        k.idart AS coda,k.prec,k.idkar,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
	        IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,
	        IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,
	        IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,c.nruc,c.ndni,
	        IFNULL(t.placa1,'') AS placa1,r.ndoc AS dcto,tdoc,r.idcliente,v.gene_usol,v.gene_csol,guia_ubig,
	        c.razo,guia_idgui AS idgui,r.idauto,c.dire,c.ciud,r.tdoc AS tdoc1,v.rucfirmad,gene_cert,clavecertificado as clavecerti,guia_moti,
	        v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo
	        FROM
	        fe_guias AS g
	        INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
	        INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	        INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	        INNER JOIN fe_kar AS k ON k.idkar=e.entr_idkar
	        INNER JOIN fe_art AS a ON a.idart=k.idart
	        LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
	        LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v WHERE guia_idgui=<<this.idautog>> and entr_acti='A'
			ENDTEXT
		Else
			TEXT To lC Noshow Textmerge
		    SELECT guia_ndoc AS ndoc,DATE_FORMAT(guia_fech,'%Y-%m-%d') AS fech,DATE_FORMAT(guia_fect,'%Y-%m-%d') AS fechat,
	        LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
	        a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
	        k.idart AS coda,k.prec,k.idkar,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
	        IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,
	        IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,
	        IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,c.nruc,c.ndni,
	        IFNULL(t.placa1,'') AS placa1,r.ndoc AS dcto,tdoc,r.idcliente,v.gene_usol,v.gene_csol,guia_ubig,
	        c.razo,guia_idgui AS idgui,r.idauto,c.dire,c.ciud,r.tdoc AS tdoc1,v.rucfirmad,gene_cert,clavecertificado as clavecerti,guia_moti,
	        v.razonfirmad,v.nruc AS rucempresa,v.nomb  AS empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciud AS ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo
	        FROM
	        fe_guias AS g
	        INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
	        INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	        INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	        INNER JOIN fe_kar AS k ON k.idkar=e.entr_idkar
	        INNER JOIN fe_art AS a ON a.idart=k.idart
	        LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
	        LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr
	        INNER JOIN fe_sucu AS v ON v.idalma=g.guia_codt WHERE guia_idgui=<<this.idautog>> and entr_acti='A'
			ENDTEXT
		Endif
	Case This.Motivo = 'C'
		TEXT To lC Noshow Textmerge
	    SELECT guia_ndoc AS ndoc,DATE_FORMAT(guia_fech,'%Y-%m-%d') AS fech,DATE_FORMAT(guia_fect,'%Y-%m-%d') AS fechat,
        LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
        a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
        e.entr_idar AS  coda,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
        IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,
        IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,
        IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,c.nruc,c.ndni,
        IFNULL(t.placa1,'') AS placa1,'09' AS tdoc,c.idprov,v.gene_usol,v.gene_csol,guia_ubig,'01' as tdoc1,
        c.razo,guia_idgui AS idgui,c.dire,c.ciud,v.rucfirmad,gene_cert,clavecertificado AS clavecerti,guia_moti,
        v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo
        FROM
        fe_guias AS g
        INNER JOIN fe_prov AS c ON c.idprov=g.guia_idpr
        INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
        INNER JOIN fe_art AS a ON a.idart=e.`entr_idar`
        LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
        INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v WHERE guia_idgui=<<this.idautog>> and entr_acti='A'
		ENDTEXT
	Case This.Motivo = 'T'
		TEXT To lC Noshow  Textmerge
	    SELECT guia_ndoc AS ndoc,DATE_FORMAT(guia_fech,'%Y-%m-%d') AS fech,DATE_FORMAT(guia_fect,'%Y-%m-%d') AS fechat,
        LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
        a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
        k.idart AS coda,k.prec,k.idkar,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
        IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,
        IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,
        IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,v.nruc,'' as ndni,
        IFNULL(t.placa1,'') AS placa1,guia_ndoc AS dcto,'09' AS tdoc,v.gene_usol,v.gene_csol,guia_ubig,
        v.empresa AS razo,guia_idgui AS idgui,'09' AS tdoc1,v.rucfirmad,gene_cert,clavecertificado as clavecerti,guia_moti,
        v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop AS ptop,
        v.ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo,tt.codigoestab AS codigo1,
        ttt.codigoestab AS codigo2,tt.ubigeo AS ubigeo1,ttt.ubigeo AS ubigeo2,'' as ciud,'' as dire
        FROM
        fe_guias AS g
        INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
        INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
        INNER JOIN fe_kar AS k ON k.idkar=e.entr_idkar
        INNER JOIN fe_art AS a ON a.idart=k.idart
        INNER JOIN fe_sucu AS tt ON tt.idalma=g.guia_codt
        INNER JOIN fe_sucu AS ttt ON ttt.idalma=r.ndo2
        LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
        INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v WHERE guia_idgui=<<this.idautog>> and entr_acti='A'
		ENDTEXT
	Case This.Motivo = 'D'
		TEXT To lC Noshow  Textmerge
            SELECT guia_ndoc AS ndoc,DATE_FORMAT(guia_fech,'%Y-%m-%d') AS fech,DATE_FORMAT(guia_fect,'%Y-%m-%d') AS fechat,
            LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
            a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
            a.idart AS  coda,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
            IFNULL(t.ructr,'') AS ructr,IFNULL(t.nombr,'') AS conductor,
            IFNULL(t.dirtr,'') AS direcciont,IFNULL(t.breve,'') AS brevete,
            IFNULL(t.cons,'') AS constancia,IFNULL(t.marca,'') AS marca,c.nruc,c.ndni,
            IFNULL(t.placa1,'') AS placa1,'09' AS tdoc,c.idprov,v.gene_usol,v.gene_csol,guia_ubig,'01' as tdoc1,
            c.razo,guia_idgui AS idgui,c.dire,c.ciud,v.rucfirmad,gene_cert,clavecertificado AS clavecerti,guia_moti,clavecertificado,
            v.razonfirmad,v.nruc AS rucempresa,v.empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciudad,v.distrito,t.tran_tipo
            FROM
            fe_guias AS g
            INNER JOIN fe_prov AS c ON c.idprov=g.guia_idpr
            INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
            inner join fe_kar as k on k.idkar=e.entr_idkar
            INNER JOIN fe_art AS a ON a.idart=k.`idart`
            LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
            INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v WHERE guia_idgui=<<this.idautog>> and entr_acti='A'
		ENDTEXT
	Case This.Motivo = 'O'
		TEXT To lC Noshow Textmerge
		    SELECT guia_ndoc AS ndoc,DATE_FORMAT(guia_fech,'%Y-%m-%d') AS fech,DATE_FORMAT(guia_fect,'%Y-%m-%d') AS fechat,
	        LEFT(guia_ndoc,4) AS serie,SUBSTR(guia_ndoc,5) AS numero,
	        a.descri,IFNULL(unid_codu,'NIU')AS unid,e.entr_cant AS cant,a.peso,g.guia_ptoll AS ptollegada,
	        k.idart AS coda,k.prec,k.idkar,g.guia_idtr,IFNULL(placa,'') AS placa,IFNULL(t.razon,'') AS razont,
	        t.ructr AS ructr,t.nomb AS conductor,t.dirtr AS direcciont,t.breve AS brevete,
	        t.cons AS constancia,t.marca AS marca,c.nruc,c.ndni,
	        IFNULL(t.placa1,'') AS placa1,r.ndoc AS dcto,tdoc,r.idcliente,v.gene_usol,v.gene_csol,guia_ubig,
	        c.razo,guia_idgui AS idgui,r.idauto,c.dire,c.ciud,r.tdoc AS tdoc1,v.rucfirmad,gene_cert,clavecertificado as clavecerti,guia_moti,
	        v.razonfirmad,v.nruc AS rucempresa,v.nomb  AS empresa,v.ubigeo,g.guia_ptop AS ptop,v.ciud AS ciudad,v.distrito,IFNULL(t.tran_tipo,'01') AS tran_tipo
	        FROM
	        fe_guias AS g
	        INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
	        INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	        INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	        INNER JOIN fe_kar AS k ON k.idkar=e.entr_idkar
	        INNER JOIN fe_art AS a ON a.idart=k.idart
	        LEFT JOIN fe_unidades AS u ON u.unid_codu=a.unid
	        INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
	        INNER JOIN fe_sucu AS v ON v.idalma=g.guia_codt WHERE guia_idgui=<<this.idautog>> and entr_acti='A'
		ENDTEXT
	Endcase
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
*Select * From (Calias) Into Table Addbs(Sys(5)+Sys(2003))+'guia.dbf'
	Select (Calias)
	nxml = rucempresa + '-09-' + Left(Ndoc, 4) + '-' + Substr(Ndoc, 5) + '.xml'
	Set Procedure To d:\Librerias\nfjsoncreate, d:\Librerias\nfcursortojson.prg, ;
		d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg, ;
		d:\Librerias\_.prg  Additive
*!*		cdata = nfcursortojson(.T.)
	Obj = Createobject("empty")
	With _(m.Obj)
		.brevete = brevete
		.ciud = ciud
		.ciudad = ciudad
		.conductor = conductor
		.clavecerti = clavecerti
		.Constancia = Constancia
		.Dire = Dire
		.direcciont = direcciont
		.distrito = distrito
		.empresa = empresa
		.fech = fech
		.fechat = fechat
		.gene_cert = gene_cert
		.gene_csol = gene_csol
		.Gene_usol = Gene_usol
		.guia_idtr = guia_idtr
		.guia_moti = guia_moti
		.guia_ubig = guia_ubig
		.idgui = idgui
		If This.Motivo = 'C' Or This.Motivo = 'D' Then
			.idprov = idprov
		Else
			.idprov = 0
		Endif
		.marca = marca
		.ndni = ndni
		.Ndoc = Ndoc
		.nruc = nruc
		.numero = numero
		.Placa = Placa
		.placa1 = placa1
		.ptollegada = ptollegada
		.ptop = ptop
		.Razo = Razo
		.razonfirmad = razonfirmad
		.razont = razont
		.rucempresa = rucempresa
		.rucfirmad = rucfirmad
		.ructr = ructr
		.Serie = Serie
		.Tdoc = Tdoc
		.Tdoc1 = Tdoc1
		.tran_tipo = tran_tipo
		.ubigeo = ubigeo
		If This.Motivo = 'T' Then
			.ubigeo1 = ubigeo1
			.ubigeo2 = ubigeo2
			.Codigo1 = Codigo1
			.codigo2 = codigo2
		Endif
		.lista = .newList()
		Scan All
			With .newItemFor( 'lista' )
				.Unid = Unid
				.Peso = Peso
				.Descri = Descri
				.coda = coda
				.cant = cant
			Endwith
		Endscan
	Endwith
	rutajson = Addbs(Sys(5) + Sys(2003)) + 'json.json'
	Strtofile(nfjsoncreate(m.Obj, .T.), rutajson)
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("POST", This.urlenviod, .F.)
	oHTTP.setRequestHeader("Content-Type ", "application/json")
	oHTTP.Send(nfjsoncreate(m.Obj, .T.))
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	conerror = 0
	Try
		orpta = nfJsonRead(lcHTML)
	Catch To loException
		This.Cmensaje = lcHTML
		conerror = 1
	Endtry
	If conerror = 0 Then
		If  Vartype(orpta.rpta) <> 'U' Then
			This.Cmensaje = orpta.rpta
			If Left(orpta.rpta, 1) = '0' Then
				XML = orpta.XML
				cdr = orpta.cdr
				crpta = orpta.rpta
				cticket = orpta.ticket
				TEXT To lC Noshow Textmerge
		         update fe_guias set guia_feen=curdate(),guia_arch='<<nxml>>',guia_xml='<<xml>>',guia_cdr='<<cdr>>',guia_mens='<<crpta>>',guia_tick='<<cticket>>' where guia_idgui=<<this.idautog>>
				ENDTEXT
				If This.Ejecutarsql(lC) < 1 Then
					Return 0
				Endif
			Else
				If Left(Trim(orpta.rpta), 5) = ' 1033' Then
					crpta = '0 ' + orpta.rpta
					TEXT To lC Noshow Textmerge
		             update fe_guias set guia_feen=curdate(),guia_arch='<<nxml>>',guia_mens='<<crpta>>' where guia_idgui=<<this.idautog>>
					ENDTEXT
					If This.Ejecutarsql(lC) < 1 Then
						Return 0
					Endif
				Endif
			Endif

		Else
			This.Cmensaje = Alltrim(lcHTML)
			Return 0
		Endif
		Return 1
	Else
		Return 0
	Endif
	Endfunc
	Function consultarticketservidor()
	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	TEXT To cdata Noshow Textmerge
	{
    "ticket":"<<TRIM(this.ticket)>>",
    "ruc":"<<cruc>>",
    "idauto":<<this.idautog>>,
    "gene_usol":"<<TRIM(fe_gene.gene_usol)>>",
    "gene_csol":"<<TRIM(fe_gene.gene_csol)>>",
    "ndoc":"<<this.ndoc>>"
    }
	ENDTEXT
*!*	    MESSAGEBOX(cdata)
	Set Procedure To d:\Librerias\nfcursortojson, d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg Additive
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlconsultacdr, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible " + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
*MESSAGEBOX(lcHTML)
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		This.Cmensaje = orpta.rpta
		If Left(orpta.rpta, 1) = '0' Then
			cdr = orpta.cdr
			crpta = orpta.rpta
			TEXT To lC Noshow Textmerge
		       update fe_guias set guia_feen=curdate(),guia_cdr='<<cdr>>',guia_mens='<<crpta>>' where guia_idgui=<<this.idautog>>
			ENDTEXT
			If This.Ejecutarsql(lC) < 1 Then
				Return 0
			Endif
		Endif
	Else
		This.Cmensaje = Alltrim(lcHTML)
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticketservidornube()
	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	TEXT To cdata Noshow Textmerge
	{
     "ticket":"<<TRIM(this.ticket)>>",
     "idauto":<<this.idautog>>,
      "ruc":"<<cruc>>",
     "ndoc":"<<this.ndoc>>"
    }
	ENDTEXT
* MESSAGEBOX(cdata)
	Set Procedure To d:\Librerias\nfcursortojson, d:\Librerias\nfcursortoobject, d:\Librerias\nfJsonRead.prg Additive
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlconsultacdrservidor, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta) <> 'U' Then
		This.Cmensaje = orpta.rpta
		Return 1
	Else
		This.Cmensaje = Alltrim(lcHTML)
		Return 0
	Endif
	Endfunc
	Function CreaTemporalGuiasElectronicasRodi(Calias)
	Set DataSession To This.Idsesion
	Create Cursor (Calias)(coda c(15), Descri c(80), Unid c(6), cant N(10, 2), Prec N(10, 2), uno N(10, 2), Dos N(10, 2), lote c(15), ;
		Peso N(10, 2), alma N(10, 2), Ndoc c(12), Nreg N(10), codc c(5), tref c(2), Refe c(12), fecr d, fechafactura d, ;
		calma c(3), Valida c, Nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), fech d, fect d, ptop c(150), ptoll c(120), Archivo c(120), Codigo c(15), ;
		razon c(120), nruc c(11), ndni c(8), conductor c(120), marca c(100), Placa c(20), placa1 c(20), Constancia c(20), brevete c(20), razont c(120), ructr c(11), ;
		Motivo c(1), Detalle c(100), tipotra c(15))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function CreaTemporalGuiasElectronicas(Calias)
	Create Cursor unidades(uequi N(7, 4), ucoda N(8), uunid c(60), uitem N(4), uprecio N(12, 6), ucosto N(8, 4), uidepta N(8), ucomi N(6, 3))
	Create Cursor (Calias)(coda N(8), duni c(20), Descri c(120), Unid c(20), cant N(10, 2), Prec N(10, 5), uno N(10, 2), Dos N(10, 2), lote c(15), ;
		Peso N(10, 2), alma N(10, 2), Ndoc c(12), Nreg N(10), codc c(5), tref c(2), Refe c(20), fecr d, Detalle c(120), fechafactura d, costo N(10, 3), Item N(8), ;
		calma c(3), Valida c, Nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), fech d, fect d, ptop c(150), ptoll c(120), Archivo c(120), valida1 c(1), ;
		razon c(120), nruc c(11), ndni c(8), conductor c(120), marca c(100), Placa c(15), placa1 c(15), Constancia c(30), equi N(8, 4), prem N(10, 4), pos N(3), idepta N(5), ;
		brevete c(20), razont c(120), ructr c(11), Motivo c(1), Codigo c(30), comi N(5, 3), idem N(8), Tigv N(5, 3), caant N(12, 2), nlote c(20), Fechavto d, tipotra c(15), Codigo1 c(30))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function listarguias(dfi, dff, nidt, Ccursor)
	dfi = cfechas(dfi)
	dff = cfechas(dff)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	    \      Select  fech,Ndoc,cliente,Detalle,Refe,Transportista,idguia,guia_arch,clie_corr,Motivo,guia_codt From(
        \      Select guia_fech As fech,guia_ndoc As Ndoc,c.Razo As cliente,guia_deta As Detalle,'' As Refe,
		\      IFNULL(T.razon,'') As Transportista,guia_idgui As idguia,guia_arch,clie_corr,'V' As Motivo,guia_codt From
		\      fe_guias As g
		\      INNER Join fe_rcom As r On r.Idauto=g.guia_idau
		\      INNER Join fe_clie As c On c.idclie=r.Idcliente
		\      Left Join fe_tra As T On T.idtra=g.guia_idtr
		\      Where Left(guia_ndoc,1)='T'  And guia_fech Between '<<dfi>>' And '<<dff>>'    And guia_moti='V' And guia_acti='A'
	If  nidt > 0 Then
        \And guia_codt=<<nidt>>
	Endif
        \      Union All
        \      Select guia_fech As fech,guia_ndoc As Ndoc,p.Razo As cliente,guia_deta As Detalle,'' As Refe,
	    \      IFNULL(T.razon,'') As Transportista,guia_idgui As idguia,guia_arch,email As clie_corr,'D' As Motivo,guia_codt From
	    \      fe_guias As g
		\      INNER Join fe_prov As p On p.idprov=g.guia_idpr
		\      Left Join fe_tra As T On T.idtra=g.guia_idtr
        \      Where Left(guia_ndoc,1)='T'   And guia_fech Between '<<dfi>>' And '<<dff>>'   And guia_moti='D'  And guia_acti='A'
	If  nidt > 0 Then
        \And guia_codt=<<nidt>>
	Endif
        \      Union All
        \      Select guia_fech As fech,guia_ndoc As Ndoc,p.Razo As cliente,guia_deta As Detalle,'' As Refe,
	    \      IFNULL(T.razon,'') As Transportista,guia_idgui As idguia,guia_arch,email As clie_corr,'C' As Motivo,guia_codt From
	    \      fe_guias As g
		\      INNER Join fe_prov As p On p.idprov=g.guia_idpr
		\      Left Join fe_tra As T On T.idtra=g.guia_idtr
        \      Where Left(guia_ndoc,1)='T'   And guia_fech Between '<<dfi>>' And '<<dff>>' And guia_moti='C' And guia_acti='A'
	If nidt > 0 Then
        \And guia_codt=<<nidt>>
	Endif
        \      Union All
        \      Select guia_fech As fech,guia_ndoc As Ndoc,g.empresa As cliente,guia_deta As Detalle,'' As Refe,
        \      IFNULL(T.razon,'') As Transportista,guia_idgui As idguia,guia_arch,g.correo As clie_corr,'T' As Motivo,guia_codt From fe_guias As a
        \      Left Join fe_tra As T On T.idtra=a.guia_idtr,fe_gene  As g
        \      Where  Left(guia_ndoc,1)='T'  And guia_fech Between '<<dfi>>' And '<<dff>>' And guia_moti='T' And guia_acti='A'
	If  nidt > 0 Then
        \And guia_codt=<<nidt>>
	Endif
       \ ) As w
        \      Group By fech,Ndoc,cliente,Detalle,Refe,Transportista,idguia,guia_arch,clie_corr,Motivo,guia_codt Order By fech
	Set Textmerge Off
	Set Textmerge To

*!*		TEXT TO lc NOSHOW TEXTMERGE
*!*			      fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,clie_corr,Motivo from(
*!*			      select
*!*			      fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,clie_corr,'V' as Motivo FROM  vguiasventas WHERE LEFT(ndoc,1)='T'
*!*	              and fech between '<<dfi>>' and '<<dff>>'
*!*	              union all
*!*	              SELECT fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,email as clie_corr,'D' as Motivo FROM  vguiasdevolucion
*!*	              WHERE LEFT(ndoc,1)<>'S' AND LEFT(ndoc,1)='T'   and fech between '<<dfi>>' and '<<dff>>'
*!*	              union all
*!*	              SELECT fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,email as clie_corr,'C' as Motivo FROM  vguiasrcompras
*!*	              WHERE LEFT(ndoc,1)<>'S' AND LEFT(ndoc,1)='T'  and fech between '<<dfi>>' and '<<dff>>'
*!*	              union all
*!*	              SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,guia_deta AS detalle,'' AS refe,
*!*	              IFNULL(t.razon,'') AS Transportista,guia_idgui AS idguia,guia_arch,g.correo AS clie_corr,'T' AS Motivo FROM fe_guias AS a
*!*	              LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
*!*	              WHERE LEFT(guia_ndoc,1)='T'  AND guia_fech BETWEEN '<<dfi>>' and '<<dff>>'  AND guia_moti='T' and guia_acti='A') as w
*!*	              group by fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,clie_corr,Motivo ORDER BY fech
*!*			ENDTEXT


*!*		Else
*!*			Text To lC Noshow Textmerge
*!*		          SELECT  fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,clie_corr,Motivo,guia_codt FROM(
*!*	              SELECT guia_fech AS fech,guia_ndoc AS ndoc,c.razo AS cliente,guia_deta AS detalle,'' AS refe,
*!*			      IFNULL(t.razon,'') AS Transportista,guia_idgui AS idguia,guia_arch,clie_corr,'V' AS motivo,guia_codt FROM
*!*			      fe_guias AS g
*!*			      INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
*!*			      INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
*!*			      LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr
*!*			      WHERE LEFT(guia_ndoc,1)='T'  AND guia_fech BETWEEN '<<dfi>>' and '<<dff>>'    AND guia_moti='V' AND guia_acti='A' and guia_codt=<<nidt>>
*!*	              UNION ALL
*!*	              SELECT guia_fech AS fech,guia_ndoc AS ndoc,p.razo AS cliente,guia_deta AS detalle,'' AS refe,
*!*		          IFNULL(t.razon,'') AS Transportista,guia_idgui AS idguia,guia_arch,email AS clie_corr,'D' AS motivo,guia_codt FROM
*!*		          fe_guias AS g
*!*			      INNER JOIN fe_prov AS p ON p.idprov=g.guia_idpr
*!*			      LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr
*!*	              WHERE LEFT(guia_ndoc,1)='T'   AND guia_fech BETWEEN '<<dfi>>' and '<<dff>>'   AND guia_moti='D'  AND guia_acti='A' and guia_codt=<<nidt>>
*!*	              UNION ALL
*!*	              SELECT guia_fech AS fech,guia_ndoc AS ndoc,p.razo AS cliente,guia_deta AS detalle,'' AS refe,
*!*		          IFNULL(t.razon,'') AS Transportista,guia_idgui AS idguia,guia_arch,email AS clie_corr,'D' AS motivo,guia_codt FROM
*!*		          fe_guias AS g
*!*			      INNER JOIN fe_prov AS p ON p.idprov=g.guia_idpr
*!*			      LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr
*!*	              WHERE LEFT(guia_ndoc,1)='T'   AND guia_fech BETWEEN '<<dfi>>' and '<<dff>>'    AND guia_moti='C' AND guia_acti='A' and guia_codt=<<nidt>>
*!*	              UNION ALL
*!*	              SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,guia_deta AS detalle,'' AS refe,
*!*	              IFNULL(t.razon,'') AS Transportista,guia_idgui AS idguia,guia_arch,g.correo AS clie_corr,'T' AS Motivo,guia_codt FROM fe_guias AS a
*!*	              LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
*!*	              WHERE  LEFT(guia_ndoc,1)='T'  AND guia_fech BETWEEN '<<dfi>>' and '<<dff>>' AND guia_moti='T' AND guia_acti='A' and guia_codt=<<nidt>>) AS w
*!*	              GROUP BY fech,ndoc,cliente,detalle,refe,Transportista,idguia,guia_arch,clie_corr,Motivo,guia_codt ORDER BY fech
*!*			Endtext
*!*		Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  Verificacantidadantesvtas()
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If Empty(This.Calias) Or !Used(This.Calias) Then
		goApp.mensajeApp = 'No  esta  Activo el Temporal de Guias'
		Return 0
	Endif
	Select Sum(coda)  As cant From (This.Calias) Where cant = 0 Into Cursor sincant
	If _Tally > 0 Then
		tcant = 0
	Else
		tcant = 1
	Endif
	Return tcant
	Endfunc
	Function Imprimirguiaxsysz(Calias, cestilo)
	ccodi = Space(3)
	Store 0 To m.nprec, m.tcant, m.Nitem
	CreaTemporalGuiasElectronicas('imp')
	Select Left(Codigo1, 5) As codi, Substr(Codigo1, 6, 5) As Color, Descri, Prec, cant,;
		Unid, Peso From (Calias) Where cant > 0 Into Cursor imprime Order By Descri, Prec, Color
	Sele imprime
	Go Top
	ni = 0
	Do While !Eof()
		cdesc = imprime.Descri
		nprec = imprime.Prec
		Store 0 To tcant
		m.Nitem = m.Nitem + 1
		x = 1
		ni = ni + 1
		Insert Into imp(Item, Descri, Ndoc)Values(m.Nitem, imprime.Descri, This.Ndoc)
		Do While !Eof() And Left(cdesc, (At('-', cdesc) - 1)) = Left(Descri, (At('-', imprime.Descri) - 1)) And nprec = imprime.Prec
			tcant = tcant + cant
			If x = 1
				Insert Into imp(Descri, cant, Prec, Ndoc, Unid, Peso)Values(imprime.codi + ' ' + imprime.Color + "(" + Ltrim(Str(imprime.cant, 3)) + ")", ;
					tcant, imprime.Prec, This.Ndoc, imprime.Unid, imprime.Peso)
				ni = ni + 1
			Else
				If x <= 7
					Sele imp
					Repla Descri With Alltrim(Descri) + ' ' + imprime.Color + "(" + Ltrim(Str(imprime.cant, 3)) + ")", ;
						cant With tcant, Prec With imprime.Prec
				Else
					Sele imp
					Repla cant With 0, Prec With 0
					Insert Into imp(Descri, cant, Prec, Ndoc, Unid, Peso)Values(imprime.codi + ' ' + imprime.Color + "(" + Ltrim(Str(imprime.cant, 3)) + ")", ;
						tcant, imprime.Prec, This.Ndoc, imprime.Unid, imprime.Peso)
					ni = ni + 1
					x = 1
				Endif
			Endif
			x = x + 1
			Sele imprime
			Skip
		Enddo
	Enddo
	If This.ticket <> 'S' Then
		For Y = 1 To This.Items - ni
			Insert Into imp(Ndoc)Values(This.Ndoc)
		Endfor
	Endif
	Sele imp
	Go Top
	Replace All fech With This.Fecha, Ndoc With This.Ndoc, ;
		fect With This.fechat, ptop With This.ptop, ;
		ptoll With This.ptoll, razon With This.razon, ;
		nruc With This.nruc, conductor With This.conductor, ;
		marca With This.marca, Placa With This.Placa, placa1 With This.placa1, ;
		Constancia With This.Constancia, brevete With This.brevete, ;
		razont With This.razont, ructr With This.ructr, Motivo With This.Motivo, ;
		tref With This.tref, Refe With This.Referencia, tipotra With This.tipotransporte;
		Ndoc With This.Ndoc, ndni With This.ndni, fechafactura With This.Fechafacturacompra, Detalle With This.Detalle  In imp
	Select imp
	Go Top In imp
	Set Order To
	Set Procedure To Imprimir Additive
	m.obji			  = Createobject("Imprimir")
	m.obji.Tdoc		  = '09'
	m.obji.ArchivoPdf = fe_gene.nruc + "-" + This.Tdoc  + "-" + Left(This.Ndoc, 4) + '-' + Substr(This.Ndoc, 5) + ".pdf"
	m.obji.ElijeFormatoM()
	Do Form ka_ldctosg To Verdad
	If cestilo = 'S' Then
		If This.ticket = 'S' Then
			m.obji.ImprimeComprobanteComoticketM('S','09')
		Else
			m.obji.ImprimeComprobanteM('S')
		Endif
	Else
		If This.ticket = 'S' Then
			m.obji.ImprimeComprobanteComoticketM('N', '09')
		Else
			m.obji.ImprimeComprobanteM('N')
			m.obji.GeneraPDF("S")
		Endif
	Endif
	Endfunc
Enddefine























