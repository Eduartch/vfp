*!*	SET PROCEDURE TO d:\capass\capadatos ADDITIVE 
Define Class ctasporpagar As Odata Of 'd:\capass\database\data.prg'
	codt = 0
	estado = ""
	cdcto = ""
	ctipo = ""
	cdeta = ""
	dFech = Date()
	dfevto = Date()
	nreg = 0
	idcaja = 0
	nimpo = 0
	nacta = 0
	cnrou = ""
	nidprov=0
	dfecha=DATE()
	Function registra
	Lparameters Calias, NAuto, ncodigo, cmoneda, dFecha, ntotal, ccta, ndolar
	Local Sw, r As Integer
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	If !Used((Calias))
		This.Cmensaje = 'no usado'
		Return 0
	Endif
	r = IngresaCabeceraDeudasCctas(NAuto, ncodigo, cmoneda, dFecha, ntotal, goApp.nidusua, goApp.Tienda, Id(), ccta)
	If r = 0 Then
		This.Cmensaje = 'Al grabar Cabecera'
		Return 0
	Endif
	Sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.ndoc, 'C', dFecha, tmpd.fevto, tmpd.tipo, ndolar, tmpd.Impo, ;
				goApp.nidusua, Id(), goApp.Tienda, tmpd.ndoc, tmpd.detalle, 'CA') = 0 Then
			Sw = 0
			This.Cmensaje = 'Al Registrar Detalle'
			Exit
		Endif
	Endscan
	If Sw = 1
		Return 1
	Else
		Return 0
	Endif
	Endfunc
