Define Class ventaslopez As Ventas Of d:\capass\modelos\Ventas
	importe = 0
	nvtas = 0
	tipocanje = ''
	Function validarvtaslopez()
	x = validacaja(This.fecha)
	If x = "C"
		This.Cmensaje = "La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif

	If !Empty(This.Calias) Then
		If This.ValidarTemporalVtas(This.Calias) < 1 Then
			Return .F.
		Endif
	Endif
	cndoc = Alltrim(This.serie) + Alltrim(This.numero)
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
	Case This.Tdoc = "01" And !ValidaRuc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) <> 4;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.fecha) <> goApp.mes Or Year(This.fecha) <> Val(goApp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto <= This.fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser mayor a la fecha de Emisión "
		Return .F.
	Case This.nroformapago >= 2 And This.CreditoAutorizado = 0 And vlineacredito(This.Codigo, This.Monto, This.lineacredito) = 0
		This.Cmensaje = "LINEA DE CREDITO FUERA DE LIMITE O TIENE VENCIMIENTOS MAYORES A 30 DIAS"
		Return .F.
	Case This.tipocliente = 'm' And This.nroformapago >= 2
		This.Cmensaje = "No es Posible Realizar esta Venta El Cliente esta Calificado Como MALO"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, 0, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Case PermiteIngresox(This.fecha) = 0
		This.Cmensaje = "Los Ingresos con esta Fecha no estan permitidos por estar Bloqueados "
		Return .F.
	Case goApp.xopcion = 0
		Do Case
		Case Substr(This.serie, 2) = '010' And This.nroformapago = 1
			This.Cmensaje = "Solo Se permiten Ventas Al Crédito Con esta Serie de Comprobantes "
			Return .F.
		Case Substr(This.serie, 2) = '010' And This.nroformapago >= 2 And goApp.nidusua <> goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA AL CRÉDITO"
			Return .F.
		Case Substr(This.serie, 2) = '010' And This.nroformapago = 1 And goApp.nidusua = goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA EN EFECTIVO"
			Return .F.
		Otherwise
			Return .T.
		Endcase
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function ImprimirLopez(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, nvalor, nigv, nimpo)
	Select (np6)
	Go Top
	ni = np3
	If goApp.ImpresionTicket <> 'S' Then
		For x = 1 To np2 - np3
			ni = ni + 1
			Insert Into (np6)(ndoc, Nitem)Values(np4, ni)
		Next
	Endif
	Replace All Tdoc With np1, ndoc With np4, cletras With np5, hash With np7, fech With np8, ;
		codc With np9, guia With np10, direccion With np11, dni With np12, Forma With np13, fono With np14, ;
		vendedor With np15, valor With nvalor, igv With nigv, Total With nimpo, ;
		dias With np16, razon With np17, nruc With np18, contacto With np19, detalle With np20, Archivo With np21, retencion With np22, ptop With goApp.direccion  In (np6)
	Go Top In (np6)
	Do FOXYPREVIEWER.App With "Release"
	Set Procedure To imprimir Additive
	obji = Createobject("Imprimir")
	If goApp.ImpresionTicket = 'S' Then
		obji.Tdoc = np1
		obji.ElijeFormato()
		Select tmpv
		Set Filter To
		Set Order To
		If np1 = '01' Or np1 = '03' Or np1 = '20' Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia <> 'Z'
		Go Top
	Else
		Select tmpv
		Go Top
		Do Case
		Case np1 = '01'
			If Left(np4, 4) = "F008"  Or Left(np4, 4) = "F010" Then
				Report Form factural1 To Printer Prompt Noconsole
			Else
				Report Form factural To Printer Prompt Noconsole
			Endif
		Case np1 = '03'
			If  Left(np4, 4) = "B008" Or Left(np4, 4) = "B010" Then
				Report Form boletal1 To Printer Prompt Noconsole
			Else
				Report Form boletal To Printer Prompt Noconsole
			Endif
		Case np1 = '07'
			Report Form notascl To Printer Prompt Noconsole
		Case np1 = '08'
			Report Form notasdl To Printer Prompt Noconsole
		Case np1 = '20'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + fe_gene.nruc) + 'notasp.frx'
			If File(cArchivo) Then
				Report Form (cArchivo) To Printer Prompt Noconsole
			Else
				Report Form (goApp.reporte) To Printer Prompt Noconsole
			Endif
		Endcase
	Endif
	Endfunc
	Function ValidarTemporalVtas(Calias)
	Local Sw As Integer
