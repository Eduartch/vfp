Define Class ctasporpagar As Odata Of 'd:\capass\database\data.prg'
	estado = ""
	cdcto = ""
	ctipo = ""
	cdeta = ""
	dFech = Date()
	dfevto = Date()
	nreg = 0
	Idcaja = 0
	nimpo = 0
	nacta = 0
	cnrou = ""
	codt = 0
	nidprov = 0
	NAuto = 0
	ccta = 0
	Cmoneda = ""
	ndolar = 0
	Calias = ""
	cmodo = ""
	Function registra
	Lparameters Calias, NAuto, ncodigo, Cmoneda, dFecha, nTotal, ccta, ndolar
	Local Sw, r As Integer
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Used((Calias))
		This.Cmensaje = 'no usado'
		Return 0
	Endif
	r = IngresaCabeceraDeudasCctas(NAuto, ncodigo, Cmoneda, dFecha, nTotal, goApp.nidusua, goApp.Tienda, Id(), ccta)
	If r < 1 Then
		Return 0
	Endif
	Sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.Ndoc, 'C', dFecha, tmpd.fevto, tmpd.Tipo, ndolar, tmpd.Impo, ;
				  goApp.nidusua, Id(), goApp.Tienda, tmpd.Ndoc, tmpd.Detalle, 'CA') = 0 Then
			Sw = 0
			This.Cmensaje = 'Al Registrar Detalle'
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registramasmas
	Local Sw, r As Integer
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Used((This.Calias))
		This.Cmensaje = 'Temporal de Registro NO usado'
		Return 0
	Endif
	r = IngresaCabeceraDeudasCctas(This.NAuto, This.nidprov, This.Cmoneda, This.dFech, This.nimpo, goApp.nidusua, This.codt, Id(), This.ccta)
	If r < 1 Then
		Return 0
	Endif
	Sw = 1
	Select (This.Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.Ndoc, 'C', This.dFech, tmpd.fevto, tmpd.Tipo, This.ndolar, tmpd.Impo, ;
				  goApp.nidusua, Id(), This.codt, tmpd.Ndoc, tmpd.Detalle, 'CA') = 0 Then
			Sw = 0
			This.Cmensaje = 'Al Registrar Detalle de Cuentas por Pagar'
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
****************************
	Function Registra1
	Lparameters Calias, NAuto, ncodigo, Cmoneda, dFecha, nTotal, ccta, ndolar
	Local Sw, r As Integer
	If !Used((Calias))
		Return 0
	Endif
	r = IngresaCabeceraDeudas(NAuto, ncodigo, Cmoneda, dFecha, nTotal, goApp.nidusua, goApp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	Sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.Ndoc, 'C', dFecha, tmpd.fevto, tmpd.Tipo, ndolar, tmpd.Impo, ;
				  goApp.nidusua, Id(), goApp.Tienda, tmpd.Ndoc, tmpd.Detalle, 'CA') = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 1
		Return 1
	Else
		Return 0
	Endif
	Endfunc
