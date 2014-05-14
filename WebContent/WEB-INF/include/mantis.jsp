<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%!%>
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
	//get all filter parameters
	String fieldName = request.getParameter("fieldName");
	request.setAttribute("fldName", fieldName); 
	
	String startDay = request.getParameter("startDay");
	String startMonth = request.getParameter("startMonth");
	String startYear = request.getParameter("startYear");
	String startDate = null;
	String endDay = request.getParameter("endDay");
	String endMonth = request.getParameter("endMonth");
	String endYear = request.getParameter("endYear");
	String endDate = null;
	long startEpoch = 0;
	long endEpoch = 0;

	//convert to unix time
	if(startDay != null && startDay != ""
	&& startMonth != null && startMonth != ""
	&& startYear != null && startYear != ""){
	startDate = startMonth + "/"+ startDay + "/" + startYear +  " " + 00 + ":" + 00 + ":" + 00;
	startEpoch = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(startDate).getTime()/1000;
	}
	
	if(endDay != null && endDay != ""
	&& endMonth != null && endMonth != ""
	&& endYear != null && endYear != ""){
	endDate = endMonth + "/"+ endDay + "/" + endYear +  " " + 235959;
	endEpoch = new SimpleDateFormat("MM/dd/yyyy HHmmss").parse(endDate).getTime()/1000;
	}
	
	StringBuilder sb = new StringBuilder();

	sb.append("SELECT mbt.id, mbt.summary, mbt.status, from_unixtime(mbt.date_submitted, '%m/%d/%Y') as subDate,");
	sb.append(" from_unixtime(mbt.last_updated, '%m/%d/%Y' ) as lastUpdate,");
	sb.append(" mpt.name, mut.username, CONCAT(cf.name, '') AS customNames, cfs.value");
	sb.append(" FROM mantis_project_table mpt");
	sb.append(" RIGHT OUTER JOIN mantis_bug_table mbt");
	sb.append(" ON mpt.id = mbt.project_id");
	sb.append(" LEFT OUTER JOIN mantis_user_table mut");
	sb.append(" ON mbt.handler_id = mut.id");
	sb.append(" LEFT OUTER JOIN mantis_custom_field_string_table cfs");
	sb.append(" ON mbt.id = cfs.bug_id");
	sb.append(" LEFT OUTER JOIN mantis_custom_field_table cf");
	sb.append(" ON cfs.field_id = cf.id");
	sb.append(" WHERE 1=1");

	//check all filter parameters
	if(request.getParameterValues("userName") != null){
		String[] params = request.getParameterValues("userName");
		request.setAttribute("userNameList", params);
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
	for(int i =0; i < params.length; i++){		
		if(i < 1 && params[i] != ""){
		sb.append(" AND( mut.username='"+ params[i] + "'");
		}else if(params[i] != ""){
	sb.append(" OR mut.username='"+ params[i] + "'");
		}	
	}
		sb.append(")");
		}
	}

	if(request.getParameterValues("projectName") != null){
		String[] params = request.getParameterValues("projectName");
		request.setAttribute("projNameList", params);
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
	for(int i =0; i < params.length; i++){		
	if(i < 1 && params[i] != ""){
		sb.append(" AND( mpt.name='"+ params[i] + "'");
	}else if(params[i] != ""){
		sb.append(" OR mpt.name='"+ params[i] + "'");
		}	
	}
		sb.append(")");
		}
	}
	
	if(request.getParameterValues("statusFilter") != null){
		String[] params = request.getParameterValues("statusFilter");
		request.setAttribute("statFilterList", params);
		//check if {any} value was choosen
		if(params[0] != ""){ 
	for(int i =0; i < params.length; i++){		
	if(i < 1 && params[i] != ""){
		sb.append(" AND( mbt.status='"+ params[i] + "'");
	}else if(params[i] != ""){
		sb.append(" OR mbt.status='"+ params[i] + "'");
		}	
	}
		sb.append(")");
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
	
	//check for dates
	if(startDate != null && endDate == null){
		sb.append(" AND mbt.last_updated >= " + startEpoch);
		
	}else if(endDate != null && startDate == null){
		sb.append(" AND mbt.last_updated >= " + endEpoch);
	
	}else if(startDate != null && endDate != null){

	sb.append(" AND mbt.last_updated BETWEEN " + startEpoch + " AND " + endEpoch);
	
	}else if(startDate == null && endDate == null){
		sb.append(" AND mbt.last_updated >= unix_timestamp(date_sub(now(), interval 7 DAY))");
	}
	
	//set sql query
	sb.append(" ORDER BY mbt.last_updated DESC");
	request.setAttribute("sql", sb.toString());
	
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mantis Bug Tracker</title>
<script type="text/javascript">
	//display function
	function toggle(id) {
		var e = document.getElementById(id);
		if (e.style.display == "none") {
			e.style.display = "block";

		} else {
			e.style.display = "none";
		}
	};
	//will load detailed information
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
</script>
<style type="text/css">
body {
	font-family: Arial, sans-serif;
	font-size: 10pt;
	background-color: #A4D1FF;
}

p {
	font-size: 15pt;
}

h2 {
	font-size: 14pt;
	font-family: Arial, sans-serif;
}

.mantisTable {
	width: 100%;
}

.mantisTable th {
	font-family: sans-serif padding : 7px;
	border: #A4D1FF
}

.mantisTable td {
	padding: 7px;
	border: #A4D1FF none;
}

.mantisTable tr:nth-child(even) { /*(even) or (2n 0)*/
	background: #A4D1FF;
}

.mantisTable tr:nth-child(odd) { /*(odd) or (2n 1)*/
	background: #EAF4FF;
}

.mantisTable tr.blend {
	background-color: #A4D1FF;
}

.filterTable {
	background-color: #D3D3D3;
}

.applyFilter {
	color: #003300;
}

.clearFilter {
	color: #600000;
}
</style>
</head>
<body>
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
	SELECT name FROM mantis_custom_field_table;
	</sql:query>

	<img src="images/logo.png" alt="SMT Bug Tracker">


	<form action="Mantis">
		<input type="submit" value="Clear Filters" class="clearFilter"
			style="float: right;">
	</form>
	<h2>Ticket Filters</h2>
	<form action="Mantis" method="post">
		<table border="20" width="100%" cellspacing="0px" class="filterTable">
			<tr>
				<th>Select Project</th>
				<th>Select User</th>
				<th>Last Updated Date Range</th>
				<th>Select Status</th>
				<th>Detailed Ticket Option</th>
			</tr>
			<tr>
				<td><select name="projectName" size="7" multiple>
						<option value="">{any}</option>
						<c:forEach var="project" items="${projectResult.rows}">

							<%-- check to see if value was selected --%>
							<option value="${project.name}"
								<c:forEach var='parameter' items='${projNameList}'>
							${parameter == project.name ? 'selected="SELECTED"' : ''}
							</c:forEach>>${project.name}</option>
						</c:forEach>

				</select></td>
				<td><select name="userName" size="7" multiple>
						<option value="">{any}</option>
						<c:forEach var="user" items="${userList}">
							<option value="${user}"
								<c:forEach var='parameter' items='${userNameList}'>
							${parameter == user ? 'selected="SELECTED"' : ''}
							</c:forEach>>${user}</option>
						</c:forEach>
				</select></td>
				<td><b>Start Date</b><select id="startMonth" name="startMonth">
						<option value="01"
							${param.startMonth == 01 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 1 ? 'selected="selected"' : ''}
							</c:if>>January</option>
						<option value="02"
							${param.startMonth == 02 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 2 ? 'selected="selected"' : ''}
							</c:if>>February</option>
						<option value="03"
							${param.startMonth == 03 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 3 ? 'selected="selected"' : ''}
							</c:if>>March</option>
						<option value="04"
							${param.startMonth == 04 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 4 ? 'selected="selected"' : ''}
							</c:if>>April</option>
						<option value="05"
							${param.startMonth == 5 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 5 ? 'selected="selected"' : ''}
							</c:if>>May</option>
						<option value="06"
							${param.startMonth == 06 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 6 ? 'selected="selected"' : ''}
							</c:if>>June</option>
						<option value="07"
							${param.startMonth == 07 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 7 ? 'selected="selected"' : ''}
							</c:if>>July</option>
						<option value="08"
							${param.startMonth == 08 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 8 ? 'selected="selected"' : ''}
							</c:if>>August</option>
						<option value="09"
							${param.startMonth == 09 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 9 ? 'selected="selected"' : ''}
							</c:if>>September</option>
						<option value="10"
							${param.startMonth == 10 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 10 ? 'selected="selected"' : ''}
							</c:if>>October</option>
						<option value="11"
							${param.startMonth == 11 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 11 ? 'selected="selected"' : ''}
							</c:if>>November</option>
						<option value="12"
							${param.startMonth == 12 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 12 ? 'selected="selected"' : ''}
							</c:if>>December</option>
				</select> <select id="startDay" name="startDay">
						<c:forEach var="day" begin='1' end='31'>
							<option value="${day}"
								${param.startDay == day ? 'selected="selected"' : ''}
								<c:if test="${param.startDay == null }">
							${daysAgo == day ? 'selected="selected"' : ''}
							</c:if>>${day}</option>
						</c:forEach>
				</select> <select id="startYear" name="startYear">
						<c:forEach var="year" begin='2000' end='2014'>
							<option value="${year}"
								${param.startYear == year ? 'selected="selected"' : ''}
								<c:if test="${param.startYear == null }">
							${curYear == year ? 'selected="selected"' : ''}
							</c:if>>${year}</option>
						</c:forEach>
				</select><b>End Date</b><select id="endMonth" name="endMonth">
						<option value="01"
							${param.endMonth == 01 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 1 ? 'selected="selected"' : ''}
							</c:if>>January</option>
						<option value="02"
							${param.endMonth == 02 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 2 ? 'selected="selected"' : ''}
							</c:if>>February</option>
						<option value="03"
							${param.endMonth == 03 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 3 ? 'selected="selected"' : ''}
							</c:if>>March</option>
						<option value="04"
							${param.endMonth == 04 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 4 ? 'selected="selected"' : ''}
							</c:if>>April</option>
						<option value="05"
							${param.endMonth == 05 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 5 ? 'selected="selected"' : ''}
							</c:if>>May</option>
						<option value="06"
							${param.endMonth == 06 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 6 ? 'selected="selected"' : ''}
							</c:if>>June</option>
						<option value="07"
							${param.endMonth == 07 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 7 ? 'selected="selected"' : ''}
							</c:if>>July</option>
						<option value="08"
							${param.endMonth == 08 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 8 ? 'selected="selected"' : ''}
							</c:if>>August</option>
						<option value="09"
							${param.endMonth == 09 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 9 ? 'selected="selected"' : ''}
							</c:if>>September</option>
						<option value="10"
							${param.endMonth == 10 ? 'selected="selected"' : ''}
							<c:if test="${param.startMonth == null}" >
							${curMonth == 10 ? 'selected="selected"' : ''}
							</c:if>>October</option>
						<option value="11"
							${param.endMonth == 11 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth == null}" >
							${curMonth == 11 ? 'selected="selected"' : ''}
							</c:if>>November</option>
						<option value="12"
							${param.endMonth == 12 ? 'selected="selected"' : ''}
							<c:if test="${param.endMonth== null}" >
							${curMonth == 12 ? 'selected="selected"' : ''}
							</c:if>>December</option>
				</select> <select id="endDay" name="endDay">
						<c:forEach var="day" begin='1' end='31'>
							<option value="${day}"
								${param.endDay == day ? 'selected="selected"' : ''}
								<c:if test="${param.endDay == null }">
							${curDay == day ? 'selected="selected"' : ''}
							</c:if>>${day}</option>
						</c:forEach>
				</select> <select id="endYear" name="endYear">
						<c:forEach var="year" begin='2000' end='2014'>
							<option value="${year}"
								${param.endYear == year ? 'selected="selected"' : ''}
								<c:if test="${param.endYear == null}">	
							${curYear == year ? 'selected="selected"' : ''}
							</c:if>>${year}</option>
						</c:forEach>
				</select></td>
				<td><select name="statusFilter" size="7" multiple>
						<option value="">{any}</option>
						<c:forEach var="stat" items="${sMap}">
							<option value="${stat.key}"
								<c:forEach var='parameter' items='${statFilterList}'> 
							${parameter == stat.key ? 'selected="selected"' : ''}
							</c:forEach>>${stat.value}</option>
						</c:forEach>
				</select></td>
				<td><select name="fieldName" size="7" multiple>
						<option value="">{any}</option>
						<c:forEach var="field" items="${fieldMap}">
							<option value="${field.key}"
								<c:forEach var='parameter' items='${fieldList}'>  
							${parameter == field.key ? 'selected="selected"' : ''}
							</c:forEach>>${field.value}</option>
						</c:forEach>
				</select></td>
		</table>
		<input type="submit" value="Apply filters" class="applyFilter"
			style="float: right;">
	</form>

	<c:if test="${empty result.rows}">
		<p>No tickets in last 7 days</p>
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
			action="ExportJS?<c:forEach var="pageParam" items="${reqMap}"
			><c:out value="${pageParam.key}"/>=<c:out value="${pageParam.value}"/>&</c:forEach>">
			<input type="submit" value="Export to Excel"> <input
				type="hidden" name="detail" value="detailed">
		</form>
	</c:if>
	<br>
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
							onclick="load('ExportJS?ticketID=${ticket.id}&${fieldSB}','a${ticket.id}');">+/-
						</button></td>
					<td>${ticket.id}</td>
					<td>${ticket.lastUpdate}</td>
					<td>${ticket.name}</td>
					<td>${ticket.username}</td>
					<td>${ticket.summary}</td>
					<td>${sMap[ticket.status + 0]}</td>
					<c:forEach var="custom" items="${customResult.rows}">
						<c:choose>
							<c:when test="${ticket.customNames == custom.name}">
								<td>${ticket.customNames} - ${ticket.value }</td>
							</c:when>
							<c:otherwise>
								<td></td>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</c:when>
				<c:otherwise>
	
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