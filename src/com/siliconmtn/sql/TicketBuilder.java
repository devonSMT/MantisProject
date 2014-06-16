package com.siliconmtn.sql;

//JDK 1.7.0
import java.text.ParseException;
import java.util.HashMap;
//log4j 1.2.15
import org.apache.log4j.Logger;

import com.siliconmtn.helper.Constants;

/****************************************************************************
 * <b>Title</b>: TicketBuilder.javaIncomingDataWebService.java
 * <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed
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

	private static Logger log = Logger.getLogger(TicketBuilder.class);

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
	 * Builds query string to ticket info
	 */
	public String buildQuery() {

		boolean ticketSearch = false;
		this.sb = new StringBuilder();

		sb.append(" SELECT mbt.id, mbt.summary, mbt.status,");
		sb.append(" from_unixtime(mht.date_modified, '%m/%d/%Y' ) as lastUpdate,");
		sb.append(" mpt.name, mut.username, CONCAT(cf.name, '') AS customNames, cfs.value,");
		sb.append(" mht.field_name, mht.date_modified");
		sb.append(" FROM mantis_project_table mpt");
		sb.append(" RIGHT OUTER JOIN mantis_bug_table mbt");
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

		for (String key : parameters.keySet()) {

			String query = evaluateParamName(key);
			if (!query.equals("none")) {

				addParameter(query, parameters.get(key));
			}
			// check if user searched by just ticket no.
			if (key.equals("ticketID")) {
				ticketSearch = true;
			}
		}

		if (!ticketSearch) {
			try {
				this.appendDate("mht.date_modified");
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		sb.append(" ORDER BY mbt.id");
		log.debug(sb.toString());
		return sb.toString();
	}

	/**
	 * Returns a result based on a given parameter name
	 * 
	 * @param paramName
	 * @return
	 */
	public String evaluateParamName(String paramName) {

		String result = null;

		switch (paramName) {

		case Constants.USER_NAME:
			result = Constants.MUT_USER + "='";
			break;
		case Constants.PROJECT_NAME:
			result = Constants.MPT_NAME + "='";
			break;
		case Constants.STATUS_FILTER:
			result = Constants.MBT_STATUS + "='";
			break;
		case Constants.TICKET_ID:
			result = Constants.MBT_ID + "='";
			break;
		case Constants.FIELD_NAME:
			result = Constants.MHT_FIELD_NAME + "='";
			break;
		default:
			result = "none";
		}

		return result;
	}

}
