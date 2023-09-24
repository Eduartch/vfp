Define Class ctasporcobrar As Odata Of 'd:\capass\database\data.prg'
	Tienda = 0
	chkTIENDA = 0
	cformapago = ""
	chkformapago = 0
	nidclie = 0
	npago = 0
	ndola = 0
	cmoneda = ""
	cndoc = ""
	dfech = Date()
	cdetalle = ""
	fechavto = Date()
	tipodcto = ""
	codv = 0
	nimpoo = 0
	nimpo = 0
	crefe = ""
	nidaval = 0
	idauto = 0
	sintransaccion = ""
	concargocaja = ""
	idcajero = 0
	Function mostrarpendientesxcobrar(nidclie, ccursor)
	Text To lc Noshow Textmerge
		SELECT `x`.`idclie`,
		`x`.`razo`      AS `razo`,
		v.importe,
		v.fevto,
		`v`.`rcre_idrc` AS `rcre_idrc`,
		`rr`.`rcre_fech` AS `fech`,
		`rr`.`rcre_idau` AS `idauto`,
		rcre_codv AS idven,
		ifnull(`vv`.`nomv`,'')  AS `nomv`,
		 IFNULL(`cc`.`ndoc`,"") AS `docd`,
		 IFNULL(`cc`.`tdoc`,'') AS `tdoc`,
		 a.`ndoc`,
		`a`.`mone`      AS `mone`,
		`a`.`banc`      AS `banc`,
		`a`.`tipo`      AS `tipo`,
		`a`.`dola`      AS `dola`,
		`a`.`nrou`      AS `nrou`,
		`a`.`banco`     AS `banco`,
		`a`.`idcred`    AS `idcred`,
		a.fech AS fepd,
		v.ncontrol,a.estd,
		a.ndoc,
		v.rcre_idrc
		FROM (
		SELECT ncontrol,rcre_idrc,rcre_idcl,MAX(`c`.`fevto`) AS `fevto`,ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) AS `importe` FROM
		fe_rcred AS r INNER JOIN fe_cred AS c ON c.`cred_idrc`=r.`rcre_idrc` WHERE r.`rcre_Acti`='A' AND c.`acti`='A' and r.rcre_idcl=<<nidclie>>
		GROUP BY `c`.`ncontrol`,r.rcre_idrc,r.rcre_idcl  HAVING (ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) <> 0)) AS v
		INNER JOIN fe_clie AS `x` ON `x`.`idclie`=v.rcre_idcl
		INNER JOIN fe_rcred AS rr ON rr.`rcre_idrc`=v.rcre_idrc
		left JOIN fe_vend AS vv ON vv.`idven`=rr.`rcre_codv`
		LEFT JOIN  (SELECT tdoc,ndoc,idauto FROM fe_rcom WHERE idcliente=<<nidclie>> AND acti='A') AS cc
		ON cc.idauto=rr.`rcre_idau` INNER JOIN fe_cred AS a ON a.idcred=v.ncontrol
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultaranticipos(nid, ccursor)
	Text To lc Noshow Textmerge
       SELECT fech,'S' AS mone,CAST(acta as decimal(10,2)) As acta,CAST(0 AS SIGNED) AS SW,idcred,banc AS deta,ndoc,tipo,rcre_idrc FROM fe_cred f
       INNER JOIN fe_rcred AS g ON g.rcre_idrc=f.cred_idrc
       WHERE ncontrol=-1 AND acti='A' AND rcre_Acti='A'  AND rcre_idcl=<<nid>> and acta>0.1
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCreditosNormal(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
	lc = 'FUNREGISTRACREDITOS'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	nid = This.EJECUTARf(lc, lp, cur)
	If nid < 1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function estadodecuentaporcliente(nidclie, cmoneda, ccursor)
	Text To lc Noshow Textmerge
	    SELECT b.rcre_idcl,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rcre_impc as impc,b.rcre_inic as inic,a.impo as impd,a.acta as actd,a.dola,
	    a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,a.mone as mond,a.estd,a.idcred as nr,b.rcre_idrc,
	    b.rcre_codv as codv,b.rcre_idau as idauto,ifnull(c.tdoc,'00') as refe,d.nomv,cred_idcb FROM fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
	    left join fe_rcom as c ON(c.idauto=b.rcre_idau)
	    left join fe_vend as d ON(d.idven=b.rcre_codv)
	    WHERE b.rcre_idcl=<<nidclie>> AND a.mone='<<cmoneda>>'
	    and a.acti<>'I' and rcre_acti<>'I'  ORDER BY a.ncontrol,a.idcred,a.fech
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadodecuentaporcliente10(nidclie, cmoneda, ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lc Noshow Textmerge
	    SELECT b.rcre_idcl,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rcre_impc as impc,b.rcre_inic as inic,a.impo as impd,a.acta as actd,a.dola,
	    a.tipo,a.banc,ifnull(c.ndoc,'00000000000') as docd,a.mone as mond,a.estd,a.idcred as nr,b.rcre_idrc,
	    b.rcre_codv as codv,b.rcre_idau as idauto,ifnull(c.tdoc,'00') as refe,d.nomv,ifnull(w.ctas_ctas,'') as bancos,ifnull(w.cban_ndoc,'') as nban,
	    cred_idcb,ifnull(t.nomb,'') as tienda  FROM fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc) 
	    left join fe_rcom as c ON(c.idauto=b.rcre_idau)
	    inner join fe_vend as d ON(d.idven=b.rcre_codv) 
	    left join fe_sucu as t on t.idalma=b.rcre_codt
	    left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM
        fe_cbancos f  inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A')
        as w on w.cban_idco=a.cred_idcb 
        WHERE b.rcre_idcl=<<nidclie>> AND a.mone='<<cmoneda>>'  and a.acti<>'I' and rcre_acti<>'I'  ORDER BY a.ncontrol,a.idcred,a.fech
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vlineacredito(ccodc, nmonto, nlinea)
	ccursor = Sys(2015)
	lc = "FUNVERIFICALINEACREDITO"
	goApp.npara1 = ccodc
	goApp.npara2 = nmonto
	goApp.npara3 = nlinea
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	Sw = This.EJECUTARf(lc, lp, (ccursor))
	If Sw < 0 Then
		Return 0
	Endif
	Select (ccursor)
	If Sw = 0 Then
		This.Cmensaje = 'Linea de Crédito NO Disponible'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function verificasaldocliente(codc, nmonto)
	lc = 'PROCALCULARSALDOSCLIENTE'
	ccursor = '_vsaldos'
	goApp.npara1 = codc
	Text To lp Noshow
	(?goapp.npara1)
	Endtext
	If This.ejecutarp(lc, lp, (ccursor)) < 1 Then
		Return 0
	Endif
	Select (ccursor)
*WAIT WINDOW impsoles
*WAIT WINDOW nmonto
	If impsoles < 0 Then
		Anticipos = Abs(impsoles)
	Else
		Anticipos = impsoles
	Endif
	If nmonto > Anticipos Then
		This.Cmensaje = 'Saldo No Disponible :' + Alltrim(Str(Anticipos, 12, 2))
		Return 0
	Endif
	Return 1
	Endfunc
	Function listactasxcobrar(df, ccursor)
	Do Case
	Case  This.chkTIENDA = 0 And This.chkformapago = 0
		Text To lc Noshow Textmerge Pretext 7
			SELECT c.nruc,c.razo AS proveedor,c.idclie AS codp,b.mone,b.tsoles,b.tdolar,c.clie_idzo,IFNULL(t.ndoc,a.ndoc) AS ndoc,
			IFNULL(t.tdoc,'') AS tdoc,IFNULL(t.fech,a.fech) AS fech FROM
			(SELECT a.ncontrol,a.mone,ROUND(IF(a.mone='S',SUM(a.impo-a.acta),0),2) AS tsoles,
			ROUND(IF(a.mone='D',SUM(a.impo-a.acta),0),2) AS tdolar
			FROM fe_cred AS a
			INNER JOIN fe_rcred AS xx  ON xx.rcre_idrc=a.cred_idrc
			WHERE a.fech<='<<df>>'  AND  a.acti<>'I' AND xx.rcre_acti<>'I' GROUP BY a.ncontrol,a.mone HAVING tsoles<>0 OR tdolar<>0) AS b
			INNER JOIN fe_cred AS a ON a.idcred=b.ncontrol
			INNER JOIN fe_rcred AS r ON r.rcre_idrc=a.cred_idrc
			INNER JOIN fe_clie AS c ON c.idclie=r.rcre_idcl
			LEFT JOIN (SELECT idauto,ndoc,tdoc,fech FROM fe_rcom WHERE acti='A' AND idcliente>0) AS t ON t.idauto=r.rcre_idau ORDER BY proveedor
		Endtext
	Case   This.chkTIENDA = 0 And This.chkformapago = 1
		Text To lc Noshow Textmerge Pretext 7
		    SELECT c.nruc,c.razo AS proveedor,c.idclie AS codp,b.mone,b.tsoles,b.tdolar,c.clie_idzo,IFNULL(t.ndoc,a.ndoc) AS ndoc,
			IFNULL(t.tdoc,'') AS tdoc,IFNULL(t.fech,a.fech) AS fech FROM
			(SELECT a.ncontrol,a.mone,ROUND(IF(a.mone='S',SUM(a.impo-a.acta),0),2) AS tsoles,
			ROUND(IF(a.mone='D',SUM(a.impo-a.acta),0),2) AS tdolar
			FROM fe_cred AS a
			INNER JOIN fe_rcred AS xx  ON xx.rcre_idrc=a.cred_idrc
			WHERE a.fech<='<<df>>'  AND  a.acti<>'I' AND xx.rcre_acti<>'I' and rcre_form='<<this.cformapago>>'  GROUP BY a.ncontrol,a.mone HAVING tsoles<>0 OR tdolar<>0) AS b
			INNER JOIN fe_cred AS a ON a.idcred=b.ncontrol
			INNER JOIN fe_rcred AS r ON r.rcre_idrc=a.cred_idrc
			INNER JOIN fe_clie AS c ON c.idclie=r.rcre_idcl
			LEFT JOIN (SELECT idauto,ndoc,tdoc,fech FROM fe_rcom WHERE acti='A' AND idcliente>0) AS t ON t.idauto=r.rcre_idau ORDER BY proveedor
		Endtext
	Case  This.chkTIENDA = 1 And This.chkformapago = 0
		Text To lc Noshow Textmerge Pretext 7
		    SELECT c.nruc,c.razo AS proveedor,c.idclie AS codp,b.mone,b.tsoles,b.tdolar,c.clie_idzo,IFNULL(t.ndoc,a.ndoc) AS ndoc,
			IFNULL(t.tdoc,'') AS tdoc,IFNULL(t.fech,a.fech) AS fech FROM
			(SELECT a.ncontrol,a.mone,ROUND(IF(a.mone='S',SUM(a.impo-a.acta),0),2) AS tsoles,
			ROUND(IF(a.mone='D',SUM(a.impo-a.acta),0),2) AS tdolar
			FROM fe_cred AS a
			INNER JOIN fe_rcred AS xx  ON xx.rcre_idrc=a.cred_idrc
			WHERE a.fech<='<<df>>'  AND  a.acti<>'I' AND xx.rcre_acti<>'I' and rcre_codt=<<this.tienda>>  GROUP BY a.ncontrol,a.mone HAVING tsoles<>0 OR tdolar<>0) AS b
			INNER JOIN fe_cred AS a ON a.idcred=b.ncontrol
			INNER JOIN fe_rcred AS r ON r.rcre_idrc=a.cred_idrc
			INNER JOIN fe_clie AS c ON c.idclie=r.rcre_idcl
			LEFT JOIN (SELECT idauto,ndoc,tdoc,fech FROM fe_rcom WHERE acti='A' AND idcliente>0) AS t ON t.idauto=r.rcre_idau ORDER BY proveedor
		Endtext
	Case  This.chkTIENDA = 1 And This.chkformapago = 1
		Text To lc Noshow Textmerge Pretext 7
		    SELECT c.nruc,c.razo AS proveedor,c.idclie AS codp,b.mone,b.tsoles,b.tdolar,c.clie_idzo,IFNULL(t.ndoc,a.ndoc) AS ndoc,
			IFNULL(t.tdoc,'') AS tdoc,IFNULL(t.fech,a.fech) AS fech FROM
			(SELECT a.ncontrol,a.mone,ROUND(IF(a.mone='S',SUM(a.impo-a.acta),0),2) AS tsoles,
			ROUND(IF(a.mone='D',SUM(a.impo-a.acta),0),2) AS tdolar
			FROM fe_cred AS a
			INNER JOIN fe_rcred AS xx  ON xx.rcre_idrc=a.cred_idrc
			WHERE a.fech<='<<df>>'  AND  a.acti<>'I' AND xx.rcre_acti<>'I' and rcre_codt=<<this.tienda>> and rcre_form='<<this.cformapago>>'  GROUP BY a.ncontrol,a.mone HAVING tsoles<>0 OR tdolar<>0) AS b
			INNER JOIN fe_cred AS a ON a.idcred=b.ncontrol
			INNER JOIN fe_rcred AS r ON r.rcre_idrc=a.cred_idrc
			INNER JOIN fe_clie AS c ON c.idclie=r.rcre_idcl
			LEFT JOIN (SELECT idauto,ndoc,tdoc,fech FROM fe_rcom WHERE acti='A' AND idcliente>0) AS t ON t.idauto=r.rcre_idau ORDER BY proveedor
		Endtext
	Endcase
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vtosxcliente(nidclie, ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If This.chkTIENDA = 0 Then
		Text To lc Noshow Textmerge
		SELECT `x`.`idclie`,`x`.`razo`      AS `razo`,
		v.importe,v.fevto,`v`.`rcre_idrc` AS `rcre_idrc`,`rr`.`rcre_fech` AS `fech`,
		`rr`.`rcre_idau` AS `idauto`,rcre_codv AS idven,`vv`.`nomv`      AS `nomv`,
		 IFNULL(`cc`.`ndoc`,"") AS `docd`, IFNULL(`cc`.`tdoc`,'') AS `tdoc`, a.`ndoc`,
		`a`.`mone`      AS `mone`,`a`.`banc`      AS `banc`,
		`a`.`tipo`      AS `tipo`,`a`.`dola`      AS `dola`,
		`a`.`nrou`      AS `nrou`,`a`.`banco`     AS `banco`,
		`a`.`idcred`    AS `idcred`,a.fech AS fepd,v.ncontrol,a.estd,a.ndoc,
		v.rcre_idrc,rr.rcre_form,a.impo as impoo
		FROM (
		SELECT ncontrol,rcre_idrc,rcre_idcl,MAX(`c`.`fevto`) AS `fevto`,ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) AS `importe` FROM
		fe_rcred AS r
		INNER JOIN fe_cred AS c ON c.`cred_idrc`=r.`rcre_idrc` WHERE r.`rcre_Acti`='A' AND c.`acti`='A' and r.rcre_idcl=<<nidclie>>
		GROUP BY `c`.`ncontrol`,r.rcre_idrc,r.rcre_idcl  HAVING (ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) <> 0)) AS v
		INNER JOIN fe_clie AS `x` ON `x`.`idclie`=v.rcre_idcl
		INNER JOIN fe_rcred AS rr ON rr.`rcre_idrc`=v.rcre_idrc
		INNER JOIN fe_vend AS vv ON vv.`idven`=rr.`rcre_codv`
		LEFT JOIN  (SELECT tdoc,ndoc,idauto FROM fe_rcom WHERE idcliente>0 AND acti='A') AS cc ON cc.idauto=rr.`rcre_idau`
		INNER JOIN fe_cred AS a ON a.idcred=v.ncontrol
		Endtext
	Else
		Text To lc Noshow Textmerge
		SELECT `x`.`idclie`,`x`.`razo`      AS `razo`,
		v.importe,v.fevto,`v`.`rcre_idrc` AS `rcre_idrc`,`rr`.`rcre_fech` AS `fech`,
		`rr`.`rcre_idau` AS `idauto`,rcre_codv AS idven,`vv`.`nomv`      AS `nomv`,
		 IFNULL(`cc`.`ndoc`,"") AS `docd`, IFNULL(`cc`.`tdoc`,'') AS `tdoc`, a.`ndoc`,
		`a`.`mone`      AS `mone`,`a`.`banc`      AS `banc`,
		`a`.`tipo`      AS `tipo`,`a`.`dola`      AS `dola`,
		`a`.`nrou`      AS `nrou`,`a`.`banco`     AS `banco`,
		`a`.`idcred`    AS `idcred`,a.fech AS fepd,v.ncontrol,a.estd,a.ndoc,
		v.rcre_idrc,rr.rcre_form,a.impo as impoo
		FROM (
		SELECT ncontrol,rcre_idrc,rcre_idcl,MAX(`c`.`fevto`) AS `fevto`,ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) AS `importe` FROM
		fe_rcred AS r
		INNER JOIN fe_cred AS c ON c.`cred_idrc`=r.`rcre_idrc` WHERE r.`rcre_Acti`='A' AND c.`acti`='A' and r.rcre_idcl=<<nidclie>> and rcre_codt=<<this.tienda>>
		GROUP BY `c`.`ncontrol`,r.rcre_idrc,r.rcre_idcl  HAVING (ROUND(SUM((`c`.`impo` - `c`.`acta`)),2) <> 0)) AS v
		INNER JOIN fe_clie AS `x` ON `x`.`idclie`=v.rcre_idcl
		INNER JOIN fe_rcred AS rr ON rr.`rcre_idrc`=v.rcre_idrc
		INNER JOIN fe_vend AS vv ON vv.`idven`=rr.`rcre_codv`
		LEFT JOIN  (SELECT tdoc,ndoc,idauto FROM fe_rcom WHERE idcliente>0 AND acti='A') AS cc ON cc.idauto=rr.`rcre_idau`
		INNER JOIN fe_cred AS a ON a.idcred=v.ncontrol
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfun
	Function registraanticipos(nidclie, dfech, npago, cndoc, cdetalle, ndolar, cmoneda)
	Set Procedure To d:\capass\modelos\cajae Additive
	ocaja = Createobject('cajae')
	If This.sintransaccion <> 'S'
		If  This.IniciaTransaccion() < 1 Then
			Return 0
		Endif
		This.CONTRANSACCION = 'S'
	Endif
	ur = This.IngresaCabeceraAnticipo(0, nidclie, dfech, This.codv, npago, goApp.nidusua, goApp.Tienda, 0, Id())
	If ur < 1
		If This.CONTRANSACCION = 'S'
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	nidanti = This.CancelaCreditosanticipos(cndoc, npago, 'P', cmoneda, cdetalle, dfech, dfech, 'F', -1, "", ur, Id(), goApp.nidusua, ur)
	If nidanti < 1 Then
		If This.contrasaccion = 'S'
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	nmp = Iif(cmoneda = 'D', Round(npago * ndolar, 2), npago)
	If ocaja.IngresaDatosLcajaEe(dfech, "", cdetalle, fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, This.idcajero, nidanti) < 1 Then
		If This.CONTRANSACCION = 'S'
			This.DEshacerCambios()
		Endif
		this.cmensaje=ocaja.cmensaje
		Return 0
	Endif
	If This.CONTRANSACCION = 'S'
		If This.GrabarCambios() < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function IngresaCabeceraAnticipo(NAuto, nidcliente, dFecha, nidven, nimpoo, nidus, nidtda, ninic, cpc)
	lc = "FUNINGRESARCREDITOSANTICIPOS"
	ccursor = "nidr"
	goApp.npara1 = NAuto
	goApp.npara2 = nidcliente
	goApp.npara3 = dFecha
	goApp.npara4 = nidven
	goApp.npara5 = nimpoo
	goApp.npara6 = nidus
	goApp.npara7 = nidtda
	goApp.npara8 = ninic
	goApp.npara9 = cpc
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
	Endtext
	Sw = This.EJECUTARf(lc, lp, ccursor)
	If Sw < 0 Then
		Return 0
	Endif
	Return Sw
	Endfunc
	Function CancelaCreditosanticipos(cndoc, nacta, cesta, cmone, cb1, dfech, dfevto, ctipo, nctrl, cnrou, nidrc, cpc, nidus, nidanticipo)
	lc = "FUNINGRESAPAGOSCREDITOSANTICIPOS"
	ccursor = "nidp"
	goApp.npara1 = cndoc
	goApp.npara2 = nacta
	goApp.npara3 = cesta
	goApp.npara4 = cmone
	goApp.npara5 = cb1
	goApp.npara6 = dfech
	goApp.npara7 = dfevto
	goApp.npara8 = ctipo
	goApp.npara9 = nctrl
	goApp.npara10 = cnrou
	goApp.npara11 = nidrc
	goApp.npara12 = cpc
	goApp.npara13 = nidus
	goApp.npara14 = nidanticipo
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	Endtext
	nid = This.EJECUTARf(lc, lp, ccursor)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function compensapagosanticipos(dfech, cndoc, Deta, ctipo, nidanticipo, nid)
	x = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = 'S'
	Select pdtes
	Scan For Sw = 1
		If This.CancelaCreditosanticipos(cndoc, pdtes.montoc, 'P', 'S', cdeta, dfech, dfech, ctipo, pdtes.ncontrol, '', pdtes.rcre_idrc, Id(), goApp.nidusua, nidanticipo) < 1 Then
			x = 0
			Exit
		Endif
	Endscan
	If x = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Text To lc Noshow Textmerge
     UPDATE fe_cred as f SET acta=f.acta-<<nacta>> WHERE idcred=<<nid>>
	Endtext
	If This.ejecutarsql(lc) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrar()
	This.crefe = "VENTA AL CREDITO"
	lc = 'FUNREGISTRACREDITOS'
	cur = "xn"
	goApp.npara1 = This.idauto
	goApp.npara2 = This.nidclie
	goApp.npara3 = This.cndoc
	goApp.npara4 = 'C'
	goApp.npara5 = 'S'
	goApp.npara6 = This.crefe
	goApp.npara7 = This.dfech
	goApp.npara8 = This.fechavto
	goApp.npara9 = This.tipodcto
	goApp.npara10 = This.cndoc
	goApp.npara11 = This.nimpo
	goApp.npara12 = 0
	goApp.npara13 = This.codv
	goApp.npara14 = This.nimpoo
	goApp.npara15 = goApp.nidusua
	goApp.npara16 = goApp.Tienda
	goApp.npara17 = Id()
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	nidcr = This.EJECUTARf(lc, lp, cur)
	If nidcr < 1 Then
		Return 0
	Endif
	Return nidcr
	Endfunc
	Function IngresaCreditosNormalFormaPago(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18)
	lc = 'FUNREGISTRACREDITOSFormaPago'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
	Endtext
	nidc = This.EJECUTARf(lc, lp, cur)
	If nidc < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


