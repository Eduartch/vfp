# Define URL "http://companiasysven.com/"
Define Class guiaremision As Odata Of 'd:\capass\database\data'
	fecha				= ""
	fechat				= .F.
	referencia			= ""
	tref				= ""
	ptop				= ""
	ptoll				= ""
	idcliente			= 0
	razon				= ""
	nruc				= ""
	conductor			= ""
	marca				= ""
	placa				= ""
	brevete				= ""
	razont				= ""
	ructr				= ""
	Motivo				= ""
	idautog				= 0
	Idtransportista		= ""
	tipotransporte      =0
	detalle				= ""
	idauto				= ""
	ndoc				= ""
	Items				= ""
	titems				= 0
	constancia			= ""
	archivo				= ""
	Multiempresa		= ""
	nsgte				= 0
	idserie				= 0
	tdoc				= ""
	Cmulti				= ""
	Codigo				= 0
	Total				= ""
	fracciones			= .F.
	ndni				= ""
	tipocursor			= "1 Id Numerico 2 id Caracter"
	fechafacturacompra	= ""
	numerofacturacompra	= ""
	actualizaguia		= ""
	placa1				= ""
	fechafactura		= ""
	ndo2				= ""
	sucursal1			= 0
	sucursal2			= ""
	archivointerno		= "Nombre del Traspaso a Imprimir No ELECTRONICO"
	coningresosucursal	= "Para Ingresar a Sucursal"
	conseries			= ""
	conserieproductos	= ""
	nautor				= 0
	nidguia				= 0
	Calias				=""
	idvendedor			=0
	tpeso               =0
	mensajerptasunat    =""
	ubigeocliente       =""
	urlenvio            = URL+"app88/envioguia.php"
	urlenviod           = URL+"app88/envioguiadesktop.php"
	urlconsultacdr      = URL+"app88/envioticketguia.php"
	urlconsultacdrservidor=URL+"app88/envioticketnube.php"
	ticket              =""
	recibido            =""
	idprov              =0
	proyecto            =""
	codt                =0
	Function VerificaSiguiaVtaEstaIngresada(np1)
	Local lc
	TEXT To m.lc Noshow Textmerge
	   Select  guia_idgui As idauto   From fe_guias  Where guia_ndoc='<<np1>>'   And guia_acti = 'A' limit 1
	ENDTEXT
	If This.EjecutaConsulta(m.lc, 'Ig') < 1 Then
		Return 0
	Endif
	If ig.idauto > 0 Then
		This.Cmensaje='Número de Guia Ya Registrado'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaGuiasVtas(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lc, lp
*:Global cur
	m.lc		  ="ProActualizaGuiasVtas"
	cur			  =""
	goapp.npara1  =m.np1
	goapp.npara2  =m.np2
	goapp.npara3  =m.np3
	goapp.npara4  =m.np4
	goapp.npara5  =m.np5
	goapp.npara6  =m.np6
	goapp.npara7  =m.np7
	goapp.npara8  =m.np8
	goapp.npara9  =m.np9
	goapp.npara10 =This.idautog
	goapp.npara11 =m.np11
	goapp.npara12 =m.np12
	goapp.npara13= This.ubigeocliente
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?this.idautog,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function  ActualizaDetalleGuiaCons1(np1, np2, np3, np4, np5, np6, np7)
	Local lc, lp
*:Global cur
	cur			 =""
	m.lc		 ='ProActualizaDetalleGuiasCons'
	goapp.npara1 =m.np1
	goapp.npara2 =m.np2
	goapp.npara3 =m.np3
	goapp.npara4 =m.np4
	goapp.npara5 =m.np5
	goapp.npara6 =m.np6
	goapp.npara7 =m.np7
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaDetalleGuiasVtas(ccursor)
	Sw=1
	Select (m.ccursor)
	Set Filter To coda<>0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc=Alltrim(tmpvg.Descri)
		If Deleted()
			If nreg > 0 Then
				If ActualizaStock12(tmpvg.coda, tmpvg.alma, tmpvg.cant, 'C', tmpvg.equi, tmpvg.caant) = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Actualizar Stock -  " + Alltrim(cdesc)
					Exit
				Endif
				If ActualizakardexUAl(This.idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, tmpvg.alma, 0, tmpvg.nreg, 0, tmpvg.equi, tmpvg.unid, tmpvg.idepta, 0, tmpvg.pos, tmpvg.costo, tmpvg.tigv) = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso de Item - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nreg, This.idautog, 0, '') = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If fe_gene.alma_nega = 0 And tmpvg.tipro = 'K' Then
				If DevuelveStocks2(tmpvg.coda, calma, "st") < 1 Then
					Sw			  =0
					This.Cmensaje ="Al Obtener Stock - " + Alltrim(cdesc)
					Exit
				Endif
				If (tmpvg.cant * tmpvg.equi) > (Iif(goapp.tienda = 1, st.uno + tmpvg.caant, st.Dos + tmpvg.caant))
					Sw			  =0
					This.Cmensaje ="Al Obtener Stock " + Alltrim(cdesc)
					Exit
				Endif
			Endif
			If tmpvg.nreg = 0 Then
				nidkar= IngresaKardexUAl(This.idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goapp.tienda, 0, 0, tmpvg.equi, tmpvg.unid, tmpvg.idepta, tmpvg.pos, tmpvg.costo, tmpvg.tigv)
				If nidkar = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Registrar Producto - " + Alltrim(cdesc)
					Exit
				Endif
				If GrabaDetalleGuias(nidkar, tmpvg.cant, This.idautog) = 0 Then
					s			  =0
					This.Cmensaje ="Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If ActualizakardexUAl(This.idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goapp.tienda, 0, tmpvg.nreg, 1, tmpvg.equi, tmpvg.unid, tmpvg.idepta, 0, tmpvg.pos, tmpvg.costo, tmpvg.tigv) < 1 Then
					Sw			  =0
					This.Cmensaje ="Al Actualizar Kardex  - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nreg, This.idautog, 1, '') < 1 Then
					Sw			  =0
					This.Cmensaje =Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
			If ActualizaStock12(tmpvg.coda, goapp.tienda, tmpvg.cant, 'V', tmpvg.equi, tmpvg.caant) = 0 Then
				Sw			  =0
				This.Cmensaje ="Al Actualizar Stock " + Alltrim(cdesc)
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
	If This.ActualizaResumenDcto('09', 'E', This.ndoc, This.fecha, This.fecha, "", 0, 0, 0, "", 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goapp.nidusua, 1, goapp.tienda, 0, 0, 0, 0, 0, This.nautor) < 1 Then
		Return 0
	Endif
	If This.ActualizaGuiasVtas(This.fecha, This.ptop, This.ptoll, This.nautor, This.fechat, goapp.nidusua, This.detalle, This.Idtransportista, This.ndoc, This.idautog, goapp.tienda, This.Codigo) < 1
		Return 0
	Endif
	Return 1
	Endfunc
************************
	Function ActualizaResumenDcto(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	Local lc, lp
*:Global cur
	m.lc		  ='ProActualizaCabeceraCV'
	cur			  =""
	goapp.npara1  =m.np1
	goapp.npara2  =m.np2
	goapp.npara3  =m.np3
	goapp.npara4  =m.np4
	goapp.npara5  =m.np5
	goapp.npara6  =m.np6
	goapp.npara7  =m.np7
	goapp.npara8  =m.np8
	goapp.npara9  =m.np9
	goapp.npara10 =m.np10
	goapp.npara11 =m.np11
	goapp.npara12 =m.np12
	goapp.npara13 =m.np13
	goapp.npara14 =m.np14
	goapp.npara15 =m.np15
	goapp.npara16 =m.np16
	goapp.npara17 =m.np17
	goapp.npara18 =m.np18
	goapp.npara19 =m.np19
	goapp.npara20 =m.np20
	goapp.npara21 =m.np21
	goapp.npara22 =m.np22
	goapp.npara23 =m.np23
	goapp.npara24 =m.np24
	goapp.npara25 =m.np25
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function imprimir(cestilo)
	Local obji As "Imprimir"
	Replace All ndoc With This.ndoc In tmpvg
	Do Form ka_ldctosg To verdad
	Select Count(*) As ti From tmpvg Into Cursor xitems
	Select tmpvg
	For x = 1 To This.Items - xitems.ti
		Insert Into tmpvg(ndoc)Values(This.ndoc)
	Next
	Replace All fech With This.fecha, ndoc With This.ndoc, ;
		fect With This.fechat, ptop With This.ptop, ;
		ptoll With This.ptoll, razon With This.razon, ;
		nruc With This.nruc, conductor With This.conductor, ;
		marca With This.marca, placa With This.placa, placa1 With This.placa1, ;
		constancia With This.constancia, brevete With This.brevete, ;
		razont With This.razont, ructr With This.ructr, Motivo With This.Motivo, ;
		tref With This.tref, Refe With This.referencia, archivo With This.archivo, ;
		ndoc With This.ndoc, ndni With This.ndni, fechafactura With This.fechafacturacompra, detalle With This.detalle  In tmpvg
*	Wait Window 'hola xxxx'
	ctdoc=IIF(LEFT(this.ndoc,1)='T','TT','09')
	If This.Cmulti = 'S' Then
		carpdf=oempresa.nruc + "-"+ctdoc+"-" + Left(This.ndoc, 4) + '-' + Substr(This.ndoc, 5) + ".Pdf"
	Else
		carpdf=fe_gene.nruc + "-"+ctdoc+"-" + Left(This.ndoc, 4) + '-' + Substr(This.ndoc, 5) + ".Pdf"
	Endif
	Select tmpvg
	Go Top In tmpvg
	Set Order To
	Set Filter To
	Set Procedure To imprimir Additive
	m.obji			  =Createobject("Imprimir")
	m.obji.tdoc		  = IIF(EMPTY(this.tdoc),'09',this.tdoc)
	m.obji.ArchivoPdf =carpdf
	m.obji.ElijeFormatoM()
	Do Case
	Case m.cestilo = 'S'
		m.obji.GeneraPDF("")
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
	This.contransaccion='S'
	If This.IniciaTransaccion() = 0
		This.contransaccion=''
		Return 0
	Endif
	If This.ActualizaGuiasVtas(This.fecha, This.ptop, This.ptoll, This.nautor, This.fechat, goapp.nidusua, This.detalle, This.Idtransportista, This.ndoc, This.idautog, goapp.tienda, This.Codigo) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtasR(This.Calias) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.GrabarCambios() = 0 Then
		This.contransaccion=""
		Return 0
	Endif
	This.imprimir('S')
	Return 1
	Endfunc
	Function ActualizaDetalleGuiasVtasR(ccursor)
*:Global cdesc, nidkar, s, sw
	Sw=1
*	WAIT WINDOW 'hola' +ccursor
	Select (m.ccursor)
	Set Filter To coda<>0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc=Alltrim(tmpvg.Descri)
		If Deleted()
			If nreg > 0 Then
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.idautog, 0, '') = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If tmpvg.nreg = 0 Then
				If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, This.idautog) = 0 Then
					s			  =0
					This.Cmensaje ="Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.idautog, 1, '') = 0 Then
					Sw			  =0
					This.Cmensaje =Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
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
	This.contransaccion='S'
	If This.IniciaTransaccion() = 0
		This.contransaccion=''
		Return 0
	Endif
	If This.ActualizaCabeceraGuiaventasdirectas() < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtasGrifos(This.Calias) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.GrabarCambios() = 0 Then
		This.contransaccion=""
		Return 0
	Endif
	This.imprimir('S')
	Return 1
	Endfunc
	Function ActualizaDetalleGuiasVtasGrifos(ccursor)
	Sw=1
	Select (m.ccursor)
	Set Filter To coda<>0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc=Alltrim(tmpvg.Descri)
		If Deleted()
			If nreg > 0 Then
				If ActualizaStock11(tmpvg.coda, tmpvg.alma, tmpvg.cant, 'C', tmpvg.caant) = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Actualizar Stock -  " + Alltrim(cdesc)
					Exit
				Endif
				If Actualizakardex1(This.idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', 0, tmpvg.alma, 0, tmpvg.nreg, 0,0) = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso de Item - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nreg, This.idautog, 0, '') = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If tmpvg.nreg = 0 Then
				nidkar= IngresaKardexGrifo(This.idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goapp.tienda, 0, 0)
				If nidkar = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Registrar Producto - " + Alltrim(cdesc)
					Exit
				Endif
				If GrabaDetalleGuias(nidkar, tmpvg.cant, This.idautog) = 0 Then
					s			  =0
					This.Cmensaje ="Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If Actualizakardex1(This.idauto, tmpvg.coda, 'V', tmpvg.Prec, tmpvg.cant, 'I', 'K', This.idvendedor, goapp.tienda, 0, tmpvg.nreg, 1,1) < 1 Then
					Sw			  =0
					This.Cmensaje ="Al Actualizar Kardex  - " + Alltrim(cdesc)
					Exit
				Endif
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nreg, This.idautog, 1, '') = 0 Then
					Sw			  =0
					This.Cmensaje =Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
			If ActualizaStock11(tmpvg.coda, goapp.tienda, tmpvg.cant, 'V', tmpvg.caant) = 0 Then
				Sw			  =0
				This.Cmensaje ="Al Actualizar Stock " + Alltrim(cdesc)
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
	Function validar()
	TEXT TO lc NOSHOW TEXTMERGE
     select guia_idgui as idauto FROM fe_guias WHERE guia_ndoc='<<this.ndoc>>' AND guia_acti='A' limit 1
	ENDTEXT
	If This.EjecutaConsulta(lc,'Ig')<1 Then
		Return 0
	Endif
	If ig.idauto>0 Then
		cencontrado='S'
	Else
		cencontrado='N'
	Endif
	If This.proyecto<>'psysr'
		If  Verificacantidadantesvtas(This.Calias)=0
			This.Cmensaje="Ingrese Cantidad es Obligatorio"
			Return 0
		Endif
	Else
		If Verificacantidadantesvtasbat(This.Calias)=0
			This.Cmensaje="Ingrese Cantidad es Obligatorio"
			Return 0
		Endif
	Endif
	Do Case
	Case cencontrado='S' And This.idautog=0
		This.Cmensaje="NÚMERO de Guia de Remisión Ya Registrado"
		Return 0
	Case Left(This.ndoc,4)="0000"  Or Val(Substr(This.ndoc,4)) =0
		This.Cmensaje="Ingrese NÚMERO de Guia Remitente Válido"
		Return 0
	Case Len(Alltrim(Left(This.ndoc,4)))<4 Or Len(Alltrim(Substr(This.ndoc,4)))<8
		This.Cmensaje="Ingrese el Nº de la Guia de Remisión"
		Return  0
	Case !esfechavalida(This.fecha)
		This.Cmensaje="La Fecha de emisón no es Válida"
		Return 0
