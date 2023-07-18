<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<!-- joinCheck.jsp -->
<!-- 회원가입 처리 -->
<!-- POST - 전달된 한글 처리 -->
<f:requestEncoding value="UTF-8" />
<c:catch var="e">
	<!-- join.jsp에서 사용자가 입력한 정보로 joinMember객체 생성 -->
	<jsp:useBean id="joinMember" class="vo.MemberVO" />
	<jsp:setProperty name="joinMember" property="*" />	
</c:catch>

<c:choose>
	<c:when test="${!empty e}">
		<!-- 예외 발생 -->
		<script>		
			alert('잘못된 회원정보입니다.');
			history.back();
		</script>
	</c:when>
	<c:otherwise>
		<!-- 정상 진행 -->
		<!-- 아이디 중복 체크 -->
		<s:query var="rs" dataSource="java/MySQLDB">
			SELECT * FROM digital_member WHERE u_id=?
			<s:param>${joinMember.u_id}</s:param>
		</s:query>
		<c:choose>
			<c:when test="${rs.rowCount > 0}">
				<!-- 동일한 아이디가 존재한다. -->
				<script>
					alert('이미 사용중인 id입니다');
					history.back();
				</script>
			</c:when>
			<c:otherwise>
				<!-- 회원정보 등록 -->
				<s:update var="result" dataSource="java/MySQLDB" >
					INSERT INTO digital_member(u_id, u_pass, u_age, u_gender) VALUES(?, ?, ${joinMember.u_age}, ?)
					<s:param>${joinMember.u_id}</s:param>
					<s:param>${joinMember.u_pass}</s:param>
					<s:param>${joinMember.u_gender}</s:param>
				</s:update>
				<script>
					/* 값이 없을 때를 대비해 EL태그 사용 시 ''로 감싸준다. 없어도 빈 문자열 됨 */
					let result='${result}';
					alert(result+'행 삽입완료');
					location.href='login.jsp';
				</script>
			</c:otherwise>		
		</c:choose>
	</c:otherwise>
</c:choose>

