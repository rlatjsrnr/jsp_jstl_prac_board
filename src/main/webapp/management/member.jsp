<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<jsp:include page="/common/header.jsp" />
<section class="wrap">

<!-- 접근 권한이 존재하는 사용자인지 확인 -->
<%@ include file="checkAdmin.jsp" %>

<jsp:useBean id="cri" class="util.Criteria" />
<c:if test="${!empty param.selectPage}">
	<c:set target="${cri}" property="page" value="${param.selectPage}" />	
</c:if>

<s:query var="r" dataSource="java/MySQLDB">
	SELECT count(*) AS cnt FROM digital_member WHERE u_id != 'admin'
</s:query>

<jsp:useBean id="pm" class="util.PageMaker" />
<c:set target="${pm}" property="cri" value="${cri}" />
<c:set target="${pm}" property="totalCount" value="${r.rows[0].cnt}" />


<s:query var="rs" dataSource="java/MySQLDB">
	SELECT * FROM digital_member WHERE u_id !='admin' AND u_join='Y' ORDER BY u_num DESC limit ${cri.startRow}, ${cri.perPageNum}
</s:query>

<table border=1>
	<tr>
		<th colspan="4">회원정보</th>
	</tr>
	<tr>
		<th>회원번호</th>
		<th>아이디</th>
		<th>회원등록일</th>
		<th>기타</th>
	</tr>
	<!-- 등록된 회원 정보가 있을 시 출력 -->
	<c:choose>
		<c:when test="${rs.rowCount>0}">
			<jsp:useBean id="now" class="java.util.Date" />
			<f:formatDate var="date" pattern="yyyy-MM-dd" value="${now}"/>
			
			<c:forEach var="row" items="${rs.rows}">
				<tr>
					<td>${row.u_num}</td> <!-- 회원 번호 -->
					<td>${row['u_id']}</td> <!-- 아이디 -->
					<!-- 
						오늘 등록된 회원이면 시간만
						오늘 이전에 등록된 회원이면 날짜만
					-->
					<f:formatDate var="reg" pattern="yyyy-MM-dd" value="${row.u_regdate}"/>
					<td>
					<c:choose>
						<c:when test="${date eq reg}">
							<f:formatDate value="${row.u_regdate}" pattern="hh:mm:ss"/>
						</c:when>
						<c:otherwise>
							${reg}
						</c:otherwise>
					</c:choose>					
					</td>
					<td>
						<a href="<c:url value='/management/memberUpdate.jsp'/>?u_num=${row.u_num}">수정</a> |
						<a href="<c:url value='/management/memberDelete.jsp'/>?u_num=${row.u_num}">삭제</a>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${!empty pm}">			
				<tr>
					<td colspan="4">
						<c:if test="${pm.prev}">
							<a href="<c:url value='/management/member.jsp'/>?selectPage=${pm.startPage-1}">[이전]</a>
						</c:if>
						<c:forEach var="i" begin="${pm.startPage}" end="${pm.endPage}">
							<a href="<c:url value='/management/member.jsp'/>?selectPage=${i}">[${i}]</a>
						</c:forEach>
						<c:if test="${pm.next}">
							<a href="<c:url value='/management/member.jsp'/>?selectPage=${pm.endPage + 1}">[다음]</a>
						</c:if>
					</td>
				</tr>
			</c:if>					
		</c:when>
		<c:otherwise>
			<!-- 등록된 회원 정보가 없을 시 출력 -->
			<tr>
				<td colspan="4">등록된 회원정보가 없습니다.</td>
			</tr>
		</c:otherwise>
	</c:choose>
</table>
</section>
<jsp:include page="/common/footer.jsp" />











