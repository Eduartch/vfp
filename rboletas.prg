Define Class Rboletas As Odata Of 'd:\capass\database\data.prg'
	todos=0
	ctdoc=""
	cserie=""
	ndesde=0
	nhasta=0
	Function ConsultaBoletasyNotasporenviar(f1, f2)
	Local lc
	TEXT To lc Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  resu_fech between '<<f1>>' and '<<f2>>' and f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
	ENDTEXT
	If  This.EjecutaConsulta(lc, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket10(np1)

	Endfunc
	Function ConsultaBoletasyNotasporenviarsinfechas()
	Local lc
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("cdatos", "")
	Endif
	If goapp.cdatos = 'S' Then
		TEXT To lc Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  f.resu_acti='A' AND LEFT(resu_mens,1)='0' and resu_codt=<<goapp.tienda>>
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE   f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0 and f.codt=<<goapp.tienda>>
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 and f.codt=<<goapp.tienda>>) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
		ENDTEXT
	Else
		TEXT To lc Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE   f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function solounticketenvio(df,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	    select resu_tick FROM fe_resboletas f
        where f.resu_acti='A' and (LEFT(resu_mens,1)<>'0' OR ISNULL(resu_mens)) and resu_fech='<<df>>' and length(TRIM(resu_tick))>0 limit 1
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrardetalleboletasxenviarurl(df,ccursor)
	TEXT TO lc NOSHOW textmerge
	SELECT tdoc,ndoc,fech,impo,idauto FROM fe_rcom WHERE tdoc='03' AND acti='A' AND idcliente>0 AND fech='<<df>>'
	UNION ALL
	SELECT f.tdoc,f.ndoc,f.fech,f.impo,f.idauto FROM fe_rcom  AS f
	INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
	INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
	WHERE f.tdoc="07"  AND f.acti='A' AND f.idcliente>0 AND w.tdoc='03' AND f.fech='<<df>>'
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultaApisunat1(cndoc,ctdoc,dfechae,cticket,nidauto,nimpo)
	Local oHTTP As "MSXML2.XMLHTTP"
	pURL_WSDL = "http://compania-sysven.com/apisunat1.php"
	If Type('oempresa') = 'U' Then
		cruc = fe_gene.nruc
	Else
		cruc = oempresa.nruc
	Endif
	TEXT To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"ndoc":"<<cndoc>>",
	"tdoc":"<<ctdoc>>",
	"fech":"<<dfechae>>",
	"impo":"<<nimpo>>",
	"ticket":"<<cticket>>",
	"idauto":"<<nidauto>>"
	}
	ENDTEXT
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", pURL_WSDL, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	lcHTML = oHTTP.responseText
	Mensaje(lcHTML)
	If oHTTP.Status <> 200 Then
		This.Cmensaje="Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultardesdeurl
	Lparameters fi,ff,cruc
	Local loXmlHttp As "Microsoft.XMLHTTP"
	Local lcHTML, lcURL, ls_compra, ls_venta
*:Global cmensaje, cndoc, cticket, dfecha, nidauto
*:Global cdata, d, fecha, ff, fi, i, otc, ovalor, x
	Set Procedure To d:\librerias\json Additive
	m.lcURL		= "http://compania-sysven.com/app88/apisunat20.php"
	m.loXmlHttp	= Createobject("Microsoft.XMLHTTP")
	TEXT To cdata Noshow Textmerge
	{
	"fi":"<<fi>>",
	"ff":"<<ff>>",
	"ruc":"<<cruc>>"
	}
	ENDTEXT
	m.loXmlHttp.Open('POST', m.lcURL, .F.)
	m.loXmlHttp.setRequestHeader("Content-Type", "application/json")
	m.loXmlHttp.Send(cdata)
	If m.loXmlHttp.Status <> 200 Then
		This.Cmensaje="Servicio WEB NO Disponible....." + Alltrim(Str(m.loXmlHttp.Status))
		Return 0
	Endif
	m.lcHTML = m.loXmlHttp.responseText
	If Atc('idauto', m.lcHTML) > 0 Then
		otc = json_decode(m.lcHTML)
		If Not Empty(json_getErrorMsg())
			This.Cmensaje="No se Pudo Obtener la Información " + json_getErrorMsg()
			Return 0
		Endif
		x=1
		Create Cursor boletas(idauto N(10),ndoc c(12),fech d,Mensaje c(50),ticket c(30),importe N(12,2))
		For i = 1 To otc._Data.getSize()
			ovalor=otc._Data.Get(x)
			If (Vartype(ovalor) = 'O') Then
				nidauto	 = Val(ovalor.Get("idauto"))
				dFecha	 = ovalor.Get("fech")
				cndoc	 = ovalor.Get('ndoc')
				Cmensaje = ovalor.Get("mensaje")
				cticket	 = ovalor.Get("ticket")
				df=Ctod(Right(dFecha,2)+'/'+Substr(dFecha,6,2)+'/'+Left(dFecha,4))
				Insert Into boletas(idauto,ndoc,fech,Mensaje,ticket)Values(nidauto,cndoc,df,Cmensaje,cticket)
			Endif
			x=x+1
		Next
		Return 1
	Else
		This.Cmensaje="No hay Infornacíon Para Consultar"
		Return 0
	Endif
	Endfunc
	Function Actualizarbxbresumendesdeurl()
	sw=1
	This.CONTRANSACCION='S'
	If This.IniciaTransaccion()=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select boletas
	Go Top
	Do While !Eof()
		cticket=boletas.ticket
		totenvio=0
		Select boletas
		Do While !Eof() And Trim(boletas.ticket)=Trim(cticket)
