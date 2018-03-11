-- Creacion de una tabla:
create table departaments
	( num_dpt integer,
	nom_dpt CHAR(30) not null,
	planta integer not null,
	edifici CHAR(30) not null,
	ciutat_dpt CHAR(30) not null,
	primary key (num_dpt));

create table projectes
	( num_proj integer,
	nom_proj CHAR(30) not null,
	producte CHAR(30) not null,
	pressupost integer not null,
	primary key (num_proj));

create table empleats
	( num_empl	integer, 
	nom_empl	CHAR(30) not null,
	sou 		integer default 100000
						check (sou>80000),
	ciutat_empl	CHAR(30),
	num_dpt		integer,
	num_proj	integer,
	primary key (num_empl),
	foreign key (num_dpt) references
	departaments(num_dpt),
	foreign key (num_proj) references projectes(num_proj));
-- Diferent UNIQUE de taula a UNIQUE de columna


-- Inserció de files:
insert into departaments
values (1,'DIRECCIO',10,'PAU CLARIS','BARCELONA');

insert into departaments
values (2,'DIRECCIO',8,'RIOS ROSAS','MADRID');

insert into departaments
values (3,'MARQUETING',1,'PAU CLARIS','BARCELONA');


insert into projectes
values (1,'IBDTEL','TELEVISIO',1000000);

insert into projectes
values (2,'IBDVID','VIDEO',500000);


insert into empleats
values (1,'CARME',400000,'MATARO',1,1);

insert into empleats
values (2,'EUGENIA',350000,'TOLEDO',2,2);

insert into empleats
values (3,'JOSEP',250000,'SITGES',3,1);

insert into empleats
values (4,'RICARDO',410000,'BARCELONA',1,1);

insert into empleats(num_empl, num_dpt, num_proj, nom_empl)
values (11,3,2,'NURIA');


-- Esborrat de files:
delete from empleats
where num_empl>=11;

-- Modificació de files
update empleats
set sou = sou - 10000
where nom_empl='RICARDO';

insert into empleats(num_empl, num_dpt, num_proj, nom_empl)
values (11,3,2,'NURIA');

update empleats
set sou = sou + 12345, ciutat_empl='VIC'
where num_empl>10;

-- Consultes:
select *
from empleats;

select num_empl, nom_empl, sou
from empleats;

select num_empl, nom_empl, sou
from empleats
where num_dpt=3;

-- Operadores:
/*
    - aritmètics: *, +, -, /
    - de comparació: =, <, >, >=, <=, <>
    - lógics: NOT, AND, OR
    - altres:
        - <columna> BETWEEN <límit1> AND <límit2>
        - <columna> IN (<valor1>,<valor2>[...,<valorn>])
        - <columna> LIKE <característica>
        - <columna> IS [NOT] NULL
    
    Operadors poden sortir en condiciones de clausula WHERE (DELETE, UPDATE, SELECT), clausula CHECK (CREATE TABLE).
*/

select num_empl, nom_empl
from empleats
where NOT(num_dpt=2)and
	(ciutat_empl in ('MATARO','SITGES','BARCELONA') or 
	ciutat_empl like 'V%') and
	num_proj is not null and
	sou between 400000 and 500000;


-- Ordenació:
select num_empl, nom_empl, sou
from empleats
where num_dpt in (1,2,3)
order by sou desc, nom_empl;
-- Per defecte ASC (ascendent)


-- Resultats senese repeticions:
insert into empleats
values (12,'NURIA',150000,'MATARO',1);

select distinct nom_empl, sou
from empleats
where num_dpt in (1,3);
-- Sempre qu hi puguin haver repetits utilitzar DISTINCT, si no hi pot haver no posarlo

-- Funcions d'agregació:
/*
Funciones que se apliquen a un conjunt de files:
    - COUNT
        - COUNT(*), número de files que compleixen WHERE.
        - COUNT(DISTINCT <columna>) número de files diferents que compleixen WHERE.
        - COUNT(<column>) número de files que compleixen WHERE, sense comptar NULL.
    - SUM(expressió): suma dels valors que compleixen WHERE
    - MIN(expressió): dóna valor mínim que compleixe WHERE
    - MAX(expressió): dóna valor màxim que compleixe WHERE
    - AVG(expressió): dóna valor promig que compleixen WHERE
*/
-- AS: àlies
select count(*) as quantEmpl,
	count(distinct nom_empl) as
	quantNoms,
	SUM(sou*0.1) as partSou
from empleats
where num_dpt in (1,3);

-- Agrupació de files:
select num_dpt,
		count(*) as quantEmpl
from empleats
where num_dpt in (1,3)
group by num_dpt;

-- Condiciones sobre grups: 
select num_dpt, SUM(sou) as sumaSous
from empleats
group by num_dpt
having count(*) >= 3;

select distinct num_dpt
from empleats
group by num_dpt, ciutat_empl
having count(*) >= 2;

-- Consultes sobre més d'una taula:
select *
from empleats e, projectes p;
-- Hace el producto cartesiano de las tablas a consultar

select e.num_empl, p.num_proj, p.nom_proj
from empleats e, projectes p
where e.num_proj = p.num_proj;
-- Estos dos códigos hacen lo mismo
select e.num_empl, p.num_proj, p.nom_proj
from empleats e natural inner join projectes p;

-- Consultas sobre varias tablas:
select p.num_proj, p.nom_proj
from projectes p, empleats e
where p.num_proj = e.num_proj
group by p.num_proj
having p.pressupost < SUM(e.sou);

-- Unión:
select ciutat_empl
from empleats
union
select ciutat_dpt
from departaments
order by ciutat_empl desc;


-- Diferencia:
insert into projectes
values (3,'IBDTEF','VIDEO',1000000);

select p.num_proj, p.nom_proj
from projectes p
where p.num_proj not in (select e.num_proj
							from empleats e);
-- NOT IN: cierto si el valor de la condicion no está en el resultado de la subconsulta
-- NOT EXIST: cierto si la subconsulta no da ningún resultado 
select p.num_proj, p.nom_proj
from projectes p
where not exists (select * from empleats e
					where p.num_proj = e.num_proj);

-- Subconsultas en sentEncias DELETE, UPDATE y SELECT:
delete from projectes
where not exists (select * 
					from empleats e
					where e.num_proj = projectes.num_proj);

update projectes
set pressupost = pressupost + (pressupost*0.1)
where 2 <= (select count(*)
			from empleats e
			where projectes.num_proj = e.num_proj);

select e.num_empl, e.nom_empl
from empleats e
where e.sou > (select AVG(e1.sou)
				from empleats e1);

select p.num_proj, p.nom_proj
from projectes p
where p.pressupost < (select SUM(e.sou)
						from empleats e 
						where e.num_proj = p.num_proj);

-- Subconsultas en sentencias INSERT y cláusulas HAVING:
select d.num_dpt, d.nom_dpt, 100*SUM(e.sou)/d.pressupost as percSous
from departaments d, empleats e
where d.num_dpt = e.num_dpt
group by d.num_dpt
having sum(e.sou) > (select sum(e1.sou)
						from empleats e1
						where e1.num_dpt=3);

INSERT INTO clients
    (SELECT num_empl, nom_empl, 200000
     FROM empleats
     WHERE num_dpt IN (2,3));