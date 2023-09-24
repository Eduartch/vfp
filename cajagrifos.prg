Define Class cajagrifos As caja  Of 'd:\capass\modelos\caja'
	nturno = 0
	nisla = 0
	nidlectura=0
	Function listarcaja(Calias)
	df = cfechas(This.dFecha)
	TEXT To lc Noshow  Textmerge
	        SELECT cajero,isla,efectivo+credito+deposito+tarjeta+dscto+centrega as Ingresos,dscto,efectivo+credito+deposito+tarjeta+centrega as ventasnetas,
	        tarjeta,credito,efectivo,centrega,egresos,efectivo-egresos as saldo,idusua from(
	        SELECT usua AS Cajero,SUM(ROUND(CASE forma WHEN 'E' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS efectivo,
			SUM(ROUND(CASE forma WHEN 'C' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS credito,
			SUM(ROUND(CASE forma WHEN 'D' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS deposito,
		    SUM(lcaj_dsct) AS dscto,
			SUM(ROUND(CASE forma WHEN 'T' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS tarjeta,
			SUM(ROUND(CASE forma WHEN 'A' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS Centrega,
			SUM(ROUND(CASE tipo WHEN 'S' THEN IF(forma='E',impo,0) ELSE 0 END,2)) AS egresos,
			lcaj_idtu,lcaj_codt as isla,lcaj_idus AS idusua
	    	FROM(
			SELECT a.lcaj_tdoc AS tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I',IF(lcaj_acre=0,'I','S')) AS tipo,lcaj_dcto AS ndoc,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS impo,
            lcaj_deta AS deta,lcaj_mone AS  mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,lcaj_dola AS dola,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 and lcaj_idtu=<<this.nturno>> and LEFT(c.tipo,1)="V"
			UNION ALL
			SELECT a.lcaj_tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I','S') AS tipo,a.lcaj_ndoc AS ndoc,IF(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) AS impo,
            a.lcaj_deta AS deta,a.lcaj_mone AS mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,a.lcaj_dola AS dola,a.lcaj_deud AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau=0 and lcaj_idtu=<<this.nturno>> and LEFT(c.tipo,1)="V")
			AS b GROUP BY lcaj_idus,lcaj_codt) as x  ORDER BY isla,cajero
	ENDTEXT
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcaja1(Calias)
	df = cfechas(This.dFecha)
	TEXT To lc Noshow Textmerge
		SELECT descri AS producto,u.nomb as Cajero,lect_idco AS surtidor,lect_mang AS manguera,lect_inic  as inicial,lect_cfinal as final,
		lect_cFinal-lect_inic As Cantidad,lect_prec as Precio,Round((lect_cFinal-lect_inic)*lect_prec,2) As Ventas,
		lect_mfinal AS montofinal,lect_inim AS montoinicial, lect_mfinal-lect_inim AS monto,
		lect_idtu as Turno,lect_fope as InicioTurno,lect_fope1 as FinTurno,lect_idar AS codigo,lect_idle as Idlecturas,lect_fech as fecha FROM fe_lecturas AS l
		INNER JOIN fe_art AS a ON a.idart=l.lect_idar
		inner join fe_usua as u on u.idusua=l.lect_idus
		WHERE lect_acti='A' and lect_idtu=<<this.nturno>> and lect_esta='C' and lect_idle=<<this.nidlectura>> order by lect_idco,lect_mang
	ENDTEXT
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcajaparacierre(Calias)
	df = cfechas(This.dFecha)
	If This.nisla = 0 Then
		TEXT To lc Noshow Textmerge
	        SELECT cajero,isla,efectivo+credito+deposito+tarjeta+dscto as Ingresos,dscto,efectivo+credito+deposito+tarjeta as ventasnetas,
	        tarjeta,credito,efectivo,egresos,efectivo-egresos as saldo,idusua from(
	        SELECT usua AS Cajero,SUM(ROUND(CASE forma WHEN 'E' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS efectivo,
			SUM(ROUND(CASE forma WHEN 'C' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS credito,
			SUM(ROUND(CASE forma WHEN 'D' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS deposito,
		    SUM(lcaj_dsct) AS dscto,
			SUM(ROUND(CASE forma WHEN 'T' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS tarjeta,
			SUM(ROUND(CASE forma WHEN 'R' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS Centrega,
			SUM(ROUND(CASE tipo WHEN 'S' THEN IF(forma='E',impo,0) ELSE 0 END,2)) AS egresos,
			lcaj_idtu,lcaj_codt as isla,lcaj_idus AS idusua
	    	FROM(
			SELECT a.lcaj_tdoc AS tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I',IF(lcaj_acre=0,'I','S')) AS tipo,lcaj_dcto AS ndoc,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS impo,
            lcaj_deta AS deta,lcaj_mone AS  mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,lcaj_dola AS dola,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 and lcaj_idtu=<<this.nturno>>  and LEFT(c.tipo,1)="V"
			UNION ALL
			SELECT a.lcaj_tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I','S') AS tipo,a.lcaj_ndoc AS ndoc,IF(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) AS impo,
            a.lcaj_deta AS deta,a.lcaj_mone AS mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,a.lcaj_dola AS dola,a.lcaj_deud AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau=0 and lcaj_idtu=<<this.nturno>> and LEFT(c.tipo,1)="V")
			AS b GROUP BY lcaj_idus,lcaj_codt) as x  ORDER BY isla,cajero
		ENDTEXT
	Else
		TEXT To lc Noshow Textmerge
	       SELECT cajero,isla,efectivo+credito+deposito+tarjeta+dscto as Ingresos,dscto,efectivo+credito+deposito+tarjeta as ventasnetas,
	       tarjeta,credito,efectivo,egresos,efectivo-egresos as saldo,idusua from(
	        SELECT usua AS Cajero,SUM(ROUND(CASE forma WHEN 'E' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS efectivo,
			SUM(ROUND(CASE forma WHEN 'C' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS credito,
			SUM(ROUND(CASE forma WHEN 'D' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS deposito,
		    SUM(lcaj_dsct) AS dscto,
			SUM(ROUND(CASE forma WHEN 'T' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS tarjeta,
			SUM(ROUND(CASE forma WHEN 'R' THEN IF(tipo='I',impo,0) ELSE 0 END,2)) AS Centrega,
			SUM(ROUND(CASE tipo WHEN 'S' THEN IF(forma='E',impo,0) ELSE 0 END,2)) AS egresos,
			lcaj_idtu,lcaj_codt as isla,lcaj_idus AS idusua
	    	FROM(
			SELECT a.lcaj_tdoc AS tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I',IF(lcaj_acre=0,'I','S')) AS tipo,lcaj_dcto AS ndoc,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS impo,
            lcaj_deta AS deta,lcaj_mone AS  mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,lcaj_dola AS dola,
			IF(lcaj_deud<>0,lcaj_deud,IF(lcaj_acre=0,lcaj_deud,lcaj_acre)) AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 and lcaj_idtu=<<this.nturno>>  and LEFT(c.tipo,1)="V" and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT a.lcaj_tdoc,a.lcaj_form AS forma,IF(lcaj_deud<>0,'I','S') AS tipo,a.lcaj_ndoc AS ndoc,IF(a.lcaj_deud<>0,lcaj_deud,lcaj_acre) AS impo,
            a.lcaj_deta AS deta,a.lcaj_mone AS mone,lcaj_idcr AS idcredito,lcaj_idde AS iddeudas,lcaj_idau AS idauto,
			c.nomb AS usua,a.lcaj_fope AS fechao,a.lcaj_mone AS tmon1,a.lcaj_dola AS dola,a.lcaj_deud AS nimpo,lcaj_idtu,lcaj_codt,lcaj_dsct,lcaj_idus FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON 	c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau=0 and lcaj_idtu=<<this.nturno>> and LEFT(c.tipo,1)="V" and lcaj_codt=<<this.nisla>>)
			AS b GROUP BY lcaj_idus,lcaj_codt) as x  ORDER BY isla,cajero
		ENDTEXT
	Endif
	This.conconexion = 1
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function resumencajasipan(Calias)
	f1=cfechas(This.dfi)
	f2=cfechas(This.dff)
*!*		TEXT TO lc NOSHOW TEXTMERGE
*!*		    SELECT "Total Ventas" as detalle, SUM(lect_mfinal-lect_inim) AS impo,'I' AS tipo,'E' AS lcaj_form,'' as isla  FROM fe_lecturas
*!*			WHERE lect_fech between '<<f1>>'  and  '<<f2>>' AND lect_acti='A' and lect_idtu=<<this.nturno>> AND lect_mfinal>0
*!*			UNION ALL
*!*			SELECT "Vtas al Crédito" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'C' as lcaj_form,'' As isla FROM
*!*			fe_lcaja AS a
*!*			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*			WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND lcaj_idtu=<<this.nturno>>
*!*			AND LEFT(c.tipo,1)="V" AND lcaj_form='C'
*!*			UNION ALL
*!*			SELECT "Vtas C/Tarjeta" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'T' as lcaj_form,'' As isla FROM
*!*			fe_lcaja AS a
*!*			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*			WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND lcaj_idtu=<<this.nturno>>
*!*			AND LEFT(c.tipo,1)="V" AND lcaj_form='T'
*!*			UNION ALL
*!*			SELECT "Vtas C/Depósito" As detalle,IFNULL(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'D' AS lcaj_form,'' As isla  FROM
*!*			fe_lcaja AS a
*!*			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*			WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND lcaj_idtu=<<this.nturno>>
*!*			AND LEFT(c.tipo,1)="V" AND lcaj_form='D'
*!*			UNION ALL
*!*			SELECT "Descuentos" as detalle,IFNULL(SUM(lcaj_dsct),0) AS impo,'E' AS tipo,'S' AS lcaj_form,'' As isla  FROM
*!*			fe_lcaja AS a
*!*			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*			WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND lcaj_idtu=<<this.nturno>>
*!*			AND LEFT(c.tipo,1)="V" AND lcaj_dsct>0
*!*			ENDTEXT

*!*	TEXT TO lc NOSHOW TEXTMERGE
*!*			    SELECT "Total Ventas" as detalle,SUM(lect_mfinal-lect_inim) AS impo,'I' AS tipo,'E' AS lcaj_form,'2' as isla  FROM fe_lecturas
*!*				WHERE lect_fech between '<<f1>>'  and  '<<f2>>' AND lect_acti='A' and lect_idtu=<<this.nturno>> and lect_idco in(3,4) AND lect_mfinal>0
*!*				UNION ALL
*!*				SELECT "Vtas al Crédito" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'C' As lcaj_form,'2' as isla FROM
*!*				fe_lcaja AS a
*!*				INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*				WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_form='C' and lcaj_codt=<<this.nisla>>
*!*				UNION ALL
*!*				SELECT "Vtas C/Tarjeta" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'T' as lcaj_form,'2' as isla FROM
*!*				fe_lcaja AS a
*!*				INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*				WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_form='T' and lcaj_codt=<<this.nisla>>
*!*				UNION ALL
*!*				SELECT "Vtas C/Depósito" As detalle,IFNULL(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'D' AS lcaj_form,'2' as isla FROM
*!*				fe_lcaja AS a
*!*				INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*				WHERE lcaj_fech between '<<f1>>'  and  '<<f2>>' AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_form='D' and lcaj_codt=<<this.nisla>>
*!*				UNION ALL
*!*				SELECT "Descuentos" as detalle,IFNULL(SUM(lcaj_dsct),0) AS impo,'E' AS tipo,'S' AS lcaj_form,'2' as isla FROM
*!*				fe_lcaja AS a
*!*				INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
*!*				WHERE  lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_dsct>0 AND lcaj_codt=<<this.nisla>>
*!*				ENDTEXT


	If This.nisla = 0 Then
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT "Total Ventas" as detalle, SUM(lect_mfinal-lect_inim) AS impo,'I' AS tipo,'E' AS lcaj_form,'' as isla  FROM fe_lecturas
		WHERE lect_idin=<<this.nidlectura>>  and   lect_acti='A' and lect_mfinal>0
		UNION ALL
		SELECT "Vtas al Crédito" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'C' as lcaj_form,'' As isla FROM
		fe_lcaja AS a
		INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
		WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0  AND LEFT(c.tipo,1)="V" AND lcaj_form='C'
		UNION ALL
		SELECT "Vtas C/Tarjeta" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'T' as lcaj_form,'' As isla FROM
		fe_lcaja AS a
		INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
		WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_form='T'
		UNION ALL
		SELECT "Vtas C/Depósito" As detalle,IFNULL(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'D' AS lcaj_form,'' As isla  FROM
		fe_lcaja AS a
		INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
		WHERE  lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND  LEFT(c.tipo,1)="V" AND lcaj_form='D'
		UNION ALL
		SELECT "Descuentos" as detalle,IFNULL(SUM(lcaj_dsct),0) AS impo,'E' AS tipo,'S' AS lcaj_form,'' As isla  FROM
		fe_lcaja AS a
		INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
		WHERE  lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_dsct>0
		ENDTEXT
	Else
		Do Case
		Case This.nisla=1
			TEXT TO lc NOSHOW TEXTMERGE
		    SELECT "Total Ventas" as detalle,SUM(lect_mfinal-lect_inim) AS impo,'I' AS tipo,'E' AS lcaj_form,'1' as isla  FROM fe_lecturas
			WHERE lect_idin=<<this.nidlectura>>  and   lect_acti='A' and lect_mfinal>0 and lect_idco in(1,2) AND lect_mfinal>0
			UNION ALL
			SELECT "Vtas al Crédito" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'C' as lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0  AND LEFT(c.tipo,1)="V" and lcaj_form='C' and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Vtas C/Tarjeta" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'T' as lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND  lcaj_form='T' and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Vtas C/Depósito" As detalle, IFNULL(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'D' AS lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE  lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_form='D' And  lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Descuentos" as detalle,IFNULL(SUM(lcaj_dsct),0) AS impo,'E' AS tipo,'S' AS lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_dsct>0 and lcaj_codt=<<this.nisla>>
			ENDTEXT
		Case This.nisla=2
			TEXT TO lc NOSHOW TEXTMERGE
		    SELECT "Total Ventas" as detalle,SUM(lect_mfinal-lect_inim) AS impo,'I' AS tipo,'E' AS lcaj_form,'1' as isla  FROM fe_lecturas
			WHERE lect_idin=<<this.nidlectura>>  and   lect_acti='A' and lect_mfinal>0 and lect_idco in(3,4) AND lect_mfinal>0
			UNION ALL
			SELECT "Vtas al Crédito" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'C' as lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0  AND LEFT(c.tipo,1)="V"  and lcaj_form='C' and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Vtas C/Tarjeta" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'T' as lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V"  and lcaj_form='T' and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Vtas C/Depósito" As detalle, IFNULL(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'D' AS lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE  lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0  and LEFT(c.tipo,1)="V" AND lcaj_form='D' And  lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Descuentos" as detalle,IFNULL(SUM(lcaj_dsct),0) AS impo,'E' AS tipo,'S' AS lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_dsct>0 and lcaj_codt=<<this.nisla>>
			ENDTEXT
		Case This.nisla=3
			TEXT TO lc NOSHOW TEXTMERGE
		    SELECT "Total Ventas" as detalle,SUM(lect_mfinal-lect_inim) AS impo,'I' AS tipo,'E' AS lcaj_form,'1' as isla  FROM fe_lecturas
			WHERE lect_idin=<<this.nidlectura>>  and   lect_acti='A' and lect_mfinal>0 and lect_idco in(5,6,7,8) AND lect_mfinal>0
			UNION ALL
			SELECT "Vtas al Crédito" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'C' as lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0  AND LEFT(c.tipo,1)="V" and lcaj_form='C' and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Vtas C/Tarjeta" as detalle,ifnull(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'T' as lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>>  AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" and lcaj_form='T' and lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Vtas C/Depósito" As detalle, IFNULL(SUM(lcaj_deud),0) AS impo,'E' AS tipo,'D' AS lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE  lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0  and LEFT(c.tipo,1)="V" AND lcaj_form='D' And  lcaj_codt=<<this.nisla>>
			UNION ALL
			SELECT "Descuentos" as detalle,IFNULL(SUM(lcaj_dsct),0) AS impo,'E' AS tipo,'S' AS lcaj_form,'1' as isla FROM
			fe_lcaja AS a
			INNER JOIN fe_usua AS c ON c.idusua=a.lcaj_idus
			WHERE lcaj_idle=<<this.nidlectura>> AND lcaj_acti<>'I' AND lcaj_idau>0 AND LEFT(c.tipo,1)="V" AND lcaj_dsct>0 and lcaj_codt=<<this.nisla>>
			ENDTEXT
		Case This.nisla=4
		Endcase
	Endif
	This.conconexion = 1
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function listatarjetas(nidus,Calias)
	fi=cfechas(This.dfi)
	ff=cfechas(This.dff)
	If nidus=0 Then
		If This.nisla=0 Then
			TEXT TO lc TEXTMERGE NOSHOW
			 select lcaj_dcto AS dcto,lcaj_deud AS Importe,lcaj_btar AS banco,lcaj_ttar AS tipo,lcaj_rtar AS referencia,lcaj_deta as Detalle,u.nomb AS Cajero,
			 lcaj_fope
			 FROM fe_lcaja AS l INNER JOIN fe_usua AS u ON u.idusua=lcaj_idus
			 WHERE lcaj_fech between '<<fi>>' and '<<ff>>'
			 AND lcaj_form='T' AND lcaj_acti='A' AND lcaj_idau>0 ORDER BY u.nomb,lcaj_dcto
			ENDTEXT
		Else
			TEXT TO lc TEXTMERGE NOSHOW
			 select lcaj_dcto AS dcto,lcaj_deud AS Importe,lcaj_btar AS banco,lcaj_ttar AS tipo,lcaj_rtar AS referencia,lcaj_deta as Detalle,u.nomb AS Cajero,
			 lcaj_fope
			 FROM fe_lcaja AS l INNER JOIN fe_usua AS u ON u.idusua=lcaj_idus
			 WHERE lcaj_fech between '<<fi>>' and '<<ff>>'
			 AND lcaj_form='T' AND lcaj_acti='A' AND lcaj_idau>0 and lcaj_codt=<<this.nisla>>  ORDER BY u.nomb,lcaj_dcto
			ENDTEXT
		Endif
	Else
		If This.nisla=0 Then
			TEXT TO lc TEXTMERGE NOSHOW
			 select lcaj_dcto AS dcto,lcaj_deud AS Importe,lcaj_btar AS banco,lcaj_ttar AS tipo,lcaj_rtar AS referencia,lcaj_deta as Detalle,u.nomb AS Cajero,
			 lcaj_fope
			 FROM fe_lcaja AS l INNER JOIN fe_usua AS u ON u.idusua=lcaj_idus
			 WHERE lcaj_fech between '<<fi>>' and '<<ff>>' and lcaj_idus=<<nidus>>
			 AND lcaj_form='T' AND lcaj_acti='A' AND lcaj_idau>0 ORDER BY u.nomb,lcaj_dcto
			ENDTEXT
		Else
			TEXT TO lc TEXTMERGE NOSHOW
			 select lcaj_dcto AS dcto,lcaj_deud AS Importe,lcaj_btar AS banco,lcaj_ttar AS tipo,lcaj_rtar AS referencia,lcaj_deta as Detalle,u.nomb AS Cajero,
			 lcaj_fope
			 FROM fe_lcaja AS l INNER JOIN fe_usua AS u ON u.idusua=lcaj_idus
			 WHERE lcaj_fech between '<<fi>>' and '<<ff>>' and lcaj_idus=<<nidus>>
			 AND lcaj_form='T' AND lcaj_acti='A' AND lcaj_idau>0  and lcaj_codt=<<this.nisla>> ORDER BY u.nomb,lcaj_dcto
			ENDTEXT
		Endif
	Endif
	If This.EjecutaConsulta(lc,Calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

