Define Class cajakya As cajae Of 'd:\capass\modelos\cajae'
	fecha=Date()
	codt=0
	nidus=0
	Function listar(dfecha,ccursor)
	If this.codt=0 Then
		TEXT TO lc NOSHOW TEXTMERGE
		      SELECT b.nomb as detalle,b.tdoc,b.orden,a.forma,a.tipo,a.ndoc,a.impo,a.deta,a.fech,a.tmon as mone,c.nomb as usua,
		      a.fechao,ifnull(z.nomv,'') as usuavtas,a.idcon,a.origen,a.mone as tmon1,a.dola,a.nimpo,'0' as vtas FROM
		      fe_caja as a
		      inner join fe_con as b ON(a.idcon=b.idcon)
		      inner join fe_usua as c on c.idusua=a.idusua
		      left join rvendedores as p on p.idauto=a.idauto
		      left join fe_vend as z On z.idven=p.codv
		      WHERE a.fech='<<dfecha>>' AND a.idusua=<<this.nidus>> and a.acti<>'I' an p.codv=4
		      union all
		      SELECT b.nomb as detalle,b.tdoc,b.orden,a.forma,a.tipo,a.ndoc,a.impo,a.deta,a.fech,a.tmon as mone,c.nomb as usua,
		      a.fechao,ifnull(z.nomv,'') as usuavtas,a.idcon,a.origen,a.mone as tmon1,a.dola,a.nimpo,'1' as vtas FROM
		      fe_caja as a
		      inner join fe_con as b ON(a.idcon=b.idcon)
		      inner join fe_usua as c on c.idusua=a.idusua
		      left join rvendedores as p on p.idauto=a.idauto
		      left join fe_vend as z   On z.idven=p.codv
		      WHERE a.fech='<<dfecha>>' AND a.idusua=<<this.nidus>> and a.acti<>'I' an p.codv<>4   order by orden
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE 
		      SELECT b.nomb as detalle,b.tdoc,b.orden,a.forma,a.tipo,a.ndoc,a.impo,a.deta,a.fech,a.tmon as mone,c.nomb as usua,
		      a.fechao,ifnull(z.nomv,'') as usuavtas,a.idcon,a.origen,a.mone as tmon1,a.dola,a.nimpo,'0' as vtas FROM
		      fe_caja as a
		      inner join fe_con as b ON(a.idcon=b.idcon)
		      inner join fe_usua as c on c.idusua=a.idusua
		      left join rvendedores as p on p.idauto=a.idauto
		      left join fe_vend as z  On z.idven=p.codv
		      WHERE a.fech='<<dfecha>>' AND a.codt=<<this.codt>> and a.acti<>'I' AND p.codv=4
		      union all
		      SELECT b.nomb as detalle,b.tdoc,b.orden,a.forma,a.tipo,a.ndoc,a.impo,a.deta,a.fech,a.tmon as mone,c.nomb as usua,
		      a.fechao,ifnull(z.nomv,'') as usuavtas,a.idcon,a.origen,a.mone as tmon1,a.dola,a.nimpo,'1' as vtas FROM
		      fe_caja as a
		      inner join fe_con as b ON(a.idcon=b.idcon)
		      inner join fe_usua as c on c.idusua=a.idusua
		      left join rvendedores as p on p.idauto=a.idauto
		      left join fe_vend as z  On z.idven=p.codv
		      WHERE a.fech='<<dfecha>>' AND a.codt=<<this.codt>> and a.acti<>'I' AND p.codv<>4 order by orden
		ENDTEXT
	Endif
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
