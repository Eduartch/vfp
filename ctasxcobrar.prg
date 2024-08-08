Define Class ctasporcobrar As Odata Of 'd:\capass\database\data.prg'
	Tienda = 0
	chkTIENDA = 0
	cformapago = ""
	chkformapago = 0
	nidclie = 0
	npago = 0
	ndola = 0
	Cmoneda = ""
	cndoc = ""
	dFech = Date()
	cdetalle = ""
	Fechavto = Date()
	tipodcto = ""
	Codv = 0
	nimpoo = 0
	nimpo = 0
	crefe = ""
	nidaval = 0
	Idauto = 0
	sintransaccion = ""
	concargocaja = ""
	idcajero = 0
	idzona = 0
	cmodo = ""
	dfi = Date()
	dff = Date()
	tipopago = ""
	Function mostrarpendientesxcobrar(nidclie, Ccursor)
	Text To lC Noshow Textmerge
		SELECT `x`.`idclie`,		`x`.`razo`      AS `razo`,
		v.importe,		v.fevto,		`v`.`rcre_idrc` AS `rcre_idrc`,		`rr`.`rcre_fech` AS `fech`,		`rr`.`rcre_idau` AS `idauto`,
		rcre_codv AS idven,		ifnull(`vv`.`nomv`,'')  AS `nomv`,		 IFNULL(`cc`.`ndoc`,"") AS `docd`,		 IFNULL(`cc`.`tdoc`,'') AS `tdoc`,
		 a.`ndoc`,		`a`.`mone`      AS `mone`,		`a`.`banc`      AS `banc`,		`a`.`tipo`      AS `tipo`,		`a`.`dola`      AS `dola`,		`a`.`nrou`      AS `nrou`,
		`a`.`banco`     AS `banco`,		`a`.`idcred`    AS `idcred`,		a.fech AS fepd,
		v.ncontrol,a.estd,		a.ndoc,		v.rcre_idrc
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultaranticipos(nid, Ccursor)
	Text To lC Noshow Textmerge
       SELECT fech,'S' AS mone,CAST(acta as decimal(10,2)) As acta,CAST(0 AS SIGNED) AS SW,idcred,banc AS deta,ndoc,tipo,rcre_idrc FROM fe_cred f
       INNER JOIN fe_rcred AS g ON g.rcre_idrc=f.cred_idrc
       WHERE ncontrol=-1 AND acti='A' AND rcre_Acti='A'  AND rcre_idcl=<<nid>> and acta>0.1
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaCreditosNormal(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17)
	lC = 'FUNREGISTRACREDITOS'
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
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	ENDIF 
	Return nid
	Endfunc
	Function estadodecuentaporcliente(nidclie, Cmoneda, Ccursor)
	Text To lC Noshow Textmerge
	    SELECT b.rcre_idcl,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rcre_impc as impc,b.rcre_inic as inic,a.impo as impd,a.acta as actd,a.dola,
	    a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,a.mone as mond,a.estd,a.idcred as nr,b.rcre_idrc,
	    b.rcre_codv as codv,b.rcre_idau as idauto,ifnull(c.tdoc,'00') as refe,d.nomv,cred_idcb FROM fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
	    left join fe_rcom as c ON(c.idauto=b.rcre_idau)
	    left join fe_vend as d ON(d.idven=b.rcre_codv)
	    WHERE b.rcre_idcl=<<nidclie>> AND a.mone='<<cmoneda>>'
	    and a.acti<>'I' and rcre_acti<>'I'  ORDER BY a.ncontrol,a.idcred,a.fech
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadodecuentaporcliente10(nidclie, Cmoneda, Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vlineacredito(ccodc, nmonto, nlinea)
	Ccursor = Sys(2015)
	lC = "FUNVERIFICALINEACREDITO"
	goApp.npara1 = ccodc
	goApp.npara2 = nmonto
	goApp.npara3 = nlinea
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	Endtext
	Sw = This.EJECUTARf(lC, lp, (Ccursor))
	If Sw < 0 Then
		Return 0
	Endif
	Select (Ccursor)
	If Sw = 0 Then
		This.Cmensaje = 'Linea de Crédito NO Disponible'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function verificasaldocliente(codc, nmonto)
	lC = 'PROCALCULARSALDOSCLIENTE'
	Ccursor = '_vsaldos'
	goApp.npara1 = codc
	Text To lp Noshow
	(?goapp.npara1)
	Endtext
	If This.ejecutarp(lC, lp, (Ccursor)) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
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
	Function listactasxcobrar(Df, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\		Select c.nruc,c.razo As proveedor,c.idclie As codp,a.mone,If(a.mone='S',saldo,0) As tsoles,If(a.mone='D',saldo,0) As tdolar,
	\       c.clie_idzo,ifnull(T.ndoc,a.ndoc) As ndoc,
	\		ifnull(T.tdoc,'') As tdoc,ifnull(T.fech,a.fech) As fech,b.fech As fecha,v.nomv As vendedor,a.tipo,s.nomb As Tienda From
	\		(Select a.Ncontrol,Min(fevto) As fech,Sum(a.Impo-a.acta) As saldo
	\		From fe_cred As a
	\		INNER Join fe_rcred As xx  On xx.rcre_idrc=a.cred_idrc
	\		Where a.fech<='<<df>>'  And  a.Acti<>'I' And xx.rcre_Acti<>'I'
	If This.chkformapago = 1 Then
    	   \And rcre_form='<<this.cformapago>>'
	Endif
	If This.chkTIENDA = 1 Then
	\ And rcre_codt=<<This.Tienda>>
	Endif
	\Group By a.Ncontrol Having saldo<>0) As b
	\	INNER Join fe_cred As a On a.idcred=b.Ncontrol
	\	INNER Join fe_rcred As r On r.rcre_idrc=a.cred_idrc
	\	INNER Join fe_clie As c On c.idclie=r.rcre_idcl
	\   INNER Join fe_vend As v On v.idven=r.rcre_codv
	\   INNER Join fe_sucu As s On s.idalma=r.rcre_codt
	\	Left Join (Select Idauto,ndoc,tdoc,fech From fe_rcom Where Acti='A' And idcliente>0) As T On T.Idauto=r.rcre_idau
	If This.idzona > 0 Then
	   \ Where clie_idzo=<<This.idzona>>
	Endif
	\Order By proveedor
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vtosxcliente(nidclie, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow Textmerge
	\Select `x`.`idclie`,`x`.`razo`      As `razo`,
	\v.importe,v.fevto,`v`.`rcre_idrc` As `rcre_idrc`,`rr`.`rcre_fech` As `fech`,
	\`rr`.`rcre_idau` As `Idauto`,rcre_codv As idven,`vv`.`nomv`      As `nomv`,
	\ ifnull(`cc`.`ndoc`,"") As `docd`, ifnull(`cc`.`tdoc`,'') As `tdoc`, a.`ndoc`,
	\`a`.`mone`      As `mone`,`a`.`banc`      As `banc`,
	\`a`.`tipo`      As `tipo`,`a`.`dola`      As `dola`,
	\`a`.`nrou`      As `nrou`,`a`.`banco`     As `banco`,
	\`a`.`idcred`    As `idcred`,a.fech As fepd,v.Ncontrol,a.estd,a.ndoc,
	\v.rcre_idrc,rr.rcre_form,a.Impo As impoo
	\From (
	\Select Ncontrol,rcre_idrc,rcre_idcl,Max(`c`.`fevto`) As `fevto`,Round(Sum((`c`.`Impo` - `c`.`acta`)),2) As `importe` From
	\fe_rcred As r
	\INNER Join fe_cred As c On c.`cred_idrc`=r.`rcre_idrc` Where r.`rcre_Acti`='A' And c.`Acti`='A' And r.rcre_idcl=<<nidclie>>
	If This.chkTIENDA > 0 Then
	   \ And rcre_codt=<<This.Tienda>>
	Endif
	If Len(Alltrim(This.cformapago)) > 0 Then
	   \ And rcre_form='<<this.cformapago>>'
	Endif
		\Group By `c`.`Ncontrol`,r.rcre_idrc,r.rcre_idcl  Having (Round(Sum((`c`.`Impo` - `c`.`acta`)),2) <> 0)) As v
		\INNER Join fe_clie As `x` On `x`.`idclie`=v.rcre_idcl
		\INNER Join fe_rcred As rr On rr.`rcre_idrc`=v.rcre_idrc
		\INNER Join fe_vend As vv On vv.`idven`=rr.`rcre_codv`
		\Left Join  (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As cc On cc.Idauto=rr.`rcre_idau`
		\INNER Join fe_cred As a On a.idcred=v.Ncontrol
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfun
	Function registraanticipos(nidclie, dFech, npago, cndoc, cdetalle, ndolar, Cmoneda)
	Set Procedure To d:\capass\modelos\cajae Additive
	ocaja = Createobject('cajae')
	If This.sintransaccion <> 'S'
		If  This.IniciaTransaccion() < 1 Then
			Return 0
		Endif
		This.CONTRANSACCION = 'S'
	Endif
	ur = This.IngresaCabeceraAnticipo(This.Idauto, nidclie, dFech, This.Codv, npago, goApp.nidusua, goApp.Tienda, 0, Id())
	If ur < 1
		If This.CONTRANSACCION = 'S'
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	nidanti = This.CancelaCreditosanticipos(cndoc, npago, 'P', Cmoneda, cdetalle, dFech, dFech, 'F', -1, "", ur, Id(), goApp.nidusua, ur)
   If nidanti < 1 Then
		If This.contrasaccion = 'S'
			This.DEshacerCambios()
		Endif
		Return 0
	Endif
	nmp = Iif(Cmoneda = 'D', Round(npago * ndolar, 2), npago)
	conerrorcaja = ''
	If This.tipopago = 'N' Then
*!*			If ocaja.IngresaDatosLCajaEe(dFech, "", cdetalle, fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, This.idcajero, nidanti) < 1 Then
*!*				conerrorcaja = 'S'
*!*			Endif
*!*			If ocaja.IngresaDatosLCajaEFectivo11(dFech,'',cdetalle,fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, 0, nidclie, this.Idauto,'S','E') < 1 Then
*!*			IngresaDatosLCajaEFectivo12(dfvta, "", .lblRAZON.Value, fe_gene.idctat, Nt, 0,  'S', fe_gene.dola, goApp.idcajero, .txtCodigo.Value, .NAuto, Left(.cmbFORMA.Value, 1), cndcto, cTdoc, goApp.Tienda) = 0 Then
*!*			DEshacerCambios()
*!*				conerrorcaja = 'S'
*!*			Endif
	Else
		If ocaja.IngresaDatosLCajaEe(dFech, "", cdetalle, fe_gene.gene_idcre, nmp, 0, 'S', fe_gene.dola, This.idcajero, nidanti) < 1 Then
			conerrorcaja = 'S'
		Endif
	Endif
	If   conerrorcaja = 'S' Then
		If This.CONTRANSACCION = 'S'
			This.DEshacerCambios()
		Endif
		This.Cmensaje = ocaja.Cmensaje
		Return 0
	Endif
	If This.CONTRANSACCION = 'S'
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function IngresaCabeceraAnticipo(NAuto, nidcliente, dFecha, nidven, nimpoo, nidus, nidtda, ninic, cpc)
	lC = "FUNINGRESARCREDITOSANTICIPOS"
	Ccursor = "nidr"
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
	Sw = This.EJECUTARf(lC, lp, Ccursor)
	If Sw < 0 Then
		Return 0
	Endif
	Return Sw
	Endfunc
	Function CancelaCreditosanticipos(cndoc, nacta, cesta, cmone, cb1, dFech, dfevto, ctipo, nctrl, cnrou, nidrc, cpc, nidus, nidanticipo)
	lC = "FUNINGRESAPAGOSCREDITOSANTICIPOS"
	Ccursor = "nidp"
	goApp.npara1 = cndoc
	goApp.npara2 = nacta
	goApp.npara3 = cesta
	goApp.npara4 = cmone
	goApp.npara5 = cb1
	goApp.npara6 = dFech
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
	nid = This.EJECUTARf(lC, lp, Ccursor)
	If nid < 1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function compensapagosanticipos(dFech, cndoc, Deta, ctipo, nidanticipo, nid)
	x = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = 'S'
	Select pdtes
	Scan For Sw = 1
		If This.CancelaCreditosanticipos(cndoc, pdtes.montoc, 'P', 'S', cdeta, dFech, dFech, ctipo, pdtes.Ncontrol, '', pdtes.rcre_idrc, Id(), goApp.nidusua, nidanticipo) < 1 Then
			x = 0
			Exit
		Endif
	Endscan
	If x = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Text To lC Noshow Textmerge
     UPDATE fe_cred as f SET acta=f.acta-<<nacta>> WHERE idcred=<<nid>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrar()
	This.crefe = "VENTA AL CREDITO"
	lC = 'FUNREGISTRACREDITOS'
	cur = "xn"
	goApp.npara1 = This.Idauto
	goApp.npara2 = This.nidclie
	goApp.npara3 = This.cndoc
	goApp.npara4 = 'C'
	goApp.npara5 = 'S'
	goApp.npara6 = This.crefe
	goApp.npara7 = This.dFech
	goApp.npara8 = This.Fechavto
	goApp.npara9 = This.tipodcto
	goApp.npara10 = This.cndoc
	goApp.npara11 = This.nimpo
	goApp.npara12 = 0
	goApp.npara13 = This.Codv
	goApp.npara14 = This.nimpoo
	goApp.npara15 = goApp.nidusua
	goApp.npara16 = goApp.Tienda
	goApp.npara17 = Id()
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	Endtext
	nidcr = This.EJECUTARf(lC, lp, cur)
	If nidcr < 1 Then
		Return 0
	Endif
	Return nidcr
	Endfunc
	Function IngresaCreditosNormalFormaPago(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18)
	lC = 'FUNREGISTRACREDITOSFormaPago'
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
	nidc = This.EJECUTARf(lC, lp, cur)
	If nidc < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardctosparacancelar(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	    select e.ndoc,e.fech,xx.fevto,xx.saldo,
	    b.rcre_impc,'C' as situa,b.rcre_idau,xx.ncontrol,e.tipo,rcre_idav,e.banco,ifnull(c.ndoc,'') as docd,ifnull(c.tdoc,'' ) as tdoc,e.nrou,
	    e.mone,0 as dscto,rcre_codt as codt,xxx.razo,b.rcre_impc as importec,b.rcre_idau as idauto,e.mone as moneda,b.rcre_idrc as idrc,xxx.idclie,
	    d.idven,d.nomv,xx.rcre_idrc FROM
	    (select ncontrol,ROUND(SUM(a.impo-a.acta),2) as saldo,MAX(fevto) as fevto,rcre_idrc from fe_cred as a
	    inner join fe_rcred as b ON(b.rcre_idrc=a.cred_idrc)
	    where a.acti='A' and b.rcre_acti='A'
	    GROUP BY ncontrol,rcre_idrc HAVING saldo<>0) as xx
	    inner join fe_rcred as b on b.rcre_idrc=xx.rcre_idrc
	    INNER JOIN fe_cred AS e ON e.idcred=xx.ncontrol
	    inner join fe_vend as d ON(d.idven=b.rcre_codv)
	    inner join fe_clie as xxx on xxx.idclie=b.rcre_idcl
	    LEFT JOIN (SELECT ndoc,tdoc,fech,idauto FROM fe_rcom WHERE acti='A' AND idcliente>0) AS c ON(c.idauto=b.rcre_idau)  ORDER BY fevto
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpdteslopez(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\Select razo,nomv,fech As fepd,fevto As fevd,importe,
	\tipo,docd,If(tdoc='01','F',If(tdoc='03','B',If(tdoc='20','P',''))) As tipodoc,ndoc,idcred As nreg,rcre_codv As idven,idclie,banc,mone As mond,
	\estd,dola,nrou,' ' As usua,Idauto,rcre_idrc,Ncontrol,tdoc From vpdtespagoc Where importe>0
	If This.Codv > 0 Then
	\ And  rcre_codv=<<This.Codv>>
	Endif
	If Len(Alltrim(This.cformapago)) > 0 Then
	\ And rcre_form='<<this.cformapago>>'
	Endif
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpendientesparacancelar1(Ccursor)
	If !Pemstatus(goApp, 'cdatos', 5)
		AddProperty(goApp, 'cdatos', '')
	Endif
	If !Pemstatus(goApp, 'clienteconproyectos', 5)
		AddProperty(goApp, 'clienteconproyectos', '')
	Endif
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select e.ndoc,e.fech,xx.fevto,xx.saldo,
	\b.rcre_impc,'C' As situa,b.rcre_idau,xx.Ncontrol,e.tipo,rcre_idav,e.banco,ifnull(c.ndoc,'0') As docd,ifnull(c.tdoc,'0' ) As tdoc,e.nrou,
	\e.mone,0 As dscto,rcre_codt As codt,xxx.razo,b.rcre_impc As importec,b.rcre_idau As Idauto,e.mone As moneda,b.rcre_idrc As idrc,xxx.idclie,
	\ d.idven,d.nomv,xx.rcre_idrc,
	If goApp.Clienteconproyectos = 'S' Then
	 \ifnull(proy_nomb,'') As proyecto
	Else
	 \ '' As proyecto
	Endif
	 \ From (Select Ncontrol,Round(Sum(a.Impo-a.acta),2) As saldo,Max(fevto) As fevto,rcre_idrc From  fe_cred As a
	\           INNER Join fe_rcred As b On(b.rcre_idrc=a.cred_idrc)
	\		    Where a.Acti='A' And b.rcre_Acti='A'
	If goApp.Cdatos = 'S' Then
	   \And b.rcre_codt=<<goApp.Tienda>>
	Endif
	\Group By Ncontrol,rcre_idrc HAVING saldo<>0) As xx
	\   INNER Join fe_rcred As b On b.rcre_idrc=xx.rcre_idrc
	\   INNER Join fe_cred As e On e.idcred=xx.Ncontrol
	\   INNER Join fe_vend As d On(d.idven=b.rcre_codv)
	\   INNER Join fe_clie As xxx On xxx.idclie=b.rcre_idcl
	\   INNER  Join (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As c On(c.Idauto=b.rcre_idau)
	If goApp.Clienteconproyectos = 'S' Then
	   \  Left Join fe_proyectos As p On p.proy_idpr=b.rcre_idsu
	Endif
	\   Order By fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CancelaCreditosCefectivoConYape(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np12, np13, np14, np15)
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
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	Text To lC Noshow
	INSERT INTO fe_cred(fech,fevto,acta,ndoc,estd,mone,banc,tipo,cred_idrc,cred_idus,cred_fope,ncontrol,nrou,cred_idpc,cred_idcb)
	VALUES(?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,
    ?goapp.npara8,?goapp.npara9,?goapp.npara10,localtime,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15);
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function vtosxcliente1(nidclie, Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lC Noshow Textmerge
	\Select `x`.`idclie`,`x`.`razo`      As `razo`,
	\v.importe,v.fevto,`v`.`rcre_idrc` As `rcre_idrc`,`rr`.`rcre_fech` As `fech`,
	\`rr`.`rcre_idau` As `Idauto`,rcre_codv As idven,`vv`.`nomv`      As `nomv`,
	\ ifnull(`cc`.`ndoc`,"") As `docd`, ifnull(`cc`.`tdoc`,'') As `tdoc`, a.`ndoc`,
	\`a`.`mone`      As `mone`,`a`.`banc`      As `banc`,
	\`a`.`tipo`      As `tipo`,`a`.`dola`      As `dola`,
	\`a`.`nrou`      As `nrou`,`a`.`banco`     As `banco`,
	\`a`.`idcred`    As `idcred`,a.fech As fepd,v.Ncontrol,a.estd,a.ndoc,
	\v.rcre_idrc,a.Impo As impoo
	\From (
	\Select Ncontrol,rcre_idrc,rcre_idcl,Max(`c`.`fevto`) As `fevto`,Round(Sum((`c`.`Impo` - `c`.`acta`)),2) As `importe` From
	\fe_rcred As r
	\INNER Join fe_cred As c On c.`cred_idrc`=r.`rcre_idrc` Where r.`rcre_Acti`='A' And c.`Acti`='A' And r.rcre_idcl=<<nidclie>>
	If This.chkTIENDA > 0 Then
	   \ And rcre_codt=<<This.Tienda>>
	Endif
	If Len(Alltrim(This.cformapago)) > 0 Then
	   \ And rcre_form='<<this.cformapago>>'
	Endif
		\Group By `c`.`Ncontrol`,r.rcre_idrc,r.rcre_idcl  Having (Round(Sum((`c`.`Impo` - `c`.`acta`)),2) <> 0)) As v
		\INNER Join fe_clie As `x` On `x`.`idclie`=v.rcre_idcl
		\INNER Join fe_rcred As rr On rr.`rcre_idrc`=v.rcre_idrc
		\INNER Join fe_vend As vv On vv.`idven`=rr.`rcre_codv`
		\Left Join  (Select tdoc,ndoc,Idauto From fe_rcom Where idcliente>0 And Acti='A') As cc On cc.Idauto=rr.`rcre_idau`
		\INNER Join fe_cred As a On a.idcred=v.Ncontrol
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetallectasxcobrar(Ccursor)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  a.razo, ifnull(b.tdoc, "SD") As tdoc, ifnull(b.ndoc, c.ndoc) As ndoc, p.rcre_fech As fech, c.fevto, ifnull(b.mone, 'S') As mone,
	\c.Impo, s.acta, s.saldo, ifnull(b.Idauto, 0) As Idauto, e.nomv, c.tipo, p.rcre_codv, a.idclie  From
	\(Select xx.rcre_idcl As idclie, a.Ncontrol, Round(Sum(a.Impo - a.acta), 2) As saldo, Sum(acta) As acta
	\From fe_cred As a
	\INNER Join fe_rcred As xx  On xx.rcre_idrc = a.cred_idrc
	\Where a.fech <= '<<f2>>' And a.Acti <> 'I' And xx.rcre_Acti <> 'I'
	If This.Tienda > 0 Then
	\  And xx.rcre_codt =<<This.Tienda>>
	Endif
	If This.Codv > 0 Then
	\  And xx.rcre_codv =<<This.Codv>>
	Endif
	\  Group By xx.rcre_idcl, a.Ncontrol, a.mone
	\Having saldo <> 0) As s
	\INNER Join fe_clie As a On a.idclie = s.idclie
	\INNER Join fe_cred As c On c.idcred = s.Ncontrol
	\INNER Join fe_rcred As p On p.rcre_idrc = c.cred_idrc
	\INNER Join fe_vend As e On e.idven = p.rcre_codv
	\Left Join fe_rcom As b On b.Idauto = p.rcre_idau Order By razo
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine














