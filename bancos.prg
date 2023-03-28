Define Class bancos As odata Of  'd:\capass\database\data.prg'

	idcta=0
	dfecha=Date()
	cope=""
	nmpago=0
	cdeta=""
	idclpr=0
	cndoc=""
	idcta1=0
	ndebe=0
	nhaber=0
    correlativo=""
    idb=0
	Function ReporteBancos(dfi, dff, ccta, Calias)
	Local lc
*:Global f1, f2
	f1 = cfechas(dfi)
	f2 = cfechas(dff)
	Local lc
	TEXT To lc Noshow Textmerge
	   SELECT a.cban_nume,a.cban_fech,b.pago_codi,b.pago_deta,a.cban_deta,if(a.cban_debe>0,ifnull(m.razo,''),ifnull(n.razo,'')) as razon,
	   a.cban_ndoc,c.ncta,c.nomb,a.cban_debe,a.cban_haber,a.cban_idct,a.cban_idmp,a.cban_idco,a.cban_idcl,a.cban_idpr,a.cban_dola as dolar,cban_tran,
	   cban_ttra as ttra,if(cban_debe<>0,'I','S') as tipo
	   from fe_cbancos as a
	   inner join fe_mpago as b on  b.pago_idpa=a.cban_idmp
	   left join fe_clie as m on m.idclie=a.cban_idcl
	   left join fe_prov as n on n.idprov=a.cban_idpr
	   inner join fe_plan as c on c.idcta=a.cban_idct
	   where a.cban_acti='A' AND a.cban_fech between '<<f1>>' and '<<f2>>'  and a.cban_idba=<<cta>> order by a.cban_fech,tipo,a.cban_ndoc
	ENDTEXT
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc

	Function Saldoinicialbancos(df, cta)
	F = cfechas(df)
	TEXT To lc Noshow Textmerge Pretext 7
       SELECT CAST(ifnull(SUM(a.cban_debe)-SUM(a.cban_haber),0) AS DECIMAL(12,2)) AS si
	   FROM fe_cbancos AS a
	   WHERE a.cban_acti='A' AND a.cban_fech<='<<F>>'  AND a.cban_idba=<<cta>> AND a.cban_idct>0
	ENDTEXT
	If This.EjecutaConsulta(lc, 'iniciobancos') < 1 Then
		Return 0
	Endif
	Return iniciobancos.si
	Endfunc
**************************
	Function MuestraLCaja(np1,ccursor)
	lc= 'PROMUESTRALCAJA'
	goapp.npara1=np1
	TEXT to lp noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function listarctas()
*******************************
	Function MuestraCtasBancos(ccursor)
	lc='PROmuestraCtasBancos'
	If This.EJECUTARP(lc,"",ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
***************************************
	Function IngresaDatosLCajaT(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
	lc='FUNIngresaCajaBancosT'
	cur='c_'+Sys(2015)
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
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	nidb=This.EJECUTARF(lc,lp,cur)
	If nidb<1 Then
		Return 0
	Endif
	Return nidb
	ENDFUNC
	FUNCTION registra()
	 	
	
	ENDFUNC

Enddefine
