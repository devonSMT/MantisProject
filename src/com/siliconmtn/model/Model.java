package com.siliconmtn.model;

//JDK 1.7.0
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import org.apache.log4j.Logger;

/****************************************************************************
 * <b>Title</b>: Model.javaIncomingDataWebService.java
 * <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed
 * <p/>
 * <b>Description: </b> <b>Copyright:</b> Copyright (c) 2014
 * <p/>
 * <b>Company:</b> Silicon Mountain Technologies
 * <p/>
 * 
 * @author Devon Franklin
 * @version 1.0
 * @since 12:27:26 PM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public abstract class Model {

	protected Connection conn = null;
	protected DataSource ds = null;
	protected Logger log = null;

	/**
	 * Class constructor that takes a datasource
	 * 
	 * @param ds
	 */
	public Model(DataSource ds) {
		this.ds = ds;
		this.log = Logger.getLogger(getClass());
	}

	/**
	 * Will return a connection from pool using datasource
	 * 
	 * @return
	 * @throws SQLException
	 */
	public Connection getConnection() throws SQLException {
		conn = ds.getConnection();

		return conn;
	}

	/**
	 * Close's a datasource connection
	 */
	public void closeConnection() {
		try {
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Selects a sql query from database then returns list of Object<?>
	 * 
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
