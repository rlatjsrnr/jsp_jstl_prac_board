<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<!-- 접근 권한이 존재하는 사용자인지 확인 -->
<%@ include file="checkAdmin.jsp" %>
<!-- memberSubmit.jsp -->
<!-- 관리자 회원 정보 수정 완료 -->
<f:requestEncoding value="UTF-8" />
<jsp:useBean id="updateMember" class="vo.MemberVO" />
<jsp:setProperty name="updateMember" property="*" />
<jsp:useBean id="now" class="java.util.Date" />

<s:update var="result" dataSource="java/MySQLDB">
	UPDATE digital_member SET u_pass =?, u_age=?, u_gender=?, u_regdate=? WHERE u_num=?
	<s:param>${updateMember.u_pass}</s:param>
	<s:param>${updateMember.u_age}</s:param>
	<s:param>${updateMember.u_gender}</s:param>
	<s:dateParam type="timestamp" value="${now}"/>	
	<s:param>${updateMember.u_num}</s:param>	
</s:update>

<c:choose>
	<c:when test="${result == 1}">
		<script>
			alert('${updateMember.u_id}님의 정보 수정 완료');
			location.href='<c:url value="/management/member.jsp"/>';
		</script>
	</c:when>
	<c:otherwise>
		<script>
			alert('정보 수정 실패');
			history.back();
		</script>
	</c:otherwise>
</c:choose>

