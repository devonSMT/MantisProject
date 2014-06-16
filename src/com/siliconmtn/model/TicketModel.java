package com.siliconmtn.model;

//JDK 1.7.0
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;

import javax.sql.DataSource;
//log4j 1.2.15
import org.apache.log4j.Logger;

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
	
	private static Logger log = Logger.getLogger(TicketModel.class);
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
			
			//build list of TicketVO's
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
		
		//Sorting the list to order by date
		Collections.sort(ticketList, new Comparator<TicketVO>() {

				@Override
				public int compare(TicketVO ticket1, TicketVO ticket2) {
					
					return ticket1.getDateModified().compareTo(ticket2.getDateModified());
				}
		    });
		//Reverse the order
		Collections.reverse(ticketList);
		log.debug(ticketList.get(0));
		log.debug(ticketList.get(1));
		return ticketList;
	
	 }
}
