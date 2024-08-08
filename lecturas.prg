Define Class lecturas As Odata Of 'd:\capass\database\data.prg'
	nturno=0
	nisla=0
	motivocierre=""
	nidlectura=0
	Function ConsultarLecturas(Calias)
	df = cfechas(fe_gene.fech - 2)
	Do Case
	Case goApp.Isla = 1
		TEXT To lc Noshow Textmerge
			SELECT gradename AS descri,amount AS monto,price AS precio,volume AS cantidad,
			nozzle AS manguera,pump AS lado,estado,TotalVolume AS totalcantidad,
			totalamount AS totalmonto,idjournal as nId_Journal,fecreg_inicio,a.idart,a.unid
			FROM venta  AS v
            INNER JOIN fe_art AS a ON a.`prod_idar`=v.`idgrade`
            WHERE estado=1 AND fecreg_inicio >='<<df>>' AND pump IN('1','2') ORDER BY fecreg_inicio DESC,nozzle ASC,pump ASC
		ENDTEXT
	Case goApp.Isla = 2
		TEXT To lc Noshow Textmerge
		    SELECT gradename AS descri,amount AS monto,price AS precio,volume AS cantidad,
			nozzle AS manguera,pump AS lado,estado,TotalVolume AS totalcantidad,
			totalamount AS totalmonto,idjournal as nId_Journal,fecreg_inicio,a.idart,a.unid
			FROM venta AS v
            INNER JOIN fe_art AS a ON a.`prod_idar`=v.`idgrade`
            WHERE estado=1 AND fecreg_inicio >='<<df>>' AND pump IN('3','4') ORDER BY fecreg_inicio DESC,nozzle ASC,pump ASC
		ENDTEXT
	Case goApp.Isla = 3
		TEXT To lc Noshow Textmerge
		    SELECT gradename AS descri,amount AS monto,price AS precio,volume AS cantidad,
			nozzle AS manguera,pump AS lado,estado,TotalVolume AS totalcantidad,
			totalamount AS totalmonto,idjournal as nId_Journal,fecreg_inicio,a.idart,a.unid
			FROM venta AS v
            INNER JOIN fe_art AS a ON a.`prod_idar`=v.`idgrade`
            WHERE estado=1 AND fecreg_inicio >='<<df>>' AND pump IN('5','6','7','8') ORDER BY fecreg_inicio DESC,nozzle ASC,pump ASC
		ENDTEXT
	Endcase
	This.conconexion = 1
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc

	Function IngresalecturasContometros20(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10)
	Local cur As String
	lc = 'PROINGRESALECTURA'
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
	TEXT To lp Noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10)
	ENDTEXT
	If This.EJECUTARP(lc, lp, "") < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registralecturas(Calias)
	nsgtelectura=goApp.idlecturas+1
	Do Case
	Case goApp.Isla=1
		TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene  SET idle1=nsgtelectura
		ENDTEXT
	Case goApp.Isla=2
		TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene  SET idle2=nsgtelectura
		ENDTEXT
	Case goApp.Isla=3
		TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene   SET idle3=nsgtelectura
		ENDTEXT
	Case goApp.Isla=4
		TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene SET idle4=nsgtelectura
		ENDTEXT
	Endcase
	q=1
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.contransaccion='S'
	Select listaci
	Scan All
		If This.IngresalecturasContometros20(listaci.surtidor,goApp.idturno,listaci.lectura,listaci.monto,fe_gene.fech,goApp.nidusua,listaci.codigo,listaci.lado,listaci.precio,nsgtelectura)<1 Then
			q=0
			Exit
		Endif
	Endscan
	If q=1 Then
		If This.GrabarCambios()<1 Then
			Return 0
		Endif
		Return 1
	Else
		This.DeshacerCambios()
		Return 0
	Endif
	Endfunc
	Function consultarxislaturno(Calias, nisla, nturno)
	Do Case
	Case nisla = 1
		TEXT To lc Noshow Textmerge
	     SELECT CAST(LEFT(idgrade,5) AS VARCHAR) AS idgrade,CAST(LEFT(gradename,20) AS VARCHAR)AS producto,estado FROM venta WHERE pump=1 AND idgrade=1 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1
		ENDTEXT
	Case nisla = 2
		TEXT To lc Noshow Textmerge
		   (SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
			fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,2 as codigo FROM venta WHERE pump=3 AND idgrade=1 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
			UNION
			(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
			fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,2 as codigo FROM venta WHERE pump=4 AND idgrade=1  AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
			UNION
			(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
			fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,5 as codigo  FROM venta WHERE pump=3 AND idgrade=2 AND nozzle=2 ORDER BY fecreg_inicio DESC LIMIT 1)
			UNION
			(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
			fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,5 as codigo FROM venta WHERE pump=4 AND idgrade=2  AND nozzle=2 ORDER BY fecreg_inicio DESC LIMIT 1)
			UNION
			(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
			fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,1 as codigo  FROM venta WHERE pump=3 AND idgrade=4 AND nozzle=3 ORDER BY fecreg_inicio DESC LIMIT 1)
			UNION
			(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
			fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,1 as codigo FROM venta WHERE pump=4 AND idgrade=4  AND nozzle=3 ORDER BY fecreg_inicio DESC LIMIT 1)
		ENDTEXT
	Case nisla = 3
		TEXT To lc Noshow Textmerge
		 (SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		 fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,3 as codigo  FROM venta WHERE pump=5 AND idgrade=5 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		 UNION
		 (SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		 fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,3 As codigo  FROM venta WHERE pump=6 AND idgrade=5 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		ENDTEXT
	Endcase
	lc = 'ProListarlecturasrealesxisla'
	goApp.npara1=nisla
	TEXT To lp Noshow
	     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP10(lc, lp,Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultarLecturasxfechas(dfi,dff,nisla,Calias)
	If (dff-dfi)>31 Then
		This.cmensaje='Máximo a consultar es 30 Días'
		Return 0
	Endif
	fi=cfechas(dfi)
	ff=cfechas(dff)
	Do Case
	Case nisla = 1
		TEXT To lc Noshow Textmerge
		    SELECT gradename AS producto,amount AS monto,price AS precio,volume AS cantidad,
			nozzle AS manguera,pump AS lado,estado,TotalVolume AS totalcantidad,
			totalamount AS totalmonto,fecreg_inicio,dcto,cliente,impo as importe,idjournal AS nId_Journal
			FROM venta  AS v
            LEFT JOIN  (SELECT fe_rcom.idauto,kar_idco,ndoc AS dcto,razo AS cliente,impo FROM fe_kar
            INNER JOIN fe_rcom ON fe_rcom.idauto=fe_kar.idauto
            INNER JOIN fe_clie ON fe_clie.idclie=fe_rcom.idcliente
            WHERE fe_kar.acti='A' AND fe_rcom.acti='A' AND kar_idco>0 AND fe_rcom.fech BETWEEN '<<fi>>'  AND '<<ff>>' GROUP BY idauto,kar_idco,ndoc,razo) AS k ON k.kar_idco=v.idjournal
            WHERE CAST(fecreg_inicio AS DATE)  BETWEEN '<<fi>>'  AND '<<ff>>'  AND pump IN('1','2') ORDER BY fecreg_inicio DESC,nozzle ASC,pump ASC
		ENDTEXT
	Case nisla = 2
		TEXT To lc Noshow Textmerge
		    SELECT gradename AS producto,amount AS monto,price AS precio,volume AS cantidad,
			nozzle AS manguera,pump AS lado,estado,TotalVolume AS totalcantidad,
			totalamount AS totalmonto,fecreg_inicio,dcto,cliente,impo as importe,idjournal AS nId_Journal
			FROM venta  AS v
            LEFT JOIN  (SELECT fe_rcom.idauto,kar_idco,ndoc AS dcto,razo AS cliente,impo FROM fe_kar
            INNER JOIN fe_rcom ON fe_rcom.idauto=fe_kar.idauto
            INNER JOIN fe_clie ON fe_clie.idclie=fe_rcom.idcliente
            WHERE fe_kar.acti='A' AND fe_rcom.acti='A' AND kar_idco>0 AND fe_rcom.fech BETWEEN '<<fi>>'  AND '<<ff>>' GROUP BY idauto,kar_idco,ndoc,razo) AS k ON k.kar_idco=v.idjournal
            WHERE CAST(fecreg_inicio AS DATE)  BETWEEN '<<fi>>'  AND '<<ff>>'  AND pump IN('3','4') ORDER BY fecreg_inicio DESC,nozzle ASC,pump ASC
		ENDTEXT
	Case nisla = 3
		TEXT To lc Noshow Textmerge
		    SELECT gradename AS producto,amount AS monto,price AS precio,volume AS cantidad,
			nozzle AS manguera,pump AS lado,estado,TotalVolume AS totalcantidad,
			totalamount AS totalmonto,fecreg_inicio,dcto,cliente,impo AS importe,idjournal AS nId_Journal
			FROM venta  AS v
            LEFT JOIN  (SELECT fe_rcom.idauto,kar_idco,ndoc AS dcto,razo AS cliente,impo FROM fe_kar
            INNER JOIN fe_rcom ON fe_rcom.idauto=fe_kar.idauto
            INNER JOIN fe_clie ON fe_clie.idclie=fe_rcom.idcliente
            WHERE fe_kar.acti='A' AND fe_rcom.acti='A' AND kar_idco>0 AND fe_rcom.fech BETWEEN '<<fi>>'  AND '<<ff>>' GROUP BY idauto,kar_idco,ndoc,razo) AS k ON k.kar_idco=v.idjournal
            WHERE CAST(fecreg_inicio AS DATE)  BETWEEN '<<fi>>'  AND '<<ff>>'  AND pump IN('5','6') ORDER BY fecreg_inicio DESC,nozzle ASC,pump Asc
		ENDTEXT
	Endcase
	This.conconexion = 1
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function listarlecturasincio(df,nturno,Calias)
	F=cfechas(df)
	TEXT To lc Noshow Textmerge
	SELECT lect_inic AS lectura_galon,lect_inim as montoi,descri AS producto,lect_mang AS manguera,lect_idco AS surtidor,
	lect_prec as Precio,lect_idar AS codigo,u.nomb as Cajero,lect_idtu as turno,lect_idle as Idlecturas,lect_fope as InicioTurno,
	lect_fope1 as FinTurno FROM fe_lecturas AS l
	INNER JOIN fe_art AS a ON a.idart=l.lect_idar
	inner join fe_usua as u on u.idusua=l.lect_idus
	WHERE lect_acti='A' and lect_esta='A' and lect_fech='<<f>>'
	ENDTEXT
	This.conconexion = 1
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function consultarlecturasreales(Calias)
	TEXT To lc Noshow Textmerge
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,2 As codigo  FROM venta WHERE pump=1 AND idgrade=1 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,2 as codigo FROM venta WHERE pump=2 AND idgrade=1  AND nozzle=3 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price AS precio,5 as codigo  FROM venta WHERE pump=1 AND idgrade=2 AND nozzle=2 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,5 as codigo FROM venta WHERE pump=2 AND idgrade=2  AND nozzle=2 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,1 as codigo  FROM venta WHERE pump=1 AND idgrade=4 AND nozzle=3 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,1 as codigo FROM venta WHERE pump=2 AND idgrade=4  AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		union
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,2 as codigo FROM venta WHERE pump=3 AND idgrade=1 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,2 as codigo FROM venta WHERE pump=4 AND idgrade=1  AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,5 as codigo  FROM venta WHERE pump=3 AND idgrade=2 AND nozzle=2 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,5 as codigo FROM venta WHERE pump=4 AND idgrade=2  AND nozzle=2 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,1 as codigo  FROM venta WHERE pump=3 AND idgrade=4 AND nozzle=3 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,1 as codigo FROM venta WHERE pump=4 AND idgrade=4  AND nozzle=3 ORDER BY fecreg_inicio DESC LIMIT 1)
		union
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,3 as codigo  FROM venta WHERE pump=5 AND idgrade=5 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
		UNION
		(SELECT idgrade,gradename AS producto,pump AS surtidor,nozzle AS lado,totalvolume AS lectura,totalamount AS monto,
		fecreg_inicio AS inicio,fecreg_fin AS fin,price as precio,3 As codigo  FROM venta WHERE pump=6 AND idgrade=5 AND nozzle=1 ORDER BY fecreg_inicio DESC LIMIT 1)
	ENDTEXT
*!*		This.conconexion = 1
*!*		If This.EjecutaConsulta(lc, Calias) < 1 Then
*!*			This.conconexion = 0
*!*			Return 0
*!*		Endif
*!*		This.conconexion = 0
	lc = 'ProListarlecturasreales'
	lp=""
	If This.EJECUTARP10(lc, lp,Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function cierrelecturas(nidt,df)
	xq=1
	If goApp.idturno=1 Then
		nsgte=2
	Else
		nsgte=1
	Endif
	nsgtelectura=goApp.idlecturas+1
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	Do Case
	Case goApp.Isla=1
		TEXT TO lcx NOSHOW TEXTMERGE
          UPDATE fe_gene  SET idle1=<<nsgtelectura>>
		ENDTEXT
	Case goApp.Isla=2
		TEXT TO lcx NOSHOW TEXTMERGE
          UPDATE fe_gene  SET idle2=<<nsgtelectura>>
		ENDTEXT
	Case goApp.Isla=3
		TEXT TO lcx NOSHOW TEXTMERGE
          UPDATE fe_gene   SET idle3=<<nsgtelectura>>
		ENDTEXT
	Case goApp.Isla=4
		TEXT TO lcx NOSHOW TEXTMERGE
          UPDATE fe_gene SET idle4=<<nsgtelectura>>
		ENDTEXT
	Endcase
	If  This.ejecutarsql(lcx)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select liq
	Go Top
	Scan All
		If This.IngresalecturasFinalContometros20(liq.idlecturas,liq.Final,liq.montofinal,goApp.nidusua,0)<1 Then
			xq=0
			Exit
		Endif
		Do Case
		Case liq.surtidor=1 Or  liq.surtidor=2
			nislax=1
		Case liq.surtidor=3 Or  liq.surtidor=4
			nislax=2
		Case liq.surtidor=5 Or  liq.surtidor=6 Or liq.surtidor=7 Or  liq.surtidor=8
			nislax=3
		Endcase
		Select islas
		Locate For Isla=nislax
		nidux=islas.idusua
		If  This.IngresalecturasContometros20(liq.surtidor,nsgte,liq.Final,liq.montofinal,df,nidux,liq.codigo,liq.manguera,liq.precio,nsgtelectura)<1 Then
			xq=0
			Exit
		Endif
		Select liq
	Endscan
	If xq=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.motivocierre='C' Then
		Do Case
		Case goApp.Isla=1
			TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene SET idtu1=<<nsgte>>
			ENDTEXT
		Case goApp.Isla=2
			TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene SET idtu2=<<nsgte>>
			ENDTEXT
		Case goApp.Isla=3
			TEXT TO lc NOSHOW TEXTMERGE
          UPDATE fe_gene SET idtu3=<<nsgte>>
			ENDTEXT
		Endcase
		If  This.ejecutarsql(lc)<1 Then
			This.DeshacerCambios()
			Return 0
		Endif
	Endif
	If This.GrabarCambios()=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresalecturasFinalContometros20(np1,np2,np3,np4,np5)
	lc='PROINGRESALECTURAFINAL'
	goApp.npara1=np1
	goApp.npara2=np2
	goApp.npara3=np3
	goApp.npara4=np4
	goApp.npara5=np5
	TEXT to lp noshow
	     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5)
	ENDTEXT
	If EJECUTARP(lc,lp,"")<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ConsultarCierreslecturas(dfi,dff,Calias)
	If (dff-dfi)>31 Then
		This.cmensaje='Máximo a consultar es 30 Días'
		Return 0
	Endif
	fi=cfechas(dfi)
	ff=cfechas(dff)
	TEXT To lc Noshow Textmerge
	SELECT descri AS producto,lect_cfinal as final,lect_inic AS inicial,lect_cfinal-lect_inic as cantidad,lect_prec as Precio,
	Round((lect_cFinal-lect_inic)*lect_prec,2) As Ventas,
	lect_mfinal as montofinal,lect_inim as montoinicial,lect_mfinal-lect_inim as monto,lect_mang AS manguera,lect_idco AS surtidor,
	u.nomb as Cajero,lect_fope as InicioTurno,lect_fope1 as FinTurno,lect_idtu as turno,lect_idle as Idlecturas,lect_idar AS codigo
	FROM fe_lecturas AS l
	INNER JOIN fe_art AS a ON a.idart=l.lect_idar
	inner join fe_usua as u on u.idusua=l.lect_idus
	WHERE lect_acti='A' and lect_idtu=<<this.nturno>> and lect_esta='C' and lect_fech between '<<fi>>' and '<<ff>>' order by u.nomb,descri,lect_idco
	ENDTEXT
	This.conconexion = 1
	If This.EjecutaConsulta(lc, Calias) < 1 Then
		This.conconexion = 0
		Return 0
	Endif
	This.conconexion = 0
	Return 1
	Endfunc
	Function obteneractiva(dfecha,nturno,nisla)
	df=cfechas(dfecha)
	ccursor='c_'+Sys(2015)
	Do Case
	Case nisla=1
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(1,2) GROUP BY lect_idin limit 1
		ENDTEXT
	Case nisla=2
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(3,4) GROUP BY lect_idin limit 1
		ENDTEXT
	Case nisla=3
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_esta='A' AND lect_idco IN(5,6,7,8) GROUP BY lect_idin limit 1
		ENDTEXT
	Endcase
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return -1
	Endif
	Select (ccursor)
	If idin>0 Then
		Return idin
	Else
		This.cmensaje="No hay Lecturas Registradas"
		Return 0
	Endif
	Endfunc
	Function obtenerlecturas(dfecha,nturno,nisla,ccursor)
	df=cfechas(dfecha)
	Do Case
	Case nisla=1
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(1,2) GROUP BY lect_idin
		ENDTEXT
	Case nisla=2
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(3,4) GROUP BY lect_idin
		ENDTEXT
	Case nisla=3
		TEXT TO lc NOSHOW TEXTMERGE
	    SELECT  CONCAT(CAST(lect_idtu AS CHAR),'-',CAST(lect_idin AS CHAR)) as lectura,lect_idin as idin FROM fe_lecturas WHERE lect_fech='<<df>>' AND lect_acti='A' AND lect_idco IN(5,6,7,8) GROUP BY lect_idin
		ENDTEXT
	Endcase
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Select (ccursor)
	Return 1
	Endfunc
Enddefine
