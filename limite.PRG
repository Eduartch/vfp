goACC = Create("VEActiveConnectionsController")
goACC.SharedFolder = Sys(5)+Sys(2003)
cEstacion = goACC.WORKSTATIONID


aqui te mando el codigo:


Define Class VEActiveConnectionsController As Custom
*
	SharedFolder = ".\"  && Ubicacion de la carpeta compartida a utilizar para crear los archivos de marca
	MaxConnections = 0   && Nro. máximo de conexiones permitidas
	WORKSTATIONID = ""   && ID de la estacion. Si no se indica, se asume el nombre del equipo.
	MarkFileExt = "ACM"  && Extension de los archivos de marca. Si no se indica se asume .ACM
	LastError = "" 	  && Texto del ultimo error ocurrido
	checkConnectionEvery = 0  && Frecuencia (en minutos) para la verificacion del archivo de marca (0 = nunca)
	onConnectionLost = ""     && Codigo a ejecutar si la conexion con el archivo de marca se pierde
	Hidden nFH			  && Handle del archivo de marca correspondiente al proceso actual
	Hidden oTimer1       && Timer para verificacion de estado de conexion


* Class constructor
* Constructor de la clase
*
	Proc Init()
*
	This.WORKSTATIONID = Allt(Left(Sys(0),At("#",Sys(0)) - 1))
	This.nFH = 0
	This.oTimer1 = Create("VEACCTimer")
	This.oTimer1.Enabled = .F.
*
	Endproc


* GetCurrentMarkFile
* Devuelve el nombre y ruta del archivo de marca correspondiente
* a la estacion actual
*
	Proc GetCurrentMarkFile()
*
	Local cMarkFile
	cMarkFile=Forceext(This.WORKSTATIONID,This.MarkFileExt)
	cMarkFile=Forcepath(cMarkFile,This.SharedFolder)
	cMarkFile=Lower(cMarkFile)

	Return cMarkFile
*
	Endproc


* GetActiveConnectionsCount
* Devuelve el nro. de conexiones concurrentes activas. Esto se logra
* contanto cuantos archivos existentes en la carpeta compartida aun
* estan bloqueados por otro proceso.
*
	Proc GetActiveConnectionsCount()
*
	Local nActiveCount,nCount,i,cFile,nFH
	Local Array aFiles[1]
	nCount=Adir(aFiles,Addbs(This.SharedFolder)+"*."+This.MarkFileExt)
	nActiveCount = 0

	For i=1 To nCount
*
* Se obtiene el nombre y ubicacion del archivo de marca a validar
		cFile=Lower(Forcepath(aFiles[i,1],This.SharedFolder))

* Se intenta abrir el archivo de marca para escritura
		nFH=Fopen(cFile,1)

* Si no se pudo abrir el archivo significa que hay un proceso activo
* que aun lo tiene bloqueado, por lo que se cuenta como una conexion
* activa, de lo contrario se cierra el archivo y se elimina pues
* corresponde a una conexion que termino anormalmente (ya que si
* hubiera terminado normalmente, el archivo habria sido borrado por
* la aplicacion directamente).
		If nFH < 0
			nActiveCount=nActiveCount + 1
		Else
			Fclose(nFH)
			Erase (cFile)
		Endif
*
	Endfor


	Return nActiveCount
*
	Endproc


* Connect
* Determina si hay conexiones disponibles y procede a crear
* un archivo de marca. El metodo devuelte:
*
* 1  si se pudo crear la conexion
* 0  si no hay conexiones disponibles
* -1 la estacion ya esta conectada
* -2 si no se pudo crear el archivo de marca
*
	Proc Connect()
*
* Se determina la cantidad de conexiones activas
	Local nActiveCount
	nActiveCount = This.GetActiveConnectionsCount()

* Si no hay mas conexiones disponibles, se cancela
* en este punto. Se utiliza >= y no solo = por razones
* de programacion defensiva.
	If nActiveCount >= This.MaxConnections
		This.LastError = "No hay conexiones disponibles"
		Return 0
	Endif

* Si ya exite un archivo de marca para la estacion, se
* cancela pues se asume que el programa ya esta en
* ejecucion en la estacion
	Local cMarkFile
	cMarkFile = This.GetCurrentMarkFile()
	If File(cMarkFile)
		This.LastError = "Esta estación ya está conectada al programa Armagedon"
		Return -1
	Endif


* Se crea el de marca
	This.nFH = Fcreate(cMarkFile)
	If This.nFH < 0
		This.LastError = "No se pudo crear el archivo " + cMarkFile
		Return -2
	Endif

* Si se indico un intervalo para verificar la conexion, se configura el timer y se inicia
	If This.checkConnectionEvery > 0
		This.oTimer1.Set(This)
	Endif

	Return 1
*
	Endproc



* Disconnect
* Libera el archivo de marca correspondiente al proceso actual
*
	Proc Disconnect()
*
* Si no hay un archivo de marca creado, se cancela
	If This.nFH = 0
		Return
	Endif

* Se cierra y elimina el archivo de marca
	Local cMarkFile
	cMarkFile = This.GetCurrentMarkFile()
	Fclose(This.nFH)
	Erase (cMarkFile)

* Se libera el timer de verificacion
	This.oTimer1.Clear()
*
	Endproc

	Proc foo
	Fclose(This.nFH)
	Endproc

* IsAlive
* Determina si el archivo de marca aun es valido
*
	Proc IsAlive
*
* Si no hay un archivo de marca creado, se cancela
	If This.nFH = 0
		Return .F.
	Endif

	Return Fflush(This.nFH)
*
	Endproc
*
Enddefine


* VEACCTimer
* Timer de verificacion de conexion para VEActiveConnectionController
*
Define Class VEACCTimer As Timer
*
	Target = Null

	Procedure Set(poTarget)
	This.Target = poTarget
	This.Interval = poTarget.checkConnectionEvery * 60 * 1000
	This.Enabled = .T.
	Endproc

	Procedure Timer
	This.Enabled = .F.

	If This.Target.IsAlive()
		This.Enabled = .T.
		Return
	Endif
	If !Empty(This.Target.onConnectionLost)
		Local cCmd
		cCmd = This.Target.onConnectionLost
		If " 06.00" $ Version()
			&cCmd
		Else
			Execscript(cCmd)
		Endif
	Endif
	Endproc

	Procedure Clear
	This.Enabled = .F.
	This.Target = Null
	Endproc
*
Enddefine
