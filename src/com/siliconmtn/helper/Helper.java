package com.siliconmtn.helper;

//JDK 1.7.0
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
//log4j 1.2.15
import org.apache.log4j.Logger;

/****************************************************************************
 * <b>Title</b>: HelperFunctions.javaIncomingDataWebService.java
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
 * @since 4:21:14 PM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/
/*
 * Class will have general functions that can be used throughout entire project
 */
public class Helper {

	private static Logger log = Logger.getLogger(Helper.class);
	
	/**
	 * Retrieves all request parameters and stores in string - string array
	 * value pairing map
	 * @param request
	 * @return
	 */
	public HashMap<String, String[]> getAllParameters(HttpServletRequest request) {
		
		// get any request parameters
		HashMap<String, String[]> requestMap = new HashMap<String, String[]>();
		Enumeration<String> em = request.getParameterNames();

		while (em.hasMoreElements()) {
			String key = (String) em.nextElement();
			String[] values = request.getParameterValues(key);

			requestMap.put(key, values);
		}
		
		return requestMap;
	}

	/**
	 * Checks servletRequest for request parameter. If found will assign values
	 * to array or declare a default array of 0
	 * @param request
	 * @param requestParam
	 * @return
	 */
	public String[] getParameter(HttpServletRequest request, String requestParam){
		
		String[] parameters = null;
		
		if (request.getParameterValues(Constants.FIELD_NAME) != null) {
			parameters = request.getParameterValues(Constants.FIELD_NAME);
			
		}else{
			parameters = new String[0];
		}
		
		log.debug(parameters.toString());
		return parameters;
	}
	
	/**
	 * Will loop through array list of parameters and return it to a formatted
	 * string value
	 * 
	 * @param requestParam
	 * @param parameters
	 * @return
	 */
	public String buildParamString(String[] parameters, String requestParam) {
		StringBuilder fieldParams = new StringBuilder();

		for (int i = 0; i < parameters.length; i++) {
			if (fieldParams.length() == 0) {
				fieldParams.append(requestParam +"=" + parameters[i]);
			} else {
				fieldParams.append("&" + "fieldName=" + parameters[i]);
			}
		}
		log.debug(fieldParams.toString());
		return fieldParams.toString();
	}

	/**
	 * Parses a string to double, returns true if input has numeric value
	 * 
	 * @param str
	 * @return
	 */
	public boolean isNumeric(String str) {
		try {
			Double.parseDouble(str);
		} catch (NumberFormatException nfe) {
			return false;
		}
		return true;
	}

}
