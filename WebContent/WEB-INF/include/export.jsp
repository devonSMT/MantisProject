<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%--Separate form to handle when user wants to export to excel spreadsheet --%>
<%
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition","attachment;filename=export.xls");
%>
<c:set var="requestParams" value="${allParams}" ></c:set>
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
			<th>Date Last Modified</th>
			<th>Project name</th>
			<th>Primary User</th>
			<th>Description</th>
			<th>Status/Comments</th>
			<c:forEach var="custom" items="${customResult.rows}">
				<th>${custom.name}</th>
			</c:forEach>
		</tr>
		<c:forEach var="ticket" items="${ticketList}">
			<tr>
				<td valign="top" align="center">Ticket ${ticket.ticketID}</td>
				<td valign="top">${ticket.dateModified}</td>
				<td valign="top">${ticket.projectName}</td>
				<td valign="top">${ticket.userName}</td>
				<td valign="top">${ticket.summary}</td>
				<td valign="top">${sMap[ticket.status + 0]}</td>
				<c:forEach var="custom" items="${customResult.rows}">
				<td valign="top"><c:forEach var="field" items="${ticket.customFields}"><c:if test="${custom.name == field.key}">${field.value}</c:if></c:forEach></td>
				</c:forEach>
			</tr>
			<tr>
				<td><c:url value="detail.jsp?${exportParams}" var="detailURL"><c:param name="ticketID" value="${ticket.ticketID}" /></c:url><c:import url="${detailURL}"/></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>