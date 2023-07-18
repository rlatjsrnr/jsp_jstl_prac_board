<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Test Member</title>
<c:url var="context" value="/"/>
<link href="${context}/css/header.css" rel="stylesheet" type="text/css" />
<link href="${context}/css/footer.css" rel="stylesheet" type="text/css" />
<link href="${context}/css/common.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<div>
		<!-- EL에서는 영역객체를 활용하기 위해서 pageContest를 제공해준다. -->		
		cookie : ${pageContext.request.cookies}<br/> <br/>
		<c:set var="cookies" value="${pageContext.request.cookies}" />
		<c:if test="${!empty cookies}" >
			<c:forEach var="c" items="${cookies}">
				<c:if test="${c.name eq 'u_id'}">
					${c.name} - ${c.value} <br/>					
				</c:if>
			</c:forEach>
		</c:if>
		<!-- 쿠키 배열 -->
		<br/> cookie[] 정보 : ${cookie}
		<!-- name값이 u_id인 cookie 객체 -->
		<br/> cookie[] name 값이 u_id 정보 : ${cookie.u_id}
		<br/> cookie[] name 값이 u_id name 정보 : ${cookie.u_id.name}
		<br/> cookie[] name 값이 u_id value 정보 : ${cookie['u_id']['value']}
		
		<c:if test="${!empty cookie.u_id and empty sessionScope.member}">
			<!-- 쿠키 정보는 있지만 로그인 된 맴버는 없다 
				 자동 로그인 요청 처리
			-->
			<s:query var="rs" dataSource="java/MySQLDB">
				SELECT * FROM digital_member WHERE u_id=?
				<s:param>${cookie.u_id.value}</s:param>
			</s:query>
			<c:if test="${rs.rowCount>0}">
				<jsp:useBean id="member" class="vo.MemberVO" scope="session"/>				
				<c:forEach var="columnName" items="${rs.columnNames}">
					<!-- columnNames : column이름을 순서대로 배열로 줌 -->					
					<c:set target="${member}" property="${columnName}" value="${rs.rows[0][columnName]}"/>
				</c:forEach>
				<%-- <c:set var="member" value="${rs.rows[0]}" scope="session"/> --%>
				${member} <br/>			
			</c:if>				
		</c:if>
	</div>
	<header>
		<div>
			<ul>
				<li><a href="<c:url value='/index.jsp'/>">home</a></li>
				<c:choose>
					<c:when test="${!empty sessionScope.member}">
						<li><a href="<c:url value='/member/info.jsp'/>">${member.u_id}</a>님 방가</li>
						<c:if test="${member.u_id eq 'admin'}">
							<li><a href="<c:url value='/management/member.jsp'/>">회원관리</a></li>
						</c:if>
						<li><a href="<c:url value='/member/logOut.jsp'/>">로그아웃</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="<c:url value='/member/login.jsp'/>">로그인</a></li>
						<li><a href="<c:url value='/member/join.jsp'/>">회원가입</a></li>
					</c:otherwise>
				</c:choose>
				
			</ul>
		</div>
		<div>
			<ul>
				<li><a href="<c:url value='/board/notice/notice_list.jsp'/>">공지사항</a></li>
				<li><a href="<c:url value='/board/qna/qna_list.jsp'/>">질문과답변</a></li>
			</ul>
		</div>
	</header>