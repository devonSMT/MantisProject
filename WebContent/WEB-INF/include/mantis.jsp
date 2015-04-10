<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="driver" value="com.mysql.jdbc.Driver"/>
<c:set var="dbLoc" value="jdbc:mysql://127.0.0.1:3306/mantisbt_current"/>
<c:set var="userVal" value="root"/>
<c:set var="passVal" value="SMT2014"/>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="binary/scripts/mantis.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mantis Bug Tracker</title>
</head>
<body>
	<div id="logo">
		<img src="binary/images/logo.png" alt="SMT_Bug_Tracker" />
	</div>	
	
	<sql:setDataSource var="dbMantis" driver="${driver}" url="${dbLoc}" user="${userVal}" password="${passVal}" scope="application" />
	<sql:query dataSource="${dbMantis}" var="projectResult"> SELECT name FROM mantis_project_table; </sql:query>
	<sql:query dataSource="${dbMantis}" var="customResult"> SELECT name, id FROM mantis_custom_field_table; </sql:query>
	<sql:query dataSource="${dbMantis}" var="userResult"> SELECT username FROM mantis_user_table WHERE enabled = 1 ORDER BY username ASC; </sql:query>

	<%@ include file="filter.jsp"%>
	<br>
	<c:if test="${ticketError != null}"><p><font color="#B00000">${ticketError}</font></p></c:if>
	<c:if test="${dateError != null }"><p><font color="#B00000">${dateError}</font></p></c:if>
	<c:if test="${empty ticketList}"><p>No Tickets Found</p></c:if>
	
	<h2 id="display_date" align="center" class="normal">
		<c:choose>
			<c:when test="${empty paramValues}">Displaying Tickets From ${lastWeek} - ${currentDate}</c:when>
			<c:when test="${param.ticketID != null }"> Displaying Tickets From ${lastWeek} - ${currentDate} </c:when>
			<c:otherwise> Displaying Tickets From ${sDate} - ${eDate}</c:otherwise>
		</c:choose>
	</h2>
	<h2 class="times" >Report Grid</h2>
	<c:if test="${empty param.exportToCSV }">
		<form method="post" action="Report?type=export">
			<input type="submit" class="exportButton" name="excel" value="Export to Excel">
		</form>
	</c:if>
	<table width="100%" cellspacing="0px" class="mantisTable">
		<tr>
			<th>&nbsp;</th>
			<th>Ticket #</th>
			<th>Last Updated On</th>
			<th>Project name</th>
			<th>Assigned To</th>
			<th>Summary</th>
			<th>Current Status</th>
			<c:forEach var="custom" items="${customResult.rows}">
				<th>${custom.name}</th>
			</c:forEach>
		</tr><c:set var="count" value="0"></c:set><c:forEach var="ticket" items="${ticketList}">
			<tr>	
				<td><button onclick="load('Report', 'type=detail&#38ticketID=${ticket.ticketID}&#38${mainParams}','a${ticket.ticketID }');">+/-</button></td>
				<td>${ticket.ticketID}</td>
				<td>${ticket.dateModified}</td>
				<td>${ticket.projectName}</td>
				<td>${ticket.userName}</td>
				<td>${ticket.summary}</td>
				<td>${sMap[ticket.status + 0]}</td>
				<c:forEach var="custom" items="${customResult.rows}"><c:set var="count" value="${count + 1}"></c:set>
				<td id="custom${count}"><font color="red">x</font><c:forEach var="field" items="${ticket.customFields}"><c:if test="${custom.name == field.key && field.value != ''}"><c:choose><c:when test="${field.key == 'Est. Delivery Date' || field.key == 'Actual Delivery Date' || field.key == 'Est. Start Date'}"><c:set var="customDate" value="${field.value}"></c:set><%DateHandler dteHdl = new DateHandler(); String formatDate = dteHdl.getReadableDate((String)pageContext.getAttribute("customDate")); request.setAttribute("formatDate", formatDate); %><script type="text/javascript"> checkTag("custom${count}", '${formatDate}');</script> </c:when><c:otherwise><script type="text/javascript"> checkTag("custom${count}", '${field.value}');</script></c:otherwise></c:choose></c:if></c:forEach></td>
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
	
<script type="text/javascript">
	function toggle(id) {
		var e = document.getElementById(id);
		if (e.style.display == "none") {
			e.style.display = "";
		} else {
			e.style.display = "none";
		}
	};

	function load(url, data, id) {
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
		xmlhttp.open("POST", url, true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send(data);
		
	};
	
	function checkTag(id, value){
		document.getElementById(id).innerHTML = value;	
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
	};
</script>
</body>
</html>