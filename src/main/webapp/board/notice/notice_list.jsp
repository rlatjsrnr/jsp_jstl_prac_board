<%@page import="vo.NoticeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s"%>
<jsp:include page="../../common/header.jsp" />
<!-- 페이징 처리 -->
<jsp:useBean id="pm" class="util.SearchPageMaker" />

<jsp:useBean id="cri" class="util.SearchCriteria" />
<jsp:setProperty property="*" name="cri"/>
<jsp:setProperty property="cri" name="pm" value="${cri}"/>

<%-- <!-- parameter로 전달된 사용자 요청 페이지 name:page -->
<c:if test="${!empty param.page}">
	<c:set target="${pm.cri}" property="page" value="${param.page}"/>	
</c:if>

<!-- 한 페이지에 보여줄 게시물 수 name:perPageNum -->
<c:if test="${!empty param.perPageNum}">
	<c:set target="${pm.cri}" property="perPageNum" value="${param.perPageNum}"/>
</c:if>
 --%>
<!-- 전체 게시물 개수 -->
<s:query var="rs" dataSource="java/MySQLDB">
	SELECT count(*) as cnt FROM notice_board
	<c:if test="${!empty pm.cri.searchValue}">
		<c:choose>
			<c:when test="${pm.cri.searchType eq 'title'}">
				WHERE notice_title LIKE CONCAT('%', '${pm.cri.searchValue}','%')
			</c:when>
			<c:otherwise>
				WHERE notice_content LIKE CONCAT('%', '${pm.cri.searchValue}','%')
			</c:otherwise>
		</c:choose>
	</c:if>
</s:query>
<c:set target="${pm}" property="totalCount" value="${rs.rows[0].cnt}"/>

<!-- 요청한 페이지 정보와 한페이지에 보여줄 게시물 개수를 연산하여 게시물 목록 검색  limit startRow, maxRows-->
<s:query var="rs" dataSource="java/MySQLDB" startRow="${pm.cri.startRow}" maxRows="${pm.cri.perPageNum}"> 
	SELECT * FROM notice_board 
	<c:if test="${!empty param.searchValue}">
		<c:choose>
			<c:when test="${param.searchType eq 'title'}">
				WHERE notice_title LIKE '%${param.searchValue}%'
			</c:when>
			<c:otherwise>
				WHERE notice_content LIKE '%${param.searchValue}%'
			</c:otherwise>
		</c:choose>
	</c:if>
	ORDER BY notice_num DESC 
</s:query>
<c:if test="${rs.rowCount>0 }">
	<jsp:useBean id="noticeList" class="java.util.ArrayList" type="java.util.List<vo.NoticeVO>" />
	<c:forEach var="notice" items="${rs.rows}">
		<jsp:useBean id="vo" class="vo.NoticeVO"/>
		<c:forEach var="c" items="${rs.columnNames}" >
			<!-- 객체의 필드 이름과 테이블의 속성이름이 같아야 가능 -->
			<c:set target="${vo}" property="${c}" value="${notice[c]}"/>
		</c:forEach>	
 		<!-- 변수에 안담으면 true 출력됨 -->
		<c:set var="temp" value="${noticeList.add(vo)}" />
		<c:remove var="vo"/>
	</c:forEach>
</c:if>

<section  class="wrap">
	<table class="list">
		<tr>
			<th colspan="4">
				<h1>공지사항</h1>
			</th>
		</tr>
		<tr>
			<th colspan="4">${pm}</th>
		</tr>
		<c:if test="${!empty member and member.u_id eq 'admin'}">
			<tr>
				<td colspan="4">
						<a href="<c:url value='/board/notice/notice_write.jsp'/>">공지글 작성</a>
				</td>
			</tr>
		</c:if>
		<!-- 공지 검색 및 한번에 보여줄 페이지 개수 선택 창 -->
		<tr>
			<td colspan="4">
				<form name="searchName" action="notice_list.jsp" method="get">
					<select name="searchType">
						<option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
						<option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>						
					</select>
					<input type="text" autofocus name="searchValue" value="${param.searchValue}"/>
					<input type="submit" value="검색" /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<!-- onchange : option에 value가 바뀌면 수행됨 -->
					<select name="perPageNum" onchange="searchName.submit();">
						<c:forEach var="i" begin="10" end="25" step="5">
							<option value="${i}" ${param.perPageNum eq i ? 'selected' : ''}>${i}개씩 보기</option>	
						</c:forEach>
					</select>
				</form>
			</td>
		</tr>
		<tr>
			<th>글번호</th>
			<th>제목</th>
			<th>작성자</tH>
			<th>작성일</th>
		</tr>
		<c:choose>
			<c:when test="${!empty noticeList}">
				<!-- 게시글 목록 존재 시 -->
				<c:forEach var="n" items="${noticeList}">
					<tr>
						<td>${n.notice_num}</td>
						<td>
							<a href="<c:url value='/board/notice/notice_detail.jsp'/>?notice_num=${n.notice_num}">
								[${n.notice_category}]${n.notice_title}
							</a>
							
						</td>
						<td>${n.notice_author}</td>
						<td>${n.notice_date}</td>
					</tr>
				</c:forEach>
				<!-- 페이징 블럭 출력 -->
				<tr>					
					<th colspan="4">
						<c:if test="${pm.first}">
							<a href="notice_list.jsp${pm.makeQuery(1)}">[처음]</a>
						</c:if>
						
						<c:if test="${pm.prev}">
							<a href="notice_list.jsp${pm.makeQuery(pm.startPage-1)}">[이전]</a>
						</c:if>
						
						<c:forEach var="i" begin="${pm.startPage}" end="${pm.endPage}">
							<a href="notice_list.jsp${pm.makeQuery(i)}">[${i}]</a>		
						</c:forEach>
						
						<c:if test="${pm.next}">
							<a href="notice_list.jsp${pm.makeQuery(pm.endPage+1)}">[다음]</a>
						</c:if>
						
						<c:if test="${pm.last}">
							<a href="notice_list.jsp${pm.makeQuery(pm.maxPage)}">[마지막]</a>
						</c:if>
					</th>
				</tr>
			</c:when>
			<c:otherwise>
				<!-- 게시글 목록 미 존재 시 -->
				<tr>
					<td colspan="4">등록된 게시물이 없습니다.</td>
				</tr>
			</c:otherwise>
		</c:choose>
	</table>
</section>
<jsp:include page="../../common/footer.jsp" />