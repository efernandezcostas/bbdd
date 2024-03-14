
/*
    \i C:/Users/kiike/Documents/sql/hospitais/creahospitaisp.sql
    \i C:/Users/kiike/Documents/sql/hospitais/phospitalp.sql

    phospitalp
    procedimento que, pasandolle o nome dun hospital, imprima os nomes dos asegurados de 1ª categoria que foron hospitalizados nel .
    Se non ten asegurados de primeira categoria hospitalizados debe imprimirse a mensaxe 'este hospital non ten asegurados de 1º categoria hospitalizados'  
    Se o hospital non existe debe imprimirse a mensaxe adecuada (mediante tratamento de excepcions) .

    call phospitalp ('povisa');
    andrea
    dorotea

    call phospitalp ('sonic');
    este hospital non ten asegurados de 1º categoria hospitalizados

    execute phospital ('roma');
    este hospital non existe
*/

create or replace procedure phospitalp(vnomh varchar) language plpgsql as $$
declare
    fcnomes record;
    vcodh varchar;
    vnomas varchar;
    r varchar='';
    c integer=0;

begin
    select codh into strict vcodh from hospital where nomh=vnomh;
    r=r||'Asegurados de 1ª categoria no hospital: '||vnomh||E'\n';
    for fcnomes in select * from hosp1 where codh=vcodh loop
        select nomas into vnomas from asegurado where codp=fcnomes.codp and numas=fcnomes.numas;
        r=r||E'\t'||'Nome: '||vnomas||E'\n';
        c=c+1;
    end loop;

    if c=0 then
        r=r||E'\t'||'Este hospital non ten asegurados de 1ª categoria'||E'\n';
    end if;

    raise notice '%', r;

exception 
    when no_data_found then
        raise notice 'Este hospital non existe';

end;
$$;