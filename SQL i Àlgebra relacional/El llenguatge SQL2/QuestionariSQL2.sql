-- Q1:
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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',2,'PAU CLARIS','BARCELONA');
INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,null);
INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

/*
Doneu una sentència SQL per obtenir el nom dels empleats que guanyen el sou més alt. Cal ordenar el resultat descendenment per nom 
de l'empleat. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NOM_EMPL
JOAN
*/

-- Solución:
select distinct e.nom_empl 
from empleats e 
where e.sou >= (select max(sou) from empleats) 
order by e.nom_empl desc;



-- Q2:
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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',2,'PAU CLARIS','BARCELONA');
INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);
INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,1);
INSERT INTO  EMPLEATS VALUES (5,'PERE',25000,'MATARO',3,1);

/*
Doneu una sentència SQL per obtenir els números i els noms dels projectes que tenen assignats dos o més empleats.
Cal ordenar el resultat descendement per número de projecte.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

NUM_PROJ		NOM_PROJ
1		IBDTEL
*/

-- Solución:
select distinct p.num_proj, p.nom_proj  
from projectes p
where 2 <= (select count(*) from empleats e where e.num_proj = p.num_proj) 
order by p.num_proj desc;



-- Q3:
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
	
INSERT INTO  PROJECTES VALUES (3,'PR1123','TELEVISIO',600000);
INSERT INTO  DEPARTAMENTS VALUES (4,'MARKETING',3,'RIOS ROSAS','BARCELONA');
INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MATARO',4,3);

/*
Doneu una sentència SQL per incrementar en 500000 el pressupost dels projectes que tenen algun empleat que treballa a BARCELONA. 
Pel joc de proves que trobareu al fitxer adjunt, el pressupost del projecte que hi ha d'haver després de l'execució de la sentència 
és 1100000
*/

-- Solución:
update projectes
set pressupost = pressupost + 500000
where 1 <= (select count(*)
		from departaments d, empleats e
		where (projectes.num_proj = e.num_proj and e.num_dpt = d.num_dpt and d.ciutat_dpt = 'BARCELONA'));