*totenvio=totenvio+boletas.importe
			Cmensaje=boletas.Mensaje
*	Wait Window cticket
			TEXT TO lc NOSHOW textmerge
	           UPDATE fe_rcom SET rcom_mens='<<boletas.mensaje>>',rcom_fecd=curdate() WHERE idauto=<<boletas.idauto>>
			ENDTEXT
			If This.ejecutarsql(lc)<1 Then
				sw=0
				Exit
			Endif
			Select boletas
			Skip
		Enddo
		If sw=0 Then
			Exit
		Endif
		TEXT TO lcc NOSHOW TEXTMERGE
		  UPDATE fe_resboletas SET resu_mens='<<cmensaje>>',resu_feen=curdate() WHERE resu_tick='<<cticket>>'
		ENDTEXT
		If This.ejecutarsql(lcc)<1 Then
			sw=0
			Exit
		Endif
		Select boletas
	Enddo
	If sw=1 Then
		This.GrabarCambios()
		This.CONTRANSACCION=""
		Return 1
	Else
		This.DeshacerCambios()
		This.CONTRANSACCION=""
		Return 0
	Endif
	Endfunc
	Function  EnviarBoletasiNotas(df)
	Local ocomp As "comprobante"
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("cdatos", "")
	Endif

	datosGlobales()
	Set Classlib To d:\librerias\fe.vcx Additive
	ocomp = Createobject("comprobante")
	F	  = cfechas(df)
	dFecha = Date()
	If goapp.cdatos = 'S' Then
		nidt = goapp.Tienda
		TEXT To lc Noshow Textmerge
		SELECT fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f inner join fe_clie c on c.idclie=f.idcliente
		where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.codt=<<nidt>> and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>> and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>> and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0
		ENDTEXT
		If This.EjecutaConsulta(lc, "rboletas") < 1 Then
			Return 0
		Endif
		TEXT To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and f.codt=<<nidt>> and LEFT(f.rcom_mens,1)<>'0' order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  and f.codt=<<nidt>> and LEFT(f.rcom_mens,1)<>'0'  and f.impo<>0 order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>> and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0 order by f.ndoc) as x group by serie
		ENDTEXT
	Else
		TEXT To lc Noshow Textmerge
		SELECT fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f
		inner join fe_clie c on c.idclie=f.idcliente
		where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and LEFT(f.rcom_mens,1)<>'0' and f.impo<>0
		ENDTEXT
		If This.EjecutaConsulta(lc, "rboletas") < 1 Then
			Return 0
		Endif
		TEXT To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(f.rcom_mens,1)<>'0' order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and LEFT(f.rcom_mens,1)<>'0' order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and LEFT(f.rcom_mens,1)<>'0' order by f.ndoc) as x group by serie
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lcx, "rb1") < 1 Then
		Return 0
	Endif

	Select tdoc, serie, desde, hasta, valor, Exon, ;
		000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, df As fech;
		From rb1 Into Cursor curb


	Select fech, tdoc, serie, numero, tipodoc, ndni, valor, rcom_exon As Exon, ;
		000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, trefe, serieref, numerorefe, idauto;
		From Rboletas Into Cursor crb


	Select crb
	ocomp.itemsdocumentos = Reccount()
	tr					  = ocomp.itemsdocumentos
	If tr = 0 Then
		This.Cmensaje="No Hay Boletas Por enviar"
		Return 0
	Endif
	ocomp.fechadocumentos = Alltrim(Str(Year(df))) + '-' + Iif(Month(df) <= 9, '0' + Alltrim(Str(Month(df))), Alltrim(Str(Month(df)))) + '-' + Iif(Day(df) <= 9, '0' + Alltrim(Str(Day(df))), Alltrim(Str(Day(df))))
	cnombreArchivo		  = Alltrim(Str(Year(dFecha))) + Iif(Month(dFecha) <= 9, '0' + Alltrim(Str(Month(dFecha))), Alltrim(Str(Month(dFecha)))) + Iif(Day(dFecha) <= 9, '0' + Alltrim(Str(Day(dFecha))), Alltrim(Str(Day(dFecha))))
	ocomp.Moneda		  = 'PEN'
	ocomp.tigv			  = '10'
	ocomp.vigv			  = '18'
	ocomp.fechaemision	  = Alltrim(Str(Year(dFecha))) + '-' + Iif(Month(dFecha) <= 9, '0' + Alltrim(Str(Month(dFecha))), Alltrim(Str(Month(dFecha)))) + '-' + Iif(Day(dFecha) <= 9, '0' + Alltrim(Str(Day(dFecha))), Alltrim(Str(Day(dFecha))))
	If Type('oempresa') = 'U' Then
		ocomp.rucfirma			 = fe_gene.rucfirmad
		ocomp.nombrefirmadigital = fe_gene.razonfirmad
		ocomp.rucemisor			 = fe_gene.nruc
		ocomp.razonsocialempresa = fe_gene.empresa
		ocomp.ubigeo			 = fe_gene.ubigeo
		ocomp.direccionempresa	 = fe_gene.ptop
		ocomp.ciudademisor		 = fe_gene.ciudad
		ocomp.distritoemisor	 = fe_gene.distrito
		cnruc					 = fe_gene.nruc
	Else
		ocomp.rucfirma			 = oempresa.rucfirmad
		ocomp.nombrefirmadigital = oempresa.razonfirmad
		ocomp.rucemisor			 = oempresa.nruc
		ocomp.razonsocialempresa = oempresa.empresa
		ocomp.ubigeo			 = oempresa.ubigeo
		ocomp.direccionempresa	 = oempresa.ptop
		ocomp.ciudademisor		 = oempresa.ciudad
		ocomp.distritoemisor	 = oempresa.distrito
