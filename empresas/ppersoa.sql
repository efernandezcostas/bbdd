/*
\i C:/Users/kiike/Documents/sql/empresas/empresastodoxuntop.sql
\i C:/Users/kiike/Documents/sql/empresas/ppersoa.sql

    ppersoa
    procedemento chamdo ppersoa que amose para unha persoa cuxo dni se pasa por parámetro o seu nome e os postos para os que se lle fixeron entrevistas e o nome e apelidos do xestor que llas fixo 

    call ppersoa('36555555');

    persoa: elisa,bermudez,bastos
    postos e xestor que o xestionou:
    p1 : ricardo,leiro,suarez
    p342 : eva,bastos,boullosa
    p14 : ricardo,leiro,suarez
*/

create or replace procedure ppersoa(vdni varchar) language plpgsql as $$

declare
    r varchar='';
    vnompersoa varchar;
    vap1persoa varchar; 
    vap2persoa varchar;
    vnumpersoa integer;
    fcpostos record;
    vnomxestor varchar;
    vap1xestor varchar;
    vap2xestor varchar;
    vcodposto varchar;
    
    

begin
    select nom_persoa, ap1_persoa, ap2_persoa, num_persoa into vnompersoa, vap1persoa, vap2persoa, vnumpersoa from persoas where dni=vdni;
    r=r||vnompersoa||', '||vap1persoa||', '||vap2persoa||E'\n';
    r=r||'postos e xestor que o xestionou:'||E'\n';

    for fcpostos in select * from postos where cod_posto in (Select cod_posto from entrevista where num_persoa=vnumpersoa) loop
        select cod_posto into vcodposto from entrevista where cod_posto=fcpostos.cod_posto;
        select nom_xestor, ap1_xestor, ap2_xestor into vnomxestor, vap1xestor, vap2xestor from xestores where cod_xestor=fcpostos.cod_xestor;
        r=r||vcodposto||': '||vnomxestor||', '||vap1xestor||', '||vap2xestor||E'\n';
    end loop;

    raise notice '%',r;

end;
$$;