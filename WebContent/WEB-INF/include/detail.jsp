<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ include file="logic.jsp"%>

	<sql:setDataSource var="snapshot" driver="com.mysql.jdbc.Driver" url="jdbc:mysql://127.0.0.1:3306/mantisbt_current" user="root" password="SMT2014" />

	<c:if test="${empty detailList}"><h3><font color="#B00000">No Matching Detailed Information found for ticket</font></h3></c:if>

	<table width="200%" cellspacing="0px">
	<tr>
	<th colspan="7">Detailed Ticket Information For #${ticketId}</th>
	</tr>
		<tr>
			<th colspan="2">Date Last Modified</th>
			<th colspan="2">User</th>
			<th colspan="2">Field</th>
			<th colspan="2">Change</th>
		</tr>
		<c:forEach var="change" items="${detailList}">
			<tr>
				<td colspan="2">${change.modDate}</td>
				<td colspan="2">${change.userName}</td>
				<td colspan="2"><c:choose><c:when test="${empty change.fieldName}">${typeList[change.type + 0]}</c:when><c:when test="${change.fieldName == 'handler_id'}">Assigned To</c:when><c:otherwise>${change.fieldName}</c:otherwise></c:choose></td>
				<td colspan="2"><c:choose><c:when test="${change.fieldName == 'handler_id'}"><sql:query dataSource="${snapshot}" var="user">SELECT username FROM mantis_user_table WHERE id = ${change.oldValue};</sql:query>${user.rows[0].username} -><sql:query dataSource="${snapshot}" var="user">SELECT username FROM mantis_user_table WHERE id = ${change.newValue};</sql:query>${user.rows[0].username}</c:when><c:when test="${change.fieldName == 'status'}">${smap[change.oldValue + 0]} ->${smap[change.newValue + 0]}</c:when><c:when test="${change.fieldName == 'resolution'}">${rsList[change.oldValue + 0]} -> ${rsList[change.newValue + 0]}</c:when><c:when test="${change.type == 18}"> ${relationList[change.oldValue + 0]} > ${change.newValue}</c:when><c:when test="${change.fieldName == 'priority'}">${priority[change.old_value + 0]} -> ${priority[change.newValue + 0]}</c:when><c:otherwise>${change.oldValue} -> ${change.newValue}</c:otherwise></c:choose></td>
			</tr>
		</c:forEach>
	</table>