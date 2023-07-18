<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<!-- withdraw.jsp -->
<!-- 회원 탈퇴 처리 - 회원 정보를 삭제하지 않고 u_join column의 값을 N으로 수정 -->
<c:choose>
	<c:when test="${empty member || member.u_id ne param.u_id || member.u_id eq 'admin' }">
		<script>
			alert('잘못된 요청입니다.');
			history.back();
		</script>
	</c:when>
	<c:otherwise>
		<c:catch var="e">
			<s:update var="result" dataSource="java/MySQLDB">
				UPDATE digital_member SET u_join = 'N' WHERE u_id='${param.u_id}'				
			</s:update>
			<script>
				alert('회원 탈퇴 완료');
				location.href='<c:url value="/member/logOut.jsp"/>';
			</script>
		</c:catch>
		<c:if test="${!empty e}">
			<script>
				alert('회원탈퇴 요청 처리 실패');
				history.go(-1);
			</script>
		</c:if>	
	</c:otherwise>
</c:choose>

