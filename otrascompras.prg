Define Class otrascompras As compras Of 'd:\capass\modelos\compras'
	Function registraotracompras()
	Set Procedure To d:\capass\modelos\cajae,d:\capass\modelos\ctasxpagar Additive
	ocaja=Createobject("cajae")
	octaspagar=Createobject("ctasporpagar")
	octaspagar.idsesion=This.idsesion
	If This.validaocompras()<1 Then
		Return 0
	Endif
	cformapago=IIF(This.cforma='C','',this.cforma)
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=This.IngresaResumenDctoC(This.ctdoc,This.cforma,This.cndoc,This.dFecha ,This.dfechar,This.cdetalle,This.nimpo1+This.nimpo2+This.nimpo3+This.nimpo4,This.nimpo5,This.nimpo8,;
		'',This.cmoneda,This.ndolar,fe_gene.igv,This.ctipo,This.nidprov,This.ctipo1 ,goapp.nidusua,0,goapp.tienda,0,0,0,0,0,This.nimpo6,This.nimpo8)
	If nauto< 1  Then
		This.DeshacerCambios()
		Return 0
	Endif

	If This.IngresaValoresCtasC1(This.nimpo1,This.nimpo2,This.nimpo3,This.nimpo4,This.nimpo5,This.nimpo6,This.nimpo7,This.nimpo8,This.nidcta1,This.nidcta2,This.nidcta3,This.nidcta4,;
			this.nidctai,This.nidctae,This.nidcta7,This.nidctat,This.ct1,This.ct2,This.ct3,This.ct4,This.ct5,This.ct6,This.ct7,This.ct8,nauto)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If _Screen.ocajae.IngresaDatosLCajaEFectivorodi1(This.dfechar,"",This.cproveedor,This.nidctat,0,This.nimpo8,This.cmoneda,This.ndolar,goapp.nidusua,This.nidprov,nauto,This.cforma,This.cndoc,This.ctdoc,goapp.tienda,'Ca',0,"","","",cformapago)<1 Then
		This.Cmensaje=ocaja.Cmensaje
		This.DeshacerCambios()
		Return 0
	Endif
	If  This.nforma=2 Then
		If  octaspagar.registra('tmpd',nauto,This.nidprov,This.cmoneda,This.dFecha,This.nimpo8,This.nidctat,This.ndolar)<1 Then
			This.Cmensaje=octaspagar.Cmensaje
			This.DeshacerCambios()
			Return 0
		Endif
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registraotracompras0()
	Set Procedure To d:\capass\modelos\cajae,d:\capass\modelos\ctasxpagar Additive
	ocaja=Createobject("cajae")
	octaspagar=Createobject("ctasporpagar")
	Set DataSession To This.idsesion
	octaspagar.idsesion=This.idsesion
	If This.validaocompras()<1 Then
		Return 0
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	nauto=This.IngresaResumenDctoC(This.ctdoc,This.cforma,This.cndoc,This.dFecha ,This.dfechar,This.cdetalle,This.nimpo1+This.nimpo2+This.nimpo3+This.nimpo4,This.nimpo5,This.nimpo8,;
		'',This.cmoneda,This.ndolar,fe_gene.igv,This.ctipo,This.nidprov,This.ctipo1 ,goapp.nidusua,0,goapp.tienda,0,0,0,0,0,This.nimpo6,This.nimpo8)
	If nauto< 1  Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.IngresaValoresCtasC1(This.nimpo1,This.nimpo2,This.nimpo3,This.nimpo4,This.nimpo5,This.nimpo6,This.nimpo7,This.nimpo8,This.nidcta1,This.nidcta2,This.nidcta3,This.nidcta4,;
			this.nidctai,This.nidctae,This.nidcta7,This.nidctat,This.ct1,This.ct2,This.ct3,This.ct4,This.ct5,This.ct6,This.ct7,This.ct8,nauto)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If  This.nforma=2 Then
		If  octaspagar.registra('tmpd',nauto,This.nidprov,This.cmoneda,This.dFecha,This.nimpo8,This.nidctat,This.ndolar)<1 Then
			This.DeshacerCambios()
			This.Cmensaje=octaspagar.Cmensaje
			Return 0
		Endif
	Endif
	If This.GrabarCambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarocompras()
	Set Procedure To d:\capass\modelos\cajae,d:\capass\modelos\ctasxpagar Additive
	ocaja=Createobject("cajae")
	octaspagar=Createobject("ctasporpagar")
	Set DataSession To This.idsesion
	octaspagar.idsesion=This.idsesion
	cformapago=IIF(This.cforma='C','',this.cforma)
	If This.validaocompras()<1 Then
		Return 0
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	If This.ActualizaResumenDctoC(This.cTDOC,This.cforma,This.cndoc,This.dFecha,This.dfechar,This.cdetalle,This.nimpo1+This.nimpo2+This.nimpo3+This.nimpo4,This.nimpo5,This.nimpo8,'',This.cmoneda,;
			this.ndolar,fe_gene.igv,This.ctipo,This.nidprov,This.ctipo1,goapp.nidusua,0,goapp.tienda,0,0,0,0,0,This.nreg,This.nimpo6,This.nimpo8)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If _Screen.ocajae.IngresaDatosLCajaEFectivorodi1(This.dfechar,"",This.cproveedor,This.nidctat,0,This.nimpo8,This.cmoneda,This.ndolar,goapp.nidusua,This.nidprov,This.nreg,This.cforma,This.cndoc,This.ctdoc,goapp.tienda,'Ca',0,"","","",cformapago)<1 Then
		This.Cmensaje=ocaja.Cmensaje
		This.DeshacerCambios()
		Return 0
	Endif
	If This.cFormaregistrada='C' And This.nforma=1 Then
		If ActualizaDeudas(This.nreg,goapp.nidusua)=0
			Return 0
		Endif
	Endif
	If This.actualizactasocompras()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If  This.nforma=2 Then
		If This.nreg>0 Then
			If ActualizaDeudas(This.nreg,goapp.nidusua)=0
				This.DeshacerCambios()
				Return 0
			Endif
		Endif
		If  octaspagar.registra('tmpd',This.nreg,This.nidprov,This.cmoneda,This.dFecha,This.nimpo8,This.nidctat,This.ndolar)<1 Then
			This.DeshacerCambios()
			Return 0
		Endif
	Endif
	If This.GrabarCambios()=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function actualizarocompras0()
	Set Procedure To d:\capass\modelos\cajae,d:\capass\modelos\ctasxpagar Additive
	ocaja=Createobject("cajae")
	octaspagar=Createobject("ctasporpagar")
	Set DataSession To This.idsesion
	octaspagar.idsesion=This.idsesion
	If This.validaocompras()<1 Then
		Return 0
	Endif
	If This.IniciaTransaccion()<1 Then
		Return 0
	Endif
	If This.ActualizaResumenDctoC(This.cTDOC,This.cforma,This.cndoc,This.dFecha,This.dfechar,This.cdetalle,This.nimpo1+This.nimpo2+This.nimpo3+This.nimpo4,This.nimpo5,This.nimpo8,'',This.cmoneda,;
			this.ndolar,fe_gene.igv,This.ctipo,This.nidprov,This.ctipo1,goapp.nidusua,0,goapp.tienda,0,0,0,0,0,This.nreg,This.nimpo6,This.nimpo8)<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If This.cFormaregistrada='C' And This.nforma=1 Then
		If ActualizaDeudas(This.nreg,goapp.nidusua)=0
			Return 0
		Endif
	Endif
	If  this.actualizactasocompras()<1 Then
		This.DeshacerCambios()
		Return 0
	Endif
	If  This.nforma=2 Then
		If This.nreg>0 Then
			If ActualizaDeudas(This.nreg,goapp.nidusua)=0
				This.DeshacerCambios()
				Return 0
			Endif
		Endif
		If  octaspagar.registra('tmpd',This.nreg,This.nidprov,This.cmoneda,This.dFecha,This.nimpo8,This.nidctat,This.ndolar)<1 Then
			This.DeshacerCambios()
			Return 0
		Endif
	Endif
	If This.GrabarCambios()=0 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
