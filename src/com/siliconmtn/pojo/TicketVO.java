package com.siliconmtn.pojo;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

/****************************************************************************
 * <b>Title</b>: TicketVO.javaIncomingDataWebService.java
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
 * @since 9:37:41 AM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public class TicketVO implements Serializable {

	private static final long serialVersionUID = 1L;
	private int ticketID;
	private String projectName = null;
	private String userName = null;
	private String summary = null;
	private String dateModified = null;
	private int status;
	private HashMap<String, String> customFields = null;
	
	/**
	 * No argument constructor
	 */
	public TicketVO() {

	}
	
	/**
	 * Constructor that will initialize bean
	 * @param ticketId
	 * @param project
	 * @param user
	 * @param summary
	 * @param date
	 * @param status
	 */
	public TicketVO(int ticketId, String project, String user, String summary,
			String date, int status, HashMap<String, String> cstFields) {
		
		this.ticketID = ticketId;
		this.projectName = project;
		this.userName = user;
		this.summary = summary;
		this.dateModified = date;
		this.status = status;
		this.customFields = cstFields;
		
	}
	
	/**
	 * Class constructor, takes a result set
	 * @param rs
	 * @throws SQLException 
	 */
	public TicketVO(ResultSet rs) throws SQLException{
		this.setData(rs);
	}
	
	/**
	 * Takes a result and populates bean with information
	 * @param rs
	 * @throws SQLException
	 */
	public void setData(ResultSet rs) throws SQLException{
		this.customFields = new HashMap<String, String>();
		this.ticketID = rs.getInt("mbt.id");
		this.projectName = rs.getString("mpt.name");
		this.summary = rs.getString("mbt.summary");
		this.userName = rs.getString("mut.username");
		this.dateModified = rs.getString("lastUpdate");
		this.status = rs.getInt("mbt.status");
		this.customFields.put(rs.getString("customNames"), rs.getString("cfs.value"));

	}
	
	/**
	 * @return the ticketID
	 */
	public int getTicketID() {
		return ticketID;
	}
	
	/**
	 * @param ticketID
	 *            the ticketID to set
	 */
	public void setTicketID(int ticketID) {
		this.ticketID = ticketID;
	}

	/**
	 * @return the projectName
	 */
	public String getProjectName() {
		return projectName;
	}

	/**
	 * @param projectName
	 *            the projectName to set
	 */
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}

	/**
	 * @param userName
	 *            the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}

	/**
	 * @return the summary
	 */
	public String getSummary() {
		return summary;
	}

	/**
	 * @param summary
	 *            the summary to set
	 */
	public void setSummary(String summary) {
		this.summary = summary;
	}

	/**
	 * @return the dateModified
	 */
	public String  getDateModified() {
		return dateModified;
	}

	/**
	 * @param dateModified
	 *            the dateModified to set
	 */
	public void setDateModified(String dateModified) {
		this.dateModified = dateModified;
	}

	/**
	 * @return the status
	 */
	public int getStatus() {
		return status;
	}

	/**
	 * @param status
	 *            the status to set
	 */
	public void setStatus(int status) {
		this.status = status;
	}

	/**
	 * @return the customFields
	 */
	public HashMap<String, String> getCustomFields() {
		return customFields;
	}

	/**
	 * @param customFields the customFields to set
	 */
	public void setCustomFields(HashMap<String, String> customFields) {
		this.customFields = customFields;
	}

}
