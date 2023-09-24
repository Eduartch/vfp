Define Class guiaremisionxotros As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function listaritemsparaguiaotros(nids, Calias)
	Text To lc Noshow Textmerge
           SELECT a.idart AS coda,entr_cant AS cant,g.guia_fech AS fech,r.idcliente AS idclie,k.idkar,guia_idgui,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,r.ndoc,a.descri,a.unid,a.peso,guia_ndoc as ndoc,guia_idau as idauto
	       FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.entr_idgu=g.guia_idgui
	       INNER JOIN fe_rcom AS r ON r.idauto=g.guia_idau
	       INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	       INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
	       INNER JOIN fe_art AS a ON a.idart=k.`idart`
	       WHERE guia_idgui=<<nids>> AND guia_acti='A'  AND entr_acti='A' and guia_idre=0 ORDER BY k.`idkar`
	Endtext
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarguiaremitenteOtros()
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.idautog > 0 Then
		If AnulaGuiasVentas(This.idautog, goApp.nidusua) = 0 Then
			DEshacerCambios()
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasXOtros(This.fecha, This.ptop, Alltrim(This.ptoll), This.idauto, This.fechat, goApp.nidusua, This.detalle, This.Idtransportista, This.ndoc, goApp.Tienda, This.ubigeocliente)
	If nidg = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, nidg) = 0 Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  this.RegistraRelacionGuias(nidg) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.generacorrelativo() = 1 And s = 1 Then

		If This.GrabarCambios() = 0 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasXOtros(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
	Local lc, lp
	lc			  = "FUNINGRESAGUIASXOTROS"
	cur			  = "YY"
	goApp.npara1  = np1
	goApp.npara2  = np2
	goApp.npara3  = np3
	goApp.npara4  = np4
	goApp.npara5  = np5
	goApp.npara6  = np6
	goApp.npara7  = np7
	goApp.npara8  = np8
	goApp.npara9  = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = This.Codigo
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12)
	Endtext
	nidgg = This.EJECUTARf(lc, lp, cur)
	If nidgg < 1 Then
		Return 0
	Endif
	Return nidgg
	Endfunc
	Function validarguia()
	If Len(Alltrim(This.detalle)) = 0 Then
		This.Cmensaje = "Es Obligatorio el detalle del Motivo del Traslado"
		Return 0
	Endif
	If This.Validar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraRelacionGuias(nidg)
	Text To lc Noshow Textmerge
	   UPDATE fe_guias SET guia_idre=<<nidg>> where guia_idgui=<<this.nautor>>;
	Endtext
	If This.Ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine