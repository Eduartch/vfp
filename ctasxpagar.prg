Define Class ctasporpagar As odata Of 'd:\capass\database\data.prg'
	codt=0
	Function registra
	Lparameters Calias, nauto, ncodigo, cmoneda, dfecha, ntotal, ccta, ndolar
	Local sw, r As Integer
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If !Used((Calias))
		This.cmensaje='no usado'
		Return 0
	Endif
	r = IngresaCabeceraDeudasCctas(nauto, ncodigo, cmoneda, dfecha, ntotal, goapp.nidusua, goapp.Tienda, Id(), ccta)
	If r = 0 Then
		This.cmensaje='Al grabar Cabecera'
		Return 0
	Endif
	sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.ndoc, 'C', dfecha, tmpd.fevto, tmpd.tipo, ndolar, tmpd.Impo, ;
				goapp.nidusua, Id(), goapp.Tienda, tmpd.ndoc, tmpd.detalle, 'CA') = 0 Then
			sw = 0
			This.cmensaje='Al Registrar Detalle'
			Exit
		Endif
	Endscan
	If sw = 1
		Return 1
	Else
		Return 0
	Endif
	Endfunc
****************************
	Function Registra1
	Lparameters Calias, nauto, ncodigo, cmoneda, dfecha, ntotal, ccta, ndolar
	Local sw, r As Integer
	If !Used((Calias))
		Return 0
	Endif
	r = IngresaCabeceraDeudas(nauto, ncodigo, cmoneda, dfecha, ntotal, goapp.nidusua, goapp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	sw = 1
	Select (Calias)
	Go Top
	Scan All
		If IngresaDetalleDeudas(r, tmpd.ndoc, 'C', dfecha, tmpd.fevto, tmpd.tipo, ndolar, tmpd.Impo, ;
				goapp.nidusua, Id(), goapp.Tienda, tmpd.ndoc, tmpd.detalle, 'CA') = 0 Then
			sw = 0
			Exit
		Endif
	Endscan
	If sw = 1
		Return 1
	Else
		Return 0
	Endif
	Endfunc
********************************
	Function RegistraTraspaso
	Lparameters Calias, nauto, ncodigo, cmoneda, dfecha, ntotal, ccta, ndolar, cndoc, cdetalle
	Local sw, r As Integer
	r = IngresaCabeceraDeudas(nauto, ncodigo, cmoneda, dfecha, ntotal, goapp.nidusua, goapp.Tienda, Id())
	If r = 0 Then
		Return 0
	Endif
	If IngresaDetalleDeudas(r, cndoc, 'C', dfecha, dfecha, 'F', ndolar, ntotal, ;
			goapp.nidusua, Id(), goapp.Tienda, cndoc, cdetalle, 'CA') = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
***************************
	Function Obtenersaldosporproveedor(nid, ccursor)
	Local lc
	cpropiedad = "cdatos"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("cdatos", "")
	Endif
	If goapp.cdatos='S' Then
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
	Function estadodecuenta(opt,nidclie,cmx)
	If opt=0 Then
		TEXT TO lc NOSHOW TEXTMERGE
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') as bancos,
         ifnull(w.cban_ndoc,'') as nban FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
         left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM fe_cbancos f  inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A') as w on w.cban_idco=a.deud_idcb
	     WHERE b.rdeu_idpr=<<nidclie>>  AND b.rdeu_mone='<<cmx>>'  and a.acti<>'I' and b.rdeu_acti<>'I' ORDER BY a.ncontrol,a.fech
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
	     SELECT b.rdeu_idpr,a.fech as fepd,a.fevto as fevd,a.ndoc,b.rdeu_impc as impc,a.impo as impd,a.acta as actd,a.dola,
	     a.tipo,a.banc,ifnull(c.ndoc,'0000000000') as docd,b.rdeu_mone as mond,a.estd,a.iddeu as nr,
	     b.rdeu_idau as idauto,ifnull(c.tdoc,'00') as refe,b.rdeu_idrd,deud_idcb,ifnull(w.ctas_ctas,'') as bancos,
         ifnull(w.cban_ndoc,'') as nban FROM fe_deu as a
	     inner join fe_rdeu as b ON(b.rdeu_idrd=a.deud_idrd)
	     left join fe_rcom as c ON(c.idauto=b.rdeu_idau)
         left join (SELECT cban_nume,cban_ndoc,g.ctas_ctas,cban_idco FROM  fe_cbancos f  inner join fe_ctasb g on g.ctas_idct=f.cban_idba where cban_acti='A') as w on w.cban_idco=a.deud_idcb
	     WHERE b.rdeu_idpr=<<nidclie>>   and a.acti<>'I' and b.rdeu_acti<>'I' and b.rdeu_codt=<<opt>>  ORDER BY b.rdeu_mone,a.ncontrol,a.fech
		ENDTEXT
	Endif
	If  This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenersaldosTproveedores(ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	     SELECT a.ndoc,a.fech,a.fevto,a.saldo,a.Importec,x.razo,
	     situa,idauto,ncontrol,a.tipo,banco,docd,tdoc,a.idpr,a.moneda,codt,dola,
	     idrd,a.rdeu_idct,IFNULL(u.nomb,'') AS usuario FROM vpdtespago as a
	     inner join fe_prov as x on x.idprov=a.idpr
	     inner join fe_rdeu as r on r.rdeu_idrd=a.idrd
	     left join fe_usua as u on u.idusua=r.rdeu_idus ORDER BY fevto
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
******************************
	Function ACtualizaDeudas(nauto,nu)
	lc="ProActualizaDeudas"
	TEXT TO lc NOSHOW
     <<nauto>>,<<nu>>
	ENDTEXT
	If  This.ejecutarp(lc,lp,'') < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraSaldosDctos(ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	If This.codt=0 Then
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
	      select a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
	      a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a order by a.fevto,a.ndoc
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE PRETEXT 7
	      select a.idpr as idprov,a.ndoc,a.saldo as importe,a.moneda as mone,a.banc,a.fech,a.fevto,a.tipo,
	      a.dola,a.docd,a.nrou,a.banco,a.iddeu,a.idauto,a.ncontrol FROM vpdtespago as a where  codt=<<this.codt>> order by a.fevto,a.ndoc
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1  Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