*	nres					 = oempresa.gene_nres
		cnruc					 = oempresa.nruc
	Endif
	nres					 = fe_gene.gene_nres
	ocomp.pais = 'PE'
	Dimension ocomp.ItemsFacturas[tr, 16]
	i  = 0
	ta = 1
	Select crb
	Scan All
		i						   = i + 1
		ocomp.ItemsFacturas[i, 1]  = crb.tdoc
		ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.serie) + '-' + Alltrim(Str(Val(crb.numero)))
		ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
		ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
		ocomp.ItemsFacturas[i, 5]  = crb.trefe
		ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
		ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
		ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
		ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
		ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
		ocomp.ItemsFacturas[i, 11] = "0.00"
		ocomp.ItemsFacturas[i, 12] = "0.00"
		ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
		ocomp.ItemsFacturas[i, 14] = "0.00"
		ocomp.ItemsFacturas[i, 15] = "0.00"
		ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
	Endscan

	cpropiedad = "Firmarcondll"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("Firmarcondll", "")
	Endif
	cpropiedad = "multiempresa"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("multiempresa", "")
	Endif
	ocomp.cmulti = goapp.multiempresa
	ocomp.FirmarconDLL = goapp.FirmarconDLL
	If nres=0 Then
		If generaCorrelativoEnvioResumenBoletas() = 0 Then
			This.Cmensaje="No se Grabo el Corretalivo de Envio de Resumen de Boletas"
			Return 0
		Endif
		datosGlobales()
		nres=fe_gene.gene_nres
	Endif
	cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
	If ocomp.generaxmlrboletas(cnruc, cserie) = 1 Then
		generaCorrelativoEnvioResumenBoletas()
	Else
		This.Cmensaje="No se Genero el XML de envío "
		Return 0
	Endif
	If !Empty(goapp.ticket) Then
		Do While .T.
			nr = ConsultaTicket(Alltrim(goapp.ticket), goapp.carchivo)
			If nr >= 0 Or nr < 0 Then
				v=0
				Exit
			Endif
		Enddo
		v = 1
		If nr = 1 Then
			Select crb
			Go Top
			Scan All
				np1		= crb.idauto
				dfenvio	= fe_gene.fech
				np3		= "0 El Resumen de Boletas ha sido aceptada "+goapp.ticket
				dfenvio	= cfechas(fe_gene.fech)
				TEXT To lc Noshow
                    UPDATE fe_rcom SET rcom_mens=?np3,rcom_fecd=?dfenvio WHERE idauto=?np1
				ENDTEXT
				If  This.ejecutasql(lc) < 0 Then
					This.Cmensaje='No se Grabo el mensaje de Respuesta'
					v = 0
					Exit
				Endif
			Endscan
		Endif
	Else
		This.Cmensaje='No se Obtuvo el Ticket de Respuesta'
		v = 0
	Endif
	Return v
	Endfunc
	Function soloregistraRboletas(df)
	Local ocomp As "comprobante"
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("cdatos", "")
	Endif

	datosGlobales()
	Set Classlib To d:\librerias\fe.vcx Additive
	ocomp = Createobject("comprobante")
	F	  = cfechas(df)
	dFecha = Date()
*	WAIT WINDOW 'aqui  '+goapp.cdatos
	If goapp.cdatos = 'S' Then
		nidt = goapp.Tienda
		TEXT To lc Noshow Textmerge
		SELECT fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f inner join fe_clie c on c.idclie=f.idcliente
		where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.codt=<<nidt>>
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>>
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>>
		ENDTEXT
		If This.EjecutaConsulta(lc, "rboletas") < 1 Then
			Return 0
		Endif
		TEXT To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and f.codt=<<nidt>>  order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  and f.codt=<<nidt>>  order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>' and f.codt=<<nidt>>  order by f.ndoc) as x group by serie
		ENDTEXT

	Else
		TEXT To lc Noshow Textmerge
		SELECT fech,tdoc,
		left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
		fROM fe_rcom f
		inner join fe_clie c on c.idclie=f.idcliente where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B'
		union all
		select f.fech,f.tdoc,
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'
		union all
		select f.fech,f.tdoc,
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,
		If(Length(trim(c.ndni))<8,'00000000',ndni) as ndni,
        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
        inner join fe_clie c on c.idclie=f.idcliente
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'
		ENDTEXT
		If This.EjecutaConsulta(lc, "rboletas") < 1 Then
			Return 0
		Endif
		TEXT To lcx Noshow Textmerge
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo
		from(select
		left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
		if(f.mone='S',impo,impo*dolar) as impo,tdoc
		fROM fe_rcom f where tdoc="03" and fech='<<f>>' and acti='A' and idcliente>0  order by ndoc) as x  group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo from(select
		concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  order by f.ndoc) as x group by serie
		union all
		SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
		sum(igv) as igv,sum(impo) as impo  from(select
		concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		abs(f.rcom_exon) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
		FROM fe_rcom f
		inner join fe_ncven g on g.ncre_idan=f.idauto
		inner join fe_rcom as w on w.idauto=g.ncre_idau
		where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<f>>'  order by f.ndoc) as x group by serie
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lcx, "rb1") < 1 Then
		Return 0
	Endif

	Select tdoc, serie, desde, hasta, valor, Exon, ;
		000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, df As fech;
		From rb1 Into Cursor curb


	Select fech, tdoc, serie, numero, tipodoc, ndni, valor, rcom_exon As Exon, ;
		000000.00 As inafectas, igv, Impo, 0.00 As gratificaciones, trefe, serieref, numerorefe, idauto;
		From Rboletas Into Cursor crb


	Select crb
	ocomp.itemsdocumentos = Reccount()
	tr					  = ocomp.itemsdocumentos
	If tr = 0 Then
