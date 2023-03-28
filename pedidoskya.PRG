Define Class pedidoskya As cotizacion Of 'd:\capass\modelos\cotizacion'
	Function listar(dfi,dff,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
              SELECT ndoc,fech,b.razo,mone,valor,igv,impo,idauto,tdoc,a.idcliente as cod FROM fe_rcom as a
              INNER JOIN fe_clie as b ON b.idclie=a.idcliente
              WHERE tdoc="20"  AND a.acti='A' and a.tipom='V' and a.fech between '<<dfi>>' and '<<dff>>' ORDER BY ndoc,fech
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine

