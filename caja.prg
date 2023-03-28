Define Class caja As Odata Of "d:\capass\database\data.prg"
	Function Registrarcaja(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12, np13, np14, np15)
	Local lc, lp
*:Global cur
	m.lc		  = "ProIngresaDatosLcajaEefectivo11"
	cur			  = ""
	goapp.npara1  = m.np1
	goapp.npara2  = m.np2
	goapp.npara3  = m.np3
	goapp.npara4  = m.np4
	goapp.npara5  = m.np5
	goapp.npara6  = m.np6
	goapp.npara7  = m.np7
	goapp.npara8  = m.np8
	goapp.npara9  = m.np9
	goapp.npara10 = m.np10
	goapp.npara11 = m.np11
	goapp.npara12 = m.np12
	goapp.npara13 = m.np13
	goapp.npara14 = m.np14
	goapp.npara15 = m.np15
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,
      ?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function buscasiestaregistradodcto(np1, np2)
	Local lc
	TEXT To m.lc Noshow Textmerge
			 Select  lcaj_idca  As idcaja  From fe_lcaja Where lcaj_dcto='<<np1>>' And lcaj_acti = 'A'  And lcaj_tdoc = '<<np2>>'
	ENDTEXT
	If This.EjecutaConsulta(m.lc, 'yaestaencaja') < 1 Then
		Return 0
	Endif
	If yaestaencaja.idcaja > 0 Then
		This.Cmensaje='Ya esta Registrado el Número del Documento'
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarCajaChicaNotaria(np1, ccursor)
	Local lc
	TEXT To m.lc Noshow Textmerge
	   Select  lcaj_dcto As dcto, lcaj_deud As importe,lcaj_deta as detalle, lcaj_fope As fechahora
	   From fe_lcaja
	   Where lcaj_fech='<<np1>>'   And lcaj_acti = 'A'  lcaj_idus = 0   And lcaj_tdoc = 'Ti'  Order By lcaj_dcto
	ENDTEXT
	If This.EjecutaConsulta(m.lc, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function buscaropencaja(np1)
	ccursor='C'+Sys(2015)
	TEXT TO lc NOSHOW textmerge
	      SELECT lcaj_ndoc  as operacion FROM fe_lcaja WHERE TRIM(lcaj_ndoc)='<<np1>>' AND lcaj_acti='A'  AND lcaj_deud>0 limit 1
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	If !Empty(operacion) Then
		This.Cmensaje='Número de Depósito Ya Registrado'
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
