<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="logic.jsp"%>
<% response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition","attachment;filename=export.xls");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="application/vnd.ms-excel; charset=UTF-8">
<title>Mantis Export</title>
</head>
<body>
<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://127.0.0.1:3306/mantisbt_current" user="root" password="SMT2014" />
	<sql:query dataSource="${snapshot}" var="projectResult">SELECT name FROM mantis_project_table;</sql:query>
	<sql:query dataSource="${snapshot}" var="customResult">SELECT name, id FROM mantis_custom_field_table;</sql:query>

	<table width="200%" cellspacing="0px">
		<tr>
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
		<c:forEach var="ticket" items="${ticketList}">
			<tr>
				<td>${ticket.ticketID}</td>
				<td>${ticket.dateModified}</td>
				<td>${ticket.projectName}</td>
				<td>${ticket.userName}</td>
				<td>${ticket.summary}</td>
				<td>${sMap[ticket.status + 0]}</td>
				<c:forEach var="custom" items="${customResult.rows}">
				<td><c:forEach var="field" items="${ticket.customFields}"><c:if test="${custom.name == field.key}">${field.value}</c:if></c:forEach></td>
				</c:forEach>
			<c:url value="detail.jsp" var="detailURL"><c:param name="ticketID" value="${ticket.ticketID}" /></c:url>
				<td><c:import url="${detailURL}"/></td>
			</tr>	
		</c:forEach>
	</table>
</body>
</html>