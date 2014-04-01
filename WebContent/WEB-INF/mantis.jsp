<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Database Query</title>
</head>
<body>
	<h2>Filters</h2>
	<!-- 
	-Make sure I know what table to use	
	
	-Make sql statement that will pull information I need for fields
	
	-Then populate fields for display
	
	-->
	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver"
		url="jdbc:mysql://localhost/mantis" user="root" password="SMT2014" />

	<sql:query dataSource="${snapshot}" var="result">
	
SELECT mbt.id, mbt.summary, mbt.resolution, mpt.name, mut.username
FROM mantis_bug_table mbt
LEFT OUTER JOIN mantis_project_table mpt
ON mbt.project_id = mpt.id
LEFT OUTER JOIN mantis_project_user_list_table mult
ON mpt.id=mult.project_id
LEFT OUTER JOIN mantis_user_table mut
ON mult.user_id = mut.id;
	</sql:query>

	<sql:query dataSource="${snapshot}" var="projectResult">
	SELECT name FROM mantis_project_table;
	</sql:query>

	<sql:query dataSource="${snapshot}" var="userResult">
	SELECT username FROM mantis_user_table;
	</sql:query>

	<table border="1" width="60%">
		<tr>
			<th>Project</th>
			<th>Select your User</th>
			<th>Last Updated Date Range</th>
			<th>Statuses</th>
		</tr>
		<tr>
			<td><select name="project_filter" multiple="multiple" size="5">
					<c:forEach var="project" items="${projectResult.rows}">
						<option value="${project.name}">${project.name}</option>
					</c:forEach>
			</select></td>
			<td><select name="user_filter" multiple="multiple" size="5">
					<c:forEach var="user" items="${userResult.rows}">
						<option value="${user.username}">${user.username}</option>
					</c:forEach>
			</select></td>
			<td>Start Date<select>
					<c:forEach var="month" begin='1' end='12'>
						<option value="${month}">Month ${month}</option>
					</c:forEach>
			</select> <select>
					<c:forEach var="day" begin='1' end='31'>
						<option value="${day}">Day ${day}</option>
					</c:forEach>
			</select> <select>
					<c:forEach var="year" begin='2000' end='2014'>
						<option value="${year}">${year}</option>
					</c:forEach>
			</select> End Date<select>
					<c:forEach var="month" begin='1' end='12'>
						<option value="${month}">Month ${month}</option>
					</c:forEach>
			</select> <select>
					<c:forEach var="day" begin='1' end='31'>
						<option value="${day}">Day ${day}</option>
					</c:forEach>
			</select> <select>
					<c:forEach var="year" begin='2000' end='2014'>
						<option value="${year}">${year}</option>
					</c:forEach>
			</select>
			</td>
			<td><select name="status_filter">
					<c:forEach var="stat" begin='1' end='10'>
						<option value="${stat}">dev complete</option>
					</c:forEach>
			</select></td>
		<tr>
	</table>
	<br></br>
	
	<!-- Filter submit button -->
	<form action="Mantis" method="post">
		<input type="hidden" name="name" value="filter"> <input
			type="submit" value="apply filters"> <br></br>
	</form>


	<h2 align="center">Report Grid</h2>

	<!-- Excel submit button -->
	<form action="Mantis" method="post">
		<input type="hidden" name="name" value="excel"> <input
			type="submit" value="export to excel">
	</form>

	<br>
	<!-- CSV submit button -->
	<form action="Mantis" method="post">
		<input type="hidden" name="name" value="csv"> <input
			type="submit" value="export to csv">
	</form>
	
	<table border="1" width="100%">
		<tr>
			<th>Ticket #</th>
			<th>Project name</th>
			<th>Primary User</th>
			<th>Description</th>
			<th>Resolution/Comments</th>
		</tr>
		<c:forEach var="row" items="${result.rows}">
			<tr>
				<td><c:out value="${row.id}" /></td>
				<td><c:out value="${row.name}" /></td>
				<td><c:out value="${row.username}" /></td>
				<td><c:out value="${row.summary}" /></td>
				<td><c:out value="${row.resolution}" /></td>
			</tr>
		</c:forEach>

	</table>

</body>
</html>