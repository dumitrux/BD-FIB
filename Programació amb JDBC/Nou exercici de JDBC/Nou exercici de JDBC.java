/*
PASSOS PREVIS: LLegir el contingut del fitxer PassosASeguir.txt 

EXERCICI:
Heu d'implementar el mètode consulta. Aquest mètode ha d'obtenir per cada professor de la base de dades, el dni del professor, i el mòdul i número de l'últim despatx en què ha estat assignat. 

Cal tenir en compte que: 
- Si un professor té una assignació amb instantFi nul, això vol dir que aquesta és la seva assignació actual, i per tant l'última del professor. 
- En qualsevol altre cas la darrera assignació d'un professor és la que té un instantFi més gran. 
- Mai hi haurà dues assignacions d'un mateix professor en un mateix instant. 
- Si un professor no té cap assignació, s'haurà de posar "XXX" com a mòdul i "YYY" com a número de despatx. 

En cas que s'identifiqui una de les situacions següents, el mètode ha de llançar una excepció identificada amb el codi d'error que s'indica.
10: No hi ha cap professor
11: Error intern

Pel joc de proves públic el resultat que s'obtindrà és el següent:
111 Omega 128
222 Omega 118

En el fitxer adjunt trobareu: 
- Els passos a seguir: (PassosASeguir.txt)
- La descripció del conjunt del programa Practica: (ProgramaPractica.pdf) 
- Les classes i mètodes per obtenir els paràmetres d'entrada: (MetodesAuxiliars.txt) 
- Les classes i mètodes per retornar el resultat i llençar excepcions: (MetodesAuxiliars.txt) 
- El projecte Eclipse que cal estendre. 
*/

//Solución:
/* Imports de la classe */
import java.sql.*; 

/* Capa de Control de Dades */
class CtrlDadesPublic extends CtrlDadesPrivat {
    
    public ConjuntTuples consulta(Connection c, Tuple params) throws BDException {
        try {
            ConjuntTuples ct = new ConjuntTuples();
            PreparedStatement assignacio = c.prepareStatement("select modul, numero from assignacions where " + 
            " dni = ? and (instantfi IS NULL)");
            PreparedStatement maxintfi = c.prepareStatement("select max(instantfi) as instfi from assignacions where dni = ? ");
            PreparedStatement assigmax = c.prepareStatement("select modul, numero from assignacions where " + 
            " dni = ? and instantfi = ?");
            PreparedStatement dnis = c.prepareStatement("select dni from professors");
            PreparedStatement hi_es = c.prepareStatement("select * from assignacions where dni = ?");
            ResultSet rs = dnis.executeQuery();
            boolean hay_dni = false;
            if (rs.next()) hay_dni = true;
            else throw new BDException(10);
            while(hay_dni) {
                String mod, num;
                mod = "XXX";
                num = "YYY";
                Tuple fila = new Tuple();
                String s = rs.getString("dni");
                fila.afegir(s);
                
                assignacio.setString(1, s);
                ResultSet assignull= assignacio.executeQuery();
                if(assignull.next()) {
                    mod = assignull.getString("modul");
                    num = assignull.getString("numero");
                }
                    
                else {
                    hi_es.setString(1, s);
                    ResultSet his = hi_es.executeQuery();
                    if (his.next()) {
                    maxintfi.setString(1, s);
                    ResultSet max = maxintfi.executeQuery();
                    max.next();
                        if (!max.wasNull()) {
                            int in = max.getInt("instfi");
                            assigmax.setString(1, s);
                            assigmax.setInt(2, in);
                            ResultSet assigmx = assigmax.executeQuery();
                            assigmx.next();
                            mod = assigmx.getString("modul");
                            num = assigmx.getString("numero");
                        }    
                    }
                }
                fila.afegir(mod);
                fila.afegir(num);
                ct.afegir(fila);
                hay_dni = rs.next();
                }
            return ct;
            }
            catch(SQLException se){
                throw new BDException(11);
            }
    }
}