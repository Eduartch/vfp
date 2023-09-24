Define Class guiaremisionxvtas As guiaremision Of 'd:\capass\modelos\guiasremision'
	Function listaritemsparaguia(nid,calias)
	TEXT TO lc NOSHOW TEXTMERGE
           select a.idauto,a.idkar,a.idart AS coda,a.saldo AS cant,r.fech,r.form,r.idcliente AS idclie,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,r.ndoc,e.descri,e.unid,e.peso,a.saldo
	       FROM (SELECT SUM(IFNULL(`f`.`entr_cant`,0)) AS `entregado`, (`b`.`cant` - SUM(IFNULL(`f`.`entr_cant`,0))) AS `saldo`, `a`.`idauto` AS `idauto`, `b`.`idkar`  AS `idkar`, `b`.`idart`  AS `idart`
	       FROM `fe_kar` `b`
	       JOIN `fe_rcom` `a`   ON `a`.`idauto` = `b`.`idauto`
	       LEFT JOIN (SELECT SUM(entr_cant) AS entr_cant,guia_idau,entr_idkar FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.`entr_idgu`=g.`guia_idgui`
	       WHERE g.`guia_idau`=<<nids>> AND g.guia_acti='A' AND e.`entr_acti`='A' GROUP BY entr_idkar,entr_idgu) AS f   ON f.entr_idkar=b.`idkar`
	       WHERE (`a`.`acti` = 'A'   AND `b`.`acti` = 'A' AND a.idauto=<<nids>>) GROUP BY `b`.`idkar`,`a`.`idauto`,`b`.`idart`) AS a
	       INNER JOIN fe_rcom AS r ON r.idauto=a.idauto
	       INNER JOIN fe_clie AS c  ON c.idclie=r.idcliente
	       INNER JOIN fe_art AS e ON e.idart=a.idart
	       where saldo>0  ORDER BY a.idkar
	ENDTEXT
	If This.ejecutaconsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaritemsparaguiaunidades(nid,calias)
	TEXT TO lc NOSHOW TEXTMERGE
           select a.idauto,a.idkar,a.idart AS coda,a.saldo AS cant,r.fech,r.form,r.idcliente AS idclie,
	       c.razo,c.nruc,c.dire,c.ciud,c.ndni,r.tdoc,r.ndoc,e.descri,a.kar_unid as unid,e.peso,a.saldo
	       FROM (SELECT SUM(IFNULL(`f`.`entr_cant`,0)) AS `entregado`, (`b`.`cant` - SUM(IFNULL(`f`.`entr_cant`,0))) AS `saldo`,
	        `a`.`idauto` AS `idauto`, `b`.`idkar`  AS `idkar`, `b`.`idart`  AS `idart`,b.kar_unid
	       FROM `fe_kar` `b`
	       JOIN `fe_rcom` `a`   ON `a`.`idauto` = `b`.`idauto`
	       LEFT JOIN (SELECT SUM(entr_cant) AS entr_cant,guia_idau,entr_idkar FROM fe_guias AS g
	       INNER JOIN fe_ent AS e ON e.`entr_idgu`=g.`guia_idgui`
	       WHERE g.`guia_idau`=<<nids>> AND g.guia_acti='A' AND e.`entr_acti`='A' GROUP BY entr_idkar,entr_idgu) AS f   ON f.entr_idkar=b.`idkar`
	       WHERE (`a`.`acti` = 'A'   AND `b`.`acti` = 'A' AND a.idauto=<<nids>>) GROUP BY `b`.`idkar`,`a`.`idauto`,`b`.`idart`,b.kar_unid) AS a
	       INNER JOIN fe_rcom AS r ON r.idauto=a.idauto
	       INNER JOIN fe_clie AS c  ON c.idclie=r.idcliente
	       INNER JOIN fe_art AS e ON e.idart=a.idart
	       where saldo>0
	       ORDER BY a.idkar
	ENDTEXT
	If This.ejecutaconsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarguiaporventa(nids,calias)
	TEXT TO lc NOSHOW TEXTMERGE
	   select guia_ndoc as ndoc,guia_fech as fech,guia_fect as fechat,
	   a.descri,a.unid,e.entr_cant as cant,a.peso,g.guia_ptoll,g.guia_ptop as ptop,
	   k.idart as coda,k.prec,k.idkar,g.guia_idtr,ifnull(placa,'') as placa,ifnull(t.razon,'') as razont,
	   ifnull(t.ructr,'') as ructr,ifnull(t.nombr,'') as conductor,guia_mens,
	   ifnull(t.dirtr,'') as direcciont,ifnull(t.breve,'') as brevete,
	   ifnull(t.cons,'') as constancia,ifnull(t.marca,'') as marca,c.nruc,c.ndni,entr_iden,
	   ifnull(t.placa1,'') as placa1,r.ndoc as dcto,tdoc,r.idcliente,r.fech as fechadcto,
	   c.Razo,'S' as mone,guia_idgui as idgui,r.idauto,c.dire,c.ciud,guia_arch,guia_hash,guia_mens,guia_ubig
	   FROM
	   fe_guias as g
	   inner join fe_rcom as r on r.idauto=g.guia_idau
	   inner join fe_clie as c on c.idclie=r.idcliente
	   inner join fe_ent as e on e.entr_idgu=g.guia_idgui
	   inner join fe_kar as k on k.idkar=e.entr_idkar
	   inner join fe_art as a on a.idart=k.idart
	   left join fe_tra as t on t.idtra=g.guia_idtr
	   where guia_idgui=<<nids>>
	ENDTEXT
	If This.ejecutaconsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Grabarguiaremitente()
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	If This.idautog>0 Then
		If AnulaGuiasVentas(This.idautog,goapp.nidusua)=0 Then
			DeshacerCambios()
			Return 0
		Endif
	Endif
	nidg=This.IngresaGuiasX(This.fecha,This.ptop,Alltrim(This.ptoll),This.idauto,This.fechat,goapp.nidusua,This.detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.ubigeocliente)
	If nidg=0 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s=1
	Do While !Eof()
		If GrabaDetalleGuias(tmpvg.nidkar,tmpvg.cant,nidg)=0 Then
			s=0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.generacorrelativo()=1 And s=1 Then
		If This.GrabarCambios()=0 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DeshacerCambios()
		Return 0
	Endif
	Endfunc
	Function ActualizaguiasRemitenteventas()
	This.contransaccion='S'
	If This.IniciaTransaccion() = 0
		This.contransaccion=''
		Return 0
	Endif
	If This.ActualizaGuiasVtas(This.fecha, This.ptop, This.ptoll, This.nautor, This.fechat, goapp.nidusua, This.detalle, This.Idtransportista, This.ndoc, This.idautog, goapp.tienda, This.Codigo) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtasR(This.calias) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.GrabarCambios() = 0 Then
		This.contransaccion=""
		Return 0
	Endif
	This.imprimir('S')
	Return 1
	Endfunc
	Function ActualizaDetalleGuiasVtasR(ccursor)
