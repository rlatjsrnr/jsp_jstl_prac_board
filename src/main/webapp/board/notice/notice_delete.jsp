<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s"%>
<!-- notice_delete.jsp -->
<!-- 공지글 번호로 삭제 처리 -->
<c:catch var="e">
	<s:update var="result" dataSource="java/MySQLDB">
		DELETE FROM notice_board WHERE notice_num=?
		<s:param>${param.notice_num}</s:param>
	</s:update>
	<c:choose>
		<c:when test="${result > 0}">
			<c:redirect url="notice_success.jsp?message=notice delete" />
		</c:when>
		<c:otherwise>
			<c:redirect url="notice_fail.jsp?message=notice delete" />
		</c:otherwise>	
	</c:choose>
</c:catch>
<c:if test="${!empty e}">
	<c:redirect url="notice_fail.jsp?message=notice delete" />
</c:if>