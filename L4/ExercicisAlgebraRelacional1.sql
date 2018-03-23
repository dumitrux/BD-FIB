-- Q1:
CREATE TABLE DEPARTAMENTS
         (	NUM_DPT INTEGER PRIMARY KEY,
	NOM_DPT CHAR(20),
	PLANTA INTEGER,
	EDIFICI CHAR(30),
	CIUTAT_DPT CHAR(20));

CREATE TABLE PROJECTES(
    NUM_PROJ INTEGER PRIMARY KEY,
    NOM_PROJ CHAR(10),
    PRODUCTE CHAR(20),
    PRESSUPOST INTEGER
);

CREATE TABLE EMPLEATS
         (	NUM_EMPL INTEGER PRIMARY KEY,
	NOM_EMPL CHAR(30),
	SOU INTEGER,
	CIUTAT_EMPL CHAR(20),
	NUM_DPT INTEGER REFERENCES DEPARTAMENTS,
	NUM_PROJ INTEGER REFERENCES PROJECTES);

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'RIOS ROSAS','BARCELONA');

INSERT INTO PROJECTES VALUEs (2,'IBDVID','VIDEO',500000);

INSERT INTO  EMPLEATS VALUES (2,'ROBERTO',25000,'BARCELONA',3,2);

/*
Doneu una seqüència d'operacions d'algebra relacional per obtenir el nom del departament on treballa i el nom del projecte on està assignat l'empleat número 2. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Nom_dpt		Nom_proj
MARKETING		IBDVID
*/

-- Solución:
A=EMPLEATS(num_empl=2)
B=A*DEPARTAMENTS
C=B*PROJECTES
R=C[NOM_DPT,NOM_PROJ]



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

INSERT INTO DEPARTAMENTS VALUES(3,'MARKETING',1,'EDIFICI1','SABADELL');

INSERT INTO  EMPLEATS VALUES (4,'JOAN',30000,'BARCELONA',3,null);

INSERT INTO  EMPLEATS VALUES (5,'PERE',25000,'MATARO',3,null);

/*
Doneu una seqüència d'operacions de l'àlgebra relacional per obtenir el número i nom dels departaments que tenen dos o més empleats que viuen a ciutats diferents. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING
*/

-- Solución:
A=EMPLEATS[NUM_EMPL, CIUTAT_EMPL, NUM_DPT]
B=A{NUM_EMPL->NUM_EMPL2, CIUTAT_EMPL->CIUTAT_EMPL2, NUM_DPT->NUM_DPT2}
C=EMPLEATS[NUM_DPT=NUM_DPT2,CIUTAT_EMPL<>CIUTAT_EMPL2, NUM_EMPL<>NUM_EMPL2]B
D=DEPARTAMENTS*C
R=D[NUM_DPT,NOM_DPT]



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

INSERT INTO  DEPARTAMENTS VALUES (3,'MARKETING',3,'VERDAGUER','VIC');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);

INSERT INTO  EMPLEATS VALUES (3,'ROBERTO',25000,'MADRID',3,1);

/*
Doneu una seqüència d'operacions d'algebra relacional per obtenir el número i nom dels departaments tals que tots els seus empleats viuen a MADRID. El resultat no ha d'incloure aquells departaments que no tenen cap empleat. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt
3		MARKETING
*/

-- Solución:
A=EMPLEATS(CIUTAT_EMPL<>'MADRID')
B=DEPARTAMENTS*A
C=B[NUM_DPT,NOM_DPT,PLANTA,EDIFICI,CIUTAT_DPT]
E=DEPARTAMENTS-C
F=E*EMPLEATS
R=F[NUM_DPT,NOM_DPT]



-- Q4:
-- Sentències de preparació de la base de dades:
create table professors
(dni char(50),
nomProf char(50) unique,
telefon char(15),
sou integer not null check(sou>0),
primary key (dni));

create table despatxos
(modul char(5), 
numero char(5), 
superficie integer not null check(superficie>12),
primary key (modul,numero));

create table assignacions
(dni char(50), 
modul char(5), 
numero char(5), 
instantInici integer, 
instantFi integer,
primary key (dni, modul, numero, instantInici),
foreign key (dni) references professors,
foreign key (modul,numero) references despatxos);
-- instantFi te valor null quan una assignacio es encara vigent.

-- Sentències d'esborrat de la base de dades:
DROP TABLE assignacions;
DROP TABLE despatxos;
DROP TABLE professors;

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències d'inicialització:
insert into professors values ('999', 'DOLORS', '323323323', 100000);

insert into despatxos values ('Omega','128',30);

insert into assignacions values ('999', 'Omega', '128',1,null);

-- Sentències de neteja de les taules:
DELETE FROM assignacions;
DELETE FROM despatxos;
DELETE FROM professors;;

/*
Donar una seqüència d'operacions d'àlgebra relacional per obtenir informació sobre els despatxos que només han estat ocupats per professors amb sou igual a 100000. Es vol obtenir el dni, el modul i el numero del despatx, i l'instant d'inici de les assignacions a aquests despatxos.

Pel joc de proves que trobareu al fitxer adjunt, la sortida ha de ser:

DNI	Modul	Numero	Instantinici
999	Omega	128	1
*/

-- Solución:
A=DESPATXOS[MODUL,NUMERO]
B=PROFESSORS(SOU<>100000)
C=B*ASSIGNACIONS
D=C[MODUL,NUMERO]
E=A-D
F=E*ASSIGNACIONS
R=F[DNI,MODUL,NUMERO,INSTANTINICI]