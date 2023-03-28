Define Class ventaslopez As ventas Of d:\capass\modelos\ventas
	importe=0
	nvtas=0
	Function validarvtaslopez()
	x = validacaja(This.fecha)
	If x = "C"
		This.Cmensaje="La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif

	If !Empty(This.calias) Then
		If This.ValidarTemporalVtas(This.calias)<1 Then
			Return .F.
		Endif
	Endif
	cndoc=Alltrim(This.serie) + Alltrim(This.numero)
	Do Case
	Case This.Codigo = 0 Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
	Case This.ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.tdoc = "01" And !ValidaRuc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.tdoc = "03" And This.monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.monto = 0
		This.Cmensaje="Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) <> 4;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.fecha) <> goapp.mes Or Year(This.fecha) <> Val(goapp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto <= This.fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser mayor a la fecha de Emisión "
		Return .F.
	Case This.nroformapago >= 2 And This.CreditoAutorizado = 0 And vlineacredito(This.Codigo, This.monto, This.lineacredito) = 0
		This.Cmensaje="LINEA DE CREDITO FUERA DE LIMITE O TIENE VENCIMIENTOS MAYORES A 30 DIAS"
		Return .F.
	Case This.tipocliente = 'm' And This.nroformapago >= 2
		This.Cmensaje="No es Posible Realizar esta Venta El Cliente esta Calificado Como MALO"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.tdoc, 0, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Case permiteIngresox(This.fecha) = 0
		This.Cmensaje="Los Ingresos con esta Fecha no estan permitidos por estar Bloqueados "
		Return .F.
	Case goapp.xopcion = 0
		Do Case
		Case Substr(This.serie, 2) = '010' And This.nroformapago = 1
			This.Cmensaje="Solo Se permiten Ventas Al Crédito Con esta Serie de Comprobantes "
			Return .F.
		Case Substr(This.serie, 2) = '010' And This.nroformapago >= 2 And goapp.nidusua <> goapp.nidusuavcredito
			This.Cmensaje="Usuario NO AUTORIZADO PARA ESTA VENTA AL CRÉDITO"
			Return .F.
		Case Substr(This.serie, 2) = '010' And This.nroformapago = 1 And goapp.nidusua = goapp.nidusuavcredito
			This.Cmensaje="Usuario NO AUTORIZADO PARA ESTA VENTA EN EFECTIVO"
			Return .F.
		Otherwise
			Return .T.
		Endcase
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function ImprimirLopez(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,nvalor,nigv,nimpo)
	Select (np6)
	Go Top
	ni=np3
	If goapp.impresionticket<>'S' Then
		For x=1 To np2-np3
			ni=ni+1
			Insert Into (np6)(ndoc,nitem)Values(np4,ni)
		Next
	Endif
	Replace All tdoc With np1,ndoc With np4,cletras With np5,hash With np7,fech With np8,;
		codc With np9,guia With np10,direccion With np11,dni With np12,Forma With np13,fono With np14,;
		vendedor With np15,valor With nvalor,igv With nigv,Total With nimpo,;
		dias With np16,razon With np17,nruc With np18,contacto With np19,detalle With np20,archivo With np21,retencion With np22,ptop With goapp.direccion  In (np6)
	Go Top In (np6)
	Do FOXYPREVIEWER.App With "Release"
	Set Procedure To imprimir Additive
	obji=Createobject("Imprimir")
	If goapp.impresionticket='S' Then
		obji.tdoc=np1
		obji.ElijeFormato()
		Select tmpv
		Set Filter To
		Set Order To
		If np1='01' Or np1='03' Or np1='20' Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia<>'Z'
		Go Top
	Else
		Select tmpv
		Go Top
		Do Case
		Case np1='01'
			If Left(np4,4)="F008"  Or Left(np4,4)="F010" Then
				Report Form factural1 To Printer Prompt Noconsole
			Else
				Report Form factural To Printer Prompt Noconsole
			Endif
		Case np1='03'
			If  Left(np4,4)="B008" Or Left(np4,4)="B010" Then
				Report Form boletal1 To Printer Prompt Noconsole
			Else
				Report Form boletal To Printer Prompt Noconsole
			Endif
		Case np1='07'
			Report Form notascl To Printer Prompt Noconsole
		Case np1='08'
			Report Form notasdl To Printer Prompt Noconsole
		Case np1='20'
			carchivo=Addbs(Addbs(Sys(5)+Sys(2003))+fe_gene.nruc)+'notasp.frx'
			If File(carchivo) Then
				Report Form (carchivo) To Printer Prompt Noconsole
			Else
				Report Form (goapp.reporte) To Printer Prompt Noconsole
			Endif
		Endcase
	Endif
	Endfunc
	Function ValidarTemporalVtas(calias)
	Local sw As Integer
