Define Class guiaremisionxtraspaso As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function Grabar()
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
		If AnulaTransaccionConMotivo('', '', 'V', This.Idauto, goApp.Idusua, '', This.Fecha, goApp.nidusua, 'Actualización') = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	NAuto = IngresaResumenTraspasos(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', ;
		  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat, ;
		  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Fracciones = 'U' Then
		If This.grabadetalleguiau(NAuto) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If This.Grabardetalleguiatraspaso(NAuto) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If  This.GeneraCorrelativo() = 1  Then
		If 	GRabarCambios() = 0 Then
			Return 0
		Endif
		If This.Tdoc = '09' And goApp.Emisorguiasremisionelectronica = 'S' Then
			Select * From tmpv Into Cursor tmpvg Readwrite
			This.Imprimir('S')
			Return 1
		Else
			Report Form (This.Archivointerno) To Printer Prompt Noconsole
			Return  1
		Endif
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function Actualizar()
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaResumenTraspasos(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', ;
			  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0, 'P', This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If DesactivaDtraspaso(This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif

	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, This.Idauto, This.fechat, ;
		  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Fracciones = 'U' Then
		If This.grabadetalleguiau(This.Idauto) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If This.Grabardetalleguiatraspaso(This.Idauto) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	If This.Tdoc = '09' And goApp.Emisorguiasremisionelectronica = 'S' Then
		Select * From tmpv Into Cursor tmpvg Readwrite
		This.Imprimir('S')
	Else
		Report Form (This.Archivointerno) To Printer Prompt Noconsole
	Endif
	Return  1
	Endfunc
	Function IngresaGuiasXTraspaso(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	Local lC, lp
*:Global cur
	lC			  = "FUNINGRESAGUIAST"
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?this.ubigeocliente)
	Endtext
	nidg = This.EJECUTARf(lC, lp, cur)
	If nidg < 1 Then
		Return 0
	Endif
	Return nidg
	Endfunc
	Function validarguia()
	Do Case
	Case  This.recibido = 'E'
		This.Cmensaje = "NO es Posible Actualizar este Traspaso Porque ya esta Recibido"
		Return 0
	Case This.sucursal1 = 0 Or This.sucursal2 = 0
		This.Cmensaje = "Seleccione al Tienda/Almacen de Ingreso y Salida"
		Return 0
	Case This.sucursal1 = This.sucursal2
		This.Cmensaje = "La Transferencia Debe ser entre almacenes Diferentes"
		Return 0
	Endcase
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Grabardetalleguiatraspaso(NAuto)
	Local Obj As SerieProducto
	rn = "d:\reglasnegocio\rnw.prg"
	Set Procedure To CapaDatos, (rn) Additive
	Obj = Createobject("serieproducto")
	Select tmpv
	Go Top
	Sw = 1
	Do While !Eof()
		If DevuelveStocks1(tmpv.coda, This.sucursal1, "St") < 1 Then
			Sw = 0
			This.Cmensaje = 'Al Obtener Stock'
			Exit
		Endif
		If tmpv.cant > st.saldo Then
			Sw = 0
			This.Cmensaje = 'Stock NO Disponible'
			Exit
		Endif
		If This.Conseries = 'S' Then
			nidk = IngresaDtraspasos(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 0, 'T', This.Detalle, This.sucursal1, This.sucursal2, 0)
			If nidk < 1 Then
				Sw = 0
				This.Cmensaje = 'Al Obtener ID del Kardex'
				Exit
			Endif
			If !Empty(tmpv.SerieProducto) Then
				Obj.AsignaValores(tmpv.SerieProducto, NAuto, nidk, tmpv.coda)
				If Obj.RegistraDseries(tmpv.Idseriep) <= 0 Then
					Sw = 0
					This.Cmensaje = 'Al Obtener ID del Kardex'
					Exit
				Endif
			Endif
		Else
			nidk = IngresaDtraspasos(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 0, 'T', This.Detalle, This.sucursal1, This.sucursal2, 0)
			If nidk = 0 Then
				Sw = 0
				This.Cmensaje = 'Al Obtener ID del Kardex'
				Exit
			Endif
		Endif
		If GrabaDetalleGuias(nidk, tmpv.cant, nidg) = 0 Then
			Sw = 0
			This.Cmensaje = 'Al Registrar Detalle'
			Exit
		Endif
		If This.Coningresosucursal = 'S' Then
			If IngresaDtraspasos(NAuto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 0, 'T', This.Detalle, This.sucursal2, This.sucursal1, 0) = 0 Then
				Sw = 0
				This.Cmensaje = 'Al Obtener ID del Kardex'
				Exit
			Endif
			If ActualizaStock(tmpv.coda, This.sucursal2, tmpv.cant, 'C') < 0 Then
				Sw = 0
				This.Cmensaje = 'Al Actualizar Stock'
				Exit
			Endif
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, 'V') < 0 Then
			Sw = 0
			This.Cmensaje = 'Al Actualizar Stock'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	Return Sw
	Endfunc
	Function grabarRodi()
	Set DataSession To This.Idsesion
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenTraspasos(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', ;
		  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto <= 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat, ;
		  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpv
	Go Top
	Do While !Eof()
		If Empty(tmpv.coda)
			Select tmpv
			Skip
			Loop
		Endif
		ctipo = "V"
		nidkar = INGRESAKARDEXT(NAuto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 'T', This.Detalle, This.sucursal2, 0, 0)
		If nidkar = 0 Then
			Sw = 0
			Cmensaje = 'Al Registrar en Tienda 1'
			Exit
		Endif
		If INGRESAKARDEXT(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'T', This.Detalle, This.sucursal1, 0, 0) = 0 Then
			Sw = 0
			Exit
			Cmensaje = 'Al Registrar en Tienda 2'
		Endif
		If GrabaDetalleGuias(nidkar, tmpv.cant, nidg) = 0 Then
			Sw = 0
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, "V") <= 0 Then
			Sw = 0
			Cmensaje = 'Al Actualizar Tienda 1'
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal2, tmpv.cant, "C") <= 0 Then
			Sw = 0
			Cmensaje = 'Al Actualizar Tienda 2'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If  This.GeneraCorrelativo() = 1  Then
		If 	GRabarCambios() = 0 Then
			Return 0
		Endif
		If This.Tdoc = '09'  Then
			Select * From tmpv Into Cursor tmpvg Readwrite
			This.Imprimir('S')
			Return 1
		Else
			Report Form (This.Archivointerno) To Printer Prompt Noconsole
			Return  1
		Endif
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function actualizaRodi()
	cdeta = " Traspaso "
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.ActualizaResumenTraspasos(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', ;
			  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0, 'P', This.Idauto) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If DesactivaDtraspaso(This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif

	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, This.Idauto, This.fechat, ;
		  goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpv
	Go Top
	Do While !Eof()
		If Empty(tmpv.coda)
			Select tmpv
			Skip
			Loop
		Endif
		calma = This.sucursal1
		ctipo = "V"
		If INGRESAKARDEXT(This.Idauto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 'T', cdeta, This.sucursal2, 0, 0) = 0 Then
			Sw = 0
			Cmensaje = 'Al Registrar en Tienda 1'
			Exit
		Endif
		If INGRESAKARDEXT(This.Idauto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'T', cdeta, This.sucursal1, 0, 0) = 0 Then
			Sw = 0
			Exit
			Cmensaje = 'Al Registrar en Tienda 2'
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, "V") <= 0 Then
			Sw = 0
			Cmensaje = 'Al Actualizar Tienda 1'
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal2, tmpv.cant, "C") <= 0 Then
			Sw = 0
			Cmensaje = 'Al Actualizar Tienda 2'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	If This.Tdoc = '09' And goApp.Emisorguiasremisionelectronica = 'S' Then
		Select * From tmpv Into Cursor tmpvg Readwrite
		This.Imprimir('S')
	Else
		Report Form (This.Archivointerno) To Printer Prompt Noconsole
	Endif
	Return  1
	Endfunc
	Function listarguiatraspasorodi(nids, Calias)
	Set DataSession To This.Idsesion
	Text To lC Noshow Textmerge
	   select  guia_ndoc as ndoc,guia_fech as fech,guia_fect as fechat,
	   a.descri,a.unid,k.cant,a.peso,g.guia_ptoll,g.guia_ptop as ptop,
	   k.idart as coda,k.prec,k.idkar,g.guia_idtr,ifnull(placa,'') as placa,ifnull(t.razon,'') as razont,
	   ifnull(t.ructr,'') as ructr,ifnull(t.nombr,'') as conductor,guia_mens,
	   ifnull(t.dirtr,'') as direcciont,ifnull(t.breve,'') as brevete,
	   ifnull(t.cons,'') as constancia,ifnull(t.marca,'') as marca,v.nruc,
	   ifnull(t.placa1,'') as placa1,r.ndoc as dcto,tdoc,r.idcliente,rcom_mens,'' as rcom_reci,k.alma,a.uno,a.dos,a.tre,a.cua,cin,sei,sie,och,nue,die,
	   v.empresa as Razo,'S' as mone,guia_idgui as idgui,r.idauto,guia_arch,guia_hash,guia_mens,r.ndo2,guia_ubig
	   FROM
	   fe_guias as g
	   inner join fe_rcom as r on r.idauto=g.guia_idau
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   left join fe_tra as t on t.idtra=g.guia_idtr,fe_gene as v where guia_idgui=<<nids>> and tipo='V' and k.acti='A'
	Endtext
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaResumenTraspasos(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	lC = 'ProActualizaCabeceraTraspasoN'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	goApp.npara26 = np26
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarTraspasodr()
	Set DataSession To This.Idsesion
	If This.validarguia() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenDcto(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.sucursal1, 'S', fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, This.sucursal1, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat,	goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, This.sucursal1)
	Sw = 1
	Select tmpv
	Go Top
	Do While !Eof()
		If goApp.Tiponegocio = 'D' Then
			dfv = Ctod("01/01/0001")
			nidkar = IngresaKardexFl(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal1, 0, 0, tmpv.equi, ;
				  tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo, fe_gene.igv, Iif(Empty(tmpv.Fechavto), dfv, tmpv.Fechavto), tmpv.nlote)
			If nidkar = 0
				Sw = 0
				Exit
			Endif
			If IngresaKardexFl(NAuto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal2, 0, 0, tmpv.equi, ;
					  tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo, fe_gene.igv, Iif(Empty(tmpv.Fechavto), dfv, tmpv.Fechavto), tmpv.nlote) = 0
				Sw = 0
				Exit
			Endif
		Else
			nidkar = INGRESAKARDEXUAl(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal1, 0, 0, tmpv.equi, ;
				  tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo / fe_gene.igv, fe_gene.igv)
			If nidkar = 0 Then
				Sw = 0
				Exit
			Endif
			If INGRESAKARDEXUAl(NAuto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal2, 0, 0, tmpv.equi, ;
					  tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo / fe_gene.igv, fe_gene.igv) = 0 Then
				Sw = 0
				Exit
			Endif
		Endif
		If GrabaDetalleGuias(nidkar, tmpv.cant, nidg) = 0 Then
			Sw = 0
			Exit
		Endif
		If Actualizastock1(tmpv.coda, This.sucursal1, tmpv.cant, 'V', tmpv.equi) = 0 Then
			Sw = 0
			Exit
		Endif
		If Actualizastock1(tmpv.coda, This.sucursal2, tmpv.cant, 'C', tmpv.equi) = 0 Then
			Sw = 0
			Exit
		Endif
		Sele tmpv
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GeneraCorrelativo() < 1  Then
		This.DEshacerCambios()
		Return
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Select * From tmpv Into Cursor tmpvg Readwrite
	This.Imprimir('S')
	Return 1
	Endfunc
	Function ActualizarTraspasoDr()
	Local NAuto
	Set DataSession To This.Idsesion
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If ActualizaResumenDcto(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.sucursal2, 'S', ;
			  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, This.Tienda, 0, 0, 0, 0, 0, This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, This.Idauto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, This.sucursal1)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If DesactivaDtraspaso(This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Select tmpv
	Go Top
	Do While !Eof()
		If Deleted()
			If tmpv.Nreg > 0
				If ActualizaKardexUAl(This.Idauto, tmpv.coda, .Tipo, tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal1, 0, tmpv.Nreg, 0, tmpv.equi, tmpv.Unid, 0, 0, tmpv.pos, 0, fe_gene.igv) = 0 Then
					Sw = 0
					Exit
				Endif
			Endif
			Sele tmpv
			Skip
			Loop
		Endif
		If goApp.Tiponegocio = 'D' Then
			dfv = Ctod("01/01/0001")
			nidkar = IngresaKardexFl(This.Idauto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal1, 0, 0, tmpv.equi, tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo, fe_gene.igv, Iif(Empty(tmpv.Fechavto), dfv, tmpv.Fechavto), tmpv.nlote)
			If nidkar = 0
				Sw = 0
				Exit
			Endif
			If IngresaKardexFl(This.Idauto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal2, 0, 0, tmpv.equi, tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo, fe_gene.igv, Iif(Empty(tmpv.Fechavto), dfv, tmpv.Fechavto), tmpv.nlote) = 0
				Sw = 0
				Exit
			Endif
		Else
			nidkar = INGRESAKARDEXUAl(This.Idauto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal1, 0, 0, tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo / fe_gene.igv, fe_gene.igv)
			If nidkar = 0 Then
				Sw = 0
				Exit
			Endif
			If INGRESAKARDEXUAl(This.Idauto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal2, 0, 0, ;
					  tmpv.Unid, tmpv.idepta, tmpv.pos, tmpv.costo / fe_gene.igv, fe_gene.igv) = 0 Then
				Sw = 0
				Exit
			Endif
		Endif
		If GrabaDetalleGuias(nidkar, tmpv.cant, nidg) = 0 Then
			Sw = 0
			Exit
		Endif
		If ActualizaStock12(tmpv.coda, This.sucursal1, tmpv.caan, 'V', tmpv.equi, 0) = 0 Then
			Sw = 0
			Exit
		Endif
		If ActualizaStock12(tmpv.coda, This.sucursal2, tmpv.caan, 'C', tmpv.equi, 0) = 0 Then
			Sw = 0
			Exit
		Endif
		Sele tmpv
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If GRabarCambios() < 1 Then
		Return 0
	Endif
	Select * From tmpv Into Cursor tmpvg Readwrite
	This.Imprimir('S')
	Return 1
	Endfunc
	Function registrarsoloingreso(Calias)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.Encontrado = 'V' Then
		If ActualizaResumenDcto(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.sucursal1, 'S', ;
				  fe_gene.dola, fe_gene.igv, 'T', 0, 'C', goApp.nidusua, 1, This.Tienda, 0, 0, 0, 0, 0, This.Idauto) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
		If DesactivaDtraspaso(This.Idauto) = 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
		NAuto = This.Idauto
	Else
		NAuto = IngresaResumenDcto(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.sucursal1, 'S', fe_gene.dola, fe_gene.igv, 'R', 0, 'C', goApp.nidusua, 0, This.sucursal1, 0, 0, 0, 0, 0)
	Endif
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Select tmpv
	Go Top
	Do While !Eof()
		If IngresaDtraspasos(NAuto, tmpv.coda, 'C', tmpv.Prec, tmpv.cant, 'I', 0, 'T', This.Detalle, This.sucursal1, This.sucursal2, 0) < 1 Then
			Sw = 0
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal2, tmpv.cant, "C") <= 0 Then
			Sw = 0
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarLopez()
	If This.validartraspasolopez() < 1 Then
		Return 0
	Endif
	Set Classlib To 'd:\librerias\clasesvisuales' Additive
	ovstock = Createobject("verificastockproducto")
	If This.IniciaTransaccion() < 1
		Return 0
	Endif
	NAuto = IngresaTraspasoAlmacenEnviado(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', ;
		  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0, 'P')
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Cmensaje = ""
	Select tmpv
	Go Top
	Do While !Eof()
		cdescri = tmpv.Desc
		If ovstock.Ejecutar(tmpv.coda, tmpv.cant, This.sucursal1) <= 0 Then
			Cmensaje = "Stock no Disponible"
			Sw = 0
			Exit
		Endif
		If This.registradetalletraspaso(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'T', This.Detalletraspaso, nidg) < 1 Then
			Sw = 0
			Cmensaje = This.Cmensaje
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, "V") < 1 Then
			Sw = 0
			Cmensaje = "Al Actualizar Stock"
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If Sw = 1 And This.GeneraCorrelativo() = 1  Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		If This.Tdoc = '09' And goApp.Emisorguiasremisionelectronica = 'S' Then
			Select * From tmpv Into Cursor tmpvg Readwrite
			This.Imprimir('S')
			Return 1
		Else
			Replace All Almacen1 With This.calmacen1, Almacen2 With This.calmacen2, fech With This.Fecha, ;
				Ndoc With This.Ndoc, Detalle With This.Detalle  In tmpv
			Do Form ka_ldctos1 To Verdad
			Select tmpv
			Go Top In tmpv
			Report Form (This.Archivointerno) To Printer Prompt Noconsole
			Return  1
		Endif
	Else
		This.DEshacerCambios()
		This.Cmensaje = Alltrim(Cmensaje) + " Item: " + Alltrim(cdescri) + " No Tiene Stock Disponible"
		Return 0
	Endif
	Endfunc
	Function registradetalletraspaso(NAuto, ccoda, ctipo, nprec, ncant, cincl, cttip, cdeta, nidg)
	lC = "FUNINGRESAKARDEX"
	goApp.npara1 = NAuto
	goApp.npara2 = ccoda
	goApp.npara3 = ctipo
	goApp.npara4 = nprec
	goApp.npara5 = ncant
	goApp.npara6 = cincl
	goApp.npara7 = 0
	goApp.npara8 = cttip
	goApp.npara9 = cdeta
	goApp.npara10 = This.sucursal1
	goApp.npara11 = This.sucursal2
	goApp.npara12 = 0
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	nidkar = This.EJECUTARf(lC, lp, "trasp")
	If nidkar < 1 Then
		Return 0
	Endif
	If GrabaDetalleGuias(nidkar, ncant, nidg) = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validartraspasolopez(Calias)
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	This.Cmensaje = ""
	Do Case
	Case This.sucursal2 = 0
		This.Cmensaje = "Ingrese el Ingreso"
	Case This.sucursal1 = 0
		This.Cmensaje = "Ingrese la Salida"
	Case This.Encontrado = "V"
		This.Cmensaje = "No Es Posible Actualizar Este Documento"
	Case This.sinstock = "S"
		This.Cmensaje = "Hay Un Item que No Tiene Stock Disponible"
	Case This.Titems = 0
		This.Cmensaje = "Ingrese Los Productos"
	Case This.sucursal1 = This.sucursal2
		This.Cmensaje = "Seleccione Otro Almacen"
	Case Len(Alltrim(This.ptop)) = 0
		This.Cmensaje = "Ingrese el Punto de Partida"
	Case Len(Alltrim(This.ptoll)) = 0
		This.Cmensaje = "Ingrese el Punto de Llegada"
	Case (Month(This.Fecha) <> goApp.mes Or Year(This.Fecha) <> Val(goApp.año)) And This.fechaautorizada = 0	And This.Fecha <= fe_gene.fech
		This.Cmensaje = "Ingrese Una Fecha Permitida Por el Sistema"
	Endcase
	If This.Cmensaje <> '' Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function Grabarpsystr()
	If This.validartraspasolopez() < 1 Then
		Return 0
	Endif
	Set Classlib To 'd:\librerias\clasesvisuales' Additive
	cproc='rnftr'
	Set Procedure To (cproc)  Additive
	ovstock = Createobject("verificastockproducto")
	If This.IniciaTransaccion() < 1
		Return 0
	Endif
	NAuto = IngresaResumenTraspasosNorplast(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', ;
		  fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0, 'P')
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Cmensajex = ""
	Select tmpv
	Go Top
	Do While !Eof()
		cdescri = tmpv.Desc
*!*			If ovstock.ejecutar(tmpv.coda, tmpv.cant, This.sucursal1) <= 0 Then
*!*				Cmensajex = "Stock no Disponible "+ALLTRIM(cdescri)
*!*				Sw = 0
*!*				Exit
*!*			Endif
		If This.registradetalletraspaso(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'T', This.Detalletraspaso, nidg) < 1 Then
			Sw = 0
			Cmensajex = This.Cmensaje
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, "V") < 1 Then
			Sw = 0
			Cmensajex = "Al Actualizar Stock " + Alltrim(cdescri)
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If Sw = 1 And This.GeneraCorrelativo() = 1  Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		If This.Tdoc = '09'  Then
			Select * From tmpv Into Cursor tmpvg Readwrite
			This.Imprimir('S')
			Return 1
		Else
			Replace All Almacen1 With This.calmacen1, Almacen2 With This.calmacen2, fech With This.Fecha, ;
				Ndoc With This.Ndoc, Detalle With This.Detalle  In tmpv
			Do Form ka_ldctos1 To Verdad
			Select tmpv
			Go Top In tmpv
			Report Form (This.Archivointerno) To Printer Prompt Noconsole
			Return  1
		Endif
	Else
		This.DEshacerCambios()
		This.Cmensaje = Alltrim(Cmensajex)
		Return 0
	Endif
	Endfunc
	Function GrabarNorplast()
	If This.validartraspasolopez() < 1 Then
		Return 0
	Endif
	Set Classlib To 'd:\librerias\clasesvisuales' Additive
	ovstock = Createobject("verificastockproducto")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	NAuto = IngresaResumenTraspasosNorplast(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, This.Ndo2, 'S', fe_gene.dola, fe_gene.igv, 'T', 0, 'V', goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0, 'P')
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg = This.IngresaGuiasXTraspaso(This.Fecha, This.ptop, This.ptoll, NAuto, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Cmensaje = ""
	Select tmpv
	Go Top
	Do While !Eof()
		cdescri = tmpv.Desc
		If ovstock.Ejecutar(tmpv.coda, tmpv.cant, This.sucursal1) < 1 Then
			Cmensaje = "Stock no Disponible"
			Sw = 0
			Exit
		Endif
		If This.registradetalletraspaso(NAuto, tmpv.coda, 'V', tmpv.Prec, tmpv.cant, 'I', 'T', This.Detalletraspaso, nidg) < 1 Then
			Sw = 0
			Cmensaje = This.Cmensaje
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, "V") < 1 Then
			Sw = 0
			Cmensaje = "Al Actualizar Stock"
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If Sw = 1 And This.GeneraCorrelativo() = 1  Then
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
		If This.Tdoc = '09'  Then
			Select * From tmpv Into Cursor tmpvg Readwrite
			This.Imprimir('S')
		Else
			Replace All Almacen1 With This.calmacen1, Almacen2 With This.calmacen2, fech With This.Fecha, ;
				Ndoc With This.Ndoc, Detalle With This.Detalle  In tmpv
			Do Form ka_ldctos1 To Verdad
			Select tmpv
			Go Top In tmpv
			Report Form (This.Archivointerno) To Printer Prompt Noconsole
		Endif
		Return 1
	Else
		This.DEshacerCambios()
		This.Cmensaje = Alltrim(Cmensaje) + " Item: " + Alltrim(cdescri) + " No Tiene Stock Disponible"
		Return 0
	Endif
	Endfunc
	Function GrabarTransformados(ctipo)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
