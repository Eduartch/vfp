Define Class zona As Odata Of 'd:\capass\database\data.prg'
	Function mostrarzonas(np1, ccursor)
    cproc		 ='PROMUESTRAZONAS'
	goapp.npara1 =m.np1
	Text To m.lparametros Noshow
          (?goapp.npara1)
	ENDTEXT
	If  this.ejecutarp(cproc,lparametros, ccursor) < 0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
Enddefine