-- Q1:
-- Sentències de preparació de la base de dades:
create table empleats(
                 nempl integer primary key,
                 salari integer);

create table missatgesExcepcions(
	num integer, 
	texte varchar(100));

insert into missatgesExcepcions values(1,'No es pot esborrar l''empleat 123 ni modificar el seu número d''empleat');

-- Sentències d'esborrat de la base de dades:
drop table empleats;
drop table missatgesExcepcions;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
insert into empleats values(1,1000);
insert into empleats values(2,2000);
insert into empleats values(123,3000);

-- Dades d'entrada o sentències d'execució:
delete from empleats where nempl=123;

/*
Implementar mitjançant disparadors la restricció d'integritat següent:
No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències: 
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__; (el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;
La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que l'atribut corresponent de l'esquema de la base de dades.

Pel joc de proves que trobareu al fitxer adjunt i la instrucció: 
DELETE FROM empleats WHERE nempl=123; 
La sortida ha de ser: 

No es pot esborrar l'empleat 123 ni modificar el seu número d'empleat
*/

-- Solución:
create or replace function no_tocar123() returns trigger as $$ 
declare
	missatge varchar(100);
begin
	
	if (old.nempl = 123) then
	-- raise notice 'IF';
	SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
	RAISE EXCEPTION '%',missatge;
	else
		-- raise notice 'ELSE';
		if(tg_op = 'DELETE') then return old;
		elseif (tg_op = 'UPDATE') then return new;
		end if;
	end if;
	
	EXCEPTION
  		WHEN raise_exception THEN 
  			RAISE EXCEPTION '%', SQLERRM;
end;
$$ language plpgsql;


create trigger modificar123 before update of nempl on empleats
for each row execute procedure no_tocar123();

create trigger esborrar123 before delete on empleats
for each row execute procedure no_tocar123();




-- Q2:
CREATE TABLE empleats(
  nempl integer primary key,
  salari integer);

insert into empleats values(1,1000);

insert into empleats values(2,2000);

insert into empleats values(123,3000);

CREATE TABLE dia(
dia char(10));

insert into dia values('dijous');

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'No es poden esborrar empleats el dijous');

/*
Implementar mitjançant disparadors la restricció d'integritat següent: 
No es poden esborrar empleats el dijous
Tigueu en compte que:
- Les restriccions d'integritat definides a la BD (primary key, foreign key,...) es violen amb menys freqüència que la restricció comprovada per aquests disparadors.
- El dia de la setmana serà el que indiqui la única fila que hi ha d'haver sempre insertada a la taula "dia". Com podreu veure en el joc de proves que trobareu al fitxer adjunt, el dia de la setmana és el 'dijous'. Per fer altres proves podeu modificar la fila de la taula amb el nom d'un altre dia de la setmana. IMPORTANT: Tant en el programa com en la base de dades poseu el nom del dia de la setmana en MINÚSCULES.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències: 
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__;(el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;
La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que l'atribut corresponent de l'esquema de la base de dades. 

Pel joc de proves que trobareu al fitxer adjunt i la instrucció:
DELETE FROM empleats WHERE salari<=1000 
la sortida ha de ser: 

No es poden esborrar empleats el dijous
*/

-- Solución:
create or replace function no_esborrar() returns trigger as $$
declare
	missatge varchar(100);
	dia2 varchar(10);
begin
	select dia into dia2 from dia;
	if(dia2 = 'dijous') then
	SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
	RAISE EXCEPTION '%',missatge;
	else return old;
	end if;

	EXCEPTION
  		WHEN raise_exception THEN 
  			RAISE EXCEPTION '%', SQLERRM;
end;
$$ language plpgsql;


create trigger dijous before delete on empleats
for each statement execute procedure no_esborrar();




-- Q3:
-- Sentències de preparació de la base de dades:
CREATE TABLE empleats(
  nempl integer primary key,
  salari integer);

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'Suma sous esborrats >  Suma sous que queden');

CREATE TABLE TEMP(
             x integer ,
             y integer);

-- Sentències d'esborrat de la base de dades:
drop table empleats;
drop table missatgesExcepcions;
drop table temp;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
insert into empleats values(1,1000);
insert into empleats values(2,2500);
insert into empleats values(123,3000);

-- Dades d'entrada o sentències d'execució:
delete from empleats where salari<=2500;

-- Resultat esperat:
P0001, 0, ERROR: Suma sous esborrats >  Suma sous que queden.

/*
Implementar mitjançant disparadors la restricció d'integritat següent: 
La suma dels sous dels empleats esborrats en una instrucció delete, no pot ser superior a la suma dels sous dels empleats que queden a la BD després de l'esborrat.
Tigueu en compte que:
- Per resoldre aquest exercici podeu utilitzar la taula temporal que trobareu al fitxer adjunt. 

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu trobar definida (amb els inserts corresponents) al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències: 
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__;(el número que sigui, depenent de l'error)
RAISE EXCEPTION '%',missatge;
La variable missatge ha de ser una variable definida al vostre procediment, i del mateix tipus que l'atribut corresponent de l'esquema de la base de dades. 

Pel joc de proves que trobareu al fitxer adjunt i la instrucció: 
DELETE FROM empleats WHERE salari<=2500 
la sortida ha de ser: 

Suma sous esborrats > Suma sous que queden 
*/

-- Solución:
create or replace function sum1() returns trigger as $$
declare
	x INTEGER;
begin
delete from TEMP;
select SUM(salari) into x from empleats;
insert into TEMP values (x,0);
return null;
end;
$$ language plpgsql;
create trigger before_sum1 before delete on empleats for each statement execute procedure sum1();

create or replace function sum2() returns trigger as $$
declare
	xi INTEGER;
	yi INTEGER;
	missatge varchar(100);
begin
select x into xi from TEMP;
update TEMP  set y = y + OLD.salari;
select y into yi from TEMP;
if (yi >= xi - yi) then
        SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
        RAISE EXCEPTION '%',
		missatge;

end if;
return null;
EXCEPTION
        WHEN raise_exception THEN
                RAISE EXCEPTION '%', SQLERRM;
end;
$$ language plpgsql;
create trigger after_sum2 after delete on empleats for each row execute procedure sum2();