*:Global cdesc, nidkar, s, sw
	Sw=1
*	WAIT WINDOW 'hola' +ccursor
	Select (m.ccursor)
	Set Filter To coda<>0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc=Alltrim(tmpvg.Descri)
		If Deleted()
			If nreg > 0 Then
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.idautog, 0, '') = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else
			If tmpvg.nreg = 0 Then
				If GrabaDetalleGuias(tmpvg.nidkar, tmpvg.cant, This.idautog) = 0 Then
					s			  =0
					This.Cmensaje ="Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nidkar, This.idautog, 1, '') = 0 Then
					Sw			  =0
					This.Cmensaje =Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif

		Endif
		Select tmpvg
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function grabarguiaremitentedirectau
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=IngresaResumenDcto('09','E',This.ndoc,This.fecha,This.fecha,"",0,0,0,'','S',fe_gene.dola,fe_gene.igv,'k',This.Codigo,'V',goapp.nidusua,1,goapp.tienda,0,0,0,0,0)
	If nauto<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	nidg=This.IngresaGuiasX(This.fecha,This.ptop,Alltrim(This.ptoll),nauto,This.fechat,goapp.nidusua,This.detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.ubigeocliente)
	If nidg<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s=1
	Do While !Eof()
		nidkar=IngresaKardexUAl(nauto,tmpvg.coda,'V',tmpvg.Prec,tmpvg.cant,'I','K',This.idvendedor,goapp.tienda,0,tmpvg.comi/100,tmpvg.equi,;
			tmpvg.unid,tmpvg.idepta,tmpvg.pos,tmpvg.costo,fe_gene.igv)
		If nidkar<1 Then
			s=0
			Cmensaje="Al Ingresar al Kardex Detalle de Items"
			Exit
		Endif
		If  This.GrabaDetalleGuias(nidkar,tmpvg.cant,nidg)<1 Then
			s=0
			Exit
		Endif
		If ActualizaStock1(tmpvg.coda,goapp.tienda,tmpvg.cant,'V',tmpvg.equi)=0 Then
			s=0
			This.Cmensaje="Al Actualizar Stock "
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.generacorrelativo()=1 And s=1  Then
		If This.GrabarCambios()<1 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DeshacerCambios()
		Return 0
	Endif
	Endfunc
