package com.smt.mantis.procedure;

//JDK 1.7.0
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

// M.R. 2.0
import com.smt.mantis.config.GlobalConfig;

/****************************************************************************
 * Title: Converter.java <p/>
 * Project: MantisReport <p/>
 * Serves as converter mapping. Mappings are conversions from 
 * plain database values into user ready defined values
 * Copyright: Copyright (c) 2015 <p/>
 * Company: Silicon Mountain Technologies <p/>
 * @author Devon Franklin
 * @version 2.0
 * @since Mar 6, 2015
 ****************************************************************************/

public class Converter {

	/**
	 *  global collection of all mappings
	 */
	protected HashMap<String, Map<?, String>> conversionList = null;
	
	/**
	 * Default Constructor to initialize class
	 */
	public Converter() {
		//initialize class
		conversionList = new HashMap<String, Map<?, String>>();
		this.setAllMappings();
	}

	/**
	 * Allows for setting of own conversion mapping. Adds the passed 
	 * mapping object to global collection 
	 * @param mapping
	 * @param name
	 */
	public void putMappingData( String name, Map<?, String> mapping){
		this.conversionList.put(name, mapping);
	}
	
	/**
	 * Wrapper method that calls all mappings methods. Allows ability for all
	 * mappings to be called and set.
	 */
	public void setAllMappings(){
		this.setStatusMap();
		this.setFieldMap();
		this.setPriorityMap();
		this.setRelationMap();
		this.setResolutionMap();
		this.setTypeMap();
	}
	
	/**
	 * Returns conversion collection
	 * @return the conversion list
	 */
	public HashMap<String, Map<?, String>> getConversionList() {
		return conversionList;
	}
	
	/**
	 * Sets unique mapping, then adds to global converter collection
	 */
	public void setStatusMap(){
		LinkedHashMap<Integer, String> statusMap = new LinkedHashMap<Integer, String>();
	
		statusMap.put(10, "new");
		statusMap.put(50, "assigned");
		statusMap.put(53, "qa failed");
		statusMap.put(55, "in progress");
		statusMap.put(60, "dev complete");
		statusMap.put(71, "SMT QA Review");
		statusMap.put(73, "SMT Regression");
		statusMap.put(74, "SMT QA Approved");
		statusMap.put(75, "User Acceptance");
		statusMap.put(80, "resolved");
		statusMap.put(90, "closed");
		
		conversionList.put(GlobalConfig.CONVERT_STATUS, statusMap);

	}
	
	/**
	 * Sets unique mapping, then adds to global converter collection
	 */
	public void setFieldMap() {
		LinkedHashMap<String, String> fieldMap = new LinkedHashMap<String, String>();

		fieldMap.put("Actual Hours", "Actual Hours");
		fieldMap.put("Actual Hours (DEV)", "Actual Hours (DEV)");
		fieldMap.put("Actual Hours (PM / Other)", "Actual Hours (PM / Other)");
		fieldMap.put("Estimated Hours", "Estimated Hours");
		fieldMap.put("handler_id", "Assigned To");
		fieldMap.put("status", "Status");
		fieldMap.put("summary", "Summary");
		fieldMap.put("resolution", "Resolution");
		
		conversionList.put(GlobalConfig.CONVERT_FIELD, fieldMap);

	}

	/**
	 * Sets unique mapping, then adds to global converter collection
	 */
	public void setTypeMap() {
		HashMap<Integer, String> typeMap = new HashMap<Integer, String>();

		typeMap.put(1, "New Issue");
		typeMap.put(2, "Note Added:");
		typeMap.put(3, "Note Edited:");
		typeMap.put(4, "Note Deleted:");
		typeMap.put(6, "Description Updated");
		typeMap.put(7, "Additional Information Updated:");
		typeMap.put(8, "Steps to Reproduce Updated:");
		typeMap.put(9, "File Added:");
		typeMap.put(10, "File Deleted:");
		typeMap.put(12, "Issue Monitored:");
		typeMap.put(13, "Issue End Monitor");
		typeMap.put(18, "Relationship Added");
		typeMap.put(19, "Relationship Deleted");
		typeMap.put(20, "Issue Cloned:");
		typeMap.put(21, "Issue Generated From:");
		typeMap.put(23, "Relationship Replaced:");
		typeMap.put(25, "Tag Attached:");
		typeMap.put(26, "Tag Detached:");
		typeMap.put(29, "Note Revision dropped:");
		
		conversionList.put(GlobalConfig.CONVERT_TYPE, typeMap);

	}

	/**
	 * Sets unique mapping, then adds to global converter collection
	 */
	public void setResolutionMap() {
		LinkedHashMap<Long, String> resMap = new LinkedHashMap<Long, String>();

		resMap.put(10L, "open");
		resMap.put(20L, "fixed");
		resMap.put(30L, "reopened");
		resMap.put(40L, "unable to reproduce");
		resMap.put(50L, "not fixable");
		resMap.put(60L, "duplicate");
		resMap.put(70L, "no change required");
		resMap.put(80L, "suspended");
		resMap.put(90L, "won't fix");
		
		conversionList.put(GlobalConfig.CONVERT_RESOLUTION, resMap);

	}

	/**
	 * Sets unique mapping, then adds to global converter collection
	 */
	public void setRelationMap() {
		HashMap<Long, String> relationMap = new HashMap<Long, String>();

		relationMap.put(0L, "duplicate of");
		relationMap.put(1L, "related to");
		relationMap.put(2L, "parent of");
		relationMap.put(3L, "child of");
		relationMap.put(4L, "has duplicate");
		
		conversionList.put(GlobalConfig.CONVERT_RELATION, relationMap);

	}

	/**
	 * Sets unique mapping, then adds to global converter collection
	 */
	public void setPriorityMap() {
		HashMap<Long, String> priorityMap = new HashMap<Long, String>();

		priorityMap.put(10L, "Lowest");
		priorityMap.put(20L, "Nice To Have");
		priorityMap.put(30L, "Low");
		priorityMap.put(40L, "Moderate");
		priorityMap.put(50L, "Normal");
		priorityMap.put(60L, "Significant");
		priorityMap.put(70L, "High");
		priorityMap.put(80L, "Critical");
		priorityMap.put(90L, "Immediate");
		priorityMap.put(100L, "Emergency");
		
		conversionList.put(GlobalConfig.CONVERT_PRIORITY, priorityMap);
	}
}
