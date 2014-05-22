<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%
	//change content to csv
response.setContentType("application/vnd.ms-excel");
%>
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mantis Export</title>
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

	function populate(value) {
		return value;
	};

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
	};
</script>
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

	<c:if test="${ticketError != null}">
		<p>${ticketError}</p>
	</c:if>

	<c:if test="${empty result.rows}">
		<p>No tickets found</p>
	</c:if>

	<table id="displayTickets" border="1" width="400%">
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
							<tr>
								<td id="a${moveID}" style="display: block" colspan="7">
								<c:url value="detail.jsp" var="detailURL">
										<c:param name="ticketID" value="${moveID}" />
									</c:url> <c:import url="${detailURL}" /></td>
							</tr>
							<tr>
						</c:otherwise>
					</c:choose>
					<td>Ticket Information</td>
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

							</c:if>
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
		<tr >
			<td id="a${moveID}" style="display: block" colspan="7"><c:url
					value="detail.jsp" var="detailURL">
					<c:param name="ticketID" value="${moveID}" />
				</c:url> <c:import url="${detailURL}" /></td>
		</tr>
	</table>
</body>
</html>