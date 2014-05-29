package com.siliconmtn.sql;

import java.util.HashMap;

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
	 * Will return a specific value from parameter list
	 * 
	 * @param values
	 * @param position
	 * @return
	 */
	public String getParamValue(String[] values, int position) {

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
