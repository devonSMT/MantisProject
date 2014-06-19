package com.siliconmtn.date;

//JDK 1.7.0
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;


//log4j 1.2.15
import org.apache.log4j.Logger;

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

	private String day;
	private String month;
	private String year;
	private Calendar cal = Calendar.getInstance();
	private DateFormat dateFormat = null;
	private final String NO_DATE = "no date";
	
	private static Logger log = Logger.getLogger(DateHandler.class);
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
		
	}

	/**
	 * Makes a formatted date in form of MM/dd/yyyy from a String date
	 * @param date -The date to be formatted 
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
	 * Concatenates month, day and year into a string date 
	 * @return - concatenated date string
	 */
	public String makeDate(String month, String day, String year){
		
		String concatenatedDate = month + "/" + day + "/" + year;
		return concatenatedDate;
	}
	
	/**
	 * Searches through list of request parameters for date parameters
	 * 
	 * @param dayParam
	 * @param monthParam
	 * @param yearParam
	 * @return
	 */
	public String checkForDate(HashMap<String, String[]> parameters, String dayParam, String monthParam,
			String yearParam) {

		String day = null;
		String month = null;
		String year = null;
		String date = NO_DATE;

		for (String key : parameters.keySet()) {
			if (key.equals(dayParam)) {
				day = getParamValue(parameters.get(key), 0);
			}
			if (key.equals(monthParam)) {
				month = getParamValue(parameters.get(key), 0);
			}
			if (key.equals(yearParam)) {
				year = getParamValue(parameters.get(key), 0);
			}
		}

		// only concatenate if there are values
		if (day != null) {
			date = this.makeDate(month, day, year);
		}

		log.debug("Date is " + date);
		return date;
	}
	
	/**
	 * Will return a specific value from a String array
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
	 * Takes epoch time string and converts it to human readable
	 * @param epochDate
	 * @return
	 */
	public String getReadableDate(String epochDate){

		Long date = new Date(Long.parseLong(epochDate)).getTime() * 1000;		
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
		
		String readableDate = format.format(date);
		
		return readableDate;
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

		Calendar caldr = Calendar.getInstance();

		caldr.add(Calendar.DATE, -dayAgo);

		int pastDay = caldr.get(Calendar.DAY_OF_MONTH);

		return pastDay;
	}
	
	/**
	 * Add or subtract days to return a specific month from current date
	 * @param day
	 * @param substract set to true if you want to subtract days from month
	 * @return
	 */
	public int retrieveMonth(int day, boolean substract){
		Calendar cl = Calendar.getInstance();

		if(substract){
			cl.add(Calendar.DAY_OF_MONTH, -day);
		}else{
			cl.add(Calendar.DAY_OF_MONTH, day);
		}
		//months are 0 based(0-11)
		int monthResult = cl.get(Calendar.MONTH) + 1;
		
		return monthResult;
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
