package com.siliconmtn.model;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.sql.DataSource;

import com.siliconmtn.pojo.DetailVO;
import com.siliconmtn.sql.DetailBuilder;

/****************************************************************************
 * <b>Title</b>: DetailModel.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since 1:16:06 PM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public class DetailModel extends Model {
	
	/**
	 * Class constructor takes Datasource for argument
	 * @param ds
	 */
	public DetailModel(DataSource ds){
		super(ds);
	}

	/* (non-Javadoc)
	 * @see com.siliconmtn.model.Model#runQuery(java.util.HashMap)
	 */
	@Override
	public ArrayList<DetailVO> runQuery(HashMap<String, String[]> requestMap) {
		 ArrayList<DetailVO> voList = new ArrayList<DetailVO>();
		 
			try {
				this.getConnection();
				
				// build SQL query
				DetailBuilder dtBuild = new DetailBuilder(requestMap);
				String sql = dtBuild.buildQuery();

				prstmt = conn.prepareStatement(sql);
				rs = prstmt.executeQuery();
				
				//build list of DetailVO's
				while (rs.next()) {
					DetailVO dvo = new DetailVO(rs);
					voList.add(dvo);
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
			
			return voList;
		 }
}