*	This.Cmensaje="No Hay Boletas Por enviar"
*	Return 0
	Endif
	ocomp.fechadocumentos = Alltrim(Str(Year(df))) + '-' + Iif(Month(df) <= 9, '0' + Alltrim(Str(Month(df))), Alltrim(Str(Month(df)))) + '-' + Iif(Day(df) <= 9, '0' + Alltrim(Str(Day(df))), Alltrim(Str(Day(df))))
	cnombreArchivo		  = Alltrim(Str(Year(dFecha))) + Iif(Month(dFecha) <= 9, '0' + Alltrim(Str(Month(dFecha))), Alltrim(Str(Month(dFecha)))) + Iif(Day(dFecha) <= 9, '0' + Alltrim(Str(Day(dFecha))), Alltrim(Str(Day(dFecha))))
	ocomp.Moneda		  = 'PEN'
	ocomp.tigv			  = '10'
	ocomp.vigv			  = '18'
	ocomp.fechaemision	  = Alltrim(Str(Year(dFecha))) + '-' + Iif(Month(dFecha) <= 9, '0' + Alltrim(Str(Month(dFecha))), Alltrim(Str(Month(dFecha)))) + '-' + Iif(Day(dFecha) <= 9, '0' + Alltrim(Str(Day(dFecha))), Alltrim(Str(Day(dFecha))))
	If Type('oempresa') = 'U' Then
		ocomp.rucfirma			 = fe_gene.rucfirmad
		ocomp.nombrefirmadigital = fe_gene.razonfirmad
		ocomp.rucemisor			 = fe_gene.nruc
		ocomp.razonsocialempresa = fe_gene.empresa
		ocomp.ubigeo			 = fe_gene.ubigeo
		ocomp.direccionempresa	 = fe_gene.ptop
		ocomp.ciudademisor		 = fe_gene.ciudad
		ocomp.distritoemisor	 = fe_gene.distrito
		cnruc					 = fe_gene.nruc
	Else
		ocomp.rucfirma			 = oempresa.rucfirmad
		ocomp.nombrefirmadigital = oempresa.razonfirmad
		ocomp.rucemisor			 = oempresa.nruc
		ocomp.razonsocialempresa = oempresa.empresa
		ocomp.ubigeo			 = oempresa.ubigeo
		ocomp.direccionempresa	 = oempresa.ptop
		ocomp.ciudademisor		 = oempresa.ciudad
		ocomp.distritoemisor	 = oempresa.distrito
*	nres					 = oempresa.gene_nres
		cnruc					 = oempresa.nruc
	Endif
	nres					 = fe_gene.gene_nres
	ocomp.pais = 'PE'
	Dimension ocomp.ItemsFacturas[tr, 16]
	i  = 0
	ta = 1
	Select crb
	Scan All
		i						   = i + 1
		ocomp.ItemsFacturas[i, 1]  = crb.tdoc
		ocomp.ItemsFacturas[i, 2]  = Alltrim(crb.serie) + '-' + Alltrim(Str(Val(crb.numero)))
		ocomp.ItemsFacturas[i, 3]  = Alltrim(crb.ndni)
		ocomp.ItemsFacturas[i, 4]  = crb.tipodoc
		ocomp.ItemsFacturas[i, 5]  = crb.trefe
		ocomp.ItemsFacturas[i, 6]  = Alltrim(crb.serieref) + '-' + Alltrim(crb.numerorefe)
		ocomp.ItemsFacturas[i, 7]  = Alltrim(Str(crb.Impo, 12, 2))
		ocomp.ItemsFacturas[i, 8]  = Alltrim(Str(crb.valor, 12, 2))
		ocomp.ItemsFacturas[i, 9]  = Alltrim(Str(crb.Exon, 12, 2))
		ocomp.ItemsFacturas[i, 10] = Alltrim(Str(crb.inafectas, 12, 2))
		ocomp.ItemsFacturas[i, 11] = "0.00"
		ocomp.ItemsFacturas[i, 12] = "0.00"
		ocomp.ItemsFacturas[i, 13] = Alltrim(Str(crb.igv, 12, 2))
		ocomp.ItemsFacturas[i, 14] = "0.00"
		ocomp.ItemsFacturas[i, 15] = "0.00"
		ocomp.ItemsFacturas[i, 16] = Alltrim(Str(crb.gratificaciones, 12, 2))
	Endscan

	cpropiedad = "Firmarcondll"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("Firmarcondll", "")
	Endif


	cpropiedad = "multiempresa"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("multiempresa", "")
	Endif

	ocomp.cmulti = goapp.multiempresa


	ocomp.FirmarconDLL = goapp.FirmarconDLL
	If nres=0 Then
		If generaCorrelativoEnvioResumenBoletas() = 0 Then
			This.Cmensaje="No se Grabo el Corretalivo de Envio de Resumen de Boletas"
			Return 0
		Endif
		datosGlobales()
		nres=fe_gene.gene_nres
	Endif
	cserie = cnombreArchivo + "-" + Alltrim(Str(nres))
	vdvto=1
	x=0
	Select curb
	Scan All
		x=x+1
		carxml = ""
		cresp=Alltrim(Str(Year(curb.fech)))+Alltrim(Str(Month(curb.fech)))+Alltrim(Str(Day(curb.fech)))+'-'+Alltrim(Str(x))
		If registraresumenboletas(curb.fech, curb.tdoc, curb.serie, curb.desde, curb.hasta, curb.Impo, curb.valor, curb.Exon, curb.inafectas, curb.igv, curb.gratificaciones, ;
				carxml, "", goapp.carchivo, cresp) = 0 Then
			This.Cmensaje="NO se Registro el Informe de Envío de Boletas en Base de Datos"
			vdvto=0
			Exit
		Endif
	Endscan
	If vdvto=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function getallboletas(dFecha,ccursor,ccursor1)
	cpropiedad = "cdatos"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("cdatos", "")
	Endif
	Set DataSession To This.idsesion
	df=cfechas(dFecha)
	If This.todos=0 Then
		If goapp.cdatos = 'S' Then
			nidt = goapp.Tienda
			TEXT TO lc NOSHOW TEXTMERGE
				select fech,tdoc,
				left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
		        c.razo,if(f.mone='S',valor,valor*dolar) as valor,if(f.mone='S',rcom_exon,rcom_exon*dolar) as rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
				if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
				fROM fe_rcom f
				inner join fe_clie c on c.idclie=f.idcliente
				where tdoc="03" and fech='<<df>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.impo<>0 and f.codt=<<goapp.tienda>>
				union all
				select f.fech,f.tdoc,
				concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
		        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
		        inner join fe_clie c on c.idclie=f.idcliente
				where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' and f.impo<>0 and f.codt=<<goapp.tienda>>
				union all
				select f.fech,f.tdoc,
				concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
		        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
		        inner join fe_clie c on c.idclie=f.idcliente
				where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' and f.impo<>0 and f.codt=<<goapp.tienda>>
			ENDTEXT
			TEXT TO lcx NOSHOW TEXTMERGE
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo
				from(select
				left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar) as rcom_exon,
				if(f.mone='S',igv,igv*dolar) as igv,if(f.mone='S',impo,impo*dolar) as impo,tdoc
				fROM fe_rcom f where tdoc="03" and fech='<<df>>' and acti='A' and idcliente>0  and f.codt=<<goapp.tienda>> order by ndoc) as x  group by serie
				union all
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo from(select
				concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
				where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' and f.codt=<<goapp.tienda>> order by f.ndoc) as x group by serie
				union all
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo  from(select
				concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
				where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>'  and f.codt=<<goapp.tienda>> order by f.ndoc) as x group by serie order by serie
			ENDTEXT
		Else
			TEXT TO lc NOSHOW TEXTMERGE
				select fech,tdoc,
				left(ndoc,4) as serie,substr(ndoc,5) as numero,If(Length(trim(c.ndni))<8,'0','1') as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
		        c.razo,if(f.mone='S',valor,valor*dolar) as valor,if(f.mone='S',rcom_exon,rcom_exon*dolar) as rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
				if(f.mone='S',impo,impo*dolar) as impo,"" as trefe,"" as serieref,"" as numerorefe,f.idauto
				fROM fe_rcom f
				inner join fe_clie c on c.idclie=f.idcliente
				where tdoc="03" and fech='<<df>>' and acti='A' and idcliente>0 and LEFT(ndoc,1)='B' and f.impo<>0
				union all
				select f.fech,f.tdoc,
				concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
		        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
		        inner join fe_clie c on c.idclie=f.idcliente
				where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' and f.impo<>0
				union all
				select f.fech,f.tdoc,
				concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,'1' as tipodoc,If(Length(trim(c.ndni))<8,'00000000',c.ndni) as ndni,
		        c.razo,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,w.tdoc as trefe,left(w.ndoc,4) as serieref,substr(w.ndoc,5) as numerorefe,f.idauto
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
		        inner join fe_clie c on c.idclie=f.idcliente
				where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' and f.impo<>0
			ENDTEXT
			TEXT TO lcx NOSHOW TEXTMERGE
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo
				from(select
				left(ndoc,4) as serie,substr(ndoc,5) as numero,if(f.mone='S',valor,valor*dolar) as valor,
				if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar) as rcom_exon,if(f.mone='S',igv,igv*dolar) as igv,
				if(f.mone='S',impo,impo*dolar) as impo,tdoc
				fROM fe_rcom f where tdoc="03" and fech='<<df>>' and acti='A' and idcliente>0 order by ndoc) as x  group by serie
				union all
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo from(select
				concat("BC",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
				where f.tdoc="07"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' order by f.ndoc) as x group by serie
				union all
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo  from(select
				concat("BD",SUBSTR(f.ndoc,3,2)) as serie,substr(f.ndoc,5) as numero,abs(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
				abs(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,abs(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,abs(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,f.tdoc
				FROM fe_rcom f
				inner join fe_ncven g on g.ncre_idan=f.idauto
				inner join fe_rcom as w on w.idauto=g.ncre_idau
				where f.tdoc="08"  and f.acti='A' and f.idcliente>0 and w.tdoc='03' and f.fech='<<df>>' order by f.ndoc) as x group by serie order by serie
			ENDTEXT
		Endif
***************

	Else
		If goapp.cdatos = 'S' Then
			If This.ctdoc='03' Then
				TEXT TO lc NOSHOW TEXTMERGE
				SELECT fech,tdoc,serie,numero,If(Length(trim(ndni))<8,'0','1') as tipodoc,If(Length(trim(ndni))<8,'00000000',ndni) as ndni,
  		        razo,valor,rcom_exon,igv,impo,trefe,serieref,numerorefe,idauto
			    from(select f.fech,f.tdoc,
			    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,
			    if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar) as rcom_exon,n,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
			    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.razo,c.ndni,
		        "" as trefe,"" as serieref,""  as numerorefe,f.idauto
		     	fROM fe_rcom f
		     	inner join fe_clie as c on c.idclie=f.idcliente
			    left join fe_ncven g on g.ncre_idan=f.idauto
			    left join fe_rcom as w on w.idauto=g.ncre_idau
			    where f.tdoc='<<this.ctdoc>>' and f.fech='<<df>>'  and f.acti='A' and f.impo<>0  and f.codt=<<goapp.tienda>> order by f.ndoc) as x
			    where numero1 between <<this.ndesde>> and <<this.nhasta>> and serie='<<this.cserie>>' 
				ENDTEXT
			Else
				TEXT TO lc NOSHOW TEXTMERGE
				SELECT fech,tdoc,serie,numero,If(Length(trim(ndni))<8,'0','1') as tipodoc,If(Length(trim(ndni))<8,'00000000',ndni) as ndni,
		        razo,valor,rcom_exon,igv,impo,trefe,serieref,numerorefe,idauto
			    from(select f.fech,f.tdoc,
			    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,ABS(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		        ABS(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,ABS(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        ABS(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.razo,c.ndni,
		        ifnull(w.tdoc,"") as trefe,ifnull(left(w.ndoc,4),"") as serieref,ifnull(substr(w.ndoc,5),"") as numerorefe,f.idauto
		     	fROM fe_rcom f
		     	inner join fe_clie as c on c.idclie=f.idcliente
			    left join fe_ncven g on g.ncre_idan=f.idauto
			    left join fe_rcom as w on w.idauto=g.ncre_idau
			    where f.tdoc='<<this.ctdoc>>' and f.fech='<<df>>'  and f.acti='A'  and f.impo<>0 and f.codt=<<goapp.tienda>> order by f.ndoc) as x
			    where numero1 between <<this.ndesde>> and <<this.nhasta>> and serie='<<this.cserie>>'
				ENDTEXT
			Endif
			TEXT TO lcx NOSHOW TEXTMERGE 
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo
				from(select
				left(ndoc,4) as serie,substr(ndoc,5) as numero,ABS(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		        ABS(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,ABS(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        ABS(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,tdoc,cast(mid(ndoc,5) as unsigned) as numero1
				fROM fe_rcom f where tdoc='<<this.ctdoc>>' and fech='<<df>>' and acti='A' and idcliente>0 and f.codt=<<goapp.tienda>> order by ndoc) as x
				where numero1 between <<this.ndesde>> and <<this.nhasta>> and serie='<<this.cserie>>'
				group by serie order by serie
			ENDTEXT
		Else
			If This.ctdoc='03' Then
				TEXT TO lc NOSHOW TEXTMERGE
				SELECT fech,tdoc,serie,numero,If(Length(trim(ndni))<8,'0','1') as tipodoc,If(Length(trim(ndni))<8,'00000000',ndni) as ndni,
		        razo,valor,rcom_exon,igv,impo,trefe,serieref,numerorefe,idauto
			    from(select f.fech,f.tdoc,
			    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,if(f.mone='S',f.valor,f.valor*f.dolar) as valor,
			    if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar) as rcom_exon,if(f.mone='S',f.igv,f.igv*f.dolar) as igv,
			    if(f.mone='S',f.impo,f.impo*f.dolar) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.razo,c.ndni,
		        "" as trefe,"" as serieref,""  as numerorefe,f.idauto
		     	fROM fe_rcom f
		     	inner join fe_clie as c on c.idclie=f.idcliente
			    left join fe_ncven g on g.ncre_idan=f.idauto
			    left join fe_rcom as w on w.idauto=g.ncre_idau
			    where f.tdoc='<<this.ctdoc>>' and f.fech='<<df>>'  and f.acti='A' and f.impo<>0 order by f.ndoc) as x
			    where numero1 between <<this.ndesde>> and <<this.nhasta>> and serie='<<this.cserie>>'
				ENDTEXT
			Else
				TEXT TO lc NOSHOW TEXTMERGE 
				SELECT fech,tdoc,serie,numero,If(Length(trim(ndni))<8,'0','1') as tipodoc,If(Length(trim(ndni))<8,'00000000',ndni) as ndni,
		        razo,valor,rcom_exon,igv,impo,trefe,serieref,numerorefe,idauto
			    from(select f.fech,f.tdoc,
			    left(f.ndoc,4) as serie,substr(f.ndoc,5) as numero,BS(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		        ABS(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,ABS(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        ABS(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,cast(mid(f.ndoc,5) as unsigned) as numero1,c.razo,c.ndni,
		        ifnull(w.tdoc,"") as trefe,ifnull(left(w.ndoc,4),"") as serieref,ifnull(substr(w.ndoc,5),"") as numerorefe,f.idauto
		     	fROM fe_rcom f
		     	inner join fe_clie as c on c.idclie=f.idcliente
			    left join fe_ncven g on g.ncre_idan=f.idauto
			    left join fe_rcom as w on w.idauto=g.ncre_idau
			    where f.tdoc='<<this.ctdoc>>' and f.fech='<<df>>'  and f.acti='A'  and f.impo<>0 order by f.ndoc) as x
			    where numero1 between <<this.ndesde>> and <<this.nhasta>> and serie='<<this.cserie>>'
				ENDTEXT
			Endif
			TEXT TO lcx NOSHOW TEXTMERGE
				SELECT serie,tdoc,min(numero) as desde,max(numero) as hasta,sum(valor) as valor,SUM(rcom_exon) as exon,
				sum(igv) as igv,sum(impo) as impo
				from(select
				left(ndoc,4) as serie,substr(ndoc,5) as numero,ABS(if(f.mone='S',f.valor,f.valor*f.dolar)) as valor,
		        ABS(if(f.mone='S',f.rcom_exon,f.rcom_exon*f.dolar)) as rcom_exon,ABS(if(f.mone='S',f.igv,f.igv*f.dolar)) as igv,
		        ABS(if(f.mone='S',f.impo,f.impo*f.dolar)) as impo,tdoc,cast(mid(ndoc,5) as unsigned) as numero1
				fROM fe_rcom f where tdoc='<<this.ctdoc>>' and fech='<<df>>' and acti='A' and idcliente>0 order by ndoc) as x
				where numero1 between <<this.ndesde>> and <<this.nhasta>> and serie='<<this.cserie>>'
				group by serie order by serie
			ENDTEXT
		Endif
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	If This.EjecutaConsulta(lcx,ccursor1)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function generaserieboletas()
	ccursor='c_'+Sys(2015)
	TEXT TO lc NOSHOW TEXTMERGE
	    UPDATE fe_gene as g SET gene_nres=gene_nres+1 WHERE idgene=1
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	TEXT TO lc NOSHOW TEXTMERGE
	    select gene_nres FROM fe_gene WHERE idgene=1
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	Return gene_nres
	Endfunc
Enddefine
