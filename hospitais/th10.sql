/*
\i C:/Users/kiike/Documents/sql/hospitais/creahospitaisp.sql
\i C:/Users/kiike/Documents/sql/hospitais/th10.sql

    th10 
    impedir que se poida hospitalizar a un asegurado de 2ª categoría si o médico que realiza a hospitalización non esta adscrito a mesma area da que procede o paciente

    insert into hosp2 values('h1','p11',1,'m1','1/1/1970','1/2/1970');
    -- o médico  non esta adscrito a mesma area da que procede o paciente
    insert into hosp2 values('h1','p1',1,'m1','1/1/1970','1/2/1970');
    --asegurado non existente ou non de 2ª categoria
    insert into hosp2 values('h1','p1',2,'m1','1/1/1970','1/2/1970');
    -- inserción levada a cabo

*/

drop trigger if exists th10 on hosp2;

create or replace function fth10() returns trigger language plpgsql as $$

declare
    vmcoda varchar;
    vpcoda varchar;

begin
    select coda into vmcoda from adscrito where codm=new.codm;
    select coda into vpcoda from asegurado, a2c where asegurado.codp=new.codp and a2c.codp=new.codp and asegurado.numas=new.numas and a2c.numas=new.numas;
    if vmcoda=vpcoda then
        raise notice 'Insercion levada a cabo';
    else
        if vmcoda is null or vpcoda is null then
            raise exception 'Asegurado non existente ou non da 2ª categoria';
        else
            raise exception 'O medico non esta adscrito na mesma area que o paciente';
        end if;
    end if;

    return new;

end;
$$;
create trigger th10 before insert on hosp2 for each row execute procedure fth10();