*:Global cmensaje
	Sw		 = 1
	Cmensaje = ""
	Select (Calias)
	Scan All
		Do Case
		Case cant = 0
			Sw		 = 0
			Cmensaje = "El Item: " + Alltrim(Desc) + " No Tiene Cantidad "
			Exit
		Case (cant * Prec) <= 0 And tipro = 'K' And costo = 0
			Sw		 = 0
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
	If Sw = 0 Then
		This.Cmensaje = Cmensaje
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrarventasparacanjes(f1, f2, nm, ccursor)
	If (f2 - f1) > 30 Then
		This.Cmensaje = "Máximo 30 Días para filtrar las Ventas"
		Return 0
	Endif
	Set DataSession To This.Idsesion
	dfi = cfechas(f1)
	dff = cfechas(f2)
	nmargen = (nm / 100) + 1
	Set DataSession To This.Idsesion
	If This.formapago = 'E' Then
		Text To lc Noshow Textmerge
		SELECT a.idart,descri,unid,cant as cantidad,importe,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*<<nmargen>>,4) As precio,
		ROUND(cant*(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*<<nmargen>>),2) AS importe1,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec),4) AS costo,cant
		FROM(
		SELECT k.idart,SUM(cant) AS cant,SUM(k.cant*k.prec) AS importe
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='E' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>' and rcom_idtr=0 and r.codt=<<this.almacen>> GROUP BY idart) AS s
		INNER JOIN fe_art AS a ON a.idart=s.idart
		INNER JOIN fe_fletes AS  f ON f.idflete=a.idflete,fe_gene AS g
		Endtext
*!*	    Para Filtrar los Id de los Pedidos
		Text To lcx Noshow Textmerge
		SELECT r.idauto FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='E' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>'  and rcom_idtr=0 and r.codt=<<this.almacen>> GROUP BY idauto
		Endtext
	Else
		Text To lc Noshow Textmerge
	    SELECT a.idart,descri,unid,cant AS cantidad,importe,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*1,4) AS precio,
		ROUND(cant*(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec)*1),2) AS importe1,
		ROUND(IF(a.tmon='S',(a.prec*g.igv)+f.prec,(a.prec*g.igv*g.dola)+f.prec),4) AS costo,cant
		FROM(
		SELECT k.idart,SUM(cant) AS cant,SUM(k.cant*k.prec) AS importe
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		INNER JOIN (SELECT  SUM(`c`.`impo` - `c`.`acta`)AS `saldo`, `c`.`ncontrol`  AS `ncontrol`,`c`.`mone` AS `mone`,rcre_idau AS idauto
		FROM `fe_rcred` `r`
		JOIN `fe_cred` `c` ON `c`.`cred_idrc` = `r`.`rcre_idrc`
		JOIN fe_rcom AS rr ON rr.idauto=r.rcre_idau
		WHERE `r`.`rcre_Acti` = 'A'  AND `c`.`acti` = 'A' AND rr.tdoc='20' AND rr.fech BETWEEN   '<<dfi>>' AND '<<dff>>'
		GROUP BY c.`ncontrol`,`c`.`mone`,r.rcre_idau HAVING (`saldo`=0)) AS yy ON yy.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='C' AND r.fech BETWEEN  '<<dfi>>' AND '<<dff>>' AND rcom_idtr=0 AND r.codt=<<this.almacen>> GROUP BY idart) AS s
		INNER JOIN fe_art AS a ON a.idart=s.idart
		INNER JOIN fe_fletes AS  f ON f.idflete=a.idflete,fe_gene AS g
		Endtext
