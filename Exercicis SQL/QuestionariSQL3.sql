-- Q1:
-- Sentències de preparació de la base de dades:
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

-- Sentències d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'VERDAGUER','VIC');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,1);

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

/*
Doneu una sentència SQL per obtenir el número i nom dels departaments tals que tots els seus empleats viuen a MADRID. El resultat no ha d'incloure aquells departaments que no tenen cap empleat. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING
*/

-- Solución:
select distinct d.num_dpt, d.nom_dpt
from departaments d, empleats e
where d.num_dpt = e.num_dpt and 
		not exists (select *
			from empleats e1
			where e1.ciutat_empl not in ('MADRID'));



-- Q2:
-- Sentències de preparació de la base de dades:
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

-- Sentències d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'BARCELONA',3,null);
INSERT INTO  EMPLEATS VALUES (5,'EULALIA',150000,'BARCELONA',3,null);

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

/*
Doneu una sentència SQL per obtenir el número i nom dels departaments que tenen 2 o més empleats que viuen a la mateixa ciutat.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT		NOM_DPT
3		MARKETING
*/

-- Solución:
select distinct d.num_dpt, d.nom_dpt
from departaments d, empleats e
where e.num_dpt = d.num_dpt and e.ciutat_empl in (select e1.ciutat_empl
				from empleats e1
				where d.num_dpt = e1.num_dpt and e1.num_empl <> e.num_empl);



-- Q3:
-- Sentències de preparació de la base de dades:
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

CREATE TABLE COST_CIUTAT
        (CIUTAT_DPT CHAR(20),
        COST INTEGER,
        PRIMARY KEY (CIUTAT_DPT));

-- Sentències d'esborrat de la base de dades:
DROP TABLE cost_ciutat;
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
INSERT INTO  PROJECTES VALUES (3,'PR1123','TELEVISIO',600000);

INSERT INTO  DEPARTAMENTS VALUES (4,'MARKETING',3,'RIOS ROSAS','BARCELONA');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',100,'MATARO',4,3);

-- Sentències de neteja de les taules:
delete from cost_ciutat;
delete from empleats;
delete from departaments;
delete from projectes;

/*
Doneu una sentència d'inserció de files a la taula cost_ciutat que l'ompli a partir del contingut de la resta de taules de la base de dades. Tingueu en compte el següent: 

Hi haurà una fila de la taula per cada ciutat on hi ha un departament. El valor de l'atribut cost serà la suma del sou dels empleats dels departaments situats a la ciutat. 

Només han de sortir les ciutats on hi ha departament que tinguin empleats. 

Pel joc de proves públic del fitxer adjunt, un cop executada la sentència d'inserció, a la taula cost_ciutat hi haurà les tuples següents:

CIUTAT_DPT		COST
BARCELONA		100
*/

-- Solución:
insert into cost_ciutat
	(select distinct d.ciutat_dpt, SUM(e.sou) as COST
	from departaments d, empleats e
	where d.num_dpt = e.num_dpt
	group by d.ciutat_dpt);



-- Q4:
-- Sentències de preparació de la base de dades:
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20),
	PRIMARY KEY (NUM_DPT));

CREATE TABLE PROJECTES
         (	NUM_PROJ INTEGER,
	NOM_PROJ CHAR(10),
	PRODUCTE CHAR(20),
	PRESSUPOST INTEGER,
	PRIMARY KEY (NUM_PROJ));

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));

/*
Tenint en compte l'esquema de la BD que s'adjunta, proposeu una sentència de creació de les taules següents:
FRANGES_HORARIES(INSTANT_INICI, INSTANT_FI, NUM_EMPL)
TASQUES_REALITZADES(NUM_TASCA, INSTANT_INICI, INSTANT_FI, NUM_EMPL, DESCRIPCIO)

Cada fila de la taula franges_horaries representa un periode d'hores seguides què ha treballat un empleat. 
Cada fila de la taula tasques_realitzades representa una tasca que un empleat ha realitzat en una franja horaria. 

En la creació de les taules cal que tingueu en compte que: 
- No hi poden haver dues franges d'un mateix empleat que comencin i acabin en uns mateixos instants. 
- L'instant fi d'una franja ha de ser més gran que l'instant d'inici més 180. 
- Una franja horària ha de ser d'un empleat que existeixi a la base de dades 
- No hi pot haver dues tasques amb el mateix número de tasca. 
- Una tasca es fa sempre en una franja horària que existeixi a la base de dades 
- La descripció d'una tasca ha de tenir un valor definit (valor diferent de null).
- Els atributs instant_inici, instant_fi, num_tasca són enters.
- L'atribut descripció ha de ser un char(50).

Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui definir). Tots els noms s'han de posar en majúscules com surt a l'enunciat.
*/

-- Solución:
create table FRANGES_HORARIES
		(	INSTANT_INICI integer,
			INSTANT_FI integer,
			NUM_EMPL integer,
			primary key (INSTANT_INICI, INSTANT_FI, NUM_EMPL),
			foreign key (NUM_EMPL) references EMPLEATS (NUM_EMPL),
			check (INSTANT_FI > INSTANT_INICI + 180));

create table TASQUES_REALITZADES
		(	NUM_TASCA integer,
			INSTANT_INICI integer not null,
			INSTANT_FI integer not null,
			NUM_EMPL integer not null,
			DESCRIPCIO CHAR(50) not null,
			primary key (NUM_TASCA),
			foreign key (INSTANT_INICI, INSTANT_FI, NUM_EMPL) references 
                        FRANGES_HORARIES (INSTANT_INICI, INSTANT_FI, NUM_EMPL));