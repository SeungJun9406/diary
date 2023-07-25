<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>

<%
		
	// 요청 분석(currentPage, ...)
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + "<-- currentPage");
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행번호
	int startRow = (currentPage-1)*rowPerPage;
	/*
		 currentPage	startRow(rowPerPage = 10일 경우)
		 1				0
		 2				10
		 3				20
		 4				30     패턴찾기, (currentPage-1)*rowPerPage
	*/
	
	
	
	
	// DB연결 설정
	// select notice_title, createdate from notice 
		// order by createdate desc
		// limit ?, ?
		//1)
		//스태틱 메서드, 드라이브 로딩, 메모리에 올린다, 변수에 저장할 필요없음.
		Class.forName("org.mariadb.jdbc.Driver");
		//2)
		// 마리아db 접속을 유지해야 함 
		Connection conn = DriverManager.getConnection("jdbc:mariadb://3.38.14.38:3306/diary", "root", "java1234");
		// 문자열로 sql문을 받아서 sql로 적용
		PreparedStatement stmt = conn.prepareStatement(
				"select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?");
		stmt.setInt(1, startRow);
		stmt.setInt(2, 10);
		// 디버깅 코드
		System.out.println(stmt + "<-- stmt");
		// 출력할 공지 데이터
		ResultSet rs = stmt.executeQuery();
		
		// 자료구조 ResultSet 타입을 일반적인(자바 배열 or 기본 API 자료구조타입 List, Set, Map) 타입으로 
		// Set : 순서가 없다, 중복되지 않는다
		// Resultset -> ArrayList<notice>
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		
		while(rs.next()){
			Notice n = new Notice();
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.createdate = rs.getString("createdate");
			noticeList.add(n);
		}
		// 마지막 페이지
		// select count(*) from notice;
		PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
		ResultSet rs2 = stmt2.executeQuery();
		int totalRow = 0; 
		if(rs2.next()) {
			totalRow = rs2.getInt("count(*)");
			System.out.println(totalRow + "<-- totalRow"); 
		}
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0 ) {
			lastPage = lastPage+1;
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
	<link rel="stylesheet" href="./resources/bootstrap.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!--  메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticeThree.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<h1>공지 리스트</h1>
</nav>
	<a href="./insertNoticeForm.jsp">공지입력</a>
	<table class="table table-hover">
		<tr class="table-warning">
			<th>공지 제목</th>
			<th>작성 날짜</th>
		</tr>
		<!-- 출력코드 -->
		<% 	// foreach를 대체할 수 있는 메서드(레거시), select절에서 가져온 항목들
			for (Notice n : noticeList) {
		%>
		<tr>
			<td>
				<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
					<%=n.noticeTitle%>
				</a>
			</td>
			<!-- 뒤의 시간 정보를 자른다. -->
			<td><%=n.createdate.substring(0, 10) %></td>
		</tr>
		<% 	
			}
		%>
		
	</table>
	<%
		if(currentPage > 1) {
	%>
			<a class="container-fluid" href="./noticethree.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
			<%=currentPage%>
	<% 
		if(currentPage < lastPage) {
	
	%>
			<a class="container-fluid" href="./noticethree.jsp?currentPage=<%=currentPage+1%>">다음</a>
	<%
		}
	%>
</body>
</html>