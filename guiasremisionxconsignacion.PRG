Define Class guiaremisionxconsignacion As guiaremision Of 'd:\capass\modelos\guiasremision'
	Function grabarx3()
	Set DataSession To This.idsesion
	If This.validar()<1 Then
		Return  0
	Endif
	If This.iniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=IngresaResumenDcto('09','E',This.ndoc ,This.Fecha,This.Fecha,"",;
		this.nvalor,This.nigv,This.ntotal,'','S',fe_gene.dola,fe_gene.igv,'k',This.Codigo,;
		'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0)
	If nauto<1
		This.DeshacerCambios()
		Return 0
	Endif
	nidg=This.IngresaGuiasConsignacionx3(This.Fecha,This.ptop,This.ptoll,nauto,This.Fechat,;
		goapp.nidusua,This.Detalle,this.Idtransportista,This.ndoc,'N',this.codigo,this.ubigeocliente,this.codt)
	If nidg<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select ltmpvg
	sws=1
	Go Top
	Do While !Eof()
		If goapp.tiponegocio='D' Then
			dfv=Ctod("01/01/0001")
			nidkar=IngresaKardexFl(nauto,ltmpvg.coda,'V',ltmpvg.Prec,ltmpvg.cant,'I','K',0,goapp.tienda,0,0,ltmpvg.equi,;
				ltmpvg.unid,ltmpvg.idepta,ltmpvg.pos,ltmpvg.costo,fe_gene.igv,Iif(Empty(ltmpvg.fechavto),dfv,ltmpvg.fechavto),ltmpvg.nlote)
		Else
			nidkar=IngresaKardexUAl(nauto,ltmpvg.coda,'V',ltmpvg.Prec,ltmpvg.cant,'I','K',0,goapp.tienda,0,0,;
				ltmpvg.unid,ltmpvg.idepta,ltmpvg.pos,ltmpvg.costo/fe_gene.igv,fe_gene.igv)
		Endif
		If nidkar=0
			sws=0
			Exit
		Endif
		If GrabaDetalleGuiasCons(ltmpvg.coda,ltmpvg.cant,nidg,nidkar)=0
			sws=0
			Exit
		Endif
		If Actualizastock1(ltmpvg.coda,goapp.tienda,ltmpvg.cant,'V',ltmpvg.equi)=0 Then
			sws=0
			Exit
		Endif
		Select ltmpvg
		Skip
	Enddo
	If sws=0 Then
		This.DeshacerCambios()
		This.cmensaje="El Item:"+Alltrim(ltmpvg.Desc)+" - " +"Unidad:"+ltmpvg.unid+" NO TIENE STOCK DISPONIBLE"
		Return 0
	Endif
	If 	This.generacorrelativo()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Select * From (This.calias) Into Cursor tmpvg Readwrite
	This.imprimir('S')
	Return 1
	Endfunc
	Function IngresaGuiasConsignacionx3(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11, np12,np13)
	Local lc, lp
	lc			  = "FUNINGRESAGUIASCons"
	cur			  = "yy"
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
	goapp.npara12 = np13
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	nidguia=This.EJECUTARF(lc, lp, cur)
	If nidguia<1 Then
		Return 0
	Endif
	Return nidguia
	Endfunc

Enddefine
