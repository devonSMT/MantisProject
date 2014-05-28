<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.siliconmtn.date.DateHandler"%>
<%@ page import="com.siliconmtn.helper.HelperFunctions" %>
<%

DateHandler dh = new DateHandler();

request.setAttribute("currentDate", dh.getCurrentDate());
request.setAttribute("lastWeek", dh.getPastWeek());
request.setAttribute("curYear", dh.getCurrentYear());
request.setAttribute("curMonth", dh.getCurrentMonth());
request.setAttribute("curDay", dh.getCurrentDay());
request.setAttribute("daysAgo", dh.retriveDay(7));

String startDay = request.getParameter("startDay");
String startMonth = request.getParameter("startMonth");
String startYear = request.getParameter("startYear");
String startDate = null;

String endDay = request.getParameter("endDay");
String endMonth = request.getParameter("endMonth");
String endYear = request.getParameter("endYear");
String endDate = null;

//convert to unix time
if(startDay != null && startMonth != null && startYear != null){
startDate = startMonth + "/"+ startDay + "/" + startYear;
request.setAttribute("sDate", startDate);
}

if(endDay != null && endMonth != null && endYear != null){
endDate = endMonth + "/"+ endDay + "/" + endYear;
request.setAttribute("eDate", endDate);

	if(dh.checkDates(startDate, endDate)){
	
		String error = "Start Date is after End Date. Please verify dates.";
		request.setAttribute("dateError", error);
	}

}

//Set mapping for all status
LinkedHashMap<Long, String> statusMap = new LinkedHashMap<Long, String>();

statusMap.put(10L, "new");
statusMap.put(50L, "assigned");
statusMap.put(53L, "qa failed");
statusMap.put(55L, "in progress");
statusMap.put(60L, "dev complete");
statusMap.put(71L, "SMT QA Review");
statusMap.put(73L, "SMT Regression");
statusMap.put(74L, "SMT QA Approved");
statusMap.put(75L, "User Acceptance");
statusMap.put(80L, "resolved");
statusMap.put(90L, "closed");


request.setAttribute("sMap", statusMap);

//mapping for all active users
List<String> users = new ArrayList<String>();

users.add("andy");
users.add("ben.landin");
users.add("billy.larsen");
users.add("cindy");
users.add("Dave_SMT");
users.add("devon");
users.add("EDamschroder");
users.add("jcamire");
users.add("jmckain");
users.add("MeeganL");
users.add("ReneaF");
users.add("KaciM");
users.add("matt.miles");
users.add("seckman");
users.add("tjohnson");
users.add("valerie");
users.add("Tom Higginbotham");

request.setAttribute("userList", users);

//For relevant field names
LinkedHashMap<String, String> fields = new LinkedHashMap<String, String>();

fields.put("Actual Hours","Actual Hours");
fields.put("Actual Hours (DEV)","Actual Hours (DEV)");
fields.put("Actual Hours (PM / Other)","Actual Hours (PM / Other)");
fields.put("Estimated Hours","Estimated Hours");
fields.put("handler_id","Assigned To");
fields.put("status","Status");
fields.put("summary","Summary");
fields.put("resolution","Resolution");

request.setAttribute("fieldMap", fields);

//check id parameter	
String ticket = request.getParameter("ticketID");

if(ticket != null){
HelperFunctions hFunc = new HelperFunctions();
String error = "";
	if(!hFunc.isNumeric(ticket) || ticket.length() > 4){
error = "Please enter a valid Ticket #";
request.setAttribute("ticketError", error);
	}
}

if(request.getParameterValues("fieldName") != null){
	String[] fieldParams = request.getParameterValues("fieldName");
	request.setAttribute("fieldList", fieldParams);
	StringBuilder fieldVal = new StringBuilder();
	for(int i =0; i < fieldParams.length; i++){
if(fieldVal.length() == 0){
	fieldVal.append("fieldName=" + fieldParams[i]);		
}else{
	fieldVal.append("&" + "fieldName=" + fieldParams[i]);			
}			
	}
	request.setAttribute("fieldSB", fieldVal.toString());
}

//set all request parameters to mapping
HashMap<String, String> requestMap = new HashMap<String, String>();
Enumeration<String> e = request.getParameterNames();

while(e.hasMoreElements()) {
	String key = (String) e.nextElement();
	requestMap.put(key, (String)request.getParameter(key));
}

request.setAttribute("reqMap", requestMap);


%>
