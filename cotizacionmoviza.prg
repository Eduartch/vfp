Define Class cotizacionmoviza As cotizacion Of  d:\capass\modelos\cotizacion
	Function registrar()
	If This.IniciaTransaccion()<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nid=This.IngresaResumenPedidosM()
	If nid<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GrabarDetalle()<1 Or  This.generacorrelativo()<1
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizar()
	If This.IniciaTransaccion()<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nid=This.ActualizaResumenPedidosM()
	If nid<1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If  This.GrabarDetalle()<1
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaResumenPedidosM()
*!*		dfech,nidclie,cndoc,'01',nimpo,cform,cusua,cidpcped,nidven,nidtienda,'p',caten,cforma,cplazo,cvalidez,centrega,cdetalle,Left(Thisform.cmbMONEDA.Value,1),'','','','',10
	Local cur As String
	lc='FUNINGRESACABECERACOTIZACION1'
	cur="Res"
	goapp.npara1=This.dfech
	goapp.npara2=This.nidclie
	goapp.npara3=This.cndoc
	goapp.npara4=This.ctdoc
	goapp.npara5=This.nimpo
	goapp.npara6=This.cform
	goapp.npara7=goapp.nidusua
	goapp.npara8=Id()
	goapp.npara9=This.nidven
	goapp.npara10=goapp.tienda
	goapp.npara11='p'
	goapp.npara12=This.caten
	goapp.npara13=This.cform
	goapp.npara14=This.cplazo
	goapp.npara15=This.cvalidez
	goapp.npara16=This.centrega
	goapp.npara17=This.cdetalle
	goapp.npara18=This.cmoneda
	goapp.npara19=""
	goapp.npara20=""
	goapp.npara21=""
	goapp.npara22=""
	goapp.npara23=This.ndias
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
	ENDTEXT
	nidp=This.EJECUTARF(lc,lp,cur)
	If nidp<1 Then
		Return 0
	Endif
	Return nidp
	Endfunc
*******************
	Function ActualizaResumenPedidosM()
