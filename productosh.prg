Define Class productosh As producto Of 'd:\capass\modelos\productos'
	Function MuestraProductosHx(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOSx1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	endif
	Return 1
	Endfunc
	Function listar(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOSx1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaritems(np1,ccursor)
	lc='PromuestraProductosY'
	goapp.npara1=np1
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP10(lc,lp,ccursor)<1
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductoskyacompra(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOSx1'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
*****************************
	Function MuestraStockCon(np1,ccur)
	lc='ProMuestraStockC'
	goapp.npara1=np1
	TEXT TO lp NOSHOW TEXTMERGE
   (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarcompleto(np1,np2,np3,ccursor)
	lc='PROMUESTRAPRODUCTOS2'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	TEXT to lp NOSHOW TEXTMERGE
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
*********************************
	Function MuestraProductosHu(np1,ccursor)
	lc='PromuestraProductosY'
	goapp.npara1=np1
	TEXT to lp NOSHOW TEXTMERGE 
     (?goapp.npara1)
	ENDTEXT
	If EJECUTARP(lc,lp,ccursor)=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine
