#Define MSGTITULO 'SISVEN'
Define Class ventaskya As ventas Of 'd:\capass\modelos\ventas.prg'
	Function createmporalpedidos(calias)
	Create Cursor unidades(uequi N(7,4),ucoda N(8),uunid c(15),uitem N(4),uprecio N(12,6),uidepta N(8),ucosto N(10,2))
	Create Cursor (calias)(Descri c(150),unid c(15),cant N(10,2),Prec N(13,8),nreg N(8),pmayor N(8,2),pmenor N(8,2),nitem N(4),;
		importe N(12,2),ndoc c(12),costo N(13,8),pos N(3),tdoc c(2),Form c(1),tipro c(1),alma N(10,2),Item N(4),coda N(8),Valida c(1),uno N(12,2),Dos N(12,2),;
		tre N(12,2),cua N(12,2),calma c(3),idco N(8),codc N(8),aprecios c(1),come N(7,4),Comc N(7,4),equi N(12,8),prem N(12,8),idepta N(8),;
		duni c(4),tigv N(6,4),npagina N(3),caant N(10,2),cletras c(150),validas c(1),valida1 c(1),fech d,direccion c(180),razon c(150),;
		copia c(1),Impo N(12,2),ndni c(8))
	Select (calias)
	Index On Descri Tag Descri
	Index On nitem Tag items
	Endfunc
	Function imprimirenbloque(calias)
	This.createmporalpedidos('tmpv')
	Select rid
	Go Top
	sw=1
	Do While !Eof()
		cimporte=""
		cimporte=Diletras(rid.Impo,'S')
		xid=rid.idauto
		nimporte=rid.Impo
		TEXT TO lc NOSHOW TEXTMERGE
		    SELECT a.ndoc,a.fech,a.tdoc,a.impo,b.idart,
		    left(concat(trim(f.dcat),' ',substr(c.descri,instr(c.descri,',')+1),' ',substr(c.descri,1,instr(c.descri,',')-1)),150) as descri,
		    b.kar_unid as unid,b.cant,b.prec,e.razo,e.dire,e.ciud,e.ndni FROM fe_rcom as a
			inner join fe_kar as b on b.idauto=a.idauto
			inner join fe_clie as e on e.idclie=a.idcliente
			inner join fe_art as c on c.idart=b.idart
			inner join fe_cat as f on f.idcat=c.idcat
			where a.acti='A' and b.acti='A' and  a.idauto=<<rid.idauto>> order by b.idkar
		ENDTEXT
		If This.EjecutaConsulta(lc,'xtmpv') <1 Then
			sw=0
			Exit
		Endif
		Select ndoc,fech,tdoc,Impo,Descri As Desc,unid As duni,cant,Prec,razo,Dire,ciud,ndni,cimporte As cletras,Recno() As nitem,unid,idart As coda From xtmpv Into Cursor xtmpv
		ni=0
		Select xtmpv
		Scan All
			cndoc=xtmpv.ndoc
			ni=ni+1
			Insert Into tmpv(ndoc,nitem,cletras,tdoc,fech,Descri,duni,cant,Prec,razon,direccion,ndni,unid,Impo,coda);
				Values(cndoc,ni,cimporte,xtmpv.tdoc,xtmpv.fech,xtmpv.Desc,xtmpv.duni,xtmpv.cant,xtmpv.Prec,xtmpv.razo,Alltrim(xtmpv.Dire)+' '+Alltrim(xtmpv.ciud),;
				xtmpv.ndni,xtmpv.unid,nimporte,xtmpv.coda)
		Endscan
		Select tmpv
		For x=1 To 17-ni
			ni=ni+1
			Insert Into tmpv(ndoc,nitem,cletras,Impo)Values(cndoc,ni,cimporte,nimporte)
		Next
		Select rid
		Skip
	Enddo
	If sw=0 Then
		Return 0
	Else
		Return 1
	Endif
	Endfunc
	Function mostrardctoparanotascredito(np1,ccursor)
	TEXT TO lc NOSHOW TEXTMERGE
	   SELECT a.idart,a.descri,k.kar_unid as unid,k.cant,k.prec,k.codv,
	   ROUND(k.cant*k.prec,2) as importe,r.idauto,r.mone,r.valor,r.igv,r.impo,kar_comi as comi,k.alma,kar_equi,
	   r.fech,r.ndoc,r.tdoc,r.dolar as dola,kar_cost FROM fe_rcom as r
	   inner join fe_kar as k on k.idauto=r.idauto
	   inner join fe_art as a on a.idart=k.idart
	   WHERE r.idauto=<<np1>> order By  idkar
	ENDTEXT
	If This.EjecutaConsulta(lc,ccursor)<1 Then
		Return 0
	Endif
	Return 1
	Endfunc
Enddefine
