package com.siliconmtn.helper;
/****************************************************************************
 * <b>Title</b>: Constants.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 1.0
 * @since 1:58:40 PM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public class Constants {

	//path for jsps
	public static final String BASE_PATH = "WEB-INF/include/";
	
	//datasource lookup
	public static final String DATA_SOURCE_LOOKUP = "jdbc/mantisdb";
	
	//Filters/Request Parameters
	public static final String USER_NAME = "userName";
	public static final String PROJECT_NAME = "projectName";
	public static final String STATUS_FILTER = "statusFilter";
	public static final String TICKET_ID = "ticketID";
	public static final String FIELD_NAME = "fieldName";
	
	//SQL Names/Values
	public static final String MUT_USER = "mut.username";
	public static final String MPT_NAME = "mpt.name";
	public static final String MBT_STATUS = "mbt.status";
	public static final String MBT_ID = "mbt.id";
	public static final String MBT_LST_UPDATE = "mbt.last_updated";
	public static final String MHT_FIELD_NAME = "mht.field_name";
	public static final String MHT_BUG_ID = "mht.bug_id";
	public static final String MHT_DATE_MOD = "mht.date_modified";

	//other constants
	public static final String MANTIS = "mantis";
	
}
