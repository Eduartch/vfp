Define Class proyectos As  Odata Of  "d:\capass\Database\Data.prg"
	cnombre		= ""
	nidcliente	= 0
	nidproyecto	= 0
	Function muestraproyectosx(np1, cur)
	Local cur As String
	Local lc, lp
	m.lc		 = 'ProMuestraProyectos'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
	     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lc, m.lp, m.cur) < 1 Then
		Return 0
	ENDIF 
		Return 1
	Endfunc
	Function CrearProyecto(np1, np2)
	Local cur As String
	Local lc, lp
	m.lc		 = 'FunCreaProyecto'
	m.cur		 = "creap"
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARf(m.lc, m.lp, m.cur) = 0 Then
		Return 0
	Else
		Mensaje("Creado Ok")
		Return creap.Id
	Endif
	Endfunc

	Function ActualizarProyecto(np1, np2, np3, np4)
	Local cur As String
	Local lc, lp
	m.lc		 = 'ProActualizaProyecto'
	m.cur		 = ""
	goApp.npara1 = m.np1
	goApp.npara2 = m.np2
	goApp.npara3 = m.np3
	goApp.npara4 = m.np4
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	Endtext
	If This.EJECUTARP(m.lc, m.lp, m.cur) = 0 Then
		Return 0
	Else
		Mensaje("Ok")
		Return 1
	Endif
	Endfunc
	Function listarcontenidodeproyectos(np1, ccursor)
	Text To lc Noshow Textmerge
			   SELECT b.descri,b.unid,a.cant,a.prec, Round(a.cant * a.Prec, 2) As importe, c.fech,a.idauto,c.codt as alma,a.idkar,a.idart,
			   a.codv,c.valor,c.igv,c.impo,c.fecr,c.form,c.deta,c.vigv as igv,d.idclie,d.razo,d.nruc,d.dire,d.ciud,
			   a.tipo,c.tdoc,c.ndoc,c.dolar,c.mone,b.premay as pre1,b.premen as pre2,b.pre3,b.cost as costo,
			   kar_esti,kar_tpro,kar_cant,kar_pre1,kar_code,s.dmar,b.prod_coda,proy_nomb,proy_idpr,proy_impo,proy_feci
			   FROM fe_kar as a
			   inner join fe_art as b on b.idart=a.idart
			   inner join fe_mar as s on s.idmar=b.idmar
			   inner JOIN fe_rcom as c on(c.idauto=a.idauto)
			   inner join fe_proyectos as p on p.proy_idpr=a.kar_proy
			   inner join fe_clie as d  ON d.idclie=p.proy_idcl
			   where a.kar_proy=<<np1>> and a.acti='A'
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function desactivardetalleproyecto(np1)
	Text To lc Noshow Textmerge
	      UPDATE fe_kar SET  acti='I' WHERE idkar=<<np1>>
	Endtext
	If This.Ejecutarsql(lc) < 1 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function actualizadetalleproyecto(np1, np2, np3)
	Text To lc Noshow Textmerge
	      UPDATE fe_kar SET cant=<<np2>> WHERE idkar=<<np1>>
	Endtext
	If This.Ejecutarsql(lc) < 1 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function ingresaconsumoproyectosconreferencia()
	Endfunc
Enddefine


