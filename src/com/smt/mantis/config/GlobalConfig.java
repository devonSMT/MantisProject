package com.smt.mantis.config;
/****************************************************************************
 * Title: GlobalConfig.java <p/>
 * Project: MantisReport <p/>
 * Contains any global parameters that are commonly 
 * used throughout application
 * Copyright: Copyright (c) 2015<p/>
 * Company:Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * since March 5, 2015
 ****************************************************************************/

public class GlobalConfig {

//Log4j Key
public static final String KEY_LOG4J_PATH = "log4jConfig";

//path for jsps
public static final String BASE_PATH = "WEB-INF/include/";

//datasource and env lookup
public static final String DATA_SOURCE_LOOKUP = "jdbc/mantisdb";
public static final String JAVA_COMP_ENV = "java:/comp/env";

//Filters/Request Parameters
public static final String USER_NAME = "userName";
public static final String PROJECT_NAME = "projectName";
public static final String STATUS_FILTER = "statusFilter";
public static final String TICKET_ID = "ticketID";
public static final String FIELD_NAME = "fieldName";

//report controller config 
public static final String MANTIS = "mantis";

//SQL Names/Values
public static final String MUT_USER = "mut.username";
public static final String MPT_NAME = "mpt.name";
public static final String MBT_STATUS = "mbt.status";
public static final String MBT_ID = "mbt.id";
public static final String MBT_LST_UPDATE = "mbt.last_updated";
public static final String MHT_FIELD_NAME = "mht.field_name";
public static final String MHT_BUG_ID = "mht.bug_id";
public static final String MHT_DATE_MOD = "mht.date_modified";

//Conversion Mappings
public static final String CONVERT_STATUS = "status";
public static final String CONVERT_FIELD = "field";
public static final String CONVERT_TYPE = "type";
public static final String CONVERT_RELATION = "relation";
public static final String CONVERT_RESOLUTION = "resolution";
public static final String CONVERT_PRIORITY = "priority";
	
}
