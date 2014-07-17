package com.siliconmtn.model;

//JDK 1.7.0
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import javax.sql.DataSource;

import com.siliconmtn.pojo.TicketVO;
import com.siliconmtn.sql.TicketBuilder;

//log4j 1.2.15

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
 * @author Devon
 * @version 1.0
 * @since 1:53:48 PM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public class TicketModel extends Model {

	private TicketBuilder ticketBuild = null;

	/**
	 * Class constructor that takes a data source
	 * 
	 * @param ds
	 */
	public TicketModel(DataSource ds) {
		super(ds);
	}

	/**
	 * Builds a list of tickets based on sql query
	 * 
	 * @param requestMap
	 * @return list of ticketVOs
	 */
	public ArrayList<TicketVO> selectQuery(HashMap<String, String[]> requestMap) {

		ArrayList<TicketVO> ticketList = new ArrayList<TicketVO>();

		PreparedStatement ps = null;
		ResultSet rs = null;
		try {

			this.getConnection();

			// build SQL query
			ticketBuild = new TicketBuilder(requestMap);
			String ticketQuery = ticketBuild.buildQuery();

			log.debug(ticketBuild.getSqlColumnNames().toString());
			ps = conn.prepareStatement(ticketQuery);

			// prepare query before executing
			this.prepareQuery(ps, ticketBuild.getSqlColumnNames(), requestMap);
			rs = ps.executeQuery();
			
			//build list of Tickets
			int count = 0;
			int ticketNo = 0;
			TicketVO tvo = null;
			while(rs.next()) {
				
			ticketNo = rs.getInt("mbt.id");

				if(count != ticketNo){
					//add to list
					if(tvo != null) ticketList.add(tvo);
					//create a new vo
					tvo = new TicketVO(rs);
				}else{
					//add additional data to previous ticket vo
					tvo.getCustomFields().put(rs.getString("customNames"),
							rs.getString("cfs.value"));
				}
				//set count to previous ticket number
				count = ticketNo;
			}
			ticketList.add(tvo);
			log.debug(ticketList.toString());
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				this.closeConnection();
			if (ps != null) {
				try {
					ps.close();

				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		
		//sort the list
		Collections.sort(ticketList);
		
		log.debug(ticketList.toString());	
		return ticketList;

	}
}
