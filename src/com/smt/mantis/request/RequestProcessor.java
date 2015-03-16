package com.smt.mantis.request;

//JDK 1.7.0
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

//javax 1.7.x
import javax.servlet.http.HttpServletRequest;

//log4j 1.2.15
import org.apache.log4j.Logger;

/****************************************************************************
 * <b>Title</b>: RequestProcessor.java <p/>
 * <b>Project</b>: MantisReport <p/>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
 ************************************************************************/
/*
 * Class is currently assisting the controller
 */
public class RequestProcessor {

	private static Logger log = Logger.getLogger(RequestProcessor.class);
	
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
		
		if (request.getParameterValues(requestParam) != null) {
			parameters = request.getParameterValues(requestParam);
			
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
	public String buildParamString(String[] parameters, String requestParam, boolean encode) {
		StringBuilder fieldParams = new StringBuilder();

		String ampersand = "&";
		if(encode) ampersand = "&#38";
		
		for (int i = 0; i < parameters.length; i++) {
			if (fieldParams.length() == 0) {
				fieldParams.append(requestParam +"=" + parameters[i]);
			} else {
				fieldParams.append(ampersand + requestParam +"=" + parameters[i]);
			}
		}
		
		//log.debug(fieldParams.toString());
		return fieldParams.toString();
	}

	/**
	 * Will loop through hashMap of all request parameters and append all to 
	 * one request string
	 * @param requestMap
	 * @return
	 */
	public String buildAllParams(HashMap<String, String[]> requestMap, boolean encode) {
		StringBuilder requestParameters = new StringBuilder();
		
		String ampersand = "&";
		if(encode) ampersand = "&#38";
		
		for (Map.Entry<String, String[]> e : requestMap.entrySet()) {
		    String key = e.getKey();
		    String[] value = e.getValue();
		    String requestString = this.buildParamString(value, key, encode);
		    
			if (requestParameters.length() == 0) {
				requestParameters.append(requestString);
			} else {
				requestParameters.append(ampersand + requestString);
			}
		}
		log.debug(requestParameters.toString());

		return  requestParameters.toString();
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
