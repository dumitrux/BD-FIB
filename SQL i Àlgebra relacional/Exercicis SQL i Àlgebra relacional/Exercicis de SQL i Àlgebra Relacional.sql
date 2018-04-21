-- Q1:



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
	NUM_DPT INTEGER NOT NULL,
	NUM_PROJ INTEGER NOT NULL,
	PRIMARY KEY (NUM_EMPL),
	FOREIGN KEY (NUM_DPT) REFERENCES DEPARTAMENTS (NUM_DPT),
	FOREIGN KEY (NUM_PROJ) REFERENCES PROJECTES (NUM_PROJ));


INSERT INTO  DEPARTAMENTS VALUES (1,'DIRECCIO',10,'PAU CLARIS','BARCELONA');
INSERT INTO  DEPARTAMENTS VALUES (2,'DIRECCIO',8,'RIOS ROSAS','MADRID');
INSERT INTO  DEPARTAMENTS VALUES (4,'MARKETING',3,'RIOS ROSAS','MADRID');

INSERT INTO  PROJECTES VALUES (1,'IBDTEL','TELEVISIO',1000000);
INSERT INTO  PROJECTES VALUES (2,'IBDVID','VIDEO',500000);
INSERT INTO  PROJECTES VALUES (3,'IBDTEF','TELEFON',200000);
INSERT INTO  PROJECTES VALUES (4,'IBDCOM','COMPACT DISC',2000000);

INSERT INTO  EMPLEATS VALUES (1,'CARME',400000,'MATARO',1,1);

/*
Doneu una sentència SQL per obtenir els departaments tals que tots els empleats del departament estan assignats a un mateix projecte. 

No es vol que surtin a la consulta els departaments que no tenen cap empleat. 

Es vol el número, nom i ciutat de cada departament. 

El resultat ha d'estar ordenat ascendentment per cadascun dels atributs anteriors.

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria:

Num_dpt		Nom_dpt		Ciutat_dpt
1		DIRECCIO		BARCELONA
*/

-- Solución:
select distinct d.num_dpt, d.nom_dpt, d.ciutat_dpt
from departaments d natural inner join empleats e
where not exists (select e1.num_proj
					from empleats e1
					where e.num_dpt = e1.num_dpt and e.num_proj <> e1.num_proj)
order by num_dpt asc, nom_dpt asc, ciutat_dpt asc;




-- Q3:
------------------------
-- Inicialitzacio
------------------------

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

/*
Tenint en compte l'esquema de la BD que s'adjunta, proposeu una sentència de creació de la taula següent:
presentacioTFG(idEstudiant, titolTFG, dniDirector, dniPresident, dniVocal, instantPresentacio, nota)

Hi ha una fila de la taula per cada treball final de grau (TFG) que estigui pendent de ser presentat o que ja s'hagi presentat.

En la creació de la taula cal que tingueu en compte que: 
- L'identificador de l'estudiant i el títol del TFG són chars de 100 caràcters. 
- Un estudiant només pot presentar un TFG. 
- No hi pot haver dos TFG amb el mateix títol.
- Tot TFG ha de tenir un títol. 
- El director, el president i el vocal han de ser professors que existeixin a la base de dades.
- El director del TFG no pot estar en el tribunal del TFG (no pot ser ni president, ni vocal).
- El president i el vocal no poden ser el mateix professor. 
- L'instant de presentació ha de ser un enter diferent de nul.
- La nota ha de ser un enter entre 0 i 10. 
- La nota té valor nul fins que s'ha fet la presentació del TFG. 

Respecteu els noms i l'ordre en què apareixen les columnes (fins i tot dins la clau o claus que calgui definir). Tots els noms 
s'han de posar en majúscues/minúscules com surt a l'enunciat. 
*/

-- Solución:
create table presentacioTFG
			(idEstudiant CHAR(100), 
			titolTFG CHAR(100) not null unique, 
			dniDirector char(50) not null, 
			dniPresident char(50) not null, 
			dniVocal char(50) not null, 
			instantPresentacio integer not null, 
			nota integer check (nota >= 0 and nota <= 10) default null,
			primary key (idEstudiant),
			foreign key (dniDirector) references professors,
			foreign key (dniPresident) references professors,
			foreign key (dniVocal) references professors,
			check (dniDirector <> dniPresident and dniDirector <> dniVocal),
			check (dniPresident <> dniVocal)
			);



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
insert into professors values('111','toni','3111',3500);

insert into despatxos values('omega','120',20);

insert into assignacions values('111','omega','120',345,null);

-- Sentències de neteja de les taules:
DELETE FROM assignacions;
DELETE FROM despatxos;
DELETE FROM professors;

/*
Doneu una seqüència d'operacions en àlgebra relacional per obtenir el nom dels professors que o bé tenen un sou superior a 2500,
o bé no tenen cap assignació a un despatx amb superfície inferior a 20. 

Pel joc de proves que trobareu al fitxer adjunt, la sortida seria: 

NomProf
toni
*/

-- Solución:
A=professors(sou > 2500)
B=professors*assignacions
C=B*despatxos
D=C(superficie<20)
L=D[nomProf]
F=C[nomProf]
E=F-L
G=professors[nomProf]
H=G-F
I=E[nomProf]
J=A[nomProf]
K=J_u_I
R=K_u_H



-- Q5:
