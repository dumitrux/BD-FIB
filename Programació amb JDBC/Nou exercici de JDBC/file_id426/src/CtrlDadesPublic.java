
/* Imports de la classe */
import java.sql.*; 

/* Capa de Control de Dades */
class CtrlDadesPublic extends CtrlDadesPrivat {
	
	public ConjuntTuples consulta(Connection c, Tuple params) throws BDException {
		ConjuntTuples ct = new ConjuntTuples();
		
		return ct;
	}
}