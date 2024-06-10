Define Class bancos As Odata Of  'd:\capass\database\data.prg'
	idcta = 0
	dFecha = Date()
	cope = ""
	nmpago = 0
	cdeta = ""
	idclpr = 0
	cndoc = ""
	idcta1 = 0
	ndebe = 0
	nhaber = 0
	Correlativo = ""
	idb = 0
	Function ReporteBancos(dfi, dff, ccta, Calias)
	Local lC
*:Global f1, f2
	f1 = cfechas(dfi)
	f2 = cfechas(dff)
	Local lC
	Text To lC Noshow Textmerge
	   SELECT a.cban_nume,a.cban_fech,b.pago_codi,b.pago_deta,a.cban_deta,if(a.cban_debe>0,ifnull(m.razo,''),ifnull(n.razo,'')) as razon,
	   a.cban_ndoc,c.ncta,c.nomb,a.cban_debe,a.cban_haber,a.cban_idct,a.cban_idmp,a.cban_idco,a.cban_idcl,a.cban_idpr,a.cban_dola as dolar,cban_tran,
	   cban_ttra as ttra,if(cban_debe<>0,'I','S') as tipo
	   from fe_cbancos as a
	   inner join fe_mpago as b on  b.pago_idpa=a.cban_idmp
	   left join fe_clie as m on m.idclie=a.cban_idcl
	   left join fe_prov as n on n.idprov=a.cban_idpr
	   inner join fe_plan as c on c.idcta=a.cban_idct
	   where a.cban_acti='A' AND a.cban_fech between '<<f1>>' and '<<f2>>'  and a.cban_idba=<<cta>> order by a.cban_fech,tipo,a.cban_ndoc
	Endtext
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc

	Function Saldoinicialbancos(df, cta)
	F = cfechas(df)
	Text To lC Noshow Textmerge Pretext 7
       SELECT CAST(ifnull(SUM(a.cban_debe)-SUM(a.cban_haber),0) AS DECIMAL(12,2)) AS si
	   FROM fe_cbancos AS a
	   WHERE a.cban_acti='A' AND a.cban_fech<='<<F>>'  AND a.cban_idba=<<cta>> AND a.cban_idct>0
	Endtext
	If This.EjecutaConsulta(lC, 'iniciobancos') < 1 Then
		Return 0
	Endif
	Return iniciobancos.si
	Endfunc
**************************
	Function MuestraLCaja(np1, Ccursor)
	lC = 'PROMUESTRALCAJA'
	goApp.npara1 = np1
	Text To lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
*******************************
	Function MuestraCtasBancos(Ccursor)
	lC = 'PROmuestraCtasBancos'
	If This.EJECUTARP(lC, "", Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
***************************************
	Function IngresaDatosLCajaT(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	lC = 'FUNIngresaCajaBancosT'
	cur = 'c_' + Sys(2015)
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	Endtext
	nidb = This.EJECUTARf(lC, lp, cur)
	If nidb < 1 Then
		Return 0
	Endif
	Return nidb
	Endfunc
	Function registra(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lC = 'FUNIngresaCajaBancos2'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	Endtext
	nidb = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Endif
	Return  nidb
	Endfunc
	Function listardepositosencuenta(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Calias = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
	SELECT a.banc_nomb as banco,b.ctas_ctas as numerocta,cban_fech,cban_nume,c.razo,cban_debe as impo,
	ifnull(acta,cast(0 as unsigned)) as acta,cban_idcl,cban_idco,cban_ndoc FROM fe_cbancos as d
	inner join fe_ctasb as b on b.ctas_idct=d.cban_idba 
	inner join fe_bancos as a on a.banc_idba=b.ctas_idba
	inner join fe_clie as c on c.idclie=d.cban_idcl
	left join (select sum(acta) as acta,cred_idcb from fe_cred where acti='A' and acta>0 and cred_idcb>0 group by cred_idcb )as x on
	x.cred_idcb=d.cban_idco where cban_acti='A'  and cban_tipo='P' and cban_idcl=<<this.idclpr>>;
	Endtext
	If This.EjecutaConsulta(lC, Calias) < 1
		Return 0
	Endif
	Select banco, numerocta, cban_fech, cban_nume, Impo, acta, 000000.00 As apagar, cban_idcl, cban_idco, Impo - acta As saldo, cban_ndoc;
		From (Calias) Into Cursor (Ccursor)  Readwrite
	Return 1
	Endfunc
	Function IngresaDatosLCajax(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lC = 'FUNIngresaCajaBancos2'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	Endtext
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1  Then
		Return 0
	Endif
	Return nid
	Endfunc
Enddefine










