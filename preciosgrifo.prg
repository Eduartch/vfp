Define Class Preciosproductos As Odata Of 'd:\capass\database\data.prg'
	codigo=0
	CodProducto=0
	CodCliente=0
	Nprecio=0
	Cestado=""
	Nopcion=0
	placa=""
	Function RegistraPreciosXCliente
	lc='ProIngresaPrecioxCliente'
	cur=""
	goapp.npara1=This.CodProducto
	goapp.npara2=This.CodCliente
	goapp.npara3=This.Nprecio
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If  This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraPreciosXCliente20
	lc='ProIngresaPrecioxCliente'
	cur=""
	goapp.npara1=This.CodProducto
	goapp.npara2=This.CodCliente
	goapp.npara3=This.Nprecio
	goapp.npara4=This.placa
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Procedure ActualizaPreciosPorCliente
	lc='ProActualizaPrecioxCliente'
	cur=""
	goapp.npara1=This.CodProducto
	goapp.npara2=This.CodCliente
	goapp.npara3=This.Nprecio
	goapp.npara4=This.codigo
	goapp.npara5=This.Nopcion
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Endif
	Return 1
	Endproc

	Procedure ActualizaPreciosPorCliente20
	lc='ProActualizaPrecioxCliente'
	cur=""
	goapp.npara1=This.CodProducto
	goapp.npara2=This.CodCliente
	goapp.npara3=This.Nprecio
	goapp.npara4=This.codigo
	goapp.npara5=This.Nopcion
	goapp.npara6=This.placa
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	If EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Endif
	Return 1
	Endproc

	Procedure ListarPreciosclientes
	Lparameters	np1,ccursor
	lc='ProListarPrecioxCliente'
	goapp.npara1=np1
	TEXT to lp noshow
          (?goapp.npara1)
	ENDTEXT
	If EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure ObtenerPrecioCliente
	Lparameters	np1,np2,ccursor
	lc='ProListarPrecioxClienteproducto'
	goapp.npara1=np1
	goapp.npara2=np2
	TEXT to lp noshow
          (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure ObtenerPrecioCliente20
	Lparameters	np1,np2,np3,ccursor
	lc='ProListarPrecioxClienteproductoxplaca'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp noshow
          (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If EJECUTARP(lc,lp,ccursor)< 1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Procedure ListarPreciosclientesxplaca
	Lparameters	np1,np2,ccursor
	lc='ProListarPrecioxClientexplaca'
	goapp.npara1=np1
	goapp.npara2=np2
	TEXT to lp noshow
          (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endproc
	Function listarprecios20(np,ccursor)
	If np=0 Then
		TEXT TO lc NOSHOW TEXTMERGE
		SELECT a.descri,c.razo,l.prec_plac,l.prec_prec,l.prec_idpr FROM fe_preciocliente AS l
		INNER JOIN fe_clie AS c ON c.idclie=l.`prec_idcl`
		INNER JOIN fe_art AS a ON a.`idart`=l.`prec_idar`
		WHERE l.`prec_acti`='A' ORDER BY descri,razo
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
		SELECT a.descri,c.razo,l.prec_plac,l.prec_prec,l.prec_idpr FROM fe_preciocliente AS l
		INNER JOIN fe_clie AS c ON c.idclie=l.`prec_idcl`
		INNER JOIN fe_art AS a ON a.`idart`=l.`prec_idar`
		WHERE l.`prec_acti`='A' and l.prec_idar=<<np>> ORDER BY descri,razo
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizaenbloque(ccursor,Nprecio)
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.CONTRANSACCION='S'
	Select (ccursor)
	sw=1
	Scan All
		Select (ccursor)
		nid=prec_idpr
		TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_preciocliente SET prec_prec=<<nprecio>> where prec_idpr=<<nid>>
		ENDTEXT
		If This.ejecutarsql(lc)<1 Then
			sw=0
			Exit
		Endif
	Endscan
	If sw=0 Then
		This.CONTRANSACCION=''
		If This.DeshacerCambios()>1 Then
			This.Cmensaje="Se Deshacieron los Cambios Ok"
			Return 0
		Else
			This.Cmensaje="No Se Deshacieron los Cambios Ok"
			Return 0
		Endif
	Else
		This.CONTRANSACCION=''
		If This.GrabarCambios()=1 Then
			Return 1
		Else
			Return 0
		Endif
	Endif
	Endfunc
Enddefine
