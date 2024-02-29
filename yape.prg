Define Class Yape As Odata Of 'd:\capass\database\data.prg'
	dFecha = Date()
	nmonto = 0
	nidclie = 0
	nidven = 0
	cdetalle = ""
	Ncontrol = 0
	nidus = 0
	nidua = 0
	idyape = 0
	reporte = ""
	idcredito = 0
	dfechai = Date()
	dfechaf = Date()
	confechas = ""
	nidrc = 0
	cndoc = ""
	idbanco = 0
	nmontodeposito = 0
	Function registrar()
	If This.VAlidar() < 1 Then
		Return 0
	Endif
	df = cfechas(This.dFecha)
	Text To lC Noshow Textmerge
	   INSERT INTO fe_yape(yape_fech,yape_impo,yape_idcl,yape_idve,yape_deta,yape_idus,yape_fope,yape_ctrl,yape_idrc,yape_ndoc)values('<<df>>',<<this.nmonto>>,<<this.nidclie>>,<<this.nidven>>,'<<this.cdetalle>>',<<goapp.nidusua>>,localtime,<<this.ncontrol>>,<<this.nidrc>>,'<<this.cndoc>>')
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function VAlidar()
	Do Case
	Case !esfechaValida(This.dFecha)
		This.Cmensaje = "Fecha NO Válida"
		Return 0
	Case This.nmonto <= 0
		This.Cmensaje = "Importe  NO Válido"
		Return 0
	Case Len(Alltrim(This.cdetalle)) = 0
		This.Cmensaje = "Es Necesario una Referencia"
		Return 0
