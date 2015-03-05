package com.smt.mantis.procedure.ticket;

//JDK 1.7.0
import java.util.HashMap;

//log4j 1.2.15
import org.apache.log4j.Logger;

import com.smt.mantis.config.GlobalConfig;

/****************************************************************************
 * <b>Title</b>: DetailedInfoBuilder.java
 * <p/>
 * <b>Project</b>: MantisReport
 * <p/>
 * <b>Description: </b> <b>Copyright:</b> Copyright (c) 2014
 * <p/>
 * <b>Company:</b> Silicon Mountain Technologies
 * <p/>
 * 
 * @author Devon Franklin
 * @version 1.0
 * @since 11:56:00 AM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public class DetailBuilder extends SQLBuilder {

	private static Logger log = Logger.getLogger(DetailBuilder.class);

	/**
	 * Constructor that takes hashmap of request parameters
	 * 
	 * @param params
	 */
	public DetailBuilder(HashMap<String, String[]> params) {
		super(params);
	}

	@Override
	public String buildQuery() {

		boolean ticketSearch = false;
		this.sb = new StringBuilder();

		sb.append("SELECT mht.field_name, mht.old_value, mht.new_value, mut.username,");
		sb.append(" mht.type, from_unixtime(mht.date_modified, '%m/%d/%Y') as modDate");
		sb.append(" FROM mantis_bug_history_table mht");
		sb.append(" LEFT OUTER JOIN mantis_user_table mut");
		sb.append(" ON mht.user_id = mut.id");
		sb.append("	WHERE 1=1");

		for (String key : requestMap.keySet()) {

			appendQuery(key, requestMap.get(key));

			// check if user searched by just ticket no.
			if (key == "ticketID")
				ticketSearch = true;

		}

		// append date
		if (ticketSearch == false) {
			this.appendDate(GlobalConfig.MHT_DATE_MOD);
		}

		sb.append(" ORDER BY mht.id");
		log.debug(sb.toString());
		return sb.toString();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.siliconmtn.sql.SQLBuilder#setParamToSqlName()
	 */
	@Override
	public void setParamToSqlName() {
		sqlColumnNames.put(GlobalConfig.TICKET_ID, GlobalConfig.MHT_BUG_ID);
		sqlColumnNames.put(GlobalConfig.FIELD_NAME, GlobalConfig.MHT_FIELD_NAME);

	}

}
