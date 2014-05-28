package com.siliconmtn.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import com.siliconmtn.pojo.TicketVO;
import com.siliconmtn.sql.SQLBuilder;

/****************************************************************************
 * <b>Title</b>: Model.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon
 * @version 1.0
 * @since 1:53:48 PM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public class Model {
	private Connection conn = null;
	private DataSource ds = null;
	private PreparedStatement prstmt = null;
	private ResultSet rs = null;
	private SQLBuilder sqlBuild = null;
	 /**
	  * Class constructor that takes a datasource
	  * @param ds
	  */
	 public Model(DataSource ds){
		 this.ds = ds;
	 }
	 
	 /**
	  *Will make connection to database and perform querying of database
	  */
	 public ArrayList<TicketVO> runQuery(HashMap<String, String[]> requestMap){
		 ArrayList<TicketVO> ticketList = new ArrayList<TicketVO>();
		 
		try {

			getConnection();
			
			// build SQL query
			sqlBuild = new SQLBuilder(requestMap);

			String sql = sqlBuild.buildQuery();;

			prstmt = conn.prepareStatement(sql);
			rs = prstmt.executeQuery();

			int previousID = -1;
	
			while (rs.next()) {

				int ticketID = rs.getInt("mbt.id");

				if (ticketID != previousID) {
					ticketList.add(new TicketVO(rs));
				
				} else {
					ticketList.get(ticketList.size() - 1).getCustomFields()
							.put(rs.getString("customNames"),rs.getString("cfs.value"));
				}
				previousID = ticketID;

			}
			

		} catch (SQLException | ParseException e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		
		return ticketList;
	 }
	 
	 /**
	  * Will return a connection from pool using datasource
	  * @return
	  * @throws SQLException
	  */
	 private Connection getConnection() throws SQLException{
		conn =  ds.getConnection();
		
		return conn;
	 }	 


}
