package com.siliconmtn.date;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/****************************************************************************
 * <b>Title</b>: DateFetcher.javaIncomingDataWebService.java <p/>
 * <b>Project</b>: MantisProjectRAMDataFeed <p/>
 * <b>Description: </b>
 * <b>Copyright:</b> Copyright (c) 2014<p/>
 * <b>Company:</b> Silicon Mountain Technologies<p/>
 * @author Devon
 * @version 1.0
 * @since 8:55:29 AM<p/>
 * <b>Changes: </b>
 ****************************************************************************/

public class DateFetcher {


	public void getDate(){
		
		//set format for date
		DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
		Calendar cal = Calendar.getInstance();

		//Add one day to current date.
		cal.add(Calendar.DATE, 1);
		System.out.println(dateFormat.format(cal.getTime()));

		//Substract one day to current date.
		cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		System.out.println(dateFormat.format(cal.getTime()));

	}
}
