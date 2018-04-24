-- Q1:
create table treballadors (num_treballador integer primary key, salari integer, usuari char(30));

create table usuari_actual(usuari char(10));

insert into usuari_actual values('bd0003');


CREATE or replace FUNCTION auditoria() RETURNS trigger AS $$
DECLARE
us char(30);
BEGIN
      us := (select usuari from usuari_actual); 
      update treballadors set usuari=us where num_treballador = NEW.num_treballador;
      RETURN NULL;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER ex172 AFTER INSERT ON treballadors  FOR EACH ROW EXECUTE PROCEDURE auditoria();

/*
Es desitja saber en tot moment quin usuari ha inserit cadascuna de les tuples de la taula Treballadors del fitxer adjunt. Es vol utilitzar per guardar aquesta informació l'atribut "usuari" de la taula Treballadors. 

Per mantenir aquesta informació disposem ja d'un disparador (que també podeu trobar al fitxer adjunt). Aquest disparador agafa com a nom de l'usuari que fa la inserció, el que es troba a l'única fila de la taula Usuari_actual. 

Implementar una solució alternativa que redueixi el nombre d'accessos a la base de dades. Aquesta solució alternativa s'ha de basar en aprofitar les possibilitats que dóna la variable NEW. A l'hora de fer aquest exercici és especialment important haver entès la transparència 220 i l'exemple de la 229.

Pel joc de proves que trobareu al fitxer adjunt,i després de l'execució de lles sentències: 
insert into treballadors values(1,1000,NULL); 
insert into treballadors values(2,2000,NULL); 
l'extensió de la taula Treballadors ha de ser:

num_treballador		salari		usuari
1		1000		bd0003
2		2000		bd0003
*/

-- Solución:
CREATE or replace FUNCTION auditoria() RETURNS trigger AS $$
	DECLARE
us char(30);
BEGIN
      us := (select usuari from usuari_actual); 
		new.usuari = us;
      RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER ex172 BEFORE INSERT ON treballadors  FOR EACH ROW EXECUTE PROCEDURE auditoria();