Define Class cajae As odata Of  'd:\capass\database\data.prg'
	dfecha=Date()
	codt=0
	ndoc=""
	nsgte=0
	idserie=0
	Function ReporteCajaEfectivo(dfi, dff, Calias)
	Local lc
	fi = cfechas(dfi)
	ff = cfechas(dff)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	TEXT To lc Noshow Textmerge
	   Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	   c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	   If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
		a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
		From fe_lcaja As a
		inner Join fe_plan As c On c.idcta=a.lcaj_idct
		Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And lcaj_form='E' Order By a.lcaj_fech
	ENDTEXT
	If This.EjecutaConsulta(lc, (Calias)) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo(df)
	F = cfechas(df)
	TEXT To lc Noshow Textmerge Pretext 7
     SELECT CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>' AND lcaj_form='E'  AND lcaj_idct>0
	ENDTEXT
	If This.EjecutaConsulta(lc, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si),0,iniciocaja.si)
	Endfunc
	Function IngresaDatosLCajaEe(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
	lc="FunIngresaDatosLcajaEe"
	cur="Ca"
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
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	ENDTEXT
	nidpc=This.EJECUTARF(lc,lp,cur)
	If nidpc<0 Then
		Return 0
	Else
		Return nidpc
	Endif
	Endfunc
	Function IngresaDatosLCajaEFectivo11(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14)
	lc="ProIngresaDatosLcajaEefectivo"
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
	goapp.npara15=goapp.tienda
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	If This.EJECUTARP(lc,lp,"")<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoinicialporcajerotienda(nidus,df,df1,nidt)
	dfecha=cfechas(fe_gene.fech)
	dfecha1=cfechas(Ctod("28/12/2017"))
	ccursor='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
        lcaj_idus,SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo
        FROM fe_lcaja  as a WHERE
        a.lcaj_fech between '<<dfecha1>>' and  '<<dfecha>>' and  a.lcaj_acti='A'  and  a.lcaj_form='E'  and  lcaj_idus=<<nidus>> and lcaj_codt=<<nidt>> group by lcaj_idus
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return -1
	Endif
	Select (ccursor)
	nsaldo=Iif(Isnull(saldo),0,saldo)
	Return nsaldo
	Endfunc
	Function TraspasoDatosLCajaE(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
	lc="FunTraspasoDatosLcajaE"
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
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidc=This.EJECUTARF(lc,lp,cur)
	If nidc<0 Then
		Return 0
	Endif
	Return nidc
	Endfunc
	Function logscaja(fi,F,ccursor)
	Set DataSession To This.idsesion
	dfi=cfechas(fi)
	ff=F+1
	dff=cfechas(ff)
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT a.lcaj_fech as fecha,x.nomb as usuario,a.lcaj_deta as detalle,acaj_fech as fechaoperacion,'' as autorizo,a.lcaj_mone as moneda,
	if(lcaj_deud>0,a.lcaj_deud,lcaj_acre) as importe,a.lcaj_dcto As documento FROM
	fe_lcaja as a
	inner join fe_acaja as b on b.acaj_caja=a.lcaj_idca
	inner join fe_usua as x on x.idusua=a.lcaj_idus
    WHERE a.lcaj_fech BETWEEN '<<dfi>>' AND '<<dff>>' order by lcaj_fech
	ENDTEXT
	If  This.EjecutaConsulta(lc,ccursor)<1
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecaja0(dfi, dff, Calias)
	fi = cfechas(dfi)
	ff = cfechas(dff)
	Set DataSession To This.idsesion
	TEXT To lc Noshow Textmerge
	       select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
		   c.ncta,c.nomb,if(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)) as debe,
		   if(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)) as haber,
		   a.lcaj_idct as idcta,lcaj_tran,if(lcaj_deud>0,'I','S') as tipomvto,'' as lcaj_dcto
		   from fe_lcaja as a
		   inner join fe_plan as c on c.idcta=a.lcaj_idct
		   where a.lcaj_acti='A' AND a.lcaj_fech between '<<fi>>' and '<<ff>>' order by a.lcaj_fech
	ENDTEXT
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo0(df)
	F = cfechas(df)
	Calias='c_'+Sys(2015)
	TEXT To lc Noshow Textmerge Pretext 7
     SELECT CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>' AND lcaj_idct>0
	ENDTEXT
	If This.EjecutaConsulta(lc, (Calias)) < 1 Then
		Return 0
	Endif
	Select (Calias)
	nsaldo=Iif(Isnull(si),0,si)
	Return nsaldo
	Endfunc
	Function IngresaDatosLCajaECreditos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
	lc="FunIngresaDatosLcajaECreditos"
	cur="Cred"
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
	TEXT to lp NOSHOW 
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7, ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	If this.EJECUTARF(lc,lp,cur)<1 Then
		Return 0
	ENDIF 
	Return cred.Id
	Endfunc
Enddefine
