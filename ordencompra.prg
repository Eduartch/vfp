Define Class OrdendeCompra As Odata Of 'd:\capass\database\data.prg'
	CodProducto = 0
	Codproveedor = 0
	Nprecio = 0
	Ncantidad = 0
	Cestado = ""
	AutoC = 0
	Accion = ""
	Idr = 0
	dFecha = Date()
	cmone = ""
	cndoc = ""
	ctigv = ""
	cobse = ""
	caten = ""
	cdeta = ""
	cdesp = ""
	cforma = ""
	nv = 0
	nigv = 0
	nimpo = 0
	Idserie = 0
	nsgte = 0
	empresa = ""
	Function Registraocompra
	lc = 'FUNINGRESAORDENCOMPRA'
	cur = "oc"
	goApp.npara1 = This.dFecha
	goApp.npara2 = This.Codproveedor
	goApp.npara3 = This.cmone
	goApp.npara4 = This.cndoc
	goApp.npara5 = This.ctigv
	goApp.npara6 = This.cobse
	goApp.npara7 = This.caten
	goApp.npara8 = This.cdeta
	goApp.npara9 = Id()
	goApp.npara10 = goApp.nidusua
	goApp.npara11 = This.cdesp
	goApp.npara12 = This.cforma
	goApp.npara13 = This.nv
	goApp.npara14 = This.nigv
	goApp.npara15 = This.nimpo
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	Endtext
	nid = This.EJECUTARf(lc, lp, cur)
	If nid < 1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function IngresaDetalleOrdendeCompra
	lc = 'PROINGRESADETALLEOCOMPRA'
	cur = ""
	goApp.npara1 = This.AutoC
	goApp.npara2 = This.CodProducto
	goApp.npara3 = This.Ncantidad
	goApp.npara4 = This.Nprecio
	goApp.npara5 = This.Cestado
	Do Case
	Case Empty(This.empresa)
		Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		Endtext
	Case This.empresa = 'Norplast'
		Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		Endtext
	Case This.empresa = 'lopezycia'
		If goApp.OrdendeCompra = 'N' Then
			Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
			Endtext
		Else
			goApp.npara1 = This.AutoC
			goApp.npara2 = This.CodProducto
			goApp.npara3 = This.Ncantidad
			goApp.npara4 = This.Nprecio
			goApp.npara5 = otmpp.uno
			goApp.npara6 = otmpp.Dos
			goApp.npara7 = otmpp.tre
			goApp.npara8 = otmpp.cua
			goApp.npara9 = otmpp.cin
			goApp.npara10 = otmpp.sei
			Text To lp Noshow
	        (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
			Endtext
		Endif
	Endcase
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function Actualizaocompra()
	lc = 'PROACTUALIZAORDENCOMPRA'
	goApp.npara1 = This.dFecha
	goApp.npara2 = This.Codproveedor
	goApp.npara3 = This.cmone
	goApp.npara4 = This.cndoc
	goApp.npara5 = This.ctigv
	goApp.npara6 = This.cobse
	goApp.npara7 = This.caten
	goApp.npara8 = This.cdeta
	goApp.npara9 = goApp.nidusua
	goApp.npara10 = This.Idr
	goApp.npara11 = This.cdesp
	goApp.npara12 = This.cforma
	goApp.npara13 = This.nv
	goApp.npara14 = This.nigv
	goApp.npara15 = This.nimpo
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	Endtext
	If  This.EJECUTARP(lc, lp, '') < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function DesactivaPedidoOrdendeCompra
	lc = 'PROActualizaOCOMPRAXD'
	cur = ""
	goApp.npara1 = This.AutoC
	goApp.npara2 = This.CodProducto
	Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lc, lp, cur) = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Procedure ActualizaDetalleOrdendeCompra
	lc = 'PROACTUALIZAOCOMPRA'
	cur = ""
	goApp.npara1 = This.Idr
	goApp.npara2 = This.Accion
	goApp.npara3 = This.CodProducto
	goApp.npara4 = This.Ncantidad
	goApp.npara5 = This.Nprecio
	Do Case
	Case Empty(This.empresa)
		Text To lp Noshow
			     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		Endtext
	Case This.empresa = 'lopezycia'
		If goApp.OrdendeCompra = 'N' Then
			Text To lp Noshow
			     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
			Endtext
		Else
			goApp.npara6 = otmpp.uno
			goApp.npara7 = otmpp.Dos
			goApp.npara8 = otmpp.tre
			goApp.npara9 = otmpp.cua
			goApp.npara10 = otmpp.cin
			goApp.npara11 = otmpp.sei
			Text To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
			Endtext
		Endif
	Endcase
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure PendientesPorRecibir
	Lparameters nidoc, ccursor
	Text To lc Noshow Textmerge
	    select idart as coda,descri,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,ocom_idroc,prec,prod_cod1 from(
		SELECT idart,descri,unid,prod_cod1,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S") and doco_idro=?nidoc) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart,descri,unid,prod_cod1,ocom_fech,razo,ocom_ndoc,ocomo_idroc having saldo>0
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure PendientesPorRecibir1
	Lparameters ccursor
	Text To lc Noshow Textmerge
	    select idart as codigo,descri,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,prec,ocom_idroc from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S")) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart having saldo>0
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure ProductoPedido
	Lparameters nidart, ccursor
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lc Noshow Textmerge
	    select idart as codigo,descri as Producto,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,ocom_mone as MOneda,prec as Precio,ocom_idroc from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S") and doco_coda=<<nidart>>) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart,descri,unid,ocom_fech,ocom_ndoc,ocom_mone,ocom_idroc,prec having saldo>0
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure GeneraVoc
	Lparameters cserie, cnumero
	Create Cursor votmp(coda N(8), Descri c(100), Unid c(4), cant N(10, 3), Prec N(13, 3), d1 N(7, 4), nreg N(8), ndoc c(10))
	cn = Val(cnumero)
	Select loc1
	Go Top
	x = 1
	F = loc1.idprov
	cdcto = cserie + cnumero
	Do While !Eof()
		If F <> loc1.idprov Then
			F = loc1.idprov
			x = x + 1
			cn = cn + 1
			cdcto = cserie + Right("00000000" + Alltrim(Str(cn)), 8)
		Endif
		If loc1.tmon = 'S' Then
			nprec = loc1.costosf
		Else
			nprec = loc1.costosf / fe_gene.dola
		Endif
		Insert Into votmp(coda, Descri, Unid, ndoc, Prec, cant)Values(loc1.idart, ;
			  loc1.Descri, loc1.Unid, cdcto, nprec / fe_gene.igv, loc1.cant)
		Skip
	Enddo
	Endproc
	Function grabar()
	This.CONTRANSACCION = 'S'
*Set Procedure To d:\capass\modelos\comprobante Additive
*ocorr=Createobject("comprobantex")
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.AutoC = This.Registraocompra()
	If This.AutoC < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.grabardetalleocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.generacorrelativo(This.nsgte, This.Idserie) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function actualizar()
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() < 1 Then
		Return 1
	Endif
	If This.Actualizaocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	This.AutoC = This.Idr
	If This.grabardetalleocompra() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function grabardetalleocompra()
	Sw = 1
	Select otmpp
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Empty(otmpp.coda)
			Select otmpp
			Skip
			Loop
		Endif
		This.CodProducto = otmpp.coda
		This.Ncantidad = otmpp.cant
		This.Nprecio = otmpp.Prec
		If Deleted()
			If otmpp.nreg > 0
				This.Idr = otmpp.nreg
				This.Accion = 'E'
				If This.ActualizaDetalleOrdendeCompra() < 1 Then
					Sw = 0
					Exit
				Endif
			Endif
			Select  otmpp
			Skip
			Loop
		Endif
		If otmpp.nreg = 0
			If This.IngresaDetalleOrdendeCompra() < 1 Then
				Sw = 0
				Exit
			Endif
		Else
			This.Idr = otmpp.nreg
			This.Accion = 'M'
			If This.ActualizaDetalleOrdendeCompra() < 1 Then
				Sw = 0
				Exit
			Endif
		Endif
		Select otmpp
		Skip
	Enddo
	Set Deleted On
	Return Sw
	Endfunc
	Function generacorrelativo(np1, np2)
	lc = "ProGeneraCorrelativo"
	goApp.npara1 = np1
	goApp.npara2 = np2
	cur = ""
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
**************************************
	Function CreaTemporal(Calias)
	If This.Idsesion > 0
		Set DataSession To This.Idsesion
	Endif
	Create Cursor (Calias)(coda N(8), Descri c(150), Unid c(4), cant N(10, 3), Prec N(13, 3), d1 N(7, 4), nreg N(8), ndoc c(10), Nitem N(5), uno N(10, 2), Dos N(10, 2), ;
		  incluido c(1), razo c(120), aten c(120), Moneda c(20), facturar c(200), despacho c(200), Forma c(100), observa c(200), fech d, ;
		  tipro c(1), come N(8, 2), Comc N(8, 2), tre N(10, 2), cua N(10, 2), cin N(10, 2), sei N(10, 2), Impo N(12, 2), Valida c(1), Codigo c(20), ;
		  despacharpor c(100), ructr c(11), direcciont c(100), contactot c(100), telefonot c(20), valor N(12, 2), igv N(12, 2), Total N(12, 2))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function listardetalle(nid, ccursor)
	Set DataSession To This.Idsesion
	Text To lc Noshow Textmerge
   	   SELECT   doco_coda,Descri,unid,doco_cant,doco_prec,doco_idro,ocom_mone,
	   ROUND(IF(tmon='S',(a.prec*v.igv)+f.prec,(a.prec*v.igv*IF(prod_dola>v.dola,prod_dola,v.dola))+f.prec),2) AS costo,
	   ROUND(IF(tmon='S',(a.prec*v.igv),(f.prec*v.igv*v.dola)),2) AS costosf,f.prec AS flete
	   FROM fe_rocom AS r
	   INNER JOIN fe_docom AS d ON d.doco_idro=r.ocom_idroc
	   INNER JOIN fe_art AS a ON a.idart=d.doco_coda
	   INNER JOIN fe_fletes AS f ON f.`idflete`=a.`idflete`, fe_gene AS v
	   WHERE doco_idro=<<nid>> AND doco_acti='A' AND r.ocom_acti='A'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarocompralopez(cndoc, ccursor)
	If goApp.OrdendeCompra = 'N' Then
		Text To lc Noshow Textmerge
	       SELECT `b`.`doco_iddo`  AS `doco_iddo`,	  `b`.`doco_coda`  AS `doco_coda`,
		  `b`.`doco_cant`  AS `doco_cant`,	  `b`.`doco_prec`  AS `doco_prec`,
		  `c`.`descri`     AS `descri`,	  `c`.`prod_smin`  AS `prod_smin`,
		  `c`.`unid`       AS `unid`,c.prod_cod1,	  `c`.`prod_smax`  AS `prod_smax`,
		  `a`.`ocom_valor` AS `ocom_valor`,	  `a`.`ocom_igv`   AS `ocom_igv`,	  `a`.`ocom_impo`  AS `ocom_impo`,	  `a`.`ocom_idroc` AS `ocom_idroc`,
		  `a`.`ocom_fech`  AS `ocom_fech`,	  `a`.`ocom_idpr`  AS `ocom_idpr`,	  `a`.`ocom_desp`  AS `ocom_desp`,	  `a`.`ocom_form`  AS `ocom_form`,
		  `a`.`ocom_mone`  AS `ocom_mone`,	  `a`.`ocom_ndoc`  AS `ocom_ndoc`,	  `a`.`ocom_tigv`  AS `ocom_tigv`,
		  `a`.`ocom_obse`  AS `ocom_obse`,	  `a`.`ocom_aten`  AS `ocom_aten`,	  `a`.`ocom_deta`  AS `ocom_deta`,
		  `a`.`ocom_idus`  AS `ocom_idus`,	  `a`.`ocom_fope`  AS `ocom_fope`,	  `a`.`ocom_idpc`  AS `ocom_idpc`,	  `a`.`ocom_idac`  AS `ocom_idac`,
		  `a`.`ocom_fact`  AS `ocom_fact`,	  `d`.`razo`       AS `razo`,	  `e`.`nomb`       AS `nomb`
		     FROM `fe_rocom` `a`
	     JOIN `fe_docom` `b`    ON `b`.`doco_idro` = `a`.`ocom_idroc`
	     JOIN `fe_art` `c`       ON `b`.`doco_coda` = `c`.`idart`
	     JOIN `fe_prov` `d`       ON `d`.`idprov` = `a`.`ocom_idpr`
	     JOIN `fe_usua` `e`     ON `e`.`idusua` = `a`.`ocom_idus`
	     WHERE `a`.`ocom_acti` <> 'I'   AND `b`.`doco_acti` <> 'I' and a.ocom_ndoc='<<cndoc>>'
		Endtext
	Else
		Text To lc Noshow Textmerge
		  SELECT
		  `b`.`doco_iddo`  AS `doco_iddo`,	  `b`.`doco_coda`  AS `doco_coda`,
		  `b`.`doco_cant`  AS `doco_cant`,	  `b`.`doco_prec`  AS `doco_prec`,
		  `c`.`descri`     AS `descri`,	  `c`.`prod_smin`  AS `prod_smin`,
		  `c`.`unid`       AS `unid`,c.prod_cod1,	  `c`.`prod_smax`  AS `prod_smax`,
		  `a`.`ocom_valor` AS `ocom_valor`,	  `a`.`ocom_igv`   AS `ocom_igv`,	  `a`.`ocom_impo`  AS `ocom_impo`,	  `a`.`ocom_idroc` AS `ocom_idroc`,
		  `a`.`ocom_fech`  AS `ocom_fech`,	  `a`.`ocom_idpr`  AS `ocom_idpr`,	  `a`.`ocom_desp`  AS `ocom_desp`,	  `a`.`ocom_form`  AS `ocom_form`,
		  `a`.`ocom_mone`  AS `ocom_mone`,	  `a`.`ocom_ndoc`  AS `ocom_ndoc`,	  `a`.`ocom_tigv`  AS `ocom_tigv`,
		  `a`.`ocom_obse`  AS `ocom_obse`,	  `a`.`ocom_aten`  AS `ocom_aten`,	  `a`.`ocom_deta`  AS `ocom_deta`,
		  `a`.`ocom_idus`  AS `ocom_idus`,	  `a`.`ocom_fope`  AS `ocom_fope`,	  `a`.`ocom_idpc`  AS `ocom_idpc`,	  `a`.`ocom_idac`  AS `ocom_idac`,
		  `a`.`ocom_fact`  AS `ocom_fact`,	  `d`.`razo`       AS `razo`,	  `e`.`nomb`       AS `nomb`,	  `b`.`doco_uno`   AS `doco_uno`,
		  `b`.`doco_dos`   AS `doco_dos`,	  `b`.`doco_tre`   AS `doco_tre`,	  `b`.`doco_cua`   AS `doco_cua`,	  `b`.`doco_cin`   AS `doco_cin`,	  `b`.`doco_sei`   AS `doco_sei`
		     FROM `fe_rocom` `a`
	     JOIN `fe_docom` `b`    ON `b`.`doco_idro` = `a`.`ocom_idroc`
	     JOIN `fe_art` `c`       ON `b`.`doco_coda` = `c`.`idart`
	     JOIN `fe_prov` `d`       ON `d`.`idprov` = `a`.`ocom_idpr`
	     JOIN `fe_usua` `e`     ON `e`.`idusua` = `a`.`ocom_idus`
	     WHERE `a`.`ocom_acti` <> 'I'   AND `b`.`doco_acti` <> 'I' and a.ocom_ndoc='<<cndoc>>'
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarocompra(cndoc, ccursor)
	Text To lc Noshow Textmerge
	  SELECT
	  `b`.`doco_iddo`  AS `doco_iddo`,
	  `b`.`doco_coda`  AS `doco_coda`,
	  `b`.`doco_cant`  AS `doco_cant`,
	  `b`.`doco_prec`  AS `doco_prec`,
	  `c`.`descri`     AS `descri`,
	  `c`.`prod_smin`  AS `prod_smin`,
	  `c`.`unid`       AS `unid`,c.prod_cod1,
	  `c`.`prod_smax`  AS `prod_smax`,
	  `a`.`ocom_valor` AS `ocom_valor`,
	  `a`.`ocom_igv`   AS `ocom_igv`,
	  `a`.`ocom_impo`  AS `ocom_impo`,
	  `a`.`ocom_idroc` AS `ocom_idroc`,
	  `a`.`ocom_fech`  AS `ocom_fech`,
	  `a`.`ocom_idpr`  AS `ocom_idpr`,
	  `a`.`ocom_desp`  AS `ocom_desp`,
	  `a`.`ocom_form`  AS `ocom_form`,
	  `a`.`ocom_mone`  AS `ocom_mone`,
	  `a`.`ocom_ndoc`  AS `ocom_ndoc`,
	  `a`.`ocom_tigv`  AS `ocom_tigv`,
	  `a`.`ocom_obse`  AS `ocom_obse`,
	  `a`.`ocom_aten`  AS `ocom_aten`,
	  `a`.`ocom_deta`  AS `ocom_deta`,
	  `a`.`ocom_idus`  AS `ocom_idus`,
	  `a`.`ocom_fope`  AS `ocom_fope`,
	  `a`.`ocom_idpc`  AS `ocom_idpc`,
	  `a`.`ocom_idac`  AS `ocom_idac`,
	  `a`.`ocom_fact`  AS `ocom_fact`,
	  `d`.`razo`       AS `razo`,
	  `e`.`nomb`       AS `nomb`
	 FROM `fe_rocom` `a`
     JOIN `fe_docom` `b`    ON `b`.`doco_idro` = `a`.`ocom_idroc`
     JOIN `fe_art` `c`       ON `b`.`doco_coda` = `c`.`idart`
     JOIN `fe_prov` `d`       ON `d`.`idprov` = `a`.`ocom_idpr`
     JOIN `fe_usua` `e`     ON `e`.`idusua` = `a`.`ocom_idus`
     WHERE `a`.`ocom_acti` <> 'I'   AND `b`.`doco_acti` <> 'I' and a.ocom_ndoc='<<cndoc>>'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function verificarpdtes(nid, ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lc Noshow  Textmerge
	    SELECT ocom_idroc AS idauto FROM (
		SELECT idart,SUM(pedido) AS pedido,SUM(recibido) AS recibido,SUM(pedido)-SUM(recibido) AS saldo,
		ocom_idroc FROM(
		SELECT idart,CASE doco_tipo WHEN 'I' THEN doco_cant ELSE 0 END AS Pedido,
		CASE doco_tipo WHEN 'S' THEN doco_cant ELSE 0 END AS Recibido,doco_idro
		FROM fe_docom f
		INNER JOIN fe_art g ON g.idart=f.doco_coda WHERE doco_acti='A' AND doco_tipo IN ("I","S")) AS q
		INNER JOIN fe_rocom r ON r.ocom_idroc=q.doco_idro
		INNER JOIN fe_prov p ON p.idprov=r.ocom_idpr
		WHERE r.ocom_idpr=<<nid>> GROUP BY idart,ocom_idroc) AS x WHERE saldo>0 GROUP BY ocom_idroc;
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc

Enddefine




