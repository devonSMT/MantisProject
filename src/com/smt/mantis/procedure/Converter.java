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
 * Serves as a mapping for conversions. The mappings are conversions from 
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
	 * Wrapper method that calls all mappings methods, all mappings set.
	 */
	public void setAllMappings(){
		this.setStatusMap();
		this.setFieldMap();
		this.setPriorityMap();
		this.setRelationMap();
		this.setResolutionMap();
		this.setNoteTypeMap();
	}
	
	/**
	 * Returns collection of conversion mappings
	 * @return the list of conversion mappings
	 */
	public HashMap<String, Map<?, String>> getConversionList() {
		return conversionList;
	}
	
	/**
	 * Sets status mapping, then adds to global converter collection
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
	 * Sets resolution mapping, then adds to global converter collection
	 */
	public void setResolutionMap() {
		LinkedHashMap<Integer, String> resMap = new LinkedHashMap<Integer, String>();

		resMap.put(10, "open");
		resMap.put(20, "fixed");
		resMap.put(30, "reopened");
		resMap.put(40, "unable to reproduce");
		resMap.put(50, "not fixable");
		resMap.put(60, "duplicate");
		resMap.put(70, "no change required");
		resMap.put(80, "suspended");
		resMap.put(90, "won't fix");
		
		conversionList.put(GlobalConfig.CONVERT_RESOLUTION, resMap);

	}
	
	/**
	 * Sets priority mapping, then adds to global converter collection
	 */
	public void setPriorityMap() {
		HashMap<Integer, String> priorityMap = new HashMap<Integer, String>();

		priorityMap.put(10, "Lowest");
		priorityMap.put(20, "Nice To Have");
		priorityMap.put(30, "Low");
		priorityMap.put(40, "Moderate");
		priorityMap.put(50, "Normal");
		priorityMap.put(60, "Significant");
		priorityMap.put(70, "High");
		priorityMap.put(80, "Critical");
		priorityMap.put(90, "Immediate");
		priorityMap.put(100, "Emergency");
		
		conversionList.put(GlobalConfig.CONVERT_PRIORITY, priorityMap);
	}
	
	/**
	 * Sets field mapping, then adds to global converter collection
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
	 * Sets type mapping, then adds to global converter collection
	 */
	public void setNoteTypeMap() {
		HashMap<Integer, String> noteTypeMap = new HashMap<Integer, String>();

		noteTypeMap.put(0, "New Issue");
		noteTypeMap.put(1, "Assigned To");
		noteTypeMap.put(2, "Note Added:");
		noteTypeMap.put(3, "Note Edited:");
		noteTypeMap.put(4, "Note Deleted:");
		noteTypeMap.put(6, "Description Updated");
		noteTypeMap.put(7, "Additional Information Updated:");
		noteTypeMap.put(8, "Steps to Reproduce Updated:");
		noteTypeMap.put(9, "File Added:");
		noteTypeMap.put(10, "File Deleted:");
		noteTypeMap.put(12, "Issue Monitored:");
		noteTypeMap.put(13, "Issue End Monitor");
		noteTypeMap.put(18, "Relationship Added");
		noteTypeMap.put(19, "Relationship Deleted");
		noteTypeMap.put(20, "Issue Cloned:");
		noteTypeMap.put(21, "Issue Generated From:");
		noteTypeMap.put(23, "Relationship Replaced:");
		noteTypeMap.put(25, "Tag Attached:");
		noteTypeMap.put(26, "Tag Detached:");
		noteTypeMap.put(29, "Note Revision dropped:");
		noteTypeMap.put(100, "Timecard_time_spent_added:");
		
		conversionList.put(GlobalConfig.CONVERT_TYPE, noteTypeMap);

	}

	/**
	 * Sets relationship mapping, then adds to global converter collection
	 */
	public void setRelationMap() {
		HashMap<Integer, String> relationMap = new HashMap<Integer, String>();

		relationMap.put(0, "duplicate of");
		relationMap.put(1, "related to");
		relationMap.put(2, "parent of");
		relationMap.put(3, "child of");
		relationMap.put(4, "has duplicate");
		
		conversionList.put(GlobalConfig.CONVERT_RELATION, relationMap);

	}
}
