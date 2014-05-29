package com.siliconmtn.model;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import com.siliconmtn.pojo.TicketVO;
import com.siliconmtn.sql.TicketBuilder;

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

public class TicketModel extends Model{

	private TicketBuilder tckBuild = null;
	
	 /**
	  * Class constructor that takes a datasource
	  * @param ds
	  */
	 public TicketModel(DataSource ds){
		 super(ds);
	 }
	 
	 /**
	  * Builds a list of tickets based on sql query
	  * @param requestMap
	  * @return list of ticketVOs
	  */
	 public ArrayList<TicketVO> runQuery(HashMap<String, String[]> requestMap){
		 
		 ArrayList<TicketVO> ticketList = new ArrayList<TicketVO>();
		 
		try {

			this.getConnection();
			
			// build SQL query
			tckBuild = new TicketBuilder(requestMap);
			String sql = tckBuild.buildQuery();

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

		} catch (SQLException e) {
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

}