*!*		np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23
*!*	dfech,tmpp.codc,cndoc,'',nimpo,cform,goapp.nidusua,nidven,nidtienda,'p',caten,cforma,cplazo,cvalidez,centrega,cdetalle,Left(Thisform.cmbMONEDA.Value,1),'',nid,'','','',10
	Local cur As String
	lc='PROACTUALIZACotizacion1'
	cur=""
	goapp.npara1=This.dfech
	goapp.npara2=This.nidclie
	goapp.npara3=This.cndoc
	goapp.npara4=This.ctdoc
	goapp.npara5=This.nimpo
	goapp.npara6=This.cform
	goapp.npara7=goapp.nidusua
	goapp.npara8=This.nidven
	goapp.npara9=goapp.tienda
	goapp.npara10='p'
	goapp.npara11=This.caten
	goapp.npara12=This.cform
	goapp.npara13=This.cplazo
	goapp.npara14=This.cvalidez
	goapp.npara15=This.centrega
	goapp.npara16=This.cdetalle
	goapp.npara17=This.cmoneda
	goapp.npara18=""
	goapp.npara19=This.nidautop
	goapp.npara20=""
	goapp.npara21=""
	goapp.npara22=""
	goapp.npara23=This.ndias
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function generacorrelativo()
	Set Procedure To d:\capass\modelos\correlativos Additive
	ocorr = Createobject("correlativo")
	ocorr.ndoc = This.cndoc
	ocorr.nsgte = This.nsgte
	ocorr.Idserie = This.nidserie
	If ocorr.generacorrelativo() < 1  Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarDetalle()
	x=1
	Select tmpp
	Set Deleted Off
	Go Top
	Do While !Eof()
		ncoda=tmpp.coda
		ncant=tmpp.cant
		nprec=tmpp.Prec
		If tmpp.nreg=0
			If IngresaDCotizacion(tmpp.coda,tmpp.cant,tmpp.Prec,nid)=0
				x=0
				Exit
			Endif
		Else
			If ActualizaDCotizacion(tmpp.coda,tmpp.cant,tmpp.Prec,tmpp.nreg,1)=0
				x=0
				Exit
			Endif
			If Deleted()
				If ActualizaDCotizacion(tmpp.coda,tmpp.cant,tmpp.Prec,tmpp.nreg,0)=0
					x=0
					Exit
				Endif
			Endif
		Endif
		Select tmpp
		Skip
	Enddo
	Set Deleted On
	If x=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarporid(calias)
	TEXT TO lcpp NOSHOW TEXTMERGE
	SELECT p.idart,descri,unid,peso,p.cant,p.prec,uno,dos,tre,cua,c.idclie,c.ndni,c.nruc,c.razo,c.dire,c.ciud,r.idautop FROM fe_rped AS r
	INNER JOIN fe_ped AS p ON p.`idautop`=r.`idautop`
	INNER JOIN fe_art AS a ON a.idart=p.idart
	INNER JOIN fe_clie AS c ON c.`idclie`=r.`idclie`
	WHERE r.`idautop`=<<this.nidautop>> AND p.acti='A' order by p.idped
	ENDTEXT
	If This.EJECUTACONSULTA(lcpp,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcotizaciones(ccursor)
	fi=cfechas(This.dfi)
	ff=cfechas(This.dff)
	If This.nidclie=0
		If This.solomoneda=0 Then
			TEXT TO lc NOSHOW TEXTMERGE
	      		  SELECT a.ndoc,a.fech,b.descri,b.unid,c.cant,c.prec,ROUND(c.cant*c.prec,2) as importe,
		          ifnull(d.razo,'') as razo,e.nomv,a.idpcped,a.aten,a.forma,a.plazo,a.validez,a.entrega,a.detalle,x.nomb as usua,
    		      if(tipopedido='P','Cotización','Pre Venta') as tipopedido,a.idautop,a.fecho,a.rped_mone as mone,
		          a.idclie as codigo FROM fe_rped as a
		          inner join fe_ped as c ON(c.idautop=a.idautop)
		          inner join fe_art as b ON(b.idart=c.idart)
		          inner join fe_vend as e ON(e.idven=a.idven)
		          left join fe_clie as d ON(d.idclie=a.idclie)
		          inner join fe_usua as x on x.idusua=a.rped_idus
		          where a.fech between '<<fi>>' and '<<ff>>>' and c.acti='A' and a.acti='A' order by a.ndoc
			ENDTEXT
		Else
			TEXT TO lc NOSHOW TEXTMERGE
	      		  SELECT a.ndoc,a.fech,b.descri,b.unid,c.cant,c.prec,ROUND(c.cant*c.prec,2) as importe,
		          ifnull(d.razo,'') as razo,e.nomv,a.idpcped,a.aten,a.forma,a.plazo,a.validez,a.entrega,a.detalle,x.nomb as usua,
    		      if(tipopedido='P','Cotización','Pre Venta') as tipopedido,a.idautop,a.fecho,a.rped_mone as mone,
		          a.idclie as codigo FROM fe_rped as a
		          inner join fe_ped as c ON(c.idautop=a.idautop)
		          inner join fe_art as b ON(b.idart=c.idart)
		          inner join fe_vend as e ON(e.idven=a.idven)
		          left join fe_clie as d ON(d.idclie=a.idclie)
		          inner join fe_usua as x on x.idusua=a.rped_idus
		          where a.fech between '<<fi>>' and '<<ff>>>' and c.acti='A' and a.acti='A' and a.rped_mone='<<this.cmoneda>>' order by a.ndoc
			ENDTEXT
		Endif
	Else
		If This.solomoneda=0 Then
			TEXT TO lc NOSHOW TEXTMERGE
    		      SELECT a.ndoc,a.fech,b.descri,b.unid,c.cant,c.prec,ROUND(c.cant*c.prec,2) as importe,
		          ifnull(d.razo,'') as razo,e.nomv,a.idpcped,a.aten,a.forma,a.plazo,a.validez,a.entrega,a.detalle,x.nomb as usua,
		          if(tipopedido='P','Cotización','Pre Venta') as tipopedido,a.idautop,a.fecho,a.rped_mone as mone,
		          a.idclie as codigo FROM fe_rped as a
		          inner join fe_ped as c ON(c.idautop=a.idautop)
		          inner join fe_art as b ON(b.idart=c.idart)
		          inner join fe_vend as e ON(e.idven=a.idven)
		          inner join fe_clie as d ON(d.idclie=a.idclie)
		          inner join fe_usua as x on x.idusua=a.rped_idus
		          where a.fech between '<<fi>>' and '<<ff>>>'  and a.idclie=<<this.nidclie>>  and c.acti='A' and a.acti='A' order by a.ndoc
			ENDTEXT
		Else
			TEXT TO lc NOSHOW TEXTMERGE
    		      SELECT a.ndoc,a.fech,b.descri,b.unid,c.cant,c.prec,ROUND(c.cant*c.prec,2) as importe,
		          ifnull(d.razo,'') as razo,e.nomv,a.idpcped,a.aten,a.forma,a.plazo,a.validez,a.entrega,a.detalle,x.nomb as usua,
		          if(tipopedido='P','Cotización','Pre Venta') as tipopedido,a.idautop,a.fecho,a.rped_mone as mone,
		          a.idclie as codigo FROM fe_rped as a
		          inner join fe_ped as c ON(c.idautop=a.idautop)
		          inner join fe_art as b ON(b.idart=c.idart)
		          inner join fe_vend as e ON(e.idven=a.idven)
		          inner join fe_clie as d ON(d.idclie=a.idclie)
		          inner join fe_usua as x on x.idusua=a.rped_idus
		          where a.fech between '<<fi>>' and '<<ff>>>'  and a.idclie=<<this.nidclie>>  and c.acti='A' and a.acti='A' and a.rped_mone='<<this.cmoneda>>' order by a.ndoc
			ENDTEXT
		Endif
	Endif
	If This.EJECUTACONSULTA(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
