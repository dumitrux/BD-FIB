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
INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','BARCELONA');

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'BARCELONA',3,null);

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

/*
Doneu una sentència SQL per obtenir el número i el nom dels empleats que viuen a la mateixa ciutat on està situat el departament on treballen

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

num_empl		nom_empl
3		ROBERTO
*/

-- Solución:
select e.num_empl, e.nom_empl
from empleats e, departaments d
where e.num_dpt = d.num_dpt and e.ciutat_empl = d.ciutat_dpt;



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
-- Joc de proves Públic
--------------------------

-- Sentències de neteja de les taules:
DELETE FROM empleats;
DELETE FROM departaments;
DELETE FROM projectes;

/*
Suposem la base de dades que podeu trobar al fitxer adjunt.
Suposem que aquesta base de dades està en un estat on no hi ha cap fila.
Doneu una seqüència de sentències SQL d'actualització (INSERTs i/o UPDATEs) que violi la integritat d'entitat de la taula Empleats al'intentar duplicar la primary key d'aquesta taula de l'empleat. 
Les sentències NOMÉS han de violar aquesta restricció.
*/

-- Solución:
INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'BARCELONA',null,null);
INSERT INTO  EMPLEATS VALUES (4,'ROBERTA',27000,'BARCELONA',null,null);

update empleats
set num_empl=4
where num_empl=3;



-- Q3:
CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER PRIMARY KEY,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER,
	NUM_PROJ INTEGER);

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,null);

INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

INSERT INTO  EMPLEATS VALUES (5,'PERE',35000,'BARCELONA',3,null);

/*
Doneu una seqüència d'operacions d'àlgebra relacional per obtenir el nom dels empleats que guanyen més que l'empleat amb num_empl 3. 
Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Nom_empl
-------------
JOAN 
PERE
*/

-- Solución:
A=empleats(num_empl=3)
B=A{num_empl->num_empl3, nom_empl->nom_empl3, sou->sou3, ciutat_empl->ciutat_empl3, num_dpt->num_dpt3, num_proj->num_proj3}
C=B[sou3<sou]empleats
R=C[nom_empl]