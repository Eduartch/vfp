Define Class guiaremisionxcompras As guiaremision Of 'd:\capass\modelos\guiasremision'
	Function grabar()
	If This.IniciaTransaccion()<1Then
		Return 0
	Endif
	If This.Idautog>0 Then
		If AnulaGuiasVentas(This.Idautog,goapp.nidusua)=0 Then
			Return 0
		Endif
	Endif
	nidg=This.IngresaGuiasXComprasRemitente(This.fecha,This.ptop,This.ptoll,0,This.fechat,;
		goapp.nidusua,This.Detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.Referencia,This.Fechafacturacompra)
	If nidg<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s=1
	Do While !Eof()
		If This.GrabaDetalleGuiasRCompras(tmpvg.coda,tmpvg.cant,nidg,tmpvg.codigo)=0 Then
			s=0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.generacorrelativo()=1  And s=1 Then
		If This.GRabarCambios()=0 Then
			Return 0
		Endif
    	This.Imprimir('S')
		Return  1
	Else
		This.DEshacerCambios()
		Return 0
	Endif
	Endfunc
	Function IngresaGuiasXComprasRemitente(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12)
	Local lc, lp
*:Global cur
	lc			  = "FunIngresaGuiasxComprasRemitente"
	cur			  = "YY"
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
	goapp.npara13 =This.idprov
	goapp.npara14= this.ubigeocliente
	TEXT To lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,
     ?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	ENDTEXT
	nidy=This.EJECUTARF(lc, lp, cur)
	If nidy< 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function GrabaDetalleGuiasRCompras(np1, np2, np3, np4)
	Local lc, lp
*:Global cur
	lc			 = "ProIngresaDetalleGuiaRCompras"
	cur			 = ""
	goapp.npara1 = np1
	goapp.npara2 = np2
	goapp.npara3 = np3
	goapp.npara4 = np4
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lc, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function validarguia()
	If This.idprov<1 Then
		This.cmensaje="Ingrese El Proveedor"
		Return 0
	Endif
	If This.validar()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
