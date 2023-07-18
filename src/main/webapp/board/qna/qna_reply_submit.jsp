<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- qna_reply_submit.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<f:requestEncoding value="UTF-8"/>

<jsp:useBean id="qnaBoard" class="vo.QnABoardVO" />
<jsp:setProperty property="*" name="qnaBoard"/>
<s:transaction  dataSource="java/MySQLDB">
	<s:update>
		UPDATE qna_board SET qna_re_seq = qna_re_seq+1 WHERE qna_re_ref = ? AND qna_re_seq > ?
		<s:param>${qnaBoard.qna_re_ref}</s:param>
		<s:param>${qnaBoard.qna_re_seq}</s:param>
	</s:update>
	
	<s:update>
		INSERT INTO qna_board VALUES(null,?,?,?,?,?,?,?,0,now())
		<s:param>${qnaBoard.qna_name}</s:param>
		<s:param>${qnaBoard.qna_title}</s:param>
		<s:param>${qnaBoard.qna_content}</s:param>
		<s:param>${qnaBoard.qna_re_ref}</s:param>
		<s:param>${qnaBoard.qna_re_lev + 1}</s:param>
		<s:param>${qnaBoard.qna_re_seq + 1}</s:param>
		<s:param>${qnaBoard.qna_writer_num}</s:param>
	</s:update>
</s:transaction>
<c:redirect url="qna_list.jsp"/>