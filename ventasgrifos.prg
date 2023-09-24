#Define MSGTITULO 'SISVEN'
Define Class ventasgrifos As Ventas  Of 'd:\capass\modelos\ventas.prg'
    nturno=0
	Function vtascomparativas(nidt, fi, ff, ccursor)
	If nidt > 0 Then
		TEXT To lc Noshow Textmerge
        SELECT fecha,SUM(ventalectura) AS ventalectura,SUM(ventafacturada) AS ventafacturada FROM(
		SELECT  lect_fech AS fecha,SUM(lect_mfinal-lect_inim) AS VentaLectura,CAST(0 AS DECIMAL(12,2)) AS VentaFacturada
		FROM fe_lecturas f WHERE lect_fech BETWEEN '<<fi>>' AND '<<ff>>'  AND lect_acti='A' and lect_idtu=<<nidt>> and lect_mfinal>0 and lect_inim>0 GROUP BY lect_fech
		UNION ALL
		SELECT lcaj_fech AS fecha,CAST(0 AS DECIMAL(12,2)) AS VentaLectura,SUM(lcaj_deud) AS VentaFacturada
		FROM fe_lcaja WHERE lcaj_fech BETWEEN '<<dfi>>' AND '<<ff>>' AND lcaj_deud<>0 AND lcaj_acti='A'
		AND lcaj_idau>0 and lcaj_idtu=<<nidt>> GROUP BY lcaj_fech) AS f GROUP BY fecha
		ENDTEXT
	Else
		TEXT To lc Noshow Textmerge
        SELECT fecha,SUM(ventalectura) AS ventalectura,SUM(ventafacturada) AS ventafacturada FROM(
		SELECT  lect_fech AS fecha,SUM(lect_mfinal-lect_inim) AS VentaLectura,CAST(0 AS DECIMAL(12,2)) AS VentaFacturada
		FROM fe_lecturas f WHERE lect_fech BETWEEN '<<dfi>>' AND '<<ff>>' AND lect_acti='A' and lect_mfinal>0 and lect_inim>0 GROUP BY lect_fech
		UNION ALL
		SELECT lcaj_fech AS fecha,CAST(0 AS DECIMAL(12,2)) AS VentaLectura,SUM(lcaj_deud) AS VentaFacturada
		FROM fe_lcaja WHERE lcaj_fech BETWEEN '<<dfi>>' AND '<<ff>>' AND lcaj_deud<>0 AND lcaj_acti='A'
		AND lcaj_idau>0 GROUP BY lcaj_fech) AS f GROUP BY fecha
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function canjearguiasporfacturas()
	Local Sw As Integer
	If This.validarcanjeguias() < 1 Then
		Return 0
	Endif
	Set Classlib To "d:\librerias\fe" Additive
	ocomp = Createobject("comprobante")
	If VerificaAlias("cabecera") = 1 Then
		Zap In cabecera
	Else
		Create Cursor cabecera(idcab N(8))
	Endif
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	If This.actualizardesdeguias() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.generacorrelativo(This.serie + This.numero, This.Idserie) < 1  Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GrabarCambios() = 0 Then
		Return 0
	Endif
	ocomp.Version = '2.1'
	Try
		Select cabecera
		Scan All
			Do Case
			Case  This.Tdoc = '01'
				vdx = ocomp.obtenerdatosfactura(cabecera.idcab, Iif(fe_gene.gene_cpea = 'N', 'SF', .F.))
			Case This.Tdoc = '03'
				vdx = ocomp.obtenerdatosboleta(cabecera.idcab, 'SF')
			Endcase
		Endscan
	Catch To oerr When oerr.ErrorNo = 1429
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Catch To oerr When oerr.ErrorNo = 1924
		Messagebox(MENSAJE1 + MENSAJE2 + MENSAJE3, 16, MSGTITULO)
	Finally
	Endtry
	This.imprimirdctocanjeado()
	Zap In cabecera
	Return 1
	Endfunc
	Function actualizardesdeguias()
	cform = Left(This.formapago, 1)
	ndolar = fe_gene.dola
	ni = fe_gene.igv
	nidusua = goApp.nidusua
	nidtda = goApp.Tienda
	If This.Tdoc = '01' Or This.Tdoc = '03' Then
		nidcta1 = fe_gene.idctav
		nidcta2 = fe_gene.idctai
		nidcta3 = fe_gene.idctat
	Else
		nidcta1 = 0
		nidcta2 = 0
		nidcta3 = 0
	Endif
	If This.ActualizaresumentDctoCanjeado(This.Tdoc, cform, This.serie + This.numero, This.fecha, This.fecha, This.detalle, ;
			This.valor, This.igv, This.Monto, This.nroguia, This.Moneda, ndolar, fe_gene.igv, 'k', This.Codigo, 'V', goApp.nidusua, 1, goApp.Tienda, nidcta1, nidcta2, nidcta3, This.iddire, This.idautoguia, This.idauto) < 1 Then
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.fecha, "", This.razon, nidcta3, This.Monto, 0, ;
			'S', fe_gene.dola, goApp.nidusua, This.Codigo, This.idauto, cform, This.serie + This.numero, This.Tdoc, goApp.Tienda) = 0 Then
		Return 0
	Endif
	If cform = 'E' Then
		If IngresaRvendedores(This.idauto, This.Codigo, goApp.nidusua, cform) = 0 Then
			Return 0
		Endif
	Endif
	If cform = 'C' Or cform = 'D' Then
		Set Procedure To d:\capass\modelos\ctasxcobrar.prg Additive
		ocre = Createobject("ctasporcobrar")
		ocre.dFech = This.fecha
		ocre.fechavto = This.fechavto
		ocre.nimpo = This.Monto
		ocre.nimpoo = This.Monto
		ocre.tipodcto = 'F'
		ocre.crefe = "VENTA AL CREDITO"
		ocre.cndoc = This.serie + This.numero
		ocre.nidclie = This.Codigo
		ocre.idauto = This.idauto
		ocre.codv = goApp.nidusua
		If ocre.registrar() < 1 Then
			Return 0
		Endif
	Endif
	Insert Into cabecera(idcab)Values(This.idauto)
	Return 1
	Endfunc
	Function imprimirdctocanjeado()
	Select * From tmpp Into Cursor tmpv Readwrite
	Select tmpv
	Replace All cletras With This.cletras, ;
		hash With This.hash, archivo With This.ArchivoXml, fech With This.fecha In tmpv
	Select tmpv
	Go Top In tmpv
	Set Procedure To imprimir Additive
	obji = Createobject("Imprimir")
	obji.Tdoc = This.Tdoc
	obji.ArchivoPdf = This.ArchivoPdf
	obji.ElijeFormato()
	obji.GeneraPDF("")
	obji.ImprimeComprobante('S')
	If !Empty(This.correo) Then
*.comprobante1.enviarcorreocliente(.comprobante1.correo)
	Endif
	Endfunc
	Function validarcanjeguias()
	Do Case
	Case This.idauto = 0
		This.Cmensaje = "Seleccione un Documento para Canje"
		Return 0
	Case  This.idautoguia = 0
		This.Cmensaje = "Seleccione una Guia de Remisión para Canje"
		Return 0
	Case PermiteIngresoVentas(This.serie + This.numero, This.Tdoc, 0, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function ActualizaresumentDctoCanjeado(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lsql = 'ProActualizaCanjeguia'
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
	TEXT To lparms Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(lsql, lparms, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarVtasGrifos()
	Local lo
	x = 'C'
	Set Procedure To d:\capass\modelos\ctasxcobrar Additive
	ctasxcobrar = Createobject('ctasporcobrar')
	Select (This.temporal)
	Locate For cant = 0 And !Empty(coda)
	Do Case
	Case !esfechaValida(This.fecha) Or Month(This.fecha) <> goApp.mes Or Year(This.fecha) <> Val(goApp.año)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema"
		lo = 0
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		lo = 0
	Case This.sinstock = "S"
		This.Cmensaje = "Hay Un Item que No tiene Stock Disponible"
		lo = 0
	Case Found()
		This.Cmensaje = "El producto:" + Alltrim(tmpv.Desc) + " no Tiene Cantidad o Precio"
		lo = 0
	Case PermiteIngresox(This.fecha) = 0
		This.Cmensaje = "NO Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		lo = 0
	Case This.nroformapago = 2  And This.dias = 0
		This.Cmensaje = "Ingrese Los días de Vencimiento de Crédito"
		lo = 0
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		lo = 0
	Case This.nroformapago = 4 And  ctasxcobrar.verificasaldocliente(This.Codigo, This.Monto) = 0
		This.Cmensaje = ctasxcobrar.Cmensaje
		lo = 0
	Case This.nroformapago = 2 And  ctasxcobrar.vlineacredito(This.Codigo, This.Monto, This.lineacredito) = 0
		If goApp.Validarcredito <> 'N' Then
			Do Form v_verifica With "A" To xv
			If !xv
				This.Cmensaje = "No esta Autorizado a Ingresar Este Documento"
				lo = 0
			Else
				lo = 1
			Endif
		Else
			lo = 1
		Endif
	Otherwise
		lo = 1
	Endcase
	If lo = 1 Then
		Return .T.
	Else
		Return .F.
	Endif
	Endfunc
	Function listardctonotascredtito(nid, ccursor)
	TEXT To lc Noshow Textmerge
	    SELECT a.idart,a.descri,a.unid,k.cant,k.prec,
		ROUND(k.cant*k.prec,2) as importe,k.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
		r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'K' as tcom,k.idkar,if(k.prec=0,kar_cost,0) as costoref from fe_rcom r
		inner join fe_kar k on k.idauto=r.idauto
		inner join fe_art a on a.idart=k.idart
		where k.acti='A' and r.acti='A' and r.idauto=<<nid>>
		union all
		SELECT cast(0 as unsigned) as idart,k.detv_desc as descri,'.' as unid,k.detv_cant as cant,k.detv_prec as prec,
		ROUND(k.detv_cant*k.detv_prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,cast(0 as unsigned) as comi,
		cast(1 as unsigned) as alma,r.fech,r.ndoc,r.tdoc,r.dolar as dola,r.vigv,r.rcom_exon,'S' as tcom,detv_idvt as idkar,CAST(0 as decimal(6,2)) as costRef
		from fe_rcom r
		inner join fe_detallevta k on k.detv_idau=r.idauto
		where k.detv_acti='A' and r.acti='A' and r.idauto=<<nid>> order by idkar
	ENDTEXT
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function GrabarIdjornaly(np1)
	TEXT To cupdate Noshow Textmerge
        update venta  set estado=2 where idjournal=<<np1>>
	ENDTEXT
	If This.Ejecutarsql(cupdate) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarvtascreditocantidad(dfi,dff,nidus,nisla,nidl,calias)
	fi=cfechas(dfi)
	ff=cfechas(dff)
*!*		If nisla=0 Then
		If nidus=0 Then
			TEXT TO lc NOSHOW TEXTMERGE
		     SELECT a.ndoc,a.fech,c.razo,d.descri,d.unid,e.cant,e.prec,f.nomb AS usuario,CAST(e.cant*e.prec AS DECIMAL(12,2)) AS impo,
	         a.deta,a.fusua,kar_idco,a.codt as isla,'credito' as tipo FROM
	         fe_rcom AS a
	         INNER JOIN fe_clie AS c ON c.idclie=a.idcliente
			 INNER JOIN fe_kar AS e ON e.idauto=a.idauto
			 INNER JOIN fe_art AS d ON d.idart=e.idart
			 INNER JOIN fe_usua AS f ON f.idusua=a.idusua
			 WHERE rcom_idis=<<nidl>> AND a.acti='A' AND e.acti='A' AND a.form='C' AND kar_idco>0  AND codt=<<nisla>>
			ENDTEXT
		Else
			TEXT TO lc NOSHOW TEXTMERGE
		     SELECT a.ndoc,a.fech,c.razo,d.descri,d.unid,e.cant,e.prec,f.nomb AS usuario,CAST(e.cant*e.prec AS DECIMAL(12,2)) AS impo,
	         a.deta,a.fusua,kar_idco,a.codt as isla,'credito' as tipo FROM
	         fe_rcom AS a
	         INNER JOIN fe_clie AS c ON c.idclie=a.idcliente
			 INNER JOIN fe_kar AS e ON e.idauto=a.idauto
			 INNER JOIN fe_art AS d ON d.idart=e.idart
			 INNER JOIN fe_usua AS f ON f.idusua=a.idusua
			 WHERE rcom_idis=<<nidl>> AND a.acti='A' AND e.acti='A' AND a.form='C' AND kar_idco>0  and a.idusua=<<nidus>>  AND codt=<<nisla>>
			ENDTEXT
		Endif
*!*		Else
*!*			If nidus=0 Then
*!*				TEXT TO lc NOSHOW TEXTMERGE
*!*		     SELECT a.ndoc,a.fech,c.razo,d.descri,d.unid,e.cant,e.prec,f.nomb AS usuario,CAST(e.cant*e.prec AS DECIMAL(12,2)) AS impo,
*!*	         a.deta,a.fusua,kar_idco,a.codt as isla,'credito' as tipo FROM
*!*	         fe_rcom AS a
*!*	         INNER JOIN fe_clie AS c ON c.idclie=a.idcliente
*!*			 INNER JOIN fe_kar AS e ON e.idauto=a.idauto
*!*			 INNER JOIN fe_art AS d ON d.idart=e.idart
*!*			 INNER JOIN fe_usua AS f ON f.idusua=a.idusua
*!*			 WHERE a.fech BETWEEN '<<fi>>' AND '<<ff>>' AND a.acti='A' AND e.acti='A' AND a.form='C' AND kar_idco>0 and a.codt=<<nisla>> and rcom_idtr=<<this.nturno>>
*!*				ENDTEXT
*!*			Else
*!*				TEXT TO lc NOSHOW TEXTMERGE
*!*		     SELECT a.ndoc,a.fech,c.razo,d.descri,d.unid,e.cant,e.prec,f.nomb AS usuario,CAST(e.cant*e.prec AS DECIMAL(12,2)) AS impo,
*!*	         a.deta,a.fusua,kar_idco,a.codt as isla,'credito' as tipo FROM
*!*	         fe_rcom AS a
*!*	         INNER JOIN fe_clie AS c ON c.idclie=a.idcliente
*!*			 INNER JOIN fe_kar AS e ON e.idauto=a.idauto
*!*			 INNER JOIN fe_art AS d ON d.idart=e.idart
*!*			 INNER JOIN fe_usua AS f ON f.idusua=a.idusua
*!*			 WHERE a.fech BETWEEN '<<fi>>' AND '<<ff>>' AND a.acti='A' AND e.acti='A' AND a.form='C' AND kar_idco>0  and a.idusua=<<nidus>> and a.codt=<<nisla>> and rcom_idtr=<<this.nturno>>
*!*				ENDTEXT
*!*			Endif
*!*		Endif
	If This.EjecutaConsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

