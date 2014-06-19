<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.* "%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="logic.jsp"%>
<!-- SEARCH BAR -->
<div id="tfheader">
	<form id="tfnewsearch" method="get" action="Mantis">
		<input type="text" id="tfq" class="tftextinput2" name="ticketID"
			size="21" maxlength="120" value="Search by Ticket No."> <input
			type="submit" value=">" class="tfbutton2">
	</form>
</div>

<h2 class="times" align="left">Ticket Filters</h2>
<form action="Mantis" method="post">
	<table class="filterTable" cellspacing="0">
		<tr>
			<th>Select Project</th>
			<th>Select Assigned To User</th>
			<th>Date Last Modified</th>
			<th>Select Status</th>
			<th>Detailed Information</th>
		</tr>
		<tr>
			<td><select class="filterSelect" name="projectName" size="7" multiple>
					<option value="" ${param.projectName == "" ? 'selected="SELECTED"' : ''}>{any}</option>
					<c:forEach var="project" items="${projectResult.rows}">
						<option value="${project.name}" <c:forEach var='parameter' items="${paramValues['projectName']}">${parameter == project.name ? 'selected="SELECTED"' : ''} </c:forEach>>${project.name}</option>
					</c:forEach>
			</select></td>
			<td><select class="filterSelect" name="userName" size="7" multiple>
					<option value="" ${param.userName == "" ? 'selected="SELECTED"' : ''}>{any}</option>
					<c:forEach var="user" items="${userResult.rows}">
						<option value="${user.username}" <c:forEach var='parameter' items="${paramValues['userName']}">	${parameter == user.username ? 'selected="SELECTED"' : ''} </c:forEach>>${user.username}</option>
					</c:forEach>
			</select></td>		
			<td class="customTD"><div class="inline">
			<b>Start Date:</b><select name="startMonth">
					<option value="01" ${param.startMonth == 01 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 1 ? 'selected="selected"' : ''} </c:if>>January</option>
					<option value="02" ${param.startMonth == 02 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 2 ? 'selected="selected"' : ''} </c:if>>February</option>
					<option value="03" ${param.startMonth == 03 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 3 ? 'selected="selected"' : ''} </c:if>>March</option>
					<option value="04" ${param.startMonth == 04 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 4 ? 'selected="selected"' : ''} </c:if>>April</option>
					<option value="05" ${param.startMonth == 05 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 5 ? 'selected="selected"' : ''} </c:if>>May</option>
					<option value="06" ${param.startMonth == 06 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 6 ? 'selected="selected"' : ''} </c:if>>June</option>
					<option value="07" ${param.startMonth == 07 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 7 ? 'selected="selected"' : ''} </c:if>>July</option>
					<option value="08" ${param.startMonth == 08 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 8 ? 'selected="selected"' : ''}</c:if>>August</option>
					<option value="09" ${param.startMonth == 09 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 9 ? 'selected="selected"' : ''}</c:if>>September</option>
					<option value="10" ${param.startMonth == 10 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 10 ? 'selected="selected"' : ''} </c:if>>October</option>
					<option value="11" ${param.startMonth == 11 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 11 ? 'selected="selected"' : ''} </c:if>>November</option>
					<option value="12" ${param.startMonth == 12 ? 'selected="selected"' : ''} <c:if test="${param.startMonth == null}" > ${pastMonth == 12 ? 'selected="selected"' : ''} </c:if>>December</option>
			</select>
			<select id="startDay" name="startDay">
					<c:forEach var="day" begin='1' end='31'>
						<option value="${day}" ${param.startDay == day ? 'selected="selected"' : ''} <c:if test="${param.startDay == null }"> ${daysAgo == day ? 'selected="selected"' : ''}</c:if>>${day}</option>
					</c:forEach>
			</select>
			<select id="startYear" name="startYear">
					<c:forEach var="year" begin='2000' end='${presentYear}'>
						<option value="${year}" ${param.startYear == year ? 'selected="selected"' : ''}<c:if test="${param.startYear == null }">${presentYear == year ? 'selected="selected"' : ''}</c:if>>${year}</option>
					</c:forEach>
			</select></div>
			<div class="inline"><b>End Date: </b><select name="endMonth">
					<option value="01" ${param.endMonth == 01 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 1 ? 'selected="selected"' : ''} </c:if>>January</option>
					<option value="02" ${param.endMonth == 02 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 2 ? 'selected="selected"' : ''} </c:if>>February</option>
					<option value="03" ${param.endMonth == 03 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 3 ? 'selected="selected"' : ''} </c:if>>March</option>
					<option value="04" ${param.endMonth == 04 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 4 ? 'selected="selected"' : ''} </c:if>>April</option>
					<option value="05" ${param.endMonth == 05 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 5 ? 'selected="selected"' : ''} </c:if>>May</option>
					<option value="06" ${param.endMonth == 06 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 6 ? 'selected="selected"' : ''} </c:if>>June</option>
					<option value="07" ${param.endMonth == 07 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 7 ? 'selected="selected"' : ''} </c:if>>July</option>
					<option value="08" ${param.endMonth == 08 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 8 ? 'selected="selected"' : ''} </c:if>>August</option>
					<option value="09" ${param.endMonth == 09 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 9 ? 'selected="selected"' : ''} </c:if>>September</option>
					<option value="10" ${param.endMonth == 10 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 10 ? 'selected="selected"' : ''} </c:if>>October</option>
					<option value="11" ${param.endMonth == 11 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 11 ? 'selected="selected"' : ''}</c:if>>November</option>
					<option value="12" ${param.endMonth == 12 ? 'selected="selected"' : ''} <c:if test="${param.endMonth == null}" > ${curMonth == 12 ? 'selected="selected"' : ''} </c:if>>December</option></select>
			<select id="endDay" name="endDay">
					<c:forEach var="day" begin='1' end='31'>
						<option value="${day}"${param.endDay == day ? 'selected="selected"' : ''}<c:if test="${param.endDay == null }">${curDay == day ? 'selected="selected"' : ''}</c:if>>${day}</option>
					</c:forEach>
			</select>
			<select name="endYear">
					<c:forEach var="year" begin='2000' end='${presentYear}'>
						<option value="${year}"${param.endYear == year ? 'selected="selected"' : ''}<c:if test="${param.endYear == null}">${presentYear == year ? 'selected="selected"' : ''}</c:if>>${year}</option>
					</c:forEach>
			</select></div></td>
			<td><select class="filterSelect" name="statusFilter" size="7" multiple>
					<option value="" ${param.statusFilter == "" ? 'selected="SELECTED"' : ''}>{any}</option>
					<c:forEach var="stat" items="${sMap}">
						<option value="${stat.key}"<c:forEach var='parameter' items="${paramValues['statusFilter']}"> ${parameter == stat.key ? 'selected="selected"' : ''}</c:forEach>>${stat.value}</option>
					</c:forEach>
			</select></td>
			<td><select class="filterSelect" name="fieldName" size="7" multiple>
					<option value="" ${param.fieldName == "" ? 'selected="SELECTED"' : ''}>{any}</option>
					<c:forEach var="field" items="${fieldMap}">
						<option value="${field.key}"<c:forEach var='parameter' items="${paramValues['fieldName']}">  ${parameter == field.key ? 'selected="selected"' : ''}</c:forEach>>${field.value}</option>
					</c:forEach>
			</select></td>
	</table>
	<input type="submit" value="Apply filters" class="applyFilter">
</form>
<form method="get" action="Mantis?type=mantis">
	<input type="submit" value="Clear Filters" class="clearFilter">
</form>
