#Define MSGTITULO 'SISVEN'
Define Class ventasx3 As Ventas  Of 'd:\capass\modelos\ventas.prg'
	Function listardctonotascredtitod(nid,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,rOUND(k.cant*k.prec,2) as importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'K' as tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,
		kar_equi,prod_cod1,kar_cost,kar_lote,kar_fvto,codv  from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return  1
	ENDFUNC
	Function listardctonotascredtito(nid,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,rOUND(k.cant*k.prec,2) as importe,
	    k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref,
		kar_equi,prod_cod1,kar_cost,codv from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>  order by idkar
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine
