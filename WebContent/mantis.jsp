<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	//Set mapping for all status
	HashMap<Long, String> hashMap = new HashMap<Long, String>();

	hashMap.put(10L, "new");
	hashMap.put(50L, "assigned");
	hashMap.put(53L, "qa failed");
	hashMap.put(55L, "in progress");
	hashMap.put(60L, "dev complete");
	hashMap.put(71L, "SMT QA Review");
	hashMap.put(73L, "SMT Regression");
	hashMap.put(74L, "SMT QA Approved");
	hashMap.put(75L, "User Acceptance");
	hashMap.put(80L, "resolved");
	hashMap.put(90L, "closed");

	request.setAttribute("hMap", hashMap);
	
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
	users.add("seckman");
	users.add("tjohnson");
	users.add("valerie");
	
	request.setAttribute("userList", users);
%>

<%
	//Check if user wants to submit to csv
	String excel = request.getParameter("exportToCSV");
	if (excel != null && excel.toString().equalsIgnoreCase("YES")) {
	response.setContentType("text/csv");
	}
	
	//get all filter parameters
	String user = request.getParameter("userName");
	String project = request.getParameter("projectName");
	String status = request.getParameter("statusFilter");
	
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
	if(startDay != null && startMonth != null && startYear != null ){
	startDate = startMonth + "/"+ startDay + "/" + startYear;
	startEpoch = new SimpleDateFormat("MM/dd/yyyy").parse(startDate).getTime()/1000;
	}
	if(endDay != null && endMonth != null && endYear != null ){
	endDate = endMonth + "/"+ endDay + "/" + endYear;
	endEpoch = new SimpleDateFormat("MM/dd/yyyy").parse(endDate).getTime()/1000;
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
	if (user != null) {
		sb.append(" AND mut.username='" + user + "'");
	}
	if(project != null){
		sb.append(" AND mpt.name='"+ project + "'");
	}
	if(status != null){
		sb.append(" AND mbt.status=" + status);
	}
	if(startDate != null && endDate == null){
		sb.append(" AND mbt.last_updated >= " + startEpoch);
		
	}else if(endDate != null && startDate == null){
		sb.append(" AND mbt.last_updated <= " + endEpoch);
	
	}else if(startDate != null && endDate != null){
	sb.append(" AND mbt.last_updated BETWEEN " + startEpoch + " AND " + endEpoch);
	
	}
	if(user ==null && project ==null && status ==null && startDate ==null && endDate ==null){
		sb.append(" AND mbt.last_updated >= unix_timestamp(date_sub(now(), interval 45 DAY))");
	}

	sb.append(" ORDER BY mbt.last_updated DESC");
	request.setAttribute("sql", sb.toString());
	
	//place request parameters inside of session for tracking
	Enumeration<String> e = request.getParameterNames();
	
	while(e.hasMoreElements()) {
		String key = (String) e.nextElement();
		session.setAttribute(key, request.getParameter((key)));
	}
	
	//Create hashmap for session variables
	HashMap<String, String> sessionMap = new HashMap<String, String>();
	
	Enumeration<String> enm = session.getAttributeNames();
	while(enm.hasMoreElements()) {
		String key = (String) enm.nextElement();
		sessionMap.put(key, (String)session.getAttribute(key));
	}

	request.setAttribute("sMap", sessionMap);
	session.invalidate();
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Database Query</title>
<script>
	//code to set element's name
	function selectName(id) {
		document.getElementById(id).name = id;
	};
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
	function load(url,id)
	{
	toggle(id);
	var xmlhttp;
	if (window.XMLHttpRequest)
	  {// code for IE7+, Firefox, Chrome, Opera, Safari
	  xmlhttp=new XMLHttpRequest();
	  }
	else
	  {// code for IE6, IE5
	  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	  }
	xmlhttp.onreadystatechange=function()
	  {
	  if (xmlhttp.readyState==4 && xmlhttp.status==200)
	    {
	    document.getElementById(id).innerHTML=xmlhttp.responseText;
	    }
	  };
	xmlhttp.open("GET",url,true);
	xmlhttp.send();
	};
</script>
</head>
<style>
table {
	background-color: #D3D3D3
}

body {
	font-family: Arial, sans-serif;
	font-size: 14pt;
}
</style>
<body >

	<h2>Filters</h2>
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
			url="jdbc:mysql://192.168.2.185/mantisbt_current" user="devon" password="sqll0gin" />

	<sql:query dataSource="${snapshot}" var="result">
		${sql}
	</sql:query>

	<sql:query dataSource="${snapshot}" var="projectResult">
	SELECT name FROM mantis_project_table;
	</sql:query>

	<form action="mantis.jsp" method="post">
		<table border="1" width="100%">
			<tr>
				<th>Project</th>
				<th>Select your User</th>
				<th>Last Updated Date Range</th>
				<th>Select Status</th>
			</tr>
			<tr>
				<td><select id="projectName" name=""
					onClick="selectName('projectName')">
						<c:forEach var="project" items="${projectResult.rows}">

							<%-- check to see if value was selected 	--%>-- 		
						<c:if test="${project.name == param.projectName }">
								<option value="${project.name}" SELECTED>${project.name}</option>
							</c:if>
							<option value="${project.name}">${project.name}</option>
						</c:forEach>

				</select></td>
				<td><select id="userName" name=""
					onClick="selectName('userName')">
						<c:forEach var="user" items="${userList}">

							<c:if test="${user == param.userName }">
								<option value="${user}" SELECTED>${user}</option>
							</c:if>
							<option value="${user}">${user}</option>
						</c:forEach>

				</select></td>
				<td><b>Start Date</b><select id="startMonth" name=""
					onClick="selectName('startMonth')">
						<option value="01" ${param.startMonth == 01 ? 'selected="selected"' : ''}>January</option>
						<option value="02" ${param.startMonth == 02 ? 'selected="selected"' : ''}>February</option>
						<option value="03" ${param.startMonth == 03 ? 'selected="selected"' : ''}>March</option>
						<option value="04" ${param.startMonth == 04 ? 'selected="selected"' : ''}>April</option>
						<option value="05" ${param.startMonth == 05 ? 'selected="selected"' : ''}>May</option>
						<option value="06" ${param.startMonth == 06 ? 'selected="selected"' : ''}>June</option>
						<option value="07" ${param.startMonth == 07 ? 'selected="selected"' : ''}>July</option>
						<option value="08" ${param.startMonth == 08 ? 'selected="selected"' : ''}>August</option>
						<option value="09" ${param.startMonth == 09 ? 'selected="selected"' : ''}>September</option>
						<option value="10" ${param.startMonth == 10 ? 'selected="selected"' : ''}>October</option>
						<option value="11" ${param.startMonth == 11 ? 'selected="selected"' : ''}>November</option>
						<option value="12" ${param.startMonth == 12 ? 'selected="selected"' : ''}>December</option>
				</select> <select id="startDay" name="" onClick="selectName('startDay')">

						<c:forEach var="day" begin='1' end='31'>
							<c:if test="${day == param.startDay }">
								<option value="${day}" SELECTED>${day}</option>
							</c:if>
							<option value="${day}">${day}</option>
						</c:forEach>

				</select> <select id="startYear" name="" onClick="selectName('startYear')">

						<c:forEach var="year" begin='2000' end='2014'>
							<c:if test="${year == param.startYear }">
								<option value="${year}" SELECTED>${year}</option>
							</c:if>
							<option value="${year}">${year}</option>
						</c:forEach>

				</select> <b>End Date</b><select id="endMonth" name=""
					onClick="selectName('endMonth')">
						<option value="01" ${param.endMonth == 01 ? 'selected="selected"' : ''}>January</option>
						<option value="02" ${param.endMonth == 02 ? 'selected="selected"' : ''}>February</option>
						<option value="03" ${param.endMonth == 03 ? 'selected="selected"' : ''}>March</option>
						<option value="04" ${param.endMonth == 04 ? 'selected="selected"' : ''}>April</option>
						<option value="05" ${param.endMonth == 05 ? 'selected="selected"' : ''}>May</option>
						<option value="06" ${param.endMonth == 06 ? 'selected="selected"' : ''}>June</option>
						<option value="07" ${param.endMonth == 07 ? 'selected="selected"' : ''}>July</option>
						<option value="08" ${param.endMonth == 08 ? 'selected="selected"' : ''}>August</option>
						<option value="09" ${param.endMonth == 09 ? 'selected="selected"' : ''}>September</option>
						<option value="10" ${param.endMonth == 10 ? 'selected="selected"' : ''}>October</option>
						<option value="11" ${param.endMonth == 11 ? 'selected="selected"' : ''}>November</option>
						<option value="12" ${param.endMonth == 12 ? 'selected="selected"' : ''}>December</option>
				</select> <select id="endDay" name="" onClick="selectName('endDay')">

						<c:forEach var="day" begin='1' end='31'>
							<c:if test="${day == param.endDay }">
								<option value="${day}" SELECTED>${day}</option>
							</c:if>
							<option value="${day}">${day}</option>
						</c:forEach>

				</select> <select id="endYear" name="" onClick="selectName('endYear')">

						<c:forEach var="year" begin='2000' end='2014'>
							<c:if test="${year == param.endYear }">
								<option value="${year}" SELECTED>${year}</option>
							</c:if>
							<option value="${year}">${year}</option>
						</c:forEach>

				</select></td>
				<td><select id="statusFilter" name=""
					onClick="selectName('statusFilter')">

						<c:forEach var="stat" items="${hMap}">
							<c:if test="${stat.key == param.statusFilter }">
								<option value="${stat.key}" SELECTED>${stat.value}</option>
							</c:if>
							<option value="${stat.key}">${stat.value}</option>
						</c:forEach>

				</select></td>
			<tr>
		</table>
		<input type="submit" value="apply filters">
	</form>
	<!-- Clear filter button -->
	<form action="mantis.jsp">
		<input type="submit" value="Clear Filters" style="float: right;">
	</form>

	<h2 align="center">Report Grid</h2>
	
	<!-- CSV submit button -->
	<c:if test="${empty param.exportToCSV }">
		<form method="post"
			action="export.jsp?<c:forEach var="pageParam" items="${sMap}"
			><c:out value="${pageParam.key}"/>=<c:out value="${pageParam.value}"/>&</c:forEach>">
			<input type="submit" value="Export to CSV"> <input
				type="hidden" name="exportToCSV" value="YES">
		</form>		
	</c:if>
	<br>
	<table id="displayTickets" border="1" width="100%">
		<tr>
			<th></th>
			<th>Ticket #</th>
			<th>Date Last Updated</th>
			<th>Project name</th>
			<th>Primary User</th>
			<th>Description</th>
			<th>Status/Comments</th>
			<th colspan="8">Custom Information</th>
		</tr>
		<!-- set variables for loop-->
		<c:set var="moveID" value="0" />
		<c:forEach var="ticket" items="${result.rows}">
			<c:set var="currentID" value="${ticket.id}" />
			<c:choose>
				<c:when test="${currentID != moveID}">
					<c:choose>
						<c:when test="${moveID == 0 }">
							<tr>
						</c:when>
						<c:otherwise>
							</tr>
							<tr>
								<td id="${moveID}" style="display:none" colspan="5"></td>
							</tr>
							<tr>
						</c:otherwise>
					</c:choose>
					<td><button onclick="load('detail.jsp?ticketID=${ticket.id}',${ticket.id})">+/-</button></td>
					<td>${ticket.id}</td>
					<td>${ticket.lastUpdate}</td>
					<td>${ticket.name}</td>
					<td>${ticket.username}</td>
					<td>${ticket.summary}</td>
					<td>${hMap[ticket.status + 0]}</td>
					<td>${ticket.customNames}-${ticket.value }</td>
				</c:when>
				<c:otherwise>
					<td>${ticket.customNames}-${ticket.value }</td>
				</c:otherwise>
			</c:choose>
			<c:set var="moveID" value="${ticket.id}" />
		</c:forEach>
		<!-- Close off table row when loop is finished -->
		</tr>
		<tr>
			<td id="${moveID}" style="display: none" colspan="7"><c:url
					value="detail.jsp" var="detailURL">
					<c:param name="ticketID" value="${moveID}" />
				</c:url> <c:import url="${detailURL}" /></td>
		</tr>
	</table>
</body>
</html>