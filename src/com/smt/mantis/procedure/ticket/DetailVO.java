package com.smt.mantis.procedure.ticket;

//jdk 1.7.0
import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

/****************************************************************************
 * <b>Title</b>: TicketDetailVO.java <p/>
 * <b>Project</b>: MantisReport <p/>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon Franklin
 * @version 2.0
 * @since March 5, 2015
 ****************************************************************************/

public class DetailVO implements Serializable{

	private static final long serialVersionUID = 1L;

	private String oldValue;
	private String newValue;
	private String userName;
	private String fieldName;
	private String modDate;
	private int type;
	
	/**
	 * No argument constructor
	 */
	public DetailVO(){
		
	}
	
	/**
	 * Class constructor, takes a result set
	 * @param rs
	 * @throws SQLException 
	 */
	public DetailVO(ResultSet rs) throws SQLException{
		this.setData(rs);
	}
	
	/**
	 * Takes a result and populates bean with information
	 * @param rs
	 * @throws SQLException
	 */
	public void setData(ResultSet rs) throws SQLException{
		this.type = rs.getInt("mht.type");
		this.fieldName = rs.getString("mht.field_name");
		this.modDate = rs.getString("modDate");
		this.userName = rs.getString("mut.username");
		this.newValue = rs.getString("mht.new_value");
		this.oldValue = rs.getString("mht.old_value");	
	}
	
	/**
	 * @return the oldValue
	 */
	public String getOldValue() {
		return oldValue;
	}
	/**
	 * @param oldValue the oldValue to set
	 */
	public void setOldValue(String oldValue) {
		this.oldValue = oldValue;
	}
	/**
	 * @return the newValue
	 */
	public String getNewValue() {
		return newValue;
	}
	/**
	 * @param newValue the newValue to set
	 */
	public void setNewValue(String newValue) {
		this.newValue = newValue;
	}
	/**
	 * @return the userName
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * @param userName the userName to set
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
	/**
	 * @return the fieldName
	 */
	public String getFieldName() {
		return fieldName;
	}
	/**
	 * @param fieldName the fieldName to set
	 */
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}
	/**
	 * @return the modDate
	 */
	public String getModDate() {
		return modDate;
	}
	/**
	 * @param modDate the modDate to set
	 */
	public void setModDate(String modDate) {
		this.modDate = modDate;
	}
	/**
	 * @return the type
	 */
	public int getType() {
		return type;
	}
	/**
	 * @param type the type to set
	 */
	public void setType(int type) {
		this.type = type;
	}
	
}
