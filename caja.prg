Define Class caja As Odata Of "d:\capass\database\data.prg"
    dfecha=DATE()
    dfi=DATE()
	dff=DATE()
	nidusua=0
	cmoneda=""
	ntienda=0
	conusuario=0
	ante=0
	Function Registrarcaja(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15)
	Local lc, lp
*:Global cur
	m.lc		  = "ProIngresaDatosLcajaEefectivo11"
	cur			  = ""
	goapp.npara1  = m.np1
	goapp.npara2  = m.np2
	goapp.npara3  = m.np3
	goapp.npara4  = m.np4
	goapp.npara5  = m.np5
	goapp.npara6  = m.np6
	goapp.npara7  = m.np7
	goapp.npara8  = m.np8
	goapp.npara9  = m.np9
	goapp.npara10 = m.np10
	goapp.npara11 = m.np11
	goapp.npara12 = m.np12
	goapp.npara13 = m.np13
	goapp.npara14 = m.np14
	goapp.npara15 = m.np15
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function buscasiestaregistradodcto(np1, np2)
	Local lc
	TEXT To m.lc Noshow Textmerge
	Select  lcaj_idca  As idcaja  From fe_lcaja Where lcaj_dcto='<<np1>>' And lcaj_acti = 'A'  And lcaj_tdoc = '<<np2>>'
	ENDTEXT
	If This.EjecutaConsulta(m.lc, 'yaestaencaja') < 1 Then
		Return 0
	Endif
	If yaestaencaja.idcaja > 0 Then
		This.Cmensaje='Ya esta Registrado el Número del Documento'
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarCajaChicaNotaria(np1, ccursor)
	Local lc
	TEXT To m.lc Noshow Textmerge
	   Select  lcaj_dcto As dcto, lcaj_deud As importe,lcaj_deta as detalle, lcaj_fope As fechahora
	   From fe_lcaja
	   Where lcaj_fech='<<np1>>'   And lcaj_acti = 'A'  lcaj_idus = 0   And lcaj_tdoc = 'Ti'  Order By lcaj_dcto
	ENDTEXT
	If This.EjecutaConsulta(m.lc, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaropencaja(np1)
	ccursor='C'+Sys(2015)
	TEXT TO lc NOSHOW textmerge
	      SELECT lcaj_ndoc  as operacion FROM fe_lcaja WHERE TRIM(lcaj_ndoc)='<<np1>>' AND lcaj_acti='A'  AND lcaj_deud>0 limit 1
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	If !Empty(operacion) Then
		This.Cmensaje='Número de Depósito Ya Registrado'
		Return 0
	Endif
	Return 1
	ENDFUNC
	FUNCTION salanteriorm(ff1,ff2,cmoneda)
	f1=cfechas(ff1)
	f2=cfechas(ff2)
	ccursor='c_'+SYS(2015)
	TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
	    select SUM(if(a.lcaj_deud<>0,lcaj_deud,0)) as ingresoss,SUM(if(a.lcaj_acre<>0,lcaj_acre,0)) as egresoss
	    FROM fe_lcaja  as a WHERE  a.lcaj_fech between '<<f1>>' and '<<f2>>'  and a.lcaj_acti='A' and a.lcaj_form='E' 
	    and lcaj_idus=<<this.nidusua>>  and lcaj_mone='<<this.cmoneda>>' group by lcaj_idus
	ENDTEXT
	If this.Ejecutaconsulta(lc,ccursor)<1
		RETURN 0
	ENDIF
	SELECT (ccursor)
	RETURN ingresoss-egresoss
	ENDFUNC 
	FUNCTION listarcajam(ccursor)
	F=cfechas(this.dfecha)
	Do Case
	Case this.ntienda=0 And this.conusuario =1
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
	        select deta,ndoc,
			round(case forma when 'E' then if(tipo='I',impo,0) else 0 end,2) as efectivo,
			round(case forma when 'C' then if(tipo='I',impo,0) else 0 end,2) as credito,
			round(case forma when 'D' then if(tipo='I',impo,0) else 0 end,2) as deposito,
			round(case forma when 'H' then if(tipo='I',impo,0) else 0 end,2) as cheque,
			round(case forma when 'T' then if(tipo='I',impo,0) else 0 end,2) as tarjeta,
			round(case forma when 'A' then if(tipo='I',impo,0) else 0 end,2) as antic,
			round(case tipo when 'S' then if(forma='E',impo,0) else 0 end,2) as egresos,
			usua,fechao,usuavtas,forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,refe
			from(
			SELECT a.lcaj_tdoc as tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I',if(lcaj_acre=0,'I','S')) as tipo,
			if(left(lcaj_dcto,1)='0',concat(if(lcaj_tdoc='01','F/.',if(lcaj_tdoc='03','B/.','P/.')),lcaj_dcto),lcaj_dcto) as ndoc,
			if(lcaj_deud<>0,lcaj_deud,if(lcaj_acre=0,lcaj_deud,lcaj_acre)) as impo,
            lcaj_deta as deta,lcaj_mone as  mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,lcaj_dola as dola,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a 
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau>0 AND a.lcaj_idus=<<this.nidusua>> and lcaj_mone='<<this.cmoneda>>'
			union all
			SELECT a.lcaj_tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I','S') as tipo,a.lcaj_dcto as ndoc,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as impo,
            a.lcaj_deta as deta,a.lcaj_mone as mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,a.lcaj_dola as dola,a.lcaj_deud as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau=0 AND a.lcaj_idus=<<this.nidusua>> and lcaj_mone='<<this.cmoneda>>')
			as b order by tipo,ndoc,tdoc
		ENDTEXT
		this.ante=1
	Case this.ntienda=1 And this.conusuario=0
    	TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
		    select deta,ndoc,
			round(case forma when 'E' then if(tipo='I',impo,0) else 0 end,2) as efectivo,
			round(case forma when 'C' then if(tipo='I',impo,0) else 0 end,2) as credito,
			round(case forma when 'D' then if(tipo='I',impo,0) else 0 end,2) as deposito,
			round(case forma when 'H' then if(tipo='I',impo,0) else 0 end,2) as cheque,
			round(case forma when 'T' then if(tipo='I',impo,0) else 0 end,2) as tarjeta,
		    round(case forma when 'A' then if(tipo='I',impo,0) else 0 end,2) as antic,
			round(case tipo when 'S' then if(forma='E',impo,0) else 0 end,2) as egresos,
			usua,fechao,usuavtas,forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,refe
			from(
			SELECT a.lcaj_tdoc as tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I',if(lcaj_acre=0,'I','S')) as tipo,
			if(left(lcaj_dcto,1)='0',concat(if(lcaj_tdoc='01','F/.',if(lcaj_tdoc='03','B/.','P/.')),lcaj_dcto),lcaj_dcto) as ndoc,
			if(lcaj_deud<>0,lcaj_deud,if(lcaj_acre=0,lcaj_deud,lcaj_acre)) as impo,
            lcaj_deta as deta,lcaj_mone as  mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,lcaj_dola as dola,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau>0 AND a.lcaj_codt=<<this.ntienda>> and lcaj_mone='<<this.cmoneda>>'  
			union all
			SELECT a.lcaj_tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I','S') as tipo,a.lcaj_dcto as ndoc,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as impo,
            a.lcaj_deta as deta,a.lcaj_mone as mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,a.lcaj_dola as dola,a.lcaj_deud as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau=0 AND a.lcaj_codt=<<this.ntienda>> and lcaj_mone='<<this.cmoneda>>')
			as b order by tipo,ndoc,tdoc
		ENDTEXT
		this.ante=1
	Case this.ntienda=1 And this.conusuario=1
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
		    select deta,ndoc,
			round(case forma when 'E' then if(tipo='I',impo,0) else 0 end,2) as efectivo,
			round(case forma when 'C' then if(tipo='I',impo,0) else 0 end,2) as credito,
			round(case forma when 'D' then if(tipo='I',impo,0) else 0 end,2) as deposito,
			round(case forma when 'H' then if(tipo='I',impo,0) else 0 end,2) as cheque,
			round(case forma when 'T' then if(tipo='I',impo,0) else 0 end,2) as tarjeta,
			round(case forma when 'A' then if(tipo='I',impo,0) else 0 end,2) as antic,
			round(case tipo when 'S' then if(forma='E',impo,0) else 0 end,2) as egresos,
			usua,fechao,usuavtas,forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,refe
			from(
			SELECT a.lcaj_tdoc as tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I',if(lcaj_acre=0,'I','S')) as tipo,
		    if(left(lcaj_dcto,1)='0',concat(if(lcaj_tdoc='01','F/.',if(lcaj_tdoc='03','B/.','P/.')),lcaj_dcto),lcaj_dcto) as ndoc,
			if(lcaj_deud<>0,lcaj_deud,if(lcaj_acre=0,lcaj_deud,lcaj_acre)) as impo,
            lcaj_deta as deta,lcaj_mone as  mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,lcaj_dola as dola,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau>0 AND a.lcaj_idus=<<this.nidusua>> and lcaj_codt=<<this.ntienda>> and lcaj_mone='<<this.cmoneda>>'
			union all
			SELECT a.lcaj_tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I','S') as tipo,a.lcaj_dcto as ndoc,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as impo,
            a.lcaj_deta as deta,a.lcaj_mone as mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,a.lcaj_dola as dola,a.lcaj_deud as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau=0 AND a.lcaj_idus=<<this.nidusua>> and lcaj_codt=<<this.ntienda>> and lcaj_mone='<<this.cmoneda>>')
			as b order by tipo,ndoc,tdoc
		ENDTEXT
		this.ante=1
	Case .chktienda1.Value=0 And .chkusuario.Value=0
	
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
		    select deta,ndoc,
			round(case forma when 'E' then if(tipo='I',impo,0) else 0 end,2) as efectivo,
			round(case forma when 'C' then if(tipo='I',impo,0) else 0 end,2) as credito,
			round(case forma when 'D' then if(tipo='I',impo,0) else 0 end,2) as deposito,
			round(case forma when 'H' then if(tipo='I',impo,0) else 0 end,2) as cheque,
			round(case forma when 'T' then if(tipo='I',impo,0) else 0 end,2) as tarjeta,
			round(case forma when 'A' then if(tipo='I',impo,0) else 0 end,2) as antic,
			round(case tipo when 'S' then if(forma='E',impo,0) else 0 end,2) as egresos,
			usua,fechao,usuavtas,forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,refe
			from(
			SELECT a.lcaj_tdoc as tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I',if(lcaj_acre=0,'I','S')) as tipo,
    		if(left(lcaj_dcto,1)='0',concat(if(lcaj_tdoc='01','F/.',if(lcaj_tdoc='03','B/.','P/.')),lcaj_dcto),lcaj_dcto) as ndoc,
			if(lcaj_deud<>0,lcaj_deud,if(lcaj_acre=0,lcaj_deud,lcaj_acre)) as impo,
            lcaj_deta as deta,lcaj_mone as  mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,lcaj_dola as dola,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on 	c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau>0 and lcaj_mone='<<this.cmoneda>>'
			union all
			SELECT a.lcaj_tdoc,a.lcaj_form as forma,if(lcaj_deud<>0,'I','S') as tipo,a.lcaj_dcto as ndoc,if(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) as impo,
            a.lcaj_deta as deta,a.lcaj_mone as mone,lcaj_idcr as idcredito,lcaj_idde as iddeudas,lcaj_idau as idauto,
			c.nomb as usua,a.lcaj_fope as fechao,ifnull(z.nomv,'') as usuavtas,a.lcaj_mone as tmon1,a.lcaj_dola as dola,a.lcaj_deud as nimpo,lcaj_ndoc as refe FROM
			fe_lcaja as a
			inner join fe_usua as c on c.idusua=a.lcaj_idus
			left join rvendedores as p on p.idauto=a.lcaj_idau
			left join fe_vend as z On z.idven=p.codv
			WHERE lcaj_fech='<<f>>' and lcaj_acti<>'I' and lcaj_idau=0 and lcaj_mone='<<this.cmoneda>>')
			as b order by tipo,ndoc,tdoc
		ENDTEXT
		this.ante=0
	Endcase
	If this.Ejecutaconsulta(lc,"icaja")<1 then
		RETURN 0
	ENDIF
	RETURN 1
	ENDFUNC 
Enddefine
