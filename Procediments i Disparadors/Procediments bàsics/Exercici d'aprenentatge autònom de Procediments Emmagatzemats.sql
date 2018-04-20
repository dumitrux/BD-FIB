-- Q1:
-- Sentències d'esborrat de la base de dades:
drop table lloguers_actius;
drop table treballadors;
drop table cotxes;
drop table missatgesExcepcions;
drop function  llistat_treb(char(8), char(8));

-- Sentències de preparació de la base de dades:
create table cotxes(
	matricula char(10) primary key,
	marca char(20) not null,
	model char(20) not null,
	categoria integer not null,
	color char(10),
	any_fab integer
	);
create table treballadors(
	dni char(8) primary key,
	nom char(30) not null,
	sou_base real not null,
	plus real not null
	);
create table lloguers_actius(
	matricula char(10) primary key    references cotxes,
	dni char(8) not null constraint fk_treb  references treballadors,
	num_dies integer not null,
	preu_total real not null
	);

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);
insert into missatgesExcepcions values(1,'No hi ha cap tupla dins del interval demanat');
insert into missatgesExcepcions values(2, 'Error intern');

--------------------------
-- Joc de proves Public
--------------------------

-- Sentències de neteja de les taules:
delete from lloguers_actius;
delete from treballadors;
delete from cotxes;

-- Sentències d'inicialització:
insert into cotxes values ('1111111111','Audi','A4',1,'Vermell',1998);
insert into cotxes values ('2222222222','Audi','A3',2,'Blanc',1998);
insert into cotxes values ('3333333333','Volskwagen','Golf',2,'Blau',1990);
insert into cotxes values ('4444444444','Toyota','Corola',3,'groc',1999);
insert into cotxes values ('5555555555','Honda','Civic',3,'Vermell',2000);
insert into cotxes values ('6666666666','BMW','Mini',2,'Vermell',2000);

insert into treballadors values ('22222222','Joan',1700,150);

insert into lloguers_actius values ('1111111111','22222222',7,750);
insert into lloguers_actius values ('2222222222','22222222',5,550);
insert into lloguers_actius values ('3333333333','22222222',4,450);
insert into lloguers_actius values ('4444444444','22222222',8,850);
insert into lloguers_actius values ('5555555555','22222222',2,250);


/*
Donat un intèrval de DNIs, obtenir la informació de cadascun dels treballadors amb un DNI d'aquest interval. 

La informació que cal obtenir és la següent:
- Per cada treballador destacat de l'interval (treballador que té un mínim de cinc lloguers actius), es vol obtenir les seves dades personals i la matrícula dels cotxes que té llogats; 
- Per la resta de treballadors, simplement es vol obtenir les seves dades personals.

Tingueu en compte que:
- En el cas de treballadors destacats, al llistat hi sortirà una fila per cadascun dels cotxes que té llogats. 
- En el cas de treballadors no destacats, al llistat hi sortirà una única fila, en què l'atribut matrícula tindrà valor nul. 
- El nom del procediment ha de ser llistat_treb, i ha de tenir dos paràmetres corresponents als dos DNIs que defineixen l'interval.
- El llistat ha d'estar ordenat per dni i matricula de forma ascendent.
- Les dades de cada treballador, s'han de donar en l'ordre que apareixen al resultat del joc de proves públic. 
- El tipus de les dades que s'han de retornar han de ser els mateixos que hi ha a la taula on estan definits els atributs corresponents.

El procediment ha d'informar dels errors a través d'excepcions. Les situacions d'error que heu d'identificar són les tipificades a la taula missatgesExcepcions, que podeu trobar definida i amb els inserts corresponents al fitxer adjunt. En el vostre procediment heu d'incloure, on s'identifiquin aquestes situacions, les sentències:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 o 2, depenent de l'error)
RAISE EXCEPTION '%',missatge;
On la variable missatge ha de ser una variable definida al vostre procediment.

Pel joc de proves que trobareu al fitxer adjunt i la crida següent,
SELECT * FROM llistat_treb('11111111','33333333');
el resultat ha de ser: 

DNI Treballador		Nom Treballador		Sou base		Plus sou		Matricula
22222222		Joan		1700		150		1111111111
22222222		Joan		1700		150		2222222222
22222222		Joan		1700		150		3333333333
22222222		Joan		1700		150		4444444444
22222222		Joan		1700		150		5555555555
*/

-- Solución:
create type dadest as (
	dni_treballador char(8),
	nom_treballador char(30),
	sou_base real,
	plus_sou real,
	matricula char(10));


create or replace function llistat_treb (dni1 treballadors.dni%type, dni2 treballadors.dni%type) returns setof dadest as $$ 
declare
	dades dadest;
	missatge varchar(50);
begin
	for dades in (select t.dni, t.nom, t.sou_base, t.plus
					from treballadors t 
					where dni >= dni1 and dni <= dni2) loop
		if (5 <= (select count(*) from lloguers_actius l where dades.dni_treballador = l.dni)) then
			for dades.matricula in (select l.matricula
						from lloguers_actius l
						where dades.dni_treballador = l.dni) loop
						return next dades;
			end loop;
		else
			return next dades;
		end if;
	end loop;
	if (not found) then SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=1;
		RAISE EXCEPTION '%',missatge;
	end if;
	EXCEPTION
  		WHEN raise_exception THEN 
  			RAISE EXCEPTION '%', SQLERRM;
		WHEN OTHERS THEN 
			SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=2;
			RAISE EXCEPTION '%', missatge;
end;
$$LANGUAGE plpgsql;