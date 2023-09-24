#Define cweb "http://companysysven.com/"
Define Class cpesisven As Odata Of 'd:\capass\database\data'
	codt = 0
	curlenvio = ""
	curlconsulta = ""
	cose = ""
	urlcdr = ""
	urlcdr = cweb + 'app88/consultarcdrd.php'
	centidad = ""
	nruc = ""
	usol = ""
	csol = ""
	Function HayInternet()
	Declare Long InternetGetConnectedState In "wininet.dll" Long lpdwFlags, Long dwReserved
	If InternetGetConnectedState(0, 0) <> 1
		This.Cmensaje = "Sin conexión a Internet"
		Return  0
	Endif
	Return 1
	Endfunc
	Function consultarcdr(ctdoc, cnumero, nidauto)
	Text To cdata Noshow Textmerge
	{ 
	 "entidad": "<<this.centidad>>", 
	 "ruc": "<<this.nruc>>",  
	 "usol": "<<this.usol>>",  
	 "csol": "<<this.csol>>", 
	 "tdoc": "<<ctdoc>>",  
	 "ndoc": "<<cnumero>>", 
	 "idauto": 0
	 }
	Endtext
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.urlcdr, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		This.Cmensaje = "WEB " + Char(13) + Alltrim(This.urlcdr) + ' No Disponible ' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
	Set Procedure To d:\librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.estado) <> 'U'
		If Left(orpta.estado, 1) = '0' Then
			cdr = orpta.cdr
			crpta = orpta.Mensaje
			If goApp.Grabarxmlbd = 'S' Then
				Text To lc Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_cdr='<<cdr>>',rcom_mens='<<crpta>>' where idauto=<<nidauto>>
				Endtext
			Else
				Text To lc Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_mens='<<crpta>>' where idauto=<<nidauto>>
				Endtext
			Endif
			If This.Ejecutarsql(lc) < 1 Then
				Return 0
			Endif
			If Type('oempresa') = 'U' Then
				crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML') + "R-" + fe_gene.nruc + '-' + ctdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Sys(5) + Sys(2003) + '\SunatXML')
			Else
				crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + "R-" + Oempresa.nruc + '-' + ctdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Sys(5) + Sys(2003) + '\SunatXML' + Alltrim(Oempresa.nruc))
			ENDIF
			IF !DIRECTORY(carpetacdr) then
			   MD (carpetacdr)
			ENDIF    
			Strtofile(cdr, crutaxmlcdr)
			This.Cmensaje = orpta.Mensaje
			Return 1
		Else
			This.Cmensaje = "Estado: " + orpta.estado + Chr(13) + "Mensaje: " + orpta.Mensaje
			Return 0
		Endif
	Else
		This.Cmensaje = lcHTML
		Return 0
	Endif
	Endfunc
	Function ConsultaBoletasyNotasporenviar(f1, f2)
	Local lc
	Text To lc Noshow Textmerge
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
	Endtext
	If This.EjecutaConsulta(lc, 'rbolne') < 1 Then
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
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("cdatos", "")
	Endif
	If goApp.Cdatos = 'S' Then
		Text To lc Noshow Textmerge
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
		Endtext
	Else

		Text To lc Noshow Textmerge
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
		Endtext
	Endif
	If This.EjecutaConsulta(lc, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviar(ccursor)
	Text To lc Noshow Textmerge
	    SELECT guia_fech,guia_ndoc,"" AS cliente,razon,motivo,idauto as idguia,v.nruc,ticket FROM
        (SELECT guia_idgui AS idauto,guia_ndoc,'V' AS motivo,guia_fech,t.razon,guia_tick AS ticket  FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='V' AND guia_acti='A' AND LEFT(guia_deta,7)<>'Anulada'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'D' AS motivo,guia_fech,t.razon,guia_tick AS ticket   FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='D' AND guia_acti='A'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'C' AS motivo,guia_fech,t.razon,guia_tick AS ticket   FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='C' AND guia_acti='A'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'N' AS motivo,guia_fech,t.razon,guia_tick AS ticket   FROM  fe_guias AS g
         INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
         WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='N' AND guia_acti='A'
         UNION ALL
         SELECT guia_idgui AS idauto,guia_ndoc,'T' AS Motivo,guia_fech,t.razon,guia_tick AS ticket   FROM fe_guias AS a
         INNER JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
         WHERE LEFT(guia_ndoc,1)='T' AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A')AS w,fe_gene AS v
         ORDER BY guia_ndoc,guia_fech
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviaralpharmaco(ccursor)
	Text To lc Noshow Textmerge
	   SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick AS ticket FROM  vguiasventas
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS guia_fech,guia_ndoc AS ndoc,c.razo AS cliente,t.razon AS transportista,guia_idgui AS idguia,guia_moti AS motivo,
           guia_tick AS ticket FROM fe_guias AS g
           INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
           INNER JOIN fe_clie AS c ON c.idclie=g.`guia_idcl`
           WHERE  guia_acti='A' AND LEFT(guia_mens,1)<>'0' AND guia_moti='v'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick AS ticket FROM  vguiasdevolucion
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick AS ticket FROM  vguiasrcompras
           WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,c.razo AS cliente,t.razon AS Transportista,guia_idgui AS idguia,'N' AS motivo,guia_tick FROM  fe_guias
            AS g 
            INNER JOIN fe_clie AS c ON c.idclie=g.guia_idcl 
            INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr 
            WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' AND guia_moti='N' AND guia_acti='A'
           UNION ALL 
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,t.razon AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  AS ticket FROM fe_guias AS a
           INNER JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A')AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviarxtienda(ccursor)
	Text To lc Noshow Textmerge
	       SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick as ticket FROM  vguiasventas
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T' and guia_codt=<<this.codt>>
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick as ticket FROM  vguiasdevolucion
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'  and guia_codt=<<this.codt>>
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick as ticket FROM  vguiasrcompras
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'  and guia_codt=<<this.codt>>
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,IFNULL(t.razon,'') AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  as ticket FROM fe_guias AS a
           LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A'  and guia_codt=<<this.codt>>)AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	Endtext
	If This.EjecutaConsulta(lc, ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function descargarxmldesdedata(carfile, nid)
	Local lc
	Text To lc Noshow Textmerge
       CAST(rcom_xml as char) as rcom_xml,CAST(rcom_cdr as char) as rcom_cdr FROM fe_rcom WHERE idauto=<<nid>>
	Endtext
	If EjecutaConsulta(lc, 'filess') < 1 Then
		Return
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Sys(5) + Sys(2003) + '\Firmaxml') + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML') + cdr
	Else
		crutaxml	= Addbs(Sys(5) + Sys(2003) + '\Firmaxml\' + Alltrim(Oempresa.nruc)) + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + cdr
	Endif
	If File(crutaxml) Then
	Else
		If !Isnull(filess.rcom_xml) Then
			cxml = filess.rcom_xml
			Strtofile(cxml, crutaxml)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Envío " + carfile
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then
	Else
		If !Isnull(filess.rcom_cdr) Then
			cdrxml = filess.rcom_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			This.cmeensaje = "No se puede Obtener el Archivo CDR"
		Endif
	Endif

	Endfunc
	Function descargarxmlguiadesdedata(carfile, nid)
	Local lc
	Text To lc Noshow Textmerge
       CAST(guia_xml AS CHAR) AS guia_xml,CAST(guia_cdr AS CHAR) AS guia_cdr FROM fe_guias WHERE guia_idgui=<<nid>>
	Endtext
	If EjecutaConsulta(lc, 'filess') < 1 Then
		Return
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Sys(5) + Sys(2003)) + 'Firmaxml\' + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003) + '\SunatXML\') + cdr
	Else
		crutaxml	= Addbs(Sys(5) + Sys(2003)) + 'Firmaxml\' + Alltrim(Oempresa.nruc) + "\" + carfile
		crutaxmlcdr	= Addbs(Sys(5) + Sys(2003)) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cdr
	Endif
	If File(crutaxml) Then
	Else
		If !Isnull(filess.guia_xml) Then
			cxml = filess.guia_xml
			Strtofile(cxml, crutaxml)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Envío"
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then
	Else
		If !Isnull(filess.guia_cdr) Then
			cdrxml = filess.guia_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			This.Cmensaje = "No se puede Obtener el Archivo XML de Respuesta"
		Endif
	Endif
	Endfunc
Enddefine











