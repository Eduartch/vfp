Define Class guiaremisionxdevolucion As guiaremision Of 'd:\capass\modelos\guiasremision'
	Function grabar()
	If This.idsesion>1 Then
		Set DataSession To  This.idsesion
	Endif
	s=1
	nidkar=0
	cmensaje=""
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	Na=IngresaResumenDcto('09','E',;
		this.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,'','S',;
		fe_gene.dola,fe_gene.igv,'k',This.idprov,'C',goapp.nidusua,0,goapp.tienda,0,0,0,0,0)
	If Na<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg=This.IngresaGuiasXdcompras(This.fecha,This.ptop,This.ptoll,Na,This.fechat,goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	Do While !Eof()
		If fe_gene.alma_nega=0 Then
			If DevuelveStocks(tmpvg.coda,"Stock")<1 Then
				s=0
				cmensaje='No está activado la venta con Negativos'
				Exit
			Endif
			Do Case
			Case goapp.tienda=1
				Ts=stock.uno
			Case goapp.tienda=2
				Ts=stock.Dos
			Case goapp.tienda=3
				Ts=stock.tre
			Case goapp.tienda=4
				Ts=stock.cua
			Case goapp.tienda=5
				Ts=stock.cin
			Case goapp.tienda=6
				Ts=stock.sei
			Case goapp.tienda=7
				Ts=stock.sie
			Case goapp.tienda=8
				Ts=stock.och
			Case goapp.tienda=9
				Ts=stock.nue
			Case goapp.tienda=10
				Ts=stock.die
			Endcase
			If tmpvg.cant>Ts Then
				s=0
				cmensaje='En Stock '+ Alltrim(Str(Ts,10))+'  no Disponible para esta Transacción '
				Exit
			Endif
		Endif
		nidkar=INGRESAKARDEX1(Na,tmpvg.coda,"V",0,tmpvg.cant,"I","K",0,goapp.tienda,0,0)
		If nidkar<1 Then
			s=0
			cmensaje='Al Registrar Kardex'
			Exit
		Endif
		If GrabaDetalleGuias(nidkar,tmpvg.cant,nidg)<1 Then
			s=0
			cmensaje='Al Registrar detalle de Guia'
			Exit
		Endif
		If Actualizastock(tmpvg.coda,goapp.tienda,tmpvg.cant,'V')<1 Then
			s=0
			cmensaje='Al actualizar Stock'
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.generacorrelativo()=1  And s=1 Then
		If This.GRabarCambios()=0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		This.cmensaje=cmensaje
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasXdcompras(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	Local lc, lp
*:Global cur
	lc			  = "FUNINGRESAGUIASxdCompras"
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
	goapp.npara11 = This.idprov
	goapp.npara12 = This.ubigeocliente
	TEXT To lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidy=This.EJECUTARF(lc, lp, cur)
	If nidy< 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function validarguia()
	If This.idsesion>1 Then
		Set DataSession To  This.idsesion
	Endif
	If This.idprov<1 Then
		This.cmensaje="Ingrese El Proveedor"
		Return 0
	Endif
	If  PermiteIngresoCompras(This.ndoc,This.tdoc,This.idprov,0,This.fecha)<1
		This.cmensaje="NÚmero de Guia Ya Registrado"
		Return 0
	Endif
	If This.validar()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function grabarodi()
	If This.idsesion>1 Then
		Set DataSession To  This.idsesion
	Endif
	s=1
	nidkar=0
	cmensaje=""
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	Na=IngresaResumenDcto('09','E',;
		this.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,'','S',;
		fe_gene.dola,fe_gene.igv,'k',This.idprov,'C',goapp.nidusua,0,goapp.tienda,0,0,0,0,0)
	If Na<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg=This.IngresaGuiasXdcompras(This.fecha,This.ptop,This.ptoll,Na,This.fechat,goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	Do While !Eof()
		If fe_gene.alma_nega=0 Then
			If DevuelveStocks(tmpvg.coda,"Stock")<1 Then
				s=0
				cmensaje='No está activado la venta con Negativos'
				Exit
			Endif
			Do Case
			Case goapp.tienda=1
				Ts=stock.uno
			Case goapp.tienda=2
				Ts=stock.Dos
			Case goapp.tienda=3
				Ts=stock.tre
			Case goapp.tienda=4
				Ts=stock.cua
			Case goapp.tienda=5
				Ts=stock.cin
			Case goapp.tienda=6
				Ts=stock.sei
			Case goapp.tienda=7
				Ts=stock.sie
			Case goapp.tienda=8
				Ts=stock.och
			Case goapp.tienda=9
				Ts=stock.nue
			Case goapp.tienda=10
				Ts=stock.die
			Endcase
			If tmpvg.cant>Ts Then
				s=0
				cmensaje='En Stock '+ Alltrim(Str(Ts,10))+'  no Disponible para esta Transacción '
				Exit
			Endif
		Endif
		nidkar=INGRESAKARDEXR(Na,tmpvg.coda,"V",0,tmpvg.cant,"I","K",0,goapp.tienda,0,0,'')
*INGRESAKARDEXR(.nauto,tmpc.coda,'C',xprec,tmpc.cant,cincl,'K',0,calma,nidcosto,0,tmpc.codigoi)
		If nidkar<1 Then
			s=0
			cmensaje='Al Registrar Kardex'
			Exit
		Endif
		If GrabaDetalleGuias(nidkar,tmpvg.cant,nidg)<1 Then
			s=0
			cmensaje='Al Registrar detalle de Guia'
			Exit
		Endif
		If Actualizastock(tmpvg.coda,goapp.tienda,tmpvg.cant,'V')<1 Then
			s=0
			cmensaje='Al actualizar Stock'
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.generacorrelativo()=1  And s=1 Then
		If This.GRabarCambios()=0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		This.cmensaje=cmensaje
		Return 0
	Endif
	Endfunc
	Function grabarD()
	If This.idsesion>1 Then
		Set DataSession To  This.idsesion
	Endif
	s=1
	nidkar=0
	cmensaje=""
	If This.validar()<1 Then
		Return 0
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	Na=IngresaResumenDcto('09','E',;
		this.ndoc,This.fecha,This.fecha,This.Detalle,0,0,0,'','S',;
		fe_gene.dola,fe_gene.igv,'k',This.idprov,'C',goapp.nidusua,0,goapp.tienda,0,0,0,0,0)
	If Na<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nidg=This.IngresaGuiasXdcompras(This.fecha,This.ptop,This.ptoll,Na,This.fechat,goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	sws=1
	Go Top
	Do While !Eof()
		dfv=Ctod("01/01/0001")
		nidkar=IngresaKardexFl(na,tmpvg.coda,'V',tmpvg.Prec,tmpvg.cant,'I','K',0,goapp.tienda,0,0,tmpvg.equi,;
			tmpvg.unid,tmpvg.idepta,tmpvg.pos,tmpvg.costo,fe_gene.igv,Iif(Empty(tmpvg.fechavto),dfv,tmpvg.fechavto),tmpvg.nlote)
		If nidkar<1
			sws=0
			cmensaje="Al Registrar el detalle de la guia"
			Exit
		Endif
		If GrabaDetalleGuiasCons(tmpvg.coda,tmpvg.cant,nidg,nidkar)=0
			sws=0
			cmensaje="Al Registrar el detalle de la guia por devolución"
			Exit
		Endif
		If Actualizastock1(tmpvg.coda,goapp.tienda,tmpvg.cant,'V',tmpvg.equi)=0 Then
			cmensaje="Al Actualizar Stock"
			sws=0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.generacorrelativo()=1  And s=1 Then
		If This.GRabarCambios()=0 Then
			Return 0
		Endif
		This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		This.cmensaje=cmensaje
		Return 0
	Endif
	Endfunc
Enddefine

