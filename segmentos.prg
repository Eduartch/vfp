Define Class segmento As Odata Of 'd:\capass\database\Data.prg'
	nombre = ""
	codigo = 0
	cmodo=""
	Function validarSegmento()
*:Global v
	v=0
	Do Case
	Case Len(Alltrim(This.nombre)) = 0
		This.Cmensaje ='Ingrese La descripción del Segmento'
		v			  =0
	Case This.BuscarSegmentoporNombre()=0
		v=0
		This.Cmensaje ='Ya existe la descripción del Segmento'
	Otherwise
		v=1
	Endcase
	Return v
	Endfunc
	Function BuscarSegmentoporNombre()
	Local lc
	If This.cmodo ='N' Then
		TEXT To m.lc Noshow Textmerge
		  Select  segm_idse, From fe_segmento  Where segm_segm='<<this.nombre>>' limit 1
		ENDTEXT
	Else
		TEXT To m.lc Noshow Textmerge
		  Select  segm_idse From fe_segmento   Where segm_segm='<<this.nombre>>' and segm_idse<><<this.codigo>>  limit 1
		ENDTEXT
	Endif
	If This.EjecutaConsulta(m.lc, 'segmentoyaesta') < 1
		Return 0
	Else
		If segmentoyaesta.segm_idse > 0 Then
			Return 0
		Else
			Return 1
		Endif
	Endif
	Endfunc
	Function crearSegmento()
	This.cmodo='N'
	If This.validarSegmento()<1
		Return 0
	Endif
	TEXT TO lc NOSHOW  TEXTMERGE
		      INSERT INTO fe_segmento (segm_segm)values('<<this.nombre>>')
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function ActualizarSegmento(opt)
	This.cmodo='M'
	If opt=1 Then
		If This.validarSegmento()<1 Then
			Return 0
		Endif
		TEXT TO lc NOSHOW TEXTMERGE
	     UPDATE fe_segmento SET segm_segm='<<this.nombre>>' WHERE segm_idse=<<this.codigo>>
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
	     UPDATE fe_segmento SET segm_acti='I' WHERE segm_idse=<<this.codigo>>
		ENDTEXT
	Endif
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function Mostrarsegmentoscliente(np1, ccursor)
	Local lc
	TEXT To m.lc Noshow Textmerge
	  Select  segm_segm, segm_idse From fe_segmento Where segm_segm Like '<<np1>>'   And segm_acti='A'  Order By segm_idse
	ENDTEXT
	If This.EjecutaConsulta(m.lc, m.ccursor) < 1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