*!*		If This.Idauto > 0 Then
*!*			If AnulaTransaccionConMotivo('', '', ctipo, This.Idauto, goApp.Idusua, '', This.Fecha, goApp.nidusua, 'Actualización') = 0 Then
*!*				This.DEshacerCambios()
*!*				Return 0
*!*			Endif
*!*		Endif
	NAuto = IngresaResumenTraspasos(This.Tdoc, 'E', This.Ndoc, This.Fecha, This.Fecha, This.Detalle, 0, 0, 0, "", 'S', ;
		  fe_gene.dola, fe_gene.igv, ctipo, 0, ctipo, goApp.nidusua, 1, goApp.Tienda, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabardetallesalidaTransormados(NAuto, ctipo) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GeneraCorrelativo() = 1  Then
		If 	GRabarCambios() = 0 Then
			Return 0
		Endif
		Return 1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function GrabardetallesalidaTransormados(NAuto, ctipox)
	Select tmpv
	Go Top
	Sw = 1
	Do While !Eof()
		If ctipox = 'V' Then
			If DevuelveStocks1(tmpv.coda, This.sucursal1, "St") < 1 Then
				Sw = 0
				This.Cmensaje = 'Al Obtener Stock'
				Exit
			Endif
			If tmpv.cant > st.saldo Then
				Sw = 0
				This.Cmensaje = 'Stock NO Disponible'
				Exit
			Endif
		Endif
		nidk = INGRESAKARDEX1(NAuto, tmpv.coda, ctipox, tmpv.Prec, tmpv.cant, 'I', 'K', 0, This.sucursal1, tmpv.costo,  0)
		If nidk = 0 Then
			Sw = 0
			This.Cmensaje = 'Al Obtener ID del Kardex'
			Exit
		Endif
		If ActualizaStock(tmpv.coda, This.sucursal1, tmpv.cant, ctipox) < 0 Then
			Sw = 0
			This.Cmensaje = 'Al Actualizar Stock'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	Return Sw
	Endfunc
	Function validarguia1()
	Do Case
	Case  !esfechaValida(This.Fecha)
		This.Cmensaje = "Fecha No Válida"
		Return 0
	Case  Len(Alltrim(This.Detalle)) = 0
		This.Cmensaje = "Ingrese una Referencia para esté Registro"
		Return 0
	Endcase
	Return 1
	Endfunc
	Function verificarsitraspasoestarecibido(nid)
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
    SELECT idauto FROM fe_rcom WHERE idauto=<<nid>> AND rcom_reci='E' AND acti='A'
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If Idauto > 0 Then
		This.Cmensaje = "Traspaso Ya Registrado!!!!"
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine











