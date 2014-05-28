<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="logic.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style/mantis.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mantis Bug Tracker</title>
<script type="text/javascript">
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
		};
		
	}
</script>

</head>
<body>
	<img src="images/logo.png" alt="SMT Bug Tracker">

	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://127.0.0.1:3306/mantisbt_current" user="root"
		password="SMT2014" />

	<sql:query dataSource="${snapshot}" var="projectResult">
	SELECT name FROM mantis_project_table;
	</sql:query>

	<sql:query dataSource="${snapshot}" var="customResult">
	SELECT name, id FROM mantis_custom_field_table;
	</sql:query>

	<%@ include file="filter.jsp"%>

	<!-- Error checking -->
	<c:if test="${ticketError != null}">
		<p>
			<font color="#B00000">${ticketError}</font>
		</p>
	</c:if>

	<c:if test="${dateError != null }">
		<p>
			<font color="#B00000">${dateError}</font>
		</p>
	</c:if>

	<c:if test="${empty ticketList}">
		<p>No Tickets Found</p>
	</c:if>

	<h2 id="display_date" align="center">
		<c:choose>
			<c:when test="${empty paramValues}">
		Displaying Tickets From ${lastWeek} - ${currentDate} 
		</c:when>
			<c:when test="${param.ticketID != null }">
					Displaying Tickets From ${lastWeek} - ${currentDate} 
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
			<input type="submit" name="excel" value="Export to Excel"> <input
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
			<th>Assigned To</th>
			<th>Description</th>
			<th>Status/Comments</th>
			<c:forEach var="custom" items="${customResult.rows}">
				<th>${custom.name}</th>
			</c:forEach>
		</tr>
		<c:forEach var="ticket" items="${ticketList}">
			<tr>
				<td><button
						onclick="load('Mantis?type=detail&#38ticketID=${ticket.ticketID}&#38${fieldSB}','a${ticket.ticketID }');">+/-
					</button></td>
				<td>${ticket.ticketID}</td>
				<td>${ticket.dateModified}</td>
				<td>${ticket.projectName}</td>
				<td>${ticket.userName}</td>
				<td>${ticket.summary}</td>
				<td>${sMap[ticket.status + 0]}</td>
				<c:forEach var="custom" items="${customResult.rows}">
					<td class="custom"><c:forEach var="field" items="${ticket.customFields}">
							<c:if test="${custom.name == field.key}">
							${field.value}
							</c:if>
						</c:forEach>
						</td>
				</c:forEach>
			</tr>
			<tr>
				<td style="display: none"></td>
			</tr>
			<tr class="blend">
				<td id="a${ticket.ticketID}" style="display: none" colspan="16"></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>