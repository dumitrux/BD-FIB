/*
PASSOS PREVIS: LLegir el contingut del fitxer PassosASeguir.txt 

EXERCICI:
Heu d'implementar el mètode consulta. Aquest mètode ha de: 
Esborrar els despatxos del mòdul D que tenen una superfície inferior a S. Els paràmetres D i S es passaran en els paràmetres d'entrada del mètode consulta.
Retornar una única fila amb la suma de les superfícies dels despatxos que queden a la base de dades després de la sentència d'esborrat. Si no en queda cap a la base de dades, en lloc d'un 0, ha de sortir "NO".
Retornar per cada professor que hi ha a la base de dades que té alguna assignació finalitzada, el nom del professor i la quantitat d'assignacions finalitzades que té a despatxos.

Cal tenir en compte que:
En les dades d'entrada només es passa un únic nom de mòdul i una superfície.

En cas que s'identifiqui una de les situacions següents, el mètode ha de llançar una excepció identificada amb el codi d'error que s'indica.
12: No hi ha cap despatx en el modul passat com a parametre amb superfície més petita que S . 
13: Algun dels despatxos a esborrar té assignacions de professors i no es pot esborrar. 
14: Error Intern

Pel joc de proves públic el contingut de la taula d'assignacions serà el següent:
20	
Toni	1

En el fitxer adjunt trobareu: 
- Els passos a seguir: (PassosASeguir.txt)
- La descripció del conjunt del programa Practica: (ProgramaPractica.pdf) 
- Les classes i mètodes per obtenir els paràmetres d'entrada: (MetodesAuxiliars.txt) 
- Les classes i mètodes per retornar el resultat i llençar excepcions: (MetodesAuxiliars.txt) 
- El projecte Eclipse que cal estendre. 
*/

// Solución:
/* Imports de la classe */
import java.sql.*; 

/* Capa de Control de Dades */
class CtrlDadesPublic extends CtrlDadesPrivat {
	
	public ConjuntTuples consulta(Connection c, Tuple params) throws BDException {
        try {
            //delete
            ConjuntTuples ct = new ConjuntTuples();
            Statement st = c.createStatement();
            String D = params.consulta(1);
            String S = params.consulta(2);
            int esborrat = st.executeUpdate("delete from despatxos where modul ='"+D+"' and superficie <"+S+";");
            if(esborrat == 0) throw new BDException(12);
            
            //suma
            ResultSet r = st.executeQuery("select sum(superficie) from despatxos;");
            r.next();
            Tuple t = new Tuple();
            int sumasou = r.getInt(1);
            if (r.wasNull()) t.afegir("NO");
            else t.afegir(String.valueOf(sumasou));
            ct.afegir(t);
            
            //assigancions
            r = st.executeQuery("select p.nomProf, count(*) from professors p, assignacions a where p.dni = a.dni and " + 
            " a.instantFi is not null group by p.nomProf;");
            while(r.next()) {
                t = new Tuple();
                t.afegir(r.getString(1));
                t.afegir(r.getString(2));
                ct.afegir(t);
            }
            return ct;
        }
        catch (SQLException se) {
            if (se.getSQLState().equals("23503")) throw new BDException(13);
            throw new BDException(14);
        }
    }    
}
