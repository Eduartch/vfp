**************************************************
*-- Class:        calcularcostopromedio (d:\librerias\clasesvisuales.vcx)
*-- ParentClass:  custom
*-- BaseClass:    custom
*-- Time Stamp:   08/03/23 04:08:07 PM
*
DEFINE CLASS calcularcostopromedio AS custom


	Width = 100
	Name = "calcularcostopromedio"


	PROCEDURE calcular
		Lparameters dfecha
		*Try
		If Parameters()<1 Then
			df=cfechas(fe_gene.fech)
			ELSE
			df=cfechas(dfecha)   
		Endif

		TEXT TO lc NOSHOW textmerge
			  a.idart,cant,if(tipo='C',a.prec*if(d.mone<>'S',d.dolar,1),1) as precio,tipo from fe_kar as a
			  inner join fe_rcom as d ON(d.idauto=a.idauto)
			  where a.acti<>'I' and d.acti<>'I' and d.tcom<>'T' and d.fech<'<<df>>'  order by a.idart,d.fech,a.tipo
		ENDTEXT
		If ejecutaconsulta(lc,"invec")<0
		    Return
		Endif
		Select idart,precio As costo From invec Where idart=-1 Into Cursor costos Readwrite
		Select invec
		Do While !Eof()
			Store 0 To sa_to,cost,nsaldo,saldo
			xcoda=invec.idart
			Store 0 To xcant,xprec,toti,xdebe
			Do While !Eof() And invec.idart=xcoda
				If invec.tipo="V"
					saldo=saldo-cant
					sa_to=sa_to-(cost*cant)
				Else
					saldo=saldo+cant
					xprec=invec.precio
					If xprec=0  Then
						xprec=cost
					Endif


					toti=toti+(Iif(invec.cant=0,1,invec.cant)*xprec)
					xdebe=Round(Iif(invec.cant=0,1,invec.cant)*xprec,2)
					If saldo<0 Then
						If invec.cant<>0 Then

							sa_to=Round(saldo*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(saldo*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(saldo*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						cost=Iif(saldo<>0,Round(sa_to/saldo,4),xprec)
					Endif
					If cost=0 Then
						cost=xprec
					Endif
				Endif
				Skip
			Enddo
			If saldo<>0 Then
				Insert Into costos(idart,costo)Values(xcoda,cost)
			Endif
			Select invec
		Enddo
		*Catch To m.oerror
		*	Messagebox('Calculando Costos',64,'SISVEN')
		*Endtry


		Return


		nsaldo=saldo
		If saldo<0 Then
			sa_to=saldo*xprec
		Else
			If sa_to<0 Then
				sa_to=saldo*xprec
			Else
				sa_to=sa_to+(cant*xprec)
			Endif
		Endif
		If sa_to<>0 Then
			If nsaldo<0 And cant<>0 Then
				cost=xprec
			Else
				cost=Iif(saldo<>0,sa_to/saldo,0)
			Endif
		Endif
		If sa_to<>0 And saldo<>0
			cost=Round(sa_to/saldo,2)
		Endif
		If cost=0
			cost=xprec
		Endif
		*Else
		*	sa_to=sa_to+Iif(invec.precio<0,-invec.precio,invec.precio)
		**	If sa_to<>0 And saldo<>0
		*		cost=Round(sa_to/saldo,2)
		*	Endif
		*Endif
	ENDPROC


	PROCEDURE calculavalorizadogeneral
		Lparameters dfi,dff
		na=Alltrim(Str(Year(dff)))
		dfi1=Ctod("01/01/"+Alltrim(na))
		todos=0
		Create Cursor k(fech D,tdoc C(2),serie C(4),ndoc C(8),ct C(1),razo C(80)Null,ingr N(10,2),prei N(10,2),;
			impi N(10,2),egre N(10,2),pree N(10,2),impe N(10,2),stock N(10,2),cost N(10,2),saldo N(10,2),;
			Desc C(100),unid C(10),coda N(8),fechaUltimaCompra D, preciosingiv N(10,2), codigoFabrica C(50), marca C(50),;
			linea C(50), grupo C(50), idauto N(12) Default 0,importe N(12,2),cestado C(1) Default 'C',nreg N(12))
		Select coda,Descri As Desc,unid,fechaUltimaCompra ,preciosingiv , codigoFabrica ,marca ,linea ,grupo From lx Into Cursor xc Order By Descri
		ff=cfechas(dff)
		TEXT TO lc NOSHOW TEXTMERGE
					b.fech,b.ndoc,b.tdoc,a.tipo,a.cant,
					ROUND(a.prec,2) as prec,b.mone,b.idcliente,
					c.razo as cliente,b.idprov,e.razo as proveedor,
					b.dolar as dola,b.vigv as igv,b.idauto,a.idkar,a.idart
					from fe_kar as a inner join fe_rcom as b ON(b.idauto=a.idauto)
					left JOIN fe_prov as e ON (e.idprov=b.idprov)
					LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente)
					WHERE b.fech<='<<ff>>' and a.acti='A' and b.acti='A' and b.tcom<>'T' and rcom_tipo='C'
					OrDER BY b.fech,a.tipo,b.tdoc,b.ndoc
		ENDTEXT
		If Ejecutaconsulta(lc,'kkxx')<0 Then
			Return
		Endif
		Select xc
		Go Top
		Do While !Eof()
			ccoda=xc.coda
			cdesc=xc.Desc
			cunid=xc.unid
			nidart=xc.coda
			dfechaUltimaCompra =iif(ISNULL(xc.fechaUltimaCompra), DATE(),xc.fechaUltimaCompra)
			npreciosingiv=xc.preciosingiv
			ccodigoFabrica=xc.codigoFabrica
			cmarca=xc.marca
			clinea=xc.linea
			cgrupo=xc.grupo
			Select * From kkxx Where idart=ccoda Into Cursor kardex
			x=0
			sw="N"
			Store 0 To calma,x,crazon,ing,egr,costo,toti,sa_to
			calma=0
			Sele kardex
			Scan All
				If kardex.fech<dfi Then
					If tipo="C" Then
						cmone=kardex.mone
						ndolar=kardex.dola
						If cmone="D"
							xprec=Prec*ndolar
						Else
							xprec=Prec
						Endif
						If xprec=0
							xprec=costo
						Endif
						toti=toti+(Iif(cant=0,1,cant)*xprec)
						xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
						calma=calma+cant
						If calma<0 Then
							If kardex.cant<>0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=sa_to+xdebe
							Endif
						Else
							If sa_to<0 Then
								sa_to=Round(calma*xprec,2)
							Else
								If sa_to=0 Then
									sa_to=Round(calma*xprec,2)
								Else
									sa_to=Round(sa_to+xdebe,2)
								Endif
							Endif
						Endif
						If toti<>0 Then
							costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
						Endif
						If costo=0
							costo=xprec
						Endif
					Else
						calma=calma-cant
						xhaber=Round(costo*kardex.cant,2)
						If calma=0 Then
							sa_to=0
						Else
							sa_to=sa_to-xhaber
						Endif
					Endif
				Else
					If x=0
						saldoi=calma
						Insert Into k(fech,razo,stock,cost,saldo,coda,Desc,unid,coda,fechaUltimaCompra,preciosingiv,codigoFabrica,marca,linea,grupo);
							Values(kardex.fech,"Stock Inicial",calma,costo,Round(calma*costo,2),ccoda,cdesc,cunid,nidart,dfechaUltimaCompra ,npreciosingiv,;
							ccodigoFabrica,cmarca,clinea,cgrupo)
						sa_to=Round(calma*costo,2)
						ing=0
						egr=0
						xtdebe=0
						xthaber=0
					Endif
					sw="S"
					x=x+1
					If tipo="C" Then
						ctdoc=kardex.tdoc
						cmone=kardex.mone
						cndoc=kardex.ndoc
						ndolar=kardex.dola
						If cmone="D"
							xprec=Prec*ndolar
						Else
							xprec=Prec
						Endif
						If xprec=0
							xprec=costo
						Endif
						ing=ing+cant
						toti=toti+(Iif(cant=0,1,cant)*xprec)
						xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
						xtdebe=xtdebe+xdebe
						calma=calma+kardex.cant
						If calma<0 Then
							If kardex.cant<>0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=sa_to+xdebe
							Endif
						Else
							If sa_to<0 Then
								sa_to=Round(calma*xprec,2)
							Else
								If sa_to=0 Then
									sa_to=Round(calma*xprec,2)
								Else
									sa_to=Round(sa_to+xdebe,2)
								Endif
							Endif
						Endif
						If toti<>0 Then
							costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
						Endif
						If costo=0
							costo=xprec
						Endif
						crazon=Iif(Isnull(kardex.proveedor),"                                             ",kardex.proveedor)
						Insert Into k(fech,tdoc,serie,ndoc,ct,razo,ingr,prei,impi,stock,cost,saldo,coda,Desc,unid,idauto,nreg,coda,fechaUltimaCompra,preciosingiv,codigoFabrica,marca,linea,grupo);
							values(kardex.fech,ctdoc,Left(cndoc,4),Substr(cndoc,5),"I",crazon,kardex.cant,;
							xprec,xdebe,calma,costo,sa_to,ccoda,cdesc,cunid,kardex.idauto,kardex.idkar,kardex.idart,dfechaUltimaCompra ,npreciosingiv,;
							ccodigoFabrica,cmarca,clinea,cgrupo)
					Else
						egr=egr+cant
						calma=calma-kardex.cant
						xhaber=Round(costo*kardex.cant,2)
						xthaber=xthaber+xhaber
						If calma=0 Then
							sa_to=0
						Else
							sa_to=sa_to-xhaber
						Endif
						crazon=Iif(Isnull(kardex.cliente),"                                             ",kardex.cliente)
						Insert Into k(fech,tdoc,serie,ndoc,ct,razo,egre,pree,impe,stock,cost,saldo,coda,Desc,unid,coda,fechaUltimaCompra,preciosingiv,codigoFabrica,marca,linea,grupo);
							values(kardex.fech,kardex.tdoc,Left(kardex.ndoc,3),Substr(kardex.ndoc,4),"S",crazon,kardex.cant,;
							costo,xhaber,calma,costo,sa_to,ccoda,cdesc,cunid,kardex.idart,dfechaUltimaCompra ,npreciosingiv,;
							ccodigoFabrica,cmarca,clinea,cgrupo)
					Endif
				Endif
			Endscan
			If sw="N"
				Insert Into k(razo,Desc,unid,stock,cost,saldo,coda,importe,coda)Values("SIN MOVIMIENTOS ",cdesc,cunid,calma,Iif(calma=0,0,costo),sa_to,ccoda,sa_to,nidart)
			Else
				Insert Into k(razo,ingr,impi,egre,impe,Desc,unid,coda,importe,cestado,coda,fechaUltimaCompra,preciosingiv,codigoFabrica,marca,linea,grupo) Values;
					("TOTALES ->:",ing,xtdebe,egr,xthaber,cdesc,cunid,ccoda,sa_to,'T',nidart,dfechaUltimaCompra ,npreciosingiv,;
							ccodigoFabrica,cmarca,clinea,cgrupo)
			Endif
			Select xc
			Skip
		Enddo
		*!*	Lparameters dfi,dff
		*!*	na=Alltrim(Str(Year(dff)))
		*!*	dfi1=Ctod("01/01/"+Alltrim(na))
		*!*	todos=0
		*!*	Create Cursor k(fech D,tdoc C(2),serie C(4),ndoc C(8),ct C(1),razo C(80)Null,ingr N(10,2),prei N(10,2),;
		*!*		impi N(10,2),egre N(10,2),pree N(10,2),impe N(10,2),stock N(10,2),cost N(10,2),saldo N(10,2),;
		*!*		Desc C(100),unid C(10),coda N(8),idauto N(12) Default 0,importe N(12,2),cestado C(1) Default 'C',nreg N(12))
		*!*	Select coda,Descri As Desc,unid From lx Into Cursor xc Order By Descri
		*!*	ff=cfechas(dff)
		*!*	TEXT TO lc NOSHOW TEXTMERGE
		*!*			   b.fech,b.ndoc,b.tdoc,a.tipo,a.cant,
		*!*			   ROUND(a.prec,2) as prec,b.mone,b.idcliente,
		*!*			   c.razo as cliente,b.idprov,e.razo as proveedor,
		*!*	           b.dolar as dola,b.vigv as igv,b.idauto,a.idkar,a.idart
		*!*	           from fe_kar as a inner join fe_rcom as b ON(b.idauto=a.idauto)
		*!*	           left JOIN fe_prov as e ON (e.idprov=b.idprov)
		*!*	           LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente)
		*!*	           WHERE b.fech<='<<ff>>' and a.acti='A' and b.acti='A' and b.tcom<>'T' and rcom_tipo='C'
		*!*	           OrDER BY b.fech,a.tipo,b.tdoc,b.ndoc
		*!*	ENDTEXT
		*!*	If Ejecutaconsulta(lc,'kkxx')<0 Then
		*!*		return
		*!*	Endif
		*!*	Select xc
		*!*	Go Top
		*!*	Do While !Eof()
		*!*		ccoda=xc.coda
		*!*		cdesc=xc.Desc
		*!*		cunid=xc.unid
		*!*		nidart=xc.coda
		*!*		Select * From kkxx Where idart=ccoda Into Cursor kardex
		*!*		x=0
		*!*		sw="N"
		*!*		Store 0 To calma,x,crazon,ing,egr,costo,toti,sa_to
		*!*		calma=0
		*!*		Sele kardex
		*!*		Scan All
		*!*			If kardex.fech<dfi Then
		*!*				If tipo="C" Then
		*!*					cmone=kardex.mone
		*!*					ndolar=kardex.dola
		*!*					If cmone="D"
		*!*						xprec=Prec*ndolar
		*!*					Else
		*!*						xprec=Prec
		*!*					Endif
		*!*					If xprec=0
		*!*						xprec=costo
		*!*					Endif
		*!*					toti=toti+(Iif(cant=0,1,cant)*xprec)
		*!*					xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
		*!*					calma=calma+cant
		*!*					If calma<0 Then
		*!*						If kardex.cant<>0 Then
		*!*							sa_to=Round(calma*xprec,2)
		*!*						Else
		*!*							sa_to=sa_to+xdebe
		*!*						Endif
		*!*					Else
		*!*						If sa_to<0 Then
		*!*							sa_to=Round(calma*xprec,2)
		*!*						Else
		*!*							If sa_to=0 Then
		*!*								sa_to=Round(calma*xprec,2)
		*!*							Else
		*!*								sa_to=Round(sa_to+xdebe,2)
		*!*							Endif
		*!*						Endif
		*!*					Endif
		*!*					If toti<>0 Then
		*!*						costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
		*!*					Endif
		*!*					If costo=0
		*!*						costo=xprec
		*!*					Endif
		*!*				Else
		*!*					calma=calma-cant
		*!*					xhaber=Round(costo*kardex.cant,2)
		*!*					If calma=0 Then
		*!*						sa_to=0
		*!*					Else
		*!*						sa_to=sa_to-xhaber
		*!*					Endif
		*!*				Endif
		*!*			Else
		*!*				If x=0
		*!*					saldoi=calma
		*!*					Insert Into k(fech,razo,stock,cost,saldo,coda,Desc,unid,coda);
		*!*						Values(kardex.fech,"Stock Inicial",calma,costo,Round(calma*costo,2),ccoda,cdesc,cunid,nidart)
		*!*					sa_to=Round(calma*costo,2)
		*!*					ing=0
		*!*					egr=0
		*!*					xtdebe=0
		*!*					xthaber=0
		*!*				Endif
		*!*				sw="S"
		*!*				x=x+1
		*!*				If tipo="C" Then
		*!*					ctdoc=kardex.tdoc
		*!*					cmone=kardex.mone
		*!*					cndoc=kardex.ndoc
		*!*					ndolar=kardex.dola
		*!*					If cmone="D"
		*!*						xprec=Prec*ndolar
		*!*					Else
		*!*						xprec=Prec
		*!*					Endif
		*!*					If xprec=0
		*!*						xprec=costo
		*!*					Endif
		*!*					ing=ing+cant
		*!*					toti=toti+(Iif(cant=0,1,cant)*xprec)
		*!*					xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
		*!*					xtdebe=xtdebe+xdebe
		*!*					calma=calma+kardex.cant
		*!*					If calma<0 Then
		*!*						If kardex.cant<>0 Then
		*!*							sa_to=Round(calma*xprec,2)
		*!*						Else
		*!*							sa_to=sa_to+xdebe
		*!*						Endif
		*!*					Else
		*!*						If sa_to<0 Then
		*!*							sa_to=Round(calma*xprec,2)
		*!*						Else
		*!*							If sa_to=0 Then
		*!*								sa_to=Round(calma*xprec,2)
		*!*							Else
		*!*								sa_to=Round(sa_to+xdebe,2)
		*!*							Endif
		*!*						Endif
		*!*					Endif
		*!*					If toti<>0 Then
		*!*						costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
		*!*					Endif
		*!*					If costo=0
		*!*						costo=xprec
		*!*					Endif
		*!*					crazon=Iif(Isnull(kardex.proveedor),"                                             ",kardex.proveedor)
		*!*					Insert Into k(fech,tdoc,serie,ndoc,ct,razo,ingr,prei,impi,stock,cost,saldo,coda,Desc,unid,idauto,nreg,coda);
		*!*						values(kardex.fech,ctdoc,Left(cndoc,4),Substr(cndoc,5),"I",crazon,kardex.cant,;
		*!*						xprec,xdebe,calma,costo,sa_to,ccoda,cdesc,cunid,kardex.idauto,kardex.idkar,kardex.idart)
		*!*				Else
		*!*					egr=egr+cant
		*!*					calma=calma-kardex.cant
		*!*					xhaber=Round(costo*kardex.cant,2)
		*!*					xthaber=xthaber+xhaber
		*!*					If calma=0 Then
		*!*						sa_to=0
		*!*					Else
		*!*						sa_to=sa_to-xhaber
		*!*					Endif
		*!*					crazon=Iif(Isnull(kardex.cliente),"                                             ",kardex.cliente)
		*!*					Insert Into k(fech,tdoc,serie,ndoc,ct,razo,egre,pree,impe,stock,cost,saldo,coda,Desc,unid,coda);
		*!*						values(kardex.fech,kardex.tdoc,Left(kardex.ndoc,3),Substr(kardex.ndoc,4),"S",crazon,kardex.cant,;
		*!*						costo,xhaber,calma,costo,sa_to,ccoda,cdesc,cunid,kardex.idart)
		*!*				Endif
		*!*			Endif
		*!*		Endscan
		*!*		If sw="N"
		*!*			Insert Into k(razo,Desc,unid,stock,cost,saldo,coda,importe,coda)Values("SIN MOVIMIENTOS ",cdesc,cunid,calma,Iif(calma=0,0,costo),sa_to,ccoda,sa_to,nidart)
		*!*		Else
		*!*			Insert Into k(razo,ingr,impi,egre,impe,Desc,unid,coda,importe,cestado,coda)Values;
		*!*				("TOTALES ->:",ing,xtdebe,egr,xthaber,cdesc,cunid,ccoda,sa_to,'T',nidart)
		*!*		Endif
		*!*		Select xc
		*!*		Skip
		*!*	Enddo
	ENDPROC


	PROCEDURE calculavalorizadogeneral1
		Lparameters dfi,dff
		na=Alltrim(Str(Year(dff)))
		dfi1=Ctod("01/01/"+Alltrim(na))
		todos=0
		Create Cursor k(fech D,tdoc C(2),serie C(4),ndoc C(8),ct C(1),razo C(80)Null,ingr N(10,2),prei N(10,2),;
			impi N(10,2),egre N(10,2),pree N(10,2),impe N(10,2),stock N(10,2),cost N(10,2),saldo N(10,2),;
			Desc C(100),unid C(10),idauto N(12) Default 0,coda N(8),importe N(12,2),cestado C(1) Default 'C',nreg N(12))
		Select coda,Descri As Desc,unid From lx Into Cursor xc Order By Descri

		ff=cfechas(dff)
		TEXT TO lc NOSHOW TEXTMERGE
				    b.fech,b.ndoc,b.tdoc,a.tipo,a.cant,
				   ROUND(a.prec,2) as prec,b.mone,
				   c.razo as cliente,e.razo as proveedor,
		           b.dolar as dola,b.vigv as igv,b.idauto,a.idkar,a.idart
		           from fe_kar as a inner join fe_rcom as b ON(b.idauto=a.idauto)
		           left JOIN fe_prov as e ON (e.idprov=b.idprov)
		           LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente)
		           WHERE a.idart=?ccoda  and b.fech<='<<ff>> and a.acti='A' and b.acti='A' and b.tcom<>'T'
		           OrDER BY b.fech,a.tipo,b.tdoc,b.ndoc
		ENDTEXT
		If Ejecutaconsulta(lc,'kkxx')<0 Then
			Return
		Endif
		Select xc
		Go Top
		Do While !Eof()
			ccoda=xc.coda
			cdesc=xc.Desc
			cunid=xc.unid
		    Select * From kkxx Where idart=ccoda Into Cursor kardex
			x=0
			sw="N"
			Store 0 To calma,x,crazon,ing,egr,costo,toti,sa_to
			calma=0
			Sele kardex
			Scan All
				If kardex.fech<dfi Then
					If tipo="C" Then
						cmone=kardex.mone
						ndolar=kardex.dola
						If cmone="D"
							xprec=Prec*ndolar
						Else
							xprec=Prec
						Endif
						If xprec=0
							xprec=costo
						Endif
						toti=toti+(Iif(cant=0,1,cant)*xprec)
						xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
						calma=calma+cant
						If calma<0 Then
							If kardex.cant<>0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=sa_to+xdebe
							Endif
						Else
							If sa_to<0 Then
								sa_to=Round(calma*xprec,2)
							Else
								If sa_to=0 Then
									sa_to=Round(calma*xprec,2)
								Else
									sa_to=Round(sa_to+xdebe,2)
								Endif
							Endif
						Endif
						If toti<>0 Then
							costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
						Endif
						If costo=0
							costo=xprec
						Endif
					Else
						calma=calma-cant
						xhaber=Round(costo*kardex.cant,2)
						If calma=0 Then
							sa_to=0
						Else
							sa_to=sa_to-xhaber
						Endif
					Endif
				Else
					If x=0
						saldoi=calma
						Insert Into k(fech,razo,stock,cost,saldo,coda,Desc,unid);
							Values(kardex.fech,"Stock Inicial",calma,costo,Round(calma*costo,2),ccoda,cdesc,cunid)
						sa_to=Round(calma*costo,2)
						ing=0
						egr=0
						xtdebe=0
						xthaber=0
					Endif
					sw="S"
					x=x+1
					If tipo="C" Then
						ctdoc=kardex.tdoc
						cmone=kardex.mone
						cndoc=kardex.ndoc
						ndolar=kardex.dola
						If cmone="D"
							xprec=Prec*ndolar
						Else
							xprec=Prec
						Endif
						If xprec=0
							xprec=costo
						Endif
						ing=ing+cant
						toti=toti+(Iif(cant=0,1,cant)*xprec)
						xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
						xtdebe=xtdebe+xdebe
						calma=calma+kardex.cant
						If calma<0 Then
							If kardex.cant<>0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=sa_to+xdebe
							Endif
						Else
							If sa_to<0 Then
								sa_to=Round(calma*xprec,2)
							Else
								If sa_to=0 Then
									sa_to=Round(calma*xprec,2)
								Else
									sa_to=Round(sa_to+xdebe,2)
								Endif
							Endif
						Endif
						If toti<>0 Then
							costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
						Endif
						If costo=0
							costo=xprec
						Endif
						crazon=Iif(Isnull(kardex.proveedor),"                                             ",kardex.proveedor)
						Insert Into k(fech,tdoc,serie,ndoc,ct,razo,ingr,prei,impi,stock,cost,saldo,coda,Desc,unid,idauto,nreg);
							values(kardex.fech,ctdoc,Left(cndoc,4),Substr(cndoc,5),"I",crazon,kardex.cant,;
							xprec,xdebe,calma,costo,sa_to,ccoda,cdesc,cunid,kardex.idauto,kardex.idkar)
					Else
						egr=egr+cant
						calma=calma-kardex.cant
						xhaber=Round(costo*kardex.cant,2)
						xthaber=xthaber+xhaber
						If calma=0 Then
							sa_to=0
						Else
							sa_to=sa_to-xhaber
						Endif
						crazon=Iif(Isnull(kardex.cliente),"                                             ",kardex.cliente)
						Insert Into k(fech,tdoc,serie,ndoc,ct,razo,egre,pree,impe,stock,cost,saldo,coda,Desc,unid,nreg);
							values(kardex.fech,kardex.tdoc,Left(kardex.ndoc,3),Substr(kardex.ndoc,4),"S",crazon,kardex.cant,;
							costo,xhaber,calma,costo,sa_to,ccoda,cdesc,cunid,kardex.idkar)
					Endif
				Endif
			Endscan
			If sw="N"
				Insert Into k(razo,Desc,unid,stock,cost,saldo,coda,importe)Values("SIN MOVIMIENTOS ",cdesc,cunid,calma,Iif(calma=0,0,costo),sa_to,ccoda,sa_to)
			Else
				Insert Into k(razo,ingr,impi,egre,impe,Desc,unid,coda,importe,cestado)Values;
					("TOTALES ->:",ing,xtdebe,egr,xthaber,cdesc,cunid,ccoda,sa_to,'T')
			Endif
			Select xc
			Skip
		Enddo
	ENDPROC


	PROCEDURE valorizadoresumido
		Lparameters dfecha
		f=cfechas(dfecha)
		TEXT TO lc NOSHOW TEXTMERGE 
			  a.idart,c.descri,c.unid,cant,a.prec as  precio,
			  tipo,d.dolar as dola,d.idauto,d.mone
			   from fe_kar as a
			  inner join fe_art as c on(c.idart=a.idart) inner join fe_rcom as d ON(d.idauto=a.idauto)
			  where  fech<='<<f>>' and a.acti<>'I' and d.acti<>'I'
			  and d.tcom<>'T'   order by a.idart,fech,a.tipo,d.tdoc,d.ndoc
		ENDTEXT

		If Ejecutaconsulta(lc,"inve")<0
			Return
		Endif
		Select idart,Descri,unid,0000000.00 As alma,0000000.0000 As costo,00000000.00 As importe From inve Where idart=-1 Into Cursor inventario Readwrite
		Select idart,Descri,unid,cant,Iif(mone='S',precio,precio*dola) As precio,tipo,dola,;
			idauto,mone From inve Into Cursor inve
		Select inve
		Do While !Eof()
			Store 0 To sa_to,cost,nsaldo,saldo,toti,xdebe
			xcoda=inve.idart
			cdescri=inve.Descri
			cunid=inve.unid
			Store 0 To xcant,xprec,cost
			Do While !Eof() And inve.idart=xcoda
				If inve.tipo="V"
					saldo=saldo-cant
					sa_to=sa_to-(cost*cant)
				Else
					xprec=precio
					If xprec=0  Then
						xprec=cost
					Endif
					toti=toti+(Iif(inve.cant=0,1,inve.cant)*xprec)
					xdebe=Round(Iif(inve.cant=0,1,inve.cant)*xprec,2)
					saldo=saldo+inve.cant
					If saldo<0 Then
						If inve.cant<>0 Then
							sa_to=Round(saldo*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(saldo*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(saldo*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						cost=Iif(saldo<>0,Round(sa_to/saldo,4),xprec)
					Endif
					If cost=0
						cost=xprec
					Endif
				Endif
				Select inve
				Skip
			Enddo
			If saldo<>0 Then
				Insert Into inventario(idart,Descri,unid,alma,costo)Values(xcoda,cdescri,cunid,saldo,cost)
			Endif
			Select inve
		Enddo
		Select idart As coda,Descri,unid,alma,costo,Round(costo*alma,2) As importe From inventario Into Cursor inventario Order By Descri
	ENDPROC


	PROCEDURE kardexindividual
		Lparameters ccoda,dfi,dff
		Store 0 To toti,ing,egr,sa_to,costo,calma,xprec,x,xdebe,xhaber,saldoi
		Create Cursor tmp(fech D,tdoc C(2),serie C(4),ndoc C(8),ct C(1),razo C(35)Null,ingr N(10,2),prei N(10,2),;
			impi N(10,2),egre N(10,2),pree N(10,2),impe N(10,2),stock N(10,2),cost N(10,2),saldo N(10,2))
			ff=cfechas(dff)
		TEXT TO lc NOSHOW TEXTMERGE 
		       b.fech,b.ndoc,b.tdoc,a.tipo,a.cant,a.prec,b.mone,a.dsnc,a.dsnd,a.gast,b.idcliente,c.razo as cliente,b.idprov,e.razo as proveedor,
		       b.dolar as dola,b.vigv as igv,b.valor from fe_kar as a 
		       inner join fe_rcom as b ON(b.idauto=a.idauto) 
		       left JOIN fe_prov as e ON (e.idprov=b.idprov)
		       LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente) 
		       WHERE a.idart=<<ccoda>>  and b.fech<='<<ff>>' and a.acti<>'I' and b.acti<>'I'  and b.tcom<>'T'
		       OrDER BY b.fech,b.tipom,b.ndoc
		ENDTEXT
		IF ejecutaconsulta(lc,"kardex")<1
			Return
		Endif
		crazon=""
		Select kardex
		Scan All
			If kardex.fech<dfi
				If tipo="C"
					*If valor<0 And cant=0
					*	npr=valor
					*Else
					npr=Prec
					*Endif
					If mone="D"
						xprec=(npr*dola)
					Else
						xprec=npr
					Endif
					If xprec=0
						*xprec=costo
					Endif
					toti=toti+(Iif(cant=0,1,cant)*xprec)
					xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
					calma=calma+cant
					If calma<0 Then
						If kardex.cant<>0 Then
							sa_to=Round(calma*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(calma*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
					Endif
					If costo=0
						costo=xprec
					Endif
				Else
					calma=calma-cant
					xhaber=Round(costo*kardex.cant,2)
					If calma=0
						sa_to=0
					Else
						sa_to=sa_to-xhaber
					Endif
				Endif
			Else
				If x=0
					saldoi=calma
					Insert Into tmp(fech,razo,stock,cost,saldo)Values(kardex.fech,"Stock Inicial",calma,costo,Round(calma*costo,2))
					sa_to=Round(calma*costo,2)
				Endif
				x=x+1
				If tipo="C" Then
					*If valor<0 And cant=0
					**	npr=valor
					*Else
					npr=Prec
					*Endif
					If mone="D"
						xprec=(npr*dola)
					Else
						xprec=npr
					Endif
					If xprec=0
						*xprec=costo
					Endif
					ing=ing+cant
					toti=toti+(Iif(cant=0,1,cant)*xprec)
					xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
					calma=calma+kardex.cant
					If calma<0 Then
						If kardex.cant<>0 Then
							sa_to=Round(calma*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(calma*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
					Endif
					If costo=0
						costo=xprec
					Endif

					crazon=Iif(Isnull(kardex.proveedor),"                                             ",kardex.proveedor)
					Insert Into tmp(fech,tdoc,serie,ndoc,ct,razo,ingr,prei,impi,stock,cost,saldo);
						values(kardex.fech,kardex.tdoc,Iif(Len(Alltrim(kardex.ndoc))<=10,Left(kardex.ndoc,3),Left(kardex.ndoc,4)),;
						Iif(Len(Alltrim(kardex.ndoc))<=10,Substr(kardex.ndoc,4),Substr(kardex.ndoc,5)),"I",crazon,kardex.cant,;
						xprec,xdebe,calma,costo,sa_to)
				Else
					egr=egr+cant
					calma=calma-kardex.cant
					xhaber=Round(costo*kardex.cant,2)
					If calma=0
						sa_to=0
					Else
						sa_to=sa_to-xhaber
					Endif
					crazon=Iif(Isnull(kardex.cliente),"                                             ",kardex.cliente)
					Insert Into tmp(fech,tdoc,serie,ndoc,ct,razo,egre,pree,impe,stock,cost,saldo);
						values(kardex.fech,kardex.tdoc,Iif(Len(Alltrim(kardex.ndoc))<=10,Left(kardex.ndoc,3),Left(kardex.ndoc,4)),;
						Iif(Len(Alltrim(kardex.ndoc))<=10,Substr(kardex.ndoc,4),Substr(kardex.ndoc,5)),"S",crazon,kardex.cant,;
						kardex.Prec,xhaber,calma,costo,sa_to)
				Endif
			Endif
		Endscan
		Insert Into tmp(razo,ingr,egre,stock)Values("TOTALES ->:",ing,egr,saldoi+ing-egr)
	ENDPROC


	PROCEDURE kardexindividualcunidades
		Lparameters ccoda,dfi,dff
		Store 0 To toti,ing,egr,sa_to,costo,calma,xprec,x,xdebe,xhaber,saldoi
		Create Cursor tmp(fech D,tdoc C(2),serie C(4),ndoc C(8),ct C(1),razo C(35)Null,ingr N(10,2),prei N(10,2),;
			impi N(10,2),egre N(10,2),pree N(10,2),impe N(10,2),stock N(10,2),cost N(10,2),saldo N(10,2))
		crazon=""
		Select kardex
		Scan All
			If kardex.fech<dfi
				If tipo="C"
					Do Case
					Case kar_equi>1 And kardex.cant<>0
						xprec=kardex.Prec/kar_equi
					Case kar_equi<1 And kardex.cant<>0
						xprec=kardex.Prec*kar_equi
					Otherwise
						xprec=kardex.Prec
					Endcase
					If mone="D"
						xprec=(xprec*dola)
					Endif
					toti=toti+(Iif(cant=0,1,cant)*xprec)
					xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
					calma=calma+cant
					If calma<0 Then
						If kardex.cant<>0 Then
							sa_to=Round(calma*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(calma*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
					Endif
					If costo=0
						costo=xprec
					Endif
				Else
					calma=calma-cant
					xhaber=Round(costo*kardex.cant,2)
					If calma=0
						sa_to=0
					Else
						sa_to=sa_to-xhaber
					Endif
				Endif
			Else
				If x=0
					saldoi=calma
					Insert Into tmp(fech,razo,stock,cost,saldo)Values(kardex.fech,"Stock Inicial",calma,costo,Round(calma*costo,2))
					sa_to=Round(calma*costo,2)
				Endif
				x=x+1
				If tipo="C" Then
					Do Case
					Case kar_equi>1 And kardex.cant<>0
						xprec=kardex.Prec/kar_equi
					Case kar_equi<1 And kardex.cant<>0
						xprec=kardex.Prec*kar_equi
					Otherwise
						xprec=kardex.Prec
					Endcase
					If mone="D"
						xprec=(xprec*dola)
					Endif
					ing=ing+cant
					toti=toti+(Iif(cant=0,1,cant)*xprec)
					xdebe=Round(Iif(cant=0,1,cant)*xprec,2)
					calma=calma+kardex.cant
					If calma<0 Then
						If kardex.cant<>0 Then
							sa_to=Round(calma*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(calma*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(calma*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						costo=Iif(calma<>0,Round(sa_to/calma,4),xprec)
					Endif
					If costo=0
						costo=xprec
					Endif
					crazon=Iif(Isnull(kardex.proveedor),"                                             ",kardex.proveedor)
					Insert Into tmp(fech,tdoc,serie,ndoc,ct,razo,ingr,prei,impi,stock,cost,saldo);
						values(kardex.fech,kardex.tdoc,Left(kardex.ndoc,3),Substr(kardex.ndoc,4),"I",crazon,kardex.cant,;
						xprec,xdebe,calma,costo,sa_to)
				Else
					egr=egr+cant
					calma=calma-kardex.cant
					xhaber=Round(costo*kardex.cant,2)
					If calma=0
						sa_to=0
					Else
						sa_to=sa_to-xhaber
					Endif
					crazon=Iif(Isnull(kardex.cliente),"                                             ",kardex.cliente)
					Insert Into tmp(fech,tdoc,serie,ndoc,ct,razo,egre,pree,impe,stock,cost,saldo);
						values(kardex.fech,kardex.tdoc,Left(kardex.ndoc,3),Substr(kardex.ndoc,4),"S",crazon,kardex.cant,;
						kardex.Prec,xhaber,calma,costo,sa_to)
				Endif
			Endif
		Endscan
		Insert Into tmp(razo,ingr,egre,stock)Values("TOTALES ->:",ing,egr,saldoi+ing-egr)
	ENDPROC


	PROCEDURE valorizadoresumidounidades
		Lparameters dfecha
		Select idart,Descri,unid,0000000.00 As alma,0000000.0000 As costo,00000000.00 As importe From inve Where idart=-1 Into Cursor inventario Readwrite
		Select idart,Descri,unid,cant,precio,tipo,kar_equi From inve Into Cursor inve
		Select inve
		Do While !Eof()
			Store 0 To sa_to,cost,nsaldo,saldo,toti,xdebe
			xcoda=inve.idart
			cdescri=inve.Descri
			cunid=inve.unid
			Store 0 To xcant,xprec,cost
			Do While !Eof() And inve.idart=xcoda
				If inve.tipo="V"
					saldo=saldo-cant
					sa_to=sa_to-(cost*cant)
				Else
					Do Case
					Case kar_equi>1
						xprec=inve.precio/kar_equi
					Case kar_equi<1
						xprec=inve.precio*kar_equi
					Otherwise
						xprec=inve.precio
					Endcase
					toti=toti+(Iif(inve.cant=0,1,inve.cant)*xprec)
					xdebe=Round(Iif(inve.cant=0,1,inve.cant)*xprec,2)
					saldo=saldo+inve.cant
					If saldo<0 Then
						If inve.cant<>0 Then
							sa_to=Round(saldo*xprec,2)
						Else
							sa_to=sa_to+xdebe
						Endif
					Else
						If sa_to<0 Then
							sa_to=Round(saldo*xprec,2)
						Else
							If sa_to=0 Then
								sa_to=Round(saldo*xprec,2)
							Else
								sa_to=Round(sa_to+xdebe,2)
							Endif
						Endif
					Endif
					If toti<>0 Then
						cost=Iif(saldo<>0,Round(sa_to/saldo,4),xprec)
					Endif
					If cost=0
						cost=xprec
					Endif
				Endif
				Select inve
				Skip
			Enddo
			If saldo<>0 Then
				Insert Into inventario(idart,Descri,unid,alma,costo)Values(xcoda,cdescri,cunid,saldo,cost)
			Endif
			Select inve
		Enddo
		Select idart As coda,Descri,unid,alma,costo,Round(costo*alma,2) As importe From inventario Into Cursor inventario Order By Descri
	ENDPROC


	PROCEDURE calcular1
		Lparameters dfecha
		Try
			If Parameters()<1 Then
				df=cfechas(fe_gene.fech)
				ELSE
				df=cfechas(dfecha)
			Endif
			TEXT TO lc NOSHOW TEXTMERGE 
			  a.idart,cant*kar_equi as cant,if(tipo='C',a.prec*if(d.mone<>'S',d.dolar,1),1) as precio,tipo,kar_equi from fe_kar as a
			  inner join fe_rcom as d ON(d.idauto=a.idauto)
			  where a.acti<>'I' and d.acti<>'I' and d.tcom<>'T' and d.fech<='<<df>>'  order by a.idart,d.fech,a.tipo
			ENDTEXT
		   If EjecutaConsulta(lc,"invec")<0
				Return
			Endif
		    Select idart,precio As costo From invec Where idart=-1 Into Cursor costos Readwrite
			Select invec
			Do While !Eof()
				Store 0 To sa_to,cost,nsaldo,saldo
				xcoda=invec.idart
				Store 0 To xcant,xprec
				Do While !Eof() And invec.idart=xcoda
					If invec.tipo="V"
						saldo=saldo-cant
						sa_to=sa_to-(cost*cant)
					Else
						saldo=saldo+cant
						If cant<>0 Then
							Do Case
							Case kar_equi>1 And invec.cant<>0
								xprec=invec.precio/kar_equi
							Case kar_equi<1 And invec.cant<>0
								xprec=invec.precio*kar_equi
							Otherwise
								xprec=invec.precio
							Endcase
							nsaldo=saldo
							If saldo<0 Then
								sa_to=saldo*xprec
							Else
								If sa_to<0 Then
									sa_to=saldo*xprec
								Else
									sa_to=sa_to+(cant*xprec)
								Endif
							Endif
							If sa_to<>0 Then
								If nsaldo<0 And cant<>0 Then
									cost=xprec
								Else
									cost=Iif(saldo<>0,sa_to/saldo,0)
								Endif
							Endif
							If sa_to<>0 And saldo<>0
								cost=Round(sa_to/saldo,2)
							Endif
							If cost=0
								cost=xprec
							Endif
						Else
							sa_to=sa_to+Iif(invec.precio<0,-invec.precio,invec.precio)
							If sa_to<>0 And saldo<>0
								cost=Round(sa_to/saldo,2)
							Endif
						Endif
					Endif
					Skip
				Enddo
				If saldo<>0 Then
					Insert Into costos(idart,costo)Values(xcoda,cost)
				Endif
				Select invec
			Enddo
		Catch To m.oerror
			Messagebox('Calculando Costos',64,'SISVEN')
		Endtry
	ENDPROC


ENDDEFINE
*
*-- EndDefine: calcularcostopromedio
**************************************************
