<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<!-- qna_select.jsp -->

<s:query var="rs" dataSource="java/MySQLDB">
	SELECT * FROM qna_board WHERE qna_num = ?
	<s:param>${param.qna_num}</s:param>
</s:query>
<c:set var="qna" value="${rs.rows[0]}" scope="request" />



