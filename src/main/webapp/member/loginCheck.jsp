<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<!-- loginCheck.jsp -->
<!--
	 로그인 요청 처리 
	 로그인 성공한 회원의 정보를 member 를 키값으로 저장
-->
<f:requestEncoding value="UTF-8"/>
<jsp:useBean id="member" class="vo.MemberVO" scope="session"/>
<jsp:setProperty property="u_id" name="member" />
<jsp:setProperty property="u_pass" name="member" />
<c:catch var="e">
	<s:query var="rs" dataSource="java/MySQLDB">
		SELECT * FROM digital_member WHERE u_join='Y' AND u_id=? AND u_pass=?
		<s:param>${member.u_id}</s:param>
		<s:param>${member.u_pass}</s:param>
	</s:query>
	<c:choose>
		<c:when test="${rs.rowCount > 0}">
			<!-- 로그인 성공 -->
			<jsp:setProperty name="member" property="u_num" value="${rs.rows[0].u_num}" />
			<jsp:setProperty name="member" property="u_age" value="${rs.rows[0]['u_age']}" />
			<jsp:setProperty name="member" property="u_gender" value="${rs.rows[0].u_gender}" />
			<jsp:setProperty name="member" property="u_regdate" value="${rs.rows[0].u_regdate}" />
			
			<!-- login checkBox 체크 시 -->
			<c:if test="${!empty param.login}">
				<!-- 자동로그인 기능 -->
				
				<%-- <%
					Cookie cookie = new Cookie("u_id", member.getU_id());
					cookie.setMaxAge(60*60*24*7);
					cookie.setPath("/");
					response.addCookie(cookie);
				%> --%>
				<!-- JS로 쿠키 만들기 -->
				<script>
					let maxAge = 60*60*24*7;
					let memberUid = '${member.u_id}';				
					document.cookie = "u_id="+memberUid+"; Max-Age="+maxAge+"; path=/;";
				</script>
			</c:if>			
			<script>
				alert('${member.u_id} : 로그인성공');
				location.href='<c:url value="/index.jsp"/>';
			</script>						
		</c:when>
		<c:otherwise>
			<!-- 로그인 실패 -->
			<script>
				alert('로그인 실패');
				history.back();				
			</script>
			<c:remove var="member" scope="session" />
		</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${!empty e}" >
	<script>
		alert('로그인 실패!');
		history.go(-1);
	</script>
	<c:remove var="member" scope="session" />
</c:if>