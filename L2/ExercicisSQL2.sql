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
INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','MADRID');
INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

/*
Doneu una sentència SQL per obtenir el número i el nom dels departaments que no tenen cap empleat que visqui a MADRID. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT		NOM_DPT
3		MARKETING

*/

-- Solució:
select d.num_dpt, d.nom_dpt
from departaments d
where 'MADRID' not in (select e.ciutat_empl 
					from empleats e
					where e.num_dpt = d.num_dpt);



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
DROP TABLE projectes;
DROP TABLE departaments;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
INSERT INTO  DEPARTAMENTS VALUES (5,'VENDES',3,'CASTELLANA','MADRID');
INSERT INTO  EMPLEATS VALUES (1,'MANEL',250000,'MADRID',5,null);
INSERT INTO  EMPLEATS VALUES (3,'JOAN',25000,'GIRONA',5,null);

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM Projectes;
DELETE FROM departaments;

/*
Doneu una sentència SQL per obtenir les ciutats on hi viuen empleats però no hi ha cap departament.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

CIUTAT_EMPL
GIRONA
*/

-- Solució:
select distinct e.ciutat_empl
from empleats e
where e.ciutat_empl not in (select d.ciutat_dpt
							from departaments d);



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

-- Sentències d'esborrat de la base de dades:
DROP TABLE empleats;
DROP TABLE departaments;
DROP TABLE projectes;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
INSERT INTO DEPARTAMENTS VALUES(3,'MARKETING',1,'EDIFICI1','SABADELL');
INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);
INSERT INTO  EMPLEATS VALUES (5,'PERE',25000,'MATARO',3,null);

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

/*
Doneu una sentència SQL per obtenir el número i nom dels departaments que tenen dos o més empleats que viuen a ciutats diferents. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_DPT		NOM_DPT
3		MARKETING

*/

-- Solució:
select d.num_dpt, d.nom_dpt
from departaments d, empleats e
where d.num_dpt = e.num_dpt
group by d.num_dpt
having count(distinct e.ciutat_empl) >= 2;



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
VENDES(NUM_VENDA, NUM_EMPL, CLIENT)
PRODUCTES_VENUTS(NUM_VENDA, PRODUCTE, QUANTITAT, IMPORT)

Cada fila de la taula vendes representa una venda que ha fet un empleat a un client. 
Cada fila de la taula productes_venuts representa una quantitat de producte venut en una venda, amb un cert import. 

En la creació de les taules cal que tingueu en compte que: 
- No hi poden haver dues vendes amb un mateix número de venda. 
- Un empleat només li pot fer una única venda a un mateix client.
- Una venda l'ha de fer un empleat que existeixi a la base de dades 
- No hi pot haver dues vegades un mateix producte en una mateixa venda. 
- La venda d'un producte venut ha d'existir a la base de dades. 
- La quantitat de producte venut no pot ser nul, i té com a valor per defecte 1. 
- Els atributs num_venda, quantitat, import són enters. 
- Els atributs client, producte són char(30), i char(20) respectivament.

Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui definir). Tots els noms 
s'han de posar en majúscues com surt a l'enunciat. 
*/

-- Solució:
create table VENDES
		(NUM_VENDA integer,
	NUM_EMPL integer not null,
	CLIENT CHAR(30),
	primary key (NUM_VENDA),
	unique (NUM_EMPL, CLIENT),
	foreign key (NUM_EMPL) references empleats (NUM_EMPL));
	
create table PRODUCTES_VENUTS
		(NUM_VENDA integer,
	PRODUCTE char(20),
	QUANTITAT integer default 1 not null,
	IMPORT integer,
	primary key (NUM_VENDA, PRODUCTE),
	foreign key (NUM_VENDA) references VENDES (NUM_VENDA));
