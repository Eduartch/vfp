Define Class caja As Odata Of "d:\capass\database\data.prg"
	dFecha = Date()
	dfi = Date()
	dff = Date()
	nidusua = 0
	cmoneda = ""
	ntienda = 0
	conusuario = 0
	idusuario = 0
	ante = 0
	Function Registrarcaja(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15)
	Local lC, lp
*:Global cur
	m.lC		  = "ProIngresaDatosLcajaEefectivo11"
	cur			  = ""
	goApp.npara1  = m.np1
	goApp.npara2  = m.np2
	goApp.npara3  = m.np3
	goApp.npara4  = m.np4
	goApp.npara5  = m.np5
	goApp.npara6  = m.np6
	goApp.npara7  = m.np7
	goApp.npara8  = m.np8
	goApp.npara9  = m.np9
	goApp.npara10 = m.np10
	goApp.npara11 = m.np11
	goApp.npara12 = m.np12
	goApp.npara13 = m.np13
	goApp.npara14 = m.np14
	goApp.npara15 = m.np15
	Text To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function buscasiestaregistradodcto(np1, np2)
	Local lC
	Text To m.lC Noshow Textmerge
	Select  lcaj_idca  As idcaja  From fe_lcaja Where lcaj_dcto='<<np1>>' And lcaj_acti = 'A'  And lcaj_tdoc = '<<np2>>'
	Endtext
	If This.EjecutaConsulta(m.lC, 'yaestaencaja') < 1 Then
		Return 0
	Endif
	If yaestaencaja.idcaja > 0 Then
		This.Cmensaje = 'Ya esta Registrado el Número del Documento'
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarCajaChicaNotaria(np1, Ccursor)
	Local lC
	Text To m.lC Noshow Textmerge
	   Select  lcaj_dcto As dcto, lcaj_deud As importe,lcaj_deta as detalle, lcaj_fope As fechahora
	   From fe_lcaja
	   Where lcaj_fech='<<np1>>'   And lcaj_acti = 'A'  lcaj_idus = 0   And lcaj_tdoc = 'Ti'  Order By lcaj_dcto
	Endtext
	If This.EjecutaConsulta(m.lC, m.Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaropencaja(np1)
	Ccursor = 'C' + Sys(2015)
	Text To lC Noshow Textmerge
	      SELECT lcaj_ndoc  as operacion FROM fe_lcaja WHERE TRIM(lcaj_ndoc)='<<np1>>' AND lcaj_acti='A'  AND lcaj_deud>0 limit 1
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If !Empty(operacion) Then
		This.Cmensaje = 'Número de Depósito Ya Registrado'
		Return 0
	Endif
	Return 1
	Endfunc
	Function salanteriorm(ff1, ff2, cmoneda)
	f1 = cfechas(ff1)
	f2 = cfechas(ff2)
	Ccursor = 'c_' + Sys(2015)
	Text To lC Noshow Textmerge Pretext 7
	    select SUM(if(a.lcaj_deud<>0,lcaj_deud,0)) as ingresoss,SUM(if(a.lcaj_acre<>0,lcaj_acre,0)) as egresoss
	    FROM fe_lcaja  as a WHERE  a.lcaj_fech between '<<f1>>' and '<<f2>>'  and a.lcaj_acti='A' and a.lcaj_form='E' 
	    and lcaj_idus=<<this.nidusua>>  and lcaj_mone='<<this.cmoneda>>' group by lcaj_idus
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1
		Return 0
	Endif
	Select (Ccursor)
	Return ingresoss - egresoss
	Endfunc
	Function listarcajam(Ccursor)
	F = cfechas(This.dFecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	        \Select Deta,ndoc,
			\Round(Case Forma When 'E' Then If(tipo='I',Impo,0) Else 0 End,2) As efectivo,
			\Round(Case Forma When 'C' Then If(tipo='I',Impo,0) Else 0 End,2) As credito,
			\Round(Case Forma When 'D' Then If(tipo='I',Impo,0) Else 0 End,2) As deposito,
			\Round(Case Forma When 'H' Then If(tipo='I',Impo,0) Else 0 End,2) As cheque,
			\Round(Case Forma When 'T' Then If(tipo='I',Impo,0) Else 0 End,2) As tarjeta,
			\Round(Case Forma When 'A' Then If(tipo='I',Impo,0) Else 0 End,2) As antic,
			\Round(Case tipo When 'S' Then If(Forma='E',Impo,0) Else 0 End,2) As egresos,
			\usua,fechao,usuavtas,Forma,mone,tmon1,dola,nimpo,tipo,tdoc,idcredito,iddeudas,idauto,Refe
			\From(
			\Select a.lcaj_tdoc As tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I',If(lcaj_acre=0,'I','S')) As tipo,
			\If(Left(lcaj_dcto,1)='0',Concat(If(lcaj_tdoc='01','F/.',If(lcaj_tdoc='03','B/.','P/.')),lcaj_dcto),lcaj_dcto) As ndoc,
			\If(lcaj_deud<>0,lcaj_deud,If(lcaj_acre=0,lcaj_deud,lcaj_acre)) As Impo,
            \lcaj_deta As Deta,lcaj_mone As  mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
			\c.nomb As usua,a.lcaj_fope As fechao,ifnull(z.nomv,'') As usuavtas,a.lcaj_mone As tmon1,lcaj_dola As dola,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As nimpo,lcaj_ndoc As Refe From
			\fe_lcaja As a
			\inner Join fe_usua As c On c.idusua=a.lcaj_idus
			\Left Join rvendedores As p On p.idauto=a.lcaj_idau
			\Left Join fe_vend As z On z.idven=p.codv
			\Where lcaj_fech='<<f>>' And lcaj_acti<>'I' And lcaj_idau>0  And lcaj_mone='<<this.cmoneda>>'
	If This.conusuario > 0 Then
	    \And a.lcaj_idus=<<This.nidusua>>

	Endif
	If This.ntienda > 0 Then
		\And a.lcaj_codt =<< This.ntienda >>
	Endif
			\Union All
			\Select a.lcaj_tdoc,a.lcaj_form As Forma,If(lcaj_deud<>0,'I','S') As tipo,a.lcaj_dcto As ndoc,If(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) As Impo,
            \a.lcaj_deta As Deta,a.lcaj_mone As mone,lcaj_idcr As idcredito,lcaj_idde As iddeudas,lcaj_idau As idauto,
			\c.nomb As usua,a.lcaj_fope As fechao,ifnull(z.nomv,'') As usuavtas,a.lcaj_mone As tmon1,a.lcaj_dola As dola,a.lcaj_deud As nimpo,lcaj_ndoc As Refe From
			\fe_lcaja As a
			\inner Join fe_usua As c On c.idusua=a.lcaj_idus
			\Left Join rvendedores As p On p.idauto=a.lcaj_idau
			\Left Join fe_vend As z On z.idven=p.codv
			\Where lcaj_fech='<<f>>' And lcaj_acti<>'I' And lcaj_idau=0  And lcaj_mone='<<this.cmoneda>>'
	If This.conusuario > 0 Then
		\And a.lcaj_idus=<<This.nidusua>>
	Endif
	If This.ntienda > 0 Then
		\And a.lcaj_codt =<< This.ntienda>>
	Endif
		\)As b Order By tipo,ndoc,tdoc
	Set Textmerge Off
	Set Textmerge To
	If This.ntienda = 0 And  This.conusuario = 0
		This.ante = 	0
	Else
		This.ante = 1
	Endif
	If This.EjecutaConsulta(lC, "icaja") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcaja1(Ccursor)
	F = cfechas(This.dFecha)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  Deta, ndoc,
	\Round(Case Forma When 'E' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As efectivo,
	\Round(Case Forma When 'C' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As credito,
	\Round(Case Forma When 'D' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As deposito,
	\Round(Case Forma When 'H' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As cheque,
	\Round(Case Forma When 'T' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As tarjeta,
	\Round(Case Forma When 'Y' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As Yape,
	\Round(Case Forma When 'P' Then If(tipo = 'I', Impo, 0) Else 0 End, 2) As plin,
	\Round(Case tipo When 'S' Then If(Forma = 'E', Impo, 0) Else 0 End, 2) As egresos,
	\usua, fechao, usuavtas, Forma, mone, tmon1, dola, nimpo, tipo, tdoc, idcredito, iddeudas, idauto, Impo As timpo
	\From(
	\Select a.lcaj_tdoc As tdoc, a.lcaj_form As Forma, If(lcaj_deud <> 0, 'I', If(lcaj_acre = 0, 'I', 'S')) As tipo,
	\If(Left(lcaj_dcto, 1) = '0', Concat(If(lcaj_tdoc = '01', 'F/.', If(lcaj_tdoc = '03', 'B/.', 'P/.')), lcaj_dcto), lcaj_dcto) As ndoc,
	\	If(lcaj_deud <> 0, lcaj_deud, If(lcaj_acre = 0, lcaj_deud, lcaj_acre)) As Impo,
	\		lcaj_deta As Deta, lcaj_mone As  mone, lcaj_idcr As idcredito, lcaj_idde As iddeudas, lcaj_idau As idauto,
	\		c.nomb As usua, a.lcaj_fope As fechao, ifnull(z.nomv, '') As usuavtas, a.lcaj_mone As tmon1, lcaj_dola As dola, If(a.lcaj_deud <> 0, lcaj_deud, lcaj_acre) As nimpo From
	\		fe_lcaja As a
	\		inner Join fe_usua As c On c.idusua = a.lcaj_idus
	\		Left Join rvendedores As p On p.idauto = a.lcaj_idau
	\		Left Join fe_vend As z On z.idven = p.codv
	\		Where lcaj_fech = '<<f>>' And lcaj_acti <> 'I' And lcaj_idau > 0
	If This.conusuario > 0 Then
	\ And a.lcaj_idus=<<This.nidusua>>
	Endif
	If This.ntienda > 0 Then
		\And a.lcaj_codt =<< This.ntienda>>
	Endif
	\		Union All
	\		Select a.lcaj_tdoc, a.lcaj_form As Forma, If(lcaj_deud <> 0, 'I', 'S') As tipo, a.lcaj_dcto As ndoc, If(a.lcaj_deud <> 0, lcaj_deud, lcaj_acre) As Impo,
	\		a.lcaj_deta As Deta, a.lcaj_mone As mone, lcaj_idcr As idcredito, lcaj_idde As iddeudas, lcaj_idau As idauto,
	\		c.nomb As usua, a.lcaj_fope As fechao, ifnull(z.nomv, '') As usuavtas, a.lcaj_mone As tmon1, a.lcaj_dola As dola, a.lcaj_deud As nimpo From
	\		fe_lcaja As a
	\		inner Join fe_usua As c On 	c.idusua = a.lcaj_idus
	\		Left Join rvendedores As p On p.idauto = a.lcaj_idau
	\		Left Join fe_vend As z On z.idven = p.codv
	\		Where lcaj_fech = '<<f>>' And lcaj_acti <> 'I' And lcaj_idau = 0
	If This.conusuario > 0 Then
	\ And a.lcaj_idus=<<This.nidusua>>
	Endif
	If This.ntienda > 0 Then
		\And a.lcaj_codt =<< This.ntienda >>
	Endif
	\)
	\As b Order By tipo, ndoc, tdoc
	Set Textmerge Off
	Set Textmerge To
	If This.ntienda = 0 And  This.conusuario = 0
		This.ante = 	0
	Else
		This.ante = 1
	Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarportipomvto(ctipo, Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select b.lcaj_fech,b.lcaj_dcto,b.lcaj_deta,
	If ctipo = 'I' Then
	   \b.lcaj_deud As Impo
	Else
		\b.lcaj_acre As Impo
	Endif
	\,c.nomb As Usuario,b.lcaj_fope As fechao From fe_lcaja As b
    \inner Join fe_usua As c On c.idusua=b.lcaj_idus
    \Where b.lcaj_acti<>'I'  And b.lcaj_fech Between '<<f1>>' And '<<f2>>'
	If ctipo = 'I' Then
    \And b.lcaj_deud>0
	Else
     \And b.lcaj_acre>0
	Endif
	If This.ntienda > 0 Then
	  \And b.lcaj_codt=<<This.ntienda>>
	Endif
	If This.idusuario > 0 Then
	  \And b.lcaj_idus=<<This.idusuario>>
	Endif
	\Order By lcaj_dcto
	Set Textmerge Off
	Set Textmerge To
    If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine









