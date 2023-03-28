Define Class promociones As Odata Of "d:\capass\database\data.prg"
	feci=Date()
	fecf=Date()
	ncosto=0
	npunto=0
	estado=""
	nidprom=0
	nidauto=0
	nidclie=0
	npunto=0
	ndscto=0
	dfecha=Date()
	Function listar()
	ccursor='c_'+Sys(2015)
	df=cfechas(fe_gene.fech)
	TEXT TO lc NOSHOW TEXTMERGE
	     SELECT prom_feci,prom_fecf,prom_cost,prom_punt,prom_idprom FROM fe_prom WHERE prom_acti='A'  AND '<<df>>' BETWEEN prom_feci AND prom_fecf limit 1
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	AddProperty(_Screen,'punto',prom_punt)
	AddProperty(_Screen,'valorpto',prom_cost)
	AddProperty(_Screen,'idpromo',prom_idprom)
	cierracursor(ccursor)
	Return 1
	Endfunc
	Function registrarpuntos()
	lc		  = 'proregistraptos'
	ffecha=cfechas(this.dfecha)
	TEXT TO lp NOSHOW TEXTMERGE
	(<<this.nidauto>>,<<this.nidclie>>,<<this.npunto>>,<<this.ndscto>>,'<<ffecha>>',<<this.nidprom>>)
	ENDTEXT
	If This.EJECUTARP(lc, lp, "")<1 Then
		Return 0
	Endif
	RETURN 1
	Endfunc
	Function descontarpuntos()

	Endfunc
	Function listarpuntos(nidclie,nidpro)
	ccursor='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
	      select  SUM(dpro_acum-dpro_desc) as ptos FROM fe_dpromo WHERE dpro_idcli=<<nidlcie>> and dpro_acti='A' AND dpro_idpro=<<nidpro>> and datediff(now(),dpro_fech)<=90
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return -1
	Endif
	Select (ccursor)
	Return ptos
	Endfunc
	Function calcular(nmonto)
	Return Int(nmonto/_Screen.valorpto)
	Endfunc
	Function calculartotal(nidclie)
	ccursor='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT SUM(dpro_acum-dpro_desc) AS saldo FROM fe_dpromo WHERE dpro_acti='A' AND dpro_idcli=<<nidclie>> and datediff(now(),dpro_fech)<=90
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return -1
	Endif
	Select (ccursor)
	nsaldo=Iif(Isnull(saldo),0,saldo)
	Return nsaldo
	Endfunc
Enddefine
