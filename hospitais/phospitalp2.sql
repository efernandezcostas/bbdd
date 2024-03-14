/*

\i C:/Users/kiike/Documents/sql/hospitais/creahospitaisp.sql
\i C:/Users/kiike/Documents/sql/hospitais/phospitalp2.sql

phospital2
procedemento que amose os nomes de todos os hospitais e para ca un deles os nomes dos medicos que prescribiron  hospitalizacions a asegurados de primeira categoria 
*/

create or replace procedure phospitalp2() language plpgsql as $$

declare
    fchospital record;
    fchosp1 record;
    vnomh varchar;
    vnomm varchar;
    r varchar='';

begin
    for fchospital in select * from hospital loop
        select nomh into vnomh from hospital where codh=fchospital.codh;
        r=r||'Hospital: '||vnomh||E'\n';

        for fchosp1 in select * from hosp1 where codh=fchospital.codh loop
            select nomm into vnomm from medico where codm=fchosp1.codm;
            r=r||E'\t'||'Medico: '||vnomm||E'\n';
        end loop;

    end loop;

    raise notice '%',r;

end;
$$;