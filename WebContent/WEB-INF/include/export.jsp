<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition","attachment;filename=export.xls");
%>
<c:set var="detailParams" value="${fieldParam}"></c:set>
<%@ include file="logic.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="application/vnd.ms-excel; charset=UTF-8">
<title>Mantis Bug Tracker</title>
</head>
<body>
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://127.0.0.1:3306/mantisbt_current" user="root" password="SMT2014" />
	<sql:query dataSource="${snapshot}" var="projectResult">SELECT name FROM mantis_project_table;</sql:query>
	<sql:query dataSource="${snapshot}" var="customResult">SELECT name, id FROM mantis_custom_field_table;</sql:query>

	<table width="200%" cellspacing="0px">
		<tr>
			<th>Ticket #</th>
			<th colspan="2">Date Last Updated</th>
			<th colspan="2">Project name</th>
			<th colspan="2">Primary User</th>
			<th colspan="2">Description</th>
			<th colspan="2">Status/Comments</th>
			<c:forEach var="custom" items="${customResult.rows}">
				<th colspan="1">${custom.name}</th>
			</c:forEach>
		</tr>
		<c:forEach var="ticket" items="${ticketList}">
			<tr>
				<td align="center">${ticket.ticketID}</td>
				<td colspan="2">${ticket.dateModified}</td>
				<td colspan="2">${ticket.projectName}</td>
				<td colspan="2">${ticket.userName}</td>
				<td colspan="2">${ticket.summary}</td>
				<td colspan="2">${sMap[ticket.status + 0]}</td>
				<c:forEach var="custom" items="${customResult.rows}">
				<td colspan="1"><c:forEach var="field" items="${ticket.customFields}"><c:if test="${custom.name == field.key}">${field.value}</c:if></c:forEach></td>
				</c:forEach>
			</tr>
		</c:forEach>
	</table>
	<c:forEach var="ticket" items="${ticketList}">
	<c:url value="detail.jsp?ticketID=${ticket.ticketID}&${exportfldParams}" var="detailURL"></c:url>
	<c:import url="${detailURL}"/>
	</c:forEach>
</body>
</html>