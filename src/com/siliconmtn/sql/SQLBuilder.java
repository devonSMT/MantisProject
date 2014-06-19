package com.siliconmtn.sql;

//JDK 1.7.0
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

public abstract class SQLBuilder  {

	protected HashMap<String, String[]> parameters;
	protected StringBuilder sb = null;
	private DateHandler dh = null;

	/**
	 * No argument constructor
	 */
	public SQLBuilder() {
		this.sb = new StringBuilder();
	}

	/**
	 * Constructor that takes a hashmap of request parameters
	 * 
	 * @param params
	 */
	public SQLBuilder(HashMap<String, String[]> params) {
		this.parameters = params;

	}
	
	/**
	 * Abstract method for building a sql query string
	 * @return
	 */
	public abstract String buildQuery();
	
	/**
	 * Abstract method for evaluating parameter names
	 * @param paramName
	 * @return
	 */
	public abstract String evaluateParamName(String paramName);
	
	/**
	 * Checks if a parameter exist, if it does will append appropriate query
	 * string
	 * 
	 * @param parameter
	 * @param values
	 */
	public void addParameter(String query, String[] values) {

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
	 * Checks date values and appends to query string. If no date is found will
	 * append a default date
	 * 
	 * @param sqlDateField - SQL field to compare date's against
	 * @throws ParseException
	 */
	public void appendDate(String sqlDateField) throws ParseException {

		this.dh = new DateHandler();

		Long start = null;
		Long end = null;

		String startDate = dh.checkForDate(this.parameters,"startDay", "startMonth", "startYear");
		String endDate = dh.checkForDate(this.parameters, "endDay", "endMonth", "endYear");

		// if no date parameters passed give default date
		if (startDate.equals("no date")) {

			start = this.dh.getEpochTime(dh.getPastWeek(), false);
			end = this.dh.getEpochTime(dh.getCurrentDate(), true);
			

		} else {
			dh.formatDate(startDate);
			dh.formatDate(endDate);
			start = this.dh.getEpochTime(startDate, false);
			end = this.dh.getEpochTime(endDate, true);

		}

		sb.append(" AND " + sqlDateField + " BETWEEN " + start + " AND " + end);
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
