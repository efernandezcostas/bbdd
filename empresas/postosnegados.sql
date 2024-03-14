
/*
\i C:/Users/kiike/Documents/sql/empresas/empresastodoxuntop.sql
\i C:/Users/kiike/Documents/sql/empresas/postosnegados.sql

    procedemento postosnegados  que dado o dni dunha persoa devolte a lista dos postos de traballo para os que non  poderia  ser entrevistada debido a que algunhas empresas rexeitan a dita persoa.
    call postosnegados('36202020');
    p2
    p9
    p13
    p8
    p14
    p15
    p16
    p17
    esta persoa e rexeitada para un total de 8 postos

    execute postosnegados('36222222');
    esta persoa e entrevistable para calquera posto de calqueira empresa
*/

create or replace procedure postosnegados(vdni varchar) language plpgsql as $$

declare
    fcpostos record;
    vcodposto varchar;
    c integer=0;
    r varchar=E'\n';

begin
    for fcpostos in select cod_posto from postos where cod_empresa in (select cod_empresa from empresas where cod_empresa in (select cod_empresa from rexeita where num_persoa in (select num_persoa from persoas where dni=vdni))) loop
        select cod_posto into vcodposto from postos where cod_posto=fcpostos.cod_posto;
        r=r||vcodposto||E'\n';
        c=c+1;
    end loop;
    if c=0 then
        raise notice 'esta persoa e entrevistable para calquera posto de calquera empresa';
    else
        r=r||'Esta persoa e rexeitada para un total de '||c||' postos'||E'\n';
        raise notice '%',r;
    end if;
end;
$$;