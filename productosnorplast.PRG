Define Class productonorplast As producto Of 'd:\capass\modelos\productos'
	dutil1=0
	dutil2=0
	dutil3=0
	prec2=0
	Function Creaproducto()

*cdesc,cunid,nprec,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,cidpc,ncome,ncomc,nutil1,nutil2,nutil3,nidusua,nsmax,nsmin,ccodigo1,ndolar
	lc='FuncreaProductos'
	cur="Xn"
	np1=This.cdesc
	np2=This.cunid
	np3=This.nprec
	np4=This.ncosto
	np5=This.np1
	np6=This.np2
	np7=This.np3
	np8=This.npeso
	np9=This.ccat
	np10=This.cmar
	np11=This.ctipro
	np12=This.nflete
	np13=This.cm
	np14=This.cidpc
	np15=This.ncome
	np16=This.ncomc
	np17=This.nutil1
	np18=This.nutil2
	np19=This.nutil3
	np20=This.nidusua
	np21=This.nsmax
	np22=This.nsmin
	np23=This.ccodigo1
	np24=This.ndolar
	np25=This.dutil1
	np26=This.dutil2
	np27=This.dutil3
	np28=This.prec2
	TEXT to lp noshow
     (?np1,?np2,?np3,?np4,?np5,?np6,?np7,?np8,?np9,?np10,?np11,?np12,?np13,?np14,?np15,?np16,?np17,?np18,?np19,?np20,?np21,?np22,?np23,?np24,?np25,?np26,?np27,?np28)
	ENDTEXT
	nid=This.EJECUTARF(lc,lp,cur)
	If nid<1 Then
		Return 0
	Else
		Return nid
	Endif
	Endfunc

	Function Modificaproducto()
*cdesc,cunid,ncosto,np1,np2,np3,npeso,ccat,cmar,ctipro,nflete,cm,nprec,nidgrupo,nutil1,nutil2,nutil3,ncome,ncomc,nidusua,ncoda,nsmax,nsmin,ccodigo1,ndolar,ce
	lc='PROACTUALIZAPRODUCTOS'
	cur=""
	goapp.npara1=This.cdesc
	goapp.npara2=This.cunid
	goapp.npara3=This.ncosto
	goapp.npara4=This.np1
	goapp.npara5=This.np2
	goapp.npara6=This.np3
	goapp.npara7=This.npeso
	goapp.npara8=This.ccat
	goapp.npara9=This.cmar
	goapp.npara10=This.ctipro
	goapp.npara11=This.nflete
	goapp.npara12=This.cm
	goapp.npara13=This.nprec
	goapp.npara14=This.nidgrupo
	goapp.npara15=This.nutil1
	goapp.npara16=This.nutil2
	goapp.npara17=This.nutil3
	goapp.npara18=This.ncome
	goapp.npara19=This.ncomc
	goapp.npara20=This.nidusua
	goapp.npara21=This.ncoda
	goapp.npara22=This.nsmax
	goapp.npara23=This.nsmin
	goapp.npara24=This.ccodigo1
	goapp.npara25=This.ndolar
	goapp.npara26=This.ce
	goapp.npara27=This.dutil1
	goapp.npara28=This.dutil2
	goapp.npara29=This.dutil3
	goapp.npara30=This.prec2
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,
      ?goapp.npara27,?goapp.npara28,?goapp.npara29,?goapp.npara30)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaCostos10(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11)
	cur=""
	lc="ProActualizaPreciosProducto1"
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function MuestraProductosDescCod10(np1,np2,np3,np4,np5,ccursor)
	lc='PROMUESTRAPRODUCTOS1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	cpropiedad='ListaPreciosPorTienda'
	If !Pemstatus(goapp,cpropiedad,5)
		goapp.AddProperty("ListaPreciosPorTienda","")
	Endif
	If goapp.ListaPreciosPorTienda='S' Then
		TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
		ENDTEXT
	Else
		TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		ENDTEXT
	Endif
	If this.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	RETURN 1
	Endfunc
Enddefine
