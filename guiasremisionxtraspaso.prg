Define Class guiaremisionxtraspaso As guiaremision Of 'd:\capass\modelos\guiasremision'
	Function grabar()
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If This.IniciaTransaccion()=0 Then
		Return 0
	Endif
	If This.Idautog>0 Then
		If AnulaGuiasVentas(This.Idautog,goapp.nidusua)=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
		If AnulaTransaccionConMotivo('','','V',This.Idauto,goapp.idusua,'',This.fecha,goapp.nidusua,'Actualización')=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	nauto =IngresaResumenTraspasos(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.Ndo2,'S',;
		fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0)
	If nauto<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg= This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,nauto,This.fechat,;
		goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Fracciones= 'U' Then
		If This.grabadetalleguiau(nauto)<1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If This.Grabardetalleguiatraspaso(nauto)<1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If  This.generacorrelativo()=1  Then
		If 	GRabarCambios()=0 Then
			Return 0
		Endif
		If This.tdoc='09' And goapp.Emisorguiasremisionelectronica='S' Then
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
	Function actualizar()
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If This.IniciaTransaccion()=0 Then
		Return 0
	Endif
	If This.Idautog>0 Then
		If AnulaGuiasVentas(This.Idautog,goapp.nidusua)=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaResumenTraspasos(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.Ndo2,'S',;
			fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0,'P',This.Idauto)=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If DesactivaDtraspaso(This.Idauto)=0 Then
		This.DEshacerCambios()
		Return 0
	Endif

	nidg=This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,This.Idauto,This.fechat,;
		goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Fracciones= 'U' Then
		If This.grabadetalleguiau(This.Idauto)=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Else
		If This.Grabardetalleguiatraspaso(This.Idauto)=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios()<1 Then
		Return 0
	Endif
	If This.tdoc='09' And goapp.Emisorguiasremisionelectronica='S' Then
		Select * From tmpv Into Cursor tmpvg Readwrite
		This.Imprimir('S')
	Else
		Report Form (This.Archivointerno) To Printer Prompt Noconsole
	Endif
	Return  1
	Endfunc
	Function IngresaGuiasXTraspaso(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	Local lc, lp
*:Global cur
	lc			  = "FUNINGRESAGUIAST"
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
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?this.ubigeocliente)
	ENDTEXT
	nidg=This.EJECUTARF(lc, lp, cur)
	If nidg<1 Then
		Return 0
	Endif
	Return nidg
	Endfunc
	Function validarguia()
	Do Case
	Case  This.recibido='E'
		This.cmensaje="NO es Posible Actualizar este Traspaso Porque ya esta Recibido"
		Return 0
	Case This.sucursal1=0 Or This.sucursal2=0
		This.cmensaje="Seleccione al Tienda/Almacen de Ingreso y Salida"
		Return 0
	Case This.sucursal1=This.sucursal2
		This.cmensaje="La Transferencia Debe ser entre almacenes Diferentes"
		Return 0
	Endcase
	If This.validar()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Grabardetalleguiatraspaso(nauto)
	Local obj As serieproducto
	rn="d:\reglasnegocio\rnw.prg"
	Set Procedure To capadatos,(rn) Additive
	obj=Createobject("serieproducto")
	Select tmpv
	Go Top
	sw=1
	Do While !Eof()
		If DevuelveStocks1(tmpv.coda,This.sucursal1,"St")<1 Then
			sw=0
			This.cmensaje='Al Obtener Stock'
			Exit
		Endif
		If tmpv.cant>st.saldo Then
			sw=0
			This.cmensaje='Stock NO Disponible'
			Exit
		Endif
		If This.Conseries='S' Then
			nidk=IngresaDtraspasos(nauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I',0,'T',This.Detalle,This.sucursal1,This.sucursal2,0)
			If nidk<1 Then
				sw=0
				This.cmensaje='Al Obtener ID del Kardex'
				Exit
			Endif
			If !Empty(tmpv.serieproducto) Then
				obj.AsignaValores(tmpv.serieproducto,nauto,nidk,tmpv.coda)
				If obj.RegistraDseries(tmpv.idseriep)<=0 Then
					sw=0
					This.cmensaje='Al Obtener ID del Kardex'
					Exit
				Endif
			Endif
		Else
			nidk=IngresaDtraspasos(nauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I',0,'T',This.Detalle,This.sucursal1,This.sucursal2,0)
			If nidk=0 Then
				sw=0
				This.cmensaje='Al Obtener ID del Kardex'
				Exit
			Endif
		Endif
		If GrabaDetalleGuias(nidk,tmpv.cant,nidg)=0 Then
			sw=0
			This.cmensaje='Al Registrar Detalle'
			Exit
		Endif
		If This.Coningresosucursal='S' Then
			If IngresaDtraspasos(nauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I',0,'T',This.Detalle,This.sucursal2,This.sucursal1,0)=0 Then
				sw=0
				This.cmensaje='Al Obtener ID del Kardex'
				Exit
			Endif
			If ActualizaStock(tmpv.coda,This.sucursal2,tmpv.cant,'C')<0 Then
				sw=0
				This.cmensaje='Al Actualizar Stock'
				Exit
			Endif
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal1,tmpv.cant,'V')<0 Then
			sw=0
			This.cmensaje='Al Actualizar Stock'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	Return sw
	Endfunc
	Function grabarRodi()
	Set DataSession To This.idsesion
	If This.validar()<1 Then
		Return 0
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto =IngresaResumenTraspasos(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.Ndo2,'S',;
		fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0)
	If nauto<=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg= This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,nauto,This.fechat,;
		goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg=0 Then
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
		ctipo="V"
		nidkar= INGRESAKARDEXT(nauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I','T',This.Detalle,This.sucursal2,0,0)
		If nidkar=0 Then
			sw=0
			cmensaje='Al Registrar en Tienda 1'
			Exit
		Endif
		If INGRESAKARDEXT(nauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','T',This.Detalle,This.sucursal1,0,0)=0 Then
			sw=0
			Exit
			cmensaje='Al Registrar en Tienda 2'
		Endif
		If GrabaDetalleGuias(nidkar,tmpv.cant,nidg)=0 Then
			sw=0
			Exit
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal1,tmpv.cant,"V")<=0 Then
			sw=0
			cmensaje='Al Actualizar Tienda 1'
			Exit
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal2,tmpv.cant,"C")<=0 Then
			sw=0
			cmensaje='Al Actualizar Tienda 2'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If  This.generacorrelativo()=1  Then
		If 	GRabarCambios()=0 Then
			Return 0
		Endif
		If This.tdoc='09'  Then
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
	cdeta=" Traspaso "
	If This.IniciaTransaccion()=0 Then
		Return 0
	Endif
	If This.Idautog>0 Then
		If AnulaGuiasVentas(This.Idautog,goapp.nidusua)=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.ActualizaResumenTraspasos(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.Ndo2,'S',;
			fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0,'P',This.Idauto)<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If DesactivaDtraspaso(This.Idauto)=0 Then
		This.DEshacerCambios()
		Return 0
	Endif

	nidg=This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,This.Idauto,This.fechat,;
		goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg<1 Then
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
		calma=This.sucursal1
		ctipo="V"
		If INGRESAKARDEXT(This.Idauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I','T',cdeta,This.sucursal2,0,0)=0 Then
			sw=0
			cmensaje='Al Registrar en Tienda 1'
			Exit
		Endif
		If INGRESAKARDEXT(This.Idauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','T',cdeta,This.sucursal1,0,0)=0 Then
			sw=0
			Exit
			cmensaje='Al Registrar en Tienda 2'
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal1,tmpv.cant,"V")<=0 Then
			sw=0
			cmensaje='Al Actualizar Tienda 1'
			Exit
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal2,tmpv.cant,"C")<=0 Then
			sw=0
			cmensaje='Al Actualizar Tienda 2'
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If This.GRabarCambios()=0 Then
		Return 0
	Endif
	If This.tdoc='09' And goapp.Emisorguiasremisionelectronica='S' Then
		Select * From tmpv Into Cursor tmpvg Readwrite
		This.Imprimir('S')
	Else
		Report Form (This.Archivointerno) To Printer Prompt Noconsole
	Endif
	Return  1
	Endfunc
	Function listarguiatraspasorodi(nids,calias)
	Set DataSession To This.idsesion
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.Ejecutaconsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaResumenTraspasos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26)
	lc='ProActualizaCabeceraTraspasoN'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	goapp.npara25=np25
	goapp.npara26=np26
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	ENDTEXT
	If This.EJECUTARP(lc,lp,"")<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarTraspasodr()
	Set DataSession To This.idsesion
	If This.validarguia()<1 Then
		Return 0
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=IngresaResumenDcto(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.sucursal1,'S',fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,This.sucursal1,0,0,0,0,0)
	If nauto<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg= This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,nauto,This.fechat,	goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,This.sucursal1)
	sw=1
	Select tmpv
	Go Top
	Do While !Eof()
		If goapp.tiponegocio='D' Then
			dfv=Ctod("01/01/0001")
			nidkar=IngresaKardexFl(nauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal1,0,0,tmpv.equi,;
				tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo,fe_gene.igv,Iif(Empty(tmpv.fechavto),dfv,tmpv.fechavto),tmpv.nlote)
			If nidkar=0
				sw=0
				Exit
			Endif
			If IngresaKardexFl(nauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal2,0,0,tmpv.equi,;
					tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo,fe_gene.igv,Iif(Empty(tmpv.fechavto),dfv,tmpv.fechavto),tmpv.nlote)=0
				sw=0
				Exit
			Endif
		Else
			nidkar=IngresaKardexUAl(nauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal1,0,0,tmpv.equi,;
				tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo/fe_gene.igv,fe_gene.igv)
			If nidkar=0 Then
				sw=0
				Exit
			Endif
			If IngresaKardexUAl(nauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal2,0,0,tmpv.equi,;
					tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo/fe_gene.igv,fe_gene.igv)=0 Then
				sw=0
				Exit
			Endif
		Endif
		If GrabaDetalleGuias(nidkar,tmpv.cant,nidg)=0 Then
			sw=0
			Exit
		Endif
		If Actualizastock1(tmpv.coda,This.sucursal1,tmpv.cant,'V',tmpv.equi)=0 Then
			sw=0
			Exit
		Endif
		If Actualizastock1(tmpv.coda,This.sucursal2,tmpv.cant,'C',tmpv.equi)=0 Then
			sw=0
			Exit
		Endif
		Sele tmpv
		Skip
	Enddo
	If sw=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.generacorrelativo()<1  Then
		This.DEshacerCambios()
		Return
	Endif
	If This.GRabarCambios()<1 Then
		Return 0
	Endif
	Select * From tmpv Into Cursor tmpvg Readwrite
	This.Imprimir('S')
	Return 1
	Endfunc
	Function ActualizarTraspasoDr()
	Local nauto
	Set DataSession To This.idsesion
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	If ActualizaResumenDcto(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.sucursal2,'S',;
			fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,This.tienda,0,0,0,0,0,This.Idauto)=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Idautog>0 Then
		If AnulaGuiasVentas(This.Idautog,goapp.nidusua)=0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	nidg=This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,This.Idauto,This.fechat,goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,This.sucursal1)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If DesactivaDtraspaso(This.Idauto)=0 Then
		This.DEshacerCambios()
		Return
	Endif
	sw=1
	Select tmpv
	Go Top
	Do While !Eof()
		If Deleted()
			If tmpv.nreg>0
				If ActualizakardexUAl(This.Idauto,tmpv.coda,.tipo,tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal1,0,tmpv.nreg,0,tmpv.equi,tmpv.unid,0,0,tmpv.pos,0,fe_gene.igv)=0 Then
					sw=0
					Exit
				Endif
			Endif
			Sele tmpv
			Skip
			Loop
		Endif
		If goapp.tiponegocio='D' Then
			dfv=Ctod("01/01/0001")
			nidkar= IngresaKardexFl(This.Idauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal1,0,0,tmpv.equi,tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo,fe_gene.igv,Iif(Empty(tmpv.fechavto),dfv,tmpv.fechavto),tmpv.nlote)
			If nidkar=0
				sw=0
				Exit
			Endif
			If IngresaKardexFl(This.Idauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal2,0,0,tmpv.equi,tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo,fe_gene.igv,Iif(Empty(tmpv.fechavto),dfv,tmpv.fechavto),tmpv.nlote)=0
				sw=0
				Exit
			Endif
		Else
			nidkar=IngresaKardexUAl(This.Idauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal1,0,0,tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo/fe_gene.igv,fe_gene.igv)
			If nidkar=0 Then
				sw=0
				Exit
			Endif
			If IngresaKardexUAl(This.Idauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I','K',0,This.sucursal2,0,0,;
					tmpv.unid,tmpv.idepta,tmpv.pos,tmpv.costo/fe_gene.igv,fe_gene.igv)=0 Then
				sw=0
				Exit
			Endif
		Endif
		If GrabaDetalleGuias(nidkar,tmpv.cant,nidg)=0 Then
			sw=0
			Exit
		Endif
		If ActualizaStock12(tmpv.coda,This.sucursal1,tmpv.caan,'V',tmpv.equi,0)=0 Then
			sw=0
			Exit
		Endif
		If ActualizaStock12(tmpv.coda,This.sucursal2,tmpv.caan,'C',tmpv.equi,0)=0 Then
			sw=0
			Exit
		Endif
		Sele tmpv
		Skip
	Enddo
	If sw=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If GRabarCambios()<1 Then
		Return 0
	Endif
	Select * From tmpv Into Cursor tmpvg Readwrite
	This.Imprimir('S')
	Return 1
	Endfunc
	Function registrarsoloingreso(calias)
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=IngresaResumenDcto(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.sucursal1,'S',fe_gene.dola,fe_gene.igv,'R',0,'C',goapp.nidusua,0,This.sucursal1,0,0,0,0,0)
	If nauto<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	sw=1
	Select tmpv
	Go Top
	Do While !Eof()
		If IngresaDtraspasos(nauto,tmpv.coda,'C',tmpv.Prec,tmpv.cant,'I',0,'T',This.Detalle,This.sucursal1,This.sucursal2,0)<1 Then
			sw=0
			Exit
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal2,tmpv.cant,"C")<=0 Then
			sw=0
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If sw=0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarLopez()
	If This.validartraspasolopez()<1 Then
		Return 0
	Endif
	Set Classlib To 'd:\librerias\clasesvisuales' Additive
	ovstock=Createobject("verificastockproducto")
	If This.IniciaTransaccion()<1
		Return 0
	Endif
	nauto =IngresaTraspasoAlmacenEnviado(This.tdoc,'E',This.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,This.Ndo2,'S',;
		fe_gene.dola,fe_gene.igv,'T',0,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0,'P')
	If nauto<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg= This.IngresaGuiasXTraspaso(This.fecha,This.ptop,This.ptoll,nauto,This.fechat,goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	sw = 1
	cmensaje=""
	Select tmpv
	Go Top
	Do While !Eof()
		cdescri = tmpv.Desc
		If ovstock.ejecutar(tmpv.coda, tmpv.cant, This.sucursal1) <= 0 Then
			cmensaje="Stock no Disponible"
			sw = 0
			Exit
		Endif
		If This.registradetalletraspaso(nauto,tmpv.coda,'V',tmpv.Prec,tmpv.cant,'I','T',This.Detalletraspaso,nidg)<1 Then
			sw = 0
			cmensaje=This.cmensaje
			Exit
		Endif
		If ActualizaStock(tmpv.coda,This.sucursal1, tmpv.cant, "V") < 1 Then
			sw = 0
			cmensaje="Al Actualizar Stock"
			Exit
		Endif
		Select tmpv
		Skip
	Enddo
	If sw = 1 And This.generacorrelativo()=1  Then
		If This.GRabarCambios() < 1 Then
			Return
		Endif
		If This.tdoc='09' And goapp.Emisorguiasremisionelectronica='S' Then
			Select * From tmpv Into Cursor tmpvg Readwrite
			This.Imprimir('S')
			Return 1
		Else
			Replace All almacen1 With This.calmacen1 ,almacen2 With This.calmacen2,fech With This.fecha,;
				ndoc With This.ndoc,Detalle With This.Detalle  In tmpv
		    DO form ka_ldctos1 to verdad		
			Select tmpv
			Go Top In tmpv
			Report Form (This.Archivointerno) To Printer Prompt Noconsole
			Return  1
		Endif
	Else
		This.DEshacerCambios()
		This.cmenesaje=Alltrim(cmensaje) +" Item: " + Alltrim(cdescri) + " No Tiene Stock Disponible"
		Return 0
	Endif
	Endfunc
	Function registradetalletraspaso(nauto,ccoda,ctipo,nprec,ncant,cincl,cttip,cdeta,nidg)
	lc="FUNINGRESAKARDEX"
	goapp.npara1=nauto
	goapp.npara2=ccoda
	goapp.npara3=ctipo
	goapp.npara4=nprec
	goapp.npara5=ncant
	goapp.npara6=cincl
	goapp.npara7=0
	goapp.npara8=cttip
	goapp.npara9=cdeta
	goapp.npara10=This.sucursal1
	goapp.npara11=This.sucursal2
	goapp.npara12=0
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidkar=This.EJECUTARF(lc,lp,"trasp")
	If nidkar<1 Then
		Return 0
	Endif
	If GrabaDetalleGuias(nidkar,ncant,nidg)=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validartraspasolopez(calias)
	If This.validar()<1 Then
		Return 0
	Endif
	This.cmensaje=""
	Do Case
	Case This.encontrado="V"
		This.cmensaje="No Es Posible Actualizar Este Documento"
	Case This.sinstock="S"
		This.cmensaje="Hay Un Item que No Tiene Stock Disponible"
	Case This.titems=0
		This.cmensaje="Ingrese Los Productos"
	Case This.sucursal1=This.sucursal2
		This.cmensaje="Seleccione Otro Almacen"
	Case (Month(This.fecha)<>goapp.mes Or Year(This.fecha)<>Val(goapp.año)) And This.fechaautorizada=0	And This.fecha<=fe_gene.fech
		This.cmensaje="Ingrese Una Fecha Permitida Por el Sistema"
	Endcase
	If This.cmensaje<>'' Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine

