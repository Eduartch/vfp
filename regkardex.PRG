Define Class regkardex As Odata Of  'd:\capass\database\data.prg'
	nidauto = 0
	ncoda = 0
	ncant = 0
	nprec = 0
	ncomi = 0
	nidtda = 0
	nidv = 0
	ctipo = ""
	ncosto = 0
	nidcosto = 0
	ctmvto = ""
	cTdoc = ""
	cincl = ""
	Function registrakardexventas()
	lC = "proregistraKardexventas"
*!*	    nid INTEGER,cc INTEGER,ct CHAR,npr FLOAT,nct FLOAT,cincl CHAR,tmvto CHAR,ccodv INTEGER,calma INTEGER,nidcosto1 DECIMAL(12,4),vcom FLOAT,ctdoc VARCHAR(2)
	Text To lp Noshow Textmerge
    (<<this.nidauto>>,<<this.ncoda>>,'<<this.ctipo>>',<<this.nprec>>,<<this.ncant>>,'<<this.cincl>>','<<this.ctmvto>>',<<this.nidv>>,<<this.nidtda>>,<<this.ncosto>>,<<this.ncomi>>,'<<this.ctdoc>>')
	Endtext
	If This.ejecutarp(lC, lp, '') < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine