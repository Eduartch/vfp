Define Class inventarios As Odata Of 'd:\capass\database\data.prg'
	marca = 0
	linea = 0
	codtienda = 0
	ncodigop = 0
	cunidad = ""
	Fecha = Date()
	ncosto = 0
	dfi = Date()
	dff = Date()
	nidart = 0
	nstock = 0
	tajuste = 0
	contraspasos = 0
	Function saldosinicialeskardex(Df, ncoda, nalma, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select k.idart,Sum(If(Tipo='C',cant,-cant)) As inicial From fe_rcom As r
	\INNER Join fe_kar As k On k.`Idauto`=r.`Idauto`
	\Where fech<'<<df>>' And idart=<<ncoda>> And r.Acti='A' And k.Acti='A'
	If nalma > 0 Then
	   \And k.alma=<<nalma>>
	Endif
	\Group By idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function saldosinicialeskardexuidadescontable(Df, ncoda, nalma, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
    \Select k.idart,Sum(If(Tipo='C',cant,-cant)) As inicial From fe_rcom As r
	\INNER Join fe_kar As k On k.`Idauto`=r.`Idauto`
	\Where fech<'<<df>>' And idart=<<ncoda>> And r.Acti='A' And k.Acti='A' And Tdoc Not In('GI','20')
	If nalma > 0 Then
	   \And k.alma=<<nalma>>
	Endif
	\Group By idart
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioresumidoconii(dfi, dff, dfii, Ccursor)
	TEXT To lC Noshow Textmerge
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
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioresumidoconiicontable(dfi, dff, dfii, Ccursor)
	TEXT To lC Noshow Textmerge
	  SELECT a.idart AS idart,c.descri,c.unid,cant,CAST(IF(mone='S',a.prec,a.prec*dolar)  AS DECIMAL(12,6))AS  precio,
	  tipo,rcom_fech AS fech,d.ndoc
	  FROM fe_rcom AS d
	  INNER JOIN fe_kar AS a ON a.idauto=d.idauto
	  INNER JOIN fe_art AS c ON c.idart=a.idart
	  WHERE  d.rcom_fech BETWEEN '<<dfi>>' and '<<dff>>' AND a.acti<>'I' AND d.acti<>'I'  AND d.tcom<>'T' AND d.rcom_tipo='C'
	  UNION ALL
	  SELECT invi_idar  AS idart,p.descri,unid,invi_cant AS cant,invi_prec AS precio,'C' AS tipo,invi_fech AS fech,'Inv.Inicial' AS ndoc
	  FROM fe_inicial AS z
	  INNER JOIN fe_art AS p ON p.idart=z.invi_idar
	  WHERE z.invi_acti='A'   AND z.invi_fech='<<dfii>>' and invi_acti='A' ORDER BY idart,fech,tipo,ndoc
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function KardexIndividualcontable(ncoda, fi, ff, fii, Ccursor)
	Set  Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select b.rcom_fech As fech, b.Ndoc, IFNULL(b.Tdoc, '') As Tdoc, a.Tipo, a.cant, Round(a.Prec, 2) As Prec,
	\b.Mone, b.Idcliente, c.Razo As cliente, b.idprov, e.Razo As proveedor,
	\b.dolar As dola, b.vigv As igv, b.Idauto, a.idart  From fe_kar As a
	\INNER Join fe_rcom As b  On(b.Idauto = a.Idauto)
	\Left Join fe_prov As e On (e.idprov = b.idprov)
	\Left Join fe_clie As c  On (c.idclie = b.Idcliente)
	\Where  b.rcom_fech  Between '<<fi>>' And '<<ff>>' And a.Acti <> 'I' And b.Acti <> 'I' And b.tcom <> 'T' And rcom_tipo = 'C'
	If ncoda > 0 Then
	   \ And a.idart=<<ncoda>>
	Endif
	\Union All
	\Select invi_fech As fech, 'Inv.Inicial' As Ndoc, 'II' As Tdoc, 'C' As Tipo,
	\invi_cant As cant, invi_prec As Prec, 'S' As Mone, Cast(0 As Decimal(2)) As Idcliente, '' As cliente, Cast(0 As Decimal(2)) As idprov,
	\'' As proveedor, g.dola, g.igv, invi_idin As Idauto, invi_idar As idart From fe_inicial As z, fe_gene As g
	\Where invi_fech = '<<fii>>' And invi_acti = 'A'
	If ncoda > 0 Then
	  \ And invi_idar =<<ncoda>>
	Endif
	\ Order By fech, Tipo, Ndoc
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultamvtosresumidos(fi, ff, fii, Ccursor)
	TEXT To lC Noshow Textmerge
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
		   Where c.tipo='V' and c.acti='A' and d.acti='A' AND d.rcom_fech between '<<fi>>' and '<<ff>>' and d.tcom<>'T' and  d.rcom_tipo='C'
		   union all
		   Select invi_idar as coda,CAST(1 as decimal(2)) as alma,invi_cant as si,cast(0000000.00 as decimal(12,2))  As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_inicial as z
		   Where z.invi_acti='A' AND invi_fech='<<fii>>')
		   as x group by x.coda) as q  inner join fe_art as b ON b.idart=q.coda where  si<>0 or compras<>0 or ventas<>0  order by b.descri
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultamvtosresumidos1(fi, ff, fii, Ccursor)
	TEXT To lC Noshow Textmerge
	       SELECT q.coda,b.descri,b.unid,si,compras,ventas,stock  FROM (
		   SELECT x.coda,sum(si) as si,Sum(compras) As compras,Sum(ventas) As ventas,sum(si)+Sum(compras)-Sum(ventas) As stock from(
		   Select idart as coda,a.alma,cast(000000.00 as decimal(12,2)) as Si,cant As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_kar as a
		   inner join fe_rcom as b  on  b.idauto=a.idauto
		   Where a.tipo='C' and a.acti='A' and b.acti='A' AND b.fech between '<<fi>>' and '<<ff>>' and b.tcom<>'T' and tdoc not in('GI','20')
		   Union All
		   Select idart as coda,c.alma,cast(000000.00 as decimal(12,2)) as si,cast(0000000.00 as decimal(12,2))  As compras,cant As ventas
		   From fe_kar as c
		   inner join fe_rcom as d  on  d.idauto=c.idauto
		   Where c.tipo='V' and c.acti='A' and d.acti='A' AND d.fech between '<<fi>>' and '<<ff>>' and d.tcom<>'T' and tdoc not in('GI','20')
		   union all
		   Select idart as coda,CAST(1 as decimal(2)) as alma,	Sum(If(Tipo='C',cant,-cant)) as si,cast(0000000.00 as decimal(12,2))  As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_rcom as z
		   inner join fe_kar as d  on  d.idauto=z.idauto
		   Where z.acti='A' AND z.fech<='<<fii>>' and tdoc not in('GI','20') group By idart)
		   as x group by x.coda) as q
		   inner join fe_art as b ON b.idart=q.coda where  si<>0 or compras<>0 or ventas<>0  order by b.descri
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraInventarioInicial(Df, Ccursor)
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
		goApp.npara4 = Df
		TEXT To lp Noshow
       (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		ENDTEXT
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
	Endif
	Return 1
	Endfunc
	Function calcularstockportienda(Ccursor)
	If This.Idsesion > 1 Then
		Set DataSession To This.Idsesion
	ENDIF
	
*!*		
*!*		


*!*		  \Select Nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,cuatro,cin,sei,idmar,alma,costo
*!*		  \From(
*!*	      \Select a.idart As Nreg,a.idart,b.Descri As Descr,b.Unid,
*!*	      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
*!*	      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
*!*	      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
*!*	      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
*!*	      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cin,
*!*	      \Sum(Case a.alma When 6 Then If(Tipo='C',cant,-cant) Else 0 End) As sei,
*!*	      \b.idmar,prod_cod1,m.dmar As marca,
*!*	      \If(tmon = 'S', b.Prec, b.Prec * v.dola) As costo
*!*		If This.codtienda > 0 Then
*!*			Do Case
*!*			Case This.codtienda = 1
*!*	             \,Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
*!*			Case This.codtienda = 2
*!*	             \,Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
*!*			Case This.codtienda = 3
*!*	             \,Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
*!*			Case This.codtienda = 4
*!*	             \,Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
*!*			Case This.codtienda = 5
*!*	             \,Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
*!*			Case This.codtienda = 6
*!*	             \,Sum(Case a.alma When 6 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
*!*			Endcase
*!*		Else
*!*		  \,Cast(0 As unsigned) As alma
*!*		Endif
*!*	      \From fe_kar As a
*!*	      \INNER Join fe_art As b On a.idart=b.idart
*!*	      \INNER Join fe_mar As m On m.idmar=b.idmar
*!*	      \INNER Join fe_rcom As c  On c.Idauto=a.Idauto, fe_gene As v
*!*	      \Where  c.fech<='<<f1>>' And c.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
*!*		If This.linea > 0 Then
*!*	        \And b.idcat=<<This.linea>>
*!*		Endif
*!*		If This.marca > 0 Then
*!*		      \And b.idmar=<<This.marca>>
*!*		Endif
*!*		If This.codtienda > 0 Then
*!*		     \And a.alma=<<This.codtienda>>
*!*		Endif
*!*		  \Group By a.idart) As a
*!*	      \Left Join (Select idart,Max(fech) As ultimacompra From fe_kar As k
*!*	      \INNER Join fe_rcom As r On r.`Idauto`=k.`Idauto`
*!*	      \Where k.Acti='A' And  r.`Acti`='A' And Tipo='C' Group By idart) As b   On b.idart=a.idart
	
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	\SELECT xx.idart AS Nreg,xx.idart,descri AS Descr,Unid,CAST(IFNULL(b.ultimacompra,'2000-1-1') AS DATE) AS ultimacompra,
	\m.dmar AS marca,xx.uno,xx.Dos,xx.tres,xx.cuatro,xx.cin,xx.sei,a.idmar,alma,
	\IF(tmon = 'S', a.Prec, a.Prec * v.dola) AS costo
	\FROM (  
	\SELECT a.idart,
     \ SUM(CASE a.alma WHEN 1 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS uno,
     \ SUM(CASE a.alma WHEN 2 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS Dos,
     \ SUM(CASE a.alma WHEN 3 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS tres,
     \ SUM(CASE a.alma WHEN 4 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS cuatro,
     \ SUM(CASE a.alma WHEN 5 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS cin,
     \ SUM(CASE a.alma WHEN 6 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS sei
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
      \FROM fe_kar AS a
      \INNER JOIN fe_rcom AS c  ON c.Idauto=a.Idauto, fe_gene AS v
      \WHERE  c.fech<='<<f1>>' AND c.Acti<>'I'  AND a.Acti<>'I' GROUP BY a.idart) AS xx
      \INNER JOIN fe_art AS a ON a.idart=xx.idart
      \INNER JOIN fe_mar AS m ON m.idmar=a.idmar
      \LEFT JOIN (SELECT idart,MAX(fech) AS ultimacompra FROM fe_kar AS k
      \INNER JOIN fe_rcom AS r ON r.`Idauto`=k.`Idauto`
      \WHERE k.Acti='A' AND  r.`Acti`='A' AND Tipo='C' GROUP BY idart) AS b ON b.idart=xx.idart,fe_gene AS v
      \where prod_acti='A'
      If This.linea > 0 Then
        \And a.idcat=<<This.linea>>
	  Endif
	  If This.marca > 0 Then
	      \And a.idmar=<<This.marca>>
	  ENDIF
	  \ order by descri
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
	 \SELECT xx.idart AS Nreg,xx.idart,descri AS Descr,Unid,CAST(IFNULL(b.ultimacompra,'2000-1-1') AS DATE) AS ultimacompra,
 	 \m.dmar AS marca,prod_cod1,xx.uno,xx.Dos,xx.tres,xx.cuatro,xx.cin,xx.sei,a.idmar,alma,
	 \IF(tmon = 'S', a.Prec, a.Prec * v.dola) AS costo
	 \FROM (
	 \SELECT a.idart,
     \ SUM(CASE a.alma WHEN 1 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS uno,
     \ SUM(CASE a.alma WHEN 2 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS Dos,
     \ SUM(CASE a.alma WHEN 3 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS tres,
     \ SUM(CASE a.alma WHEN 4 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS cuatro,
     \ SUM(CASE a.alma WHEN 5 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS cin,
     \ SUM(CASE a.alma WHEN 6 THEN IF(Tipo='C',cant,-cant) ELSE 0 END) AS sei
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
     \ ,CAST(0 AS UNSIGNED) AS alma
	Endif
     \ FROM fe_kar AS a
     \ INNER JOIN fe_rcom AS c  ON c.Idauto=a.Idauto, fe_gene AS v
     \ WHERE  c.fech<='<<f1>>' AND c.Acti<>'I'  AND a.Acti<>'I'
     If This.codtienda > 0 Then
	     \And a.alma=<<This.codtienda>>
	 Endif
     \ GROUP BY a.idart) AS xx
     \ INNER JOIN fe_art AS a ON a.idart=xx.idart
     \ INNER JOIN fe_mar AS m ON m.idmar=a.idmar
     \ LEFT JOIN (SELECT idart,MAX(fech) AS ultimacompra FROM fe_kar AS k
     \ INNER JOIN fe_rcom AS r ON r.`Idauto`=k.`Idauto`
     \ WHERE k.Acti='A' AND  r.`Acti`='A' AND Tipo='C' GROUP BY idart) AS b ON b.idart=xx.idart,fe_gene AS v
     \ where prod_acti='A' 
     If This.linea > 0 Then
        \And a.idcat=<<This.linea>>
	 Endif
	 If This.marca > 0 Then
	      \And a.idmar=<<This.marca>>
	 ENDIF
	\ order by descri 
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
	  \Select Nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,uno,Dos,tres,cuatro,cinco,idmar,alma From(
      \Select a.idart As Nreg,a.idart,b.Descri As Descr,b.Unid,
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
      \INNER Join fe_rcom As c  On c.Idauto=a.Idauto
      \Where  c.fech<='<<f1>>' And c.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
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
	Na = Alltrim(Str(Year(dff)))
	todos = 0
	Create Cursor k(fech D, Tdoc c(2), Serie c(4), Ndoc c(8), ct c(1), Razo c(80)Null, ingr N(10, 2), prei N(10, 2), ;
		impi N(10, 2), egre N(10, 2), pree N(10, 2), impe N(10, 2), stock N(10, 2), cost N(10, 2), saldo N(10, 2), ;
		Desc c(100), Unid c(10), coda N(8), fechaUltimaCompra D, preciosingiv N(10, 2), codigoFabrica c(50), marca c(50), ;
		linea c(50), grupo c(50), Idauto N(12) Default 0, Importe N(12, 2), Cestado c(1) Default 'C', Nreg N(12))
	Select coda, Descri As Desc, Unid From lx Into Cursor xc Order By Descri
	ff = cfechas(dff)
	TEXT To lC Noshow Textmerge
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
	ENDTEXT
	If This.EjecutaConsulta(lC, 'kkxx') < 1 Then
		Return 0
	Endif
	Select xc
	Go Top
	Do While !Eof()
		ccoda = xc.coda
		cdesc = xc.Desc
		cUnid = xc.Unid
		nidart = xc.coda
*!*			dfechaUltimaCompra =Iif(Isnull(xc.fechaUltimaCompra), Date(),xc.fechaUltimaCompra)
*!*			npreciosingiv=xc.preciosingiv
		Select * From kkxx Where idart = ccoda Into Cursor Kardex
		x = 0
		Sw = "N"
		Store 0 To calma, x, Crazon, ing, egr, costo, toti, sa_to
		calma = 0
		Sele Kardex
		Scan All
			If Kardex.fech < dfi Then
				If Tipo = "C" Then
					cmone = Kardex.Mone
					ndolar = Kardex.dola
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
						If Kardex.cant <> 0 Then
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
					xhaber = Round(costo * Kardex.cant, 2)
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
						Values(Kardex.fech, "Stock Inicial", calma, costo, Round(calma * costo, 2), ccoda, cdesc, cUnid, nidart)
					sa_to = Round(calma * costo, 2)
					ing = 0
					egr = 0
					xtdebe = 0
					xthaber = 0
				Endif
				Sw = "S"
				x = x + 1
				If Tipo = "C" Then
					cTdoc = Kardex.Tdoc
					cmone = Kardex.Mone
					cndoc = Kardex.Ndoc
					ndolar = Kardex.dola
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
					calma = calma + Kardex.cant
					If calma < 0 Then
						If Kardex.cant <> 0 Then
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
					Crazon = Iif(Isnull(Kardex.proveedor), "                                             ", Kardex.proveedor)
					Insert Into k(fech, Tdoc, Serie, Ndoc, ct, Razo, ingr, prei, impi, stock, cost, saldo, coda, Desc, Unid, Idauto, Nreg, coda);
						Values(Kardex.fech, cTdoc, Left(cndoc, 4), Substr(cndoc, 5), "I", Crazon, Kardex.cant, ;
						xprec, xdebe, calma, costo, sa_to, ccoda, cdesc, cUnid, Kardex.Idauto, Kardex.idkar, Kardex.idart)
				Else
					egr = egr + cant
					calma = calma - Kardex.cant
					xhaber = Round(costo * Kardex.cant, 2)
					xthaber = xthaber + xhaber
					If calma = 0 Then
						sa_to = 0
					Else
						sa_to = sa_to - xhaber
					Endif
					Crazon = Iif(Isnull(Kardex.cliente), "                                             ", Kardex.cliente)

					Insert Into k(fech, Tdoc, Serie, Ndoc, ct, Razo, egre, pree, impe, stock, cost, saldo, coda, Desc, Unid, coda);
						Values(Kardex.fech, Kardex.Tdoc, Left(Kardex.Ndoc, 3), Substr(Kardex.Ndoc, 4), "S", Crazon, Kardex.cant, ;
						costo, xhaber, calma, costo, sa_to, ccoda, cdesc, cUnid, Kardex.idart)
				Endif
			Endif
		Endscan
		If Sw = "N"
			Insert Into k(Razo, Desc, Unid, stock, cost, saldo, coda, Importe, coda)Values("SIN MOVIMIENTOS ", cdesc, cUnid, calma, Iif(calma = 0, 0, costo), sa_to, ccoda, sa_to, nidart)
		Else
			Insert Into k(Razo, ingr, impi, egre, impe, Desc, Unid, coda, Importe, Cestado, coda) Values;
				("TOTALES ->:", ing, xtdebe, egr, xthaber, cdesc, cUnid, ccoda, sa_to, 'T', nidart)
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
	\Select  q.idart As Nreg, q.idart, a.Descri As Descr, x.dmar, q.uno, q.Dos, q.tres, q.cuatro, q.cin, q.sei, q.sie, q.och, q.nue, q.die, q.once, a.Peso, x.idmar, q.alma From
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
	\INNER Join fe_rcom As c  On c.Idauto = a.Idauto Where c.fech <= '<<f1>>' And c.Acti <> 'I'  And a.Acti <> 'I' Group By a.idart)
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
	\Select  a.idart As Nreg, a.idart, b.Descri As Descr, b.prod_unid1, b.Unid, a.uno, a.Dos, a.tres, a.cuatro, (a.uno + a.Dos + a.tres + a.cuatro) As Total,
	\b.prod_cost As costo,((a.uno + a.Dos + a.tres + a.cuatro) * b.prod_cost) As subtotal,b.prod_equi1 As equi,b.prod_cod1,Cast(alma As Decimal(10,2)) As alma
	\From (Select idart, Sum(Case k.alma When 1 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As uno,
	\Sum(Case k.alma When 2 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As Dos,
	\Sum(Case k.alma When 3 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As tres,
	\Sum(Case k.alma When 4 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As cuatro
	If This.codtienda > 0 Then
		Do Case
		Case This.codtienda = 1
             \,Sum(Case k.alma When 1 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Case This.codtienda = 2
             \,Sum(Case k.alma When 2 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Case This.codtienda = 3
             \,Sum(Case k.alma When 3 Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
		Case This.codtienda = 4
            \,Sum(Case k.alma  When 4  Then If(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) Else 0 End) As alma
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
	  \Select Nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,idmar,alma,costo From(
      \Select a.idart As Nreg,a.idart,b.Descri As Descr,b.Unid,
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
      \INNER Join fe_rcom As c  On c.Idauto=a.Idauto,fe_gene As g
      \Where  c.fech<='<<f1>>' And c.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
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
	  \Select Nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,cuatro,cin,idmar,costo
	  \From(
      \Select a.idart As Nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cin,b.idmar,prod_cod1,m.dmar As marca,
      \If(tmon = 'S', b.Prec, b.Prec * v.dola) As costo
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As c  On c.Idauto=a.Idauto, fe_gene As v
      \Where  c.fech<='<<f1>>' And c.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
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
*!*		TEXT To lC Noshow Textmerge
*!*		 SELECT a.idart,descri,unid,prod_unid1,prod_equi1,prod_equi2,b.uno AS cant,kar_lote,kar_fvto,z.uno AS stock,dcat as linea,a.prod_cod1 FROM (
*!*	     SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
*!*		 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
*!*		 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
*!*		 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro,kar_lote,kar_fvto
*!*		 FROM  fe_kar AS k
*!*		 INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
*!*		 WHERE r.fech <= '<<f>>' AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart,kar_lote,kar_fvto HAVING uno>0  ORDER BY idart)
*!*		 AS b
*!*		 INNER JOIN fe_art AS a ON a.idart=b.idart
*!*		 inner join fe_cat AS c on c.idcat=a.idcat
*!*	     INNER JOIN
*!*		 (SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
*!*		 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
*!*		 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
*!*		 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro
*!*		 FROM  fe_kar AS k
*!*		 INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
*!*		 WHERE r.fech <= '<<f>>' AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart HAVING uno>0  ORDER BY idart)
*!*		 AS z ON z.idart=b.idart order by a.idart,kar_fvto desc
*!*		ENDTEXT
	TEXT To lC Noshow Textmerge
	 SELECT a.idart,descri,unid,prod_unid1,prod_equi1,prod_equi2,b.uno AS cant,kar_lote,kar_fvto,z.uno AS stock,dcat AS linea,a.prod_cod1 FROM
    (SELECT idart, idkar,cant*kar_equi AS uno,CAST(0 AS DECIMAL(10,2)) AS dos,CAST(0 AS DECIMAL(10,2)) AS tres,
    CAST(0 AS DECIMAL(12,2)) AS cuatro,kar_lote,kar_fvto
	 FROM fe_kar AS k
	 INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
	 WHERE r.fech <= '<<f>>' AND r.Acti <> 'I' AND k.Acti <> 'I' AND tipo='C' AND cant>0 ORDER BY idkar DESC)
	 AS b
	 INNER JOIN fe_art AS a ON a.idart=b.idart
	 INNER JOIN fe_cat AS c ON c.idcat=a.idcat
     INNER JOIN
	 (SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
	 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
	 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
	 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro
	 FROM fe_kar AS k
	 INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
	 WHERE r.fech <= '<<f>>' AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart HAVING uno>0  ORDER BY idart)
	 AS z ON z.idart=b.idart ORDER BY idart,idkar DESC
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioporfechavtolotexproducto(Ccursor)
	Calias = 'ls'
	TEXT To lC Noshow Textmerge
	 SELECT a.idart,descri,unid,prod_unid1,prod_equi1,prod_equi2,b.uno AS cant,kar_lote,kar_fvto,z.uno AS stock,dcat as linea,a.prod_cod1 FROM (
     SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
	 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
	 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
	 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro,kar_lote,kar_fvto
	 FROM
	 fe_kar AS k INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
	 WHERE k.idart=<<this.nidart>> AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart,kar_lote,kar_fvto HAVING uno>0  ORDER BY idart)
	 AS b INNER JOIN fe_art AS a ON a.idart=b.idart
	 inner join fe_cat AS c on c.idcat=a.idcat
     INNER JOIN
	 (SELECT idart, SUM(CASE k.alma WHEN 1 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS uno,
	 SUM(CASE k.alma WHEN 2 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS Dos,
	 SUM(CASE k.alma WHEN 3 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS tres,
	 SUM(CASE k.alma WHEN 4 THEN IF(Tipo = 'C', cant * k.kar_equi, - cant * k.kar_equi) ELSE 0 END) AS cuatro
	 FROM
	 fe_kar AS k INNER JOIN fe_rcom AS r ON r.Idauto = k.Idauto
	 WHERE  k.idart=<<this.nidart>> AND r.Acti <> 'I' AND k.Acti <> 'I' GROUP BY k.idart HAVING uno>0  ORDER BY idart)
	 AS z ON z.idart=b.idart order by a.idart,kar_fvto desc
	ENDTEXT
	If This.EjecutaConsulta(lC, 'ls') < 1 Then
		Return 0
	Endif
	Create Cursor (Ccursor)(idart N(8), Descri c(120), Unid c(15), prod_unid1 c(15), prod_equi1 N(10, 2), prod_equi2 N(10, 2), cant N(10, 2), kar_lote c(20), kar_fvto D, stock N(10, 2), estado c(1), linea c(100), prod_cod1 c(15))
	Select (Calias)
	Do While !Eof()
		Select (Calias)
		nid = idart
		nstock = stock
		Sw = 0
		ncant = 0
		Do While !Eof() And idart = nid
			Select (Calias)
			If ncant > nstock
				Skip
				Loop
			Endif
			clote = kar_lote
			dfvto = Iif(Isnull(kar_fvto), Ctod("  /  /    "), kar_fvto)
			ncant = ncant + cant
			If ncant > nstock Then
				If Sw = 0 Then
					Insert Into (Ccursor)(idart, Descri, Unid, prod_unid1, prod_equi1, prod_equi2, cant, kar_lote, kar_fvto,  estado, prod_cod1, linea)Values;
						(ls.idart, ls.Descri, ls.Unid, ls.prod_unid1, ls.prod_equi1, ls.prod_equi2, ls.stock, ls.kar_lote, Iif(Isnull(ls.kar_fvto), Ctod("  /  /    "), ls.kar_fvto), 'A', ls.prod_cod1, ls.linea)
				Else
					Insert Into (Ccursor)(idart, Descri, Unid, prod_unid1, prod_equi1, prod_equi2, cant, kar_lote, kar_fvto,  estado, prod_cod1, linea)Values;
						(ls.idart, ls.Descri, ls.Unid, ls.prod_unid1, ls.prod_equi1, ls.prod_equi2, ls.stock - (ncant - ls.cant), ls.kar_lote, Iif(Isnull(ls.kar_fvto), Ctod("  /  /    "), ls.kar_fvto), 'A', ls.prod_cod1, ls.linea)
				Endif
				Sw = 1
			Else
				Insert Into (Ccursor)(idart, Descri, Unid, prod_unid1, prod_equi1, prod_equi2, cant, kar_lote, kar_fvto, estado, prod_cod1, linea)Values;
					(ls.idart, ls.Descri, ls.Unid, ls.prod_unid1, ls.prod_equi1, ls.prod_equi2, ls.cant, ls.kar_lote, Iif(Isnull(ls.kar_fvto), Ctod("  /  /    "), ls.kar_fvto), 'A', ls.prod_cod1, ls.linea)
			Endif
			Sw = Sw + 1
			Skip
		Enddo
	Enddo
	Return 1
	Endfunc
	Function consultamvtosresumidosunidades(fi, ff, fii, Ccursor)
	TEXT To lC Noshow Textmerge
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
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function KardexIndividualcontableunidades(ncoda, fi, ff, fii, Ccursor)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
		   \Select b.fech,b.Ndoc,b.Tdoc,a.Tipo,a.cant*kar_equi As cant,Round(a.Prec,4) As Prec,
	       \b.Mone,b.Idcliente,c.Razo As cliente,b.idprov,e.Razo As proveedor,
	       \b.dolar As dola,b.vigv As igv,b.Idauto,a.idart,a.idkar  From fe_kar As a
	       \INNER Join fe_rcom As b  On(b.Idauto=a.Idauto)
	       \Left Join fe_prov As e On (e.idprov=b.idprov)
	       \Left Join fe_clie As c  On (c.idclie=b.Idcliente)
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
*!*		IF this.contraspasos=0 then
*!*		\If(Tdoc<>'TT',D.fech,'0001-01-01'),'0001-01-01'),'0001-01-01')) As ulfc,
*!*		ELSE
*!*		\D.fech,'0001-01-01'),'0001-01-01')) As ulfc,
*!*		ENDIF
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow  Textmerge
	\Select a.prod_cod1,a.Descri,a.Unid,m.dmar,b.stocki,b.tingresos,b.tegresos,(b.stocki+b.tingresos-b.tegresos) As sfinal,0 As reposicion,b.ulfc,b.ulfv,b.idart As coda
	\From (Select Sum(If(D.fech<'<<f1>>',If(Tipo='C',cant,-cant),0)) As stocki,
	\Sum(If(D.fech Between '<<f1>>' And '<<f2>>',If(Tipo='C',cant,0),0)) As tingresos,
	\Sum(If(D.fech Between '<<f1>>' And '<<f2>>',If(Tipo='V',cant,0),0)) As tegresos,
	\Max(If(Tipo='C',If(Tdoc<>'AJ',If(Tdoc<>'TT',D.fech,'0001-01-01'),'0001-01-01'),'0001-01-01')) As ulfc,
	If This.contraspasos = 0 Then
	\Max(If(Tipo='V',If(Tdoc<>'AJ',If(Tdoc<>'TT',D.fech,'0001-01-01'),'0001-01-01'),'0001-01-01')) As ulfv,
	Else
	\Max(If(Tipo='V',If(Tdoc<>'AJ',D.fech,'0001-01-01'),'0001-01-01')) As ulfv,
	Endif
	\c.idart
	\From fe_rcom As D
	\INNER Join fe_kar As c On c.Idauto=D.Idauto
	\Where D.Acti='A' And c.Acti='A'
	If This.codtienda > 0 Then
	   \ And  c.alma=<<This.codtienda>>
	Endif
	\Group By c.idart) As b
	\INNER Join fe_art As a On a.idart=b.idart
	\INNER Join fe_mar As m On m.idmar=a.idmar
	If This.marca > 0 Then
	    \ Where  a.idmar=<<This.marca>>
	Endif
	\Order By a.Descri;
	Set Textmerge Off
	Set Textmerge To


*!*		MESSAGEBOX(lc)
*!*		RETURN 0


*!*		Set Textmerge On
*!*		Set Textmerge To Memvar lC Noshow  Textmerge
*!*		\Select a.prod_cod1,a.Descri,a.Unid,m.dmar,b.stocki,b.tingresos,b.tegresos,(b.stocki+b.tingresos-b.tegresos) As sfinal,0 As reposicion,b.ulfc,b.ulfv,b.idart As coda
*!*		\From (Select Sum(If(D.fech<'<<f1>>',If(Tipo='C',cant,-cant),0)) As stocki,
*!*		\Sum(If(D.fech Between '<<f1>>' And '<<f2>>',If(Tipo='C',cant,0),0)) As tingresos,
*!*		\Sum(If(D.fech Between '<<f1>>' And '<<f2>>',If(Tipo='V',cant,0),0)) As tegresos,
*!*		\Max(If(Tipo='C',If(Tdoc<>'AJ',If(Tdoc<>'TT',D.fech,'0001-01-01'),'0001-01-01'),'0001-01-01')) As ulfc,
*!*		\Max(If(Tipo='V',If(Tdoc<>'AJ',If(Tdoc<>'TT',D.fech,'0001-01-01'),'0001-01-01'),'0001-01-01')) As ulfv,c.idart
*!*		\From fe_rcom As D
*!*		\INNER Join fe_kar As c On c.Idauto=D.Idauto
*!*		\Where D.Acti='A' And c.Acti='A'
*!*		If This.codtienda > 0 Then
*!*		   \ And  c.alma=<<This.codtienda>>
*!*		Endif
*!*		\Group By c.idart) As b
*!*		\INNER Join fe_art As a On a.idart=b.idart
*!*		\INNER Join fe_mar As m On m.idmar=a.idmar
*!*		If This.marca > 0 Then
*!*		    \ Where  a.idmar=<<This.marca>>
*!*		Endif
*!*		\Order By a.Descri;
*!*		Set Textmerge Off
*!*		Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Traspasosentrealmacenes(Ccursor)
	f1 = cfechas(This.dfi)
	f2 = cfechas(This.dff)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\Select b.fech,b.Tdoc,b.Ndoc,c.tras_codt As alma,IFNULL(c.tras_codt1,1) As Ndo2,a.Tipo,a.cant,a.idart,b.FUsua,D.nomb As usua,
	\    e.Descri,e.Unid,F.nomb As origen,g.nomb As destino,c.tras_idau As Idauto,b.Deta  As Refe,b.Impo
	\    From fe_kar As a
	\    INNER Join fe_art As e On(e.idart=a.idart)
	\    INNER Join fe_rcom  As b On(b.Idauto=a.Idauto)
	\    INNER Join (Select p.tras_idau,p.tras_idau1,p.tras_codt,p.tras_codt1
	\    From  fe_traspaso As p Group By tras_idau,tras_idau1,tras_codt,tras_codt1) As c On (c.tras_idau=b.Idauto)
	\    INNER Join fe_usua As D On(D.idusua=b.idusua)
	\    INNER Join fe_sucu As F On(F.idalma=c.tras_codt)
	\    INNER Join fe_sucu As g On(g.idalma=c.tras_codt1)
	\    Left Join fe_rcom As x  On x.Idauto=c.tras_idau1
	\    Where b.tcom='T'  And b.Acti<>'I' And b.fech Between '<<f1>>' And '<<f2>>' And a.Acti='A'
	If This.codtienda > 0 Then
	 \ And b.codt=<<This.codtienda>>
	Endif
	\Order By b.fech,b.Ndoc,a.Tipo
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function kardexinterno(Calias)
	If This.nidart < 1 Then
		This.Cmensaje = 'Seleccione un Producto'
		Return 0
	Endif
	dfechai = This.dfi
	dfechaf = This.dff
	ccoda = This.nidart
	fechaf = cfechas(This.Fecha)
	Create Cursor tmpk(Fecha D, Tdoc c(2), dcto c(12), Razo c(40), ingr N(12, 2), ;
		egre N(12, 2), saldo N(12, 2), Moneda c(12), Precio N(10, 2), Refe c(10)Null, usua c(10)Null, ;
		FUsua Datetime Null, usua1 c(10)Null, tipomvto c(20))
	TEXT To lC Noshow Textmerge
	   select ifnull(e.ndoc,'')  as nped,d.ndo2,d.fech,d.ndoc,d.tdoc,a.tipo,d.mone as cmoneda,a.cant,d.fusua,ifnull(g.nomb,'') as usua1,d.codt,
	   a.prec,d.vigv as igv,d.dolar,f.nomb as usua,d.idcliente as codc,b.razo AS cliente,d.idprov as codp,c.razo AS proveedor,d.deta,a.alma
	   FROM fe_kar as a
	   inner JOIN fe_rcom as d on (d.idauto=a.idauto)
	   left join fe_prov as c ON(d.idprov=c.idprov)
	   left JOIN fe_clie as b ON(d.idcliente=b.idclie)
	   LEFT JOIN fe_rped as e ON(e.idautop=d.idautop)
	   inner join fe_usua as f ON(f.idusua=d.idusua)
	   left join fe_usua as g   ON (g.idusua=d.idusua1)
	   WHERE a.idart=<<this.nidart>> and a.alma=<<this.codtienda>> and d.acti<>'I' and d.fech<='<<fechaf>>'
	   and a.acti<>'I' ORDER BY d.fech,d.tipom,a.idkar
	ENDTEXT
	If This.EjecutaConsulta(lC, 'kardex') < 1
		Return 0
	Endif
	Sw = "N"
	cm = ""
	calma = 0
	x = 0
	ing = 0
	egr = 0
	nh = 0
	Select Kardex
	Scan All
		If Kardex.fech < dfechai
			If Tipo = "C"
				calma = calma + cant
			Else
				calma = calma - cant
			Endif
		Else
			If x = 0
				Insert Into tmpk(Fecha, Razo, saldo)Values(Kardex.fech, "Stock Inicial", calma)
			Endif
			x = x + 1
			Sw = 'S'
			Nprecio = Iif(Kardex.Tipo = "C", Kardex.Prec * Kardex.igv, Kardex.Prec)
			If Tipo = "C"
				calma = calma + cant
				ing = ing + cant
				If Isnull(Kardex.proveedor)
					If Almacenes.idalma = Val(Kardex.Ndo2)
						nh = Kardex.codt
					Else
						nh = Val(Kardex.Ndo2)
					Endif
					Crazon = 'Ingresa Desde ' + Iif(nh > 0, RetornaNAlmacen(nh), "")
				Else
					Crazon = Kardex.proveedor
				Endif
				Do Case
				Case Kardex.Tdoc = "01" Or Kardex.Tdoc = "09"
					cm = "Compras"
				Case Kardex.Tdoc = "II"
					cm = "Inventario"
				Case Kardex.Tdoc = "TT"
					cm = "Traspasos"
				Case Kardex.Tdoc = "99"
					cm = "Reposiciones"
				Endcase
				Insert Into tmpk(Fecha, Tdoc, dcto, Razo, ingr, saldo, Moneda, Precio, usua, FUsua, usua1, tipomvto);
					Values(Kardex.fech, Kardex.Tdoc, Kardex.Ndoc, Crazon, Kardex.cant, calma, ;
					Kardex.Cmoneda, Nprecio, Kardex.usua, Kardex.FUsua, Kardex.usua1, cm)
			Else
				calma = calma - cant
				egr = egr + cant
				If Isnull(Kardex.cliente)
					Crazon = 'Salida A ' + Iif(Val(Kardex.Ndo2) > 0, RetornaNAlmacen(Kardex.Ndo2), "")
				Else
					Crazon = Kardex.cliente
				Endif
				Do Case
				Case Kardex.Tdoc = "01" Or Kardex.Tdoc = "03" Or Kardex.Tdoc = "20"
					cm = "Ventas"
				Case Kardex.Tdoc = "TT"
					cm = "Traspasos"
				Case Kardex.Tdoc = "99"
					cm = "Reposiciones"
				Endcase
				Insert Into tmpk(Fecha, Tdoc, dcto, Razo, egre, saldo, Moneda, Precio, usua, FUsua, Refe, usua1, tipomvto);
					Values(Kardex.fech, Kardex.Tdoc, Kardex.Ndoc, Crazon, Kardex.cant, calma, Kardex.Cmoneda, Nprecio, ;
					Kardex.usua, Kardex.FUsua, Kardex.nped, Kardex.usua1, cm)
			Endif
		Endif
	Endscan
	If Sw = 'N'  Then
		_Screen.oProductos.Idsesion = This.Idsesion
		If _Screen.oProductos.calcularstockproducto(This.nidart, This.codtienda, 'sinn') < 1 Then
			This.Cmensaje = _Screen.oProductos.Cmensaje
			Return 0
		Endif
		Insert Into tmpk(Razo, saldo)Values("Stock", sinn.stock)
	Else
		Insert Into tmpk(Razo, ingr, egre)Values("TOTALES ->:", ing, egr)
	Endif
	Return 1
	Endfunc
	Function calcularstockportiendapsystrlyg(Ccursor)
	If This.Idsesion > 0 Then
		Set DataSession To This.Idsesion
	Endif
	f1 = cfechas(This.Fecha)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow
	  \Select Nreg,a.idart,Descr,Unid,Cast(IFNULL(b.ultimacompra,'2000-1-1') As Date) As ultimacompra,marca,prod_cod1,uno,Dos,tres,cuatro,cin,sei,sie,och,idmar,alma,costo,
	  \prod_ubi1,prod_ubi2,prod_ubi3,prod_ubi4,prod_ubi5
	  \From(
      \Select a.idart As Nreg,a.idart,b.Descri As Descr,b.Unid,
      \Sum(Case a.alma When 1 Then If(Tipo='C',cant,-cant) Else 0 End) As uno,
      \Sum(Case a.alma When 2 Then If(Tipo='C',cant,-cant) Else 0 End) As Dos,
      \Sum(Case a.alma When 3 Then If(Tipo='C',cant,-cant) Else 0 End) As tres,
      \Sum(Case a.alma When 4 Then If(Tipo='C',cant,-cant) Else 0 End) As cuatro,
      \Sum(Case a.alma When 5 Then If(Tipo='C',cant,-cant) Else 0 End) As cin,
      \Sum(Case a.alma When 6 Then If(Tipo='C',cant,-cant) Else 0 End) As sei,
      \Sum(Case a.alma When 7 Then If(Tipo='C',cant,-cant) Else 0 End) As sie,
      \Sum(Case a.alma When 8 Then If(Tipo='C',cant,-cant) Else 0 End) As och,
      \b.idmar,prod_cod1,m.dmar As marca,
      \If(tmon = 'S', b.Prec, b.Prec * v.dola) As costo,prod_ubi1,prod_ubi2,prod_ubi3,prod_ubi4,prod_ubi5
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
		Case This.codtienda = 7
             \,Sum(Case a.alma When 7 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Case This.codtienda = 8
             \,Sum(Case a.alma When 8 Then If(Tipo='C',cant,-cant) Else 0 End) As alma
		Endcase
	Else
	  \,Cast(0 As unsigned) As alma
	Endif
      \From fe_kar As a
      \INNER Join fe_art As b On a.idart=b.idart
      \INNER Join fe_mar As m On m.idmar=b.idmar
      \INNER Join fe_rcom As c  On c.Idauto=a.Idauto, fe_gene As v
      \Where  c.fech<='<<f1>>' And c.Acti<>'I' And b.prod_acti<>'I' And a.Acti<>'I'
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
	Function registrAjusteDrogueria()
	cdf = "Ajus" + Right("0000000" + Alltrim(Str(Day(fe_gene.fech))) + Alltrim(Str(Month(fe_gene.fech))) + + Alltrim(Str(Year(fe_gene.fech))), 8)
	Nsgte = 0
	nIdserie = 0
	If BuscarSeries(1, 'AJ') = 0 Then
		This.Cmensaje = "No Existe el Correlativo para Ajuste de Inventarios"
		Return 0
	Endif
	cdf = "0001" + Right("0000000000" + Alltrim(Str(series.nume)), 8)
	Nsgte = series.nume
	nIdserie = series.Idserie
	If This.inventarioporfechavtolotexproducto('lotexproducto') < 1 Then
		Return 0
	Endif

	If This.IniciaTransaccion() < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	NAuto = IngresaResumenDcto('AJ', 'E', cdf, fe_gene.fech, fe_gene.fech, 'Ajuste de Inventarios', 0, 0, 0, "", 'S', ;
		fe_gene.dola, fe_gene.igv, '1', Val(goApp.Proveedorajuste), '1', goApp.nidusua, 0, This.codtienda, 0, 0, 0, 0, 0)
	If NAuto < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	Sw = 1
	Select lotexproducto
	Go Top
	Scan All
		najuste = 0 - lotexproducto.cant
		If IngresaKardexFl(NAuto, This.nidart, 'C', This.ncosto, najuste, 'I', 'K', 0, This.codtienda, 0, 0, 1, This.cunidad, 0, 1, 0, fe_gene.igv, lotexproducto.kar_fvto, lotexproducto.kar_lote) = 0 Then
			Mensaje = "Al Ingresar Detalle de Ingresos"
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		This.Cmensaje = Mensaje
		Return 0
	Endif
	Select tlotes
	Scan All
		If IngresaKardexFl(NAuto, This.nidart, 'C', This.ncosto, tlotes.Cantidad, 'I', 'K', 0, This.codtienda, 0, 0, 1, This.cunidad, 0, 1, 0, fe_gene.igv, tlotes.fvto, tlotes.lote) = 0 Then
			Mensaje = "Al Ingresar Detalle de Ingresos"
			Sw = 0
			Exit
		Endif
		If Actualizastock1(This.nidart, This.codtienda, tlotes.Cantidad, 'C', 1) = 0 Then
			Mensaje = "Al Actualizar Stock"
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		This.Cmensaje = Mensaje
		Return 0
	Endif
	If GeneraNumero(Substr(cdf, 5), Nsgte, nIdserie) = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	This.Cmensaje = "Se Genero el Documento " + Alltrim(cdf)
	Return 1
	Endfunc
	Function consultamvtosresumidosxsysg(dfi, dff, dfii, df2, Ccursor)
	fi = cfechas(dfi)
	ff = cfechas(dff)
	fii = cfechas(dfii)
	f2 = cfechas(df2)
	TEXT To lC Noshow Textmerge
	       SELECT q.coda,b.descri,b.unid,si,compras,ventas,stock,0 As cmd  FROM (
		   SELECT x.coda,sum(si) as si,Sum(compras) As compras,Sum(ventas) As ventas,sum(si)+Sum(compras)-Sum(ventas) As stock from(
		   Select idart as coda,a.alma,cast(000000.00 as decimal(12,2)) as Si,cant As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_kar as a
		   inner join fe_rcom as b  on b.idauto=a.idauto
		   Where a.tipo='C' and a.acti='A' and b.acti='A' AND b.fech between '<<fi>>' and '<<ff>>' and b.tcom<>'T'  and tdoc<>'20'
		   Union All
		   Select idart as coda,c.alma,cast(000000.00 as decimal(12,2)) as si,cast(0000000.00 as decimal(12,2))  As compras,cant As ventas
		   From fe_kar as c
		   inner join fe_rcom as d on d.idauto=c.idauto
		   Where c.tipo='V' and c.acti='A' and d.acti='A' AND d.fech between '<<fi>>' and '<<ff>>' and d.tcom<>'T'  and tdoc<>'20'
		   union all
		   Select idart as coda,z.alma,if(tipo='C',cant,-cant) as si,cast(0000000.00 as decimal(12,2))  As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_kar as z
		   inner join fe_rcom as y  on  y.idauto=z.idauto
		   Where z.acti='A' and y.acti='A' AND y.fech='<<fii>>' AND  y.tcom<>'T'
		   union all
		   Select idart as coda,z.alma,if(tipo='C',cant,-cant) as si,cast(0000000.00 as decimal(12,2))  As compras,cast(000000.00 as decimal(12,2)) As ventas
		   From fe_kar as z
		   inner join fe_rcom as y  on  y.idauto=z.idauto
		   Where z.acti='A' and y.acti='A' AND  y.fech between '<<fii>>' and '<<f2>>' AND  y.tcom<>'T' and tdoc<>'20' )
		   as x group by x.coda) as q
		   inner join fe_art as b ON b.idart=q.coda where  si<>0 or compras<>0 or ventas<>0  order by b.descri
	ENDTEXT
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function permanentevalorizadoxsysg(dfi, dff)
	Na = Alltrim(Str(Year(dff)))
	dfi1 = Ctod("01/01/" + Alltrim(Na))
	todos = 0
	Create Cursor k(fech D, Tdoc c(2), Serie c(4), Ndoc c(8), ct c(1), Razo c(80)Null, ingr N(10, 2), prei N(10, 2), ;
		impi N(10, 2), egre N(10, 2), pree N(10, 2), impe N(10, 2), stock N(10, 2), cost N(10, 2), saldo N(10, 2), ;
		Desc c(100), Unid c(10), coda N(8), fechaUltimaCompra D, preciosingiv N(10, 2), codigoFabrica c(50), marca c(50), ;
		linea c(50), grupo c(50), Idauto N(12) Default 0, Importe N(12, 2), Cestado c(1) Default 'C', Nreg N(12), si N(12, 2), ;
		codigoestab c(4), tipoope c(2))
	Select coda, Descri As Desc, Unid  From lx Into Cursor xc Order By Descri
	ff = cfechas(dff)
	TEXT To lC Noshow Textmerge
			select b.fech,b.ndoc,b.tdoc,a.tipo,a.cant,
			ROUND(a.prec,2) as prec,b.mone,b.idcliente,
			c.razo as cliente,b.idprov,e.razo as proveedor,
			b.dolar as dola,b.vigv as igv,b.idauto,a.idkar,a.idart,s.codigoestab
			from fe_kar as a
			inner join fe_rcom as b ON(b.idauto=a.idauto)
			left JOIN fe_prov as e ON (e.idprov=b.idprov)
			LEFT JOIN fe_clie as c  ON (c.idclie=b.idcliente)
			inner join fe_sucu as s on s.idalma=a.alma
			WHERE b.fech<='<<ff>>' and a.acti='A' and b.acti='A' and b.tcom<>'T' and b.tdoc<>'20'
			OrDER BY b.fech,a.tipo,b.tdoc,b.ndoc
	ENDTEXT
	If This.EjecutaConsulta(lC, 'kkxx') < 1 Then
		Return 0
	Endif
	Select xc
	Go Top
	Do While !Eof()
		ccoda = xc.coda
		cdesc = xc.Desc
		cUnid = xc.Unid
		nidart = xc.coda
		dfechaUltimaCompra = Date()
		npreciosingiv = 0
		ccodigoFabrica = ""
		cmarca = ""
		clinea = ""
		cgrupo = ""
		Select * From kkxx Where idart = ccoda Into Cursor Kardex
		x = 0
		Sw = "N"
		Store 0 To calma, x, Crazon, ing, egr, costo, toti, sa_to
		calma = 0
		Sele Kardex
		Scan All
			If Kardex.fech < dfi Then
				If Tipo = "C" Then
					cmone = Kardex.Mone
					ndolar = Kardex.dola
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
						If Kardex.cant <> 0 Then
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
					xhaber = Round(costo * Kardex.cant, 2)
					If calma = 0 Then
						sa_to = 0
					Else
						sa_to = sa_to - xhaber
					Endif
				Endif
			Else
				If x = 0
					saldoi = calma
					Insert Into k(fech, Razo, stock, cost, saldo, coda, Desc, Unid, coda, fechaUltimaCompra, preciosingiv, codigoFabrica, marca, linea, grupo, si, codigoestab, tipoope);
						Values(Kardex.fech, "Stock Inicial", calma, costo, Round(calma * costo, 2), ccoda, cdesc, cUnid, nidart, dfechaUltimaCompra, npreciosingiv, ;
						ccodigoFabrica, cmarca, clinea, cgrupo, Round(calma * costo, 2), Kardex.codigoestab, '16')
					sa_to = Round(calma * costo, 2)
					ing = 0
					egr = 0
					xtdebe = 0
					xthaber = 0
				Endif
				Sw = "S"
				x = x + 1
				If Tipo = "C" Then
					cTdoc = Kardex.Tdoc
					cmone = Kardex.Mone
					cndoc = Kardex.Ndoc
					ndolar = Kardex.dola
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
					calma = calma + Kardex.cant
					If calma < 0 Then
						If Kardex.cant <> 0 Then
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
					Crazon = Iif(Isnull(Kardex.proveedor), "                                             ", Kardex.proveedor)
					Insert Into k(fech, Tdoc, Serie, Ndoc, ct, Razo, ingr, prei, impi, stock, cost, saldo, coda, Desc, Unid, Idauto, Nreg, coda, fechaUltimaCompra, preciosingiv, codigoFabrica, marca, linea, grupo, codigoestab, tipoope);
						Values(Kardex.fech, cTdoc, Left(cndoc, 4), Substr(cndoc, 5), "I", Crazon, Kardex.cant, ;
						xprec, xdebe, calma, costo, sa_to, ccoda, cdesc, cUnid, Kardex.Idauto, Kardex.idkar, Kardex.idart, dfechaUltimaCompra, npreciosingiv, ;
						ccodigoFabrica, cmarca, clinea, cgrupo, Kardex.codigoestab, '02')
				Else
					egr = egr + cant
					calma = calma - Kardex.cant
					xhaber = Round(costo * Kardex.cant, 2)
					xthaber = xthaber + xhaber
					If calma = 0 Then
						sa_to = 0
					Else
						sa_to = sa_to - xhaber
					Endif
					Crazon = Iif(Isnull(Kardex.cliente), "                                             ", Kardex.cliente)
					Insert Into k(fech, Tdoc, Serie, Ndoc, ct, Razo, egre, pree, impe, stock, cost, saldo, coda, Desc, Unid, coda, fechaUltimaCompra, preciosingiv, codigoFabrica, marca, linea, grupo, codigoestab, tipoope);
						Values(Kardex.fech, Kardex.Tdoc, Left(Kardex.Ndoc, 4), Substr(Kardex.Ndoc, 5), "S", Crazon, Kardex.cant, ;
						costo, xhaber, calma, costo, sa_to, ccoda, cdesc, cUnid, Kardex.idart, dfechaUltimaCompra, npreciosingiv, ;
						ccodigoFabrica, cmarca, clinea, cgrupo, Kardex.codigoestab, '01')
				Endif
			Endif
		Endscan
		If Sw = "N"
			Insert Into k(Razo, Desc, Unid, stock, cost, saldo, coda, Importe, coda)Values("SIN MOVIMIENTOS ", cdesc, cUnid, calma, Iif(calma = 0, 0, costo), sa_to, ccoda, sa_to, nidart)
		Else
			Insert Into k(Razo, ingr, impi, egre, impe, Desc, Unid, coda, Importe, Cestado, coda, fechaUltimaCompra, preciosingiv, codigoFabrica, marca, linea, grupo) Values;
				("TOTALES ->:", ing, xtdebe, egr, xthaber, cdesc, cUnid, ccoda, sa_to, 'T', nidart, dfechaUltimaCompra, npreciosingiv, ;
				ccodigoFabrica, cmarca, clinea, cgrupo)
		Endif
		Select xc
		Skip
	Enddo
	Return 1
	Endfunc
	Function kardexindividualxsys3(Ccursor)
	If This.nidart < 1 Then
		This.Cmensaje = 'Seleccione un Producto'
		Return 0
	Endif
	dfechai = This.dfi
	dfechaf = This.dff
	ccoda = This.nidart
	F = cfechas(This.Fecha)
	Create Cursor (Ccursor)(Fecha D, Tdoc c(2), dcto c(12), Razo c(40), ingr N(12, 2), ;
		egre N(12, 2), saldo N(12, 2), Fechavto D, lote c(30), Moneda c(12), Precio N(10, 2), Refe c(10)Null, usua c(10)Null, ;
		FUsua Datetime Null, usua1 c(10)Null, tipomvto c(20), cant1 N(12, 2), unidad c(20))
	TEXT To ejecuta Noshow Textmerge
	   select d.ndo2,d.fech,d.ndoc,d.tdoc,a.tipo,d.mone as cmoneda,a.cant*a.kar_equi as cant,d.fusua,ifnull(g.nomb,'') as usua1,
	   a.prec,d.vigv as igv,d.dolar,f.nomb as usua,d.idcliente as codc,b.razo AS cliente,d.idprov as codp,c.razo AS proveedor,d.deta,a.kar_equi,a.kar_unid,
	   a.cant as Cantidad,a.kar_alma1,a.kar_fvto,a.kar_lote
	   FROM fe_kar as a
	   inner JOIN fe_rcom as d on (d.idauto=a.idauto)
	   left join fe_prov as c ON(d.idprov=c.idprov)
	   left JOIN fe_clie as b ON(d.idcliente=b.idclie)
	   inner join fe_usua as f ON(f.idusua=d.idusua)
	   left join fe_usua as g    ON (g.idusua=d.idusua1)
	   WHERE a.idart=<<this.nidart>> and a.alma=<<this.codtienda>> and d.acti<>'I' and d.fech<='<<f>>' and a.acti<>'I' ORDER BY d.fech,d.tipom,a.idkar
	ENDTEXT
	If This.EjecutaConsulta(ejecuta, 'kardex') < 1
		Return 0
	Endif
	Sw = "N"
	cm = ""
	Store 0 To calma, x, Crazon, ing, egr, Nprecio
	Select Kardex
	Scan All
		If Kardex.fech < dfechai
			If Tipo = "C"
				calma = calma + cant
			Else
				calma = calma - cant
			Endif
		Else
			If x = 0
				Insert Into tmpk(Fecha, Razo, saldo)Values(Kardex.fech, "Stock Inicial", calma)
			Endif
			x = x + 1
			Nprecio = Iif(Kardex.Tipo = "C", Kardex.Prec * Kardex.igv, Kardex.Prec)
			If Tipo = "C"
				calma = calma + cant
				ing = ing + cant
				If Isnull(Kardex.proveedor)
					Crazon = 'Ingresa Desde ' + Iif(Kardex.kar_alma1 > 0, RetornaNAlmacen(Kardex.kar_alma1), "")
				Else
					Crazon = Kardex.proveedor
				Endif
				Do Case
				Case Kardex.Tdoc = "01" Or Kardex.Tdoc = "09"
					cm = "Compras"
				Case Kardex.Tdoc = "II"
					cm = "Inventario"
				Case Kardex.Tdoc = "TT"
					cm = "Traspasos"
				Case Kardex.Tdoc = "99"
					cm = "Reposiciones"
				Endcase
				Insert Into tmpk(Fecha, Tdoc, dcto, Razo, ingr, saldo, Moneda, Precio, usua, FUsua, usua1, tipomvto, cant1, unidad, Fechavto, lote);
					Values(Kardex.fech, Kardex.Tdoc, Kardex.Ndoc, Crazon, Kardex.cant, calma, ;
					Iif(Kardex.Cmoneda = 'S', 'Soles', 'Dólares'), Nprecio, Kardex.usua, Kardex.FUsua, Kardex.usua1, cm, Kardex.Cantidad, Kardex.kar_unid, Kardex.kar_fvto, Kardex.kar_lote)
			Else
				calma = calma - cant
				egr = egr + cant
				If Isnull(Kardex.cliente)
					Crazon = 'Salida A ' + Iif(Val(Kardex.Ndo2) > 0, RetornaNAlmacen(Kardex.Ndo2), "")
				Else
					Crazon = Kardex.cliente
				Endif
				Do Case
				Case Kardex.Tdoc = "01" Or Kardex.Tdoc = "03" Or Kardex.Tdoc = "20"
					cm = "Ventas"
				Case Kardex.Tdoc = "TT"
					cm = "Traspasos"
				Case Kardex.Tdoc = "99"
					cm = "Reposiciones"
				Endcase

				Insert Into tmpk(Fecha, Tdoc, dcto, Razo, egre, saldo, Moneda, Precio, usua, FUsua, Refe, usua1, tipomvto, cant1, unidad, Fechavto, lote);
					Values(Kardex.fech, Kardex.Tdoc, Kardex.Ndoc, Crazon, Kardex.cant, calma, Iif(Kardex.Cmoneda = 'S', 'Soles', 'Dólares'), Nprecio, ;
					Kardex.usua, Kardex.FUsua, "", Kardex.usua1, cm, Kardex.Cantidad, Kardex.kar_unid, Kardex.kar_fvto, Kardex.kar_lote)
			Endif
		Endif
	Endscan
	Insert Into tmpk(Razo, ingr, egre)Values("TOTALES ->:", ing, egr)
	Return 1
	Endfunc
	Function calcularinventariocontable(Ccursor)
	dFecha = cfechas(This.Fecha)
	TEXT To lC Noshow Textmerge
	  select a.idart,c.descri,c.unid,cant,a.prec as  precio,
	  tipo,d.dolar as dola,d.idauto,d.mone
	  from fe_kar as a
	  inner join fe_art as c on(c.idart=a.idart)
	  inner join fe_rcom as d ON(d.idauto=a.idauto)
	  where  fech<='<<dfecha>>' and a.acti<>'I' and d.acti<>'I'  and d.tcom<>'T' and tdoc not in('GI','20') order by a.idart,fech,a.tipo,d.tdoc,d.ndoc
	ENDTEXT
	If This.EjecutaConsulta(lC, "inve") < 1 Then
		Return 0
	Endif
	Select idart, Descri, Unid, 0000000.00 As alma, 0000000.0000 As costo, 00000000.00 As Importe From inve Where idart = -1 Into Cursor inventario Readwrite
	Select idart, Descri, Unid, cant, Iif(Mone = 'S', Precio, Precio * dola) As Precio, Tipo, dola, ;
		Idauto, Mone From inve Into Cursor inve
	Select inve
	Do While !Eof()
		Store 0 To sa_to, cost, nsaldo, saldo, toti, xdebe
		xcoda = inve.idart
		cdescri = inve.Descri
		cUnid = inve.Unid
		Store 0 To xcant, xprec, cost
		Do While !Eof() And inve.idart = xcoda
			If inve.Tipo = "V"
				saldo = saldo - cant
				sa_to = sa_to - (cost * cant)
			Else
				xprec = Precio
				If xprec = 0  Then
					xprec = cost
				Endif
				toti = toti + (Iif(inve.cant = 0, 1, inve.cant) * xprec)
				xdebe = Round(Iif(inve.cant = 0, 1, inve.cant) * xprec, 2)
				saldo = saldo + cant
				If saldo < 0 Then
					If inve.cant <> 0 Then
						sa_to = Round(saldo * xprec, 2)
					Else
						sa_to = sa_to + xdebe
					Endif
				Else
					If sa_to < 0 Then
						sa_to = Round(saldo * xprec, 2)
					Else
						If sa_to = 0 Then
							sa_to = Round(saldo * xprec, 2)
						Else
							sa_to = Round(sa_to + xdebe, 2)
						Endif
					Endif
				Endif
				If toti <> 0 Then
					cost = Iif(saldo <> 0, Round(sa_to / saldo, 4), xprec)
				Endif
				If cost = 0 Then
					cost = xprec
				Endif
			Endif
			Select inve
			Skip
		Enddo
		If saldo <> 0 Then
			Insert Into inventario(idart, Descri, Unid, alma, costo)Values(xcoda, cdescri, cUnid, saldo, cost)
		Endif
		Select inve
	Enddo
	Return 1
	Endfunc
	Function quitarnegativos()
	dfo = Datetime()
	Df = This.Fecha
	cndoc = 'Ajuste'
	Select * From inventario Where alma <= -1 Into Cursor xinv
	If This.IniciaTransaccion() < 1 Then
		Return 0
	Endif
	TEXT To lC Noshow
	   INSERT INTO fe_rcom(tdoc,form,ndoc,fech,fecr,deta,valor,igv,impo,ndo2,mone,dolar,vigv,tcom,idprov,tipom,fusua,idusua,codt)
	   VALUES ('AJ','E',?cndoc,?df,?df,'',0,0,0,'','S',3.85,1.18,'1',0,'1',?dfo,3,1);
	ENDTEXT
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	TEXT To lC Noshow
      SELECT LAST_INSERT_ID() as u FROM fe_rcom
	ENDTEXT
	If This.EjecutaConsulta(lC, 'ul') < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	nid = ul.u
	Sw = 1
	Select xinv
	Scan All
		nidart = xinv.coda
		ncant = (xinv.alma * (-1))
		xprec = xinv.costo
		TEXT To lC Noshow
            insert into fe_kar(idart,tipo,cant,prec,idauto)values(?nidart,'C',?ncant,?xprec,?nid)
		ENDTEXT
		If This.Ejecutarsql(lC) < 1
			Sw = 0
			Exit
		Endif
	Endscan
	If Sw = 0 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function mostrardiferenciasinventarios(Ccursor)
	TEXT To lC Noshow Textmerge Pretext 7
      SELECT idart,descri,unid,uno+dos+tre+cua as stocki,prod_stoc,if((uno+dos+tre)>0,if((uno+dos+tre+cua)-prod_stoc>0,(uno+dos+tre+cua)+prod_stoc,0),(uno+dos+tre+cua)) as difei,
      if(prod_stoc>0,if((prod_stoc-(uno+dos+tre+cua))>0,prod_stoc-(uno+dos+tre+cua),0),prod_stoc) as difec,
      ifnull(round(if(tmon='S',((a.prec*t.igv)+b.prec)*1.05,((a.prec*t.igv*if(prod_dola>0,prod_dola,t.dola))+b.prec)*1.05),2),0) as pre1,
      prod_come,prod_comc,
      ifnull(round(if(tmon='S',((a.prec*t.igv)+b.prec),((a.prec*t.igv*if(prod_dola>0,prod_dola,t.dola))+b.prec)),2),0) as Costoreferencial
      from fe_art as a
      inner join fe_fletes as b on b.idflete=a.idflete, fe_gene as t order by descri
	ENDTEXT
	If  This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine






































