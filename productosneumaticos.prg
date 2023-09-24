Define Class productosneumaticos As producto Of 'd:\capass\modelos\productos.prg'
	Function MuestraCostosParaVenta(np1, ccursor)
	Local lc, lp
	m.lc		 ='ProMuestraCostosParaVenta'
	goapp.npara1 =m.np1
	TEXT To m.lp Noshow
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, m.ccursor) <1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function nuevo()
	If This.validarproducto()<1 Then
		Return 0
	Endif
	cidpc=Id()
	TEXT TO lcInsert NOSHOW TEXTMERGE 
    INSERT INTO fe_art(descri,unid,prec,pre1,pre2,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,usua,idpc,prod_perc,prod_mode,prod_ccai,cost)
    VALUES ('<<this.cdesc>>','<<this.cunid>>',<<this.ncosto>>,<<this.np1>>,<<this.np2>>,<<this.np3>>,<<this.npeso>>,<<this.ccat>>,<<this.cmar>>,'<<this.ctipro>>',<<this.nflete>>,'<<this.moneda>>',
    localtime,'<<this.cusua>>','<<cidpc>>',<<this.nper>>,'<<this.cmodelo>>','<<this.ccai>>',<<this.ncosto>>)
	ENDTEXT
	If This.ejecutarsql(lcINSERT) < 1 Then
		Return 0
	Endif
	This.cmensaje='Creado Ok'
	Return 1
	Endfunc
	Function actualizar()
	If This.validarproducto()<1 Then
		Return 0
	Endif
	TEXT TO lm NOSHOW TEXTMERGE 
     UPDATE fe_art SET descri='<<this.cdesc>>',unid='<<this.cunid>>',cost=<<this.ncosto>>,pre1=<<this.np1>>,pre2=<<this.np2>>,
     pre3=<<this.np3>>,peso=<<this.npeso>>,idcat=<<this.ccat>>,idmar=<<this.cmar>>,tipro='<<this.ctipro>>',idflete=<<this.nflete>>,tmon='<<this.moneda>>',
     prod_perc=<<this.nper>>,prod_mode='<<this.cmodelo>>',prod_ccai='<<this.ccai>>',prod_uact=<<goapp.nidusua>> WHERE idart=<<this.ncoda>>
	ENDTEXT
	If This.ejecutarsql(lm) < 1
		Return 0
	Endif
	This.cmensaje='Actualizado Ok'
	Return 1
	Endfunc
	Function listar(cb,ccursor)
	lw = '%'+Alltrim(cb)+'%'
	TEXT TO lcConsulta NOSHOW TEXTMERGE
      SELECT idart,descri,unid,prec,uno,pre1,pre2,pre3,peso,idmar,idcat,idflete,tipro,cost,tmon,prod_perc,prod_mode,prod_ccai,prod_grat
      FROM fe_art WHERE descri LIKE ?lw ORDER BY descri
	ENDTEXT
	If ejecutaconsulta(lcconsulta, "lpro") < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function listar(np1,calias)
	m.lc		 ='PROMUESTRAPRODUCTOS'
	goapp.npara1 =m.np1
	TEXT To m.lp NOSHOW
     (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, calias) <1 Then
		Return 0
	Endif
	Return 1
	ENDFUNC
	Function Validarproducto()
	Do Case
	Case  Empty(This.cdesc)
		This.Cmensaje = 'Ingrese Nombre de producto'
		Return 0
	Case  Empty(This.cUnid)
		This.Cmensaje = 'Ingrese Unidad'
		Return 0
	Case  This.ccat = 0
		This.Cmensaje = 'Ingrese Linea de Producto'
		Return 0
	Case  This.cmar = 0
		This.Cmensaje = 'Ingrese Marca de Producto'
		Return 0
	Case This.nflete = 0
		This.Cmensaje = 'Ingrese Costo de Flete de Producto'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
Enddefine
