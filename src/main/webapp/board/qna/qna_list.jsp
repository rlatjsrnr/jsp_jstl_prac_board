<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- qna_list.jsp -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="s" %>
<jsp:include page="../../common/header.jsp" />
<!-- 페이징 처리 -->
<jsp:useBean id="cri" class="util.Criteria" />
<jsp:setProperty property="*" name="cri" />
<jsp:useBean id="pm" class="util.PageMaker"/>
<c:set target="${pm}" property="cri" value="${cri}" />

<!-- 전체 게시물 개수 -->
<s:query var="r" dataSource="java/MySQLDB">
	SELECT count(*) as cnt FROM qna_board
</s:query>
<c:set target="${pm}" property="totalCount" value="${r.rows[0].cnt}"/>

<!-- 게시물 목록 -->
<s:query var="rs" dataSource="java/MySQLDB">
	SELECT * FROM qna_board ORDER BY qna_re_ref DESC, qna_re_seq ASC limit ${cri.startRow}, ${cri.perPageNum}
</s:query>

<br/>
<section class="wrap">
	<table>
		<tr>
			<th colspan="5">
				<h1>질문과 답변 목록</h1>
			</th>
		</tr>
		<tr>
			<th colspan="5">${pm}</th>
		</tr>
		<c:if test="${!empty member}">
			<tr>
				<th colspan="5" style="text-align:right">
					<a href="qna_write.jsp">질문 작성하러 가기</a>
				</th>
			</tr>
		</c:if>
		<c:choose>
			<c:when test="${rs.rowCount > 0}">
				<tr>
					<th>글번호</th>
					<th>제목</th>
					<th>ref</th>
					<th>lev</th>
					<th>seq</th>
					<th>작성자</th>
					<th>작성시간</th>
					<th>조회수</th>
				</tr>
				<c:forEach var="board" items="${rs.rows}">
				<tr>
					<td>${board.qna_num}</td>
					<td style="text-align:left;padding:5px;">
						<c:if test="${board.qna_re_lev != 0}">
							<c:forEach begin="1" end="${board.qna_re_lev}">
								&nbsp;&nbsp;&nbsp;
							</c:forEach>
							└>
						</c:if>
						<a href="qna_detail.jsp?qna_num=${board.qna_num}">
						${board.qna_title}
						</a>
					</td>
					<td>${board.qna_re_ref}</td>
					<td>${board.qna_re_lev}</td>
					<td>${board.qna_re_seq}</td>
					<td>${board.qna_name}</td>
					<td>${board.qna_date}</td>
					<td>${board.qna_readcount}</td>
				</tr>
				<!-- <tr>
					<th colspan="5">삭제된 게시물 입니다.</th>
				</tr> -->
				</c:forEach>
				
				<!-- 페이징 처리 -->
				<tr>
					<th colspan="5">
						<c:if test="${pm.first}">
							<a href="qna_list.jsp${pm.makeQuery(1)}">[&lt;&lt;]</a>
						</c:if>
						<c:if test="${pm.prev}">
							<a href="qna_list.jsp${pm.makeQuery(pm.startPage-1)}">[&lt;]</a>
						</c:if>
						<c:forEach var="i" begin="${pm.startPage}" end="${pm.endPage}">
							<c:choose>
								<c:when test="${pm.cri.page eq i}">
									<span style='color:red;'>[${i}]</span>
								</c:when>
								<c:otherwise>
									<a href="qna_list.jsp${pm.makeQuery(i)}">[${i}]</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>	
						<c:if test="${pm.next}">
							<a href="qna_list.jsp${pm.makeQuery(pm.endPage+1)}">[&gt;]</a>							
						</c:if>	
						<c:if test="${pm.last}">
							<a href="qna_list.jsp${pm.makeQuery(pm.maxPage)}">[&gt;&gt;]</a>
						</c:if>
					</th>
				</tr>
				
			</c:when>
			<c:otherwise>
				<tr>
					<th colspan="5">
						등록된 게시물이 없습니다.
					</th>
				</tr>
			</c:otherwise>
		</c:choose>
		
	</table>
</section>
<jsp:include page="../../common/footer.jsp" />












