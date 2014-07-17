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
	protected HashMap<String, String> sqlColumnNames = null;
	protected StringBuilder sb = null;
	private DateHandler dh = null;
	protected static Logger log;

	/**
	 * Creates a new stringBuilder and makes new hashMap for SQLParamName
	 * mapping, also makes logger (available for all children)
	 */
	public SQLBuilder() {
		this.sb = new StringBuilder();
		this.sqlColumnNames = new HashMap<String, String>();
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
		this.sqlColumnNames = new HashMap<String, String>();
		log = Logger.getLogger(getClass());
	}

	/**
	 * Abstract method for building a sql query string
	 * 
	 * @return
	 */
	public abstract String buildQuery();

	/**
	 * Set mapping from request parameters to appropriate sql column name
	 */
	public abstract void setParamToSqlName();

	/**
	 * Will loop through array of a request parameters values and build into sql
	 * query. Need to ensure you have proper names mapped to setParamToSqlName()
	 * to get back desired results to query
	 * 
	 * @param parameter
	 * @param values
	 */
	public void appendQuery(String paramName, String[] values) {
		// check if there is a match before looping
		if (sqlColumnNames.get(paramName) == null || values[0] == "") {
			return;
		}

		// if match loop through and append sql query based on number 
		//of values in String[]
		for (int i = 0; i < values.length; i++) {
			if (i < 1) {
				// use mapping to get right sql field name
				sb.append(" AND( ");
				sb.append(sqlColumnNames.get(paramName));
				sb.append(" = ?");

			} else {
				sb.append(" OR ");
				sb.append(sqlColumnNames.get(paramName));
				sb.append(" = ?");

			}
		}
		log.debug(sqlColumnNames.get(paramName));
		sb.append(")");
	}

	/**
	 * Checks date values and appends to query string. If no date is found will
	 * append a default date
	 * 
	 * @param sqlDateField
	 *            - SQL field to compare date's against
	 */
	public void appendDate(String sqlDateField) {

		this.dh = new DateHandler();

		Long start = null;
		Long end = null;

		//I am getting the date back from the database in a data format
		
		//however i am doing just one big sql select statement that varies
		//on request parameters
		
		//so the information/tickets i am getting back depends on the
		//query that I am building
		
		//that query goes to the db and gets anything that matches
		
		//so I can't get info back from the db first then compare it will be
		//to late
		
		//but can i change the int date in the database to a formatted date
		//string and compare that to the concatenated date
		
		//what to compare formatted mysql date to string date that is made
		
		//so how to compare formatted date to two strings??
		
		//so do a formatDate whatever on the sql column field
			
		//so i am converting the date(04-24-12) into it's long equivalent
		
		//do I need to convert it to long for comparison
		
		//b/c if so then I do 
		
//		if(this.requestMap.size() <= 1 ){
//			//don't loop
//			
//			//create default date
//		}else{
//			
//			String startDt = dh.makeDate(requestMap.get("startMonth")[0], 
//					requestMap.get("startDay")[0], requestMap.get("startYear")[0]);
//			
//			String endDt = dh.makeDate(requestMap.get("endMonth")[0], 
//					requestMap.get("endDay")[0], requestMap.get("endYear")[0]);
//			
//		}
			
		//Old Way
		String startDate = dh.checkForDate(this.requestMap, "startDay",
				"startMonth", "startYear");
		String endDate = dh.checkForDate(this.requestMap, "endDay", "endMonth",
				"endYear");

		// if no date parameters passed give default date
		if (startDate.equals("no date")) {

			try {
				
			start = this.dh.getEpochTime(dh.getPastWeek(), false);
			end = this.dh.getEpochTime(dh.getCurrentDate(), true);
			
			} catch (ParseException e) {
				e.printStackTrace();
			}

			// Or use given dates and convert to long
		} else {
			//don't even need formatDate, hasn't even been working
			//	startDate = dh.formatDate(startDate);
			//	dh.formatDate(endDate);
			try {
				start = this.dh.getEpochTime(startDate, false);
				end = this.dh.getEpochTime(endDate, true);

			} catch (ParseException e) {
				e.printStackTrace();
			}

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
	 * @param sb  the sb to set
	 */
	public void setSb(StringBuilder sb) {
		this.sb = sb;
	}

	/**
	 * @return the sqlColumnNames
	 */
	public HashMap<String, String> getSqlColumnNames() {
		return sqlColumnNames;
	}

	/**
	 * @param sqlColumnNames the sqlColumnNames to set
	 */
	public void setSqlColumnNames(HashMap<String, String> sqlColumnNames) {
		this.sqlColumnNames = sqlColumnNames;
	}
}
