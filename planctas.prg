Define Class planctas As Odata Of 'd:\capass\database\data.prg'
	Function MuestraPlanCuentasX(np1,cur)
	lc="PROMUESTRAPLANCUENTAS"
	goapp.npara1=np1
	goapp.npara2=Val(goapp.año)
	TEXT to lp noshow
       (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function listarctasrcompras()
	If !Pemstatus(goapp,'ctasmp',5 ) Then
		AddProperty(goapp,'ctasmp','')
	Endif
	If goapp.ctasmp='S' Then
		TEXT TO lc NOSHOW TEXTMERGE
         SELECT ncta,idctacv AS idcta  FROM fe_gene  AS g INNER JOIN fe_plan AS p ON p.idcta=g.idctacv  WHERE idgene=1
		 UNION ALL
		 SELECT ncta,gene_ctamp AS idcta FROM fe_gene AS g INNER JOIN fe_plan AS p ON p.idcta=g.gene_ctamp   WHERE idgene=1
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
         SELECT ncta,idctacv AS idcta  FROM fe_gene  AS g INNER JOIN fe_plan AS p ON p.idcta=g.idctacv  WHERE idgene=1
		ENDTEXT
	Endif
	If ejecutaconsulta(lc,'ctascompras')<1 Then
		Return  0
	Endif
	Return  1
	Endfunc
Enddefine
