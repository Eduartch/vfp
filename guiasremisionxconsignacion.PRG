Define Class guiaremisionxconsignacion As guiaremision Of 'd:\capass\modelos\guiasremision'
	If This.iniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=IngresaResumenDcto('09','E',;
		this.ndoc ,This.Fecha,This.Fecha,"",nv,nigv,nt,'','S',;
		fe_gene.dola,fe_gene.igv,'k',This.Codigo,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0)
	If nauto<1
		This.DeshacerCambios()
		Return 0
	Endif
	nidg=IngresaGuiasConsignacionx3(This.Fecha,This.ptop,This.ptoll,nauto,This.Fechat,;
		goapp.nidusua,This.Detallecreditos ,idtr1,This.ndoc,'C')
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
		This.cmensaje="El Item:"+Alltrim(ltmpvg.Desc)+" - " +"Unidad:"+ltmpvg.unid+" NO TIENE STOCK DISPONIBLE",16,'Sisven')
		Return 0
	Endif

	If 	This.generacorrelativo()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Return 1
Enddefine