*!*		Case This.nidclie = 0
*!*			This.Cmensaje = "Seleccione un Cliente"
*!*			Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function Actualizar(opt)
	df = cfechas(This.dFecha)
	If opt = 1 Then
		If This.VAlidar() < 1 Then
			Return 0
		Endif
		Text To lC Noshow Textmerge
	    update fe_yape SET yape_fech='<<df>>',yape_impo=<<this.nmonto>>,yape_idcl=<<this.nidclie>>,yape_idve=<<this.nidven>>,yape_deta='<<this.cdetalle>>',yape_idua=<<goapp.nidusua>>,yape_fope1=localtime WHERE yape_idya=<<this.idyape>>
		Endtext
	Else
		Text To lC Noshow Textmerge
	    update fe_yape SET yape_idua=<<goapp.nidusua>>,yape_fope1=localtime,yape_acti='I' WHERE yape_idya=<<this.idyape>>
		Endtext
	Endif
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Listar(Ccursor)
	f1 = cfechas(This.dfechai)
	f2 = cfechas(This.dfechaf)
	Set Textmerge On
	Set Textmerge To Memvar lC Noshow Textmerge
	\  Select yape_fech As Fecha,ifnull(c.razo,'') As cliente,yape_impo As Monto,yape_deta As detalle,v.nomv As vendedor,
	\  yape_ctrl As Ncontrol,yape_idya As idyape,yape_idcl As idclie,yape_idve As idven,yape_idcr As idcredito,yape_esta As estado,yape_idrc As Idrc,yape_ndoc As ndoc,yape_idba
	\  From fe_yape As Y
	\  Left Join fe_clie As c On c.idclie=Y.yape_idcl
    \  inner Join fe_vend As v On Y.yape_idve=v.idven
	\  Where Y.yape_acti='A'
	If This.reporte = 'P' Then
	 \ And yape_esta='P'
	Else
   	\ And yape_esta='A'
	Endif
	If This.confechas = 'S' Then
	\ And yape_fech Between '<<f1>>' And '<<f2>>'
	Endif
	\ Order By yape_fech,yape_idya
	Set Textmerge Off
	Set Textmerge To
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return  1
	Endfunc
	Function cancelapdtes(bco)
	S = 1
	Set Procedure To d:\capass\modelos\bancos, d:\capass\modelos\correlativos, d:\capass\modelos\ctasxcobrar Additive
	obco = Createobject("bancos")
	ocorr = Createobject("correlativo")
	ocr = Createobject("ctasporcobrar")
	If ocorr.BuscarSeries(Val(bco.Cserie), 'LC', 'series') < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	ccorrelativo = Right("000" + Trim(bco.Cserie), 3) + Right('000000000' + Alltrim(Str(series.nume)), 7)
	ocorr.Nsgte = series.nume
	ocorr.Idserie = series.Idserie
	If This.IniciaTransaccion() < 1 Then
		Return  0
	Endif
	xc = obco.IngresaDatosLCajax(bco.idcta, Ctod(bco.Fecha), bco.coperacion, 1, bco.cdetalle, 0, 0, ccorrelativo, fe_gene.gene_idve, bco.nmonto, 0, 1, 0, fe_gene.dola)
	If xc < 1 Then
		This.DEshacerCambios()
		This.Cmensaje = obco.Cmensaje
		Return 0
	Endif
	Select Cc
	Scan All
		nidc = ocr.CancelaCreditosCefectivoConYape( Cc.Fecha, Cc.Fecha, Cc.Monto, "Yape", 'P', 'S', 'Pago con Yape', 'F', Cc.Idrc,  goApp.nidusua, Cc.Ncontrol, '', Id(), xc)
		If nidc < 1 Then
			This.DEshacerCambios()
			This.Cmensaje = ocr.Cmensaje
			S = 0
			Exit
		Endif
		Text To lC Noshow Textmerge
          UPDATE fe_yape SET yape_esta='P',yape_idcr=<<nidc>>,yape_ctrl=<<cc.ncontrol>>,yape_idcl=<<cc.idclie>>,yape_idrc=<<cc.idrc>>,yape_ndoc='<<cc.ndoc>>',yape_idba=<<xc>> where yape_idya=<<cc.idyape>>
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			This.DEshacerCambios()
			S = 0
			Exit
		Endif
	Endscan
	If S = 0 Then
		Return 0
	Endif
	If ocorr.generacorrelativo1() < 1 Then
		This.Cmensaje = ocorr.Cmensaje
		Return 0
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Report Form infpagosyape To Printer Prompt Noconsole
	Return 1
	Endfunc
	Function extornarpago()
	If This.IniciaTransaccion() < 1 Then
		Return  0
	Endif
	Text To lC Noshow Textmerge
       UPDATE fe_yape SET yape_idcr=0,yape_idua=<<goapp.nidusua>>,yape_fope1=localtime,yape_esta='A'  where yape_idya=<<this.idyape>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		This.DEshacerCambios()
		Return 0
	Endif
	If This.idcredito > 0 Then
		Text To lC Noshow Textmerge
        UPDATE fe_cred SET acti='I' where idcred=<<this.idcredito>>
		Endtext
		If This.Ejecutarsql(lC) < 1 Then
			This.DEshacerCambios()
			Return 0
		Endif
	Endif
	If This.GRabarCambios() < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function cancela0()
	Text To lC Noshow Textmerge
          UPDATE fe_yape SET yape_idrc=<<this.nidrc>>,yape_ctrl=<<this.Ncontrol>>,yape_idcl=<<this.nidclie>>,yape_ndoc='<<this.cndoc>>' where yape_idya=<<this.idyape>>
	Endtext
	If This.Ejecutarsql(lC) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function listaryapebancos(nid, Ccursor)
	Text To lC Noshow Textmerge
	     select yape_fech as fecha,yape_ndoc as ndoc,ifnull(c.razo,'') As cliente,yape_impo As Monto,yape_deta As detalle
	     From fe_yape As Y
	     Left Join fe_clie As c On c.idclie=Y.yape_idcl
         inner Join fe_vend As v On Y.yape_idve=v.idven
	     Where Y.yape_acti='A' and yape_idba=<<nid>> order by yape_fech
	Endtext
	If This.EjecutaConsulta(lC, Ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine














