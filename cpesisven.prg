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
	mostrarmensaje = ""
	nidauto = 0
	dfenvio = Date()
	dfi = Date()
	dff = Date()
	confechas = 0
	cTdoc = ""
	Function HayInternet()
	Declare Long InternetGetConnectedState In "wininet.dll" Long lpdwFlags, Long dwReserved
	If InternetGetConnectedState(0, 0) <> 1
		This.Cmensaje = "Sin conexión a Internet"
		Return  0
	Endif
	Return 1
	Endfunc
	Function consultarcdr(cTdoc, cnumero, nidauto)
	Text To cdata Noshow Textmerge
	{
	 "entidad": "<<this.cose>>",
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
		This.Cmensaje = "WEB " + Chr(13) + Alltrim(This.urlcdr) + ' No Disponible ' + Alltrim(Str(oHTTP.Status))
		Return 0
	Endif
	lcHTML = oHTTP.responseText
*!*		MESSAGEBOX(lcHtml)
	Set Procedure To d:\Librerias\nfJsonRead.prg Additive
	orpta = nfJsonRead(lcHTML)
	If  Vartype(orpta.estado) <> 'U'
		If Left(orpta.estado, 1) = '0' Then
			cdr = orpta.cdr
			crpta = orpta.Mensaje
			If goApp.Grabarxmlbd = 'S' Then
				Text To lC Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_cdr=?cdr,rcom_mens=?crpta where idauto=<<nidauto>>
				Endtext
			Else
				Text To lC Noshow Textmerge
		         update fe_rcom set rcom_fecd=curdate(),rcom_mens=?crpta where idauto=<<nidauto>>
				Endtext
			Endif
			If This.Ejecutarsql(lC) < 1 Then
				Return 0
			Endif
			If Type('oempresa') = 'U' Then
				crutaxmlcdr	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + "R-" + fe_gene.nruc + '-' + cTdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML')
			Else
				crutaxmlcdr	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'sunatXML') + Alltrim(Oempresa.nruc)) + "R-" + Oempresa.nruc + '-' + cTdoc + '-' + Left(cnumero, 4) + '-' + Substr(cnumero, 5, 8) + '.xml'
				carpetacdr = Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'sunatXML') + Alltrim(Oempresa.nruc))
			Endif
			If !Directory(carpetacdr) Then
				Md (carpetacdr)
			Endif
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
	Local lC
	Text To lC Noshow Textmerge
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
	If This.EjecutaConsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket10(np1)

	Endfunc
	Function ConsultaBoletasyNotasporenviarsinfechas()
	Local lC
	If !Pemstatus(goApp, "cdatos", 5)
		goApp.AddProperty("cdatos", "")
	Endif
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
	\	From(Select resu_fech,Cast(Sum(enviados) As Decimal(12,2)) As enviados,Cast(Sum(resumen) As Decimal(12,2))As resumen From(
	\	Select resu_fech,Case tipo When 1 Then resu_impo Else 0 End As enviados,
	\	Case tipo When 2 Then resu_impo Else 0 End As resumen,resu_mens,tipo From (
	\	Select resu_fech,resu_impo As resu_impo,resu_mens,1 As tipo From fe_resboletas F
	\	Where  F.resu_acti='A' And Left(resu_mens,1)='0'
	If goApp.Cdatos = 'S' Then
	   \ And resu_codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select fech As resu_fech,If(mone='S',Impo,Impo*dolar) As resu_impo,' ' As resu_mens,2 As tipo From fe_rcom F
	\	Where   F.Acti='A' And Tdoc='03' And Left(ndoc,1)='B' And F.idcliente>0
	If goApp.Cdatos = 'S' Then
	 \And F.codt=<<goApp.tienda>>
	Endif
	\	Union All
	\	Select F.fech As resu_fech,If(F.mone='S',Abs(F.Impo),Abs(F.Impo*F.dolar)) As resu_impo,' ' As resu_mens,2 As tipo From fe_rcom F
	\	INNER Join fe_ncven g On g.ncre_idan=F.Idauto
	\	INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
	\	Where F.Acti='A' And F.Tdoc In ('07','08') And Left(F.ndoc,1)='F' And w.Tdoc='03' And F.idcliente>0
	If goApp.Cdatos = 'S' Then
	 \And F.codt=<<goApp.tienda>>
	Endif
	\) As x)
	\ As Y Group By resu_fech Order By resu_fech) As zz  Where resumen-enviados>=1
	Set Textmerge Off
	Set Textmerge  To
	If This.EjecutaConsulta(lC, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviar(Ccursor)
	Text To lC Noshow Textmerge
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviaralpharmaco(Ccursor)
	Text To lC Noshow Textmerge
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviarxtienda(Ccursor)
	Text To lC Noshow Textmerge
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
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function descargarxmldesdedata(carfile, nid)
	Local lC
	Text To lC Noshow Textmerge
       CAST(rcom_xml as char) as rcom_xml,CAST(rcom_cdr as char) as rcom_cdr FROM fe_rcom WHERE idauto=<<nid>>
	Endtext
	If EjecutaConsulta(lC, 'filess') < 1 Then
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
			This.Cmensaje = "No se puede Obtener el Archivo CDR"
		Endif
	Endif

	Endfunc
	Function descargarxmlguiadesdedata(carfile, nid)
	Local lC
	Text To lC Noshow Textmerge
       CAST(guia_xml AS CHAR) AS guia_xml,CAST(guia_cdr AS CHAR) AS guia_cdr FROM fe_guias WHERE guia_idgui=<<nid>>
	Endtext
	If EjecutaConsulta(lC, 'filess') < 1 Then
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
	Function ConsultarCPE
	Lparameters LcRucEmisor, lcUser_Sol, lcPswd_Sol, ctipodcto, Cserie, cnumero, pk
	Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
	Local loXMLBody As "MSXML2.DOMDocument.6.0"
	Local loXMLResp As "MSXML2.DOMDocument.6.0"
	Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
	Local oShell As "Shell.Application"
	Local res As "MSXML2.DOMDocument.6.0"
	Local lcEnvioXML, lcURL, lcUserName, lsURL, ls_pwd_sol, ls_ruc_emisor, ls_user
	Declare Integer CryptBinaryToString In Crypt32;
		String @pbBinary, Long cbBinary, Long dwFlags, ;
		String @pszString, Long @pcchString

	Declare Integer CryptStringToBinary In Crypt32;
		String @pszString, Long cchString, Long dwFlags, ;
		String @pbBinary, Long @pcbBinary, ;
		Long pdwSkip, Long pdwFlags

	#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
	If !Pemstatus(goApp, "ose", 5)
		goApp.AddProperty("ose", "")
	Endif
	If !Pemstatus(goApp, "Grabarxmlbd", 5)
		goApp.AddProperty("Grabarxmlbd", "")
	Endif
	loXmlHttp  = Createobject("MSXML2.ServerXMLHTTP.6.0")
	loXMLBody  = Createobject("MSXML2.DOMDocument.6.0")
	crespuesta = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'
	Do Case
	Case goApp.ose = "nubefact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://demo-ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.nubefact.com/ol-ti-itcpe/billService"
			ls_ruc_emisor = LcRucEmisor
			ls_pwd_sol	  = lcPswd_Sol
*!*				ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
			ls_user		  = LcRucEmisor + lcUser_Sol

		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		   <soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
		   <soapenv:Header>
				<wsse:Security>
					<wsse:UsernameToken>
							<wsse:Username><<ls_user>></wsse:Username>
			                <wsse:Password><<ls_pwd_sol>></wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <rucComprobante><<LcRucEmisor>></rucComprobante>
		         <tipoComprobante><<ctipodcto>></tipoComprobante>
		         <serieComprobante><<cserie>></serieComprobante>
				 <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			This.Cmensaje = loXMLBody.parseError.reason
			Return - 1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<message>", "</message>", 1)
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = crpta + ' ' + Alltrim(CMensaje1)
			Endif
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = (Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1))
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "bizlinks"
		loXmlHttp = Createobject("MSXML2.XMLHTTP.6.0")
		loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://osetesting.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'TESTBIZLINKS'
			ls_user		  = Alltrim(fe_gene.nruc) + 'BIZLINKS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.bizlinks.com.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		cnum = Right("00000000" + Alltrim(cnumero), 8)
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		<SOAP-ENV:Header xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
		<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		<wsse:UsernameToken>
	    <wsse:Username><<ls_user>></wsse:Username>
		<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"><<ls_pwd_sol>></wsse:Password></wsse:UsernameToken>
		</wsse:Security>
		</SOAP-ENV:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		         <!--Optional:-->
		         <statusCdr>
		            <!--Optional:-->
		             <numeroComprobante><<cnum>></numeroComprobante>
		            <!--Optional:-->
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
		            <!--Optional:-->
		             <serieComprobante><<cserie>></serieComprobante>
		            <!--Optional:-->
		            	 <tipoComprobante><<ctipodcto>></tipoComprobante>
		         </statusCdr>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
*loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<detail>", "</detail>", 1)
			This.Cmensaje = crpta + ' ' + Alltrim(CMensaje1)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "efact"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL   = "https://ose-gw1.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'iGje3Ei9GN'
			ls_user		  = ls_ruc_emisor
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://ose.efact.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		  <soapenv:Header>
		   <wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
		      <wsse:UsernameToken>
		       <wsse:Username><<ls_user>></wsse:Username>
			   <wsse:Password><<ls_pwd_sol>></wsse:Password>
		      </wsse:UsernameToken>
		   </wsse:Security>
		   </soapenv:Header>
		   <soapenv:Body>
		      <ser:getStatusCdr>
		             <rucComprobante><<LcRucEmisor>></rucComprobante>
			       	 <tipoComprobante><<ctipodcto>></tipoComprobante>
			      	 <serieComprobante><<cserie>></serieComprobante>
			         <numeroComprobante><<cnumero>></numeroComprobante>
		      </ser:getStatusCdr>
		   </soapenv:Body>
		</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror	  = Nvl(loXmlHttp.responseText, '')
			crpta	  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			CMensaje1 = Strextract(cerror, "<detail>", "</detail>", 1)
			This.Cmensaje = crpta + ' ' + Alltrim(CMensaje1)
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = (Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1))
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//document")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case goApp.ose = "conastec"
		Do Case
		Case goApp.tipoh == 'B'
			lsURL		  = "https://test.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = fe_gene.nruc
			ls_pwd_sol	  = 'moddatos'
			ls_user		  = ls_ruc_emisor + 'MODDATOS'
		Case goApp.tipoh = 'P'
			lsURL		  =  "https://prod.conose.pe/ol-ti-itcpe/billService"
			ls_ruc_emisor = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc)
			ls_pwd_sol	  = Iif(Type('oempresa') = 'U', Alltrim(fe_gene.gene_csol), Alltrim(Oempresa.gene_csol))
			ls_user		  = ls_ruc_emisor + Iif(Type('oempresa') = 'U', Alltrim(fe_gene.Gene_usol), Alltrim(Oempresa.Gene_usol))
		Endcase
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.sunat.gob.pe">
		  <soapenv:Header>
			<wsse:Security   xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
			<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
			<wsse:Username><<ls_user>></wsse:Username>
			<wsse:Password><<ls_pwd_sol>></wsse:Password>
			</wsse:UsernameToken>
			</wsse:Security>
			</soapenv:Header>
			   <soapenv:Body>
			      <ser:getStatusCdr>
			         <!--Optional:-->
			         <rucComprobante><<LcRucEmisor>></rucComprobante>
			         <!--Optional:-->
			       	 <tipoComprobante><<ctipodcto>></tipoComprobante>
			         <!--Optional:-->
			      	 <serieComprobante><<cserie>></serieComprobante>
			         <numeroComprobante><<cnumero>></numeroComprobante>
			      </ser:getStatusCdr>
			   </soapenv:Body>
			</soapenv:Envelope>
		Endtext
		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif
		loXmlHttp.Open( "POST", lsURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=UTF-8")
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "urn:getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )

		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror = Nvl(loXmlHttp.responseText, '')
			crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			This.Cmensaje = crpta
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<statusMessage>", "</statusMessage>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0004' Then
			If Vartype(mostramensaje) = 'L'
				This.Cmensaje = Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1)
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Case Empty(goApp.ose)
		Local ArchivoRespuestaSunat As "MSXML2.DOMDocument.6.0"
		Local loXMLBody As "MSXML2.DOMDocument.6.0"
		Local loXMLResp As "MSXML2.DOMDocument.6.0"
		Local loXmlHttp As "MSXML2.ServerXMLHTTP.6.0"
		Local oShell As "Shell.Application"
		Local lC, lcEnvioXML, lcURL, lcUserName
		Declare Integer CryptBinaryToString In Crypt32;
			String @pbBinary, Long cbBinary, Long dwFlags, ;
			String @pszString, Long @pcchString
		Declare Integer CryptStringToBinary In Crypt32;
			String @pszString, Long cchString, Long dwFlags, ;
			String @pbBinary, Long @pcbBinary, ;
			Long pdwSkip, Long pdwFlags

		#Define SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS    13056
		loXmlHttp = Createobject("MSXML2.ServerXMLHTTP.6.0")
		loXMLBody = Createobject("MSXML2.DOMDocument.6.0")
		lcUserName = LcRucEmisor + lcUser_Sol
		lcURL	   = "https://e-factura.sunat.gob.pe/ol-it-wsconscpegem/billConsultService"



		crespuesta = Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.zip'
		Text To lcEnvioXML Textmerge Noshow Flags 1 Pretext 1 + 2 + 4 + 8
	<soapenv:Envelope xmlns:ser="http://service.sunat.gob.pe"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
	<soapenv:Header>
	<wsse:Security>
	<wsse:UsernameToken>
	<wsse:Username><<lcUsername>></wsse:Username>
	<wsse:Password><<lcPswd_Sol>></wsse:Password>
	</wsse:UsernameToken>
	</wsse:Security>
	</soapenv:Header>
	<soapenv:Body>
	<ser:getStatusCdr>
	<rucComprobante><<LcRucEmisor>></rucComprobante>
	<tipoComprobante><<ctipodcto>></tipoComprobante>
	<serieComprobante><<cserie>></serieComprobante>
	<numeroComprobante><<cnumero>></numeroComprobante>
	</ser:getStatusCdr>
	</soapenv:Body>
	</soapenv:Envelope>
		Endtext

		If Not loXMLBody.LoadXML( lcEnvioXML )
			Error loXMLBody.parseError.reason
			Return - 1
		Endif

		loXmlHttp.Open( "POST", lcURL, .F. )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml" )
		loXmlHttp.setRequestHeader( "Content-Type", "text/xml;charset=utf-8" )
		loXmlHttp.setRequestHeader( "Content-Length", Len(lcEnvioXML) )
		loXmlHttp.setRequestHeader( "SOAPAction", "getStatusCdr" )
		loXmlHttp.setOption( 2, SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS )
		loXmlHttp.Send(loXMLBody.documentElement.XML)
		If loXmlHttp.Status # 200 Then
			cerror = Nvl(loXmlHttp.responseText, '')
			crpta  = Strextract(cerror, '<faultstring>', '</faultstring>', 1)
			This.Cmensaje = crpta
			Return - 1
		Endif
		loXMLResp = Createobject("MSXML2.DOMDocument.6.0")
		loXMLResp.LoadXML(loXmlHttp.responseText)
		CmensajeError	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultcode>", "</faultcode>")
		CMensajeMensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<faultstring>", "</faultstring>")
		CMensajedetalle	= leerXMl(Alltrim(loXmlHttp.responseText), "<detail>", "</detail>")
		Cnumeromensaje	= leerXMl(Alltrim(loXmlHttp.responseText), "<statusCode>", "</statusCode>")
		CMensaje1		= leerXMl(Alltrim(loXmlHttp.responseText), "<message>", "</message>")
		If !Empty(CmensajeError) Or !Empty(CMensajeMensaje) Or Cnumeromensaje <> '0' Then
			If Vartype(mostrarmensaje) = 'L' Then
				This.Cmensaje = (Alltrim(CmensajeError) + ' ' + Alltrim(CMensajeMensaje) + ' ' + Alltrim(CMensajedetalle) + ' ' + Alltrim(CMensaje1))
			Endif
			Return 0
		Endif
		ArchivoRespuestaSunat = Createobject("MSXML2.DOMDocument.6.0")  &&Creamos el archivo de respuesta
		ArchivoRespuestaSunat.LoadXML(loXmlHttp.responseText)			&&Llenamos el archivo de respuesta
		txtCod = loXMLResp.selectSingleNode("//statusCode")  &&Return
		txtMsg = loXMLResp.selectSingleNode("//statusMessage")  &&Return

		If txtCod.Text <> "0004"  Then
			If Vartype(mostrarmensaje) = 'L' Then
				This.Cmensaje = Alltrim(txtCod.Text) + ' ' + Alltrim(txtMsg.Text)
			Endif
			Return - 1
		Endif
		TxtB64 = ArchivoRespuestaSunat.selectSingleNode("//content")  &&Ahora Buscamos el nodo "applicationResponse" llenamos la variable TxtB64 con el contenido del nodo "applicationResponse"
	Endcase
	If Vartype(TxtB64) <> 'O' Then
		This.Cmensaje = "No se puede LEER el Contenido del Archivo XML de SUNAT"
		Return 0
	Endif
	crptaxmlcdr = 'R-' + Iif(Type('oempresa') = 'U', fe_gene.nruc, Oempresa.nruc) + '-' + ctipodcto + '-' + Cserie + '-' + cnumero + '.XML'
	If Type('oempresa') = 'U' Then
		cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml') + crespuesta
		cDirDesti = Addbs( Sys(5) + Sys(2003) + '\SunatXML')
		cfilerpta = Addbs( Sys(5) + Sys(2003) + '\SunatXML') + crptaxmlcdr
	Else
		cnombre	  = Addbs(Sys(5) + Sys(2003) + '\SunatXml\' + Alltrim(Oempresa.nruc)) + crespuesta
		cDirDesti = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc))
		cfilerpta = Addbs(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc)) + crptaxmlcdr
	Endif
	If !Directory(cDirDesti) Then
		Md (cDirDesti)
	Endif
	If File(cfilerpta) Then
		Delete File(cfilerpta)
	Endif
	decodefile(TxtB64.Text, cnombre)
	oShell	  = Createobject("Shell.Application")
	cfilerpta = "R"
	For Each oArchi In oShell.NameSpace(cnombre).Items
		If Left(oArchi.Name, 1) = 'R' Then
			oShell.NameSpace(cDirDesti).CopyHere(oArchi)
			cfilerpta = Juststem(oArchi.Name) + '.XML'
		Endif
	Endfor
	If Type('oempresa') = 'U' Then
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + cfilerpta
	Else
		rptaSunat = LeerRespuestaSunat(Sys(5) + Sys(2003) + '\SunatXML\' + Alltrim(Oempresa.nruc) + "\" + cfilerpta)
		cfilecdr  = Sys(5) + Sys(2003) + '\SunatXML\' + + Alltrim(Oempresa.nruc) + "\" + cfilerpta
	Endif
	If Len(Alltrim(rptaSunat)) > 100 Then
		This.Cmensaje = rptaSunat
		Return 0
	Endif
	Do Case
	Case Left(rptaSunat, 1) = '0'
		If goApp.Grabarxmlbd = 'S' Then
			cdrxml = Filetostr(cfilecdr)
			cdrxml  =  ""
			Text  To lC Noshow Textmerge
                  UPDATE fe_rcom SET rcom_mens='<<rptaSunat>>',rcom_cdr='<<cdrxml>>' WHERE idauto=<<pk>>
			Endtext
		Else
			Text  To lC Noshow Textmerge
                  UPDATE fe_rcom SET rcom_mens='<<rptaSunat>>' WHERE idauto=<<pk>>
			Endtext
		Endif
		If  This.Ejecutarsql(lC) < 1 Then
			Return 0
		Endif
		This.Cmensaje = rptaSunat
		Return 1
	Case Empty(rptaSunat)
		If Vartype(mostramensaje) = 'L' Then
			This.Cmensaje = rptaSunat
		Endif
		Return 0
	Otherwise
		If Vartype(mostramensaje) = 'L' Then
			This.Cmensaje = rptaSunat
		Endif
		Return 0
	Endcase
	Endfunc
	Function Actualizarestadoenviocpe()
	fenvio = cfechas(This.dfenvio)
	Text  To lC Noshow Textmerge
    UPDATE fe_rcom SET rcom_mens='<<this.cmensaje>>',rcom_fecd='<<fenvio>>' WHERE idauto=<<this.nidauto>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpeporenviar(Ccursor)
	Text To lC Noshow Textmerge Pretext 7
	    select a.ndoc as dcto,a.fech,b.razo,a.valor,a.rcom_exon,CAST(0 as decimal(12,2)) as inafecto,
	    a.igv,a.impo,rcom_hash,u.nomb,a.fusua,IF(mone='S','Soles','Dólares') as moneda,a.tdoc,a.ndoc,idauto,a.idcliente,b.clie_corr,
	    ndo2,b.fono,nruc,tcom,tdoc,a.vigv,a.mone,a.rcom_arch
	    FROM fe_rcom as a
	    JOIN fe_clie as b ON (a.idcliente=b.idclie)
	    join fe_usua u on u.idusua=a.idusua
	    where a.acti='A' and LEFT(ndoc,1) in ('F') and left(rcom_mens,1)<>'0' and  impo<>0 and a.tdoc='01'
	    union all
	    SELECT a.ndoc as dcto,a.fech,b.razo,a.valor,a.rcom_exon,CAST(0 as decimal(12,2)) as inafecto,
	    a.igv,a.impo,a.rcom_hash,u.nomb,a.fusua,IF(a.mone='S','Soles','Dólares') as moneda,a.tdoc,a.ndoc,a.idauto,a.idcliente,b.clie_corr,
	    a.ndo2,b.fono,nruc,a.tcom,w.tdoc,a.vigv,a.mone,a.rcom_arch
	    FROM fe_rcom as a
	    JOIN fe_clie as b ON (a.idcliente=b.idclie)
	    join fe_usua u on u.idusua=a.idusua
	    inner join fe_ncven g on g.ncre_idan=a.idauto
	    inner join fe_rcom as w on w.idauto=g.ncre_idau
        where a.acti='A' AND LEFT(a.ndoc,1) in ('F') and left(a.rcom_mens,1)<>'0'  and a.impo<>0  and w.tdoc='01' and a.tdoc in("07","08") order by fech,ndoc
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxmsys(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,Idauto,b.ndni,b.clie_corr,
	\    nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,tcom,Tdoc,a.vigv,rcom_dsct,ndoc,a.rcom_carg
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where a.Acti<>'I' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And nruc<>"***********" And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.Idauto,b.ndni,b.clie_corr,
	\    nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,a.tcom,w.Tdoc,a.vigv,a.rcom_dsct,a.ndoc,a.rcom_carg
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti<>'I' And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And  nruc<>"***********" And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \Order By fech,dcto
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarpsysw(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.ndoc As dcto, a.fech, b.razo,If(a.mone='S','Soles','Dólares') As moneda, a.valor, a.rcom_exon, rcom_otro,
	\a.igv, a.Impo, rcom_hash, u.nomb, a.fusua, rcom_mens, rcom_arch, mone, a.Tdoc, a.ndoc, dolar, Idauto, b.ndni, a.idcliente, b.clie_corr,
	\ndo2, b.fono, nruc, Concat(Trim(b.Dire), ' ', Trim(b.ciud)) As direccion, tcom, Tdoc, a.vigv
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente = b.idclie)
	\Join fe_usua u On u.idusua = a.idusua
	\Where a.Acti <> 'I' And Left(ndoc, 1) In ('F') And Left(rcom_mens, 1) <> '0'   And a.Tdoc = '01' and b.nruc<>'***********' and (a.Impo <> 0 Or a.rcom_otro <> 0) 
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Union All
	\Select a.ndoc As dcto, a.fech, b.razo,If(a.mone='S','Soles','Dólares') As moneda, a.valor, a.rcom_exon, a.rcom_otro,
	\a.igv, a.Impo, a.rcom_hash, u.nomb, a.fusua, a.rcom_mens, a.rcom_arch, a.mone, a.Tdoc, a.ndoc, a.dolar, a.Idauto, b.ndni, a.idcliente, b.clie_corr,
	\a.ndo2, b.fono, nruc, Concat(Trim(b.Dire), ' ', Trim(b.ciud)) As direccion, a.tcom, w.Tdoc, a.vigv
	\From fe_rcom As a
	\INNER Join fe_clie As b On (a.idcliente = b.idclie)
	\INNER Join fe_usua u On u.idusua = a.idusua
	\INNER Join fe_ncven g On g.ncre_idan = a.Idauto
	\INNER Join fe_rcom As w On w.Idauto = g.ncre_idau
	\Where a.Acti <> 'I' And Left(a.ndoc, 1) In ('F') And Left(a.rcom_mens, 1) <> '0' And (a.Impo <> 0 Or a.rcom_otro <> 0)  And w.Tdoc = '01' And a.Tdoc In("07", "08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By fech, ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	FUNCTION consultarcpexenviarpsysu(ccursor)
	SET TEXTMERGE on
	SET TEXTMERGE TO memvar lc NOSHOW TEXTMERGE 
    \select a.ndoc as dcto,a.fech,b.razo,IF(a.mone='S','Soles','Dólares') as moneda,a.valor,a.rcom_exon,rcom_otro,
    \a.igv,a.impo,rcom_mens,rcom_arch,mone,a.tdoc,a.ndoc,dolar,idauto,b.ndni,a.idcliente,b.clie_corr,
    \ndo2,nruc,tcom,tdoc,rcom_hash
    \FROM fe_rcom as a 
    \inner JOIN fe_clie as b ON (a.idcliente=b.idclie)
    \where  a.acti<>'I' and LEFT(ndoc,1) in ('F') and left(rcom_mens,1)<>'0' and (impo<>0 or rcom_otro>0)  and a.tdoc='01'
    If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \union all
    \SELECT a.ndoc as dcto,a.fech,b.razo,IF(a.mone='S','Soles','Dólares') as moneda,a.valor,a.rcom_exon,CAST(0 as decimal(12,2)) as inafecto,
    \a.igv,a.impo,a.rcom_mens,a.rcom_arch,a.mone,a.tdoc,a.ndoc,a.dolar,a.idauto,b.ndni,a.idcliente,b.clie_corr,
    \a.ndo2,nruc,a.tcom,w.tdoc,a.rcom_hash
    \FROM fe_rcom as a JOIN fe_clie as b ON (a.idcliente=b.idclie)
    \inner join fe_ncven g on g.ncre_idan=a.idauto 
    \inner join fe_rcom as w on w.idauto=g.ncre_idau
    \where a.acti<>'I' AND LEFT(a.ndoc,1) in ('F') and left(a.rcom_mens,1)<>'0'  and a.impo<>0  and w.tdoc='01' and a.tdoc in("07","08") 
     If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
    If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \order by fech,ndoc
	SET TEXTMERGE off
	SET TEXTMERGE TO 
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC 
	Function consultarcpexenviarpsys(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,rcom_otro,
	\    a.igv,a.Impo,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,a.ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,a.tcom
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where  a.Acti<>'I' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And (Impo<>0 Or rcom_otro>0) And a.Tdoc='01' And  b.nruc<>"***********"
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,rcom_otro,
	\    a.igv,a.Impo,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,a.tcom
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    INNER Join fe_rven As rv On rv.Idauto=a.Idauto
	\    INNER Join fe_refe F On F.idrven=rv.idrven
	\    INNER Join fe_tdoc As w On w.idtdoc=F.idtdoc
	\    Where  a.Acti<>'I'  And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0' And  b.nruc<>"***********"   And w.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxsysg(Ccursor)
	If !Pemstatus(goApp, 'periodo', 5) Then
		AddProperty(goApp, 'periodo', 0)
	Endif
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\ Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,u.nomb,a.fusua,If(mone='S','Soles','Dólares') As moneda,a.ndoc,Idauto,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,tcom,a.Tdoc,a.vigv,a.mone,a.rcom_arch,rcom_hash,a.Tdoc
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    Where a.Acti='A' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And  Impo<>0 And a.Tdoc='01'
	If goApp.Periodo > 0 Then
	   \ And Year(a.fech)>=<<goApp.Periodo>>
	Endif
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	\    a.igv,a.Impo,u.nomb,a.fusua,If(a.mone='S','Soles','Dólares') As moneda,a.ndoc,a.Idauto,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,a.tcom,a.Tdoc,a.vigv,a.mone,a.rcom_arch,a.rcom_hash,w.Tdoc
	\    From fe_rcom As a
	\    Join fe_clie As b On (a.idcliente=b.idclie)
	\    Join fe_usua u On u.idusua=a.idusua
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \    Where a.Acti='A' And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0' And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If goApp.Periodo > 0 Then
	   \ And Year(a.fech)>=<<goApp.Periodo>>
	Endif
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \ Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexenviarxsys3(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select a.ndoc As dcto,a.fech,b.razo,a.mone,a.valor,a.rcom_exon,rcom_otro,rcom_inaf As inafecto,
    \a.igv,a.Impo,rcom_arch,a.Tdoc,a.ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
    \ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,tcom,Tdoc
    \From fe_rcom As a
    \INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \Where  a.Acti<>'I' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And (Impo<>0 Or rcom_otro>0)  And a.Tdoc='01'
    \Union All
    \Select a.ndoc As dcto,a.fech,b.razo,a.mone,a.valor,a.rcom_exon,a.rcom_otro,a.rcom_inaf As inafecto,
    \a.igv,a.Impo,a.rcom_arch,a.Tdoc,a.ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
    \a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,a.tcom,w.Tdoc
    \From fe_rcom As a
    \INNER Join fe_clie As b On (a.idcliente=b.idclie)
    \INNER Join fe_ncven g On g.ncre_idan=a.Idauto
    \INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \Where a.Acti<>'I' And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'   And a.Impo<>0  And w.Tdoc In('01','07','08') And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	   \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	    \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 0
		Return 0
	Endif
	Return 1
	Endfunc
	Function EnviarSunat()
	If This.consultarcpeporenviar("rmvtos") < 1 Then
		Return 0
	Endif
	enviado = ""
	Set Classlib To d:\envio\fe.vcx Additive
	ocomp = Createobject("comprobante")
	Select rmvtos
	Go Top
	Do While !Eof()
		If enviado <> 'S' Then
			ocomp.Version = "2.1"
			ocomp.Condetraccion = goApp.vtascondetraccion
			Do Case
			Case rmvtos.Tdoc = '01'
				If rmvtos.vigv = 1 Then
					If rmvtos.tcom = 'S' Then
						vdne = ocomp.obtenerdatosfacturaexoneradaotros(rmvtos.Idauto)
					Else
						ocomp.Gironegocio = "Grifo"
						vdne = ocomp.obtenerdatosfacturaexonerada(rmvtos.Idauto)
					Endif
				Else
					If rmvtos.tcom = 'S' Then
						vdne = ocomp.obtenerdatosfacturaotros(rmvtos.Idauto)
					Else
						ocomp.Gironegocio = "Grifo"
						vdne = ocomp.obtenerdatosfactura(rmvtos.Idauto)
					Endif
				Endif
			Case rmvtos.Tdoc = '07'
				If rmvtos.vigv = 1 Then
					vdne = ocomp.Obtenerdatosnotecreditoexonerada(rmvtos.Idauto, 'E')
				Else
					vdne = ocomp.obtenerdatosnotascredito(rmvtos.Idauto, 'E')
				Endif
			Case rmvtos.Tdoc = '08'
				If rmvtos.vigv = 1 Then
					vdne = ocomp.obtenernotasdebitoexonerada(rmvtos.Idauto, 'E')
				Else
					vdne = ocomp.obtenerdatosnotasDebito(rmvtos.Idauto, 'E')
				Endif
			Endcase
		Endif
		Select rmvtos
		Skip
	Enddo
	Endfunc
	Function Test()
	Text To lC Noshow
		   select empresa FROM fe_gene WHERE idgene=1
	Endtext
	If This.EjecutaConsulta(lC, 'test') < 1 Then
		Return 0
	Endif
	This.Cmensaje = Test.empresa
	Return 1
	Endfunc
	Function consultarcpexenviarpsysn(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	 \   Select a.ndoc As dcto,a.fech,b.razo,If(a.mone="S","Soles","Dólares") As moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	 \   a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	 \   ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,tcom,Tdoc,rcom_hash
	 \   From fe_rcom As a
	 \   INNER Join fe_clie As b On (a.idcliente=b.idclie)
	 \   Where Year(a.fech)>=2018  And
	 \   a.Acti<>'I' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0' And  Impo<>0 And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	 \   Union All
	  \  Select a.ndoc As dcto,a.fech,b.razo,If(a.mone="S","Soles","Dólares") As moneda,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,
	  \  a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	  \  a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,a.tcom,w.Tdoc,a.rcom_hash
	  \  From fe_rcom As a
	  \  INNER Join fe_clie As b On (a.idcliente=b.idclie)
	  \  INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	  \  INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
      \  Where a.Acti<>'I' And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
      \  And a.Impo<>0  And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	Function consultarcpexenviarpsysg(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\select a.ndoc as dcto,a.fech,b.razo,a.valor,a.rcom_exon,CAST(0 as decimal(12,2)) as inafecto,
	\    a.igv,a.impo,a.fusua,rcom_mens,rcom_arch,mone,a.tdoc,a.ndoc,dolar,idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,concat(TRIM(b.dire),' ',TRIM(b.ciud)) as direccion,tcom,tdoc,rcom_hash
	\    FROM fe_rcom as a JOIN fe_clie as b ON (a.idcliente=b.idclie)
	\    where a.acti<>'I' and LEFT(ndoc,1) in ('F') and left(rcom_mens,1)<>'0'  and impo<>0 and a.tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    union all
	\    SELECT a.ndoc as dcto,a.fech,b.razo,a.valor,a.rcom_exon,CAST(0 as decimal(12,2)) as inafecto,
	\    a.igv,a.impo,a.usua,a.rcom_mens,a.rcom_arch,a.mone,a.tdoc,a.ndoc,a.dolar,a.idauto,b.ndni,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,concat(TRIM(b.dire),' ',TRIM(b.ciud)) as direccion,a.tcom,w.tdoc,a.rcom_hash
	\    FROM fe_rcom as a 
	\    JOIN fe_clie as b ON (a.idcliente=b.idclie)
	\    inner join fe_ncven g on g.ncre_idan=a.idauto 
	\    inner join fe_rcom as w on w.idauto=g.ncre_idau
    \    where a.acti<>'I' AND LEFT(a.ndoc,1) in ('F') and left(a.rcom_mens,1)<>'0'   and a.impo<>0  and w.tdoc='01' and a.tdoc in("07","08") 
    If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
    \order by fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC 
	Function consultarcpexenviarpsysl(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,rcom_otro,
	\    a.igv,a.Impo,rcom_hash,rcom_mens,rcom_arch,mone,a.Tdoc,a.ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,tcom,Tdoc
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    Where  a.Acti<>'I' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'  And  (Impo<>0 Or rcom_otro>0)   And a.Tdoc='01'
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\    Union All
	\    Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,a.rcom_otro,
	\    a.igv,a.Impo,a.rcom_hash,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\    a.ndo2,b.fono,nruc,Concat(Trim(b.Dire),' ',Trim(b.ciud)) As direccion,a.tcom,w.Tdoc
	\    From fe_rcom As a
	\    INNER Join fe_clie As b On (a.idcliente=b.idclie)
	\    INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\    INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
    \   Where a.Acti<>'I' And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'
	\    And w.Tdoc='01' And a.Tdoc In("07","08")
	If This.confechas = 1 Then
	  \ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	 \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarcpexreimprimir()
	Endfunc
	Function consultarcpexenviarpsystr(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,rcom_otro,
	\a.igv,a.Impo,rcom_mens,rcom_arch,mone,a.Tdoc,a.ndoc,dolar,Idauto,b.ndni,a.idcliente,b.clie_corr,
    \ndo2,b.fono,nruc,tcom,a.vigv,Tdoc,rcom_hash
    \From fe_rcom As a
	\Join fe_clie As b On (a.idcliente=b.idclie)
	\Where  a.Acti<>'I' And Left(ndoc,1) In ('F') And Left(rcom_mens,1)<>'0'   And a.Tdoc='01'  And  (Impo<>0 Or rcom_otro>0)
	If goApp.Cdatos = 'S' Then
	   \And  a.codt=<<This.codt>>
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	   \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\Union All
	\Select a.ndoc As dcto,a.fech,b.razo,a.valor,a.rcom_exon,Cast(0 As Decimal(12,2)) As inafecto,a.rcom_otro,
	\a.igv,a.Impo,a.rcom_mens,a.rcom_arch,a.mone,a.Tdoc,a.ndoc,a.dolar,a.Idauto,b.ndni,a.idcliente,b.clie_corr,
	\a.ndo2,b.fono,nruc,a.tcom,a.vigv,w.Tdoc,a.rcom_hash
	\From fe_rcom As a
	\Join fe_clie As b On (a.idcliente=b.idclie)
	\INNER Join fe_ncven g On g.ncre_idan=a.Idauto
	\INNER Join fe_rcom As w On w.Idauto=g.ncre_idau
	\Where a.Acti<>'I' And Left(a.ndoc,1) In ('F') And Left(a.rcom_mens,1)<>'0'  And w.Tdoc='01' And a.Tdoc In("07","08") And nruc<>'***********'
	If goApp.Cdatos = 'S' Then
	  \ And  a.codt=<<This.codt>>
	Endif
	If This.confechas = 1 Then
		\ And  a.fech Between '<<f1>>' And '<<f2>>'
	Endif
	If Len(Alltrim(This.cTdoc)) > 0 Then
	   \ And a.Tdoc='<<this.ctdoc>>'
	Endif
	\ Order By fech,ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function descargarxmlguiadesdedata(carfile, nid)
	Text To lC Noshow Textmerge
       select CAST(guia_xml AS CHAR) AS guia_xml,CAST(guia_cdr AS CHAR) AS guia_cdr FROM fe_guias WHERE guia_idgui=<<nid>>
	Endtext
	If This.EjecutaConsulta(lC, 'filess') < 1 Then
		Return 0
	Endif
	cdr = "R-" + carfile
	If Type('oempresa') = 'U' Then
		crutaxml	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'Firmaxml') + carfile
		crutaxmlcdr	= Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + cdr
	Else
		crutaxml	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'Firmaxml') + Alltrim(Oempresa.nruc)) + carfile
		crutaxmlcdr	= Addbs(Addbs(Addbs(Sys(5) + Sys(2003)) + 'SunatXML') + Alltrim(Oempresa.nruc)) + cdr
	Endif
	This.Cmensaje = ""
	If File(crutaxml) Then
*ocomx.ArchivoXml=Addbs(Sys(5)+Sys(2003)+'\FirmaXML\')+carfile
	Else
		If !Isnull(filess.guia_xml) Then
			cxml = filess.guia_xml
			Strtofile(cxml, crutaxml)
		Else
			This.cmemsaje = "No se puede Obtener el Archivo XML de Envío"
		Endif
	Endif
	cdr = "R-" + carfile
	If File(crutaxmlcdr) Then

	Else
		If !Isnull(filess.guia_cdr) Then
			cdrxml = filess.guia_cdr
			Strtofile(cdrxml, crutaxmlcdr)
		Else
			This.cmemsaje = "No se puede Obtener el Archivo XML de Envío"
		Endif
	Endif
	Return 1
	Endfunc
	Function verificarbajasxanular(Ccursor)
	Text To lC Noshow
         SELECT r.tdoc as Tipo_dcto,r.ndoc as Numero_Dcto,r.fech as fecha,f.baja_fech as fecha_Baja,
		 c.nruc as Ruc,c.ndni as DNI,c.razo as cliente,r.valor as valor_gravado,r.igv,r.impo as Importe,baja_idau FROM fe_bajas f
		 inner join fe_rcom r on r.idauto=f.baja_idau
		 inner join fe_clie as c on c.idclie=r.idcliente
		 where (r.acti='A' or  length(Trim(baja_mens))=0)  order by ndoc;
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
Enddefine




























