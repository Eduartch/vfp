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
*!*		dct[4,1]='OTROS'
*!*		dct[4,2]='25'
*!*		dct[4,3]=3
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
	IF this.idsesion>0 then
	   SET DATASESSION TO this.idsesion
	ENDIF    
	lc="PROMUESTRADCTOS"
	TEXT to lp NOSHOW TEXTMERGE 
     ('<<cb>>')
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
