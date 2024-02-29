#Define Url  'http://companiasysven.com'
#Define mensajeError 'NO Se Anulo Correctamente de la Base de Datos'
Define Class bajas As Odata Of 'd:\capass\database\data.prg'
    conticket=""
	Function consultarbaja(cticket, odcto)
	Local lc, lcr
	np3		= "0 La Comunicación de Baja  ha sido aceptado desde APISUNAT"
	Text To lcr Noshow Textmerge
        UPDATE fe_bajas SET baja_mens='<<np3>>' WHERE baja_tick='<<cticket>>';
	Endtext
	Sw	 = 1
	np1	  = odcto.Idauto
	odvto = This.ConsultaApisunat(odcto.Tdoc, odcto.serie, Alltrim(odcto.nume), odcto.fech, Alltrim(Str(odcto.Impo, 12, 2)))
	Do Case
	Case  odvto.vdvto = '2'
		Do Case
		Case Lower(odcto.Proc) = 'rnnorplast'
			Set Procedure To (odcto.Proc) Additive
			If AnulaTransaccionN('', '', 'V', odcto.Idauto, odcto.idusua, "", Ctod(odcto.fech), goApp.uauto, 0) = 0 Then
				This.Cmensaje = mensajeError
				Return 0
			Endif
		Case Lower(odcto.Proc) = 'rnftr'
			Set Procedure To (odcto.Proc) Additive
			If AnulaTransaccionN('', '', 'V', odcto.Idauto, odcto.idusua, "", Ctod(odcto.fech), goApp.idcajero, 0) = 0 Then
				This.Cmensaje = mensajeError
				Return 0
			Endif
		Case Lower(odcto.Proc) = 'rnxm'
			Set Procedure To (odcto.Proc) Additive
			If AnulaTransaccionN('', '', 'V', odcto.Idauto, odcto.idusua, "", Ctod(odcto.fech), goApp.idcajero, 0) = 0 Then
				This.Cmensaje = mensajeError
				Return 0
			Endif
		Otherwise
			If AnulaTransaccionConMotivo('', '', 'V', odcto.Idauto, odcto.idusua, 'S', Ctod(odcto.fech), goApp.uauto, odcto.Detalle) = 0 Then
				This.Cmensaje = mensajeError
				Return 0
			Endif
		Endcase
		IF this.conticket='S' then
			If This.Ejecutarsql(lcr) < 1 Then
				Return 0
			Endif
		Endif
		This.Cmensaje = "Proceso Culminado Correctamente"
		Return 1
	Case  odvto.vdvto = '7'
		This.Cmensaje = "No se puede Obtener Respuesta desde el Servidor...no Existen las Credenciales para hacer la Consulta"
	Otherwise
		This.cmensaje = "Respuesta del Servidor " + Alltrim(odvto.vdvto)
	Endcase
	Return 0
	Endfunc
	Function ConsultaApisunat
	Lparameters cTdoc, Cserie, cnumero, dFecha, nimpo
	Local Obj As "empty"
	Local oHTTP As "MSXML2.XMLHTTP"
	Local lcHTML
	Obj		  = Createobject("empty")
	pURL_WSDL = Url + "/ccpe.php"
	If Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Text To cdata Noshow Textmerge
	{
	"ruc":"<<cruc>>",
	"tdoc":"<<ctdoc>>",
	"serie":"<<cserie>>",
	"cndoc":"<<cnumero>>",
	"cfecha":"<<dfecha>>",
	"cimporte":"<<nimpo>>"
	}
	Endtext
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", pURL_WSDL, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
	If oHTTP.Status <> 200 Then
		AddProperty(Obj, "vdvto", '-1')
		AddProperty(Obj, "mensaje", "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status)))
		This.Cmensaje = "Servicio WEB NO Disponible....." + Alltrim(Str(oHTTP.Status))
		Return Obj
	Endif
	lcHTML = oHTTP.responseText
	Set Procedure To d:\librerias\nfJsonRead.prg Additive
	ocomp = nfJsonRead(lcHTML)
	If  Vartype(ocomp.Mensaje) <> 'U' Then
		AddProperty(Obj, "vdvto", ocomp.estadocomprobante)
		AddProperty(Obj, "estadoruc", ocomp.estadoruc)
		AddProperty(Obj, "estadodom", ocomp.condomicilio)
		AddProperty(Obj, "mensaje", ocomp.mensaje)
	Else
		AddProperty(Obj, "vdvto", '')
		AddProperty(Obj, "estadoruc", '')
		AddProperty(Obj, "estadodom", '')
		AddProperty(Obj, "mensaje", 'Sin Obtener la Respuesta de la Consulta')
	Endif
	Return Obj
	Endfunc
	Function verificaSiestaAnulada(cndoc, cTdoc)
	Local lc
	Text To lc Noshow Textmerge
     select  COUNT(*) as idauto from fe_rcom where ndoc='<<cndoc>>' and tdoc='<<ctdoc>>' and impo=0 and idcliente>0 and acti='A' group by ndoc limit 1
	Endtext
	If This.EjecutaConsulta(lc, 'anulada') < 1 Then
		Return 0
	Endif
	Select anulada
	nidauto = Iif(Vartype(anulada.Idauto) = 'C', Val(anulada.Idauto), Idauto)
	If nidauto > 0 Then
		this.cmensaje='Ya está Registrada como Anulada'
		Return  0
	Else
		Return  1
	Endif
	Endfunc
Enddefine