*:Global cmensaje
	sw		 = 1
	Cmensaje = ""
	Select (calias)
	Scan All
		Do Case
		Case cant=0
			sw		 = 0
			Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad "
			Exit
		Case (cant * Prec) <= 0 And tipro = 'K' And costo=0
			sw		 = 0
			Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene costo Para Transferencia Gratuita"
			Exit
*!*			Case Prec < costo And aprecios <> 'A' And grati <> 'S'
*!*				sw		 = 0
*!*				Cmensaje = "El Producto: " + Rtrim(Desc) + " Tiene Un precio Por Debajo del Costo y No esta Autorizado para hacer esta Venta"
*!*				Exit
*!*			Case cant * costo <= 0 And grati = 'S' And Prec = 0
*!*				Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad o Costo para la Transferencia Gratuita"
*!*				sw		 = 0

		Endcase
	Endscan
	If sw = 0 Then
		This.Cmensaje=Cmensaje
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrarventasparacanjes(f1,f2,nm,ccursor)
	SET DATASESSION TO this.idsesion
	dfi=cfechas(f1)
	dff=cfechas(f2)
	nmargen=(nm/100)+1
*GROUP BY idart,descri,unid,costo
	Set DataSession To This.idsesion
	TEXT TO lc NOSHOW textmerge
		SELECT a.idart,descri,unid,cant as cantidad,importe,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*<<nmargen>>,4) As precio,
		ROUND(cant*(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*<<nmargen>>),2) AS importe1,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec),4) AS costo,cant
		FROM(
		SELECT k.idart,SUM(cant) AS cant,SUM(k.cant*k.prec) AS importe
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='E' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>' and rcom_idtr=0 GROUP BY idart) AS s
		INNER JOIN fe_art AS a ON a.idart=s.idart
		INNER JOIN fe_fletes AS  f ON f.idflete=a.idflete,fe_gene AS g
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	TEXT TO lcx NOSHOW textmerge
		SELECT r.idauto
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='E' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>' GROUP BY idauto
	ENDTEXT
	If This.ejecutaconsulta(lcx,'ldx')<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function generatmpcanjes(ccursor)
	Set DataSession To This.idsesion
	Create Cursor vtas2(Descri c(80),unid c(4),cant N(10,2),Prec N(13,5),coda N(8),idco N(13,5),Auto N(5),;
		ndoc c(12),nitem N(3),comi N(7,4),cletras c(150),cantidad N(10,2),idautop N(10),costo N(12,6),valor N(12,2),igv N(12,2),Total N(12,2))
	Create Cursor vtas3(Descri c(80),unid c(4),cant N(10,2),Prec N(10,2),coda N(8),codt N(10),idautop N(10),valor N(12,2),igv N(12,2),Total N(12,2))
	Select (ccursor)
	Go Top
	x=1
	F=0
	sws=1
	cdcto=This.serie+This.numero
	Cmensaje=""
	cn=Val(This.numero)
	nimporte=0
	nmontob=700
	Do While !Eof()
		If lcanjes.cant=0 Then
			Select lcanjes
			Skip
			Loop
		Endif
		If F>=This.nitems Or nimporte>=nmontob Then
			For i=1 To This.nitems-F
				Insert Into vtas2(ndoc,nitem,Auto)Values(cdcto,i,x)
			Next
			F=1
			x=x+1
			cn=cn+1
			nimporte=0
			cdcto=This.serie+Right("0000000"+Alltrim(Str(cn)),8)
		Endif
		F=F+1
		nimporte=nimporte+(lcanjes.cant*lcanjes.Precio)
		If nimporte<=nmontob Then
			Insert Into vtas2(Descri,unid,cant,Prec,coda,idco,Auto,ndoc,nitem,comi,idautop,costo)Values(lcanjes.Descri,lcanjes.unid,lcanjes.cant,lcanjes.Precio,lcanjes.idart,0,x,cdcto,F,0,0,lcanjes.costo)
			Replace cant With 0 In lcanjes
		Else
			If (lcanjes.cant=1 And (lcanjes.cant*lcanjes.Precio)>=nmontob) Then
				Insert Into vtas2(Descri,unid,cant,Prec,coda,idco,Auto,ndoc,nitem,comi,idautop,costo)Values(lcanjes.Descri,lcanjes.unid,lcanjes.cantidad,lcanjes.Precio,lcanjes.idart,0,x,cdcto,F,0,0,lcanjes.costo)
				Replace cant With cant-1 In lcanjes
				For i=1 To This.nitems-F
					Insert Into vtas2(ndoc,nitem,Auto)Values(cdcto,i,x)
				Next
				F=1
				x=x+1
				cn=cn+1
				nimporte=0
				cdcto=This.serie+Right("0000000"+Alltrim(Str(cn)),8)
			Else
				nimporte=nimporte-(lcanjes.cant*lcanjes.Precio)
				ncant=Int((nmontob-nimporte)/lcanjes.Precio)
				If ncant>0 Then
					nimporte=nimporte+(ncant*lcanjes.Precio)
					Insert Into vtas2(Descri,unid,cant,Prec,coda,idco,Auto,ndoc,nitem,comi,idautop,costo)Values(lcanjes.Descri,lcanjes.unid,ncant,lcanjes.Precio,lcanjes.idart,0,x,cdcto,F,0,0,lcanjes.costo)
					Replace cant With cant-ncant In lcanjes
				Else
					If lcanjes.cant-Int(lcanjes.cant)>0
						ncant=(nmontob-nimporte)/lcanjes.Precio
						nimporte=nimporte+(ncant*lcanjes.Precio)
						Insert Into vtas2(Descri,unid,cant,Prec,coda,idco,Auto,ndoc,nitem,comi,idautop,costo)Values(lcanjes.Descri,lcanjes.unid,ncant,lcanjes.Precio,lcanjes.idart,0,x,cdcto,F,0,0,lcanjes.costo)
						Replace cant With cant-ncant In lcanjes
					Else
						For i=1 To This.nitems-F
							Insert Into vtas2(ndoc,nitem,Auto)Values(cdcto,i,x)
						Next
						F=1
						x=x+1
						cn=cn+1
						nimporte=0
						cdcto=This.serie+Right("0000000"+Alltrim(Str(cn)),8)
					Endif
				Endif
				Select (ccursor)
				Loop
			Endif
		Endif
		Select (ccursor)
		Skip
	Enddo
	nit=F
	For i=1 To This.nitems-F
		nit=nit+1
		Insert Into vtas2(ndoc,nitem,Auto)Values(cdcto,nit,x)
	Next
*!*		Select ndoc,Sum(Round(cant*Prec,2)) As importe,Count(*) As nitem,Auto From vtas2 Into Cursor;
*!*			xvtas Readwrite Group By Auto
*!*		Select xvtas
*!*		Do While !Eof()
*!*			cimporte=Diletras(xvtas.importe,'S')
*!*			ntotal=xvtas.importe
*!*			nvalor=Round(xvtas.importe/fe_gene.igv,2)
*!*			nigv=Round(ntotal-nvalor,2)
*!*			Select vtas2
*!*			Replace cletras With cimporte,ndoc With xvtas.ndoc,valor With nvalor,igv With nigv,Total With ntotal For vtas2.Auto=xvtas.Auto
*!*			Select xvtas
*!*			Skip
*!*		Enddo
	Select * From vtas2 Into Table Addbs(Sys(5)+Sys(2003))+'canjes'
*!*		Go Top In xvtas
	Return 1
	Endfunc
	Function generacanjes()
	sw=1
	SET DATASESSION TO this.idsesion
*!*		This.generatmpcanjes("lcanjes")
	Set Procedure To d:\capass\modelos\correlativos,d:\capass\modelos\ctasxcobrar Additive
	ocorr=Createobject("correlativo")
	octascobrar=Createobject("ctasporcobrar")
	If This.iniciatransaccion()<1 Then
		Return 0
	Endif
	nidrv=This.registracanjes()
	If nidrv<1 Then
		This.deshacerCambios()
		Return 0
	Endif
	Select xvtas
	Go Top
	Do While !Eof()
		If This.registradctocanjeado(nidrv)<1 Then
			sw=0
			Exit
		Endif
		ocorr.ndoc=xvtas.ndoc
		ocorr.nsgte=This.nsgte
		ocorr.idserie=This.idserie
		If ocorr.generacorrelativo()<1  Then
			This.Cmensaje=ocorr.Cmensaje
			sw=0
			Exit
		Endif
		Select xvtas
		Skip
	Enddo
	If sw=0 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.actualizaCanjespedidos(nidrv)<1 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.grabarcambios()<1 Then
		Return 0
	Endif
	This.imprimircanjes()
	Return 1
	Endfunc
	Function registracanjes()
	lc='funingrecanjesvtas'
	goapp.npara1=This.fecha
	goapp.npara2=This.importe
	goapp.npara3=This.nvtas
	goapp.npara4=This.fechai
	goapp.npara5=This.fechaf
	goapp.npara6=goapp.nidusua
	TEXT to lp NOSHOW
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	nidr=This.EJECUTARf(lc,lp,'cvtx')
	If nidr<0 Then
		Return 0
	Endif
	Return nidr
	Endfunc
	Function registradctocanjeado(nidrv)
	SET DATASESSION TO  this.idsesion
	ctdoc=This.tdoc
	cform='E'
	cndoc=xvtas.ndoc
	nv=Round(xvtas.importe/fe_gene.igv,2)
	nigv=Round(xvtas.importe-Round(xvtas.importe/fe_gene.igv,2),2)
	nt=xvtas.importe
	ccodp=9083
	ctg="K"
	cor="CK"
	cmvtoc="I"
	cdeta='Canje  '+ Dtoc(This.fechai)+ '-' + ' Hasta '+Dtoc(This.fechaf)
	cdetalle=''
	ndvto=0
	cidpc=Id()
	nidusua=goapp.nidusua
	nidtda=goapp.tienda
	nAuto=This.IngresaResumenDctocanjeado(This.tdoc,cform,cndoc,This.fecha,This.fecha,cdeta,nv,nigv,nt,'','S',fe_gene.dola,fe_gene.igv,'k',ccodp,'V',goapp.nidusua,1,goapp.tienda,fe_gene.idctav,fe_gene.idctai,fe_gene.idctat,'',nidrv)
	If nAuto<1 Then
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo11(This.fecha,"","",fe_gene.idctat,nt,0,'S',fe_gene.dola,0,ccodp,nAuto,cform,cndoc,This.tdoc)<1 Then
		Return 0
	Endif
	If IngresaRvendedores(nAuto,ccodp,4,cform)<1 Then
		Return 0
	Endif
	If cform<>'E' Then
		If ctasporcobrar.IngresaCreditosNormalFormaPago(nAuto,ccodp,cndoc,'C','S',"",This.fecha,This.fecha,'B',cndoc,nt,0,0,nt,goapp.nidusua,goapp.tienda,Id(),'C')
			Return 0
		Endif
	Endif
	Local sws As Integer
	ccodv=4
	sws=1
	Cmensaje=""
	Select vtas2
	Set Filter To Auto=xvtas.Auto And coda>0
	Go Top
	Do While !Eof()
		If INGRESAKARDEX1(nAuto,vtas2.coda,"V",vtas2.Prec,vtas2.cant,"I","K",ccodv,nidtda,vtas2.costo,vtas2.comi)<1 Then
			sws=0
			This.Cmensaje='Al Registrar Item '+Alltrim(vtas2.Descri)
			Exit
		Endif
		Select vtas2
		Skip
	Enddo
	If sws=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function imprimircanjes()
	dfech=This.fecha
	ncodc=This.Codigo
	cguia=""
	cdire=""
	cdni=""
	cforma='Efectivo'
	cfono=""
	cvendedor='Oficina'
	ndias=0
	crazo='-'
	cruc=""
	chash=""
	carchivo=""
	dfvto=This.fecha
	cptop=goapp.direccion

***
	cContacto=""
	Npedido=""
	cdetalle=""
	ctdoc=This.tdoc
***
	Select Descri  As Desc,unid,cant,Prec,ndoc,'' As Modi,coda,cletras,chash As hash,dfech As fech,ncodc As codc,cguia As guia,;
		cdire As direccion,cdni As dni,cforma As Forma,cfono As fono,cvendedor As vendedor,ndias As dias,crazo As razon,ctdoc As tdoc,;
		cruc As nruc,'S' As mone,cguia As ndo2,cforma As Form,'I' As IgvIncluido,cdetalle As detalle,cContacto As contacto,carchivo As archivo,;
		dfvto As fechav,valor,igv,Total,'' As copia,cptop As ptop;
		from vtas2 Into Cursor tmpv Readwrite
	titem=_Tally
	Go Top In tmpv
	goapp.IgvIncluido='I'
	Set Procedure To imprimir Additive
	obji=Createobject("Imprimir")
	If goapp.impresionticket='S'  Then
		obji.tdoc=This.tdoc
		obji.ElijeFormato()
		If This.tdoc='01' Or This.tdoc='03' Or This.tdoc='20'  Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia<>'Z'
		Go Top
	Else
		Do Case
		Case This.tdoc='01'
			If Left(tmpv.ndoc,4)="F008" Or Left(tmpv.ndoc,4)="B008" Then
				Report Form factural1 To Printer Prompt Noconsole
			Else
				Report Form factural To Printer Prompt Noconsole
			Endif
		Case This.tdoc='03'
			If Left(tmpv.ndoc,4)="F008" Or Left(tmpv.ndoc,4)="B008" Then
				Report Form boletal1 To Printer Prompt Noconsole
			Else
				Report Form boletal To Printer Prompt Noconsole
			Endif
		Case This.tdoc='20'
			carchivo=Addbs(Addbs(Sys(5)+Sys(2003))+fe_gene.nruc)+'notasp.frx'
			If File(carchivo) Then
				Report Form (carchivo) To Printer Prompt Noconsole
			Else
				Report Form (goapp.reporte) To Printer Prompt Noconsole
			Endif
		Endcase
	Endif
	Endfunc
	Function actualizaCanjespedidos(nidrv)
	vd=1
	Select ldx
	Scan All
		TEXT TO ulcx TEXTMERGE
           UPDATE fe_rcom SET rcom_idtr=<<nidrv>> where idauto=<<ldx.idauto>>
		ENDTEXT
		If This.ejecutarsql(ulcx)<1 Then
			Exit
			vd=0
		Endif
	Endscan
	If vd=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctocanjeado(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
	lc='FunIngresaCabeceravtascanjeado'
	cur="Xn"
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
	TEXT to lparametros NOSHOW
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
	ENDTEXT
	nida=This.EJECUTARf(lc,lparametros,cur)
	If nida<1 Then
		Return 0
	Endif
	Return nida
	Endfunc
Enddefine
