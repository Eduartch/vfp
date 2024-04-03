Define Class appsysven As Odata Of 'd:\capass\database\data.prg'
	Function dATOSGLOBALES(Ccursor)
	Text To lC Noshow
      SELECT * FROM fe_gene WHERE idgene=1 limit 1
	Endtext
	If This.EjecutaConsulta( lC, (Ccursor) ) < 1
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine