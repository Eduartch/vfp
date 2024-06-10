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
	Centrega  = ""
	cdetalle  = ""
	Cgarantia = ""
	Cmoneda =  ""
	Nsgte = 0
	nIdserie = 0
	ndias = 0
	cTdoc = ""
	nidautop = 0
	dfi = Date()
	dff = Date()
	solomoneda = 0
	Function cambiaestadocotizacion(nid, estado)
	Local lC
*:Global cestado
	Do Case
	Case m.estado = 1
		Cestado = estado1
	Case m.estado = 2
		Cestado = estado2
	Otherwise
		Cestado = estado3
	Endcase
	Text To m.lC Noshow Textmerge
      UPDATE fe_rped SET rped_esta='<<cestado>>' WHERE idautop=<<nid>>
	Endtext
	If This.Ejecutarsql(m.lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreatemporalCotizaciones(Calias)
	Create Cursor precios(Precio N(8, 2), coda N(8), iden N(1), Nitem N(3))
	Create  Cursor (Calias) (Descri c(120), Unid c(4), cant N(10, 3), Prec N(13, 5), Nreg N(8), idco N(8), Moneda c(20), ;
		  Ndoc c(10), prevta N(13, 5), Nitem N(5), alma N(10, 2), coda N(8), Valida c(1), pos N(5), costo N(13, 8), pre1 N(8, 2), pre2 N(8, 2), Pre3 N(8, 2), ;
		  uno N(10, 2), Dos N(10, 2), tre N(10, 2), cua N(10, 2), calma c(5), aprecios c(1), come N(7), a1 c(15), idped N(10), valida1 c (1), permitido N(1), ;
		  Direccion c(180), fono c(15), atencion c(100), vigv N(6, 4), Forma c(100), validez c(100), plazo c(100), entrega c(100), Detalle c(180), ;
		  nTotal N(12, 2), Mone c(1), garantia c(100), nruc c(11), nfax c(15), Comc N(7, 4), pmenor N(8, 2), pmayor N(8, 2), ;
		  contacto c(120), Transportista c(120), dire1 c(120), fono1 c(20), dias N(2), Vendedor c(100), tipro c(1), Item N(4), ;
		  codc N(6), razon c(120), fech d, Cod c(20), orden N(3), coda1 c(15), pre0 N(13, 8), cantoferta N(10, 2), precio1 N(13, 8), Tdoc c(2), swd N(1) Default 0, como N(7, 3), ;
		  Importe N(10, 2), idproy N(5), valor N(12, 2), igv N(12, 2))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function listarcotizacionesatmel(np1, dfi, dff, Ccursor)
	If np1 = 0
		Text To lC Noshow Textmerge Pretext 1 + 2 + 4
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
		Text To lC Noshow Textmerge Pretext 1 + 2 + 4
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarcotizaionesresumidasAtmel(Ccursor, nid)
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
	If This.EjecutaConsulta(lcconsulta, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarcotizacion(nid, cndoc, Ccursor)

	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		        \Select  a.idart,a.Descri,a.Unid,a.cant,a.idven,a.Vendedor,a.Prec,a.premay,a.premen,a.fech,a.idautop,a.Impo,a.Ndoc,a.aten,
				\a.Forma,a.plazo,a.validez,a.entrega,a.Detalle,a.idclie,a.razo,a.nruc,a.Dire,a.ciud,a.fono,a.rped_mone,a.Nreg,
				\b.prod_come As come,b.prod_comc As Comc,rped_dias,rped_cont,rped_dire,rped_trans,rped_fono,a.Form,
				\ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti1,((b.Prec*v.igv*If(b.prod_dola>v.dola,prod_dola,v.dola))+p.Prec)*prod_uti1),2),0) As pre1,
				\ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti2,((b.Prec*v.igv*If(b.prod_dola>v.dola,prod_dola,v.dola))+p.Prec)*prod_uti2),2),0) As pre2,
				\ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti3,((b.Prec*v.igv*If(b.prod_dola>v.dola,prod_dola,v.dola))+p.Prec)*prod_uti3),2),0) As Pre3,
				\ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti0,((b.Prec*v.igv*If(b.prod_dola>v.dola,prod_dola,v.dola))+p.Prec)*prod_uti0),2),0) As pre0,
				\Round(If(tmon='S',(b.Prec*v.igv)+p.Prec,(b.Prec*v.igv*v.dola)+p.Prec),2) As costo,b.uno,b.Dos,b.tre,b.cua,b.prod_idco As idco,prod_ocan,prod_ocom
				\From vmuestrapedidos a
				\inner Join fe_art b On b.idart=a.idart
				\inner Join fe_fletes p On p.idflete=b.idflete, fe_gene v
				\Where
	If nid = 0 Then
				 \a.Ndoc='<<cndoc>>'
	Else
				 \a.idautop=<<nid>>
	Endif
	\ Order By a.Nreg
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarcotizacion1(opt, cndoc, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		   \Select  a.idart,a.Descri,a.Unid,a.cant,a.idven,a.Vendedor,a.Prec,a.premay,a.premen,a.fech,a.idautop,a.Impo,a.Ndoc,a.aten,
           \a.Forma,a.plazo,a.validez,a.entrega,a.Detalle,a.idclie,a.razo,a.nruc,a.Dire,a.ciud,a.rped_mone,a.Nreg,ifnull(a.fono,'') As fono,ifnull(a.fax,'') As fax,
           \b.prod_come As come,b.prod_comc As Comc,
           \ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti1,((b.Prec*v.igv*v.dola)+p.Prec)*prod_uti1),2),0) As pre1,
           \ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti2,((b.Prec*v.igv*v.dola)+p.Prec)*prod_uti2),2),0) As pre2,
           \ifnull(Round(If(tmon='S',((b.Prec*v.igv)+p.Prec)*prod_uti3,((b.Prec*v.igv*v.dola)+p.Prec)*prod_uti3),2),0) As Pre3,
           \Round(If(tmon='S',(b.Prec*v.igv)+p.Prec,(b.Prec*v.igv*v.dola)+p.Prec),2) As costo,b.uno,b.Dos,b.tre,b.cua,b.prod_idco As idco,prod_cod1
           \From vmuestracotizaciones a
           \inner Join fe_art b On b.idart=a.idart
           \inner Join fe_fletes p On p.idflete=b.idflete,
           \fe_gene v Where
	If opt = 0 Then
           \a.Ndoc='<<cndoc>>'
	Else
            \a.idautop=<<opt>>
	Endif
           \Order By Nreg
	Set Textmerge Off
	Set Textmerge To

	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarCotizacionesFacturadasmercaderiasResumnen(np1, Ccursor)
	Text To m.lC Noshow Textmerge
		SELECT  a.ndoc,a.fech, b.razo, a.Form, a.valor,a.igv,a.Impo,a.idauto,a.fusua From   fe_rcom As a
			 inner Join fe_clie As b On b.idclie=a.idcliente
			 inner Join fe_canjesp As c On  c.canp_idau=a.idauto
			  inner join fe_usua as u on u.idusua=a.idusua
		     Where c.canp_idap = <<np1>> And a.Acti = 'A' And c.canp_acti = 'A'
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MostrarCotizacionesFacturadasmercaderiasDetalle(np1, Ccursor)
	Text To m.lC Noshow Textmerge
		SELECT  a.ndoc,a.fech, b.razo, a.Form, a.valor,a.igv,a.Impo,a.idauto,a.fusua,
		       p.descri,p.unid,k.cant,k.prec,u.nomb as usuario From   fe_rcom As a
			 inner Join fe_clie As b On b.idclie=a.idcliente
			 inner Join fe_canjesp As c On  c.canp_idau=a.idauto
			 inner join fe_kar as k on k.idauto=a.idauto
			 inner join fe_art as p on p.idart=k.idart
			 inner join fe_usua as u on u.idusua=a.idusua
			 Where c.canp_idap = <<np1>> And a.Acti = 'A' And c.canp_acti = 'A'
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraCotizaciones(Cd)
	Text To lC Noshow Textmerge Pretext 7
      SELECT * from vmuestracotizaciones where ndoc='<<cd>>'
	Endtext
	If This.EjecutaConsulta(lC, 'pedidos') < 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcotizacionpornumeropsystr(cndoc, Ccursor)
	Text To lC Noshow Textmerge
      SELECT   `a`.`idart` ,`b`.`descri`,`b`.`unid` ,`a`.`cant`,IFNULL(`m`.`idven`,0) AS `idven`,
	  IFNULL(`m`.`nomv`,'') AS `Vendedor`, `a`.`prec`, `b`.`premay`,  `b`.`premen`,
	  `c`.`fech` , `c`.`idautop` ,  `c`.`impo`,  `c`.`ndoc` ,
	  `c`.`aten` ,  `c`.`forma` ,  `c`.`plazo`  ,  `c`.`validez` ,
	  `c`.`entrega` , `c`.`detalle`,  IFNULL(`d`.`idclie`,0) AS `idclie`,
	  IFNULL(`d`.`razo`,'') AS `razo`,  IFNULL(`d`.`nruc`,'') AS `nruc`,  IFNULL(`d`.`dire`,'') AS `dire`,
	  `c`.`rped_mone` AS `rped_mone`,  IFNULL(`d`.`ciud`,'') AS `ciud`,  `d`.`fono`      AS `fono`,d.ndni,
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparacanje(cnumero, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  a.Descri,a.Unid,b.Prec,b.idart As coda,a.cost,
	\b.cant,c.idclie As codc,x.nomb As usua,c.Form,d.razo,d.Dire,c.rped_idus,
	\d.ciud,ifnull(d.ndni,'') As ndni,d.nruc,c.Tdoc,c.idven,c.idautop,c.facturado,
	\a.prod_idco,c.rped_tipo,c.Ndoc,a.prod_come As comi,a.prod_cod1,c.Detalle,a.prod_icbper,
	\Round(If(a.tmon='S',(a.Prec*v.igv)+p.Prec,(a.Prec*v.igv*v.dola)+p.Prec),2) As costo
	If goApp.Clienteconproyectos = 'S'
	  \,rped_idpr
	Endif
	If goApp.Productoscp = 'S' Then
	   \,a.prod_ubi1,prod_ubi2,prod_ubi3,prod_ubi4,prod_ubi5
	Endif
	\From fe_ped  As b
	\      inner Join fe_art As a On (a.idart=b.idart)
	\       inner Join fe_rped As c On(c.idautop=b.idautop)
	\	   inner Join fe_clie As d On(d.idclie=c.idclie)
	\	   inner Join fe_usua As x On x.idusua=c.rped_idus
	\	   inner Join fe_fletes As p On p.idflete=a.idflete,fe_gene v
	\	   Where c.Ndoc='<<cnumero>>' And b.cant>0 And b.Prec>0 And b.Acti='A' And c.Acti='A'
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparacanjepsysm(cnumero, Ccursor)
	Text To m.lC Noshow Textmerge Pretext 7
	   select a.descri,a.unid,b.prec,b.idart as coda,a.cost,c.ndoc,
	   b.cant,c.idclie as codc,x.nomb as usua,c.form,d.razo,d.dire,d.ciud,ifnull(d.ndni,'') as ndni,d.nruc,c.tdoc,c.idven,c.idautop,c.facturado,
	   a.prod_idco,c.rped_auto,b.pedi_perc,c.rped_incl,c.rped_sper,c.rped_agen,d.clie_corr,a.prod_perc,prod_icbper,rped_dias,forma,rped_mone,prod_detr
       FROM fe_ped  as b
       INNER JOIN fe_art as a ON (a.idart=b.idart)
       INNER JOIN fe_rped as c ON(c.idautop=b.idautop)
	   INNER JOIN fe_clie as d On(d.idclie=c.idclie)
	   inner join fe_usua as x on x.idusua=c.rped_idus
	   WHERE c.ndoc='<<cnumero>>' AND    b.cant>0 and b.prec>0 and b.acti='A' and c.acti='A'
	Endtext
	If This.EjecutaConsulta(m.lC, "pedidos") < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparacanjespsysb(cnumero, Ccursor)
	Text To lC Noshow Textmerge Pretext 7
	   SELECT a.dped_cost  AS costo,
	   c.tdoc,  c.form, c.idclie , a.idart, b.prod_tigv  AS prod_tigv,  b.descri     AS descri,
	   x.pres_desc  AS unid,  a.cant       AS cant,  a.prec,  b.premay,  b.premen     AS premen,  c.fech       AS fech,  c.idautop    AS idautop,
	   c.impo       AS impo,  a.dped_epta  AS dped_epta,  c.ndoc,  b.prod_idco  AS idco,  b.uno, b.dos,b.tre, b.cua,  a.dped_equi,  n.nomb       AS Usuario,  c.rped_idus  AS rped_idus,  c.idpcped    AS idpcped,  c.fecho      AS fecho,  m.nomv       AS nomv,
	   c.idven      AS idven,  c.idtienda   AS idtienda,  c.facturado  AS facturado,  a.dped_posi  AS dped_posi,  c.aten       AS aten,  c.forma,
	   b.prod_equi1 AS equi1,  b.prod_equi2 AS equi2,  c.plazo      AS plazo,  c.validez    AS validez,  b.premay     AS pre1,  b.premen     AS pre2,  IFNULL(b.pre3,0) AS pre3,
	   a.idped      AS nreg,d.razo,d.dire,d.ciud,d.ndni,d.nruc,d.clie_lcre
	    FROM fe_ped a
	    JOIN fe_rped c       ON a.idautop = c.idautop
	    JOIN fe_art b       ON b.idart = a.idart
	    JOIN fe_fletes p     ON p.idflete = b.idflete    
		JOIN fe_vend m       ON m.idven = c.idven
	    JOIN fe_usua n     ON n.idusua = c.rped_idus
	    JOIN fe_epta v    ON v.epta_idep = a.dped_epta
	    JOIN fe_presentaciones x   ON x.pres_idpr = v.epta_pres
	    join fe_clie as d on d.idclie=c.idclie
	    WHERE c.acti = 'A'      AND a.acti = 'A' and c.ndoc='<<cnumero>>' 
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarunacotizacionpsysb(cnumero, Ccursor)
	Text To lC Noshow Textmerge Pretext  7
	SELECT
	  a.dped_cost AS costo,	  a.idart     AS idart,
	  b.prod_tigv AS prod_tigv,	  b.descri    AS descri,
	  x.pres_desc AS unid,	  a.cant      AS cant,	  IFNULL(m.idven,0) AS idven,
	  IFNULL(m.nomv,'') AS Vendedor,	  b.uno       AS uno,
	  b.dos       AS dos,	  b.tre       AS tre,	  b.cua       AS cua,
	  a.prec      AS prec,	  b.premay    AS premay,	  b.premen    AS premen,
	  c.fech      AS fech,	  c.idautop   AS idautop,	  c.impo      AS impo,
	  c.form      AS form,	  c.ndoc      AS ndoc,	  a.dped_equi AS equi,
	  c.aten      AS aten,	  c.forma     AS forma,	  a.dped_posi AS dped_posi,
	  a.dped_epta AS dped_epta,	  c.plazo     AS plazo,	  c.validez   AS validez,	  c.entrega   AS entrega,
	  c.detalle   AS detalle,	  IFNULL(d.idclie,0) AS idclie,
	  IFNULL(d.razo,'') AS razo,	  IFNULL(d.nruc,'') AS nruc,	  IFNULL(d.dire,'') AS dire,
	  c.rped_vigv AS rped_vigv,	  c.rped_mone AS rped_mone,	  IFNULL(d.ciud,'') AS ciud, IFNULL(d.ndni,'') AS ndni,ifnull(d.clie_lcre,0) as clie_lcre,
	  d.fono      AS fono,	  d.fax       AS fax,	  a.idped     AS nreg
	FROM fe_ped a
	     JOIN fe_rped c           ON a.idautop = c.idautop
	     JOIN fe_art b         ON b.idart = a.idart
	     JOIN fe_epta v        ON v.epta_idep = a.dped_epta
	     JOIN fe_presentaciones x       ON x.pres_idpr = v.epta_pres
	     LEFT JOIN fe_clie d      ON d.idclie = c.idclie
	     LEFT JOIN fe_vend m     ON m.idven = c.idven
	WHERE a.acti <> 'I'       AND c.acti <> 'I'  and c.ndoc='<<cnumero>>' 
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	ENDIF
	RETURN 1
	Endfunc
Enddefine



