Define Class vendedores As Odata Of 'd:\capass\database\data.prg'
	nidv = 0
	Function MuestraVendedores(np1, ccursor)
	Local lc, lp
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	m.lc		 = 'PROMUESTRAVENDEDORES'
	goApp.npara1 = m.np1
	Text To m.lp Noshow Textmerge
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Mostrarclientesxvendedor(ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Text To lc Noshow Textmerge
	     Select a.razo,a.nruc,a.dire,a.ciud,a.fono,a.fax,a.clie_rpm,ifnull(x.zona_nomb,'') as zona,a.refe as Referencia
        from fe_clie as a 
        left join fe_zona as x on x.zona_idzo=a.clie_idzo 
        where a.clie_acti='A' and a.clie_codv=<<this.nidv>>  order by zona,a.razo 
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine



