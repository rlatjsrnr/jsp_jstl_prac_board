<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<!-- qna_delete.jsp -->
<c:catch var="e">
	<s:update var="result" dataSource="java/MySQLDB">
		DELETE FROM qna_board WHERE qna_num=?
		<s:param>${param.qna_num}</s:param>
	</s:update>
	<c:choose>
		<c:when test="${result == 1}">
			<c:redirect url="qna_list.jsp" />
		</c:when>
		<c:otherwise>
			<script>
				alert('삭제 요청 처리 실패');
				history.back();
			</script>
		</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${!empty e}">
	<script>
		alert('요청 처리 실패 - ${e.getMessage()}');
		history.back();
	</script>
</c:if>







