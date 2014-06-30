package com.siliconmtn.sql;

//JDK 1.7.0
import java.text.ParseException;
import java.util.HashMap;

import org.apache.log4j.Logger;

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

public abstract class SQLBuilder {

	protected HashMap<String, String[]> requestMap = null;
	protected HashMap<String, String> sqlParamNames = null;
	protected StringBuilder sb = null;
	private DateHandler dh = null;
	protected static Logger log;

	/**
	 * Creates a new stringBuilder and makes new hashMap for SQLParamName
	 * mapping, also makes logger (available for all children)
	 */
	public SQLBuilder() {
		this.sb = new StringBuilder();
		this.sqlParamNames = new HashMap<String, String>();
		log = Logger.getLogger(getClass());
	}

	/**
	 * Creates a new stringBuilder, sets the given request parameters to global
	 * parameters and makes new hashMap for SQLParamName mapping also makes
	 * logger (available for all children)
	 * 
	 * @param params
	 */
	public SQLBuilder(HashMap<String, String[]> params) {
		this.sb = new StringBuilder();
		this.requestMap = params;
		this.sqlParamNames = new HashMap<String, String>();
		log = Logger.getLogger(getClass());
	}

	/**
	 * Abstract method for building a sql query string
	 * 
	 * @return
	 */
	public abstract String buildQuery();

	/**
	 * Abstract method for evaluating parameter names
	 * 
	 * @param paramName
	 * @return
	 */
	public abstract String evaluateParamName(String paramName);

	/**
	 * Set mapping from request parameters to appropriate sql column name
	 */
	public abstract void setSqlParamNames();

	/**
	 * Will loop through array of a request parameters values and build into sql
	 * query
	 * 
	 * @param parameter
	 * @param values
	 */
	public void appendParameter(String paramName, String[] values) {
		
		//need to place proper sql column names here with ? marks
		for (int i = 0; i < values.length; i++) {		
			if (i < 1 && values[i] != "") {
				// use mapping to get right sql field name
				if (sqlParamNames.get(paramName) != null) {
					sb.append(" AND( ");
					sb.append(sqlParamNames.get(paramName));
					sb.append("= ?");
					log.debug(sqlParamNames.get(paramName));
				}

			} else if (values[i] != "") {
				if (sqlParamNames.get(paramName) != null) {
					sb.append(" OR ");
					sb.append(sqlParamNames.get(paramName));
					sb.append("= ?");
					log.debug(sqlParamNames.get(paramName));
				}
			}
		}
		sb.append(")");
	}

	/**
	 * Checks date values and appends to query string. If no date is found will
	 * append a default date
	 * 
	 * @param sqlDateField
	 *            - SQL field to compare date's against
	 * @throws ParseException
	 */
	public void appendDate(String sqlDateField) throws ParseException {

		this.dh = new DateHandler();

		Long start = null;
		Long end = null;

		String startDate = dh.checkForDate(this.requestMap, "startDay",
				"startMonth", "startYear");
		String endDate = dh.checkForDate(this.requestMap, "endDay", "endMonth",
				"endYear");

		// if no date parameters passed give default date
		if (startDate.equals("no date")) {

			start = this.dh.getEpochTime(dh.getPastWeek(), false);
			end = this.dh.getEpochTime(dh.getCurrentDate(), true);

			// Or use given dates and convert to long
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
		return requestMap;
	}

	/**
	 * @param params
	 *            the params to set
	 */
	public void setParams(HashMap<String, String[]> params) {
		this.requestMap = params;
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
