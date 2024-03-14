/*
\i C:/Users/kiike/Documents/sql/hospitais/creahospitaisp.sql
\i C:/Users/kiike/Documents/sql/hospitais/

3) trigger  th1p 
impedir que se poida hospitalizar a un asegurado de 1ª categoría nun hospital concertado si o médico non está adscrito a mesma area que ten asignada dito hospital concertado. En caso contrario debe levarse a cabo a hospitalizacion.
Se o asegurado ( sempre nos referimos ao de 1ª categoria) se hospitaliza nun hospital propio non se ten en conta a restriccion anterir, e decir a hospitalizacion e immediata).

insert into hosp1 values('h8','p4',2,'m1','1/1/1970','1/2/1970');
 o medico non está adscrito a mesma area que ten asignada dito hospital concertado
insert into hosp1 values('h5','p4',2,'m1','1/1/1980','1/2/1980');
inserción levada a cabo
insert into hosp1 values('h1','p4',2,'m1','1/1/1970','1/2/1970');
realizada insercion en hospital propio
*/

drop trigger if exists th1p on hosp1;

create or replace function fth1p() returns trigger language plpgsql as $$
declare
    vmcoda varchar;
    vhcoda varchar;

begin
    select coda into vmcoda from adscrito where codm=new.codm;
    select coda into vhcoda from area where coda in (Select coda from concertado where codh=new.codh);
    if vmcoda!=vhcoda then 
        raise exception 'o médico non está escrito na mesma área';
    elsif vmcoda=vhcoda then
        raise notice 'inserción levada a acabo';
    else
        raise notice 'inserción en hospital propio';
    end if;

    return new;

end;$$
;
create trigger th1p before insert on hosp1 for each row execute procedure fth1p();