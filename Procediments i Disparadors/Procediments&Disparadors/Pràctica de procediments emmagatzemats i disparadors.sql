-- Q1:
create table empleats1 (nemp1 integer primary key, nom1 char(25), ciutat1 char(10) not null);

create table empleats2 (nemp2 integer primary key, nom2 char(25), ciutat2 char(10) not null);

insert into empleats2 values(1,'joan','bcn');
insert into empleats2 values(2,'pere','mad');
insert into empleats2 values(3,'enric','bcn');
insert into empleats1 values(1,'joan','bcn');
insert into empleats1 values(2,'maria','mad');

/*
En aquest exercici es tracta definir els disparadors necessaris sobre empleats2 (veure definició de la base de dades al fitxer adjunt) per mantenir la restricció següent: 
Els valors de l'atribut ciutat1 de la taula empleats1 han d'estar inclosos en els valors de ciutat2 de la taula empleats2 
Per mantenir la restricció, la idea és que:

En lloc de treure un missatge d'error en cas que s'intenti executar una sentència sobre empleats2 que pugui violar la restricció, 
cal executar operacions compensatories per assegurar el compliment de l'asserció. En concret aquestes operacions compensatories ÚNICAMENT podran ser operacions DELETE. 

Pel joc de proves que trobareu al fitxer adjunt, i la sentència:
DELETE FROM empleats2 WHERE nemp2=1;
La sentència s'executarà sense cap problema,i l'estat de la base de dades just després ha de ser:

Taula empleats1
nemp1	nom1	ciutat1
1	joan	bcn
2	maria	mad

Taula empleats2
nemp2	nom2	ciutat2
2	pere	mad
3	enric	bcn
*/

-- Solución:
create or replace function esborrar_empleat() returns trigger as $$
begin
	if (not exists (select * from empleats2 where ciutat2 = old.ciutat2)) then
		delete from empleats1 where ciutat1 = old.ciutat2;
	end if;
	return null;
end;
$$ language plpgsql;

create trigger ciutat after delete on empleats2
for each row execute procedure esborrar_empleat();

create trigger ciutat_update after update of ciutat2 on empleats2
for each row execute procedure esborrar_empleat();



-- Q2:
create table socis ( nsoci char(10) primary key, sexe char(1) not null);

create table clubs ( nclub char(10) primary key);

create table socisclubs (nsoci char(10) not null references socis, 
  nclub char(10) not null references clubs, 
  primary key(nsoci, nclub));

create table clubs_amb_mes_de_5_socis (nclub char(10) primary key references clubs);

create table missatgesExcepcions(
	num integer, 
	texte varchar(50)
	);

	
	
insert into missatgesExcepcions values(1, 'Club amb mes de 10 socis');
insert into missatgesExcepcions values(2, 'Club amb mes homes que dones');
insert into missatgesExcepcions values(3, 'Soci ja assignat a aquest club');
insert into missatgesExcepcions values(4, 'O el soci o el club no existeixen');
insert into missatgesExcepcions values(5, 'Error intern');

insert into clubs values ('escacs');
insert into clubs values ('petanca');

insert into socis values ('anna','F');

insert into socis values ('joanna','F');
insert into socis values ('josefa','F');
insert into socis values ('pere','M');

insert into socisclubs values('joanna','petanca');
insert into socisclubs values('josefa','petanca');
insert into socisclubs values('pere','petanca');

/*
Disposem de la base de dades del fitxer adjunt que gestiona clubs esportius i socis d'aquests clubs. Cal implementar un procediment emmagatzemat que enregistra l'assignació d'un soci a un club. 

El procediment ha de: 
- Enregistrar l'assignació d'un soci a un club (el soci i club es passen com a paràmetre), inserint la fila corresponent a la taula Socisclubs. 
- En cas que el club amb la nova assignació passi a tenir més de 5 socis, inserir el club a la taula Clubs_amb_mes_de_5_socis.
- Cal que el procediment informi d'errors mitjançant excepcions si la nova assignació fa que no es compleixi alguna de les restriccions d'usuari següents:
RI1: Un club no pot tenir més de 10 socis
RI2: Un club no pot tenir més homes que dones
- El nom del procediment ha de ser assignar_individual.
- El procediment no retorna cap resultat. 
- El tipus dels paràmetres d'entrada han de ser els mateixos que hi ha a la taula on estan definits els atributs corresponents.

El procediment ha d'informar dels errors a través d'excepcions. Les situacions d'error que cal que identifiqui són les tipificades a la taula missatgesExcepcions que podeu trobar definida (amb els inserts corresponents) al fitxer adjunt. En el vostre procediment heu d'incloure, on s'identifiquin aquestes situacions, les sentències:
SELECT texte INTO missatge FROM missatgesExcepcions WHERE num=___; ( 1 .. 5, depenent de l'error)
RAISE EXCEPTION '%',missatge;
On la variable missatge ha de ser una variable definida al vostre procediment.

Suposem el joc de proves que trobareu al fitxer adjunt i la sentència 
select * from assignar_individual('anna','escacs'); 
La sentència s'executarà sense cap problema, i l'estat de la base de dades just després ha de ser: 

Taula Socisclubs
nsoci	nclub
anna	escacs
joanna	petanca
josefa	petanca
pere	petanca
Taula clubs_amb_mes_de_5_soci
sense cap fila
*/

-- Solución:
create or replace function assignar_individual(nom_soci socis.nsoci%type, nom_club clubs.nclub%TYPE) returns void as $$
declare
	missatge varchar(50);
	countador integer;
	num_F	integer;
begin
	insert into socisclubs values (nom_soci, nom_club);
	

	select count(*) into countador from socisclubs where nom_club = nclub;
	
	if (countador > 10) then
		 select texte into missatge from missatgesexcepcions where num = 1;
		 raise exception '%', missatge;
	else
		if (countador > 5) and not exists(select * from clubs_amb_mes_de_5_socis where nclub = nom_club) then
			insert into clubs_amb_mes_de_5_socis values(nom_club);
		end if;
		select count(*) into num_F from socis s, socisclubs c where s.sexe = 'F' and s.nsoci = c.nsoci and nom_club = c.nclub;
		if (countador - num_F > num_F) then
			select texte into missatge from missatgesexcepcions where num = 2;
			raise exception '%', missatge;
		end if;
	end if;
	
	
	exception
		when raise_exception then
			raise exception '%', SQLERRM;
		when foreign_key_violation then
			select texte into missatge from missatgesexcepcions where num = 4;
			raise exception '%', missatge;
		when unique_violation then
			select texte into missatge from missatgesexcepcions where num = 3;
			raise exception '%', missatge;
		when others then
			select texte into missatge from missatgesexcepcions where num = 5;
			raise exception '%', missatge;

end;
$$ language plpgsql;