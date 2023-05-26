Define Class compras As Odata Of "d:\capass\Database\Data.prg"
	ctdoc	 = ""
	cforma	 = ""
	cndoc	 = ""
	dFecha	 = Date()
	dfechar	 = Date()
	cdetalle = ""
	nimpo1	 = 0
	nimpo2	 = 0
	nimpo3	 = 0
	nimpo4	 = 0
	nimpo5	 = 0
	nimpo6	 = 0
	nimpo7	 = 0
	nimpo8	 = 0
	cguia	 = ""
	cmoneda	 = ""
	ndolar	 = 0
	vigv	 = 0
	ctipo	 = ""
	nidprov	 = 0
	ctipo1	 = ""
	nidusua	 = 0
	nidt	 = 0
	nreg	 = 0
	nidcta1 = 0
	nidcta2 = 0
	nidcta3 = 0
	nidcta4 = 0
	nidctai = 0
	nidctae = 0
	nidcta7 = 0
	nidctat = 0
	idcta1 = 0
	idcta2 = 0
	idcta3 = 0
	idcta4 = 0
	idcta5 = 0
	idcta6 = 0
	idcta7 = 0
	idcta8 = 0
	ct1 = ""
	ct2 = ""
	ct3 = ""
	ct4 = ""
	ct5 = ""
	ct6 = ""
	ct7 = ""
	ct8 = ""
	cproveedor = ""
	serie = ''
	ndoc = ''
	nforma = 0
	nmontor = 0
	cformaregistrada = ""
	ntienepagos = 0
	cencontrado = ""
	conedaregistrada = ""
	Function actualizaparteotrascompras()
	This.CONTRANSACCION = 'S'
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	lc = 'ProActualizaRCompras1'
	cur = ""
	goApp.npara1 = This.ctdoc
	goApp.npara2 = This.cforma
	goApp.npara3 = This.cndoc
	goApp.npara4 = This.dFecha
	goApp.npara5 = This.dfechar
	goApp.npara6 = This.cdetalle
	goApp.npara7 = This.nimpo1 + This.nimpo2 + This.nimpo3 + This.nimpo4
	goApp.npara8 = This.nimpo5
	goApp.npara9 = This.nimpo8
	goApp.npara10 = ""
	goApp.npara11 = This.cmoneda
	goApp.npara12 = This.ndolar
	goApp.npara13 = This.vigv
	goApp.npara14 = This.ctipo
	goApp.npara15 = This.nidprov
	goApp.npara16 = This.ctipo1
	goApp.npara17 = This.nidusua
	goApp.npara18 = 0
	goApp.npara19 = This.nidt
	goApp.npara20 = 0
	goApp.npara21 = 0
	goApp.npara22 = 0
	goApp.npara22 = 0
	goApp.npara24 = 0
	goApp.npara25 = This.nreg
	goApp.npara26 = This.nimpo7
	goApp.npara27 = This.nimpo8
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	Endtext
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		This.Cmensaje = ' Actualizando Cabecera de Documento de Compras/Gastos'
		Return 0
	Endif
	If This.actualizacuentascontablesocompras() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function actualizacuentascontablesocompras()
	lcsql = 'ProActualizaCtascsolocuentas'
	goApp.npara1 = 0
	goApp.npara2 = 0
	goApp.npara3 = 0
	goApp.npara4 = 0
	goApp.npara5 = 0
	goApp.npara6 = 0
	goApp.npara7 = 0
	goApp.npara8 = 0
	goApp.npara9 = This.nidcta1
	goApp.npara10 = This.nidcta2
	goApp.npara11 = This.nidcta3
	goApp.npara12 = This.nidcta4
	goApp.npara13 = This.nidctai
	goApp.npara14 = This.nidctae
	goApp.npara15 = This.nidcta7
	goApp.npara16 = This.nidctat
	goApp.npara17 = This.idcta1
	goApp.npara18 = This.idcta2
	goApp.npara19 = This.idcta3
	goApp.npara20 = This.idcta4
	goApp.npara21 = This.idcta5
	goApp.npara22 = This.idcta6
	goApp.npara23 = This.idcta7
	goApp.npara24 = This.idcta8
	goApp.npara25 = ""
	goApp.npara26 = ""
	goApp.npara27 = ""
	goApp.npara28 = ""
	goApp.npara29 = ""
	goApp.npara30 = ""
	goApp.npara31 = ""
	goApp.npara32 = ""
	Text To lc1 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta1>> WHERE idectas=<<This.idcta1>>;
	Endtext
	If This.ejecutarsql(lc1) < 1 Then
		Return 0
	Endif
	Text To lc2 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta1>> WHERE idectas=<<This.idcta2>>;
	Endtext
	If This.ejecutarsql(lc2) < 1 Then
		Return 0
	Endif
	Text To lc3 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta3>> WHERE idectas=<<This.idcta3>>;
	Endtext
	If This.ejecutarsql(lc3) < 1 Then
		Return 0
	Endif
	Text To lc4 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta4>> WHERE idectas=<<This.idcta4>>;
	Endtext
	If This.ejecutarsql(lc4) < 1 Then
		Return 0
	Endif
	Text To lc5 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidctai>> WHERE idectas=<<This.idcta5>>;
	Endtext
	If This.ejecutarsql(lc5) < 1 Then
		Return 0
	Endif
	Text To lc6 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidctae>> WHERE idectas=<<This.idcta6>>;
	Endtext
	If This.ejecutarsql(lc6) < 1 Then
		Return 0
	Endif
	Text To lc7 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidcta7>> WHERE idectas=<<This.idcta7>>;
	Endtext
	If This.ejecutarsql(lc7) < 1 Then
		Return 0
	Endif
	Text To lc8 Noshow Textmerge
	  UPDATE fe_ectasc SET idcta=<<This.nidctat>> WHERE idectas=<<This.idcta8>>;
	Endtext
	If This.ejecutarsql(lc8) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function BuscarcomprasGrifos(nid, ccursor)
	If nid > 0 Then
		Text To lc Noshow Textmerge
	    SELECT  c.deta AS deta, a.idauto,a.alma, a.idkar AS idkar,b.descri AS descri, b.peso AS peso, b.prod_idco AS prod_idco, b.unid AS unid,
		b.tipro  AS tipro, a.idart AS idart, a.incl AS incl, c.ndoc AS ndoc, c.valor     AS valor, c.igv       AS igv,
		c.impo   AS impo, c.pimpo AS pimpo, a.cant  AS cant, a.prec AS prec, c.fech      AS fech, c.fecr      AS fecr,
		c.form   AS form, c.exon  AS exon, c.ndo2  AS ndo2, c.vigv  AS vigv, c.idprov    AS idprov, a.tipo      AS tipo,
		c.tdoc, c.dolar  AS dolar, c.mone  AS mone,p.razo AS razo, p.dire      AS dire, p.ciud      AS ciud,
		p.nruc   AS nruc, c.codt AS codt, a.dsnc,a.dsnd,a.gast, c.fusua,c.idusua AS idusua, w.nomb  AS Usuario, c.rcom_fise,rcom_exon
		FROM fe_rcom c
		LEFT JOIN fe_kar a  ON c.idauto = a.idauto
		LEFT JOIN fe_art b  ON b.idart = a.idart
		JOIN fe_prov p  on p.idprov = c.idprov
		JOIN fe_usua w ON w.idusua = c.idusua
		WHERE c.acti='A' AND a.acti= 'A' and c.idauto=<<nid>>
		Endtext
	Else
		Text To lc Noshow Textmerge
	    SELECT  c.deta AS deta, a.idauto,a.alma, a.idkar AS idkar,b.descri AS descri, b.peso AS peso, b.prod_idco AS prod_idco, b.unid AS unid,
		b.tipro  AS tipro, a.idart AS idart, a.incl AS incl, c.ndoc AS ndoc, c.valor     AS valor, c.igv       AS igv,
		c.impo   AS impo, c.pimpo AS pimpo, a.cant  AS cant, a.prec AS prec, c.fech      AS fech, c.fecr      AS fecr,
		c.form   AS form, c.exon  AS exon, c.ndo2  AS ndo2, c.vigv  AS vigv, c.idprov    AS idprov, a.tipo      AS tipo,
		c.tdoc   AS tdoc, c.dolar  AS dolar, c.mone  AS mone,p.razo AS razo, p.dire      AS dire, p.ciud      AS ciud,
		p.nruc   AS nruc, c.codt AS codt, a.dsnc,a.dsnd,a.gast, c.fusua,c.idusua AS idusua, w.nomb  AS Usuario, c.rcom_fise,rcom_exon
		FROM fe_rcom c
		LEFT JOIN fe_kar a  ON c.idauto = a.idauto
		LEFT JOIN fe_art b  ON b.idart = a.idart
		JOIN fe_prov p  on p.idprov = c.idprov
		JOIN fe_usua w ON w.idusua = c.idusua
		WHERE c.acti='A' AND a.acti= 'A' and c.ndoc='<<this.cndoc>>' AND c.tdoc='<<this.ctdoc>>' AND c.idprov=<<this.nidprov>>
		Endtext
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarCanjesGuiascompras()
	Do Case
	Case Len(Alltrim(This.serie)) <> 4 Or Len(Alltrim(This.ndoc)) <> 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return 0
	Case Val(This.ndoc) = 0
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return 0
	Case This.nimpo8 = 0
		This.Cmensaje = "Ingrese Importes Válidos Diferentes de 0"
		Return  0
	Case !esfechaValida(This.dfechar) Or !esfechaValida(This.dfechar)
		This.Cmensaje = "Fecha de Registro No Permitido Diferente al Mes Actual"
		Return  0
	Case Year(This.dfechar) <> Val(goApp.año) Or Year(This.dfechar) <> Val(goApp.año)
		This.Cmensaje = "Fecha No Permitida Por el Sistema ... Diferente al Año Actual"
		Return 0
	Case PermiteIngresoCompras(This.cndoc, '01', This.nidprov, 0, This.dfechar) = 0
		This.Cmensaje = "Número de Documento de Compra Ya Registrado"
		Return 0
	Case  PermiteIngresox(This.dfechar) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case Empty(This.nidprov) Or This.nidprov = 0
		This.Cmensaje = "Seleccione Un Proveedor"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function comprasxproducto(nidart, ccursor)
	Text To lc Noshow Textmerge
	        SELECT b.razo,c.fech,cant,ROUND(prec*c.vigv,2) as prec,If(mone='D',Round(Prec*g.dola*c.vigv,2),Prec) As precios,c.mone,tdoc,ndoc,MONTH(c.fech) as mes FROM fe_kar as a
			INNER JOIN fe_rcom  as c ON(c.idauto=a.idauto)
			inner join fe_prov as b ON (b.idprov=c.idprov),fe_gene as g
			WHERE idart=<<nidart>> AND  c.acti<>'I' and a.acti='A' order by c.fech desc;
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registraotracompras()
	Set Procedure To d:\capass\modelos\cajae, d:\capass\modelos\ctasxpagar Additive
	ocaja = Createobject("cajae")
	octaspagar = Createobject("ctasporpagar")
	If This.validaocompras() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif

	NAuto = This.IngresaResumenDctoC(This.ctdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.cdetalle, This.nimpo1 + This.nimpo2 + This.nimpo3 + This.nimpo4, This.nimpo5, This.nimpo8, ;
		  '', This.cmoneda, This.ndolar, fe_gene.igv, This.ctipo, This.nidprov, This.ctipo1, goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0, This.nimpo6, This.nimpo8)
	If NAuto < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif

	If This.IngresaValoresCtasC1(This.nimpo1, This.nimpo2, This.nimpo3, This.nimpo4, This.nimpo5, This.nimpo6, This.nimpo7, This.nimpo8, This.nidcta1, This.nidcta2, This.nidcta3, This.nidcta4, ;
			  This.nidctai, This.nidctae, This.nidcta7, This.nidctat, This.ct1, This.ct2, This.ct3, This.ct4, This.ct5, This.ct6, This.ct7, This.ct8, NAuto) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If ocaja.IngresaDatosLCajaEFectivo11(This.dfechar, "", This.cproveedor, This.nidctat, 0, This.nimpo8, This.cmoneda, This.ndolar, goApp.nidusua, This.nidprov, NAuto, This.cforma, This.cndoc, This.ctdoc) < 1 Then
		This.Cmensaje = ocaja.Cmensaje
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.nforma = 2 Then
		If  ctaspagar.registrarcuentasporpagar('tmpd', NAuto, This.nidprov, This.cmoneda, This.dFecha, This.nimpo8, This.nidctat, This.ndolar) < 1 Then
			This.Cmensaje = octaspagar.Cmensaje
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaValoresCtasC1(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	Local cur As String
	lc = 'IngresaCuentas'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	Endtext
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenDctoC(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	lc = 'FunIngresaRCompras'
	cur = "Xn"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	goApp.npara26 = np26
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	Endtext
	nid = This.EJECUTARf(lc, lp, cur)
	If nid < 1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc
	Function validaocompras()
	Do Case
	Case PermiteIngresoCompras(This.ndoc, This.ctdoc, This.nidprov, This.nreg, This.dFecha) = 0
		This.Cmensaje = "NUMERO de Documento de Compra Ya Registrado "
		Return 0
	Case  PermiteIngresox(This.dfechar) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case Len(Alltrim(This.serie)) < 4 Or Len(Alltrim(This.ndoc)) < 8
		This.Cmensaje = "Ingrese un Nº de Documento Válido"
		Return 0
	Case Year(This.dfechar) <> Val(goApp.año) Or !esfechaValida(This.dFecha) Or !esfechaValida(This.dfechar)
		This.Cmensaje = "Fecha No permitida por el Sietema"
		Return 0
	Case This.nidprov = 0
		This.Cmensaje = "Seleccione Un Proveedor"
		Return 0
	Case (This.nmontor <> This.nimpo8  Or This.cmonedaregistrada <> This.cmoneda) And This.ntienepagos = 1 And This.cencontrado = 'V'
		This.Cmensaje = "El Nuevo Monto Ingresado o el Tipo de Moneda es Diferente al Registrado como Deuda(Tiene Que ser los mismos Datos) "
		Return 0
	Case This.cformaregistrada <> This.cforma And This.ntienepagos = 1 And This.cencontrado = 'V'
		This.Cmensaje = "Este Documento Tiene Pagos Aplicados y no es Posible Cambiar la forma de pago"
		Return 0
	Case Empty(This.ctdoc)
		This.Cmensaje = "Seleccione Un Tipo de Documento"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function ActualizaResumenDctoC(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26, np27)
	lc = 'ProActualizaRCompras'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = np13
	goApp.npara14 = np14
	goApp.npara15 = np15
	goApp.npara16 = np16
	goApp.npara17 = np17
	goApp.npara18 = np18
	goApp.npara19 = np19
	goApp.npara20 = np20
	goApp.npara21 = np21
	goApp.npara22 = np22
	goApp.npara23 = np23
	goApp.npara24 = np24
	goApp.npara25 = np25
	goApp.npara26 = np26
	goApp.npara27 = np27
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	Endtext
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarocompras()
	Set Procedure To d:\capass\modelos\cajae, d:\capass\modelos\ctasxpagar Additive
	ocaja = Createobject("cajae")
	octaspagar = Createobject("ctasporpagar")
	If This.validaocompras() < 1 Then
		Return 0
	Endif
	If This.IniciaTransaccion() = 0 Then
		Return 0
	Endif
	If This.ActualizaResumenDctoC(This.Tdoc, This.cforma, This.cndoc, This.dFecha, This.dfechar, This.cdetalle, This.nimpo1 + This.nimpo2 + This.nimpo3 + This.nimpo4, This.nimpo5, This.nimpo8, '', This.cmoneda, ;
			  This.ndolar, fe_gene.igv, This.ctipo, This.nidprov, This.ctipo1, goApp.nidusua, 0, goApp.Tienda, 0, 0, 0, 0, 0, This.nreg, This.nimpo6, This.nimpo8) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If ocaja.IngresaDatosLCajaEFectivo11(This.dfechar, "", This.cproveedor, This.nidctat, 0, This.nimpo8, This.cmoneda, ;
			  This.ndolar, goApp.nidusua, This.nidprov, This.nreg, This.cforma, This.cndoc, This.ctdoc) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.FormaRegistrada = 'C' And This.nforma = 1 Then
		If ACtualizaDeudas(This.nreg, goApp.nidusua) = 0
			Return 0
		Endif
	Endif
	If This.actualizaparteotrascompras() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.nforma = 2 Then
		If This.nreg > 0 Then
			If ACtualizaDeudas(This.nreg, goApp.nidusua) = 0
				This.DEshacerCambios()
				Return 0
			Endif
		Endif
		If  ctaspagar.registrarcuentasporpagar('tmpd', This.nreg, This.nidprov, This.cmoneda, This.dFecha, This.nimpo8, This.nidctat, This.ndolar) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GrabarCambios() = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizactasocompras()
	lc = 'ProActualizactasc'
	Text To lp  Noshow Textmerge
	(<<this.nimpo1>>,<<this.nimpo2>>,<<this.nimpo3>>,<<this.nimpo4>>,<<this.nimpo5>>,<<this.nimpo6>>,<<this.nimpo7>>,<<this.nimpo8>>,
	<<this.nidcta1>>,<<this.nidcta2>>,<<this.nidcta3>>,<<this.nidcta4>>,<<this.nidctai>>,<<this.nidctae>>,<<this.nidcta7>>,<<this.nidctat>>,
	<<this.idcta1>>,<<this.idcta2>>,<<this.idcta3>>,<<this.idcta4>>,<<this.idcta5>>,<<this.idcta6>>,<<this.idcta7>>,<<this.idcta8>>,'<<this.ct1>>','<<this.ct2>>','<<this.ct3>>','<<this.ct4>>','<<this.ct5>>','<<this.ct6>>','<<this.ct7>>','<<this.ct8>>')
	Endtext
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxdcto(ccursor)
	If This.idsesion > 1 Then
		Set DataSession To This.idsesion
	Endif
	Text To lc Noshow Textmerge
	SELECT  `c`.`deta`      AS `deta`, `a`.`idauto`    AS `idauto`, `a`.`alma`      AS `alma`, `a`.`idkar`     AS `idkar`,
			  `b`.`descri`    AS `descri`,  `b`.`peso`      AS `peso`,  `b`.`prod_idco` AS `prod_idco`,
			  `b`.`unid`      AS `unid`,  `b`.`tipro`     AS `tipro`,  `a`.`idart`     AS `idart`,
			  `a`.`incl`      AS `incl`,  `c`.`ndoc`      AS `ndoc`,  `c`.`valor`     AS `valor`,
			  `c`.`igv`       AS `igv`,  `c`.`impo`      AS `impo`,  `c`.`pimpo`     AS `pimpo`,
			  `a`.`cant`      AS `cant`, `a`.`prec`      AS `prec`,  `c`.`fech`      AS `fech`,
			  `c`.`fecr`      AS `fecr`, `c`.`form`      AS `form`,  `c`.`exon`      AS `exon`,
			  `c`.`ndo2`      AS `ndo2`,  `c`.`vigv`      AS `vigv`,  `c`.`idprov`    AS `idprov`,
			  `a`.`tipo`      AS `tipo`, `c`.`tdoc`      AS `tdoc`,  `c`.`dolar`     AS `dolar`,
			  `c`.`mone`      AS `mone`,  `p`.`razo`      AS `razo`,  `p`.`dire`      AS `dire`,
			  `p`.`ciud`      AS `ciud`, `p`.`nruc`      AS `nruc`,  `c`.`codt`      AS `codt`,
			  `a`.`dsnc`      AS `dsnc`, `a`.`dsnd`      AS `dsnd`,  `a`.`gast`      AS `gast`,prod_cod1,
			  `c`.`fusua`     AS `fusua`, `c`.`idusua`    AS `idusua`,  `w`.`nomb`      AS `Usuario`
		    FROM `fe_rcom` `c`
		    LEFT JOIN `fe_kar` `a`  ON `c`.`idauto` = `a`.`idauto`
		    LEFT JOIN `fe_art` `b`  ON `b`.`idart` = `a`.`idart`
		    JOIN `fe_prov` `p`  on `p`.`idprov` = `c`.`idprov`
		    JOIN `fe_usua` `w` ON `w`.`idusua` = `c`.`idusua`
		    WHERE `c`.`acti` <> 'I'     AND `a`.`acti` <> 'I' and c.ndoc='<<this.cndoc>>' AND c.tdoc='<<this.ctdoc>>' AND c.idprov=<<this.nidprov>>
		    order by idkar
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscarxid(nidauto, ccursor)
	If This.idsesion > 1 Then
		Set DataSession To This.idsesion
	Endif
	Text To lc Noshow Textmerge
	SELECT  `c`.`deta`      AS `deta`, `a`.`idauto`    AS `idauto`, `a`.`alma`      AS `alma`, `a`.`idkar`     AS `idkar`,
			  `b`.`descri`    AS `descri`,  `b`.`peso`      AS `peso`,  `b`.`prod_idco` AS `prod_idco`,
			  `b`.`unid`      AS `unid`,  `b`.`tipro`     AS `tipro`,  `a`.`idart`     AS `idart`,
			  `a`.`incl`      AS `incl`,  `c`.`ndoc`      AS `ndoc`,  `c`.`valor`     AS `valor`,
			  `c`.`igv`       AS `igv`,  `c`.`impo`      AS `impo`,  `c`.`pimpo`     AS `pimpo`,
			  `a`.`cant`      AS `cant`, `a`.`prec`      AS `prec`,  `c`.`fech`      AS `fech`,
			  `c`.`fecr`      AS `fecr`, `c`.`form`      AS `form`,  `c`.`exon`      AS `exon`,
			  `c`.`ndo2`      AS `ndo2`,  `c`.`vigv`      AS `vigv`,  `c`.`idprov`    AS `idprov`,
			  `a`.`tipo`      AS `tipo`, `c`.`tdoc`      AS `tdoc`,  `c`.`dolar`     AS `dolar`,
			  `c`.`mone`      AS `mone`,  `p`.`razo`      AS `razo`,  `p`.`dire`      AS `dire`,
			  `p`.`ciud`      AS `ciud`, `p`.`nruc`      AS `nruc`,  `c`.`codt`      AS `codt`,l.lcaj_idus,
			  `a`.`dsnc`      AS `dsnc`, `a`.`dsnd`      AS `dsnd`,  `a`.`gast`      AS `gast`,prod_cod1,
			  `c`.`fusua`     AS `fusua`, `c`.`idusua`    AS `idusua`,  `w`.`nomb`      AS `Usuario`
		    FROM `fe_rcom` `c`
		    LEFT JOIN `fe_kar` `a`  ON `c`.`idauto` = `a`.`idauto`
		    LEFT JOIN `fe_art` `b`  ON `b`.`idart` = `a`.`idart`
		    JOIN `fe_prov` `p`  on `p`.`idprov` = `c`.`idprov`
		    JOIN `fe_usua` `w` ON `w`.`idusua` = `c`.`idusua`
		    left join (select lcaj_idus,lcaj_idau from fe_lcaja  as w where lcaj_idau=<<nidauto>> and lcaj_acti='A') as l on l.lcaj_idau=c.idauto 
		    WHERE `c`.`acti` <> 'I'     AND `a`.`acti` <> 'I' and c.idauto=<<nidauto>>
		    order by idkar
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registradetraccion(c1, f1, nid)
	F = cfechas(f1)
	Text To lc Noshow Textmerge
      UPDATE fe_rcom SET rcom_detr='<<c1>>',rcom_fecd='<<f>>' WHERE idauto=<<nid>>
	Endtext
	If This.ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Endfunc
Enddefine