*!*		Case !esfechavalida(This.fechat)
*!*			This.Cmensaje="La Fecha de emisón no es Válida"
*!*			Return 0
	Case  This.fechat< This.fecha
		This.Cmensaje="La Fecha de Traslado No Puede Ser Antes que la Fecha de Emisión"
		Return 0
	Case Len(Alltrim(This.ptoll))=0
		This.Cmensaje="Ingrese La dirección de LLegada"
		Return 0
	Case Len(Alltrim(This.ptop))=0
		This.Cmensaje="Ingrese La dirección de Partida"
		Return 0
	Case  This.tref='03' And Len(Alltrim(This.nruc))<>8
		This.Cmensaje="Ingrese el documento del Destinatario"
		Return 0
	Case This.tref='01' And !validaruc(This.nruc)
		This.Cmensaje="Ingrese el documento del Destinatario"
		Return 0
	Case Left(This.mensajerptasunat,1)='0'
		This.Cmensaje="Este Documento Ya esta Informado a SUNAT no es posible Actualizar"
		Return 0
	Case This.tpeso=0 And This.tdoc='09'
		This.Cmensaje="El Peso de los Productos es Obligatorio"
		Return 0
	Case This.Idtransportista=0 And This.tdoc='09'
		This.Cmensaje="El Transportista es Obligatorio"
		Return 0
	Case (Empty(.txtrazont.Value) Or Len(Alltrim(This.ructr))<>11 Or  Len(Alltrim(This.constancia))=0) And This.tipotransporte='01' And This.tdoc='09'
		This.Cmensaje="Es obligatorio el RUC, el Nombre y el Registro MTC"
		Return 0
	Case Empty(.txtrazont.Value) And Len(Alltrim(This.ructr))<>11 And This.tipotransporte='02' And Len(Alltrim(This.brevete))<>9 And Len(Alltrim(This.conductor))=0 And This.tdoc='09'
		This.Cmensaje="Es obligatorio el nombre de Chofer y Brevete"
		Return 0
	Case This.tipotransporte='02' And (!Isalpha(Left(This.brevete,1))  Or  !Isdigit(Substr(This.brevete,2))) And This.tdoc='09'
		This.Cmensaje="El Brevete no es Válido... empieza con una Letra y lo demás son digitos"
		Return 0
	Case Empty(This.ubigeocliente)
		This.Cmensaje="Ingrese el Ubigeo del Punto de LLegada"
		Return 0
*!*		Case Verificacantidadantesvtas(This.Calias)=0
*!*			This.Cmensaje="Ingrese Cantidad es Obligatorio"
*!*			Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Grabarguiaremitente()
	If This.IniciaTransaccion()=0 Then
		Return 0
	Endif
	If This.idautog>0 Then
		If AnulaGuiasVentas(This.idautog,goapp.nidusua)=0 Then
			DeshacerCambios()
			Return 0
		Endif
	Endif

	nidg=This.IngresaGuiasX(This.fecha,This.ptop,Alltrim(This.ptoll),This.idauto,This.fechat,goapp.nidusua,This.detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.ubigeocliente)
	If nidg=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s=1
	Do While !Eof()
		If GrabaDetalleGuias(tmpvg.nidkar,tmpvg.cant,nidg)=0 Then
			s=0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.generacorrelativo()=1 And s=1 Then
		If This.GrabarCambios()=0 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DeshacerCambios()
		Return 0
	Endif
	Endfunc
***
	Function grabarguiaremitentedirecta()
	If This.IniciaTransaccion()=0 Then
		Return 0
	Endif
	nauto=IngresaResumenDcto('09','E',This.ndoc,This.fecha,This.fecha,"",0,0,0,'','S',fe_gene.dola,fe_gene.igv,'k',This.Codigo,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0)
	If nauto<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	nidg=This.IngresaGuiasX(This.fecha,This.ptop,This.ptoll,nauto,This.fechat,goapp.nidusua,This.detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.ubigeocliente)
	If nidg=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s=1
	Do While !Eof()
		If This.proyecto='psysw' Then
			nidkar=INGRESAKARDEX1(nauto,tmpvg.coda,'V',tmpvg.Prec,tmpvg.cant,'I','K',0,goapp.tienda,0)
		Else
			nidkar=IngresaKardexGrifo(nauto,tmpvg.coda,'V',tmpvg.Prec,tmpvg.cant,'I','K',0,goapp.tienda,0,0,0)
		Endif
		If nidkar<1 Then
			s=0
			This.Cmensaje="Al Ingresar al Kardex Detalle de Items"
			Exit
		Endif
		If GrabaDetalleGuias(nidkar,tmpvg.cant,nidg)=0 Then
			s=0
			This.Cmensaje="Al Ingresar Detalle de Guia "
			Exit
		Endif
		If ActualizaStock(tmpvg.coda,goapp.tienda,tmpvg.cant,'V')=0 Then
			s=0
			This.Cmensaje="Al Actualizar Stock "
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If s=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If  This.generacorrelativo()=1 Then
		If This.GrabarCambios()=0 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DeshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasX(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10,np11)
	Local lc, lp
	lc			  = "FUNINGRESAGUIAS"
	cur			  = "YY"
	goapp.npara1  = np1
	goapp.npara2  = np2
	goapp.npara3  = np3
	goapp.npara4  = np4
	goapp.npara5  = np5
	goapp.npara6  = np6
	goapp.npara7  = np7
	goapp.npara8  = np8
	goapp.npara9  = np9
	goapp.npara10 = np10
	goapp.npara11 = np11
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
	ENDTEXT
	nidgg=This.EJECUTARF(lc, lp, cur)
	If nidgg<1 Then
		Return 0
	Endif
	Return nidgg
	Endfunc
	Function generacorrelativo()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr=Createobject("correlativo")
	ocorr.ndoc=This.ndoc
	ocorr.nsgte=This.nsgte
	ocorr.idserie=This.idserie
	If ocorr.generacorrelativo()<1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function enviarasunat()
	If Type('oempresa') = 'U' Then
		cruc=fe_gene.nruc
	Else
		cruc=oempresa.nruc
	Endif
	TEXT To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"idauto":<<this.idautog>>,
	"motivo":"<<this.motivo>>"
	}
	ENDTEXT
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenvio, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status<>200 Then
		This.Cmensaje="Servicio "+Alltrim(This.urlenvio)+ ' No Disponible' +Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.Responsetext
	Set Procedure To d:\librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta)<>'U' Then
		This.Cmensaje=orpta.rpta
		If Left(orpta.rpta,1)='0' Then
			Return 1
		Else
			This.Cmensaje=orpta.rpta
			Return 0
		Endif
	Else
		This.Cmensaje=Alltrim(lcHTML)
		Return 0
	Endif
	Endfunc
	Function enviarservidor()
	Calias= 'c_'+Sys(2015)
	Do Case
	Case This.Motivo='V'
		If goapp.cdatos<>'S' Then
			TEXT TO lc NOSHOW textmerge
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
	        LEFT JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v WHERE guia_idgui=<<this.idautog>>
			ENDTEXT
		Else
			TEXT TO lc NOSHOW textmerge
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
	        INNER JOIN fe_sucu AS v ON v.idalma=g.guia_codt WHERE guia_idgui=<<this.idautog>>
			ENDTEXT
		Endif
	Case This.Motivo='C'
		TEXT TO lc NOSHOW textmerge
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
        INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr,fe_gene AS v WHERE guia_idgui=<<this.idautog>>
		ENDTEXT
	Endcase
	If This.EjecutaConsulta(lc,Calias)<1 Then
		Return 0
	Endif
*Select * From (Calias) Into Table Addbs(Sys(5)+Sys(2003))+'guia.dbf'
	Select (Calias)
	nxml=rucempresa+'-09-'+Left(ndoc,4)+'-'+Substr(ndoc,5)+'.xml'
	Set Procedure To d:\librerias\nfcursortojson,d:\librerias\nfcursortoobject,d:\librerias\nfJsonRead.prg Additive
	cdata=nfcursortojson(.T.)
	rutajson=Addbs(Sys(5)+Sys(2003))+'json.json'
	Strtofile (cdata,rutajson)
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlenviod, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status<>200 Then
		This.Cmensaje="Servicio WEB NO Disponible....."+Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.Responsetext
*	MESSAGEBOX(lcHTML)
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta)<>'U' Then
		This.Cmensaje=orpta.rpta
		If Left(orpta.rpta,1)='0' Then
			XML=orpta.XML
			cdr=orpta.cdr
			crpta=orpta.rpta
			cticket=orpta.ticket
			TEXT TO lc NOSHOW TEXTMERGE
		       update fe_guias set guia_feen=curdate(),guia_arch='<<nxml>>',guia_xml='<<xml>>',guia_cdr='<<cdr>>',guia_mens='<<crpta>>',guia_tick='<<cticket>>' where guia_idgui=<<this.idautog>>
			ENDTEXT
			If This.ejecutarsql(lc)<1 Then
				Return 0
			Endif
		Endif
	Else
		This.Cmensaje=Alltrim(lcHTML)
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticketservidor()
	If Type('oempresa') = 'U' Then
		cruc=fe_gene.nruc
	Else
		cruc=oempresa.nruc
	Endif
	TEXT TO cdata NOSHOW TEXTMERGE
	{
    "ticket":"<<TRIM(this.ticket)>>",
    "ruc":"<<cruc>>",
    "idauto":<<this.idautog>>,
    "gene_usol":"<<TRIM(fe_gene.gene_usol)>>",
    "gene_csol":"<<TRIM(fe_gene.gene_csol)>>",
    "ndoc":"<<this.ndoc>>"
    }
	ENDTEXT
* MESSAGEBOX(cdata)
	Set Procedure To d:\librerias\nfcursortojson,d:\librerias\nfcursortoobject,d:\librerias\nfJsonRead.prg Additive
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlconsultacdr , .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status<>200 Then
		This.Cmensaje="Servicio WEB NO Disponible....."+Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.Responsetext
*MESSAGEBOX(lcHTML)
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta)<>'U' Then
		This.Cmensaje=orpta.rpta
		If Left(orpta.rpta,1)='0' Then
			cdr=orpta.cdr
			crpta=orpta.rpta
			TEXT TO lc NOSHOW TEXTMERGE
		       update fe_guias set guia_feen=curdate(),guia_cdr='<<cdr>>',guia_mens='<<crpta>>' where guia_idgui=<<this.idautog>>
			ENDTEXT
			If This.ejecutarsql(lc)<1 Then
				Return 0
			Endif
		Endif
	Else
		This.Cmensaje=Alltrim(lcHTML)
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticketservidornube()
	If Type('oempresa') = 'U' Then
		cruc=fe_gene.nruc
	Else
		cruc=oempresa.nruc
	Endif
	TEXT TO cdata NOSHOW TEXTMERGE
	{
     "ticket":"<<TRIM(this.ticket)>>",
     "idauto":<<this.idautog>>,
      "ruc":"<<cruc>>",
     "ndoc":"<<this.ndoc>>"
    }
	ENDTEXT
* MESSAGEBOX(cdata)
	Set Procedure To d:\librerias\nfcursortojson,d:\librerias\nfcursortoobject,d:\librerias\nfJsonRead.prg Additive
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlconsultacdrservidor , .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status<>200 Then
		This.Cmensaje="Servicio WEB NO Disponible....."+Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.Responsetext
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.rpta)<>'U' Then
		This.Cmensaje=orpta.rpta
		Return 1
	Else
		This.Cmensaje=Alltrim(lcHTML)
		Return 0
	Endif
	Endfunc
	Function CreaTemporalGuiasElectronicasRodi(Calias)
	Set DataSession To This.idsesion
	Create Cursor (Calias)(coda c(15),Descri c(80),unid c(6),cant N(10,2),Prec N(10,2),uno N(10,2),Dos N(10,2),lote c(15),;
		peso N(10,2),alma N(10,2),ndoc c(12),nreg N(10),codc c(5),tref c(2),Refe c(12),fecr d,fechafactura d,;
		calma c(3),Valida c,nitem N(3),saldo N(10,2),idin N(8),nidkar N(10),coda1 c(15),fech d,fect d,ptop c(150),ptoll c(120),archivo c(120),Codigo c(15),;
		razon c(120),nruc c(11),ndni c(8),conductor c(120),marca c(100),placa c(20),placa1 c(20),constancia c(20),brevete c(20),razont c(120),ructr c(11),Motivo c(1),detalle c(100))
	Select (Calias)
	Index On Descri Tag Descri
	Index On nitem Tag Items
	Endfunc
Enddefine
