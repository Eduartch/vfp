Define Class bajas As Odata Of 'd:\capass\database\data.prg'
	dfi=Date()
	dff=Date()
	codt=0
	Function consultar(ccursor)
	If !Pemstatus(goapp,'cdatos',5) Then
		AddProperty(goapp,'cdatos','')
	Endif
	fi=cfechas(this.dfi)
	ff=cfechas(this.dff)
	If goapp.cdatos='S' Then
		TEXT TO lc NOSHOW TEXTMERGE
		     select baja_fech,baja_tdoc,baja_serie,baja_nume,baja_moti,baja_arch,baja_hash,baja_tick,baja_mens,baja_idau
		     FROM fe_bajas f where f.baja_fech between '<<fi>>' and '<<ff>>'  and  f.baja_acti='A'  and baja_codt=<<this.codt>> order by baja_fech,baja_serie,baja_nume
		ENDTEXT
	Else
		TEXT TO lc NOSHOW TEXTMERGE
		     select baja_fech,baja_tdoc,baja_serie,baja_nume,baja_moti,baja_arch,baja_hash,baja_tick,baja_mens,baja_idau
		     FROM fe_bajas f where f.baja_fech between '<<fi>>' and '<<ff>>'  and  f.baja_acti='A' order by baja_fech,baja_serie,baja_nume
		ENDTEXT
	Endif
	If This.ejecutaconsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
