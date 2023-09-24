Define Class cotizacion As Odata Of 'd:\capass\database\data.prg'
	#Define estado1  'EN ESPERA'
	#Define estado2  'RECHAZADA'
	#Define estado3  'APROBADA'
	dFech	  = Date()
	nidclie	  = 0
	cndoc	  = ""
	nimpo	  = 0
	cform	  = ""
	cusua	  = 0
	nidven	  = 0
	caten	  = ""
	cvalidez  = ""
	cforma	  = ""
	cplazo	  = ""
	centrega  = ""
	cdetalle  = ""
	cgarantia = ""
    cmoneda=  ""
    nsgte=0
    nidserie=0
    ndias=0
    ctdoc=""
    nidautop=0
    dfi=DATE()
    dff=date()
    solomoneda=0
*!*	dfech=Thisform.txtfecha.Value
*!*	nidclie=Thisform.txtcodigo.Value
*!*	cndoc=Thisform.txtserie.Value+Thisform.txtnumero.Value
*!*	nimpo=Thisform.txttotal.Value
*!*	cidpcped=Id()
*!*	cform="E"
*!*	cusua=goapp.nidusua
*!*	nidven=Thisform.cvendedor
*!*	nidtienda=goapp.tienda
*!*	caten=Thisform.txtatencion.Value
*!*	cvalidez=Thisform.txtvalidez.Value
*!*	cforma=Thisform.txtforma.Value
*!*	cplazo=Thisform.txtplazo.Value
*!*	centrega=Thisform.txtentrega.Value
*!*	cdetalle=Thisform.txtobserva.Value


	Function cambiaestadocotizacion(nid, estado)
	Local lc
*:Global cestado
	Do Case
	Case m.estado = 1
		Cestado = estado1
	Case m.estado = 2
		Cestado = estado2
	Otherwise
		Cestado = estado3
	Endcase
	Text To m.lc Noshow Textmerge
      UPDATE fe_rped SET rped_esta='<<cestado>>' WHERE idautop=<<nid>>
	Endtext
	If This.Ejecutarsql(m.lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreatemporalCotizaciones(Calias)
	Create Cursor precios(Precio N(8, 2), coda N(8), iden N(1), Nitem N(3))
	Create  Cursor (Calias) (Descri c(120), Unid c(4), cant N(10, 3), Prec N(13, 5), nreg N(8), idco N(8),moneda c(20), ;
		  ndoc c(10), prevta N(13, 5), Nitem N(5), alma N(10, 2), coda N(8), Valida c(1), pos N(5), costo N(13, 8), pre1 N(8, 2), pre2 N(8, 2), pre3 N(8, 2), ;
		  uno N(10, 2), Dos N(10, 2), tre N(10, 2), cua N(10, 2), calma c(5), aprecios c(1), come N(7), a1 c(15), idped N(10), valida1 c (1), permitido N(1), ;
		  direccion c(180), fono c(15), atencion c(100), vigv N(6, 4), Forma c(100), validez c(100), plazo c(100), entrega c(100), detalle c(180), ;
		  ntotal N(12, 2), Mone c(1), garantia c(100), nruc c(11), nfax c(15), Comc N(7, 4), pmenor N(8, 2), pmayor N(8, 2), ;
		  contacto c(120), Transportista c(120), dire1 c(120), fono1 c(20), dias N(2), vendedor c(100), tipro c(1), Item N(4), ;
		  codc N(6), razon c(120), fech d, cod c(20), orden N(3), coda1 c(15), pre0 N(13, 8), cantoferta N(10, 2), precio1 N(13, 8), Tdoc c(2), swd N(1) Default 0, como N(7, 3), ;
		  importe N(10, 2), idproy N(5), valor N(12, 2), igv N(12, 2))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function listarcotizacionesatmel(np1, dfi, dff, ccursor)
	If np1 = 0
		Text To lc Noshow Textmerge Pretext 1 + 2 + 4
	      		  SELECT a.ndoc,a.fech,b.descri,b.unid,c.cant,c.prec,ROUND(c.cant*c.prec,2) as importe,
		          d.razo,e.nomv,a.idpcped,a.aten,a.forma,a.plazo,a.validez,a.entrega,a.detalle,x.nomb as usua,
    		      if(tipopedido='P','Proforma','Nota Pedido') as tipopedido,a.idautop,a.fecho,a.rped_mone as mone,
		          a.idclie as codigo,rped_esta as estado FROM fe_rped as a
		          inner join fe_ped as c ON(c.idautop=a.idautop)
		          inner join fe_art as b ON(b.idart=c.idart)
		          inner join fe_vend as e ON(e.idven=a.idven)
		          left join fe_clie as d ON(d.idclie=a.idclie)
		          inner join fe_usua as x on x.idusua=a.rped_idus where a.fech between '<<dfi>>' and '<<dff>>' and a.acti='A' and c.acti='A'  order by a.ndoc
		Endtext
	Else
		Text To lc Noshow Textmerge Pretext 1 + 2 + 4
    		      SELECT a.ndoc,a.fech,b.descri,b.unid,c.cant,c.prec,ROUND(c.cant*c.prec,2) as importe,
		          d.razo,e.nomv,a.idpcped,a.aten,a.forma,a.plazo,a.validez,a.entrega,a.detalle,x.nomb as usua,
		          if(tipopedido='P','Proforma','Nota Pedido') as tipopedido,a.idautop,a.fecho,a.rped_mone as mone,
		          a.idclie as codigo,rped_esta  as estado FROM fe_rped as a
		          inner join fe_ped as c ON(c.idautop=a.idautop)
		          inner join fe_art as b ON(b.idart=c.idart)
		          inner join fe_vend as e ON(e.idven=a.idven)
		          left join fe_clie as d ON(d.idclie=a.idclie)
		          inner join fe_usua as x on x.idusua=a.rped_idus
		          where a.fech between '<<dfi>>' and '<<dff>>' and a.idclie=<<np1>> and a.acti='A' and c.acti='A' order by a.ndoc
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarcotizaionesresumidasAtmel(ccursor, nid)
	If nid = 0 Then
		Text To lcconsulta Noshow Textmerge
		  SELECT '20' AS tdoc,ndoc,fech,razo,rped_mone AS mone,valor,igv,impo,r.rped_esta,r.idautop AS idauto FROM fe_rped AS r
	      INNER JOIN fe_clie AS c ON c.idclie=r.idclie
	      WHERE r.acti='A' ORDER BY ndoc+fech DESC
		Endtext
	Else
		Text To lcconsulta Noshow Textmerge
		  SELECT '20' AS tdoc,ndoc,fech,razo,rped_mone AS mone,valor,igv,impo,r.rped_esta,r.idautop AS idauto FROM fe_rped AS r
	      INNER JOIN fe_clie AS c ON c.idclie=r.idclie WHERE r.acti='A' and r.idautop=<<nid>> ORDER BY ndoc+fech DESC
		Endtext
	Endif
	If This.EjecutaConsulta(lcconsulta, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarcotizacion(nid, cndoc, ccursor)
	If nid = 0 Then
		Text To lc Noshow Textmerge
		        SELECT  a.idart,a.descri,a.unid,a.cant,a.idven,a.vendedor,a.prec,a.premay,a.premen,a.fech,a.idautop,a.impo,a.ndoc,a.aten,
				a.forma,a.plazo,a.validez,a.entrega,a.detalle,a.idclie,a.razo,a.nruc,a.dire,a.ciud,a.fono,a.rped_mone,a.nreg,
				b.prod_come as come,b.prod_comc as comc,rped_dias,rped_cont,rped_dire,rped_trans,rped_fono,a.form,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti1,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti1),2),0) as pre1,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti2,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti2),2),0) as pre2,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti3,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti3),2),0) as pre3,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti0,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti0),2),0) as pre0,
				round(if(tmon='S',(b.prec*v.igv)+p.prec,(b.prec*v.igv*v.dola)+p.prec),2) as costo,b.uno,b.dos,b.tre,b.cua,b.prod_idco as idco,prod_ocan,prod_ocom
				FROM vmuestrapedidos a
				inner join fe_art b on b.idart=a.idart
				inner join fe_fletes p on p.idflete=b.idflete, fe_gene v
				WHERE a.ndoc='<<cndoc>>'
		  
		Endtext
	Else
     	Text To lc Noshow Textmerge
		        SELECT b.idart,b.descri,b.unid,a.cant,a.idven,a.vendedor,a.prec,a.premay,a.premen,a.fech,a.idautop,a.impo,a.ndoc,a.aten,
				a.forma,a.plazo,a.validez,a.entrega,a.detalle,a.idclie,a.razo,a.nruc,a.dire,a.ciud,a.fono,a.rped_mone,a.nreg,
				b.prod_come as come,b.prod_comc as comc,rped_dias,rped_cont,rped_dire,rped_trans,rped_fono,a.form,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti1,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti1),2),0) as pre1,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti2,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti2),2),0) as pre2,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti3,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti3),2),0) as pre3,
				ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti0,((b.prec*v.igv*IF(b.prod_dola>v.dola,prod_dola,v.dola))+p.prec)*prod_uti0),2),0) as pre0,
				round(if(tmon='S',(b.prec*v.igv)+p.prec,(b.prec*v.igv*v.dola)+p.prec),2) as costo,b.uno,b.dos,b.tre,b.cua,b.prod_idco as idco,prod_ocan,prod_ocom
				FROM vmuestrapedidos a
				inner join fe_art b on b.idart=a.idart
				inner join fe_fletes p on p.idflete=b.idflete, fe_gene v
		        WHERE a.idautop=<<nid>>
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarcotizacion1(opt, cndoc, ccursor)
	If opt = 0 Then
		Text To lc Noshow Textmerge
		   SELECT  a.idart,a.descri,a.unid,a.cant,a.idven,a.vendedor,a.prec,a.premay,a.premen,a.fech,a.idautop,a.impo,a.ndoc,a.aten,
           a.forma,a.plazo,a.validez,a.entrega,a.detalle,a.idclie,a.razo,a.nruc,a.dire,a.ciud,a.rped_mone,a.nreg,ifnull(a.fono,'') as fono,ifnull(a.fax,'') as fax,
           b.prod_come as come,b.prod_comc as comc,
           ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti1,((b.prec*v.igv*v.dola)+p.prec)*prod_uti1),2),0) as pre1,
           ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti2,((b.prec*v.igv*v.dola)+p.prec)*prod_uti2),2),0) as pre2,
           ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti3,((b.prec*v.igv*v.dola)+p.prec)*prod_uti3),2),0) as pre3,
           round(if(tmon='S',(b.prec*v.igv)+p.prec,(b.prec*v.igv*v.dola)+p.prec),2) as costo,b.uno,b.dos,b.tre,b.cua,b.prod_idco as idco,prod_cod1
           FROM vmuestracotizaciones a
           inner join fe_art b on b.idart=a.idart
           inner join fe_fletes p on p.idflete=b.idflete,
           fe_gene v WHERE a.ndoc='<<cndoc>>'
		Endtext
	Else
		Text To lc Noshow Textmerge
		   SELECT  a.idart,a.descri,a.unid,a.cant,a.idven,a.vendedor,a.prec,a.premay,a.premen,a.fech,a.idautop,a.impo,a.ndoc,a.aten,
           a.forma,a.plazo,a.validez,a.entrega,a.detalle,a.idclie,a.razo,a.nruc,a.dire,a.ciud,a.rped_mone,a.nreg,ifnull(a.fono,'') as fono,ifnull(a.fax,'') as fax,
           b.prod_come as come,b.prod_comc as comc,
           ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti1,((b.prec*v.igv*v.dola)+p.prec)*prod_uti1),2),0) as pre1,
           ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti2,((b.prec*v.igv*v.dola)+p.prec)*prod_uti2),2),0) as pre2,
           ifnull(round(if(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti3,((b.prec*v.igv*v.dola)+p.prec)*prod_uti3),2),0) as pre3,
           round(if(tmon='S',(b.prec*v.igv)+p.prec,(b.prec*v.igv*v.dola)+p.prec),2) as costo,b.uno,b.dos,b.tre,b.cua,b.prod_idco as idco,prod_cod1
           FROM vmuestracotizaciones a
           inner join fe_art b on b.idart=a.idart
           inner join fe_fletes p on p.idflete=b.idflete,fe_gene v
		   WHERE a.idautop=<<opt>>
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarCotizacionesFacturadasmercaderiasResumnen(np1, ccursor)
	Text To m.lc Noshow Textmerge
		SELECT  a.ndoc,a.fech, b.razo, a.Form, a.valor,a.igv,a.Impo,a.idauto,a.fusua From   fe_rcom As a
			 inner Join fe_clie As b On b.idclie=a.idcliente
			 inner Join fe_canjesp As c On  c.canp_idau=a.idauto
			  inner join fe_usua as u on u.idusua=a.idusua
		     Where c.canp_idap = <<np1>> And a.Acti = 'A' And c.canp_acti = 'A'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarCotizacionesFacturadasmercaderiasDetalle(np1, ccursor)
	Text To m.lc Noshow Textmerge
		SELECT  a.ndoc,a.fech, b.razo, a.Form, a.valor,a.igv,a.Impo,a.idauto,a.fusua,
		       p.descri,p.unid,k.cant,k.prec,u.nomb as usuario From   fe_rcom As a
			 inner Join fe_clie As b On b.idclie=a.idcliente
			 inner Join fe_canjesp As c On  c.canp_idau=a.idauto
			 inner join fe_kar as k on k.idauto=a.idauto
			 inner join fe_art as p on p.idart=k.idart
			 inner join fe_usua as u on u.idusua=a.idusua
			 Where c.canp_idap = <<np1>> And a.Acti = 'A' And c.canp_acti = 'A'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraCotizaciones(Cd)
	Text To lc Noshow Textmerge Pretext 7
      SELECT * from vmuestracotizaciones where ndoc='<<cd>>'
	Endtext
	If This.EjecutaConsulta(lc, 'pedidos') < 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcotizacionpornumeropsystr(cndoc, ccursor)
	Text To lc Noshow Textmerge
      SELECT   `a`.`idart` ,`b`.`descri`,`b`.`unid` ,`a`.`cant`,IFNULL(`m`.`idven`,0) AS `idven`,
	  IFNULL(`m`.`nomv`,'') AS `Vendedor`, `a`.`prec`, `b`.`premay`,  `b`.`premen`,
	  `c`.`fech` , `c`.`idautop` ,  `c`.`impo`,  `c`.`ndoc` ,
	  `c`.`aten` ,  `c`.`forma` ,  `c`.`plazo`  ,  `c`.`validez` ,
	  `c`.`entrega` , `c`.`detalle`,  IFNULL(`d`.`idclie`,0) AS `idclie`,
	  IFNULL(`d`.`razo`,'') AS `razo`,  IFNULL(`d`.`nruc`,'') AS `nruc`,  IFNULL(`d`.`dire`,'') AS `dire`,
	  `c`.`rped_mone` AS `rped_mone`,  IFNULL(`d`.`ciud`,'') AS `ciud`,  `d`.`fono`      AS `fono`,
	  `d`.`fax`  ,  `a`.`idped`     AS `nreg`,b.prod_come AS come,b.prod_comc AS comc,
	   IFNULL(ROUND(IF(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti1,((b.prec*v.igv*v.dola)+p.prec)*prod_uti1),2),0) AS pre1,
	   IFNULL(ROUND(IF(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti2,((b.prec*v.igv*v.dola)+p.prec)*prod_uti2),2),0) AS pre2,
	   IFNULL(ROUND(IF(tmon='S',((b.prec*v.igv)+p.prec)*prod_uti3,((b.prec*v.igv*v.dola)+p.prec)*prod_uti3),2),0) AS pre3,
	   ROUND(IF(tmon='S',(b.prec*v.igv)+p.prec,(b.prec*v.igv*v.dola)+p.prec),2) AS costo,b.uno,b.dos,b.tre,b.cua,b.prod_idco AS idco
	   FROM `fe_ped` `a`
	   INNER JOIN `fe_rped` `c`  ON ((`a`.`idautop` = `c`.`idautop`))
	   INNER JOIN `fe_art` `b`   ON ((`b`.`idart` = `a`.`idart`))
	   LEFT JOIN `fe_clie` `d`   ON ((`d`.`idclie` = `c`.`idclie`))
	   LEFT JOIN `fe_vend` `m`   ON ((`m`.`idven` = `c`.`idven`))
	   INNER JOIN fe_fletes p ON p.idflete=b.idflete, fe_gene v
	   WHERE `a`.`acti` <> 'I'   AND `c`.`acti` <> 'I' AND ndoc='<<cndoc>>'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	
Enddefine


