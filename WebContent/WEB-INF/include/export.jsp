<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
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
	
	request.setAttribute("userList", users);
%>

<%
	//get all filter parameters
	
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
	startDate = startMonth + "/"+ startDay + "/" + startYear;
	startEpoch = new SimpleDateFormat("MM/dd/yyyy").parse(startDate).getTime()/1000;
	}
	if(endDay != null && endDay != ""
	&& endMonth != null && endMonth != ""
	&& endYear != null && endYear != ""){
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
	if(request.getParameterValues("userName") != null){
		String[] params = request.getParameterValues("userName");
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
			for(int i =0; i < params.length; i++){		
				if(i < 1 && params[i] != ""){
				sb.append(" AND( mut.username='"+ params[i] + "'");
				}else if(params[i] != ""){
					sb.append(" OR mut.username='"+ params[i] + "'");
					System.out.println(params);
				}	
			}
		sb.append(")");
		}
	}
	
	if(request.getParameterValues("projectName") != null){
		String[] params = request.getParameterValues("projectName");
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
			for(int i =0; i < params.length; i++){		
			if(i < 1 && params[i] != ""){
				sb.append(" AND( mpt.name='"+ params[i] + "'");
			}else if(params[i] != ""){
				sb.append(" OR mpt.name='"+ params[i] + "'");
				System.out.println(params[i]);
				}	
			}
		sb.append(")");
		}
	}
	
	if(request.getParameterValues("statusFilter") != null){
		String[] params = request.getParameterValues("statusFilter");
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
			for(int i =0; i < params.length; i++){		
			if(i < 1 && params[i] != ""){
				sb.append(" AND( mbt.status='"+ params[i] + "'");
			}else if(params[i] != ""){
				sb.append(" OR mbt.status='"+ params[i] + "'");
				System.out.println(params[i]);
				}	
			}
		sb.append(")");
		}
	}

	if(startDate != null && endDate == null){
		sb.append(" AND mbt.last_updated >= " + startEpoch);
		
	}else if(endDate != null && startDate == null){
		sb.append(" AND mbt.last_updated >= " + endEpoch);
	
	}else if(startDate != null && endDate != null){
	sb.append(" AND mbt.last_updated BETWEEN " + startEpoch + " AND " + endEpoch);
	
	}else if(startDate == null && endDate == null){
		sb.append(" AND mbt.last_updated >= unix_timestamp(date_sub(now(), interval 7 DAY))");
	}
	
	sb.append(" ORDER BY mbt.last_updated DESC");
	request.setAttribute("sql", sb.toString());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mantis Ticket Tracker</title>
<script>
	//display function
	function toggle(id) {
		var e = document.getElementById(id);
		if (e.style.display == "none") {
			e.style.display = "block";
		
		} else {
			e.style.display = "none";
		}
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

	<c:if test="${empty result.rows}">
		<p>No tickets in last 7 days</p>
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
			<th colspan="8">Custom Information</th>
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
								<td id="${moveID}" style="display: block" colspan="7"><c:url
										value="detail.jsp" var="detailURL">
										<c:param name="ticketID" value="${moveID}" />
									</c:url> <c:import url="${detailURL}" /></td>
							</tr>
							<tr>
						</c:otherwise>
					</c:choose>
					<td>Ticket Information</td>
					<td width="70%">${ticket.id}</td>
					<td width="70%">${ticket.lastUpdate}</td>
					<td width="70%">${ticket.name}</td>
					<td width="70%">${ticket.username}</td>
					<td width="70%">${ticket.summary}</td>
					<td width="70%">${sMap[ticket.status + 0]}</td>
					<td width="70%">${ticket.customNames}-${ticket.value }</td>
				</c:when>
				<c:otherwise>
					<td>${ticket.customNames}-${ticket.value }</td>
				</c:otherwise>
			</c:choose>
			<c:set var="moveID" value="${ticket.id}" />
		</c:forEach>
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