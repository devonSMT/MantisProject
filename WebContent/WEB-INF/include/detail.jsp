<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<%
	//Set mapping for all status and for types
	HashMap<Long, String> statusMap = new HashMap<Long, String>();
	
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

	request.setAttribute("statList", statusMap);

	HashMap<Long, String> typeMap = new HashMap<Long, String>();

	typeMap.put(1L, "New Issue");
	typeMap.put(2L, "Note Added:");
	typeMap.put(3L, "Note Edited:");
	typeMap.put(4L, "Note Deleted:");
	typeMap.put(6L, "Description Updated");
	typeMap.put(7L, "Additional Information Updated:");
	typeMap.put(8L, "Steps to Reproduce Updated:");
	typeMap.put(9L, "File Added:");
	typeMap.put(10L, "File Deleted:");
	typeMap.put(12L, "Issue Monitored:");
	typeMap.put(13L, "Issue End Monitor");
	typeMap.put(18L, "Relationship Added");
	typeMap.put(19L, "Relationship Deleted");
	typeMap.put(20L, "Issue Cloned:");
	typeMap.put(21L, "Issue Generated From:");
	typeMap.put(23L, "Relationship Replaced:");
	typeMap.put(25L, "Tag Attached:");
	typeMap.put(26L, "Tag Detached:");
	typeMap.put(29L, "Note Revision dropped:");

	request.setAttribute("typeList", typeMap);
	
	HashMap<Long, String> rsMap = new HashMap<Long, String>();
	
	rsMap.put(10L, "open");
	rsMap.put(20L,"fixed");
	rsMap.put(30L,"reopened");
	rsMap.put(40L,"unable to reproduce");
	rsMap.put(50L,"not fixable");
	rsMap.put(60L,"duplicate");
	rsMap.put(70L,"no change required");
	rsMap.put(80L,"suspended");
	rsMap.put(90L,"won't fix");
	
	request.setAttribute("rsList", rsMap);

	HashMap<Long, String> relationMap = new HashMap<Long, String>();
	
	relationMap.put(0L, "duplicate of");
	relationMap.put(1L, "related to");
	relationMap.put(2L, "parent of");
	relationMap.put(3L, "child of");
	relationMap.put(4L, "has duplicate");
	
	request.setAttribute("relationList", relationMap);
	
	HashMap<Long, String> priorityMap = new HashMap<Long, String>();
	
	priorityMap.put(10L, "Lowest");
	priorityMap.put(20L, "Nice To Have");
	priorityMap.put(30L, "Low");
	priorityMap.put(40L, "Moderate");
	priorityMap.put(50L, "Normal");
	priorityMap.put(60L, "Significant");
	priorityMap.put(70L, "High");
	priorityMap.put(80L, "Critical");
	priorityMap.put(90L, "Immediate");
	priorityMap.put(100L, "Emergency");

	request.setAttribute("priority", priorityMap);
	
	//Build SQL Query
	StringBuilder sb = new StringBuilder();

	sb.append("SELECT mht.field_name, mht.old_value, mht.new_value, mut.username,");
	sb.append(" mht.type, from_unixtime(mht.date_modified, '%m/%d/%Y') as modDate");
	sb.append(" FROM mantis_bug_history_table mht");
	sb.append(" LEFT OUTER JOIN mantis_user_table mut");
	sb.append(" ON mht.user_id = mut.id");
	sb.append("	WHERE 1=1");

	//check for request parameters 
	String ticket = request.getParameter("ticketID");
	sb.append("	AND mht.bug_id = " + ticket);
	
	if(request.getParameterValues("fieldName") != null){
		String[] params = request.getParameterValues("fieldName");
		
		//check if {any} value was choosen
		if(params[0] != ""){ 
			for(int i =0; i < params.length; i++){		
			if(i < 1 && params[i] != ""){
				sb.append(" AND( mht.field_name='"+ params[i] + "'");
			}else if(params[i] != ""){
				sb.append(" OR mht.field_name='"+ params[i] + "'");
				}	
			}
		sb.append(")");
		}
	}
	
	sb.append(" ORDER BY mht.id");
	request.setAttribute("sql", sb.toString());
%>
	<sql:setDataSource var="mantisDB" driver="com.mysql.jdbc.Driver"
			url="jdbc:mysql://127.0.0.1:3306/mantisbt_current" user="root" password="SMT2014" />

	<sql:query dataSource="${mantisDB}" var="history">
		${sql}
	</sql:query>
	
	<c:if test="${empty history.rows}">
		<h3><font color="#B00000">No Matching Detailed Information found for ticket</font></h3>
	</c:if>
	
	<table width="200%" cellspacing="0px">
	<tr>
	<th colspan="7">Detailed Ticket Information</th>
	</tr>
		<tr>
			<th>Date Last Modified</th>
			<th>User</th>
			<th>Field</th>
			<th>Change</th>
		</tr>
		<c:forEach var="change" items="${history.rows}">
			<tr>
				<td>${change.modDate}</td>
				<td>${change.username}</td>
				<td><c:choose>
						<c:when test="${empty change.field_name}">
						${typeList[change.type + 0]}
					</c:when>
						<c:when test="${change.field_name == 'handler_id'}">
							Assigned To						
						</c:when>
						<c:otherwise>
						${change.field_name}
					</c:otherwise>
					</c:choose></td>
				<td><c:choose>
						<c:when test="${change.field_name == 'handler_id'}">
							<sql:query dataSource="${mantisDB}" var="user">
							SELECT username FROM mantis_user_table
							WHERE id = ${change.old_value};
							</sql:query>
						 	${user.rows[0].username} ->
						 	<sql:query dataSource="${mantisDB}" var="user">
							SELECT username FROM mantis_user_table
							WHERE id = ${change.new_value};
							</sql:query>
						 ${user.rows[0].username}  
					</c:when>
						<c:when test="${change.field_name == 'status'}">
						${statList[change.old_value + 0]} ->${statList[change.new_value + 0]}
					</c:when>
						<c:when test="${change.field_name == 'resolution'}">
						${rsList[change.old_value + 0]} -> ${rsList[change.new_value + 0]}
					</c:when>
							<c:when test="${change.type == 18}">
						 ${relationList[change.old_value + 0]} > ${change.new_value}
					</c:when>
						<c:when test="${change.field_name == 'priority'}">
						${priority[change.old_value + 0]} -> ${priority[change.new_value + 0]}
					</c:when>
						<c:otherwise>
						${change.old_value} -> ${change.new_value}
					</c:otherwise>
					</c:choose></td>
			</tr>
		</c:forEach>
	</table>