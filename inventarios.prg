Define Class inventarios As Odata Of 'd:\capass\database\data.prg'
	Function saldosinicialeskardex(df,ncoda,nalma,ccursor)
	IF nalma>0 then
	TEXT TO lc NOSHOW textmerge
    SELECT k.idart,SUM(IF(tipo='C',cant,-cant)) AS inicial FROM fe_rcom AS r
	INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
	WHERE fech<'<<df>>' AND idart=<<ncoda>> AND k.alma=<<nalma>> AND r.acti='A' AND k.acti='A' GROUP BY idart
    ENDTEXT
    ELSE
    TEXT TO lc NOSHOW textmerge
    SELECT k.idart,SUM(IF(tipo='C',cant,-cant)) AS inicial FROM fe_rcom AS r
	INNER JOIN fe_kar AS k ON k.`idauto`=r.`idauto`
	WHERE fech<'<<df>>' AND idart=<<ncoda>> AND r.acti='A' AND k.acti='A' GROUP BY idart
    ENDTEXT
    ENDIF 
	IF this.ejecutaconsulta(lc,ccursor)<1 then
	   RETURN 0
	ENDIF
	RETURN 1
	Endfunc
	Function inventarioresumidoconii(dfi,dff,dfii,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function inventarioresumidoconiicontable(dfi,dff,dfii,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function KardexIndividualcontable(ncoda,fi,ff,fii,ccursor)
	If ncoda>0 Then
		TEXT TO lc NOSHOW TEXTMERGE
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
		ENDTEXT
	Else
		TEXT TO lc NOSHOW textmerge
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
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultamvtosresumidos(fi,ff,fii,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
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
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function RegistraInventarioIniciual(df,ccursor)
	sw=1
	lc='ProIngresaInventarioInicial'
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.CONTRANSACCION='S'
	Select (ccursor)
	Scan All
		goapp.npara1=inventario.coda
		goapp.npara2=inventario.alma
		goapp.npara3=inventario.costo
		goapp.npara4=df
		TEXT to lp noshow
       (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
		ENDTEXT
		If This.EJECUTARP(lc,lp)<1 Then
			sw=0
			Exit
		Endif
	Endscan
	If sw=0 Then
		If This.DeshacerCambios()>=1 Then
			This.Cmensaje="Se Deshacieron los Cambios Ok"
			Return 0
		Else
			This.Cmensaje="No Se Deshacieron los Cambios Ok"
			Return 0
		Endif
	Else
		If This.GrabarCambios()<1 Then
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function CalCularStock()
	Local cur As String
	lc='CalcularStock'
	cur=""
	lp=""
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
******************
	Function CalCularStockContable()
	Local cur As String
	lc='CalcularStock1'
	cur=""
	lp=""
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine
