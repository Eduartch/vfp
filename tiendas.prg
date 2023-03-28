Define Class tienda As Odata Of 'd:\capass\database\data.prg'
	Function Muestratiendas(ccursor)
*!*		If !Pemstatus(_Screen,'conectado',5)
*!*			_Screen.AddProperty('conectado','')
*!*		Endif
*!*		If _Screen.conectado<>'S' Then
	lc="PROMUESTRAALMACENES"
	lp=""
	If This.EJECUTARP(lc,lp,ccursor)<1 Then
		Return 0
	Endif
*!*			Select (ccursor)
*!*			=Afields(estructura)
*!*			_Screen.AddProperty("salmacenes",estructura)
*!*			Select * From (ccursor) Into Array nlista1
*!*			_Screen.AddProperty("almacenes[1]")
*!*			Acopy(nlista1,_Screen.almacenes)
*!*			Acopy(estructura,_Screen.salmacenes)
*!*			wait WINDOW 'hola 3'
*!*			_Screen.conectado='S'
*!*			Wait Window 'estado conexion '+_Screen.conectado
*!*		Else
*!*			Wait Window 'estado conexion Ya No consultando BBDD '+_Screen.conectado
*!*			Create Cursor (ccursor) From Array _Screen.salmacenes
*!*			Insert Into (ccursor) From Array _Screen.almacenes
*!*		Endif
*!*		Select (ccursor)
*!*		Go Top
	Return 1
	Endfunc
	Function Muestratiendasx(ccursor)
	Set DataSession To This.idsesion
	lc="PROMUESTRAALMACENES"
	If This.EJECUTARP(lc,"",ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