*!*	    Para Filtrar los Id de los Pedidos
		Text To lcx Noshow Textmerge
		SELECT r.idauto FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		inner join
		(SELECT  SUM(`c`.`impo` - `c`.`acta`)AS `saldo`, `c`.`ncontrol`  AS `ncontrol`,`c`.`mone` AS `mone`,rcre_idau AS idauto
		FROM `fe_rcred` `r`
		JOIN `fe_cred` `c` ON `c`.`cred_idrc` = `r`.`rcre_idrc`
		JOIN fe_rcom AS rr ON rr.idauto=r.rcre_idau
		WHERE `r`.`rcre_Acti` = 'A'  AND `c`.`acti` = 'A' AND rr.tdoc='20' AND rr.fech BETWEEN   '<<dfi>>' AND '<<dff>>'
		GROUP BY c.`ncontrol`,`c`.`mone`,r.rcre_idau HAVING (`saldo`=0)) AS yy ON yy.idauto=r.idauto
		WHERE tdoc='20' AND k.acti='A' AND r.acti='A' AND form='C' AND r.fech BETWEEN '<<dfi>>' AND '<<dff>>'  and rcom_idtr=0 and r.codt=<<this.almacen>> GROUP BY idauto
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	If This.EjecutaConsulta(lcx, 'ldx') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function generatmpcanjes(ccursor)
	Set DataSession To This.Idsesion
	Create Cursor vtas2(Descri c(80), Unid c(4), cant N(10, 2), Prec N(13, 5), coda N(8), idco N(13, 5), Auto N(5), ;
		  ndoc c(12), Nitem N(3), comi N(7, 4), cletras c(150), Cantidad N(10, 2), idautop N(10), costo N(12, 6), valor N(12, 2), igv N(12, 2), Total N(12, 2))
	Create Cursor vtas3(Descri c(80), Unid c(4), cant N(10, 2), Prec N(10, 2), coda N(8), codt N(10), idautop N(10), valor N(12, 2), igv N(12, 2), Total N(12, 2))
	Select (ccursor)
	Go Top
	x = 1
	F = 0
	sws = 1
	cdcto = This.serie + This.numero
	Cmensaje = ""
	cn = Val(This.numero)
	nimporte = 0
	If This.Tdoc = '03' Then
		nmontob = 700
	Else
		nmontob = 2000
	Endif
	Do While !Eof()
		If lcanjes.cant = 0 Then
			Select lcanjes
			Skip
			Loop
		Endif
		If F >= This.Nitems Or nimporte >= nmontob Then
			For i = 1 To This.Nitems - F
				Insert Into vtas2(ndoc, Nitem, Auto)Values(cdcto, i, x)
			Next
			F = 1
			x = x + 1
			cn = cn + 1
			nimporte = 0
			cdcto = This.serie + Right("0000000" + Alltrim(Str(cn)), 8)
		Endif
		F = F + 1
		nimporte = nimporte + (lcanjes.cant * lcanjes.Precio)
		If nimporte <= nmontob Then
			Insert Into vtas2(Descri, Unid, cant, Prec, coda, idco, Auto, ndoc, Nitem, comi, idautop, costo)Values(lcanjes.Descri, lcanjes.Unid, lcanjes.cant, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
			Replace cant With 0 In lcanjes
		Else
			If (lcanjes.cant = 1 And (lcanjes.cant * lcanjes.Precio) >= nmontob) Then
				Insert Into vtas2(Descri, Unid, cant, Prec, coda, idco, Auto, ndoc, Nitem, comi, idautop, costo)Values(lcanjes.Descri, lcanjes.Unid, lcanjes.Cantidad, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
				Replace cant With cant - 1 In lcanjes
				For i = 1 To This.Nitems - F
					Insert Into vtas2(ndoc, Nitem, Auto)Values(cdcto, i, x)
				Next
				F = 1
				x = x + 1
				cn = cn + 1
				nimporte = 0
				cdcto = This.serie + Right("0000000" + Alltrim(Str(cn)), 8)
			Else
				nimporte = nimporte - (lcanjes.cant * lcanjes.Precio)
				ncant = Int((nmontob - nimporte) / lcanjes.Precio)
				If ncant > 0 Then
					nimporte = nimporte + (ncant * lcanjes.Precio)
					Insert Into vtas2(Descri, Unid, cant, Prec, coda, idco, Auto, ndoc, Nitem, comi, idautop, costo)Values(lcanjes.Descri, lcanjes.Unid, ncant, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
					Replace cant With cant - ncant In lcanjes
				Else
					If lcanjes.cant - Int(lcanjes.cant) > 0
						ncant = (nmontob - nimporte) / lcanjes.Precio
						nimporte = nimporte + (ncant * lcanjes.Precio)
						Insert Into vtas2(Descri, Unid, cant, Prec, coda, idco, Auto, ndoc, Nitem, comi, idautop, costo)Values(lcanjes.Descri, lcanjes.Unid, ncant, lcanjes.Precio, lcanjes.idart, 0, x, cdcto, F, 0, 0, lcanjes.costo)
						Replace cant With cant - ncant In lcanjes
					Else
						For i = 1 To This.Nitems - F
							Insert Into vtas2(ndoc, Nitem, Auto)Values(cdcto, i, x)
						Next
						F = 1
						x = x + 1
						cn = cn + 1
						nimporte = 0
						cdcto = This.serie + Right("0000000" + Alltrim(Str(cn)), 8)
					Endif
				Endif
				Select (ccursor)
				Loop
			Endif
		Endif
		Select (ccursor)
		Skip
	Enddo
	nit = F
	For i = 1 To This.Nitems - F
		nit = nit + 1
		Insert Into vtas2(ndoc, Nitem, Auto)Values(cdcto, nit, x)
	Next
*!*		Select * From vtas2 Into Table Addbs(Sys(5) + Sys(2003)) + 'canjes'
	Return 1
	Endfunc
	Function Generacanjes()
	Sw = 1
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Procedure To d:\capass\modelos\correlativos, d:\capass\modelos\ctasxcobrar Additive
	ocorr = Createobject("correlativo")
	octascobrar = Createobject("ctasporcobrar")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	nidrv = This.registracanjes()
	If nidrv < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select xvtas
	Go Top
	Do While !Eof()
		If This.registradctocanjeado(nidrv) < 1 Then
			Sw = 0
			Exit
		Endif
		ocorr.ndoc = xvtas.ndoc
		ocorr.nsgte = This.nsgte
		ocorr.nsgte = Val(Substr(xvtas.ndoc, 5))
		ocorr.Idserie = This.Idserie
		If ocorr.generacorrelativo() < 1  Then
			This.Cmensaje = ocorr.Cmensaje
			Sw = 0
			Exit
		Endif
		Select xvtas
		Skip
	Enddo
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.actualizaCanjespedidos(nidrv) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	This.imprimircanjes()
	Return 1
	Endfunc
	Function registracanjes()
	lc = 'funingrecanjesvtas'
	goApp.npara1 = This.fecha
	goApp.npara2 = This.importe
	goApp.npara3 = This.nvtas
	goApp.npara4 = This.fechai
	goApp.npara5 = This.fechaf
	goApp.npara6 = goApp.nidusua
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	Endtext
	nidr = This.EJECUTARf(lc, lp, 'cvtx')
	If nidr < 0 Then
		Return 0
	Endif
	Return nidr
	Endfunc
	Function registradctocanjeado(nidrv)
	If This.Idsesion > 0 Then
		Set DataSession To  This.Idsesion
	Endif
	ctdoc = This.Tdoc
	cform = 'E'
	cndoc = xvtas.ndoc
	nv = Round(xvtas.importe / fe_gene.igv, 2)
	nigv = Round(xvtas.importe - Round(xvtas.importe / fe_gene.igv, 2), 2)
	nt = xvtas.importe
	ccodp = This.Codigo
	cmvtoc = "I"
	cdeta = 'Canje  ' + Dtoc(This.fechai) + '-' + ' Hasta ' + Dtoc(This.fechaf)
	cdetalle = ''
	nidusua = goApp.nidusua
	nidtda = goApp.Tienda
	NAuto = This.IngresaResumenDctocanjeado(This.Tdoc, cform, xvtas.ndoc, This.fecha, This.fecha, cdeta, nv, nigv, nt, '', 'S', fe_gene.dola, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, fe_gene.idctav, fe_gene.idctai, fe_gene.idctat, '', nidrv)
	If NAuto < 1 Then
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo11(This.fecha, "", this.razon, fe_gene.idctat, nt, 0, 'S', fe_gene.dola, 0, This.Codigo, NAuto, cform, cndoc, This.Tdoc) < 1 Then
		Return 0
	Endif
	If IngresaRvendedores(NAuto, This.Codigo, 4, cform) < 1 Then
		Return 0
	Endif
	If cform <> 'E' Then
		If ctasporcobrar.IngresaCreditosNormalFormaPago(NAuto, This.Codigo, cndoc, 'C', 'S', "", This.fecha, This.fecha, 'B', cndoc, nt, 0, 0, nt, goApp.nidusua, goApp.Tienda, Id(), 'C')
			Return 0
		Endif
	Endif
	Local sws As Integer
	ccodv = 4
	sws = 1
	Select vtas2
	If This.tipocanje = 'I' Then
	Else
		Set Filter To Auto = xvtas.Auto And coda > 0
	Endif
	ccursor = 'vtas2'
	Go Top
	Do While !Eof()
		If INGRESAKARDEX1(NAuto, coda, "V", Prec, cant, "I", "K", ccodv, 0, costo, comi) < 1 Then
			sws = 0
			This.Cmensaje = 'Al Registrar Item ' + Alltrim(Descri)
			Exit
		Endif
		Select (ccursor)
		Skip
	Enddo
	If sws = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function imprimircanjes()
	dFech = This.fecha
	ncodc = This.Codigo
	cguia = ""
	cdire = ""
	cdni = ""
	cforma = 'Efectivo'
	cfono = ""
	cvendedor = 'Oficina'
	ndias = 0
	crazo = '-'
	Cruc = ""
	chash = ""
	cArchivo = ""
	dfvto = This.fecha
	cptop = goApp.direccion
	cContacto = ""
	Npedido = ""
	cdetalle = ""
	ctdoc = This.Tdoc
	If This.tipocanje <> 'I' Then
		Select Descri  As Desc, Unid, cant, Prec, ndoc, '' As Modi, coda, cletras, chash As hash, dFech As fech, ncodc As codc, cguia As guia, ;
			cdire As direccion, cdni As dni, cforma As Forma, cfono As fono, cvendedor As vendedor, ndias As dias, crazo As razon, ctdoc As Tdoc, ;
			Cruc As nruc, 'S' As Mone, cguia As ndo2, cforma As Form, 'I' As IgvIncluido, cdetalle As detalle, cContacto As contacto, cArchivo As Archivo, ;
			dfvto As fechav, valor, igv, Total, '' As copia, cptop As ptop;
			From vtas2 Into Cursor tmpv Readwrite
	Else
		cndoc = This.serie + This.numero
		cletras = Diletras(This.importe, 'S')
		Select Desc, Unid, cant, Prec, cndoc As ndoc, '' As Modi, coda, cletras, chash As hash, dFech As fech, ncodc As codc, cguia As guia, ;
			cdire As direccion, cdni As dni, cforma As Forma, cfono As fono, cvendedor As vendedor, ndias As dias, crazo As razon, ctdoc As Tdoc, ;
			Cruc As nruc, 'S' As Mone, cguia As ndo2, cforma As Form, 'I' As IgvIncluido, cdetalle As detalle, cContacto As contacto, cArchivo As Archivo, ;
			dfvto As fechav, This.valor As valor, This.igv As  igv, This.Monto As Total, '' As copia, cptop As ptop;
			From vtas2  Into Cursor tmpv Readwrite
		titem = _Tally
		nit = titem
		For i = 1 To This.Nitems - titem
			nit = nit + 1
			Insert Into vtas2(ndoc, Nitem)Values(cndoc, nit)
		Next
	Endif
	titem = _Tally
	Go Top In tmpv
	goApp.IgvIncluido = 'I'
	Set Procedure To imprimir Additive
	obji = Createobject("Imprimir")
	If goApp.ImpresionTicket = 'S'  Then
		obji.Tdoc = This.Tdoc
		obji.ElijeFormato()
		If This.Tdoc = '01' Or This.Tdoc = '03' Or This.Tdoc = '20'  Then
			Select * From tmpv Into Cursor copiaor Readwrite
			Replace All copia With 'Z' In copiaor
			Select tmpv
			Append From Dbf("copiaor")
		Endif
		Select tmpv
		Set Filter To !Empty(coda)
		Go Top
		obji.ImprimeComprobanteComoTicket('S')
		Set Filter To copia <> 'Z'
		Go Top
	Else
		Do Case
		Case This.Tdoc = '01'
			If Left(tmpv.ndoc, 4) = "F008" Or Left(tmpv.ndoc, 4) = "B008" Then
				Report Form factural1 To Printer Prompt Noconsole
			Else
				Report Form factural To Printer Prompt Noconsole
			Endif
		Case This.Tdoc = '03'
			If Left(tmpv.ndoc, 4) = "F008" Or Left(tmpv.ndoc, 4) = "B008" Then
				Report Form boletal1 To Printer Prompt Noconsole
			Else
				Report Form boletal To Printer Prompt Noconsole
			Endif
		Case This.Tdoc = '20'
			cArchivo = Addbs(Addbs(Sys(5) + Sys(2003)) + fe_gene.nruc) + 'notasp.frx'
			If File(cArchivo) Then
				Report Form (cArchivo) To Printer Prompt Noconsole
			Else
				Report Form (goApp.reporte) To Printer Prompt Noconsole
			Endif
		Endcase
	Endif
	Endfunc
	Function actualizaCanjespedidos(nidrv)
	vd = 1
	Select ldx
	Scan All
		Text To ulcx Noshow  Textmerge
           UPDATE fe_rcom SET rcom_idtr=<<nidrv>> where idauto=<<ldx.idauto>>
		Endtext
		If This.Ejecutarsql(ulcx) < 1 Then
			vd = 0
			Exit
		Endif
	Endscan
	If vd = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctocanjeado(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24)
	lc = 'FunIngresaCabeceravtascanjeado'
	cur = "Xn"
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
	Text To lparametros Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
	Endtext
	nida = This.EJECUTARf(lc, lparametros, cur)
	If nida < 1 Then
		Return 0
	Endif
	Return nida
	Endfunc
	Function listarcanjesvtas(ccursor)
	Set DataSession To This.Idsesion
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Text To lc Noshow Textmerge
	SELECT canj_fech,canj_vtas,canj_impo,canj_feci,canj_fecf,u.nomb as usuario,canj_fope,r.ndoc,r.impo,r.idauto,canj_idcan,tdoc
	FROM fe_canjesvtas AS c
	inner join fe_usua as u  on u.idusua=c.canj_idus
	INNER JOIN fe_rcom AS r ON r.rcom_idtr=c.canj_idcan
	WHERE canj_fech BETWEEN '<<dfi>>' AND '<<dff>>' AND canj_acti='A'  AND r.acti='A'  ORDER BY canj_fech
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarventaporid(nidauto, ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lc Noshow Textmerge
	  SELECT  a.kar_Cost  AS kar_cost,	  c.idusua,a.kar_comi  AS kar_comi,	  a.codv      AS codv,
	  a.idauto    AS idauto,	  c.codt      AS alma,	  a.kar_idco  AS idcosto,	  a.idkar     AS idkar,
	  a.idart     AS Coda,	  a.cant      AS cant,	  a.prec      AS prec,	  c.valor     AS valor,
	  c.igv       AS igv,	  c.impo      AS impo,	  c.fech      AS fech, c.fecr      AS fecr,	  c.form      AS form,	  c.deta      AS deta,
	  c.exon      AS exon,	  c.ndo2      AS ndo2,	  c.rcom_entr AS rcom_entr,	  c.idcliente AS idclie,	  d.razo      AS razo,	  d.nruc      AS nruc,
	  d.dire      AS dire,	  d.ciud      AS ciud,	  d.ndni      AS ndni,	  a.tipo      AS tipo,	  c.tdoc      AS tdoc,	  c.ndoc      AS ndoc,	  c.dolar     AS dolar,	  c.mone      AS mone,	  b.descri    AS descri,
	  IFNULL(xx.idcaja,0) AS idcaja,	  b.unid      AS unid,	  b.premay    AS pre1,	  b.tipro     AS tipro,
	  b.peso      AS peso,	  b.premen    AS pre2,	  IFNULL(z.vend_idrv,0) AS nidrv,	  c.vigv      AS vigv,	  a.dsnc      AS dsnc, a.dsnd      AS dsnd,	  a.gast      AS gast, c.idcliente AS idcliente,
	  c.codt      AS codt, b.pre3      AS pre3,	  b.cost      AS costo,  b.uno       AS uno,	  b.dos       AS dos,b.tre,b.cua,	  (b.uno + b.dos+b.tre+b.cua) AS TAlma,
	  c.fusua     AS fusua,  p.nomv      AS Vendedor,	  q.nomb      AS Usuario,	  a.incl      AS incl,	  c.rcom_mens AS rcom_mens,rcom_idtr
	FROM fe_art b
    INNER JOIN fe_kar a  ON a.idart = b.idart
    INNER  JOIN fe_rcom c ON a.idauto = c.idauto
    LEFT JOIN fe_caja xx   ON xx.idauto = c.idauto
    INNER JOIN fe_clie d  ON c.idcliente = d.idclie
    INNER  JOIN fe_vend p      ON p.idven = a.codv
    INNER JOIN fe_usua q     ON q.idusua = c.idusua
    LEFT JOIN (SELECT vend_idau,vend_idrv FROM fe_rvendedor WHERE vend_acti='A') AS z  ON z.vend_idau = c.idauto
    WHERE c.acti <> 'I'   AND a.acti <> 'I' AND c.idauto=<<nidauto>> order by idkar
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine












