-- Q1:
CREATE TABLE DEPARTAMENTS
         (        NUM_DPT INTEGER,
        NOM_DPT CHAR(20),
        PLANTA INTEGER,
        EDIFICI CHAR(30),
        CIUTAT_DPT CHAR(20),
        PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (        NUM_PROJ INTEGER,
        NOM_PROJ CHAR(10),
        PRODUCTE CHAR(20),
        PRESSUPOST INTEGER,
        PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (        NUM_EMPL INTEGER,
        NOM_EMPL CHAR(30),
        SOU INTEGER,
        CIUTAT_EMPL CHAR(20),
        NUM_DPT INTEGER,
        NUM_PROJ INTEGER,
        PRIMARY KEY (NUM_EMPL),
        FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
        FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

create table missatgesExcepcions(
        num integer, 
        texte varchar(50)
        );

insert into missatgesExcepcions values(1,'No es pot esborrar. Hi ha empleats del departament');
insert into missatgesExcepcions values(2,'El departament no existeix');
insert into missatgesExcepcions values(3,'Error Intern');

INSERT INTO  DEPARTAMENTS VALUES (1,'Vendes',10,'World Trade Center','Barcelona');
INSERT INTO  DEPARTAMENTS VALUES (2,'Compres',10,'World','Barcelona');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (1,'Carme',400000,'MATARO',2,1);
INSERT INTO  EMPLEATS VALUES (2,'Eugenia',350000,'TOLEDO',2,1);
INSERT INTO  EMPLEATS VALUES (3,'Josep',250000,'SITGES',2,1);

CREATE OR REPLACE FUNCTION eliminar_dept(numdept integer) RETURNS void AS $$
DECLARE 
   missatge varchar(50);
 
BEGIN

     DELETE FROM departaments WHERE num_dpt = numdept;

     IF NOT FOUND THEN
	   SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=2; 
           RAISE EXCEPTION '%',missatge;
     END IF;

EXCEPTION
   WHEN raise_exception THEN
           RAISE EXCEPTION '%',SQLERRM;
   WHEN OTHERS THEN
           SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=3; 
           RAISE EXCEPTION '%',missatge;

END;
$$LANGUAGE plpgsql;

/*
El procediment inclòs al fitxer adjunt esborra el departament identificat pel número de departament que es passa com a paràmetre. En cas que no es pugui esborrar el departament, el procediment retorna una excepció. Concretament retorna una excepció en cas que el departament no existeix (El departament no existeix), i en cas que en executar el procediment es produeixi qualsevol error de la base de dades (Error intern).

Es vol que feu canvis en aquest procediment per tal de que:
- Quan es produieix l'error número 1 de la taula missatgesExcepcions, salti una nova excepció amb el missatge corresponent. 

Pel joc de proves que trobareu al fitxer adjunt i després de les sentències següents:
SELECT * FROM eliminar_dept(1);
SELECT num_dpt FROM departaments; el resultat ha de l'execució de la segona sentència ha de ser: 

Num_dpt
2
*/

-- Solución:
CREATE OR REPLACE FUNCTION eliminar_dept(numdept integer) RETURNS void AS $$
DECLARE 
   missatge varchar(50);
 
BEGIN

	
	if exists(select * from empleats e where e.num_dpt = numdept) then
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1; 
           RAISE EXCEPTION '%',missatge;
	end if;

     DELETE FROM departaments WHERE num_dpt = numdept;
     IF NOT FOUND THEN
	   SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=2; 
           RAISE EXCEPTION '%',missatge;
     END IF;


EXCEPTION
   WHEN raise_exception THEN
           RAISE EXCEPTION '%',SQLERRM;
   WHEN OTHERS THEN
           SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=3; 
           RAISE EXCEPTION '%',missatge;

END;
$$LANGUAGE plpgsql;



-- Q2:
create table empleats1 (nemp1 integer primary key, nom1 char(25), ciutat1 char(10) not null);

create table empleats2 (nemp2 integer primary key, nom2 char(25), ciutat2 char(10) not null);

create table missatgesExcepcions(
	num integer, 
	texte varchar(100)
	);


insert into missatgesExcepcions values(1,' Els valors de l''atribut ciutat1 d''empleats1  han d''estar inclosos en els valors de ciutat2');

insert into empleats2 values(1,'joan','bcn');

/*
En aquest exercici es tracta de simular una asserció a base de definir disparadors. En concret, es demana definir els disparadors necessaris sobre empleats1 (veure definició de la base de dades al fitxer adjunt) per comprovar la restricció següent:
Els valors de l'atribut ciutat1 de la taula empleats1 han d'estar inclosos en els valors de ciutat2 de la taula empleats2 
La idea és llançar una excepció en cas que s'intenti executar una sentència sobre EMPLEATS1 que pugui violar aquesta restricció.

Cal informar dels errors a través d'excepcions tenint en compte les situacions tipificades a la taula missatgesExcepcions, que podeu trobar definida i amb els inserts corresponents al fitxer adjunt. Concretament en el vostre procediment heu d'incloure, quan calgui, les sentències: 
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=__ (segons l'error 1,2,...);
RAISE EXCEPTION '%',missatge;
La variable missatge ha de ser una variable definida al vostre procediment.

Pel joc de proves que trobareu al fitxer adjunt i la sentència:
INSERT INTO empleats1 VALUES (1,'joan','mad'); 
La sortida ha de ser: 

Els valors de l'atribut ciutat1 d'empleats1 han d''estar inclosos en els valors de ciutat2
*/

-- Solución:
create or replace function ciutat() returns trigger as $$ 
declare
	missatge varchar(100);
begin

	if (not exists(select * from empleats2 where new.ciutat1 = ciutat2)) then
		SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
			RAISE EXCEPTION '%',missatge;
		return null;
	end if;
	
	return new;
	EXCEPTION
  		WHEN raise_exception THEN 
  			RAISE EXCEPTION '%', SQLERRM;
end;
$$ language plpgsql;


create trigger update_ciutat1 before update of ciutat1 on empleats1
for each row execute procedure ciutat();

create trigger insert_ciutat1 before insert on empleats1
for each row execute procedure ciutat();