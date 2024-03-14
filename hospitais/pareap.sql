
/*
\i C:/Users/kiike/Documents/sql/hospitais/creahospitaisp.sql
\i C:/Users/kiike/Documents/sql/hospitais/

parea
procedemento que liste os codigos de todas as areas e para cada codigo de area os nomes dos asegurados de dita area xunto co numero total deles.
Se un area non ten asegurados debe imprimirse a mensaxe: area sen asegurados:

puntuacion:
amosar codigos de area: .5
amosar nomes de asegurados: 1
amosar numero total de asegurados: .25
amosar 'area sen asegurados' : .25 



call parea();

codigo de area: a1
luis
ana
numero de asegurados: 2
codigo de area: a2
pedro
juan
carlos
numero de asegurados: 3
codigo de area: a3
bieito
numero de asegurados: 1
codigo de area: a4
xoan
eva
comba
ainara
numero de asegurados: 4
codigo de area: a5
dorotea
elisa
amalia
dolores
maria
xose
andrea
iria
antia
xana
numero de asegurados: 10
codigo de area: a6
area  sen asegurados
codigo de area: a7
jose
numero de asegurados: 1

*/

create or replace procedure pareap() language plpgsql as $$
declare
    r varchar='';
    c integer=0;
    fcarea record;
    fcasegurado record;

begin
    for fcarea in select * from area loop
        r=r||'Codigo del area: '||fcarea.coda||E'\n';
            c=0;
        for fcasegurado in select * from asegurado where coda=fcarea.coda loop
            r=r||E'\t'||'Nombre del asegurado: '||fcasegurado.nomas||E'\n';
            c=c+1;
        end loop;
        if c=0 then
            r=r||E'\t'||'Area sen asegurados'||E'\n';
        else
            r=r||E'\t'||'Numero de asegurados: '||c||E'\n';
        end if;
    end loop;

    raise notice '%', r;

end;
$$;