****************************
	Function Registra1
	Lparameters Calias, NAuto, ncodigo, cmoneda, dFecha, ntotal, ccta, ndolar
	Local Sw, r As Integer
	If !Used((Calias))
		Return 0
	Endif
	r = IngresaCabeceraDeudas(NAuto, ncodigo, cmoneda, dFecha, ntotal, goApp.nidusua, goApp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	Sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.ndoc, 'C', dFecha, tmpd.fevto, tmpd.tipo, ndolar, tmpd.Impo, ;
				goApp.nidusua, Id(), goApp.Tienda, tmpd.ndoc, tmpd.detalle, 'CA') = 0 Then
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
	Lparameters Calias, NAuto, ncodigo, cmoneda, dFecha, ntotal, ccta, ndolar, cndoc, cdetalle
	Local Sw, r As Integer
	r = IngresaCabeceraDeudas(NAuto, ncodigo, cmoneda, dFecha, ntotal, goApp.nidusua, goApp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	If IngresaDetalleDeudas(r, cndoc, 'C', dFecha, dFecha, 'F', ndolar, ntotal, ;
			goApp.nidusua, Id(), goApp.Tienda, cndoc, cdetalle, 'CA') = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
***************************
	Function Obtenersaldosporproveedor(nid, ccursor)
	Local lc
	cpropiedad = "cdatos"
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If goApp.Cdatos = 'S' Then
		TEXT To lc Noshow Textmerge Pretext 7
	      SELECT a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
	       a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a  where idpr=<<nid>> and codt=<<goapp.tienda>> order by a.fevto,a.ndoc
		ENDTEXT
	Else
		TEXT To lc Noshow Textmerge Pretext 7
	      SELECT a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
	      a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a  where idpr=<<nid>> order by a.fevto,a.ndoc
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1  Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
********************
	Function ObtenerVtos
	Lparameters dfi, dff, Calias
	Local lc
	TEXT To lc Noshow Textmerge Pretext 7
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
	ENDTEXT
	If  This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function estadodecuenta(opt, nidclie, cmx, Calias)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	Endif
	If opt = 0 Then
		TEXT To lc Noshow Textmerge
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') as bancos,
         ifnull(w.cban_ndoc,'') as nban,ifnull(t.nomb,'') As tienda FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
         left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM fe_cbancos f
         inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A') as w on w.cban_idco=a.deud_idcb
         left join fe_sucu as t on t.idalma=b.rdeu_codt
	     WHERE b.rdeu_idpr=<<nidclie>>  AND b.rdeu_mone='<<cmx>>'  and a.acti<>'I' and b.rdeu_acti<>'I' ORDER BY a.ncontrol,a.fech,c.ndoc
		ENDTEXT

	Else
		TEXT To lc Noshow Textmerge
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') as bancos,
         ifnull(w.cban_ndoc,'') as nban,ifnull(t.nomb,'') As tienda FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
	     left join fe_sucu as t on t.idalma=b.rdeu_codt
         left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM  fe_cbancos f
         inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A') as w on w.cban_idco=a.deud_idcb
	     WHERE b.rdeu_idpr=<<nidclie>>   and a.acti<>'I' and b.rdeu_acti<>'I' and b.rdeu_codt=<<opt>>  ORDER BY b.rdeu_mone,a.ncontrol,a.fech,c.ndoc
		ENDTEXT
	Endif
	If  This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenersaldosTproveedores(ccursor)
	TEXT To lc Noshow Textmerge
	     SELECT a.ndoc,a.fech,a.fevto,a.saldo,a.Importec,x.razo,
	     situa,idauto,ncontrol,a.tipo,banco,docd,tdoc,a.idpr,a.moneda,codt,dola,
	     idrd,a.rdeu_idct,IFNULL(u.nomb,'') AS usuario FROM vpdtespago as a
	     inner join fe_prov as x on x.idprov=a.idpr
	     inner join fe_rdeu as r on r.rdeu_idrd=a.idrd
	     left join fe_usua as u on u.idusua=r.rdeu_idus ORDER BY fevto
	ENDTEXT
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	Function obtenersaldosTproveedoresx(df,ccursor)
	f=cfechas(df)
	
	If  this.codt=0 then
		TEXT TO lc NOSHOW TEXTMERGE 
		select p.rdeu_idpr AS codp,b.razo AS proveedor,b.nruc,p.rdeu_idct AS idcta,p.rdeu_mone AS mone,tsoles,tdolar,
        IFNULL(q.ncta,'') AS ncta,IFNULL(t.ndoc,'') AS ndoc,IFNULL(t.fech,p.rdeu_fech) AS fech
        FROM
        (SELECT a.ncontrol,IF(p.rdeu_mone='S',SUM(a.impo-a.acta),0) AS tsoles,
		IF(p.rdeu_mone='D',SUM(a.impo-a.acta),0) AS tdolar,rdeu_idpr
		FROM fe_deu AS a INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=a.deud_idrd
		WHERE a.acti<>'I' AND p.rdeu_acti='A' AND a.fech<='<<f>>'  GROUP BY rdeu_idpr,a.ncontrol,rdeu_mone HAVING tsoles<>0 OR tdolar<>0) AS xx
		INNER JOIN fe_prov AS b ON b.idprov=xx.rdeu_idpr
		INNER JOIN fe_deu AS d ON d.iddeu=xx.ncontrol 
		INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=d.deud_idrd
		LEFT JOIN fe_rcom AS t ON t.idauto=p.rdeu_idau LEFT JOIN fe_plan AS q ON q.idcta=p.rdeu_idct 
	  ENDTEXT
	Else
	    TEXT TO lc NOSHOW TEXTMERGE 
		select p.rdeu_idpr AS codp,b.razo AS proveedor,b.nruc,p.rdeu_idct AS idcta,p.rdeu_mone AS mone,tsoles,tdolar,
        IFNULL(q.ncta,'') AS ncta,IFNULL(t.ndoc,'') AS ndoc,IFNULL(t.fech,p.rdeu_fech) AS fech
        FROM
        (SELECT a.ncontrol,IF(p.rdeu_mone='S',SUM(a.impo-a.acta),0) AS tsoles,
		IF(p.rdeu_mone='D',SUM(a.impo-a.acta),0) AS tdolar,rdeu_idpr
		FROM fe_deu AS a INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=a.deud_idrd
		WHERE a.acti<>'I' AND p.rdeu_acti='A' AND a.fech<='<<f>>' and p.rdeu_codt=<<ltdas.idalma>> 
		GROUP BY rdeu_idpr,a.ncontrol,rdeu_mone HAVING tsoles<>0 OR tdolar<>0) AS xx
		INNER JOIN fe_prov AS b ON b.idprov=xx.rdeu_idpr
		INNER JOIN fe_deu AS d ON d.iddeu=xx.ncontrol 
		INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=d.deud_idrd
		LEFT JOIN fe_rcom AS t ON t.idauto=p.rdeu_idau LEFT JOIN fe_plan AS q ON q.idcta=p.rdeu_idct 
	  ENDTEXT
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
******************************
	Function ACtualizaDeudas(NAuto, nu)
	lc = "ProActualizaDeudas"
	TEXT To lc Noshow
     <<nauto>>,<<nu>>
	ENDTEXT
	If  This.ejecutarp(lc, lp, '') < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraSaldosDctos(ccursor)
	f=cfechas(this.dfecha)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	ENDIF
*!*		    select a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
*!*			      a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a order by a.fevto,a.ndoc
	If This.codt = 0 Then
		If This.nidprov=0 Then
			TEXT To lc Noshow Textmerge Pretext 7
			SELECT  a.ndoc,  a.fech  ,  a.dola ,  a.nrou ,  a.banc ,
			a.iddeu ,  a.fevto , s.saldo ,  s.rdeu_idpr AS Idpr, b.rdeu_impc AS ImporteC, 'C'  AS situa,
			b.rdeu_idau AS Idauto, s.ncontrol, a.tipo ,  a.banco,  IFNULL(c.ndoc,'0') AS docd,
			IFNULL(c.tdoc,'0') AS tdoc,  b.rdeu_mone AS Moneda,  b.rdeu_codt AS Codt,  b.rdeu_idrd AS Idrd,  b.rdeu_idct AS rdeu_idct
			FROM  (SELECT a.ncontrol,SUM(a.impo-a.acta) AS saldo,rdeu_idpr
			FROM fe_deu AS a INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=a.deud_idrd
			WHERE a.acti<>'I' AND p.rdeu_acti='A' AND a.fech<='<<f>>'  GROUP BY rdeu_idpr,a.ncontrol,rdeu_mone HAVING saldo<>0) s
			JOIN fe_prov z    ON z.idprov = s.rdeu_idpr
			JOIN fe_deu a      ON a.iddeu = s.ncontrol
			JOIN fe_rdeu b      ON b.rdeu_idrd = a.deud_idrd
			LEFT JOIN fe_rcom c  ON c.idauto = b.rdeu_idau
			ORDER BY a.fevto
		 	ENDTEXT
		Else
		    TEXT To lc Noshow Textmerge Pretext 7
		    SELECT  a.ndoc,  a.fech  ,  a.dola ,  a.nrou ,  a.banc ,
			a.iddeu ,  a.fevto , s.saldo ,  s.rdeu_idpr AS Idpr, b.rdeu_impc AS ImporteC, 'C'  AS situa,
			b.rdeu_idau AS Idauto, s.ncontrol, a.tipo ,  a.banco,  IFNULL(c.ndoc,'0') AS docd,
			IFNULL(c.tdoc,'0') AS tdoc,  b.rdeu_mone AS Moneda,  b.rdeu_codt AS Codt,  b.rdeu_idrd AS Idrd,  b.rdeu_idct AS rdeu_idct
			FROM  (SELECT a.ncontrol,SUM(a.impo-a.acta) AS saldo,rdeu_idpr
			FROM fe_deu AS a INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=a.deud_idrd
			WHERE a.acti<>'I' AND p.rdeu_acti='A' AND a.fech<='<<f>>' and  rdeu_idpr=<<this.nidprov>> GROUP BY rdeu_idpr,a.ncontrol,rdeu_mone HAVING saldo<>0) s
			JOIN fe_prov z    ON z.idprov = s.rdeu_idpr
			JOIN fe_deu a      ON a.iddeu = s.ncontrol
			JOIN fe_rdeu b      ON b.rdeu_idrd = a.deud_idrd
			LEFT JOIN fe_rcom c  ON c.idauto = b.rdeu_idau
			ORDER BY a.fevto
		 	ENDTEXT
		Endif
	Else
		If This.nidprov=0 Then
			TEXT To lc Noshow Textmerge Pretext 7
			SELECT  a.ndoc,  a.fech  ,  a.dola ,  a.nrou ,  a.banc ,
			a.iddeu ,  a.fevto , s.saldo ,  s.rdeu_idpr AS Idpr, b.rdeu_impc AS ImporteC, 'C'  AS situa,
			b.rdeu_idau AS Idauto, s.ncontrol, a.tipo ,  a.banco,  IFNULL(c.ndoc,'0') AS docd,
			IFNULL(c.tdoc,'0') AS tdoc,  b.rdeu_mone AS Moneda,  b.rdeu_codt AS Codt,  b.rdeu_idrd AS Idrd,  b.rdeu_idct AS rdeu_idct
			FROM  (SELECT a.ncontrol,SUM(a.impo-a.acta) AS saldo,rdeu_idpr
			FROM fe_deu AS a INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=a.deud_idrd
			WHERE a.acti<>'I' AND p.rdeu_acti='A' AND a.fech<='<<f>>' and  rdeu_codt=<<this.codt>>  GROUP BY rdeu_idpr,a.ncontrol,rdeu_mone HAVING saldo<>0) s
			JOIN fe_prov z    ON z.idprov = s.rdeu_idpr
			JOIN fe_deu a      ON a.iddeu = s.ncontrol
			JOIN fe_rdeu b      ON b.rdeu_idrd = a.deud_idrd
			LEFT JOIN fe_rcom c  ON c.idauto = b.rdeu_idau
			ORDER BY a.fevto
		 	ENDTEXT
		Else
			TEXT To lc Noshow Textmerge Pretext 7
			SELECT  a.ndoc,  a.fech  ,  a.dola ,  a.nrou ,  a.banc ,
			a.iddeu ,  a.fevto , s.saldo ,  s.rdeu_idpr AS Idpr, b.rdeu_impc AS ImporteC, 'C'  AS situa,
			b.rdeu_idau AS Idauto, s.ncontrol, a.tipo ,  a.banco,  IFNULL(c.ndoc,'0') AS docd,
			IFNULL(c.tdoc,'0') AS tdoc,  b.rdeu_mone AS Moneda,  b.rdeu_codt AS Codt,  b.rdeu_idrd AS Idrd,  b.rdeu_idct AS rdeu_idct
			FROM  (SELECT a.ncontrol,SUM(a.impo-a.acta) AS saldo,rdeu_idpr
			FROM fe_deu AS a INNER JOIN fe_rdeu AS p ON p.rdeu_idrd=a.deud_idrd
			WHERE a.acti<>'I' AND p.rdeu_acti='A' AND a.fech<='<<f>>' and  rdeu_codt=<<this.codt>> and rdeu_idpr=<<this.nidprov>> GROUP BY rdeu_idpr,a.ncontrol,rdeu_mone HAVING saldo<>0) s
			JOIN fe_prov z    ON z.idprov = s.rdeu_idpr
			JOIN fe_deu a      ON a.iddeu = s.ncontrol
			JOIN fe_rdeu b      ON b.rdeu_idrd = a.deud_idrd
			LEFT JOIN fe_rcom c  ON c.idauto = b.rdeu_idau
			ORDER BY a.fevto
		 	ENDTEXT
    	Endif
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1  Then
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
	df = cfechas(This.dFech)
	dfv = cfechas(This.dfevto)
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lc Noshow Textmerge Pretext 1 + 2 + 4
    UPDATE fe_deu SET ndoc='<<this.cdcto>>',tipo='<<this.ctipo>>',banc='<<this.cdeta>>',fech='<<df>>',fevto='<<dfv>>'  WHERE iddeu=<<this.nreg>>
	ENDTEXT
	If This.Ejecutarsql(lc) < 1
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lc Noshow Textmerge
     UPDATE fe_lcaja SET lcaj_fech='<<df>>' WHERE lcaj_idde=<<this.nreg>>
	ENDTEXT
	If Ejecutarsql(lc) < 1
		This.deshacerCambos()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
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
			If This.idcaja > 0 Then
				If  ocaja.DesactivaCajaEfectivoDe(This.nreg) < 1 Then
					This.Cmensaje = ocaja.Cmensaje
					This.DEshacerCambios()
					Return 0
				Endif
			Endif
		Endif
		If This.GrabarCambios() < 1 Then
			Return 0
		Endif
	Endif
	Return 1
	Endfunc
	Function DesactivaDDeudas(np1)
	Local cur As String
	lc = 'PRODESACTIVADEUDAS'
	goApp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lc, lp, "") < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
*********************************
	Function DesactivaDeudas(np1)
	lc = 'PRODESACTIVACDEUDAS'
	goApp.npara1 = np1
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.ejecutarp(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function editaregistro1()
	df = cfechas(This.dFech)
	dfv = cfechas(This.dfevto)
	TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
         UPDATE fe_deu SET nrou='<<this.cnrou>>',banc='<<this.cdeta>>',fevto='<<dfv>>',fech='<<df>>' WHERE iddeu=<<this.nreg>>
	ENDTEXT
	If This.Ejecutarsql(lc) < 1
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

















