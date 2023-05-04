Define Class usuarios As Odata Of 'd:\capass\database\data.prg'
	Function mostrarusuarios(ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
      SELECT idusua,nomb,clave,activo,tipo FROM fe_usua WHERE activo="S"  ORDER BY nomb
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscausuario(cmodo,nidus,cnombre)
	If cmodo="N"
		TEXT TO lc NOSHOW TEXTMERGE
        SELECT idusua FROM fe_usua WHERE tRIM(nomb)='<<cnombre>>'  AND activo='S'
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
          SELECT idusua FROM fe_usua WHERE TRIM(nomb)='<<cnombre>>' AND idusua<><<nidsus>> AND activo<>'S'
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,'ya')<1
		Return 0
	Endif
	If ya.idusua>0 Then
		This.Cmensaje="Nombre de Usuario Ya Registrado"
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function MostrarUsuarios1(np1,np2,np3,ccur)
	lc="ProMuestraUsuarios"
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarpassword(np1,np2)
	cpass=Alltrim(np2)
	TEXT TO lc NOSHOW textmerge
	  UPDATE fe_usua SET clave='<<cpass>>' WHERE idusua=<<np1>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	This.Url="http://companiasysven.com/app88/enc.php"
	If  Type('oempresa') = 'U' Then
		cruc=fe_gene.nruc
	Else
		cruc=oempresa.nruc
	Endif
	TEXT TO cdata NOSHOW TEXTMERGE
	{
    "nruc":"<<cruc>>",
    "idusua":<<np1>>,
    "valor":"<<cpass>>"
    }
	ENDTEXT
*	MESSAGEBOX(cdata,16,'hola')
	oHTTP = Createobject("MSXML2.XMLHTTP")
	oHTTP.Open("post", This.Url, .F.)
	oHTTP.setRequestHeader("Content-Type", "application/json")
	oHTTP.Send(cdata)
*	MESSAGEBOX(oHttp.Responsebody)
	Return 1
	Endfunc
	Function obtenercontraseña(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
        SELECT idusua,nomb,clave FROM fe_usua WHERE idusua=<<np1>>  AND activo='S'
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc

Enddefine
