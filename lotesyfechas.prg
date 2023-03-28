Define Class lotesyfechas As odata Of  'd:\capass\database\data'
	Function listarxproducto(np1,ccursor)
	TEXT to lp NOSHOW TEXTMERGE
	        SELECT CAST(cant AS DECIMAL(12,2)) AS cant,fech_fvto,fech_lote,kar_idkar,a.alma FROM(
			SELECT a.alma,kar_idkar,SUM(IF((`a`.`tipo` = 'C'),(`a`.`cant` * `a`.`kar_equi`),-((`a`.`cant` * `a`.`kar_equi`)))) AS `cant` FROM
			`fe_kar` `a`
			INNER JOIN `fe_rcom` AS b ON b.idauto=a.idauto
			WHERE idart=<<np1>> AND a.acti='A' AND b.acti='A' AND a.alma=<<goapp.tienda>> GROUP BY a.alma,kar_idkar HAVING (cant>0)) AS a
			INNER JOIN fe_fechas AS t ON t.fech_idka=a.kar_idkar order by fech_fvto,fech_lote
	ENDTEXT
	If This.ejecutaconsulta(lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function quitarfechasylotes(np1)
	TEXT TO lc NOSHOW TEXTMERGE
	      UPDATE fe_kar SET kar_idkar=0 WHERE kar_idkar=<<np1>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
*!*	    SELECT CAST(SUM(IF((`a`.`tipo` = 'C'),(`a`.`cant` * `a`.`kar_equi`),-((`a`.`cant` * `a`.`kar_equi`)))) AS DECIMAL(10,2)) AS `cant`,
*!*		  `t`.`fech_fvto`,`t`.`fech_lote`,`t`.`fech_idka`,w.idprov,a.alma, idart
*!*		  FROM (((`fe_kar` `a`  JOIN `fe_rcom` `b`
*!*		       ON ((`b`.`idauto` = `a`.`idauto`)))
*!*		      JOIN `fe_fechas` `t`
*!*		      ON ((`t`.`fech_idka` = `a`.`kar_idkar`)))
*!*		      JOIN (SELECT b.`idprov`,`kar_idkar`
*!*		  FROM ((`fe_kar` `a`  JOIN `fe_rcom` `b`
*!*		      ON ((`b`.`idauto` = `a`.`idauto`)))
*!*		      JOIN `fe_prov` `x`  ON ((`x`.`idprov` = `b`.`idprov`)))
*!*		   WHERE ((`a`.`acti` = 'A')   AND (`b`.`acti` = 'A') AND idart=<<np1>> and a.alma=<<goapp.tienda>>)
*!*		   GROUP BY idprov,`a`.kar_idkar) `w`
*!*		     ON ((`w`.`kar_idkar` = `a`.`kar_idkar`)))
*!*		   WHERE ((`a`.`acti` = 'A')  AND (`b`.`acti` = 'A') AND a.idart =<<np1>>)
*!*		   GROUP BY `a`.`alma`,`a`.`idart`,`a`.`kar_idkar`,kar_fvto,kar_lote,idprov HAVING (`cant` > 0) order by fech_fvto,fech_lote
