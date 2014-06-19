package com.siliconmtn.sql;

//JDK 1.7.0
import java.text.ParseException;
import java.util.HashMap;

//log4j 1.2.15
import org.apache.log4j.Logger;

import com.siliconmtn.helper.Constants;

/****************************************************************************
 * <b>Title</b>: DetailedInfoBuilder.javaIncomingDataWebService.java
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

		this.sb = new StringBuilder();

		sb.append("SELECT mht.field_name, mht.old_value, mht.new_value, mut.username,");
		sb.append(" mht.type, from_unixtime(mht.date_modified, '%m/%d/%Y') as modDate");
		sb.append(" FROM mantis_bug_history_table mht");
		sb.append(" LEFT OUTER JOIN mantis_user_table mut");
		sb.append(" ON mht.user_id = mut.id");
		sb.append("	WHERE 1=1");

		for (String key : parameters.keySet()) {

			String query = evaluateParamName(key);
			if (!query.equals("none")) {

				addParameter(query, parameters.get(key));

			}
			
			
		}
		
		//append date
		try {
			this.appendDate(Constants.MHT_DATE_MOD);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		sb.append(" ORDER BY mht.id");
		log.debug(sb.toString());
		return sb.toString();
	}

	@Override
	public String evaluateParamName(String paramName) {

		String result = null;

		switch (paramName) {

		case Constants.TICKET_ID:
			result = Constants.MHT_BUG_ID + "='";
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
