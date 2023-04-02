#Define MSGTITULO 'SISVEN'
Define Class ventas As Odata Of 'd:\capass\database\data.prg'
	fecha=Date()
	fechavto=Date()
	temporal=""
	codigo=0
	sinserie=""
	ruc=""
	tdoc=""
	dni=""
	encontrado=""
	serie=""
	numero=""
	almacen=0
	nroformapago=0
	formapago=""
	igv=0
	valor=0
	exonerado=0
	inafecta=0
	gratuita=0
	monto=0
	moneda=""
	usuario=0
	sinstock=""
	dias=0
	lineacredito=0
	rptasunat=""
	vendedor=0
	idauto=0
	creditoautorizado=0
	tipocliente=""
	tiponotacredito=""
	nombre=""
	tdocref=""
	agrupada=0
	noagrupada=0
	montoreferencia=0
	montonotacredito13=0
	detraccion=0
	coddetraccion=""
	chkdetraccion=0
	calias=""
	nroguia=""
	razon=""
	cletras=""
	hash=""
	idserie=0
	nitems=0
	nsgte=0
	archivoxml=""
	archivopdf=""
	correo=""
	idautoguia=0
	detalle=""
	iddire=0
	fechai=Date()
	fechaf=Date()
	Function mostraroventasservicios(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostraroventasserviciosconretdet(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function  mostrarotrasventas(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	        SELECT b.nruc,b.razo,b.dire,b.ciud,a.dolar,a.fech,a.fecr,a.mone,a.idauto,a.vigv,a.valor,a.igv,
	        a.impo,ndoc,a.deta,a.tcom,a.idcliente,codt,tdoc,
	        w.impo as impo1,c.nomb,w.nitem,c.ncta,w.tipo,a.form,rcom_mdet,rcom_mret,
	        w.idectas,w.idcta,a.rcom_dsct,rcom_idtr,b.clie_corr,rcom_carg,rcom_mens
	        from fe_rcom as a
	        inner join fe_ectas as w  ON w.idrven=a.idauto
	        inner join fe_plan as c on c.idcta=w.idcta
	        inner join fe_clie as b on b.idclie=a.idcliente
	        where a.idauto=<<np1>> and w.acti='A'
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obteneridventa(np1,np2,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
		    SELECT a.idauto,b.nruc FROM fe_rcom as a
		    inner JOIN fe_clie as b  on(b.idcliE=a.idcliente)
		    where a.ndoc='<<np1>>' and a.tdoc='<<np2>>' and acti<>'I'
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleotrasventas(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
				  SELECT q.detv_desc,q.detv_item,q.detv_ite1,q.detv_ite2,detv_prec,detv_cant FROM fe_detallevta as q
				  where detv_acti='A' and detv_idau=<<np1>> order by detv_idvt
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarventasxzonas(dfi,dff,nidzona,ccursor)
	If nidzona=0 Then
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT descri as producto,p.unid,CAST(t.importe AS DECIMAL(12,2)) as importe,z.`zona_nomb` as zona,c.razo as cliente FROM
		(SELECT SUM(k.cant*k.prec) AS importe,idart,idcliente FROM fe_rcom  AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE fech='<<dfi>>' AND '<<dff>>'  AND r.acti='A' AND k.acti='A' GROUP BY k.idart,r.`idcliente` ) AS t
		INNER JOIN fe_clie AS c ON c.idclie=t.`idcliente`
		INNER JOIN fe_art AS p  ON p.`idart`=t.`idart`
		INNER JOIN fe_zona AS z ON z.`zona_idzo`=c.`clie_idzo` ORDER BY zona_nomb
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT descri as producto,p.unid,CAST(t.importe AS DECIMAL(12,2)) as importe,z.`zona_nomb` as zona,c.razo as cliente FROM
		(SELECT SUM(k.cant*k.prec) AS importe,idart,idcliente FROM fe_rcom  AS r
		INNER JOIN fe_kar AS k ON k.idauto=r.idauto
		WHERE fech='<<dfi>>' AND '<<dff>>'  AND r.acti='A' AND k.acti='A' GROUP BY k.idart,r.`idcliente` ) AS t
		INNER JOIN fe_clie AS c ON c.idclie=t.`idcliente`
		INNER JOIN fe_art AS p  ON p.`idart`=t.`idart`
		INNER JOIN fe_zona AS z ON z.`zona_idzo`=c.`clie_idzo`  where clie_idzo=<<nidzona>> ORDER BY zona_nomb
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ventasxusuario(fi,ff,nidtda,ccursor)
	If nidtda=0 Then
		TEXT TO lc NOSHOW TEXTMERGE
		SELECT fech,ndoc,fusua AS fechahora,u.nomb AS usuario,t.nomb AS tienda,r.idusua,if(mone='S',r.impo,r.impo*dolar) as impo FROM fe_rcom AS r
		INNER JOIN fe_clie AS c ON c.`idclie`=r.`idcliente`
		INNER JOIN fe_usua AS u  ON u.`idusua`=r.`idusua`
		INNER JOIN fe_sucu AS t ON t.`idalma`=r.`codt`
		WHERE fech between '<<fi>>' and '<<ff>>'  AND acti='A' ORDER BY u.nomb,t.nomb
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
		SELECT fech,ndoc,fusua AS fechahora,u.nomb AS usuario,t.nomb AS tienda,r.idusua,if(mone='S',r.impo,r.impo*dolar) as impo FROM fe_rcom AS r
		INNER JOIN fe_clie AS c ON c.`idclie`=r.`idcliente`
		INNER JOIN fe_usua AS u  ON u.`idusua`=r.`idusua`
		INNER JOIN fe_sucu AS t ON t.`idalma`=r.`codt`
		WHERE fech between '<<fi>>' and '<<ff>>'  AND acti='A'  and r.codt=<<nidtda>> ORDER BY u.nomb,t.nomb
		ENDTEXT
	Endif
	If  This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizaarsolofecha(np1,np2)
	TEXT TO lc NOSHOW TEXTMERGE
	      UPDATE fe_rcom SET fech='<<np2>>' WHERE idauto=<<np1>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RentabilidadAgrupadaporproducto(fi,ff,ccursor)

	TEXT TO lc NOSHOW textmerge
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RentabilidadAgrupadaporlinea(fi,ff,ccursor)

	TEXT TO lc NOSHOW textmerge
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function obtenervendedorlopez(np1,ccursor)
	TEXT TO lc NOSHOW textmerge
	SELECT nomv AS vendedor,idven,CAST(IFNULL(dctos_idau,0) as decimal) AS dctos_idau FROM fe_rvendedor AS r
	INNER JOIN fe_vend AS v ON v.idven=r.vend_codv
	LEFT JOIN (SELECT dctos_idau FROM fe_ldctos WHERE dctos_idau=<<np1>> and dctos_acti='A') AS l ON l.dctos_idau=r.vend_idau
	WHERE vend_idau=<<np1>>
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarvtas()
*:Global x
	x = validacaja(This.fecha)
	If x = "C"
		This.Cmensaje="La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
	Select (This.temporal)
	Locate For Valida = "N"
	cndoc=Alltrim(This.serie)+Alltrim(This.numero)
	Do Case
	Case This.codigo = 0 Or Empty(This.codigo)
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
	Case This.tdoc= "01" And !validaruc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.tdoc = "03" And This.monto > 700 And Len(Alltrim(This.dni)) < 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.monto = 0
		This.Cmensaje="Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) < 3;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.fecha) <> goapp.mes Or Year(This.fecha) <> Val(goapp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto<=This.fecha And This.nroformapago=2
		This.Cmensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisión "
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.tdoc, 0, This.fecha) = 0
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
		This.Cmensaje="La caja de Esta Fecha Esta Cerrada"
		Return .F.
	Endif
*	Select (This.temporal)
*Locate For Valida = "N"
	cndoc=Alltrim(This.serie)+Alltrim(This.numero)
	Do Case
	Case This.codigo = 0 Or Empty(This.codigo)
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
	Case This.tdoc= "01" And !validaruc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.tdoc = "03" And This.monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.encontrado = "V"
		This.Cmensaje = "NO Es Posible Actualizar Este Documento El Numero del Comprobante Pertenece a uno ya Registrado"
		Return .F.
	Case This.monto = 0
		This.Cmensaje="Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) <> 4;
			Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Empty(This.almacen)
		This.Cmensaje = "Seleccione Un Almacen"
		Return .F.
	Case Month(This.fecha) <> goapp.mes Or Year(This.fecha) <> Val(goapp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto<=This.fecha And This.nroformapago=2
		This.Cmensaje = "La Fecha de Vencimiento debe ser mayor a la fecha de Emisión "
		Return .F.
	Case This.nroformapago>=2 And This.creditoautorizado=0 And vlineacredito(This.codigo ,This.monto ,This.lineacredito)=0
		This.Cmensaje="LINEA DE CREDITO FUERA DE LIMITE O TIENE VENCIMIENTOS MAYORES A 30 DIAS"
		Return .F.
	Case This.tipocliente='m' And This.nroformapago>=2
		This.Cmensaje="No es Posible Efecuar esta Venta El Cliente esta Calificado Como MALO"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.tdoc, 0, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Case permiteingresox(This.fecha)=0
		This.Cmensaje="Los Ingresos con esta Fecha no estan permitidos por estar Bloqueados "
		Return .F.
	Case goapp.xopcion=0
		Do Case
		Case Substr(This.serie,2)='010' And This.nroformapago=1
			This.Cmensaje="Solo Se permiten Ventas Al Crédito Con esta Serie de Comprobantes "
			Return .F.
		Case Substr(This.serie,2)='010' And This.nroformapago>=2 And goapp.nidusua<>goapp.nidusuavcredito
			This.Cmensaje="Usuario NO AUTORIZADO PARA ESTA VENTA AL CRÉDITO"
			Return .F.
		Case Substr(This.serie,2)='010' And This.nroformapago=1 And goapp.nidusua=goapp.nidusuavcredito
			This.Cmensaje="Usuario NO AUTORIZADO PARA ESTA VENTA EN EFECTIVO"
			Return .F.
		Otherwise
			Return .T.
		Endcase
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function validarvtasporservicios()
	cndoc=Alltrim(This.serie)+Alltrim(This.numero)
	Do Case
	Case  permiteingresox(This.fecha)=0
		This.Cmensaje="No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"
		Return .F.
	Case This.vendedor=0
		This.Cmensaje="Seleccione Un Vendedor"
		Return .F.
	Case Left(This.rptasunat,1)='0'
		This.Cmensaje="Este Documento ya fue Informado a SUNAT"
		Return .F.
	Case This.encontrado='V' And TieneKardex(This.idauto)=0
		This.Cmensaje="Este Documento Tiene Movimientos Relacionados con el Kardex...Utilice por la Opción ACTUALIZAR VENTAS"
		Return .F.
	Case This.codigo = 0  Or Empty(This.codigo)
		This.Cmensaje = "Seleccione un Cliente Para Esta Venta"
		Return .F.
	Case This.sinserie = "N"
		This.Cmensaje = "Serie NO Permitida"
		Return .F.
	Case This.ruc = "***********"
		This.Cmensaje = "Seleccione Otro Cliente"
		Return .F.
	Case This.tdoc= "01" And !validaruc(This.ruc)
		This.Cmensaje = "Ingrese RUC del Cliente"
		Return .F.
	Case This.tdoc = "03" And This.monto > 700 And Len(Alltrim(This.dni)) <> 8
		This.Cmensaje = "Ingrese DNI del Cliente "
		Return .F.
	Case This.monto = 0
		This.Cmensaje="Ingrese Cantidad y Precio"
		Return .F.
	Case This.serie = "0000" Or Val(This.numero) = 0 Or Len(Alltrim(This.serie)) < 3Or Len(Alltrim(This.numero)) < 8
		This.Cmensaje = "Ingrese Un Número de Documento Válido"
		Return .F.
	Case Month(This.fecha) <> goapp.mes Or Year(This.fecha) <> Val(goapp.año) Or !esfechaValida(This.fecha)
		This.Cmensaje = "Fecha NO Permitida Por el Sistema y/o Fecha no Válida"
		Return .F.
	Case  !esfechavalidafvto(This.fechavto)
		This.Cmensaje = "Fecha de Vencimiento no Válida"
		Return .F.
	Case This.fechavto<=This.fecha And This.nroformapago=2
		This.Cmensaje = "La Fecha de Vencimiento debe ser diferente de le fecha de Emisión "
		Return .F.
	Case This.chkdetraccion=1 And Len(Alltrim(This.coddetraccion))<>3
		This.Cmensaje="Ingrese Código de Detracción Válido"
		Return .F.
	Case PermiteIngresoVentas1(cndoc, This.tdoc, This.idauto, This.fecha) = 0
		This.Cmensaje = "Número de Documento de Venta Ya Registrado"
		Return .F.
	Otherwise
		Return .T.
	Endcase
	Endfunc
	Function buscardctoparaplicarncndconseries(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT a.coda as idart,a.descri,a.unid,a.cant,a.prec,
	   ROUND(a.cant*a.prec,2) as importe,a.idauto,a.mone,a.valor,a.igv,a.impo,kar_comi as comi,alma,
	   a.fech,a.ndoc,a.tdoc,a.dolar as dola,vigv,rcom_exon,ifnull(s.seriep,"") as serieproducto,ifnull(idseriep,0) as idseriep FROM vmuestraventas as a
	   left join (SELECT rser_seri as seriep,rser_idse as idseriep,dser_idka FROM fe_rseries f
       inner join fe_dseries g on g.dser_idre=f.rser_idse
       where g.dser_acti='A' and rser_acti='A') as s ON s.dser_idka=a.idkar WHERE a.idauto=<<np1>>
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function extornarstockenventas(ccursor)
	Set Procedure To d:\capass\modelos\productos Additive
	opro=Createobject("producto")
	This.CONTRANSACCION='S'
	xy=1
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	Select (ccursor)
	Scan All
		TEXT TO lc NOSHOW TEXTMERGE
		    UPDATE fe_kar SET alma=0 where idkar=<<dvtas.idkar>>
		ENDTEXT
		If  This.ejecutarsql(lc)<1 Then
			xy=0
			Exit
		Endif
		If opro.ActualizaStock(dvtas.idart, dvtas.alma, dvtas.cant, 'C')<1 Then
			xy		 =0
			Exit
		Endif
	Endscan
	If xy=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	This.CONTRANSACCION=""
	Return 1
	Endfunc
	Function mostrarresumenventasxproducto(dfi,dff,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT  a.descri,a.unid,k.cant,CAST(k.importe AS DECIMAL(12,2))AS importe,k.idart FROM
	   (SELECT idart,SUM(cant) as cant,SUM(cant*prec) as importe from fe_rcom AS r
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   WHERE r.fech between '<<dfi>>' and '<<dff>>' AND k.acti='A' and r.acti='A' group by idart) as k
	   INNER JOIN fe_art AS a ON a.idart=k.idart
	   order by descri
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleventas(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT  c.razo,a.descri,a.unid,k.cant,k.prec,k.idart,k.alma,r.idcliente AS idclie,r.idauto,rcom_idtr,
	   r.fech,r.valor,r.igv,r.impo,r.mone,u.nomb AS usuario,r.fusua,ndoc,idkar FROM fe_rcom AS r
	   INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	   INNER JOIN fe_kar AS k ON k.idauto=r.idauto
	   INNER JOIN fe_art AS a ON a.idart=k.idart
	   INNER JOIN fe_usua AS u  ON u.idusua=r.idusua
	   WHERE r.idauto=<<np1>> AND k.acti='A'
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ValidarNotaCreditoVentas()
	Do Case
	Case This.monto = 0 And  This.tiponotacredito <> '13'

		This.Cmensaje = "Importes Deben de Ser Diferente de Cero"
		Return 0
	Case Len(Alltrim(This.serie)) < 4 Or Len(Alltrim(This.numero)) < 8;
			OR This.serie = "0000" Or Val(This.numero) = 0
		This.Cmensaje = "Falta Ingresar Correctamente el Número del  Documento"

		Return 0
	Case This.tdocref = '01' And  !'FN' $ Left(This.serie,2)
		This.Cmensaje = "Número del  Documento NO Válido"

		Return 0
	Case This.codigo=0
		This.Cmensaje = "Ingrese Un Cliente"

		Return 0
	Case (Len(Alltrim(This.nombre)) < 5 Or !validaruc(This.ruc)) And This.tdocref = '01'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, RUC Válido"

		Return 0
	Case (Len(Alltrim(This.nombre)) < 5 Or Len(Alltrim(This.dni)) <> 8) And This.tdocref = '03'
		This.Cmensaje = "Es Necesario Ingresar el Nombre Completo de Cliente, DNI Válidos"

		Return 0
	Case Year(This.fecha) <> Val(goapp.año)
		This.Cmensaje = "La Fecha No es Válida"

		Return 0
	Case  permiteingresox(This.fecha) = 0
		This.Cmensaje = "No Es posible Registrar en esta Fecha estan bloqueados Los Ingresos"

		Return 0
	Case PermiteIngresoVentas1(This.serie +This.numero, This.tdoc, 0, This.fecha) = 0
		This.Cmensaje = "N° de Documento de Venta Ya Registrado"

		Return 0
	Case Left(This.tiponotacredito, 2) = '13' And This.agrupada = 0
		This.Cmensaje = "Tiene que seleccionar la opción  Agrupada para este documento"
		Return 0
	Case Left(This.tiponotacredito, 2) = '13' And This.monto > 0
		This.Cmensaje = "Los Importes Deben de ser 0"

		Return 0
	Case Left(This.tiponotacredito, 2) = '13' And This.montonotacredito13 = 0
		This.Cmensaje = "Ingrese Importe para Nota Crédito Tipo 13"

		Return 0
	Case This.tdoc ='07'

		If This.monto >This.montoreferencia
			This.Cmensaje = "El Importe No Puede Ser Mayor al del Documento"
			Return 0
		Else
			Return 1
		Endif
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Buscarsiestaregistrado(cdcto,ctdoc)
	TEXT TO lc NOSHOW TEXTMERGE
       SELECT  idauto FROM fe_rcom WHERE ndoc='<<cdcto>>' AND tdoc='<<ctdoc>>' and acti<>'I' AND idcliente>0
	ENDTEXT
	ccursor=Alltrim(Sys(2015))
	If This.EjecutaConsulta (lc,(ccursor))<1 Then
		Return 0
	Endif
	Select (ccursor)
	If idauto>0 Then
		This.Cmensaje='Este Documento Ya esta Registrado en la Base de Datos'
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrarventaspornumerosh(df,ctdoc,cserie,ndesde,nhasta,ccursor)
	If ctdoc='20' Then
		TEXT TO lc NOSHOW textmerge
	        SELECT serie,numero,ndni,razo,if(mone='S','Soles','Dólares') as mone,valor,igv,impo,idauto,fech,tdoc
		    from(select f.fech,f.tdoc,mone,
		    left(f.ndoc,3) as serie,substr(f.ndoc,4) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,f.rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,4) as unsigned) as numero1,c.ndni,c.razo,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    where f.tdoc='<<ctdoc>>' and f.fech='<<df>>'  and f.acti='A'   order by f.ndoc) as x
		    where numero1 between <<ndesde>> and <<nhasta>> and serie='<<cserie>>'
		ENDTEXT
	Else
		TEXT TO lc NOSHOW textmerge
	        SELECT serie,numero,ndni,razo,if(mone='S','Soles','Dólares') as mone,valor,igv,impo,idauto,fech,tdoc
		    from(select f.fech,f.tdoc,mone,
		    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,f.rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
		    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.ndni,c.razo,f.idauto
	     	fROM fe_rcom f
	     	inner join fe_clie as c on c.idclie=f.idcliente
		    where f.tdoc='<<ctdoc>>' and f.fech='<<df>>'  and f.acti='A'   order by f.ndoc) as x
		    where numero1 between <<ndesde>> and <<nhasta>> and serie='<<cserie>>'
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function imprimirenbloque(calias)
	Create Cursor tmpv(Desc c(100),unid c(20),Prec N(13,8),cant N(10,3),;
		ndoc c(10),coda N(8),nitem N(3),cletras c(120),duni c(20),tdoc c(2),razon c(100),Direccion c(100),ndni c(8),fech d,Impo N(8,2),copia c(1),importe N(12,2))
	Select rid
	Go Top
	sw=1
	Do While !Eof()
		cimporte=""
		cimporte=Diletras(rid.Impo,'S')
		xid=rid.idauto
		nimporte=rid.Impo
		TEXT TO lc NOSHOW TEXTMERGE
		    SELECT a.ndoc,a.fech,a.tdoc,a.impo,b.idart,
		    left(concat(trim(f.dcat),' ',substr(c.descri,instr(c.descri,',')+1),' ',substr(c.descri,1,instr(c.descri,',')-1)),150) as descri,
		    b.kar_unid as unid,b.cant,b.prec,e.razo,e.dire,e.ciud,e.ndni FROM fe_rcom as a
			inner join fe_kar as b on b.idauto=a.idauto
			inner join fe_clie as e on e.idclie=a.idcliente
			inner join fe_art as c on c.idart=b.idart
			inner join fe_cat as f on f.idcat=c.idcat
			where a.acti='A' and b.acti='A' and  a.idauto=<<rid.idauto>> order by b.idkar
		ENDTEXT
		If This.EjecutaConsulta(lc,'xtmpv') <1 Then
			sw=0
			Exit
		Endif
		Select ndoc,fech,tdoc,Impo,Descri As Desc,unid As duni,cant,Prec,razo,Dire,ciud,ndni,cimporte As cletras,Recno() As nitem,unid From xtmpv Into Cursor xtmpv
		ni=0
		Select xtmpv
		Scan All
			cndoc=xtmpv.ndoc
			ni=ni+1
			Insert Into tmpv(ndoc,nitem,cletras,tdoc,fech,Desc,duni,cant,Prec,razon,Direccion,ndni,unid,importe);
				Values(cndoc,ni,cimporte,xtmpv.tdoc,xtmpv.fech,xtmpv.Desc,xtmpv.duni,xtmpv.cant,xtmpv.Prec,xtmpv.razo,Alltrim(xtmpv.Dire)+' '+Alltrim(xtmpv.ciud),;
				xtmpv.ndni,xtmpv.unid,nimporte)
		Endscan
		Select tmpv
		For x=1 To 17-ni
			ni=ni+1
			Insert Into tmpv(ndoc,nitem,cletras,importe)Values(cndoc,ni,cimporte,nimporte)
		Next
		Select rid
		Skip
	Enddo
	If sw=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function generacorrelativo(cndoc,nidserie)
	Local cn As Integer
	cn=Val(Substr(cndoc,5))+1
	If generacorrelativo(cn,nidserie)=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function IngresaDocumentoElectronicocondirecciones(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
	lc='FuningresaDocumentoElectronico'
	cur="Xn"
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	goapp.npara25=np25
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	nidf=This.EJECUTARF(lc,lp,cur)
	If nidf<1 Then
		Return 0
	Endif
	Return nidf
	Endfunc
	Function IngresaResumenDctovtascondetraccioncondirecciones(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15, np16, np17, np18, np19, np20, np21, np22, np23, np24,np25,np26)
	Local lc, lp
*:Global cur
	lc			  = 'FunIngresaCabeceraVtascdetraccion'
	cur			  = "Xn"
	goapp.npara1  = np1
	goapp.npara2  = np2
	goapp.npara3  = np3
	goapp.npara4  = np4
	goapp.npara5  = np5
	goapp.npara6  = np6
	goapp.npara7  = np7
	goapp.npara8  = np8
	goapp.npara9  = np9
	goapp.npara10 = np10
	goapp.npara11 = np11
	goapp.npara12 = np12
	goapp.npara13 = np13
	goapp.npara14 = np14
	goapp.npara15 = np15
	goapp.npara16 = np16
	goapp.npara17 = np17
	goapp.npara18 = np18
	goapp.npara19 = np19
	goapp.npara20 = np20
	goapp.npara21 = np21
	goapp.npara22 = np22
	goapp.npara23 = np23
	goapp.npara24 = np24
	goapp.npara25 = np25
	goapp.npara26 = np26
	TEXT To lp Noshow
    (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	ENDTEXT
	nidf=This.EJECUTARF(lc, lp, cur)
	If nidf< 1 Then
		Return 0
	Endif
	Return nidf
	Endfunc
	Function ActualizaResumenDctocondirecciones(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
	lc='ProActualizaCabeceravtas'
	cur=""
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	goapp.npara25=np25
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardctoparanotascreditogral(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT a.idart,a.descri,unid,k.cant,k.prec,k.codv,
	   ROUND(k.cant*k.prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,
	   r.fech,r.ndoc,r.tdoc,r.dolar as dola,kar_cost FROM fe_rcom as r
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   WHERE r.idauto=<<np1>> and k.acti='A' order By  idkar
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrarvtasresumidaspormes(ccoda,ccursor)
	dff=cfechas(fe_gene.fech)
	dfi=cfechas(fe_gene.fech-90)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimamontoventas()
	ccursor='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT MAX(lcaj_fope) AS fope,lcaj_deud as monto FROM fe_lcaja WHERE lcaj_deud>0 AND lcaj_acti='A' AND lcaj_idau>0 GROUP BY lcaj_fope,lcaj_deud  ORDER BY lcaj_fope DESC LIMIT 1
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	Return monto
	Endfunc
	Function mnostrarventasagrupdasporcantidadymes(calias)
	fi=cfechas(This.fechai)
	ff=cfechas(This.fechaf)
	Set DataSession To This.idsesion
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc

Enddefine
