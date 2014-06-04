package com.siliconmtn.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import com.siliconmtn.pojo.TicketVO;

/****************************************************************************
 * <b>Title</b>: Model.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since 12:27:26 PM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public abstract class Model {

	protected Connection conn = null;
	protected DataSource ds = null;
	protected  PreparedStatement prstmt = null;
	protected  ResultSet rs = null;
	
	 /**
	  * Class constructor that takes a datasource
	  * @param ds
	  */
	 public Model(DataSource ds){
		 this.ds = ds;
	 }
	 /**
	  * Will return a connection from pool using datasource
	  * @return
	  * @throws SQLException
	  */
	 public Connection getConnection() throws SQLException{
		conn =  ds.getConnection();
		
		return conn;
	 }	 
	 
	 
	 /**
	  * Builds a sql query
	  * @param requestMap
	  * @return 
	  */
	 public abstract ArrayList<TicketVO> runQuery(HashMap<String, String[]> requestMap);
	 
}
