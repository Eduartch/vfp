Define Class bancosrodi As bancos Of  'd:\capass\modelos\bancos.prg'
	Function registratranscaja(dfecha,ccorrelativo,cdetalle,idcta,ndebe,nhaber,cmone,nd,nidusua,idctab,coperacion,nimp,cdetalle1,nidtda,cfp)
	If This.iniciatransaccion()<1 Then
		Return 0
	Endif
	If goapp.xopcion=0 Then
		vd=_Screen.ocajae.TraspasoDatosLcajaE(dfecha,ccorrelativo,cdetalle,idcta,ndebe,nhaber,cmone,nd,nidusua,0)
	Else
		vd=_Screen.ocajae.TraspasoDatosLCajaErodi(dfecha,ccorrelativo,cdetalle,idcta,ndebe,nhaber,cmone,nd,nidusua,0,'',nidtda,cfp)
	Endif
	If vd<1 Then
		This.deshacercambios()
		Return 0
	Endif
	If _Screen.obancos.IngresaDatosLCajaT(idctab,dfecha,coperacion,nimp,Alltrim(cdetalle)+' '+Alltrim(cdetalle1),0,0,ccorrelativo,idcta,ndebe,nhaber,1,vd)<1 Then
		This.deshacercambios()
		This.cmensaje=_Screen.obancos.cmensaje
		Return 0
	Endif
	If This.Grabarcambios()<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registraoperacion(idctab,dfecha,coperacion,mpago,cdetalle,idclpr,ccorrelativo,idcta,ndebe,nhaber)
	Set DataSession To This.idsesion
	This.dfecha=dfecha
	This.correlativo=ccorrelativo
	If This.iniciatransaccion()<1 Then
		Return 0
	Endif
	nidb=This.IngresaDatos(idctab,dfecha,coperacion,mpago,cdetalle,0,idclpr,ccorrelativo,idcta,ndebe,nhaber,1,idclpr)
	If nidb<1 Then
		This.deshacercambios()
		Return 0
	Endif
	This.idb=nidb
	Endfunc
	Function IngresaDatos(np1,np2,np3,np4,np5,np6,np7,np8,np9,np10,np11,np12,np13)
	lc='FUNIngresaCajaBancos'
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
	TEXT to lp noshow
     (?goapp.npara1,?goapp.npara2,?goapp.npara3,?goapp.npara4,?goapp.npara5,?goapp.npara6,?goapp.npara7,?goapp.npara8,?goapp.npara9,
      ?goapp.npara10,?goapp.npara11,?goapp.npara12,?goapp.npara13)
	ENDTEXT
	nidb=This.EJECUTARF(lc,lp,cur)
	If nidb<1 Then
		Return 0
	Endif
	Return nidb
	Endfunc
	Function cancelacreditos()
	Select atmp
	Scan All
		If CancelaCreditosCb(This.correlativo,atmp.saldo,'P',atmp.moneda,Iif(Empty(atmp.detalle),This.detalle,atmp.detalle),;
				this.dfecha,atmp.fevto,atmp.tipo,atmp.ncontrol,atmp.nrou,atmp.idrc,Id(),goapp.nidusua,This.idb)=0 Then
			q=0
			Exit
		Endif
		Select atmp
	Endscan
	Endfunc
	Function canceladeudas(cndoc,nd,idclpr,cmoneda,nidtda,nmp)
	Do Case
	Case this.ncontrol>0
		Select atmp
		Scan All
			If CancelaDeudasCb(this.dfecha,atmp.fevto,atmp.saldo,cndoc,'P',atmp.moneda,this.detalle,atmp.tipo,atmp.idrd,goapp.nidusua,atmp.ncontrol,'',Id(),nd,this.idb)=0 Then
				q=0
				Exit
			Endif
		Endscan
	Case this.ncontrol=-1
		ur=IngresaCabeceraDeudas(0,idclpr,Left(cmoneda,1),this.dfecha,0,goapp.nidusua,nidtda,Id())
		If ur=0 Then
			RETURN 0
		Endif
		nidd=CancelaDeudasCb(this.dfecha,this.dfecha,nmp,cndoc,'P',cmoneda,this.cdetalle,'F',ur,goapp.nidusua,nidd,'',Id(),nd,this.idb)
		If nidd=0 Then
			RETURN 0
		Endif
	Endcase
	Endfunc
Enddefine
