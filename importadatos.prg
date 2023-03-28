Define Class importadatos As Odata Of 'd:\capass\database\data'
	ruc=""
	dni=""
	url='http://companiasysven.com'
	Function importaruc()
*Try
	Local ocliente
	ocliente=Createobject("custom")
	ocliente.AddProperty("ruc","")
	ocliente.AddProperty("razon","")
	ocliente.AddProperty("direccion","")
	ocliente.AddProperty("ciudad","")
	ocliente.AddProperty("ubigeo","")
	ocliente.AddProperty("mensaje","")
	ocliente.AddProperty("valor",0)
	ocliente.AddProperty("estado","")
	ocliente.AddProperty("domicilio",0)
	If Len(Alltrim(This.ruc))<>11 Then
		ocliente.mensaje="El RUC es Obligatorio"
		ocliente.valor=0
		Return ocliente
	Endif
	tcruc=This.ruc
	lcToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImVkdWFydGNoQGhvdG1haWwuY29tIn0.ETKCW24wdZCkcfkPupEJTZyrN_-6ntS68MA2ZF9zyxI"
	lcUrl=Textmerge(This.url+"/consulta5.php?cruc=<<tcruc>>")
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('GET', lcUrl, .F.)
	loXmlHttp.Send()
	If loXmlHttp.Status<>200 Then
		ocliente.mensaje="Servicio WEB NO Disponible....."+Alltrim(Str(loXmlHttp.Status))
		ocliente.valor=0
		Return ocliente
	Endif
	This.cmensaje=""
	lcHTML = loXmlHttp.Responsetext
	Set Procedure  To d:\librerias\nfJsonRead.prg Additive
	ocontrib = nfJsonRead(lcHTML)
	If  Vartype(ocontrib.nombre_o_razon_social)<>'U' Then
		ocliente.ruc=This.ruc
		ocliente.razon=Alltrim(ocontrib.nombre_o_razon_social)
		ocliente.estado=Alltrim(ocontrib.estado_del_contribuyente)
		ocliente.domicilio=Alltrim(ocontrib.condicion_de_domicilio)
		If Left(This.ruc,1)<>'1' Then
			ocliente.direccion=Alltrim(ocontrib.direccion)
			ocliente.ciudad=Alltrim(ocontrib.DISTRITO)+' '+Alltrim(ocontrib.PROVINCIA)+' '+Alltrim(ocontrib.DEPARTAMENTO)
			ocliente.ubigeo=Alltrim(ocontrib.ubigeo)
		Else
			ocliente.direccion=""
			ocliente.ciudad=""
		Endif
		If Alltrim(ocontrib.estado_del_contribuyente)<> "ACTIVO" Then
			cmensaje="El Estado del Contribuyente es  "+Alltrim(ocontrib.estado_del_contribuyente)
			ocliente.mensaje=cmensaje
		Endif
		If Alltrim(ocontrib.condicion_de_domicilio)<>"HABIDO"
			cmensaje="El Domicilio del Contribuyente es  "+Alltrim(ocontrib.condicion_de_domicilio)
			ocliente.mensaje=cmensaje
		Endif
		ocliente.valor=1
		Return ocliente
	Else
		ocliente.mensaje="No se puede Obtener Información"
		ocliente.valor=0
		Return ocliente
	Endif
	Endfunc
	Function importardni
	Local ocliente
	ocliente=Createobject("custom")
	ocliente.AddProperty("razon","")
	ocliente.AddProperty("mensaje","")
	ocliente.AddProperty("valor",0)
	lcUrl=Textmerge(This.url+'/consulta5.php?cruc=<<cdni>>')
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('GET', lcUrl, .F.)
	loXmlHttp.Send()
	If loXmlHttp.Status<>200 Then
		ocliente.mensaje="Servicio NO Disponible "+Alltrim(Str(loXmlHttp.Status))
		ocliente.valor=0
		Return ocliente
	Endif
	lcHTML = loXmlHttp.Responsetext
	Set Procedure  To d:\librerias\nfJsonRead.prg Additive
	opersona = nfJsonRead(lcHTML)
	If  Vartype(opersona.nombre)<>'U' Then
		ocliente.razon=Alltrim(opersona.nombre)
		ocliente.valor=1
		Return ocliente
	Else
		ocliente.mensaje="No se puede Obtener Información"
		ocliente.valor=0
		Return ocliente
	Endif
	Endfunc
	Function ubigeos
	lcUrl = Textmerge(This.url+ "/ubigeos.php")
	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	loXmlHttp.Open('GET', lcUrl, .F.)
	loXmlHttp.setRequestHeader("Content-Type", "application/json")
	loXmlHttp.Send()
	If loXmlHttp.Status<>200 Then
		This.cmensaje="Servicio WEB NO Disponible....."+Alltrim(Str(loXmlHttp.Status))
		Return 0
	Endif
	lcHTML = loXmlHttp.Responsetext
	Create Cursor ubigeo(ubigeo c(8),DISTRITO c(70),PROVINCIA c(80),DEPARTAMENTO c(50),clave c(150))
	Set Procedure  To d:\librerias\nfJsonRead.prg Additive
	ubigeos = nfJsonRead(lcHTML)
	For Each oub In ubigeos.Array
		Insert Into ubigeo(ubigeo,DISTRITO,PROVINCIA,DEPARTAMENTO,clave)Values(oub.ubigeo,oub.DISTRITO,oub.PROVINCIA,oub.DEPARTAMENTO,Upper(Trim(oub.DISTRITO)+' '+Trim(oub.PROVINCIA)+' '+Trim(oub.DEPARTAMENTO)))
	Endfor
	Return 1
	Endfunc
	Function ImportaTCSunat(nmes, nanio)
	Local loXmlHttp As "Microsoft.XMLHTTP"
	Local lcHTML, lcUrl, ls_compra, ls_venta
	mensaje("Consultando Tipo de Cambio desde sunat.gob.pe")
	Set Procedure To d:\librerias\json Additive
	nm	  = Iif(nmes <= 9, '0' + Alltrim(Str(nmes)), Alltrim(Str(nmes)))
	na	  = Alltrim(Str(nanio))
	lcUrl = Textmerge(This.url+"/tc.php")
	fi	  = na + '-' + nm + '-01'
	dfecha2	= Dtos(Ctod('01/' + Trim(Str(Iif(nmes < 12, nmes + 1, 1))) + '/' + Trim(Str(Iif(nmes < 12, nanio, nanio + 1)))))
	ff		= Left(dfecha2, 4) + '-' + Substr(dfecha2, 5, 2) + '-' + Right(dfecha2, 2)

	loXmlHttp = Createobject("Microsoft.XMLHTTP")
	TEXT To cdata Noshow Textmerge
	{
	"dfi":"<<fi>>",
	"dff":"<<ff>>"
	}
	ENDTEXT
	loXmlHttp.Open('POST', lcUrl, .F.)
	loXmlHttp.setRequestHeader("Content-Type", "application/json")
	loXmlHttp.Send(cdata)
	If loXmlHttp.Status <> 200 Then
		This.cmensaje="Servicio WEB NO Disponible....." + Alltrim(Str(loXmlHttp.Status))
		Return 0
	Endif
	lcHTML = Chrtran(loXmlHttp.Responsetext, '-', '')
	If 	(Atc("precio_compra", lcHTML) > 0) && si tiene la palabra compra es válido
		Create Cursor CurTCambio(DIA N(2), TC_COMPRA N(5, 3), TC_VENTA N(5, 3))
		otc = json_decode(lcHTML)
		If Not Empty(json_getErrorMsg())
			This.cmensaje="No se Pudo Obtener la Información " + json_getErrorMsg()
			Return 0
		Endif
		x = 0
		For i = 1 To otc._Data.getSize()
			x	   = x + 1
			ovalor = otc._Data.Get(x)
			If (Vartype(ovalor) = 'O') Then
				fecha	  = ovalor.Get("fecha")
				ls_compra = ovalor.Get("precio_compra")
				ls_venta  = ovalor.Get('precio_venta')
				d		  = Val(Right(fecha, 2))
				Insert Into CurTCambio(DIA, TC_COMPRA, TC_VENTA)Values(d, Val(ls_compra), Val(ls_venta))
			Endif
		NEXT
		this.cmensaje=''
		RETURN 1
	Else
		this.cmensaje='No se encontro información para Tipo de Cambio'
		RETURN 0
	Endif
	Endfunc
Enddefine
