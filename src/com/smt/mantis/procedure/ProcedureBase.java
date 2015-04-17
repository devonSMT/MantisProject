package com.smt.mantis.procedure;

//jdk 1.7.0
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

//log4j
import org.apache.log4j.Logger;
//jdbc
import com.mysql.jdbc.Connection;

/****************************************************************************
 * <b>Title</b>: ProcedureAbstractBase.java <p/>
 * <b>Project</b>: MantisReport <p/>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
 ************************************************************************/

public abstract class ProcedureBase implements ProcedureInterface {
	
	/**
	 * Provides a connection to the db for this procedure
	 */
	protected Connection dbConn = null;
   
	/**
	 * Provides a converter object allowing for conversions from db
	 */
	protected Converter converter = null;
	
	/**
	 * Provides a logger for this procedure
	 */
	protected static Logger log = null;

	/**
	 * Class constructor initializes class and logger for child classes
	 * @param ds
	 */
	public ProcedureBase() {
		this.converter = new Converter();
		log = Logger.getLogger(getClass());
	}

	/**
	 * Attempts to return a connection from pool
	 * @throws SQLException 
	 */
	public Connection getConnection() throws SQLException  {
		return dbConn;
	}
	
	/**
	 * Allows setting of a database connection
	 * @param conn
	 */
	public void setConnection(Connection conn){
		this.dbConn = conn;
	}
	
	/**
	 * Returns the database connection, implemented from interface
	 */
	@Override
	public Connection getDBConn(){
		return this.dbConn;
	}
	
	/**
	 * Sets the database connection to use, implemented from interface
	 */
	@Override
	public void setDBConn(Connection dbConn) {
		this.dbConn = dbConn;
	}
	
	/**
	 * Attempts to close the established connection, implemented from interface
	 */
	@Override
	public void closeDBConn(){
		try {
			dbConn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Selects a sql query from database then returns list of Object<?>
	 * @param requestMap
	 * @return
	 */
	public abstract ArrayList<?> selectQuery(
			HashMap<String, String[]> requestMap);

	/**
	 * Will prepare sql query by replacing all ? marks with proper data
	 * 
	 * @throws SQLException
	 */
	public void prepareQuery(PreparedStatement ps,
			HashMap<String, String> columnMap,
			HashMap<String, String[]> requestMap) throws SQLException {

		// set count for keeping track of what ? mark method is on
		int count = 1;
		
		for (String key : requestMap.keySet()) {
			String[] values = requestMap.get(key);
			
			// check if there is a match before entering second loop
			if (columnMap.get(key) == null || values[0] == "" ) {
				continue;
			}
			
			for (int i = 0; i < values.length; i++) {
				// use mapping to get right sql field name
				ps.setObject(count, values[i]);
				log.debug(columnMap.get(key));
				log.debug("Inside preparyQuery method, count is: " + count);
				count++;
			}
		}
	}

}
