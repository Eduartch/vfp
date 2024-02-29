Define Class inventarios As Odata Of 'd:\capass\database\data.prg'
	marca = 0
	linea = 0
	codtienda = 0
	ncodigop = 0
	Fecha = Date()
	dfi = Date()
	dff = Date()
	Function saldosinicialeskardex(df, ncoda, nalma, Ccursor)
	If nalma > 0 Then
		Text To lC Noshow Textmerge
    SELECT k.idart,SUM(IF(tipo='C',cant,-cant)) AS inicial FROM fe_rcom AS r
	INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
	WHERE fech<'<<df>>' AND idart=<<ncoda>> AND k.alma=<<nalma>> AND r.acti='A' AND k.acti='A' GROUP BY idart
		Endtext
	Else
		Text To lC Noshow Textmerge
    SELECT k.idart,SUM(IF(tipo='C',cant,-cant)) AS inicial FROM fe_rcom AS r
	INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
	WHERE fech<'<<df>>' AND idart=<<ncoda>> AND r.acti='A' AND k.acti='A' GROUP BY idart
		Endtext
	Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioresumidoconii(dfi, dff, dfii, Ccursor)
	Text To lC Noshow Textmerge
	   	Select a.idart,descri,unid,cant,if(tipo='C',a.prec*if(b.mone<>'S',b.dolar,1),1) as precio,tipo,b.fech
        From fe_kar as a
        inner join fe_rcom as b on b.idauto=a.idauto
		inner join fe_art as p on p.idart=a.idart
		Where a.acti='A' and b.acti='A' AND b.fech between '<<dfi>>' and '<<dff>>' and b.tcom<>'T' and p.tipro<>'S' and b.tdoc<>'SS'
		union all
		Select invi_idar  as idart,p.descri,unid,invi_cant as cant,invi_prec as precio,'C' as tipo,invi_fech as fech
		From fe_inicial as z
		inner join fe_art as p on p.idart=z.invi_idar
		Where z.invi_acti='A' and p.tipro<>'S'
		and z.invi_fech='<<dfii>>' 	order by idart,fech,tipo
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioresumidoconiicontable(dfi, dff, dfii, Ccursor)
	Text To lC Noshow Textmerge
	  SELECT a.idart,c.descri,c.unid,cant,CAST(IF(mone='S',a.prec,a.prec*dolar)  AS DECIMAL(12,6))AS  precio,
	  tipo,rcom_fech AS fech,d.ndoc
	  FROM fe_rcom AS d
	  INNER JOIN fe_kar AS a ON a.idauto=d.idauto
	  INNER JOIN fe_art AS c ON c.idart=a.idart
	  WHERE  d.rcom_fech BETWEEN '<<dfi>>' and '<<dff>>' AND a.acti<>'I' AND d.acti<>'I'
	  AND d.tcom<>'T' AND d.rcom_tipo='C'
	  UNION ALL
	  SELECT invi_idar  AS idart,p.descri,unid,invi_cant AS cant,invi_prec AS precio,'C' AS tipo,invi_fech AS fech,'Inv.Inicial' AS ndoc
	  FROM fe_inicial AS z
	  INNER JOIN fe_art AS p ON p.idart=z.invi_idar
	  WHERE z.invi_acti='A'   AND z.invi_fech='<<dfii>>' and invi_acti='A' ORDER BY idart,fech,tipo,ndoc
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function KardexIndividualcontable(ncoda, fi, ff, fii, Ccursor)
	If ncoda > 0 Then
		Text To lC Noshow Textmerge
		   SELECT b.rcom_fech AS fech,b.ndoc,IFNULL(b.tdoc,'') AS tdoc,a.tipo,a.cant,ROUND(a.prec,2) AS prec,
	       b.mone,b.idcliente,c.razo AS cliente,b.idprov,e.razo AS proveedor,
	       b.dolar AS dola,b.vigv AS igv,b.idauto,a.idart  FROM fe_kar AS a
	       INNER JOIN fe_rcom AS b  ON(b.idauto=a.idauto)
	       LEFT JOIN fe_prov AS e ON (e.idprov=b.idprov)
	       LEFT JOIN fe_clie AS c  ON (c.idclie=b.idcliente)
	       WHERE a.idart=<<ncoda>>   AND  b.rcom_fech  BETWEEN '<<fi>>' AND '<<ff>>' AND a.acti<>'I' AND b.acti<>'I'
	       AND b.tcom<>'T' AND rcom_tipo='C'
	       UNION ALL
	       SELECT invi_fech AS fech,'Inv.Inicial' AS ndoc,'II' AS tdoc,'C' AS tipo,
	       invi_cant AS cant,invi_prec AS prec,'S' AS mone,CAST(0 AS DECIMAL(2)) AS idcliente,'' AS cliente,CAST(0 AS DECIMAL(2)) AS idprov,
	      '' AS proveedor,g.dola,g.igv,invi_idin AS idauto,invi_idar as idart FROM fe_inicial AS z, fe_gene AS g
	      WHERE invi_idar=<<ncoda>>  and invi_fech='<<fii>>' and invi_acti='A' ORDER BY fech,tipo,ndoc
		Endtext
	Else
		Text To lC Noshow Textmerge
	       SELECT b.rcom_fech as fech,b.ndoc,b.tdoc,a.tipo,a.cant,
		   ROUND(a.prec,2) as prec,b.mone,b.idcliente,
		   c.razo as cliente,b.idprov,e.razo as proveedor,
           b.dolar as dola,b.vigv as igv,b.idauto,a.idkar,a.idart
           from fe_kar as a
           inner join fe_rcom as b ON(b.idauto=a.idauto)
           left JOIN fe_prov as e ON (e.idprov=b.idprov)
           LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente)
           left join vgr as q on q.guic_idau=b.idauto
           WHERE  b.rcom_fech between '<<fi>>'  and '<<ff>>' and a.acti='A' and b.acti='A' and b.tcom<>'T' and rcom_tipo='C'
           union all
           SELECT invi_fech AS fech,'Inv.Inicial' AS ndoc,'II' AS tdoc,'C' AS tipo,
           invi_cant AS cant,invi_prec AS prec,'S' AS mone,CAST(0 AS DECIMAL(2)) AS idcliente,'' AS cliente,CAST(0 AS DECIMAL(2)) AS idprov,
           '' AS proveedor,g.dola,g.igv,invi_idin AS idauto,cast(0 as  decimal(2)) as idkar,invi_idar as idart
           FROM fe_inicial AS z, fe_gene AS g WHERE invi_fech='<<fii>>' and invi_acti='A'
           OrDER BY fech,tipo,ndoc
		Endtext
	Endif
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultamvtosresumidos(fi, ff, fii, Ccursor)
	Text To lC Noshow Textmerge
	       SELECT q.coda,b.descri,b.unid,si,compras,ventas,stock  FROM (
		   SELECT x.coda,sum(si) as si,Sum(compras) As compras,Sum(ventas) As ventas,sum(si)+Sum(compras)-Sum(ventas) As stock from(
		   Select idart as coda,a.alma,cast(000000.00 as decimal(12,2)) as Si,cant As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_kar as a
		   inner join fe_rcom as b  on  b.idauto=a.idauto
		   Where a.tipo='C' and a.acti='A' and b.acti='A' AND b.rcom_fech between '<<fi>>' and '<<ff>>' and b.tcom<>'T' and b.rcom_tipo='C'
		   Union All
		   Select idart as coda,c.alma,cast(000000.00 as decimal(12,2)) as si,cast(0000000.00 as decimal(12,2))  As compras,cant As ventas
		   From fe_kar as c
		   inner join fe_rcom as d  on  d.idauto=c.idauto
		   Where c.tipo='V' and c.acti='A' and d.acti='A' AND d.rcom_fech between '<<fi>>' and '<<ff>>' and d.tcom<>'T' and
		   d.rcom_tipo='C'
		   union all
		   Select invi_idar as coda,CAST(1 as decimal(2)) as alma,invi_cant as si,cast(0000000.00 as decimal(12,2))  As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_inicial as z
		   Where z.invi_acti='A' AND invi_fech='<<fii>>')
		   as x group by x.coda) as q  inner join fe_art as b ON b.idart=q.coda where  si<>0 or compras<>0 or ventas<>0  order by b.descri
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraInventarioInicial(df, Ccursor)
	Sw = 1
	lC = 'ProIngresaInventarioInicial'
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	This.CONTRANSACCION = 'S'
	Select (Ccursor)
	Scan All
		goApp.npara1 = inventario.coda
		goApp.npara2 = inventario.alma
		goApp.npara3 = inventario.costo
		goApp.npara4 = df
		Text To lp Noshow
       (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		Endtext
		If This.EJECUTARP(lC, lp) < 1 Then
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		If This.DEshacerCambios() >= 1 Then
			This.Cmensaje = "Se Deshacieron los Cambios Ok"
			Return 0
		Else
			This.Cmensaje = "No Se Deshacieron los Cambios Ok"
			Return 0
		Endif
	Else
		If This.GRabarCambios() < 1 Then
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function CalCularStock()
	Local cur As String
	lC = 'CalcularStock'
	cur = ""
	lp = ""
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
******************
	Function CalCularStockContable()
	Local cur As String
	lC = 'CalcularStock1'
	cur = ""
	lp = ""
	If This.EJECUTARP(lC, lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function calcularstockportienda(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	  \Select nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,sei,cuatro,cin,idmar,alma From(
      \Select a.idart As nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \Sum(Case a.alma When 6 Then If(Tipo='C',cant,-cant) Else 0 End) As sei,
      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cin,b.idmar,prod_cod1,m.dmar As marca
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 2
             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 3
             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 4
             \,Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 5
             \,Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 6
             \,Sum(Case a.alma When 6 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As C  On C.Idauto=a.Idauto
      \Where  C.fech<='<<f1>>' And C.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.marca > 0 Then
	      \And b.idmar=<<This.marca>>
	Endif
	If This.codtienda > 0 Then
	     \And a.alma=<<This.codtienda>>
	Endif
	  \Group By a.idart) As a
      \Left Join (Select idart,Max(fech) As ultimacompra From fe_kar As k
      \INNER Join fe_rcom As r On r.`Idauto`=k.`Idauto`
      \Where k.Acti='A' And  r.`Acti`='A' And Tipo='C' Group By idart) As b   On b.idart=a.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockportiendapsystr(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	  \Select nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,cuatro,cin,idmar,alma,costo
	  \From(
      \Select a.idart As nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cin,b.idmar,prod_cod1,m.dmar As marca,
      \If(tmon = 'S', b.Prec, b.Prec * v.dola) As costo
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 2
             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 3
             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 4
             \,Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 5
             \,Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As C  On C.Idauto=a.Idauto, fe_gene As v
      \Where  C.fech<='<<f1>>' And C.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.marca > 0 Then
	      \And b.idmar=<<This.marca>>
	Endif
	If This.codtienda > 0 Then
	     \And a.alma=<<This.codtienda>>
	Endif
	  \Group By a.idart) As a
      \Left Join (Select idart,Max(fech) As ultimacompra From fe_kar As k
      \INNER Join fe_rcom As r On r.`Idauto`=k.`Idauto`
      \Where k.Acti='A' And  r.`Acti`='A' And Tipo='C' Group By idart) As b   On b.idart=a.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockportiendapsysm(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	  \Select nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,uno,Dos,tres,cuatro,cinco,idmar,alma From(
      \Select a.idart As nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cinco,b.idmar,m.dmar As marca
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 2
             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 3
             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 4
             \,Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 5
             \,Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As C  On C.Idauto=a.Idauto
      \Where  C.fech<='<<f1>>' And C.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.marca > 0 Then
	      \And b.idmar=<<This.marca>>
	Endif
	If This.codtienda > 0 Then
	     \And a.alma=<<This.codtienda>>
	Endif
	  \Group By a.idart) As a
      \Left Join (Select idart,Max(fech) As ultimacompra From fe_kar As k
      \INNER Join fe_rcom As r On r.`Idauto`=k.`Idauto`
      \Where k.Acti='A' And  r.`Acti`='A' And Tipo='C' Group By idart) As b   On b.idart=a.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calculavalorizadogeneralunidades(dfi, dff)
	na = Alltrim(Str(Year(dff)))
	todos = 0
	Create Cursor k(fech D, Tdoc C(2), serie C(4), Ndoc C(8), ct C(1), Razo C(80)Null, ingr N(10, 2), prei N(10, 2), ;
		  impi N(10, 2), egre N(10, 2), pree N(10, 2), impe N(10, 2), stock N(10, 2), cost N(10, 2), saldo N(10, 2), ;
		  Desc C(100), Unid C(10), coda N(8), fechaUltimaCompra D, preciosingiv N(10, 2), codigoFabrica C(50), marca C(50), ;
		  linea C(50), grupo C(50), Idauto N(12) Default 0, Importe N(12, 2), Cestado C(1) Default 'C', nreg N(12))
	Select coda, Descri As Desc, Unid From lx Into Cursor xc Order By Descri
	ff = cfechas(dff)
	Text To lC Noshow Textmerge
				    select b.fech,b.ndoc,b.tdoc,a.tipo,ROUND(a.cant*a.kar_equi,2) as cant,
					ROUND(a.prec,2) as prec,b.mone,b.idcliente,
					c.razo as cliente,b.idprov,e.razo as proveedor,
					b.dolar as dola,b.vigv as igv,b.idauto,a.idkar,a.idart
					from fe_kar as a 
					inner join fe_rcom as b ON(b.idauto=a.idauto)
					left JOIN fe_prov as e ON (e.idprov=b.idprov)
					LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente)
					WHERE b.fech<='<<ff>>' and a.acti='A' and b.acti='A' and b.tcom<>'T' 
					OrDER BY b.fech,a.tipo,b.tdoc,b.ndoc
	Endtext
	If This.EjecutaConsulta(lC, 'kkxx') < 1 Then
		Return 0
	Endif
	Select xc
	Go Top
	Do While !Eof()
		ccoda = xc.coda
		cdesc = xc.Desc
		cunid = xc.Unid
		nidart = xc.coda
*!*			dfechaUltimaCompra =Iif(Isnull(xc.fechaUltimaCompra), Date(),xc.fechaUltimaCompra)
*!*			npreciosingiv=xc.preciosingiv
		Select * From kkxx Where idart = ccoda Into Cursor kardex
		x = 0
		Sw = "N"
		Store 0 To calma, x, Crazon, ing, egr, costo, toti, sa_to
		calma = 0
		Sele kardex
		Scan All
			If kardex.fech < dfi Then
				If Tipo = "C" Then
					cmone = kardex.Mone
					ndolar = kardex.dola
					If cmone = "D"
						xprec = Prec * ndolar
					Else
						xprec = Prec
					Endif
					If xprec = 0
						xprec = costo
					Endif
					toti = toti + (Iif(cant = 0, 1, cant) * xprec)
					xdebe = Round(Iif(cant = 0, 1, cant) * xprec, 2)
					calma = calma + cant
					If calma < 0 Then
						If kardex.cant <> 0 Then
							sa_to = Round(calma * xprec, 2)
						Else
							sa_to = sa_to + xdebe
						Endif
					Else
						If sa_to < 0 Then
							sa_to = Round(calma * xprec, 2)
						Else
							If sa_to = 0 Then
								sa_to = Round(calma * xprec, 2)
							Else
								sa_to = Round(sa_to + xdebe, 2)
							Endif
						Endif
					Endif
					If toti <> 0 Then
						costo = Iif(calma <> 0, Round(sa_to / calma, 4), xprec)
					Endif
					If costo = 0
						costo = xprec
					Endif
				Else
					calma = calma - cant
					xhaber = Round(costo * kardex.cant, 2)
					If calma = 0 Then
						sa_to = 0
					Else
						sa_to = sa_to - xhaber
					Endif
				Endif
			Else
				If x = 0
					saldoi = calma
					Insert Into k(fech, Razo, stock, cost, saldo, coda, Desc, Unid, coda);
						Values(kardex.fech, "Stock Inicial", calma, costo, Round(calma * costo, 2), ccoda, cdesc, cunid, nidart)
					sa_to = Round(calma * costo, 2)
					ing = 0
					egr = 0
					xtdebe = 0
					xthaber = 0
				Endif
				Sw = "S"
				x = x + 1
				If Tipo = "C" Then
					cTdoc = kardex.Tdoc
					cmone = kardex.Mone
					cndoc = kardex.Ndoc
					ndolar = kardex.dola
					If cmone = "D"
						xprec = Prec * ndolar
					Else
						xprec = Prec
					Endif
					If xprec = 0
						xprec = costo
					Endif
					ing = ing + cant
					toti = toti + (Iif(cant = 0, 1, cant) * xprec)
					xdebe = Round(Iif(cant = 0, 1, cant) * xprec, 2)
					xtdebe = xtdebe + xdebe
					calma = calma + kardex.cant
					If calma < 0 Then
						If kardex.cant <> 0 Then
							sa_to = Round(calma * xprec, 2)
						Else
							sa_to = sa_to + xdebe
						Endif
					Else
						If sa_to < 0 Then
							sa_to = Round(calma * xprec, 2)
						Else
							If sa_to = 0 Then
								sa_to = Round(calma * xprec, 2)
							Else
								sa_to = Round(sa_to + xdebe, 2)
							Endif
						Endif
					Endif
					If toti <> 0 Then
						costo = Iif(calma <> 0, Round(sa_to / calma, 4), xprec)
					Endif
					If costo = 0
						costo = xprec
					Endif
					Crazon = Iif(Isnull(kardex.proveedor), "                                             ", kardex.proveedor)
					Insert Into k(fech, Tdoc, serie, Ndoc, ct, Razo, ingr, prei, impi, stock, cost, saldo, coda, Desc, Unid, Idauto, nreg, coda);
						Values(kardex.fech, cTdoc, Left(cndoc, 4), Substr(cndoc, 5), "I", Crazon, kardex.cant, ;
						  xprec, xdebe, calma, costo, sa_to, ccoda, cdesc, cunid, kardex.Idauto, kardex.idkar, kardex.idart)
				Else
					egr = egr + cant
					calma = calma - kardex.cant
					xhaber = Round(costo * kardex.cant, 2)
					xthaber = xthaber + xhaber
					If calma = 0 Then
						sa_to = 0
					Else
						sa_to = sa_to - xhaber
					Endif
					Crazon = Iif(Isnull(kardex.cliente), "                                             ", kardex.cliente)

					Insert Into k(fech, Tdoc, serie, Ndoc, ct, Razo, egre, pree, impe, stock, cost, saldo, coda, Desc, Unid, coda);
						Values(kardex.fech, kardex.Tdoc, Left(kardex.Ndoc, 3), Substr(kardex.Ndoc, 4), "S", Crazon, kardex.cant, ;
						  costo, xhaber, calma, costo, sa_to, ccoda, cdesc, cunid, kardex.idart)
				Endif
			Endif
		Endscan
		If Sw = "N"
			Insert Into k(Razo, Desc, Unid, stock, cost, saldo, coda, Importe, coda)Values("SIN MOVIMIENTOS ", cdesc, cunid, calma, Iif(calma = 0, 0, costo), sa_to, ccoda, sa_to, nidart)
		Else
			Insert Into k(Razo, ingr, impi, egre, impe, Desc, Unid, coda, Importe, Cestado, coda) Values;
				("TOTALES ->:", ing, xtdebe, egr, xthaber, cdesc, cunid, ccoda, sa_to, 'T', nidart)
		Endif
		Select xc
		Skip
	Enddo
	Return 1
	Endfunc
	Function calcularstockportiendapsysrx(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  q.idart As nreg, q.idart, a.Descri As Descr, x.dmar, q.uno, q.Dos, q.tres, q.cuatro, q.cin, q.sei, q.sie, q.och, q.nue, q.die, q.once, a.Peso, x.idmar, q.alma From
	\(Select a.idart,
	\Sum(Case a.alma When 1 Then If(Tipo = 'C', cant, - cant) Else 0 End) As uno,
	\Sum(Case a.alma When 2 Then If(Tipo = 'C', cant, - cant) Else 0 End) As Dos,
	\Sum(Case a.alma When 3 Then If(Tipo = 'C', cant, - cant) Else 0 End) As tres,
	\Sum(Case a.alma When 4 Then If(Tipo = 'C', cant, - cant) Else 0 End) As cuatro,
	\Sum(Case a.alma When 5 Then If(Tipo = 'C', cant, - cant) Else 0 End) As cin,
	\Sum(Case a.alma When 6 Then If(Tipo = 'C', cant, - cant) Else 0 End) As sei,
	\Sum(Case a.alma When 7 Then If(Tipo = 'C', cant, - cant) Else 0 End) As sie,
	\Sum(Case a.alma When 8 Then If(Tipo = 'C', cant, - cant) Else 0 End) As och,
	\Sum(Case a.alma When 9 Then If(Tipo = 'C', cant, - cant) Else 0 End) As nue,
	\Sum(Case a.alma When 10 Then If(Tipo = 'C', cant, - cant) Else 0 End) As die,
	\Sum(Case a.alma When 11 Then If(Tipo = 'C', cant, - cant) Else 0 End) As once
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.uno'
		Case This.codtienda = 2
             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.dos'
		Case This.codtienda = 3
             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.cua'
		Case This.codtienda = 4
             \,Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.cua'
		Case This.codtienda = 5
             \,Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.cin'
		Case This.codtienda = 6
             \,Sum(Case a.alma When 6 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.sei'
		Case This.codtienda = 7
             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.sie'
		Case This.codtienda = 8
             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.och'
		Case This.codtienda = 9
             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.nue'
		Case This.codtienda = 10
             \,Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.die'
		Case This.codtienda = 11
             \,Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
			ctienda = 'q.onc'
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
	\From fe_kar As a
	\INNER Join fe_rcom As C  On C.Idauto = a.Idauto Where C.fech <= '<<f1>>' And C.Acti <> 'I'  And a.Acti <> 'I' Group By a.idart)
	\As q
	\INNER Join fe_art a On a.idart = q.idart
	\INNER Join fe_mar As x On x.idmar = a.idmar Where  a.tipro <> 'S' And a.prod_acti <> 'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.marca > 0 Then
	      \And b.idmar=<<This.marca>>
	Endif
	If This.codtienda > 0 Then
	     \And <<ctienda>> <> 0
	Endif
	\Order By a.Descri ;
		Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockportiendaxsys3(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select  a.idart As nreg, a.idart, b.Descri As Descr, b.prod_unid1, b.Unid, a.uno, a.Dos, a.tres, a.cuatro, (a.uno + a.Dos + a.tres + a.cuatro) As Total,
	\b.prod_cost As costo,
	\((a.uno + a.Dos + a.tres + a.cuatro) * b.prod_cost) As subtotal,
	\b.prod_equi1 As equi
	\From (Select idart, Sum(Case k.alma When 1 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As uno,
	\Sum(Case k.alma When 2 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As Dos,
	\Sum(Case k.alma When 3 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As tres,
	\Sum(Case k.alma When 4 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As cuatro
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case a.alma When 1 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Case This.codtienda = 2
             \,Sum(Case a.alma When 2 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Case This.codtienda = 3
             \,Sum(Case a.alma When 3 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Case This.codtienda = 4
            \,Sum(Case a.alma  When 4  Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
	\ From
	\fe_kar As k INNER Join fe_rcom As r On r.Idauto = k.Idauto
	\Where r.fech <= '<<f1>>' And r.Acti <> 'I' And k.Acti <> 'I' Group By k.idart ) As a
	\INNER Join fe_art As b On b.idart = a.idart
	\Where b.prod_acti <> 'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.ncodigop > 0 Then
	   \And b.ulpc=<<This.ncodigop>>
	Endif
	\ Order By b.Descri
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockportiendapsysn(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	  \Select nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,idmar,alma,costo From(
      \Select a.idart As nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \b.idmar,m.dmar As marca,prod_cod1,Round(If(tmon='S',a.Prec,a.Prec*g.dola),2)As costo
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 2
             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 3
             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As C  On C.Idauto=a.Idauto,fe_gene As g
      \Where  C.fech<='<<f1>>' And C.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.marca > 0 Then
	      \And b.idmar=<<This.marca>>
	Endif
	If This.codtienda > 0 Then
	     \And a.alma=<<This.codtienda>>
	Endif
	  \Group By a.idart) As a
      \Left Join (Select idart,Max(fech) As ultimacompra From fe_kar As k
      \INNER Join fe_rcom As r On r.`Idauto`=k.`Idauto`
      \Where k.Acti='A' And  r.`Acti`='A' And Tipo='C' Group By idart) As b   On b.idart=a.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function calcularstockportiendapsystr1(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	  \Select nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,cuatro,cin,idmar,costo
	  \From(
      \Select a.idart As nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cin,b.idmar,prod_cod1,m.dmar As marca,
      \If(tmon = 'S', b.Prec, b.Prec * v.dola) As costo
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As C  On C.Idauto=a.Idauto, fe_gene As v
      \Where  C.fech<='<<f1>>' And C.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
	If This.linea > 0 Then
        \And b.idcat=<<This.linea>>
	Endif
	If This.marca > 0 Then
	      \And b.idmar=<<This.marca>>
	Endif
      \ Group By a.idart) As a
      \ Left Join (Select idart,Max(fech) As ultimacompra From fe_kar As k
      \ INNER Join fe_rcom As r On r.`Idauto`=k.`Idauto`
      \ Where k.Acti='A' And  r.`Acti`='A' And Tipo='C' Group By idart) As b   On b.idart=a.idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioporfechavtolote(Ccursor)
	F = cfechas(This.Fecha)
	Text To lC Noshow Textmerge
	 SELECT a.idart,descri,unid,prod_unid1,prod_equi1,prod_equi2,b.uno AS cant,kar_lote,kar_fvto,z.uno AS stock,dcat as linea,a.prod_cod1 FROM ( 
     SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
	 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
	 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
	 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro,kar_lote,kar_fvto
	 FROM
	 fe_kar AS k INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
	 WHERE r.fech <= '<<f>>' AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart,kar_lote,kar_fvto HAVING uno>0  ORDER BY idart)
	 AS b INNER JOIN fe_art AS a ON a.idart=b.idart 
	 inner join fe_cat AS c on c.idcat=a.idcat
     INNER JOIN 
	 (SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
	 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
	 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
	 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro
	 FROM
	 fe_kar AS k INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
	 WHERE r.fech <= '<<f>>' AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart HAVING uno>0  ORDER BY idart)
	 AS z ON z.idart=b.idart order by a.idart,kar_fvto desc
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultamvtosresumidosunidades(fi, ff, fii, Ccursor)
	Text To lC Noshow Textmerge
	       SELECT q.coda,b.descri,b.unid,si,compras,ventas,stock  FROM (
		   SELECT x.coda,sum(si) as si,Sum(compras) As compras,Sum(ventas) As ventas,sum(si)+Sum(compras)-Sum(ventas) As stock from(
		   Select idart as coda,a.alma,cast(000000.00 as decimal(12,2)) as Si,cant*kar_equi As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_kar as a
		   inner join fe_rcom as b  on  b.idauto=a.idauto
		   Where a.tipo='C' and a.acti='A' and b.acti='A' AND b.fech between '<<fi>>' and '<<ff>>' and b.tcom<>'T' and b.rcom_tipo='C'
		   Union All
		   Select idart as coda,c.alma,cast(000000.00 as decimal(12,2)) as si,cast(0000000.00 as decimal(12,2))  As compras,cant*kar_equi As ventas
		   From fe_kar as c
		   inner join fe_rcom as d  on  d.idauto=c.idauto
		   Where c.tipo='V' and c.acti='A' and d.acti='A' AND d.fech between '<<fi>>' and '<<ff>>' and d.tcom<>'T' and   d.rcom_tipo='C'
		   union all
		   Select idart as coda,CAST(1 as decimal(2)) as alma,if(a.tipo='C',cant*kar_equi,-cant*kar_equi) as si,cast(0000000.00 as decimal(12,2))  As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_rcom as c
		   inner join fe_kar as a On a.idauto=c.idauto
		   Where c.acti='A' and a.acti='A' AND c.fech='<<fii>>' and c.tcom<>'T' and  c.rcom_tipo='C')
		   as x group by x.coda) as q  inner join fe_art as b ON b.idart=q.coda where  si<>0 or compras<>0 or ventas<>0  order by b.descri
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function KardexIndividualcontableunidades(ncoda, fi, ff, fii, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		   \Select b.fech,b.Ndoc,b.Tdoc,a.Tipo,a.cant*kar_equi As cant,Round(a.Prec,4) As Prec,
	       \b.Mone,b.idcliente,C.Razo As cliente,b.idprov,e.Razo As proveedor,
	       \b.dolar As dola,b.vigv As igv,b.Idauto,a.idart,a.idkar  From fe_kar As a
	       \INNER Join fe_rcom As b  On(b.Idauto=a.Idauto)
	       \Left Join fe_prov As e On (e.idprov=b.idprov)
	       \Left Join fe_clie As C  On (C.idclie=b.idcliente)
	       \Where   b.fech  Between '<<fi>>' And '<<ff>>' And a.Acti<>'I' And b.Acti<>'I'
	       \And b.tcom<>'T' And rcom_tipo='C'
	If ncoda > 0 Then
	          \And a.idart=<<ncoda>>
	Endif
	       \ Order By fech,Tipo,Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function rotacionproductos(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow  Textmerge
	\Select a.prod_cod1,a.Descri,a.Unid,m.dmar,b.stocki,b.tingresos,b.tegresos,(b.stocki+b.tingresos-b.tegresos) As sfinal,0 As reposicion,b.ulfc,b.ulfv,b.idart As coda
	\From (Select Sum(If(D.fech<'<<f1>>',If(Tipo='C',cant,-cant),0)) As stocki,
	\Sum(If(D.fech Between '<<f1>>' And '<<f2>>',If(Tipo='C',cant,0),0)) As tingresos,
	\Sum(If(D.fech Between '<<f1>>' And '<<f2>>',If(Tipo='V',cant,0),0)) As tegresos,MAX(IF(tipo='C',D.fech,'0001-01-01')) AS ulfc, 
	\MaX(IF(tipo='V',D.fech,'0001-01-01')) AS ulfv,C.idart
	\From fe_rcom As D
	\INNER Join fe_kar As C On C.Idauto=D.Idauto
	\Where D.Acti='A' And C.Acti='A'
	If This.codtienda > 0 Then
	   \ And  C.alma=<<This.codtienda>>
	Endif
	\Group By C.idart) As b
	\INNER Join fe_art As a On a.idart=b.idart
	\INNER Join fe_mar As m On m.idmar=a.idmar
	If This.marca > 0 Then
	    \ Where  a.idmar=<<This.marca>>
	Endif
	\Order By a.Descri;
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine


















