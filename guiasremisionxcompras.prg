Define Class guiaremisionxcompras As GuiaRemision Of 'd:\capass\modelos\guiasremision'
	Function CreaTemporalGuiasElectronicasRodi(Calias)
	Create Cursor (Calias)(coda c(15), duni c(20), Descri c(120), Unid c(20), cant N(10, 4), Prec N(10, 5), uno N(10, 2), Dos N(10, 2), lote c(15), ;
		  Peso N(10, 2), alma N(10, 2), Ndoc c(12), nreg N(10), codc c(5), tref c(2), Refe c(20), fecr d, Detalle c(120), fechafactura d, costo N(10, 3), ;
		  calma c(3), Valida c, Nitem N(3), saldo N(10, 2), idin N(8), nidkar N(10), coda1 c(15), fech d, fect d, ptop c(150), ;
		  ptoll c(120), Archivo c(120), valida1 c(1), valido c(1), stock N(10, 2), ;
		  razon c(120), nruc c(11), ndni c(8), conductor c(120), marca c(100), Placa c(15), ;
		  placa1 c(15), Constancia c(30), equi N(8, 4), prem N(10, 4), pos N(3), idepta N(5), ;
		  brevete c(20), razont c(120), ructr c(11), Motivo c(1), Codigo c(30), comi N(5, 3), idem N(8), ;
		  tigv N(5, 3), caant N(12, 2), nlote c(20), fechavto d, tipotra c(15))
	Select (Calias)
	Index On Descri Tag Descri
	Index On Nitem Tag Items
	Endfunc
	Function Grabar()
	If This.IniciaTransaccion() < 1Then
		Return 0
	Endif
	If This.Idautog > 0 Then
		If AnulaGuiasVentas(This.Idautog, goApp.nidusua) = 0 Then
			Return 0
		Endif
	Endif
	nidg = This.IngresaGuiasXComprasRemitente(This.Fecha, This.ptop, This.ptoll, 0, This.fechat, goApp.nidusua, This.Detalle, This.Idtransportista, This.Ndoc, goApp.Tienda, This.Referencia, This.Fechafacturacompra)
	If nidg < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s = 1
	Do While !Eof()
		If This.GrabaDetalleGuiasRCompras(tmpvg.coda, tmpvg.cant, nidg, tmpvg.Codigo) < 1  Then
			s = 0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If This.GeneraCorrelativo() = 1  And s = 1 Then
		If This.GRabarCambios() = 0 Then
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
	Local lC, lp
*:Global cur
	lC			  = "FunIngresaGuiasxComprasRemitente"
	cur			  = "YY"
	goApp.npara1  = np1
	goApp.npara2  = np2
	goApp.npara3  = np3
	goApp.npara4  = np4
	goApp.npara5  = np5
	goApp.npara6  = np6
	goApp.npara7  = np7
	goApp.npara8  = np8
	goApp.npara9  = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	goApp.npara12 = np12
	goApp.npara13 = This.idprov
	goApp.npara14 = This.ubigeocliente
	Text To lp Noshow Textmerge
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,
     ?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14)
	Endtext
	nidy = This.EJECUTARf(lC, lp, cur)
	If nidy < 1 Then
		Return 0
	Endif
	Return nidy
	Endfunc
	Function GrabaDetalleGuiasRCompras(np1, np2, np3, np4)
	Local lC, lp
	lC			 = "ProIngresaDetalleGuiaRCompras"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	Endtext
	If This.EJECUTARP(lC, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarguia()
	If  Type('oempresa') = 'U' Then
		Cruc = fe_gene.nruc
	Else
		Cruc = Oempresa.nruc
	Endif
	Do Case
	Case  This.idprov < 1
		This.Cmensaje = "Ingrese El Proveedor"
		Return 0
*!*		Case This.nruc = Cruc
*!*			This.Cmensaje = "El Remitente no puede Ser la misma Empresa"
*!*			Return 0
	Endcase
	If This.Validar() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






