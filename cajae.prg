Define Class cajae As Odata Of  'd:\capass\database\data.prg'
	dFecha = Date()
	codt = 0
	Ndoc = ""
	Nsgte = 0
	Idserie = 0
	nidprovedor = 0
	cdetalle = ""
	nidcta = 0
	ndebe = 0
	nhaber = 0
	ndolar = 0
	nidusua = 0
	nidclpr = 0
	NAuto = 0
	cmoneda=""
	cTdoc = ""
	cforma=""
	dfi=DATE()
	dff=DATE()
	Function ReporteCajaEfectivo(dfi, dff, Calias)
	Local lC
	fi = cfechas(dfi)
	ff = cfechas(dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	   Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	   c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	   If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
		a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
		From fe_lcaja As a
		inner Join fe_plan As c On c.idcta=a.lcaj_idct
		Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And (lcaj_form='E' OR (lcaj_form='T' AND lcaj_deud>0)) Order By a.lcaj_fech
	Endtext
	If This.EjecutaConsulta(lC, (Calias)) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ReporteCajaEfectivo10(dfi, dff, Calias)
	Local lC
	fi = cfechas(dfi)
	ff = cfechas(dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lC Noshow Textmerge
	    Select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
	    c.ncta,c.nomb,If(lcaj_mone='S',a.lcaj_deud,Round(a.lcaj_deud*a.lcaj_dola,2)) As debe,
	    If(a.lcaj_mone='S',a.lcaj_acre,Round(a.lcaj_acre*a.lcaj_dola,2)) As haber,
	    a.lcaj_idct As idcta,lcaj_tran,If(lcaj_deud>0,'I','S') As tipomvto,lcaj_idca,lcaj_dcto
		From fe_lcaja As a
		inner Join fe_plan As c On c.idcta=a.lcaj_idct
		Where a.lcaj_acti='A' And a.lcaj_fech Between '<<fi>>' And '<<ff>>'  And lcaj_form='E' Order By a.lcaj_fech
	Endtext
	If This.EjecutaConsulta(lC, (Calias)) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo10(Df)
	F = cfechas(Df)
	Text To lC Noshow Textmerge Pretext 7
     SELECT 
     CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>'  AND lcaj_idct>0 AND lcaj_form='E'
	Endtext
	If This.EjecutaConsulta(lC, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si), 0, iniciocaja.si)
	Endfunc
	Function Saldoinicialcajaefectivo(Df)
	F = cfechas(Df)
	Text To lC Noshow Textmerge Pretext 7
     SELECT 
     CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>'  AND lcaj_idct>0 AND (lcaj_form='E' OR (lcaj_form='T' AND lcaj_deud>0))
	Endtext
	If This.EjecutaConsulta(lC, 'iniciocaja') < 1 Then
		Return 0
	Endif
	Return Iif(Isnull(iniciocaja.si), 0, iniciocaja.si)
	Endfunc
    FUNCTION IngresaDatosLCajaEe(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)  
	lC = "FunIngresaDatosLcajaEe"
	cur = "Ca"
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	Endtext
	nidpc = This.EJECUTARf(lC, lp, cur)
	If nidpc < 0 Then
		Return 0
	Else
		Return nidpc
	Endif
	Endfunc
	Function IngresaDatosLCajaEFectivo11(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14)
	lC = "ProIngresaDatosLcajaEefectivo"
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
	goApp.npara15 = goApp.Tienda
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivo10()
	lC = "ProIngresaDatosLcajaEefectivo"
	Text To lp NOSHOW TEXTMERGE 
     ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,<<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>','<<this.ndoc>>','<<this.cTdoc>>')
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivo11()
	lC = "ProIngresaDatosLcajaEefectivo11"
	Text To lp NOSHOW TEXTMERGE 
     ('<<cfechas(this.dfecha)>>','','<<this.cdetalle>>',<<this.nidcta>>,<<this.ndebe>>,<<this.nhaber>>,'<<this.cmoneda>>',<<this.ndolar>>,<<goapp.nidusua>>,<<this.nidclpr>>,<<this.NAuto>>,'<<this.cforma>>','<<this.ndoc>>','<<this.cTdoc>>',<<this.codt>>)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoinicialporcajerotienda(nidus, Df, df1, nidt)
	dFecha = cfechas(fe_gene.fech)
	dfecha1 = cfechas(Ctod("28/12/2017"))
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge
        select lcaj_idus,SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo
        FROM fe_lcaja  as a WHERE
        a.lcaj_fech between '<<dfecha1>>' and  '<<dfecha>>' and  a.lcaj_acti='A'  and  a.lcaj_form='E'  and  lcaj_idus=<<nidus>> and lcaj_codt=<<nidt>> group by lcaj_idus
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return - 1
	Endif
	Select (Ccursor)
	nsaldo = Iif(Isnull(saldo), 0, saldo)
	Return nsaldo
	Endfunc
	Function TraspasoDatosLCajaE(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	lC = "FunTraspasoDatosLcajaE"
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	nidc = This.EJECUTARf(lC, lp, cur)
	If nidc < 0 Then
		Return 0
	Endif
	Return nidc
	Endfunc
	Function logscaja(fi, F, Ccursor)
	Set DataSession To This.Idsesion
	dfi = cfechas(fi)
	ff = F + 1
	dff = cfechas(ff)
	Text To lC Noshow Textmerge
	SELECT a.lcaj_fech as fecha,x.nomb as usuario,a.lcaj_deta as detalle,acaj_fech as fechaoperacion,'' as autorizo,a.lcaj_mone as moneda,
	if(lcaj_deud>0,a.lcaj_deud,lcaj_acre) as importe,a.lcaj_dcto As documento FROM
	fe_lcaja as a
	inner join fe_acaja as b on b.acaj_caja=a.lcaj_idca
	inner join fe_usua as x on x.idusua=a.lcaj_idus
    WHERE a.lcaj_fech BETWEEN '<<dfi>>' AND '<<dff>>' order by lcaj_fech
	Endtext
	If  This.EjecutaConsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecaja0(dfi, dff, Calias)
	fi = cfechas(dfi)
	ff = cfechas(dff)
	Set DataSession To This.Idsesion
	Text To lC Noshow Textmerge
	       select a.lcaj_ndoc,a.lcaj_fech,a.lcaj_deta,
		   c.ncta,c.nomb,if(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)) as debe,
		   if(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)) as haber,
		   a.lcaj_idct as idcta,lcaj_tran,if(lcaj_deud>0,'I','S') as tipomvto,'' as lcaj_dcto
		   from fe_lcaja as a
		   inner join fe_plan as c on c.idcta=a.lcaj_idct
		   where a.lcaj_acti='A' AND a.lcaj_fech between '<<fi>>' and '<<ff>>' order by a.lcaj_fech
	Endtext
	If This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Saldoinicialcajaefectivo0(Df)
	F = cfechas(Df)
	Calias = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge Pretext 7
     SELECT CAST((SUM(IF(lcaj_mone='S',a.lcaj_deud,ROUND(a.lcaj_deud*a.lcaj_dola,2)))-SUM(IF(a.lcaj_mone='S',a.lcaj_acre,ROUND(a.lcaj_acre*a.lcaj_dola,2)))) as decimal(12,2)) AS si
	 FROM fe_lcaja AS a
	 WHERE a.lcaj_acti='A' AND a.lcaj_fech<'<<f>>' AND lcaj_idct>0
	Endtext
	If This.EjecutaConsulta(lC, (Calias)) < 1 Then
		Return 0
	Endif
	Select (Calias)
	nsaldo = Iif(Isnull(si), 0, si)
	Return nsaldo
	Endfunc
	Function IngresaDatosLCajaECreditos(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13)
	lC = "FunIngresaDatosLcajaECreditos"
	cur = "Cred"
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
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7, ?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	Endtext
	If This.EJECUTARf(lC, lp, cur) < 1 Then
		Return 0
	Endif
	Return cred.Id
	Endfunc
	Function DesactivaCajaEfectivoDe(np1)
	lC = 'ProDesactivaCajaEfectivoDe'
	goApp.npara1 = np1
	Text To lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(lC, lp, "") = 0 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	FUNCTION resumenporcajero(ccursor)
	fi=cfechas(this.dfi)
	ff=cfechas(this.dff)
	TEXT TO lc NOSHOW TEXTMERGE 
	  select nomb,saldo,lcaj_idus FROM (
	  SELECT SUM(if(a.lcaj_deud<>0,lcaj_deud,-lcaj_acre)) as saldo,lcaj_idus
      FROM fe_lcaja  as a 
      WHERE  a.lcaj_fech between '<<fi>>' and '<<ff>>' and a.lcaj_acti='A' and a.lcaj_form='E'  group by lcaj_idus) as c
      inner join fe_usua as u on u.idusua=c.lcaj_idus 
	ENDTEXT
	If this.ejecutaconsulta(lc,"tc")<1
		RETURN 0
	ENDIF 
	RETURN 1
	ENDFUNC 
Enddefine






