/*

\i C:/Users/kiike/Documents/sql/

1) trigger timpidep
trigger que impida que un asegurado de 2ª categoria poda rexistrarse tamen como asegurado de 1ª categoría
 
 insert into a1c values('p15',1);
   o asegurado xa o e de 2ª categoria
 insert into a1c values('p15',2);
   realizada insercion de asegurado de 1ª categoria
*/

drop trigger if exists timpidep on a1c;

create or replace function ftimpidep() returns trigger language plpgsql as $$
declare
    vcodp varchar;
    vnumas integer;

begin
    select codp, numas into vcodp, vnumas from a2c where codp=new.codp and numas=new.numas;
    if vcodp is null then
        raise notice 'inserción realizada na 1ª categoría'; 
    else
        raise exception 'o asegurado xa é de 2ª categoría';
    end if;

    return new;

end;$$
;
create trigger timpidep before insert on a1c for each row execute procedure ftimpidep();
