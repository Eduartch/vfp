Define Class cpesisven As Odata Of 'd:\capass\database\data'
	codt=0
	Function ConsultaBoletasyNotasporenviar(f1, f2)
	Local lc
	TEXT To lc Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  resu_fech between '<<f1>>' and '<<f2>>' and f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE  f.fech between '<<f1>>' and '<<f2>>' and f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
	ENDTEXT
	If This.EjecutaConsulta(lc, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarticket10(np1)

	Endfunc
	Function ConsultaBoletasyNotasporenviarsinfechas()
	Local lc
*:Global cpropiedad
	cpropiedad = "cdatos"
	If !Pemstatus(goapp, cpropiedad, 5)
		goapp.AddProperty("cdatos", "")
	Endif
	If goapp.cdatos = 'S' Then
		TEXT To lc Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  f.resu_acti='A' AND LEFT(resu_mens,1)='0' and resu_codt=<<goapp.tienda>>
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE   f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0 and f.codt=<<goapp.tienda>>
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 and f.codt=<<goapp.tienda>>) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
		ENDTEXT
	Else

		TEXT To lc Noshow Textmerge
	    SELECT resu_fech,enviados,resumen,resumen-enviados,enviados-resumen
		FROM(SELECT resu_fech,CAST(SUM(enviados) AS DECIMAL(12,2)) AS enviados,CAST(SUM(resumen) AS DECIMAL(12,2))AS resumen FROM(
		SELECT resu_fech,CASE tipo WHEN 1 THEN resu_impo ELSE 0 END AS enviados,
		CASE tipo WHEN 2 THEN resu_impo ELSE 0 END AS Resumen,resu_mens,tipo FROM (
		SELECT resu_fech,resu_impo AS resu_impo,resu_mens,1 AS Tipo FROM fe_resboletas f
		WHERE  f.resu_acti='A' AND LEFT(resu_mens,1)='0'
		UNION ALL
		SELECT fech AS resu_fech,IF(mone='S',impo,impo*dolar) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		WHERE   f.acti='A' AND tdoc='03' AND LEFT(ndoc,1)='B' AND f.idcliente>0
		UNION ALL
		SELECT f.fech AS resu_fech,IF(f.mone='S',ABS(f.impo),ABS(f.impo*f.dolar)) AS resu_impo,' ' AS resu_mens,2 AS Tipo FROM fe_rcom f
		INNER JOIN fe_ncven g ON g.ncre_idan=f.idauto
		INNER JOIN fe_rcom AS w ON w.idauto=g.ncre_idau
		WHERE f.acti='A' AND f.tdoc IN ('07','08') AND LEFT(f.ndoc,1)='F' AND w.tdoc='03' AND f.idcliente>0 ) AS x)
		AS y GROUP BY resu_fech ORDER BY resu_fech) AS zz  WHERE resumen-enviados>=1
		ENDTEXT
	Endif
	If This.EjecutaConsulta(lc, 'rbolne') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviar(ccursor)
*!*		 SELECT guia_fech AS guia_fech,guia_ndoc AS ndoc,t.razon AS transportista,guia_idgui AS idguia,guia_moti AS motivo,
*!*	           guia_tick AS ticket FROM fe_guias AS g
*!*	           INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
*!*	          WHERE  guia_acti='A' AND LEFT(guia_mens,1)<>'0' AND LEFT(guia_ndoc,1)='T' order by guia_ndoc,guia_fech
*!*

*!*	    SELECT guia_fech AS guia_fech,guia_ndoc AS ndoc,c.razo AS cliente,t.razon AS transportista,guia_idgui AS idguia,guia_moti AS motivo,
*!*	           guia_tick AS ticket FROM fe_guias AS g
*!*	           INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
*!*	           INNER JOIN fe_clie AS c ON c.idclie=g.`guia_idcl`
*!*	           WHERE  guia_acti='A' AND LEFT(guia_mens,1)<>'0' AND guia_moti='v'
*!*	           UNION ALL
	TEXT TO lc NOSHOW textmerge
	      SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick AS ticket FROM  vguiasventas
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick AS ticket FROM  vguiasdevolucion
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick AS ticket FROM  vguiasrcompras
           WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,IFNULL(t.razon,'') AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  AS ticket FROM fe_guias AS a
           LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A')AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviaralpharmaco(ccursor)
	TEXT TO lc NOSHOW textmerge
	      SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick AS ticket FROM  vguiasventas
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS guia_fech,guia_ndoc AS ndoc,c.razo AS cliente,t.razon AS transportista,guia_idgui AS idguia,guia_moti AS motivo,
           guia_tick AS ticket FROM fe_guias AS g
           INNER JOIN fe_tra AS t ON t.idtra=g.guia_idtr
           INNER JOIN fe_clie AS c ON c.idclie=g.`guia_idcl`
           WHERE  guia_acti='A' AND LEFT(guia_mens,1)<>'0' AND guia_moti='v'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick AS ticket FROM  vguiasdevolucion
           WHERE LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick AS ticket FROM  vguiasrcompras
           WHERE  LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,IFNULL(t.razon,'') AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  AS ticket FROM fe_guias AS a
           LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A')AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function consultarguiasxenviarxtienda(ccursor)
	TEXT TO lc NOSHOW textmerge
	       SELECT fech,ndoc,cliente,Transportista,idguia,motivo,ticket FROM
          (SELECT fech,ndoc,cliente,Transportista,idguia,'V' AS motivo,guia_tick as ticket FROM  vguiasventas
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T' and guia_codt=<<this.codt>>
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'D' AS motivo,guia_tick as ticket FROM  vguiasdevolucion
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'  and guia_codt=<<this.codt>>
           UNION ALL
           SELECT fech,ndoc,cliente,Transportista,idguia,'C' AS motivo,guia_tick as ticket FROM  vguiasrcompras
           WHERE LEFT(ndoc,1)<>'S' AND LEFT(guia_mens,1)<>'0' AND LEFT(ndoc,1)='T'  and guia_codt=<<this.codt>>
           UNION ALL
           SELECT guia_fech AS fech,guia_ndoc AS ndoc,g.empresa AS cliente,IFNULL(t.razon,'') AS Transportista,
           guia_idgui AS idguia,'T' AS Motivo,guia_tick  as ticket FROM fe_guias AS a
           LEFT JOIN fe_tra AS t ON t.idtra=a.guia_idtr,fe_gene  AS g
           WHERE LEFT(guia_ndoc,1)='T'  AND  LEFT(guia_mens,1)<>'0' AND guia_moti='T' AND guia_acti='A'  and guia_codt=<<this.codt>>)AS w
           GROUP BY fech,ndoc,cliente,Transportista,idguia,motivo,ticket  ORDER BY fech,ndoc
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
