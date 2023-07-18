<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f"%>
<!-- 공지사항 게시글 삽입 -->
<!-- 
	POST 방식으로 전달된 request의 body data는 encoding이 되어있지 않으므로
	한글 처리를 위해서 전달된 request의 encoding을 지정해줘야함.
 -->
<f:requestEncoding value="UTF-8" />
<c:catch var="e">
	<jsp:useBean id="notice" class="vo.NoticeVO" />
	<!-- 
		parameter로 전달된 request의 data와 NoticeVO의 필드이름이 일치하면
		생성된 bean의 필드에 변환된 data를 저장
	-->
	<jsp:setProperty property="*" name="notice"/>
	<s:update var="result" dataSource="java/MySQLDB">
		INSERT INTO notice_board VALUES(null, ?, ?, ?,?,now())
		<s:param>${notice.notice_category}</s:param>
		<s:param>${member.u_id}</s:param>
		<s:param>${notice.notice_title}</s:param>
		<s:param>${notice.notice_content}</s:param>
	</s:update>
	<c:choose>
		<c:when test="${result > 0}">
			<c:redirect url="notice_success.jsp?message=notice write"/>			
		</c:when>
		<c:otherwise>
			<c:redirect url="notice_fail.jsp?message=notice write"/>
		</c:otherwise>
	</c:choose>
	
</c:catch>
<c:if test="${!empty e}" >
	${e.printStacktrace()}
	<c:redirect url="notice_fail.jsp"/>
</c:if>

