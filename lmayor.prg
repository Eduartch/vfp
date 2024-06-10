Define Class lmayor As Odata Of 'd:\capass\database\data.prg'
	dfi = Date()
	dff = Date()
	ncodt = 0
	dfp = Date()
	nmes = 0
	na = 0
	cmultiempresa = ''
	Function listarresumido(Ccursor)
	dfecha1 = Ctod('01/' + Trim(Str(This.nmes)) + '/' + Trim(Str(This.na)))
	F = cfechas(dfecha1)
	dfecha2 = Ctod('01/' + Trim(Str(Iif(This.nmes < 12, This.nmes + 1, 1))) + '/' + Trim(Str(Iif(This.nmes < 12, This.na, This.na + 1))))
	dfecha2 = dfecha2 - 1
	dfecha11 = dfecha1 + 1
	fi = cfechas(dfecha1)
	ff = cfechas(dfecha2)
	If This.nmes = 1 Then
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
	       \Select z.ldia_fech,z.ncta,z.nomb,If(z.debe>z.haber,z.debe-z.haber,00000000.00) As adeudor,
		   \If(z.haber>z.debe,z.haber-z.debe,000000000.00) As aacreedor,idcta,ldia_nume,estado  From
		   \(Select MAX(a.ldia_fech) as ldia_fech,b.ncta,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,b.idcta,MAX(a.ldia_nume) as ldia_nume,'I' As estado
		   \From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		   \Where a.ldia_acti='A' And ldia_fech = '<<f>>' And ldia_tran<>'T'  And ldia_inic='I'
		If This.cmultiempresa = 'S' Then
		   \And ldia_codt=<<This.ncodt>>
		Endif
		   \ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off

	Else
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
		\Select z.ldia_fech,z.ncta,z.nomb,If(z.debe>z.haber,z.debe-z.haber,00000000.00) As adeudor,
		\If(z.haber>z.debe,z.haber-z.debe,000000000.00) As aacreedor,idcta,ldia_nume,estado  From
		\	(Select MAX(a.ldia_fech) As ldia_fech,b.ncta,b.nomb,Sum(a.ldia_debe-a.ldia_itrd) As debe,Sum(a.ldia_haber-a.ldia_itrh) As haber,b.idcta,MAX(a.ldia_nume) As ldia_nume,'M' As estado
		\	From fe_ldiario As a inner Join fe_plan As b On b.idcta=a.ldia_idcta
		\	Where a.ldia_acti='A' And ldia_fech Between '<<fi>>' And '<<ff>>' And ldia_tran<>'T' And ldia_inic<>'I' 
		If This.cmultiempresa = 'S' Then
		   \And ldia_codt=<<This.ncodt>>
		Endif
		   \ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off
	Endif

	If This.EjecutaConsulta(lC, 'rlda') < 1 Then
		Return 0
	Endif
	Create Cursor (Ccursor)(ldia_fech d, ncta c(15), nomb c(60), adeudor N(12, 2), aacreedor N(12, 2), debe N(12, 2), haber N(12, 2), idcta N(10), ldia_nume c(10), estado c(1))
	Select * From rlda Where (adeudor + aacreedor) > 0 Into Cursor rlda
	Select rld
	Append From Dbf("rlda")
	If nm = 1 Then
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
		\Select z.ldia_fech, z.ncta, z.nomb, z.debe, z.haber, idcta, ldia_nume, estado  From
		\(Select MAX(a.ldia_fech) As ldia_fech, b.ncta, b.nomb, Sum(a.ldia_debe - a.ldia_itrd) As debe, Sum(a.ldia_haber - a.ldia_itrh) As haber, b.idcta, MAX(a.ldia_nume) as ldia_nume, 'M'  As estado
		\From fe_ldiario As a
		\inner Join fe_plan As b On b.idcta = a.ldia_idcta
		\Where a.ldia_acti = 'A' And ldia_fech Between '<<fi>>' And '<<ff>>' And ldia_tran <> 'T'  And ldia_inic <> 'I'
		If This.cmultiempresa = 'S' Then
		 \And ldia_codt =<< nidt >>
		Endif
		\ Group By a.ldia_idcta) As z
		Set Textmerge To
		Set Textmerge Off
	Else
		Set Textmerge On
		Set Textmerge To  Memvar lC  Noshow
		\Select  z.ldia_fech, z.ncta, z.nomb, z.debe, z.haber, idcta, ldia_nume, estado  From
		\(Select MAX(a.ldia_fech) as ldia_fech, b.ncta, b.nomb, Sum(a.ldia_debe - a.ldia_itrd) As debe, Sum(a.ldia_haber - a.ldia_itrh) As haber, b.idcta, MAX(a.ldia_nume) As ldia_nume, 'M'  As estado
		\From fe_ldiario As a
		\inner Join fe_plan As b On b.idcta = a.ldia_idcta
		\Where a.ldia_acti = 'A' And ldia_fech Between '<<fi>>' And '<<ff>>' And ldia_tran <> 'T' And ldia_inic <> 'I'
		If This.cmultiempresa = 'S' Then
		 \And ldia_codt =<< nidt >>
		Endif
		\ Group By a.ldia_idcta) As z
		SET TEXTMERGE to
		SET TEXTMERGE off
	Endif
	If This.EjecutaConsulta(lC, 'rldn') < 1 Then
		Return 0
	Endif
	Select rldn
	Do While !Eof()
		Select rld
		Locate For idcta = rldn.idcta
		If Found()
			Replace debe With rldn.debe, haber With rldn.haber, ldia_nume With rldn.ldia_nume In rld
		Else
			Insert Into rld(ldia_fech, ncta, nomb, debe, haber, idcta, ldia_nume)Values(rldn.ldia_fech, rldn.ncta, rldn.nomb, rldn.debe, rldn.haber, rldn.idcta, rldn.ldia_nume)
		Endif
		Select rldn
		Skip
	Enddo
	Return 1
	Endfunc
Enddefine


