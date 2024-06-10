Define Class ventasneuma As Ventas  Of 'd:\capass\modelos\ventas.prg'
	Function registrarxservicios()
	Set Procedure To d:\capass\modelos\correlativos,capadatos,rnneumaticos Additive
	ocorr = Createobject("correlativo")
	If This.IniciaTransaccion() < 1  Then
		Return 0
	Endif
	NAuto = IngresaResumenDctovtascondetraccion(This.Tdoc, Left(This.formaPago, 1), This.Serie + This.numero, This.Fecha, This.Fecha, ;
		  This.Detalle, This.valor, This.igv, This.Monto, '', Left(This.Moneda, 1), ;
		  This.ndolar, This.vigv, 'S', This.Codigo, "D", goApp.nidusua, This.Vendedor, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, This.detraccion, This.coddetraccion)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.Concaja = 1
		If Left(This.formaPago, 1) = "E"
			cconcepto = This.Tdoc + "E"
		Else
			If  Left(This.formaPago, 1) = "D"
				cconcepto = "XT" + "C"
			Else
				cconcepto = This.Tdoc + "C"
			Endif
		Endif
	Else
		cconcepto = "XTC"
	Endif
	nidcon = RetConcepto(cconcepto, 'I')
	If (Left(This.formaPago, 1) = 'C' Or Left(This.formaPago, 1) = 'F')
		xcr = RegistraCreditosNeumaticos(NAuto, This.Serie + This.numero, Left(This.Moneda, 1), This.Fecha, This.Monto, This.ndolar, This.Vendedor)
		If xcr.Vdvto = 0
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If IngresaCaja(NAuto, This.Fecha, This.Monto, 'I', Left(This.formaPago, 1), Left(This.Moneda, 1), This.Serie + This.numero, nidcon, goApp.nidusua, This.Detallecaja, 'CK', 0, Left(This.Moneda, 1), This.ndolar, goApp.Tienda, '', 0, 1) < 1
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpv
	Go Top
	Scan All
		If IngresaDetalleVTaCunidad(tmpv.Desc, tmpv.Nitem, tmpv.nitem1, tmpv.nitem2, NAuto, tmpv.Prec, tmpv.cant, tmpv.Unid) = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	ocorr.Idserie = This.Idserie
	ocorr.Nsgte = This.Nsgte
	If ocorr.GeneraCorrelativo1() < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	If This.GRabarCambios() < 1  Then
		Return 0
	Endif
	Return NAuto
	Endfunc
	Function actualizarxservicios()
	cndoc = This.Serie + This.numero
	If This.IniciaTransaccion() < 1  Then
		Return 0
	Endif
	If ActualizaResumenDctovtascondetraccion(This.Tdoc, Left(This.formapagoPago, 1), cndoc, This.Fecha, This.Fecha, This.Detalle, This.valor, This.igv, This.Monto, "", Left(This.Moneda, 1), ;
			  This.ndolar, This.vigv, 'S', This.Codigo, "V", goApp.nidusua, This.Vendedor, This.codt, This.cta1, This.cta2, This.cta3, This.exonerado, 0, This.detraccion, This.Idauto, This.coddetraccion) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif

	If ActualizaCreditos(This.Idauto, goApp.nidusua) = 0
		This.DEshacerCambios()
		Return 0
	Endif
	If IngresaDatosLCajaEFectivo12(This.Fecha, "", This.clienteseleccionado, This.cta3, This.Monto, 0, 'S', fe_gene.dola, goApp.nidusua, This.Codigo, This.Idauto, Left(This.formapagoPago, 1), This.Serie + This.numero, This.Tdoc, goApp.Tienda) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If Left(This.formaPago, 1) = 'C' Then
		Vdvto = IngresaCreditosNormal(This.Idauto, This.Codigo, This.Serie + This.numero, 'C', Left(This.Moneda, 1), This.Detalle, This.Fecha, This.Fechavto, Left(This.tipodcto, 1), This.Serie + This.numero, This.Monto, 0, This.Vendedor, This.Monto, goApp.nidusua, This.codt, Id())
		If Vdvto < 0 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If ActualizaDetalleVTa(This.Idauto) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpv
	Go Top
	Scan All
		If IngresaDetalleVTaCunidad(tmpv.Desc, tmpv.Nitem, tmpv.nitem1, tmpv.nitem2, This.Idauto, tmpv.Prec, tmpv.cant, tmpv.Unid) = 0 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If  Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarvtasxreimprimir(Ccursor)
	Do Case
	Case This.Tdoc = '01' Or this.tdoc = '03' Or This.Tdoc = '00'
		If  Vartype(This.ctipovta) = 'C' Then
			cx = This.ctipovta
		Endif
		If cx = 'S' Then
			Text To lC Noshow Textmerge
			    select 23 AS codv,c.idauto,detv_idvt AS idart,detv_cant as cant,detv_prec AS prec,c.codt AS alma,
          		c.tdoc AS tdoc1,CAST(0 AS DECIMAL(5,2)) AS costo,
			    c.ndoc AS dcto,c.fech AS fech1,c.vigv,IFNULL(p.fevto,c.fech) AS fvto,
			    c.fech,c.fecr,c.form,c.rcom_exon,c.ndo2,c.idcliente,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
          		c.pimpo,u.nomb AS usuario,c.deta,c.tcom AS tipovta,
			    c.tdoc,c.ndoc,c.dolar AS dola,c.mone,m.detv_desc AS descri,detv_unid AS Unid,
          		c.rcom_hash,'Oficina' AS nomv,c.valor,c.rcom_otro AS gratuita,c.igv,c.impo,c.rcom_arch,IFNULL(x.dpto_nomb,'') AS dpto,d.clie_dist AS distrito,
          		c.rcom_mdet,c.rcom_detr,tipom
          		FROM fe_rcom as c
          		inner join fe_clie as d on(d.idclie=c.idcliente)
			    inner join fe_usua as u on u.idusua=c.idusua
			    inner join fe_detallevta as m on m.detv_idau=c.idauto
			    left join (select idauto,min(c.fevto) as fevto from fe_cred as c where acti='A' and idauto=<<this.idauto>> group by idauto) as p on p.idauto=c.idauto
			    left join fe_dpto as x on x.dpto_idpt=d.clie_idpt
            	where c.idauto=<<this.idauto>> and  detv_Acti='A' order by detv_ite1
			Endtext
		Else
			Text To lC Noshow Textmerge
			    select a.codv,a.idauto,a.alma,a.idkar,a.idauto,a.idart,a.cant,ifnull(a.prec,CAST(0 as decimal(12,5))) as prec,a.alma,c.tdoc as tdoc1,
			    c.ndoc as dcto,c.fech as fech1,rcom_arch,a.kar_cost as costo,ifnull(p.fevto,c.fech) as fvto,
			    c.fech,c.fecr,c.form,c.deta,c.exon,c.ndo2,a.idclie,d.razo,d.nruc,d.dire,d.ciud,d.ndni,
			    c.pimpo,ifnull(x.dpto_nomb,'') as dpto,d.clie_dist as distrito,
			    c.tdoc,c.ndoc,a.dola,c.mone,b.descri,b.unid,c.rcom_hash,v.nomv,c.valor,c.rcom_otro As gratuita,c.igv,c.impo,c.tcom AS tipovta,
			    c.rcom_mdet,c.rcom_detr,c.tipom
			    FROM fe_rcom  as c
			    inner join fe_kar as a on a.idauto=c.idauto
			    inner join fe_art as b on b.idart=a.idart
			    inner join fe_vend as v on v.idven=a.codv
			    inner join fe_clie as d on c.idcliente=d.idclie
			    left join fe_dpto as x on x.dpto_idpt=d.clie_idpt
			    left join (select idauto,min(c.fevto) as fevto from fe_cred as c where acti='A' and idauto=<<this.idauto>> group by idauto) as p on p.idauto=c.idauto
			    where c.idauto=<<this.idauto>> and a.acti='A';
			Endtext
		Endif
	Case This.Tdoc = '08'
		Text To lC Noshow Textmerge
			   select  r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,ifnull(x.dpto_nomb,'') as dpto,c.clie_dist as distrito,
		       abs(r.valor) as valor,ABS(r.rcom_otro) as gratuita,abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(kar_cost,CAST(0 as decimal(12,5))) as costo,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,f.ndoc as dcto,
		       f.fech as fech1,w.tdoc as tdoc1,rcom_hash,rcom_arch,r.fech as fvto,'' as tipovta,
		       r.rcom_mdet,r.rcom_detr,r.tipom
		       from fe_rcom r
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto 
		       left join fe_art a on a.idart=k.idart
		       inner join fe_rven as rv on rv.idauto=r.idauto
		       inner join fe_refe f on f.idrven=rv.idrven
		       inner join fe_tdoc as w on w.idtdoc=f.idtdoc
		       left join fe_dpto as x on x.dpto_idpt=c.clie_idpt
		       where r.idauto=<<this.idauto>> and r.acti='A' and r.tdoc='08'
		Endtext
	Case This.Tdoc = '07'
		Text To lC Noshow Textmerge
			   select r.idauto,r.ndoc,r.tdoc,r.fech,r.mone,r.ndo2,
		       r.vigv,c.nruc,c.razo,c.dire,c.ciud,c.ndni,' ' as nomv,r.form,ifnull(x.dpto_nomb,'') as dpto,c.clie_dist as distrito,
		       abs(r.valor) as valor,ABS(r.rcom_otro) as gratuita,abs(r.igv) as igv,abs(r.impo) as impo,ifnull(k.cant,CAST(0 as decimal(12,2))) as cant,
		       ifnull(kar_cost,CAST(0 as decimal(12,5))) as costo,
		       ifnull(k.prec,ABS(r.impo)) as prec,LEFT(r.ndoc,4) as serie,SUBSTR(r.ndoc,5) as numero,
		       ifnull(a.unid,'') as unid,ifnull(a.descri,r.deta) as descri,r.deta,ifnull(k.idart,CAST(0 as decimal(8))) as idart,f.ndoc as dcto,
		       f.fech as fech1,w.tdoc as tdoc1,rcom_hash,rcom_arch,r.fech as fvto,'' As tipovta,
		       r.rcom_mdet,r.rcom_detr,r.tipom
		       from fe_rcom r
		       inner join fe_clie c on c.idclie=r.idcliente
		       left join fe_kar k on k.idauto=r.idauto
		       left join fe_art a on a.idart=k.idart
		       inner join fe_rven as rv on rv.idauto=r.idauto
		       inner join fe_refe f on f.idrven=rv.idrven
		       inner join fe_tdoc as w on w.idtdoc=f.idtdoc
		       left join fe_dpto as x on x.dpto_idpt=c.clie_idpt
		       where r.idauto=<<this.idauto>> and r.acti='A' and r.tdoc='07'
		Endtext
	Endcase
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine







