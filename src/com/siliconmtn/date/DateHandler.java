package com.siliconmtn.date;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/****************************************************************************
 * <b>Title</b>: DateMaker.javaIncomingDataWebService.java
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
 * @since 11:11:41 AM
 *        <p/>
 *        <b>Changes: </b>
 ****************************************************************************/

public class DateHandler {

	private String fullDate;
	private String day;
	private String month;
	private String year;
	private Calendar cal = Calendar.getInstance();
	private DateFormat dateFormat = null;
	/**
	 * No argument class constructor
	 */
	public DateHandler() {

	}

	/**
	 * Class constructor, combines given strings into formatted date
	 * 
	 * @param month
	 * @param day
	 * @param year
	 */
	public DateHandler(String month, String day, String year) {
		this.day = day;
		this.month = month;
		this.year = year;
		this.fullDate = month + "/" + day + "/" + year;
	}

	/**
	 * Makes a complete formatted date
	 * 
	 * @param day
	 * @param month
	 * @param year
	 */
	public void formatDate(String date) {

			dateFormat = new SimpleDateFormat("MM/dd/yyyy");

		try {
			Date d = dateFormat.parse(date);
			date = dateFormat.format(d);

		} catch (ParseException e) {

			e.printStackTrace();
		}

	}

	/**
	 * Takes a string date and converts it to it's epoch time
	 * 
	 * @param date
	 * @return
	 * @throws ParseException
	 */
	public Long getEpochTime(String date, boolean addEnd) throws ParseException {

		Long epoch = null;

		if (addEnd) {
			date += " " + +23 + ":" + 23 + ":" + 59;

			epoch = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(date).getTime() / 1000;
		} else {

			epoch = new SimpleDateFormat("MM/dd/yyyy").parse(date).getTime() / 1000;
		}

		return epoch;
	}

	/**
	 * Takes two dates for comparison. Returns true if startDate is after endDate
	 * @param date1
	 * @param date2
	 * @return
	 * @throws ParseException 
	 */
	public boolean checkDates(String startDate, String endDate) throws ParseException{
		boolean verified = false;
		
		dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		
		Date date1 = dateFormat.parse(startDate);
	    Date date2 = dateFormat.parse(endDate);
		
	    Calendar cal2 = Calendar.getInstance();
	    
	    cal.setTime(date1);
	    cal2.setTime(date2);
	    
	   		 if(cal.after(cal2)){
	    	  verified = true;
			}
		
		return verified;
	}
	/**
	 * Will return a formatted string of the current date
	 * 
	 * @return
	 */
	public String getCurrentDate() {

		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");

		String date = dateFormat.format(cal.getTime());

		return date;
	}

	/**
	 * Subtracts a week from the current time into formatted string
	 * 
	 * @return
	 */
	public String getPastWeek() {

		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		Calendar cal = Calendar.getInstance();

		cal.add(Calendar.DATE, -7);

		String date = dateFormat.format(cal.getTime());

		return date;
	}

	/**
	 * Will return a specific day from current date
	 * 
	 * @param dayAgo
	 *            the amount of days to subtract from current date
	 * @return
	 */
	public int retriveDay(int dayAgo) {

		Calendar cal = Calendar.getInstance();

		cal.add(Calendar.DATE, -dayAgo);

		int pastDay = cal.get(Calendar.DAY_OF_MONTH);

		return pastDay;
	}
	
	/**
	 * Returns the current day
	 * 
	 * @return
	 */
	public int getCurrentDay() {
		int iDay = cal.get(Calendar.DAY_OF_MONTH);

		return iDay;
	}

	/**
	 * returns the current month
	 * 
	 * @return
	 */
	public int getCurrentMonth() {
		int iMonth = cal.get(Calendar.MONTH) + 1;

		return iMonth;
	}

	/**
	 * return the current year
	 * 
	 * @return
	 */
	public int getCurrentYear() {
		int iYear = cal.get(Calendar.YEAR);

		return iYear;
	}

	/**
	 * @return the fulldate
	 */
	public String getDay() {
		return day;
	}

	/**
	 * @return the fulldate
	 */
	public String getFulldate() {
		return fullDate;
	}

	/**
	 * @param fulldate
	 *            the fulldate to set
	 */
	public void setFulldate(String fulldate) {
		this.fullDate = fulldate;
	}

	/**
	 * @param day
	 *            the day to set
	 */
	public void setDay(String day) {
		this.day = day;
	}

	/**
	 * @return the month
	 */
	public String getMonth() {
		return month;
	}

	/**
	 * @param month
	 *            the month to set
	 */
	public void setMonth(String month) {
		this.month = month;
	}

	/**
	 * @return the year
	 */
	public String getYear() {
		return year;
	}

	/**
	 * @param year
	 *            the year to set
	 */
	public void setYear(String year) {
		this.year = year;
	}
}
