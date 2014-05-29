package com.siliconmtn.sql;

import java.text.ParseException;
import java.util.HashMap;

import com.siliconmtn.date.DateHandler;

/****************************************************************************
 * <b>Title</b>: TicketBuilder.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since 10:21:47 AM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public class TicketBuilder extends SQLBuilder{

	private DateHandler dh = null;
	
	/**
	 * Constructor takes takes hashmap of request parameters
	 * @param params
	 */
	public TicketBuilder(HashMap<String, String[]> params){
		super(params);
	}
	
	@Override
	/**
	 * Builds query string to ticket info
	 */
	public String buildQuery() {
		
		this.sb = new StringBuilder();
		
		sb.append(" SELECT mbt.id, mbt.summary, mbt.status,");
		sb.append(" from_unixtime(mbt.last_updated, '%m/%d/%Y' ) as lastUpdate,");
		sb.append(" mpt.name, mut.username, CONCAT(cf.name, '') AS customNames, cfs.value");
		sb.append(" FROM mantis_project_table mpt");
		sb.append(" RIGHT OUTER JOIN mantis_bug_table mbt");
		sb.append(" ON mpt.id = mbt.project_id");
		sb.append(" LEFT OUTER JOIN mantis_user_table mut");
		sb.append(" ON mbt.handler_id = mut.id");
		sb.append(" LEFT OUTER JOIN mantis_custom_field_string_table cfs");
		sb.append(" ON mbt.id = cfs.bug_id");
		sb.append(" LEFT OUTER JOIN mantis_custom_field_table cf");
		sb.append(" ON cfs.field_id = cf.id");
		sb.append(" WHERE 1=1");
		
		for (String key : parameters.keySet()) {

			String query = evaluateParamName(key);
			if (!query.equals("")) {

				addParameter(query, parameters.get(key));
			}
		}
		try {
			this.appendDate();
		} catch (ParseException e) {
			e.printStackTrace();
		}	
		
		sb.append(" ORDER BY mbt.last_updated DESC");
		
		return sb.toString();
	}

	/**
	 * Returns a result based on a given parameter name
	 * 
	 * @param paramName
	 * @return
	 */
	protected String evaluateParamName(String paramName) {

		String result = null;

		switch (paramName) {

		case "userName":
			result = "mut.username='";
			break;
		case "projectName":
			result = "mpt.name='";
			break;
		case "statusFilter":
			result = "mbt.status='";
			break;
		case "ticketID":
			result = "mbt.id='";
			break;
		default:
			result = "";
		}

		return result;
	}

	/**
	 * Checks date values and appends to query string. If no date is found will
	 * append a default date
	 * @throws ParseException
	 */
	public void appendDate() throws ParseException{
		
		this.dh = new DateHandler();
		
		Long start = null;
		Long end = null;
				
		String startDate = this.fetchDate("startDay", "startMonth","startYear");
		String endDate = this.fetchDate("endDay", "endMonth", "endYear");

		if (startDate.length() < 3) {
			
			start = this.dh.getEpochTime(dh.getPastWeek(), false);			
			end = this.dh.getEpochTime(dh.getCurrentDate(), true);

		} else {
			dh.formatDate(startDate);
			dh.formatDate(endDate);
			start = this.dh.getEpochTime(startDate, false);
			end = this.dh.getEpochTime(endDate, true);
			
		}
		
		sb.append(" AND mbt.last_updated BETWEEN " + start + " AND " + end);
	}
	
	/**
	 * Searches through list of request parameters for date parameters
	 * 
	 * @param dayParam
	 * @param monthParam
	 * @param yearParam
	 * @return
	 */
	private String fetchDate(String dayParam, String monthParam,
			String yearParam) {

		String day = "";
		String month = "";
		String year = "";

		for (String key : parameters.keySet()) {

			if (key.equals(dayParam)) {
				day = getParamValue(parameters.get(key), 0);
			}
			if (key.equals(monthParam)) {
				month = getParamValue(parameters.get(key), 0);
			}
			if (key.equals(yearParam)) {
				year = getParamValue(parameters.get(key), 0);
			}
		}

		this.dh = new DateHandler(month, day, year);
		String date = dh.getFulldate();

		return date;
	}

}
