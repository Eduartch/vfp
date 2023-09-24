Define Class cajarodi As cajae Of 'd:\capass\modelos\cajae'
    cdetalle1=""
    cdetalle2=""
	Function saldoanterior1()
	lc='FunSaldoCaja'
	calias='c_'+Sys(2015)
	dfecha=cfechas(This.dfecha)
	TEXT to lp NOSHOW TEXTMERGE
     ('<<dfecha>>',<<this.codt>>)
	ENDTEXT
	If This.EJECUTARF(lc,lp,calias)<1 Then
		If This.conerror=1 Then
			Return -1
		Endif
	Endif
	Select (calias)
	nsaldo=Iif(Isnull(Id),0,Id)
	Return nsaldo
	Endfunc
	Function reportecaja1(ccursor)
	Set DataSession To This.idsesion
	dfecha=cfechas(This.dfecha)
	nidalma=This.codt
	TEXT to lc NOSHOW TEXTMERGE
	     select ifnull(k.prec,0) as prec,ifnull(k.idart,'') as coda,day(a.fech) as dia,ifnull(k.cant,0) as cant,
		 CASE a.forma
         WHEN 'E' THEN 'Efecivo'
         WHEN 'C' THEN 'Crédito'
         WHEN 'T' THEN 'Tarjeta'
         ELSE 'Deposito'
         END AS forma,a.deta,
		ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ifnull(ROUND(k.cant*k.prec,2),0) as Np,
		CAST(if(forma='C',ifnull(ROUND(k.cant*k.prec,2),a.impo),0)  as decimal(12,2)) as credito,origen,tipo,
		case origen when "CK" then 'a'
		when "Ca" then 'c' when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
		if(a.origen='CC',a.impo,0) as pagos,
        if(a.origen<>'CC',if(tipo='I',if(a.forma='E',if(left(a.deta,8)="Cambiada",0,ifnull(if(a.impo=0,0,ROUND(k.cant*k.prec,2)),a.impo)),0),0),0) as ingresos,
        CAST(0 as decimal(12,2)) as usada,
		CAST(IF(a.forma='D',IFNULL(ROUND(k.cant*k.prec,2),0),IF(a.origen='CB',a.impo,0)) AS DECIMAL(12,2)) AS bancos,
		if(a.forma='T',if(caja_tarj=0,ROUND(k.cant*k.prec,2),0),0) as tarjeta1,
		if(a.tipo='S',if(a.origen='Ca',a.impo,0),0) as gastos,idcon
		from fe_caja as a
		left join fe_rcom as b on b.idauto=a.idauto
		left join (select idart,alma,cant,prec,idauto from fe_kar as q where acti='A' AND q.alma=<<nidalma>> AND tipo='V') as k on k.idauto=b.idauto
		where a.fech='<<dfecha>>' and a.acti='A' and a.codt=<<nidalma>> and a.caja_form='E'
		union all
		select k.prec,k.idart as coda,day(a.fech) as dia,k.cant,
		 CASE a.forma
         WHEN 'E' THEN 'Efecivo'
         WHEN 'C' THEN 'Crédito'
         WHEN 'T' THEN 'Tarjeta'
         ELSE 'Deposito'
         END AS forma,a.deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ROUND(k.cant*-k.prec,2) as Np,
        if(forma='C',ROUND(k.cant*-k.prec,2),0) as credito,origen,tipo,'a' as orden,0 as pagos,0 as ingresos,
        if(a.forma='E',ROUND(k.cant*k.prec,2),0) as usada,0 as bancos,
        if(a.forma='T',if(caja_tarj=0,ROUND(k.cant*-k.prec,2),0),0) as tarjeta1,0 as gastos,idcon
		from fe_caja as a
		inner join fe_rcom as b on b.idauto=a.idauto
        inner join (select q.idart,alma,cant,q.prec,idauto from fe_kar as q join fe_art a on a.idart=q.idart
        where acti='A' AND q.alma=<<nidalma>> AND tipo='C' and a.tipro='C') as k on k.idauto=b.idauto
		where a.fech='<<dfecha>>'  and a.acti='A' and a.codt=<<nidalma>>
		union all
        select 0 as prec,' ' as coda,day(a.fech) as dia,0 as cant,
		'Tarjeta' as forma,a.deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,origen,tipo,
		case origen when "CK" then 'a'
		when "Ca" then 'c' when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,a.impo as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,caja_tarj as tarjeta1,0 as gastos,idcon
		from fe_caja as a
		inner join fe_rcom as b on b.idauto=a.idauto
		where a.fech='<<dfecha>>'  and a.acti='A' and a.codt=<<nidalma>>  and caja_tarj>0
		union all
		select 0 as prec,' ' as coda,day(a.fech) as dia,0 as cant,
		'Efectivo' as forma,a.deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,origen,tipo,
		case origen when "CK" then 'a'
		when "Ca" then 'c' when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,a.impo as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,0 as tarjeta1,0 as gastos,idcon
		from fe_caja as a
		inner join fe_rcom as b on b.idauto=a.idauto
		where a.fech='<<dfecha>>'  and a.acti='A' and a.codt=<<nidalma>> and left(a.deta,8)="Cambiada"
	    order by tdoc,ndoc
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivorodi(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20)
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
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20)
	ENDTEXT
	If This.EJECUTARP(lc,lp,"")<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaDatosLCajaEFectivorodi1(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21)
	lc="ProIngresaDatosLcajaEefectivo1"
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
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,
     ?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21)
	ENDTEXT
	If This.EJECUTARP(lc,lp,"")<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldoanterior2()
	lc='FunSaldoCaja'
	calias='c_'+Sys(2015)
	dfecha=cfechas(This.dfecha)
	TEXT to lp NOSHOW TEXTMERGE
     ('<<dfecha>>',<<this.codt>>)
	ENDTEXT
	If This.EJECUTARF(lc,lp,calias)<1 Then
		If This.conerror=1 Then
			Return -1
		Endif
	Endif
	Select (calias)
	nsaldo=Iif(Isnull(Id),0,Id)
	Return nsaldo
	Endfunc
	Function reportecaja2(ccursor)
	Set DataSession To This.idsesion
	dfecha=cfechas(This.dfecha)
	nidalma=This.codt
	TEXT to lc NOSHOW TEXTMERGE
	     select ifnull(k.prec,0) as prec,ifnull(k.idart,'') as coda,day(a.lcaj_fech) as dia,ifnull(k.cant,0) as cant,
		 CASE a.lcaj_form
         WHEN 'E' THEN 'Efecivo'
         WHEN 'C' THEN 'Crédito'
         WHEN 'T' THEN 'Tarjeta'
         ELSE 'Deposito'
         END AS forma,a.lcaj_deta as deta,
		IFNULL(lcaj_dcto,b.ndoc) AS ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ifnull(ROUND(k.cant*k.prec,2),0) as Np,
		CAST(if(lcaj_form='C',ifnull(ROUND(k.cant*k.prec,2),a.lcaj_deud),0)  as decimal(12,2)) as credito,
		lcaj_orig AS origen,if(lcaj_deud>0,'I','E') as tipo,
		case lcaj_orig
		when "CK" then 'a'
		when "Ca" then 'c'
		when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
		if(a.lcaj_orig='CC',a.lcaj_deud,0) as pagos,
	    if(a.lcaj_orig<>'CC',if(lcaj_deud>0,if(a.lcaj_form='E',if(left(a.lcaj_deta,8)="Cambiada",0,ifnull(if(a.lcaj_deud=0,0,ROUND(k.cant*k.prec,2)),a.lcaj_deud)),0),0),0) as ingresos,
        CAST(0 as decimal(12,2)) as usada,
		CAST(IF(a.lcaj_form='D',IFNULL(ROUND(k.cant*k.prec,2),0),IF(a.lcaj_orig='CB',a.lcaj_acre,0)) AS DECIMAL(12,2)) AS bancos,
		if(a.lcaj_form='T',if(lcaj_tarj=0,ROUND(k.cant*k.prec,2),0),0) as tarjeta1,
		if(a.lcaj_acre>0,if(a.lcaj_orig='Ca',if(lcaj_form='C',0,a.lcaj_acre),if(lcaj_orig='CB',0,lcaj_acre)),0) as gastos
		from fe_lcaja as a
		left join fe_rcom as b on b.idauto=a.lcaj_idau
		left join (select idart,alma,cant,prec,idauto from fe_kar as q where acti='A' AND q.alma=<<nidalma>> AND tipo='V') as k on k.idauto=b.idauto
		where a.lcaj_fech='<<dfecha>>' and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>> and a.caja_form='E' 
		union all
		select k.prec,k.idart as coda,day(a.lcaj_fech) as dia,k.cant,
		CASE a.lcaj_form
        WHEN 'E' THEN 'Efecivo'
        WHEN 'C' THEN 'Crédito'
        WHEN 'T' THEN 'Tarjeta'
        ELSE 'Deposito'
        END AS forma,a.lcaj_deta As deta,
	    ifnull(a.lcaj_dcto,ndoc) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		ROUND(k.cant*-k.prec,2) as Np,
        if(lcaj_form='C',ROUND(k.cant*-k.prec,2),0) as credito,lcaj_orig As origen,if(lcaj_deud>0,'I','S') as tipo,'a' as orden,0 as pagos,0 as ingresos,
        if(a.lcaj_form='E',ROUND(k.cant*k.prec,2),0) as usada,0 as bancos,
        if(a.lcaj_form='T',if(lcaj_tarj=0,ROUND(k.cant*-k.prec,2),0),0) as tarjeta1,0 as gastos
		from fe_lcaja as a
		inner join fe_rcom as b on b.idauto=a.lcaj_idau
        inner join (select q.idart,alma,cant,q.prec,idauto from fe_kar as q join fe_art a on a.idart=q.idart
        where acti='A' AND q.alma=<<nidalma>> AND tipo='C' and a.tipro='C' ) as k on k.idauto=b.idauto
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>> and b.idcliente>0
		union all
        select 0 as prec,' ' as coda,day(a.lcaj_fech) as dia,0 as cant,
		'Tarjeta' as forma,a.lcaj_deta As deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.lcaj_dcto) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,lcaj_orig AS origen,if(lcaj_deud>0,'I','S') as tipo,
		case lcaj_orig
		when "CK" then 'a'
		when "Ca" then 'c'
		when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,lcaj_deud as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,lcaj_tarj as tarjeta1,0 as gastos
		from fe_lcaja as a
		inner join fe_rcom as b on b.idauto=a.lcaj_idau
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>>  and lcaj_tarj>0
		union all
		select 0 as prec,' ' as coda,day(a.lcaj_fech) as dia,0 as cant,
		'Efectivo' as forma,a.lcaj_deta As deta,
	    ifnull(if(tdoc='01',if(left(b.ndoc,1)='F',b.ndoc,concat('F/.',b.ndoc)),
        if(left(b.ndoc,1)='B',b.ndoc,concat('B/.',b.ndoc))),a.lcaj_dcto) as ndoc,
        ifnull(b.tdoc,'99') as tdoc,
		0 as Np,0 as credito,lcaj_orig as origen,if(lcaj_deud>0,'I','S') as tipo,
		case lcaj_orig
		when "CK" then 'a'
		when "Ca" then 'c'
		when "CC" then 'b'
		when "CB" then 'd' else 'z' end as orden,
	    0 as pagos,a.lcaj_deud as ingresos,CAST(0 as decimal(12,2)) as usada,0 as bancos,0 as tarjeta1,0 as gastos
		from fe_lcaja as a
		inner join fe_rcom as b on b.idauto=a.lcaj_idau
		where a.lcaj_fech='<<dfecha>>'  and a.lcaj_acti='A' and a.lcaj_codt=<<nidalma>> and left(a.lcaj_deta,8)="Cambiada"
	    order by tdoc,ndoc
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registraTransferenciabancosRetiro(dfecha,cndoc,cdetalle,nidcta,nimpo,cmoneda,ndolar,nidb,corigen,nidtda,cfp)
    SET DATASESSION TO this.idsesion
	If BuscarSeries(1,'LC')=0 Then
		This.cmensaje="NO Hay Correlativo"
		Return 0
	Endif
	ccorrelativo='001'+Right('0000000'+Alltrim(Str(series.nume)),7)
	This.ndoc=ccorrelativo
	This.nsgte=series.nume
	This.idserie=series.idserie
	If This.iniciatransaccion()<1 Then
		Return 0
	Endif
	vd=This.TraspasoDatosLCajaErodi(dfecha,ccorrelativo,_Screen.ocajae.cdetalle1,nidcta,0,nimpo,cmoneda,ndolar,goapp.nidusua,0,corigen,nidtda,cfp)
	If vd<1 Then
		This.deshacerCambios()
		Return 0
	Endif
	If _Screen.obancos.IngresaDatosLCajaT(nidb,dfecha,cndoc,1,_Screen.ocajae.cdetalle2,0,0,ccorrelativo,fe_gene.gene_idca,nimpo,0,1,vd)<1 Then
		This.deshacerCambios()
		This.cmensaje=_Screen.obancos.cmensaje
		Return 0
	Endif
	If This.generacorrelativo()<1 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.Grabarcambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarparaquitar(todos,fe,f1,f2,ccursor)
	dfi=cfechas(f1)
	dff=cfechas(f2)
	dfecha=cfechas(fe)
	Set DataSession To This.idsesion
	If Left(goapp.tipousuario,1)="G"  Or Left(goapp.tipousuario,1)="A"
		If goapp.xopcion=0 Then
			If todos=1 Then
				TEXT TO lc NOSHOW TEXTMERGE
                 SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB")  AND acti<>'I' and fech between '<<dfi>>' and '<<dff>>' ORDER BY fech
				ENDTEXT
			Else
				TEXT TO lc NOSHOW TEXTMERGE
             SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB")  AND acti<>'I'  and fech='<<dfecha>>' ORDER BY fech
				ENDTEXT
			Endif
		Else
			If todos=1 Then
				TEXT TO lc NOSHOW TEXTMERGE
                 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech between '<<dfi>>' and '<<dff>>' ORDER BY lcaj_fech
				ENDTEXT
			Else
				TEXT TO lc NOSHOW TEXTMERGE
				 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech='<<dfecha>>' ORDER BY lcaj_fech
				ENDTEXT
			Endif
		Endif
	Else
		If goapp.xopcion=0 Then
			If todos=1 Then
				TEXT  TO  lc NOSHOW TEXTMERGE
                 SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB") and acti<>'I' AND fech between '<<dfi>>' and '<<dff>>'  ORDER BY fech
				ENDTEXT
			Else
				TEXT  TO  lc NOSHOW TEXTMERGE
                SELECT idcaja,fech,impo,deta,tmon,origen,idauto FROM fe_caja WHERE origen in ("Ca","CC","CB") and acti<>'I' AND fech='<<dfecha>>' ORDER BY fech
				ENDTEXT
			Endif
		Else
			If todos=1 Then
				TEXT TO lc NOSHOW TEXTMERGE
                 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech between '<<dfi>>' and '<<dff>>' ORDER BY lcaj_fech
				ENDTEXT
			Else
				TEXT TO lc NOSHOW TEXTMERGE
				 SELECT lcaj_idca as idcaja,lcaj_fech as fech,if(lcaj_deud>0,lcaj_deud,lcaj_acre) as impo,lcaj_deta as deta,lcaj_mone as tmon,lcaj_orig as origen,lcaj_idau as idauto
                 FROM fe_lcaja WHERE lcaj_orig in ("Ca","CC","CB")  AND lcaj_acti<>'I' and lcaj_fech='<<dfecha>>' ORDER BY lcaj_fech
				ENDTEXT
			Endif
		Endif
	Endif
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1.
	Endfunc
	Function registrapagos1(dfecha,cndoc,cdetalle,nidcta,nimporte,cmone,ndolar,ncontrol,ctipo)
	q=1
	If This.iniciatransaccion()<1 Then
		Return 0
	Endif
	If ctipo='I'  Then
		xc=IngresaDatosLcajaE(dfecha,cndoc,cdetalle,nidcta,nimporte,0,cmone,ndolar,goapp.nidusua,ncontrol)
		If xc=0 Then
			q=0
		Else
			If  ncontrol>0 Then
				Select atmp
				Scan All
					cxr=CancelaCreditosCCajaE(cndoc,atmp.saldo,'P',atmp.moneda,cdetalle,dfecha,atmp.fevto,atmp.tipo,atmp.ncontrol,atmp.nrou,atmp.idrc,Id(),goapp.nidusua,xc)
					If cxr=0 Then
						q=0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Else
		xc=IngresaDatosLcajaE(dfecha,cndoc,cdetalle,nidcta,	0,nimporte,cmone,ndolar,goapp.nidusua,ncontrol)
		If xc=0 Then
			q=0
		Else
			If ncontrol>0 Then
				Select atmp
				Scan All
					cxd=CancelaDeudasCCajae(dfecha,atmp.fevto,atmp.saldo,cndoc,'P',	atmp.moneda,cdetalle,atmp.tipo,atmp.idrd,goapp.nidusua,atmp.ncontrol,'',Id(),ndolar,xc)
					If cxd=0 Then
						q=0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Endif
	If q=0  Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.generacorrelativo()<1 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.Grabarcambios()<1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function ActualizaLcaja1(dfecha,cndoc,cdetalle,nidcta,nimporte,cmone,ndolar,ncontrol,n4,ctipo)
	If ctio='I' Then
		If ActualizaDatosLcajaE(dfecha,.cndoc,cdetalle,nidcta,nimporte,0,n4,1,cmone,ndolar)<1
			Return 0
		Endif
	Else
		If ActualizaDatosLcajaE(dfecha,.cndoc,cdetalle,nidcta,nimporte,0,n4,1,cmone,ndolar)<1
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function generacorrelativo()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr=Createobject("correlativo")
	ocorr.ndoc=This.ndoc
	ocorr.nsgte=This.nsgte
	ocorr.idserie=This.idserie
	If ocorr.generacorrelativo()<1  Then
		This.cmensaje=ocorr.cmensaje
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registrapagosporcajarodi(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12)
	lc="FunIngresaDatosLcajaE"
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
	TEXT to lp NOSHOW
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	ENDTEXT
	nidcaja=This.EJECUTARF(lc,lp,cur)
	If nidcaja<1 Then
		Return 0
	Endif
	Return nidcaja
	Endfunc
	Function registrapagos2(dfecha,cndoc,cdetalle,nidcta,nimporte,cmone,ndolar,nctrl,ctipo,nidtda)
	If This.iniciatransaccion()<1 Then
		Return 0
	Endif
	If ctipo='I'  Then
		xc= This.Registrapagosporcajarodi(dfecha,cndoc,cdetalle,nidcta,nimporte,0,cmone,ndolar,goapp.nidusua,nctrl,'E',nidtda)
		If xc=0 Then
			q=0
		Else
			If  nctrl>0 Then
				Select atmp
				Scan All
					cxr=CancelaCreditosCCajaE(cndoc,atmp.saldo,'P',atmp.moneda,cdetalle,dfecha,atmp.fevto,atmp.tipo,atmp.ncontrol,atmp.nrou,atmp.idrc,Id(),goapp.nidusua,xc)
					If cxr=0 Then
						q=0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Else
		xc=This.Registrapagosporcajarodi(dfecha,cndoc,cdetalle,nidcta,0,nimporte,cmone,ndolar,goapp.nidusua,nctrl,'E',nidtda)
		If xc=0 Then
			q=0
		Else
			If nctrl>0 Then
				Select atmp
				Scan All
					cxd=CancelaDeudasCCajae(dfecha,atmp.fevto,atmp.saldo,cndoc,'P',	atmp.moneda,cdetalle,atmp.tipo,atmp.idrd,goapp.nidusua,atmp.ncontrol,'',Id(),ndolar,xc)
					If cxd=0 Then
						q=0
						Exit
					Endif
					Select atmp
				Endscan
			Endif
		Endif
	Endif
	If q=0  Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.generacorrelativo()<1 Then
		This.deshacerCambios()
		Return 0
	Endif
	If This.Grabarcambios()<1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function TraspasoDatosLCajaErodi(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
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
	goapp.npara13=np13
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	nidc=This.EJECUTARF(lc,lp,cur)
	If nidc<0 Then
		Return 0
	Endif
	Return nidc
	Function reportecajacreditos1(ccursor)
	Set DataSession To This.idsesion
	dfecha=cfechas(This.dfecha)
	nidalma=This.codt
	TEXT to lc NOSHOW TEXTMERGE
		select day(a.fech) as dia,a.deta,
		ifnull(if(tdoc='01',concat('F/.',b.ndoc),concat('B/.',b.ndoc)),a.ndoc) as ndoc,ifnull(b.tdoc,'99') as tdoc,
		origen,tipo,case tipo when "I" then 'a' when "S" then 'b' else 'z' end as orden,
		if(a.origen='CC',a.impo,CAST(0 as decimal(10,2))) as pagos,idcaja,
		if(a.origen='CB',a.impo,CAST(0 as decimal(10,2))) as bancos from fe_caja as a
		left join fe_rcom as b on b.idauto=a.idauto
		where a.fech='<<df>>' and a.acti='A' and a.impo<>0 and a.codt=<<nidalma>> and a.caja_form='C' order by idcaja
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function reportecajacreditos2(ccursor)
	Set DataSession To This.idsesion
	dfecha=cfechas(This.dfecha)
	nidalma=This.codt
	TEXT to lc NOSHOW TEXTMERGE
		select day(a.lcaj_fech) as dia,a.lcaj_deta as deta,
		ifnull(if(tdoc='01',concat('F/.',b.ndoc),concat('B/.',b.ndoc)),a.lcaj_dcto)  as ndoc,ifnull(b.tdoc,'99') as tdoc,
		lcaj_orig as origen,if(lcaj_deud>0,'I','S') as tipo,if(lcaj_deud>0, 'a' , 'b') as orden,
		if(a.lcaj_orig='CC',a.lcaj_deud,CAST(0 as decimal(10,2))) as pagos,lcaj_idca As idcaja,
		if(a.lcaj_orig='CB',a.lcaj_acre,CAST(0 as decimal(10,2))) as bancos from fe_lcaja as a
		left join fe_rcom as b on b.idauto=a.lcaj_idau
		where a.lcaj_fech='<<df>>' and a.lcaj_acti='A' and (a.lcaj_deud<>0 or lcaj_acre<>0) 
		and a.lcaj_codt=<<nidalma>> and a.caja_form='C' order by idcaja
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function TraspasoDatosLCajaErodi0(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10)
	lc="FunTraspasoDatosLcajaE"
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
	nidc=This.EJECUTARF(lc,lp,cur)
	If nidc<1 Then
		Return 0
	Endif
	Return nidc
	Endfunc
Enddefine
