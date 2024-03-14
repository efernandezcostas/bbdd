/*

\i C:/Users/kiike/Documents/sql/

2) trigger tlimitepolizap
trigger que impida que unha mesma poliza teña mais de 2 asegurados

insert into asegurado values ('p15',3,'agapito','2/3/2000','a1');
    a poliza xa ten dos asegurados, rexeitado o terceiro
insert into asegurado values ('p14',3,'agapito','2/3/2000','a1');
    realizada insercion de novo asegurado

    */

drop trigger if exists tlimitepolizap on asegurado;

create or replace function ftlimitepolizap() returns trigger language plpgsql as $$
declare
    vcount integer;

begin
    select count(codp) into vcount from asegurado where codp=new.codp;
    if vcount>=2 then
        raise exception 'a poliza xa tengo 2 asegurados, rexeitado';
    else
        raise notice 'inserción realizada';
    end if;

    return new;

end;$$
;
create trigger tlimitepoliza before insert on asegurado for each row execute procedure ftlimitepolizap();