<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.siliconmtn.date.DateHandler"%>
<%@ page import="com.siliconmtn.helper.Helper"%>
<%
	//Handle dates
	DateHandler dh = new DateHandler();

	request.setAttribute("currentDate", dh.getCurrentDate());
	request.setAttribute("lastWeek", dh.getPastWeek());
	request.setAttribute("presentYear", dh.getCurrentYear());
	request.setAttribute("curMonth", dh.getCurrentMonth());
	request.setAttribute("pastMonth", dh.retrieveMonth(7, true));
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

	if (startDay != null && startMonth != null && startYear != null) {
		startDate = startMonth + "/" + startDay + "/" + startYear;
		request.setAttribute("sDate", startDate);
	}

	if (endDay != null && endMonth != null && endYear != null) {
		endDate = endMonth + "/" + endDay + "/" + endYear;
		request.setAttribute("eDate", endDate);

		if (dh.checkDates(startDate, endDate)) {

			String error = "Start Date is after End Date. Please verify dates.";
			request.setAttribute("dateError", error);
		}
	}

	//Set all mappings
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

	LinkedHashMap<String, String> fieldMap = new LinkedHashMap<String, String>();

	//fieldMap.put("Actual Hours","Actual Hours");
	fieldMap.put("Actual Hours (DEV)", "Actual Hours (DEV)");
	fieldMap.put("Actual Hours (PM / Other)", "Actual Hours (PM / Other)");
	fieldMap.put("Estimated Hours", "Estimated Hours");
	fieldMap.put("handler_id", "Assigned To");
	fieldMap.put("status", "Status");
	fieldMap.put("summary", "Summary");
	fieldMap.put("resolution", "Resolution");

	request.setAttribute("fieldMap", fieldMap);

	HashMap<Long, String> typeMap = new HashMap<Long, String>();

	typeMap.put(1L, "New Issue");
	typeMap.put(2L, "Note Added:");
	typeMap.put(3L, "Note Edited:");
	typeMap.put(4L, "Note Deleted:");
	typeMap.put(6L, "Description Updated");
	typeMap.put(7L, "Additional Information Updated:");
	typeMap.put(8L, "Steps to Reproduce Updated:");
	typeMap.put(9L, "File Added:");
	typeMap.put(10L, "File Deleted:");
	typeMap.put(12L, "Issue Monitored:");
	typeMap.put(13L, "Issue End Monitor");
	typeMap.put(18L, "Relationship Added");
	typeMap.put(19L, "Relationship Deleted");
	typeMap.put(20L, "Issue Cloned:");
	typeMap.put(21L, "Issue Generated From:");
	typeMap.put(23L, "Relationship Replaced:");
	typeMap.put(25L, "Tag Attached:");
	typeMap.put(26L, "Tag Detached:");
	typeMap.put(29L, "Note Revision dropped:");

	request.setAttribute("typeList", typeMap);

	HashMap<Long, String> rsMap = new HashMap<Long, String>();

	rsMap.put(10L, "open");
	rsMap.put(20L, "fixed");
	rsMap.put(30L, "reopened");
	rsMap.put(40L, "unable to reproduce");
	rsMap.put(50L, "not fixable");
	rsMap.put(60L, "duplicate");
	rsMap.put(70L, "no change required");
	rsMap.put(80L, "suspended");
	rsMap.put(90L, "won't fix");

	request.setAttribute("rsList", rsMap);

	HashMap<Long, String> relationMap = new HashMap<Long, String>();

	relationMap.put(0L, "duplicate of");
	relationMap.put(1L, "related to");
	relationMap.put(2L, "parent of");
	relationMap.put(3L, "child of");
	relationMap.put(4L, "has duplicate");

	request.setAttribute("relationList", relationMap);

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

	request.setAttribute("priority", priorityMap);

	//check request parameters
	String ticket = request.getParameter("ticketID");
	request.setAttribute("ticketId", ticket);

	Helper hlp = new Helper();
	
	if (request.getParameterValues("fieldName") != null) {
		String[] fieldParams = request.getParameterValues("fieldName");
		String detailParams = hlp.getParameters(fieldParams);
		request.setAttribute("mainfldParams", detailParams);
	}
	
	if (pageContext.getAttribute("detailParams") != null) {
		String[] fieldParams = (String [])pageContext.getAttribute("detailParams");
		String detailParams = hlp.getParameters(fieldParams);
		request.setAttribute("exportfldParams", detailParams);
	}
	
	//error check
	if (ticket != null) {	
		if (!hlp.isNumeric(ticket) || ticket.length() > 4
				|| ticket.length() < 4) {
			String error = "Please enter a valid Ticket #";
			request.setAttribute("ticketError", error);
		}
	}

	//Build SQL Query
	StringBuilder sb = new StringBuilder();

	sb.append("SELECT mht.field_name, mht.old_value, mht.new_value, mut.username,");
	sb.append(" mht.type, from_unixtime(mht.date_modified, '%m/%d/%Y') as modDate");
	sb.append(" FROM mantis_bug_history_table mht");
	sb.append(" LEFT OUTER JOIN mantis_user_table mut");
	sb.append(" ON mht.user_id = mut.id");
	sb.append("	WHERE 1=1");

	//check for request parameters 
	sb.append("	AND mht.bug_id = " + ticket);
	if(request.getParameterValues("fldName") != null){
		String[] params = request.getParameterValues("fldName");
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
			for(int i =0; i < params.length; i++){		
			if(i < 1 && params[i] != ""){
				sb.append(" AND( mht.field_name='"+ params[i] + "'");
			}else if(params[i] != ""){
				sb.append(" OR mht.field_name='"+ params[i] + "'");
				}	
			}
		sb.append(")");
		}
	}

	sb.append(" ORDER BY mht.id");
	request.setAttribute("sql", sb.toString());

%>
