package com.siliconmtn.sql;

//JDK 1.7.0
import java.util.HashMap;
//M.R. 1.0
import com.siliconmtn.helper.Constants;

/****************************************************************************
 * <b>Title</b>: TicketBuilder.java
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
 * @since 10:21:47 AM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public class TicketBuilder extends SQLBuilder {

	/**
	 * Constructor that takes hash map of request parameters
	 * 
	 * @param params
	 */
	public TicketBuilder(HashMap<String, String[]> params) {
		super(params);

	}

	@Override
	/**
	 * Builds sql query for ticket info based on request parameters
	 */
	public String buildQuery() {
		// set mapping
		this.setParamToSqlName();

		boolean ticketSearch = false;

		sb.append(" SELECT mbt.id, mbt.summary, mbt.status,");
		sb.append(" from_unixtime(mht.date_modified, '%m/%d/%Y' ) as lastUpdate,");
		sb.append(" mpt.name, mut.username, CONCAT(cf.name, '') AS customNames, cfs.value,");
		sb.append(" mht.field_name, mht.date_modified");
		sb.append(" FROM mantis_project_table mpt");
		sb.append(" INNER JOIN mantis_bug_table mbt");
		sb.append(" ON mpt.id = mbt.project_id");
		sb.append(" LEFT OUTER JOIN mantis_user_table mut");
		sb.append(" ON mbt.handler_id = mut.id");
		sb.append(" LEFT OUTER JOIN mantis_custom_field_string_table cfs");
		sb.append(" ON mbt.id = cfs.bug_id");
		sb.append(" LEFT OUTER JOIN mantis_custom_field_table cf");
		sb.append(" ON cfs.field_id = cf.id");
		sb.append(" LEFT OUTER JOIN mantis_bug_history_table mht");
		sb.append(" ON mht.bug_id = mbt.id");
		sb.append(" WHERE 1=1");

		// Loop through requestMap of parameters
		for (String key : requestMap.keySet()) {

			// determine to add request parameter to query or not
			appendQuery(key, requestMap.get(key));

			// check if user searched by just ticket no.
			if (key == "ticketID")
				ticketSearch = true;
		}
		
		// append date
		if (ticketSearch == false) {
			this.appendDate(Constants.MHT_DATE_MOD);
		}

		sb.append(" ORDER BY mbt.id");
		log.debug(sb.toString());
		return sb.toString();
	}

	/**
	 * Sets a mapping for request parameters to their appropriate sql column
	 * name
	 */
	public void setParamToSqlName() {

		sqlColumnNames.put(Constants.USER_NAME, Constants.MUT_USER);
		sqlColumnNames.put(Constants.PROJECT_NAME, Constants.MPT_NAME);
		sqlColumnNames.put(Constants.STATUS_FILTER, Constants.MBT_STATUS);
		sqlColumnNames.put(Constants.TICKET_ID, Constants.MBT_ID);
		sqlColumnNames.put(Constants.FIELD_NAME, Constants.MHT_FIELD_NAME);

	}

}
