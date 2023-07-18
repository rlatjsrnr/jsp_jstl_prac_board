<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:if test="${empty member or member.u_id ne 'admin'}">
	<!-- <script>
		alert('접근 권한이 없습니다.');
		history.go(-1);
	</script> -->
	
	<%
		response.sendError(403, "접근 권한이 없습니다.");		
	%>
</c:if>