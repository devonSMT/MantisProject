<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="logic.jsp"%>

	<sql:query dataSource="${dbMantis}" var="history">${sql}</sql:query>
	<table cellspacing="0px" style="border: 2px solid #333;" class="matrix_detail">
	<tr>
	<th colspan="7">Detailed Ticket Information For ${ticketId}</th>
	</tr>
		<tr>
			<th colspan="2">Date Modified</th>
			<th colspan="2">Username</th>
			<th colspan="2">Fieldname</th>
			<th colspan="2">Change Over Status</th>
		</tr>
		<c:forEach var="change" items="${history.rows}">
			<tr>
				<td colspan="2">${change.modDate}</td>
				<td colspan="2">${change.username}</td>
				<td colspan="2"><c:choose><c:when test="${empty change.field_name}">${typeList[change.type + 0]}</c:when>
				<c:when test="${change.field_name == 'handler_id'}">Assigned To</c:when>
				<c:otherwise>${change.field_name}</c:otherwise></c:choose></td>
				<%-- REFACTOR: Complex SQL and logic operations should be partitioned off to the model side. View
				should just handle looping through list of normal/detailed ticket list --%>
				<td colspan="2"><c:choose><c:when test="${change.field_name == 'handler_id'}">
				<sql:query dataSource="${dbMantis}" var="user">SELECT username FROM mantis_user_table WHERE id = ${change.old_value};</sql:query>${user.rows[0].username} ->
				<sql:query dataSource="${dbMantis}" var="user">SELECT username FROM mantis_user_table WHERE id = ${change.new_value};</sql:query>${user.rows[0].username}</c:when>
				<c:when test="${change.field_name == 'status'}">${sMap[change.old_value + 0]} ->${sMap[change.new_value + 0]}</c:when>
				<c:when test="${change.field_name == 'resolution'}">${rsList[change.old_value + 0]} -> ${rsList[change.new_value + 0]}</c:when>
				<c:when test="${change.type == 18}"> ${relationList[change.old_value + 0]} > ${change.new_value}</c:when>
				<c:when test="${change.field_name == 'priority'}">${priority[change.old_value + 0]} -> ${priority[change.new_value + 0]}</c:when>
				<c:otherwise>${change.old_value} -> ${change.new_value}</c:otherwise></c:choose></td>
			</tr>
		</c:forEach>
	</table>