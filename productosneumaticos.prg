Define Class productosneumaticos As Producto Of 'd:\capass\modelos\productos.prg'
	Function MuestraCostosParaVenta(np1, Ccursor)
	Local lC, lp
	m.lC		 = 'ProMuestraCostosParaVenta'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, m.Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Nuevo()
	If This.validarproducto() < 1 Then
		Return 0
	Endif
	cidpc = Id()
	Text To lcINSERT Noshow Textmerge
    INSERT INTO fe_art(descri,unid,prec,pre1,pre2,pre3,peso,idcat,idmar,tipro,idflete,tmon,fechc,usua,idpc,prod_perc,prod_mode,prod_ccai,cost)
    VALUES ('<<this.cdesc>>','<<this.cunid>>',<<this.ncosto>>,<<this.np1>>,<<this.np2>>,<<this.np3>>,<<this.npeso>>,<<this.ccat>>,<<this.cmar>>,'<<this.ctipro>>',<<this.nflete>>,'<<this.moneda>>',
    localtime,'<<this.cusua>>','<<cidpc>>',<<this.nper>>,'<<this.cmodelo>>','<<this.ccai>>',<<this.ncosto>>)
	Endtext
	If This.Ejecutarsql(lcINSERT) < 1 Then
		Return 0
	Endif
	This.Cmensaje = 'Creado Ok'
	Return 1
	Endfunc
	Function Actualizar()
	If This.validarproducto() < 1 Then
		Return 0
	Endif
	Text To lm Noshow Textmerge
     UPDATE fe_art SET descri='<<this.cdesc>>',unid='<<this.cunid>>',cost=<<this.ncosto>>,pre1=<<this.np1>>,pre2=<<this.np2>>,
     pre3=<<this.np3>>,peso=<<this.npeso>>,idcat=<<this.ccat>>,idmar=<<this.cmar>>,tipro='<<this.ctipro>>',idflete=<<this.nflete>>,tmon='<<this.moneda>>',
     prod_perc=<<this.nper>>,prod_mode='<<this.cmodelo>>',prod_ccai='<<this.ccai>>',prod_uact=<<goapp.nidusua>> WHERE idart=<<this.ncoda>>
	Endtext
	If This.Ejecutarsql(lm) < 1
		Return 0
	Endif
	This.Cmensaje = 'Actualizado Ok'
	Return 1
	Endfunc
	Function Listar(cb, Ccursor)
	lw = '%' + Alltrim(cb) + '%'
	Text To lcconsulta Noshow Textmerge
      SELECT idart,descri,unid,prec,uno,pre1,pre2,pre3,peso,idmar,idcat,idflete,tipro,cost,tmon,prod_perc,prod_mode,prod_ccai,prod_grat
      FROM fe_art WHERE descri LIKE ?lw ORDER BY descri
	Endtext
	If EjecutaConsulta(lcconsulta, "lpro") < 1
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listar(np1, Calias)
	m.lC		 = 'PROMUESTRAPRODUCTOS'
	goApp.npara1 = m.np1
	Text To m.lp Noshow
     (?goapp.npara1)
	Endtext
	If This.EJECUTARP(m.lC, m.lp, Calias) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validarproducto()
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
	ENDFUNC
	FUNCTION listarproductosxservicio(lw,ccursor)
	cb="%"+TRIM(lw)+"%"
	TEXT TO lc NOSHOW TEXTMERGE 
	SELECT prod_ccai,descri,uno,dos,tre,cua,cin,sei,die,sie,onc,doce,trece,catorce,quince,cost*v.igv AS costo,
	IF(tmon="S","Soles","Dólares") AS tmon,ROUND(cost*v.igv*prod_uti1,2) AS pre1,
	CAST(0 AS DECIMAL(12,2)) AS costop,unid,pre2,pre3,peso,prod_perc,tipro,prod_grat,idart 
	FROM fe_art  AS a,fe_gene AS v  WHERE descri LIKE '<<cb>>' AND prod_acti<>'I'  and tipro='S'  ORDER BY descri;
	ENDTEXT 
	IF this.ejecutaconsulta(lc,ccursor)<1 then
	   RETURN 0
	ENDIF 
	RETURN 1   
	ENDFUNC 
Enddefine

