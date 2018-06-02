/* 
PASSOS PREVIS: LLegir el contingut del fitxer PassosASeguir.txt 
EXERCICI:
Heu d'implementar el mètode consulta. Aquest mètode ha de:
- Retornar els despatxos de la base de dades on NO ha estat assignat el professor amb el dni que s'indica en els paràmetres d'entrada. 
- Per cada despatx cal donar el mòdul i número de despatx. 

Cal tenir en compte que:
- En els paràmetres d'entrada només hi haurà una línia amb el dni d'un professor. Ignoreu i NO editeu la segona línia, -999, que marca el final del fitxer. 
- L'exercici per anar bé s'ha de resoldre amb màxim una sentència de consulta.

En cas que s'identifiqui una de les situacions següents, el mètode ha de llançar una excepció identificada amb el codi d'error que s'indica.
11: No hi ha cap despatx on NO hagi estat assignat el professor 
12: Error intern

Pel joc de proves públic el resultat que s'obtindrà és el següent:
Omega		118

En el fitxer adjunt trobareu: 
- Els passos a seguir: (PassosASeguir.txt)
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
        ConjuntTuples ct = new ConjuntTuples();
        PreparedStatement ps = c.preparedStatement("select modul, numero from despatxos d " + 
        " where not exists(select * from assignacions a where d.modul = a.modul and d.numero = a.numero and dni = ?);");
        int i = 1;
        String s = params.consulta(i);
        while(!s.equals("-999")) {
			boolean no_hay = true;
			ps.setString(1, s);
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				Tuple fila = new Tuple();
				String mod = rs.getString("modul");
				String num = rs.getString("numero");
				fila.afegir(mod);
				fila.afegir(num);
				ct.afegir(fila);
				no_hay = false;
			}
			if (no_hay) throw new BDException(11);
			++i;
			s = params.consulta(i);
        }
        return ct;
        }
        catch(SQLException se) {
			throw new BDException(12);
        }
    }    
}
     
