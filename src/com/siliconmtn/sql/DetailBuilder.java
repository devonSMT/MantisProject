package com.siliconmtn.sql;

import java.util.HashMap;

/****************************************************************************
 * <b>Title</b>: DetailedInfoBuilder.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since 11:56:00 AM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public class DetailBuilder extends SQLBuilder {

	/**
	 * Constructor that takes hashmap of request parameters
	 * @param params
	 */
	public DetailBuilder (HashMap<String, String[]> params){
		super(params);
	}
	
	@Override
	public String buildQuery() {
		this.sb = new StringBuilder();
		
		sb.append("SELECT mht.field_name, mht.old_value, mht.new_value, mut.username,");
		sb.append(" mht.type, from_unixtime(mht.date_modified, '%m/%d/%Y') as modDate");
		sb.append(" FROM mantis_bug_history_table mht");
		sb.append(" LEFT OUTER JOIN mantis_user_table mut");
		sb.append(" ON mht.user_id = mut.id");
		sb.append("	WHERE 1=1");
		
		for (String key : parameters.keySet()) {

			String query = evaluateParamName(key);
			if (!query.equals("")) {

				addParameter(query, parameters.get(key));
			}
		}
		sb.append(" ORDER BY mht.id");
		return sb.toString();
	}


	@Override
	protected String evaluateParamName(String paramName) {
		
		String result = null;

		switch (paramName) {

		case "ticketID":
			result = "mht.bug_id='";
			break;
		case "fieldName":
			result = "mht.field_name='";
			break;
		default:
			result = "";
		}

		return result;
	}

}
