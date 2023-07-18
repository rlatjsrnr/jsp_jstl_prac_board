<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!--  qna_write_submit.jsp    -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<f:requestEncoding value="UTF-8"/>

<jsp:useBean id="qnaBoard" class="vo.QnABoardVO" />
<jsp:setProperty property="*" name="qnaBoard" />

<c:catch var="e">
	<s:transaction dataSource="java/MySQLDB">
		<s:update>
			INSERT INTO qna_board(qna_name, qna_title, qna_content, qna_writer_num) VALUES(?,?,?,?)
			<s:param>${qnaBoard.qna_name}</s:param>
			<s:param>${qnaBoard.qna_title}</s:param>
			<s:param>${qnaBoard.qna_content}</s:param>
			<s:param>${qnaBoard.qna_writer_num}</s:param>
		</s:update>
		<s:update var="result">
			UPDATE qna_board SET qna_re_ref = LAST_INSERT_ID() WHERE qna_num = LAST_INSERT_ID()
		</s:update>
	</s:transaction>
	
	<c:choose>
		<c:when test="${result > 0}">
			<c:redirect url="qna_list.jsp" />
		</c:when>
		<c:otherwise>
			<script>
				alert('게시글 등록 실패!');
				history.back();
			</script>
		</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${!empty e}">
	<script>
		alert('게시글 등록 실패!');
		history.back();
	</script>
</c:if>











