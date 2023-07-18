<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s"%>
<!-- notice_select.jsp -->
<!-- 게시글 번호를 전달받아 번호가 일치하는 하나의 행 정보를 NoticeVO bean에 저장 -->
<s:query var="rs" dataSource="java/MySQLDB">
	SELECT * FROM notice_board WHERE notice_num=?
	<s:param>${param.notice_num}</s:param>
</s:query>
<c:if test="${rs.rowCount > 0}">
	<jsp:useBean id="notice" class="vo.NoticeVO" scope="request"/>
	<c:forEach var="c" items="${rs.columnNames}">
		<c:set target="${notice}" property="${c}" value="${rs.rows[0][c]}"/>		
	</c:forEach>
</c:if>
