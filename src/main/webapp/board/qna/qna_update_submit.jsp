<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<!-- qna_update_submit.jsp -->
<f:requestEncoding value="utf-8"/>
<jsp:useBean id="qna" class="vo.QnABoardVO"/>
<jsp:setProperty property="*" name="qna"/>
<c:choose>
	<c:when test="${!empty member and member.u_num eq qna.qna_writer_num}">
		<c:catch var="e">
			<s:update dataSource="java/MySQLDB">
				UPDATE qna_board SET 
				qna_name = ? , 
				qna_title = ? , 
				qna_content = ? 
				WHERE qna_num = ? 
				<s:param>${qna.qna_name}</s:param> 
				<s:param>${qna.qna_title}</s:param> 
				<s:param>${qna.qna_content}</s:param> 
				<s:param>${qna.qna_num}</s:param> 
			</s:update>
			<c:redirect url="qna_detail.jsp?qna_num=${qna.qna_num}"/>
		</c:catch>
		<c:if test="${!empty e}">
			<script>
				alert('정상적으로 처리하지 못하였습니다.');
				history.go(-1);
			</script>
		</c:if>
	</c:when>
	<c:otherwise>
		<script>
			alert('잘못된 요청입니다.');
			location.replace("qna_list.jsp");
		</script>
	</c:otherwise>
</c:choose>










