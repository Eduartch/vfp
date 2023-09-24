Define Class dctos As Odata Of "d:\capass\database\data.prg"
	Function mostrarvtasf(ccursor)
	Dimension dct[3,3]
	dct[1,1]='FACTURA     '
	dct[1,2]='01'
	dct[1,3]=1
	dct[2,1]='BOLETA      '
	dct[2,2]='03'
	dct[2,3]=2
	dct[3,1]='NOTAS-PEDIDO'
	dct[3,2]='20'
	dct[3,3]=3
	Create Cursor (ccursor) (nomb c(10), tdoc c(2),idtdoc N(2))
	Insert Into (ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrarvtasregistro(ccursor)
	Dimension dct[4,4]
	dct[1,1]='FACTURA     '
	dct[1,2]='01'
	dct[1,3]=1
	dct[2,1]='BOLETA      '
	dct[2,2]='03'
	dct[2,3]=2
	dct[3,1]='NOTAS CREDITO'
	dct[3,2]='07'
	dct[3,3]=3
	dct[4,1]='NOTAS DEBITO'
	dct[4,2]='08'
	dct[4,3]=4
	Create Cursor (ccursor) (nomb c(10), tdoc c(2),idtdoc N(2))
	Insert Into (ccursor) From Array dct
	Return 1
	Endfunc
	Function mostrartraspasos(ccursor)
	Dimension dct[2,3]
	dct[1,1]='Guias Remision'
	dct[1,2]='09'
	dct[1,3]=1
	dct[2,1]='Traspasos     '
	dct[2,2]='TT'
	dct[2,3]=2
	Create Cursor (ccursor) (nomb c(10), tdoc c(2),idtdoc N(2))
	Insert Into (ccursor) From Array dct
	Return 1
	Endfunc
*******************************
	Function MuestraDctos(cb,ccursor)
	If This.idsesion>0 Then
		Set DataSession To This.idsesion
	Endif
	lc="PROMUESTRADCTOS"
	TEXT to lp NOSHOW TEXTMERGE
     ('<<cb>>')
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function mostrartvtas(ccursor)
	Dimension dct[5,4]
	dct[1,1]='FACTURA     '
	dct[1,2]='01'
	dct[1,3]=1
	dct[2,1]='BOLETA      '
	dct[2,2]='03'
	dct[2,3]=2
	dct[3,1]='NOTAS CREDITO'
	dct[3,2]='07'
	dct[3,3]=3
	dct[4,1]='NOTAS DEBITO'
	dct[4,2]='08'
	dct[4,3]=4
	dct[5,1]='N/VENTAS'
	dct[5,2]='20'
	dct[5,3]=5
	Create Cursor (ccursor) (nomb c(10), tdoc c(2),idtdoc N(2))
	Insert Into (ccursor) From Array dct
	Return 1
	ENDFUNC
	Function mostrarvtasf1(ccursor)
	Dimension dct[4,3]
	dct[1,1]='FACTURA     '
	dct[1,2]='01'
	dct[1,3]=1
	dct[2,1]='BOLETA      '
	dct[2,2]='03'
	dct[2,3]=2
	dct[3,1]='NOTAS-PEDIDO'
	dct[3,2]='20'
	dct[3,3]=3
	dct[4,1]='G.INTERNO'
	dct[4,2]='GI'
	dct[4,3]=4
	Create Cursor (ccursor) (nomb c(10), tdoc c(2),idtdoc N(2))
	Insert Into (ccursor) From Array dct
	Return 1
	Endfunc
Enddefine
