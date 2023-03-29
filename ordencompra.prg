Define Class OrdendeCompra As Odata Of 'd:\capass\database\data.prg'
	CodProducto=0
	Codproveedor=0
	Nprecio=0
	Ncantidad=0
	Cestado=""
	AutoC=0
	Accion=""
	Idr=0
	dfecha=Date()
	cmone=""
	cndoc=""
	ctigv=""
	cobse=""
	caten=""
	cdeta=""
	cdesp=""
	cforma=""
	nv=0
	nigv=0
	nimpo=0
	idserie=0
	nsgte=0
	empresa=""
	Function Registraocompra
	lc='FUNINGRESAORDENCOMPRA'
	cur="oc"
	goapp.npara1=This.dfecha
	goapp.npara2=This.Codproveedor
	goapp.npara3=This.cmone
	goapp.npara4=This.cndoc
	goapp.npara5=This.ctigv
	goapp.npara6=This.cobse
	goapp.npara7=This.caten
	goapp.npara8=This.cdeta
	goapp.npara9=Id()
	goapp.npara10=goapp.nidusua
	goapp.npara11=This.cdesp
	goapp.npara12=This.cforma
	goapp.npara13=This.nv
	goapp.npara14=This.nigv
	goapp.npara15=This.nimpo
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	nid=This.EJECUTARf(lc,lp,cur)
	If nid<1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function IngresaDetalleOrdendeCompra
	lc='PROINGRESADETALLEOCOMPRA'
	cur=""
	goapp.npara1=This.AutoC
	goapp.npara2=This.CodProducto
	goapp.npara3=This.Ncantidad
	goapp.npara4=This.Nprecio
	goapp.npara5=This.Cestado
	Do Case
	Case Empty(This.empresa)
		TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		ENDTEXT
	Case This.empresa ='Norplast'
		TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		ENDTEXT
	Case This.empresa ='lopezycia'
		If goapp.OrdendeCompra='N' Then
			TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
			ENDTEXT
		Else
			goapp.npara1=This.AutoC
			goapp.npara2=This.CodProducto
			goapp.npara3=This.Ncantidad
			goapp.npara4=This.Nprecio
			goapp.npara5=otmpp.uno
			goapp.npara6=otmpp.Dos
			goapp.npara7=otmpp.tre
			goapp.npara8=otmpp.cua
			goapp.npara9=otmpp.cin
			goapp.npara10=otmpp.sei
			TEXT to lp noshow
	        (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
			ENDTEXT
		Endif
	Endcase
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function Actualizaocompra()
	lc='PROACTUALIZAORDENCOMPRA'
	goapp.npara1=This.dfecha
	goapp.npara2=This.Codproveedor
	goapp.npara3=This.cmone
	goapp.npara4=This.cndoc
	goapp.npara5=This.ctigv
	goapp.npara6=This.cobse
	goapp.npara7=This.caten
	goapp.npara8=This.cdeta
	goapp.npara9=goapp.nidusua
	goapp.npara10=This.Idr
	goapp.npara11=This.cdesp
	goapp.npara12=This.cforma
	goapp.npara13=This.nv
	goapp.npara14=This.nigv
	goapp.npara15=This.nimpo
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	If  This.EJECUTARP(lc,lp,'') <1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function DesactivaPedidoOrdendeCompra
	lc='PROActualizaOCOMPRAXD'
	cur=""
	goapp.npara1=This.AutoC
	goapp.npara2=This.CodProducto
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Procedure ActualizaDetalleOrdendeCompra
	lc='PROACTUALIZAOCOMPRA'
	cur=""
	goapp.npara1=This.Idr
	goapp.npara2=This.Accion
	goapp.npara3=This.CodProducto
	goapp.npara4=This.Ncantidad
	goapp.npara5=This.Nprecio
	Do Case
	Case Empty(This.empresa)
		TEXT to lp noshow
			     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		ENDTEXT
	Case This.empresa ='lopezycia'
		If goapp.OrdendeCompra='N' Then
			TEXT to lp noshow
			     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
			ENDTEXT
		Else
			goapp.npara6=otmpp.uno
			goapp.npara7=otmpp.Dos
			goapp.npara8=otmpp.tre
			goapp.npara9=otmpp.cua
			goapp.npara10=otmpp.cin
			goapp.npara11=otmpp.sei
			TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
			ENDTEXT
		Endif
	Endcase
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure PendientesPorRecibir
	Lparameters nidoc,ccursor
	TEXT TO lc NOSHOW TEXTMERGE
	    select idart as coda,descri,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,ocom_idroc,prec from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S") and doco_idro=?nidoc) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart having saldo>0
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure PendientesPorRecibir1
	Lparameters ccursor
	TEXT TO lc NOSHOW TEXTMERGE
	    select idart as codigo,descri,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,prec,ocom_idroc from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f
		inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S")) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro
		inner join fe_prov p on p.idprov=r.ocom_idpr group by idart having saldo>0
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure ProductoPedido
	Lparameters nidart,ccursor
	TEXT TO lc NOSHOW TEXTMERGE
	    select idart as codigo,descri as Producto,unid,sum(pedido) as pedido,sum(recibido) as recibido,sum(pedido)-sum(recibido) as saldo,ocom_fech as fecha,
		p.razo,ocom_ndoc as NumeroOC,ocom_mone as MOneda,prec as Precio,ocom_idroc from(
		SELECT idart,descri,unid,case doco_tipo when 'I' then doco_cant else 0 end as Pedido,
		case doco_tipo when 'S' then doco_cant else 0 end as Recibido,doco_idro,doco_prec as prec
		FROM fe_docom f inner join fe_art g on g.idart=f.doco_coda where doco_acti='A' and doco_tipo in ("I","S") and doco_coda=?nidart) as q
		inner join fe_rocom r on r.ocom_idroc=q.doco_idro inner join fe_prov p on p.idprov=r.ocom_idpr group by idart having saldo>0
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure GeneraVoc
	Lparameters cserie,cnumero
	Create Cursor votmp(coda N(8),Descri c(100),unid c(4),cant N(10,3),Prec N(13,3), d1 N(7,4),nreg N(8),ndoc c(10))
	cn=Val(cnumero)
	Select loc1
	Go Top
	x=1
	F=loc1.idprov
	cdcto=cserie+cnumero
	Do While !Eof()
		If F<>loc1.idprov Then
			F=loc1.idprov
			x=x+1
			cn=cn+1
			cdcto=cserie+Right("00000000"+Alltrim(Str(cn)),8)
		Endif
		If loc1.tmon='S' Then
			nprec=loc1.costosf
		Else
			nprec=loc1.costosf/fe_gene.dola
		Endif
		Insert Into votmp(coda,Descri,unid,ndoc,Prec,cant)Values(loc1.idart,;
			loc1.Descri,loc1.unid,cdcto,nprec/fe_gene.igv,loc1.cant)
		Skip
	Enddo
	Endproc
	Function grabar()
	This.CONTRANSACCION='S'
*Set Procedure To d:\capass\modelos\comprobante Additive
*ocorr=Createobject("comprobantex")
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.AutoC=This.Registraocompra()
	If This.AutoC<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.grabardetalleocompra()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.generacorrelativo(This.nsgte,This.idserie)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	This.CONTRANSACCION=""
	Return 1
	Endfunc
	Function actualizar()
	This.CONTRANSACCION='S'
	If This.IniciaTransaccion()<1 Then
		Return 1
	Endif
	If This.Actualizaocompra()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	This.AutoC=This.Idr
	If This.grabardetalleocompra()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	This.CONTRANSACCION=""
	Return 1
	Endfunc
	Function grabardetalleocompra()
	sw=1
	Select otmpp
	Set Deleted Off
	Go Top
	Do While !Eof()
		If Empty(otmpp.coda)
			Select otmpp
			Skip
			Loop
		Endif
		This.CodProducto=otmpp.coda
		This.Ncantidad=otmpp.cant
		This.Nprecio =otmpp.Prec
		If Deleted()
			If otmpp.nreg>0
				This.Idr=otmpp.nreg
				This.Accion='E'
				If This.ActualizaDetalleOrdendeCompra()<1 Then
					sw=0
					Exit
				Endif
			Endif
			Select  otmpp
			Skip
			Loop
		Endif
		If otmpp.nreg=0
			If This.IngresaDetalleOrdendeCompra()<1 Then
				sw=0
				Exit
			Endif
		Else
			This.Idr=otmpp.nreg
			This.Accion='M'
			If This.ActualizaDetalleOrdendeCompra()<1 Then
				sw=0
				Exit
			Endif
		Endif
		Select otmpp
		Skip
	Enddo
	Set Deleted On
	Return sw
	Endfunc
	Function generacorrelativo(np1,np2)
	lc="ProGeneraCorrelativo"
	goapp.npara1=np1
	goapp.npara2=np2
	cur=""
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
**************************************
	Function CreaTemporal(Calias)
	Set DataSession To This.idsesion
	Create Cursor (Calias)(coda N(8), Descri c(150), unid c(4), cant N(10, 3), Prec N(13, 3), d1 N(7, 4), nreg N(8), ndoc c(10), nitem N(5), uno N(10, 2), Dos N(10, 2), ;
		incluido c(1), razo c(120), aten c(120), Moneda c(20), facturar c(200), despacho c(200), Forma c(100), observa c(200), fech d,;
		tipro c(1), come N(8, 2), Comc N(8, 2),tre N(10,2),cua N(10,2),cin N(10,2),sei N(10,2),Impo N(12,2),Valida c(1),codigo c(20))
	Select (Calias)
	Index On Descri Tag Descri
	Index On nitem Tag Items
	Endfunc
	Function listardetalle(nid,ccursor)
	Set DataSession To This.idsesion
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT   doco_coda,Descri,unid,doco_cant,doco_prec,doco_idro,ocom_mone  FROM fe_rocom as r
	   inner join fe_docom AS d on d.doco_idro=r.ocom_idroc 
       INNER JOIN fe_art AS a ON a.idart=d.doco_coda WHERE doco_idro=<<nid>> AND doco_acti='A' and r.ocom_acti='A'
    ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	FUNCTION mostrarocompralopez(cndoc,ccursor) 	
	TEXT TO lc NOSHOW TEXTMERGE 
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
	  `e`.`nomb`       AS `nomb`,
	  `b`.`doco_uno`   AS `doco_uno`,
	  `b`.`doco_dos`   AS `doco_dos`,
	  `b`.`doco_tre`   AS `doco_tre`,
	  `b`.`doco_cua`   AS `doco_cua`,
	  `b`.`doco_cin`   AS `doco_cin`,
	  `b`.`doco_sei`   AS `doco_sei`
	     FROM `fe_rocom` `a`
     JOIN `fe_docom` `b`    ON `b`.`doco_idro` = `a`.`ocom_idroc`
     JOIN `fe_art` `c`       ON `b`.`doco_coda` = `c`.`idart`
     JOIN `fe_prov` `d`       ON `d`.`idprov` = `a`.`ocom_idpr`
     JOIN `fe_usua` `e`     ON `e`.`idusua` = `a`.`ocom_idus`
     WHERE `a`.`ocom_acti` <> 'I'   AND `b`.`doco_acti` <> 'I' and a.ocom_ndoc='<<cndoc>>'
     ENDTEXT 
     IF this.ejecutaconsulta(lc,ccursor)<1 then
        RETURN 0
     ENDIF
     RETURN 1   
	ENDFUNC
Enddefine
