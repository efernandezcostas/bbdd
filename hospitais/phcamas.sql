/*
\i C:/Users/kiike/Documents/sql/hospitais/phcamas.sql

    phcamas:

    procedimento que, pasandolle o numero de camas como parametro, devolte os nomes dos hospitais propios que as superan asi como os nomes dos hospitalizados de 1º categoria que estiveron neles, e o seu total. Se ningun hospital propio supera o numero de camas a mensaxe debe ser: 'ningun hospital propio supera ese numero de camas'
    Si agun dos hospitais non ten hospitalizados de 1ª categoria a mensaxe debe ser : 'hospital sen hospitalizados'.

    Ex:
    call phcamas(150);
        hospital: canalejo
        dolores
        dolores
        o numero de hospitalizados e : 2

        hospital: meixoeiro
        hospital sen hospitalizados

        hospital: paz
        andrea
        o numero de hospitalizados e : 1

    Ex:
    call  phcamas(3000);
        ningun hospital propio supera ese numero de camas
*/
create or replace procedure phcamas(vnumc integer) language plpgsql as $$

declare
    r varchar='';
    fchospital record;
    fchosp1 record;
    vnomh varchar;
    vnomas varchar;
    ch integer=0;
    ca integer=0;

begin
    for fchospital in select * from hospital where codh in (select codh from propio) and numc>vnumc loop
        select nomh into vnomh from hospital where codh=fchospital.codh;
        ca=0;
        r=r||'Hospital: '||vnomh||E'\n';

        for fchosp1 in select * from hosp1 where codh=fchospital.codh loop
            select nomas into vnomas from asegurado where codp=fchosp1.codp and numas=fchosp1.numas; 
            r=r||E'\t'||vnomas||E'\n';
            ca=ca+1;
        end loop;

        if ca=0 then
            r=r||E'\t'||'Ningun hospitalizado de 1ª cateria'||E'\n';
        end if;
        ch=ch+1;
    end loop;

    if ch=0 then
        raise notice 'Ningun hospital supera ese numero de camas';
    else
        raise notice '%',r;
    end if;
end;
$$;