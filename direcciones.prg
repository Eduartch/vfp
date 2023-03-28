Define Class direcciones As Odata Of 'd:\capass\database\data.prg'
	cdireccion=""
	nid=0
	nidclie=0
	Function listar(ccur)
	Local lc
	TEXT To m.lc NOSHOW TEXTMERGE
     select dire_dire,dire_acti,dire_iddi,dire_idcl,dire_iddi FROM fe_direcciones WHERE dire_idcl=<<this.nidclie>> and dire_acti='A' ORDER BY dire_dire
	ENDTEXT
	If  This.ejecutaconsulta(lc,ccur)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
	Function registrar()
	If This.validar()<1 Then
		Return 0
	Endif
	TEXT TO lc NOSHOW  TEXTMERGE
	     INSERT INTO fe_direcciones(dire_dire,dire_idcl)values('<<this.cdireccion>>',<<this.nidclie>>)
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	This.cmensaje="Agregado Ok"
	Return  1
	Endfunc
	Function actualizar()
	If This.validar()<1 Then
		Return 0
	Endif
	TEXT TO lc NOSHOW  TEXTMERGE
	     UPDATE fe_direcciones SET dire_dire='<<this.cdireccion>>' WHERE dire_iddi=<<this.nid>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	This.cmensaje="Actualizado Ok"
	Endfunc
	Function validar()
	Do Case
	Case Empty(This.cdireccion)
		This.cmensaje="Ingrese la Dirección"
		Return 0
	Case This.nidclie=0
		This.cmensaje="Seleccione un Cliente Para Registar Direcciones"
		Return 0
	Otherwise
		Return 1
	Endcase
	Endfunc
	Function desactivar()
	TEXT TO lc NOSHOW TEXTMERGE
	     UPDATE fe_direcciones SET dire_acti='I' WHERE dire_iddi=<<this.nid>>
	ENDTEXT
	If This.ejecutarsql(lc)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
