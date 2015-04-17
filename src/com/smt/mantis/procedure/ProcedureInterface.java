package com.smt.mantis.procedure;

import com.mysql.jdbc.Connection;

/****************************************************************************
 * Title: ProcedureInterface.java <p/>
 * Project: MantisReport <p/>
 * Description: <p/>Implements the com.mysql.jdbc.Connection
 * Copyright: Copyright (c) 2015<p/>
 * Company: Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since Apr 16, 2015
 ****************************************************************************/

public interface ProcedureInterface {
	
	/**
	 * SQL retrieve procedure for select statements
	 */
	public void retrieve();
	
	/**
	 * Returns the database connection
	 */
	public Connection getDBConn();
	
	/**
	 * Sets the database connection
	 */
	public void setDBConn(Connection dbConn);
	
	/**
	 * Attempts to close the established connection
	 */
	public void closeDBConn();
}
