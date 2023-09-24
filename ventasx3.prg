Define Class ventasx3 As Ventas  Of 'd:\capass\modelos\ventas.prg'
	Function listardctonotascredtitod(nid, Ccursor)
	Text To lc Noshow Textmerge
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,rOUND(k.cant*k.prec,2) as importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'K' as tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,
		kar_equi,prod_cod1,kar_cost,kar_lote,kar_fvto,codv  from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function listardctonotascredtito(nid, Ccursor)
	Text To lc Noshow Textmerge
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,rOUND(k.cant*k.prec,2) as importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,
		kar_equi,prod_cod1,kar_cost,codv from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function listardetallevtas(Ccursor)
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	Set Textmerge On
	Set Textmerge  To Memvar lc Noshow
	    \Select tdoc, ndoc, r.fech, Razo, Descri, kar_unid As unid, cant, k.Prec, mone, u.nomb As Usuario,
	    \If(a.tmon = 'S', a.Prec, a.Prec * v.dola) As costo,
		\Form, cant * k.Prec As Impo, If(mone = 'S', cant * k.Prec, cant * k.Prec * r.dolar) As impo1, p.nruc, ndni,Dire,ciud,g.nomv,k.idart  From fe_rcom r
		\inner Join fe_kar k On k.idauto = r.idauto
		\inner Join fe_clie p On p.idclie = r.Idcliente
		\inner Join fe_usua u On u.idusua = r.idusua
		\inner Join fe_art a On a.idart = k.idart
		\inner Join fe_vend As g On g.idven=r.rcom_vend, fe_gene As v
	    \Where  r.fech  Between '<<dfi>>' And '<<dff>>'
	If This.codt > 0 Then
		\ And r.codt=<<This.codt>>
	Endif
	Set Textmerge To
	Set Textmerge To Memvar lc Noshow  Additive
		\And k.Acti = 'A' And r.Acti = 'A' Order By r.fech,r.tdoc, r.ndoc
	Set Textmerge To
	Set Textmerge Off
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine





