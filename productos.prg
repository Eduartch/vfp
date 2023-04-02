Define Class producto As Odata Of 'd:\capass\database\data'
	m.cdesc	   = ""
	m.cunid	   = ""
	m.nprec	   = 0
	m.ncosto   = 0
	np1		   = 0
	m.np2	   = 0
	m.np3	   = 0
	m.npeso	   = 0
	m.ccat	   = 0
	m.cmar	   = 0
	m.ctipro   = ""
	m.nflete   = 0
	m.cm	   = ""
	m.ce	   = ""
	m.cidpc	   = ""
	m.dFecha   = Datetime()
	m.nidusua  = 0
	m.nutil1   = 0
	m.nutil2   = 0
	m.nutil3   = 0
	m.ncome	   = 0
	m.ncomc	   = 0
	m.nsmax	   = 0
	m.nsmin	   = 0
	m.nidcosto = 0
	m.nidgrupo = 0
	m.ndolar   = 0
	m.ccodigo1 = ""
	m.ncoda	   = 0
	m.mflete  = 0
	m.costoneto=0
	m.costosflete=0
	m.moneda=""
	m.cusua=""
	m.nper=0
	m.modelo=""
	m.ccai=""
************************************
	Function MuestraProductosJ1(np1,np2,np3,np4,ccursor)
	lc='PROMUESTRAPRODUCTOSJx'
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If  This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function listapreciosporlineaunidades(nidcat,ccursor)
	If nidcat>0 Then
		TEXT TO lc NOSHOW textmerge
		 SELECT idart,descri,unid,prod_unid1,
		 CAST(IF(uno>0,IF(MOD(uno,prod_equi2)=0,uno/prod_equi2,IF(MOD(uno,prod_equi2)=0,uno DIV prod_equi2,TRUNCATE(uno/prod_equi2,0))),0.00) AS DECIMAL(12,2)) AS prod_unim,
		 CAST(IF(uno>0,IF(MOD(uno,prod_equi2)=0,0.00,MOD(uno,prod_equi2)),uno) AS DECIMAL(12,2)) AS prod_unin,
		 CAST(IF(dos>0,IF(MOD(dos,prod_equi2)=0,dos/prod_equi2,IF(MOD(dos,prod_equi2)=0,dos DIV prod_equi2,TRUNCATE(dos/prod_equi2,0))),0.00) AS DECIMAL(12,2)) AS prod_dunim,
		 CAST(IF(dos>0,IF(MOD(dos,prod_equi2)=0,0.00,MOD(dos,prod_equi2)),dos) AS DECIMAL(12,2)) AS prod_dunin,
		 CAST(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,IF(MOD(tre,prod_equi1)=0,tre DIV prod_equi1,TRUNCATE(tre/prod_equi1,0))),0.00) AS DECIMAL(12,2)) AS prod_tunim,
		 CAST(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) AS DECIMAL(12,2)) AS prod_tunin,
		 CAST(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,IF(MOD(cua,prod_equi1)=0,cua DIV prod_equi1,TRUNCATE(cua/prod_equi1,0))),0.00) AS  DECIMAL(12,2)) AS prod_cunim,
		 CAST(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) AS DECIMAL(12,2)) AS prod_cunin,
		 ROUND(IF(tmon='S',(a.prec*prod_tigv)+b.prec,(a.prec*prod_tigv*v.dola)+b.prec),2) AS costo,c.idgrupo,c.dcat,
		 IFNULL(ROUND(IF(tmon='S',premay,((a.prec*prod_tigv*v.dola)+b.prec)*prod_uti3),2),0) AS pre1,
		 IFNULL(ROUND(IF(tmon='S',premen,((a.prec*prod_tigv*v.dola)+b.prec)*prod_uti2),2),0) AS pre2,
		 IFNULL(ROUND(IF(tmon='S',pre3,((a.prec*prod_tigv*v.dola)+b.prec)*prod_uti1),2),0) AS pre3,prod_tigv,
		 ROUND(IF(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*v.dola)),2) AS costosf,b.prec AS flete,ulfc,uno,dos,tre,cua,
		 CAST(0 AS DECIMAL(12,2)) AS costor,CAST(0 AS DECIMAL(10,2)) AS precr,''  AS moner,
	     CAST(0 AS UNSIGNED) AS cost_idco,CAST(0 AS DECIMAL(5,2))  AS fleter,CAST(0 AS DECIMAL(5,2)) AS dolar,
	     peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
	     prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,IFNULL(o.razo,'') AS proveedor,
	     IFNULL(yy.ndoc,'') AS ndoc,IFNULL(yy.fech,'') AS fech, prod_idpc,prod_idpm,prod_cod1,prod_acti,prod_alma  FROM fe_art  AS a
	     INNER JOIN fe_fletes AS b ON(b.idflete=a.idflete)
	     INNER JOIN fe_cat AS c ON(c.idcat=a.idcat)
	     LEFT JOIN fe_rcom AS yy ON (yy.idauto=a.prod_idau)
	     LEFT JOIN fe_prov AS o ON (o.idprov=yy.idprov) ,fe_gene as v
	     WHERE a.idcat=<<nidcat>>  AND prod_acti<>'I' ORDER BY DESCRI;
		ENDTEXT
	Else
		TEXT TO lc NOSHOW textmerge
		 SELECT idart,descri,unid,prod_unid1,
		 CAST(IF(uno>0,IF(MOD(uno,prod_equi2)=0,uno/prod_equi2,IF(MOD(uno,prod_equi2)=0,uno DIV prod_equi2,TRUNCATE(uno/prod_equi2,0))),0.00) AS DECIMAL(12,2)) AS prod_unim,
		 CAST(IF(uno>0,IF(MOD(uno,prod_equi2)=0,0.00,MOD(uno,prod_equi2)),uno) AS DECIMAL(12,2)) AS prod_unin,
		 CAST(IF(dos>0,IF(MOD(dos,prod_equi2)=0,dos/prod_equi2,IF(MOD(dos,prod_equi2)=0,dos DIV prod_equi2,TRUNCATE(dos/prod_equi2,0))),0.00) AS DECIMAL(12,2)) AS prod_dunim,
		 CAST(IF(dos>0,IF(MOD(dos,prod_equi2)=0,0.00,MOD(dos,prod_equi2)),dos) AS DECIMAL(12,2)) AS prod_dunin,
		 CAST(IF(tre>0,IF(MOD(tre,prod_equi1)=0,tre/prod_equi1,IF(MOD(tre,prod_equi1)=0,tre DIV prod_equi1,TRUNCATE(tre/prod_equi1,0))),0.00) AS DECIMAL(12,2)) AS prod_tunim,
		 CAST(IF(tre>0,IF(MOD(tre,prod_equi1)=0,0.00,MOD(tre,prod_equi1)),tre) AS DECIMAL(12,2)) AS prod_tunin,
		 CAST(IF(cua>0,IF(MOD(cua,prod_equi1)=0,cua/prod_equi1,IF(MOD(cua,prod_equi1)=0,cua DIV prod_equi1,TRUNCATE(cua/prod_equi1,0))),0.00) AS  DECIMAL(12,2)) AS prod_cunim,
		 CAST(IF(cua>0,IF(MOD(cua,prod_equi1)=0,0.00,MOD(cua,prod_equi1)),cua) AS DECIMAL(12,2)) AS prod_cunin,
		 ROUND(IF(tmon='S',(a.prec*prod_tigv)+b.prec,(a.prec*prod_tigv*v.dola)+b.prec),2) AS costo,c.idgrupo,c.dcat,
		 IFNULL(ROUND(IF(tmon='S',premay,((a.prec*prod_tigv*v.dola)+b.prec)*prod_uti3),2),0) AS pre1,
		 IFNULL(ROUND(IF(tmon='S',premen,((a.prec*prod_tigv*v.dola)+b.prec)*prod_uti2),2),0) AS pre2,
		 IFNULL(ROUND(IF(tmon='S',pre3,((a.prec*prod_tigv*v.dola)+b.prec)*prod_uti1),2),0) AS pre3,prod_tigv,
		 ROUND(IF(tmon='S',(a.prec*prod_tigv),(a.prec*prod_tigv*v.dola)),2) AS costosf,b.prec AS flete,ulfc,uno,dos,tre,cua,
		 CAST(0 AS DECIMAL(12,2)) AS costor,CAST(0 AS DECIMAL(10,2)) AS precr,''  AS moner,
	     CAST(0 AS UNSIGNED) AS cost_idco,CAST(0 AS DECIMAL(5,2))  AS fleter,CAST(0 AS DECIMAL(5,2)) AS dolar,
	     peso,a.prec,tipro,idmar,a.idcat,cost,tmon,a.idflete,prod_uti1,prod_uti2,prod_uti3,prod_idus,prod_equi1,prod_equi2,
	     prod_come,prod_comc,ulpc,prod_idus,prod_uact,prod_fact,fechc,prod_smax,prod_smin,IFNULL(o.razo,'') AS proveedor,
	     IFNULL(yy.ndoc,'') AS ndoc,IFNULL(yy.fech,'') AS fech, prod_idpc,prod_idpm,prod_cod1,prod_acti,prod_alma  FROM fe_art  AS a
	     INNER JOIN fe_fletes AS b ON(b.idflete=a.idflete)
	     INNER JOIN fe_cat AS c ON(c.idcat=a.idcat)
	     LEFT JOIN fe_rcom AS yy ON (yy.idauto=a.prod_idau)
	     LEFT JOIN fe_prov AS o ON (o.idprov=yy.idprov) ,fe_gene as v
	     WHERE  prod_acti<>'I' ORDER BY DESCRI;
		ENDTEXT
	Endif
	If  This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function MuestraProductosDescCod(np1, np2, np3, np4, ccursor)
	Local lc, lp
	m.lc		 = 'PROMUESTRAPRODUCTOS1'
	goapp.npara1 = m.np1
	goapp.npara2 = m.np2
	goapp.npara3 = m.np3
	goapp.npara4 = m.np4
*cpropiedad	 = 'ListaPreciosPorTienda'
	TEXT To m.lp Noshow
   (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP10(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function CreaProducto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24)
	lc='FUNCREAPRODUCTOS'
	cur="Xn"
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24)
	ENDTEXT
	nid=This.EJECUTARF(lc,lp,cur)
	If nid<1
		Return 0
	Else
		Return nid
	Endif

	Endfunc
	Function Creaproducto4(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25)
	lc='FUNCREAPRODUCTOS'
	cur="Xn"
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	goapp.npara25=np25
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25)
	ENDTEXT
	nid=This.EJECUTARF(lc,lp,cur)
	If nid<1 Then
		Return 0
	Endif
	Return nid
	Endfunc
	Function editarproducto4(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26,np27)
	Local cur As String
	lc='PROACTUALIZAPRODUCTOS'
	cur=""
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	goapp.npara25=np25
	goapp.npara26=np26
	goapp.npara27=np27
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27)
	ENDTEXT
	If  This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.contransaccion='S'
	If This.EJECUTARP(lc,lp,cur)<1 Then
		This.deshacercambios()
		Return 0
	Endif
	If This.Actualizacostos1()<1 Then
		This.deshacercambios()
		Return 0
	Endif
	If This.grabarcambios()<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function Actualizacostos1()
	lc='PROACTUALIZACOSTOS'
*Thisform.frame.txtidcosto.Value,;
thisform.frame.txtcosto.Value,Thisform.frame.txtflete.Value,Thisform.frame.txtcoston.Value,;
Left(Thisform.frame.cmbmoneda.Value,1),Thisform.frame.txtdolar.Value
	goapp.npara1=This.nidcosto
	goapp.npara2=This.costosflete
	goapp.npara3=This.mflete
	goapp.npara4=This.costoneto
	goapp.npara5=This.moneda
	goapp.npara6=This.ndolar
*	Wait Window This.nidcosto
*	Wait Window This.costosflete
*	Wait Window This.mflete
*	Wait Window This.costoneto
*	Wait Window This.moneda
*	Wait Window This.ndolar
	TEXT TO lp NOSHOW
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6)
	ENDTEXT
	If This.EJECUTARP(lc,lp,'')<1 Then
		Return  0
	Else
		Return 1
	Endif
	Endfunc
	Function EditarProducto(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13,np14,np15,np16,np17,np18,np19,np20,np21,np22,np23,np24,np25,np26)
	Local cur As String
	lc='PROACTUALIZAPRODUCTOS'
	cur=""
	goapp.npara1=np1
	goapp.npara2=np2
	goapp.npara3=np3
	goapp.npara4=np4
	goapp.npara5=np5
	goapp.npara6=np6
	goapp.npara7=np7
	goapp.npara8=np8
	goapp.npara9=np9
	goapp.npara10=np10
	goapp.npara11=np11
	goapp.npara12=np12
	goapp.npara13=np13
	goapp.npara14=np14
	goapp.npara15=np15
	goapp.npara16=np16
	goapp.npara17=np17
	goapp.npara18=np18
	goapp.npara19=np19
	goapp.npara20=np20
	goapp.npara21=np21
	goapp.npara22=np22
	goapp.npara23=np23
	goapp.npara24=np24
	goapp.npara25=np25
	goapp.npara26=np26
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ListarPrecios()
	Endfunc
	Function MostrarSolounproducto(np1, Calias)
	Local lc, lp
