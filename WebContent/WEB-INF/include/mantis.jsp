<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%!public static boolean isNumeric(String str) {
		try {
			double d = Double.parseDouble(str);
		} catch (NumberFormatException nfe) {
			return false;
		}
		return true;
	}%>
<%
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
%>

<%

	//check all filter parameters	
	String ticket = request.getParameter("ticketID");
	if(ticket != null){
		String error = "";
		//error check
		if(!isNumeric(ticket) || ticket.length() > 4){
	error = "Please enter a valid Ticket #";
	request.setAttribute("ticketError", error);
	
		}else{
	sb.append("	AND mbt.id = " + ticket);
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
		
	//get current date
	DateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
   	Calendar cal = Calendar.getInstance();
   	request.setAttribute("currentDate", dateFormat.format(cal.getTime()));
   	
    int iYear = cal.get(Calendar.YEAR);
    int iMonth = cal.get(Calendar.MONTH)+1;
    int iDay= cal.get(Calendar.DAY_OF_MONTH);
    request.setAttribute("curYear", iYear);
    request.setAttribute("curMonth", iMonth);
    request.setAttribute("curDay", iDay);
    
	//Substract a week from current date.
	cal.add(Calendar.DATE, -7);
	request.setAttribute("weekAgo", dateFormat.format(cal.getTime()));
	
    int bDay= cal.get(Calendar.DAY_OF_MONTH);
    request.setAttribute("daysAgo", bDay);
    
    //get full start date and end date for display
    startDate = startMonth + "/"+ startDay + "/" + startYear;
    endDate = endMonth + "/"+ endDay + "/" + endYear;
    request.setAttribute("sMonth", startMonth);
    request.setAttribute("sDate", startDate);
    request.setAttribute("eDate", endDate);
    
    //check if date is out of range
    String error = null;
    if(startMonth != null){
    Date date1 = dateFormat.parse(startDate);
    Date date2 = dateFormat.parse(endDate);
	
    Calendar cal2 = Calendar.getInstance();
    
    cal.setTime(date1);
    cal2.setTime(date2);
    
   		 if(cal.after(cal2)){
    	  error = "Start date is after End date. Please check.";
    	    request.setAttribute("errMessage", error);
		}
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style/mantis.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mantis Bug Tracker</title>
<script type="text/javascript">
<!--display function -->
	function toggle(id) {
		var e = document.getElementById(id);
		if (e.style.display == "none") {
			e.style.display = "block";

		} else {
			e.style.display = "none";
		}
	};

	function load(url, id) {
		toggle(id);
		var xmlhttp;
		if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp = new XMLHttpRequest();
		} else {// code for IE6, IE5
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				document.getElementById(id).innerHTML = xmlhttp.responseText;
			}
		};
		xmlhttp.open("GET", url, true);
		xmlhttp.send();
	};
	//will populate given td tag based on it's id -->
	function populate(value) {
		return value;
	};

	// JAVASCRIPT to clear search text when the field is clicked -->
	window.onload = function() {
		//Get submit button
		var submitbutton = document.getElementById("tfq");
		//Add listener to submit button
		if (submitbutton.addEventListener) {
			submitbutton.addEventListener("click", function() {
				if (submitbutton.value == 'Search by Ticket No.') {//Customize this text string to whatever you want
					submitbutton.value = '';
				}
			});
		}
		;
	}
</script>

</head>
<body>
		<!-- sql queries -->
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://192.168.2.185/mantisbt_current" user="devon"
		password="sqll0gin" />

	<sql:query dataSource="${snapshot}" var="result">
		${sql}
	</sql:query>

	<sql:query dataSource="${snapshot}" var="projectResult">
	SELECT name FROM mantis_project_table;
	</sql:query>

	<sql:query dataSource="${snapshot}" var="customResult">
	SELECT name, id FROM mantis_custom_field_table;
	</sql:query>

	<img src="images/logo.png" alt="SMT Bug Tracker">

	<!-- include filters -->
	<%@ include file="filter.jsp" %>

	<c:if test="${ticketError != null}">
		<p>${ticketError}</p>
	</c:if>
	<c:if test="${empty result.rows}">
		<p>No tickets found</p>
	</c:if>

	<c:if test="${errMessage != null }">
		<h2>
			<font color="#B00000">${errMessage }</font>
		</h2>
	</c:if>

	<h2 id="display_date" align="center">
		<c:choose>
			<c:when test="${sMonth == null}">
		Displaying Tickets From ${weekAgo} - ${currentDate} 
		</c:when>
			<c:otherwise>
		Displaying Tickets From ${sDate} - ${eDate}
		</c:otherwise>
		</c:choose>
	</h2>
	<h2>Report Grid</h2>
	<c:if test="${empty param.exportToCSV }">
		<form method="post"
			action="Mantis?type=export&<c:forEach var="pageParam" items="${reqMap}"
			><c:out value="${pageParam.key}"/>=<c:out value="${pageParam.value}"/>&</c:forEach>">
			<input type="submit" value="Export to Excel"> <input
				type="hidden" name="detail" value="detailed">
		</form>
	</c:if>
	<br>

	<form method="get" action="Mantis?type=mantis">
		<input type="submit" value="Clear Filters" class="clearFilter"
			style="float: right;">
	</form>

	<table width="100%" cellspacing="0px" class="mantisTable">
		<tr>
			<th></th>
			<th>Ticket #</th>
			<th>Date Last Updated</th>
			<th>Project name</th>
			<th>Primary User</th>
			<th>Description</th>
			<th>Status/Comments</th>
			<c:forEach var="custom" items="${customResult.rows}">
				<th>${custom.name}</th>
			</c:forEach>
		</tr>

		<c:set var="moveID" value="-1" />
		<c:forEach var="ticket" items="${result.rows}">
			<c:set var="currentID" value="${ticket.id}" />
			<c:choose>
				<c:when test="${currentID != moveID}">
					<c:choose>
						<c:when test="${moveID == -1 }">
							<tr>
						</c:when>
						<c:otherwise>
							</tr>
							<tr class="blend">
								<td id="a${moveID}" style="display: none"></td>
							</tr>
							<tr>
								<td style="display: none"></td>
							</tr>
							<tr>
						</c:otherwise>
					</c:choose>
					<td><button
							onclick="load('Mantis?type=detail&ticketID=${ticket.id}&${fieldSB}','a${ticket.id}');">+/-
						</button></td>
					<td>${ticket.id}</td>
					<td>${ticket.lastUpdate}</td>
					<td>${ticket.name}</td>
					<td>${ticket.username}</td>
					<td>${ticket.summary}</td>
					<td>${sMap[ticket.status + 0]}</td>

					<c:forEach var="custom" items="${customResult.rows}">
						<c:set var="customID" value="custom${custom.id}${ticket.id}"></c:set>
						<td id="${customID}"><c:if
								test="${ticket.customNames == custom.name}">
								<script type="text/javascript">
									document.getElementById('${customID}').innerHTML = populate('${ticket.value}');
								</script>

							</c:if></td>
					</c:forEach>
				</c:when>
				<c:otherwise>

					<c:forEach var="custom" items="${customResult.rows}">
						<c:set var="customID" value="custom${custom.id}${ticket.id}"></c:set>
						<c:if test="${ticket.customNames == custom.name}">
							<script type="text/javascript">
								document.getElementById('${customID}').innerHTML = populate('${ticket.value}');
							</script>
						</c:if>
					</c:forEach>

				</c:otherwise>
			</c:choose>
			<c:set var="moveID" value="${ticket.id}" />
		</c:forEach>
		</tr>
		<tr class="blend">
			<td id="a${moveID}" style="display: none" colspan="8"></td>
		</tr>
	</table>
</body>
</html>