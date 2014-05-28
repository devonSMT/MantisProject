package com.siliconmtn.sql;

import java.text.ParseException;
import java.util.HashMap;

import com.siliconmtn.date.DateHandler;

/****************************************************************************
 * <b>Title</b>: SQLBuilder.javaIncomingDataWebService.java
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
 * @since 10:02:19 AM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public class SQLBuilder {

	private HashMap<String, String[]> parameters;
	private StringBuilder sb = null;
	private DateHandler dh = null;

	/**
	 * No argument class constructor
	 */
	public SQLBuilder() {

	}

	/**
	 * Class constructor that takes a hashmap of request parameters
	 * 
	 * @param params
	 */
	public SQLBuilder(HashMap<String, String[]> params) {
		this.parameters = params;

	}

	/**
	 * Builds the sql query to be used
	 * 
	 * @return
	 * @throws ParseException
	 */
	public String buildQuery() throws ParseException {

		Long start = null;
		Long end = null;
		
		this.dh = new DateHandler();
		this.sb = new StringBuilder();

		sb.append("SELECT mbt.id, mbt.summary, mbt.status,");
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

		// check for any request parameters
		for (String key : parameters.keySet()) {

			String query = evaluateParamName(key);
			if (!query.equals("")) {

				addParameter(query, parameters.get(key));
			}
		}

		String startDate = this.fetchDate("startDay", "startMonth","startYear");
		String endDate = this.fetchDate("endDay", "endMonth", "endYear");

		// default to pass 7 days
		if (startDate.length() < 3) {
			
			start = this.dh.getEpochTime(dh.getPastWeek(), false);			
			end = this.dh.getEpochTime(dh.getCurrentDate(), true);
		
			//display current dates
		} else {
			dh.formatDate(startDate);
			dh.formatDate(endDate);
			start = this.dh.getEpochTime(startDate, false);
			end = this.dh.getEpochTime(endDate, true);
			
		}
		
		sb.append(" AND mbt.last_updated BETWEEN " + start + " AND " + end);
		sb.append(" ORDER BY mbt.last_updated DESC");

		return sb.toString();
	}

	/**
	 * Checks if a parameter exist, if it does will append appropriate query
	 * string
	 * 
	 * @param parameter
	 * @param values
	 */
	private void addParameter(String query, String[] values) {

		if (values[0] != "") {

			for (int i = 0; i < values.length; i++) {
				if (i < 1 && values[i] != "") {
					this.sb.append(" AND( " + query + values[i] + "'");
				} else if (values[i] != "") {
					this.sb.append(" OR " + query + values[i] + "'");
				}
			}
			sb.append(")");
		}
	}

	/**
	 * Returns a result based on a given parameter name
	 * 
	 * @param paramName
	 * @return
	 */
	private String evaluateParamName(String paramName) {

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

	/**
	 * Will return a specific value from parameter list
	 * 
	 * @param values
	 * @param position
	 * @return
	 */
	private String getParamValue(String[] values, int position) {

		String value = values[position];

		return value;
	}
	
	/**
	 * @return the params map
	 */
	public HashMap<String, String[]> getParams() {
		return parameters;
	}

	/**
	 * @param params
	 *            the params to set
	 */
	public void setParams(HashMap<String, String[]> params) {
		this.parameters = params;
	}

	/**
	 * @return the sb
	 */
	public StringBuilder getSb() {
		return sb;
	}

	/**
	 * @param sb
	 *            the sb to set
	 */
	public void setSb(StringBuilder sb) {
		this.sb = sb;
	}
}