*******************
	Function GrabaDetalleGuias(nidk,ncant,nidg)
	Local lc, lp
	lc			  = "FunDetalleGuiaVentas"
	cur			  = "ig"
	goapp.npara1  = nidk
	goapp.npara2  = ncant
	goapp.npara3  = nidg
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3)
	ENDTEXT
	idg=This.EJECUTARF(lc, lp, cur)
	If idg<1 Then
		Return 0
	Endif
	Return idg
	Endfunc
	Function actualiaguiasventasdirectasu()
	This.contransaccion='S'
	If This.IniciaTransaccion() = 0
		This.contransaccion=''
		Return 0
	Endif
	If This.ActualizaCabeceraGuiaventasdirectas() < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtas(This.calias) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.GrabarCambios() = 0 Then
		This.contransaccion=""
		Return 0
	Endif
	This.imprimir('S')
	Return 1
	Endfunc
	Function grabarguiaremitentevtasx3
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nidg=This.IngresaGuiasX3vtas(This.fecha,This.ptop,Alltrim(This.ptoll),This.Codigo,This.fechat,goapp.nidusua,This.detalle,This.Idtransportista,This.ndoc,goapp.tienda,This.ubigeocliente)
	If nidg<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	Select tmpvg
	Go Top
	s=1
	Do While !Eof()
		If This.GrabaDetalleGuiasx3(0,tmpvg.cant,nidg,tmpvg.coda)<1 Then
			s=0
			Exit
		Endif
		Select tmpvg
		Skip
	Enddo
	If  This.generacorrelativo()=1 And s=1  Then
		If This.GrabarCambios()<1 Then
			Return 0
		Endif
		This.imprimir('S')
		Return  1
	Else
		This.DeshacerCambios()
		Return 0
	Endif
	Endfunc
	Function GrabaDetalleGuiasx3(nidk,ncant,nidg,ncoda)
	Local lc, lp
	lc			  = "proDetalleGuiaVentas"
	cur			  = ""
	goapp.npara1  = nidk
	goapp.npara2  = ncant
	goapp.npara3  = nidg
	goapp.npara4  = ncoda
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4)
	ENDTEXT
	If This.EJECUTARP(lc, lp, cur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function IngresaGuiasX3vtas(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10,np11)
	Local lc, lp
	lc			  = "FUNINGRESAGUIAS1"
	cur			  = "YY"
	goapp.npara1  = np1
	goapp.npara2  = np2
	goapp.npara3  = np3
	goapp.npara4  = np4
	goapp.npara5  = np5
	goapp.npara6  = np6
	goapp.npara7  = np7
	goapp.npara8  = np8
	goapp.npara9  = np9
	goapp.npara10 = np10
	goapp.npara11 = np11
	TEXT To lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?goapp.npara10,?goapp.npara11)
	ENDTEXT
	nidgg=This.EJECUTARF(lc, lp, cur)
	If nidgg<1 Then
		Return 0
	Endif
	Return nidgg
	Endfunc
	Function actualiaguiasremitentevtasx3()
	This.contransaccion='S'
	If This.IniciaTransaccion() = 0
		This.contransaccion=''
		Return 0
	Endif
	If This.ActualizaGuiasVtasx3(This.fecha, This.ptop, This.ptoll, 0, This.fechat, goapp.nidusua, This.detalle, This.Idtransportista, This.ndoc, This.idautog, goapp.tienda,This.Codigo) < 1
		Return 0
	Endif
	If This.ActualizaDetalleGuiasVtas(This.calias) < 1 Then
		This.DeshacerCambios()
		This.contransaccion=""
		Return 0
	Endif
	If This.GrabarCambios() = 0 Then
		This.contransaccion=""
		Return 0
	Endif
	This.imprimir('S')
	Return 1
	Endfunc
	Function ActualizaGuiasVtasx3(np1, np2, np3, np4, np5, np6, np7, np8, np9, np10, np11,np12)
	Local lc, lp
	m.lc		  ="ProActualizaGuiasVtas"
	cur			  =""
	goapp.npara1  =m.np1
	goapp.npara2  =m.np2
	goapp.npara3  =m.np3
	goapp.npara4  =m.np4
	goapp.npara5  =m.np5
	goapp.npara6  =m.np6
	goapp.npara7  =m.np7
	goapp.npara8  =m.np8
	goapp.npara9  =m.np9
	goapp.npara10 =This.idautog
	goapp.npara11 =m.np11
	goapp.npara12 =m.np12
	goapp.npara13= This.ubigeocliente
	TEXT To m.lp Noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,?this.idautog,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	If This.EJECUTARP(m.lc, m.lp, cur) < 1 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function ActualizaDetalleGuiasVtasx3(ccursor)
	Sw=1
	Select (m.ccursor)
	Set Filter To coda<>0
	Set Deleted Off
	Go Top
	Do While !Eof()
		cdesc=Alltrim(tmpvg.Descri)
		If Deleted()
			If nreg > 0 Then
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nreg, This.idautog, 0, '') = 0 Then
					Sw			  =0
					This.Cmensaje ="Al Desactivar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Else

			If tmpvg.nreg = 0 Then
				If  This.GrabaDetalleGuiasx3(nidkar, tmpvg.cant, This.idautog,tmpvg.coda) = 0 Then
					s			  =0
					This.Cmensaje ="Al Ingresar Detalle de Guia " + Alltrim(cdesc)
					Exit
				Endif
			Else
				If This.ActualizaDetalleGuiaCons1(tmpvg.coda, tmpvg.cant, tmpvg.idem, tmpvg.nreg, This.idautog, 1, '') < 1 Then
					Sw			  =0
					This.Cmensaje =Alltrim(This.Cmensaje) + " Al Actualizar Ingreso (Guia)  de Item  - " + Alltrim(cdesc)
					Exit
				Endif
			Endif
		Endif
		Select (ccursor)
		Skip
	Enddo
	Set Deleted On
	If Sw = 0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listarguiasxcanjear(nidtda,cestado,calias)
	Do Case
	Case cestado='P'
		TEXT TO lc NOSHOW TEXTMERGE
	         SELECT guia_ndoc,guia_fech,ndoc,fech,c.razo,r.impo FROM fe_guias AS g
             INNER JOIN fe_rcom AS r ON r.`idauto`=g.guia_idau
             inner join fe_clie as c on c.idclie=r.idcliente
             WHERE guia_acti='A' AND r.`acti`='A' AND r.`codt`=<<nidtda>> AND r.tdoc='09'
		ENDTEXT
	Case cestado='T'
		TEXT TO lc NOSHOW TEXTMERGE
	         SELECT guia_ndoc,guia_fech,ndoc,fech,c.razo,r.impo FROM fe_guias AS g
             INNER JOIN fe_rcom AS r ON r.`idauto`=g.guia_idau
             inner join fe_clie as c on c.idclie=r.idcliente
             WHERE guia_acti='A' AND r.`acti`='A' AND r.`codt`=<<nidtda>>
		ENDTEXT
	Case cestado="F"
		TEXT TO lc NOSHOW TEXTMERGE
	         SELECT guia_ndoc,guia_fech,ndoc,fech,c.razo,r.impo FROM fe_guias AS g
             INNER JOIN fe_rcom AS r ON r.`idauto`=g.guia_idau
             inner join fe_clie as c on c.idclie=r.idcliente
             WHERE guia_acti='A' AND r.`acti`='A' AND r.tdoc='01' and  r.`codt`=<<nidtda>>
		ENDTEXT
	Endcase
	If This.ejecutaconsulta(lc,calias)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
