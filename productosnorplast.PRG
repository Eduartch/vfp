Define Class productonorplast As Producto Of 'd:\capass\modelos\productos'
	dutil1 = 0
	dutil2 = 0
	dutil3 = 0
	prec2 = 0
	crefe = ""
	cfileprecios=""
	Function CreaProducto()
*cdesc,cunid,nprec,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,cidpc,ncome,ncomc,nutil1,nutil2,nutil3,nidusua,nsmax,nsmin,ccodigo1,ndolar
	lC = 'FuncreaProductos'
	cur = "Xn"
	np1 = This.cdesc
	np2 = This.cunid
	np3 = This.nprec
	np4 = This.ncosto
	np5 = This.np1
	np6 = This.np2
	np7 = This.np3
	np8 = This.npeso
	np9 = This.ccat
	np10 = This.cmar
	np11 = This.ctipro
	np12 = This.nflete
	np13 = This.cm
	np14 = This.cidpc
	np15 = This.ncome
	np16 = This.ncomc
	np17 = This.nutil1
	np18 = This.nutil2
	np19 = This.nutil3
	np20 = This.nidusua
	np21 = This.nsmax
	np22 = This.nsmin
	np23 = This.ccodigo1
	np24 = This.ndolar
	np25 = This.dutil1
	np26 = This.dutil2
	np27 = This.dutil3
	np28 = This.prec2
	Text To lp Noshow
     (?np1,?np2,?np3,?np4,?np5,?np6,?np7,?np8,?np9,?np10,?np11,?np12,?np13,?np14,?np15,?np16,?np17,?np18,?np19,?np20,?np21,?np22,?np23,?np24,?np25,?np26,?np27,?np28,?this.crefe)
	Endtext
	nid = This.EJECUTARf(lC, lp, cur)
	If nid < 1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc

	Function Modificaproducto()
*cdesc,cunid,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,nprec,nidgrupo,nutil1,nutil2,nutil3,ncome,ncomc,nidusua,ncoda,nsmax,nsmin,ccodigo1,ndolar,ce
	lC = 'PROACTUALIZAPRODUCTOS'
	cur = ""
	goApp.npara1 = This.cdesc
	goApp.npara2 = This.cunid
	goApp.npara3 = This.ncosto
	goApp.npara4 = This.np1
	goApp.npara5 = This.np2
	goApp.npara6 = This.np3
	goApp.npara7 = This.npeso
	goApp.npara8 = This.ccat
	goApp.npara9 = This.cmar
	goApp.npara10 = This.ctipro
	goApp.npara11 = This.nflete
	goApp.npara12 = This.cm
	goApp.npara13 = This.nprec
	goApp.npara14 = This.nidgrupo
	goApp.npara15 = This.nutil1
	goApp.npara16 = This.nutil2
	goApp.npara17 = This.nutil3
	goApp.npara18 = This.ncome
	goApp.npara19 = This.ncomc
	goApp.npara20 = This.nidusua
	goApp.npara21 = This.ncoda
	goApp.npara22 = This.nsmax
	goApp.npara23 = This.nsmin
	goApp.npara24 = This.ccodigo1
	goApp.npara25 = This.ndolar
	goApp.npara26 = This.ce
	goApp.npara27 = This.dutil1
	goApp.npara28 = This.dutil2
	goApp.npara29 = This.dutil3
	goApp.npara30 = This.prec2
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,
      ?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30,?this.crefe)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaCostos10(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11)
	cur = ""
	lC = "ProActualizaPreciosProducto1"
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	goApp.npara6 = np6
	goApp.npara7 = np7
	goApp.npara8 = np8
	goApp.npara9 = np9
	goApp.npara10 = np10
	goApp.npara11 = np11
	Text To lp Noshow
	  (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11)
	Endtext
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	ENDIF 
	Return 1
	Endfunc
	Function MuestraProductosDescCod10(np1, np2, np3, np4, np5, Ccursor)
	lC = 'PROMUESTRAPRODUCTOS1'
	goApp.npara1 = np1
	goApp.npara2 = np2
	goApp.npara3 = np3
	goApp.npara4 = np4
	goApp.npara5 = np5
	cpropiedad = 'ListaPreciosPorTienda'
	If !Pemstatus(goApp, cpropiedad, 5)
		goApp.AddProperty("ListaPreciosPorTienda", "")
	Endif
	If goApp.ListaPreciosPorTienda = 'S' Then
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		Endtext
	Else
		Text To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		Endtext
	Endif
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductos1(np1, np2, Ccursor)
	IF this.idsesion>0 then
	    SET DATASESSION TO this.idsesion
	ENDIF     
	lC = 'PROMUESTRAPRODUCTOS'
	goApp.npara1 = np1
	goApp.npara2 = np2
	Text To lp Noshow
     (?goapp.npara1,?goapp.npara2)
	Endtext
	If This.EJECUTARP(lC, lp, Ccursor) < 1 Then
		Return 0
	ENDIF
	RETURN 1
	Endfunc
Enddefine



