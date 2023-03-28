Define Class comprobantex As odata Of 'd:\capass\database\data'
	Function consultardata(pkid,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
		  SELECT r.idauto,r.ndoc,r.tdoc,r.fech as dfecha,r.mone,valor,CAST(0 as decimal(12,2)) as inafectas,
	      CAST(0 as decimal(12,2)) as exoneradas,'10' as tigv,vigv,v.rucfirmad,v.razonfirmad,ndo2,v.nruc as rucempresa,v.empresa,v.ubigeo,
	      v.ptop,v.ciudad,v.distrito,c.nruc,'6' as tipodoc,c.razo,concat(TRIM(c.dire),' ',TRIM(c.ciud)) as direccion,c.ndni,r.rcom_otro,kar_cost as costoref,deta,
	      'PE' as pais,r.igv,CAST(0 as decimal(12,2)) as tdscto,CAST(0 as decimal(12,2)) as Tisc,impo,CAST(0 as decimal(12,2)) as montoper,k.incl,
	      CAST(0 as decimal(12,2)) as totalpercepcion,k.cant,k.prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,k.kar_unid as unid,a.descri,k.idart as coda,
	      ifnull(unid_codu,'NIU') as unid1,s.codigoestab,r.form,r.rcom_icbper,k.kar_icbper
	      from fe_rcom r
	      inner join fe_clie c on c.idclie=r.idcliente
	      inner join fe_kar k on k.idauto=r.idauto
	      inner join fe_art a on a.idart=k.idart
	      inner join fe_epta as e on e.epta_idep=k.kar_epta
	      inner join fe_presentaciones as p on p.pres_idpr=e.epta_pres
	      left join fe_unidades as u on u.unid_codu=p.pres_unid
	      left join fe_sucu s on s.idalma=r.codt,fe_gene as v
		  where r.idauto=<<pkid>> and r.acti='A' and k.acti='A'
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Geracorrelativo(np1,np2)
	lc="ProGeneraCorrelativo"
	goapp.npara1=np1
	goapp.npara2=np2
	cur=""
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	ENDFUNC
	
Enddefine