********************************
	Function RegistraTraspaso
	Lparameters Calias, NAuto, ncodigo, Cmoneda, dFecha, nTotal, ccta, ndolar, cndoc, cdetalle
	Local Sw, r As Integer
	r = IngresaCabeceraDeudas(NAuto, ncodigo, Cmoneda, dFecha, nTotal, goApp.nidusua, goApp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	If IngresaDetalleDeudas(r, cndoc, 'C', dFecha, dFecha, 'F', ndolar, nTotal, ;
			  goApp.nidusua, Id(), goApp.Tienda, cndoc, cdetalle, 'CA') = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
***************************
	Function Obtenersaldosporproveedor(nid, Ccursor)
	Local lC
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow Textmerge
	    \  Select a.idpr As idprov,a.Ndoc,a.saldo As importe,a.moneda As mone,a.banc,a.fech,a.fevto,a.Tipo,
	    \   a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol From vpdtespago As a  Where idpr=<<nid>>
	If goApp.Cdatos = 'S' Then
	    \And codt=<<goApp.Tienda>>
	Endif
	    \Order By a.fevto,a.Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1  Then
		Return 0
	ENDIF 
	Return 1
	Endfunc
********************
	Function ObtenerVtos
	Lparameters dfi, dff, Calias
	Local lC
	Text To lC Noshow Textmerge Pretext 7
	    SELECT w.fech,fevto,nrou,
		CASE r.rdeu_mone WHEN 'S' THEN importe ELSE 0 END AS soles,
		CASE r.rdeu_mone WHEN 'D' THEN importe ELSE 0 END AS dolares,cta.ncta as ncta,
		ncontrol,deud_idrd,banc,tipo,p.razo,r.rdeu_mone  as mone,ndoc FROM
		(SELECT a.fech,a.nrou,a.fevto,b.importe,a.ncontrol,deud_idrd,a.banc,a.tipo,a.ndoc FROM
		(SELECT ROUND(SUM(a.impo-a.acta),2) AS importe,a.ncontrol FROM fe_rdeu AS x
		 INNER JOIN fe_deu AS a  ON a.deud_idrd=x.rdeu_idrd
	     WHERE a.acti<>'I' AND rdeu_acti<>'I' GROUP BY ncontrol HAVING importe<>0) AS b
	     INNER JOIN (SELECT fech,nrou,fevto,ncontrol,deud_idrd,banc,tipo,ndoc FROM fe_deu WHERE acti='A' AND estd='C') AS a
	     ON a.ncontrol=b.ncontrol) AS w INNER JOIN fe_rdeu AS r ON r.`rdeu_idrd`=w.deud_idrd INNER JOIN fe_prov
	    as p ON p.idprov=r.rdeu_idpr left join fe_plan as cta on cta.idcta=r.rdeu_idct
	Endtext
	If  This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadodecuenta(opt, nidclie, cmx, Calias)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	    \ Select b.rdeu_idpr,a.fech As fepd,a.fevto As fevd,a.Ndoc,b.rdeu_impc As impc,a.Impo As impd,a.acta As actd,a.dola,
	    \ a.Tipo,a.banc,ifnull(c.Ndoc,'0000000000') As docd,b.rdeu_mone As mond,a.estd,a.iddeu As nr,
	    \ b.rdeu_idau As idauto,ifnull(c.tdoc,'00') As Refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') As bancos,
        \ ifnull(w.cban_ndoc,'') As nban,ifnull(T.nomb,'') As Tienda From fe_deu As a
	    \ INNER Join fe_rdeu As b On(b.rdeu_idrd=a.deud_idrd)
	    \ Left Join fe_rcom As c On(c.idauto=b.rdeu_idau)
        \ Left Join (Select cban_nume,cban_ndoc,g.ctas_ctas,cban_idco From fe_cbancos F
        \ INNER Join fe_ctasb g On g.ctas_idct=F.cban_idba Where cban_acti='A') As w On w.cban_idco=a.deud_idcb
        \ Left Join fe_sucu As T On T.idalma=b.rdeu_codt
	    \ Where b.rdeu_idpr=<<nidclie>>  And b.rdeu_mone='<<cmx>>'  And a.Acti<>'I' And b.rdeu_acti<>'I'
	If opt > 0 Then
	    \ And b.rdeu_codt=<<opt>>
	Endif
	    \ Order By a.ncontrol,a.fech,c.Ndoc
	Set Textmerge Off
	Set Textmerge To
	If  This.EjecutaConsulta(lC, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenersaldosTproveedores(Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\     Select a.Ndoc,a.fech,a.fevto,a.saldo,a.Importec,x.razo,
	\     situa,idauto,ncontrol,a.Tipo,banco,docd,tdoc,a.idpr,a.moneda,codt,dola,
	\     idrd,a.rdeu_idct,ifnull(u.nomb,'') As usuario From vpdtespago As a
	\     INNER Join fe_prov As x On x.idprov=a.idpr
	\     INNER Join fe_rdeu As r On r.rdeu_idrd=a.idrd
	\     Left Join fe_usua As u On u.idusua=r.rdeu_idus
	\ Order By fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenersaldosTproveedoresx(Df, Ccursor)
	F = cfechas(Df)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		\Select p.rdeu_idpr As codp,b.razo As proveedor,b.nruc,p.rdeu_idct As idcta,p.rdeu_mone As mone,tsoles,tdolar,
        \ifnull(q.ncta,'') As ncta,ifnull(T.Ndoc,'') As Ndoc,ifnull(T.fech,p.rdeu_fech) As fech
        \From
        \(Select a.ncontrol,If(p.rdeu_mone='S',Sum(a.Impo-a.acta),0) As tsoles,
		\If(p.rdeu_mone='D',Sum(a.Impo-a.acta),0) As tdolar,rdeu_idpr
		\From fe_deu As a INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
		\Where a.Acti<>'I' And p.rdeu_acti='A' And a.fech<='<<f>>'
	If  This.codt > 0 Then
			\ And p.rdeu_codt=<<ltdas.idalma>>
	Endif
	If This.cmodo = 'C' Then
	\  And rdeu_idct>0
	Endif
		\Group By rdeu_idpr,a.ncontrol,rdeu_mone Having tsoles<>0 Or tdolar<>0) As xx
		\INNER Join fe_prov As b On b.idprov=xx.rdeu_idpr
		\INNER Join fe_deu As d On d.iddeu=xx.ncontrol
		\INNER Join fe_rdeu As p On p.rdeu_idrd=d.deud_idrd
		\Left Join fe_rcom As T On T.idauto=p.rdeu_idau Left Join fe_plan As q On q.idcta=p.rdeu_idct
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
******************************
	Function ACtualizaDeudas(NAuto, nu)
	lC = "ProActualizaDeudas"
	Text To lC Noshow
     <<nauto>>,<<nu>>
	Endtext
	If  This.ejecutarp(lC, lp, '') < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraSaldosDctos(Ccursor)
	F = cfechas(This.dFecha)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
			\Select  a.Ndoc,  a.fech  ,  a.dola ,  a.nrou ,  a.banc ,
			\a.iddeu ,  a.fevto , s.saldo ,  s.rdeu_idpr As idpr, b.rdeu_impc As Importec, 'C'  As situa,
			\b.rdeu_idau As idauto, s.ncontrol, a.Tipo ,  a.banco,  ifnull(c.Ndoc,'0') As docd,
			\ifnull(c.tdoc,'0') As tdoc,  b.rdeu_mone As moneda,  b.rdeu_codt As codt,  b.rdeu_idrd As idrd,  b.rdeu_idct As rdeu_idct
			\From  (Select a.ncontrol,Sum(a.Impo-a.acta) As saldo,rdeu_idpr
			\From fe_deu As a INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
			\Where a.Acti<>'I' And p.rdeu_acti='A' And a.fech<='<<f>>'
	If This.codt > 0 Then
			\ And  rdeu_codt=<<This.codt>>
	Endif
	If This.nidprov = 0 Then
			\ And  rdeu_idpr=<<This.nidprov>>
	Endif
			\Group By rdeu_idpr,a.ncontrol,rdeu_mone Having saldo<>0) s
			\Join fe_prov z    On z.idprov = s.rdeu_idpr
			\Join fe_deu a      On a.iddeu = s.ncontrol
			\Join fe_rdeu b      On b.rdeu_idrd = a.deud_idrd
			\Left Join fe_rcom c  On c.idauto = b.rdeu_idau
			\Order By a.fevto
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function editaregistro()
	If This.estado = "C"
		nimpo = This.nimpo
	Else
		nacta = This.nimpo
	Endif
	Df = cfechas(This.dFech)
	dfv = cfechas(This.dfevto)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Text To lC Noshow Textmerge Pretext 1 + 2 + 4
    UPDATE fe_deu SET ndoc='<<this.cdcto>>',tipo='<<this.ctipo>>',banc='<<this.cdeta>>',fech='<<df>>',fevto='<<dfv>>'  WHERE iddeu=<<this.nreg>>
	Endtext
	If This.Ejecutarsql(lC) < 1
		This.DEshacerCambios()
		Return 0
	Endif
	Text To lC Noshow Textmerge
     UPDATE fe_lcaja SET lcaj_fech='<<df>>' WHERE lcaj_idde=<<this.nreg>>
	Endtext
	If Ejecutarsql(lC) < 1
		This.deshacerCambos()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function quitarRegistro()
	If This.estado = 'C' Then
		If This.DesactivaDeudas(This.rdeud) < 1 Then
			Return 0
		Endif
	Else
		Set Procedure To d:\capass\modelos\cajae Additive
		ocaja = Createobject("cajae")
		If This.IniciaTransaccion() < 1 Then
			Return 0
		Endif
		If This.DesactivaDDeudas(This.nreg) < 1 Then
			This.DEshacerCambios()
			Return 0
		Else
			If This.Idcaja > 0 Then
				If  ocaja.DesactivaCajaEfectivoDe(This.nreg) < 1 Then
					This.Cmensaje = ocaja.Cmensaje
					This.DEshacerCambios()
					Return 0
				Endif
			Endif
		Endif
		If This.GRabarCambios() < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function DesactivaDDeudas(np1)
	Local cur As String
	lC = 'PRODESACTIVADEUDAS'
	goApp.npara1 = np1
	Text To lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.ejecutarp(lC, lp, "") < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
*********************************
	Function DesactivaDeudas(np1)
	lC = 'PRODESACTIVACDEUDAS'
	goApp.npara1 = np1
	Text To lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.ejecutarp(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function editaregistro1()
	Df = cfechas(This.dFech)
	dfv = cfechas(This.dfevto)
	Text To lC Noshow Textmerge Pretext 7
         UPDATE fe_deu SET nrou='<<this.cnrou>>',banc='<<this.cdeta>>',fevto='<<dfv>>',fech='<<df>>' WHERE iddeu=<<this.nreg>>
	Endtext
	If This.Ejecutarsql(lC) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listardetalle(Ccursor)
	Df = cfechas(This.dFech)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\   Select razo,ndoc,fech,tsoles,tdolar,mone,idprov From (
	\	Select p.rdeu_idpr As idprov,b.razo,p.rdeu_mone As mone,ifnull(T.Ndoc,'') As Ndoc,ifnull(T.fech,p.rdeu_fech) As fech,
	\	If(p.rdeu_mone='S',Sum(a.Impo-a.acta),0) As tsoles,
	\	If(p.rdeu_mone='D',Sum(a.Impo-a.acta),0) As tdolar
	\	From fe_deu As a
	\	INNER Join fe_rdeu As p On p.rdeu_idrd=a.deud_idrd
	\	INNER Join  fe_prov As b On b.idprov=p.rdeu_idpr
	\	Left Join fe_rcom As T On T.idauto=p.rdeu_idau
	\	Where a.Acti<>'I' And p.rdeu_acti='A'  And a.fech<='<<df>>'
	If This.cmodo = 'C' Then
	\  And p.rdeu_idct>0
	Endif
	\Group By p.rdeu_idrd,rdeu_mone)
	\	As T Where T.tsoles<>0 Or T.tdolar<>0 Order By razo
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

