*:Global ccur
	m.lc		 = "PROMUESTRAP1"
	goapp.npara1 = m.np1
	goapp.npara2 = fe_gene.dola
	ccur		 = m.Calias
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, ccur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function CreaProductosXm1(opr)
	Local lc, lp
*:Global cur
	m.lc		  ='FUNCREAPRODUCTOS'
	cur			  ="Xn"
	goapp.npara1  =opr.cdesc
	goapp.npara2  =opr.cunid
	goapp.npara3  =opr.nprec
	goapp.npara4  =opr.ncosto
	goapp.npara5  =opr.np1
	goapp.npara6  =opr.np2
	goapp.npara7  =opr.np3
	goapp.npara8  =opr.npeso
	goapp.npara9  =opr.ccat
	goapp.npara10 =opr.cmar
	goapp.npara11 =opr.ctipro
	goapp.npara12 =1
	goapp.npara13 =opr.cm
	goapp.npara14 =opr.cidpc
	goapp.npara15 =opr.ncome
	goapp.npara16 =opr.ncomc
	goapp.npara17 =opr.nutil1
	goapp.npara18 =opr.nutil2
	goapp.npara19 =opr.nutil3
	goapp.npara20 =opr.nidusua
	goapp.npara21 =opr.nsmax
	goapp.npara22 =opr.nsmin
	goapp.npara23 =opr.nidcosto
	goapp.npara24 =opr.ndolar
	goapp.npara25 =opr.ccoda
	goapp.npara26 =opr.crefe
	goapp.npara27 =opr.nflete
	goapp.npara28 =opr.nutil4
	goapp.npara29 =opr.nutil5
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,
      ?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29)
	ENDTEXT
	nidproducto= This.EJECUTARF(m.lc, m.lp, cur)
	If nidproducto < 1 Then
		Return 0
	Else
		Return nidproducto
	Endif
	Endfunc
	Function ModificaProductosXM1(opr)
	Local cur As String
	lc='PROACTUALIZAPRODUCTOS'
	cur=""
	goapp.npara1  =opr.cdesc
	goapp.npara2  =opr.cunid
	goapp.npara3  =opr.ncosto
	goapp.npara4  =opr.np1
	goapp.npara5  =opr.np2
	goapp.npara6  =opr.np3
	goapp.npara7  =opr.npeso
	goapp.npara8=opr.ccat
	goapp.npara9=opr.cmar
	goapp.npara10=opr.ctipro
	goapp.npara11=1
	goapp.npara12=opr.cm
	goapp.npara13=opr.nprec
	goapp.npara14=opr.nflete
	goapp.npara15=opr.nutil1
	goapp.npara16=opr.nutil2
	goapp.npara17=opr.nutil3
	goapp.npara18=opr.ncome
	goapp.npara19=opr.ncomc
	goapp.npara20=opr.nidusua
	goapp.npara21=opr.ncoda
	goapp.npara22=opr.nsmax
	goapp.npara23=opr.nsmin
	goapp.npara24=opr.crefe
	goapp.npara25=opr.ndolar
	goapp.npara26=opr.ce
	goapp.npara27=opr.ccoda
	goapp.npara28 =opr.nutil4
	goapp.npara29 =opr.nutil5
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13,?goapp.npara14,?goapp.npara15,?goapp.npara16,?goapp.npara17,
      ?goapp.npara18,?goapp.npara19,?goapp.npara20,?goapp.npara21,?goapp.npara22,?goapp.npara23,?goapp.npara24,?goapp.npara25,?goapp.npara26,?goapp.npara27,?goapp.npara28,?goapp.npara29)
	ENDTEXT
	If This.EJECUTARP(lc,lp,cur)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
*************************
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
	Function MuestraStockcontable(np1,ccur)
	lc='ProMuestraStockC'
	goapp.npara1=np1
	TEXT TO lp noshow
   (?goapp.npara1)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaCodigoFabricantebloque(ccursor)
	Ab=1
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	This.contransaccion='S'
	Select (ccursor)
	Go Top
	Do While !Eof()
		nidart=xlpr.idart
		cdeta=xlpr.prod_cod1
		TEXT TO lc NOSHOW TEXTMERGE
		    UPDATE fe_art SET prod_cod1='<<cdeta>>' WHERE idart=<<nidart>>
		ENDTEXT
		If This.ejecutarsql(lc)<1 Then
			Ab=0
			Exit
		Endif
		Select xlpr
		Skip
	Enddo
	If Ab=0 Then
		If This.deshacercambios()>=1 Then
			This.cmensaje="Se Deshacieron los Cambios Ok"
			Return 0
		Else
			This.cmensaje="No Se Deshacieron los Cambios Ok"
			Return 0
		Endif
	Else
		If This.grabarcambios()<1 Then
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function listarofertas(Calias)
	TEXT TO lc NOSHOW textmerge
	     SELECT idart as codigo,descri as producto,unid as unidad,uno,dos,tre,cua,cin,sei,
	     IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>v.dola,prod_dola,v.dola)))*prod_uti0)+b.prec,2),0) AS precioferta,prod_ocan as cantidad
	     fROM fe_art  as a
	     inner join fe_fletes as b  on b.idflete=a.idflete,
	     fe_gene as v
	     WHERE prod_acti='A' AND prod_uti0>0 ORDER BY descri
	ENDTEXT
	If This.ejecutaconsulta(lc,Calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarofertas1(Calias)
	TEXT TO lc NOSHOW textmerge
	     SELECT idart as codigo,descri as producto,unid as unidad,uno,dos,tre,
	     IFNULL(ROUND(IF(tmon='S',((a.prec*v.igv)+b.prec)*prod_uti0,((a.prec*v.igv*IF(prod_dola>v.dola,prod_dola,v.dola))+b.prec)*prod_uti0),2),0) AS precioferta,prod_ocan as cantidad
	     fROM fe_art  as a
	     inner join fe_fletes as b  on b.idflete=a.idflete,
	     fe_gene as v
	     WHERE prod_acti='A' AND prod_uti0>0 ORDER BY descri
	ENDTEXT
	If This.ejecutaconsulta(lc,Calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function GrabarOfertascontidadyprecio(np1,np2,np3,np4)
	TEXT TO lc NOSHOW  textmerge
	UPDATE fe_art SET prod_uti0=<<np2>>,prod_ocan=<<np3>>,prod_ocom=<<np4>> where idart=<<np1>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizaStock(ncoda,nalma,ncant,ctipo)
	lc="ASTOCK"
	goapp.npara1  =ncoda
	goapp.npara2  =nalma
	goapp.npara3  =ncant
	goapp.npara4  =ctipo
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lc,lp)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function consultarkardexproducto(ccoda,dfechai,dfechaf,calmacen,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT ifnull(e.ndoc,'')  as nped,d.ndo2,d.fech,d.ndoc,d.tdoc,a.tipo,d.mone as cmoneda,a.cant,d.fusua,ifnull(g.nomb,'') as usua1,
	   a.prec,d.vigv as igv,d.dolar,f.nomb as usua,d.idcliente as codc,b.razo AS cliente,d.idprov as codp,c.razo AS proveedor,d.deta,a.alma
	   FROM fe_kar as a
	   inner JOIN fe_rcom as d on (d.idauto=a.idauto)
	   left join fe_prov as c ON(d.idprov=c.idprov)
	   left JOIN fe_clie as b ON(d.idcliente=b.idclie)
	   LEFT JOIN fe_rped as e ON(e.idautop=d.idautop)
	   inner join fe_usua as f ON(f.idusua=d.idusua)
	   left join fe_usua as g ON (g.idusua=d.idusua1)
	   WHERE a.idart=<<ccoda>> and d.acti<>'I' and d.fech between '<<dfechai>>' and  '<<dfechaf>>' and a.acti<>'I' AND a.alma=<<calmacen>> ORDER BY d.fech,d.tipom,a.idkar
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return  0
	Endif
	Return 1
	Endfunc
	Function MuestraProductos1(np1,np2,ccursor)
	lc='PROMUESTRAPRODUCTOS'
	goapp.npara1=np1
	goapp.npara2=np2
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function MostrarSolounproducto(ncoda,ndola,ccursor)
	lc='PROMUESTRAP1'
	goapp.npara1=ncoda
	goapp.npara2=ndola
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2)
	ENDTEXT
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function calcularstock()
	ncon=This.abreconexion1(goapp.xopcion)
	lc='calcularstock()'
	If This.EJECUTARP1(lc,"","",ncon)<1 Then
		This.cierraconexion(ncon)
		Return 0
	Endif
	This.cierraconexion(ncon)
	This.cmensaje='Stock Calculado'
	Return 1
	Endfunc
	Function MuestraProductosDescCod2(np1, np2, np3, np4, ccursor)
	Local lc, lp
	If goapp.nube='S' Then
		m.lc		 = 'PROMUESTRAPRODUCTOS2'
	Else
		m.lc		 = 'PROMUESTRAPRODUCTOS1'
	Endif
	goapp.npara1 = m.np1
	goapp.npara2 = m.np2
	goapp.npara3 = m.np3
	goapp.npara4 = m.np4
*cpropiedad	 = 'ListaPreciosPorTienda'
	TEXT To m.lp Noshow
   (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP10(m.lc, m.lp, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function validar()
	Do Case
	Case  Empty(This.cdesc)
		This.cmensaje='Ingrese Nombre de producto'
		Return 0
	Case  Empty(This.unid)
		This.cmensaje='Ingrese Unidad'
		Return 0
	Case  This.ccat=0
		This.cmensaje='Ingrese Linea de Producto'
		Return 0
	Case  This.cmar=0
		This.cmensaje='Ingrese Marca de Producto'
		Return 0
	Case This.nflete=0
		This.cmensaje='Ingrese Costo de Flete de Producto'
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function agratuito(opt)
	If opt=1 Then
		If This.ncosto=0 Then
			This.cmensaje='Ingrese Costo del producto'
			Return 0
		Endif
		TEXT TO lc NOSHOW TEXTMERGE
	    UPDATE fe_art SET prod_grat='S' WHERE idart=<<this.ncoda>>
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
	     UPDATE fe_art SET prod_grat='N' WHERE idart=<<this.ncoda>>
		ENDTEXT
	Endif
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimaventa(ncoda,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT c.razo,MAX(r.fech)as fech,ndoc,prec FROM fe_kar AS k
	INNER JOIN fe_rcom AS r ON r.idauto=k.idauto
	INNER JOIN fe_clie AS c ON c.idclie=r.idcliente
	WHERE idart=<<ncoda>> AND k.acti='A' AND r.acti='A' LIMIT 1
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ultimacompra(ncoda,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	SELECT c.razo,MAX(r.fech)as fech,ndoc,prec FROM fe_kar AS k
	INNER JOIN fe_rcom AS r ON r.idauto=k.idauto
	INNER JOIN fe_prov AS c ON c.idprov=r.idprov
	WHERE idart=<<ncoda>> AND k.acti='A' AND r.acti='A' LIMIT 1
	ENDTEXT
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarpormarcaylinea(calias)
	Set DataSession To This.idsesion
	Do Case
	Case This.cmar=0 And This.ccat=0
		TEXT TO lc NOSHOW TEXTMERGE
	     select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art where prod_acti='A' order by idart
		ENDTEXT
	Case This.ccat>0 And This.cmar>0
		TEXT TO lc NOSHOW TEXTMERGE
        select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art where prod_acti='A' and idcat=<<this.ccat>> and idmar=<<this.cmar>> order by idart
		ENDTEXT
	Case This.ccat>0 And This.cmar=0
		TEXT TO lc NOSHOW TEXTMERGE
        select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art  where prod_acti='A' and idcat=<<this.ccat>> order by idart
		ENDTEXT
	Case This.ccat=0 And This.cmar>0
		TEXT TO lc NOSHOW TEXTMERGE
        select idart,descri,unid,uno as tienda,dos as almacen,tre as interno,idmar,idcat FROM fe_art  where prod_acti='A' and idmar=<<this.cmar>> order by idart
		ENDTEXT
	Endcase
	If This.ejecutaconsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
