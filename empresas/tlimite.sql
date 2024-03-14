/*
\i C:/Users/kiike/Documents/sql/empresas/empresastodoxuntop.sql
\i C:/Users/kiike/Documents/sql/empresas/tlimite.sql

    tlimite
    valor : 2'5 puntos
    trigger que rexeite  entrevistar a unha persoa para un posto si xa se lle fixeron 2 ou mais entrevistas para outros !postos xestionados polo mesmo  xestor! que o do posto o que se presenta. 

    ex:  insert into entrevista values('p16',5,'f','f');
    ERROR:  non podes entrevistar a esta persoa para dito posto pois xa se lle fixeron 2 entrevistas para outros postos xestionados polo mesmo  xestor que o do posto o que se presenta

    insert into entrevista values('p55',12,'f','f');
    non existe a persoa ou o posto

    insert into entrevista values('p12',55,'f','f');
    non existe a persoa ou o posto


    ex: insert into entrevista values('p12',5,'f','f');
    NOTICE:   entrevista aceptada pois a persoa non tiña todavia duas  entrevistas co mesmo xestor deste posto
*/

drop trigger if exists tlimite on entrevista;

create or replace function ptlimite() returns trigger language plpgsql as $$
declare
    vcodxestor varchar;
    vnumpersoa integer;
    vcont integer=0;

begin
    select cod_xestor into vcodxestor from postos where cod_posto=new.cod_posto;
    select num_persoa into vnumpersoa from persoas where num_persoa=new.num_persoa;
    if vcodxestor is null or vnumpersoa is null then
        raise exception 'non existe a persoa ou o posto';
    else
        select count(cod_posto) into vcont from postos where cod_xestor=vcodxestor and cod_posto in (select cod_posto from entrevista where num_persoa=vnumpersoa);
        if vcont>=2 then
            raise exception 'non podes entrevistar a esta persoa para dito posto pois xa se lle fixeron 2 entrevistas para outros postos xestionados polo mesmo  xestor que o do posto o que se presenta';
        else
            raise notice 'entrevista aceptada pois a persoa non tiña todavia duas  entrevistas co mesmo xestor deste posto';
        end if;
    end if;

    return new;

end;
$$;
create trigger tlimite before insert on entrevista for each row execute procedure ptlimite();





