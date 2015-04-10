package com.smt.mantis.procedure.ticket;
//jdk 1.7.0
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;


//javax 1.7.x
import javax.sql.DataSource;

//m.r 2.0
import com.smt.mantis.procedure.ProcedureBase;

/****************************************************************************
 * <b>Title</b>: TicketDetailProcedure.java <p/>
 * <b>Project</b>: MantisReport <p/>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
 ************************************************************************/

public class DetailProcedure extends ProcedureBase {
	
	/**
	 * Class constructor takes Datasource for argument
	 * @param ds
	 */
	public DetailProcedure(DataSource ds){
		super(ds);
	}

	/* (non-Javadoc)
	 * @see com.siliconmtn.model.Model#runQuery(java.util.HashMap)
	 */
	@Override
	public ArrayList<DetailVO> selectQuery(HashMap<String, String[]> requestMap) {
		 ArrayList<DetailVO> voList = new ArrayList<DetailVO>();
		 
		 PreparedStatement ps = null;
		 ResultSet rs = null;
			try {
				this.getConnection();
				
				// build SQL query
				DetailBuilder dtBuild = new DetailBuilder(requestMap);
				String sql = dtBuild.buildQuery();
				log.debug(sql);
				
				ps = conn.prepareStatement(sql);
				rs = ps.executeQuery();
				
				//build list of DetailVO's
				while (rs.next()) {
					DetailVO dvo = new DetailVO(rs);
					voList.add(dvo);
				}		

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
			
			return voList;
		 }
}
