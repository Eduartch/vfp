#Define MSGTITULO 'SISVEN'
Define Class Ventas As Odata Of 'd:\capass\database\data.prg'
	fecha = Date()
	fechavto = Date()
	temporal = ""
	Codigo = 0
	sinserie = ""
	ruc = ""
	Tdoc = ""
	dni = ""
	encontrado = ""
	serie = ""
	numero = ""
	almacen = 0
	nroformapago = 0
	formapago = ""
	igv = 0
	valor = 0
	exonerado = 0
	inafecta = 0
	gratuita = 0
	Monto = 0
	Moneda = ""
	Usuario = 0
	sinstock = ""
	dias = 0
	lineacredito = 0
	rptaSunat = ""
	vendedor = 0
	idauto = 0
	CreditoAutorizado = 0
	tipocliente = ""
	tiponotacredito = ""
	nombre = ""
	tdocref = ""
	agrupada = 0
	noagrupada = 0
	montoreferencia = 0
	montonotacredito13 = 0
	detraccion = 0
	coddetraccion = ""
	chkdetraccion = 0
	Calias = ""
	nroguia = ""
	razon = ""
	cletras = ""
	hash = ""
	Idserie = 0
	Nitems = 0
	nsgte = 0
	ArchivoXml = ""
	ArchivoPdf = ""
	correo = ""
	idautoguia = 0
	detalle = ""
	iddire = 0
	clienteseleccionado = ""
	codt = 0
	fechai = Date()
	fechaf = Date()
	nmarca = 0
	bancarizada = ""
	Function mostraroventasservicios(np1, Ccursor)
	Text To lc Noshow Textmerge
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,rcom_mens,ifnull(p.fevto,a.fech) as fvto
	        from fe_rcom as a
	        inner join fe_ectas as w ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
            where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=a.idauto
	        where a.idauto=<<np1>> and a.acti='A' and w.acti='A'
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostraroventasserviciosconretdet(np1, Ccursor)
	Text To lc Noshow Textmerge
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,rcom_mens,rcom_mdet,rcom_mret,ifnull(p.fevto,a.fech) as fvto
	        from fe_rcom as a
	        inner join fe_ectas as w ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        left join (select rcre_idau,min(c.fevto) as fevto from fe_rcred as r inner join fe_cred as c on c.cred_idrc=r.rcre_idrc
            where rcre_acti='A' and acti='A' and rcre_idau=<<np1>> group by rcre_idau) as p on p.rcre_idau=a.idauto
	        where a.idauto=<<np1>> and a.acti='A' and w.acti='A'
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  mostrarotrasventas(np1, Ccursor)
	Text To lc Noshow Textmerge
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,codt,tdoc,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,rcom_mdet,rcom_mret,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,b.clie_corr,rcom_carg,rcom_mens
	        from fe_rcom as a
	        inner join fe_ectas as w  ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        where a.idauto=<<np1>> and w.acti='A'
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obteneridventa(np1, np2, Ccursor)
	Text To lc Noshow Textmerge
		    SELECT a.idauto,b.nruc FROM fe_rcom as a
		    inner JOIN fe_clie as b  on(b.idcliE=a.idcliente)
		    where a.ndoc='<<np1>>' and a.tdoc='<<np2>>' and acti<>'I'
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleotrasventas(np1, Ccursor)
	Text To lc Noshow Textmerge
				  SELECT q.detv_desc,q.detv_item,q.detv_ite1,q.detv_ite2,detv_prec,detv_cant FROM fe_detallevta as q
				  where detv_acti='A' and detv_idau=<<np1>> order by detv_idvt
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarventasxzonas(dfi, dff, nidzona, Ccursor)
	If nidzona = 0 Then
		Text To lc Noshow Textmerge
	    SELECT descri as producto,p.unid,CAST(t.importe AS DECIMAL(12,2)) as importe,z.`zona_nomb` as zona,c.razo as cliente FROM
		(SELECT SUM(k.cant*k.prec) AS importe,idart,idcliente FROM fe_rcom  AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE fech='<<dfi>>' AND '<<dff>>'  AND r.acti='A' AND k.acti='A' GROUP BY k.idart,r.`idcliente` ) AS t
		INNER JOIN fe_clie AS c ON c.idclie=t.`idcliente`
		INNER JOIN fe_art AS p  ON p.`idart`=t.`idart`
		INNER JOIN fe_zona AS z ON z.`zona_idzo`=c.`clie_idzo` ORDER BY zona_nomb
		Endtext
	Else
		Text To lc Noshow Textmerge
	    SELECT descri as producto,p.unid,CAST(t.importe AS DECIMAL(12,2)) as importe,z.`zona_nomb` as zona,c.razo as cliente FROM
		(SELECT SUM(k.cant*k.prec) AS importe,idart,idcliente FROM fe_rcom  AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE fech='<<dfi>>' AND '<<dff>>'  AND r.acti='A' AND k.acti='A' GROUP BY k.idart,r.`idcliente` ) AS t
		INNER JOIN fe_clie AS c ON c.idclie=t.`idcliente`
		INNER JOIN fe_art AS p  ON p.`idart`=t.`idart`
		INNER JOIN fe_zona AS z ON z.`zona_idzo`=c.`clie_idzo`  where clie_idzo=<<nidzona>> ORDER BY zona_nomb
		Endtext
	Endif
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxusuario(fi, ff, nidtda, Ccursor)
	If nidtda = 0 Then
		Text To lc Noshow Textmerge
		SELECT fech,ndoc,fusua AS fechahora,u.nomb AS usuario,t.nomb AS tienda,r.idusua,if(mone='S',r.impo,r.impo*dolar) as impo FROM fe_rcom AS r
		INNER JOIN fe_clie AS c ON c.`idclie`=r.`idcliente`
		INNER JOIN fe_usua AS u  ON u.`idusua`=r.`idusua`
		INNER JOIN fe_sucu AS t ON t.`idalma`=r.`codt`
		WHERE fech between '<<fi>>' and '<<ff>>'  AND acti='A' ORDER BY u.nomb,t.nomb
		Endtext
	Else
		Text To lc Noshow Textmerge
		SELECT fech,ndoc,fusua AS fechahora,u.nomb AS usuario,t.nomb AS tienda,r.idusua,if(mone='S',r.impo,r.impo*dolar) as impo FROM fe_rcom AS r
		INNER JOIN fe_clie AS c ON c.`idclie`=r.`idcliente`
		INNER JOIN fe_usua AS u  ON u.`idusua`=r.`idusua`
		INNER JOIN fe_sucu AS t ON t.`idalma`=r.`codt`
		WHERE fech between '<<fi>>' and '<<ff>>'  AND acti='A'  and r.codt=<<nidtda>> ORDER BY u.nomb,t.nomb
		Endtext
	Endif
	If  This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizaarsolofecha(np1, np2)
	Text To lc Noshow Textmerge
	      UPDATE fe_rcom SET fech='<<np2>>' WHERE idauto=<<np1>>
	Endtext
	If This.Ejecutarsql(lc) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RentabilidadAgrupadaporproducto(fi, ff, Ccursor)

	Text To lc Noshow Textmerge
	    SELECT k.idart,p.descri,p.unid,cant,costototal,ventatotal,renta,c.dcat AS linea  FROM
       (SELECT k.idart,SUM(cant) AS cant,
	    CAST(SUM(cant*kar_cost) AS DECIMAL(12,2)) AS costoTotal,
	    CAST(SUM(cant*k.prec)  AS DECIMAL(12,2)) AS ventaTotal,
	    CAST(SUM(cant*k.prec)-SUM(cant*k.kar_cost) AS DECIMAL(12,2)) AS renta
		FROM fe_rcom AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	    WHERE r.fech BETWEEN '<<fi>>' AND '<<ff>>' AND idcliente>0 AND r.acti='A' AND k.acti='A' GROUP BY k.idart) AS k
	    INNER JOIN fe_art AS p ON p.idart=k.idart
	    INNER JOIN fe_cat AS c ON c.idcat=p.idcat  ORDER BY descri
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RentabilidadAgrupadaporlinea(fi, ff, Ccursor)

	Text To lc Noshow Textmerge
	   SELECT c.dcat AS linea,SUM(cant) AS cant,SUM(costototal) AS costototal,SUM(ventatotal) AS ventatotal,SUM(renta) AS renta  FROM
       (SELECT k.idart,SUM(cant) AS cant,
	   CAST(SUM(cant*kar_cost) AS DECIMAL(12,2)) AS costoTotal,
	   CAST(SUM(cant*k.prec)  AS DECIMAL(12,2)) AS ventaTotal,
	   CAST(SUM(cant*k.prec)-SUM(cant*k.kar_cost) AS DECIMAL(12,2)) AS renta
	   fROM fe_rcom AS r
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   WHERE r.fech BETWEEN '<<fi>>' AND '<<ff>>' AND idcliente>0 AND r.acti='A' AND k.acti='A' GROUP BY k.idart) AS k
	   INNER JOIN fe_art AS p ON p.idart=k.idart
	   INNER JOIN fe_cat AS c ON c.idcat=p.idcat  GROUP BY c.dcat  ORDER BY dcat
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenervendedorlopez(np1, Ccursor)
	Text To lc Noshow Textmerge
	SELECT nomv AS vendedor,idven,CAST(IFNULL(dctos_idau,0) as decimal) AS dctos_idau FROM fe_rvendedor AS r
	INNER JOIN fe_vend AS v ON v.idven=r.vend_codv
	LEFT JOIN (SELECT dctos_idau FROM fe_ldctos WHERE dctos_idau=<<np1>> and dctos_acti='A') AS l ON l.dctos_idau=r.vend_idau
	WHERE vend_idau=<<np1>>
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarvtas()
*:Global x
	x = validacaja(This.fecha)
	If x = "C"
		This.Cmensaje = "La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
	Select (This.temporal)
	Locate For Valida = "N"
	cndoc = Alltrim(This.serie) + Alltrim(This.numero)
	Do Case
	Case This.Codigo = 0 Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
	Case Found()
		This.Cmensaje = "Hay Un Producto que Falta Cantidad o Precio"
		Return .F.
	Case This.ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.Tdoc = "01" And !ValidaRuc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto > 700 And Len(Alltrim(This.dni)) < 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) < 3;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.fecha) <> goApp.mes Or Year(This.fecha) <> Val(goApp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto <= This.fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisión "
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, 0, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function validarvtaslopez()
*:Global x
	x = validacaja(This.fecha)
	If x = "C"
		This.Cmensaje = "La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
*	Select (This.temporal)
*Locate For Valida = "N"
	cndoc = Alltrim(This.serie) + Alltrim(This.numero)
	Do Case
	Case This.Codigo = 0 Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
*Case Found()
*	This.Cmensaje = "Hay Un Producto que Falta Cantidad o Precio"
*!*			Return .F.
	Case This.ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.Tdoc = "01" And !ValidaRuc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) <> 4;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.fecha) <> goApp.mes Or Year(This.fecha) <> Val(goApp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto <= This.fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser mayor a la fecha de Emisión "
		Return .F.
	Case This.nroformapago >= 2 And This.CreditoAutorizado = 0 And vlineacredito(This.Codigo, This.Monto, This.lineacredito) = 0
		This.Cmensaje = "LINEA DE CREDITO FUERA DE LIMITE O TIENE VENCIMIENTOS MAYORES A 30 DIAS"
		Return .F.
	Case This.tipocliente = 'm' And This.nroformapago >= 2
		This.Cmensaje = "No es Posible Efecuar esta Venta El Cliente esta Calificado Como MALO"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, 0, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Case PermiteIngresox(This.fecha) = 0
		This.Cmensaje = "Los Ingresos con esta Fecha no estan permitidos por estar Bloqueados "
		Return .F.
	Case goApp.xopcion = 0
		Do Case
		Case Substr(This.serie, 2) = '010' And This.nroformapago = 1
			This.Cmensaje = "Solo Se permiten Ventas Al Crédito Con esta Serie de Comprobantes "
			Return .F.
		Case Substr(This.serie, 2) = '010' And This.nroformapago >= 2 And goApp.nidusua <> goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA AL CRÉDITO"
			Return .F.
		Case Substr(This.serie, 2) = '010' And This.nroformapago = 1 And goApp.nidusua = goApp.nidusuavcredito
			This.Cmensaje = "Usuario NO AUTORIZADO PARA ESTA VENTA EN EFECTIVO"
			Return .F.
		Otherwise
			Return .T.
		Endcase
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function validarvtasporservicios()
	cndoc = Alltrim(This.serie) + Alltrim(This.numero)
	Do Case
	Case  PermiteIngresox(This.fecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return .F.
	Case This.vendedor = 0
		This.Cmensaje = "Seleccione Un Vendedor"
		Return .F.
	Case Left(This.rptaSunat, 1) = '0'
		This.Cmensaje = "Este Documento ya fue Informado a SUNAT"
		Return .F.
	Case This.encontrado = 'V' And TieneKardex(This.idauto) = 0
		This.Cmensaje = "Este Documento Tiene Movimientos Relacionados con el Kardex...Utilice por la Opción ACTUALIZAR VENTAS"
		Return .F.
	Case This.Codigo = 0  Or Empty(This.Codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
	Case This.ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.Tdoc = "01" And !ValidaRuc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.Tdoc = "03" And This.Monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.Monto = 0
		This.Cmensaje = "Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) < 3Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Month(This.fecha) <> goApp.mes Or Year(This.fecha) <> Val(goApp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto <= This.fecha And This.nroformapago = 2
		This.Cmensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisión "
		Return .F.
	Case This.chkdetraccion = 1 And Len(Alltrim(This.coddetraccion)) <> 3
		This.Cmensaje = "Ingrese Código de Detracción Válido"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.Tdoc, This.idauto, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function buscardctoparaplicarncndconseries(np1, Ccursor)
	Text To lc Noshow Textmerge
	   SELECT a.coda as idart,a.descri,a.unid,a.cant,a.prec,
	   ROUND(a.cant*a.prec,2) as importe,a.idauto,a.mone,a.valor,a.igv,a.impo,kar_comi as comi,alma,
	   a.fech,a.ndoc,a.tdoc,a.dolar as dola,vigv,rcom_exon,ifnull(s.seriep,"") as serieproducto,ifnull(idseriep,0) as idseriep FROM vmuestraventas as a
	   left join (SELECT rser_seri as seriep,rser_idse as idseriep,dser_idka FROM fe_rseries f
       inner join fe_dseries g on g.dser_idre=f.rser_idse
       where g.dser_acti='A' and rser_acti='A') as s ON s.dser_idka=a.idkar WHERE a.idauto=<<np1>>
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function extornarstockenventas(Ccursor)
	Set Procedure To d:\capass\modelos\productos Additive
	opro = Createobject("producto")
	This.CONTRANSACCION = 'S'
	xy = 1
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Scan All
		Text To lc Noshow Textmerge
		    UPDATE fe_kar SET alma=0 where idkar=<<dvtas.idkar>>
		Endtext
		If  This.Ejecutarsql(lc) < 1 Then
			xy = 0
			Exit
		Endif
		If opro.ActualizaStock(dvtas.idart, dvtas.alma, dvtas.cant, 'C') < 1 Then
			xy		 = 0
			Exit
		Endif
	Endscan
	If xy = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = ""
	Return 1
	Endfunc
	Function mostrarresumenventasxproducto(dfi, dff, Ccursor)
	Text To lc Noshow Textmerge
	   SELECT  a.descri,a.unid,k.cant,CAST(k.importe AS DECIMAL(12,2))AS importe,k.idart FROM
	   (SELECT idart,SUM(cant) as cant,SUM(cant*prec) as importe from fe_rcom AS r
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   WHERE r.fech between '<<dfi>>' and '<<dff>>' AND k.acti='A' and r.acti='A' and idcliente>0 group by idart) as k
	   INNER JOIN fe_art AS a ON a.idart=k.idart
	   order by descri
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleventas(np1, Ccursor)
	Text To lc Noshow Textmerge
	   SELECT  c.razo,a.descri,a.unid,k.cant,k.prec,k.idart,k.alma,r.idcliente AS idclie,r.idauto,rcom_idtr,
	   r.fech,r.valor,r.igv,r.impo,r.mone,u.nomb AS usuario,r.fusua,ndoc,idkar FROM fe_rcom AS r
	   INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   INNER JOIN fe_art AS a ON a.idart=k.idart
	   INNER JOIN fe_usua AS u  ON u.idusua=r.idusua
	   WHERE r.idauto=<<np1>> AND k.acti='A'
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarNotaCreditoVentas()
	Do Case
	Case This.Monto = 0 And  This.tiponotacredito <> '13'
		This.Cmensaje = "Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(This.serie)) < 4 Or Len(Alltrim(This.numero)) < 8;
			Or This.serie = "0000" Or Val(This.numero) = 0
		This.Cmensaje = "Falta Ingresar Correctamente el Número del  Documento"
		Return 0
	Case This.tdocref = '01' And  !'FN' $ Left(This.serie, 2) And This.Tdoc = '07'
		This.Cmensaje = "Número del  Documento NO Válido"
		Return 0
	Case This.tdocref = '01' And  !'FD' $ Left(This.serie, 2) And This.Tdoc = '08'
		This.Cmensaje = "Número del  Documento NO Válido"
		Return 0
	Case This.Codigo = 0
		This.Cmensaje = "Ingrese Un Cliente"
		Return 0
	Case (Len(Alltrim(This.nombre)) < 5 Or !ValidaRuc(This.ruc)) And This.tdocref = '01'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, RUC Válido"
		Return 0
	Case (Len(Alltrim(This.nombre)) < 5 Or Len(Alltrim(This.dni)) <> 8) And This.tdocref = '03'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, DNI Válidos"
		Return 0
	Case Year(This.fecha) <> Val(goApp.año)
		This.Cmensaje = "La Fecha No es Válida"
		Return 0
	Case  PermiteIngresox(This.fecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return 0
	Case PermiteIngresoVentas1(This.serie + This.numero, This.Tdoc, 0, This.fecha) = 0
		This.Cmensaje = "N° de Documento de Venta Ya Registrado"
		Return 0
	Case Left(This.tiponotacredito, 2) = '13' And This.agrupada = 0
		This.Cmensaje = "Tiene que seleccionar la opción  Agrupada para este documento"
		Return 0
	Case Left(This.tiponotacredito, 2) = '13' And This.Monto > 0
		This.Cmensaje = "Los Importes Deben de ser 0"
		Return 0
	Case Left(This.tiponotacredito, 2) = '13' And This.montonotacredito13 = 0
		This.Cmensaje = "Ingrese Importe para Nota Crédito Tipo 13"
		Return 0
	Case This.Tdoc = '07'
		If This.Monto > This.montoreferencia
			This.Cmensaje = "El Importe No Puede Ser Mayor al del Documento"
			Return 0
		Else
			Return 1
		Endif
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Buscarsiestaregistrado(cdcto, ctdoc)
	Text To lc Noshow Textmerge
       SELECT  idauto FROM fe_rcom WHERE ndoc='<<cdcto>>' AND tdoc='<<ctdoc>>' and acti<>'I' AND idcliente>0
	Endtext
	Ccursor = Alltrim(Sys(2015))
	If This.EjecutaConsulta (lc, (Ccursor)) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	If idauto > 0 Then
		This.Cmensaje = 'Este Documento Ya esta Registrado en la Base de Datos'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrarventaspornumerosh(df, ctdoc, Cserie, ndesde, nhasta, Ccursor)
	If ctdoc = '20' Then
		Text To lc Noshow Textmerge
	        SELECT serie,numero,ndni,razo,if(mone='S','Soles','Dólares') as mone,valor,igv,impo,idauto,fech,tdoc
		    from(select f.fech,f.tdoc,mone,
		    left(f.ndoc,3) as serie,substr(f.ndoc,4) as numero,
		    if(f.mone='S',f.valor,f.valor*f.dolar) as valor,f.rcom_exon,
		    if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,4) as unsigned) as numero1,c.ndni,c.razo,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    where f.tdoc='<<ctdoc>>' and f.fech='<<df>>'  and f.acti='A'   order by f.ndoc) as x
		    where numero1 between <<ndesde>> and <<nhasta>> and serie='<<cserie>>'
		Endtext
	Else
		Text To lc Noshow Textmerge
	        SELECT serie,numero,ndni,razo,if(mone='S','Soles','Dólares') as mone,valor,igv,impo,idauto,fech,tdoc
		    from(select f.fech,f.tdoc,mone,
		    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,
		    f.rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.ndni,c.razo,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    where f.tdoc='<<ctdoc>>' and f.fech='<<df>>'  and f.acti='A'   order by f.ndoc) as x
		    where numero1 between <<ndesde>> and <<nhasta>> and serie='<<cserie>>'
		Endtext
	Endif
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function imprimirenbloque(Calias)
	Create Cursor tmpv(Desc c(100), Unid c(20), Prec N(13, 8), cant N(10, 3), ;
		  ndoc c(10), coda N(8), Nitem N(3), cletras c(120), duni c(20), Tdoc c(2), razon c(100), Direccion c(100), ndni c(8), fech d, Impo N(8, 2), copia c(1), importe N(12, 2))
	Select rid
	Go Top
	Sw = 1
	Do While !Eof()
		Cimporte = ""
		Cimporte = Diletras(rid.Impo, 'S')
		xid = rid.idauto
		nimporte = rid.Impo
		Text To lc Noshow Textmerge
		    SELECT a.ndoc,a.fech,a.tdoc,a.impo,b.idart,
		    left(concat(trim(f.dcat),' ',substr(c.descri,instr(c.descri,',')+1),' ',substr(c.descri,1,instr(c.descri,',')-1)),150) as descri,
		    b.kar_unid as unid,b.cant,b.prec,e.razo,e.dire,e.ciud,e.ndni FROM fe_rcom as a
			inner join fe_kar as b on b.idauto=a.idauto
			inner join fe_clie as e on e.idclie=a.idcliente
			inner join fe_art as c on c.idart=b.idart
			inner join fe_cat as f on f.idcat=c.idcat
			where a.acti='A' and b.acti='A' and  a.idauto=<<rid.idauto>> order by b.idkar
		Endtext
		If This.EjecutaConsulta(lc, 'xtmpv') < 1 Then
			Sw = 0
			Exit
		Endif
		Select ndoc, fech, Tdoc, Impo, Descri As Desc, Unid As duni, cant, Prec, Razo, Dire, ciud, ndni, Cimporte As cletras, Recno() As Nitem, Unid From xtmpv Into Cursor xtmpv
		ni = 0
		Select xtmpv
		Scan All
			cndoc = xtmpv.ndoc
			ni = ni + 1
			Insert Into tmpv(ndoc, Nitem, cletras, Tdoc, fech, Desc, duni, cant, Prec, razon, Direccion, ndni, Unid, importe);
				Values(cndoc, ni, Cimporte, xtmpv.Tdoc, xtmpv.fech, xtmpv.Desc, xtmpv.duni, xtmpv.cant, xtmpv.Prec, xtmpv.Razo, Alltrim(xtmpv.Dire) + ' ' + Alltrim(xtmpv.ciud), ;
				  xtmpv.ndni, xtmpv.Unid, nimporte)
		Endscan
		Select tmpv
		For x = 1 To 17 - ni
			ni = ni + 1
			Insert Into tmpv(ndoc, Nitem, cletras, importe)Values(cndoc, ni, Cimporte, nimporte)
		Next
		Select rid
		Skip
	Enddo
	If Sw = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function generacorrelativo(cndoc, nidserie)
	Local cn As Integer
	cn = Val(Substr(cndoc, 5)) + 1
	If generacorrelativo(cn, nidserie) = 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function IngresaDocumentoElectronicocondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lc = 'FuningresaDocumentoElectronico'
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
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	Endtext
	nidf = This.EJECUTARf(lc, lp, cur)
	If nidf < 1 Then
		Return 0
	Endif
	Return nidf
	Endfunc
	Function IngresaResumenDctovtascondetraccioncondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25, np26)
	Local lc, lp
*:Global cur
	lc			  = 'FunIngresaCabeceraVtascdetraccion'
	cur			  = "Xn"
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
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	Endtext
	nidf = This.EJECUTARf(lc, lp, cur)
	If nidf < 1 Then
		Return 0
	Endif
	Return nidf
	Endfunc
	Function ActualizaResumenDctocondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24, np25)
	lc = 'ProActualizaCabeceravtas'
	cur = ""
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
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardctoparanotascreditogral(np1, Ccursor)
	Text To lc Noshow Textmerge
	   SELECT a.idart,a.descri,unid,k.cant,k.prec,k.codv,
	   ROUND(k.cant*k.prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
	   r.fech,r.ndoc,r.tdoc,r.dolar as dola,kar_cost FROM fe_rcom as r
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   WHERE r.idauto=<<np1>> and k.acti='A' order By  idkar
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarvtasresumidaspormes(ccoda, Ccursor)
	dff = cfechas(fe_gene.fech)
	dfi = cfechas(fe_gene.fech - 90)
	Text To lc Noshow Textmerge
    SELECT
	CASE nromes
	 WHEN 1 THEN 'Enero'
	 WHEN 2 THEN 'Febrero'
	 WHEN 3 THEN 'Marzo'
	 WHEN 4 THEN 'Abril'
	 WHEN 5 THEN 'Mayo'
	 WHEN 6 THEN 'Junio'
	 WHEN 7 THEN 'Julio'
	 WHEN 8 THEN 'Agosto'
	 WHEN 9 THEN 'Septiembre'
	 WHEN 10 THEN 'Octubre'
	 WHEN 11 THEN 'Noviembre'
	 ELSE 'Diciembre'
	END AS mes,
	SUM(cant) AS cant,nromes FROM(
	SELECT cant,MONTH(fech) AS nromes FROM fe_kar AS a
	INNER JOIN fe_rcom  AS c ON(c.idauto=a.idauto)
	WHERE idart=<<ccoda>>  AND c.acti='A' AND a.acti='A' AND idcliente>0 AND c.fech between '<<dfi>>' and '<<dff>>') AS xx GROUP BY mes,nromes order by nromes
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimamontoventas()
	Ccursor = 'c_' + Sys(2015)
	Text To lc Noshow Textmerge
	SELECT MAX(lcaj_fope) AS fope,lcaj_deud as monto FROM fe_lcaja WHERE lcaj_deud>0 AND lcaj_acti='A' AND lcaj_idau>0 GROUP BY lcaj_fope,lcaj_deud  ORDER BY lcaj_fope DESC LIMIT 1
	Endtext
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Select (Ccursor)
	Return Monto
	Endfunc
	Function mnostrarventasagrupdasporcantidadymes(Calias)
	fi = cfechas(This.fechai)
	ff = cfechas(This.fechaf)
	Set DataSession To This.Idsesion
	Text To lc Noshow Textmerge
	  SELECT idart,SUM(enero) AS enero,SUM(febrero) AS febrero,SUM(marzo) AS marzo,
      SUM(abril) AS abril,SUM(mayo) AS mayo,SUM(junio) AS junio,SUM(julio) AS julio,SUM(agosto) AS agosto,
      SUM(septiembre) AS septiembre,SUM(octubre) AS octubre,SUM(noviembre) AS noviembre,SUM(diciembre) AS diciembre
      FROM( 
      SELECT idart,
	  CASE mes WHEN 1 THEN cant ELSE 0 END AS enero,
	  CASE mes WHEN 2 THEN cant ELSE 0 END AS febrero,
	  CASE mes WHEN 3 THEN cant ELSE 0 END AS marzo,
	  CASE mes WHEN 4 THEN cant ELSE 0 END AS abril,
	  CASE mes WHEN 5 THEN cant ELSE 0 END AS mayo,
	  CASE mes WHEN 6 THEN cant ELSE 0 END AS junio,
	  CASE mes WHEN 7 THEN cant ELSE 0 END AS julio,
	  CASE mes WHEN 8 THEN cant ELSE 0 END AS agosto,
	  CASE mes WHEN 9 THEN cant ELSE 0 END AS septiembre,
	  CASE mes WHEN 10 THEN cant ELSE 0 END AS octubre,
	  CASE mes WHEN 11 THEN cant ELSE 0 END AS noviembre,
	  CASE mes WHEN 12 THEN cant ELSE 0 END AS diciembre
	  FROM(
	  SELECT idart,SUM(cant) AS cant,MONTH(fech) AS mes FROM fe_kar AS k
	  INNER JOIN fe_rcom AS r ON r.`idauto`= k.`idauto`
	  WHERE r.fech BETWEEN '<<fi>>' AND '<<ff>>' AND r.acti='A' AND k.`acti`='A' and r.idcliente>0
	  GROUP BY idart,mes) AS xx) AS yy GROUP BY idart ORDER BY idart
	Endtext
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxcliente(Ccursor)
	dfi = cfechas(This.fechai)
	dff = cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To  Memvar lcc Noshow
		    \Select x.fech,x.fecr,x.Tdoc,x.ndoc,x.ndo2,x.mone,x.valor,x.igv,x.Impo,x.pimpo,x.dolar As dola,x.Form,x.idauto,
			\Y.cant,Y.Prec,Round(Y.cant*Y.Prec,2)As importe,dsnc,dsnd,gast,
			\z.Descri,z.Unid,w.nomb As Usuario,x.fusua From fe_rcom x
			\inner Join fe_kar Y On Y.idauto=x.idauto
			\inner Join fe_clie T On T.idclie=x.idcliente
			\inner Join fe_usua w On w.idusua=x.idusua
			\inner Join fe_art z  On z.idart=Y.idart
			\Where x.fech Between '<<dfi>>' And '<<dff>>'
	If This.codt > 0 Then
			   \ And x.codt=<<This.codt
	Endif
	If This.Codigo > 0 Then
			\ And x.idcliente=<<This.Codigo>>
	Endif
	If This.nmarca > 0 Then
			\ And z.idmar=<<This.nmarca>>
	Endif
	Set Textmerge To
	Set Textmerge To Memvar lcc Noshow  Additive
			\ And x.Acti='A' And Y.Acti='A' Order By fech,x.Tdoc,x.ndoc
	Set Textmerge To
	Set Textmerge Off
	If This.EjecutaConsulta(lcc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Registroventaspsystr(Ccursor)

	If !Pemstatus(goApp, 'cdatos', 5) Then
		AddProperty(goApp, 'cdatos', '')
	Endif
	f1 = cfechas(This.fechai)
	f2 = cfechas(This.fechaf)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow
	   \Select a.Form,a.fecr,a.fech,a.Tdoc,If(Length(Trim(a.ndoc))<=10,Left(a.ndoc,3),Left(a.ndoc,4)) As serie,
	   \If(Length(Trim(a.ndoc))<=10,mid(a.ndoc,4,7),mid(a.ndoc,5,8)) As ndoc,
	   \b.nruc,b.ndni ,b.Razo,Round(If(mone='S',a.valor,(a.Impo*a.dolar)/a.vigv),2) As valorg,
	   \rcom_exon As exon,Cast(0 As Decimal(12,2)) As inafecta,
	   \Round(If(mone="D",Impo*dolar-(Impo*dolar)/vigv,igv),2) As igvg,
	   \Round(If(mone="D",Impo*dolar,Impo),2) As importe,
	   \Cast(a.rcom_icbper As Decimal(5,2)) As icbper,a.pimpo,a.Deta As detalle,rcom_mens As mensaje,Cast(a.dolar As Decimal(8,3))As dola,a.mone,a.idcliente As Codigo,fech As fevto,
	   \If(Tdoc='07',fech,If(Tdoc='08',fech,Cast("0001-01-01" As Date))) As fechn,
	   \If(Tdoc='07',Tdoc,If(Tdoc='08',Tdoc,' ')) As tref,
	   \If(Tdoc='07',ndoc,If(Tdoc='08',ndoc,' ')) As Refe,a.vigv,
	   \a.idauto As Auto,'A' As orden From fe_rcom As a
	   \inner Join fe_clie  As b On(b.idclie=a.idcliente)
	   \Where fecr Between '<<f1>>' And '<<f2>>'   And Tdoc In ('01','03','07','08') And Acti='A'
	If goApp.Cdatos = 'S' Then
	      \And a.codt=<<goApp.tienda>>
	Endif
	If Len(Alltrim(This.serie)) > 0 Then
	   \ And Left(a.ndoc,4)='<<this.serie>>'
	Endif
	If Len(Alltrim(This.Tdoc)) > 0 Then
    	\  And  a.Tdoc='<<this.tdoc>>'
	Endif
	   \Union All
	   \Select z.Form,z.fecr,z.fech,z.Tdoc,If(Length(Trim(z.ndoc))<=10,Left(z.ndoc,3),Left(z.ndoc,4)) As serie,
	   \If(Length(Trim(z.ndoc))<=10,mid(z.ndoc,4,7),mid(z.ndoc,5,8)) As ndoc,
	   \F.nruc,F.ndni,F.Razo,Cast(0 As Decimal(12,2)) As valorg,Cast(0 As Decimal(12,2)) As exon,Cast(0 As Decimal(12,2)) As inafecta,
	   \Cast(0 As Decimal(12,2)) As igvg,Cast(0 As Decimal(12,2)) As importe,
	   \Cast(0 As Decimal(5,2)) As  icbper,Cast(0 As Decimal(5,2)) As pimpo,' ' As detalle,z.rcom_mens As mensaje,
	   \Cast(a.dolar As Decimal(8,3)) As dola,z.mone,z.idcliente As Codigo,z.fech As fevto,Cast(a.fech As Date) As fechn,
	   \a.Tdoc As tref,a.ndoc As Refe,z.vigv,b.ncre_idau As Auto,'B' As orden
	   \From (Select ncre_idau,ncre_idan From fe_ncven As b Where  b.ncre_acti='A' Group By ncre_idau,ncre_idan) As b
	   \inner Join fe_rcom As a On a.idauto=b.ncre_idau
	   \inner Join fe_rcom As z On z.idauto=b.ncre_idan
	   \inner Join fe_clie As F On F.idclie=z.idcliente
	   \Where z.fech Between '<<f1>>' And '<<f2>>'  And z.Acti='A' And z.Tdoc In("07","08")
	   \And Left(nruc,1)<>'*'
	If goApp.Cdatos = 'S' Then
	      \And z.codt=<<goApp.tienda>>
	Endif
	If This.serie <> '' Then
	   \ And Left(a.ndoc,4)='<<this.serie>>'
	Endif
	  \ Order By serie,fech,ndoc,orden
	Set Textmerge To
	Set Textmerge Off
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxvendedorpsystr(Ccursor)
	f1 = cfechas(This.fechai)
	f2 = cfechas(This.fechaf)
	IF this.idsesion>0 then
	   SET DATASESSION TO this.idsesion
	ENDIF    
	Set Textmerge On
	Set Textmerge To Memvar lc Noshow
	\Select  a.kar_comi As comi, a.idauto, e.Tdoc, e.ndoc, e.fech, b.idart, a.cant, a.Prec, Round(a.cant * a.Prec, 2) As timporte,
	\e.Mone, a.alma, a.idart, b.idmar, c.nomv As nomb, e.Form,
	\e.vigv As igv, a.codv, e.dolar As dola, b.Descri, b.Unid, d.Razo, m.dmar As marca, d.nruc, d.ndni, b.prod_cod1 From fe_rcom As e
	\inner Join fe_clie As d  On d.idclie = e.Idcliente
	\Left Join fe_kar As a On a.idauto = e.idauto
	\Left Join fe_vend As c On c.idven = a.codv
	\Left Join fe_art As  b On b.idart = a.idart
	\Left Join fe_mar As m On m.idmar = b.idmar
	\Where e.Acti <> 'I' And a.Acti <> 'I'  And e.fech  Between '<<f1>>' And '<<f2>>'
	If This.vendedor > 0 Then
	      \ And a.codv=<<This.vendedor>>
	Endif
	      \Order By a.codv,a.idauto,e.mone
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lc, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine










