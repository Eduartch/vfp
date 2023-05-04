Define Class ctasporcobrar As Odata Of 'd:\capass\database\data.prg'
	tienda=0
	chktienda=0
	cformapago=""
	chkformapago=0
	nidclie=0
	npago=0
	ndola=0
	cmoneda=""
	cndoc=""
	dfech=Date()
	cdetalle=""
	fechavto=Date()
	tipodcto=""
	codv=0
	nimpoo=0
	nimpo=0
	crefe=""
	nidaval=0
	idauto=0
	sintransaccion=""
	concargocaja=""
	idcajero=0
	Function mostrarpendientesxcobrar(nidclie,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultaranticipos(nid,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
       SELECT fech,'S' AS mone,CAST(acta as decimal(10,2)) As acta,CAST(0 AS SIGNED) AS SW,idcred,banc AS deta,ndoc,tipo,rcre_idrc FROM fe_cred f
       INNER JOIN fe_rcred AS g ON g.rcre_idrc=f.cred_idrc
       WHERE ncontrol=-1 AND acti='A' AND rcre_Acti='A'  AND rcre_idcl=<<nid>> and acta>0
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCreditosNormal(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17)
	lc='FUNREGISTRACREDITOS'
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
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	ENDTEXT
	nid=This.EJECUTARF(lc,lp,cur)
	If nid<1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function estadodecuentaporcliente(nidclie,cmoneda,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	    SELECT b.rcre_idcl,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rcre_impc as impc,b.rcre_inic as inic,a.impo as impd,a.acta as actd,a.dola,
	    a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,a.mone as mond,a.estd,a.idcred as nr,b.rcre_idrc,
	    b.rcre_codv as codv,b.rcre_idau as idauto,ifnull(c.tdoc,'00') as refe,d.nomv,cred_idcb FROM fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
	    left join fe_rcom as c ON(c.idauto=b.rcre_idau)
	    left join fe_vend as d ON(d.idven=b.rcre_codv)
	    WHERE b.rcre_idcl=<<nidclie>> AND a.mone='<<cmoneda>>'
	    and a.acti<>'I' and rcre_acti<>'I'  ORDER BY a.ncontrol,a.idcred,a.fech
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vlineacredito(ccodc,nmonto,nlinea)
	ccursor=Sys(2015)
	lc="FUNVERIFICALINEACREDITO"
	goapp.npara1=ccodc
	goapp.npara2=nmonto
	goapp.npara3=nlinea
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	sw=This.EJECUTARF(lc,lp,(ccursor))
	If sw<0 Then
		Return 0
	Endif
	Select (ccursor)
	If sw=0 Then
		This.Cmensaje='Linea de Crédito NO Disponible'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function verificasaldocliente(codc,nmonto)
	lc='PROCALCULARSALDOSCLIENTE'
	ccursor='_vsaldos'
	goapp.npara1=codc
	TEXT TO lp NOSHOW
	(?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lc,lp,(ccursor))<1 Then
		Return 0
	Endif
	Select (ccursor)
*WAIT WINDOW impsoles
*WAIT WINDOW nmonto
	If impsoles<0 Then
		anticipos=Abs(impsoles)
	Else
		anticipos=impsoles
	Endif
	If nmonto>anticipos Then
		This.Cmensaje='Saldo No Disponible :'+Alltrim(Str(anticipos,12,2))
		Return 0
	Endif
	Return 1
	Endfunc
	Function listactasxcobrar(df,ccursor)
	Do Case
	Case  This.chktienda=0 And This.chkformapago=0
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
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
		ENDTEXT
	Case   This.chktienda=0 And This.chkformapago=1
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
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
		ENDTEXT
	Case  This.chktienda=1 And This.chkformapago=0
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
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
		ENDTEXT
	Case  This.chktienda=1 And This.chkformapago=1
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
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
		ENDTEXT
	Endcase
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vtosxcliente(nidclie,ccursor)
	IF this.idsesion>0 then
	   SET DATASESSION TO this.idsesion
	ENDIF    
	If This.chktienda = 0 Then
		TEXT TO lc NOSHOW TEXTMERGE
		SELECT `x`.`idclie`,`x`.`razo`      AS `razo`,
		v.importe,v.fevto,`v`.`rcre_idrc` AS `rcre_idrc`,`rr`.`rcre_fech` AS `fech`,
		`rr`.`rcre_idau` AS `idauto`,rcre_codv AS idven,`vv`.`nomv`      AS `nomv`,
		 IFNULL(`cc`.`ndoc`,"") AS `docd`, IFNULL(`cc`.`tdoc`,'') AS `tdoc`, a.`ndoc`,
		`a`.`mone`      AS `mone`,`a`.`banc`      AS `banc`,
		`a`.`tipo`      AS `tipo`,`a`.`dola`      AS `dola`,
		`a`.`nrou`      AS `nrou`,`a`.`banco`     AS `banco`,
		`a`.`idcred`    AS `idcred`,a.fech AS fepd,v.ncontrol,a.estd,a.ndoc,
		v.rcre_idrc,rr.rcre_form
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
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
		SELECT `x`.`idclie`,`x`.`razo`      AS `razo`,
		v.importe,v.fevto,`v`.`rcre_idrc` AS `rcre_idrc`,`rr`.`rcre_fech` AS `fech`,
		`rr`.`rcre_idau` AS `idauto`,rcre_codv AS idven,`vv`.`nomv`      AS `nomv`,
		 IFNULL(`cc`.`ndoc`,"") AS `docd`, IFNULL(`cc`.`tdoc`,'') AS `tdoc`, a.`ndoc`,
		`a`.`mone`      AS `mone`,`a`.`banc`      AS `banc`,
		`a`.`tipo`      AS `tipo`,`a`.`dola`      AS `dola`,
		`a`.`nrou`      AS `nrou`,`a`.`banco`     AS `banco`,
		`a`.`idcred`    AS `idcred`,a.fech AS fepd,v.ncontrol,a.estd,a.ndoc,
		v.rcre_idrc,rr.rcre_form
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
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfun
	Function registraanticipos(nidclie,dfech,npago,cndoc,cdetalle,ndolar,cmoneda)
	Set Procedure To d:\capass\modelos\cajae Additive
	ocaja=Createobject('cajae')
	If This.sintransaccion<>'S'
		If  This.IniciaTransaccion()=0 Then
			Return 0
		Endif
		This.CONTRANSACCION='S'
	Endif
	ur=This.IngresaCabeceraAnticipo(0,nidclie,dfech,this.codv,npago,goapp.nidusua,goapp.tienda,0,Id())
	If ur<1
		If This.contransaccion='S'
			This.DeshacerCambios()
		Endif
		Return 0
	Endif
	nidanti=This.CancelaCreditosanticipos(cndoc,npago,'P',cmoneda,cdetalle,dfech,dfech,'F',-1,"",ur,Id(),goapp.nidusua,ur)
	If nidanti<1 Then
		If This.contrasaccion='S'
			This.DeshacerCambios()
		Endif
		Return 0
	Endif
	nmp=Iif(cmoneda='D',Round(npago*ndolar,2),npago)
	If ocaja.IngresaDatosLcajaEe(dfech,"",cdetalle,fe_gene.gene_idcre,nmp,0,'S',fe_gene.dola,this.idcajero,nidanti)<1 Then
		If This.contrasaccion='S'
			This.DeshacerCambios()
		Endif
		Return 0
	Endif
	If This.contransaccion='S'
		If This.GrabarCambios()<1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function IngresaCabeceraAnticipo(nauto,nidcliente,dFecha,nidven,nimpoo,nidus,nidtda,ninic,cpc)
	lc="FUNINGRESARCREDITOSANTICIPOS"
	ccursor="nidr"
	goapp.npara1=nauto
	goapp.npara2=nidcliente
	goapp.npara3=dFecha
	goapp.npara4=nidven
	goapp.npara5=nimpoo
	goapp.npara6=nidus
	goapp.npara7=nidtda
	goapp.npara8=ninic
	goapp.npara9=cpc
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9)
	ENDTEXT
	sw=This.EJECUTARF(lc,lp,ccursor)
	If sw<0 Then
		Return 0
	Endif
	Return sw
	Endfunc
	Function CancelaCreditosanticipos(cndoc,nacta,cesta,cmone,cb1,dfech,dfevto,ctipo,nctrl,cnrou,nidrc,cpc,nidus,nidanticipo)
	lc="FUNINGRESAPAGOSCREDITOSANTICIPOS"
	ccursor="nidp"
	goapp.npara1=cndoc
	goapp.npara2=nacta
	goapp.npara3=cesta
	goapp.npara4=cmone
	goapp.npara5=cb1
	goapp.npara6=dfech
	goapp.npara7=dfevto
	goapp.npara8=ctipo
	goapp.npara9=nctrl
	goapp.npara10=cnrou
	goapp.npara11=nidrc
	goapp.npara12=cpc
	goapp.npara13=nidus
	goapp.npara14=nidanticipo
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nid=This.EJECUTARF(lc,lp,ccursor)
	If nid<1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function compensapagosanticipos(dfech,cndoc,Deta,ctipo,nidanticipo,nid)
	x=1
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.CONTRANSACCION='S'
	Select pdtes
	Scan For sw=1
		If This.CancelaCreditosanticipos(cndoc,pdtes.montoc,'P','S',cdeta,dfech,dfech,ctipo,pdtes.ncontrol,'',pdtes.rcre_idrc,Id(),goapp.nidusua,nidanticipo)<1 Then
			x=0
			Exit
		Endif
	Endscan
	If x=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
     UPDATE fe_cred as f SET acta=f.acta-<<nacta>> WHERE idcred=<<nid>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrar()
	This.crefe="VENTA AL CREDITO"
	lc='FUNREGISTRACREDITOS'
	cur="xn"
	goapp.npara1=This.idauto
	goapp.npara2=This.nidclie
	goapp.npara3=This.cndoc
	goapp.npara4='C'
	goapp.npara5='S'
	goapp.npara6=This.crefe
	goapp.npara7=This.dfech
	goapp.npara8=This.fechavto
	goapp.npara9=This.tipodcto
	goapp.npara10=This.cndoc
	goapp.npara11=This.nimpo
	goapp.npara12=0
	goapp.npara13=This.codv
	goapp.npara14=This.nimpoo
	goapp.npara15=goapp.nidusua
	goapp.npara16=goapp.tienda
	goapp.npara17=Id()
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	ENDTEXT
	nidcr=This.EJECUTARF(lc,lp,cur)
	If nidcr< 1 Then
		Return 0
	Endif
	Return nidcr
	Endfunc
	Function IngresaCreditosNormalFormaPago(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18)
	lc='FUNREGISTRACREDITOSFormaPago'
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
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18)
	ENDTEXT
	nidc=This.EJECUTARF(lc,lp,cur)
	If nidc<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
