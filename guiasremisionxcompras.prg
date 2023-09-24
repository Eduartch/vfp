Define Class guiaremisionxcompras As guiaremision Of 'd:\capass\modelos\guiasremision'
*********************************
	Function CreaTemporalGuiasElectronicasrodi(Calias)
	Create Cursor (Calias)(coda c(15), duni c(20),Descri c(120), unid c(20), cant N(10, 2), Prec N(10, 5), uno N(10, 2), Dos N(10, 2), lote c(15), ;
		peso N(10, 2), alma N(10, 2), ndoc c(12), nreg N(10), codc c(5), tref c(2), Refe c(20), fecr d, detalle c(120), fechafactura d,costo N(10,3),;
		calma c(3), Valida c, nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), fech d, fect d, ptop c(150),;
		ptoll c(120), archivo c(120), valida1 c(1),valido c(1), stock N(10,2),;
		razon c(120), nruc c(11), ndni c(8), conductor c(120), marca c(100), placa c(15),;
		placa1 c(15), constancia c(30), equi N(8,4),prem N(10,4),pos N(3),idepta N(5),;
		brevete c(20), razont c(120), ructr c(11), motivo c(1), codigo c(30),comi N(5,3),idem N(8),;
		tigv N(5,3),caant N(12,2),nlote c(20),fechavto d,tipotra c(15))
	Select (Calias)
	Index On Descri Tag Descri
	Index On nitem Tag Items
	Endfunc
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
		goapp.nidusua,This.detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.Referencia,This.Fechafacturacompra)
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
	goapp.npara14= This.ubigeocliente
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
