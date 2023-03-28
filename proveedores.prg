#Define ERRORPROC "Error "
#Define MSGTITULO "SISVEN"
Set Procedure To d:\capass\CAPADATOS.prg, d:\capasss\ple5.prg Additive
Define Class proveedor As Odata OF 'd:\capass\database\data' 
	codigo	   =0
	nruc	   =""
	nombre	   =""
	direccion  =""
	ciudad	   =""
	fono	   =""
	fax		   =""
	ndni	   =""
	tipo	   =""
	correo	   =""
	Vendedor   =0
	usuario	   =0
	pc		   =""
	Celular	   =""
	Refe	   =""
	linea	   =0
	Rpm		   =""
	zona	   =0
	idsegmento =0
	Cmensaje   =""
	Procedure AsignaValores
	Lparameters codigo, cnruc, crazo, cdire, cciud, cfono, cfax, cdni, ctipo, cemail, nidven, cusua, cidpc, ccelu, crefe, linea, crpm, nidz
	This.codigo	   =m.codigo
	This.nruc	   =m.cnruc
	This.nombre	   =m.crazo
	This.direccion =m.cdire
	This.ciudad	   =m.cciud
	This.fono	   =m.cfono
	This.fax	   =m.cfax
	This.ndni	   =m.cdni
	This.tipo	   =m.ctipo
	This.correo	   =m.cemail
	This.Vendedor  =m.nidven
	This.usuario   =m.cusua
	This.pc		   =m.cidpc
	This.Celular   =m.ccelu
	This.Refe	   =m.crefe
	This.linea	   =m.linea
	This.Rpm	   =m.crpm
	This.zona	   =m.nidz
	Endproc
	Function Creaproveedor
	Local lc, lp
*:Global Cmensaje, cur
	m.lc		  ='funcreaproveedor'
	cur			  ="xt"
	goapp.npara1  =This.nruc
	goapp.npara2  =This.nombre
	goapp.npara3  =This.direccion
	goapp.npara4  =This.ciudad
	goapp.npara5  =This.fono
	goapp.npara6  =This.fax
	goapp.npara7  =This.ndni
	goapp.npara8  =This.tipo
	goapp.npara9  =This.correo
	goapp.npara10 =This.Vendedor
	goapp.npara11 =This.usuario
	goapp.npara12 =This.pc
	goapp.npara13 =This.Celular
	goapp.npara14 =This.Refe
	goapp.npara15 =This.linea
	goapp.npara16 =This.Rpm
	goapp.npara17 =This.zona
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	ENDTEXT
	If this.EJECUTARF(m.lc, m.lp, cur) = 0 Then
		Return 0
	Else
		Return xt.Id
	Endif
	Endfunc
	Procedure Actualizaproveedor
	Local lc, lp
*:Global cur
	m.lc		  ='proactualizaproveedor'
	cur			  =""
	goapp.npara1  =This.codigo
	goapp.npara2  =This.nruc
	goapp.npara3  =This.nombre
	goapp.npara4  =This.direccion
	goapp.npara5  =This.ciudad
	goapp.npara6  =This.fono
	goapp.npara7  =This.fax
	goapp.npara8  =This.ndni
	goapp.npara9  =This.tipo
	goapp.npara10 =This.correo
	goapp.npara11 =This.Vendedor
	goapp.npara12 =This.usuario
	goapp.npara13 =This.Celular
	goapp.npara14 =This.Refe
	goapp.npara15 =This.linea
	goapp.npara16 =This.Rpm
	goapp.npara17 =This.zona
	Text To m.lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
	      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17)
	ENDTEXT
	If this.EJECUTARP(m.lc, m.lp, cur) = 0 Then
		Return 0
	Else
		Return  1
	Endif
	Endproc
	Procedure Listarproveedores
	Lparameters	np1, np2, np3, nombrecursor
	Local lparametros
*:Global cproc
	cproc		 =""
	cproc		 ='promuestraproveedor'
	goapp.npara1 =m.np1
	goapp.npara2 =m.np2
	goapp.npara3 =m.np3
	Text To m.lparametros Noshow
          (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If this.EJECUTARP10(cproc, m.lparametros, m.nombrecursor) < 1 Then
    	Return 0
	Else
		Return 1
	Endif
	Endproc
Enddefine

